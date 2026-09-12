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
pub fn UIContext::menu_bar(
  self : UIContext,
  content : (UIContext) -> Unit,
) -> Unit {
  let scale = self.style.scale
  let bar_h = self.style.menu_bar_h * scale
  let bar_w = self.available_width
  let bar_pos = self.cursor
  let bar_rect = @math.Rect::new(bar_pos.x, bar_pos.y, bar_w, bar_h)

  // 1. Menu bar background and subtle bottom divider line
  self.draw_list.add_rect(bar_rect, @color.Color::bg_surface(), 0.0)
  self.draw_list.add_line(
    @math.Vec2::new(bar_rect.x, bar_rect.y + bar_h),
    @math.Vec2::new(bar_rect.x + bar_w, bar_rect.y + bar_h),
    @color.Color::border_muted(),
    1.0,
  )

  // 2. Lay out items horizontally inside the menu bar
  let prev_cursor = self.cursor
  let prev_avail_w = self.available_width
  let prev_spacing = self.item_spacing

  self.cursor = @math.Vec2::new(
    bar_pos.x + 8.0 * scale,
    bar_pos.y + 3.0 * scale,
  )
  self.available_width = bar_w - 16.0 * scale
  self.item_spacing = @math.Vec2::new(4.0 * scale, 0.0)

  // Horizontal layout scope for menu triggers
  self.horizontal(content)

  // Restore cursor below menu bar
  self.cursor = @math.Vec2::new(prev_cursor.x, bar_pos.y + bar_h)
  self.available_width = prev_avail_w
  self.item_spacing = prev_spacing
}

///|
/// Render a top-level menu dropdown trigger (e.g. "文件", "视图").
/// When open, it renders its child menu items on the deferred foreground layer.
pub fn UIContext::menu(
  self : UIContext,
  title : String,
  content : (UIContext) -> Unit,
) -> Unit {
  let scale = self.style.scale
  let font_nm = self.style.font_normal * scale
  let menu_id = self.id_stack.derive_id("menu::" + title)
  let text_size = self.measure_text(title, font_nm)
  let btn_w = text_size.x + 16.0 * scale
  let btn_h = self.style.menu_bar_btn_h * scale

  self.push_id(title)
  let (_id, btn_rect, _) = self.allocate_space(@math.Vec2::new(btn_w, btn_h))
  self.pop_id()

  let is_open = self.open_menu_id == menu_id
  let hovered = self.is_hovered(btn_rect)
  if hovered {
    self.set_cursor_icon("pointer")
  }

  // Desktop Hover-to-Switch interaction:
  // If a menu is ALREADY open, moving the pointer over another menu trigger automatically
  // switches to open that menu!
  if self.open_menu_id != Id::zero() && self.open_menu_id != menu_id && hovered {
    self.set_open_menu_id(menu_id)
  } else if hovered && self.input.mouse_pressed {
    if is_open {
      self.set_open_menu_id(Id::zero())
    } else {
      self.set_open_menu_id(menu_id)
    }
  }

  let currently_open = self.open_menu_id == menu_id

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

  let radius = self.style.menu_bar_radius * scale
  if currently_open || hovered {
    self.draw_list.add_rect(btn_rect, btn_bg, radius)
  }
  self.draw_list.add_text(
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
    self.begin_foreground()

    let pad = 4.0 * scale
    let popup_w = self.style.menu_bar_popup_w * scale
    let mut popup_x = btn_rect.x
    let popup_y = btn_rect.y + btn_rect.h + 3.0 * scale

    // Prevent spilling off-screen to the right if near viewport edge
    if popup_x + popup_w > self.available_width {
      let clamped = self.available_width - popup_w - 4.0 * scale
      if clamped > 4.0 * scale {
        popup_x = clamped
      }
    }

    let prev_cursor = self.cursor
    let prev_avail_w = self.available_width
    let prev_spacing = self.item_spacing

    self.cursor = @math.Vec2::new(popup_x + pad, popup_y + pad)
    self.available_width = popup_w - pad * 2.0
    self.item_spacing = @math.Vec2::new(0.0, 2.0 * scale)

    // Temporary draw list to capture items while determining exact height
    let item_draw_list = @draw.DrawList::new()
    let saved_dl = self.draw_list
    self.draw_list = item_draw_list

    self.vertical(content)

    self.draw_list = saved_dl

    let content_h = self.cursor.y - (popup_y + pad)
    let total_h = if content_h > 0.0 { content_h + pad } else { 24.0 }
    let menu_rect = @math.Rect::new(popup_x, popup_y, popup_w, total_h)

    // Block hover on lower layers
    self.block_hover(menu_rect)

    // Outside click dismiss: if clicked outside both the menu card and trigger button
    if self.input.mouse_pressed && !self.is_hovered(menu_rect) && !hovered {
      self.set_open_menu_id(Id::zero())
    }

    // Elevation shadow
    let shadow_rect = @math.Rect::new(
      menu_rect.x,
      menu_rect.y + 2.0,
      menu_rect.w,
      menu_rect.h,
    )
    let menu_radius = self.style.radius_md
    self.draw_list.add_rect(
      shadow_rect,
      @color.Color::shadow_ambient(),
      menu_radius,
    )

    // Card background and border
    self.draw_list.add_rect(menu_rect, @color.Color::bg_window(), menu_radius)
    self.draw_list.add_rect_stroke(
      menu_rect,
      @color.Color::border_default(),
      1.0,
      menu_radius,
    )

    // Append items on top of background
    self.draw_list.append(item_draw_list)

    // Restore context state
    self.cursor = prev_cursor
    self.available_width = prev_avail_w
    self.item_spacing = prev_spacing

    self.end_foreground()
  }
}

