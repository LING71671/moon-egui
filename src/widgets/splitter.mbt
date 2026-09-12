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
/// Standalone resizable split container widget supporting fluent configuration.
pub struct Splitter {
  id_salt : String
  split_ratio : Double
  size : @math.Vec2
  min_ratio : Double
  max_ratio : Double
  min_px : Double
  vertical : Bool
} derive(Eq, Debug)

///|
/// Create a horizontal splitter container.
pub fn Splitter::horizontal(
  id_salt : String,
  split_ratio : Double,
  size : @math.Vec2,
) -> Splitter {
  {
    id_salt,
    split_ratio,
    size,
    min_ratio: 0.15,
    max_ratio: 0.85,
    min_px: 60.0,
    vertical: false,
  }
}

///|
/// Create a vertical splitter container.
pub fn Splitter::vertical(
  id_salt : String,
  split_ratio : Double,
  size : @math.Vec2,
) -> Splitter {
  {
    id_salt,
    split_ratio,
    size,
    min_ratio: 0.15,
    max_ratio: 0.85,
    min_px: 60.0,
    vertical: true,
  }
}

///|
/// Configure minimum split ratio boundary.
pub fn Splitter::min_ratio(self : Splitter, min_ratio : Double) -> Splitter {
  { ..self, min_ratio, }
}

///|
/// Configure maximum split ratio boundary.
pub fn Splitter::max_ratio(self : Splitter, max_ratio : Double) -> Splitter {
  { ..self, max_ratio, }
}

///|
/// Configure minimum pixel width/height per pane.
pub fn Splitter::min_px(self : Splitter, min_px : Double) -> Splitter {
  { ..self, min_px, }
}

///|
/// Show the splitter and execute closures for first and second panes.
pub fn Splitter::show(
  self : Splitter,
  ctx : UIContext,
  first : (UIContext, @math.Rect) -> Unit,
  second : (UIContext, @math.Rect) -> Unit,
) -> Double {
  if self.vertical {
    split_vertical(
      ctx,
      self.id_salt,
      self.split_ratio,
      self.size,
      first,
      second,
      min_ratio=self.min_ratio,
      max_ratio=self.max_ratio,
      min_px=self.min_px,
    )
  } else {
    split_horizontal(
      ctx,
      self.id_salt,
      self.split_ratio,
      self.size,
      first,
      second,
      min_ratio=self.min_ratio,
      max_ratio=self.max_ratio,
      min_px=self.min_px,
    )
  }
}

