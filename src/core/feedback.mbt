///|
/// Render a styled progress bar with progress fill and label.
pub fn UIContext::progress_bar(
  self : UIContext,
  fraction : Double,
  text : String,
) -> Response {
  let scale = self.style.scale
  let w = self.available_width()
  let h = self.style.progress_bar_h * scale
  let (_id, rect, resp) = self.allocate_space(@math.Vec2::new(w, h))

  let clamped_pct = if fraction < 0.0 {
    0.0
  } else if fraction > 1.0 {
    1.0
  } else {
    fraction
  }

  let bar_radius = self.style.radius_sm * scale
  self.draw_list.add_rect(rect, @color.Color::bg_surface(), bar_radius)
  self.draw_list.add_rect_stroke(
    rect,
    @color.Color::border_muted(),
    1.0,
    bar_radius,
  )

  let fill_w = rect.w * clamped_pct
  if fill_w > 0.0 {
    let fill_rect = @math.Rect::new(rect.x, rect.y, fill_w, rect.h)
    self.draw_list.add_rect(
      fill_rect,
      @color.Color::accent_primary(),
      bar_radius,
    )
  }

  let display_text = if text.is_empty() {
    (clamped_pct * 100.0).to_int().to_string() + "%"
  } else {
    text
  }

  let font_sz = self.style.font_small * scale
  let text_size = self.measure_text(display_text, font_sz)
  let text_x = rect.x + (rect.w - text_size.x) * 0.5
  let text_y = rect.y + (rect.h - font_sz) * 0.5
  let text_color = if clamped_pct >= 0.5 {
    @color.Color::text_inverse()
  } else {
    @color.Color::text_primary()
  }
  self.draw_list.add_text(
    @math.Vec2::new(text_x, text_y),
    display_text,
    font_sz,
    text_color,
  )

  resp
}

///|
/// Render an on-hover floating tooltip bubble at cursor position.
/// Drawn on the foreground layer so it is never clipped away by the container
/// that owns the hovered widget.
pub fn UIContext::tooltip(self : UIContext, text : String) -> Unit {
  let scale = self.style.scale
  let font_size = self.style.font_small * scale
  let pad_x = self.style.tooltip_pad_x * scale
  let pad_y = self.style.tooltip_pad_y * scale
  let text_size = self.measure_text(text, font_size)
  let tip_w = text_size.x + pad_x * 2.0
  let tip_h = text_size.y + pad_y * 2.0

  let mouse = self.input.mouse_pos
  let mut tip_x = mouse.x + 12.0 * scale
  let tip_y = mouse.y + 12.0 * scale

  let vp_w = match self.layers.current_clip() {
    Some(c) => c.w
    None =>
      if self.available_width() > 0.0 {
        self.available_width()
      } else {
        800.0
      }
  }
  if tip_x + tip_w > vp_w {
    tip_x = mouse.x - tip_w - 4.0 * scale
    if tip_x < 4.0 * scale {
      tip_x = 4.0 * scale
    }
  }
  let tip_rect = @math.Rect::new(tip_x, tip_y, tip_w, tip_h)

  self.begin_foreground()

  let tip_radius = self.style.tooltip_radius * scale
  // Floating bubble with dark background & subtle border
  self.draw_list.add_rect(tip_rect, @color.Color::bg_inverse(), tip_radius)
  self.draw_list.add_rect_stroke(
    tip_rect,
    @color.Color::border_muted(),
    1.0,
    tip_radius,
  )
  self.draw_list.add_text(
    @math.Vec2::new(tip_rect.x + pad_x, tip_rect.y + pad_y),
    text,
    font_size,
    @color.Color::text_inverse(),
  )

  self.end_foreground()
}
