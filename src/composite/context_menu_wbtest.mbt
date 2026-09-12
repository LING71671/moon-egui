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
fn sample_context_items() -> Array[ContextMenuItem] {
  [
    ContextMenuItem::new("copy", "复制节点", shortcut="⌘C"),
    ContextMenuItem::new("paste", "粘贴至此", shortcut="⌘V"),
    ContextMenuItem::separator(),
    ContextMenuItem::new(
      "delete",
      "删除元素",
      shortcut="⌫",
      disabled=false,
    ),
  ]
}

///|
test "context_menu: closed idle state renders nothing" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::new())

  let res = context_menu_items(
    ctx,
    "node_ctx",
    false,
    @math.Vec2::new(100.0, 100.0),
    sample_context_items(),
  )
  assert_eq(res.open, false)
  assert_eq(res.selected_id, None)

  let dl = ctx.end_frame()
  assert_eq(dl.len(), 0)
}

///|
test "context_menu: open renders surface, border, and items into foreground" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::new())

  let res = context_menu_items(
    ctx,
    "node_ctx",
    true,
    @math.Vec2::new(100.0, 100.0),
    sample_context_items(),
  )
  assert_eq(res.open, true)
  assert_eq(res.selected_id, None)
  assert_true(res.size.x >= 180.0)
  assert_true(res.size.y > 50.0)

  let dl = ctx.end_frame()
  // Must contain shadows, background rect, border stroke, line separator, and text items
  assert_true(dl.len() >= 6)
}

///|
test "context_menu: horizontal collision auto flips to left" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::new())

  // Viewport width default is 800. If we anchor at 750, menu (width 180) would spill to 930
  let res = context_menu_items(
    ctx,
    "node_ctx",
    true,
    @math.Vec2::new(750.0, 100.0),
    sample_context_items(),
  )
  assert_eq(res.open, true)
  // Must flip to left of 750.0
  assert_true(res.pos.x < 750.0)
  // Must not exceed viewport right edge 800.0
  assert_true(res.pos.x + res.size.x <= 800.0)
  let _ = ctx.end_frame()
}

///|
test "context_menu: vertical collision auto flips upwards" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::new())

  // Viewport height default is 600. If we anchor at 570, menu (height ~80) would spill to 650
  let res = context_menu_items(
    ctx,
    "node_ctx",
    true,
    @math.Vec2::new(100.0, 570.0),
    sample_context_items(),
  )
  assert_eq(res.open, true)
  // Must flip upwards
  assert_true(res.pos.y < 570.0)
  assert_true(res.pos.y + res.size.y <= 600.0)
  let _ = ctx.end_frame()
}

///|
test "context_menu: item click executes and closes" {
  let ctx = UIContext::new()

  // Click at (110, 110), inside the first item ("copy") anchored at (100, 100)
  let raw = RawInput::from_mouse(@math.Vec2::new(110.0, 110.0), true)
  ctx.begin_frame(raw)

  let res = context_menu_items(
    ctx,
    "node_ctx",
    true,
    @math.Vec2::new(100.0, 100.0),
    sample_context_items(),
  )
  assert_eq(res.open, false)
  assert_eq(res.selected_id, Some("copy"))
  let _ = ctx.end_frame()
}

///|
test "context_menu: escape key cancels and dismisses" {
  let ctx = UIContext::new()

  let raw_esc = RawInput::with_events(
    @math.Vec2::zero(),
    false,
    @math.Vec2::zero(),
    [Event::Key(Key::Escape, true, Modifiers::none())],
    "",
    Modifiers::none(),
  )
  ctx.begin_frame(raw_esc)

  let res = context_menu_items(
    ctx,
    "node_ctx",
    true,
    @math.Vec2::new(100.0, 100.0),
    sample_context_items(),
  )
  assert_eq(res.open, false)
  assert_eq(res.selected_id, None)
  let _ = ctx.end_frame()
}

///|
test "context_menu: outside click cancels and dismisses" {
  let ctx = UIContext::new()

  // Menu anchored at (300, 300). Click happens at (50, 50) far outside
  let raw_click = RawInput::from_mouse(@math.Vec2::new(50.0, 50.0), true)
  ctx.begin_frame(raw_click)

  let res = context_menu_items(
    ctx,
    "node_ctx",
    true,
    @math.Vec2::new(300.0, 300.0),
    sample_context_items(),
  )
  assert_eq(res.open, false)
  assert_eq(res.selected_id, None)
  let _ = ctx.end_frame()
}

///|
test "context_menu: cascading submenu hover and child item selection" {
  let ctx = UIContext::new()
  let menu = [
    ContextMenuItem::new("edit", "Edit"),
    ContextMenuItem::submenu("export", "Export", [
      ContextMenuItem::new("export_png", "Export as PNG"),
      ContextMenuItem::new("export_svg", "Export as SVG"),
    ]),
  ]

  // Frame 1: Hover over "Export" item to open submenu
  let raw1 = RawInput::from_mouse(@math.Vec2::new(120.0, 134.0), false)
  ctx.begin_frame(raw1)
  let res1 = context_menu_items(
    ctx,
    "node_ctx",
    true,
    @math.Vec2::new(100.0, 100.0),
    menu,
  )
  assert_eq(res1.open, true)
  assert_eq(ctx.active_submenu_id(), "export")
  let dl1 = ctx.end_frame()
  assert_true(dl1.len() > 10)

  // Frame 2: Click on "Export as PNG" inside the submenu
  let raw2 = RawInput::from_mouse(@math.Vec2::new(300.0, 134.0), true)
  ctx.begin_frame(raw2)
  let res2 = context_menu_items(
    ctx,
    "node_ctx",
    true,
    @math.Vec2::new(100.0, 100.0),
    menu,
  )
  assert_eq(res2.open, false)
  assert_eq(res2.selected_id, Some("export_png"))
  let _ = ctx.end_frame()
}
