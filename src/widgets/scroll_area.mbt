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
/// Standalone vertical scrolling container supporting fluent configuration.
pub struct ScrollArea {
  id_salt : String
  size : @math.Vec2
} derive(Eq, Debug)

///|
/// Create a new scroll area with an identifier and viewport dimension.
pub fn ScrollArea::new(id_salt : String, size : @math.Vec2) -> ScrollArea {
  { id_salt, size, }
}

///|
/// Show the scroll area and execute the nested content closure.
pub fn ScrollArea::show(
  self : ScrollArea,
  ctx : UIContext,
  content : (UIContext) -> Unit,
) -> Unit {
  scroll_area(ctx, self.id_salt, self.size, content)
}

///|
/// Render a vertical scrolling container with wheel scrolling, nested scissor clipping,
/// and smooth interactive scrollbar indicator in Studio Light porcelain style.
pub fn scroll_area(
  ctx : UIContext,
  id_salt : String,
  size : @math.Vec2,
  content : (UIContext) -> Unit,
) -> Unit {
  let container_id = ctx.id_stack.derive_id(id_salt)
  let (_id, container_rect, _resp) = ctx.allocate_space(size)

  // The viewport is Tab-reachable: keyboard scrolling applies only while the
  // container itself holds focus, so focused children keep their arrow keys.
  ctx.register_focusable(container_id)

  if ctx.is_hovered(container_rect) {
    ctx.set_wants_capture_mouse(true)
  }

  let mut scroll_y = ctx.get_scroll_offset(container_id)
  let prev_content_h = ctx.get_scroll_content_height(container_id)
  let max_scroll = if prev_content_h > size.y {
    prev_content_h - size.y
  } else {
    0.0
  }

  // Handle pointer wheel scrolling inside container
  if ctx.is_hovered(container_rect) && ctx.input.scroll_delta.y != 0.0 {
    scroll_y = scroll_y - ctx.input.scroll_delta.y
  }

  // Clamp scroll range against previous frame estimate
  if scroll_y < 0.0 {
    scroll_y = 0.0
  }
  if max_scroll > 0.0 && scroll_y > max_scroll {
    scroll_y = max_scroll
  }
  ctx.set_scroll_offset(container_id, scroll_y)

  // Push nested scissor clipping
  ctx.push_clip(container_rect)

  // Save current context layout state
  let prev_cursor = ctx.cursor()
  let prev_avail_w = ctx.available_width()

  // Adjust available width if scrollbar is present
  let scrollbar_w = 6.0
  let inner_w = if max_scroll > 0.0 {
    size.x - scrollbar_w - 4.0
  } else {
    size.x
  }

  ctx.set_cursor(@math.Vec2::new(container_rect.x, container_rect.y - scroll_y))
  ctx.set_available_width(inner_w)

  content(ctx)

  let measured_content_h = ctx.cursor().y + scroll_y - container_rect.y
  ctx.set_scroll_content_height(container_id, measured_content_h)

  // Post-closure height clamping: immediately clamp scroll_y if content shrank
  let real_max_scroll = if measured_content_h > size.y {
    measured_content_h - size.y
  } else {
    0.0
  }
  if scroll_y > real_max_scroll {
    scroll_y = real_max_scroll
    ctx.set_scroll_offset(container_id, scroll_y)
  }

  // Keyboard scrolling while the container holds focus. Focus is exclusive,
  // so a focused child (text_edit, slider, ...) keeps its arrow keys.
  if ctx.has_focus(container_id) && real_max_scroll > 0.0 {
    let kb_step = 36.0 * ctx.style.scale
    let page = size.y * 0.85
    let mut delta = 0.0
    if ctx.input.key_pressed(Key::ArrowDown) {
      delta = kb_step
      ctx.input.consume_key(Key::ArrowDown)
    }
    if ctx.input.key_pressed(Key::ArrowUp) {
      delta = -kb_step
      ctx.input.consume_key(Key::ArrowUp)
    }
    if ctx.input.key_pressed(Key::PageDown) {
      delta = page
      ctx.input.consume_key(Key::PageDown)
    }
    if ctx.input.key_pressed(Key::PageUp) {
      delta = -page
      ctx.input.consume_key(Key::PageUp)
    }
    if ctx.input.key_pressed(Key::End) {
      delta = real_max_scroll - scroll_y
      ctx.input.consume_key(Key::End)
    }
    if ctx.input.key_pressed(Key::Home) {
      delta = -scroll_y
      ctx.input.consume_key(Key::Home)
    }
    if delta != 0.0 {
      scroll_y = if scroll_y + delta < 0.0 {
        0.0
      } else if scroll_y + delta > real_max_scroll {
        real_max_scroll
      } else {
        scroll_y + delta
      }
      ctx.set_scroll_offset(container_id, scroll_y)
    }
  }

  // Restore cursor and pop scissor clip
  ctx.set_cursor(prev_cursor)
  ctx.set_available_width(prev_avail_w)
  ctx.pop_clip()

  // Focus ring so Tab users can see the viewport is keyboard-scrollable
  if ctx.has_focus(container_id) {
    ctx
    .painter()
    .add_rect_stroke(
      container_rect,
      @color.Color::border_focus(),
      1.0 * ctx.style.scale,
      ctx.style.radius_md,
    )
  }

  // Draw scrollbar thumb if content exceeds container height
  if real_max_scroll > 0.0 && measured_content_h > 0.0 {
    let bar_x = container_rect.x + size.x - scrollbar_w - 2.0
    let bar_track_y = container_rect.y
    let bar_track_h = size.y

    let ratio = size.y / measured_content_h
    let raw_thumb_h = size.y * ratio
    let thumb_h = if raw_thumb_h < 24.0 {
      24.0
    } else if raw_thumb_h > bar_track_h {
      bar_track_h
    } else {
      raw_thumb_h
    }

    let usable_h = bar_track_h - thumb_h
    let thumb_id = ctx.id_stack.derive_id(id_salt + "::thumb")
    let track_rect = @math.Rect::new(
      bar_x - 2.0,
      bar_track_y,
      scrollbar_w + 4.0,
      bar_track_h,
    )

    let mut current_pct = if real_max_scroll > 0.0001 {
      scroll_y / real_max_scroll
    } else {
      0.0
    }
    let thumb_y = bar_track_y + current_pct * usable_h
    let thumb_rect = @math.Rect::new(bar_x, thumb_y, scrollbar_w, thumb_h)

    let is_thumb_hovered = ctx.is_hovered(thumb_rect)
    let is_track_hovered = ctx.is_hovered(track_rect)

    if (is_thumb_hovered || is_track_hovered) && ctx.input.mouse_pressed {
      ctx.set_active_id(thumb_id)
    }

    if ctx.active_id() == thumb_id {
      ctx.set_wants_capture_mouse(true)
      if ctx.input.mouse_down && usable_h > 0.0 {
        let rel_mouse_y = ctx.input.mouse_pos.y - bar_track_y - thumb_h * 0.5
        let mut new_pct = rel_mouse_y / usable_h
        if new_pct < 0.0 {
          new_pct = 0.0
        }
        if new_pct > 1.0 {
          new_pct = 1.0
        }
        scroll_y = new_pct * real_max_scroll
        ctx.set_scroll_offset(container_id, scroll_y)
        current_pct = new_pct
      }
      if ctx.input.mouse_released {
        ctx.set_active_id(@core.Id::zero())
      }
    }

    let active_thumb_y = bar_track_y + current_pct * usable_h
    let active_thumb_rect = @math.Rect::new(
      bar_x, active_thumb_y, scrollbar_w, thumb_h,
    )

    let thumb_color = if ctx.active_id() == thumb_id || is_thumb_hovered {
      @color.Color::accent_primary()
    } else {
      @color.Color::border_muted()
    }
    ctx.painter().add_rect(active_thumb_rect, thumb_color, ctx.style.radius_sm)
  }
}
