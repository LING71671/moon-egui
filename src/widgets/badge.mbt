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
/// Standalone semantic badge widget supporting fluent configuration.
pub struct Badge {
  text : String
  kind : BadgeKind
  dot : Bool
  pill : Bool
} derive(Eq, Debug)

///|
/// Create a new badge widget with default category.
pub fn Badge::new(text : String) -> Badge {
  { text, kind: Default, dot: false, pill: false, }
}

///|
/// Set the semantic category of the badge.
pub fn Badge::kind(self : Badge, kind : BadgeKind) -> Badge {
  { ..self, kind, }
}

///|
/// Enable or disable breathing status dot.
pub fn Badge::dot(self : Badge, dot : Bool) -> Badge {
  { ..self, dot, }
}

///|
/// Enable or disable pill capsule rounded corners.
pub fn Badge::pill(self : Badge, pill : Bool) -> Badge {
  { ..self, pill, }
}

///|
/// Render the badge into the provided UIContext.
pub impl @core.Widget for Badge with fn ui(self, ctx : UIContext) -> Response {
  badge(ctx, self.text, kind=self.kind, dot=self.dot, pill=self.pill)
}

///|
/// Render a compact semantic status badge capsule with optional breathing status dot
/// and pill-shaped fully rounded borders.
pub fn badge(
  ctx : UIContext,
  text : String,
  kind? : BadgeKind = Default,
  dot? : Bool = false,
  pill? : Bool = false,
) -> Response {
  let scale = ctx.style.scale
  let font_sz = ctx.style.font_small * scale
  let text_sz = ctx.measure_text(text, font_sz)

  let dot_w = if dot { ctx.style.spacing_md * scale } else { 0.0 }
  let pad_x = ctx.style.spacing_sm * scale
  let h = (ctx.style.control_h_sm - ctx.style.radius_xs) * scale
  let w = pad_x * 2.0 + dot_w + text_sz.x

  let (_id, rect, resp) = ctx.allocate_space(@math.Vec2::new(w, h))
  let radius = if pill { h * 0.5 } else { ctx.style.radius_sm * scale }

  let (bg, border, fg) = badge_colors(kind)

  let p = ctx.painter()
  p.add_rect(rect, bg, radius)
  p.add_rect_stroke(rect, border, 1.0, radius)

  let mut current_x = rect.x + pad_x

  // Status dot
  if dot {
    let dot_r = 3.0 * scale
    let dot_center = @math.Vec2::new(current_x + dot_r, rect.y + h * 0.5)
    p.add_circle(dot_center, dot_r, fg)
    current_x = current_x + dot_w
  }

  // Text
  let text_y = rect.y + (h - font_sz) * 0.5
  p.add_text(@math.Vec2::new(current_x, text_y), text, font_sz, fg)

  resp
}

///|
/// Render an interactive tag chip with optional close button (returning true when clicked).
pub fn tag(
  ctx : UIContext,
  id_salt : String,
  text : String,
  kind? : BadgeKind = Default,
  closable? : Bool = false,
) -> (Bool, Response) {
  let font_sz = ctx.style.font_small
  let text_sz = ctx.measure_text(text, font_sz)

  let close_w = if closable { 16.0 } else { 0.0 }
  let pad_x = 8.0
  let h = 24.0
  let w = pad_x * 2.0 + text_sz.x + close_w

  ctx.push_id(id_salt)
  let (id, rect, resp) = ctx.allocate_space(@math.Vec2::new(w, h))
  ctx.pop_id()
  ctx.register_focusable(id)
  let is_focused = resp.has_focus() || ctx.has_focus(id)

  let (bg, border, fg) = badge_colors(kind)

  let tag_radius = ctx.style.radius_sm
  let p = ctx.painter()
  p.add_rect(rect, bg, tag_radius)
  p.add_rect_stroke(
    rect,
    if is_focused {
      @color.Color::border_focus()
    } else {
      border
    },
    if is_focused {
      1.5
    } else {
      1.0
    },
    tag_radius,
  )

  // Label text
  let text_y = rect.y + (h - font_sz) * 0.5
  p.add_text(@math.Vec2::new(rect.x + pad_x, text_y), text, font_sz, fg)

  let mut closed = false

  // Closable button
  if closable {
    let close_box = @math.Rect::new(
      rect.x + w - pad_x - 14.0,
      rect.y + (h - 14.0) * 0.5,
      14.0,
      14.0,
    )
    let is_close_hovered = ctx.is_hovered(close_box)
    if is_close_hovered {
      ctx.set_cursor_icon("pointer")
      p.add_rect(close_box, @color.Color::tag_close_hover(), tag_radius)
      if ctx.input.mouse_pressed {
        closed = true
      }
    }

    // Keyboard close while the tag holds focus
    if is_focused &&
      (ctx.input.key_pressed(Key::Space) || ctx.input.key_pressed(Key::Enter)) {
      ctx.input.consume_key(Key::Space)
      ctx.input.consume_key(Key::Enter)
      closed = true
    }
    let x_center = close_box.center()
    let r = 3.5
    p.add_line(
      @math.Vec2::new(x_center.x - r, x_center.y - r),
      @math.Vec2::new(x_center.x + r, x_center.y + r),
      fg,
      1.2,
    )
    p.add_line(
      @math.Vec2::new(x_center.x - r, x_center.y + r),
      @math.Vec2::new(x_center.x + r, x_center.y - r),
      fg,
      1.2,
    )
  }

  (closed, resp)
}