///|
/// Scoped horizontal split container:
/// Automatically divides available space into left and right panes,
/// manages clipping for both sides, and handles interactive divider dragging.
pub fn split_horizontal(
  ctx : UIContext,
  id_salt : String,
  split_ratio : Double,
  size : @math.Vec2,
  left : (UIContext, @math.Rect) -> Unit,
  right : (UIContext, @math.Rect) -> Unit,
  min_ratio? : Double = 0.15,
  max_ratio? : Double = 0.85,
  min_px? : Double = 60.0,
) -> Double {
  ctx.push_id(id_salt)
  let (_id, container_rect, _resp) = ctx.allocate_space(size)
  ctx.pop_id()

  let w = container_rect.w
  let h = container_rect.h

  let raw_ratio = if split_ratio < min_ratio {
    min_ratio
  } else if split_ratio > max_ratio {
    max_ratio
  } else {
    split_ratio
  }

  if w <= 0.0 || h <= 0.0 {
    return raw_ratio
  }

  let safe_min_px = if min_px * 2.0 > w { w * 0.5 } else { min_px }
  let mut left_w = w * raw_ratio
  if left_w < safe_min_px {
    left_w = safe_min_px
  }
  if w - left_w < safe_min_px {
    left_w = w - safe_min_px
  }
  let mut effective_ratio = left_w / w

  let bar_x = container_rect.x + left_w
  let hit_w = 10.0
  let hit_rect = @math.Rect::new(
    bar_x - hit_w * 0.5,
    container_rect.y,
    hit_w,
    h,
  )

  let bar_id = ctx.id_stack.derive_id("splitter_h::" + id_salt)
  let hovered = ctx.is_hovered(hit_rect)
  ctx.register_focusable(bar_id)
  let is_focused = ctx.has_focus(bar_id)

  if hovered {
    ctx.set_cursor_icon("col-resize")
  }
  if hovered && ctx.input.mouse_pressed {
    ctx.set_active_id(bar_id)
  }

  let is_active = ctx.active_id() == bar_id
  if is_active {
    ctx.set_wants_capture_mouse(true)
    ctx.set_cursor_icon("col-resize")
    if ctx.input.mouse_down {
      let mouse_rel_x = ctx.input.mouse_pos.x - container_rect.x
      let mut clamped_x = mouse_rel_x
      if clamped_x < safe_min_px {
        clamped_x = safe_min_px
      }
      if w - clamped_x < safe_min_px {
        clamped_x = w - safe_min_px
      }
      effective_ratio = clamped_x / w
      if effective_ratio < min_ratio {
        effective_ratio = min_ratio
      }
      if effective_ratio > max_ratio {
        effective_ratio = max_ratio
      }
    }
    if ctx.input.mouse_released {
      ctx.set_active_id(@core.Id::zero())
    }
  }

  // Keyboard resize: the divider is Tab-reachable; arrows nudge the ratio.
  if is_focused {
    let kb_step = 0.02
    if ctx.input.key_pressed(Key::ArrowRight) {
      ctx.input.consume_key(Key::ArrowRight)
      effective_ratio = if effective_ratio + kb_step > max_ratio {
        max_ratio
      } else {
        effective_ratio + kb_step
      }
    }
    if ctx.input.key_pressed(Key::ArrowLeft) {
      ctx.input.consume_key(Key::ArrowLeft)
      effective_ratio = if effective_ratio - kb_step < min_ratio {
        min_ratio
      } else {
        effective_ratio - kb_step
      }
    }
  }

  left_w = w * effective_ratio
  let right_w = w - left_w
  let left_rect = @math.Rect::new(container_rect.x, container_rect.y, left_w, h)
  let right_rect = @math.Rect::new(
    container_rect.x + left_w,
    container_rect.y,
    right_w,
    h,
  )

  let saved_cursor = ctx.cursor()
  let saved_avail = ctx.available_width()

  ctx.push_clip(left_rect)
  ctx.set_cursor(@math.Vec2::new(left_rect.x, left_rect.y))
  ctx.set_available_width(left_rect.w)
  left(ctx, left_rect)
  ctx.pop_clip()

  ctx.push_clip(right_rect)
  ctx.set_cursor(@math.Vec2::new(right_rect.x, right_rect.y))
  ctx.set_available_width(right_rect.w)
  right(ctx, right_rect)
  ctx.pop_clip()

  ctx.set_cursor(saved_cursor)
  ctx.set_available_width(saved_avail)

  let divider_x = container_rect.x + left_w
  let line_col = if is_active || hovered {
    @color.Color::accent_primary()
  } else {
    @color.Color::border_muted()
  }
  let line_w = if is_active || hovered { 2.0 } else { 1.0 }

  ctx
  .painter()
  .add_line(
    @math.Vec2::new(divider_x, container_rect.y),
    @math.Vec2::new(divider_x, container_rect.y + h),
    line_col,
    line_w,
  )

  let mid_y = container_rect.y + h * 0.5
  let dot_col = if is_active || hovered {
    @color.Color::accent_primary()
  } else {
    @color.Color::border_strong()
  }
  ctx
  .painter()
  .add_circle(@math.Vec2::new(divider_x, mid_y - 6.0), 1.5, dot_col)
  ctx.painter().add_circle(@math.Vec2::new(divider_x, mid_y), 1.5, dot_col)
  ctx
  .painter()
  .add_circle(@math.Vec2::new(divider_x, mid_y + 6.0), 1.5, dot_col)

  if is_focused {
    ctx
    .painter()
    .add_rect_stroke(
      hit_rect.expand(1.0),
      @color.Color::border_focus(),
      1.0,
      ctx.style.radius_sm,
    )
  }

  effective_ratio
}

