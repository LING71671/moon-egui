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
/// A single 2D vertex holding spatial coordinates, UV texture coordinates,
/// and normalized RGBA color channels for hardware-accelerated GPU rasterization.
pub struct Vertex {
  x : Double
  y : Double
  u : Double
  v : Double
  r : Double
  g : Double
  b : Double
  a : Double
} derive(Eq, Debug, Default)

///|
pub fn Vertex::new(
  x : Double,
  y : Double,
  u? : Double = 0.0,
  v? : Double = 0.0,
  color? : @color.Color = @color.Color::white(),
) -> Vertex {
  {
    x,
    y,
    u,
    v,
    r: color.r.to_double() / 255.0,
    g: color.g.to_double() / 255.0,
    b: color.b.to_double() / 255.0,
    a: color.a.to_double() / 255.0,
  }
}

///|
/// Contiguous 2D triangle mesh holding vertex and index buffers for batched WebGL/GPU rendering.
pub struct Mesh {
  vertices : Array[Vertex]
  indices : Array[Int]
} derive(Eq, Debug)

///|
pub fn Mesh::new() -> Mesh {
  { vertices: [], indices: [], }
}

///|
pub fn Mesh::clear(self : Mesh) -> Unit {
  self.vertices.clear()
  self.indices.clear()
}

///|
pub fn Mesh::vertex_count(self : Mesh) -> Int {
  self.vertices.length()
}

///|
pub fn Mesh::index_count(self : Mesh) -> Int {
  self.indices.length()
}

///|
pub fn Mesh::add_vertex(self : Mesh, v : Vertex) -> Int {
  let idx = self.vertices.length()
  self.vertices.push(v)
  idx
}

///|
pub fn Mesh::add_triangle(self : Mesh, i0 : Int, i1 : Int, i2 : Int) -> Unit {
  self.indices.push(i0)
  self.indices.push(i1)
  self.indices.push(i2)
}

///|
/// Appends a quad defined by 4 vertex indices (i0: top-left, i1: top-right, i2: bottom-right, i3: bottom-left).
pub fn Mesh::add_quad(
  self : Mesh,
  i0 : Int,
  i1 : Int,
  i2 : Int,
  i3 : Int,
) -> Unit {
  self.add_triangle(i0, i1, i2)
  self.add_triangle(i0, i2, i3)
}

///|
/// Serializes interleaved vertex attributes (x, y, u, v, r, g, b, a) into a flat array
/// for direct WebGL Float32Buffer upload.
pub fn Mesh::write_vertex_floats(self : Mesh, out : Array[Double]) -> Unit {
  for v in self.vertices {
    out.push(v.x)
    out.push(v.y)
    out.push(v.u)
    out.push(v.v)
    out.push(v.r)
    out.push(v.g)
    out.push(v.b)
    out.push(v.a)
  }
}

