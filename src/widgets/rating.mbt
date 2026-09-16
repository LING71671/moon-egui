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
/// Standalone Star Rating widget supporting fractional ratings, live hover preview,
/// and keyboard navigation.
pub struct Rating {
  id_salt : String
  value : Double
  max_stars : Int
  allow_half : Bool
  read_only : Bool
  star_size : Double?
  spacing : Double?
} derive(Eq, Debug)

///|
/// Creates a new Rating widget with the given identifier and initial score.
pub fn Rating::new(id_salt : String, value : Double) -> Rating {
  {
    id_salt,
    value,
    max_stars: 5,
    allow_half: true,
    read_only: false,
    star_size: None,
    spacing: None,
  }
}

///|
/// Sets maximum number of stars (e.g. 5 or 10).
pub fn Rating::max_stars(self : Rating, max_stars : Int) -> Rating {
  { ..self, max_stars: if max_stars > 0 { max_stars } else { 5 }, }
}

///|
/// Configures whether half-star (0.5) fractional ratings are allowed.
pub fn Rating::allow_half(self : Rating, allow_half : Bool) -> Rating {
  { ..self, allow_half, }
}

///|
/// Configures whether the rating is read-only (display only).
pub fn Rating::read_only(self : Rating, read_only : Bool) -> Rating {
  { ..self, read_only, }
}

///|
/// Sets custom star glyph size.
pub fn Rating::star_size(self : Rating, star_size : Double) -> Rating {
  { ..self, star_size: Some(star_size), }
}

///|
/// Sets horizontal spacing between star glyphs.
pub fn Rating::spacing(self : Rating, spacing : Double) -> Rating {
  { ..self, spacing: Some(spacing), }
}

///|
/// Reference-bound Rating widget for uniform `ui.add(...)` dispatch.
pub struct RatingRef {
  rating : Rating
  target : Ref[Double]
}

///|
/// Creates a Rating widget bound directly to a `Ref[Double]`.
pub fn Rating::from_ref(id_salt : String, target : Ref[Double]) -> RatingRef {
  { rating: Rating::new(id_salt, target.val), target, }
}

///|
pub fn RatingRef::max_stars(self : RatingRef, max_stars : Int) -> RatingRef {
  { ..self, rating: self.rating.max_stars(max_stars), }
}

///|
pub fn RatingRef::allow_half(self : RatingRef, allow_half : Bool) -> RatingRef {
  { ..self, rating: self.rating.allow_half(allow_half), }
}

///|
pub fn RatingRef::read_only(self : RatingRef, read_only : Bool) -> RatingRef {
  { ..self, rating: self.rating.read_only(read_only), }
}

///|
pub fn RatingRef::star_size(self : RatingRef, star_size : Double) -> RatingRef {
  { ..self, rating: self.rating.star_size(star_size), }
}

///|
pub fn RatingRef::spacing(self : RatingRef, spacing : Double) -> RatingRef {
  { ..self, rating: self.rating.spacing(spacing), }
}

///|
pub impl @core.Widget for RatingRef with fn ui(self, ctx : UIContext) -> Response {
  let (new_val, resp) = { ..self.rating, value: self.target.val, }.show(ctx)
  self.target.val = new_val
  resp
}

