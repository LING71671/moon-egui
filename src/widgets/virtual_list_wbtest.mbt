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
test "virtual_list: 10000 items renders only visible window" {
  let ctx = @core.UIContext::new()
  ctx.begin_frame(@core.RawInput::from_mouse(@math.Vec2::zero(), false))

  let rendered_items : Array[Int] = []
  let resp = virtual_list(ctx, "massive_list", 10000, 300.0, item_height=30.0, fn(
    idx,
    _rect,
  ) {
    rendered_items.push(idx)
  })
  let _ = ctx.end_frame()

  // For height=300 and item_height=30, visible window is 10 items + overscan (2*2 = 4) = 14 items
  assert_true(rendered_items.length() < 25)
  assert_eq(resp.first_visible, 0)
  assert_true(resp.last_visible < 20)
  assert_true(rendered_items.contains(0))
  assert_false(rendered_items.contains(5000))
}

///|
test "virtual_list: scrolling advances visible slice" {
  let ctx = @core.UIContext::new()
  let list_id = ctx.id_stack.derive_id("scrolling_list")

  // Simulate scroll offset of 3000.0 px (at item_height 30.0, this is around item 100)
  ctx.set_scroll_offset(list_id, 3000.0)

  ctx.begin_frame(@core.RawInput::from_mouse(@math.Vec2::zero(), false))
  let rendered_items : Array[Int] = []
  let resp = virtual_list(
    ctx,
    "scrolling_list",
    1000,
    300.0,
    item_height=30.0,
    fn(idx, _rect) { rendered_items.push(idx) },
  )
  let _ = ctx.end_frame()

  // First visible index should be near item 98-100 (100 - overscan 2)
  assert_true(resp.first_visible >= 95 && resp.first_visible <= 100)
  assert_true(rendered_items.contains(100))
  assert_false(rendered_items.contains(0))
}

///|
test "virtual_list: empty list handling" {
  let ctx = @core.UIContext::new()
  ctx.begin_frame(@core.RawInput::from_mouse(@math.Vec2::zero(), false))

  let rendered_items : Array[Int] = []
  let resp = virtual_list(ctx, "empty_list", 0, 300.0, item_height=30.0, fn(
    idx,
    _rect,
  ) {
    rendered_items.push(idx)
  })
  let _ = ctx.end_frame()

  assert_eq(rendered_items.length(), 0)
  assert_eq(resp.first_visible, 0)
  assert_eq(resp.last_visible, -1)
}
