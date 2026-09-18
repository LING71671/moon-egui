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
test "mesh: rect tessellation produces 4 vertices and 2 triangles" {
  let mesh = Mesh::new()
  mesh.tessellate_rect(
    @math.Rect::new(10.0, 20.0, 100.0, 50.0),
    @color.Color::rgb(255, 0, 0),
    0.0,
  )
  assert_eq(mesh.vertex_count(), 4)
  assert_eq(mesh.index_count(), 6)

  // Verify vertex coordinate boundaries
  let v0 = mesh.vertices[0]
  assert_eq(v0.x, 10.0)
  assert_eq(v0.y, 20.0)
  assert_eq(v0.r, 1.0)
  assert_eq(v0.g, 0.0)
  assert_eq(v0.b, 0.0)
  assert_eq(v0.a, 1.0)
}

///|
test "mesh: stroked rect tessellation produces 4 edge quads" {
  let mesh = Mesh::new()
  mesh.tessellate_rect_stroke(
    @math.Rect::new(0.0, 0.0, 40.0, 40.0),
    @color.Color::black(),
    2.0,
  )
  // 4 outer + 4 inner = 8 vertices, 4 quads * 6 = 24 indices
  assert_eq(mesh.vertex_count(), 8)
  assert_eq(mesh.index_count(), 24)
}

///|
test "mesh: circle tessellation fan topology" {
  let mesh = Mesh::new()
  mesh.tessellate_circle(
    @math.Vec2::new(50.0, 50.0),
    20.0,
    @color.Color::rgb(0, 255, 0),
    segments=16,
  )
  // 1 center + 16 perimeter = 17 vertices, 16 triangles * 3 = 48 indices
  assert_eq(mesh.vertex_count(), 17)
  assert_eq(mesh.index_count(), 48)

  let center = mesh.vertices[0]
  assert_eq(center.x, 50.0)
  assert_eq(center.y, 50.0)
}

///|
test "mesh: line tessellation produces oriented quad" {
  let mesh = Mesh::new()
  mesh.tessellate_line(
    @math.Vec2::new(0.0, 0.0),
    @math.Vec2::new(100.0, 0.0),
    @color.Color::rgb(0, 0, 255),
    4.0,
  )
  assert_eq(mesh.vertex_count(), 4)
  assert_eq(mesh.index_count(), 6)
}

///|
test "mesh: batch draw list tessellation" {
  let dl = DrawList::new()
  dl.add_rect(@math.Rect::new(0.0, 0.0, 50.0, 50.0), @color.Color::white(), 0.0)
  dl.add_circle(@math.Vec2::new(100.0, 100.0), 10.0, @color.Color::black())
  dl.add_line(
    @math.Vec2::new(0.0, 0.0),
    @math.Vec2::new(50.0, 50.0),
    @color.Color::rgb(255, 0, 0),
    2.0,
  )

  let mesh = dl.to_mesh()
  // Rect (4) + Circle (33) + Line (4) = 41 vertices
  assert_eq(mesh.vertex_count(), 41)
  // Rect (6) + Circle (32 * 3 = 96) + Line (6) = 108 indices
  assert_eq(mesh.index_count(), 108)
}

///|
test "mesh: write_vertex_floats interleaved buffer" {
  let mesh = Mesh::new()
  mesh.tessellate_rect(
    @math.Rect::new(0.0, 0.0, 10.0, 10.0),
    @color.Color::rgba(255, 128, 0, 255),
    0.0,
  )

  let floats : Array[Double] = []
  mesh.write_vertex_floats(floats)
  // 4 vertices * 8 floats per vertex = 32 floats
  assert_eq(floats.length(), 32)
  // First vertex: x=0, y=0, u=0, v=0, r=1, g~0.5, b=0, a=1
  assert_eq(floats[0], 0.0)
  assert_eq(floats[1], 0.0)
  assert_eq(floats[4], 1.0)
  assert_eq(floats[7], 1.0)
}

///|
test "mesh: degenerate geometries do not corrupt buffer" {
  let mesh = Mesh::new()
  // Empty or negative dimensions
  mesh.tessellate_rect(
    @math.Rect::new(0.0, 0.0, -10.0, 20.0),
    @color.Color::black(),
    0.0,
  )
  mesh.tessellate_circle(@math.Vec2::zero(), 0.0, @color.Color::black())
  mesh.tessellate_line(
    @math.Vec2::zero(),
    @math.Vec2::zero(),
    @color.Color::black(),
    0.0,
  )
  assert_eq(mesh.vertex_count(), 0)
  assert_eq(mesh.index_count(), 0)
}
