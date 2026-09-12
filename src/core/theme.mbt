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
/// Comprehensive UI metrics, typography, and sizing tokens.
pub struct WidgetStyle {
  scale : Double
  button_h : Double
  button_pad_x : Double
  button_radius : Double
  button_min_w : Double
  text_edit_h : Double
  text_edit_pad_x : Double
  text_edit_radius : Double
  caret_h : Double
  slider_h : Double
  slider_track_w : Double
  slider_track_h : Double
  slider_thumb_r : Double
  toggle_w : Double
  toggle_h : Double
  toggle_thumb_r : Double
  knob_r : Double
  code_editor_line_h : Double
  code_editor_gutter_w : Double
  font_normal : Double
  font_small : Double
  font_large : Double
  item_spacing : @math.Vec2
  radius_sm : Double
  radius_md : Double
  radius_lg : Double
  radius_xl : Double
  segmented_h : Double
  segmented_pad : Double
  segmented_radius : Double
  segmented_pill_radius : Double
  segmented_item_pad_x : Double
  dialog_w : Double
  dialog_min_h : Double
  dialog_radius : Double
  dialog_btn_w : Double
  code_editor_font_size : Double
  code_editor_gutter_font_size : Double
  code_editor_radius : Double
  command_palette_w : Double
  command_palette_radius : Double
  command_palette_row_h : Double
  command_palette_header_h : Double
  command_palette_footer_h : Double
  toast_radius : Double
  table_header_h : Double
  table_row_h : Double
  table_radius : Double
  tree_view_row_h : Double
  tree_view_radius : Double
  rich_text_line_h : Double
  checkbox_size : Double
  checkbox_gap : Double
  checkbox_h : Double
  checkbox_radius : Double
  radio_r : Double
  radio_gap : Double
  radio_h : Double
  badge_dot_w : Double
  badge_pad_x : Double
  badge_h : Double
  badge_radius : Double
  menu_bar_h : Double
  menu_bar_btn_h : Double
  menu_bar_popup_w : Double
  menu_bar_radius : Double
} derive(Eq, Debug)

///|
/// Returns the standard Studio Light porcelain widget style.
pub fn WidgetStyle::default() -> WidgetStyle {
  {
    scale: 1.0,
    button_h: 32.0,
    button_pad_x: 14.0,
    button_radius: 6.0,
    button_min_w: 68.0,
    text_edit_h: 32.0,
    text_edit_pad_x: 10.0,
    text_edit_radius: 5.0,
    caret_h: 16.0,
    slider_h: 24.0,
    slider_track_w: 120.0,
    slider_track_h: 4.0,
    slider_thumb_r: 7.0,
    toggle_w: 36.0,
    toggle_h: 20.0,
    toggle_thumb_r: 8.0,
    knob_r: 20.0,
    code_editor_line_h: 20.0,
    code_editor_gutter_w: 44.0,
    font_normal: 13.0,
    font_small: 11.0,
    font_large: 15.0,
    item_spacing: @math.Vec2::new(8.0, 8.0),
    radius_sm: 4.0,
    radius_md: 6.0,
    radius_lg: 10.0,
    radius_xl: 12.0,
    segmented_h: 34.0,
    segmented_pad: 3.0,
    segmented_radius: 7.0,
    segmented_pill_radius: 5.0,
    segmented_item_pad_x: 12.0,
    dialog_w: 380.0,
    dialog_min_h: 160.0,
    dialog_radius: 12.0,
    dialog_btn_w: 80.0,
    code_editor_font_size: 12.5,
    code_editor_gutter_font_size: 11.0,
    code_editor_radius: 6.0,
    command_palette_w: 540.0,
    command_palette_radius: 8.0,
    command_palette_row_h: 32.0,
    command_palette_header_h: 46.0,
    command_palette_footer_h: 28.0,
    toast_radius: 7.0,
    table_header_h: 32.0,
    table_row_h: 30.0,
    table_radius: 6.0,
    tree_view_row_h: 26.0,
    tree_view_radius: 6.0,
    rich_text_line_h: 22.0,
    checkbox_size: 18.0,
    checkbox_gap: 8.0,
    checkbox_h: 22.0,
    checkbox_radius: 4.0,
    radio_r: 7.0,
    radio_gap: 8.0,
    radio_h: 22.0,
    badge_dot_w: 12.0,
    badge_pad_x: 8.0,
    badge_h: 22.0,
    badge_radius: 4.0,
    menu_bar_h: 28.0,
    menu_bar_btn_h: 22.0,
    menu_bar_popup_w: 170.0,
    menu_bar_radius: 4.0,
  }
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
