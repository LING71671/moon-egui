///|
/// Render an interactive button with modern Studio Light porcelain aesthetic and 1.5px physical mechanical actuation travel.
/// Supports optional labeled parameters:
/// - `shortcut~`: e.g. "⌘S" or "Esc", renders an Apple-grade chiclet keycap badge.
/// - `primary~`: renders a high-contrast cold cobalt blue emphasize button.
/// - `size~`: overrides automatic dimension calculation.
pub fn UIContext::button(
  self : UIContext,
  text : String,
  shortcut? : String = "",
  primary? : Bool = false,
  size? : @math.Vec2 = @math.Vec2::zero(),
) -> Response {
  let scale = self.style.scale
  let font_size = self.style.font_normal * scale
  let text_size = self.measure_text(text, font_size)
  let text_w = text_size.x
  let has_shortcut = shortcut.length() > 0
  let kbd_font_size = self.style.font_small * scale
  let kbd_w = if has_shortcut {
    self.measure_text(shortcut, kbd_font_size).x + 14.0 * scale
  } else {
    0.0
  }

  let min_w = if has_shortcut {
    (self.style.button_min_w + 20.0) * scale
  } else {
    self.style.button_min_w * scale
  }
  let pad_w = if has_shortcut {
    36.0 * scale
  } else {
    self.style.button_pad_x * 2.0 * scale
  }
  let content_w = if has_shortcut {
    text_w + kbd_w + pad_w
  } else {
    text_w + pad_w
  }
  let auto_w = if content_w > min_w { content_w } else { min_w }
  let w = if size.x > 0.0 { size.x } else { auto_w }
  let h = if size.y > 0.0 { size.y } else { self.style.button_h * scale }

  let (_id, rect, resp) = self.allocate_space(@math.Vec2::new(w, h))
  if resp.hovered {
    self.set_cursor_icon("pointer")
  }

  // 1.5px Mechanical Press Travel & Tactile Actuation Displacement
  let press_offset = if resp.pressed { 1.5 * scale } else { 0.0 }
  let draw_rect = @math.Rect::new(
    rect.x,
    rect.y + press_offset,
    rect.w,
    rect.h - press_offset,
  )

  // Studio Light Lunar Porcelain Palette
  let bg_color = if primary {
    if resp.pressed {
      @color.Color::accent_pressed() // Deep cobalt under load
    } else if resp.hovered {
      @color.Color::accent_hover() // Vibrant azure excitation
    } else {
      @color.Color::accent_primary() // Precision cold cobalt base
    }
  } else if resp.pressed {
    @color.Color::bg_surface() // Sunken active porcelain
  } else if resp.hovered {
    @color.Color::bg_subtle() // Floating porcelain highlight
  } else {
    @color.Color::bg_window() // Pure bone porcelain surface
  }

  let border_color = if primary {
    if resp.pressed {
      @color.Color::accent_deep()
    } else {
      @color.Color::accent_pressed()
    }
  } else if resp.pressed {
    @color.Color::border_strong() // Compressed border
  } else if resp.hovered {
    @color.Color::accent_primary() // Precision cobalt halo
  } else {
    @color.Color::border_default() // Milled cold-slate hairline
  }

  let text_color = if primary {
    @color.Color::text_inverse()
  } else if resp.pressed {
    @color.Color::text_strong()
  } else if resp.hovered {
    @color.Color::text_primary()
  } else {
    @color.Color::text_body()
  }

  let radius = self.style.button_radius * scale
  self.draw_list.add_rect(draw_rect, bg_color, radius)
  self.draw_list.add_rect_stroke(draw_rect, border_color, 1.0, radius)

  if has_shortcut {
    // Left-align text when shortcut badge exists
    let text_x = draw_rect.x + 12.0 * scale
    let text_y = draw_rect.y + (draw_rect.h - font_size) * 0.5
    self.draw_list.add_text(
      @math.Vec2::new(text_x, text_y),
      text,
      font_size,
      text_color,
    )

    // Chiclet Shortcut Badge (synchronously moves down on press)
    let kbd_h = 18.0 * scale
    let kbd_rect = @math.Rect::new(
      draw_rect.x + draw_rect.w - kbd_w - 10.0 * scale,
      draw_rect.y + (draw_rect.h - kbd_h) * 0.5,
      kbd_w,
      kbd_h,
    )
    let (kbd_bg, kbd_col) = if primary {
      (@color.Color::accent_highlight(), @color.Color::text_inverse())
    } else {
      (
        if resp.pressed {
          @color.Color::border_muted()
        } else if resp.hovered {
          @color.Color::bg_active()
        } else {
          @color.Color::bg_surface()
        },
        if resp.hovered {
          @color.Color::text_primary()
        } else {
          @color.Color::text_muted()
        },
      )
    }
    self.draw_list.add_rect(kbd_rect, kbd_bg, self.style.radius_sm * scale)
    let sc_w = self.measure_text(shortcut, kbd_font_size).x
    let kbd_text_x = kbd_rect.x + (kbd_rect.w - sc_w) * 0.5
    let kbd_text_y = kbd_rect.y + (kbd_rect.h - kbd_font_size) * 0.5
    self.draw_list.add_text(
      @math.Vec2::new(kbd_text_x, kbd_text_y),
      shortcut,
      kbd_font_size,
      kbd_col,
    )
  } else {
    // Center-align text in standard button
    let text_x = draw_rect.x + (draw_rect.w - text_w) * 0.5
    let text_y = draw_rect.y + (draw_rect.h - font_size) * 0.5
    self.draw_list.add_text(
      @math.Vec2::new(text_x, text_y),
      text,
      font_size,
      text_color,
    )
  }

  resp
}

///|
/// Render an interactive button with an explicitly specified size.
pub fn UIContext::button_sized(
  self : UIContext,
  text : String,
  size : @math.Vec2,
) -> Response {
  self.button(text, size~)
}

///|
/// Render an emphasized primary button with an explicitly specified size.
pub fn UIContext::button_primary_sized(
  self : UIContext,
  text : String,
  size : @math.Vec2,
) -> Response {
  self.button(text, primary=true, size~)
}

///|
/// Render an emphasized call-to-action primary button using accent colors.
pub fn UIContext::button_primary(self : UIContext, text : String) -> Response {
  self.button(text, primary=true)
}

///|
/// Render an interactive button with a desktop-grade shortcut badge (e.g. "⌘S" or "Esc").
pub fn UIContext::button_with_shortcut(
  self : UIContext,
  text : String,
  shortcut : String,
) -> Response {
  self.button(text, shortcut~)
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
  if resp.hovered {
    self.set_cursor_icon("pointer")
  }

  let press_offset = if resp.pressed { 1.0 } else { 0.0 }
  let btn_rect = @math.Rect::new(
    rect.x,
    rect.y + press_offset,
    size,
    size - press_offset,
  )
  let border_color = if resp.pressed {
    @color.Color::accent_primary()
  } else if resp.hovered {
    @color.Color::accent_primary()
  } else {
    @color.Color::border_default()
  }

  // Draw color swatch with clean white rim
  let swatch_radius = self.style.text_edit_radius
  self.draw_list.add_rect(btn_rect, color, swatch_radius)
  self.draw_list.add_rect_stroke(btn_rect, border_color, 1.5, swatch_radius)

  (resp.clicked, resp)
}
