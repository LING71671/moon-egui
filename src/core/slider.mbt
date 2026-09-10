///|
/// Render a continuous floating-point slider.
/// Returns a tuple of (new_value, response).
pub fn UIContext::slider(
  self : UIContext,
  label : String,
  value : Double,
  min : Double,
  max : Double,
) -> (Double, Response) {
  let char_w = 8.0
  let label_w = if label.length() > 0 {
    label.length().to_double() * char_w + 12.0
  } else {
    0.0
  }
  let track_w = 120.0
  let val_w = 42.0
  let total_w = label_w + track_w + val_w + 8.0
  let h = 24.0
  let (id, rect, resp) = self.allocate_space(@math.Vec2::new(total_w, h))

  let track_rect = @math.Rect::new(
    rect.x + label_w,
    rect.y + (h - 6.0) * 0.5,
    track_w,
    6.0,
  )

  // Hit-testing on interactive track zone
  let touch_rect = @math.Rect::new(track_rect.x - 4.0, rect.y, track_w + 8.0, h)
  let is_hovered = touch_rect.contains(self.input.mouse_pos)
  if is_hovered && self.input.mouse_pressed {
    self.set_active_id(id)
  }

  let is_active = self.active_id() == id
  let clamped_min = if min < max { min } else { max }
  let clamped_max = if max > min { max } else { min }
  let range = clamped_max - clamped_min
  let safe_range = if range > 0.000001 { range } else { 1.0 }

  let mut new_val = value
  if is_active && self.input.mouse_down {
    let mouse_x = self.input.mouse_pos.x
    let mut pct = (mouse_x - track_rect.x) / track_rect.w
    if pct < 0.0 {
      pct = 0.0
    } else if pct > 1.0 {
      pct = 1.0
    }
    new_val = clamped_min + pct * safe_range
  }

  // Draw Label
  if label.length() > 0 {
    self.draw_list.add_text(
      @math.Vec2::new(rect.x, rect.y + 4.0),
      label,
      13.0,
      @color.Color::rgb(15, 23, 42),
    )
  }

  // Draw Recessed Track Background
  self.draw_list.add_rect(track_rect, @color.Color::rgb(241, 245, 249), 3.0)
  self.draw_list.add_rect_stroke(
    track_rect,
    @color.Color::rgb(226, 232, 240),
    1.0,
    3.0,
  )

  // Draw Discrete Ticks (25%, 50%, 75%)
  let tick_col = @color.Color::rgb(203, 213, 225)
  for t in [0.25, 0.5, 0.75] {
    let tick_x = track_rect.x + track_rect.w * t
    let tick_y = track_rect.y + track_rect.h * 0.5
    self.draw_list.add_circle(@math.Vec2::new(tick_x, tick_y), 1.5, tick_col)
  }

  // Draw Active Progress Fill
  let mut current_pct = (new_val - clamped_min) / safe_range
  if current_pct < 0.0 {
    current_pct = 0.0
  } else if current_pct > 1.0 {
    current_pct = 1.0
  }
  let active_w = track_rect.w * current_pct
  if active_w > 0.0 {
    let fill_rect = @math.Rect::new(
      track_rect.x,
      track_rect.y,
      active_w,
      track_rect.h,
    )
    self.draw_list.add_rect(fill_rect, @color.Color::rgb(37, 99, 235), 3.0)
  }

  // Compute Value Text
  let val_text = if safe_range >= 10.0 {
    new_val.to_int().to_string()
  } else {
    let int_part = new_val.to_int()
    let diff = new_val - int_part.to_double()
    let abs_diff = if diff < 0.0 { -diff } else { diff }
    let frac_part = (abs_diff * 100.0).to_int()
    let frac_str = if frac_part < 10 {
      "0" + frac_part.to_string()
    } else {
      frac_part.to_string()
    }
    int_part.to_string() + "." + frac_str
  }

  // Draw White Ceramic Thumb Handle with Cobalt Border
  let thumb_cx = track_rect.x + active_w
  let thumb_cy = track_rect.y + track_rect.h * 0.5
  let thumb_r = if is_active { 7.0 } else if is_hovered { 6.5 } else { 5.5 }
  self.draw_list.add_circle(
    @math.Vec2::new(thumb_cx, thumb_cy),
    thumb_r,
    @color.Color::white(),
  )
  self.draw_list.add_circle_stroke(
    @math.Vec2::new(thumb_cx, thumb_cy),
    thumb_r,
    @color.Color::rgb(37, 99, 235),
    1.5,
  )

  // Draw Floating HUD Bubble above Thumb when active
  if is_active {
    let bubble_w = val_text.length().to_double() * 7.5 + 14.0
    let bubble_h = 20.0
    let bubble_x = thumb_cx - bubble_w * 0.5
    let bubble_y = thumb_cy - thumb_r - bubble_h - 4.0
    let bubble_rect = @math.Rect::new(bubble_x, bubble_y, bubble_w, bubble_h)
    self.draw_list.add_rect(bubble_rect, @color.Color::white(), 5.0)
    self.draw_list.add_rect_stroke(
      bubble_rect,
      @color.Color::rgb(203, 213, 225),
      1.0,
      5.0,
    )
    let bubble_text_pos = @math.Vec2::new(bubble_x + 7.0, bubble_y + 3.5)
    self.draw_list.add_text(
      bubble_text_pos,
      val_text,
      11.0,
      @color.Color::rgb(15, 23, 42),
    )
  }

  // Draw Value Text in row
  self.draw_list.add_text(
    @math.Vec2::new(track_rect.x + track_w + 10.0, rect.y + 4.0),
    val_text,
    12.0,
    @color.Color::rgb(71, 85, 105),
  )

  (new_val, resp)
}

