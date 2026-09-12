// Copyright 2026 Ling71671
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

///|
test "theme: default WidgetStyle values" {
  let style = WidgetStyle::default()
  assert_eq(style.scale, 1.0)
  assert_eq(style.elevation, 1.0)
  assert_eq(style.control_h_sm, 24.0)
  assert_eq(style.control_h_md, 32.0)
  assert_eq(style.control_h_lg, 40.0)
  assert_eq(style.font_xs, 10.0)
  assert_eq(style.font_sm, 11.0)
  assert_eq(style.font_small, 11.0)
  assert_eq(style.font_normal, 13.0)
  assert_eq(style.font_large, 15.0)
  assert_eq(style.font_xl, 18.0)
  assert_eq(style.spacing_xs, 4.0)
  assert_eq(style.spacing_sm, 8.0)
  assert_eq(style.spacing_md, 12.0)
  assert_eq(style.spacing_lg, 16.0)
  assert_eq(style.spacing_xl, 24.0)
  assert_eq(style.item_spacing, @math.Vec2::new(8.0, 8.0))
  assert_eq(style.radius_xs, 2.0)
  assert_eq(style.radius_sm, 4.0)
  assert_eq(style.radius_md, 6.0)
  assert_eq(style.radius_lg, 10.0)
  assert_eq(style.radius_xl, 12.0)
  assert_eq(style.caret_blink_interval, 0.53)

  // Component style descriptors
  let code_style = CodeEditorStyle::default()
  assert_eq(code_style.font_size, 12.5)
  assert_eq(code_style.gutter_w, 44.0)

  let plot_style = PlotStyle::default()
  assert_eq(plot_style.default_w, 280.0)
  assert_eq(plot_style.default_h, 150.0)

  let table_style = TableStyle::default()
  assert_eq(table_style.header_h, 32.0)
  assert_eq(table_style.row_h, 30.0)

  let fader_style = FaderStyle::default()
  assert_eq(fader_style.width, 44.0)
  assert_eq(fader_style.height, 150.0)

  let knob_style = KnobStyle::default()
  assert_eq(knob_style.radius, 20.0)
}

///|
test "theme: scale multiplier scales widget dimensions" {
  let ctx = UIContext::new()
  let scaled_style = { ..WidgetStyle::default(), scale: 1.5, }
  ctx.set_style(scaled_style)
  assert_eq(ctx.style().scale, 1.5)

  ctx.begin_frame(RawInput::new())
  let resp = ctx.button("Scaled Action")
  assert_eq(resp.rect.h, 48.0) // 32.0 * 1.5
}

///|
test "theme: cursor_icon reporting on hover" {
  let ctx = UIContext::new()

  // Frame 1: Mouse hovering over button at (30.0, 15.0)
  let raw1 = RawInput::from_mouse(@math.Vec2::new(30.0, 15.0), false)
  ctx.begin_frame(raw1)
  let resp_btn = ctx.button("Action")
  assert_true(resp_btn.hovered())
  assert_eq(ctx.cursor_icon(), "pointer")

  // Frame 2: Mouse hovering over text_edit at (30.0, 15.0)
  let ctx2 = UIContext::new()
  let raw2 = RawInput::from_mouse(@math.Vec2::new(30.0, 15.0), false)
  ctx2.begin_frame(raw2)
  let (_, resp_txt) = ctx2.text_edit("input_name", "Hello", "Enter...")
  assert_true(resp_txt.hovered())
  assert_eq(ctx2.cursor_icon(), "text")
}

///|
test "theme: caret blinking and interaction reset" {
  let ctx = UIContext::new()
  // Initially at time 0.0, caret is visible
  assert_true(ctx.is_caret_visible())

  // Advance time to 0.6s (within off phase [0.5, 1.0))
  ctx.set_time(0.6)
  assert_false(ctx.is_caret_visible())

  // Advance time to 1.1s (within on phase [1.0, 1.5))
  ctx.set_time(1.1)
  assert_true(ctx.is_caret_visible())

  // Advance time to 1.7s (within off phase [1.5, 2.0))
  ctx.set_time(1.7)
  assert_false(ctx.is_caret_visible())

  // User types or clicks: caret immediately resets to visible
  ctx.reset_caret_blink()
  assert_true(ctx.is_caret_visible())
}

///|
test "theme: custom caret blink interval is honored" {
  let ctx = UIContext::new()
  let custom_style = { ..WidgetStyle::default(), caret_blink_interval: 0.8, }
  ctx.set_style(custom_style)

  // At 0.7s (< 0.8s), should still be visible
  ctx.set_time(0.7)
  assert_true(ctx.is_caret_visible())

  // At 0.9s (in [0.8, 1.6)), should be off
  ctx.set_time(0.9)
  assert_false(ctx.is_caret_visible())

  // At 1.7s (in [1.6, 2.4)), should be on again
  ctx.set_time(1.7)
  assert_true(ctx.is_caret_visible())
}