///|
/// Render a single item inside an active menu dropdown.
/// Supports an optional keyboard shortcut (e.g. "⌘N") aligned to the right.
pub fn UIContext::menu_item(
  self : UIContext,
  label : String,
  shortcut? : String = "",
  disabled? : Bool = false,
) -> Response {
  let scale = self.style.scale
  let item_h = 24.0 * scale
  let item_w = self.available_width

  self.push_id(label)
  let (id, rect, resp) = self.allocate_space(@math.Vec2::new(item_w, item_h))
  self.pop_id()

  let is_hovered = self.is_hovered(rect) && !disabled

  let item_radius = self.style.radius_sm * scale
  let font_nm = self.style.font_normal * scale
  let font_sm = self.style.font_small * scale
  if is_hovered {
    self.set_cursor_icon("pointer")
    self.draw_list.add_rect(rect, @color.Color::bg_surface(), item_radius)
  }

  let clicked = if disabled {
    false
  } else {
    is_hovered && (self.input.mouse_pressed || resp.clicked)
  }
  if clicked {
    self.set_open_menu_id(Id::zero())
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
  self.draw_list.add_text(
    @math.Vec2::new(rect.x + 8.0 * scale, text_y),
    label,
    font_nm,
    text_col,
  )

  // Right-aligned shortcut badge
  if !shortcut.is_empty() {
    let sc_size = self.measure_text(shortcut, font_sm)
    let sc_x = rect.x + item_w - sc_size.x - 8.0 * scale
    let sc_y = rect.y + (item_h - font_sm) * 0.5
    let sc_col = if disabled {
      @color.Color::text_disabled()
    } else if is_hovered {
      @color.Color::accent_primary()
    } else {
      @color.Color::text_muted()
    }
    self.draw_list.add_text(
      @math.Vec2::new(sc_x, sc_y),
      shortcut,
      font_sm,
      sc_col,
    )
  }

  Response::new(id, rect, is_hovered, clicked, resp.pressed, false)
}

///|
/// Render a clean divider line between menu item groups.
pub fn UIContext::menu_separator(self : UIContext) -> Unit {
  let sep_h = 7.0
  let item_w = self.available_width
  let (_id, rect, _) = self.allocate_space(@math.Vec2::new(item_w, sep_h))
  let line_y = rect.y + 3.0
  self.draw_list.add_line(
    @math.Vec2::new(rect.x + 4.0, line_y),
    @math.Vec2::new(rect.x + item_w - 4.0, line_y),
    @color.Color::border_muted(),
    1.0,
  )
}
