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
/// Render a real-time micro sparkline trend chart with auto-normalized scaling,
/// flat-data divide-by-zero protection, gradient area fill, and interactive hover point snapping.
pub fn UIContext::sparkline(
  self : UIContext,
  id_salt : String,
  values : Array[Double],
  size? : @math.Vec2 = @math.Vec2::new(120.0, 36.0),
  color? : @color.Color = @color.Color::accent_primary(),
  fill? : Bool = true,
  show_hover? : Bool = true,
) -> (Int?, Response) {
  self.push_id(id_salt)
  let (_id, rect, resp) = self.allocate_space(size)
  self.pop_id()

  let count = values.length()

  let scale = self.style.scale
  let radius = self.style.radius_sm * scale

  // 1. Container Card
  self.draw_list.add_rect(rect, @color.Color::sparkline_wash(), radius)
  self.draw_list.add_rect_stroke(
    rect,
    @color.Color::border_muted(),
    1.0,
    radius,
  )

  if count == 0 {
    return (None, resp)
  }

  let pad_x = 4.0
  let pad_y = 4.0
  let plot_w = rect.w - pad_x * 2.0
  let plot_h = rect.h - pad_y * 2.0
  let base_y = rect.y + pad_y + plot_h

  if count == 1 {
    let mid_y = rect.y + pad_y + plot_h * 0.5
    self.draw_list.add_line(
      @math.Vec2::new(rect.x + pad_x, mid_y),
      @math.Vec2::new(rect.x + pad_x + plot_w, mid_y),
      color,
      1.5,
    )
    return (None, resp)
  }

  // 2. Extremum Calculation with Zero-Delta Protection
  let mut min_val = values[0]
  let mut max_val = values[0]
  for v in values {
    if v < min_val {
      min_val = v
    }
    if v > max_val {
      max_val = v
    }
  }

  let delta = max_val - min_val
  let is_flat = delta < 0.00001

  // 3. Compute Data Coordinates
  let points : Array[@math.Vec2] = []
  let denom = (count - 1).to_double()

  for i = 0; i < count; i = i + 1 {
    let px = rect.x + pad_x + i.to_double() / denom * plot_w
    let py = if is_flat {
      rect.y + pad_y + plot_h * 0.5
    } else {
      let norm = (values[i] - min_val) / delta
      rect.y + pad_y + (1.0 - norm) * plot_h
    }
    points.push(@math.Vec2::new(px, py))
  }

  // 4. Subtle Area Wash Fill
  if fill {
    let fill_col = color.with_alpha(30)
    for i = 0; i < count - 1; i = i + 1 {
      let p1 = points[i]
      let p2 = points[i + 1]
      let slice_w = p2.x - p1.x
      let avg_y = (p1.y + p2.y) * 0.5
      let slice_h = base_y - avg_y
      if slice_h > 0.0 {
        self.draw_list.add_rect(
          @math.Rect::new(p1.x, avg_y, slice_w, slice_h),
          fill_col,
          0.0,
        )
      }
    }
  }

  // 5. Antialiased Polyline
  for i = 0; i < count - 1; i = i + 1 {
    self.draw_list.add_line(points[i], points[i + 1], color, 1.8)
  }

  // 6. Interactive Hover Guideline & Data Dot Snapping
  let mut hovered_idx : Int? = None

  if show_hover && self.is_hovered(rect) {
    let mouse_rel = (self.input.mouse_pos.x - (rect.x + pad_x)) / plot_w
    let raw_idx = (mouse_rel * denom + 0.5).to_int()
    let snapped_idx = if raw_idx < 0 {
      0
    } else if raw_idx >= count {
      count - 1
    } else {
      raw_idx
    }

    hovered_idx = Some(snapped_idx)
    let pt = points[snapped_idx]

    // Vertical dashed guideline
    self.draw_list.add_line(
      @math.Vec2::new(pt.x, rect.y + pad_y),
      @math.Vec2::new(pt.x, base_y),
      color.with_alpha(80),
      1.0,
    )

    // Snapped target dot with dual-ring highlight
    self.draw_list.add_circle(pt, 4.0 * scale, color)
    self.draw_list.add_circle(pt, 2.0 * scale, @color.Color::bg_window())
  }

  (hovered_idx, resp)
}
