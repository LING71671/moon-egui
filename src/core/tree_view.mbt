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
pub struct TreeNode {
  id : String
  label : String
  icon : String
  children : Array[TreeNode]
} derive(Eq, Debug)

///|
pub fn TreeNode::new(
  id : String,
  label : String,
  children? : Array[TreeNode] = [],
  icon? : String = "",
) -> TreeNode {
  { id, label, icon, children, }
}

///|
pub fn TreeNode::leaf(
  id : String,
  label : String,
  icon? : String = "",
) -> TreeNode {
  { id, label, icon, children: [], }
}

///|
pub fn TreeNode::is_leaf(self : TreeNode) -> Bool {
  self.children.is_empty()
}

///|
pub struct TreeViewResponse {
  selected_id : String?
  expanded_ids : Array[String]
  clicked_id : String?
  toggled_id : String?
  response : Response
} derive(Eq, Debug)

///|
priv struct FlatTreeNode {
  node : TreeNode
  depth : Int
  is_expanded : Bool
  has_children : Bool
  parent_id : String?
}

///|
fn flatten_tree_nodes(
  nodes : Array[TreeNode],
  expanded_ids : Array[String],
  depth : Int,
  parent_id : String?,
  out : Array[FlatTreeNode],
) -> Unit {
  for node in nodes {
    let has_children = !node.children.is_empty()
    let is_expanded = has_children && expanded_ids.contains(node.id)
    out.push({ node, depth, is_expanded, has_children, parent_id, })
    if is_expanded {
      flatten_tree_nodes(
        node.children,
        expanded_ids,
        depth + 1,
        Some(node.id),
        out,
      )
    }
  }
}

