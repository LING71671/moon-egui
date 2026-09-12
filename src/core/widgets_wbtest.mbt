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

  // Frame 2: Drag further right to x = 180 (end of track)
  let raw2 = RawInput::from_mouse(@math.Vec2::new(180.0, 12.0), true)
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

///|
test "widgets: button_sized and mouse capture integration" {
  let ctx = UIContext::new()

  // Frame 1: Mouse at (20, 10) hovering over button
  let raw1 = RawInput::from_mouse(@math.Vec2::new(20.0, 10.0), false)
  ctx.begin_frame(raw1)
  let resp = ctx.button_sized("Compact", @math.Vec2::new(80.0, 24.0))
  assert_eq(resp.rect.w, 80.0)
  assert_eq(resp.rect.h, 24.0)
  assert_true(resp.hovered())
  assert_true(ctx.wants_capture_mouse())

  let _ = ctx.end_frame()

  // Frame 2: Mouse at (500, 500) far away -> no capture
  let raw2 = RawInput::from_mouse(@math.Vec2::new(500.0, 500.0), false)
  ctx.begin_frame(raw2)
  let resp2 = ctx.button_sized("Compact", @math.Vec2::new(80.0, 24.0))
  assert_true(!resp2.hovered())
  let _ = ctx.end_frame()
  assert_true(!ctx.wants_capture_mouse())
}

///|
test "widgets: scroll_area content measurement, wheel scrolling and clamping" {
  let ctx = UIContext::new()

  // Frame 1: Initial layout of scroll area with high content
  // Container size: (200, 100). Content: 10 labels of height 18 + 8 = 260px.
  ctx.begin_frame(RawInput::new())
  ctx.scroll_area("viewport_1", @math.Vec2::new(200.0, 100.0), fn(ui) {
    for i = 0; i < 10; i = i + 1 {
      let _ = ui.label("Item " + i.to_string())
    }
  })
  let dl1 = ctx.end_frame()
  // Clip pushed, labels drawn, clip popped, scrollbar drawn
  assert_true(dl1.len() > 10)

  // Frame 2: Mouse inside container at (50, 50), scroll wheel down by 40.0
  let raw2 = {
    mouse_pos: @math.Vec2::new(50.0, 50.0),
    mouse_down: false,
    mouse_secondary_down: false,
    scroll_delta: @math.Vec2::zero(),
    dt: 0.0166,
    events: [Event::PointerWheel(@math.Vec2::new(0.0, -40.0))],
    text_input: "",
    modifiers: Modifiers::none(),
  }
  ctx.begin_frame(raw2)
  let mut scrolled_cursor_y = 0.0
  ctx.scroll_area("viewport_1", @math.Vec2::new(200.0, 100.0), fn(ui) {
    scrolled_cursor_y = ui.cursor().y
    let _ = ui.label("Item 0")
  })
  let _ = ctx.end_frame()

  // Because scroll_y = 40.0, the inner cursor starts at container_y - scroll_y = 0.0 - 40.0 = -40.0
  assert_eq(scrolled_cursor_y, -40.0)
}

