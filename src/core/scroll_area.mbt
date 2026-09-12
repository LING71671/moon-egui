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
/// Render a vertical scrolling container with wheel scrolling, nested scissor clipping,
/// and smooth interactive scrollbar indicator.
pub fn UIContext::scroll_area(
  self : UIContext,
  id_salt : String,
  size : @math.Vec2,
  content : (UIContext) -> Unit,
) -> Unit {
  let container_id = self.id_stack.derive_id(id_salt)
  let (_id, container_rect, _resp) = self.allocate_space(size)

  if self.is_hovered(container_rect) {
    self.set_wants_capture_mouse(true)
  }

  let mut scroll_y = self.get_scroll_offset(container_id)
  let prev_content_h = self.get_scroll_content_height(container_id)
  let max_scroll = if prev_content_h > size.y {
    prev_content_h - size.y
  } else {
    0.0
  }

  // Handle pointer wheel scrolling inside container
  if self.is_hovered(container_rect) && self.input.scroll_delta.y != 0.0 {
    scroll_y = scroll_y - self.input.scroll_delta.y
  }

  // Clamp scroll range against previous frame estimate
  if scroll_y < 0.0 {
    scroll_y = 0.0
  }
  if max_scroll > 0.0 && scroll_y > max_scroll {
    scroll_y = max_scroll
  }
  self.set_scroll_offset(container_id, scroll_y)

  // Push nested scissor clipping
  self.push_clip(container_rect)

  // Save current context layout state
  let prev_cursor = self.cursor()
  let prev_avail_w = self.available_width()

  // Adjust available width if scrollbar is present
  let scrollbar_w = 6.0
  let inner_w = if max_scroll > 0.0 {
    size.x - scrollbar_w - 4.0
  } else {
    size.x
  }

  self.set_cursor(
    @math.Vec2::new(container_rect.x, container_rect.y - scroll_y),
  )
  self.set_available_width(inner_w)

  content(self)

  let measured_content_h = self.cursor().y + scroll_y - container_rect.y
  self.set_scroll_content_height(container_id, measured_content_h)

  // Post-closure height clamping: immediately clamp scroll_y if content shrank
  let real_max_scroll = if measured_content_h > size.y {
    measured_content_h - size.y
  } else {
    0.0
  }
  if scroll_y > real_max_scroll {
    scroll_y = real_max_scroll
    self.set_scroll_offset(container_id, scroll_y)
  }

  // Restore cursor and pop scissor clip
  self.set_cursor(prev_cursor)
  self.set_available_width(prev_avail_w)
  self.pop_clip()

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
    let thumb_id = self.id_stack.derive_id(id_salt + "::thumb")
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

    let is_thumb_hovered = self.is_hovered(thumb_rect)
    let is_track_hovered = self.is_hovered(track_rect)

    if (is_thumb_hovered || is_track_hovered) && self.input.mouse_pressed {
      self.set_active_id(thumb_id)
    }

    if self.active_id() == thumb_id {
      self.set_wants_capture_mouse(true)
      if self.input.mouse_down && usable_h > 0.0 {
        let rel_mouse_y = self.input.mouse_pos.y - bar_track_y - thumb_h * 0.5
        let mut new_pct = rel_mouse_y / usable_h
        if new_pct < 0.0 {
          new_pct = 0.0
        }
        if new_pct > 1.0 {
          new_pct = 1.0
        }
        scroll_y = new_pct * real_max_scroll
        self.set_scroll_offset(container_id, scroll_y)
        current_pct = new_pct
      }
      if self.input.mouse_released {
        self.set_active_id(Id::zero())
      }
    }

    let active_thumb_y = bar_track_y + current_pct * usable_h
    let active_thumb_rect = @math.Rect::new(
      bar_x, active_thumb_y, scrollbar_w, thumb_h,
    )

    let thumb_color = if self.active_id() == thumb_id || is_thumb_hovered {
      @color.Color::accent_primary()
    } else {
      @color.Color::border_muted()
    }
    self.draw_list.add_rect(
      active_thumb_rect,
      thumb_color,
      self.style.radius_sm,
    )
  }
}
