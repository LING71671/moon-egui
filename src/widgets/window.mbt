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
/// Standalone floating window container widget supporting fluent configuration.
pub struct Window {
  title : String
  pos : @math.Vec2
  size : @math.Vec2
  id_salt : String?
  constrain_to : @math.Rect?
} derive(Eq, Debug)

///|
/// Create a new window container.
pub fn Window::new(
  title : String,
  pos : @math.Vec2,
  size : @math.Vec2,
) -> Window {
  { title, pos, size, id_salt: None, constrain_to: None, }
}

///|
/// Explicitly configure a unique identification salt for distinguishing windows with matching titles.
pub fn Window::id_salt(self : Window, id_salt : String) -> Window {
  { ..self, id_salt: Some(id_salt), }
}

///|
/// Constrain window dragging within specified boundary rectangle.
pub fn Window::constrain_to(self : Window, bounds : @math.Rect) -> Window {
  { ..self, constrain_to: Some(bounds), }
}

///|
/// Show the floating window and execute content closure.
pub fn Window::show(
  self : Window,
  ctx : UIContext,
  content : (UIContext) -> Unit,
) -> Response {
  match (self.id_salt, self.constrain_to) {
    (Some(salt), Some(bounds)) =>
      window(
        ctx,
        self.title,
        self.pos,
        self.size,
        content,
        id_salt=salt,
        constrain_to=bounds,
      )
    (Some(salt), None) =>
      window(ctx, self.title, self.pos, self.size, content, id_salt=salt)
    (None, Some(bounds)) =>
      window(ctx, self.title, self.pos, self.size, content, constrain_to=bounds)
    (None, None) => window(ctx, self.title, self.pos, self.size, content)
  }
}

