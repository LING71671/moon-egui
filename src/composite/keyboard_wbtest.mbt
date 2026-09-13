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

///|
test "context_menu: arrows and Enter drive the open menu" {
  let ctx = @core.UIContext::new()
  let menu = [
    ContextMenuItem::new("edit", "Edit"),
    ContextMenuItem::submenu("export", "Export", [
      ContextMenuItem::new("export_png", "Export as PNG"),
    ]),
  ]

  // Frame 1: open the menu with the pointer away
  ctx.begin_frame(
    @core.RawInput::from_mouse(@math.Vec2::new(-50.0, -50.0), false),
  )
  let r1 = context_menu_items(
    ctx,
    "kb_menu",
    true,
    @math.Vec2::new(100.0, 100.0),
    menu,
  )
  let _ = ctx.end_frame()
  assert_eq(r1.open, true)

  // Frame 2: ArrowDown highlights the next actionable row ("Export")
  ctx.begin_frame(kb_key_input(@core.Key::ArrowDown))
  let r2 = context_menu_items(
    ctx,
    "kb_menu",
    true,
    @math.Vec2::new(100.0, 100.0),
    menu,
  )
  let _ = ctx.end_frame()
  assert_eq(r2.open, true)

  // Frame 3: Enter opens the highlighted submenu
  ctx.begin_frame(kb_key_input(@core.Key::Enter))
  let r3 = context_menu_items(
    ctx,
    "kb_menu",
    true,
    @math.Vec2::new(100.0, 100.0),
    menu,
  )
  let _ = ctx.end_frame()
  assert_eq(r3.open, true)
  assert_eq(ctx.active_submenu_id(), "export")
}

///|
test "dock: keyboard switches tabs inside a pane" {
  let ctx = @core.UIContext::new()
  let tree = DockTree::leaf([
    DockTab::new("t1", "Tab 1"),
    DockTab::new("t2", "Tab 2"),
  ])

  // Frame 1: Tab focuses the first tab (the current one; Enter is a no-op)
  ctx.begin_frame(kb_key_input(@core.Key::Tab))
  let r1 = dock_area(ctx, "kb_dock", @math.Vec2::new(800.0, 500.0), tree, fn(
    _ui,
    _id,
    _rect,
  ) {

  })
  let _ = ctx.end_frame()
  assert_eq(r1.active_tab_changed, None)

  // Frame 2: Tab reaches the second tab
  ctx.begin_frame(kb_key_input(@core.Key::Tab))
  let r2 = dock_area(ctx, "kb_dock", @math.Vec2::new(800.0, 500.0), tree, fn(
    _ui,
    _id,
    _rect,
  ) {

  })
  let _ = ctx.end_frame()
  assert_eq(r2.active_tab_changed, None)

  // Frame 3: Enter switches to it
  ctx.begin_frame(kb_key_input(@core.Key::Enter))
  let r3 = dock_area(ctx, "kb_dock", @math.Vec2::new(800.0, 500.0), tree, fn(
    _ui,
    _id,
    _rect,
  ) {

  })
  let _ = ctx.end_frame()
  assert_eq(r3.active_tab_changed, Some(("t1", "t2")))
}

///|
test "dock: keyboard resizes the focused divider" {
  let ctx = @core.UIContext::new()
  let tree = DockTree::split(
    DockSplitDirection::Horizontal,
    0.5,
    DockTree::leaf([DockTab::new("t1", "Tab 1")]),
    DockTree::leaf([DockTab::new("t2", "Tab 2")]),
  )

  // Frames 1-4: the handle registers before the child tabs, so Tab cycles
  // divider -> t1 -> t2 -> back to the divider
  ctx.begin_frame(kb_key_input(@core.Key::Tab))
  let _ = dock_area(ctx, "kb_dock_split", @math.Vec2::new(800.0, 500.0), tree, fn(
    _ui,
    _id,
    _rect,
  ) {

  })
  let _ = ctx.end_frame()

  ctx.begin_frame(kb_key_input(@core.Key::Tab))
  let _ = dock_area(ctx, "kb_dock_split", @math.Vec2::new(800.0, 500.0), tree, fn(
    _ui,
    _id,
    _rect,
  ) {

  })
  let _ = ctx.end_frame()

  ctx.begin_frame(kb_key_input(@core.Key::Tab))
  let _ = dock_area(ctx, "kb_dock_split", @math.Vec2::new(800.0, 500.0), tree, fn(
    _ui,
    _id,
    _rect,
  ) {

  })
  let _ = ctx.end_frame()

  ctx.begin_frame(kb_key_input(@core.Key::Tab))
  let _ = dock_area(ctx, "kb_dock_split", @math.Vec2::new(800.0, 500.0), tree, fn(
    _ui,
    _id,
    _rect,
  ) {

  })
  let _ = ctx.end_frame()

  // Frame 5: ArrowRight nudges the divider ratio
  ctx.begin_frame(kb_key_input(@core.Key::ArrowRight))
  let r4 = dock_area(
    ctx,
    "kb_dock_split",
    @math.Vec2::new(800.0, 500.0),
    tree,
    fn(_ui, _id, _rect) {  },
  )
  let _ = ctx.end_frame()
  assert_true(r4.ratio_changed)
}