///|
/// Scoped vertical split container:
/// Divides space into top and bottom panes with interactive vertical divider.
pub fn split_vertical(
  ctx : UIContext,
  id_salt : String,
  split_ratio : Double,
  size : @math.Vec2,
  top : (UIContext, @math.Rect) -> Unit,
  bottom : (UIContext, @math.Rect) -> Unit,
  min_ratio? : Double = 0.15,
  max_ratio? : Double = 0.85,
  min_px? : Double = 60.0,
) -> Double {
  ctx.push_id(id_salt)
  let (_id, container_rect, _resp) = ctx.allocate_space(size)
  ctx.pop_id()

  let w = container_rect.w
  let h = container_rect.h

  let raw_ratio = if split_ratio < min_ratio {
    min_ratio
  } else if split_ratio > max_ratio {
    max_ratio
  } else {
    split_ratio
  }

  if w <= 0.0 || h <= 0.0 {
    return raw_ratio
  }

  let safe_min_px = if min_px * 2.0 > h { h * 0.5 } else { min_px }
  let mut top_h = h * raw_ratio
  if top_h < safe_min_px {
    top_h = safe_min_px
  }
  if h - top_h < safe_min_px {
    top_h = h - safe_min_px
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

  let bar_id = ctx.id_stack.derive_id("splitter_v::" + id_salt)
  let hovered = ctx.is_hovered(hit_rect)
  ctx.register_focusable(bar_id)
  let is_focused = ctx.has_focus(bar_id)

  if hovered {
    ctx.set_cursor_icon("row-resize")
  }
  if hovered && ctx.input.mouse_pressed {
    ctx.set_active_id(bar_id)
  }

  let is_active = ctx.active_id() == bar_id
  if is_active {
    ctx.set_wants_capture_mouse(true)
    ctx.set_cursor_icon("row-resize")
    if ctx.input.mouse_down {
      let mouse_rel_y = ctx.input.mouse_pos.y - container_rect.y
      let mut clamped_y = mouse_rel_y
      if clamped_y < safe_min_px {
        clamped_y = safe_min_px
      }
      if h - clamped_y < safe_min_px {
        clamped_y = h - safe_min_px
      }
      effective_ratio = clamped_y / h
      if effective_ratio < min_ratio {
        effective_ratio = min_ratio
      }
      if effective_ratio > max_ratio {
        effective_ratio = max_ratio
      }
    }
    if ctx.input.mouse_released {
      ctx.set_active_id(@core.Id::zero())
    }
  }

  // Keyboard resize: the divider is Tab-reachable; arrows nudge the ratio.
  if is_focused {
    let kb_step = 0.02
    if ctx.input.key_pressed(Key::ArrowDown) {
      ctx.input.consume_key(Key::ArrowDown)
      effective_ratio = if effective_ratio + kb_step > max_ratio {
        max_ratio
      } else {
        effective_ratio + kb_step
      }
    }
    if ctx.input.key_pressed(Key::ArrowUp) {
      ctx.input.consume_key(Key::ArrowUp)
      effective_ratio = if effective_ratio - kb_step < min_ratio {
        min_ratio
      } else {
        effective_ratio - kb_step
      }
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

  let saved_cursor = ctx.cursor()
  let saved_avail = ctx.available_width()

  ctx.push_clip(top_rect)
  ctx.set_cursor(@math.Vec2::new(top_rect.x, top_rect.y))
  ctx.set_available_width(top_rect.w)
  top(ctx, top_rect)
  ctx.pop_clip()

  ctx.push_clip(bottom_rect)
  ctx.set_cursor(@math.Vec2::new(bottom_rect.x, bottom_rect.y))
  ctx.set_available_width(bottom_rect.w)
  bottom(ctx, bottom_rect)
  ctx.pop_clip()

  ctx.set_cursor(saved_cursor)
  ctx.set_available_width(saved_avail)

  let divider_y = container_rect.y + top_h
  let line_col = if is_active || hovered {
    @color.Color::accent_primary()
  } else {
    @color.Color::border_muted()
  }
  let line_w = if is_active || hovered { 2.0 } else { 1.0 }

  ctx
  .painter()
  .add_line(
    @math.Vec2::new(container_rect.x, divider_y),
    @math.Vec2::new(container_rect.x + w, divider_y),
    line_col,
    line_w,
  )

  let mid_x = container_rect.x + w * 0.5
  let dot_col = if is_active || hovered {
    @color.Color::accent_primary()
  } else {
    @color.Color::border_strong()
  }
  ctx
  .painter()
  .add_circle(@math.Vec2::new(mid_x - 6.0, divider_y), 1.5, dot_col)
  ctx.painter().add_circle(@math.Vec2::new(mid_x, divider_y), 1.5, dot_col)
  ctx
  .painter()
  .add_circle(@math.Vec2::new(mid_x + 6.0, divider_y), 1.5, dot_col)

  if is_focused {
    ctx
    .painter()
    .add_rect_stroke(
      hit_rect.expand(1.0),
      @color.Color::border_focus(),
      1.0,
      ctx.style.radius_sm,
    )
  }

  effective_ratio
}
