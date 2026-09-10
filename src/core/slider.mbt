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
      @color.Color::text_primary(),
    )
  }

  // Draw Track Background
  self.draw_list.add_rect(track_rect, @color.Color::bg_hover(), 3.0)

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
    self.draw_list.add_rect(fill_rect, @color.Color::accent_primary(), 3.0)
  }

  // Draw Thumb Handle
  let thumb_cx = track_rect.x + active_w
  let thumb_cy = track_rect.y + track_rect.h * 0.5
  let thumb_r = if is_active { 7.0 } else if is_hovered { 6.0 } else { 5.0 }
  let thumb_col = if is_active {
    @color.Color::accent_hover()
  } else if is_hovered {
    @color.Color::white()
  } else {
    @color.Color::accent_primary()
  }
  self.draw_list.add_circle(
    @math.Vec2::new(thumb_cx, thumb_cy),
    thumb_r,
    thumb_col,
  )
  self.draw_list.add_circle_stroke(
    @math.Vec2::new(thumb_cx, thumb_cy),
    thumb_r,
    @color.Color::white(),
    1.5,
  )

  // Draw Value Text
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
  self.draw_list.add_text(
    @math.Vec2::new(track_rect.x + track_w + 10.0, rect.y + 4.0),
    val_text,
    12.0,
    @color.Color::text_secondary(),
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
    let step = if speed > 0.0001 { speed } else { 1.0 }
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
      @color.Color::text_primary(),
    )
  }

  // Draw Box Background & Stroke
  let bg_color = if is_active {
    @color.Color::bg_hover()
  } else if is_hovered {
    @color.Color::bg_surface()
  } else {
    @color.Color::bg_window()
  }

  let border_color = if is_active {
    @color.Color::accent_primary()
  } else if is_hovered {
    @color.Color::accent_hover()
  } else {
    @color.Color::border_muted()
  }

  self.draw_list.add_rect(box_rect, bg_color, 4.0)
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
      @color.Color::accent_primary()
    } else {
      @color.Color::text_primary()
    },
  )

  (new_val, resp)
}