///|
/// Tessellates a filled solid rectangle into the mesh.
pub fn Mesh::tessellate_rect(
  self : Mesh,
  rect : @math.Rect,
  color : @color.Color,
  corner_radius : Double,
) -> Unit {
  if rect.w <= 0.0 || rect.h <= 0.0 {
    return
  }

  let r_clamped = if corner_radius <= 0.0 {
    0.0
  } else {
    let max_r = if rect.w < rect.h { rect.w * 0.5 } else { rect.h * 0.5 }
    if corner_radius > max_r {
      max_r
    } else {
      corner_radius
    }
  }

  if r_clamped <= 0.0 {
    let i0 = self.add_vertex(Vertex::new(rect.x, rect.y, color~))
    let i1 = self.add_vertex(Vertex::new(rect.x + rect.w, rect.y, color~))
    let i2 = self.add_vertex(
      Vertex::new(rect.x + rect.w, rect.y + rect.h, color~),
    )
    let i3 = self.add_vertex(Vertex::new(rect.x, rect.y + rect.h, color~))
    self.add_quad(i0, i1, i2, i3)
  } else {
    // Nine-patch rounded rect tessellation with 4 corner fans
    let segments = 4
    let center_idx = self.add_vertex(
      Vertex::new(rect.x + rect.w * 0.5, rect.y + rect.h * 0.5, color~),
    )

    let corner_centers = [
      (rect.x + rect.w - r_clamped, rect.y + r_clamped, 0.0), // Top-Right (0 to pi/2)
      (rect.x + rect.w - r_clamped, rect.y + rect.h - r_clamped, @math.pi * 0.5), // Bottom-Right (pi/2 to pi)
      (rect.x + r_clamped, rect.y + rect.h - r_clamped, @math.pi), // Bottom-Left (pi to 3pi/2)
      (rect.x + r_clamped, rect.y + r_clamped, @math.pi * 1.5), // Top-Left (3pi/2 to 2pi)
    ]

    let perimeter_indices : Array[Int] = []

    for c in corner_centers {
      let (cx, cy, base_angle) = c
      for s = 0; s <= segments; s = s + 1 {
        // Skip duplicate starting vertex for subsequent corners
        if s == 0 && !perimeter_indices.is_empty() {
          continue
        }
        let angle = base_angle +
          @math.pi * 0.5 * (s.to_double() / segments.to_double())
        let px = cx + r_clamped * @math.cos(angle)
        let py = cy + r_clamped * @math.sin(angle)
        let idx = self.add_vertex(Vertex::new(px, py, color~))
        perimeter_indices.push(idx)
      }
    }

    let p_len = perimeter_indices.length()
    for i = 0; i < p_len; i = i + 1 {
      let next_i = (i + 1) % p_len
      self.add_triangle(
        center_idx,
        perimeter_indices[i],
        perimeter_indices[next_i],
      )
    }
  }
}

///|
/// Tessellates a stroked rectangle border into the mesh.
pub fn Mesh::tessellate_rect_stroke(
  self : Mesh,
  rect : @math.Rect,
  color : @color.Color,
  stroke_width : Double,
  corner_radius? : Double = 0.0,
) -> Unit {
  let _ = corner_radius
  if stroke_width <= 0.0 || rect.w <= 0.0 || rect.h <= 0.0 {
    return
  }
  let half_sw = stroke_width * 0.5
  let o_x = rect.x - half_sw
  let o_y = rect.y - half_sw
  let o_w = rect.w + stroke_width
  let o_h = rect.h + stroke_width

  let i_x = rect.x + half_sw
  let i_y = rect.y + half_sw
  let i_w = if rect.w > stroke_width { rect.w - stroke_width } else { 0.0 }
  let i_h = if rect.h > stroke_width { rect.h - stroke_width } else { 0.0 }

  // 4 outer vertices
  let o0 = self.add_vertex(Vertex::new(o_x, o_y, color~))
  let o1 = self.add_vertex(Vertex::new(o_x + o_w, o_y, color~))
  let o2 = self.add_vertex(Vertex::new(o_x + o_w, o_y + o_h, color~))
  let o3 = self.add_vertex(Vertex::new(o_x, o_y + o_h, color~))

  // 4 inner vertices
  let i0 = self.add_vertex(Vertex::new(i_x, i_y, color~))
  let i1 = self.add_vertex(Vertex::new(i_x + i_w, i_y, color~))
  let i2 = self.add_vertex(Vertex::new(i_x + i_w, i_y + i_h, color~))
  let i3 = self.add_vertex(Vertex::new(i_x, i_y + i_h, color~))

  // Top edge
  self.add_quad(o0, o1, i1, i0)
  // Right edge
  self.add_quad(o1, o2, i2, i1)
  // Bottom edge
  self.add_quad(i3, i2, o2, o3)
  // Left edge
  self.add_quad(o0, i0, i3, o3)
}

