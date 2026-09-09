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
