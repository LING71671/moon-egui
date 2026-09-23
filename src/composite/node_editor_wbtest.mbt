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
test "composite: node_editor builder and basic rendering" {
  let ctx = UIContext::new()
  ctx.begin_frame(@core.RawInput::new())

  let nodes = [
    NodeItem::new("node_src", "Data Source", @math.Vec2::new(30.0, 30.0), outputs=[
      NodePort::output("out_val", "Value"),
    ]),
    NodeItem::new(
      "node_filter",
      "Threshold Filter",
      @math.Vec2::new(260.0, 30.0),
      inputs=[NodePort::input("in_val", "Input")],
      outputs=[NodePort::output("out_filtered", "Result")],
    ),
  ]
  let conns = [
    NodeConnection::new("node_src", "out_val", "node_filter", "in_val"),
  ]

  let resp = NodeEditor::new(
    "test_editor",
    @math.Vec2::new(600.0, 400.0),
    nodes,
    conns,
  ).show(ctx)

  assert_eq(resp.rect.w, 600.0)
  assert_eq(resp.rect.h, 400.0)
  assert_eq(resp.connections.length(), 1)
  assert_eq(resp.nodes.length(), 2)

  let dl = ctx.end_frame()
  assert_true(dl.len() > 10)
}

///|
test "composite: node_editor click header to select node" {
  let ctx = UIContext::new()

  let nodes = [
    NodeItem::new("node_a", "Generator", @math.Vec2::new(40.0, 40.0), outputs=[
      NodePort::output("out", "Signal"),
    ]),
  ]

  // Header of node_a is at canvas_rect.min + pos = (0+40, 0+40) = (40, 40)
  // Header height is 28.0, width is >= 160.0. Point (60.0, 50.0) is inside header!
  let raw1 = @core.RawInput::from_mouse(@math.Vec2::new(60.0, 50.0), true)
  ctx.begin_frame(raw1)
  let resp1 = node_editor(ctx, "ne_sel", @math.Vec2::new(500.0, 300.0), nodes, [])
  assert_eq(resp1.selected_node, Some("node_a"))
  let _ = ctx.end_frame()
}

///|
test "composite: node_editor drag node position" {
  let ctx = UIContext::new()

  let nodes = [
    NodeItem::new("node_move", "Movable Block", @math.Vec2::new(50.0, 50.0), outputs=[
      NodePort::output("out", "Out"),
    ]),
  ]

  // Frame 1: Mouse down on header at (70.0, 60.0). Anchor is (70 - 50 = 20, 60 - 50 = 10)
  let raw1 = @core.RawInput::from_mouse(@math.Vec2::new(70.0, 60.0), true)
  ctx.begin_frame(raw1)
  let resp1 = node_editor(
    ctx,
    "ne_drag",
    @math.Vec2::new(500.0, 300.0),
    nodes,
    [],
  )
  assert_eq(resp1.dragged_node, Some("node_move"))
  let _ = ctx.end_frame()

  // Frame 2: Mouse dragged to (120.0, 90.0). New pos should be (120 - 20 = 100, 90 - 10 = 80)
  let raw2 = @core.RawInput::from_mouse(@math.Vec2::new(120.0, 90.0), true)
  ctx.begin_frame(raw2)
  let resp2 = node_editor(
    ctx,
    "ne_drag",
    @math.Vec2::new(500.0, 300.0),
    nodes,
    [],
  )
  assert_eq(resp2.dragged_node, Some("node_move"))
  assert_eq(nodes[0].pos.x, 100.0)
  assert_eq(nodes[0].pos.y, 80.0)
  assert_true(resp2.changed)
  let _ = ctx.end_frame()

  // Frame 3: Mouse release
  let raw3 = @core.RawInput::from_mouse(@math.Vec2::new(120.0, 90.0), false)
  ctx.begin_frame(raw3)
  let resp3 = node_editor(
    ctx,
    "ne_drag",
    @math.Vec2::new(500.0, 300.0),
    nodes,
    [],
  )
  assert_eq(resp3.dragged_node, None)
  assert_eq(nodes[0].pos.x, 100.0)
  assert_eq(nodes[0].pos.y, 80.0)
  let _ = ctx.end_frame()
}

