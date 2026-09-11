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
test "menu_bar: basic layout and initial closed state" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::new())

  ctx.menu_bar(fn(bar) {
    bar.menu("文件", fn(menu) { let _ = menu.menu_item("新建") })
    bar.menu("视图", fn(menu) { let _ = menu.menu_item("重置") })
  })

  // Cursor should be advanced downwards by 28px (menu bar height)
  assert_eq(ctx.cursor().y, 28.0)
  assert_eq(ctx.open_menu_id(), Id::zero())

  let dl = ctx.end_frame()
  assert_true(dl.len() > 0)
}

///|
test "menu_bar: click trigger opens menu dropdown" {
  let ctx = UIContext::new()

  // Frame 1: Press on the "文件" menu trigger button (around x=16, y=10)
  let raw1 = RawInput::from_mouse(@math.Vec2::new(16.0, 10.0), true)
  ctx.begin_frame(raw1)

  let mut item_rendered = false
  ctx.menu_bar(fn(bar) {
    bar.menu("文件", fn(menu) {
      item_rendered = true
      let _ = menu.menu_item("新建", shortcut="⌘N")
    })
  })

  let _ = ctx.end_frame()
  // Menu should now be open!
  assert_true(ctx.open_menu_id() != Id::zero())

  // Frame 2: Mouse released at same position; items should now be rendered
  let raw2 = RawInput::from_mouse(@math.Vec2::new(16.0, 10.0), false)
  ctx.begin_frame(raw2)

  item_rendered = false
  ctx.menu_bar(fn(bar) {
    bar.menu("文件", fn(menu) {
      item_rendered = true
      let _ = menu.menu_item("新建", shortcut="⌘N")
      menu.menu_separator()
      let _ = menu.menu_item("退出", shortcut="⌘Q")
    })
  })

  let dl2 = ctx.end_frame()
  assert_true(item_rendered)
  assert_true(ctx.open_menu_id() != Id::zero())
  // Draw list should include background rects, separators, shadow, and text
  assert_true(dl2.len() >= 6)
}

///|
test "menu_bar: desktop hover-to-switch between open menus" {
  let ctx = UIContext::new()

  // Manually open "文件" menu
  let file_id = ctx.id_stack.derive_id("menu::文件")
  let view_id = ctx.id_stack.derive_id("menu::视图")
  ctx.set_open_menu_id(file_id)

  // Frame: Mouse is hovering over "视图" button (x ≈ 65, y = 12) without clicking
  let raw = RawInput::from_mouse(@math.Vec2::new(65.0, 12.0), false)
  ctx.begin_frame(raw)

  ctx.menu_bar(fn(bar) {
    bar.menu("文件", fn(menu) { let _ = menu.menu_item("新建") })
    bar.menu("视图", fn(menu) { let _ = menu.menu_item("自适应") })
  })

  let _ = ctx.end_frame()
  // Active menu should have smoothly switched to "视图" without any mouse click!
  assert_eq(ctx.open_menu_id(), view_id)
}

///|
test "menu_bar: clicking menu_item triggers action and dismisses menu" {
  let ctx = UIContext::new()
  let file_id = ctx.id_stack.derive_id("menu::文件")
  ctx.set_open_menu_id(file_id)

  // First menu item is at (x ≈ 10, y ≈ 35) inside dropdown card
  let raw = RawInput::from_mouse(@math.Vec2::new(20.0, 35.0), true)
  ctx.begin_frame(raw)

  let mut action_triggered = false
  ctx.menu_bar(fn(bar) {
    bar.menu("文件", fn(menu) {
      if menu.menu_item("新建", shortcut="⌘N").clicked {
        action_triggered = true
      }
    })
  })

  let _ = ctx.end_frame()
  // The clicked response must be true
  assert_true(action_triggered)
  // The menu must automatically dismiss itself upon click!
  assert_eq(ctx.open_menu_id(), Id::zero())
}

///|
test "menu_bar: clicking outside dismisses open menu" {
  let ctx = UIContext::new()
  let file_id = ctx.id_stack.derive_id("menu::文件")
  ctx.set_open_menu_id(file_id)

  // Click far outside (e.g. x=500, y=400)
  let raw = RawInput::from_mouse(@math.Vec2::new(500.0, 400.0), true)
  ctx.begin_frame(raw)

  ctx.menu_bar(fn(bar) {
    bar.menu("文件", fn(menu) { let _ = menu.menu_item("新建") })
  })

  let _ = ctx.end_frame()
  // Menu should now be dismissed
  assert_eq(ctx.open_menu_id(), Id::zero())
}
