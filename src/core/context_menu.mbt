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
pub struct ContextMenuItem {
  id : String
  label : String
  shortcut : String
  disabled : Bool
  is_separator : Bool
} derive(Eq, Debug)

///|
pub fn ContextMenuItem::new(
  id : String,
  label : String,
  shortcut? : String = "",
  disabled? : Bool = false,
) -> ContextMenuItem {
  { id, label, shortcut, disabled, is_separator: false, }
}

///|
pub fn ContextMenuItem::separator() -> ContextMenuItem {
  { id: "", label: "", shortcut: "", disabled: true, is_separator: true, }
}

///|
pub struct ContextMenuResponse {
  open : Bool
  selected_id : String?
  pos : @math.Vec2
  size : @math.Vec2
} derive(Eq, Debug)

///|
/// Helper to compute collision-aware context menu placement with automatic
/// horizontal and vertical screen boundary flipping.
fn calculate_context_menu_pos(
  anchor : @math.Vec2,
  size : @math.Vec2,
  viewport : @math.Vec2,
) -> @math.Vec2 {
  let mut x = anchor.x + 2.0
  let mut y = anchor.y + 2.0

  // Horizontal collision: if menu exceeds viewport width, flip to the left of anchor
  if x + size.x > viewport.x {
    let flipped_x = anchor.x - size.x - 2.0
    x = if flipped_x >= 4.0 { flipped_x } else { viewport.x - size.x - 4.0 }
  }

  // Ensure left boundary safety
  if x < 4.0 {
    x = 4.0
  }

  // Vertical collision: if menu exceeds viewport height, flip upwards
  if y + size.y > viewport.y {
    let flipped_y = anchor.y - size.y - 2.0
    y = if flipped_y >= 4.0 { flipped_y } else { viewport.y - size.y - 4.0 }
  }

  // Ensure top boundary safety
  if y < 4.0 {
    y = 4.0
  }

  @math.Vec2::new(x, y)
}

