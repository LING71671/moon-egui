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
/// Scoped horizontal split container:
/// Automatically divides available space into left and right panes,
/// manages clipping for both sides, and handles interactive divider dragging.
pub fn UIContext::split_horizontal(
  self : UIContext,
  id_salt : String,
  split_ratio : Double,
  size : @math.Vec2,
  left : (UIContext, @math.Rect) -> Unit,
  right : (UIContext, @math.Rect) -> Unit,
  min_ratio? : Double = 0.15,
  max_ratio? : Double = 0.85,
  min_px? : Double = 60.0,
) -> Double {
  self.push_id(id_salt)
  let (_id, container_rect, _resp) = self.allocate_space(size)
  self.pop_id()

  let w = container_rect.w
  let h = container_rect.h

  // Clamp raw ratio
  let raw_ratio = if split_ratio < min_ratio {
    min_ratio
  } else if split_ratio > max_ratio {
    max_ratio
  } else {
    split_ratio
  }

  // Enforce physical pixel bounds
  let mut left_w = w * raw_ratio
  if left_w < min_px {
    left_w = min_px
  }
  if w - left_w < min_px {
    left_w = w - min_px
  }
  let mut effective_ratio = left_w / w

  // Splitter divider bar hit testing
  let bar_x = container_rect.x + left_w
  let hit_w = 10.0
  let hit_rect = @math.Rect::new(
    bar_x - hit_w * 0.5,
    container_rect.y,
    hit_w,
    h,
  )

  let bar_id = self.id_stack.derive_id("splitter_h::" + id_salt)
  let hovered = hit_rect.contains(self.input.mouse_pos)

  if hovered {
    self.set_cursor_icon("col-resize")
  }
  if hovered && self.input.mouse_pressed {
    self.set_active_id(bar_id)
  }

  let is_active = self.active_id == bar_id
  if is_active {
    self.set_wants_capture_mouse(true)
    self.set_cursor_icon("col-resize")
    if self.input.mouse_down {
      let mouse_rel_x = self.input.mouse_pos.x - container_rect.x
      let mut clamped_x = mouse_rel_x
      if clamped_x < min_px {
        clamped_x = min_px
      }
      if w - clamped_x < min_px {
        clamped_x = w - min_px
      }
      effective_ratio = clamped_x / w
      if effective_ratio < min_ratio {
        effective_ratio = min_ratio
      }
      if effective_ratio > max_ratio {
        effective_ratio = max_ratio
      }
    }
    if self.input.mouse_released {
      self.set_active_id(Id::zero())
    }
  }

  // Recalculate panel dimensions after interaction
  left_w = w * effective_ratio
  let right_w = w - left_w
  let left_rect = @math.Rect::new(container_rect.x, container_rect.y, left_w, h)
  let right_rect = @math.Rect::new(
    container_rect.x + left_w,
    container_rect.y,
    right_w,
    h,
  )

  let saved_cursor = self.cursor
  let saved_avail = self.available_width

  // Render left pane
  self.push_clip(left_rect)
  self.set_cursor(@math.Vec2::new(left_rect.x, left_rect.y))
  self.set_available_width(left_rect.w)
  left(self, left_rect)
  self.pop_clip()

  // Render right pane
  self.push_clip(right_rect)
  self.set_cursor(@math.Vec2::new(right_rect.x, right_rect.y))
  self.set_available_width(right_rect.w)
  right(self, right_rect)
  self.pop_clip()

  self.set_cursor(saved_cursor)
  self.set_available_width(saved_avail)

  // Render divider line on top of panes
  let divider_x = container_rect.x + left_w
  let line_col = if is_active || hovered {
    @color.Color::accent_primary()
  } else {
    @color.Color::border_muted()
  }
  let line_w = if is_active || hovered { 2.0 } else { 1.0 }

  self.draw_list.add_line(
    @math.Vec2::new(divider_x, container_rect.y),
    @math.Vec2::new(divider_x, container_rect.y + h),
    line_col,
    line_w,
  )

  // 3 grip dots at middle height
  let mid_y = container_rect.y + h * 0.5
  let dot_col = if is_active || hovered {
    @color.Color::accent_primary()
  } else {
    @color.Color::border_strong()
  }
  self.draw_list.add_circle(
    @math.Vec2::new(divider_x, mid_y - 6.0),
    1.5,
    dot_col,
  )
  self.draw_list.add_circle(@math.Vec2::new(divider_x, mid_y), 1.5, dot_col)
  self.draw_list.add_circle(
    @math.Vec2::new(divider_x, mid_y + 6.0),
    1.5,
    dot_col,
  )

  effective_ratio
}

