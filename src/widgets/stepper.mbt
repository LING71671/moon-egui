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
/// Formats a floating-point number into a string with specified decimal precision.
fn format_stepper_value(val : Double, precision : Int) -> String {
  if precision <= 0 {
    let rounded = if val >= 0.0 {
      (val + 0.5).to_int()
    } else {
      (val - 0.5).to_int()
    }
    rounded.to_string()
  } else if precision == 1 {
    let factor = 10.0
    let rounded = if val >= 0.0 {
      (val * factor + 0.5).to_int()
    } else {
      (val * factor - 0.5).to_int()
    }
    let whole = rounded / 10
    let frac = (rounded % 10).abs()
    let sign = if val < 0.0 && whole == 0 { "-" } else { "" }
    "\{sign}\{whole}.\{frac}"
  } else {
    let mut factor = 1.0
    for i = 0; i < precision; i = i + 1 {
      factor = factor * 10.0
    }
    let factor_int = factor.to_int()
    let rounded = if val >= 0.0 {
      (val * factor + 0.5).to_int()
    } else {
      (val * factor - 0.5).to_int()
    }
    let whole = rounded / factor_int
    let frac = (rounded % factor_int).abs()
    let mut frac_str = frac.to_string()
    while frac_str.length() < precision {
      frac_str = "0" + frac_str
    }
    let sign = if val < 0.0 && whole == 0 { "-" } else { "" }
    "\{sign}\{whole}.\{frac_str}"
  }
}

///|
/// Standalone numeric stepper widget supporting fluent configuration.
pub struct Stepper {
  id_salt : String
  value : Double
  step : Double
  min : Double?
  max : Double?
  precision : Int
  prefix : String
  suffix : String
  width : Double?
} derive(Eq, Debug)

///|
/// Creates a new Stepper widget with the given identifier and initial value.
pub fn Stepper::new(id_salt : String, value : Double) -> Stepper {
  {
    id_salt,
    value,
    step: 1.0,
    min: None,
    max: None,
    precision: 0,
    prefix: "",
    suffix: "",
    width: None,
  }
}

///|
/// Sets the step increment/decrement amount per step action.
pub fn Stepper::step(self : Stepper, step : Double) -> Stepper {
  { ..self, step: if step > 0.0 { step } else { 1.0 }, }
}

///|
/// Sets the lower bound minimum value.
pub fn Stepper::min(self : Stepper, min : Double) -> Stepper {
  { ..self, min: Some(min), }
}

///|
/// Sets the upper bound maximum value.
pub fn Stepper::max(self : Stepper, max : Double) -> Stepper {
  { ..self, max: Some(max), }
}

///|
/// Sets both minimum and maximum boundaries.
pub fn Stepper::range(self : Stepper, min : Double, max : Double) -> Stepper {
  { ..self, min: Some(min), max: Some(max), }
}

///|
/// Sets decimal precision for number formatting.
pub fn Stepper::precision(self : Stepper, precision : Int) -> Stepper {
  { ..self, precision: if precision < 0 { 0 } else { precision }, }
}

///|
/// Sets a display prefix string (e.g. "Width: ").
pub fn Stepper::prefix(self : Stepper, prefix : String) -> Stepper {
  { ..self, prefix, }
}

///|
/// Sets a display suffix string (e.g. " px", " dB").
pub fn Stepper::suffix(self : Stepper, suffix : String) -> Stepper {
  { ..self, suffix, }
}

///|
/// Overrides the default width of the stepper component.
pub fn Stepper::width(self : Stepper, width : Double) -> Stepper {
  { ..self, width: Some(width), }
}

///|
/// Reference-bound stepper widget for uniform `ui.add(...)` dispatch.
pub struct StepperRef {
  stepper : Stepper
  target : Ref[Double]
}

///|
/// Creates a Stepper bound directly to a `Ref[Double]`.
pub fn Stepper::from_ref(id_salt : String, target : Ref[Double]) -> StepperRef {
  { stepper: Stepper::new(id_salt, target.val), target, }
}

///|
pub fn StepperRef::step(self : StepperRef, step : Double) -> StepperRef {
  { ..self, stepper: self.stepper.step(step), }
}

///|
pub fn StepperRef::min(self : StepperRef, min : Double) -> StepperRef {
  { ..self, stepper: self.stepper.min(min), }
}

///|
pub fn StepperRef::max(self : StepperRef, max : Double) -> StepperRef {
  { ..self, stepper: self.stepper.max(max), }
}

///|
pub fn StepperRef::range(
  self : StepperRef,
  min : Double,
  max : Double,
) -> StepperRef {
  { ..self, stepper: self.stepper.range(min, max), }
}

///|
pub fn StepperRef::precision(self : StepperRef, precision : Int) -> StepperRef {
  { ..self, stepper: self.stepper.precision(precision), }
}

///|
pub fn StepperRef::prefix(self : StepperRef, prefix : String) -> StepperRef {
  { ..self, stepper: self.stepper.prefix(prefix), }
}