///|
/// Render a right-click context menu modal in Studio Light porcelain style.
/// Anchors to the specified pointer position with boundary collision detection,
/// outside-click dismissal, and keyboard Escape cancellation.
pub fn UIContext::context_menu_items(
  self : UIContext,
  id_salt : String,
  open : Bool,
  pos : @math.Vec2,
  items : Array[ContextMenuItem],
  menu_width? : Double = 180.0,
  viewport_size? : @math.Vec2,
) -> ContextMenuResponse {
  let _ = id_salt
  if !open {
    return { open: false, selected_id: None, pos, size: @math.Vec2::zero(), }
  }

  // 1. Calculate menu dimensions
  let item_h = 24.0
  let sep_h = 7.0
  let pad_y = 4.0
  let mut content_h = 0.0

  for item in items {
    if item.is_separator {
      content_h = content_h + sep_h
    } else {
      content_h = content_h + item_h
    }
  }

  let total_w = menu_width
  let total_h = if content_h > 0.0 { content_h + pad_y * 2.0 } else { 32.0 }
  let menu_size = @math.Vec2::new(total_w, total_h)

  // 2. Viewport dimensions and collision flip calculation
  let viewport = match viewport_size {
    Some(vp) => vp
    None => {
      let vw = if self.available_width > 0.0 {
        self.available_width
      } else {
        800.0
      }
      @math.Vec2::new(vw, 600.0)
    }
  }

  let placed_pos = calculate_context_menu_pos(pos, menu_size, viewport)
  let menu_rect = @math.Rect::new(placed_pos.x, placed_pos.y, total_w, total_h)

  // 3. Occlusion and hover blocking
  self.block_hover(menu_rect)

  // 4. Escape dismissal
  if self.input.key_pressed(Key::Escape) {
    return { open: false, selected_id: None, pos: placed_pos, size: menu_size, }
  }

  // 5. Outside click dismissal
  if self.input.mouse_pressed && !menu_rect.contains(self.input.mouse_pos) {
    return { open: false, selected_id: None, pos: placed_pos, size: menu_size, }
  }

  // 6. Item hit-testing
  let mut selected_id : String? = None
  let mut cur_hit_y = placed_pos.y + pad_y

  for item in items {
    if item.is_separator {
      cur_hit_y = cur_hit_y + sep_h
    } else {
      let row_rect = @math.Rect::new(
        placed_pos.x + 4.0,
        cur_hit_y,
        total_w - 8.0,
        item_h,
      )
      let hovered = row_rect.contains(self.input.mouse_pos) && !item.disabled
      if hovered {
        self.set_cursor_icon("pointer")
      }
      if hovered && self.input.mouse_pressed {
        selected_id = Some(item.id)
      }
      cur_hit_y = cur_hit_y + item_h
    }
  }

  if selected_id is Some(id) {
    return {
      open: false,
      selected_id: Some(id),
      pos: placed_pos,
      size: menu_size,
    }
  }

  // 7. Render into foreground layer
  self.begin_foreground()

  // Dual-layer Elevation Shadow
  let menu_radius = self.style.radius_md
  let row_radius = self.style.radius_sm
  let font_nm = self.style.font_normal
  let font_sm = self.style.font_small
  self.draw_list.add_rect(
    @math.Rect::new(placed_pos.x, placed_pos.y + 4.0, total_w, total_h),
    @color.Color::shadow_ambient(),
    menu_radius,
  )
  self.draw_list.add_rect(
    @math.Rect::new(placed_pos.x, placed_pos.y + 1.0, total_w, total_h),
    @color.Color::shadow_key(),
    menu_radius,
  )

  // Porcelain Surface and Crisp Border
  self.draw_list.add_rect(menu_rect, @color.Color::bg_window(), menu_radius)
  self.draw_list.add_rect_stroke(
    menu_rect,
    @color.Color::border_default(),
    1.0,
    menu_radius,
  )

  // Render Items
  let mut cur_draw_y = placed_pos.y + pad_y

  for item in items {
    if item.is_separator {
      let line_y = cur_draw_y + 3.0
      self.draw_list.add_line(
        @math.Vec2::new(placed_pos.x + 8.0, line_y),
        @math.Vec2::new(placed_pos.x + total_w - 8.0, line_y),
        @color.Color::border_muted(),
        1.0,
      )
      cur_draw_y = cur_draw_y + sep_h
    } else {
      let row_rect = @math.Rect::new(
        placed_pos.x + 4.0,
        cur_draw_y,
        total_w - 8.0,
        item_h,
      )
      let hovered = row_rect.contains(self.input.mouse_pos) && !item.disabled

      if hovered {
        self.draw_list.add_rect(
          row_rect,
          @color.Color::bg_surface(),
          row_radius,
        )
      }

      let text_col = if item.disabled {
        @color.Color::text_disabled()
      } else if hovered {
        @color.Color::accent_primary()
      } else {
        @color.Color::text_primary()
      }

      let text_y = cur_draw_y + (item_h - font_nm) * 0.5
      self.draw_list.add_text(
        @math.Vec2::new(placed_pos.x + 12.0, text_y),
        item.label,
        font_nm,
        text_col,
      )

      if !item.shortcut.is_empty() {
        let sc_size = self.measure_text(item.shortcut, font_sm)
        let sc_x = placed_pos.x + total_w - sc_size.x - 12.0
        let sc_col = if item.disabled {
          @color.Color::text_disabled()
        } else if hovered {
          @color.Color::accent_primary()
        } else {
          @color.Color::text_muted()
        }
        self.draw_list.add_text(
          @math.Vec2::new(sc_x, text_y + 1.0),
          item.shortcut,
          font_sm,
          sc_col,
        )
      }

      cur_draw_y = cur_draw_y + item_h
    }
  }

  self.end_foreground()

  { open: true, selected_id: None, pos: placed_pos, size: menu_size, }
}

