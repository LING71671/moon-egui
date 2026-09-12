///|
/// Render a collapsible section header with expand/collapse arrow indicator and nested content.
pub fn UIContext::collapsing_header(
  self : UIContext,
  id_salt : String,
  title : String,
  default_open : Bool,
  content : (UIContext) -> Unit,
) -> Response {
  let header_id = self.id_stack.derive_id(id_salt)
  let w = self.available_width
  let h = 26.0

  self.push_id(id_salt)
  let (_id, rect, resp) = self.allocate_space(@math.Vec2::new(w, h))
  self.pop_id()

  let mut is_open = self.is_collapsing_open(header_id, default_open)
  if resp.clicked() {
    is_open = !is_open
    self.set_collapsing_open(header_id, is_open)
  }

  if resp.hovered() {
    self.set_cursor_icon("pointer")
  }
  let bg_color = if resp.hovered() {
    @color.Color::bg_surface()
  } else {
    @color.Color::bg_subtle()
  }
  let border_color = if resp.hovered() {
    @color.Color::border_default()
  } else {
    @color.Color::border_muted()
  }
  let header_radius = self.style.radius_sm
  self.draw_list.add_rect(rect, bg_color, header_radius)
  self.draw_list.add_rect_stroke(rect, border_color, 1.0, header_radius)

  let arrow_color = if resp.hovered() {
    @color.Color::accent_primary()
  } else {
    @color.Color::text_muted()
  }

  // Draw crisp vector chevron
  let arrow_cx = rect.x + 12.0
  let arrow_cy = rect.y + h * 0.5
  if is_open {
    let p1 = @math.Vec2::new(arrow_cx - 3.5, arrow_cy - 1.5)
    let p2 = @math.Vec2::new(arrow_cx, arrow_cy + 2.0)
    let p3 = @math.Vec2::new(arrow_cx + 3.5, arrow_cy - 1.5)
    self.draw_list.add_line(p1, p2, arrow_color, 1.5)
    self.draw_list.add_line(p2, p3, arrow_color, 1.5)
  } else {
    let p1 = @math.Vec2::new(arrow_cx - 1.5, arrow_cy - 3.5)
    let p2 = @math.Vec2::new(arrow_cx + 2.0, arrow_cy)
    let p3 = @math.Vec2::new(arrow_cx - 1.5, arrow_cy + 3.5)
    self.draw_list.add_line(p1, p2, arrow_color, 1.5)
    self.draw_list.add_line(p2, p3, arrow_color, 1.5)
  }

  let font_sz = self.style.font_normal
  let title_x = rect.x + 24.0
  let title_y = rect.y + (h - font_sz) * 0.5
  let text_color = if resp.hovered() {
    @color.Color::text_primary()
  } else {
    @color.Color::text_body()
  }
  self.draw_list.add_text(
    @math.Vec2::new(title_x, title_y),
    title,
    font_sz,
    text_color,
  )

  if is_open {
    let prev_cursor = self.cursor
    let prev_avail_w = self.available_width
    let indent = 16.0

    self.cursor = @math.Vec2::new(prev_cursor.x + indent, prev_cursor.y)
    self.available_width = prev_avail_w - indent

    content(self)

    let final_y = self.cursor.y
    self.cursor = @math.Vec2::new(prev_cursor.x, final_y)
    self.available_width = prev_avail_w
  }

  resp
}

