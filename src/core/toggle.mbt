///|
/// Render an interactive toggle checkbox.
/// Returns a tuple of (new_checked_state, response).
pub fn UIContext::checkbox(
  self : UIContext,
  text : String,
  checked : Bool,
) -> (Bool, Response) {
  let scale = self.style.scale
  let box_size = self.style.checkbox_size * scale
  let gap = self.style.checkbox_gap * scale
  let font_nm = self.style.font_normal * scale
  let text_size = self.measure_text(text, font_nm)
  let w = box_size + gap + text_size.x
  let h = self.style.checkbox_h * scale
  let (id, rect, resp) = self.allocate_space(@math.Vec2::new(w, h))
  self.register_focusable(id)
  if resp.hovered {
    self.set_cursor_icon("pointer")
  }
  let new_state = if resp.clicked { !checked } else { checked }

  let box_rect = @math.Rect::new(
    rect.x,
    rect.y + (h - box_size) * 0.5,
    box_size,
    box_size,
  )

  let radius = self.style.checkbox_radius * scale
  if checked {
    self.painter().add_rect(box_rect, @color.Color::accent_primary(), radius)
    let stroke_color = if resp.has_focus() {
      @color.Color::border_focus()
    } else {
      @color.Color::accent_pressed()
    }
    let stroke_w = if resp.has_focus() { 1.5 * scale } else { 1.0 }
    self.painter().add_rect_stroke(box_rect, stroke_color, stroke_w, radius)
    let inner = box_rect.shrink(4.0 * scale)
    self.painter().add_rect(inner, @color.Color::text_inverse(), 2.0 * scale)
  } else {
    let box_bg = if resp.hovered {
      @color.Color::bg_subtle()
    } else {
      @color.Color::bg_window()
    }
    let box_border = if resp.has_focus() {
      @color.Color::border_focus()
    } else if resp.hovered {
      @color.Color::accent_primary()
    } else {
      @color.Color::border_default()
    }
    let stroke_w = if resp.has_focus() { 1.5 * scale } else { 1.0 }
    self.painter().add_rect(box_rect, box_bg, radius)
    self.painter().add_rect_stroke(box_rect, box_border, stroke_w, radius)
  }

  let text_x = rect.x + box_size + gap
  let text_y = rect.y + (h - font_nm) * 0.5
  let text_color = if resp.hovered {
    @color.Color::text_primary()
  } else {
    @color.Color::text_body()
  }
  self
  .painter()
  .add_text(@math.Vec2::new(text_x, text_y), text, font_nm, text_color)

  (new_state, resp)
}

///|
/// Render an interactive radio button option.
/// Returns a tuple of (new_selected_state, response).
pub fn UIContext::radio(
  self : UIContext,
  label : String,
  selected : Bool,
) -> (Bool, Response) {
  let scale = self.style.scale
  let circle_r = self.style.radio_r * scale
  let gap = self.style.radio_gap * scale
  let font_nm = self.style.font_normal * scale
  let text_size = self.measure_text(label, font_nm)
  let total_w = circle_r * 2.0 + gap + text_size.x
  let total_h = self.style.radio_h * scale
  let (id, rect, resp) = self.allocate_space(@math.Vec2::new(total_w, total_h))
  if resp.hovered {
    self.set_cursor_icon("pointer")
  }
  self.register_focusable(id)

  let new_selected = if resp.clicked() { true } else { selected }

  let center = @math.Vec2::new(
    rect.x + circle_r + 1.0 * scale,
    rect.y + total_h * 0.5,
  )

  let outer_color = if resp.has_focus() || selected {
    @color.Color::accent_primary()
  } else if resp.hovered {
    @color.Color::accent_primary()
  } else {
    @color.Color::border_default()
  }

  let bg_circle_color = if resp.hovered {
    @color.Color::bg_subtle()
  } else {
    @color.Color::bg_window()
  }

  self.painter().add_circle(center, circle_r, bg_circle_color)
  self.painter().add_circle_stroke(center, circle_r, outer_color, 1.5 * scale)

  if selected {
    self
    .painter()
    .add_circle(center, circle_r * 0.5, @color.Color::accent_primary())
  }

  let text_pos = @math.Vec2::new(
    rect.x + circle_r * 2.0 + gap + 1.0 * scale,
    rect.y + (total_h - font_nm) * 0.5,
  )
  let text_color = if resp.hovered {
    @color.Color::text_primary()
  } else {
    @color.Color::text_body()
  }
  self.painter().add_text(text_pos, label, font_nm, text_color)

  (new_selected, resp)
}

///|
/// Render an interactive toggle pill switch.
/// Returns a tuple of (new_checked_state, response).
pub fn UIContext::toggle(
  self : UIContext,
  text : String,
  checked : Bool,
) -> (Bool, Response) {
  let scale = self.style.scale
  let font_nm = self.style.font_normal * scale
  let switch_w = self.style.toggle_w * scale
  let switch_h = self.style.toggle_h * scale
  let gap = 8.0 * scale
  let text_size = self.measure_text(text, font_nm)
  let total_w = switch_w + gap + text_size.x
  let h = 24.0 * scale
  let (id, rect, resp) = self.allocate_space(@math.Vec2::new(total_w, h))
  self.register_focusable(id)
  if resp.hovered {
    self.set_cursor_icon("pointer")
  }
  let new_state = if resp.clicked { !checked } else { checked }

  let switch_rect = @math.Rect::new(
    rect.x,
    rect.y + (h - switch_h) * 0.5,
    switch_w,
    switch_h,
  )

  let bg_color = if checked {
    if resp.hovered {
      @color.Color::accent_pressed()
    } else {
      @color.Color::accent_primary()
    }
  } else if resp.hovered {
    @color.Color::border_default()
  } else {
    @color.Color::border_muted()
  }

  // Draw pill background with subtle shadow
  self.painter().add_rect(switch_rect, bg_color, switch_h * 0.5)
  if resp.has_focus() {
    self
    .painter()
    .add_rect_stroke(
      switch_rect,
      @color.Color::border_focus(),
      1.5 * scale,
      switch_h * 0.5,
    )
  }

  // Draw sliding thumb circle
  let thumb_radius = (switch_h - 4.0 * scale) * 0.5
  let thumb_cx = if checked {
    switch_rect.x + switch_w - 2.0 * scale - thumb_radius
  } else {
    switch_rect.x + 2.0 * scale + thumb_radius
  }
  let thumb_cy = switch_rect.y + switch_h * 0.5
  let thumb_rect = @math.Rect::new(
    thumb_cx - thumb_radius,
    thumb_cy - thumb_radius,
    thumb_radius * 2.0,
    thumb_radius * 2.0,
  )
  self.painter().add_rect(thumb_rect, @color.Color::bg_window(), thumb_radius)

  // Draw label text
  let text_x = rect.x + switch_w + gap
  let text_y = rect.y + (h - font_nm) * 0.5
  let text_color = if resp.hovered {
    @color.Color::text_primary()
  } else {
    @color.Color::text_body()
  }
  self
  .painter()
  .add_text(@math.Vec2::new(text_x, text_y), text, font_nm, text_color)

  (new_state, resp)
}
