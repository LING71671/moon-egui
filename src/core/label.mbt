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
