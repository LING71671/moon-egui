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
/// Component style metrics descriptor for NodeEditor topology graphs.
pub struct NodeEditorStyle {
  node_min_w : Double
  node_header_h : Double
  port_radius : Double
  port_spacing : Double
  card_radius : Double
  wire_width : Double
  grid_size : Double
} derive(Eq, Debug)

///|
/// Default style configuration adhering to Studio Light design tokens.
pub fn NodeEditorStyle::default() -> NodeEditorStyle {
  {
    node_min_w: 160.0,
    node_header_h: 28.0,
    port_radius: 5.0,
    port_spacing: 22.0,
    card_radius: 6.0,
    wire_width: 2.0,
    grid_size: 24.0,
  }
}

///|
/// Directional polarity of a node connector port.
pub enum NodePortKind {
  Input
  Output
} derive(Eq, Debug)

///|
/// Terminal connection port on a node card.
pub struct NodePort {
  id : String
  name : String
  kind : NodePortKind
  color : @color.Color?
} derive(Eq, Debug)

///|
/// Construct an input port.
pub fn NodePort::input(
  id : String,
  name : String,
  color? : @color.Color,
) -> NodePort {
  { id, name, kind: Input, color, }
}

///|
/// Construct an output port.
pub fn NodePort::output(
  id : String,
  name : String,
  color? : @color.Color,
) -> NodePort {
  { id, name, kind: Output, color, }
}

///|
/// Node card item placed within the infinite or bounded canvas.
pub struct NodeItem {
  id : String
  title : String
  mut pos : @math.Vec2
  size : @math.Vec2?
  inputs : Array[NodePort]
  outputs : Array[NodePort]
  accent_color : @color.Color?
} derive(Eq, Debug)

///|
/// Update position of a node item.
pub fn NodeItem::set_pos(self : NodeItem, pos : @math.Vec2) -> Unit {
  self.pos = pos
}

///|
/// Construct a new node card item.
pub fn NodeItem::new(
  id : String,
  title : String,
  pos : @math.Vec2,
  inputs? : Array[NodePort] = [],
  outputs? : Array[NodePort] = [],
  accent_color? : @color.Color,
  size? : @math.Vec2,
) -> NodeItem {
  { id, title, pos, size, inputs, outputs, accent_color, }
}

///|
/// Directed connection wire between two ports on different nodes.
pub struct NodeConnection {
  from_node : String
  from_port : String
  to_node : String
  to_port : String
} derive(Eq, Debug)

///|
/// Construct a connection descriptor.
pub fn NodeConnection::new(
  from_node : String,
  from_port : String,
  to_node : String,
  to_port : String,
) -> NodeConnection {
  { from_node, from_port, to_node, to_port, }
}

///|
/// Interaction and state feedback from the NodeEditor component.
pub struct NodeEditorResponse {
  rect : @math.Rect
  nodes : Array[NodeItem]
  connections : Array[NodeConnection]
  selected_node : String?
  dragged_node : String?
  new_connection : NodeConnection?
  changed : Bool
} derive(Eq, Debug)

///|
/// Standalone NodeEditor builder supporting fluent configuration.
pub struct NodeEditor {
  id_salt : String
  size : @math.Vec2
  nodes : Array[NodeItem]
  connections : Array[NodeConnection]
  custom_style : NodeEditorStyle?
  selected_node : String?
} derive(Eq, Debug)

///|
/// Create a new NodeEditor builder.
pub fn NodeEditor::new(
  id_salt : String,
  size : @math.Vec2,
  nodes : Array[NodeItem],
  connections : Array[NodeConnection],
) -> NodeEditor {
  {
    id_salt,
    size,
    nodes,
    connections,
    custom_style: None,
    selected_node: None,
  }
}

///|
/// Override styling metrics.
pub fn NodeEditor::style(
  self : NodeEditor,
  style : NodeEditorStyle,
) -> NodeEditor {
  { ..self, custom_style: Some(style), }
}

///|
/// Set currently selected node identifier.
pub fn NodeEditor::selected_node(
  self : NodeEditor,
  selected_node : String?,
) -> NodeEditor {
  { ..self, selected_node, }
}