///|
/// Immediate-mode hierarchical tree view in Studio Light porcelain style.
/// Supports multi-level expand/collapse with memory, hierarchy guide lines,
/// custom node icons, selection highlights, and full keyboard navigation.
pub fn UIContext::tree_view(
  self : UIContext,
  id_salt : String,
  nodes : Array[TreeNode],
  selected_id? : String? = None,
  expanded_ids? : Array[String] = [],
  indent_step? : Double = 16.0,
  item_height? : Double = 26.0,
  size? : @math.Vec2,
) -> TreeViewResponse {
  // 1. Flatten visible hierarchy based on expanded set
  let flat_nodes : Array[FlatTreeNode] = []
  flatten_tree_nodes(nodes, expanded_ids, 0, None, flat_nodes)

  let node_count = flat_nodes.length()
  let content_height = if node_count > 0 {
    node_count.to_double() * item_height + 4.0
  } else {
    item_height + 4.0
  }

  let total_w = match size {
    Some(s) => s.x
    None =>
      if self.available_width > 0.0 {
        self.available_width
      } else {
        240.0
      }
  }
  let total_h = match size {
    Some(s) => s.y
    None => content_height
  }

  // 2. Allocate widget container space
  let id = self.id_stack.derive_id("tree_view::" + id_salt)
  let (_, rect, response) = self.allocate_space(
    @math.Vec2::new(total_w, total_h),
  )

  self.register_focusable(id)
  if response.pressed() || response.clicked() {
    self.request_focus(id)
  }
  let is_focused = self.has_focus(id)

  // Surface and outer border
  self.draw_list.add_rect(rect, @color.Color::white(), 6.0)
  let border_color = if is_focused {
    @color.Color::border_focus()
  } else {
    @color.Color::border_muted()
  }
  self.draw_list.add_rect_stroke(rect, border_color, 1.0, 6.0)

  let mut cur_selected = selected_id
  let next_expanded = expanded_ids.copy()
  let mut clicked_id : String? = None
  let mut toggled_id : String? = None

  // 3. Keyboard navigation when focused
  if is_focused && node_count > 0 {
    let mut sel_idx = -1
    for i = 0; i < node_count; i = i + 1 {
      if Some(flat_nodes[i].node.id) == cur_selected {
        sel_idx = i
        break
      }
    }

    // Up arrow
    if self.input.key_pressed(Key::ArrowUp) {
      if sel_idx > 0 {
        cur_selected = Some(flat_nodes[sel_idx - 1].node.id)
        clicked_id = cur_selected
      } else if sel_idx == -1 {
        cur_selected = Some(flat_nodes[0].node.id)
        clicked_id = cur_selected
      }
    }

    // Down arrow
    if self.input.key_pressed(Key::ArrowDown) {
      if sel_idx >= 0 && sel_idx < node_count - 1 {
        cur_selected = Some(flat_nodes[sel_idx + 1].node.id)
        clicked_id = cur_selected
      } else if sel_idx == -1 {
        cur_selected = Some(flat_nodes[0].node.id)
        clicked_id = cur_selected
      }
    }

    // Right arrow: expand if node has children and is collapsed
    if self.input.key_pressed(Key::ArrowRight) && sel_idx >= 0 {
      let flat = flat_nodes[sel_idx]
      if flat.has_children && !flat.is_expanded {
        next_expanded.push(flat.node.id)
        toggled_id = Some(flat.node.id)
      }
    }

    // Left arrow: collapse if node is expanded, or jump to parent
    if self.input.key_pressed(Key::ArrowLeft) && sel_idx >= 0 {
      let flat = flat_nodes[sel_idx]
      if flat.has_children && flat.is_expanded {
        let mut idx_to_remove = -1
        for i = 0; i < next_expanded.length(); i = i + 1 {
          if next_expanded[i] == flat.node.id {
            idx_to_remove = i
            break
          }
        }
        if idx_to_remove >= 0 {
          let _ = next_expanded.remove(idx_to_remove)
          toggled_id = Some(flat.node.id)
        }
      } else if flat.parent_id is Some(p_id) {
        cur_selected = Some(p_id)
        clicked_id = Some(p_id)
      }
    }
  }

  // 4. Hit testing and rendering visible rows with container scissor clipping
  if node_count > 0 {
    self.push_clip(rect)
  }
  for i = 0; i < node_count; i = i + 1 {
    let flat = flat_nodes[i]
    let node = flat.node
    let row_y = rect.y + 2.0 + i.to_double() * item_height
    let is_in_view = row_y + item_height <= rect.y + rect.h + 2.0 &&
      row_y >= rect.y
    let row_rect = @math.Rect::new(
      rect.x + 2.0,
      row_y,
      rect.w - 4.0,
      item_height,
    )

    let is_row_hovered = is_in_view && self.is_hovered(row_rect)
    let is_row_selected = Some(node.id) == cur_selected

    // Chevron hit box
    let chevron_x = row_rect.x + 4.0 + flat.depth.to_double() * indent_step
    let chevron_rect = @math.Rect::new(chevron_x, row_y, 16.0, item_height)
    let is_chevron_hovered = flat.has_children && self.is_hovered(chevron_rect)
    if is_row_hovered || is_chevron_hovered {
      self.set_cursor_icon("pointer")
    }

    // Handle clicks
    if self.input.mouse_pressed {
      if is_chevron_hovered {
        // Toggle expansion
        if flat.is_expanded {
          let mut found = -1
          for j = 0; j < next_expanded.length(); j = j + 1 {
            if next_expanded[j] == node.id {
              found = j
              break
            }
          }
          if found >= 0 {
            let _ = next_expanded.remove(found)
          }
        } else {
          next_expanded.push(node.id)
        }
        toggled_id = Some(node.id)
      } else if is_row_hovered {
        cur_selected = Some(node.id)
        clicked_id = Some(node.id)
        self.request_focus(id)
      }
    }

    // Row background wash
    if is_row_selected {
      self.draw_list.add_rect(row_rect, @color.Color::hex(0xEFF6FF), 4.0)
      // Left cobalt accent bar (2.5px)
      self.draw_list.add_rect(
        @math.Rect::new(row_rect.x, row_rect.y + 2.0, 2.5, row_rect.h - 4.0),
        @color.Color::accent_primary(),
        1.0,
      )
    } else if is_row_hovered {
      self.draw_list.add_rect(row_rect, @color.Color::bg_hover(), 4.0)
    }

    // Hierarchy guide lines (for depths > 0)
    for d = 0; d < flat.depth; d = d + 1 {
      let guide_x = row_rect.x + 4.0 + d.to_double() * indent_step + 7.5
      self.draw_list.add_line(
        @math.Vec2::new(guide_x, row_rect.y),
        @math.Vec2::new(guide_x, row_rect.y + row_rect.h),
        @color.Color::border_muted(),
        1.0,
      )
    }

    // Chevron glyph
    if flat.has_children {
      let chevron_glyph = if flat.is_expanded { "v" } else { ">" }
      let chevron_col = if is_chevron_hovered {
        @color.Color::text_primary()
      } else {
        @color.Color::text_muted()
      }
      self.draw_list.add_text(
        @math.Vec2::new(chevron_x + 3.0, row_y + 5.0),
        chevron_glyph,
        11.0,
        chevron_col,
      )
    }

    // Icon chiclet badge (if provided)
    let content_x = chevron_x + 18.0
    let mut text_x = content_x
    if !node.icon.is_empty() {
      let icon_size = self.measure_text(node.icon, 10.0)
      let badge_w = icon_size.x + 8.0
      let badge_h = 16.0
      let badge_rect = @math.Rect::new(content_x, row_y + 4.0, badge_w, badge_h)
      let (badge_bg, badge_col) = if is_row_selected {
        (@color.Color::accent_soft(), @color.Color::accent_primary())
      } else {
        (@color.Color::bg_subtle(), @color.Color::text_secondary())
      }
      self.draw_list.add_rect(badge_rect, badge_bg, 3.0)
      self.draw_list.add_text(
        @math.Vec2::new(content_x + 4.0, row_y + 6.0),
        node.icon,
        10.0,
        badge_col,
      )
      text_x = content_x + badge_w + 6.0
    }

    // Label text
    let label_col = if is_row_selected {
      @color.Color::accent_primary()
    } else if is_row_hovered {
      @color.Color::text_primary()
    } else {
      @color.Color::text_body()
    }
    self.draw_list.add_text(
      @math.Vec2::new(text_x, row_y + 5.5),
      node.label,
      12.0,
      label_col,
    )
  }
  if node_count > 0 {
    self.pop_clip()
  }

  {
    selected_id: cur_selected,
    expanded_ids: next_expanded,
    clicked_id,
    toggled_id,
    response,
  }
}
