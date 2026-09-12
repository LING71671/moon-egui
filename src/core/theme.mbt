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

///|
/// Systemic design tokens holding foundational scales, typography, and elevation metrics.
pub struct WidgetStyle {
  // Scaling & Elevation
  scale : Double
  elevation : Double

  // Base Interactive Control Heights
  control_h_sm : Double // 24.0
  control_h_md : Double // 32.0
  control_h_lg : Double // 40.0

  // Typography Scales
  font_xs : Double // 10.0
  font_sm : Double // 11.0
  font_small : Double // 11.0 (alias for font_sm)
  font_normal : Double // 13.0
  font_large : Double // 15.0
  font_xl : Double // 18.0

  // Spacing Scales
  spacing_xs : Double // 4.0
  spacing_sm : Double // 8.0
  spacing_md : Double // 12.0
  spacing_lg : Double // 16.0
  spacing_xl : Double // 24.0
  item_spacing : @math.Vec2 // (8.0, 8.0)

  // Corner Radius Scales
  radius_xs : Double // 2.0
  radius_sm : Double // 4.0
  radius_md : Double // 6.0
  radius_lg : Double // 10.0
  radius_xl : Double // 12.0

  // Caret & Cursor Interaction
  caret_blink_interval : Double // 0.53
} derive(Eq, Debug)

///|
/// Returns the standard Studio Light porcelain widget style.
pub fn WidgetStyle::default() -> WidgetStyle {
  {
    scale: 1.0,
    elevation: 1.0,
    control_h_sm: 24.0,
    control_h_md: 32.0,
    control_h_lg: 40.0,
    font_xs: 10.0,
    font_sm: 11.0,
    font_small: 11.0,
    font_normal: 13.0,
    font_large: 15.0,
    font_xl: 18.0,
    spacing_xs: 4.0,
    spacing_sm: 8.0,
    spacing_md: 12.0,
    spacing_lg: 16.0,
    spacing_xl: 24.0,
    item_spacing: @math.Vec2::new(8.0, 8.0),
    radius_xs: 2.0,
    radius_sm: 4.0,
    radius_md: 6.0,
    radius_lg: 10.0,
    radius_xl: 12.0,
    caret_blink_interval: 0.53,
  }
}

///|
/// Return a copy of this style with its global scale factor multiplied.
/// Downstream packages cannot mutate `WidgetStyle` fields directly, so this
/// fluent builder is the supported way to derive density variants.
pub fn WidgetStyle::scaled(self : WidgetStyle, factor : Double) -> WidgetStyle {
  { ..self, scale: self.scale * factor, }
}

///|
/// Runtime semantic theme profile holding color slots for all UI elements.
pub struct Theme {
  name : String
  bg_app : @color.Color
  bg_window : @color.Color
  bg_surface : @color.Color
  bg_subtle : @color.Color
  bg_hover : @color.Color
  bg_active : @color.Color
  bg_inverse : @color.Color
  border_muted : @color.Color
  border_default : @color.Color
  border_strong : @color.Color
  border_focus : @color.Color
  text_primary : @color.Color
  text_strong : @color.Color
  text_body : @color.Color
  text_secondary : @color.Color
  text_muted : @color.Color
  text_disabled : @color.Color
  text_inverse : @color.Color
  accent_primary : @color.Color
  accent_hover : @color.Color
  accent_pressed : @color.Color
  accent_deep : @color.Color
  accent_soft : @color.Color
  accent_light : @color.Color
} derive(Eq, Debug)

