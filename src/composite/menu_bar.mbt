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
/// Render a top-level horizontal application menu bar in Studio Light style.
/// Spans the available width with a standard 28.0px height.
pub fn menu_bar(ctx : UIContext, content : (UIContext) -> Unit) -> Unit {
  let scale = ctx.style.scale
  let bar_h = (ctx.style.control_h_sm + ctx.style.spacing_xs) * scale
  let bar_w = ctx.available_width()
  let bar_pos = ctx.cursor()
  let bar_rect = @math.Rect::new(bar_pos.x, bar_pos.y, bar_w, bar_h)

  // 1. Menu bar background and subtle bottom divider line
  ctx.painter().add_rect(bar_rect, @color.Color::bg_surface(), 0.0)
  ctx
  .painter()
  .add_line(
    @math.Vec2::new(bar_rect.x, bar_rect.y + bar_h),
    @math.Vec2::new(bar_rect.x + bar_w, bar_rect.y + bar_h),
    @color.Color::border_muted(),
    1.0,
  )

  // 2. Lay out items horizontally inside the menu bar
  let prev_cursor = ctx.cursor()
  let prev_avail_w = ctx.available_width()
  let prev_spacing = ctx.item_spacing()

  ctx.set_cursor(
    @math.Vec2::new(bar_pos.x + 8.0 * scale, bar_pos.y + 3.0 * scale),
  )
  ctx.set_available_width(bar_w - 16.0 * scale)
  ctx.set_item_spacing(@math.Vec2::new(4.0 * scale, 0.0))

  // Horizontal layout scope for menu triggers
  ctx.horizontal(content)

  // Restore cursor below menu bar
  ctx.set_cursor(@math.Vec2::new(prev_cursor.x, bar_pos.y + bar_h))
  ctx.set_available_width(prev_avail_w)
  ctx.set_item_spacing(prev_spacing)
}

///|
/// Render a top-level menu dropdown trigger (e.g. "文件", "视图").
/// When open, it renders its child menu items on the deferred foreground layer.
pub fn menu(
  ctx : UIContext,
  title : String,
  content : (UIContext) -> Unit,
) -> Unit {
  let scale = ctx.style.scale
  let font_nm = ctx.style.font_normal * scale
  let menu_id = ctx.id_stack.derive_id("menu::" + title)
  let text_size = ctx.measure_text(title, font_nm)
  let btn_w = text_size.x + 16.0 * scale
  let btn_h = (ctx.style.control_h_sm - ctx.style.radius_xs) * scale

  ctx.push_id(title)
  let (id, btn_rect, _) = ctx.allocate_space(@math.Vec2::new(btn_w, btn_h))
  ctx.pop_id()
  ctx.register_focusable(id)
  let is_focused = ctx.has_focus(id)

  let is_open = ctx.open_menu_id() == menu_id
  let hovered = ctx.is_hovered(btn_rect)
  if hovered {
    ctx.set_cursor_icon("pointer")
  }

  // Keyboard: Enter / Space / ArrowDown toggles the dropdown while the
  // trigger holds focus; Escape closes it.
  let key_toggle = is_focused &&
    (
      ctx.input.key_pressed(Key::Enter) ||
      ctx.input.key_pressed(Key::Space) ||
      ctx.input.key_pressed(Key::ArrowDown)
    )
  if key_toggle {
    ctx.input.consume_key(Key::Enter)
    ctx.input.consume_key(Key::Space)
    ctx.input.consume_key(Key::ArrowDown)
    if is_open {
      ctx.set_open_menu_id(Id::zero())
    } else {
      ctx.set_open_menu_id(menu_id)
    }
  }

  // Desktop Hover-to-Switch interaction:
  // If a menu is ALREADY open, moving the pointer over another menu trigger automatically
  // switches to open that menu!
  if ctx.open_menu_id() != Id::zero() &&
    ctx.open_menu_id() != menu_id &&
    hovered {
    ctx.set_open_menu_id(menu_id)
  } else if hovered && ctx.input.mouse_pressed {
    if is_open {
      ctx.set_open_menu_id(Id::zero())
    } else {
      ctx.set_open_menu_id(menu_id)
    }
  }

  let currently_open = ctx.open_menu_id() == menu_id

  // Escape closes the open dropdown
  if currently_open && ctx.input.key_pressed(Key::Escape) {
    ctx.input.consume_key(Key::Escape)
    ctx.set_open_menu_id(Id::zero())
  }

  // Render the menu bar trigger button
  let btn_bg = if currently_open {
    @color.Color::bg_active()
  } else if hovered {
    @color.Color::bg_subtle()
  } else {
    @color.Color::transparent()
  }
  let btn_text_col = if currently_open {
    @color.Color::accent_primary()
  } else if hovered {
    @color.Color::text_primary()
  } else {
    @color.Color::text_body()
  }

  let radius = ctx.style.radius_sm * scale
  if currently_open || hovered {
    ctx.painter().add_rect(btn_rect, btn_bg, radius)
  }
  if is_focused {
    ctx
    .painter()
    .add_rect_stroke(btn_rect, @color.Color::border_focus(), 1.0, radius)
  }
  ctx
  .painter()
  .add_text(
    @math.Vec2::new(
      btn_rect.x + 8.0 * scale,
      btn_rect.y + (btn_h - font_nm) * 0.5,
    ),
    title,
    font_nm,
    btn_text_col,
  )

  // If this menu is open, render the dropdown menu panel
  if currently_open {
    ctx.begin_foreground()

    let pad = 4.0 * scale
    let popup_w = 170.0 * scale
    let mut popup_x = btn_rect.x
    let popup_y = btn_rect.y + btn_rect.h + 3.0 * scale

    // Prevent spilling off-screen to the right if near viewport edge
    if popup_x + popup_w > ctx.available_width() {
      let clamped = ctx.available_width() - popup_w - 4.0 * scale
      if clamped > 4.0 * scale {
        popup_x = clamped
      }
    }

    let prev_cursor = ctx.cursor()
    let prev_avail_w = ctx.available_width()
    let prev_spacing = ctx.item_spacing()

    ctx.set_cursor(@math.Vec2::new(popup_x + pad, popup_y + pad))
    ctx.set_available_width(popup_w - pad * 2.0)
    ctx.set_item_spacing(@math.Vec2::new(0.0, 2.0 * scale))

    // Temporary draw list to capture items while determining exact height
    let item_draw_list = @draw.DrawList::new()
    let saved_dl = ctx.layers.draw_list()
    ctx.layers.set_draw_list(item_draw_list)

    ctx.vertical(content)

    ctx.layers.set_draw_list(saved_dl)

    let content_h = ctx.cursor().y - (popup_y + pad)
    let total_h = if content_h > 0.0 { content_h + pad } else { 24.0 }
    let menu_rect = @math.Rect::new(popup_x, popup_y, popup_w, total_h)

    // Block hover on lower layers
    ctx.block_hover(menu_rect)

    // Outside click dismiss: if clicked outside both the menu card and trigger button
    if ctx.input.mouse_pressed && !ctx.is_hovered(menu_rect) && !hovered {
      ctx.set_open_menu_id(Id::zero())
    }

    // Elevation shadow
    let shadow_rect = @math.Rect::new(
      menu_rect.x,
      menu_rect.y + 2.0,
      menu_rect.w,
      menu_rect.h,
    )
    let menu_radius = ctx.style.radius_md
    ctx
    .painter()
    .add_rect(shadow_rect, @color.Color::shadow_ambient(), menu_radius)

    // Card background and border
    ctx.painter().add_rect(menu_rect, @color.Color::bg_window(), menu_radius)
    ctx
    .painter()
    .add_rect_stroke(
      menu_rect,
      @color.Color::border_default(),
      1.0,
      menu_radius,
    )

    // Append items on top of background
    ctx.painter().append(item_draw_list)

    // Restore context state
    ctx.set_cursor(prev_cursor)
    ctx.set_available_width(prev_avail_w)
    ctx.set_item_spacing(prev_spacing)

    ctx.end_foreground()
  }
}