///|
/// Closure-based ContextMenu for fully custom layout and widget composition.
pub fn UIContext::context_menu(
  self : UIContext,
  id_salt : String,
  open : Bool,
  pos : @math.Vec2,
  content : (UIContext) -> Unit,
  menu_width? : Double = 180.0,
  viewport_size? : @math.Vec2,
) -> ContextMenuResponse {
  let menu_id = self.id_stack.derive_id("context_menu::" + id_salt)
  if !open {
    if self.open_menu_id == menu_id {
      self.set_open_menu_id(Id::zero())
    }
    return { open: false, selected_id: None, pos, size: @math.Vec2::zero(), }
  }

  self.set_open_menu_id(menu_id)

  let pad = 4.0
  let total_w = menu_width

  // Measure content by evaluating in a temporary draw list
  let prev_cursor = self.cursor
  let prev_avail_w = self.available_width
  let prev_spacing = self.item_spacing

  self.cursor = @math.Vec2::new(pad, pad)
  self.available_width = total_w - pad * 2.0
  self.item_spacing = @math.Vec2::new(0.0, 2.0)

  let temp_draw_list = @draw.DrawList::new()
  let saved_dl = self.draw_list
  self.draw_list = temp_draw_list

  self.vertical(content)

  self.draw_list = saved_dl

  let content_h = self.cursor.y - pad
  let total_h = if content_h > 0.0 { content_h + pad * 2.0 } else { 32.0 }
  let menu_size = @math.Vec2::new(total_w, total_h)

  // Viewport and placement
  let viewport = match viewport_size {
    Some(vp) => vp
    None => {
      let vw = if self.available_width > 0.0 {
        self.available_width
      } else {
        800.0
      }
      @math.Vec2::new(vw, 600.0)
    }
  }

  let placed_pos = calculate_context_menu_pos(pos, menu_size, viewport)
  let menu_rect = @math.Rect::new(placed_pos.x, placed_pos.y, total_w, total_h)

  self.block_hover(menu_rect)

  // Escape key dismissal
  if self.input.key_pressed(Key::Escape) {
    self.set_open_menu_id(Id::zero())
    self.cursor = prev_cursor
    self.available_width = prev_avail_w
    self.item_spacing = prev_spacing
    return { open: false, selected_id: None, pos: placed_pos, size: menu_size, }
  }

  // Outside click dismissal
  if self.input.mouse_pressed && !menu_rect.contains(self.input.mouse_pos) {
    self.set_open_menu_id(Id::zero())
    self.cursor = prev_cursor
    self.available_width = prev_avail_w
    self.item_spacing = prev_spacing
    return { open: false, selected_id: None, pos: placed_pos, size: menu_size, }
  }

  // Re-run closure with exact placed coordinates in foreground
  self.begin_foreground()

  // Shadows
  let custom_menu_radius = self.style.radius_md
  self.draw_list.add_rect(
    @math.Rect::new(placed_pos.x, placed_pos.y + 4.0, total_w, total_h),
    @color.Color::shadow_ambient(),
    custom_menu_radius,
  )
  self.draw_list.add_rect(
    @math.Rect::new(placed_pos.x, placed_pos.y + 1.0, total_w, total_h),
    @color.Color::shadow_key(),
    custom_menu_radius,
  )

  // Card
  self.draw_list.add_rect(
    menu_rect,
    @color.Color::bg_window(),
    custom_menu_radius,
  )
  self.draw_list.add_rect_stroke(
    menu_rect,
    @color.Color::border_default(),
    1.0,
    custom_menu_radius,
  )

  self.cursor = @math.Vec2::new(placed_pos.x + pad, placed_pos.y + pad)
  self.available_width = total_w - pad * 2.0
  self.item_spacing = @math.Vec2::new(0.0, 2.0)

  self.vertical(content)

  self.end_foreground()

  self.cursor = prev_cursor
  self.available_width = prev_avail_w
  self.item_spacing = prev_spacing

  let is_still_open = self.open_menu_id == menu_id
  { open: is_still_open, selected_id: None, pos: placed_pos, size: menu_size, }
}
