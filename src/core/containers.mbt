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
    @color.Color::bg_surface()
  } else {
    @color.Color::bg_subtle()
  }
  let border_color = if resp.hovered() {
    @color.Color::border_default()
  } else {
    @color.Color::border_muted()
  }
  self.draw_list.add_rect(rect, bg_color, 5.0)
  self.draw_list.add_rect_stroke(rect, border_color, 1.0, 5.0)

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

  let title_x = rect.x + 24.0
  let title_y = rect.y + (h - 13.0) * 0.5
  let text_color = if resp.hovered() {
    @color.Color::text_primary()
  } else {
    @color.Color::text_body()
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
  let box_hovered = self.is_hovered(box_rect)

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
    @color.Color::bg_subtle()
  } else {
    @color.Color::white()
  }
  let border_color = if is_open || box_hovered {
    @color.Color::accent_primary()
  } else {
    @color.Color::border_default()
  }

  self.draw_list.add_rect(box_rect, bg_color, 5.0)
  self.draw_list.add_rect_stroke(box_rect, border_color, 1.0, 5.0)

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
    let menu_h = item_h * options.length().to_double()
    let menu_rect = @math.Rect::new(
      box_rect.x,
      box_rect.y + box_rect.h + 2.0,
      box_w,
      menu_h,
    )

    // The popup lives on the foreground layer: it must not be clipped by the
    // container that hosts the combo box, and it must swallow pointer input
    // for the widgets drawn underneath it.
    self.begin_foreground()
    self.block_hover(menu_rect)

    // Elevation shadow & border
    let shadow_rect = @math.Rect::new(
      menu_rect.x,
      menu_rect.y + 2.0,
      menu_rect.w,
      menu_rect.h,
    )
    self.draw_list.add_rect(shadow_rect, @color.Color::shadow(), 6.0)
    self.draw_list.add_rect(menu_rect, @color.Color::white(), 5.0)
    self.draw_list.add_rect_stroke(
      menu_rect,
      @color.Color::border_default(),
      1.0,
      5.0,
    )

    for i = 0; i < options.length(); i = i + 1 {
      let item_rect = @math.Rect::new(
        menu_rect.x,
        menu_rect.y + item_h * i.to_double(),
        box_w,
        item_h,
      )
      let item_hovered = self.is_hovered(item_rect)
      if item_hovered {
        self.draw_list.add_rect(item_rect, @color.Color::bg_surface(), 3.0)
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
        @math.Vec2::new(item_rect.x + 8.0, item_rect.y + (item_h - 12.0) * 0.5),
        options[i],
        12.0,
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

    self.end_foreground()
  }

  (current_idx, resp)
}

///|
/// Render a segmented horizontal tab bar in Studio Light.
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

  // Draw recessed groove container
  self.draw_list.add_rect(rect, @color.Color::bg_surface(), 6.0)
  self.draw_list.add_rect_stroke(rect, @color.Color::border_muted(), 1.0, 6.0)

  let mut cur_x = rect.x
  for i = 0; i < tabs.length(); i = i + 1 {
    let tab_text = tabs[i]
    let tab_w = tab_text.length().to_double() * char_w + 24.0
    let tab_rect = @math.Rect::new(cur_x, rect.y, tab_w, h)
    let is_hovered = self.is_hovered(tab_rect)
    let is_selected = i == current_selected

    if is_hovered && self.input.mouse_pressed() {
      current_selected = i
    }

    if is_selected {
      let active_rect = tab_rect.shrink(2.0)
      self.draw_list.add_rect(active_rect, @color.Color::white(), 5.0)
      self.draw_list.add_rect_stroke(
        active_rect,
        @color.Color::border_default(),
        1.0,
        5.0,
      )
    } else if is_hovered {
      let hover_rect = tab_rect.shrink(2.0)
      self.draw_list.add_rect(hover_rect, @color.Color::bg_subtle(), 4.0)
    }

    let text_col = if is_selected {
      @color.Color::text_primary()
    } else if is_hovered {
      @color.Color::text_primary()
    } else {
      @color.Color::text_muted()
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
