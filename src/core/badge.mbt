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
/// Semantic palette category for badges and tags.
pub(all) enum BadgeKind {
  Default
  Success
  Warning
  Danger
  Info
} derive(Eq, Debug)

///|
pub fn BadgeKind::default() -> BadgeKind {
  Default
}

///|
pub fn BadgeKind::success() -> BadgeKind {
  Success
}

///|
pub fn BadgeKind::warning() -> BadgeKind {
  Warning
}

///|
pub fn BadgeKind::danger() -> BadgeKind {
  Danger
}

///|
pub fn BadgeKind::info() -> BadgeKind {
  Info
}

///|
fn badge_colors(kind : BadgeKind) -> (@color.Color, @color.Color, @color.Color) {
  match kind {
    Default =>
      (
        @color.Color::bg_subtle(),
        @color.Color::border_default(),
        @color.Color::text_secondary(),
      )
    Success =>
      (
        @color.Color::badge_success_bg(),
        @color.Color::badge_success_border(),
        @color.Color::badge_success_text(),
      )
    Warning =>
      (
        @color.Color::badge_warning_bg(),
        @color.Color::badge_warning_border(),
        @color.Color::badge_warning_text(),
      )
    Danger =>
      (
        @color.Color::badge_danger_bg(),
        @color.Color::badge_danger_border(),
        @color.Color::badge_danger_text(),
      )
    Info =>
      (
        @color.Color::badge_info_bg(),
        @color.Color::badge_info_border(),
        @color.Color::badge_info_text(),
      )
  }
}

///|
/// Render a compact semantic status badge capsule with optional breathing status dot
/// and pill-shaped fully rounded borders.
pub fn UIContext::badge(
  self : UIContext,
  text : String,
  kind? : BadgeKind = Default,
  dot? : Bool = false,
  pill? : Bool = false,
) -> Response {
  let font_sz = self.style.font_small
  let text_sz = self.measure_text(text, font_sz)

  let dot_w = if dot { 12.0 } else { 0.0 }
  let pad_x = 8.0
  let h = 22.0
  let w = pad_x * 2.0 + dot_w + text_sz.x

  let (_id, rect, resp) = self.allocate_space(@math.Vec2::new(w, h))
  let radius = if pill { h * 0.5 } else { 4.0 }

  let (bg, border, fg) = badge_colors(kind)

  self.draw_list.add_rect(rect, bg, radius)
  self.draw_list.add_rect_stroke(rect, border, 1.0, radius)

  let mut current_x = rect.x + pad_x

  // Status dot
  if dot {
    let dot_center = @math.Vec2::new(current_x + 3.0, rect.y + h * 0.5)
    self.draw_list.add_circle(dot_center, 3.0, fg)
    current_x = current_x + dot_w
  }

  // Text
  let text_y = rect.y + (h - font_sz) * 0.5
  self.draw_list.add_text(@math.Vec2::new(current_x, text_y), text, font_sz, fg)

  resp
}

///|
/// Render an interactive tag chip with optional close button (returning true when clicked).
pub fn UIContext::tag(
  self : UIContext,
  id_salt : String,
  text : String,
  kind? : BadgeKind = Default,
  closable? : Bool = false,
) -> (Bool, Response) {
  let font_sz = self.style.font_small
  let text_sz = self.measure_text(text, font_sz)

  let close_w = if closable { 16.0 } else { 0.0 }
  let pad_x = 8.0
  let h = 24.0
  let w = pad_x * 2.0 + text_sz.x + close_w

  self.push_id(id_salt)
  let (_id, rect, resp) = self.allocate_space(@math.Vec2::new(w, h))
  self.pop_id()

  let (bg, border, fg) = badge_colors(kind)

  let tag_radius = self.style.radius_sm
  self.draw_list.add_rect(rect, bg, tag_radius)
  self.draw_list.add_rect_stroke(rect, border, 1.0, tag_radius)

  // Label text
  let text_y = rect.y + (h - font_sz) * 0.5
  self.draw_list.add_text(
    @math.Vec2::new(rect.x + pad_x, text_y),
    text,
    font_sz,
    fg,
  )

  let mut closed = false

  // Closable button
  if closable {
    let close_box = @math.Rect::new(
      rect.x + w - pad_x - 14.0,
      rect.y + (h - 14.0) * 0.5,
      14.0,
      14.0,
    )
    let is_close_hovered = close_box.contains(self.input.mouse_pos)
    if is_close_hovered {
      self.set_cursor_icon("pointer")
      self.draw_list.add_rect(
        close_box,
        @color.Color::tag_close_hover(),
        tag_radius,
      )
      if self.input.mouse_pressed {
        closed = true
      }
    }

    let x_center = close_box.center()
    let r = 3.5
    self.draw_list.add_line(
      @math.Vec2::new(x_center.x - r, x_center.y - r),
      @math.Vec2::new(x_center.x + r, x_center.y + r),
      fg,
      1.2,
    )
    self.draw_list.add_line(
      @math.Vec2::new(x_center.x - r, x_center.y + r),
      @math.Vec2::new(x_center.x + r, x_center.y - r),
      fg,
      1.2,
    )
  }

  (closed, resp)
}
