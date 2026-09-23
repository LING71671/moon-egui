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
test "widgets: pagination item generation logic" {
  // Total <= 7: shows all pages
  let items_small = generate_pagination_items(1, 5)
  assert_eq(items_small, [
    PaginationItem::Page(1),
    PaginationItem::Page(2),
    PaginationItem::Page(3),
    PaginationItem::Page(4),
    PaginationItem::Page(5),
  ])

  // Current near start: current = 3, total = 10 -> [1, 2, 3, 4, 5, ..., 10]
  let items_start = generate_pagination_items(3, 10)
  assert_eq(items_start, [
    PaginationItem::Page(1),
    PaginationItem::Page(2),
    PaginationItem::Page(3),
    PaginationItem::Page(4),
    PaginationItem::Page(5),
    PaginationItem::Ellipsis,
    PaginationItem::Page(10),
  ])

  // Current near end: current = 8, total = 10 -> [1, ..., 6, 7, 8, 9, 10]
  let items_end = generate_pagination_items(8, 10)
  assert_eq(items_end, [
    PaginationItem::Page(1),
    PaginationItem::Ellipsis,
    PaginationItem::Page(6),
    PaginationItem::Page(7),
    PaginationItem::Page(8),
    PaginationItem::Page(9),
    PaginationItem::Page(10),
  ])

  // Current in middle: current = 6, total = 12 -> [1, ..., 5, 6, 7, ..., 12]
  let items_middle = generate_pagination_items(6, 12)
  assert_eq(items_middle, [
    PaginationItem::Page(1),
    PaginationItem::Ellipsis,
    PaginationItem::Page(5),
    PaginationItem::Page(6),
    PaginationItem::Page(7),
    PaginationItem::Ellipsis,
    PaginationItem::Page(12),
  ])
}

///|
test "widgets: pagination builder and geometry allocation" {
  let ctx = UIContext::new()
  ctx.begin_frame(@core.RawInput::new())

  let (p, resp) = Pagination::new("pg_builder", 1, 10)
    .item_size(32.0)
    .spacing(4.0)
    .show_prev_next(true)
    .show(ctx)

  assert_eq(p, 1)
  // 7 page items + 2 nav buttons = 9 items
  // 9 * 32.0 + 8 * 4.0 = 288.0 + 32.0 = 320.0
  assert_eq(resp.rect.w, 320.0)
  assert_eq(resp.rect.h, 32.0)

  let dl = ctx.end_frame()
  assert_true(dl.len() > 0)
}

///|
test "widgets: pagination click page button" {
  let ctx = UIContext::new()
  // Layout with item_size=30, spacing=10
  // Buttons:
  // 0: Prev -> [0..30]
  // 1: Page(1) -> [40..70]
  // 2: Page(2) -> [80..110]
  // 3: Page(3) -> [120..150]
  // 4: Page(4) -> [160..190]
  // 5: Page(5) -> [200..230]
  // 6: Next -> [240..270]

  // Frame 1: Mouse down on Page(3) (x=135.0, y=15.0)
  let raw1 = @core.RawInput::from_mouse(@math.Vec2::new(135.0, 15.0), true)
  ctx.begin_frame(raw1)
  let (p1, _) = pagination(ctx, "pg_click", 1, 5, item_size=30.0, spacing=10.0)
  assert_eq(p1, 1)
  let _ = ctx.end_frame()

  // Frame 2: Mouse release on Page(3)
  let raw2 = @core.RawInput::from_mouse(@math.Vec2::new(135.0, 15.0), false)
  ctx.begin_frame(raw2)
  let (p2, _) = pagination(ctx, "pg_click", 1, 5, item_size=30.0, spacing=10.0)
  assert_eq(p2, 3)
  let _ = ctx.end_frame()
}

///|
test "widgets: pagination click prev and next buttons" {
  let ctx = UIContext::new()
  // Layout with item_size=30, spacing=10
  // Prev: [0..30], Page(1): [40..70], Page(2): [80..110], Page(3): [120..150], Next: [160..190]

  // 1. Click Next from page 1 (Next is at x=175.0)
  let raw_next_down = @core.RawInput::from_mouse(
    @math.Vec2::new(175.0, 15.0),
    true,
  )
  ctx.begin_frame(raw_next_down)
  let _ = pagination(ctx, "pg_nav", 1, 3, item_size=30.0, spacing=10.0)
  let _ = ctx.end_frame()

  let raw_next_up = @core.RawInput::from_mouse(
    @math.Vec2::new(175.0, 15.0),
    false,
  )
  ctx.begin_frame(raw_next_up)
  let (p_after_next, _) = pagination(
    ctx,
    "pg_nav",
    1,
    3,
    item_size=30.0,
    spacing=10.0,
  )
  assert_eq(p_after_next, 2)
  let _ = ctx.end_frame()

  // 2. Click Prev from page 2 (Prev is at x=15.0)
  let raw_prev_down = @core.RawInput::from_mouse(
    @math.Vec2::new(15.0, 15.0),
    true,
  )
  ctx.begin_frame(raw_prev_down)
  let _ = pagination(ctx, "pg_nav", 2, 3, item_size=30.0, spacing=10.0)
  let _ = ctx.end_frame()

  let raw_prev_up = @core.RawInput::from_mouse(
    @math.Vec2::new(15.0, 15.0),
    false,
  )
  ctx.begin_frame(raw_prev_up)
  let (p_after_prev, _) = pagination(
    ctx,
    "pg_nav",
    2,
    3,
    item_size=30.0,
    spacing=10.0,
  )
  assert_eq(p_after_prev, 1)
  let _ = ctx.end_frame()

  // 3. Prev should not go below 1
  ctx.begin_frame(raw_prev_up)
  let (p_floor, _) = pagination(
    ctx,
    "pg_nav",
    1,
    3,
    item_size=30.0,
    spacing=10.0,
  )
  assert_eq(p_floor, 1)
  let _ = ctx.end_frame()
}

