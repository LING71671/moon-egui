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
  assert_eq(style.button_h, 32.0)
  assert_eq(style.button_pad_x, 14.0)
  assert_eq(style.text_edit_h, 32.0)
  assert_eq(style.text_edit_pad_x, 10.0)
  assert_eq(style.caret_h, 16.0)
  assert_eq(style.slider_h, 24.0)
  assert_eq(style.slider_track_w, 120.0)
  assert_eq(style.toggle_w, 36.0)
  assert_eq(style.font_normal, 13.0)
  assert_eq(style.item_spacing, @math.Vec2::new(8.0, 8.0))
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
