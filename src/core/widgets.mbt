///|
/// Render a read-only text label using standard theme text color.
pub fn UIContext::label(self : UIContext, text : String) -> Response {
  self.label_colored(text, @color.Color::text_primary())
}

///|
/// Render a text label with a specified custom color.
pub fn UIContext::label_colored(
  self : UIContext,
  text : String,
  color : @color.Color,
) -> Response {
  let char_w = 8.0
  let text_w = text.length().to_double() * char_w
  let w = if text_w > 20.0 { text_w } else { 20.0 }
  let h = 18.0
  let (_id, rect, resp) = self.allocate_space(@math.Vec2::new(w, h))
  let text_pos = @math.Vec2::new(rect.x, rect.y + 2.0)
  self.draw_list.add_text(text_pos, text, 14.0, color)
  resp
}

///|
/// Render an interactive button with an explicitly specified size.
pub fn UIContext::button_sized(
  self : UIContext,
  text : String,
  size : @math.Vec2,
) -> Response {
  let char_w = 8.0
  let text_w = text.length().to_double() * char_w
  let (_id, rect, resp) = self.allocate_space(size)

  let bg_color = if resp.pressed {
    @color.Color::accent_primary()
  } else if resp.hovered {
    @color.Color::bg_hover()
  } else {
    @color.Color::bg_surface()
  }

  let border_color = if resp.pressed {
    @color.Color::accent_hover()
  } else if resp.hovered {
    @color.Color::accent_primary()
  } else {
    @color.Color::border_muted()
  }

  let text_color = if resp.pressed || resp.hovered {
    @color.Color::white()
  } else {
    @color.Color::text_primary()
  }

  self.draw_list.add_rect(rect, bg_color, 4.0)
  self.draw_list.add_rect_stroke(rect, border_color, 1.0, 4.0)

  let text_x = rect.x + (rect.w - text_w) * 0.5
  let text_y = rect.y + (rect.h - 14.0) * 0.5
  self.draw_list.add_text(
    @math.Vec2::new(text_x, text_y),
    text,
    13.0,
    text_color,
  )
  resp
}

///|
/// Render an interactive button.
/// Automatically handles hover, press, and click interactions with modern dark-mode styling.
pub fn UIContext::button(self : UIContext, text : String) -> Response {
  let char_w = 8.0
  let text_w = text.length().to_double() * char_w
  let w = if text_w + 28.0 > 64.0 { text_w + 28.0 } else { 64.0 }
  let h = 32.0
  self.button_sized(text, @math.Vec2::new(w, h))
}

///|
/// Render an emphasized primary button with an explicitly specified size.
pub fn UIContext::button_primary_sized(
  self : UIContext,
  text : String,
  size : @math.Vec2,
) -> Response {
  let char_w = 8.0
  let text_w = text.length().to_double() * char_w
  let (_id, rect, resp) = self.allocate_space(size)

  let bg_color = if resp.pressed {
    @color.Color::bg_active()
  } else if resp.hovered {
    @color.Color::accent_hover()
  } else {
    @color.Color::accent_primary()
  }

  let border_color = if resp.hovered {
    @color.Color::white()
  } else {
    @color.Color::accent_hover()
  }

  self.draw_list.add_rect(rect, bg_color, 4.0)
  self.draw_list.add_rect_stroke(rect, border_color, 1.0, 4.0)

  let text_x = rect.x + (rect.w - text_w) * 0.5
  let text_y = rect.y + (rect.h - 14.0) * 0.5
  self.draw_list.add_text(
    @math.Vec2::new(text_x, text_y),
    text,
    13.0,
    @color.Color::white(),
  )
  resp
}

///|
/// Render an emphasized call-to-action primary button using accent colors.
pub fn UIContext::button_primary(self : UIContext, text : String) -> Response {
  let char_w = 8.0
  let text_w = text.length().to_double() * char_w
  let w = if text_w + 28.0 > 64.0 { text_w + 28.0 } else { 64.0 }
  let h = 32.0
  self.button_primary_sized(text, @math.Vec2::new(w, h))
}

