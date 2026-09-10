///|
/// Render an interactive button with an explicitly specified size.
pub fn UIContext::button_sized(
  self : UIContext,
  text : String,
  size : @math.Vec2,
) -> Response {
  let char_w = 8.0
  let text_w = text.length().to_double() * char_w
  let (_id, rect, resp) = self.allocate_space(size)

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
    13.0,
    text_color,
  )
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
  self.button_sized(text, @math.Vec2::new(w, h))
}

///|
/// Render an emphasized primary button with an explicitly specified size.
pub fn UIContext::button_primary_sized(
  self : UIContext,
  text : String,
  size : @math.Vec2,
) -> Response {
  let char_w = 8.0
  let text_w = text.length().to_double() * char_w
  let (_id, rect, resp) = self.allocate_space(size)

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
    13.0,
    @color.Color::white(),
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
  self.button_primary_sized(text, @math.Vec2::new(w, h))
}

///|
/// Render an interactive color preview button.
/// Clicking it returns clicked in response to toggle a color picker.
pub fn UIContext::color_button(
  self : UIContext,
  _id_str : String,
  color : @color.Color,
) -> (Bool, Response) {
  let size = 22.0
  let (_id, rect, resp) = self.allocate_space(@math.Vec2::new(size, size))

  let btn_rect = @math.Rect::new(rect.x, rect.y, size, size)
  let border_color = if resp.pressed {
    @color.Color::white()
  } else if resp.hovered {
    @color.Color::accent_primary()
  } else {
    @color.Color::border_muted()
  }

  // Draw color swatch
  self.draw_list.add_rect(btn_rect, color, 4.0)
  self.draw_list.add_rect_stroke(btn_rect, border_color, 1.5, 4.0)

  (resp.clicked, resp)
}

///|
/// Render an interactive button with a desktop-grade shortcut badge (e.g. "⌘S" or "Enter").
pub fn UIContext::button_with_shortcut(
  self : UIContext,
  text : String,
  shortcut : String,
) -> Response {
  let char_w = 8.0
  let text_w = text.length().to_double() * char_w
  let kbd_w = shortcut.length().to_double() * 7.0 + 12.0
  let total_w = text_w + kbd_w + 32.0
  let w = if total_w > 80.0 { total_w } else { 80.0 }
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

  // Draw Main Text
  let text_x = rect.x + 10.0
  let text_y = rect.y + (rect.h - 14.0) * 0.5
  self.draw_list.add_text(
    @math.Vec2::new(text_x, text_y),
    text,
    13.0,
    text_color,
  )

  // Draw Shortcut Badge Pill
  let kbd_rect = @math.Rect::new(
    rect.x + rect.w - kbd_w - 8.0,
    rect.y + (rect.h - 18.0) * 0.5,
    kbd_w,
    18.0,
  )
  let kbd_bg = if resp.pressed || resp.hovered {
    @color.Color::accent_hover()
  } else {
    @color.Color::bg_hover()
  }
  let kbd_col = if resp.pressed || resp.hovered {
    @color.Color::white()
  } else {
    @color.Color::text_secondary()
  }
  self.draw_list.add_rect(kbd_rect, kbd_bg, 3.0)
  self.draw_list.add_text(
    @math.Vec2::new(kbd_rect.x + 6.0, kbd_rect.y + 2.0),
    shortcut,
    11.0,
    kbd_col,
  )

  resp
}
