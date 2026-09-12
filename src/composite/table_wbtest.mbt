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
test "table: virtual scrolling renders only visible rows" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::new())

  let cols = [
    TableColumn::new("id", "ID", 60.0),
    TableColumn::new("name", "Name", 140.0),
  ]

  let mut rendered_cells = 0
  let mut max_row_seen = -1

  let resp = table(
    ctx,
    "virtual_test",
    @math.Vec2::new(300.0, 200.0),
    cols,
    10000,
    fn(_ui, r, _c, _rect) {
      rendered_cells = rendered_cells + 1
      if r > max_row_seen {
        max_row_seen = r
      }
    },
    row_height=28.0,
    header_height=32.0,
  )

  let _ = ctx.end_frame()

  // 200 - 32 = 168px body height. 168 / 28 = 6 visible rows + 2 buffer = 8 rows
  // 8 rows * 2 cols = 16 cells (far less than 10000 * 2 = 20000 cells!)
  assert_true(rendered_cells <= 20)
  assert_true(max_row_seen < 15)
  assert_eq(resp.sort_changed, false)
}

///|
test "table: clicking sortable header changes sort state" {
  let ctx = UIContext::new()

  let cols = [
    TableColumn::new("id", "ID", 80.0, sortable=true),
    TableColumn::new("name", "Name", 120.0, sortable=false),
  ]

  // Click at (x = 30.0, y = 15.0) which is inside ID header
  let raw = RawInput::from_mouse(@math.Vec2::new(30.0, 15.0), true)
  ctx.begin_frame(raw)

  let resp = table(
    ctx,
    "sort_test",
    @math.Vec2::new(300.0, 200.0),
    cols,
    10,
    fn(_ui, _r, _c, _rect) { () },
    sort_column="",
    sort_direction=NoSort,
  )
  let _ = ctx.end_frame()

  assert_true(resp.sort_changed)
  assert_eq(resp.sort_column, "id")
  assert_eq(resp.sort_direction, TableSortDirection::Ascending)
}

///|
test "table: dragging column handle resizes column width" {
  let ctx = UIContext::new()

  let cols = [
    TableColumn::new("col1", "Col 1", 100.0, min_width=50.0),
    TableColumn::new("col2", "Col 2", 150.0, min_width=50.0),
  ]

  // Frame 1: Mouse down at col1 right handle (x = 100.0, y = 15.0)
  let raw1 = RawInput::from_mouse(@math.Vec2::new(100.0, 15.0), true)
  ctx.begin_frame(raw1)
  let _ = table(ctx, "resize_test", @math.Vec2::new(400.0, 200.0), cols, 5, fn(
    _ui,
    _r,
    _c,
    _rect,
  ) {
    ()
  })
  let _ = ctx.end_frame()

  // Frame 2: Drag mouse to x = 160.0
  let raw2 = RawInput::from_mouse(@math.Vec2::new(160.0, 15.0), true)
  ctx.begin_frame(raw2)
  let _ = table(ctx, "resize_test", @math.Vec2::new(400.0, 200.0), cols, 5, fn(
    _ui,
    _r,
    _c,
    _rect,
  ) {
    ()
  })
  let _ = ctx.end_frame()

  assert_eq(cols[0].width, 160.0)
}

///|
test "table: row click detection" {
  let ctx = UIContext::new()

  let cols = [TableColumn::new("id", "ID", 100.0)]

  // Header height is 32.0. Row 0 is at y = 32.0 to 60.0.
  // Click at (x = 50.0, y = 45.0) which is inside Row 0
  let raw = RawInput::from_mouse(@math.Vec2::new(50.0, 45.0), true)
  ctx.begin_frame(raw)

  let resp = table(ctx, "click_test", @math.Vec2::new(200.0, 200.0), cols, 10, fn(
    _ui,
    _r,
    _c,
    _rect,
  ) {
    ()
  })
  let _ = ctx.end_frame()

  assert_eq(resp.clicked_row, Some(0))
  assert_eq(resp.hovered_row, Some(0))
}