///|
test "widgets: text_edit typing, backspace, and cursor navigation" {
  let ctx = UIContext::new()

  // Frame 1: Click at (100, 10) to focus text_edit and position cursor at end
  let raw1 = RawInput::from_mouse(@math.Vec2::new(100.0, 10.0), true)
  ctx.begin_frame(raw1)
  let (t1, resp1) = ctx.text_edit("input_name", "Hello", "Enter name...")
  let _ = ctx.end_frame()
  assert_true(resp1.pressed())
  assert_eq(t1, "Hello")

  // Frame 2: Backspace key deletes 'o' from end of "Hello" -> "Hell"
  let raw2 = {
    mouse_pos: @math.Vec2::zero(),
    mouse_down: false,
    mouse_secondary_down: false,
    scroll_delta: @math.Vec2::zero(),
    dt: 0.0166,
    events: [Event::Key(Key::Backspace, true, Modifiers::none())],
    text_input: "",
    modifiers: Modifiers::none(),
  }
  ctx.begin_frame(raw2)
  let (t2, _) = ctx.text_edit("input_name", t1, "Enter name...")
  let _ = ctx.end_frame()
  assert_eq(t2, "Hell")

  // Frame 3: TextInput inserts "o World" at end of "Hell" -> "Hello World"
  let raw3 = {
    mouse_pos: @math.Vec2::zero(),
    mouse_down: false,
    mouse_secondary_down: false,
    scroll_delta: @math.Vec2::zero(),
    dt: 0.0166,
    events: [Event::TextInput("o World")],
    text_input: "",
    modifiers: Modifiers::none(),
  }
  ctx.begin_frame(raw3)
  let (t3, _) = ctx.text_edit("input_name", t2, "Enter name...")
  let _ = ctx.end_frame()
  assert_eq(t3, "Hello World")

  // Frame 4: Home key moves cursor to start (0)
  let raw4 = {
    mouse_pos: @math.Vec2::zero(),
    mouse_down: false,
    mouse_secondary_down: false,
    scroll_delta: @math.Vec2::zero(),
    dt: 0.0166,
    events: [Event::Key(Key::Home, true, Modifiers::none())],
    text_input: "",
    modifiers: Modifiers::none(),
  }
  ctx.begin_frame(raw4)
  let (t4, _) = ctx.text_edit("input_name", t3, "Enter name...")
  let _ = ctx.end_frame()
  assert_eq(t4, "Hello World")

  // Frame 5: TextInput inserts ">>> " at start (cursor 0) -> ">>> Hello World"
  let raw5 = {
    mouse_pos: @math.Vec2::zero(),
    mouse_down: false,
    mouse_secondary_down: false,
    scroll_delta: @math.Vec2::zero(),
    dt: 0.0166,
    events: [Event::TextInput(">>> ")],
    text_input: "",
    modifiers: Modifiers::none(),
  }
  ctx.begin_frame(raw5)
  let (t5, _) = ctx.text_edit("input_name", t4, "Enter name...")
  let dl = ctx.end_frame()
  assert_eq(t5, ">>> Hello World")
  assert_true(dl.len() > 3)
}

///|
test "widgets: radio button toggle interaction" {
  let ctx = UIContext::new()

  // Frame 1: Initial state (opt1 = true, opt2 = false)
  ctx.begin_frame(RawInput::new())
  let (s1, resp1) = ctx.radio("Option A", true)
  let (s2, resp2) = ctx.radio("Option B", false)
  let _ = ctx.end_frame()
  assert_true(s1)
  assert_true(!s2)
  assert_true(!resp1.clicked())
  assert_true(!resp2.clicked())

  // Frame 2: Mouse click on Option B (starts at y = 22 + 8 = 30)
  let raw2 = RawInput::from_mouse(@math.Vec2::new(10.0, 40.0), false)
  // simulate click release
  let raw_press = RawInput::from_mouse(@math.Vec2::new(10.0, 40.0), true)
  ctx.begin_frame(raw_press)
  let _ = ctx.radio("Option A", true)
  let (_, resp2_press) = ctx.radio("Option B", false)
  assert_true(resp2_press.pressed())

  ctx.begin_frame(raw2)
  let _ = ctx.radio("Option A", true)
  let (s2_clicked, resp2_release) = ctx.radio("Option B", false)
  assert_true(resp2_release.clicked())
  assert_true(s2_clicked)
}

///|
test "widgets: progress_bar value clamping and drawing" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::new())

  let resp1 = ctx.progress_bar(0.65, "65%")
  assert_eq(resp1.rect.h, 18.0)

  // Clamp over 1.0 and under 0.0
  let resp2 = ctx.progress_bar(1.5, "")
  assert_eq(resp2.rect.h, 18.0)

  let resp3 = ctx.progress_bar(-0.5, "")
  assert_eq(resp3.rect.h, 18.0)

  let dl = ctx.end_frame()
  assert_true(dl.len() >= 6) // each has rect, border, fill, text
}