///|
test "context_menu: keyboard skips disabled rows and wraps" {
  let ctx = @core.UIContext::new()
  let menu = [
    ContextMenuItem::new("cut", "Cut"),
    ContextMenuItem::new("paste_special", "Paste Special", disabled=true),
    ContextMenuItem::new("delete", "Delete"),
  ]

  ctx.begin_frame(
    @core.RawInput::from_mouse(@math.Vec2::new(-50.0, -50.0), false),
  )
  let _ = context_menu_items(
    ctx,
    "kb_skip",
    true,
    @math.Vec2::new(100.0, 100.0),
    menu,
  )
  let _ = ctx.end_frame()

  // ArrowDown walks past the disabled row onto "Delete"
  ctx.begin_frame(kb_key_input(@core.Key::ArrowDown))
  let _ = context_menu_items(
    ctx,
    "kb_skip",
    true,
    @math.Vec2::new(100.0, 100.0),
    menu,
  )
  let _ = ctx.end_frame()

  // Enter activates it
  ctx.begin_frame(kb_key_input(@core.Key::Enter))
  let r3 = context_menu_items(
    ctx,
    "kb_skip",
    true,
    @math.Vec2::new(100.0, 100.0),
    menu,
  )
  let _ = ctx.end_frame()
  assert_eq(r3.selected_id, Some("delete"))

  // Re-opening resets to the first actionable row; Enter picks "Cut"
  ctx.begin_frame(
    @core.RawInput::from_mouse(@math.Vec2::new(-50.0, -50.0), false),
  )
  let _ = context_menu_items(
    ctx,
    "kb_fresh",
    true,
    @math.Vec2::new(100.0, 100.0),
    menu,
  )
  let _ = ctx.end_frame()
  ctx.begin_frame(kb_key_input(@core.Key::Enter))
  let r5 = context_menu_items(
    ctx,
    "kb_fresh",
    true,
    @math.Vec2::new(100.0, 100.0),
    menu,
  )
  let _ = ctx.end_frame()
  assert_eq(r5.selected_id, Some("cut"))
}

///|
test "context_menu: disabled-only menu is keyboard inert" {
  let ctx = @core.UIContext::new()
  let menu = [
    ContextMenuItem::new("x", "Locked", disabled=true),
    ContextMenuItem::new("y", "Also locked", disabled=true),
  ]

  ctx.begin_frame(
    @core.RawInput::from_mouse(@math.Vec2::new(-50.0, -50.0), false),
  )
  let _ = context_menu_items(
    ctx,
    "kb_inert",
    true,
    @math.Vec2::new(100.0, 100.0),
    menu,
  )
  let _ = ctx.end_frame()

  ctx.begin_frame(kb_key_input(@core.Key::ArrowDown))
  ctx.begin_frame(kb_key_input(@core.Key::Enter))
  let r = context_menu_items(
    ctx,
    "kb_inert",
    true,
    @math.Vec2::new(100.0, 100.0),
    menu,
  )
  let _ = ctx.end_frame()
  assert_eq(r.open, true)
  assert_eq(r.selected_id, None)
}

///|
test "context_menu: submenu flips left near the right viewport edge" {
  let ctx = @core.UIContext::new()
  let menu = [
    ContextMenuItem::submenu("export", "Export", [
      ContextMenuItem::new("png", "PNG"),
    ]),
  ]

  // Anchor hard against the right edge of a 500px viewport: neither the main
  // menu nor the submenu may spill past it.
  ctx.begin_frame(
    @core.RawInput::from_mouse(@math.Vec2::new(-50.0, -50.0), false),
  )
  let r1 = context_menu_items(
    ctx,
    "kb_flip",
    true,
    @math.Vec2::new(420.0, 100.0),
    menu,
    viewport_size=@math.Vec2::new(500.0, 600.0),
  )
  let _ = ctx.end_frame()
  assert_eq(r1.open, true)

  ctx.begin_frame(kb_key_input(@core.Key::Enter))
  let r2 = context_menu_items(
    ctx,
    "kb_flip",
    true,
    @math.Vec2::new(420.0, 100.0),
    menu,
    viewport_size=@math.Vec2::new(500.0, 600.0),
  )
  let _ = ctx.end_frame()
  assert_eq(ctx.active_submenu_id(), "export")
  assert_eq(r2.open, true)
}

///|
test "context_menu: separators render inside submenus" {
  let ctx = @core.UIContext::new()
  let menu = [
    ContextMenuItem::submenu("export", "Export", [
      ContextMenuItem::separator(),
      ContextMenuItem::new("png", "PNG"),
    ]),
  ]

  ctx.begin_frame(
    @core.RawInput::from_mouse(@math.Vec2::new(-50.0, -50.0), false),
  )
  let r = context_menu_items(
    ctx,
    "kb_sep",
    true,
    @math.Vec2::new(100.0, 100.0),
    menu,
  )
  let _ = ctx.end_frame()
  assert_eq(r.open, true)
}