///|
/// Render a full-width horizontal divider line.
pub fn UIContext::separator(self : UIContext) -> Unit {
  let w = self.available_width
  let h = 9.0
  let (_id, rect, _resp) = self.allocate_space(@math.Vec2::new(w, h))
  let y = rect.y + 4.0
  self.draw_list.add_line(
    @math.Vec2::new(rect.x, y),
    @math.Vec2::new(rect.x + rect.w, y),
    @color.Color::border_muted(),
    1.0,
  )
}

///|
/// Insert vertical spacing advancing the cursor downwards.
pub fn UIContext::spacer(self : UIContext, height : Double) -> Unit {
  self.advance_cursor(@math.Vec2::new(0.0, height))
}

///|
/// Render an interactive toggle checkbox.
/// Returns a tuple of (new_checked_state, response).
pub fn UIContext::checkbox(
  self : UIContext,
  text : String,
  checked : Bool,
) -> (Bool, Response) {
  let box_size = 18.0
  let gap = 8.0
  let char_w = 8.0
  let text_w = text.length().to_double() * char_w
  let w = box_size + gap + text_w
  let h = 22.0
  let (_id, rect, resp) = self.allocate_space(@math.Vec2::new(w, h))
  let new_state = if resp.clicked { !checked } else { checked }

  let box_rect = @math.Rect::new(
    rect.x,
    rect.y + (h - box_size) * 0.5,
    box_size,
    box_size,
  )

  if checked {
    self.draw_list.add_rect(box_rect, @color.Color::accent_primary(), 3.0)
    let inner = box_rect.shrink(4.0)
    self.draw_list.add_rect(inner, @color.Color::white(), 2.0)
  } else {
    let box_bg = if resp.hovered {
      @color.Color::bg_hover()
    } else {
      @color.Color::bg_window()
    }
    let box_border = if resp.hovered {
      @color.Color::accent_primary()
    } else {
      @color.Color::border_muted()
    }
    self.draw_list.add_rect(box_rect, box_bg, 3.0)
    self.draw_list.add_rect_stroke(box_rect, box_border, 1.0, 3.0)
  }

  let text_x = rect.x + box_size + gap
  let text_y = rect.y + (h - 14.0) * 0.5
  let text_color = if resp.hovered {
    @color.Color::white()
  } else {
    @color.Color::text_primary()
  }
  self.draw_list.add_text(
    @math.Vec2::new(text_x, text_y),
    text,
    14.0,
    text_color,
  )

  (new_state, resp)
}

