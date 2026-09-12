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

///|
pub struct ContextMenuItem {
  id : String
  label : String
  shortcut : String
  disabled : Bool
  is_separator : Bool
  children : Array[ContextMenuItem]
} derive(Eq, Debug)

///|
pub fn ContextMenuItem::new(
  id : String,
  label : String,
  shortcut? : String = "",
  disabled? : Bool = false,
  children? : Array[ContextMenuItem] = [],
) -> ContextMenuItem {
  { id, label, shortcut, disabled, is_separator: false, children, }
}

///|
pub fn ContextMenuItem::submenu(
  id : String,
  label : String,
  children : Array[ContextMenuItem],
  disabled? : Bool = false,
) -> ContextMenuItem {
  { id, label, shortcut: "", disabled, is_separator: false, children, }
}

///|
pub fn ContextMenuItem::separator() -> ContextMenuItem {
  {
    id: "",
    label: "",
    shortcut: "",
    disabled: true,
    is_separator: true,
    children: [],
  }
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
fn compute_menu_content_height(
  items : Array[ContextMenuItem],
  item_h : Double,
  sep_h : Double,
  pad_y : Double,
) -> Double {
  let mut h = 0.0
  for item in items {
    if item.is_separator {
      h = h + sep_h
    } else {
      h = h + item_h
    }
  }
  if h > 0.0 {
    h + pad_y * 2.0
  } else {
    32.0
  }
}

///|
/// Render a right-click context menu modal in Studio Light porcelain style.
/// Anchors to the specified pointer position with boundary collision detection,
/// outside-click dismissal, cascading submenus, and keyboard Escape cancellation.
pub fn context_menu_items(
  ctx : UIContext,
  id_salt : String,
  open : Bool,
  pos : @math.Vec2,
  items : Array[ContextMenuItem],
  menu_width? : Double = 180.0,
  viewport_size? : @math.Vec2,
) -> ContextMenuResponse {
  let _ = id_salt
  if !open {
    ctx.set_active_submenu_id("")
    return { open: false, selected_id: None, pos, size: @math.Vec2::zero(), }
  }

  let scale = ctx.style.scale
  let item_h = 24.0 * scale
  let sep_h = 7.0 * scale
  let pad_y = 4.0 * scale

  let total_w = menu_width * scale
  let total_h = compute_menu_content_height(items, item_h, sep_h, pad_y)
  let menu_size = @math.Vec2::new(total_w, total_h)

  // Viewport dimensions and collision flip calculation
  let viewport = match viewport_size {
    Some(vp) => vp
    None => {
      let vw = if ctx.available_width() > 0.0 {
        ctx.available_width()
      } else {
        800.0
      }
      @math.Vec2::new(vw, 600.0)
    }
  }

  let placed_pos = calculate_context_menu_pos(pos, menu_size, viewport)
  let menu_rect = @math.Rect::new(placed_pos.x, placed_pos.y, total_w, total_h)

  // Occlusion and hover blocking
  ctx.block_hover(menu_rect)

  // Escape dismissal
  if ctx.input.key_pressed(Key::Escape) {
    ctx.set_active_submenu_id("")
    return { open: false, selected_id: None, pos: placed_pos, size: menu_size, }
  }

  // Identify hovered item and active submenu. Like every popup that blocks
  // hover over its own area, the interaction phase runs in the foreground
  // scope: is_hovered ignores blockers there, so the menu's own one-frame-old
  // blocker cannot swallow its rows.
  ctx.begin_foreground()
  let mut cur_y = placed_pos.y + pad_y
  let mut active_sub_item : ContextMenuItem? = None
  let mut active_sub_row_y = 0.0
  let mut selected_id : String? = None

  for item in items {
    if item.is_separator {
      cur_y = cur_y + sep_h
    } else {
      let row_rect = @math.Rect::new(
        placed_pos.x + 4.0 * scale,
        cur_y,
        total_w - 8.0 * scale,
        item_h,
      )
      let hovered = ctx.is_hovered(row_rect) && !item.disabled
      if hovered {
        ctx.set_cursor_icon("pointer")
        if item.children.length() > 0 {
          ctx.set_active_submenu_id(item.id)
        } else if ctx.active_submenu_id() != "" &&
          !item.children.is_empty() == false {
          ctx.set_active_submenu_id("")
        }
      }

      if ctx.active_submenu_id() == item.id && item.children.length() > 0 {
        active_sub_item = Some(item)
        active_sub_row_y = cur_y
      }

      if hovered && ctx.input.mouse_pressed && item.children.is_empty() {
        selected_id = Some(item.id)
      }
      cur_y = cur_y + item_h
    }
  }

  // Submenu placement, hover blocking, and hit testing
  let mut sub_rect_opt : @math.Rect? = None
  if active_sub_item is Some(sub_item) {
    let sub_w = total_w
    let sub_h = compute_menu_content_height(
      sub_item.children,
      item_h,
      sep_h,
      pad_y,
    )
    let mut sub_x = placed_pos.x + total_w - 2.0 * scale
    if sub_x + sub_w > viewport.x {
      sub_x = placed_pos.x - sub_w + 2.0 * scale
    }
    if sub_x < 4.0 {
      sub_x = 4.0
    }
    let mut sub_y = active_sub_row_y - pad_y
    if sub_y + sub_h > viewport.y {
      sub_y = viewport.y - sub_h - 4.0
    }
    if sub_y < 4.0 {
      sub_y = 4.0
    }
    let sub_rect = @math.Rect::new(sub_x, sub_y, sub_w, sub_h)
    sub_rect_opt = Some(sub_rect)
    ctx.block_hover(sub_rect)

    // Submenu item hit-testing
    let mut sub_cur_y = sub_y + pad_y
    for child in sub_item.children {
      if child.is_separator {
        sub_cur_y = sub_cur_y + sep_h
      } else {
        let child_row = @math.Rect::new(
          sub_x + 4.0 * scale,
          sub_cur_y,
          sub_w - 8.0 * scale,
          item_h,
        )
        let child_hovered = ctx.is_hovered(child_row) && !child.disabled
        if child_hovered {
          ctx.set_cursor_icon("pointer")
          if ctx.input.mouse_pressed {
            selected_id = Some(child.id)
          }
        }
        sub_cur_y = sub_cur_y + item_h
      }
    }
  }

  // Outside click dismissal
  if ctx.input.mouse_pressed {
    let in_main = menu_rect.contains(ctx.input.mouse_pos)
    let in_sub = match sub_rect_opt {
      Some(sr) => sr.contains(ctx.input.mouse_pos)
      None => false
    }
    if !in_main && !in_sub {
      ctx.set_active_submenu_id("")
      ctx.end_foreground()
      return {
        open: false,
        selected_id: None,
        pos: placed_pos,
        size: menu_size,
      }
    }
  }

  if selected_id is Some(id) {
    ctx.set_active_submenu_id("")
    ctx.end_foreground()
    return {
      open: false,
      selected_id: Some(id),
      pos: placed_pos,
      size: menu_size,
    }
  }

  ctx.end_foreground()

  // Render into foreground layer
  ctx.begin_foreground()

  let menu_radius = ctx.style.radius_md * scale
  let row_radius = ctx.style.radius_sm * scale
  let font_nm = ctx.style.font_normal * scale
  let font_sm = ctx.style.font_small * scale

  // 1. Dual-layer Elevation Shadow for main menu
  ctx
  .painter()
  .add_rect(
    @math.Rect::new(placed_pos.x, placed_pos.y + 4.0 * scale, total_w, total_h),
    @color.Color::shadow_ambient(),
    menu_radius,
  )
  ctx
  .painter()
  .add_rect(
    @math.Rect::new(placed_pos.x, placed_pos.y + 1.0 * scale, total_w, total_h),
    @color.Color::shadow_key(),
    menu_radius,
  )

  // Porcelain Surface and Crisp Border
  ctx.painter().add_rect(menu_rect, @color.Color::bg_window(), menu_radius)
  ctx
  .painter()
  .add_rect_stroke(menu_rect, @color.Color::border_default(), 1.0, menu_radius)

  // Render main menu items
  let mut cur_draw_y = placed_pos.y + pad_y
  for item in items {
    if item.is_separator {
      let line_y = cur_draw_y + 3.0 * scale
      ctx
      .painter()
      .add_line(
        @math.Vec2::new(placed_pos.x + 8.0 * scale, line_y),
        @math.Vec2::new(placed_pos.x + total_w - 8.0 * scale, line_y),
        @color.Color::border_muted(),
        1.0,
      )
      cur_draw_y = cur_draw_y + sep_h
    } else {
      let row_rect = @math.Rect::new(
        placed_pos.x + 4.0 * scale,
        cur_draw_y,
        total_w - 8.0 * scale,
        item_h,
      )
      let hovered = (
          ctx.is_hovered(row_rect) || ctx.active_submenu_id() == item.id
        ) &&
        !item.disabled

      if hovered {
        ctx.painter().add_rect(row_rect, @color.Color::bg_surface(), row_radius)
      }

      let text_col = if item.disabled {
        @color.Color::text_disabled()
      } else if hovered {
        @color.Color::accent_primary()
      } else {
        @color.Color::text_primary()
      }

      let text_y = cur_draw_y + (item_h - font_nm) * 0.5
      ctx
      .painter()
      .add_text(
        @math.Vec2::new(placed_pos.x + 12.0 * scale, text_y),
        item.label,
        font_nm,
        text_col,
      )

      if item.children.length() > 0 {
        // Render cascading chevron indicator
        let chev_col = if hovered {
          @color.Color::accent_primary()
        } else {
          @color.Color::text_muted()
        }
        ctx
        .painter()
        .add_text(
          @math.Vec2::new(placed_pos.x + total_w - 18.0 * scale, text_y),
          ">",
          font_sm,
          chev_col,
        )
      } else if !item.shortcut.is_empty() {
        let sc_size = ctx.measure_text(item.shortcut, font_sm)
        let sc_x = placed_pos.x + total_w - sc_size.x - 12.0 * scale
        let sc_col = if item.disabled {
          @color.Color::text_disabled()
        } else if hovered {
          @color.Color::accent_primary()
        } else {
          @color.Color::text_muted()
        }
        ctx
        .painter()
        .add_text(
          @math.Vec2::new(sc_x, text_y + 1.0 * scale),
          item.shortcut,
          font_sm,
          sc_col,
        )
      }

      cur_draw_y = cur_draw_y + item_h
    }
  }

  // 2. Render cascading Submenu if active
  if active_sub_item is Some(sub_item) && sub_rect_opt is Some(sub_rect) {
    ctx
    .painter()
    .add_rect(
      @math.Rect::new(
        sub_rect.x,
        sub_rect.y + 4.0 * scale,
        sub_rect.w,
        sub_rect.h,
      ),
      @color.Color::shadow_ambient(),
      menu_radius,
    )
    ctx
    .painter()
    .add_rect(
      @math.Rect::new(
        sub_rect.x,
        sub_rect.y + 1.0 * scale,
        sub_rect.w,
        sub_rect.h,
      ),
      @color.Color::shadow_key(),
      menu_radius,
    )
    ctx.painter().add_rect(sub_rect, @color.Color::bg_window(), menu_radius)
    ctx
    .painter()
    .add_rect_stroke(sub_rect, @color.Color::border_default(), 1.0, menu_radius)

    let mut sub_draw_y = sub_rect.y + pad_y
    for child in sub_item.children {
      if child.is_separator {
        let line_y = sub_draw_y + 3.0 * scale
        ctx
        .painter()
        .add_line(
          @math.Vec2::new(sub_rect.x + 8.0 * scale, line_y),
          @math.Vec2::new(sub_rect.x + sub_rect.w - 8.0 * scale, line_y),
          @color.Color::border_muted(),
          1.0,
        )
        sub_draw_y = sub_draw_y + sep_h
      } else {
        let child_row = @math.Rect::new(
          sub_rect.x + 4.0 * scale,
          sub_draw_y,
          sub_rect.w - 8.0 * scale,
          item_h,
        )
        let child_hovered = ctx.is_hovered(child_row) && !child.disabled
        if child_hovered {
          ctx
          .painter()
          .add_rect(child_row, @color.Color::bg_surface(), row_radius)
        }

        let text_col = if child.disabled {
          @color.Color::text_disabled()
        } else if child_hovered {
          @color.Color::accent_primary()
        } else {
          @color.Color::text_primary()
        }

        let text_y = sub_draw_y + (item_h - font_nm) * 0.5
        ctx
        .painter()
        .add_text(
          @math.Vec2::new(sub_rect.x + 12.0 * scale, text_y),
          child.label,
          font_nm,
          text_col,
        )

        if !child.shortcut.is_empty() {
          let sc_size = ctx.measure_text(child.shortcut, font_sm)
          let sc_x = sub_rect.x + sub_rect.w - sc_size.x - 12.0 * scale
          let sc_col = if child.disabled {
            @color.Color::text_disabled()
          } else if child_hovered {
            @color.Color::accent_primary()
          } else {
            @color.Color::text_muted()
          }
          ctx
          .painter()
          .add_text(
            @math.Vec2::new(sc_x, text_y + 1.0 * scale),
            child.shortcut,
            font_sm,
            sc_col,
          )
        }

        sub_draw_y = sub_draw_y + item_h
      }
    }
  }

  ctx.end_foreground()

  { open: true, selected_id: None, pos: placed_pos, size: menu_size, }
}

///|
/// Closure-based ContextMenu for fully custom layout and widget composition.
pub fn context_menu(
  ctx : UIContext,
  id_salt : String,
  open : Bool,
  pos : @math.Vec2,
  content : (UIContext) -> Unit,
  menu_width? : Double = 180.0,
  viewport_size? : @math.Vec2,
) -> ContextMenuResponse {
  let menu_id = ctx.id_stack.derive_id("context_menu::" + id_salt)
  if !open {
    if ctx.open_menu_id == menu_id {
      ctx.set_open_menu_id(Id::zero())
    }
    return { open: false, selected_id: None, pos, size: @math.Vec2::zero(), }
  }

  ctx.set_open_menu_id(menu_id)

  let pad = 4.0
  let total_w = menu_width

  // Measure content by evaluating in a temporary draw list
  let prev_cursor = ctx.cursor()
  let prev_avail_w = ctx.available_width()
  let prev_spacing = ctx.item_spacing()

  ctx.set_cursor(@math.Vec2::new(pad, pad))
  ctx.set_available_width(total_w - pad * 2.0)
  ctx.set_item_spacing(@math.Vec2::new(0.0, 2.0))

  let temp_draw_list = @draw.DrawList::new()
  let saved_dl = ctx.layers.draw_list()
  ctx.layers.set_draw_list(temp_draw_list)

  ctx.vertical(content)

  ctx.layers.set_draw_list(saved_dl)

  let content_h = ctx.cursor().y - pad
  let total_h = if content_h > 0.0 { content_h + pad * 2.0 } else { 32.0 }
  let menu_size = @math.Vec2::new(total_w, total_h)

  // Viewport and placement
  let viewport = match viewport_size {
    Some(vp) => vp
    None => {
      let vw = if ctx.available_width() > 0.0 {
        ctx.available_width()
      } else {
        800.0
      }
      @math.Vec2::new(vw, 600.0)
    }
  }

  let placed_pos = calculate_context_menu_pos(pos, menu_size, viewport)
  let menu_rect = @math.Rect::new(placed_pos.x, placed_pos.y, total_w, total_h)

  ctx.block_hover(menu_rect)

  // Escape key dismissal
  if ctx.input.key_pressed(Key::Escape) {
    ctx.set_open_menu_id(Id::zero())
    ctx.set_cursor(prev_cursor)
    ctx.set_available_width(prev_avail_w)
    ctx.set_item_spacing(prev_spacing)
    return { open: false, selected_id: None, pos: placed_pos, size: menu_size, }
  }

  // Outside click dismissal
  if ctx.input.mouse_pressed && !menu_rect.contains(ctx.input.mouse_pos) {
    ctx.set_open_menu_id(Id::zero())
    ctx.set_cursor(prev_cursor)
    ctx.set_available_width(prev_avail_w)
    ctx.set_item_spacing(prev_spacing)
    return { open: false, selected_id: None, pos: placed_pos, size: menu_size, }
  }

  // Re-run closure with exact placed coordinates in foreground
  ctx.begin_foreground()

  // Shadows
  let custom_menu_radius = ctx.style.radius_md
  ctx
  .painter()
  .add_rect(
    @math.Rect::new(placed_pos.x, placed_pos.y + 4.0, total_w, total_h),
    @color.Color::shadow_ambient(),
    custom_menu_radius,
  )
  ctx
  .painter()
  .add_rect(
    @math.Rect::new(placed_pos.x, placed_pos.y + 1.0, total_w, total_h),
    @color.Color::shadow_key(),
    custom_menu_radius,
  )

  // Card
  ctx
  .painter()
  .add_rect(menu_rect, @color.Color::bg_window(), custom_menu_radius)
  ctx
  .painter()
  .add_rect_stroke(
    menu_rect,
    @color.Color::border_default(),
    1.0,
    custom_menu_radius,
  )

  ctx.set_cursor(@math.Vec2::new(placed_pos.x + pad, placed_pos.y + pad))
  ctx.set_available_width(total_w - pad * 2.0)
  ctx.set_item_spacing(@math.Vec2::new(0.0, 2.0))

  ctx.vertical(content)

  ctx.end_foreground()

  ctx.set_cursor(prev_cursor)
  ctx.set_available_width(prev_avail_w)
  ctx.set_item_spacing(prev_spacing)

  let is_still_open = ctx.open_menu_id() == menu_id
  { open: is_still_open, selected_id: None, pos: placed_pos, size: menu_size, }
}
