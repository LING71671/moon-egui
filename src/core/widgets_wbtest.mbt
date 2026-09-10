///|
test "widgets: label allocation and text draw command" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::new())

  let resp = ctx.label("Hello, moon-egui!")
  assert_eq(resp.rect.h, 18.0)
  assert_true(resp.rect.w >= 64.0)

  let dl = ctx.end_frame()
  assert_eq(dl.len(), 1)
  let cmd0 = dl.get_command(0)
  assert_true(cmd0 is Some(@draw.DrawCmd::Text(_)))
}

///|
test "widgets: button interaction lifecycle (hover -> press -> click)" {
  let ctx = UIContext::new()

  // Frame 1: Mouse at (20, 10), button is 64x32
  let raw1 = RawInput::from_mouse(@math.Vec2::new(20.0, 10.0), false)
  ctx.begin_frame(raw1)
  let resp1 = ctx.button("Submit")
  assert_true(resp1.hovered())
  assert_true(!resp1.clicked())
  assert_true(!resp1.pressed())

  let dl1 = ctx.end_frame()
  assert_eq(dl1.len(), 3) // Rect + RectStroke + Text

  // Frame 2: Mouse clicked down on button
  let raw2 = RawInput::from_mouse(@math.Vec2::new(20.0, 10.0), true)
  ctx.begin_frame(raw2)
  let resp2 = ctx.button("Submit")
  assert_true(resp2.pressed())
  assert_true(!resp2.clicked())

  // Frame 3: Mouse released on button -> CLICK!
  let raw3 = RawInput::from_mouse(@math.Vec2::new(20.0, 10.0), false)
  ctx.begin_frame(raw3)
  let resp3 = ctx.button("Submit")
  assert_true(resp3.clicked())
  assert_true(!resp3.pressed())
}

///|
test "widgets: primary button rendering" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::new())

  let resp = ctx.button_primary("Action")
  assert_eq(resp.rect.h, 32.0)
  let dl = ctx.end_frame()
  assert_eq(dl.len(), 3)
}

///|
test "widgets: separator and spacer cursor positioning" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::new())

  assert_eq(ctx.cursor().y, 0.0)
  ctx.separator()
  // separator height is 9.0 + spacing 8.0 = 17.0
  assert_eq(ctx.cursor().y, 17.0)

  ctx.spacer(20.0)
  assert_eq(ctx.cursor().y, 37.0)
}

///|
test "widgets: checkbox toggle interaction" {
  let ctx = UIContext::new()

  // Frame 1: Hover and mouse press down
  let raw1 = RawInput::from_mouse(@math.Vec2::new(10.0, 10.0), true)
  ctx.begin_frame(raw1)
  let (state1, resp1) = ctx.checkbox("Audio", false)
  assert_true(resp1.pressed())
  assert_true(!state1) // not yet toggled until release

  // Frame 2: Mouse released -> click toggles state to true!
  let raw2 = RawInput::from_mouse(@math.Vec2::new(10.0, 10.0), false)
  ctx.begin_frame(raw2)
  let (state2, resp2) = ctx.checkbox("Audio", false)
  assert_true(resp2.clicked())
  assert_true(state2) // toggled to true!
}

///|
test "widgets: slider continuous dragging calculation" {
  let ctx = UIContext::new()

  // Frame 1: Mouse hovering over slider track (label_w ~ 44, track 120, so track spans ~44 to 164)
  // Drag at middle of track (x = 104)
  let raw1 = RawInput::from_mouse(@math.Vec2::new(104.0, 12.0), true)
  ctx.begin_frame(raw1)
  let (val1, resp1) = ctx.slider("Zoom", 0.0, 0.0, 100.0)
  assert_true(resp1.pressed())
  // 104 is halfway through track (44 to 164) -> ~50.0
  assert_true(val1 >= 45.0 && val1 <= 55.0)

  // Frame 2: Drag further right to x = 164 (end of track)
  let raw2 = RawInput::from_mouse(@math.Vec2::new(164.0, 12.0), true)
  ctx.begin_frame(raw2)
  let (val2, resp2) = ctx.slider("Zoom", val1, 0.0, 100.0)
  assert_true(resp2.dragged() || resp2.pressed())
  assert_true(val2 >= 99.0)

  // Frame 3: Drag beyond left bound (x = 0) while mouse is down
  let raw3 = RawInput::from_mouse(@math.Vec2::new(0.0, 12.0), true)
  ctx.begin_frame(raw3)
  let (val3, _) = ctx.slider("Zoom", val2, 0.0, 100.0)
  assert_eq(val3, 0.0) // clamped to min

  // Frame 4: slider_int steps
  let raw4 = RawInput::new()
  ctx.begin_frame(raw4)
  let (int_val, _) = ctx.slider_int("Volume", 50, 0, 100)
  assert_eq(int_val, 50)
}