///|
/// Renders the rating widget, handles hover preview, mouse clicks, keyboard adjustments,
/// and returns the current score and interaction response.
pub fn Rating::show(self : Rating, ctx : UIContext) -> (Double, Response) {
  let scale = ctx.style.scale
  let star_sz = match self.star_size {
    Some(sz) => sz * scale
    None => 18.0 * scale
  }
  let spacing = match self.spacing {
    Some(sp) => sp * scale
    None => 4.0 * scale
  }
  let max_stars = if self.max_stars > 0 { self.max_stars } else { 5 }
  let total_w = max_stars.to_double() * star_sz +
    (max_stars - 1).to_double() * spacing
  let h = star_sz + 4.0 * scale

  ctx.push_id(self.id_salt)
  let (id, rect, resp) = ctx.allocate_space(@math.Vec2::new(total_w, h))
  ctx.pop_id()

  if !self.read_only {
    ctx.register_focusable(id)
    if resp.hovered {
      ctx.set_cursor_icon("pointer")
    }
  }

  let is_focused = !self.read_only && (resp.has_focus() || ctx.has_focus(id))

  let mut new_val = self.value
  let mut display_val = self.value

  // 1. Mouse Hover and Click Evaluation
  if !self.read_only && resp.hovered {
    let mouse_x = ctx.input.mouse_pos.x
    let rel_x = mouse_x - rect.x
    if rel_x < 0.0 {
      display_val = 0.0
    } else {
      let star_idx = (rel_x / (star_sz + spacing)).to_int()
      if star_idx >= max_stars {
        display_val = max_stars.to_double()
      } else {
        let star_start_x = rect.x + star_idx.to_double() * (star_sz + spacing)
        let inside_x = mouse_x - star_start_x
        if inside_x <= 0.0 {
          display_val = star_idx.to_double()
        } else if inside_x >= star_sz {
          display_val = (star_idx + 1).to_double()
        } else if self.allow_half && inside_x < star_sz * 0.5 {
          display_val = star_idx.to_double() + 0.5
        } else {
          display_val = (star_idx + 1).to_double()
        }
      }
    }

    if resp.clicked {
      new_val = display_val
    }
  }

  // 2. Keyboard Navigation when focused
  if is_focused {
    let step = if self.allow_half { 0.5 } else { 1.0 }
    if ctx.input.key_pressed(Key::ArrowLeft) ||
      ctx.input.key_pressed(Key::ArrowDown) {
      new_val = new_val - step
      ctx.input.consume_key(Key::ArrowLeft)
      ctx.input.consume_key(Key::ArrowDown)
      display_val = new_val
    }
    if ctx.input.key_pressed(Key::ArrowRight) ||
      ctx.input.key_pressed(Key::ArrowUp) {
      new_val = new_val + step
      ctx.input.consume_key(Key::ArrowRight)
      ctx.input.consume_key(Key::ArrowUp)
      display_val = new_val
    }
    if ctx.input.key_pressed(Key::Home) {
      new_val = 0.0
      ctx.input.consume_key(Key::Home)
      display_val = new_val
    }
    if ctx.input.key_pressed(Key::End) {
      new_val = max_stars.to_double()
      ctx.input.consume_key(Key::End)
      display_val = new_val
    }
  }

  // 3. Bounds Clamping
  if new_val < 0.0 {
    new_val = 0.0
  }
  if new_val > max_stars.to_double() {
    new_val = max_stars.to_double()
  }
  if display_val < 0.0 {
    display_val = 0.0
  }
  if display_val > max_stars.to_double() {
    display_val = max_stars.to_double()
  }

  // 4. Focus Ring
  if is_focused {
    let radius = ctx.style.radius_sm * scale
    ctx
    .painter()
    .add_rect_stroke(
      rect.expand(2.0 * scale),
      @color.Color::border_focus(),
      1.5,
      radius + 2.0 * scale,
    )
  }

  // 5. Star Glyphs Drawing
  let empty_color = @color.Color::border_default()
  let active_color = @color.Color::warning()

  for i = 0; i < max_stars; i = i + 1 {
    let star_x = rect.x + i.to_double() * (star_sz + spacing)
    let star_y = rect.y + (h - star_sz) * 0.5
    let star_pos = @math.Vec2::new(star_x, star_y)

    let threshold = (i + 1).to_double()
    let half_threshold = i.to_double() + 0.5

    if display_val >= threshold {
      // Fully active star
      ctx.painter().add_text(star_pos, "★", star_sz, active_color)
    } else if display_val >= half_threshold {
      // Half active star: draw base star, clip left half, draw active star
      ctx.painter().add_text(star_pos, "★", star_sz, empty_color)
      let half_clip = @math.Rect::new(star_x, star_y, star_sz * 0.5, star_sz)
      ctx.painter().push_clip(half_clip)
      ctx.painter().add_text(star_pos, "★", star_sz, active_color)
      ctx.painter().pop_clip()
    } else {
      // Inactive star
      ctx.painter().add_text(star_pos, "★", star_sz, empty_color)
    }
  }

  (new_val, resp)
}

///|
/// Convenience functional helper to render a rating widget.
pub fn rating(
  ctx : UIContext,
  id_salt : String,
  value : Double,
  max_stars? : Int = 5,
  allow_half? : Bool = true,
  read_only? : Bool = false,
  star_size? : Double,
  spacing? : Double,
) -> (Double, Response) {
  let mut r = Rating::new(id_salt, value)
    .max_stars(max_stars)
    .allow_half(allow_half)
    .read_only(read_only)
  if star_size is Some(sz) {
    r = r.star_size(sz)
  }
  if spacing is Some(sp) {
    r = r.spacing(sp)
  }
  r.show(ctx)
}