///|
test "widgets: collapsing_header expand, collapse and indentation" {
  let ctx = UIContext::new()

  // Frame 1: Header starts closed (default_open: false)
  ctx.begin_frame(RawInput::new())
  let mut content_evaluated = false
  let resp1 = ctx.collapsing_header("sec_1", "Section 1", false, fn(ui) {
    content_evaluated = true
    let _ = ui.label("Secret Content")
  })
  let _ = ctx.end_frame()
  assert_true(!content_evaluated)
  assert_eq(resp1.rect.h, 26.0)

  // Frame 2: Click header to toggle open
  let raw_press = RawInput::from_mouse(@math.Vec2::new(20.0, 10.0), true)
  ctx.begin_frame(raw_press)
  let _ = ctx.collapsing_header("sec_1", "Section 1", false, fn(_ui) {  })

  let raw_release = RawInput::from_mouse(@math.Vec2::new(20.0, 10.0), false)
  ctx.begin_frame(raw_release)
  let mut inner_cursor_x = 0.0
  let resp2 = ctx.collapsing_header("sec_1", "Section 1", false, fn(ui) {
    content_evaluated = true
    inner_cursor_x = ui.cursor().x
    let _ = ui.label("Secret Content")
  })
  let _ = ctx.end_frame()

  assert_true(resp2.clicked())
  assert_true(content_evaluated)
  // Indented by 16.0 px
  assert_eq(inner_cursor_x, 16.0)
  // Outer cursor returns to 0.0
  assert_eq(ctx.cursor().x, 0.0)
}

///|
test "widgets: combo_box popup open and selection" {
  let ctx = UIContext::new()
  let options = ["Dark", "Light", "Solarized"]

  // Frame 1: Combo box is closed initially
  ctx.begin_frame(RawInput::new())
  let (idx1, _) = ctx.combo_box("combo_theme", "Theme", 0, options)
  let dl1 = ctx.end_frame()
  assert_eq(idx1, 0)
  // Only main box drawn (bg, border, label, text, arrow)
  assert_true(dl1.len() <= 6)

  // Frame 2: Click on combo box to open dropdown
  let raw2 = RawInput::from_mouse(@math.Vec2::new(100.0, 14.0), true)
  ctx.begin_frame(raw2)
  let _ = ctx.combo_box("combo_theme", "Theme", 0, options)
  assert_true(ctx.open_combo_id() != Id::zero())

  // Release mouse after opening
  let raw_rel = RawInput::from_mouse(@math.Vec2::new(100.0, 14.0), false)
  ctx.begin_frame(raw_rel)
  let _ = ctx.combo_box("combo_theme", "Theme", 0, options)

  // Frame 3: While open, click on item 1 ("Light")
  // item 1 is at y = 28 + 2 + 24 * 1 = 54
  let raw3 = RawInput::from_mouse(@math.Vec2::new(100.0, 56.0), true)
  ctx.begin_frame(raw3)
  let (idx3, _) = ctx.combo_box("combo_theme", "Theme", 0, options)
  assert_eq(idx3, 1)
  // Menu closes after selection
  assert_eq(ctx.open_combo_id(), Id::zero())
}

///|
test "widgets: toggle switch state transition" {
  let ctx = UIContext::new()

  // Frame 1: Toggle initially off, hovered
  let raw1 = RawInput::from_mouse(@math.Vec2::new(10.0, 10.0), false)
  ctx.begin_frame(raw1)
  let (state1, resp1) = ctx.toggle("Snap to Grid", false)
  let _ = ctx.end_frame()
  assert_eq(state1, false)
  assert_true(resp1.hovered())

  // Frame 2: Click to toggle ON
  let raw2 = RawInput::from_mouse(@math.Vec2::new(10.0, 10.0), true)
  ctx.begin_frame(raw2)
  let (state2, _) = ctx.toggle("Snap to Grid", false)
  let _ = ctx.end_frame()

  let raw3 = RawInput::from_mouse(@math.Vec2::new(10.0, 10.0), false)
  ctx.begin_frame(raw3)
  let (state3, resp3) = ctx.toggle("Snap to Grid", state2)
  let _ = ctx.end_frame()
  assert_true(resp3.clicked())
  assert_eq(state3, true)
}

///|
test "widgets: drag_value dragging and clamping" {
  let ctx = UIContext::new()

  // Frame 1: Initial state
  ctx.begin_frame(RawInput::new())
  let (val1, _) = ctx.drag_value("Scale", 1.0, 0.1, 0.5, 5.0)
  let _ = ctx.end_frame()
  assert_eq(val1, 1.0)

  // Frame 2: Mouse press on box
  let raw2 = RawInput::from_mouse(@math.Vec2::new(60.0, 10.0), true)
  ctx.begin_frame(raw2)
  let _ = ctx.drag_value("Scale", 1.0, 0.1, 0.5, 5.0)

  // Frame 3: Mouse drag to the right
  let raw3 = RawInput::from_mouse(@math.Vec2::new(70.0, 10.0), true)
  ctx.begin_frame(raw3)
  let (val3, _) = ctx.drag_value("Scale", 1.0, 0.1, 0.5, 5.0)
  let _ = ctx.end_frame()
  assert_true(val3 >= 1.0)
}

