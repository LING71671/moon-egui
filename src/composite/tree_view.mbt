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
pub fn tree_view(
  ctx : UIContext,
  id_salt : String,
  nodes : Array[TreeNode],
  selected_id? : String? = None,
  expanded_ids? : Array[String] = [],
  indent_step? : Double = 16.0,
  item_height? : Double = 0.0,
  size? : @math.Vec2,
) -> TreeViewResponse {
  let scale = ctx.style.scale
  let eff_indent = indent_step * scale
  let eff_row_h = if item_height > 0.0 {
    item_height
  } else {
    (ctx.style.control_h_sm + ctx.style.radius_xs) * scale
  }

  // 1. Flatten visible hierarchy based on expanded set
  let flat_nodes : Array[FlatTreeNode] = []
  flatten_tree_nodes(nodes, expanded_ids, 0, None, flat_nodes)

  let node_count = flat_nodes.length()
  let content_height = if node_count > 0 {
    node_count.to_double() * eff_row_h + 4.0 * scale
  } else {
    eff_row_h + 4.0 * scale
  }

  let total_w = match size {
    Some(s) => s.x
    None =>
      if ctx.available_width() > 0.0 {
        ctx.available_width()
      } else {
        240.0 * scale
      }
  }
  let total_h = match size {
    Some(s) => s.y
    None => content_height
  }

  // 2. Allocate widget container space
  let id = ctx.id_stack.derive_id("tree_view::" + id_salt)
  let (_, rect, response) = ctx.allocate_space(
    @math.Vec2::new(total_w, total_h),
  )

  if response.hovered {
    ctx.set_cursor_icon("pointer")
  }

  ctx.register_focusable(id)
  if response.pressed() || response.clicked() {
    ctx.request_focus(id)
  }
  let is_focused = ctx.has_focus(id)

  let scroll_id = ctx.id_stack.derive_id("tree_view::" + id_salt + "::scroll")
  let mut scroll_y = ctx.get_scroll_offset(scroll_id)
  let max_scroll = if content_height > total_h {
    content_height - total_h
  } else {
    0.0
  }

  if response.hovered && ctx.input.scroll_delta.y != 0.0 && max_scroll > 0.0 {
    scroll_y = scroll_y - ctx.input.scroll_delta.y
  }

  let tree_radius = ctx.style.radius_md * scale

  // Surface and outer border
  ctx.painter().add_rect(rect, ctx.theme.bg_window, tree_radius)
  let border_color = if is_focused {
    ctx.theme.border_focus
  } else {
    ctx.theme.border_muted
  }
  ctx.painter().add_rect_stroke(rect, border_color, 1.0, tree_radius)

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
    if ctx.input.key_pressed(Key::ArrowUp) {
      ctx.input.consume_key(Key::ArrowUp)
      if sel_idx > 0 {
        cur_selected = Some(flat_nodes[sel_idx - 1].node.id)
        clicked_id = cur_selected
      } else if sel_idx == -1 {
        cur_selected = Some(flat_nodes[0].node.id)
        clicked_id = cur_selected
      }
    }

    // Down arrow
    if ctx.input.key_pressed(Key::ArrowDown) {
      ctx.input.consume_key(Key::ArrowDown)
      if sel_idx >= 0 && sel_idx < node_count - 1 {
        cur_selected = Some(flat_nodes[sel_idx + 1].node.id)
        clicked_id = cur_selected
      } else if sel_idx == -1 {
        cur_selected = Some(flat_nodes[0].node.id)
        clicked_id = cur_selected
      }
    }

    // Right arrow: expand if node has children and is collapsed
    if ctx.input.key_pressed(Key::ArrowRight) {
      ctx.input.consume_key(Key::ArrowRight)
      if sel_idx >= 0 {
        let flat = flat_nodes[sel_idx]
        if flat.has_children && !flat.is_expanded {
          next_expanded.push(flat.node.id)
          toggled_id = Some(flat.node.id)
        }
      }
    }

    // Left arrow: collapse if node is expanded, or jump to parent
    if ctx.input.key_pressed(Key::ArrowLeft) {
      ctx.input.consume_key(Key::ArrowLeft)
      if sel_idx >= 0 {
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

    // Auto-scroll selected node into view
    let target_idx = match cur_selected {
      Some(sel_id) => {
        let mut idx = -1
        for i = 0; i < node_count; i = i + 1 {
          if flat_nodes[i].node.id == sel_id {
            idx = i
            break
          }
        }
        idx
      }
      None => -1
    }
    if target_idx >= 0 && max_scroll > 0.0 {
      let row_top = target_idx.to_double() * eff_row_h
      let row_bottom = row_top + eff_row_h
      if row_top < scroll_y {
        scroll_y = row_top
      } else if row_bottom > scroll_y + total_h - 4.0 * scale {
        scroll_y = row_bottom - (total_h - 4.0 * scale)
      }
    }
  }

  if scroll_y < 0.0 {
    scroll_y = 0.0
  }
  if scroll_y > max_scroll {
    scroll_y = max_scroll
  }
  ctx.set_scroll_offset(scroll_id, scroll_y)

  // 4. Hit testing and rendering visible rows with container scissor clipping
  if node_count > 0 {
    ctx.push_clip(rect)
  }
  let sb_reserve = if max_scroll > 0.0 { 6.0 * scale } else { 0.0 }
  for i = 0; i < node_count; i = i + 1 {
    let flat = flat_nodes[i]
    let node = flat.node
    let row_y = rect.y + 2.0 * scale + i.to_double() * eff_row_h - scroll_y
    let is_in_view = row_y + eff_row_h >= rect.y && row_y <= rect.y + rect.h
    let row_rect = @math.Rect::new(
      rect.x + 2.0 * scale,
      row_y,
      rect.w - 4.0 * scale - sb_reserve,
      eff_row_h,
    )

    let is_row_hovered = is_in_view && ctx.is_hovered(row_rect)
    let is_row_selected = Some(node.id) == cur_selected

    // Chevron hit box
    let chevron_x = row_rect.x +
      4.0 * scale +
      flat.depth.to_double() * eff_indent
    let chevron_rect = @math.Rect::new(
      chevron_x,
      row_y,
      16.0 * scale,
      eff_row_h,
    )
    let is_chevron_hovered = flat.has_children && ctx.is_hovered(chevron_rect)
    if is_row_hovered || is_chevron_hovered {
      ctx.set_cursor_icon("pointer")
    }

    // Handle clicks
    if ctx.input.mouse_pressed {
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
        ctx.request_focus(id)
      }
    }

    let row_radius = ctx.style.radius_sm * scale
    let font_sm = ctx.style.font_small * scale
    let font_nm = ctx.style.font_normal * scale

    // Row background wash
    if is_row_selected {
      ctx
      .painter()
      .add_rect(row_rect, @color.Color::tree_row_selected(), row_radius)
      // Left cobalt accent bar (2.5px)
      ctx
      .painter()
      .add_rect(
        @math.Rect::new(
          row_rect.x,
          row_rect.y + 2.0 * scale,
          2.5 * scale,
          row_rect.h - 4.0 * scale,
        ),
        @color.Color::accent_primary(),
        1.0,
      )
    } else if is_row_hovered {
      ctx.painter().add_rect(row_rect, ctx.theme.bg_hover, row_radius)
    }

    // Hierarchy guide lines (for depths > 0)
    for d = 0; d < flat.depth; d = d + 1 {
      let guide_x = row_rect.x +
        4.0 * scale +
        d.to_double() * eff_indent +
        7.5 * scale
      ctx
      .painter()
      .add_line(
        @math.Vec2::new(guide_x, row_rect.y),
        @math.Vec2::new(guide_x, row_rect.y + row_rect.h),
        ctx.theme.border_muted,
        1.0,
      )
    }

    // Chevron glyph
    if flat.has_children {
      let chevron_glyph = if flat.is_expanded { "v" } else { ">" }
      let chevron_col = if is_chevron_hovered {
        ctx.theme.text_primary
      } else {
        ctx.theme.text_muted
      }
      ctx
      .painter()
      .add_text(
        @math.Vec2::new(chevron_x + 3.0 * scale, row_y + 5.0 * scale),
        chevron_glyph,
        font_sm,
        chevron_col,
      )
    }

    // Icon chiclet badge (if provided)
    let content_x = chevron_x + 18.0 * scale
    let mut text_x = content_x
    if !node.icon.is_empty() {
      let icon_size = ctx.measure_text(node.icon, font_sm)
      let badge_w = icon_size.x + 8.0 * scale
      let badge_h = 16.0 * scale
      let badge_rect = @math.Rect::new(
        content_x,
        row_y + 4.0 * scale,
        badge_w,
        badge_h,
      )
      let (badge_bg, badge_col) = if is_row_selected {
        (ctx.theme.accent_soft, ctx.theme.accent_primary)
      } else {
        (ctx.theme.bg_subtle, ctx.theme.text_secondary)
      }
      ctx.painter().add_rect(badge_rect, badge_bg, 3.0 * scale)
      ctx
      .painter()
      .add_text(
        @math.Vec2::new(content_x + 4.0 * scale, row_y + 6.0 * scale),
        node.icon,
        font_sm,
        badge_col,
      )
      text_x = content_x + badge_w + 6.0 * scale
    }

    // Label text
    let label_col = if is_row_selected {
      ctx.theme.accent_primary
    } else if is_row_hovered {
      ctx.theme.text_primary
    } else {
      ctx.theme.text_body
    }
    ctx
    .painter()
    .add_text(
      @math.Vec2::new(text_x, row_y + 5.5 * scale),
      node.label,
      font_nm,
      label_col,
    )
  }
  if node_count > 0 {
    ctx.pop_clip()
  }

  // 5. Interactive Scrollbar Thumb (when content overflows container)
  if max_scroll > 0.0 {
    let sb_w = 4.0 * scale
    let sb_x = rect.x + rect.w - sb_w - 2.0 * scale
    let sb_track_y = rect.y + 2.0 * scale
    let sb_track_h = rect.h - 4.0 * scale
    let raw_thumb_h = sb_track_h * (total_h / content_height)
    let min_thumb_h = 16.0 * scale
    let thumb_h = if raw_thumb_h < min_thumb_h {
      min_thumb_h
    } else if raw_thumb_h > sb_track_h {
      sb_track_h
    } else {
      raw_thumb_h
    }
    let usable_h = sb_track_h - thumb_h
    let thumb_y = sb_track_y +
      (if max_scroll > 0.0 { scroll_y / max_scroll * usable_h } else { 0.0 })
    let thumb_rect = @math.Rect::new(sb_x, thumb_y, sb_w, thumb_h)
    let track_rect = @math.Rect::new(
      sb_x - 2.0 * scale,
      sb_track_y,
      sb_w + 4.0 * scale,
      sb_track_h,
    )

    let is_tb_hovered = ctx.is_hovered(thumb_rect)
    let is_tk_hovered = ctx.is_hovered(track_rect)
    let thumb_id = ctx.id_stack.derive_id("tree_view::" + id_salt + "::thumb")
    let grab_id = ctx.id_stack.derive_id("tree_view::" + id_salt + "::grab")

    if is_tb_hovered || is_tk_hovered || ctx.active_id() == thumb_id {
      ctx.set_cursor_icon("pointer")
    }

    if (is_tb_hovered || is_tk_hovered) && ctx.input.mouse_pressed {
      ctx.set_active_id(thumb_id)
      let initial_grab = if is_tb_hovered {
        ctx.input.mouse_pos.y - thumb_y
      } else {
        thumb_h * 0.5
      }
      ctx.set_scroll_offset(grab_id, initial_grab)
    }

    if ctx.active_id() == thumb_id {
      ctx.set_wants_capture_mouse(true)
      if ctx.input.mouse_down && usable_h > 0.0 {
        let grab_offset = ctx.get_scroll_offset(grab_id)
        let rel_mouse_y = ctx.input.mouse_pos.y - sb_track_y - grab_offset
        let mut new_pct = rel_mouse_y / usable_h
        if new_pct < 0.0 {
          new_pct = 0.0
        }
        if new_pct > 1.0 {
          new_pct = 1.0
        }
        scroll_y = new_pct * max_scroll
        ctx.set_scroll_offset(scroll_id, scroll_y)
      }
      if ctx.input.mouse_released {
        ctx.set_active_id(@core.Id::zero())
      }
    }

    let active_thumb_y = sb_track_y +
      (if max_scroll > 0.0 { scroll_y / max_scroll * usable_h } else { 0.0 })
    let active_thumb_rect = @math.Rect::new(sb_x, active_thumb_y, sb_w, thumb_h)
    let thumb_col = if ctx.active_id() == thumb_id || is_tb_hovered {
      ctx.theme.accent_primary
    } else {
      ctx.theme.border_muted
    }
    ctx
    .painter()
    .add_rect(active_thumb_rect, thumb_col, ctx.style.radius_sm * scale)
  }

  {
    selected_id: cur_selected,
    expanded_ids: next_expanded,
    clicked_id,
    toggled_id,
    response,
  }
}