///|
pub fn StepperRef::suffix(self : StepperRef, suffix : String) -> StepperRef {
  { ..self, stepper: self.stepper.suffix(suffix), }
}

///|
pub fn StepperRef::width(self : StepperRef, width : Double) -> StepperRef {
  { ..self, stepper: self.stepper.width(width), }
}

///|
pub impl @core.Widget for StepperRef with fn ui(self, ctx : UIContext) -> Response {
  let (new_val, resp) = { ..self.stepper, value: self.target.val, }.show(ctx)
  self.target.val = new_val
  resp
}

///|
/// Renders the stepper widget, handles mouse clicks, wheel, keyboard inputs,
/// and returns the updated numeric value and interaction response.
pub fn Stepper::show(self : Stepper, ctx : UIContext) -> (Double, Response) {
  let scale = ctx.style.scale
  let h = (ctx.style.control_h_sm - ctx.style.radius_xs) * scale
  let radius = ctx.style.radius_sm * scale
  let font_sz = ctx.style.font_small * scale
  let default_w = 112.0 * scale
  let w = match self.width {
    Some(w_val) => w_val * scale
    None => default_w
  }
  let btn_w = h

  ctx.push_id(self.id_salt)
  let (id, rect, resp) = ctx.allocate_space(@math.Vec2::new(w, h))
  ctx.pop_id()
  ctx.register_focusable(id)

  let is_focused = resp.has_focus() || ctx.has_focus(id)

  let btn_minus_rect = @math.Rect::new(rect.x, rect.y, btn_w, h)
  let btn_plus_rect = @math.Rect::new(rect.x + rect.w - btn_w, rect.y, btn_w, h)
  let val_rect = @math.Rect::new(
    rect.x + btn_w,
    rect.y,
    rect.w - 2.0 * btn_w,
    h,
  )

  let minus_hovered = ctx.is_hovered(btn_minus_rect)
  let plus_hovered = ctx.is_hovered(btn_plus_rect)
  let val_hovered = ctx.is_hovered(val_rect)

  // Cursor contract
  if resp.hovered {
    if minus_hovered || plus_hovered {
      ctx.set_cursor_icon("pointer")
    } else if val_hovered {
      ctx.set_cursor_icon("ew-resize")
    } else {
      ctx.set_cursor_icon("pointer")
    }
  }

  // Modifiers: Shift = 10x, Ctrl/Meta = 0.1x
  let multiplier = if ctx.input.modifiers.shift {
    10.0
  } else if ctx.input.modifiers.ctrl || ctx.input.modifiers.meta {
    0.1
  } else {
    1.0
  }
  let effective_step = self.step * multiplier

  let mut new_val = if self.value.is_nan() {
    match self.min {
      Some(min_v) => min_v
      None => 0.0
    }
  } else {
    self.value
  }

  // 1. Mouse Click on Buttons
  if resp.clicked {
    if minus_hovered {
      new_val = new_val - effective_step
    } else if plus_hovered {
      new_val = new_val + effective_step
    }
  }

  // 2. Mouse Wheel when hovered over stepper
  if resp.hovered && ctx.input.scroll_delta.y != 0.0 {
    if ctx.input.scroll_delta.y > 0.0 {
      new_val = new_val - effective_step
    } else {
      new_val = new_val + effective_step
    }
  }

  // 3. Keyboard navigation when focused
  if is_focused {
    if ctx.input.key_pressed(Key::ArrowLeft) ||
      ctx.input.key_pressed(Key::ArrowDown) {
      new_val = new_val - effective_step
      ctx.input.consume_key(Key::ArrowLeft)
      ctx.input.consume_key(Key::ArrowDown)
    }
    if ctx.input.key_pressed(Key::ArrowRight) ||
      ctx.input.key_pressed(Key::ArrowUp) {
      new_val = new_val + effective_step
      ctx.input.consume_key(Key::ArrowRight)
      ctx.input.consume_key(Key::ArrowUp)
    }
    if ctx.input.key_pressed(Key::Home) {
      match self.min {
        Some(min_v) => new_val = min_v
        None => ()
      }
      ctx.input.consume_key(Key::Home)
    }
    if ctx.input.key_pressed(Key::End) {
      match self.max {
        Some(max_v) => new_val = max_v
        None => ()
      }
      ctx.input.consume_key(Key::End)
    }
    let page_step = effective_step * 10.0
    if ctx.input.key_pressed(Key::PageUp) {
      new_val = new_val + page_step
      ctx.input.consume_key(Key::PageUp)
    }
    if ctx.input.key_pressed(Key::PageDown) {
      new_val = new_val - page_step
      ctx.input.consume_key(Key::PageDown)
    }
  }

  // 4. Bounds Clamping
  match self.min {
    Some(min_v) => if new_val < min_v { new_val = min_v }
    None => ()
  }
  match self.max {
    Some(max_v) => if new_val > max_v { new_val = max_v }
    None => ()
  }

  // 5. Drawing (Painter)
  // Background for the entire stepper
  let base_bg = if resp.hovered {
    @color.Color::bg_window()
  } else {
    @color.Color::bg_surface()
  }
  ctx.painter().add_rect(rect, base_bg, radius)

  // Minus button background
  let minus_bg = if minus_hovered && ctx.input.mouse_down {
    @color.Color::bg_active()
  } else if minus_hovered {
    @color.Color::bg_subtle()
  } else {
    @color.Color::bg_surface()
  }
  ctx.painter().add_rect(btn_minus_rect, minus_bg, radius)

  // Plus button background
  let plus_bg = if plus_hovered && ctx.input.mouse_down {
    @color.Color::bg_active()
  } else if plus_hovered {
    @color.Color::bg_subtle()
  } else {
    @color.Color::bg_surface()
  }
  ctx.painter().add_rect(btn_plus_rect, plus_bg, radius)

  // Vertical divider lines
  let sep_color = @color.Color::border_muted()
  let line_w = 1.0 * scale
  ctx
  .painter()
  .add_line(
    @math.Vec2::new(rect.x + btn_w, rect.y + 2.0 * scale),
    @math.Vec2::new(rect.x + btn_w, rect.y + h - 2.0 * scale),
    sep_color,
    line_w,
  )
  ctx
  .painter()
  .add_line(
    @math.Vec2::new(rect.x + rect.w - btn_w, rect.y + 2.0 * scale),
    @math.Vec2::new(rect.x + rect.w - btn_w, rect.y + h - 2.0 * scale),
    sep_color,
    line_w,
  )

  // Outer border stroke
  let border_color = if is_focused {
    @color.Color::border_focus()
  } else if resp.hovered {
    @color.Color::accent_primary()
  } else {
    @color.Color::border_default()
  }
  ctx.painter().add_rect_stroke(rect, border_color, 1.0 * scale, radius)

  // Focus Ring
  if is_focused {
    ctx
    .painter()
    .add_rect_stroke(
      rect.expand(2.0 * scale),
      @color.Color::border_focus(),
      1.5 * scale,
      radius + 2.0 * scale,
    )
  }

  // Draw Minus icon (-)
  let icon_color = if minus_hovered {
    @color.Color::accent_primary()
  } else {
    @color.Color::text_secondary()
  }
  let minus_center = @math.Vec2::new(
    btn_minus_rect.x + btn_w * 0.5,
    btn_minus_rect.y + h * 0.5,
  )
  let icon_half_w = 4.0 * scale
  ctx
  .painter()
  .add_line(
    @math.Vec2::new(minus_center.x - icon_half_w, minus_center.y),
    @math.Vec2::new(minus_center.x + icon_half_w, minus_center.y),
    icon_color,
    1.5 * scale,
  )

  // Draw Plus icon (+)
  let plus_icon_color = if plus_hovered {
    @color.Color::accent_primary()
  } else {
    @color.Color::text_secondary()
  }
  let plus_center = @math.Vec2::new(
    btn_plus_rect.x + btn_w * 0.5,
    btn_plus_rect.y + h * 0.5,
  )
  ctx
  .painter()
  .add_line(
    @math.Vec2::new(plus_center.x - icon_half_w, plus_center.y),
    @math.Vec2::new(plus_center.x + icon_half_w, plus_center.y),
    plus_icon_color,
    1.5 * scale,
  )
  ctx
  .painter()
  .add_line(
    @math.Vec2::new(plus_center.x, plus_center.y - icon_half_w),
    @math.Vec2::new(plus_center.x, plus_center.y + icon_half_w),
    plus_icon_color,
    1.5 * scale,
  )

  // Format and draw Value Text
  let formatted_val = format_stepper_value(new_val, self.precision)
  let display_text = self.prefix + formatted_val + self.suffix
  let text_sz = ctx.measure_text(display_text, font_sz)
  let text_pos = @math.Vec2::new(
    val_rect.x + (val_rect.w - text_sz.x) * 0.5,
    val_rect.y + (val_rect.h - font_sz) * 0.5,
  )
  let text_color = if is_focused {
    @color.Color::accent_primary()
  } else {
    @color.Color::text_primary()
  }
  ctx.painter().add_text(text_pos, display_text, font_sz, text_color)

  (new_val, resp)
}

///|
/// Convenience functional helper to render a stepper widget.
pub fn stepper(
  ctx : UIContext,
  id_salt : String,
  value : Double,
  step? : Double = 1.0,
  min? : Double,
  max? : Double,
  precision? : Int = 0,
  prefix? : String = "",
  suffix? : String = "",
  width? : Double,
) -> (Double, Response) {
  let mut s = Stepper::new(id_salt, value)
    .step(step)
    .precision(precision)
    .prefix(prefix)
    .suffix(suffix)
  if min is Some(m) {
    s = s.min(m)
  }
  if max is Some(m) {
    s = s.max(m)
  }
  if width is Some(w) {
    s = s.width(w)
  }
  s.show(ctx)
}
