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
fn sample_tree() -> Array[TreeNode] {
  [
    TreeNode::new(
      "root_scene",
      "场景根节点 (Scene)",
      children=[
        TreeNode::new(
          "camera_group",
          "摄影机组 (Cameras)",
          children=[
            TreeNode::leaf("main_cam", "透视主摄影机", icon="[C]"),
            TreeNode::leaf("top_cam", "正交顶视图", icon="[C]"),
          ],
          icon="[G]",
        ),
        TreeNode::new(
          "mesh_group",
          "几何体模型 (Meshes)",
          children=[
            TreeNode::leaf("mesh_cube", "立方体网格", icon="[M]"),
            TreeNode::leaf("mesh_torus", "圆环面拓扑", icon="[M]"),
          ],
          icon="[G]",
        ),
        TreeNode::leaf("env_light", "环境天光 (Light)", icon="[L]"),
      ],
      icon="[S]",
    ),
  ]
}

///|
test "tree_view: empty nodes renders minimal container" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::new())

  let res = ctx.tree_view("empty_tree", [])
  assert_eq(res.selected_id, None)
  assert_eq(res.expanded_ids.length(), 0)

  let dl = ctx.end_frame()
  // Container surface + stroke = 2 primitives
  assert_eq(dl.len(), 2)
}

///|
test "tree_view: collapsed root renders only root level, children hidden" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::new())

  // Default: expanded_ids is empty, root_scene is collapsed
  let res = ctx.tree_view("tree_collapsed", sample_tree())
  assert_eq(res.selected_id, None)
  assert_eq(res.expanded_ids.length(), 0)

  let dl = ctx.end_frame()
  // Container + stroke + root row (chevron + icon + text) = 5 primitives
  assert_true(dl.len() >= 4)
  assert_true(dl.len() < 10)
}

///|
test "tree_view: expanded root exposes child nodes in visual list" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::new())

  // Expand "root_scene"
  let res = ctx.tree_view("tree_expanded", sample_tree(), expanded_ids=[
    "root_scene",
  ])
  assert_eq(res.expanded_ids.length(), 1)
  assert_eq(res.expanded_ids[0], "root_scene")

  let dl = ctx.end_frame()
  // Root + 3 children (camera_group, mesh_group, env_light) are now visible -> much more primitives
  assert_true(dl.len() > 12)
}

///|
test "tree_view: clicking chevron toggles expansion on" {
  let ctx = UIContext::new()
  // Root node is at (rect.x, rect.y). Chevron is at x + 4 + 0*16 = 4.0, y + 2.0 = 2.0
  // With default origin (0, 0), click at (8.0, 10.0) lands inside the root chevron
  let raw = RawInput::from_mouse(@math.Vec2::new(8.0, 10.0), true)
  ctx.begin_frame(raw)

  let res = ctx.tree_view("tree_chevron", sample_tree())
  assert_eq(res.toggled_id, Some("root_scene"))
  assert_eq(res.expanded_ids.contains("root_scene"), true)

  let _ = ctx.end_frame()
}

///|
test "tree_view: clicking chevron toggles expansion off" {
  let ctx = UIContext::new()
  let raw = RawInput::from_mouse(@math.Vec2::new(8.0, 10.0), true)
  ctx.begin_frame(raw)

  // Start with root_scene expanded, clicking chevron should remove it
  let res = ctx.tree_view("tree_chevron_off", sample_tree(), expanded_ids=[
    "root_scene",
  ])
  assert_eq(res.toggled_id, Some("root_scene"))
  assert_eq(res.expanded_ids.contains("root_scene"), false)

  let _ = ctx.end_frame()
}

///|
test "tree_view: clicking node row selects it and sets selected_id" {
  let ctx = UIContext::new()
  // Click at (100.0, 10.0) -> inside the root row label area, outside the 16px chevron
  let raw = RawInput::from_mouse(@math.Vec2::new(100.0, 10.0), true)
  ctx.begin_frame(raw)

  let res = ctx.tree_view("tree_click_row", sample_tree())
  assert_eq(res.clicked_id, Some("root_scene"))
  assert_eq(res.selected_id, Some("root_scene"))

  let _ = ctx.end_frame()
}