///|
/// Render a single item inside an active menu dropdown.
/// Supports an optional keyboard shortcut (e.g. "⌘N") aligned to the right.
pub fn menu_item(
  ctx : UIContext,
  label : String,
  shortcut? : String = "",
  disabled? : Bool = false,
) -> Response {
  let scale = ctx.style.scale
  let item_h = 24.0 * scale
  let item_w = ctx.available_width()

  ctx.push_id(label)
  let (id, rect, resp) = ctx.allocate_space(@math.Vec2::new(item_w, item_h))
  ctx.pop_id()
  ctx.register_focusable(id)
  let is_focused = resp.has_focus() || ctx.has_focus(id)

  let is_hovered = ctx.is_hovered(rect) && !disabled

  let item_radius = ctx.style.radius_sm * scale
  let font_nm = ctx.style.font_normal * scale
  let font_sm = ctx.style.font_small * scale
  if is_hovered {
    ctx.set_cursor_icon("pointer")
    ctx.painter().add_rect(rect, @color.Color::bg_surface(), item_radius)
  }
  if is_focused {
    ctx
    .painter()
    .add_rect_stroke(rect, @color.Color::border_focus(), 1.0, item_radius)
  }

  let key_activate = is_focused &&
    !disabled &&
    (ctx.input.key_pressed(Key::Space) || ctx.input.key_pressed(Key::Enter))
  if key_activate {
    ctx.input.consume_key(Key::Space)
    ctx.input.consume_key(Key::Enter)
  }

  let clicked = if disabled {
    false
  } else {
    (is_hovered && (ctx.input.mouse_pressed || resp.clicked)) || key_activate
  }
  if clicked {
    ctx.set_open_menu_id(Id::zero())
  }

  let text_col = if disabled {
    @color.Color::text_disabled()
  } else if is_hovered {
    @color.Color::accent_primary()
  } else {
    @color.Color::text_primary()
  }

  // Left-aligned label
  let text_y = rect.y + (item_h - font_nm) * 0.5
  ctx
  .painter()
  .add_text(
    @math.Vec2::new(rect.x + 8.0 * scale, text_y),
    label,
    font_nm,
    text_col,
  )

  // Right-aligned shortcut badge
  if !shortcut.is_empty() {
    let sc_size = ctx.measure_text(shortcut, font_sm)
    let sc_x = rect.x + item_w - sc_size.x - 8.0 * scale
    let sc_y = rect.y + (item_h - font_sm) * 0.5
    let sc_col = if disabled {
      @color.Color::text_disabled()
    } else if is_hovered {
      @color.Color::accent_primary()
    } else {
      @color.Color::text_muted()
    }
    ctx
    .painter()
    .add_text(@math.Vec2::new(sc_x, sc_y), shortcut, font_sm, sc_col)
  }

  Response::new(id, rect, is_hovered, clicked, resp.pressed, false)
}

///|
/// Render a clean divider line between menu item groups.
pub fn menu_separator(ctx : UIContext) -> Unit {
  let sep_h = 7.0
  let item_w = ctx.available_width()
  let (_id, rect, _) = ctx.allocate_space(@math.Vec2::new(item_w, sep_h))
  let line_y = rect.y + 3.0
  ctx
  .painter()
  .add_line(
    @math.Vec2::new(rect.x + 4.0, line_y),
    @math.Vec2::new(rect.x + item_w - 4.0, line_y),
    @color.Color::border_muted(),
    1.0,
  )
}