///|
test "widgets: tab_bar item selection" {
  let ctx = UIContext::new()
  let tabs = ["Inspector", "Layers", "Settings"]

  // Frame 1: Initially tab 0 selected
  ctx.begin_frame(RawInput::new())
  let (sel1, _) = ctx.tab_bar("panel_tabs", tabs, 0)
  let _ = ctx.end_frame()
  assert_eq(sel1, 0)

  // Frame 2: Click on tab 1 ("Layers" at approx x = 120.0, y = 14.0)
  let raw2 = RawInput::from_mouse(@math.Vec2::new(120.0, 14.0), true)
  ctx.begin_frame(raw2)
  let (sel2, _) = ctx.tab_bar("panel_tabs", tabs, 0)
  let _ = ctx.end_frame()
  assert_eq(sel2, 1)
}

///|
test "widgets: color_button click and dimensions" {
  let ctx = UIContext::new()
  let col = @color.Color::rgb(255, 100, 50)

  // Frame 1: Hover over color button
  let raw1 = RawInput::from_mouse(@math.Vec2::new(10.0, 10.0), false)
  ctx.begin_frame(raw1)
  let (clicked1, resp1) = ctx.color_button("stroke_col", col)
  let _ = ctx.end_frame()
  assert_false(clicked1)
  assert_true(resp1.hovered())
  assert_eq(resp1.rect.w, 22.0)
  assert_eq(resp1.rect.h, 22.0)

  // Frame 2: Click color button
  let raw2 = RawInput::from_mouse(@math.Vec2::new(10.0, 10.0), true)
  ctx.begin_frame(raw2)
  let _ = ctx.color_button("stroke_col", col)

  let raw3 = RawInput::from_mouse(@math.Vec2::new(10.0, 10.0), false)
  ctx.begin_frame(raw3)
  let (clicked3, resp3) = ctx.color_button("stroke_col", col)
  let _ = ctx.end_frame()
  assert_true(clicked3)
  assert_true(resp3.clicked())
}

///|
test "widgets: tooltip rendering" {
  let ctx = UIContext::new()

  ctx.begin_frame(RawInput::from_mouse(@math.Vec2::new(50.0, 50.0), false))
  ctx.tooltip("Ctrl + S to Save")
  let dl = ctx.end_frame()
  // Tooltip adds rect, stroke, text (at least 3 draw commands)
  assert_true(dl.len() >= 3)
}

///|
test "widgets: button_with_shortcut rendering" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::from_mouse(@math.Vec2::new(10.0, 10.0), false))
  let resp = ctx.button_with_shortcut("保存", "Ctrl+S")
  let dl = ctx.end_frame()
  assert_true(resp.rect.w >= 80.0)
  assert_true(resp.hovered())
  // Button background, stroke, main text, badge rect, badge text
  assert_true(dl.len() >= 5)
}

///|
test "widgets: drag_value speed modifiers shift and ctrl" {
  let ctx = UIContext::new()

  // Frame 1: Initial state
  ctx.begin_frame(RawInput::new())
  let (v1, _) = ctx.drag_value("", 100.0, 1.0, 0.0, 200.0)
  let _ = ctx.end_frame()
  assert_eq(v1, 100.0)

  // Frame 2: Mouse press on box
  let raw2 = RawInput::from_mouse(@math.Vec2::new(20.0, 10.0), true)
  ctx.begin_frame(raw2)
  let _ = ctx.drag_value("", 100.0, 1.0, 0.0, 200.0)
  let _ = ctx.end_frame()

  // Frame 3: Mouse moved +10px with Shift (0.1x micro-precision mode)
  let raw3 = {
    ..RawInput::from_mouse(@math.Vec2::new(30.0, 10.0), true),
    modifiers: Modifiers::new(false, true, false, false),
  }
  ctx.begin_frame(raw3)
  let (v3, _) = ctx.drag_value("", 100.0, 1.0, 0.0, 200.0)
  let _ = ctx.end_frame()
  // Delta is 10.0 * 1.0 * 0.1 = 1.0
  assert_eq(v3, 101.0)

  // Frame 4: Mouse moved +10px with Ctrl (10x coarse mode)
  let raw4 = {
    ..RawInput::from_mouse(@math.Vec2::new(40.0, 10.0), true),
    modifiers: Modifiers::new(true, false, false, false),
  }
  ctx.begin_frame(raw4)
  let (v4, _) = ctx.drag_value("", 100.0, 1.0, 0.0, 200.0)
  let _ = ctx.end_frame()
  // Delta is 10.0 * 1.0 * 10.0 = 100.0
  assert_eq(v4, 200.0)
}

