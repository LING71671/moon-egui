///|
/// Render an interactive toggle checkbox.
/// Returns a tuple of (new_checked_state, response).
pub fn UIContext::checkbox(
  self : UIContext,
  text : String,
  checked : Bool,
) -> (Bool, Response) {
  let box_size = 18.0
  let gap = 8.0
  let text_size = self.measure_text(text, 14.0)
  let w = box_size + gap + text_size.x
  let h = 22.0
  let (_id, rect, resp) = self.allocate_space(@math.Vec2::new(w, h))
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

  if checked {
    self.draw_list.add_rect(box_rect, @color.Color::accent_primary(), 4.0)
    self.draw_list.add_rect_stroke(
      box_rect,
      @color.Color::accent_pressed(),
      1.0,
      4.0,
    )
    let inner = box_rect.shrink(4.0)
    self.draw_list.add_rect(inner, @color.Color::white(), 2.0)
  } else {
    let box_bg = if resp.hovered {
      @color.Color::bg_subtle()
    } else {
      @color.Color::white()
    }
    let box_border = if resp.hovered {
      @color.Color::accent_primary()
    } else {
      @color.Color::border_default()
    }
    self.draw_list.add_rect(box_rect, box_bg, 4.0)
    self.draw_list.add_rect_stroke(box_rect, box_border, 1.0, 4.0)
  }

  let text_x = rect.x + box_size + gap
  let text_y = rect.y + (h - 14.0) * 0.5
  let text_color = if resp.hovered {
    @color.Color::text_primary()
  } else {
    @color.Color::text_body()
  }
  self.draw_list.add_text(
    @math.Vec2::new(text_x, text_y),
    text,
    14.0,
    text_color,
  )

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
  let circle_r = 7.0
  let gap = 8.0
  let text_size = self.measure_text(label, 13.0)
  let total_w = circle_r * 2.0 + gap + text_size.x
  let total_h = 22.0
  let (id, rect, resp) = self.allocate_space(@math.Vec2::new(total_w, total_h))
  if resp.hovered {
    self.set_cursor_icon("pointer")
  }
  self.register_focusable(id)

  let new_selected = if resp.clicked() { true } else { selected }

  let center = @math.Vec2::new(rect.x + circle_r + 1.0, rect.y + total_h * 0.5)

  let outer_color = if resp.has_focus() || selected {
    @color.Color::accent_primary()
  } else if resp.hovered() {
    @color.Color::accent_primary()
  } else {
    @color.Color::border_default()
  }

  let bg_circle_color = if resp.hovered() {
    @color.Color::bg_subtle()
  } else {
    @color.Color::white()
  }

  self.draw_list.add_circle(center, circle_r, bg_circle_color)
  self.draw_list.add_circle_stroke(center, circle_r, outer_color, 1.5)

  if selected {
    self.draw_list.add_circle(center, 3.5, @color.Color::accent_primary())
  }

  let text_pos = @math.Vec2::new(
    rect.x + circle_r * 2.0 + gap + 1.0,
    rect.y + (total_h - 13.0) * 0.5,
  )
  let text_color = if resp.hovered() {
    @color.Color::text_primary()
  } else {
    @color.Color::text_body()
  }
  self.draw_list.add_text(text_pos, label, 13.0, text_color)

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
  let switch_w = 36.0
  let switch_h = 20.0
  let gap = 8.0
  let text_size = self.measure_text(text, 14.0)
  let total_w = switch_w + gap + text_size.x
  let h = 24.0
  let (_id, rect, resp) = self.allocate_space(@math.Vec2::new(total_w, h))
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
  self.draw_list.add_rect(switch_rect, bg_color, switch_h * 0.5)

  // Draw sliding thumb circle
  let thumb_radius = (switch_h - 4.0) * 0.5
  let thumb_cx = if checked {
    switch_rect.x + switch_w - 2.0 - thumb_radius
  } else {
    switch_rect.x + 2.0 + thumb_radius
  }
  let thumb_cy = switch_rect.y + switch_h * 0.5
  let thumb_rect = @math.Rect::new(
    thumb_cx - thumb_radius,
    thumb_cy - thumb_radius,
    thumb_radius * 2.0,
    thumb_radius * 2.0,
  )
  self.draw_list.add_rect(thumb_rect, @color.Color::white(), thumb_radius)

  // Draw label text
  let text_x = rect.x + switch_w + gap
  let text_y = rect.y + (h - 14.0) * 0.5
  let text_color = if resp.hovered {
    @color.Color::text_primary()
  } else {
    @color.Color::text_body()
  }
  self.draw_list.add_text(
    @math.Vec2::new(text_x, text_y),
    text,
    14.0,
    text_color,
  )

  (new_state, resp)
}
