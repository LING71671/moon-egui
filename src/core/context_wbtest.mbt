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

///|
test "keyboard input events, text input, and modifiers" {
  let ctx = UIContext::new()
  let raw = {
    mouse_pos: @math.Vec2::zero(),
    mouse_down: false,
    scroll_delta: @math.Vec2::zero(),
    dt: 0.0166,
    events: [
      Event::Key(Key::Tab, true, Modifiers::none()),
      Event::Key(Key::A, true, Modifiers::new(true, false, false, false)),
      Event::TextInput("Moon"),
    ],
    text_input: "",
    modifiers: Modifiers::new(true, false, false, false),
  }

  ctx.begin_frame(raw)
  let input = ctx.input()
  assert_true(input.key_down(Key::Tab))
  assert_true(input.key_pressed(Key::Tab))
  assert_true(input.key_down(Key::A))
  assert_true(input.key_pressed(Key::A))
  assert_true(!input.key_down(Key::B))
  assert_eq(input.text_input(), "Moon")
  assert_true(input.modifiers().ctrl)
  assert_true(!input.modifiers().shift)

  // Next frame: key released
  let raw2 = {
    mouse_pos: @math.Vec2::zero(),
    mouse_down: false,
    scroll_delta: @math.Vec2::zero(),
    dt: 0.0166,
    events: [Event::Key(Key::Tab, false, Modifiers::none())],
    text_input: "",
    modifiers: Modifiers::none(),
  }
  ctx.begin_frame(raw2)
  assert_true(!ctx.input().key_down(Key::Tab))
  assert_true(ctx.input().key_released(Key::Tab))
  // Key::A remains down from previous frame because it wasn't released!
  assert_true(ctx.input().key_down(Key::A))
  assert_true(!ctx.input().key_pressed(Key::A))
}

///|
test "focus state transitions and lifecycle on response" {
  let ctx = UIContext::new()

  // Frame 1: Click on widget 1 to focus it
  let raw1 = RawInput::from_mouse(@math.Vec2::new(20.0, 20.0), false)
  ctx.begin_frame(raw1)
  let (id1, _, resp1) = ctx.allocate_space(@math.Vec2::new(100.0, 40.0))
  assert_true(!resp1.has_focus())
  assert_true(!resp1.gained_focus())

  // Click widget 1
  ctx.request_focus(id1)
  assert_true(ctx.has_focus(id1))
  let _ = ctx.end_frame()

  // Frame 2: Widget 1 retains focus
  let raw2 = RawInput::new()
  ctx.begin_frame(raw2)
  let (_, _, resp1_f2) = ctx.allocate_space(@math.Vec2::new(100.0, 40.0))
  let (id2, _, resp2_f2) = ctx.allocate_space(@math.Vec2::new(100.0, 40.0))
  assert_true(resp1_f2.has_focus())
  assert_true(!resp1_f2.gained_focus())
  assert_true(!resp2_f2.has_focus())

  // Frame 3: Switch focus to widget 2 during this frame
  let raw3 = RawInput::new()
  ctx.begin_frame(raw3)
  ctx.request_focus(id2)
  let (_, _, resp1_f3) = ctx.allocate_space(@math.Vec2::new(100.0, 40.0))
  let (_, _, resp2_f3) = ctx.allocate_space(@math.Vec2::new(100.0, 40.0))
  assert_true(!resp1_f3.has_focus())
  assert_true(resp1_f3.lost_focus())
  assert_true(resp2_f3.has_focus())
  assert_true(resp2_f3.gained_focus())
}

///|
test "tab key navigation cycles through registered focusable widgets" {
  let ctx = UIContext::new()
  let id_a = Id::from_string("field_a")
  let id_b = Id::from_string("field_b")
  let id_c = Id::from_string("field_c")

  // Frame 1: Register fields and set initial focus to id_a
  ctx.begin_frame(RawInput::new())
  ctx.register_focusable(id_a)
  ctx.register_focusable(id_b)
  ctx.register_focusable(id_c)
  ctx.request_focus(id_a)
  let _ = ctx.end_frame()
  assert_eq(ctx.focused_id(), id_a)

  // Frame 2: Press Tab -> end_frame should cycle to id_b
  let raw_tab = {
    mouse_pos: @math.Vec2::zero(),
    mouse_down: false,
    scroll_delta: @math.Vec2::zero(),
    dt: 0.0166,
    events: [Event::Key(Key::Tab, true, Modifiers::none())],
    text_input: "",
    modifiers: Modifiers::none(),
  }
  ctx.begin_frame(raw_tab)
  ctx.register_focusable(id_a)
  ctx.register_focusable(id_b)
  ctx.register_focusable(id_c)
  let _ = ctx.end_frame()
  assert_eq(ctx.focused_id(), id_b)

  // Frame 3: Press Tab again -> cycles to id_c
  ctx.begin_frame(raw_tab)
  ctx.register_focusable(id_a)
  ctx.register_focusable(id_b)
  ctx.register_focusable(id_c)
  let _ = ctx.end_frame()
  assert_eq(ctx.focused_id(), id_c)

  // Frame 4: Press Tab again -> wraps around to id_a
  ctx.begin_frame(raw_tab)
  ctx.register_focusable(id_a)
  ctx.register_focusable(id_b)
  ctx.register_focusable(id_c)
  let _ = ctx.end_frame()
  assert_eq(ctx.focused_id(), id_a)

  // Frame 5: Press Shift+Tab -> moves backwards to id_c
  let raw_shift_tab = {
    mouse_pos: @math.Vec2::zero(),
    mouse_down: false,
    scroll_delta: @math.Vec2::zero(),
    dt: 0.0166,
    events: [
      Event::Key(Key::Tab, true, Modifiers::new(false, true, false, false)),
    ],
    text_input: "",
    modifiers: Modifiers::new(false, true, false, false),
  }
  ctx.begin_frame(raw_shift_tab)
  ctx.register_focusable(id_a)
  ctx.register_focusable(id_b)
  ctx.register_focusable(id_c)
  let _ = ctx.end_frame()
  assert_eq(ctx.focused_id(), id_c)
}

