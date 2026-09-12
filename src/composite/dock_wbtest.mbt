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
test "dock: tree data structures and search" {
  let tab1 = DockTab::new("editor", "Code Editor", closable=true)
  let tab2 = DockTab::new("preview", "Live Preview")
  let tab3 = DockTab::new("terminal", "Terminal", closable=true)

  let left_leaf = DockTree::leaf([tab1, tab2])
  let right_leaf = DockTree::leaf([tab3])

  let tree = DockTree::split(
    DockSplitDirection::Horizontal,
    0.6,
    left_leaf,
    right_leaf,
  )

  let found_editor = tree.find_tab("editor")
  assert_true(found_editor is Some(_))
  assert_eq(found_editor.unwrap().0.title, "Code Editor")

  let found_term = tree.find_tab("terminal")
  assert_true(found_term is Some(_))
  assert_eq(found_term.unwrap().0.title, "Terminal")

  let not_found = tree.find_tab("non_existent")
  assert_true(not_found is None)
}

///|
test "dock: tab activation and tab closing" {
  let tab1 = DockTab::new("t1", "Tab 1", closable=true)
  let tab2 = DockTab::new("t2", "Tab 2", closable=true)
  let tree = DockTree::leaf([tab1, tab2])

  // Initial active tab index is 0
  let res1 = tree.find_tab("t1")
  assert_eq(res1.unwrap().1, 0)

  // Activate Tab 2
  let switched = tree.set_active_tab("t2")
  assert_true(switched)
  let res2 = tree.find_tab("t2")
  assert_eq(res2.unwrap().1, 1)

  // Close Tab 1
  let closed = tree.close_tab("t1")
  assert_true(closed)
  assert_true(tree.find_tab("t1") is None)
  assert_true(tree.find_tab("t2") is Some(_))

  // Close Tab 2 -> tree becomes Empty
  let closed2 = tree.close_tab("t2")
  assert_true(closed2)
  assert_true(tree.root is Empty)
}

///|
test "dock: split node collapse when branch becomes empty" {
  let tab_left = DockTab::new("left", "Left")
  let tab_right = DockTab::new("right", "Right", closable=true)

  let tree = DockTree::split(
    DockSplitDirection::Horizontal,
    0.5,
    DockTree::leaf([tab_left]),
    DockTree::leaf([tab_right]),
  )

  // Close right tab -> right branch becomes empty, split collapses into leaf left
  let closed = tree.close_tab("right")
  assert_true(closed)
  match tree.root {
    Leaf(tabs, _) => {
      assert_eq(tabs.length(), 1)
      assert_eq(tabs[0].id, "left")
    }
    _ => abort("Expected collapsed Leaf node")
  }
}

///|
test "dock: frame rendering with UIContext::dock_area and scoped clipping" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::new())

  let tab_main = DockTab::new("canvas", "Viewport")
  let tab_prop = DockTab::new("props", "Inspector")
  let tree = DockTree::split(
    DockSplitDirection::Horizontal,
    0.7,
    DockTree::leaf([tab_main]),
    DockTree::leaf([tab_prop]),
  )

  let mut rendered_main = false
  let mut rendered_props = false
  let mut main_w = 0.0
  let mut props_w = 0.0

  let d_resp = dock_area(
    ctx,
    "main_dock",
    @math.Vec2::new(800.0, 500.0),
    tree,
    fn(_ui, tab_id, rect) {
      if tab_id == "canvas" {
        rendered_main = true
        main_w = rect.w
      }
      if tab_id == "props" {
        rendered_props = true
        props_w = rect.w
      }
    },
  )

  assert_true(rendered_main)
  assert_true(rendered_props)
  assert_true(main_w > 40.0)
  assert_true(props_w > 40.0)
  assert_eq(d_resp.resp.rect.w, 800.0)
  assert_eq(d_resp.resp.rect.h, 500.0)

  let dl = ctx.end_frame()
  assert_true(dl.len() > 0)
}

///|
test "dock: fluent DockArea widget and ui.add dispatch" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::new())

  let tab_console = DockTab::new("console", "Output Console")
  let tree = DockTree::leaf([tab_console])

  let dock_widget = DockArea::new(
    "console_dock",
    @math.Vec2::new(400.0, 200.0),
    tree,
    fn(ui, tab_id, _rect) { let _ = ui.label("Tab rendered: " + tab_id) },
  )

  let resp = ctx.add(dock_widget)
  assert_eq(resp.rect.w, 400.0)
  assert_eq(resp.rect.h, 200.0)

  let dl = ctx.end_frame()
  assert_true(dl.len() > 0)
}

///|
test "dock: tabs and splitter handles advertise their cursor" {
  let ctx = @core.UIContext::new()
  let tab = DockTab::new("t1", "Tab 1")
  let tree = DockTree::leaf([tab])

  // Tab strip: the first tab starts at x + 4 and the bar is 28 tall, so the
  // point (12, 12) sits inside the tab.
  ctx.begin_frame(
    @core.RawInput::from_mouse(@math.Vec2::new(12.0, 12.0), false),
  )
  let _ = dock_area(ctx, "cursor_dock", @math.Vec2::new(800.0, 500.0), tree, fn(
    _ui,
    _id,
    _rect,
  ) {

  })
  assert_eq(ctx.cursor_icon(), "pointer")
  let _ = ctx.end_frame()
}
