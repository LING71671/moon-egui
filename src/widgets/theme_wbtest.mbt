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

///|
fn get_first_rect_color(dl : @draw.DrawList) -> @color.Color? {
  for cmd in dl.commands() {
    match cmd {
      @draw.DrawCmd::Rect(_, col, _) => return Some(col)
      _ => ()
    }
  }
  None
}

///|
test "widgets: dynamic theme switching recolors standard button" {
  let ctx = @core.UIContext::new()
  let unhovered = @core.RawInput::from_mouse(
    @math.Vec2::new(-100.0, -100.0),
    false,
  )

  // 1. Studio Light theme
  ctx.set_theme(@core.Theme::studio_light())
  ctx.begin_frame(unhovered)
  let _ = button(ctx, "Light Button")
  let dl_light = ctx.end_frame()
  assert_eq(get_first_rect_color(dl_light), Some(@color.Color::hex(0xFFFFFF)))

  // 2. Slate Dark theme
  ctx.set_theme(@core.Theme::slate_dark())
  ctx.begin_frame(unhovered)
  let _ = button(ctx, "Dark Button")
  let dl_dark = ctx.end_frame()
  assert_eq(get_first_rect_color(dl_dark), Some(@color.Color::hex(0x111827)))

  // 3. High Contrast theme
  ctx.set_theme(@core.Theme::high_contrast())
  ctx.begin_frame(unhovered)
  let _ = button(ctx, "Contrast Button")
  let dl_contrast = ctx.end_frame()
  assert_eq(
    get_first_rect_color(dl_contrast),
    Some(@color.Color::hex(0x000000)),
  )
}

///|
test "widgets: primary button adapts accent color dynamically across themes" {
  let ctx = @core.UIContext::new()
  let unhovered = @core.RawInput::from_mouse(
    @math.Vec2::new(-100.0, -100.0),
    false,
  )

  // Light
  ctx.set_theme(@core.Theme::studio_light())
  ctx.begin_frame(unhovered)
  let _ = button(ctx, "Action", primary=true)
  let dl_light = ctx.end_frame()
  assert_eq(get_first_rect_color(dl_light), Some(@color.Color::hex(0x2563EB)))

  // Dark
  ctx.set_theme(@core.Theme::slate_dark())
  ctx.begin_frame(unhovered)
  let _ = button(ctx, "Action", primary=true)
  let dl_dark = ctx.end_frame()
  assert_eq(get_first_rect_color(dl_dark), Some(@color.Color::hex(0x3B82F6)))

  // High Contrast
  ctx.set_theme(@core.Theme::high_contrast())
  ctx.begin_frame(unhovered)
  let _ = button(ctx, "Action", primary=true)
  let dl_contrast = ctx.end_frame()
  assert_eq(
    get_first_rect_color(dl_contrast),
    Some(@color.Color::hex(0x00E5FF)),
  )
}

///|
test "widgets: badge status colors adapt to theme tokens" {
  let ctx = @core.UIContext::new()

  // High Contrast theme uses bright red (0xFF0000) for danger
  ctx.set_theme(@core.Theme::high_contrast())
  ctx.begin_frame(@core.RawInput::new())
  let _ = badge(ctx, "Danger", kind=Danger)
  let dl = ctx.end_frame()
  // High contrast danger bg is theme.danger.with_alpha(35)
  let expected_bg = @color.Color::hex(0xFF0000).with_alpha(35)
  assert_eq(get_first_rect_color(dl), Some(expected_bg))

  // Slate Dark theme uses 0xEF4444 for danger
  ctx.set_theme(@core.Theme::slate_dark())
  ctx.begin_frame(@core.RawInput::new())
  let _ = badge(ctx, "Danger", kind=Danger)
  let dl_dark = ctx.end_frame()
  let expected_dark_bg = @color.Color::hex(0xEF4444).with_alpha(35)
  assert_eq(get_first_rect_color(dl_dark), Some(expected_dark_bg))
}

///|
test "widgets: text_edit background adapts dynamically across themes" {
  let ctx = @core.UIContext::new()
  let unhovered = @core.RawInput::from_mouse(
    @math.Vec2::new(-100.0, -100.0),
    false,
  )

  // Light: 0xFFFFFF (theme.bg_window)
  ctx.set_theme(@core.Theme::studio_light())
  ctx.begin_frame(unhovered)
  let _ = text_edit_val(ctx, "input_fld", "Sample Text")
  let dl_light = ctx.end_frame()
  assert_eq(get_first_rect_color(dl_light), Some(@color.Color::hex(0xFFFFFF)))

  // Dark: 0x111827 (theme.bg_window)
  ctx.set_theme(@core.Theme::slate_dark())
  ctx.begin_frame(unhovered)
  let _ = text_edit_val(ctx, "input_fld", "Sample Text")
  let dl_dark = ctx.end_frame()
  assert_eq(get_first_rect_color(dl_dark), Some(@color.Color::hex(0x111827)))

  // Contrast: 0x000000 (theme.bg_window)
  ctx.set_theme(@core.Theme::high_contrast())
  ctx.begin_frame(unhovered)
  let _ = text_edit_val(ctx, "input_fld", "Sample Text")
  let dl_contrast = ctx.end_frame()
  assert_eq(
    get_first_rect_color(dl_contrast),
    Some(@color.Color::hex(0x000000)),
  )
}

///|
test "widgets: checked checkbox adapts accent fill across themes" {
  let ctx = @core.UIContext::new()
  let unhovered = @core.RawInput::from_mouse(
    @math.Vec2::new(-100.0, -100.0),
    false,
  )

  // Light: 0x2563EB
  ctx.set_theme(@core.Theme::studio_light())
  ctx.begin_frame(unhovered)
  let _ = checkbox(ctx, "Accept Terms", true)
  let dl_light = ctx.end_frame()
  assert_eq(get_first_rect_color(dl_light), Some(@color.Color::hex(0x2563EB)))

  // Dark: 0x3B82F6
  ctx.set_theme(@core.Theme::slate_dark())
  ctx.begin_frame(unhovered)
  let _ = checkbox(ctx, "Accept Terms", true)
  let dl_dark = ctx.end_frame()
  assert_eq(get_first_rect_color(dl_dark), Some(@color.Color::hex(0x3B82F6)))

  // Contrast: 0x00E5FF
  ctx.set_theme(@core.Theme::high_contrast())
  ctx.begin_frame(unhovered)
  let _ = checkbox(ctx, "Accept Terms", true)
  let dl_contrast = ctx.end_frame()
  assert_eq(
    get_first_rect_color(dl_contrast),
    Some(@color.Color::hex(0x00E5FF)),
  )
}