///|
test "nested scissor clipping calculates proper intersection" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::new())

  assert_true(ctx.current_clip() is None)

  let r1 = @math.Rect::new(10.0, 10.0, 100.0, 100.0)
  ctx.push_clip(r1)
  assert_eq(ctx.current_clip(), Some(r1))

  // Inner clip overlapping partially
  let r2 = @math.Rect::new(50.0, 50.0, 100.0, 100.0)
  ctx.push_clip(r2)
  // Intersection should be [50, 50, 60, 60] (from 50 to 110 in x and y)
  let expected = @math.Rect::new(50.0, 50.0, 60.0, 60.0)
  assert_eq(ctx.current_clip(), Some(expected))

  // Pop restores parent clip
  ctx.pop_clip()
  assert_eq(ctx.current_clip(), Some(r1))

  ctx.pop_clip()
  assert_true(ctx.current_clip() is None)
}

///|
test "text measurement distinguishes cjk and ascii characters" {
  let ascii_size = measure_text_size("abc", 10.0)
  // 3 * 10.0 * 0.58 = 17.4
  assert_eq(ascii_size.x, 17.4)
  assert_eq(ascii_size.y, 12.5)

  let cjk_size = measure_text_size("月兔", 10.0)
  // 2 * 10.0 * 1.05 = 21.0
  assert_eq(cjk_size.x, 21.0)
  assert_eq(cjk_size.y, 12.5)

  let mixed_size = measure_text_size("a月", 10.0)
  // 1 * 5.8 + 1 * 10.5 = 16.3
  assert_eq(mixed_size.x, 16.3)
}

///|
test "hit testing respects the scissor clip" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::from_mouse(@math.Vec2::new(60.0, 60.0), false))

  // The clip excludes the pointer even though the allocated rect covers it
  ctx.push_clip(@math.Rect::new(0.0, 0.0, 40.0, 40.0))
  let (_id, rect, resp) = ctx.allocate_space(@math.Vec2::new(200.0, 200.0))
  ctx.pop_clip()

  assert_true(rect.contains(@math.Vec2::new(60.0, 60.0)))
  assert_true(!resp.hovered())

  // With the clip popped the very same geometry becomes hoverable
  ctx.set_cursor(@math.Vec2::zero())
  let (_id2, _rect2, resp2) = ctx.allocate_space(@math.Vec2::new(200.0, 200.0))
  assert_true(resp2.hovered())
}

///|
test "foreground layer composites after the main layer and escapes clipping" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::from_mouse(@math.Vec2::new(50.0, 50.0), false))

  ctx.push_clip(@math.Rect::new(0.0, 0.0, 10.0, 10.0))
  ctx.tooltip("tip")
  ctx.pop_clip()
  let dl = ctx.end_frame()

  // 0..1 are the main layer clip pair, 2..4 the deferred tooltip bubble
  assert_eq(dl.len(), 5)
  assert_true(dl.get_command(0) is Some(@draw.DrawCmd::Clip(_)))
  assert_true(dl.get_command(1) is Some(@draw.DrawCmd::ResetClip))
  assert_true(dl.get_command(2) is Some(@draw.DrawCmd::Rect(_, _, _)))
  assert_true(dl.get_command(3) is Some(@draw.DrawCmd::RectStroke(_, _, _, _)))
  assert_true(dl.get_command(4) is Some(@draw.DrawCmd::Text(_, _, _, _)))

  // The main layer's clip stack is restored after the foreground pass
  assert_true(ctx.current_clip() is None)
}

///|
test "foreground blocking region suppresses hover on the main layer" {
  let ctx = UIContext::new()
  let blocker = @math.Rect::new(0.0, 0.0, 100.0, 100.0)

  // Frame 1: an open popup registers its blocking region
  ctx.begin_frame(RawInput::from_mouse(@math.Vec2::new(10.0, 10.0), false))
  ctx.block_hover(blocker)
  let _ = ctx.end_frame()

  // Frame 2: the widget underneath the popup no longer receives hover
  ctx.begin_frame(RawInput::from_mouse(@math.Vec2::new(10.0, 10.0), false))
  let (_id, rect, resp) = ctx.allocate_space(@math.Vec2::new(100.0, 100.0))
  assert_true(rect.contains(@math.Vec2::new(10.0, 10.0)))
  assert_true(!resp.hovered())

  // The popup itself sits on the foreground layer and stays interactive
  ctx.set_cursor(@math.Vec2::zero())
  ctx.begin_foreground()
  let (_fid, frect, fresp) = ctx.allocate_space(@math.Vec2::new(100.0, 100.0))
  ctx.end_foreground()
  assert_true(frect.contains(@math.Vec2::new(10.0, 10.0)))
  assert_true(fresp.hovered())
}
