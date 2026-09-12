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
/// Component style descriptor for vertical fader channel controls.
pub struct FaderStyle {
  width : Double
  height : Double
  track_w : Double
  cap_w : Double
  cap_h : Double
  cap_radius : Double
} derive(Eq, Debug)

///|
pub fn FaderStyle::default() -> FaderStyle {
  {
    width: 44.0,
    height: 150.0,
    track_w: 6.0,
    cap_w: 32.0,
    cap_h: 20.0,
    cap_radius: 3.0,
  }
}

///|
/// Standalone vertical audio channel fader parameter controller supporting fluent configuration.
pub struct Fader {
  id_salt : String
  label : String
  value : Double
  min_val : Double
  max_val : Double
  step : Double
  default_val : Double
  unit : String
  show_ticks : Bool
  size : @math.Vec2?
} derive(Eq, Debug)

///|
/// Create a new vertical fader widget with standard defaults.
pub fn Fader::new(id_salt : String, label : String, value : Double) -> Fader {
  {
    id_salt,
    label,
    value,
    min_val: 0.0,
    max_val: 1.0,
    step: 0.01,
    default_val: 0.0,
    unit: "",
    show_ticks: true,
    size: None,
  }
}

///|
/// Set minimum parameter value.
pub fn Fader::min(self : Fader, min_val : Double) -> Fader {
  { ..self, min_val, }
}

///|
/// Set maximum parameter value.
pub fn Fader::max(self : Fader, max_val : Double) -> Fader {
  { ..self, max_val, }
}

///|
/// Set step increment.
pub fn Fader::step(self : Fader, step : Double) -> Fader {
  { ..self, step, }
}

///|
/// Set default reset value (triggered on Alt+Click).
pub fn Fader::default_val(self : Fader, default_val : Double) -> Fader {
  { ..self, default_val, }
}

///|
/// Set display unit suffix (e.g. "dB", "Hz", "%").
pub fn Fader::unit(self : Fader, unit : String) -> Fader {
  { ..self, unit, }
}

///|
/// Toggle calibrated scale tick marks.
pub fn Fader::show_ticks(self : Fader, show_ticks : Bool) -> Fader {
  { ..self, show_ticks, }
}

///|
/// Override layout dimensions.
pub fn Fader::size(self : Fader, size : @math.Vec2) -> Fader {
  { ..self, size: Some(size), }
}

///|
/// Reference-bound fader widget for uniform `ui.add(...)` dispatch.
pub struct FaderRef {
  fader : Fader
  target : Ref[Double]
}

///|
/// Create a vertical fader bound directly to a `Ref[Double]`.
pub fn Fader::from_ref(
  id_salt : String,
  label : String,
  target : Ref[Double],
) -> FaderRef {
  { fader: Fader::new(id_salt, label, target.val), target, }
}

///|
pub fn FaderRef::min(self : FaderRef, min_val : Double) -> FaderRef {
  { ..self, fader: self.fader.min(min_val), }
}

///|
pub fn FaderRef::max(self : FaderRef, max_val : Double) -> FaderRef {
  { ..self, fader: self.fader.max(max_val), }
}

///|
pub fn FaderRef::step(self : FaderRef, step : Double) -> FaderRef {
  { ..self, fader: self.fader.step(step), }
}

///|
pub fn FaderRef::default_val(self : FaderRef, default_val : Double) -> FaderRef {
  { ..self, fader: self.fader.default_val(default_val), }
}

///|
pub fn FaderRef::unit(self : FaderRef, unit : String) -> FaderRef {
  { ..self, fader: self.fader.unit(unit), }
}

///|
pub fn FaderRef::show_ticks(self : FaderRef, show_ticks : Bool) -> FaderRef {
  { ..self, fader: self.fader.show_ticks(show_ticks), }
}

///|
pub fn FaderRef::size(self : FaderRef, size : @math.Vec2) -> FaderRef {
  { ..self, fader: self.fader.size(size), }
}

///|
pub impl Widget for FaderRef with fn ui(self, ctx : UIContext) -> Response {
  let (new_val, resp) = { ..self.fader, value: self.target.val, }.show(ctx)
  self.target.val = new_val
  resp
}

