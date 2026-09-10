///|
test "id hashing and id stack" {
  let id1 = Id::from_string("button_1")
  let id2 = Id::from_string("button_1")
  let id3 = Id::from_string("button_2")

  // Determinism
  assert_eq(id1.val, id2.val)
  assert_true(id1.val != id3.val)
  assert_true(id1.is_valid())

  // ID Stack hierarchy
  let stack = IdStack::new()
  let root_id = stack.derive_id("item")
  stack.push("window_1")
  let child_id = stack.derive_id("item")
  assert_true(root_id.val != child_id.val)

  stack.pop()
  let restored_id = stack.derive_id("item")
  assert_eq(root_id.val, restored_id.val)
}

///|
test "uicontext lifecycle and space allocation interaction" {
  let ctx = UIContext::new()
  assert_eq(ctx.available_width(), 800.0)

  // Frame 1: Mouse hovering over widget area
  let raw1 = RawInput::from_mouse(@math.Vec2::new(50.0, 15.0), false)
  ctx.begin_frame(raw1)

  let (id1, rect1, resp1) = ctx.allocate_space(@math.Vec2::new(100.0, 30.0))
  assert_true(resp1.hovered)
  assert_true(!resp1.clicked)
  assert_true(!resp1.pressed)
  assert_eq(ctx.hot_id(), id1)
  assert_eq(rect1.w, 100.0)
  assert_eq(rect1.h, 30.0)

  // Cursor should have advanced downwards by 30 + 8 = 38
  assert_eq(ctx.cursor().y, 38.0)

  // Second widget sits at y = 38.0
  let (id2, rect2, resp2) = ctx.allocate_space(@math.Vec2::new(100.0, 30.0))
  assert_eq(rect2.y, 38.0)
  assert_true(!resp2.hovered) // mouse is at y=15, not y in [38, 68]
  assert_true(id1.val != id2.val)

  // Frame 2: Mouse pressed down on widget 1
  let raw2 = RawInput::from_mouse(@math.Vec2::new(50.0, 15.0), true)
  ctx.begin_frame(raw2)

  let (_, _, resp1_frame2) = ctx.allocate_space(@math.Vec2::new(100.0, 30.0))
  assert_true(resp1_frame2.pressed)
  assert_true(!resp1_frame2.clicked)
  assert_eq(ctx.active_id(), id1)

  // Frame 3: Mouse released inside widget 1 -> triggers CLICK!
  let raw3 = RawInput::from_mouse(@math.Vec2::new(50.0, 15.0), false)
  ctx.begin_frame(raw3)

  let (_, _, resp1_frame3) = ctx.allocate_space(@math.Vec2::new(100.0, 30.0))
  assert_true(resp1_frame3.clicked)
  assert_true(!resp1_frame3.pressed)
  assert_eq(ctx.active_id(), Id::zero()) // reset after release

  let draw_list = ctx.end_frame()
  assert_eq(draw_list.len(), 0)
}

///|
test "horizontal layout flow advances cursor to right and wraps" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::new())

  let mut r1_x = 0.0
  let mut r1_y = 0.0
  let mut r2_x = 0.0
  let mut r2_y = 0.0

  ctx.horizontal(fn(ui) {
    let (_, rect1, _) = ui.allocate_space(@math.Vec2::new(50.0, 30.0))
    r1_x = rect1.x
    r1_y = rect1.y
    // In horizontal mode with 8px item spacing, next item sits at x = 58.0
    let (_, rect2, _) = ui.allocate_space(@math.Vec2::new(60.0, 40.0))
    r2_x = rect2.x
    r2_y = rect2.y
  })

  assert_eq(r1_x, 0.0)
  assert_eq(r1_y, 0.0)
  assert_eq(r2_x, 58.0)
  assert_eq(r2_y, 0.0)

  // After horizontal block exits, cursor is back at x = 0, y advanced by max_h (40) + 8 = 48.0
  assert_eq(ctx.cursor().x, 0.0)
  assert_eq(ctx.cursor().y, 48.0)

  let (_, rect3, _) = ctx.allocate_space(@math.Vec2::new(100.0, 20.0))
  assert_eq(rect3.x, 0.0)
  assert_eq(rect3.y, 48.0)
  assert_eq(ctx.cursor().y, 76.0)
}

///|
test "window container sets local origin and clip" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::new())

  let win_pos = @math.Vec2::new(50.0, 50.0)
  let win_size = @math.Vec2::new(200.0, 150.0)

  let mut inside_cur_x = 0.0
  let mut inside_cur_y = 0.0
  let mut inside_avail_w = 0.0
  let mut after_label_y = 0.0

  ctx.window("Test Window", win_pos, win_size, fn(ui) {
    // Inside window, cursor starts at pos.x + pad(12), pos.y + title_h(28) + pad(12) = (62.0, 90.0)
    inside_cur_x = ui.cursor().x
    inside_cur_y = ui.cursor().y
    inside_avail_w = ui.available_width()
    let _ = ui.label("Inside Window")
    after_label_y = ui.cursor().y
  })

  assert_eq(inside_cur_x, 62.0)
  assert_eq(inside_cur_y, 90.0)
  assert_eq(inside_avail_w, 200.0 - 24.0)
  assert_eq(after_label_y, 90.0 + 18.0 + 8.0)

  // Outside window, cursor returns to previous position (0, 0)
  assert_eq(ctx.cursor().x, 0.0)
  assert_eq(ctx.cursor().y, 0.0)

  let dl = ctx.end_frame()
  assert_true(dl.len() > 5)
}
