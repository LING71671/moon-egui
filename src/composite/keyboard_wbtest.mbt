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
/// One key press crossing the host boundary (used by the keyboard tests).
fn kb_key_input(k : @core.Key) -> @core.RawInput {
  @core.RawInput::with_events(
    @math.Vec2::zero(),
    false,
    @math.Vec2::zero(),
    [@core.Event::Key(k, true, @core.Modifiers::none())],
    "",
    @core.Modifiers::none(),
  )
}

///|
test "menu_bar: keyboard opens a dropdown and activates items" {
  let ctx = @core.UIContext::new()
  let ran = Ref(false)
  let render = fn() {
    menu_bar(ctx, fn(top) {
      menu(top, "File", fn(menu) {
        if menu_item(menu, "New").clicked {
          ran.val = true
        }
      })
    })
  }

  // Frame 1: Tab focuses the first menu trigger
  ctx.begin_frame(kb_key_input(@core.Key::Tab))
  render()
  let _ = ctx.end_frame()
  assert_false(ran.val)

  // Frame 2: Enter opens the dropdown
  ctx.begin_frame(kb_key_input(@core.Key::Enter))
  render()
  let _ = ctx.end_frame()
  assert_false(ran.val)

  // Frame 3: Tab moves focus into the dropdown item
  ctx.begin_frame(kb_key_input(@core.Key::Tab))
  render()
  let _ = ctx.end_frame()
  assert_false(ran.val)

  // Frame 4: Enter activates the focused item
  ctx.begin_frame(kb_key_input(@core.Key::Enter))
  render()
  let _ = ctx.end_frame()
  assert_true(ran.val)
}

///|
test "menu_bar: escape closes the open dropdown" {
  let ctx = @core.UIContext::new()
  let render = fn() {
    menu_bar(ctx, fn(top) {
      menu(top, "File", fn(menu) { let _ = menu_item(menu, "New") })
    })
  }

  ctx.begin_frame(kb_key_input(@core.Key::Tab))
  render()
  let _ = ctx.end_frame()

  ctx.begin_frame(kb_key_input(@core.Key::Enter))
  render()
  let _ = ctx.end_frame()

  ctx.begin_frame(kb_key_input(@core.Key::Escape))
  render()
  let _ = ctx.end_frame()

  // After Escape the next Tab pass starts from the trigger again, and the
  // dropdown is gone: activating Enter re-opens instead of clicking an item.
  let ran = Ref(false)
  ctx.begin_frame(kb_key_input(@core.Key::Tab))
  menu_bar(ctx, fn(top) {
    menu(top, "File", fn(menu) {
      if menu_item(menu, "New").clicked {
        ran.val = true
      }
    })
  })
  let _ = ctx.end_frame()
  assert_false(ran.val)
}

///|
test "table: keyboard arrows move the highlight and Enter activates the row" {
  let ctx = @core.UIContext::new()
  let size = @math.Vec2::new(300.0, 120.0)
  let cols = [
    TableColumn::new("id", "ID", 140.0),
    TableColumn::new("name", "Name", 140.0),
  ]
  let render = fn() {
    table(ctx, "kb_table", size, cols, 6, fn(
      _ui : @core.UIContext,
      _r : Int,
      _c : Int,
      _rect : @math.Rect,
    ) {

    })
  }

  // Frame 1: Tab focuses the table
  ctx.begin_frame(kb_key_input(@core.Key::Tab))
  let resp1 = render()
  let _ = ctx.end_frame()
  assert_eq(resp1.clicked_row, None)

  // Frame 2: ArrowDown moves the keyboard highlight to row 1
  ctx.begin_frame(kb_key_input(@core.Key::ArrowDown))
  let resp2 = render()
  let _ = ctx.end_frame()
  assert_eq(resp2.clicked_row, None)

  // Frame 3: Enter activates the highlighted row
  ctx.begin_frame(kb_key_input(@core.Key::Enter))
  let resp3 = render()
  let _ = ctx.end_frame()
  assert_eq(resp3.clicked_row, Some(1))
}