///|
/// Render a dropdown selection menu in Studio Light.
/// Returns a tuple of (new_selected_index, response).
pub fn UIContext::combo_box(
  self : UIContext,
  id_salt : String,
  label : String,
  selected_index : Int,
  options : Array[String],
) -> (Int, Response) {
  let combo_id = self.id_stack.derive_id(id_salt)
  let combo_font_sz = self.style.font_normal
  let label_size = if !label.is_empty() {
    self.measure_text(label, combo_font_sz).x + 8.0
  } else {
    0.0
  }
  let box_w = 140.0
  let total_w = label_size + box_w
  let h = 28.0

  self.push_id(id_salt)
  let (id, rect, resp) = self.allocate_space(@math.Vec2::new(total_w, h))
  self.pop_id()
  self.register_focusable(id)

  let box_rect = @math.Rect::new(rect.x + label_size, rect.y, box_w, h)
  let box_hovered = self.is_hovered(box_rect)
  if box_hovered {
    self.set_cursor_icon("pointer")
  }

  let mut current_idx = selected_index
  let is_open = self.open_combo_id() == combo_id
  let is_focused = resp.has_focus() || self.has_focus(id)

  let key_toggle = is_focused &&
    (self.input.key_pressed(Key::Space) || self.input.key_pressed(Key::Enter))
  if key_toggle {
    self.input.consume_key(Key::Space)
    self.input.consume_key(Key::Enter)
  }

  if (box_hovered && self.input.mouse_pressed()) || key_toggle {
    if is_open {
      self.set_open_combo_id(Id::zero())
    } else {
      self.set_open_combo_id(combo_id)
    }
  }

  if is_open {
    if self.input.key_pressed(Key::Escape) {
      self.set_open_combo_id(Id::zero())
      self.input.consume_key(Key::Escape)
    }
    if self.input.key_pressed(Key::ArrowDown) {
      if current_idx < options.length() - 1 {
        current_idx = current_idx + 1
      }
      self.input.consume_key(Key::ArrowDown)
    }
    if self.input.key_pressed(Key::ArrowUp) {
      if current_idx > 0 {
        current_idx = current_idx - 1
      }
      self.input.consume_key(Key::ArrowUp)
    }
    if self.input.key_pressed(Key::Enter) {
      self.set_open_combo_id(Id::zero())
      self.input.consume_key(Key::Enter)
    }
  }

  if !label.is_empty() {
    let label_y = rect.y + (h - combo_font_sz) * 0.5
    self.draw_list.add_text(
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

  let box_radius = self.style.radius_sm
  self.draw_list.add_rect(box_rect, bg_color, box_radius)
  let stroke_w = if is_focused || is_open { 1.5 } else { 1.0 }
  self.draw_list.add_rect_stroke(box_rect, border_color, stroke_w, box_radius)

  let selected_str = if current_idx >= 0 && current_idx < options.length() {
    options[current_idx]
  } else {
    ""
  }
  let text_y = box_rect.y + (h - combo_font_sz) * 0.5
  self.draw_list.add_text(
    @math.Vec2::new(box_rect.x + 8.0, text_y),
    selected_str,
    combo_font_sz,
    @color.Color::text_primary(),
  )

  // Draw vector chevron on trigger
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
    self.draw_list.add_line(p1, p2, chevron_col, 1.5)
    self.draw_list.add_line(p2, p3, chevron_col, 1.5)
  } else {
    let p1 = @math.Vec2::new(chevron_cx - 3.5, chevron_cy - 1.5)
    let p2 = @math.Vec2::new(chevron_cx, chevron_cy + 2.0)
    let p3 = @math.Vec2::new(chevron_cx + 3.5, chevron_cy - 1.5)
    self.draw_list.add_line(p1, p2, chevron_col, 1.5)
    self.draw_list.add_line(p2, p3, chevron_col, 1.5)
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

    // Screen collision flipping: if menu extends past bottom, flip above trigger
    let mut menu_y = box_rect.y + box_rect.h + 2.0
    if menu_y + menu_h > 600.0 && box_rect.y - menu_h - 2.0 >= 0.0 {
      menu_y = box_rect.y - menu_h - 2.0
    }
    let menu_rect = @math.Rect::new(box_rect.x, menu_y, box_w, menu_h)

    // The popup lives on the foreground layer: it must not be clipped by the
    // container that hosts the combo box, and it must swallow pointer input
    // for the widgets drawn underneath it.
    self.begin_foreground()
    self.block_hover(menu_rect)

    // Handle scroll wheel inside dropdown if options exceed max menu height
    let combo_scroll_id = self.id_stack.derive_id(id_salt + "::combo_scroll")
    let mut combo_scroll_y = self.get_scroll_offset(combo_scroll_id)
    let max_scroll = if total_options_h > menu_h {
      total_options_h - menu_h
    } else {
      0.0
    }
    if self.is_hovered(menu_rect) && self.input.scroll_delta.y != 0.0 {
      combo_scroll_y = combo_scroll_y - self.input.scroll_delta.y
    }
    if combo_scroll_y < 0.0 {
      combo_scroll_y = 0.0
    }
    if combo_scroll_y > max_scroll {
      combo_scroll_y = max_scroll
    }
    self.set_scroll_offset(combo_scroll_id, combo_scroll_y)

    // A press outside both the box and the popup dismisses the dropdown. The
    // popup itself is already on the foreground layer, so its rect is tested
    // against the pointer without the scissor clip of the hosting container -
    // a popup that extends past its container is still dismissed correctly.
    if self.input.mouse_pressed() && !self.is_hovered(menu_rect) && !box_hovered {
      self.set_open_combo_id(Id::zero())
      self.end_foreground()
      return (current_idx, resp)
    }

    // Elevation shadow & border
    let shadow_rect = @math.Rect::new(
      menu_rect.x,
      menu_rect.y + 2.0,
      menu_rect.w,
      menu_rect.h,
    )
    let menu_radius = self.style.radius_md
    let item_radius = self.style.radius_sm
    let item_font_sz = self.style.font_small
    self.draw_list.add_rect(
      shadow_rect,
      @color.Color::shadow_ambient(),
      menu_radius,
    )
    self.draw_list.add_rect(menu_rect, @color.Color::bg_window(), item_radius)
    self.draw_list.add_rect_stroke(
      menu_rect,
      @color.Color::border_default(),
      1.0,
      item_radius,
    )

    self.push_clip(menu_rect)

    for i = 0; i < options.length(); i = i + 1 {
      let item_rect = @math.Rect::new(
        menu_rect.x,
        menu_rect.y + item_h * i.to_double() - combo_scroll_y,
        box_w,
        item_h,
      )
      let item_hovered = self.is_hovered(item_rect)
      if item_hovered {
        self.set_cursor_icon("pointer")
        self.draw_list.add_rect(
          item_rect,
          @color.Color::bg_surface(),
          item_radius,
        )
        if self.input.mouse_pressed() {
          current_idx = i
          self.set_open_combo_id(Id::zero())
        }
      }
      let item_text_col = if item_hovered {
        @color.Color::accent_primary()
      } else if i == current_idx {
        @color.Color::accent_primary()
      } else {
        @color.Color::text_body()
      }
      self.draw_list.add_text(
        @math.Vec2::new(
          item_rect.x + 8.0,
          item_rect.y + (item_h - item_font_sz) * 0.5,
        ),
        options[i],
        item_font_sz,
        item_text_col,
      )

      // Vector checkmark for active item
      if i == current_idx {
        let chk_x = item_rect.x + box_w - 14.0
        let chk_y = item_rect.y + item_h * 0.5
        let p1 = @math.Vec2::new(chk_x - 4.0, chk_y)
        let p2 = @math.Vec2::new(chk_x - 1.5, chk_y + 2.5)
        let p3 = @math.Vec2::new(chk_x + 3.5, chk_y - 2.5)
        self.draw_list.add_line(p1, p2, @color.Color::accent_primary(), 1.5)
        self.draw_list.add_line(p2, p3, @color.Color::accent_primary(), 1.5)
      }
    }

    self.pop_clip()
    self.end_foreground()
  }

  (current_idx, resp)
}

///|
/// Render a segmented horizontal tab bar in Studio Light.
/// Returns a tuple of (new_selected_index, response).
///
/// Tab widths come from `measure_text`, which accounts for CJK glyphs being
/// roughly twice as wide as Latin ones. A fixed per-character estimate used to
/// make non-Latin labels overflow their tab and break the centring.
pub fn UIContext::tab_bar(
  self : UIContext,
  _id_str : String,
  tabs : Array[String],
  selected_idx : Int,
) -> (Int, Response) {
  let font_size = self.style.font_normal
  let mut total_w = 0.0
  for tab in tabs {
    total_w = total_w + self.measure_text(tab, font_size).x + 24.0
  }
  let h = 28.0
  let (_id, rect, resp) = self.allocate_space(@math.Vec2::new(total_w, h))
  let mut current_selected = selected_idx

  let container_radius = self.style.radius_md
  let tab_radius = self.style.radius_sm
  // Draw recessed groove container
  self.draw_list.add_rect(rect, @color.Color::bg_surface(), container_radius)
  self.draw_list.add_rect_stroke(
    rect,
    @color.Color::border_muted(),
    1.0,
    container_radius,
  )

  let mut cur_x = rect.x
  for i = 0; i < tabs.length(); i = i + 1 {
    let tab_text = tabs[i]
    let text_w = self.measure_text(tab_text, font_size).x
    let tab_w = text_w + 24.0
    let tab_rect = @math.Rect::new(cur_x, rect.y, tab_w, h)
    let is_hovered = self.is_hovered(tab_rect)
    let is_selected = i == current_selected

    if is_hovered {
      self.set_cursor_icon("pointer")
    }
    if is_hovered && self.input.mouse_pressed() {
      current_selected = i
    }

    if is_selected {
      let active_rect = tab_rect.shrink(2.0)
      self.draw_list.add_rect(
        active_rect,
        @color.Color::bg_window(),
        tab_radius,
      )
      self.draw_list.add_rect_stroke(
        active_rect,
        @color.Color::border_default(),
        1.0,
        tab_radius,
      )
    } else if is_hovered {
      let hover_rect = tab_rect.shrink(2.0)
      self.draw_list.add_rect(hover_rect, @color.Color::bg_subtle(), tab_radius)
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
    self.draw_list.add_text(
      @math.Vec2::new(text_x, text_y),
      tab_text,
      font_size,
      text_col,
    )

    cur_x = cur_x + tab_w
  }

  (current_selected, resp)
}
