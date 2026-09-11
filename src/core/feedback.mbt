///|
/// Render a styled progress bar with progress fill and label.
pub fn UIContext::progress_bar(
  self : UIContext,
  fraction : Double,
  text : String,
) -> Response {
  let w = self.available_width
  let h = 18.0
  let (_id, rect, resp) = self.allocate_space(@math.Vec2::new(w, h))

  let clamped_pct = if fraction < 0.0 {
    0.0
  } else if fraction > 1.0 {
    1.0
  } else {
    fraction
  }

  self.draw_list.add_rect(rect, @color.Color::bg_surface(), 4.0)
  self.draw_list.add_rect_stroke(rect, @color.Color::border_muted(), 1.0, 4.0)

  let fill_w = rect.w * clamped_pct
  if fill_w > 0.0 {
    let fill_rect = @math.Rect::new(rect.x, rect.y, fill_w, rect.h)
    self.draw_list.add_rect(fill_rect, @color.Color::accent_primary(), 4.0)
  }

  let display_text = if text.is_empty() {
    (clamped_pct * 100.0).to_int().to_string() + "%"
  } else {
    text
  }

  let text_size = self.measure_text(display_text, 11.0)
  let text_x = rect.x + (rect.w - text_size.x) * 0.5
  let text_y = rect.y + (rect.h - 11.0) * 0.5
  let text_color = if clamped_pct >= 0.5 {
    @color.Color::white()
  } else {
    @color.Color::text_primary()
  }
  self.draw_list.add_text(
    @math.Vec2::new(text_x, text_y),
    display_text,
    11.0,
    text_color,
  )

  resp
}

///|
/// Render an on-hover floating tooltip bubble at cursor position.
/// Drawn on the foreground layer so it is never clipped away by the container
/// that owns the hovered widget.
pub fn UIContext::tooltip(self : UIContext, text : String) -> Unit {
  let font_size = 12.0
  let pad_x = 8.0
  let pad_y = 4.0
  let text_size = self.measure_text(text, font_size)
  let tip_w = text_size.x + pad_x * 2.0
  let tip_h = text_size.y + pad_y * 2.0

  let mouse = self.input.mouse_pos
  let tip_rect = @math.Rect::new(mouse.x + 12.0, mouse.y + 12.0, tip_w, tip_h)

  self.begin_foreground()

  // Floating bubble with dark background & subtle border
  self.draw_list.add_rect(tip_rect, @color.Color::bg_window(), 4.0)
  self.draw_list.add_rect_stroke(
    tip_rect,
    @color.Color::border_muted(),
    1.0,
    4.0,
  )
  self.draw_list.add_text(
    @math.Vec2::new(tip_rect.x + pad_x, tip_rect.y + pad_y),
    text,
    font_size,
    @color.Color::white(),
  )

  self.end_foreground()
}