///|
test "text_edit: caret line rendered when visible and omitted when blinking off" {
  let ctx = UIContext::new()

  // Frame 1: mouse down on field at time 0.0
  let raw1 = RawInput::from_mouse(@math.Vec2::new(30.0, 15.0), true)
  ctx.begin_frame(raw1)
  let _ = ctx.text_edit("email", "dev@moonbitlang.com", "")
  let dl1 = ctx.end_frame()
  let mut has_line1 = false
  for i = 0; i < dl1.len(); i = i + 1 {
    if dl1.get_command(i) is Some(@draw.DrawCmd::Line(_)) {
      has_line1 = true
    }
  }
  assert_true(has_line1)

  // Frame 2: mouse released to complete click at time 0.05
  ctx.set_time(0.05)
  let raw2 = RawInput::from_mouse(@math.Vec2::new(30.0, 15.0), false)
  ctx.begin_frame(raw2)
  let _ = ctx.text_edit("email", "dev@moonbitlang.com", "")
  let _ = ctx.end_frame()

  // Frame 3: idle for 0.6s (time = 0.65s) -> caret enters off phase (hidden)
  ctx.set_time(0.65)
  let raw3 = RawInput::from_mouse(@math.Vec2::new(-100.0, -100.0), false)
  ctx.begin_frame(raw3)
  let _ = ctx.text_edit("email", "dev@moonbitlang.com", "")
  let dl3 = ctx.end_frame()
  let mut has_line3 = false
  for i = 0; i < dl3.len(); i = i + 1 {
    if dl3.get_command(i) is Some(@draw.DrawCmd::Line(_)) {
      has_line3 = true
    }
  }
  assert_false(has_line3)

  // Frame 4: user types a key -> caret immediately solid (visible)
  let raw4 = RawInput::with_events(
    @math.Vec2::new(-100.0, -100.0),
    false,
    @math.Vec2::zero(),
    [],
    "x",
    Modifiers::none(),
  )
  ctx.begin_frame(raw4)
  let _ = ctx.text_edit("email", "dev@moonbitlang.com", "")
  let dl4 = ctx.end_frame()
  let mut has_line4 = false
  for i = 0; i < dl4.len(); i = i + 1 {
    if dl4.get_command(i) is Some(@draw.DrawCmd::Line(_)) {
      has_line4 = true
    }
  }
  assert_true(has_line4)
}

///|
test "theme: runtime dynamic theme switching" {
  let ctx = UIContext::new()
  assert_eq(ctx.theme().name, "studio_light")
  assert_eq(ctx.theme().bg_window, @color.Color::hex(0xFFFFFF))

  ctx.set_theme(Theme::slate_dark())
  assert_eq(ctx.theme().name, "slate_dark")
  assert_eq(ctx.theme().bg_window, @color.Color::hex(0x111827))

  ctx.set_theme(Theme::high_contrast())
  assert_eq(ctx.theme().name, "high_contrast")
  assert_eq(ctx.theme().bg_window, @color.Color::hex(0x000000))
}

///|
test "theme: animate_bool and animate_float immediate-mode transitions" {
  let ctx = UIContext::new()
  let id = Id::from_int(101)

  // Frame 1: start at false (0.0) with 0.1s duration
  ctx.begin_frame(RawInput::new())
  let v0 = ctx.animate_bool(id, false, 0.1)
  assert_eq(v0, 0.0)
  let _ = ctx.end_frame()

  // Frame 2: target becomes true, advance dt=0.05s (50% progress)
  let raw2 = RawInput::from_mouse(@math.Vec2::zero(), false, dt=0.05)
  ctx.begin_frame(raw2)
  let v1 = ctx.animate_bool(id, true, 0.1)
  assert_true(v1 >= 0.49 && v1 <= 0.51)
  let _ = ctx.end_frame()

  // Frame 3: advance another 0.05s (reaches 100% = 1.0)
  let raw3 = RawInput::from_mouse(@math.Vec2::zero(), false, dt=0.05)
  ctx.begin_frame(raw3)
  let v2 = ctx.animate_bool(id, true, 0.1)
  assert_eq(v2, 1.0)
  let _ = ctx.end_frame()

  // Test animate_float
  let id_f = Id::from_int(202)
  ctx.begin_frame(RawInput::new())
  let f0 = ctx.animate_float(id_f, 100.0, 0.1)
  assert_eq(f0, 100.0)
  let _ = ctx.end_frame()

  let raw_f = RawInput::from_mouse(@math.Vec2::zero(), false, dt=0.05)
  ctx.begin_frame(raw_f)
  let f1 = ctx.animate_float(id_f, 200.0, 0.1)
  assert_true(f1 > 100.0 && f1 < 200.0)
  let _ = ctx.end_frame()
}
