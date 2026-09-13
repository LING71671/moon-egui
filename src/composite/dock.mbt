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
/// Split direction for a docking container node.
pub(all) enum DockSplitDirection {
  Horizontal
  Vertical
} derive(Eq, Debug)

///|
pub fn DockSplitDirection::horizontal() -> DockSplitDirection {
  Horizontal
}

///|
pub fn DockSplitDirection::vertical() -> DockSplitDirection {
  Vertical
}

///|
/// Single tab descriptor inside a dock leaf panel.
pub struct DockTab {
  id : String
  title : String
  closable : Bool
} derive(Eq, Debug)

///|
/// Create a new dock tab.
pub fn DockTab::new(
  id : String,
  title : String,
  closable? : Bool = false,
) -> DockTab {
  { id, title, closable, }
}

///|
/// Recursive layout tree node for multi-window docking.
pub(all) enum DockNode {
  Leaf(Array[DockTab], Int) // tabs, active_tab_index
  Split(DockSplitDirection, Double, DockNode, DockNode) // direction, ratio, first, second
  Empty
} derive(Eq, Debug)

///|
/// Container managing a mutable docking layout tree.
pub struct DockTree {
  mut root : DockNode
} derive(Eq, Debug)

///|
/// Create a new dock tree from a root node.
pub fn DockTree::new(root : DockNode) -> DockTree {
  { root, }
}

///|
/// Create a leaf dock tree with tabs.
pub fn DockTree::leaf(tabs : Array[DockTab], active_tab? : Int = 0) -> DockTree {
  { root: Leaf(tabs, active_tab), }
}

///|
/// Create a split dock tree combining two subtrees.
pub fn DockTree::split(
  direction : DockSplitDirection,
  ratio : Double,
  first : DockTree,
  second : DockTree,
) -> DockTree {
  { root: Split(direction, ratio, first.root, second.root), }
}

///|
/// Retrieve current root node.
pub fn DockTree::root(self : DockTree) -> DockNode {
  self.root
}

///|
/// Helper to find a tab and its leaf index recursively.
fn find_tab_in_node(node : DockNode, tab_id : String) -> (DockTab, Int)? {
  match node {
    Leaf(tabs, active_idx) => {
      for i = 0; i < tabs.length(); i = i + 1 {
        if tabs[i].id == tab_id {
          return Some((tabs[i], active_idx))
        }
      }
      None
    }
    Split(_, _, first, second) =>
      match find_tab_in_node(first, tab_id) {
        Some(res) => Some(res)
        None => find_tab_in_node(second, tab_id)
      }
    Empty => None
  }
}

///|
/// Find a tab by its ID across the entire dock tree.
pub fn DockTree::find_tab(self : DockTree, tab_id : String) -> (DockTab, Int)? {
  find_tab_in_node(self.root, tab_id)
}

///|
/// Helper to activate a tab by its ID recursively.
fn activate_tab_in_node(node : DockNode, tab_id : String) -> (DockNode, Bool) {
  match node {
    Leaf(tabs, _) => {
      let mut found_idx = -1
      for i = 0; i < tabs.length(); i = i + 1 {
        if tabs[i].id == tab_id {
          found_idx = i
          break
        }
      }
      if found_idx >= 0 {
        (Leaf(tabs, found_idx), true)
      } else {
        (node, false)
      }
    }
    Split(dir, ratio, first, second) => {
      let (new_first, f_ok) = activate_tab_in_node(first, tab_id)
      if f_ok {
        (Split(dir, ratio, new_first, second), true)
      } else {
        let (new_second, s_ok) = activate_tab_in_node(second, tab_id)
        (Split(dir, ratio, new_first, new_second), s_ok)
      }
    }
    Empty => (Empty, false)
  }
}

///|
/// Set active tab by tab ID across the dock tree.
pub fn DockTree::set_active_tab(self : DockTree, tab_id : String) -> Bool {
  let (new_root, ok) = activate_tab_in_node(self.root, tab_id)
  self.root = new_root
  ok
}

