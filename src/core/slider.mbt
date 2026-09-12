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
  let scale = self.style.scale
  let font_size = self.style.font_normal * scale
  let label_size = self.measure_text(label, font_size)
  let label_w = if label.length() > 0 {
    label_size.x + 12.0 * scale
  } else {
    0.0
  }
  let track_w = self.style.slider_track_w * scale
  let val_w = 42.0 * scale
  let total_w = label_w + track_w + val_w + 8.0 * scale
  let h = self.style.slider_h * scale
  let (id, rect, resp) = self.allocate_space(@math.Vec2::new(total_w, h))
  self.register_focusable(id)

  let track_h = 6.0 * scale
  let track_rect = @math.Rect::new(
    rect.x + label_w,
    rect.y + (h - track_h) * 0.5,
    track_w,
    track_h,
  )

  // Hit-testing on interactive track zone
  let touch_rect = @math.Rect::new(
    track_rect.x - 4.0 * scale,
    rect.y,
    track_w + 8.0 * scale,
    h,
  )
  let is_hovered = self.is_hovered(touch_rect)
  if is_hovered && self.input.mouse_pressed {
    self.set_active_id(id)
  }

  let is_active = self.active_id() == id
  if is_hovered || is_active {
    self.set_cursor_icon("ew-resize")
  }
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

  // Keyboard navigation when focused
  let is_focused = resp.has_focus()
  if is_focused {
    let step = if safe_range >= 100.0 {
      1.0
    } else if safe_range >= 10.0 {
      0.5
    } else {
      0.05
    }
    if self.input.key_pressed(Key::ArrowLeft) ||
      self.input.key_pressed(Key::ArrowDown) {
      new_val = new_val - step
      if new_val < clamped_min {
        new_val = clamped_min
      }
      self.input.consume_key(Key::ArrowLeft)
      self.input.consume_key(Key::ArrowDown)
    }
    if self.input.key_pressed(Key::ArrowRight) ||
      self.input.key_pressed(Key::ArrowUp) {
      new_val = new_val + step
      if new_val > clamped_max {
        new_val = clamped_max
      }
      self.input.consume_key(Key::ArrowRight)
      self.input.consume_key(Key::ArrowUp)
    }
  }

  // Draw Label
  if label.length() > 0 {
    self
    .painter()
    .add_text(
      @math.Vec2::new(rect.x, rect.y + (h - 13.0) * 0.5),
      label,
      13.0,
      @color.Color::text_primary(),
    )
  }

  // Draw Recessed Track Background
  self.painter().add_rect(track_rect, @color.Color::bg_surface(), 3.0)
  self
  .painter()
  .add_rect_stroke(track_rect, @color.Color::border_muted(), 1.0, 3.0)

  // Draw Discrete Ticks (25%, 50%, 75%)
  let tick_col = @color.Color::border_default()
  for t in [0.25, 0.5, 0.75] {
    let tick_x = track_rect.x + track_rect.w * t
    let tick_y = track_rect.y + track_rect.h * 0.5
    self.painter().add_circle(@math.Vec2::new(tick_x, tick_y), 1.5, tick_col)
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
    self.painter().add_rect(fill_rect, @color.Color::accent_primary(), 3.0)
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
  let scale = self.style.scale
  let font_sm = self.style.font_small * scale
  let radius_sm = self.style.radius_sm * scale

  let thumb_r = if is_active {
    7.0 * scale
  } else if is_hovered || is_focused {
    6.5 * scale
  } else {
    5.5 * scale
  }
  self
  .painter()
  .add_circle(
    @math.Vec2::new(thumb_cx, thumb_cy),
    thumb_r,
    @color.Color::bg_window(),
  )
  let thumb_stroke = if is_focused {
    @color.Color::border_focus()
  } else {
    @color.Color::accent_primary()
  }
  let thumb_stroke_w = if is_focused { 2.0 * scale } else { 1.5 }
  self
  .painter()
  .add_circle_stroke(
    @math.Vec2::new(thumb_cx, thumb_cy),
    thumb_r,
    thumb_stroke,
    thumb_stroke_w,
  )

  // Draw Floating HUD Bubble above Thumb when active
  if is_active {
    let bubble_size = self.measure_text(val_text, font_sm)
    let bubble_w = bubble_size.x + 14.0 * scale
    let bubble_h = 20.0 * scale
    let bubble_x = thumb_cx - bubble_w * 0.5
    let bubble_y = thumb_cy - thumb_r - bubble_h - 4.0 * scale
    let bubble_rect = @math.Rect::new(bubble_x, bubble_y, bubble_w, bubble_h)
    self.painter().add_rect(bubble_rect, @color.Color::bg_window(), radius_sm)
    self
    .painter()
    .add_rect_stroke(
      bubble_rect,
      @color.Color::border_default(),
      1.0,
      radius_sm,
    )
    let bubble_text_pos = @math.Vec2::new(
      bubble_x + 7.0 * scale,
      bubble_y + (bubble_h - font_sm) * 0.5,
    )
    self
    .painter()
    .add_text(bubble_text_pos, val_text, font_sm, @color.Color::text_primary())
  }

  // Draw Value Text in row
  self
  .painter()
  .add_text(
    @math.Vec2::new(track_rect.x + track_w + 10.0, rect.y + (h - 12.0) * 0.5),
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
  let scale = self.style.scale
  let font_nm = self.style.font_normal * scale
  let font_sm = self.style.font_small * scale
  let radius_sm = self.style.radius_sm * scale
  let box_w = self.style.drag_value_w * scale
  let h = self.style.drag_value_h * scale

  let label_size = self.measure_text(label, font_nm)
  let label_w = if label.length() > 0 {
    label_size.x + 8.0 * scale
  } else {
    0.0
  }
  let total_w = label_w + box_w
  let (id, rect, resp) = self.allocate_space(@math.Vec2::new(total_w, h))
  self.register_focusable(id)

  let box_rect = @math.Rect::new(rect.x + label_w, rect.y, box_w, h)
  let is_hovered = self.is_hovered(box_rect)
  if is_hovered && self.input.mouse_pressed {
    self.set_active_id(id)
  }

  let is_active = self.active_id() == id
  if is_hovered || is_active {
    self.set_cursor_icon("ew-resize")
  }
  let mut new_val = value

  let base_speed = if speed > 0.0001 { speed } else { 1.0 }
  let multiplier = if self.input.modifiers.shift {
    0.1
  } else if self.input.modifiers.ctrl {
    10.0
  } else {
    1.0
  }
  let step = base_speed * multiplier

  // 1. Keyboard navigation when focused
  let is_focused = resp.has_focus() || self.has_focus(id)
  if is_focused {
    if self.input.key_pressed(Key::ArrowLeft) ||
      self.input.key_pressed(Key::ArrowDown) {
      new_val = new_val - step
      self.input.consume_key(Key::ArrowLeft)
      self.input.consume_key(Key::ArrowDown)
    }
    if self.input.key_pressed(Key::ArrowRight) ||
      self.input.key_pressed(Key::ArrowUp) {
      new_val = new_val + step
      self.input.consume_key(Key::ArrowRight)
      self.input.consume_key(Key::ArrowUp)
    }
    if min < max {
      if new_val < min {
        new_val = min
      } else if new_val > max {
        new_val = max
      }
    }
  }

  // 2. Pointer drag tracking
  if is_active && self.input.mouse_down {
    let delta_x = self.input.mouse_delta.x
    new_val = new_val + delta_x * step
    if min < max {
      if new_val < min {
        new_val = min
      } else if new_val > max {
        new_val = max
      }
    }
  }

  // 3. Draw Label
  if label.length() > 0 {
    self
    .painter()
    .add_text(
      @math.Vec2::new(rect.x, rect.y + (h - font_nm) * 0.5),
      label,
      font_nm,
      @color.Color::text_primary(),
    )
  }

  // 4. Draw Box Background & Mercury Progress Fill
  let bg_color = if is_active {
    @color.Color::bg_surface()
  } else if is_hovered {
    @color.Color::bg_window()
  } else {
    @color.Color::bg_subtle()
  }

  let border_color = if is_focused {
    @color.Color::border_focus()
  } else if is_active || is_hovered {
    @color.Color::accent_primary()
  } else {
    @color.Color::border_default()
  }

  self.painter().add_rect(box_rect, bg_color, radius_sm)

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
      self
      .painter()
      .add_rect(mercury_rect, @color.Color::accent_soft(), radius_sm)
    }
  }

  self.painter().add_rect_stroke(box_rect, border_color, 1.0, radius_sm)
  if is_focused {
    self
    .painter()
    .add_rect_stroke(
      box_rect.expand(2.0 * scale),
      @color.Color::border_focus(),
      1.5,
      radius_sm + 2.0 * scale,
    )
  }

  // Format value to 1 decimal place or integer
  let rounded_int = (new_val * 10.0).to_int()
  let whole = rounded_int / 10
  let frac = (rounded_int % 10).abs()
  let val_str = whole.to_string() + "." + frac.to_string()

  let val_size = self.measure_text(val_str, font_sm)
  let text_x = box_rect.x + (box_w - val_size.x) * 0.5
  let text_y = box_rect.y + (h - font_sm) * 0.5
  self
  .painter()
  .add_text(
    @math.Vec2::new(text_x, text_y),
    val_str,
    font_sm,
    if is_active {
      @color.Color::accent_primary()
    } else {
      @color.Color::text_primary()
    },
  )

  (new_val, resp)
}