///|
/// Render a continuous floating-point slider.
/// Returns a tuple of (new_value, response).
pub fn UIContext::slider(
  self : UIContext,
  label : String,
  value : Double,
  min : Double,
  max : Double,
) -> (Double, Response) {
  let char_w = 8.0
  let label_w = if label.length() > 0 {
    label.length().to_double() * char_w + 12.0
  } else {
    0.0
  }
  let track_w = 120.0
  let val_w = 42.0
  let total_w = label_w + track_w + val_w + 8.0
  let h = 24.0
  let (id, rect, resp) = self.allocate_space(@math.Vec2::new(total_w, h))

  let track_rect = @math.Rect::new(
    rect.x + label_w,
    rect.y + (h - 6.0) * 0.5,
    track_w,
    6.0,
  )

  // Hit-testing on interactive track zone
  let touch_rect = @math.Rect::new(track_rect.x - 4.0, rect.y, track_w + 8.0, h)
  let is_hovered = touch_rect.contains(self.input.mouse_pos)
  if is_hovered && self.input.mouse_pressed {
    self.set_active_id(id)
  }

  let is_active = self.active_id() == id
  let clamped_min = if min < max { min } else { max }
  let clamped_max = if max > min { max } else { min }
  let range = clamped_max - clamped_min
  let safe_range = if range > 0.000001 { range } else { 1.0 }

  let mut new_val = value
  if is_active && self.input.mouse_down {
    let mouse_x = self.input.mouse_pos.x
    let mut pct = (mouse_x - track_rect.x) / track_rect.w
    if pct < 0.0 {
      pct = 0.0
    } else if pct > 1.0 {
      pct = 1.0
    }
    new_val = clamped_min + pct * safe_range
  }

  // Draw Label
  if label.length() > 0 {
    self.draw_list.add_text(
      @math.Vec2::new(rect.x, rect.y + 4.0),
      label,
      13.0,
      @color.Color::text_primary(),
    )
  }

  // Draw Track Background
  self.draw_list.add_rect(track_rect, @color.Color::bg_hover(), 3.0)

  // Draw Active Progress Fill
  let mut current_pct = (new_val - clamped_min) / safe_range
  if current_pct < 0.0 {
    current_pct = 0.0
  } else if current_pct > 1.0 {
    current_pct = 1.0
  }
  let active_w = track_rect.w * current_pct
  if active_w > 0.0 {
    let fill_rect = @math.Rect::new(
      track_rect.x,
      track_rect.y,
      active_w,
      track_rect.h,
    )
    self.draw_list.add_rect(fill_rect, @color.Color::accent_primary(), 3.0)
  }

  // Draw Thumb Handle
  let thumb_cx = track_rect.x + active_w
  let thumb_cy = track_rect.y + track_rect.h * 0.5
  let thumb_r = if is_active { 7.0 } else if is_hovered { 6.0 } else { 5.0 }
  let thumb_col = if is_active {
    @color.Color::accent_hover()
  } else if is_hovered {
    @color.Color::white()
  } else {
    @color.Color::accent_primary()
  }
  self.draw_list.add_circle(
    @math.Vec2::new(thumb_cx, thumb_cy),
    thumb_r,
    thumb_col,
  )
  self.draw_list.add_circle_stroke(
    @math.Vec2::new(thumb_cx, thumb_cy),
    thumb_r,
    @color.Color::white(),
    1.5,
  )

  // Draw Value Text
  let val_text = if safe_range >= 10.0 {
    new_val.to_int().to_string()
  } else {
    let int_part = new_val.to_int()
    let diff = new_val - int_part.to_double()
    let abs_diff = if diff < 0.0 { -diff } else { diff }
    let frac_part = (abs_diff * 100.0).to_int()
    let frac_str = if frac_part < 10 {
      "0" + frac_part.to_string()
    } else {
      frac_part.to_string()
    }
    int_part.to_string() + "." + frac_str
  }
  self.draw_list.add_text(
    @math.Vec2::new(track_rect.x + track_w + 10.0, rect.y + 4.0),
    val_text,
    12.0,
    @color.Color::text_secondary(),
  )

  (new_val, resp)
}

///|
/// Render an integer step slider.
/// Returns a tuple of (new_value, response).
pub fn UIContext::slider_int(
  self : UIContext,
  label : String,
  value : Int,
  min : Int,
  max : Int,
) -> (Int, Response) {
  let (new_val, resp) = self.slider(
    label,
    value.to_double(),
    min.to_double(),
    max.to_double(),
  )
  let rounded = if new_val >= 0.0 {
    (new_val + 0.5).to_int()
  } else {
    (new_val - 0.5).to_int()
  }
  (rounded, resp)
}

///|
/// Render an interactive radio button option.
/// Returns a tuple of (new_selected_state, response).
pub fn UIContext::radio(
  self : UIContext,
  label : String,
  selected : Bool,
) -> (Bool, Response) {
  let circle_r = 7.0
  let gap = 8.0
  let text_size = self.measure_text(label, 13.0)
  let total_w = circle_r * 2.0 + gap + text_size.x
  let total_h = 22.0
  let (id, rect, resp) = self.allocate_space(@math.Vec2::new(total_w, total_h))
  self.register_focusable(id)

  let new_selected = if resp.clicked() { true } else { selected }

  let center = @math.Vec2::new(rect.x + circle_r + 1.0, rect.y + total_h * 0.5)

  let outer_color = if resp.has_focus() {
    @color.Color::accent_primary()
  } else if resp.hovered() {
    @color.Color::accent_hover()
  } else if selected {
    @color.Color::accent_primary()
  } else {
    @color.Color::border_muted()
  }

  let bg_circle_color = if resp.hovered() {
    @color.Color::bg_hover()
  } else {
    @color.Color::bg_surface()
  }

  self.draw_list.add_circle(center, circle_r, bg_circle_color)
  self.draw_list.add_circle_stroke(center, circle_r, outer_color, 1.5)

  if selected {
    self.draw_list.add_circle(center, 3.5, @color.Color::accent_primary())
  }

  let text_pos = @math.Vec2::new(
    rect.x + circle_r * 2.0 + gap + 1.0,
    rect.y + (total_h - 13.0) * 0.5,
  )
  let text_color = if resp.hovered() {
    @color.Color::white()
  } else {
    @color.Color::text_primary()
  }
  self.draw_list.add_text(text_pos, label, 13.0, text_color)

  (new_selected, resp)
}