///|
test "tree_view: keyboard ArrowDown and ArrowUp navigate visible items" {
  let ctx = UIContext::new()

  // First frame: focus the tree by clicking it
  let raw1 = RawInput::from_mouse(@math.Vec2::new(100.0, 10.0), true)
  ctx.begin_frame(raw1)
  let res1 = ctx.tree_view("tree_nav", sample_tree(), expanded_ids=[
    "root_scene",
  ])
  assert_eq(res1.selected_id, Some("root_scene"))
  let _ = ctx.end_frame()

  // Next frame: press ArrowDown -> should move selection to first child "camera_group"
  let raw2 = {
    mouse_pos: @math.Vec2::new(0.0, 0.0),
    mouse_down: false,
    mouse_secondary_down: false,
    scroll_delta: @math.Vec2::zero(),
    dt: 0.0166,
    events: [Event::Key(Key::ArrowDown, true, Modifiers::none())],
    text_input: "",
    modifiers: Modifiers::none(),
  }
  ctx.begin_frame(raw2)
  let res2 = ctx.tree_view(
    "tree_nav",
    sample_tree(),
    selected_id=res1.selected_id,
    expanded_ids=res1.expanded_ids,
  )
  assert_eq(res2.selected_id, Some("camera_group"))
  let _ = ctx.end_frame()

  // Next frame: press ArrowUp -> should move selection back to "root_scene"
  let raw3 = {
    mouse_pos: @math.Vec2::new(0.0, 0.0),
    mouse_down: false,
    mouse_secondary_down: false,
    scroll_delta: @math.Vec2::zero(),
    dt: 0.0166,
    events: [Event::Key(Key::ArrowUp, true, Modifiers::none())],
    text_input: "",
    modifiers: Modifiers::none(),
  }
  ctx.begin_frame(raw3)
  let res3 = ctx.tree_view(
    "tree_nav",
    sample_tree(),
    selected_id=res2.selected_id,
    expanded_ids=res2.expanded_ids,
  )
  assert_eq(res3.selected_id, Some("root_scene"))
  let _ = ctx.end_frame()
}

///|
test "tree_view: keyboard ArrowRight expands and ArrowLeft collapses node" {
  let ctx = UIContext::new()

  // Frame 1: click to focus on camera_group
  let raw1 = RawInput::from_mouse(@math.Vec2::new(100.0, 10.0), true)
  ctx.begin_frame(raw1)
  let _ = ctx.tree_view(
    "tree_expand_key",
    sample_tree(),
    selected_id=Some("camera_group"),
    expanded_ids=["root_scene"],
  )
  let _ = ctx.end_frame()

  // Frame 2: press ArrowRight -> should expand camera_group
  let raw2 = {
    mouse_pos: @math.Vec2::new(0.0, 0.0),
    mouse_down: false,
    mouse_secondary_down: false,
    scroll_delta: @math.Vec2::zero(),
    dt: 0.0166,
    events: [Event::Key(Key::ArrowRight, true, Modifiers::none())],
    text_input: "",
    modifiers: Modifiers::none(),
  }
  ctx.begin_frame(raw2)
  let res2 = ctx.tree_view(
    "tree_expand_key",
    sample_tree(),
    selected_id=Some("camera_group"),
    expanded_ids=["root_scene"],
  )
  assert_eq(res2.expanded_ids.contains("camera_group"), true)
  assert_eq(res2.toggled_id, Some("camera_group"))
  let _ = ctx.end_frame()

  // Frame 3: press ArrowLeft -> should collapse camera_group
  let raw3 = {
    mouse_pos: @math.Vec2::new(0.0, 0.0),
    mouse_down: false,
    mouse_secondary_down: false,
    scroll_delta: @math.Vec2::zero(),
    dt: 0.0166,
    events: [Event::Key(Key::ArrowLeft, true, Modifiers::none())],
    text_input: "",
    modifiers: Modifiers::none(),
  }
  ctx.begin_frame(raw3)
  let res3 = ctx.tree_view(
    "tree_expand_key",
    sample_tree(),
    selected_id=Some("camera_group"),
    expanded_ids=res2.expanded_ids,
  )
  assert_eq(res3.expanded_ids.contains("camera_group"), false)
  assert_eq(res3.toggled_id, Some("camera_group"))
  let _ = ctx.end_frame()
}
