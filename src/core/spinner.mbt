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
/// Render a smooth, continuous loading spinner animation driven by context time,
/// featuring an asymmetric breathing sweep arc with trailing opacity taper.
pub fn UIContext::spinner(
  self : UIContext,
  size? : Double = 20.0,
  color? : @color.Color = @color.Color::accent_primary(),
  stroke_width? : Double = 2.5,
) -> Response {
  let (_id, rect, resp) = self.allocate_space(@math.Vec2::new(size, size))
  let center = rect.center()
  let radius = (size - stroke_width) * 0.5

  // 1. Subtle Background Track Ring
  self.draw_list.add_circle_stroke(
    center,
    radius,
    @color.Color::border_muted().with_alpha(60),
    stroke_width,
  )

  // 2. Dynamic Arc Angles Driven by UIContext::time
  let pi2 = 6.283185307179586
  let base_rot = self.time * 4.0 % pi2
  let sweep_min = 0.6
  let sweep_max = 4.8
  let sweep_factor = (@math.sin(self.time * 2.8) + 1.0) * 0.5
  let sweep_len = sweep_min + sweep_factor * (sweep_max - sweep_min)

  // 3. Tapered Arc Line Segments
  let num_steps = 18
  for i = 0; i < num_steps; i = i + 1 {
    let t1 = i.to_double() / num_steps.to_double()
    let t2 = (i + 1).to_double() / num_steps.to_double()
    let a1 = base_rot + t1 * sweep_len
    let a2 = base_rot + t2 * sweep_len

    let p1 = center.add(@math.Vec2::from_polar(radius, a1))
    let p2 = center.add(@math.Vec2::from_polar(radius, a2))

    let alpha = (80.0 + t2 * 175.0).to_int()
    let seg_color = color.with_alpha(alpha)
    self.draw_list.add_line(p1, p2, seg_color, stroke_width)
  }

  resp
}

///|
/// Render a loading spinner inline with an adjacent text label.
pub fn UIContext::spinner_with_label(
  self : UIContext,
  label : String,
  size? : Double = 18.0,
  color? : @color.Color = @color.Color::accent_primary(),
  stroke_width? : Double = 2.0,
) -> Response {
  let font_sz = self.style.font_normal
  let label_sz = self.measure_text(label, font_sz)
  let total_w = size + 8.0 + label_sz.x
  let total_h = if size > label_sz.y { size } else { label_sz.y }

  let (_id, rect, resp) = self.allocate_space(@math.Vec2::new(total_w, total_h))
  let center = @math.Vec2::new(rect.x + size * 0.5, rect.y + rect.h * 0.5)
  let radius = (size - stroke_width) * 0.5

  // Background ring
  self.draw_list.add_circle_stroke(
    center,
    radius,
    @color.Color::border_muted().with_alpha(60),
    stroke_width,
  )

  // Arc
  let pi2 = 6.283185307179586
  let base_rot = self.time * 4.0 % pi2
  let sweep_factor = (@math.sin(self.time * 2.8) + 1.0) * 0.5
  let sweep_len = 0.6 + sweep_factor * 4.2

  let num_steps = 16
  for i = 0; i < num_steps; i = i + 1 {
    let t1 = i.to_double() / num_steps.to_double()
    let t2 = (i + 1).to_double() / num_steps.to_double()
    let a1 = base_rot + t1 * sweep_len
    let a2 = base_rot + t2 * sweep_len

    let p1 = center.add(@math.Vec2::from_polar(radius, a1))
    let p2 = center.add(@math.Vec2::from_polar(radius, a2))

    let alpha = (90.0 + t2 * 165.0).to_int()
    let seg_color = color.with_alpha(alpha)
    self.draw_list.add_line(p1, p2, seg_color, stroke_width)
  }

  // Label text
  let text_pos = @math.Vec2::new(
    rect.x + size + 8.0,
    rect.y + (rect.h - font_sz) * 0.5,
  )
  self.draw_list.add_text(
    text_pos,
    label,
    font_sz,
    @color.Color::text_secondary(),
  )

  resp
}
