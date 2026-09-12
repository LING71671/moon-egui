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
test "widgets: scale multiplier scales widget dimensions" {
  let ctx = @core.UIContext::new()
  let scaled_style = @core.WidgetStyle::default().scaled(1.5)
  ctx.set_style(scaled_style)
  assert_eq(ctx.style().scale, 1.5)

  ctx.begin_frame(@core.RawInput::new())
  let resp = button(ctx, "Scaled Action")
  assert_eq(resp.rect.h, 48.0) // 32.0 * 1.5
}

///|
test "widgets: cursor_icon reporting on hover" {
  let ctx = @core.UIContext::new()

  // Frame 1: Mouse hovering over button at (30.0, 15.0)
  let raw1 = @core.RawInput::from_mouse(@math.Vec2::new(30.0, 15.0), false)
  ctx.begin_frame(raw1)
  let resp_btn = button(ctx, "Action")
  assert_true(resp_btn.hovered())
  assert_eq(ctx.cursor_icon(), "pointer")

  // Frame 2: Mouse hovering over text_edit at (30.0, 15.0)
  let ctx2 = @core.UIContext::new()
  let raw2 = @core.RawInput::from_mouse(@math.Vec2::new(30.0, 15.0), false)
  ctx2.begin_frame(raw2)
  let (_, resp_txt) = text_edit_val(
    ctx2,
    "input_name",
    "Hello",
    placeholder="Enter...",
  )
  assert_true(resp_txt.hovered())
  assert_eq(ctx2.cursor_icon(), "text")
}