///|
/// Render an integer step slider.
/// Returns a tuple of (new_value, response).
pub fn UIContext::slider_int(
  self : UIContext,
  label : String,
  value : Int,
  min : Int,
  max : Int,
) -> (Int, Response) {
  let (new_val, resp) = self.slider(
    label,
    value.to_double(),
    min.to_double(),
    max.to_double(),
  )
  let rounded = if new_val >= 0.0 {
    (new_val + 0.5).to_int()
  } else {
    (new_val - 0.5).to_int()
  }
  (rounded, resp)
}

///|
/// Render a compact numerical drag-value box.
/// Click and drag horizontally to smoothly adjust the value.
/// Returns a tuple of (new_value, response).
pub fn UIContext::drag_value(
  self : UIContext,
  label : String,
  value : Double,
  speed : Double,
  min : Double,
  max : Double,
) -> (Double, Response) {
  let char_w = 8.0
  let label_w = if label.length() > 0 {
    label.length().to_double() * char_w + 8.0
  } else {
    0.0
  }
  let box_w = 64.0
  let total_w = label_w + box_w
  let h = 22.0
  let (id, rect, resp) = self.allocate_space(@math.Vec2::new(total_w, h))

  let box_rect = @math.Rect::new(rect.x + label_w, rect.y, box_w, h)
  let is_hovered = box_rect.contains(self.input.mouse_pos)
  if is_hovered && self.input.mouse_pressed {
    self.set_active_id(id)
  }

  let is_active = self.active_id() == id
  let mut new_val = value

  if is_active && self.input.mouse_down {
    let delta_x = self.input.mouse_delta.x
    let base_speed = if speed > 0.0001 { speed } else { 1.0 }
    let multiplier = if self.input.modifiers.shift {
      0.1
    } else if self.input.modifiers.ctrl {
      10.0
    } else {
      1.0
    }
    let step = base_speed * multiplier
    new_val = new_val + delta_x * step
    if min < max {
      if new_val < min {
        new_val = min
      } else if new_val > max {
        new_val = max
      }
    }
  }

  // Draw Label
  if label.length() > 0 {
    self.draw_list.add_text(
      @math.Vec2::new(rect.x, rect.y + 4.0),
      label,
      13.0,
      @color.Color::rgb(15, 23, 42),
    )
  }

  // Draw Box Background & Mercury Progress Fill
  let bg_color = if is_active {
    @color.Color::rgb(241, 245, 249)
  } else if is_hovered {
    @color.Color::rgb(255, 255, 255)
  } else {
    @color.Color::rgb(248, 250, 252)
  }

  let border_color = if is_active || is_hovered {
    @color.Color::rgb(37, 99, 235)
  } else {
    @color.Color::rgb(203, 213, 225)
  }

  self.draw_list.add_rect(box_rect, bg_color, 4.0)

  // Blender-style Mercury Progress Fill inside box
  if min < max {
    let range = max - min
    let pct = (new_val - min) / range
    let safe_pct = if pct < 0.0 { 0.0 } else if pct > 1.0 { 1.0 } else { pct }
    let fill_w = box_rect.w * safe_pct
    if fill_w > 0.0 {
      let mercury_rect = @math.Rect::new(
        box_rect.x,
        box_rect.y,
        fill_w,
        box_rect.h,
      )
      self.draw_list.add_rect(
        mercury_rect,
        @color.Color::rgba(37, 99, 235, 45),
        4.0,
      )
    }
  }

  self.draw_list.add_rect_stroke(box_rect, border_color, 1.0, 4.0)

  // Format value to 1 decimal place or integer
  let rounded_int = (new_val * 10.0).to_int()
  let whole = rounded_int / 10
  let frac = (rounded_int % 10).abs()
  let val_str = whole.to_string() + "." + frac.to_string()

  let text_x = box_rect.x + (box_w - val_str.length().to_double() * 7.0) * 0.5
  let text_y = box_rect.y + (h - 12.0) * 0.5
  self.draw_list.add_text(
    @math.Vec2::new(text_x, text_y),
    val_str,
    12.0,
    if is_active {
      @color.Color::rgb(37, 99, 235)
    } else {
      @color.Color::rgb(15, 23, 42)
    },
  )

  (new_val, resp)
}