///|
/// Helper to close a tab by its ID recursively.
fn close_tab_in_node(node : DockNode, tab_id : String) -> (DockNode, Bool) {
  match node {
    Leaf(tabs, active_idx) => {
      let new_tabs = []
      let mut removed = false
      for i = 0; i < tabs.length(); i = i + 1 {
        if tabs[i].id == tab_id {
          removed = true
        } else {
          new_tabs.push(tabs[i])
        }
      }
      if removed {
        if new_tabs.is_empty() {
          (Empty, true)
        } else {
          let new_active = if active_idx >= new_tabs.length() {
            new_tabs.length() - 1
          } else {
            active_idx
          }
          (Leaf(new_tabs, new_active), true)
        }
      } else {
        (node, false)
      }
    }
    Split(dir, ratio, first, second) => {
      let (new_first, f_ok) = close_tab_in_node(first, tab_id)
      let (new_second, s_ok) = if f_ok {
        (second, false)
      } else {
        close_tab_in_node(second, tab_id)
      }

      if f_ok || s_ok {
        // Collapse if one branch became Empty
        match (new_first, new_second) {
          (Empty, remaining) => (remaining, true)
          (remaining, Empty) => (remaining, true)
          _ => (Split(dir, ratio, new_first, new_second), true)
        }
      } else {
        (node, false)
      }
    }
    Empty => (Empty, false)
  }
}

///|
/// Close a tab by its ID across the dock tree.
pub fn DockTree::close_tab(self : DockTree, tab_id : String) -> Bool {
  let (new_root, ok) = close_tab_in_node(self.root, tab_id)
  self.root = new_root
  ok
}

///|
/// Interaction response for a dock area layout frame.
pub struct DockResponse {
  resp : Response
  active_tab_changed : (String, String)? // (old_id, new_id)
  tab_closed : String?
  ratio_changed : Bool
} derive(Eq, Debug)

///|
/// Standalone DockArea widget struct.
pub struct DockArea {
  id_salt : String
  size : @math.Vec2
  tree : DockTree
  render_tab : (UIContext, String, @math.Rect) -> Unit
}

///|
/// Create a new DockArea widget.
pub fn DockArea::new(
  id_salt : String,
  size : @math.Vec2,
  tree : DockTree,
  render_tab : (UIContext, String, @math.Rect) -> Unit,
) -> DockArea {
  { id_salt, size, tree, render_tab, }
}

///|
pub impl @core.Widget for DockArea with fn ui(self, ctx : UIContext) -> Response {
  let d_resp = self.show(ctx)
  d_resp.resp
}

///|
/// Render the DockArea and return interaction details.
pub fn DockArea::show(self : DockArea, ctx : UIContext) -> DockResponse {
  dock_area(ctx, self.id_salt, self.size, self.tree, self.render_tab)
}

