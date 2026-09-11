///|
/// Render a floating window container with title bar, border, and clipped content region.
/// The layout cursor inside the content closure is local to the window interior.
pub fn UIContext::window(
  self : UIContext,
  title : String,
  pos : @math.Vec2,
  size : @math.Vec2,
  content : (UIContext) -> Unit,
) -> Unit {
  let title_bar_h = 28.0
  let window_rect = @math.Rect::new(pos.x, pos.y, size.x, size.y)
  let title_bar_rect = @math.Rect::new(pos.x, pos.y, size.x, title_bar_h)

  if self.is_hovered(window_rect) {
    self.wants_capture_mouse = true
  }

  // 1. Draw Window Background & Border
  let bg_color = @color.Color::bg_window()
  let border_color = @color.Color::border_muted()
  let header_color = @color.Color::bg_surface()

  self.draw_list.add_rect(window_rect, bg_color, 8.0)
  self.draw_list.add_rect_stroke(window_rect, border_color, 1.0, 8.0)

  // 2. Draw Title Bar Header
  self.draw_list.add_rect(title_bar_rect, header_color, 8.0)
  let filler_rect = @math.Rect::new(
    pos.x,
    pos.y + title_bar_h - 4.0,
    size.x,
    4.0,
  )
  self.draw_list.add_rect(filler_rect, header_color, 0.0)
  self.draw_list.add_line(
    @math.Vec2::new(pos.x, pos.y + title_bar_h),
    @math.Vec2::new(pos.x + size.x, pos.y + title_bar_h),
    border_color,
    1.0,
  )

  // 3. Draw Title Text
  self.draw_list.add_text(
    @math.Vec2::new(pos.x + 12.0, pos.y + 7.0),
    title,
    13.0,
    @color.Color::text_primary(),
  )

  // 4. Content Area with Scissor Clipping & Scoped Layout
  let pad = 12.0
  let content_x = pos.x + pad
  let content_y = pos.y + title_bar_h + pad
  let content_w = size.x - pad * 2.0
  let content_h = size.y - title_bar_h - pad * 2.0

  let clip_rect = @math.Rect::new(content_x, content_y, content_w, content_h)
  self.push_clip(clip_rect)

  // Save current context layout state
  let prev_cursor = self.cursor
  let prev_avail_w = self.available_width

  self.cursor = @math.Vec2::new(content_x, content_y)
  self.available_width = content_w

  content(self)

  // Restore context state and pop clip
  self.cursor = prev_cursor
  self.available_width = prev_avail_w
  self.pop_clip()
}