///|
test "composite: node_editor connect ports interactively" {
  let ctx = UIContext::new()
  let style = NodeEditorStyle::default()
  // node_min_w = 160.0, node_header_h = 28.0, port_spacing = 22.0
  // Node 1: pos = (50.0, 50.0), width = 160.0
  // Output port 0 center: x = 50.0 + 160.0 = 210.0, y = 50.0 + 28.0 + 14.0 = 92.0
  // Node 2: pos = (300.0, 50.0), width = 160.0
  // Input port 0 center: x = 300.0, y = 50.0 + 28.0 + 14.0 = 92.0

  let nodes = [
    NodeItem::new("src", "Source", @math.Vec2::new(50.0, 50.0), outputs=[
      NodePort::output("out1", "Out"),
    ]),
    NodeItem::new("dst", "Destination", @math.Vec2::new(300.0, 50.0), inputs=[
      NodePort::input("in1", "In"),
    ]),
  ]

  // Frame 1: Mouse down exactly on output port (210.0, 92.0)
  let raw1 = @core.RawInput::from_mouse(@math.Vec2::new(210.0, 92.0), true)
  ctx.begin_frame(raw1)
  let _ = node_editor(
    ctx,
    "ne_wire",
    @math.Vec2::new(600.0, 400.0),
    nodes,
    [],
    custom_style=Some(style),
  )
  let _ = ctx.end_frame()

  // Frame 2: Mouse dragged toward input port at (250.0, 92.0)
  let raw2 = @core.RawInput::from_mouse(@math.Vec2::new(250.0, 92.0), true)
  ctx.begin_frame(raw2)
  let _ = node_editor(
    ctx,
    "ne_wire",
    @math.Vec2::new(600.0, 400.0),
    nodes,
    [],
    custom_style=Some(style),
  )
  // Crosshair cursor active during wire dragging
  assert_eq(ctx.cursor_icon(), "crosshair")
  let _ = ctx.end_frame()

  // Frame 3: Mouse released over destination input port (300.0, 92.0)
  let raw3 = @core.RawInput::from_mouse(@math.Vec2::new(300.0, 92.0), false)
  ctx.begin_frame(raw3)
  let resp3 = node_editor(
    ctx,
    "ne_wire",
    @math.Vec2::new(600.0, 400.0),
    nodes,
    [],
    custom_style=Some(style),
  )
  assert_true(resp3.new_connection is Some(_))
  let new_c = resp3.new_connection.unwrap()
  assert_eq(new_c.from_node, "src")
  assert_eq(new_c.from_port, "out1")
  assert_eq(new_c.to_node, "dst")
  assert_eq(new_c.to_port, "in1")
  assert_eq(resp3.connections.length(), 1)
  let _ = ctx.end_frame()
}

///|
test "composite: node_editor cursor semantics" {
  let ctx = UIContext::new()
  let nodes = [
    NodeItem::new("n1", "Header Node", @math.Vec2::new(20.0, 20.0), outputs=[
      NodePort::output("o1", "Out"),
    ]),
  ]

  // Hover over header (x=50.0, y=30.0) -> cursor should be "move"
  let raw_header = @core.RawInput::from_mouse(
    @math.Vec2::new(50.0, 30.0),
    false,
  )
  ctx.begin_frame(raw_header)
  let _ = node_editor(ctx, "ne_cur", @math.Vec2::new(400.0, 300.0), nodes, [])
  assert_eq(ctx.cursor_icon(), "move")
  let _ = ctx.end_frame()

  // Hover over output port (x=180.0, y=62.0) -> cursor should be "crosshair"
  let raw_port = @core.RawInput::from_mouse(@math.Vec2::new(180.0, 62.0), false)
  ctx.begin_frame(raw_port)
  let _ = node_editor(ctx, "ne_cur", @math.Vec2::new(400.0, 300.0), nodes, [])
  assert_eq(ctx.cursor_icon(), "crosshair")
  let _ = ctx.end_frame()
}

///|
test "composite: node_editor adaptive wire LOD steps and is_hovered hit testing" {
  let ctx = UIContext::new()

  // Short distance wire: Node 1 at (20, 20), Node 2 at (100, 20) -> dist ~80px, should use 8 steps
  let nodes_short = [
    NodeItem::new("s1", "A", @math.Vec2::new(20.0, 20.0), outputs=[
      NodePort::output("o", "O"),
    ]),
    NodeItem::new("s2", "B", @math.Vec2::new(100.0, 20.0), inputs=[
      NodePort::input("i", "I"),
    ]),
  ]
  let conns_short = [NodeConnection::new("s1", "o", "s2", "i")]

  ctx.begin_frame(@core.RawInput::new())
  let resp = node_editor(
    ctx,
    "ne_lod",
    @math.Vec2::new(400.0, 300.0),
    nodes_short,
    conns_short,
  )
  let dl = ctx.end_frame()
  assert_eq(resp.connections.length(), 1)
  assert_true(dl.len() > 0)

  let mut bezier_count = 0
  for i = 0; i < dl.len(); i = i + 1 {
    if dl.get_command(i) is Some(@draw.DrawCmd::BezierCurve(_)) {
      bezier_count = bezier_count + 1
    }
  }
  assert_eq(bezier_count, 1)
}
