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
  let scale = self.style.scale
  let font_nm = self.style.font_normal * scale
  let font_sm = self.style.font_small * scale
  let f_style = FaderStyle::default()
  let total_w = match size {
    Some(s) => s.x
    None => f_style.width * scale
  }
  let total_h = match size {
    Some(s) => s.y
    None => f_style.height * scale
  }
  let track_w = f_style.track_w * scale
  let cap_w = f_style.cap_w * scale
  let cap_h = f_style.cap_h * scale
  let cap_radius = f_style.cap_radius * scale

  let range = if max_val > min_val { max_val - min_val } else { 1.0 }
  let clamped_initial = if value < min_val {
    min_val
  } else if value > max_val {
    max_val
  } else {
    value
  }

  self.push_id(id_salt)
  let (id, rect, response) = self.allocate_space(
    @math.Vec2::new(total_w, total_h),
  )
  self.pop_id()

  self.register_focusable(id)
  if response.pressed() || response.clicked() {
    self.request_focus(id)
  }
  if response.hovered() || response.dragged() || response.pressed() {
    self.set_cursor_icon("ns-resize")
  }
  let is_focused = self.has_focus(id) || response.has_focus()

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
  if !self.input.modifiers.alt &&
    (response.dragged() || (response.pressed() && self.input.mouse_down)) {
    let dy = -self.input.mouse_delta.y
    let sensitivity = if self.input.modifiers.shift {
      0.1
    } else if self.input.modifiers.ctrl {
      10.0
    } else {
      1.0
    }
    let delta = dy / track_travel_h * range * sensitivity
    current_val = current_val + delta
  }

  // 2. Mouse Scroll Wheel
  if response.hovered() && self.input.scroll_delta.y.abs() > 0.0 {
    let dir = if self.input.scroll_delta.y > 0.0 { 1.0 } else { -1.0 }
    let multiplier = if self.input.modifiers.shift { 0.1 } else { 1.0 }
    current_val = current_val + dir * step * multiplier
  }

  // 3. Keyboard Navigation when focused
  if is_focused {
    let key_step = if self.input.modifiers.shift {
      step * 0.1
    } else if self.input.modifiers.ctrl {
      step * 10.0
    } else {
      step
    }
    if self.input.key_pressed(Key::ArrowUp) ||
      self.input.key_pressed(Key::ArrowRight) {
      current_val = current_val + key_step
      self.input.consume_key(Key::ArrowUp)
      self.input.consume_key(Key::ArrowRight)
    }
    if self.input.key_pressed(Key::ArrowDown) ||
      self.input.key_pressed(Key::ArrowLeft) {
      current_val = current_val - key_step
      self.input.consume_key(Key::ArrowDown)
      self.input.consume_key(Key::ArrowLeft)
    }
    if self.input.key_pressed(Key::Home) {
      current_val = max_val
      self.input.consume_key(Key::Home)
    }
    if self.input.key_pressed(Key::End) {
      current_val = min_val
      self.input.consume_key(Key::End)
    }
  }

  // 4. Alt + Click or double click reset to default
  if response.clicked() && self.input.modifiers.alt {
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

  // A. Top Label
  if label.length() > 0 {
    let lbl_sz = self.measure_text(label, font_nm)
    let lbl_x = center_x - lbl_sz.x * 0.5
    self
    .painter()
    .add_text(
      @math.Vec2::new(lbl_x, rect.y),
      label,
      font_nm,
      @color.Color::text_secondary(),
    )
  }

  // B. Calibrated Tick Marks on both sides of the track
  if show_ticks {
    let tick_count = 5
    let tick_len = 4.0 * scale
    for i = 0; i <= tick_count; i = i + 1 {
      let t_frac = i.to_double() / tick_count.to_double()
      let ty = track_bottom_y - t_frac * track_travel_h
      let is_mid = i == tick_count / 2 || i == 0 || i == tick_count
      let cur_len = if is_mid { tick_len * 1.5 } else { tick_len }
      let tick_col = if is_mid {
        @color.Color::border_strong()
      } else {
        @color.Color::fader_tick()
      }
      // Left tick
      self
      .painter()
      .add_line(
        @math.Vec2::new(center_x - track_w * 0.5 - 2.0 * scale - cur_len, ty),
        @math.Vec2::new(center_x - track_w * 0.5 - 2.0 * scale, ty),
        tick_col,
        1.0,
      )
      // Right tick
      self
      .painter()
      .add_line(
        @math.Vec2::new(center_x + track_w * 0.5 + 2.0 * scale, ty),
        @math.Vec2::new(center_x + track_w * 0.5 + 2.0 * scale + cur_len, ty),
        tick_col,
        1.0,
      )
    }
  }

  // C. Recessed Fader Track
  let track_rect = @math.Rect::new(
    center_x - track_w * 0.5,
    track_top_y,
    track_w,
    track_travel_h,
  )
  self
  .painter()
  .add_rect(track_rect, @color.Color::fader_track_bg(), track_w * 0.5)
  self
  .painter()
  .add_rect_stroke(track_rect, @color.Color::border_muted(), 1.0, track_w * 0.5)

  // D. Active Level Fill inside track (bottom up to cap)
  let cap_y = track_bottom_y - clamped_frac * track_travel_h
  if clamped_frac > 0.001 {
    let fill_h = clamped_frac * track_travel_h
    let fill_rect = @math.Rect::new(
      center_x - track_w * 0.5,
      cap_y,
      track_w,
      fill_h,
    )
    self
    .painter()
    .add_rect(fill_rect, @color.Color::accent_primary(), track_w * 0.5)
  }

  // E. Tactile Fader Cap
  let cap_rect = @math.Rect::new(
    center_x - cap_w * 0.5,
    cap_y - cap_h * 0.5,
    cap_w,
    cap_h,
  )

  let is_active = response.dragged() ||
    (response.pressed() && self.input.mouse_down)
  let is_hovered = response.hovered()

  let cap_bg = if is_active {
    @color.Color::bg_surface()
  } else if is_hovered {
    @color.Color::bg_subtle()
  } else {
    @color.Color::bg_window()
  }

  let cap_border = if is_focused {
    @color.Color::border_focus()
  } else if is_active || is_hovered {
    @color.Color::accent_primary()
  } else {
    @color.Color::border_default()
  }

  // Cap drop shadow
  self
  .painter()
  .add_rect(
    @math.Rect::new(
      cap_rect.x,
      cap_rect.y + 1.0 * scale,
      cap_rect.w,
      cap_rect.h,
    ),
    @color.Color::pill_ambient_shadow(),
    cap_radius,
  )
  // Cap body
  self.painter().add_rect(cap_rect, cap_bg, cap_radius)
  self.painter().add_rect_stroke(cap_rect, cap_border, 1.0, cap_radius)

  // Cap center indicator index line
  let line_w = cap_w - 8.0 * scale
  self
  .painter()
  .add_line(
    @math.Vec2::new(center_x - line_w * 0.5, cap_y),
    @math.Vec2::new(center_x + line_w * 0.5, cap_y),
    if is_active || is_focused {
      @color.Color::fader_cap_line()
    } else {
      @color.Color::border_strong()
    },
    1.5 * scale,
  )

  // Focus ring
  if is_focused {
    self
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
  let readout_sz = self.measure_text(readout_str, font_sm)
  let readout_x = center_x - readout_sz.x * 0.5
  let readout_y = rect.y + total_h - font_sm
  self
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
