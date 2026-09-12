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
test "layout_engine: top-down cursor advancement" {
  let le = LayoutEngine::new()
  le.begin_frame(800.0)

  let r1 = le.allocate_rect(@math.Vec2::new(100.0, 30.0))
  assert_eq(r1, @math.Rect::new(0.0, 0.0, 100.0, 30.0))
  assert_eq(le.cursor(), @math.Vec2::new(0.0, 38.0)) // 30 + 8

  let r2 = le.allocate_rect(@math.Vec2::new(100.0, 20.0))
  assert_eq(r2, @math.Rect::new(0.0, 38.0, 100.0, 20.0))
  assert_eq(le.cursor(), @math.Vec2::new(0.0, 66.0)) // 38 + 20 + 8
}

///|
test "layout_engine: left-to-right wrapped scope wrapping" {
  let le = LayoutEngine::new()
  le.begin_frame(300.0)

  le.push_scope({
    dir: LeftToRightWrapped,
    start_x: 0.0,
    start_y: 0.0,
    max_cross_size: 0.0,
    current_row_h: 0.0,
    wrap_width: 150.0,
  })

  // First item: fits on first row
  let r1 = le.allocate_rect(@math.Vec2::new(80.0, 25.0))
  assert_eq(r1.x, 0.0)
  assert_eq(r1.y, 0.0)

  // Second item: 80 + 8 + 80 = 168 > 150 -> wraps to row 2
  let r2 = le.allocate_rect(@math.Vec2::new(80.0, 25.0))
  assert_eq(r2.x, 0.0)
  assert_eq(r2.y, 33.0) // 25 + 8
}