///|
/// Draws a smooth cubic Bézier curve wire connecting two endpoints.
fn draw_cubic_bezier_wire(
  painter : Painter,
  p0 : @math.Vec2,
  p3 : @math.Vec2,
  color : @color.Color,
  width : Double,
  steps? : Int = 20,
) -> Unit {
  let dx = (p3.x - p0.x).abs() * 0.5
  let curvature = if dx < 40.0 { 40.0 } else { dx }
  let p1 = @math.Vec2::new(p0.x + curvature, p0.y)
  let p2 = @math.Vec2::new(p3.x - curvature, p3.y)

  let mut prev_pt = p0
  let step_count = if steps > 4 { steps } else { 4 }
  for i = 1; i <= step_count; i = i + 1 {
    let t = i.to_double() / step_count.to_double()
    let inv_t = 1.0 - t
    let c0 = inv_t * inv_t * inv_t
    let c1 = 3.0 * inv_t * inv_t * t
    let c2 = 3.0 * inv_t * t * t
    let c3 = t * t * t
    let curr_pt = @math.Vec2::new(
      c0 * p0.x + c1 * p1.x + c2 * p2.x + c3 * p3.x,
      c0 * p0.y + c1 * p1.y + c2 * p2.y + c3 * p3.y,
    )
    painter.add_line(prev_pt, curr_pt, color, width)
    prev_pt = curr_pt
  }
}

///|
/// Resolves screen coordinate for a specific port on a node.
fn find_port_position(
  canvas_min : @math.Vec2,
  nodes : Array[NodeItem],
  node_id : String,
  port_id : String,
  style : NodeEditorStyle,
  scale : Double,
) -> @math.Vec2? {
  for node in nodes {
    if node.id == node_id {
      let screen_x = canvas_min.x + node.pos.x
      let screen_y = canvas_min.y + node.pos.y
      let node_w = match node.size {
        Some(sz) => sz.x * scale
        None => style.node_min_w * scale
      }
      let header_h = style.node_header_h * scale
      let port_spacing = style.port_spacing * scale

      // Check inputs (left edge)
      for i, p in node.inputs {
        if p.id == port_id {
          let py = screen_y +
            header_h +
            14.0 * scale +
            i.to_double() * port_spacing
          return Some(@math.Vec2::new(screen_x, py))
        }
      }
      // Check outputs (right edge)
      for j, p in node.outputs {
        if p.id == port_id {
          let py = screen_y +
            header_h +
            14.0 * scale +
            j.to_double() * port_spacing
          return Some(@math.Vec2::new(screen_x + node_w, py))
        }
      }
    }
  }
  None
}

///|
/// Render the NodeEditor into UIContext.
pub fn NodeEditor::show(
  self : NodeEditor,
  ctx : UIContext,
) -> NodeEditorResponse {
  node_editor(
    ctx,
    self.id_salt,
    self.size,
    self.nodes,
    self.connections,
    custom_style=self.custom_style,
    selected_node=self.selected_node,
  )
}

