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
fn draw_arc(
  dl : @draw.DrawList,
  center : @math.Vec2,
  radius : Double,
  start_angle : Double,
  end_angle : Double,
  color : @color.Color,
  width : Double,
  segments : Int,
) -> Unit {
  let sweep = end_angle - start_angle
  if sweep.abs() < 0.001 || segments <= 0 {
    return
  }
  let step = sweep / segments.to_double()
  let mut prev_p = center.add(@math.Vec2::from_polar(radius, start_angle))
  for i = 1; i <= segments; i = i + 1 {
    let a = start_angle + step * i.to_double()
    let cur_p = center.add(@math.Vec2::from_polar(radius, a))
    dl.add_line(prev_p, cur_p, color, width)
    prev_p = cur_p
  }
}

///|
/// Immediate-mode rotary knob parameter controller in Studio Light porcelain style.
/// Features 270-degree arc track, unipolar/bipolar sweeps, vertical drag delta,
/// scroll wheel stepping, Shift precision scaling, and monospace readouts.
pub fn UIContext::knob(
  self : UIContext,
  id_salt : String,
  label : String,
  value : Double,
  min_val? : Double = 0.0,
  max_val? : Double = 1.0,
  step? : Double = 0.01,
  default_val? : Double = 0.0,
  unit? : String = "",
  radius? : Double = 22.0,
  bipolar? : Bool = false,
) -> (Double, Response) {
  let range = if max_val > min_val { max_val - min_val } else { 1.0 }
  let clamped_initial = if value < min_val {
    min_val
  } else if value > max_val {
    max_val
  } else {
    value
  }

  let diameter = radius * 2.0
  let label_h = if label.is_empty() { 0.0 } else { 15.0 }
  let val_h = 16.0
  let total_w = diameter + 16.0
  let total_h = diameter + label_h + val_h + 8.0

  let id = self.id_stack.derive_id("knob::" + id_salt)
  let (_, rect, response) = self.allocate_space(
    @math.Vec2::new(total_w, total_h),
  )

  self.register_focusable(id)
  if response.pressed() || response.clicked() {
    self.request_focus(id)
  }
  let is_focused = self.has_focus(id)

  let mut current_val = clamped_initial

  // 1. Mouse Drag Gesture (Vertical delta is primary industry standard)
  if !self.input.modifiers.alt &&
    (response.dragged() || (response.pressed() && self.input.mouse_down)) {
    let dy = -self.input.mouse_delta.y
    let dx = self.input.mouse_delta.x
    let delta = dy + dx
    let sensitivity = if self.input.modifiers.shift { 0.001 } else { 0.005 }
    current_val = current_val + delta * range * sensitivity
  }

  // 2. Mouse Scroll Wheel
  if response.hovered() && self.input.scroll_delta.y.abs() > 0.0 {
    let dir = if self.input.scroll_delta.y > 0.0 { 1.0 } else { -1.0 }
    current_val = current_val + dir * step
  }

  // 3. Keyboard Navigation when focused
  if is_focused {
    if self.input.key_pressed(Key::ArrowUp) ||
      self.input.key_pressed(Key::ArrowRight) {
      current_val = current_val + step
    }
    if self.input.key_pressed(Key::ArrowDown) ||
      self.input.key_pressed(Key::ArrowLeft) {
      current_val = current_val - step
    }
    if self.input.key_pressed(Key::Home) {
      current_val = min_val
    }
    if self.input.key_pressed(Key::End) {
      current_val = max_val
    }
    if self.input.key_pressed(Key::Backspace) ||
      self.input.key_pressed(Key::Delete) {
      current_val = default_val
    }
  }

  // 4. Reset to default on Alt+Click or Alt+Press
  if (response.pressed() || response.clicked()) && self.input.modifiers.alt {
    current_val = default_val
  }

  // 4. Quantize and clamp
  if step > 0.0 {
    let steps_count = ((current_val - min_val) / step + 0.5)
      .to_int()
      .to_double()
    current_val = min_val + steps_count * step
  }
  let final_val = if current_val < min_val {
    min_val
  } else if current_val > max_val {
    max_val
  } else {
    current_val
  }

  // 5. Visual Rendering
  let center_x = rect.x + total_w * 0.5
  let center_y = rect.y + label_h + 4.0 + radius
  let center = @math.Vec2::new(center_x, center_y)
  let dial_radius = radius - 3.5

  // 270 degree sweep: from 135 deg (0.75 pi) to 405 deg (2.25 pi)
  let start_angle = 0.75 * @math.pi
  let total_sweep = 1.5 * @math.pi
  let end_angle = start_angle + total_sweep

  // A. Background track arc
  draw_arc(
    self.draw_list,
    center,
    radius,
    start_angle,
    end_angle,
    @color.Color::border_muted(),
    3.5,
    20,
  )

  // B. Active Indicator Arc
  let norm = (final_val - min_val) / range
  if bipolar {
    let mid_angle = 1.5 * @math.pi // Top center (270 deg)
    let curr_angle = start_angle + norm * total_sweep
    let segs = ((curr_angle - mid_angle).abs() / total_sweep * 16.0).to_int() +
      2
    draw_arc(
      self.draw_list,
      center,
      radius,
      mid_angle,
      curr_angle,
      @color.Color::accent_primary(),
      3.5,
      segs,
    )
  } else {
    let curr_angle = start_angle + norm * total_sweep
    let segs = (norm * 20.0).to_int() + 2
    draw_arc(
      self.draw_list,
      center,
      radius,
      start_angle,
      curr_angle,
      @color.Color::accent_primary(),
      3.5,
      segs,
    )
  }

  // C. Dial Cap (White Porcelain disc + border + shadow)
  self.draw_list.add_circle(
    center.add(@math.Vec2::new(0.0, 1.5)),
    dial_radius,
    @color.Color::shadow(),
  )
  let cap_col = if response.pressed() {
    @color.Color::bg_active()
  } else if response.hovered() {
    @color.Color::bg_hover()
  } else {
    @color.Color::white()
  }
  self.draw_list.add_circle(center, dial_radius, cap_col)
  let border_col = if is_focused {
    @color.Color::border_focus()
  } else {
    @color.Color::border_default()
  }
  self.draw_list.add_circle_stroke(center, dial_radius, border_col, 1.0)

  // D. Laser-engraved pointer tick
  let pointer_angle = start_angle + norm * total_sweep
  let tick_start = center.add(
    @math.Vec2::from_polar(dial_radius * 0.35, pointer_angle),
  )
  let tick_end = center.add(
    @math.Vec2::from_polar(dial_radius * 0.85, pointer_angle),
  )
  let tick_col = if response.pressed() {
    @color.Color::accent_primary()
  } else {
    @color.Color::text_secondary()
  }
  self.draw_list.add_line(tick_start, tick_end, tick_col, 2.0)

  // E. Uppercase Label (Top)
  if !label.is_empty() {
    let label_w = self.measure_text(label, 10.5).x
    self.draw_list.add_text(
      @math.Vec2::new(center_x - label_w * 0.5, rect.y),
      label,
      10.5,
      @color.Color::text_muted(),
    )
  }

  // F. Numeric Readout Badge (Bottom)
  let val_str = if unit.is_empty() {
    final_val.to_string()
  } else {
    final_val.to_string() + " " + unit
  }
  let val_w = self.measure_text(val_str, 11.0).x
  let val_col = if is_focused || response.pressed() {
    @color.Color::accent_primary()
  } else {
    @color.Color::text_strong()
  }
  self.draw_list.add_text(
    @math.Vec2::new(center_x - val_w * 0.5, center_y + radius + 4.0),
    val_str,
    11.0,
    val_col,
  )

  (final_val, response)
}