///|
/// Tessellates a filled solid circle into a triangle fan.
pub fn Mesh::tessellate_circle(
  self : Mesh,
  center : @math.Vec2,
  radius : Double,
  color : @color.Color,
  segments? : Int = 32,
) -> Unit {
  if radius <= 0.0 || segments < 3 {
    return
  }

  let center_idx = self.add_vertex(Vertex::new(center.x, center.y, color~))
  let step = @math.pi * 2.0 / segments.to_double()
  let first_perim = self.add_vertex(
    Vertex::new(center.x + radius, center.y, color~),
  )
  let mut prev_idx = first_perim

  for i = 1; i < segments; i = i + 1 {
    let angle = step * i.to_double()
    let px = center.x + radius * @math.cos(angle)
    let py = center.y + radius * @math.sin(angle)
    let cur_idx = self.add_vertex(Vertex::new(px, py, color~))
    self.add_triangle(center_idx, prev_idx, cur_idx)
    prev_idx = cur_idx
  }
  self.add_triangle(center_idx, prev_idx, first_perim)
}

///|
/// Tessellates a line segment into an oriented rectangle quad.
pub fn Mesh::tessellate_line(
  self : Mesh,
  start : @math.Vec2,
  end : @math.Vec2,
  color : @color.Color,
  stroke_width : Double,
) -> Unit {
  if stroke_width <= 0.0 {
    return
  }
  let dx = end.x - start.x
  let dy = end.y - start.y
  let len_sq = dx * dx + dy * dy
  if len_sq <= 0.0001 {
    return
  }

  // Fast approximation or exact normal
  let half_sw = stroke_width * 0.5
  // Length using standard distance
  let len = len_sq / (len_sq / 2.0 + 0.5) // positive fallback
  // Normalize normal vector (-dy, dx)
  let nx = -dy / len * half_sw
  let ny = dx / len * half_sw

  let i0 = self.add_vertex(Vertex::new(start.x + nx, start.y + ny, color~))
  let i1 = self.add_vertex(Vertex::new(end.x + nx, end.y + ny, color~))
  let i2 = self.add_vertex(Vertex::new(end.x - nx, end.y - ny, color~))
  let i3 = self.add_vertex(Vertex::new(start.x - nx, start.y - ny, color~))
  self.add_quad(i0, i1, i2, i3)
}

///|
/// Batch converts an entire DrawList into a single contiguous Mesh.
///
/// NOTE on primitive support and lossy conversions:
/// - Supports geometric vector primitives: Rect, RectStroke, Circle, and Line.
/// - LinearGradient is approximated as a solid rectangle filled with `start_col`,
///   as smooth vertex gradient interpolation requires multi-color vertex meshes or shader support.
/// - Text commands are skipped here; text geometry must be generated via a font atlas texture.
/// - Clip commands are not tessellated into vertex geometry; viewport clipping must be
///   managed via hardware scissor test or geometric polygon clipping.
pub fn Mesh::tessellate_draw_list(self : Mesh, draw_list : DrawList) -> Unit {
  for cmd in draw_list.commands {
    match cmd {
      DrawCmd::Rect(rect, color, radius) =>
        self.tessellate_rect(rect, color, radius)
      DrawCmd::RectStroke(rect, color, stroke_width, radius) =>
        self.tessellate_rect_stroke(
          rect,
          color,
          stroke_width,
          corner_radius=radius,
        )
      DrawCmd::Circle(center, radius, color) =>
        self.tessellate_circle(center, radius, color)
      DrawCmd::Line(start, end, color, stroke_width) =>
        self.tessellate_line(start, end, color, stroke_width)
      DrawCmd::LinearGradient(rect, _p0, _p1, start_col, _end_col, radius) =>
        self.tessellate_rect(rect, start_col, radius)
      _ => () // Text and Clip are managed via font atlas or Scissor tests
    }
  }
}

///|
/// Extension method to directly compile a DrawList into a Mesh.
pub fn DrawList::to_mesh(self : DrawList) -> Mesh {
  let mesh = Mesh::new()
  mesh.tessellate_draw_list(self)
  mesh
}