///|
/// Render the fader and return the updated value alongside the interaction response.
pub fn Fader::show(self : Fader, ctx : UIContext) -> (Double, Response) {
  let scale = ctx.style.scale
  let font_nm = ctx.style.font_normal * scale
  let font_sm = ctx.style.font_small * scale
  let f_style = FaderStyle::default()
  let total_w = match self.size {
    Some(s) => s.x
    None => f_style.width * scale
  }
  let total_h = match self.size {
    Some(s) => s.y
    None => f_style.height * scale
  }
  let track_w = f_style.track_w * scale
  let cap_w = f_style.cap_w * scale
  let cap_h = f_style.cap_h * scale
  let cap_radius = f_style.cap_radius * scale

  let min_val = self.min_val
  let max_val = self.max_val
  let step = self.step
  let default_val = self.default_val
  let unit = self.unit
  let show_ticks = self.show_ticks
  let label = self.label
  let value = self.value

  let range = if max_val > min_val { max_val - min_val } else { 1.0 }
  let clamped_initial = if value < min_val {
    min_val
  } else if value > max_val {
    max_val
  } else {
    value
  }

  ctx.push_id(self.id_salt)
  let (id, rect, response) = ctx.allocate_space(
    @math.Vec2::new(total_w, total_h),
  )
  ctx.pop_id()

  ctx.register_focusable(id)
  if response.pressed() || response.clicked() {
    ctx.request_focus(id)
  }
  if response.hovered() || response.dragged() || response.pressed() {
    ctx.set_cursor_icon("ns-resize")
  }
  let is_focused = ctx.has_focus(id) || response.has_focus()

  let label_h = if label.length() > 0 { font_nm + 6.0 * scale } else { 0.0 }
  let readout_h = font_sm + 6.0 * scale

  let track_top_y = rect.y + label_h + cap_h * 0.5
  let track_bottom_y = rect.y + total_h - readout_h - cap_h * 0.5
  let track_travel_h = if track_bottom_y > track_top_y {
    track_bottom_y - track_top_y
  } else {
    1.0
  }
  let center_x = rect.x + total_w * 0.5

  let mut current_val = clamped_initial

  // 1. Mouse Drag (Vertical motion: upward drag increases value, downward decreases)
  if !ctx.input.modifiers.alt &&
    (response.dragged() || (response.pressed() && ctx.input.mouse_down)) {
    let dy = -ctx.input.mouse_delta.y
    let sensitivity = if ctx.input.modifiers.shift {
      0.1
    } else if ctx.input.modifiers.ctrl {
      10.0
    } else {
      1.0
    }
    let delta = dy / track_travel_h * range * sensitivity
    current_val = current_val + delta
  }

  // 2. Mouse Scroll Wheel
  if response.hovered() && ctx.input.scroll_delta.y.abs() > 0.0 {
    let dir = if ctx.input.scroll_delta.y > 0.0 { 1.0 } else { -1.0 }
    let multiplier = if ctx.input.modifiers.shift { 0.1 } else { 1.0 }
    current_val = current_val + dir * step * multiplier
  }

  // 3. Keyboard Navigation when focused
  if is_focused {
    let key_step = if ctx.input.modifiers.shift {
      step * 0.1
    } else if ctx.input.modifiers.ctrl {
      step * 10.0
    } else {
      step
    }
    if ctx.input.key_pressed(Key::ArrowUp) ||
      ctx.input.key_pressed(Key::ArrowRight) {
      current_val = current_val + key_step
      ctx.input.consume_key(Key::ArrowUp)
      ctx.input.consume_key(Key::ArrowRight)
    }
    if ctx.input.key_pressed(Key::ArrowDown) ||
      ctx.input.key_pressed(Key::ArrowLeft) {
      current_val = current_val - key_step
      ctx.input.consume_key(Key::ArrowDown)
      ctx.input.consume_key(Key::ArrowLeft)
    }
    if ctx.input.key_pressed(Key::Home) {
      current_val = max_val
      ctx.input.consume_key(Key::Home)
    }
    if ctx.input.key_pressed(Key::End) {
      current_val = min_val
      ctx.input.consume_key(Key::End)
    }
  }

  // 4. Alt + Click or double click reset to default
  if response.clicked() && ctx.input.modifiers.alt {
    current_val = default_val
  }

  // Final value clamping
  if current_val < min_val {
    current_val = min_val
  } else if current_val > max_val {
    current_val = max_val
  }

  // --- Rendering ---
  let fraction = (current_val - min_val) / range
  let clamped_frac = if fraction < 0.0 {
    0.0
  } else if fraction > 1.0 {
    1.0
  } else {
    fraction
  }

  let cap_center_y = track_bottom_y - clamped_frac * track_travel_h

  // A. Top Label
  if label.length() > 0 {
    let label_sz = ctx.measure_text(label, font_nm)
    let label_x = center_x - label_sz.x * 0.5
    let label_y = rect.y
    ctx
    .painter()
    .add_text(
      @math.Vec2::new(label_x, label_y),
      label,
      font_nm,
      @color.Color::text_secondary(),
    )
  }

  // B. Calibrated Tick Marks (Left & Right)
  if show_ticks {
    let tick_count = 11
    let left_x = center_x - track_w * 0.5 - 4.0 * scale
    let right_x = center_x + track_w * 0.5 + 4.0 * scale
    for i = 0; i < tick_count; i = i + 1 {
      let t = i.to_double() / (tick_count - 1).to_double()
      let tick_y = track_bottom_y - t * track_travel_h
      let is_major = i == 0 || i == 5 || i == 10
      let tick_len = if is_major { 5.0 * scale } else { 3.0 * scale }
      let tick_col = if is_major {
        @color.Color::border_strong()
      } else {
        @color.Color::border_muted()
      }
      ctx
      .painter()
      .add_line(
        @math.Vec2::new(left_x - tick_len, tick_y),
        @math.Vec2::new(left_x, tick_y),
        tick_col,
        1.0,
      )
      ctx
      .painter()
      .add_line(
        @math.Vec2::new(right_x, tick_y),
        @math.Vec2::new(right_x + tick_len, tick_y),
        tick_col,
        1.0,
      )
    }
  }

  // C. Recessed Track Groove
  let track_x = center_x - track_w * 0.5
  let track_h_total = track_travel_h + cap_h
  let track_y = track_top_y - cap_h * 0.5
  let track_radius = 3.0 * scale

  // Track shadow/recess
  ctx
  .painter()
  .add_rect(
    @math.Rect::new(track_x, track_y, track_w, track_h_total),
    @color.Color::bg_surface(),
    track_radius,
  )
  ctx
  .painter()
  .add_rect_stroke(
    @math.Rect::new(track_x, track_y, track_w, track_h_total),
    @color.Color::border_muted(),
    1.0,
    track_radius,
  )

  // Track active fill from bottom up to cap
  let fill_h = track_bottom_y - cap_center_y
  if fill_h > 0.0 {
    let fill_y = cap_center_y
    ctx
    .painter()
    .add_rect(
      @math.Rect::new(
        track_x + 1.0 * scale,
        fill_y,
        track_w - 2.0 * scale,
        fill_h,
      ),
      @color.Color::accent_primary().with_alpha(160),
      2.0 * scale,
    )
  }

  // D. Fader Cap Shadow
  let cap_x = center_x - cap_w * 0.5
  let cap_y = cap_center_y - cap_h * 0.5
  let cap_rect = @math.Rect::new(cap_x, cap_y, cap_w, cap_h)
  let is_active = response.dragged() ||
    (response.pressed() && ctx.input.mouse_down)

  ctx
  .painter()
  .add_rect(
    cap_rect.translate(@math.Vec2::new(0.0, 2.0 * scale)),
    @color.Color::shadow(),
    cap_radius,
  )

  // E. Porcelain Tactile Fader Cap
  let cap_bg = if is_active {
    @color.Color::bg_active()
  } else if response.hovered() {
    @color.Color::bg_hover()
  } else {
    @color.Color::bg_window()
  }
  ctx.painter().add_rect(cap_rect, cap_bg, cap_radius)

  // Cap border
  let cap_border = if is_focused {
    @color.Color::border_focus()
  } else if response.hovered() || is_active {
    @color.Color::border_strong()
  } else {
    @color.Color::border_default()
  }
  ctx.painter().add_rect_stroke(cap_rect, cap_border, 1.0, cap_radius)

  // Center High-Contrast Index Line on Cap
  let index_y = cap_center_y
  let index_inset = 4.0 * scale
  ctx
  .painter()
  .add_line(
    @math.Vec2::new(cap_x + index_inset, index_y),
    @math.Vec2::new(cap_x + cap_w - index_inset, index_y),
    if is_active {
      @color.Color::accent_primary()
    } else {
      @color.Color::border_strong()
    },
    1.5 * scale,
  )

  // Focus ring
  if is_focused {
    ctx
    .painter()
    .add_rect_stroke(
      cap_rect.expand(2.0 * scale),
      @color.Color::border_focus(),
      1.5,
      cap_radius + 2.0 * scale,
    )
  }

  // F. Bottom Monospace Readout
  let rounded_int = (current_val * 10.0).to_int()
  let whole = rounded_int / 10
  let frac_part = (rounded_int % 10).abs()
  let mut readout_str = whole.to_string() + "." + frac_part.to_string()
  if unit.length() > 0 {
    readout_str = readout_str + unit
  }
  let readout_sz = ctx.measure_text(readout_str, font_sm)
  let readout_x = center_x - readout_sz.x * 0.5
  let readout_y = rect.y + total_h - font_sm
  ctx
  .painter()
  .add_text(
    @math.Vec2::new(readout_x, readout_y),
    readout_str,
    font_sm,
    if is_active || is_focused {
      @color.Color::accent_primary()
    } else {
      @color.Color::text_muted()
    },
    font_family="monospace",
  )

  (current_val, response)
}

