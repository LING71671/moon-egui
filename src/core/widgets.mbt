///|
/// Render a read-only text label using standard theme text color.
pub fn UIContext::label(self : UIContext, text : String) -> Response {
  self.label_colored(text, @color.Color::text_primary())
}

///|
/// Render a text label with a specified custom color.
pub fn UIContext::label_colored(
  self : UIContext,
  text : String,
  color : @color.Color,
) -> Response {
  let char_w = 8.0
  let text_w = text.length().to_double() * char_w
  let w = if text_w > 20.0 { text_w } else { 20.0 }
  let h = 18.0
  let (_id, rect, resp) = self.allocate_space(@math.Vec2::new(w, h))
  let text_pos = @math.Vec2::new(rect.x, rect.y + 2.0)
  self.draw_list.add_text(text_pos, text, 14.0, color)
  resp
}

///|
/// Render an interactive button.
/// Automatically handles hover, press, and click interactions with modern dark-mode styling.
pub fn UIContext::button(self : UIContext, text : String) -> Response {
  let char_w = 8.0
  let text_w = text.length().to_double() * char_w
  let w = if text_w + 28.0 > 64.0 { text_w + 28.0 } else { 64.0 }
  let h = 32.0
  let (_id, rect, resp) = self.allocate_space(@math.Vec2::new(w, h))

  let bg_color = if resp.pressed {
    @color.Color::accent_primary()
  } else if resp.hovered {
    @color.Color::bg_hover()
  } else {
    @color.Color::bg_surface()
  }

  let border_color = if resp.pressed {
    @color.Color::accent_hover()
  } else if resp.hovered {
    @color.Color::accent_primary()
  } else {
    @color.Color::border_muted()
  }

  let text_color = if resp.pressed || resp.hovered {
    @color.Color::white()
  } else {
    @color.Color::text_primary()
  }

  self.draw_list.add_rect(rect, bg_color, 4.0)
  self.draw_list.add_rect_stroke(rect, border_color, 1.0, 4.0)

  let text_x = rect.x + (rect.w - text_w) * 0.5
  let text_y = rect.y + (rect.h - 14.0) * 0.5
  self.draw_list.add_text(
    @math.Vec2::new(text_x, text_y),
    text,
    14.0,
    text_color,
  )
  resp
}

///|
/// Render an emphasized call-to-action primary button using accent colors.
pub fn UIContext::button_primary(self : UIContext, text : String) -> Response {
  let char_w = 8.0
  let text_w = text.length().to_double() * char_w
  let w = if text_w + 28.0 > 64.0 { text_w + 28.0 } else { 64.0 }
  let h = 32.0
  let (_id, rect, resp) = self.allocate_space(@math.Vec2::new(w, h))

  let bg_color = if resp.pressed {
    @color.Color::bg_active()
  } else if resp.hovered {
    @color.Color::accent_hover()
  } else {
    @color.Color::accent_primary()
  }

  let border_color = if resp.hovered {
    @color.Color::white()
  } else {
    @color.Color::accent_hover()
  }

  self.draw_list.add_rect(rect, bg_color, 4.0)
  self.draw_list.add_rect_stroke(rect, border_color, 1.0, 4.0)

  let text_x = rect.x + (rect.w - text_w) * 0.5
  let text_y = rect.y + (rect.h - 14.0) * 0.5
  self.draw_list.add_text(
    @math.Vec2::new(text_x, text_y),
    text,
    14.0,
    @color.Color::white(),
  )
  resp
}

///|
/// Render a full-width horizontal divider line.
pub fn UIContext::separator(self : UIContext) -> Unit {
  let w = self.available_width
  let h = 9.0
  let (_id, rect, _resp) = self.allocate_space(@math.Vec2::new(w, h))
  let y = rect.y + 4.0
  self.draw_list.add_line(
    @math.Vec2::new(rect.x, y),
    @math.Vec2::new(rect.x + rect.w, y),
    @color.Color::border_muted(),
    1.0,
  )
}

///|
/// Insert vertical spacing advancing the cursor downwards.
pub fn UIContext::spacer(self : UIContext, height : Double) -> Unit {
  self.advance_cursor(@math.Vec2::new(0.0, height))
}

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
  let char_w = 8.0
  let text_w = text.length().to_double() * char_w
  let w = box_size + gap + text_w
  let h = 22.0
  let (_id, rect, resp) = self.allocate_space(@math.Vec2::new(w, h))
  let new_state = if resp.clicked { !checked } else { checked }

  let box_rect = @math.Rect::new(
    rect.x,
    rect.y + (h - box_size) * 0.5,
    box_size,
    box_size,
  )

  if checked {
    self.draw_list.add_rect(box_rect, @color.Color::accent_primary(), 3.0)
    let inner = box_rect.shrink(4.0)
    self.draw_list.add_rect(inner, @color.Color::white(), 2.0)
  } else {
    let box_bg = if resp.hovered {
      @color.Color::bg_hover()
    } else {
      @color.Color::bg_window()
    }
    let box_border = if resp.hovered {
      @color.Color::accent_primary()
    } else {
      @color.Color::border_muted()
    }
    self.draw_list.add_rect(box_rect, box_bg, 3.0)
    self.draw_list.add_rect_stroke(box_rect, box_border, 1.0, 3.0)
  }

  let text_x = rect.x + box_size + gap
  let text_y = rect.y + (h - 14.0) * 0.5
  let text_color = if resp.hovered {
    @color.Color::white()
  } else {
    @color.Color::text_primary()
  }
  self.draw_list.add_text(
    @math.Vec2::new(text_x, text_y),
    text,
    14.0,
    text_color,
  )

  (new_state, resp)
}