///|
/// Internal rendering function for a single dock node.
fn render_dock_node(
  ctx : UIContext,
  node : DockNode,
  rect : @math.Rect,
  path : String,
  render_tab : (UIContext, String, @math.Rect) -> Unit,
) -> (DockNode, (String, String)?, String?, Bool) {
  let scale = ctx.style.scale
  let min_pane_size = 40.0 * scale

  match node {
    Empty => (Empty, None, None, false)
    Leaf(tabs, active_idx) => {
      if tabs.is_empty() {
        return (Empty, None, None, false)
      }

      let valid_active = if active_idx < 0 || active_idx >= tabs.length() {
        0
      } else {
        active_idx
      }

      let tab_bar_h = 28.0 * scale
      let header_rect = @math.Rect::new(rect.x, rect.y, rect.w, tab_bar_h)
      let content_rect = @math.Rect::new(
        rect.x,
        rect.y + tab_bar_h,
        rect.w,
        rect.h - tab_bar_h,
      )

      let painter = ctx.painter()

      // Header tab-bar background
      painter.add_rect(header_rect, @color.Color::bg_surface(), 0.0)
      painter.add_line(
        @math.Vec2::new(rect.x, rect.y + tab_bar_h),
        @math.Vec2::new(rect.x + rect.w, rect.y + tab_bar_h),
        @color.Color::border_default(),
        1.0,
      )

      // Render tab buttons
      let mut cur_tab_x = rect.x + 4.0 * scale
      let mut new_active_idx = valid_active
      let mut tab_switched = None
      let mut closed_tab_id = None

      for i = 0; i < tabs.length(); i = i + 1 {
        let tab = tabs[i]
        let font_sz = ctx.style.font_small * scale
        let title_w = ctx.measure_text(tab.title, font_sz).x
        let close_btn_w = if tab.closable { 16.0 * scale } else { 0.0 }
        let tab_w = title_w + close_btn_w + 16.0 * scale
        let tab_rect = @math.Rect::new(
          cur_tab_x,
          rect.y + 2.0 * scale,
          tab_w,
          tab_bar_h - 2.0 * scale,
        )

        let is_current = i == valid_active
        let is_hovered = ctx.is_hovered(tab_rect)
        let tab_focus_id = ctx.id_stack.derive_id(path + "_tab::" + tab.id)
        ctx.register_focusable(tab_focus_id)
        let tab_focused = ctx.has_focus(tab_focus_id)
        let key_switch = tab_focused &&
          !is_current &&
          (
            ctx.input().key_pressed(Key::Enter) ||
            ctx.input().key_pressed(Key::Space)
          )
        if key_switch {
          ctx.input().consume_key(Key::Enter)
          ctx.input().consume_key(Key::Space)
        }

        // A tab is a click target as a whole; the close cross overrides this
        // with its own pointer further down.
        if is_hovered {
          ctx.set_cursor_icon("pointer")
        }

        // Tab background pill
        if is_current {
          painter.add_rect(tab_rect, @color.Color::bg_window(), 4.0 * scale)
          painter.add_rect_stroke(
            tab_rect,
            @color.Color::border_default(),
            1.0,
            4.0 * scale,
          )
          // Top accent line
          painter.add_rect(
            @math.Rect::new(
              cur_tab_x + 4.0 * scale,
              rect.y + 2.0 * scale,
              tab_w - 8.0 * scale,
              2.0 * scale,
            ),
            @color.Color::accent_primary(),
            1.0,
          )
        } else if is_hovered {
          painter.add_rect(tab_rect, @color.Color::bg_hover(), 4.0 * scale)
        }

        if tab_focused {
          painter.add_rect_stroke(
            tab_rect,
            @color.Color::border_focus(),
            1.0,
            4.0 * scale,
          )
        }

        // Tab title text
        let text_col = if is_current {
          @color.Color::text_strong()
        } else {
          @color.Color::text_muted()
        }
        painter.add_text(
          @math.Vec2::new(cur_tab_x + 8.0 * scale, rect.y + 7.0 * scale),
          tab.title,
          font_sz,
          text_col,
        )

        // Close button if closable
        if tab.closable {
          let close_x = cur_tab_x + tab_w - 14.0 * scale
          let close_y = rect.y + 8.0 * scale
          let close_rect = @math.Rect::new(
            close_x - 2.0 * scale,
            close_y - 2.0 * scale,
            12.0 * scale,
            12.0 * scale,
          )
          let close_hovered = ctx.is_hovered(close_rect)

          if close_hovered {
            painter.add_rect(close_rect, @color.Color::bg_active(), 2.0 * scale)
            ctx.set_cursor_icon("pointer")
          }

          let close_col = if close_hovered {
            @color.Color::danger()
          } else {
            @color.Color::text_muted()
          }
          painter.add_text(
            @math.Vec2::new(close_x, close_y - 1.0 * scale),
            "×",
            font_sz,
            close_col,
          )

          if close_hovered && ctx.input().mouse_released {
            closed_tab_id = Some(tab.id)
          }
        }

        // Click or keyboard to switch tab
        if (is_hovered && ctx.input().mouse_released && closed_tab_id is None) ||
          (key_switch && closed_tab_id is None) {
          if i != valid_active {
            tab_switched = Some((tabs[valid_active].id, tab.id))
            new_active_idx = i
          }
        }

        cur_tab_x = cur_tab_x + tab_w + 4.0 * scale
      }

      // Handle close tab if clicked
      let result_node = match closed_tab_id {
        Some(cid) => {
          let remaining = []
          for t in tabs {
            if t.id != cid {
              remaining.push(t)
            }
          }
          if remaining.is_empty() {
            Empty
          } else {
            let next_active = if new_active_idx >= remaining.length() {
              remaining.length() - 1
            } else {
              new_active_idx
            }
            Leaf(remaining, next_active)
          }
        }
        None => Leaf(tabs, new_active_idx)
      }

      // Scoped content panel rendering
      if content_rect.w > 0.0 && content_rect.h > 0.0 {
        let content_painter = ctx.painter().sub_painter(@math.Vec2::zero())
        content_painter.push_clip(content_rect)
        content_painter.add_rect(content_rect, @color.Color::bg_window(), 0.0)

        let active_tab_id = tabs[valid_active].id
        render_tab(ctx, active_tab_id, content_rect)
        content_painter.pop_clip()
      }

      (result_node, tab_switched, closed_tab_id, false)
    }
    Split(direction, ratio, first, second) => {
      let handle_thick = 6.0 * scale
      let mut cur_ratio = ratio
      let mut ratio_changed = false

      let (first_rect, handle_rect, second_rect) = match direction {
        Horizontal => {
          let total_w = rect.w - handle_thick
          let mut w1 = total_w * cur_ratio
          if w1 < min_pane_size {
            w1 = min_pane_size
          }
          if total_w - w1 < min_pane_size {
            w1 = total_w - min_pane_size
          }
          let w2 = total_w - w1

          let r1 = @math.Rect::new(rect.x, rect.y, w1, rect.h)
          let rh = @math.Rect::new(rect.x + w1, rect.y, handle_thick, rect.h)
          let r2 = @math.Rect::new(
            rect.x + w1 + handle_thick,
            rect.y,
            w2,
            rect.h,
          )
          (r1, rh, r2)
        }
        Vertical => {
          let total_h = rect.h - handle_thick
          let mut h1 = total_h * cur_ratio
          if h1 < min_pane_size {
            h1 = min_pane_size
          }
          if total_h - h1 < min_pane_size {
            h1 = total_h - min_pane_size
          }
          let h2 = total_h - h1

          let r1 = @math.Rect::new(rect.x, rect.y, rect.w, h1)
          let rh = @math.Rect::new(rect.x, rect.y + h1, rect.w, handle_thick)
          let r2 = @math.Rect::new(
            rect.x,
            rect.y + h1 + handle_thick,
            rect.w,
            h2,
          )
          (r1, rh, r2)
        }
      }

      // Handle hit-testing and dragging
      let handle_hovered = ctx.is_hovered(handle_rect)
      let handle_id = ctx.id_stack.derive_id(path + "_spl")
      ctx.register_focusable(handle_id)
      let handle_focused = ctx.has_focus(handle_id)

      let cursor_icon = match direction {
        Horizontal => "col-resize"
        Vertical => "row-resize"
      }

      if handle_hovered {
        ctx.set_cursor_icon(cursor_icon)
      }

      if handle_hovered && ctx.input().mouse_pressed {
        ctx.set_active_id(handle_id)
      }

      let is_active = ctx.active_id() == handle_id
      if is_active {
        ctx.set_cursor_icon(cursor_icon)
        if ctx.input().mouse_down {
          match direction {
            Horizontal => {
              let avail = rect.w - handle_thick
              if avail > 0.0 {
                let local_x = ctx.input().mouse_pos().x - rect.x
                let raw_ratio = local_x / avail
                let clamped_ratio = if raw_ratio < 0.05 {
                  0.05
                } else if raw_ratio > 0.95 {
                  0.95
                } else {
                  raw_ratio
                }
                if clamped_ratio != cur_ratio {
                  cur_ratio = clamped_ratio
                  ratio_changed = true
                }
              }
            }
            Vertical => {
              let avail = rect.h - handle_thick
              if avail > 0.0 {
                let local_y = ctx.input().mouse_pos().y - rect.y
                let raw_ratio = local_y / avail
                let clamped_ratio = if raw_ratio < 0.05 {
                  0.05
                } else if raw_ratio > 0.95 {
                  0.95
                } else {
                  raw_ratio
                }
                if clamped_ratio != cur_ratio {
                  cur_ratio = clamped_ratio
                  ratio_changed = true
                }
              }
            }
          }
        }
      }

      // Keyboard resize: Tab-focus the divider and nudge the ratio.
      if handle_focused {
        let kb_step = 0.02
        let grow_key = match direction {
          Horizontal => Key::ArrowRight
          Vertical => Key::ArrowDown
        }
        let shrink_key = match direction {
          Horizontal => Key::ArrowLeft
          Vertical => Key::ArrowUp
        }
        if ctx.input().key_pressed(grow_key) {
          ctx.input().consume_key(grow_key)
          cur_ratio = if cur_ratio + kb_step > 0.95 {
            0.95
          } else {
            cur_ratio + kb_step
          }
          ratio_changed = true
        }
        if ctx.input().key_pressed(shrink_key) {
          ctx.input().consume_key(shrink_key)
          cur_ratio = if cur_ratio - kb_step < 0.05 {
            0.05
          } else {
            cur_ratio - kb_step
          }
          ratio_changed = true
        }
      }

      // Render splitter handle bar
      let painter = ctx.painter()
      let handle_col = if is_active {
        @color.Color::accent_primary()
      } else if handle_hovered {
        @color.Color::accent_hover()
      } else {
        @color.Color::border_muted()
      }
      painter.add_rect(handle_rect, handle_col, 0.0)

      if handle_focused {
        painter.add_rect_stroke(
          handle_rect.expand(1.0),
          @color.Color::border_focus(),
          1.0,
          0.0,
        )
      }

      // Recursively render child panes
      let (new_first, f_switched, f_closed, f_rc) = render_dock_node(
        ctx,
        first,
        first_rect,
        path + "_0",
        render_tab,
      )
      let (new_second, s_switched, s_closed, s_rc) = render_dock_node(
        ctx,
        second,
        second_rect,
        path + "_1",
        render_tab,
      )

      let tab_switched = match f_switched {
        Some(_) => f_switched
        None => s_switched
      }
      let closed_tab = match f_closed {
        Some(_) => f_closed
        None => s_closed
      }

      // Collapse tree if one branch became Empty
      let updated_node = match (new_first, new_second) {
        (Empty, remaining) => remaining
        (remaining, Empty) => remaining
        _ => Split(direction, cur_ratio, new_first, new_second)
      }

      (updated_node, tab_switched, closed_tab, ratio_changed || f_rc || s_rc)
    }
  }
}

///|
/// Core immediate-mode dock area layout primitive.
/// Manages flexible multi-window splits, tabs, and content clipping.
pub fn dock_area(
  ctx : UIContext,
  id_salt : String,
  size : @math.Vec2,
  tree : DockTree,
  render_tab : (UIContext, String, @math.Rect) -> Unit,
) -> DockResponse {
  ctx.id_stack.push(id_salt)
  let (_, rect, resp) = ctx.allocate_space(size)

  // Outer border
  let painter = ctx.painter()
  painter.add_rect_stroke(rect, @color.Color::border_default(), 1.0, 4.0)

  let (new_root, active_tab_changed, tab_closed, ratio_changed) = render_dock_node(
    ctx,
    tree.root,
    rect,
    id_salt,
    render_tab,
  )
  tree.root = new_root

  ctx.id_stack.pop()

  { resp, active_tab_changed, tab_closed, ratio_changed, }
}