///|
/// Scoped vertical split container:
/// Divides space into top and bottom panes with interactive vertical divider.
pub fn UIContext::split_vertical(
  self : UIContext,
  id_salt : String,
  split_ratio : Double,
  size : @math.Vec2,
  top : (UIContext, @math.Rect) -> Unit,
  bottom : (UIContext, @math.Rect) -> Unit,
  min_ratio? : Double = 0.15,
  max_ratio? : Double = 0.85,
  min_px? : Double = 60.0,
) -> Double {
  self.push_id(id_salt)
  let (_id, container_rect, _resp) = self.allocate_space(size)
  self.pop_id()

  let w = container_rect.w
  let h = container_rect.h

  let raw_ratio = if split_ratio < min_ratio {
    min_ratio
  } else if split_ratio > max_ratio {
    max_ratio
  } else {
    split_ratio
  }

  let mut top_h = h * raw_ratio
  if top_h < min_px {
    top_h = min_px
  }
  if h - top_h < min_px {
    top_h = h - min_px
  }
  let mut effective_ratio = top_h / h

  let bar_y = container_rect.y + top_h
  let hit_h = 10.0
  let hit_rect = @math.Rect::new(
    container_rect.x,
    bar_y - hit_h * 0.5,
    w,
    hit_h,
  )

  let bar_id = self.id_stack.derive_id("splitter_v::" + id_salt)
  let hovered = hit_rect.contains(self.input.mouse_pos)

  if hovered {
    self.set_cursor_icon("row-resize")
  }
  if hovered && self.input.mouse_pressed {
    self.set_active_id(bar_id)
  }

  let is_active = self.active_id == bar_id
  if is_active {
    self.set_wants_capture_mouse(true)
    self.set_cursor_icon("row-resize")
    if self.input.mouse_down {
      let mouse_rel_y = self.input.mouse_pos.y - container_rect.y
      let mut clamped_y = mouse_rel_y
      if clamped_y < min_px {
        clamped_y = min_px
      }
      if h - clamped_y < min_px {
        clamped_y = h - min_px
      }
      effective_ratio = clamped_y / h
      if effective_ratio < min_ratio {
        effective_ratio = min_ratio
      }
      if effective_ratio > max_ratio {
        effective_ratio = max_ratio
      }
    }
    if self.input.mouse_released {
      self.set_active_id(Id::zero())
    }
  }

  top_h = h * effective_ratio
  let bottom_h = h - top_h
  let top_rect = @math.Rect::new(container_rect.x, container_rect.y, w, top_h)
  let bottom_rect = @math.Rect::new(
    container_rect.x,
    container_rect.y + top_h,
    w,
    bottom_h,
  )

  let saved_cursor = self.cursor
  let saved_avail = self.available_width

  // Render top pane
  self.push_clip(top_rect)
  self.set_cursor(@math.Vec2::new(top_rect.x, top_rect.y))
  self.set_available_width(top_rect.w)
  top(self, top_rect)
  self.pop_clip()

  // Render bottom pane
  self.push_clip(bottom_rect)
  self.set_cursor(@math.Vec2::new(bottom_rect.x, bottom_rect.y))
  self.set_available_width(bottom_rect.w)
  bottom(self, bottom_rect)
  self.pop_clip()

  self.set_cursor(saved_cursor)
  self.set_available_width(saved_avail)

  // Render horizontal divider line
  let divider_y = container_rect.y + top_h
  let line_col = if is_active || hovered {
    @color.Color::accent_primary()
  } else {
    @color.Color::border_muted()
  }
  let line_w = if is_active || hovered { 2.0 } else { 1.0 }

  self.draw_list.add_line(
    @math.Vec2::new(container_rect.x, divider_y),
    @math.Vec2::new(container_rect.x + w, divider_y),
    line_col,
    line_w,
  )

  // 3 grip dots at middle width
  let mid_x = container_rect.x + w * 0.5
  let dot_col = if is_active || hovered {
    @color.Color::accent_primary()
  } else {
    @color.Color::border_strong()
  }
  self.draw_list.add_circle(
    @math.Vec2::new(mid_x - 6.0, divider_y),
    1.5,
    dot_col,
  )
  self.draw_list.add_circle(@math.Vec2::new(mid_x, divider_y), 1.5, dot_col)
  self.draw_list.add_circle(
    @math.Vec2::new(mid_x + 6.0, divider_y),
    1.5,
    dot_col,
  )

  effective_ratio
}
