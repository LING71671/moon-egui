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
/// Standalone collapsible header container supporting fluent configuration.
pub struct CollapsingHeader {
  id_salt : String
  title : String
  default_open : Bool
} derive(Eq, Debug)

///|
/// Create a new collapsing header container.
pub fn CollapsingHeader::new(
  id_salt : String,
  title : String,
) -> CollapsingHeader {
  { id_salt, title, default_open: false, }
}

///|
/// Configure default open state on initial display.
pub fn CollapsingHeader::default_open(
  self : CollapsingHeader,
  default_open : Bool,
) -> CollapsingHeader {
  { ..self, default_open, }
}

///|
/// Show the collapsible header and execute content closure if expanded.
pub fn CollapsingHeader::show(
  self : CollapsingHeader,
  ctx : UIContext,
  content : (UIContext) -> Unit,
) -> Response {
  collapsing_header(ctx, self.id_salt, self.title, self.default_open, content)
}

///|
/// Render a collapsible section header with expand/collapse arrow indicator and nested content.
pub fn collapsing_header(
  ctx : UIContext,
  id_salt : String,
  title : String,
  default_open : Bool,
  content : (UIContext) -> Unit,
) -> Response {
  let header_id = ctx.id_stack.derive_id(id_salt)
  let scale = ctx.style.scale
  let w = ctx.available_width()
  let h = (ctx.style.control_h_sm + ctx.style.radius_xs) * scale

  ctx.push_id(id_salt)
  let (id, rect, resp) = ctx.allocate_space(@math.Vec2::new(w, h))
  ctx.pop_id()
  ctx.register_focusable(id)

  let is_focused = resp.has_focus() || ctx.has_focus(id)
  let mut is_open = ctx.is_collapsing_open(header_id, default_open)
  let key_toggle = is_focused &&
    (ctx.input.key_pressed(Key::Space) || ctx.input.key_pressed(Key::Enter))
  if key_toggle {
    ctx.input.consume_key(Key::Space)
    ctx.input.consume_key(Key::Enter)
  }

  if resp.clicked() || key_toggle {
    is_open = !is_open
    ctx.set_collapsing_open(header_id, is_open)
  }

  if resp.hovered() {
    ctx.set_cursor_icon("pointer")
  }
  let bg_color = if resp.hovered() {
    @color.Color::bg_surface()
  } else {
    @color.Color::bg_subtle()
  }
  let border_color = if is_focused {
    @color.Color::border_focus()
  } else if resp.hovered() {
    @color.Color::border_default()
  } else {
    @color.Color::border_muted()
  }
  let header_radius = ctx.style.radius_sm * scale
  ctx.painter().add_rect(rect, bg_color, header_radius)
  ctx.painter().add_rect_stroke(rect, border_color, 1.0, header_radius)
  if is_focused {
    ctx
    .painter()
    .add_rect_stroke(
      rect.expand(2.0 * scale),
      @color.Color::border_focus(),
      1.5,
      header_radius + 2.0 * scale,
    )
  }

  let arrow_color = if is_open {
    @color.Color::accent_primary()
  } else {
    @color.Color::text_muted()
  }
  let arrow_cx = rect.x + 12.0
  let arrow_cy = rect.y + h * 0.5
  if is_open {
    let p1 = @math.Vec2::new(arrow_cx - 3.5, arrow_cy - 1.5)
    let p2 = @math.Vec2::new(arrow_cx, arrow_cy + 2.0)
    let p3 = @math.Vec2::new(arrow_cx + 3.5, arrow_cy - 1.5)
    ctx.painter().add_line(p1, p2, arrow_color, 1.5)
    ctx.painter().add_line(p2, p3, arrow_color, 1.5)
  } else {
    let p1 = @math.Vec2::new(arrow_cx - 1.5, arrow_cy - 3.5)
    let p2 = @math.Vec2::new(arrow_cx + 2.0, arrow_cy)
    let p3 = @math.Vec2::new(arrow_cx - 1.5, arrow_cy + 3.5)
    ctx.painter().add_line(p1, p2, arrow_color, 1.5)
    ctx.painter().add_line(p2, p3, arrow_color, 1.5)
  }

  let font_sz = ctx.style.font_normal * scale
  let title_x = rect.x + 24.0 * scale
  let title_y = rect.y + (rect.h - font_sz) * 0.5
  let text_color = if is_open {
    @color.Color::text_strong()
  } else if resp.hovered() {
    @color.Color::text_primary()
  } else {
    @color.Color::text_body()
  }
  ctx
  .painter()
  .add_text(@math.Vec2::new(title_x, title_y), title, font_sz, text_color)

  if is_open {
    let prev_cursor = ctx.cursor()
    let prev_avail_w = ctx.available_width()
    let indent = ctx.style.spacing_lg * scale

    ctx.set_cursor(@math.Vec2::new(prev_cursor.x + indent, prev_cursor.y))
    ctx.set_available_width(prev_avail_w - indent)

    content(ctx)

    let final_y = ctx.cursor().y
    ctx.set_cursor(@math.Vec2::new(prev_cursor.x, final_y))
    ctx.set_available_width(prev_avail_w)
  }

  resp
}

