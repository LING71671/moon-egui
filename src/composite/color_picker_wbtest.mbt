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
test "color_picker: HSV and RGB conversion round-trip" {
  // Pure Red: (255, 0, 0) -> H=0, S=1, V=1
  let (h1, s1, v1) = rgb_to_hsv(255, 0, 0)
  assert_eq(h1, 0.0)
  assert_eq(s1, 1.0)
  assert_eq(v1, 1.0)

  let (r1, g1, b1) = hsv_to_rgb(0.0, 1.0, 1.0)
  assert_eq(r1, 255)
  assert_eq(g1, 0)
  assert_eq(b1, 0)

  // Pure Green: (0, 255, 0) -> H=120, S=1, V=1
  let (h2, s2, v2) = rgb_to_hsv(0, 255, 0)
  assert_eq(h2, 120.0)
  assert_eq(s2, 1.0)
  assert_eq(v2, 1.0)

  let (r2, g2, b2) = hsv_to_rgb(120.0, 1.0, 1.0)
  assert_eq(r2, 0)
  assert_eq(g2, 255)
  assert_eq(b2, 0)

  // Pure White: (255, 255, 255) -> S=0, V=1
  let (_, s3, v3) = rgb_to_hsv(255, 255, 255)
  assert_eq(s3, 0.0)
  assert_eq(v3, 1.0)
}

///|
test "color_picker: panel renders grid and controls" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::from_mouse(@math.Vec2::new(-100.0, -100.0), false))

  let initial_color = @color.Color::rgba(79, 70, 229, 200)
  let (col, resp) = color_picker(ctx, "picker1", initial_color, show_alpha=true)
  let dl = ctx.end_frame()

  assert_eq(resp.rect.w, 180.0)
  assert_eq(resp.rect.h, 230.0)
  assert_eq(col.a, 200)
  // card + stroke + 70 grid tiles + border + 2 cursor rings + 24 hue tiles + hue stroke + thumb + thumb stroke + alpha bar + 16 alpha tiles + alpha stroke + thumb + thumb stroke + swatch + swatch stroke + hex text = 120+ cmds
  assert_true(dl.len() > 100)
}

///|
test "color_picker_button: renders button with swatch and hex" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::from_mouse(@math.Vec2::new(-100.0, -100.0), false))

  let col = @color.Color::rgb(255, 0, 0)
  let (_c, resp) = color_picker_button(ctx, "btn1", col, show_alpha=false)
  let dl = ctx.end_frame()

  assert_true(resp.rect.w > 70.0)
  assert_eq(resp.rect.h, 28.0)
  assert_true(dl.len() >= 4) // button bg, border, swatch, swatch border, text
}

///|
test "color_picker: drag handles report a resize cursor" {
  let ctx = @core.UIContext::new()

  // The panel is (180 x 230) at the cursor; inside it the SV area spans
  // y + 10 .. y + 136, the hue bar y + 144 .. y + 156 and the alpha bar
  // y + 164 .. y + 176.
  let cx = 90.0

  let sv = @core.RawInput::from_mouse(@math.Vec2::new(cx, 70.0), false)
  ctx.begin_frame(sv)
  let _ = color_picker(ctx, "cp_cursor_sv", @color.Color::rgb(255, 0, 0))
  assert_eq(ctx.cursor_icon(), "crosshair")
  let _ = ctx.end_frame()

  let hue = @core.RawInput::from_mouse(@math.Vec2::new(cx, 150.0), false)
  ctx.begin_frame(hue)
  let _ = color_picker(ctx, "cp_cursor_hue", @color.Color::rgb(255, 0, 0))
  assert_eq(ctx.cursor_icon(), "ew-resize")
  let _ = ctx.end_frame()

  let alpha = @core.RawInput::from_mouse(@math.Vec2::new(cx, 170.0), false)
  ctx.begin_frame(alpha)
  let _ = color_picker(ctx, "cp_cursor_alpha", @color.Color::rgb(255, 0, 0))
  assert_eq(ctx.cursor_icon(), "ew-resize")
  let _ = ctx.end_frame()

  // Away from the panel the cursor falls back to the default arrow.
  let away = @core.RawInput::from_mouse(@math.Vec2::new(600.0, 400.0), false)
  ctx.begin_frame(away)
  let _ = color_picker(ctx, "cp_cursor_away", @color.Color::rgb(255, 0, 0))
  assert_eq(ctx.cursor_icon(), "default")
  let _ = ctx.end_frame()
}