///|
/// Render a styled progress bar with progress fill and label.
pub fn UIContext::progress_bar(
  self : UIContext,
  fraction : Double,
  text : String,
) -> Response {
  let w = self.available_width
  let h = 18.0
  let (_id, rect, resp) = self.allocate_space(@math.Vec2::new(w, h))

  let clamped_pct = if fraction < 0.0 {
    0.0
  } else if fraction > 1.0 {
    1.0
  } else {
    fraction
  }

  self.draw_list.add_rect(rect, @color.Color::bg_surface(), 4.0)
  self.draw_list.add_rect_stroke(rect, @color.Color::border_muted(), 1.0, 4.0)

  let fill_w = rect.w * clamped_pct
  if fill_w > 0.0 {
    let fill_rect = @math.Rect::new(rect.x, rect.y, fill_w, rect.h)
    self.draw_list.add_rect(fill_rect, @color.Color::accent_primary(), 4.0)
  }

  let display_text = if text.is_empty() {
    (clamped_pct * 100.0).to_int().to_string() + "%"
  } else {
    text
  }

  let text_size = self.measure_text(display_text, 11.0)
  let text_x = rect.x + (rect.w - text_size.x) * 0.5
  let text_y = rect.y + (rect.h - 11.0) * 0.5
  self.draw_list.add_text(
    @math.Vec2::new(text_x, text_y),
    display_text,
    11.0,
    @color.Color::white(),
  )

  resp
}

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
/// Render an interactive toggle pill switch.
/// Returns a tuple of (new_checked_state, response).
pub fn UIContext::toggle(
  self : UIContext,
  text : String,
  checked : Bool,
) -> (Bool, Response) {
  let switch_w = 34.0
  let switch_h = 18.0
  let gap = 8.0
  let char_w = 8.0
  let text_w = text.length().to_double() * char_w
  let total_w = switch_w + gap + text_w
  let h = 22.0
  let (_id, rect, resp) = self.allocate_space(@math.Vec2::new(total_w, h))
  let new_state = if resp.clicked { !checked } else { checked }

  let switch_rect = @math.Rect::new(
    rect.x,
    rect.y + (h - switch_h) * 0.5,
    switch_w,
    switch_h,
  )

  let bg_color = if checked {
    if resp.hovered {
      @color.Color::accent_hover()
    } else {
      @color.Color::accent_primary()
    }
  } else if resp.hovered {
    @color.Color::bg_hover()
  } else {
    @color.Color::border_muted()
  }

  // Draw pill background
  self.draw_list.add_rect(switch_rect, bg_color, switch_h * 0.5)

  // Draw sliding thumb circle
  let thumb_radius = (switch_h - 4.0) * 0.5
  let thumb_cx = if checked {
    switch_rect.x + switch_w - 2.0 - thumb_radius
  } else {
    switch_rect.x + 2.0 + thumb_radius
  }
  let thumb_cy = switch_rect.y + switch_h * 0.5
  let thumb_rect = @math.Rect::new(
    thumb_cx - thumb_radius,
    thumb_cy - thumb_radius,
    thumb_radius * 2.0,
    thumb_radius * 2.0,
  )
  self.draw_list.add_rect(thumb_rect, @color.Color::white(), thumb_radius)

  // Draw label text
  let text_x = rect.x + switch_w + gap
  let text_y = rect.y + (h - 14.0) * 0.5
  let text_color = if resp.hovered {
    @color.Color::white()
  } else {
    @color.Color::text_primary()
  }
  self.draw_list.add_text(
    @math.Vec2::new(text_x, text_y),
    text,
    14.0,
    text_color,
  )

  (new_state, resp)
}