///|
/// Render a floating window container with a draggable title bar, border, and
/// clipped content region. The layout cursor inside the content closure is
/// local to the window interior.
pub fn window(
  ctx : UIContext,
  title : String,
  pos : @math.Vec2,
  size : @math.Vec2,
  content : (UIContext) -> Unit,
  id_salt? : String,
  constrain_to? : @math.Rect,
) -> Response {
  let scale = ctx.style.scale
  let title_bar_h = (ctx.style.control_h_sm + ctx.style.spacing_xs) * scale
  let id = ctx.id_stack.derive_id("window::" + id_salt.unwrap_or(title))
  ctx.register_focusable(id)

  let saved_draw_list = ctx.layers.draw_list()
  let saved_clip : Array[@math.Rect] = []
  for clip in ctx.layers.clip_stack() {
    saved_clip.push(clip)
  }
  ctx.layers.clip_stack().clear()

  let mut win_pos = ctx.get_window_pos(id, pos)
  let mut window_rect = @math.Rect::new(win_pos.x, win_pos.y, size.x, size.y)
  let mut title_bar_rect = @math.Rect::new(
    win_pos.x,
    win_pos.y,
    size.x,
    title_bar_h,
  )

  ctx.windows.set_active_z(ctx.window_z(id))
  let window_hovered = ctx.is_hovered(window_rect)
  let bar_hovered = ctx.is_hovered(title_bar_rect)

  if window_hovered && ctx.input.mouse_pressed {
    ctx.raise_window(id)
    ctx.windows.set_active_z(ctx.window_z(id))
  }

  if bar_hovered && ctx.input.mouse_pressed {
    ctx.set_active_id(id)
    ctx.request_focus(id)
  }

  let is_active = ctx.active_id() == id
  let is_dragging = is_active &&
    ctx.input.mouse_down &&
    !ctx.input.mouse_pressed
  let clicked = is_active && ctx.input.mouse_released && bar_hovered

  // The title bar is the drag handle: advertise it, and keep the cursor while
  // the drag continues even after the pointer has left the bar.
  if bar_hovered || is_active {
    ctx.set_cursor_icon("move")
  }

  if is_dragging {
    win_pos = win_pos.add(ctx.input.mouse_delta)
    if constrain_to is Some(bounds) {
      win_pos = clamp_window_pos(win_pos, size, bounds)
    }
    ctx.set_window_pos(id, win_pos)
    window_rect = @math.Rect::new(win_pos.x, win_pos.y, size.x, size.y)
    title_bar_rect = @math.Rect::new(win_pos.x, win_pos.y, size.x, title_bar_h)
  }

  // Keyboard move: with the window focused, the arrows nudge it inside the
  // same constraint bounds the mouse drag uses.
  if ctx.has_focus(id) {
    let kb_step = 8.0 * scale
    let mut dx = 0.0
    let mut dy = 0.0
    if ctx.input.key_pressed(Key::ArrowRight) {
      dx = kb_step
      ctx.input.consume_key(Key::ArrowRight)
    }
    if ctx.input.key_pressed(Key::ArrowLeft) {
      dx = -kb_step
      ctx.input.consume_key(Key::ArrowLeft)
    }
    if ctx.input.key_pressed(Key::ArrowDown) {
      dy = kb_step
      ctx.input.consume_key(Key::ArrowDown)
    }
    if ctx.input.key_pressed(Key::ArrowUp) {
      dy = -kb_step
      ctx.input.consume_key(Key::ArrowUp)
    }
    if dx != 0.0 || dy != 0.0 {
      win_pos = win_pos.add(@math.Vec2::new(dx, dy))
      if constrain_to is Some(bounds) {
        win_pos = clamp_window_pos(win_pos, size, bounds)
      }
      ctx.set_window_pos(id, win_pos)
      window_rect = @math.Rect::new(win_pos.x, win_pos.y, size.x, size.y)
      title_bar_rect = @math.Rect::new(
        win_pos.x,
        win_pos.y,
        size.x,
        title_bar_h,
      )
    }
  }

  if is_active && ctx.input.mouse_released {
    ctx.set_active_id(@core.Id::zero())
  }

  if window_hovered {
    ctx.set_wants_capture_mouse(true)
  }

  ctx.windows.record_rect(window_rect, ctx.windows.active_z())

  let batch = ctx.window_batch(id)
  batch.clear()
  ctx.windows.mark_drawn(id)
  ctx.layers.set_draw_list(batch)

  let x = win_pos.x
  let y = win_pos.y

  let bg_color = @color.Color::bg_window()
  let border_color = @color.Color::border_muted()
  let header_color = @color.Color::bg_surface()

  let win_radius = ctx.style.radius_md
  let font_sz = ctx.style.font_normal
  let painter = ctx.painter()
  painter.add_rect(window_rect, bg_color, win_radius)
  painter.add_rect_stroke(window_rect, border_color, 1.0, win_radius)

  painter.add_rect(title_bar_rect, header_color, win_radius)
  let filler_rect = @math.Rect::new(x, y + title_bar_h - 4.0, size.x, 4.0)
  painter.add_rect(filler_rect, header_color, 0.0)
  painter.add_line(
    @math.Vec2::new(x, y + title_bar_h),
    @math.Vec2::new(x + size.x, y + title_bar_h),
    border_color,
    1.0,
  )

  painter.add_text(
    @math.Vec2::new(x + 12.0, y + 7.0),
    title,
    font_sz,
    @color.Color::text_primary(),
  )

  let pad = 12.0
  let content_x = x + pad
  let content_y = y + title_bar_h + pad
  let content_w = size.x - pad * 2.0
  let content_h = size.y - title_bar_h - pad * 2.0

  let clip_rect = @math.Rect::new(content_x, content_y, content_w, content_h)
  ctx.push_clip(clip_rect)

  let prev_cursor = ctx.cursor()
  let prev_avail_w = ctx.available_width()

  ctx.set_cursor(@math.Vec2::new(content_x, content_y))
  ctx.set_available_width(content_w)

  content(ctx)

  ctx.set_cursor(prev_cursor)
  ctx.set_available_width(prev_avail_w)
  ctx.pop_clip()

  ctx.layers.set_draw_list(saved_draw_list)
  ctx.layers.clip_stack().clear()
  for clip in saved_clip {
    ctx.layers.clip_stack().push(clip)
  }
  ctx.windows.set_active_z(-1)

  Response::with_focus(
    id, window_rect, window_hovered, clicked, is_dragging, is_dragging, false, false,
    false,
  )
}

///|
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
