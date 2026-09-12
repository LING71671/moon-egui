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
/// Scoped drawing abstraction that isolates UI widgets from raw global DrawList command queues
/// and enforces local coordinate translation and active scissor clip boundaries.
pub struct Painter {
  draw_list : @draw.DrawList
  clip_rect : @math.Rect?
  offset : @math.Vec2
} derive(Eq, Debug)

///|
pub fn Painter::new(
  draw_list : @draw.DrawList,
  clip_rect? : @math.Rect? = None,
  offset? : @math.Vec2 = @math.Vec2::zero(),
) -> Painter {
  { draw_list, clip_rect, offset, }
}

///|
/// Returns the active drawing coordinate offset.
pub fn Painter::offset(self : Painter) -> @math.Vec2 {
  self.offset
}

///|
/// Returns the current active clip rectangle if one is active.
pub fn Painter::clip_rect(self : Painter) -> @math.Rect? {
  self.clip_rect
}

///|
/// Create a child painter with an additional local translation offset and optional intersected clip rectangle.
pub fn Painter::sub_painter(
  self : Painter,
  local_offset : @math.Vec2,
  sub_clip? : @math.Rect? = None,
) -> Painter {
  let combined_offset = self.offset.add(local_offset)
  let effective_clip = match (self.clip_rect, sub_clip) {
    (Some(parent), Some(child)) => Some(parent.intersect(child))
    (Some(parent), None) => Some(parent)
    (None, Some(child)) => Some(child)
    (None, None) => None
  }
  Painter::new(self.draw_list, clip_rect=effective_clip, offset=combined_offset)
}

///|
/// Render a filled rectangle with optional corner rounding, shifted by the painter's offset.
pub fn Painter::add_rect(
  self : Painter,
  rect : @math.Rect,
  color : @color.Color,
  corner_radius : Double,
) -> Unit {
  let shifted_rect = @math.Rect::new(
    rect.x + self.offset.x,
    rect.y + self.offset.y,
    rect.w,
    rect.h,
  )
  self.draw_list.add_rect(shifted_rect, color, corner_radius)
}

///|
/// Render a stroked rectangle with line width and corner rounding, shifted by the painter's offset.
pub fn Painter::add_rect_stroke(
  self : Painter,
  rect : @math.Rect,
  color : @color.Color,
  stroke_width : Double,
  corner_radius : Double,
) -> Unit {
  let shifted_rect = @math.Rect::new(
    rect.x + self.offset.x,
    rect.y + self.offset.y,
    rect.w,
    rect.h,
  )
  self.draw_list.add_rect_stroke(
    shifted_rect, color, stroke_width, corner_radius,
  )
}

///|
/// Render a filled circle shifted by the painter's offset.
pub fn Painter::add_circle(
  self : Painter,
  center : @math.Vec2,
  radius : Double,
  color : @color.Color,
) -> Unit {
  let shifted_center = @math.Vec2::new(
    center.x + self.offset.x,
    center.y + self.offset.y,
  )
  self.draw_list.add_circle(shifted_center, radius, color)
}

///|
/// Render a stroked circle with specified line width, shifted by the painter's offset.
pub fn Painter::add_circle_stroke(
  self : Painter,
  center : @math.Vec2,
  radius : Double,
  color : @color.Color,
  stroke_width : Double,
) -> Unit {
  let shifted_center = @math.Vec2::new(
    center.x + self.offset.x,
    center.y + self.offset.y,
  )
  self.draw_list.add_circle_stroke(shifted_center, radius, color, stroke_width)
}

///|
/// Render a line segment connecting two endpoints, shifted by the painter's offset.
pub fn Painter::add_line(
  self : Painter,
  start : @math.Vec2,
  end : @math.Vec2,
  color : @color.Color,
  stroke_width : Double,
) -> Unit {
  let shifted_start = @math.Vec2::new(
    start.x + self.offset.x,
    start.y + self.offset.y,
  )
  let shifted_end = @math.Vec2::new(
    end.x + self.offset.x,
    end.y + self.offset.y,
  )
  self.draw_list.add_line(shifted_start, shifted_end, color, stroke_width)
}

///|
/// Render text at the specified local position, shifted by the painter's offset.
pub fn Painter::add_text(
  self : Painter,
  pos : @math.Vec2,
  text : String,
  font_size : Double,
  color : @color.Color,
  font_family? : String = "",
  font_weight? : Int = 500,
) -> Unit {
  let shifted_pos = @math.Vec2::new(
    pos.x + self.offset.x,
    pos.y + self.offset.y,
  )
  self.draw_list.add_text(
    shifted_pos,
    text,
    font_size,
    color,
    font_family~,
    font_weight~,
  )
}

///|
/// Render a linear color gradient inside a rectangle, shifted by the painter's offset.
pub fn Painter::add_linear_gradient(
  self : Painter,
  rect : @math.Rect,
  start_pt : @math.Vec2,
  end_pt : @math.Vec2,
  start_color : @color.Color,
  end_color : @color.Color,
  corner_radius : Double,
) -> Unit {
  let shifted_rect = @math.Rect::new(
    rect.x + self.offset.x,
    rect.y + self.offset.y,
    rect.w,
    rect.h,
  )
  let shifted_start = @math.Vec2::new(
    start_pt.x + self.offset.x,
    start_pt.y + self.offset.y,
  )
  let shifted_end = @math.Vec2::new(
    end_pt.x + self.offset.x,
    end_pt.y + self.offset.y,
  )
  self.draw_list.add_linear_gradient(
    shifted_rect, shifted_start, shifted_end, start_color, end_color, corner_radius,
  )
}

///|
/// Push a scissor clipping region to the underlying draw list.
pub fn Painter::push_clip(self : Painter, rect : @math.Rect) -> Unit {
  let shifted_rect = @math.Rect::new(
    rect.x + self.offset.x,
    rect.y + self.offset.y,
    rect.w,
    rect.h,
  )
  self.draw_list.push_clip(shifted_rect)
}

///|
/// Pop the active scissor clipping region from the underlying draw list.
pub fn Painter::pop_clip(self : Painter) -> Unit {
  self.draw_list.pop_clip()
}

///|
/// Append another draw list to this painter's target list.
pub fn Painter::append(self : Painter, other : @draw.DrawList) -> Unit {
  self.draw_list.append(other)
}