///|
/// Standalone dropdown selection menu supporting fluent configuration.
pub struct ComboBox {
  id_salt : String
  label : String
  selected_index : Int
  options : Array[String]
} derive(Eq, Debug)

///|
/// Create a new combo box widget.
pub fn ComboBox::new(
  id_salt : String,
  selected_index : Int,
  options : Array[String],
) -> ComboBox {
  { id_salt, label: "", selected_index, options, }
}

///|
/// Configure label for combo box.
pub fn ComboBox::label(self : ComboBox, label : String) -> ComboBox {
  { ..self, label, }
}

///|
/// Show the combo box and return (new_selected_index, response).
pub fn ComboBox::show(self : ComboBox, ctx : UIContext) -> (Int, Response) {
  combo_box(ctx, self.id_salt, self.label, self.selected_index, self.options)
}

///|
/// Render a dropdown selection menu in Studio Light.
/// Returns a tuple of (new_selected_index, response).
pub fn combo_box(
  ctx : UIContext,
  id_salt : String,
  label : String,
  selected_index : Int,
  options : Array[String],
) -> (Int, Response) {
  let combo_id = ctx.id_stack.derive_id(id_salt)
  let scale = ctx.style.scale
  let combo_font_sz = ctx.style.font_normal * scale
  let label_size = if !label.is_empty() {
    ctx.measure_text(label, combo_font_sz).x + 8.0 * scale
  } else {
    0.0
  }
  let box_w = 140.0 * scale
  let total_w = label_size + box_w
  let h = (ctx.style.control_h_sm + ctx.style.spacing_xs) * scale

  ctx.push_id(id_salt)
  let (id, rect, resp) = ctx.allocate_space(@math.Vec2::new(total_w, h))
  ctx.pop_id()
  ctx.register_focusable(id)

  let box_rect = @math.Rect::new(rect.x + label_size, rect.y, box_w, h)
  let box_hovered = ctx.is_hovered(box_rect)
  if box_hovered {
    ctx.set_cursor_icon("pointer")
  }

  let mut current_idx = selected_index
  let is_open = ctx.open_combo_id() == combo_id
  let is_focused = resp.has_focus() || ctx.has_focus(id)

  let key_toggle = is_focused &&
    (ctx.input.key_pressed(Key::Space) || ctx.input.key_pressed(Key::Enter))
  if key_toggle {
    ctx.input.consume_key(Key::Space)
    ctx.input.consume_key(Key::Enter)
  }

  if (box_hovered && ctx.input.mouse_pressed()) || key_toggle {
    if is_open {
      ctx.set_open_combo_id(@core.Id::zero())
    } else {
      ctx.set_open_combo_id(combo_id)
    }
  }

  if is_open {
    if ctx.input.key_pressed(Key::Escape) {
      ctx.set_open_combo_id(@core.Id::zero())
      ctx.input.consume_key(Key::Escape)
    }
    if ctx.input.key_pressed(Key::ArrowDown) {
      if current_idx < options.length() - 1 {
        current_idx = current_idx + 1
      }
      ctx.input.consume_key(Key::ArrowDown)
    }
    if ctx.input.key_pressed(Key::ArrowUp) {
      if current_idx > 0 {
        current_idx = current_idx - 1
      }
      ctx.input.consume_key(Key::ArrowUp)
    }
    if ctx.input.key_pressed(Key::Enter) {
      ctx.set_open_combo_id(@core.Id::zero())
      ctx.input.consume_key(Key::Enter)
    }
  }

  if !label.is_empty() {
    let label_y = rect.y + (h - combo_font_sz) * 0.5
    ctx
    .painter()
    .add_text(
      @math.Vec2::new(rect.x, label_y),
      label,
      combo_font_sz,
      @color.Color::text_primary(),
    )
  }

  let bg_color = if box_hovered || is_open {
    @color.Color::bg_subtle()
  } else {
    @color.Color::bg_window()
  }
  let border_color = if is_focused || is_open {
    @color.Color::border_focus()
  } else if box_hovered {
    @color.Color::accent_primary()
  } else {
    @color.Color::border_default()
  }

  let box_radius = ctx.style.radius_sm
  ctx.painter().add_rect(box_rect, bg_color, box_radius)
  let stroke_w = if is_focused || is_open { 1.5 } else { 1.0 }
  ctx.painter().add_rect_stroke(box_rect, border_color, stroke_w, box_radius)

  let selected_str = if current_idx >= 0 && current_idx < options.length() {
    options[current_idx]
  } else {
    ""
  }
  let text_y = box_rect.y + (h - combo_font_sz) * 0.5
  ctx
  .painter()
  .add_text(
    @math.Vec2::new(box_rect.x + 8.0, text_y),
    selected_str,
    combo_font_sz,
    @color.Color::text_primary(),
  )

  let chevron_cx = box_rect.x + box_w - 14.0
  let chevron_cy = box_rect.y + h * 0.5
  let chevron_col = if is_open {
    @color.Color::accent_primary()
  } else if box_hovered {
    @color.Color::text_primary()
  } else {
    @color.Color::text_muted()
  }
  if is_open {
    let p1 = @math.Vec2::new(chevron_cx - 3.5, chevron_cy + 1.5)
    let p2 = @math.Vec2::new(chevron_cx, chevron_cy - 2.0)
    let p3 = @math.Vec2::new(chevron_cx + 3.5, chevron_cy + 1.5)
    ctx.painter().add_line(p1, p2, chevron_col, 1.5)
    ctx.painter().add_line(p2, p3, chevron_col, 1.5)
  } else {
    let p1 = @math.Vec2::new(chevron_cx - 3.5, chevron_cy - 1.5)
    let p2 = @math.Vec2::new(chevron_cx, chevron_cy + 2.0)
    let p3 = @math.Vec2::new(chevron_cx + 3.5, chevron_cy - 1.5)
    ctx.painter().add_line(p1, p2, chevron_col, 1.5)
    ctx.painter().add_line(p2, p3, chevron_col, 1.5)
  }

  if is_open {
    let item_h = 24.0
    let total_options_h = item_h * options.length().to_double()
    let max_menu_h = 240.0
    let menu_h = if total_options_h > max_menu_h {
      max_menu_h
    } else {
      total_options_h
    }

    let mut menu_y = box_rect.y + box_rect.h + 2.0
    if menu_y + menu_h > 600.0 && box_rect.y - menu_h - 2.0 >= 0.0 {
      menu_y = box_rect.y - menu_h - 2.0
    }
    let menu_rect = @math.Rect::new(box_rect.x, menu_y, box_w, menu_h)

    ctx.begin_foreground()
    ctx.block_hover(menu_rect)

    let combo_scroll_id = ctx.id_stack.derive_id(id_salt + "::combo_scroll")
    let mut combo_scroll_y = ctx.get_scroll_offset(combo_scroll_id)
    let max_scroll = if total_options_h > menu_h {
      total_options_h - menu_h
    } else {
      0.0
    }
    if ctx.is_hovered(menu_rect) && ctx.input.scroll_delta.y != 0.0 {
      combo_scroll_y = combo_scroll_y - ctx.input.scroll_delta.y
    }
    if combo_scroll_y < 0.0 {
      combo_scroll_y = 0.0
    }
    if combo_scroll_y > max_scroll {
      combo_scroll_y = max_scroll
    }
    ctx.set_scroll_offset(combo_scroll_id, combo_scroll_y)

    if ctx.input.mouse_pressed() && !ctx.is_hovered(menu_rect) && !box_hovered {
      ctx.set_open_combo_id(@core.Id::zero())
      ctx.end_foreground()
      return (current_idx, resp)
    }

    let shadow_rect = @math.Rect::new(
      menu_rect.x,
      menu_rect.y + 2.0,
      menu_rect.w,
      menu_rect.h,
    )
    let menu_radius = ctx.style.radius_md
    let item_radius = ctx.style.radius_sm
    let item_font_sz = ctx.style.font_small
    ctx
    .painter()
    .add_rect(shadow_rect, @color.Color::shadow_ambient(), menu_radius)
    ctx.painter().add_rect(menu_rect, @color.Color::bg_window(), item_radius)
    ctx
    .painter()
    .add_rect_stroke(
      menu_rect,
      @color.Color::border_default(),
      1.0,
      item_radius,
    )

    ctx.push_clip(menu_rect)

    for i = 0; i < options.length(); i = i + 1 {
      let item_rect = @math.Rect::new(
        menu_rect.x,
        menu_rect.y + item_h * i.to_double() - combo_scroll_y,
        box_w,
        item_h,
      )
      let item_hovered = ctx.is_hovered(item_rect)
      if item_hovered {
        ctx.set_cursor_icon("pointer")
        ctx
        .painter()
        .add_rect(item_rect, @color.Color::bg_surface(), item_radius)
        if ctx.input.mouse_pressed() {
          current_idx = i
          ctx.set_open_combo_id(@core.Id::zero())
        }
      }
      let item_text_col = if item_hovered {
        @color.Color::accent_primary()
      } else if i == current_idx {
        @color.Color::accent_primary()
      } else {
        @color.Color::text_body()
      }
      ctx
      .painter()
      .add_text(
        @math.Vec2::new(
          item_rect.x + 8.0,
          item_rect.y + (item_h - item_font_sz) * 0.5,
        ),
        options[i],
        item_font_sz,
        item_text_col,
      )

      if i == current_idx {
        let chk_x = item_rect.x + box_w - 14.0
        let chk_y = item_rect.y + item_h * 0.5
        let p1 = @math.Vec2::new(chk_x - 4.0, chk_y)
        let p2 = @math.Vec2::new(chk_x - 1.5, chk_y + 2.5)
        let p3 = @math.Vec2::new(chk_x + 3.5, chk_y - 2.5)
        ctx.painter().add_line(p1, p2, @color.Color::accent_primary(), 1.5)
        ctx.painter().add_line(p2, p3, @color.Color::accent_primary(), 1.5)
      }
    }

    ctx.pop_clip()
    ctx.end_foreground()
  }

  (current_idx, resp)
}