///|
/// Immediate-mode vertical audio channel fader parameter controller.
/// Features vertical recessed track groove, calibrated tick marks,
/// tactile fader cap with center index indicator line, vertical drag delta,
/// scroll wheel stepping, Shift (0.1x) / Ctrl (10x) modifiers,
/// keyboard ArrowUp/ArrowDown navigation, and Alt+Click reset.
pub fn UIContext::fader(
  self : UIContext,
  id_salt : String,
  label : String,
  value : Double,
  min_val? : Double = 0.0,
  max_val? : Double = 1.0,
  step? : Double = 0.01,
  default_val? : Double = 0.0,
  unit? : String = "",
  show_ticks? : Bool = true,
  size? : @math.Vec2,
) -> (Double, Response) {
  let mut f = Fader::new(id_salt, label, value)
    .min(min_val)
    .max(max_val)
    .step(step)
    .default_val(default_val)
    .unit(unit)
    .show_ticks(show_ticks)
  if size is Some(s) {
    f = f.size(s)
  }
  f.show(self)
}

///|
/// Integer variant of the vertical parameter fader.
pub fn UIContext::fader_int(
  self : UIContext,
  id_salt : String,
  label : String,
  value : Int,
  min_val? : Int = 0,
  max_val? : Int = 100,
  step? : Int = 1,
  default_val? : Int = 0,
  unit? : String = "",
  show_ticks? : Bool = true,
  size? : @math.Vec2,
) -> (Int, Response) {
  let (new_val, resp) = match size {
    Some(s) =>
      self.fader(
        id_salt,
        label,
        value.to_double(),
        min_val=min_val.to_double(),
        max_val=max_val.to_double(),
        step=step.to_double(),
        default_val=default_val.to_double(),
        unit~,
        show_ticks~,
        size=s,
      )
    None =>
      self.fader(
        id_salt,
        label,
        value.to_double(),
        min_val=min_val.to_double(),
        max_val=max_val.to_double(),
        step=step.to_double(),
        default_val=default_val.to_double(),
        unit~,
        show_ticks~,
      )
  }
  let rounded = if new_val >= 0.0 {
    (new_val + 0.5).to_int()
  } else {
    (new_val - 0.5).to_int()
  }
  (rounded, resp)
}
