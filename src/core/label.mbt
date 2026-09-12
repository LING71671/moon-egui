///|
/// Render a read-only text label using Studio Light slate text color.
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
  let font_sz = self.style.font_normal * self.style.scale
  let text_size = self.measure_text(text, font_sz)
  let w = if text_size.x > 20.0 { text_size.x } else { 20.0 }
  let h = 18.0
  let (_id, rect, resp) = self.allocate_space(@math.Vec2::new(w, h))
  let text_pos = @math.Vec2::new(rect.x, rect.y + (h - font_sz) * 0.5)
  self.draw_list.add_text(text_pos, text, font_sz, color)
  resp
}

///|
/// Render a full-width horizontal divider line.
pub fn UIContext::separator(self : UIContext) -> Unit {
  let w = self.available_width()
  let h = 9.0
  let (_id, rect, _resp) = self.allocate_space(@math.Vec2::new(w, h))
  let y = rect.y + 4.5
  self.draw_list.add_line(
    @math.Vec2::new(rect.x, y),
    @math.Vec2::new(rect.x + rect.w, y),
    @color.Color::border_muted(),
    1.0,
  )
}

///|
/// Insert spacing advancing the cursor along the active layout direction.
pub fn UIContext::spacer(self : UIContext, amount : Double) -> Unit {
  let is_horiz = match self.layout.current_scope() {
    Some(s) => s.dir == LeftToRight
    None => false
  }
  if is_horiz {
    self.advance_cursor(@math.Vec2::new(amount, 0.0))
  } else {
    self.advance_cursor(@math.Vec2::new(0.0, amount))
  }
}