///|
/// Returns the standard Studio Light porcelain theme.
pub fn Theme::studio_light() -> Theme {
  {
    name: "studio_light",
    bg_app: @color.Color::hex(0xF8FAFC),
    bg_window: @color.Color::hex(0xFFFFFF),
    bg_surface: @color.Color::hex(0xF1F5F9),
    bg_subtle: @color.Color::hex(0xF8FAFC),
    bg_hover: @color.Color::hex(0xF8FAFC),
    bg_active: @color.Color::hex(0xE2E8F0),
    bg_inverse: @color.Color::hex(0x1A1B23),
    border_muted: @color.Color::hex(0xE2E8F0),
    border_default: @color.Color::hex(0xCBD5E1),
    border_strong: @color.Color::hex(0x94A3B8),
    border_focus: @color.Color::hex(0x2563EB),
    text_primary: @color.Color::hex(0x0F172A),
    text_strong: @color.Color::hex(0x1E293B),
    text_body: @color.Color::hex(0x334155),
    text_secondary: @color.Color::hex(0x475569),
    text_muted: @color.Color::hex(0x64748B),
    text_disabled: @color.Color::hex(0x94A3B8),
    text_inverse: @color.Color::hex(0xFFFFFF),
    accent_primary: @color.Color::hex(0x2563EB),
    accent_hover: @color.Color::hex(0x3B82F6),
    accent_pressed: @color.Color::hex(0x1D4ED8),
    accent_deep: @color.Color::hex(0x1E3A8A),
    accent_soft: @color.Color::rgba(37, 99, 235, 45),
    accent_light: @color.Color::rgba(255, 255, 255, 140),
  }
}

///|
/// Returns the dark slate theme profile.
pub fn Theme::slate_dark() -> Theme {
  {
    name: "slate_dark",
    bg_app: @color.Color::hex(0x0B0F19),
    bg_window: @color.Color::hex(0x111827),
    bg_surface: @color.Color::hex(0x1F2937),
    bg_subtle: @color.Color::hex(0x1E293B),
    bg_hover: @color.Color::hex(0x374151),
    bg_active: @color.Color::hex(0x4B5563),
    bg_inverse: @color.Color::hex(0xF8FAFC),
    border_muted: @color.Color::hex(0x1F2937),
    border_default: @color.Color::hex(0x374151),
    border_strong: @color.Color::hex(0x4B5563),
    border_focus: @color.Color::hex(0x3B82F6),
    text_primary: @color.Color::hex(0xF9FAFB),
    text_strong: @color.Color::hex(0xFFFFFF),
    text_body: @color.Color::hex(0xE5E7EB),
    text_secondary: @color.Color::hex(0x9CA3AF),
    text_muted: @color.Color::hex(0x6B7280),
    text_disabled: @color.Color::hex(0x4B5563),
    text_inverse: @color.Color::hex(0x111827),
    accent_primary: @color.Color::hex(0x3B82F6),
    accent_hover: @color.Color::hex(0x60A5FA),
    accent_pressed: @color.Color::hex(0x2563EB),
    accent_deep: @color.Color::hex(0x1D4ED8),
    accent_soft: @color.Color::rgba(59, 130, 246, 50),
    accent_light: @color.Color::rgba(255, 255, 255, 180),
  }
}

///|
/// Returns the high accessibility contrast theme profile.
pub fn Theme::high_contrast() -> Theme {
  {
    name: "high_contrast",
    bg_app: @color.Color::hex(0x000000),
    bg_window: @color.Color::hex(0x000000),
    bg_surface: @color.Color::hex(0x121212),
    bg_subtle: @color.Color::hex(0x1E1E1E),
    bg_hover: @color.Color::hex(0x2E2E2E),
    bg_active: @color.Color::hex(0x444444),
    bg_inverse: @color.Color::hex(0xFFFFFF),
    border_muted: @color.Color::hex(0x555555),
    border_default: @color.Color::hex(0xFFFFFF),
    border_strong: @color.Color::hex(0xFFFFFF),
    border_focus: @color.Color::hex(0xFFFF00),
    text_primary: @color.Color::hex(0xFFFFFF),
    text_strong: @color.Color::hex(0xFFFFFF),
    text_body: @color.Color::hex(0xF0F0F0),
    text_secondary: @color.Color::hex(0xDDDDDD),
    text_muted: @color.Color::hex(0xAAAAAA),
    text_disabled: @color.Color::hex(0x777777),
    text_inverse: @color.Color::hex(0x000000),
    accent_primary: @color.Color::hex(0x00E5FF),
    accent_hover: @color.Color::hex(0x80F0FF),
    accent_pressed: @color.Color::hex(0x00B0FF),
    accent_deep: @color.Color::hex(0x0080FF),
    accent_soft: @color.Color::rgba(0, 229, 255, 80),
    accent_light: @color.Color::rgba(255, 255, 255, 220),
  }
}