///|
test "widgets: combo_box dismisses on a press outside the box and popup" {
  let ctx = UIContext::new()
  let options = ["Dark", "Light", "Solarized"]

  // Frame 1: press the box to open the dropdown
  ctx.begin_frame(RawInput::from_mouse(@math.Vec2::new(100.0, 14.0), true))
  let _ = ctx.combo_box("combo_theme", "Theme", 0, options)
  assert_true(ctx.open_combo_id() != Id::zero())
  let _ = ctx.end_frame()

  // Frame 2: releasing over the box keeps it open
  ctx.begin_frame(RawInput::from_mouse(@math.Vec2::new(100.0, 14.0), false))
  let _ = ctx.combo_box("combo_theme", "Theme", 0, options)
  assert_true(ctx.open_combo_id() != Id::zero())
  let _ = ctx.end_frame()

  // Frame 3: pressing well away from both closes it
  ctx.begin_frame(RawInput::from_mouse(@math.Vec2::new(600.0, 400.0), true))
  let _ = ctx.combo_box("combo_theme", "Theme", 0, options)
  assert_eq(ctx.open_combo_id(), Id::zero())
}

///|
test "widgets: tab_bar sizes each tab by its measured text width" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::new())

  // Latin: 1 * 13 * 0.58 = 7.54 plus 24 of padding
  let ascii_w = measure_text_size("A", 13.0).x + 24.0
  let (_, resp_ascii) = ctx.tab_bar("tabs_ascii", ["A"], 0)
  assert_eq(resp_ascii.rect.w, ascii_w)

  // CJK: 2 * 13 * 1.05 = 27.3 plus 24 of padding. A fixed 8px-per-character
  // estimate gave 2 * 8 + 24 = 40 and let the label overflow its tab.
  let cjk_w = measure_text_size("月兔", 13.0).x + 24.0
  let (_, resp_cjk) = ctx.tab_bar("tabs_cjk", ["月兔"], 0)
  assert_eq(resp_cjk.rect.w, cjk_w)
  assert_true(resp_cjk.rect.w > 40.0)

  // The groove spans the sum of the individual tabs
  let (_, resp_mixed) = ctx.tab_bar("tabs_mixed", ["A", "月兔"], 0)
  assert_eq(resp_mixed.rect.w, ascii_w + cjk_w)
}

///|
test "widgets: button and checkbox keyboard activation via Space and Enter" {
  let ctx = UIContext::new()

  // Frame 1: Tab key in end_frame navigates focus to the first focusable widget (Button)
  let raw1 = {
    ..RawInput::new(),
    events: [Event::Key(Key::Tab, true, Modifiers::none())],
  }
  ctx.begin_frame(raw1)
  let _ = ctx.button("Submit")
  let (chk_val1, _) = ctx.checkbox("Agree", false)
  let _ = ctx.end_frame()
  assert_true(!chk_val1)

  // Frame 2: Button now has focus from Frame 1 Tab traversal. Press Space -> Button triggers click
  let raw2 = {
    ..RawInput::new(),
    events: [Event::Key(Key::Space, true, Modifiers::none())],
  }
  ctx.begin_frame(raw2)
  let btn_resp2 = ctx.button("Submit")
  let _ = ctx.checkbox("Agree", false)
  let _ = ctx.end_frame()

  assert_true(btn_resp2.has_focus())
  assert_true(btn_resp2.clicked())

  // Frame 3: Button is still focused. Press Enter -> Button triggers click
  let raw3 = {
    ..RawInput::new(),
    events: [Event::Key(Key::Enter, true, Modifiers::none())],
  }
  ctx.begin_frame(raw3)
  let btn_resp3 = ctx.button("Submit")
  let _ = ctx.checkbox("Agree", false)
  let _ = ctx.end_frame()

  assert_true(btn_resp3.has_focus())
  assert_true(btn_resp3.clicked())

  // Frame 4: Tab navigates focus to next widget (Checkbox)
  let raw4 = {
    ..RawInput::new(),
    events: [Event::Key(Key::Tab, true, Modifiers::none())],
  }
  ctx.begin_frame(raw4)
  let _ = ctx.button("Submit")
  let _ = ctx.checkbox("Agree", false)
  let _ = ctx.end_frame()

  // Frame 5: Checkbox is now focused. Press Space on focused Checkbox -> toggles state
  let raw5 = {
    ..RawInput::new(),
    events: [Event::Key(Key::Space, true, Modifiers::none())],
  }
  ctx.begin_frame(raw5)
  let _ = ctx.button("Submit")
  let (chk_val5, chk_resp5) = ctx.checkbox("Agree", false)
  let _ = ctx.end_frame()

  assert_true(chk_resp5.has_focus())
  assert_true(chk_resp5.clicked())
  assert_true(chk_val5)
}

