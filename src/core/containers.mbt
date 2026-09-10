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

  let bg_color = if resp.hovered() {
    @color.Color::bg_hover()
  } else {
    @color.Color::bg_surface()
  }
  self.draw_list.add_rect(rect, bg_color, 4.0)

  let arrow_color = if resp.hovered() {
    @color.Color::white()
  } else {
    @color.Color::text_secondary()
  }
  let arrow_char = if is_open { "▼" } else { "▶" }
  let arrow_x = rect.x + 8.0
  let arrow_y = rect.y + (h - 10.0) * 0.5
  self.draw_list.add_text(
    @math.Vec2::new(arrow_x, arrow_y),
    arrow_char,
    10.0,
    arrow_color,
  )

  let title_x = rect.x + 24.0
  let title_y = rect.y + (h - 13.0) * 0.5
  let text_color = if resp.hovered() {
    @color.Color::white()
  } else {
    @color.Color::text_primary()
  }
  self.draw_list.add_text(
    @math.Vec2::new(title_x, title_y),
    title,
    13.0,
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
/// Render a dropdown selection menu.
/// Returns a tuple of (new_selected_index, response).
pub fn UIContext::combo_box(
  self : UIContext,
  id_salt : String,
  label : String,
  selected_index : Int,
  options : Array[String],
) -> (Int, Response) {
  let combo_id = self.id_stack.derive_id(id_salt)
  let label_size = if !label.is_empty() {
    self.measure_text(label, 13.0).x + 8.0
  } else {
    0.0
  }
  let box_w = 140.0
  let total_w = label_size + box_w
  let h = 28.0

  self.push_id(id_salt)
  let (_id, rect, resp) = self.allocate_space(@math.Vec2::new(total_w, h))
  self.pop_id()

  let box_rect = @math.Rect::new(rect.x + label_size, rect.y, box_w, h)
  let box_hovered = box_rect.contains(self.input.mouse_pos)

  let mut current_idx = selected_index
  let is_open = self.open_combo_id() == combo_id

  if box_hovered && self.input.mouse_pressed() {
    if is_open {
      self.set_open_combo_id(Id::zero())
    } else {
      self.set_open_combo_id(combo_id)
    }
  }

  if !label.is_empty() {
    let label_y = rect.y + (h - 13.0) * 0.5
    self.draw_list.add_text(
      @math.Vec2::new(rect.x, label_y),
      label,
      13.0,
      @color.Color::text_primary(),
    )
  }

  let bg_color = if box_hovered || is_open {
    @color.Color::bg_hover()
  } else {
    @color.Color::bg_surface()
  }
  let border_color = if is_open {
    @color.Color::accent_primary()
  } else if box_hovered {
    @color.Color::accent_hover()
  } else {
    @color.Color::border_muted()
  }

  self.draw_list.add_rect(box_rect, bg_color, 4.0)
  self.draw_list.add_rect_stroke(box_rect, border_color, 1.0, 4.0)

  let selected_str = if current_idx >= 0 && current_idx < options.length() {
    options[current_idx]
  } else {
    ""
  }
  let text_y = box_rect.y + (h - 13.0) * 0.5
  self.draw_list.add_text(
    @math.Vec2::new(box_rect.x + 8.0, text_y),
    selected_str,
    13.0,
    @color.Color::text_primary(),
  )

  let arrow_x = box_rect.x + box_w - 18.0
  let arrow_y = box_rect.y + (h - 10.0) * 0.5
  self.draw_list.add_text(
    @math.Vec2::new(arrow_x, arrow_y),
    "▼",
    10.0,
    @color.Color::text_secondary(),
  )

  if is_open {
    let item_h = 24.0
    let menu_h = item_h * options.length().to_double()
    let menu_rect = @math.Rect::new(
      box_rect.x,
      box_rect.y + box_rect.h + 2.0,
      box_w,
      menu_h,
    )

    self.draw_list.add_rect(menu_rect, @color.Color::bg_window(), 4.0)
    self.draw_list.add_rect_stroke(
      menu_rect,
      @color.Color::border_muted(),
      1.0,
      4.0,
    )

    for i = 0; i < options.length(); i = i + 1 {
      let item_rect = @math.Rect::new(
        menu_rect.x,
        menu_rect.y + item_h * i.to_double(),
        box_w,
        item_h,
      )
      let item_hovered = item_rect.contains(self.input.mouse_pos)
      if item_hovered {
        self.draw_list.add_rect(item_rect, @color.Color::accent_primary(), 2.0)
        if self.input.mouse_pressed() {
          current_idx = i
          self.set_open_combo_id(Id::zero())
        }
      }
      let item_text_col = if item_hovered {
        @color.Color::white()
      } else if i == current_idx {
        @color.Color::accent_primary()
      } else {
        @color.Color::text_primary()
      }
      self.draw_list.add_text(
        @math.Vec2::new(item_rect.x + 8.0, item_rect.y + (item_h - 12.0) * 0.5),
        options[i],
        12.0,
        item_text_col,
      )
    }
  }

  (current_idx, resp)
}

///|
/// Render a segmented horizontal tab bar.
/// Returns a tuple of (new_selected_index, response).
pub fn UIContext::tab_bar(
  self : UIContext,
  _id_str : String,
  tabs : Array[String],
  selected_idx : Int,
) -> (Int, Response) {
  let char_w = 8.0
  let mut total_w = 0.0
  for tab in tabs {
    total_w = total_w + tab.length().to_double() * char_w + 24.0
  }
  let h = 28.0
  let (_id, rect, resp) = self.allocate_space(@math.Vec2::new(total_w, h))
  let mut current_selected = selected_idx

  // Draw background container
  self.draw_list.add_rect(rect, @color.Color::bg_window(), 6.0)
  self.draw_list.add_rect_stroke(rect, @color.Color::border_muted(), 1.0, 6.0)

  let mut cur_x = rect.x
  for i = 0; i < tabs.length(); i = i + 1 {
    let tab_text = tabs[i]
    let tab_w = tab_text.length().to_double() * char_w + 24.0
    let tab_rect = @math.Rect::new(cur_x, rect.y, tab_w, h)
    let is_hovered = tab_rect.contains(self.input.mouse_pos)
    let is_selected = i == current_selected

    if is_hovered && self.input.mouse_pressed {
      current_selected = i
    }

    if is_selected {
      let active_rect = tab_rect.shrink(2.0)
      self.draw_list.add_rect(active_rect, @color.Color::accent_primary(), 4.0)
    } else if is_hovered {
      let hover_rect = tab_rect.shrink(2.0)
      self.draw_list.add_rect(hover_rect, @color.Color::bg_hover(), 4.0)
    }

    let text_col = if is_selected {
      @color.Color::white()
    } else if is_hovered {
      @color.Color::white()
    } else {
      @color.Color::text_secondary()
    }

    let text_x = tab_rect.x +
      (tab_w - tab_text.length().to_double() * char_w) * 0.5
    let text_y = tab_rect.y + (h - 13.0) * 0.5
    self.draw_list.add_text(
      @math.Vec2::new(text_x, text_y),
      tab_text,
      13.0,
      text_col,
    )

    cur_x = cur_x + tab_w
  }

  (current_selected, resp)
}