///|
/// Standalone horizontal tab bar container supporting fluent configuration.
pub struct TabBar {
  id_str : String
  tabs : Array[String]
  selected_idx : Int
} derive(Eq, Debug)

///|
/// Create a new tab bar widget.
pub fn TabBar::new(
  id_str : String,
  tabs : Array[String],
  selected_idx : Int,
) -> TabBar {
  { id_str, tabs, selected_idx, }
}

///|
/// Show the tab bar and return (new_selected_idx, response).
pub fn TabBar::show(self : TabBar, ctx : UIContext) -> (Int, Response) {
  tab_bar(ctx, self.id_str, self.tabs, self.selected_idx)
}

///|
/// Render a segmented horizontal tab bar in Studio Light.
/// Returns a tuple of (new_selected_index, response).
pub fn tab_bar(
  ctx : UIContext,
  _id_str : String,
  tabs : Array[String],
  selected_idx : Int,
) -> (Int, Response) {
  let scale = ctx.style.scale
  let font_size = ctx.style.font_normal * scale
  let tab_pad = ctx.style.spacing_md * scale
  let mut total_w = 0.0
  for tab in tabs {
    total_w = total_w + ctx.measure_text(tab, font_size).x + tab_pad * 2.0
  }
  let h = (ctx.style.control_h_sm + ctx.style.spacing_xs) * scale
  let (id, rect, resp) = ctx.allocate_space(@math.Vec2::new(total_w, h))
  ctx.register_focusable(id)

  let mut current_selected = selected_idx
  let is_focused = resp.has_focus() || ctx.has_focus(id)

  if is_focused && tabs.length() > 0 {
    if ctx.input.key_pressed(Key::ArrowLeft) {
      current_selected = if current_selected > 0 {
        current_selected - 1
      } else {
        tabs.length() - 1
      }
      ctx.input.consume_key(Key::ArrowLeft)
    }
    if ctx.input.key_pressed(Key::ArrowRight) {
      current_selected = if current_selected < tabs.length() - 1 {
        current_selected + 1
      } else {
        0
      }
      ctx.input.consume_key(Key::ArrowRight)
    }
  }

  let container_radius = ctx.style.radius_md * scale
  let tab_radius = ctx.style.radius_sm * scale
  ctx.painter().add_rect(rect, @color.Color::bg_surface(), container_radius)
  ctx
  .painter()
  .add_rect_stroke(
    rect,
    if is_focused {
      @color.Color::border_focus()
    } else {
      @color.Color::border_muted()
    },
    1.0,
    container_radius,
  )

  let mut cur_x = rect.x
  for i = 0; i < tabs.length(); i = i + 1 {
    let tab_text = tabs[i]
    let text_w = ctx.measure_text(tab_text, font_size).x
    let tab_w = text_w + tab_pad * 2.0
    let tab_rect = @math.Rect::new(cur_x, rect.y, tab_w, h)
    let is_hovered = ctx.is_hovered(tab_rect)
    let is_selected = i == current_selected

    if is_hovered {
      ctx.set_cursor_icon("pointer")
    }
    if is_hovered && ctx.input.mouse_pressed() {
      current_selected = i
    }

    if is_selected {
      let active_rect = tab_rect.shrink(2.0)
      ctx.painter().add_rect(active_rect, @color.Color::bg_window(), tab_radius)
      ctx
      .painter()
      .add_rect_stroke(
        active_rect,
        @color.Color::border_default(),
        1.0,
        tab_radius,
      )
    } else if is_hovered {
      let hover_rect = tab_rect.shrink(2.0)
      ctx.painter().add_rect(hover_rect, @color.Color::bg_subtle(), tab_radius)
    }

    let text_col = if is_selected {
      @color.Color::text_primary()
    } else if is_hovered {
      @color.Color::text_primary()
    } else {
      @color.Color::text_muted()
    }

    let text_x = tab_rect.x + (tab_w - text_w) * 0.5
    let text_y = tab_rect.y + (h - font_size) * 0.5
    ctx
    .painter()
    .add_text(@math.Vec2::new(text_x, text_y), tab_text, font_size, text_col)

    cur_x = cur_x + tab_w
  }

  (current_selected, resp)
}