///|
/// Render a compact numerical drag-value box.
/// Click and drag horizontally to smoothly adjust the value.
/// Returns a tuple of (new_value, response).
pub fn UIContext::drag_value(
  self : UIContext,
  label : String,
  value : Double,
  speed : Double,
  min : Double,
  max : Double,
) -> (Double, Response) {
  let char_w = 8.0
  let label_w = if label.length() > 0 {
    label.length().to_double() * char_w + 8.0
  } else {
    0.0
  }
  let box_w = 64.0
  let total_w = label_w + box_w
  let h = 22.0
  let (id, rect, resp) = self.allocate_space(@math.Vec2::new(total_w, h))

  let box_rect = @math.Rect::new(rect.x + label_w, rect.y, box_w, h)
  let is_hovered = box_rect.contains(self.input.mouse_pos)
  if is_hovered && self.input.mouse_pressed {
    self.set_active_id(id)
  }

  let is_active = self.active_id() == id
  let mut new_val = value

  if is_active && self.input.mouse_down {
    let delta_x = self.input.mouse_delta.x
    let step = if speed > 0.0001 { speed } else { 1.0 }
    new_val = new_val + delta_x * step
    if min < max {
      if new_val < min {
        new_val = min
      } else if new_val > max {
        new_val = max
      }
    }
  }

  // Draw Label
  if label.length() > 0 {
    self.draw_list.add_text(
      @math.Vec2::new(rect.x, rect.y + 4.0),
      label,
      13.0,
      @color.Color::text_primary(),
    )
  }

  // Draw Box Background & Stroke
  let bg_color = if is_active {
    @color.Color::bg_hover()
  } else if is_hovered {
    @color.Color::bg_surface()
  } else {
    @color.Color::bg_window()
  }

  let border_color = if is_active {
    @color.Color::accent_primary()
  } else if is_hovered {
    @color.Color::accent_hover()
  } else {
    @color.Color::border_muted()
  }

  self.draw_list.add_rect(box_rect, bg_color, 4.0)
  self.draw_list.add_rect_stroke(box_rect, border_color, 1.0, 4.0)

  // Format value to 1 decimal place or integer
  let rounded_int = (new_val * 10.0).to_int()
  let whole = rounded_int / 10
  let frac = (rounded_int % 10).abs()
  let val_str = whole.to_string() + "." + frac.to_string()

  let text_x = box_rect.x + (box_w - val_str.length().to_double() * 7.0) * 0.5
  let text_y = box_rect.y + (h - 12.0) * 0.5
  self.draw_list.add_text(
    @math.Vec2::new(text_x, text_y),
    val_str,
    12.0,
    if is_active {
      @color.Color::accent_primary()
    } else {
      @color.Color::text_primary()
    },
  )

  (new_val, resp)
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

///|
/// Render an interactive color preview button.
/// Clicking it returns clicked in response to toggle a color picker.
pub fn UIContext::color_button(
  self : UIContext,
  _id_str : String,
  color : @color.Color,
) -> (Bool, Response) {
  let size = 22.0
  let (_id, rect, resp) = self.allocate_space(@math.Vec2::new(size, size))

  let btn_rect = @math.Rect::new(rect.x, rect.y, size, size)
  let border_color = if resp.pressed {
    @color.Color::white()
  } else if resp.hovered {
    @color.Color::accent_primary()
  } else {
    @color.Color::border_muted()
  }

  // Draw color swatch
  self.draw_list.add_rect(btn_rect, color, 4.0)
  self.draw_list.add_rect_stroke(btn_rect, border_color, 1.5, 4.0)

  (resp.clicked, resp)
}

///|
/// Render an on-hover floating tooltip bubble at cursor position.
pub fn UIContext::tooltip(self : UIContext, text : String) -> Unit {
  let char_w = 7.0
  let text_w = text.length().to_double() * char_w
  let pad_x = 8.0
  let pad_y = 4.0
  let tip_w = text_w + pad_x * 2.0
  let tip_h = 22.0

  let mouse = self.input.mouse_pos
  let tip_rect = @math.Rect::new(mouse.x + 12.0, mouse.y + 12.0, tip_w, tip_h)

  // Floating bubble with dark background & subtle border
  self.draw_list.add_rect(tip_rect, @color.Color::bg_window(), 4.0)
  self.draw_list.add_rect_stroke(
    tip_rect,
    @color.Color::border_muted(),
    1.0,
    4.0,
  )
  self.draw_list.add_text(
    @math.Vec2::new(tip_rect.x + pad_x, tip_rect.y + pad_y),
    text,
    12.0,
    @color.Color::white(),
  )
}
