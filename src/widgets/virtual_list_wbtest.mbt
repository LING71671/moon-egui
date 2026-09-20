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

///|
test "virtual_list: focus and keyboard navigation" {
  let ctx = @core.UIContext::new()
  let list_id = ctx.id_stack.derive_id("vlist_key_test")

  // Frame 1: mouse down on container
  let raw1 = @core.RawInput::from_mouse(@math.Vec2::new(50.0, 50.0), true)
  ctx.begin_frame(raw1)
  let _ = virtual_list(ctx, "vlist_key_test", 100, 300.0, item_height=30.0, fn(
    _,
    _,
  ) {

  })
  let _ = ctx.end_frame()

  // Frame 2: mouse release completes click, establishing focused state
  let raw2 = @core.RawInput::from_mouse(@math.Vec2::new(50.0, 50.0), false)
  ctx.begin_frame(raw2)
  let _ = virtual_list(ctx, "vlist_key_test", 100, 300.0, item_height=30.0, fn(
    _,
    _,
  ) {

  })
  let _ = ctx.end_frame()
  assert_true(ctx.has_focus(list_id))

  // Frame 3: press ArrowDown -> should advance scroll_y by 30.0 and consume key
  let raw3 = @core.RawInput::with_events(
    @math.Vec2::new(50.0, 50.0),
    false,
    @math.Vec2::zero(),
    [@core.Event::Key(Key::ArrowDown, true, @core.Modifiers::none())],
    "",
    @core.Modifiers::none(),
  )
  ctx.begin_frame(raw3)
  let _ = virtual_list(ctx, "vlist_key_test", 100, 300.0, item_height=30.0, fn(
    _,
    _,
  ) {

  })
  assert_true(ctx.input().is_key_consumed(Key::ArrowDown))
  let dl3 = ctx.end_frame()

  let scroll1 = ctx.get_scroll_offset(list_id)
  assert_eq(scroll1, 30.0)

  // Verify focus ring is rendered in draw list
  let mut has_focus_ring = false
  for i = 0; i < dl3.len(); i = i + 1 {
    if dl3.get_command(i) is Some(@draw.DrawCmd::RectStroke(_)) {
      has_focus_ring = true
    }
  }
  assert_true(has_focus_ring)

  // Frame 4: press End -> jump to max_scroll
  let raw4 = @core.RawInput::with_events(
    @math.Vec2::new(50.0, 50.0),
    false,
    @math.Vec2::zero(),
    [@core.Event::Key(Key::End, true, @core.Modifiers::none())],
    "",
    @core.Modifiers::none(),
  )
  ctx.begin_frame(raw4)
  let _ = virtual_list(ctx, "vlist_key_test", 100, 300.0, item_height=30.0, fn(
    _,
    _,
  ) {

  })
  assert_true(ctx.input().is_key_consumed(Key::End))
  let _ = ctx.end_frame()

  let max_s = 100.0 * 30.0 - 300.0
  let scroll_end = ctx.get_scroll_offset(list_id)
  assert_eq(scroll_end, max_s)
}

///|
test "virtual_list: scrollbar thumb reports pointer cursor" {
  let ctx = @core.UIContext::new()

  // Frame 1: hover over scrollbar thumb area (right edge of 300x300 container)
  let raw1 = @core.RawInput::from_mouse(@math.Vec2::new(295.0, 10.0), false)
  ctx.begin_frame(raw1)
  let list = VirtualList::new("vlist_thumb_test", 100, 300.0)
    .width(300.0)
    .item_height(30.0)
  let _ = list.render(ctx, fn(_, _) {  })
  let _ = ctx.end_frame()

  assert_eq(ctx.cursor_icon(), "pointer")
}