///|
test "widgets: pagination keyboard navigation" {
  let ctx = UIContext::new()

  // Frame 1: Tab to focus pagination
  let raw_tab = @core.RawInput::with_events(
    @math.Vec2::zero(),
    false,
    @math.Vec2::zero(),
    [@core.Event::Key(@core.Key::Tab, true, @core.Modifiers::none())],
    "",
    @core.Modifiers::none(),
  )
  ctx.begin_frame(raw_tab)
  let (p0, _) = pagination(ctx, "pg_kb", 2, 10)
  assert_eq(p0, 2)
  let _ = ctx.end_frame()

  // Frame 2: ArrowRight increments to page 3
  let raw_right = @core.RawInput::with_events(
    @math.Vec2::zero(),
    false,
    @math.Vec2::zero(),
    [@core.Event::Key(@core.Key::ArrowRight, true, @core.Modifiers::none())],
    "",
    @core.Modifiers::none(),
  )
  ctx.begin_frame(raw_right)
  let (p1, _) = pagination(ctx, "pg_kb", 2, 10)
  assert_eq(p1, 3)
  let _ = ctx.end_frame()

  // Frame 3: End jumps to last page (10)
  let raw_end = @core.RawInput::with_events(
    @math.Vec2::zero(),
    false,
    @math.Vec2::zero(),
    [@core.Event::Key(@core.Key::End, true, @core.Modifiers::none())],
    "",
    @core.Modifiers::none(),
  )
  ctx.begin_frame(raw_end)
  let (p_end, _) = pagination(ctx, "pg_kb", 3, 10)
  assert_eq(p_end, 10)
  let _ = ctx.end_frame()

  // Frame 4: Home jumps to first page (1)
  let raw_home = @core.RawInput::with_events(
    @math.Vec2::zero(),
    false,
    @math.Vec2::zero(),
    [@core.Event::Key(@core.Key::Home, true, @core.Modifiers::none())],
    "",
    @core.Modifiers::none(),
  )
  ctx.begin_frame(raw_home)
  let (p_home, _) = pagination(ctx, "pg_kb", 10, 10)
  assert_eq(p_home, 1)
  let _ = ctx.end_frame()
}

///|
test "widgets: pagination from_ref binding" {
  let ctx = UIContext::new()
  let current_ref = Ref(2)

  let raw1 = @core.RawInput::from_mouse(@math.Vec2::new(175.0, 15.0), true)
  ctx.begin_frame(raw1)
  let _ = ctx.add(
    Pagination::from_ref("pg_ref", current_ref, 5).item_size(30.0).spacing(10.0),
  )
  let _ = ctx.end_frame()

  // Click Next button (x=240..270 for 5 pages + 2 navs = 7 buttons)
  // Prev(0..30), 1(40..70), 2(80..110), 3(120..150), 4(160..190), 5(200..230), Next(240..270)
  let raw2 = @core.RawInput::from_mouse(@math.Vec2::new(255.0, 15.0), false)
  ctx.begin_frame(raw2)
  let _ = ctx.add(
    Pagination::from_ref("pg_ref", current_ref, 5).item_size(30.0).spacing(10.0),
  )
  assert_eq(current_ref.val, 3)
  let _ = ctx.end_frame()
}

///|
test "widgets: pagination PageUp and PageDown coarse navigation" {
  let ctx = UIContext::new()

  // Frame 1: Tab into pagination
  let raw_tab = @core.RawInput::with_events(
    @math.Vec2::zero(),
    false,
    @math.Vec2::zero(),
    [@core.Event::Key(@core.Key::Tab, true, @core.Modifiers::none())],
    "",
    @core.Modifiers::none(),
  )
  ctx.begin_frame(raw_tab)
  let (p0, _) = pagination(ctx, "pg_coarse", 2, 20)
  let _ = ctx.end_frame()
  assert_eq(p0, 2)

  // Frame 2: PageDown steps forward by 5 pages (2 + 5 = 7)
  let raw_pgdn = @core.RawInput::with_events(
    @math.Vec2::zero(),
    false,
    @math.Vec2::zero(),
    [@core.Event::Key(@core.Key::PageDown, true, @core.Modifiers::none())],
    "",
    @core.Modifiers::none(),
  )
  ctx.begin_frame(raw_pgdn)
  let (p1, _) = pagination(ctx, "pg_coarse", 2, 20)
  let _ = ctx.end_frame()
  assert_eq(p1, 7)

  // Frame 3: PageUp steps backward by 5 pages (7 - 5 = 2)
  let raw_pgup = @core.RawInput::with_events(
    @math.Vec2::zero(),
    false,
    @math.Vec2::zero(),
    [@core.Event::Key(@core.Key::PageUp, true, @core.Modifiers::none())],
    "",
    @core.Modifiers::none(),
  )
  ctx.begin_frame(raw_pgup)
  let (p2, _) = pagination(ctx, "pg_coarse", 7, 20)
  let _ = ctx.end_frame()
  assert_eq(p2, 2)
}
