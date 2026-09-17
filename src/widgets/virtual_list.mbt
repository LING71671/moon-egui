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
/// Interactive response data returned from VirtualList execution.
pub struct VirtualListResponse {
  rect : @math.Rect
  scroll_offset : Double
  first_visible : Int
  last_visible : Int
  hovered : Bool
} derive(Eq, Debug)

///|
/// Standalone virtualized 1D list container rendering only items currently visible
/// within the viewable scissor bounds.
pub struct VirtualList {
  id_salt : String
  total_items : Int
  height : Double
  mut width_val : Double?
  mut item_height_val : Double
  mut overscan_val : Int
} derive(Eq, Debug)

///|
pub fn VirtualList::new(
  id_salt : String,
  total_items : Int,
  height : Double,
) -> VirtualList {
  {
    id_salt,
    total_items,
    height,
    width_val: None,
    item_height_val: 28.0,
    overscan_val: 2,
  }
}

///|
pub fn VirtualList::item_height(self : VirtualList, h : Double) -> VirtualList {
  let valid_h = if h < 4.0 { 4.0 } else { h }
  self.item_height_val = valid_h
  self
}

///|
pub fn VirtualList::width(self : VirtualList, w : Double) -> VirtualList {
  self.width_val = Some(w)
  self
}

///|
pub fn VirtualList::overscan(self : VirtualList, count : Int) -> VirtualList {
  let valid_c = if count < 0 { 0 } else { count }
  self.overscan_val = valid_c
  self
}

///|
/// Computes visible slice bounds and executes the row rendering closure exclusively
/// for visible items within the scroll viewport.
pub fn VirtualList::render(
  self : VirtualList,
  ctx : UIContext,
  item_renderer : (Int, @math.Rect) -> Unit,
) -> VirtualListResponse {
  let scale = ctx.style.scale
  let item_h = self.item_height_val * scale
  let list_h = self.height * scale

  let total_w = match self.width_val {
    Some(w) => w * scale
    None =>
      if ctx.available_width() > 0.0 {
        ctx.available_width()
      } else {
        300.0 * scale
      }
  }

  let list_id = ctx.id_stack.derive_id(self.id_salt)
  let (_id, container_rect, _resp) = ctx.allocate_space(
    @math.Vec2::new(total_w, list_h),
  )

  let is_hovered = ctx.is_hovered(container_rect)
  if is_hovered {
    ctx.set_wants_capture_mouse(true)
  }

  let total_content_h = self.total_items.to_double() * item_h
  let max_scroll = if total_content_h > list_h {
    total_content_h - list_h
  } else {
    0.0
  }

  let mut scroll_y = ctx.get_scroll_offset(list_id)

  // Process mouse wheel scrolling
  if is_hovered && max_scroll > 0.0 {
    let dy = ctx.input.scroll_delta.y
    if dy != 0.0 {
      scroll_y = scroll_y + dy
    }
  }

  // Clamp scroll offset within valid boundaries
  if scroll_y < 0.0 {
    scroll_y = 0.0
  } else if scroll_y > max_scroll {
    scroll_y = max_scroll
  }
  ctx.set_scroll_offset(list_id, scroll_y)

  // Compute visible item window index range
  let (first_idx, last_idx) = if self.total_items <= 0 {
    (0, -1)
  } else {
    let raw_first = if item_h > 0.0 {
      (scroll_y / item_h).to_int() - self.overscan_val
    } else {
      0
    }
    let first = if raw_first < 0 { 0 } else { raw_first }

    let raw_last = if item_h > 0.0 {
      ((scroll_y + list_h) / item_h).to_int() + self.overscan_val
    } else {
      self.total_items - 1
    }
    let last = if raw_last >= self.total_items {
      self.total_items - 1
    } else {
      raw_last
    }
    (first, last)
  }

  let scrollbar_w = 5.0 * scale
  let content_w = if max_scroll > 0.0 {
    container_rect.w - scrollbar_w - 2.0 * scale
  } else {
    container_rect.w
  }

  // Scoped scissor clipping around container
  ctx.push_clip(container_rect)

  if first_idx <= last_idx {
    for i = first_idx; i <= last_idx; i = i + 1 {
      let item_y = container_rect.y + i.to_double() * item_h - scroll_y
      let item_rect = @math.Rect::new(
        container_rect.x,
        item_y,
        content_w,
        item_h,
      )
      item_renderer(i, item_rect)
    }
  }

  ctx.pop_clip()

  // Draw vertical scrollbar indicator if overflowing
  if max_scroll > 0.0 {
    let track_x = container_rect.x +
      container_rect.w -
      scrollbar_w -
      2.0 * scale
    let min_thumb_h = 16.0 * scale
    let thumb_h = if total_content_h > 0.0 {
      let h_prop = list_h / total_content_h * list_h
      if h_prop < min_thumb_h {
        min_thumb_h
      } else {
        h_prop
      }
    } else {
      min_thumb_h
    }

    let track_travel = list_h - thumb_h
    let thumb_y = container_rect.y + scroll_y / max_scroll * track_travel
    let thumb_rect = @math.Rect::new(track_x, thumb_y, scrollbar_w, thumb_h)

    let p = ctx.painter()
    let radius = scrollbar_w * 0.5
    p.add_rect(thumb_rect, @color.Color::border_default(), radius)
  }

  {
    rect: container_rect,
    scroll_offset: scroll_y,
    first_visible: first_idx,
    last_visible: last_idx,
    hovered: is_hovered,
  }
}

///|
/// Convenience one-liner to render a virtual list with default metrics.
pub fn virtual_list(
  ctx : UIContext,
  id_salt : String,
  total_items : Int,
  height : Double,
  item_height? : Double = 28.0,
  item_renderer : (Int, @math.Rect) -> Unit,
) -> VirtualListResponse {
  let list = VirtualList::new(id_salt, total_items, height).item_height(
    item_height,
  )
  list.render(ctx, item_renderer)
}
