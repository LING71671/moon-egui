// Copyright 2026 Ling71671
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

///|
/// Render a floating window container with a draggable title bar, border, and
/// clipped content region. The layout cursor inside the content closure is
/// local to the window interior.
///
/// `pos` is the initial position: from the first drag onwards the context owns
/// the position and `pos` is ignored. The window is identified by `id_salt`,
/// falling back to `title`, so two windows sharing a title need explicit salts.
pub fn UIContext::window(
  self : UIContext,
  title : String,
  pos : @math.Vec2,
  size : @math.Vec2,
  content : (UIContext) -> Unit,
  id_salt? : String,
) -> Response {
  let title_bar_h = 28.0
  let id = self.id_stack.derive_id("window::" + id_salt.unwrap_or(title))

  let mut win_pos = self.get_window_pos(id, pos)
  let mut window_rect = @math.Rect::new(win_pos.x, win_pos.y, size.x, size.y)
  let mut title_bar_rect = @math.Rect::new(
    win_pos.x,
    win_pos.y,
    size.x,
    title_bar_h,
  )

  // 1. Title bar interaction: grab on press, then follow the pointer delta.
  let bar_hovered = self.is_hovered(title_bar_rect)
  if bar_hovered && self.input.mouse_pressed {
    self.set_active_id(id)
  }

  let is_active = self.active_id() == id
  // The frame that grabs the title bar must not consume the pointer delta:
  // it measures the distance from the previous frame's position, so applying
  // it here would snap the window to the pointer instead of dragging it.
  let is_dragging = is_active &&
    self.input.mouse_down &&
    !self.input.mouse_pressed
  let clicked = is_active && self.input.mouse_released && bar_hovered

  if is_dragging {
    win_pos = win_pos.add(self.input.mouse_delta)
    self.set_window_pos(id, win_pos)
    window_rect = @math.Rect::new(win_pos.x, win_pos.y, size.x, size.y)
    title_bar_rect = @math.Rect::new(win_pos.x, win_pos.y, size.x, title_bar_h)
  }

  if is_active && self.input.mouse_released {
    self.set_active_id(Id::zero())
  }

  let window_hovered = self.is_hovered(window_rect)
  if window_hovered {
    self.wants_capture_mouse = true
  }

  let x = win_pos.x
  let y = win_pos.y

  // 2. Draw Window Background & Border
  let bg_color = @color.Color::bg_window()
  let border_color = @color.Color::border_muted()
  let header_color = @color.Color::bg_surface()

  self.draw_list.add_rect(window_rect, bg_color, 8.0)
  self.draw_list.add_rect_stroke(window_rect, border_color, 1.0, 8.0)

  // 3. Draw Title Bar Header
  self.draw_list.add_rect(title_bar_rect, header_color, 8.0)
  let filler_rect = @math.Rect::new(x, y + title_bar_h - 4.0, size.x, 4.0)
  self.draw_list.add_rect(filler_rect, header_color, 0.0)
  self.draw_list.add_line(
    @math.Vec2::new(x, y + title_bar_h),
    @math.Vec2::new(x + size.x, y + title_bar_h),
    border_color,
    1.0,
  )

  // 4. Draw Title Text
  self.draw_list.add_text(
    @math.Vec2::new(x + 12.0, y + 7.0),
    title,
    13.0,
    @color.Color::text_primary(),
  )

  // 5. Content Area with Scissor Clipping & Scoped Layout
  let pad = 12.0
  let content_x = x + pad
  let content_y = y + title_bar_h + pad
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

  Response::with_focus(
    id, window_rect, window_hovered, clicked, is_dragging, is_dragging, false, false,
    false,
  )
}
