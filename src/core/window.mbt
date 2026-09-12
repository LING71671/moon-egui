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
///
/// `constrain_to` clamps the window while it is dragged, so a panel cannot be
/// dragged out of the viewport it belongs to.
///
/// Windows are composited in stacking order rather than call order: pressing
/// anywhere inside a window raises it above its siblings, and the content is
/// drawn into a batch that is flushed at `end_frame`. A window is therefore
/// always on top of the main layer, regardless of where in the frame it was
/// declared.
pub fn UIContext::window(
  self : UIContext,
  title : String,
  pos : @math.Vec2,
  size : @math.Vec2,
  content : (UIContext) -> Unit,
  id_salt? : String,
  constrain_to? : @math.Rect,
) -> Response {
  let scale = self.style.scale
  let title_bar_h = self.style.window_title_bar_h * scale
  let id = self.id_stack.derive_id("window::" + id_salt.unwrap_or(title))

  // A floating window is not subject to the scissor clip of whatever container
  // declared it - neither when it draws nor when it tests the pointer. The
  // caller's clip stack is suspended for this whole body and restored at the
  // end, so the window's own content clip is the only one that applies.
  let saved_draw_list = self.layers.draw_list()
  let saved_clip : Array[@math.Rect] = []
  for clip in self.layers.clip_stack() {
    saved_clip.push(clip)
  }
  self.layers.clip_stack().clear()

  let mut win_pos = self.get_window_pos(id, pos)
  let mut window_rect = @math.Rect::new(win_pos.x, win_pos.y, size.x, size.y)
  let mut title_bar_rect = @math.Rect::new(
    win_pos.x,
    win_pos.y,
    size.x,
    title_bar_h,
  )

  // 1. Stacking. Hit testing has to know which window is on top before any of
  // them can be tested, and a press anywhere inside raises the window.
  self.windows.set_active_z(self.window_z(id))
  let window_hovered = self.is_hovered(window_rect)
  let bar_hovered = self.is_hovered(title_bar_rect)

  if window_hovered && self.input.mouse_pressed {
    self.raise_window(id)
    self.windows.set_active_z(self.window_z(id))
  }

  // 2. Title bar interaction: grab on press, then follow the pointer delta.
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
    if constrain_to is Some(bounds) {
      win_pos = clamp_window_pos(win_pos, size, bounds)
    }
    self.set_window_pos(id, win_pos)
    window_rect = @math.Rect::new(win_pos.x, win_pos.y, size.x, size.y)
    title_bar_rect = @math.Rect::new(win_pos.x, win_pos.y, size.x, title_bar_h)
  }

  if is_active && self.input.mouse_released {
    self.set_active_id(Id::zero())
  }

  if window_hovered {
    self.set_wants_capture_mouse(true)
  }

  // Publish the settled rect so the next frame can resolve occlusion against
  // it, then draw into a dedicated batch.
  self.windows.record_rect(window_rect, self.windows.active_z())

  let batch = self.window_batch(id)
  batch.clear()
  self.windows.mark_drawn(id)
  self.layers.set_draw_list(batch)

  let x = win_pos.x
  let y = win_pos.y

  // 3. Draw Window Background & Border
  let bg_color = @color.Color::bg_window()
  let border_color = @color.Color::border_muted()
  let header_color = @color.Color::bg_surface()

  let win_radius = self.style.radius_md
  let font_sz = self.style.font_normal
  let painter = self.painter()
  painter.add_rect(window_rect, bg_color, win_radius)
  painter.add_rect_stroke(window_rect, border_color, 1.0, win_radius)

  // 4. Draw Title Bar Header
  painter.add_rect(title_bar_rect, header_color, win_radius)
  let filler_rect = @math.Rect::new(x, y + title_bar_h - 4.0, size.x, 4.0)
  painter.add_rect(filler_rect, header_color, 0.0)
  painter.add_line(
    @math.Vec2::new(x, y + title_bar_h),
    @math.Vec2::new(x + size.x, y + title_bar_h),
    border_color,
    1.0,
  )

  // 5. Draw Title Text
  painter.add_text(
    @math.Vec2::new(x + 12.0, y + 7.0),
    title,
    font_sz,
    @color.Color::text_primary(),
  )

  // 6. Content Area with Scissor Clipping & Scoped Layout
  let pad = 12.0
  let content_x = x + pad
  let content_y = y + title_bar_h + pad
  let content_w = size.x - pad * 2.0
  let content_h = size.y - title_bar_h - pad * 2.0

  let clip_rect = @math.Rect::new(content_x, content_y, content_w, content_h)
  self.push_clip(clip_rect)

  // Save current context layout state
  let prev_cursor = self.cursor()
  let prev_avail_w = self.available_width()

  self.set_cursor(@math.Vec2::new(content_x, content_y))
  self.set_available_width(content_w)

  content(self)

  // Restore context state and pop clip
  self.set_cursor(prev_cursor)
  self.set_available_width(prev_avail_w)
  self.pop_clip()

  self.layers.set_draw_list(saved_draw_list)
  self.layers.clip_stack().clear()
  for clip in saved_clip {
    self.layers.clip_stack().push(clip)
  }
  self.windows.set_active_z(-1)

  Response::with_focus(
    id, window_rect, window_hovered, clicked, is_dragging, is_dragging, false, false,
    false,
  )
}

///|
/// Keep a window fully inside `bounds`. When the bounds are smaller than the
/// window the left/top edge wins, so the title bar always stays reachable.
fn clamp_window_pos(
  pos : @math.Vec2,
  size : @math.Vec2,
  bounds : @math.Rect,
) -> @math.Vec2 {
  let max_x = bounds.x + bounds.w - size.x
  let max_y = bounds.y + bounds.h - size.y
  let x = if pos.x < bounds.x {
    bounds.x
  } else if pos.x > max_x {
    max_x
  } else {
    pos.x
  }
  let y = if pos.y < bounds.y {
    bounds.y
  } else if pos.y > max_y {
    max_y
  } else {
    pos.y
  }
  @math.Vec2::new(x, y)
}