///|
/// Main functional entry point for the NodeEditor component.
pub fn node_editor(
  ctx : UIContext,
  id_salt : String,
  size : @math.Vec2,
  nodes : Array[NodeItem],
  connections : Array[NodeConnection],
  custom_style? : NodeEditorStyle? = None,
  selected_node? : String? = None,
) -> NodeEditorResponse {
  let scale = ctx.style.scale
  let style = match custom_style {
    Some(s) => s
    None => NodeEditorStyle::default()
  }

  let node_min_w = style.node_min_w * scale
  let header_h = style.node_header_h * scale
  let port_r = style.port_radius * scale
  let port_spacing = style.port_spacing * scale
  let card_radius = style.card_radius * scale
  let wire_width = style.wire_width * scale
  let font_title = ctx.style.font_normal * scale
  let font_port = ctx.style.font_small * scale

  ctx.push_id(id_salt)
  let (canvas_id, canvas_rect, _) = ctx.allocate_space(size)
  ctx.pop_id()

  let painter = ctx.painter()

  // 1. Draw Canvas Background & Studio Dot Grid
  painter.add_rect(canvas_rect, @color.Color::bg_subtle(), card_radius)
  painter.add_rect_stroke(
    canvas_rect,
    @color.Color::border_default(),
    1.0,
    card_radius,
  )

  // Push scissor clip so nodes & wires cannot leak outside editor bounds
  ctx.push_clip(canvas_rect)
  painter.push_clip(canvas_rect)

  let grid_step = style.grid_size * scale
  let mut gx = canvas_rect.x + grid_step * 0.5
  let canvas_right = canvas_rect.x + canvas_rect.w
  let canvas_bottom = canvas_rect.y + canvas_rect.h
  while gx < canvas_right {
    let mut gy = canvas_rect.y + grid_step * 0.5
    while gy < canvas_bottom {
      painter.add_circle(
        @math.Vec2::new(gx, gy),
        1.0 * scale,
        @color.Color::border_muted(),
      )
      gy = gy + grid_step
    }
    gx = gx + grid_step
  }

  // 2. Persistent State in Memory
  let mut active_drag_node = ctx.memory.get_string_or_default(
    canvas_id,
    "",
    tag="drag_node",
  )
  let mut active_conn_node = ctx.memory.get_string_or_default(
    canvas_id,
    "",
    tag="conn_node",
  )
  let mut active_conn_port = ctx.memory.get_string_or_default(
    canvas_id,
    "",
    tag="conn_port",
  )
  let mut cur_selected_node = match selected_node {
    Some(sn) => sn
    None => ctx.memory.get_string_or_default(canvas_id, "", tag="selected_node")
  }

  let mouse_pos = ctx.input.mouse_pos
  let mouse_down = ctx.input.mouse_down
  let mouse_pressed = ctx.input.mouse_pressed
  let is_canvas_hovered = ctx.is_hovered(canvas_rect)

  let mut new_conn : NodeConnection? = None
  let mut changed = false
  let out_conns = []
  for c in connections {
    out_conns.push(c)
  }

  // 3. Handle Mouse Release Actions (End Drag or Complete Port Connection)
  if !mouse_down {
    if active_conn_node != "" && active_conn_port != "" {
      // Check if released over an input port on a different node
      for node in nodes {
        if node.id != active_conn_node {
          let screen_x = canvas_rect.x + node.pos.x
          let screen_y = canvas_rect.y + node.pos.y
          for i, in_port in node.inputs {
            let py = screen_y +
              header_h +
              14.0 * scale +
              i.to_double() * port_spacing
            let port_center = @math.Vec2::new(screen_x, py)
            let dist = (mouse_pos.x - port_center.x).abs() +
              (mouse_pos.y - port_center.y).abs()
            if dist <= port_r * 2.5 + 4.0 * scale {
              let conn = NodeConnection::new(
                active_conn_node,
                active_conn_port,
                node.id,
                in_port.id,
              )
              out_conns.push(conn)
              new_conn = Some(conn)
              changed = true
            }
          }
        }
      }
      ctx.memory.set_string(canvas_id, "", tag="conn_node")
      ctx.memory.set_string(canvas_id, "", tag="conn_port")
      active_conn_node = ""
      active_conn_port = ""
    }

    if active_drag_node != "" {
      ctx.memory.set_string(canvas_id, "", tag="drag_node")
      active_drag_node = ""
    }
  }

  // 4. Update Node Positions During Active Dragging
  if mouse_down && active_drag_node != "" {
    let anchor_x = ctx.memory.get_double_or_default(
      canvas_id,
      0.0,
      tag="drag_anchor_x",
    )
    let anchor_y = ctx.memory.get_double_or_default(
      canvas_id,
      0.0,
      tag="drag_anchor_y",
    )
    for node in nodes {
      if node.id == active_drag_node {
        let new_x = mouse_pos.x - canvas_rect.x - anchor_x
        let new_y = mouse_pos.y - canvas_rect.y - anchor_y
        if node.pos.x != new_x || node.pos.y != new_y {
          node.pos = @math.Vec2::new(new_x, new_y)
          changed = true
        }
        ctx.set_cursor_icon("move")
      }
    }
  }

  // 5. Port Click / Header Drag Initiation (Top-to-Bottom Node Detection)
  if is_canvas_hovered &&
    mouse_pressed &&
    active_drag_node == "" &&
    active_conn_node == "" {
    let mut handled = false

    // Check ports first
    for node in nodes {
      if handled {
        break
      }
      let screen_x = canvas_rect.x + node.pos.x
      let screen_y = canvas_rect.y + node.pos.y
      let node_w = match node.size {
        Some(sz) => sz.x * scale
        None => node_min_w
      }

      for j, out_port in node.outputs {
        let py = screen_y +
          header_h +
          14.0 * scale +
          j.to_double() * port_spacing
        let port_center = @math.Vec2::new(screen_x + node_w, py)
        let dist = (mouse_pos.x - port_center.x).abs() +
          (mouse_pos.y - port_center.y).abs()
        if dist <= port_r * 2.0 + 3.0 * scale {
          active_conn_node = node.id
          active_conn_port = out_port.id
          ctx.memory.set_string(canvas_id, node.id, tag="conn_node")
          ctx.memory.set_string(canvas_id, out_port.id, tag="conn_port")
          handled = true
          break
        }
      }
    }

    // If not clicked on port, check node headers / bodies
    if !handled {
      // Traverse nodes in reverse (topmost visually is last in array)
      for k = nodes.length() - 1; k >= 0; k = k - 1 {
        let node = nodes[k]
        let screen_x = canvas_rect.x + node.pos.x
        let screen_y = canvas_rect.y + node.pos.y
        let node_w = match node.size {
          Some(sz) => sz.x * scale
          None => node_min_w
        }
        let max_ports = if node.inputs.length() > node.outputs.length() {
          node.inputs.length()
        } else {
          node.outputs.length()
        }
        let body_h = (max_ports.to_double() * style.port_spacing + 16.0) * scale
        let total_h = match node.size {
          Some(sz) => sz.y * scale
          None => header_h + body_h
        }

        let node_rect = @math.Rect::new(screen_x, screen_y, node_w, total_h)
        if node_rect.contains(mouse_pos) {
          cur_selected_node = node.id
          active_drag_node = node.id
          ctx.memory.set_string(canvas_id, node.id, tag="selected_node")
          ctx.memory.set_string(canvas_id, node.id, tag="drag_node")
          ctx.memory.set_double(
            canvas_id,
            mouse_pos.x - canvas_rect.x - node.pos.x,
            tag="drag_anchor_x",
          )
          ctx.memory.set_double(
            canvas_id,
            mouse_pos.y - canvas_rect.y - node.pos.y,
            tag="drag_anchor_y",
          )
          handled = true
          break
        }
      }
    }
  }

  // 6. Draw Existing Connection Wires
  let canvas_min = canvas_rect.min()
  for conn in out_conns {
    let p_start = find_port_position(
      canvas_min,
      nodes,
      conn.from_node,
      conn.from_port,
      style,
      scale,
    )
    let p_end = find_port_position(
      canvas_min,
      nodes,
      conn.to_node,
      conn.to_port,
      style,
      scale,
    )
    match (p_start, p_end) {
      (Some(p0), Some(p3)) =>
        draw_cubic_bezier_wire(
          painter,
          p0,
          p3,
          @color.Color::accent_primary(),
          wire_width,
        )
      _ => ()
    }
  }

  // 7. Draw Active In-Progress Drag Connection Wire
  if active_conn_node != "" && active_conn_port != "" {
    let p_start = find_port_position(
      canvas_min, nodes, active_conn_node, active_conn_port, style, scale,
    )
    if p_start is Some(p0) {
      draw_cubic_bezier_wire(
        painter,
        p0,
        mouse_pos,
        @color.Color::accent_hover(),
        wire_width + 0.5,
      )
      ctx.set_cursor_icon("crosshair")
    }
  }

  // 8. Draw Node Cards & Ports
  for node in nodes {
    let screen_x = canvas_rect.x + node.pos.x
    let screen_y = canvas_rect.y + node.pos.y
    let node_w = match node.size {
      Some(sz) => sz.x * scale
      None => node_min_w
    }
    let max_ports = if node.inputs.length() > node.outputs.length() {
      node.inputs.length()
    } else {
      node.outputs.length()
    }
    let body_h = (max_ports.to_double() * style.port_spacing + 16.0) * scale
    let total_h = match node.size {
      Some(sz) => sz.y * scale
      None => header_h + body_h
    }

    let node_rect = @math.Rect::new(screen_x, screen_y, node_w, total_h)
    let header_rect = @math.Rect::new(screen_x, screen_y, node_w, header_h)
    let is_selected = cur_selected_node == node.id

    // Card background fill
    painter.add_rect(node_rect, @color.Color::bg_window(), card_radius)

    // Header background fill
    let header_color = match node.accent_color {
      Some(c) => c
      None => @color.Color::bg_surface()
    }
    painter.add_rect(header_rect, header_color, card_radius)
    // Square off bottom corners of header
    painter.add_rect(
      @math.Rect::new(
        screen_x,
        screen_y + header_h - card_radius,
        node_w,
        card_radius,
      ),
      header_color,
      0.0,
    )

    // Card stroke (highlight if selected)
    let (border_col, stroke_w) = if is_selected {
      (@color.Color::border_focus(), 1.5 * scale)
    } else {
      (@color.Color::border_default(), 1.0)
    }
    painter.add_rect_stroke(node_rect, border_col, stroke_w, card_radius)

    // Node title text
    let title_color = match node.accent_color {
      Some(_) => @color.Color::text_inverse()
      None => @color.Color::text_strong()
    }
    let title_pos = @math.Vec2::new(
      screen_x + 10.0 * scale,
      screen_y + (header_h - font_title) * 0.5,
    )
    painter.add_text(title_pos, node.title, font_title, title_color)

    // Cursor feedback on header hover
    if is_canvas_hovered && header_rect.contains(mouse_pos) {
      ctx.set_cursor_icon("move")
    }

    // Render Input Ports (Left)
    for i, in_port in node.inputs {
      let py = screen_y + header_h + 14.0 * scale + i.to_double() * port_spacing
      let port_center = @math.Vec2::new(screen_x, py)
      let p_col = match in_port.color {
        Some(c) => c
        None => @color.Color::accent_primary()
      }

      // Check hover
      let is_port_hovered = is_canvas_hovered &&
        (mouse_pos.x - port_center.x).abs() <= port_r * 2.0 &&
        (mouse_pos.y - port_center.y).abs() <= port_r * 2.0

      if is_port_hovered {
        ctx.set_cursor_icon("crosshair")
        painter.add_circle(port_center, port_r + 2.0 * scale, p_col)
      } else {
        painter.add_circle(port_center, port_r, p_col)
        painter.add_circle_stroke(
          port_center,
          port_r,
          @color.Color::bg_surface(),
          1.5,
        )
      }

      let label_pos = @math.Vec2::new(
        screen_x + port_r + 6.0 * scale,
        py - font_port * 0.5,
      )
      painter.add_text(
        label_pos,
        in_port.name,
        font_port,
        @color.Color::text_primary(),
      )
    }

    // Render Output Ports (Right)
    for j, out_port in node.outputs {
      let py = screen_y + header_h + 14.0 * scale + j.to_double() * port_spacing
      let port_center = @math.Vec2::new(screen_x + node_w, py)
      let p_col = match out_port.color {
        Some(c) => c
        None => @color.Color::accent_primary()
      }

      let is_port_hovered = is_canvas_hovered &&
        (mouse_pos.x - port_center.x).abs() <= port_r * 2.0 &&
        (mouse_pos.y - port_center.y).abs() <= port_r * 2.0

      if is_port_hovered {
        ctx.set_cursor_icon("crosshair")
        painter.add_circle(port_center, port_r + 2.0 * scale, p_col)
      } else {
        painter.add_circle(port_center, port_r, p_col)
        painter.add_circle_stroke(
          port_center,
          port_r,
          @color.Color::bg_surface(),
          1.5,
        )
      }

      let label_sz = ctx.measure_text(out_port.name, font_port)
      let label_pos = @math.Vec2::new(
        screen_x + node_w - port_r - 6.0 * scale - label_sz.x,
        py - font_port * 0.5,
      )
      painter.add_text(
        label_pos,
        out_port.name,
        font_port,
        @color.Color::text_primary(),
      )
    }
  }

  // Pop scissor clip
  painter.pop_clip()
  ctx.pop_clip()

  let active_drag = if active_drag_node != "" {
    Some(active_drag_node)
  } else {
    None
  }
  let sel_node = if cur_selected_node != "" {
    Some(cur_selected_node)
  } else {
    None
  }

  {
    rect: canvas_rect,
    nodes,
    connections: out_conns,
    selected_node: sel_node,
    dragged_node: active_drag,
    new_connection: new_conn,
    changed,
  }
}
