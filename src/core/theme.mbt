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
  }
}