///|
test "widgets: slider keyboard arrow keys stepping when focused" {
  let ctx = UIContext::new()

  // Frame 1: Tab to focus the slider
  let raw1 = {
    ..RawInput::new(),
    events: [Event::Key(Key::Tab, true, Modifiers::none())],
  }
  ctx.begin_frame(raw1)
  let (val1, _) = ctx.slider("Volume", 50.0, 0.0, 100.0)
  let _ = ctx.end_frame()
  assert_eq(val1, 50.0)

  // Frame 2: Slider has focus. ArrowRight increments value by step (1.0 for range >= 100)
  let raw2 = {
    ..RawInput::new(),
    events: [Event::Key(Key::ArrowRight, true, Modifiers::none())],
  }
  ctx.begin_frame(raw2)
  let (val2, resp2) = ctx.slider("Volume", 50.0, 0.0, 100.0)
  let _ = ctx.end_frame()

  assert_true(resp2.has_focus())
  assert_eq(val2, 51.0)

  // Frame 3: ArrowDown decrements value by step
  let raw3 = {
    ..RawInput::new(),
    events: [Event::Key(Key::ArrowDown, true, Modifiers::none())],
  }
  ctx.begin_frame(raw3)
  let (val3, _) = ctx.slider("Volume", val2, 0.0, 100.0)
  let _ = ctx.end_frame()

  assert_eq(val3, 50.0)
}

///|
test "input: code_editor tab indentation consumes key and prevents focus escape" {
  let ctx = UIContext::new()

  // Frame 1: Click directly on code editor at (100.0, 50.0)
  let raw1 = RawInput::from_mouse(@math.Vec2::new(100.0, 50.0), true)
  ctx.begin_frame(raw1)
  let _ = ctx.button("Before")
  let (t1, resp1) = ctx.code_editor("editor", "fn main() {\n}")
  let _ = ctx.button("After")
  let _ = ctx.end_frame()

  assert_true(resp1.has_focus())

  // Frame 2: Press Tab inside code editor -> adds two spaces and keeps focus
  let raw2 = {
    ..RawInput::new(),
    events: [Event::Key(Key::Tab, true, Modifiers::none())],
  }
  ctx.begin_frame(raw2)
  let btn_before = ctx.button("Before")
  let (t2, resp2) = ctx.code_editor("editor", t1)
  let btn_after = ctx.button("After")
  let _ = ctx.end_frame()

  // Tab key was consumed by code_editor, so focus did not escape to "After" button
  assert_true(t2.contains("  "))
  assert_true(resp2.has_focus())
  assert_true(!btn_after.has_focus())
  assert_true(!btn_before.has_focus())
}

///|
test "input: secondary mouse click sets secondary_clicked on response" {
  let ctx = UIContext::new()

  // Frame 1: Press secondary mouse button (right-click) over button rect
  let raw1 = RawInput::from_mouse(
    @math.Vec2::new(50.0, 15.0),
    false,
    mouse_secondary_down=true,
  )
  ctx.begin_frame(raw1)
  let resp1 = ctx.button("RightClickMe")
  let _ = ctx.end_frame()

  assert_true(resp1.hovered())
  assert_true(resp1.secondary_clicked())
  assert_true(!resp1.clicked())
}
