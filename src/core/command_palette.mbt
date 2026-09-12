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
pub struct CommandItem {
  id : String
  title : String
  category : String
  shortcut : String
} derive(Eq, Debug)

///|
pub fn CommandItem::new(
  id : String,
  title : String,
  category? : String = "",
  shortcut? : String = "",
) -> CommandItem {
  { id, title, category, shortcut, }
}

///|
pub struct CommandPaletteResponse {
  open : Bool
  selected_id : String?
  query : String
  selected_index : Int
} derive(Eq, Debug)

///|
fn char_code_to_lower(code : Int) -> Int {
  if code >= 65 && code <= 90 {
    code + 32
  } else {
    code
  }
}

///|
fn string_contains_ignore_case(haystack : String, needle : String) -> Bool {
  let n_len = needle.length()
  let h_len = haystack.length()
  if n_len == 0 {
    return true
  }
  if n_len > h_len {
    return false
  }
  for i = 0; i <= h_len - n_len; i = i + 1 {
    let mut matched = true
    for j = 0; j < n_len; j = j + 1 {
      let hc = char_code_to_lower(haystack[i + j].to_int())
      let nc = char_code_to_lower(needle[j].to_int())
      if hc != nc {
        matched = false
        break
      }
    }
    if matched {
      return true
    }
  }
  false
}

///|
/// Render a global command palette modal in Studio Light porcelain style.
/// Supports backdrop dimming, live query filtering, arrow key navigation,
/// enter selection, and pointer click dismissal.
pub fn UIContext::command_palette(
  self : UIContext,
  open : Bool,
  query : String,
  commands : Array[CommandItem],
  selected_index? : Int = 0,
) -> CommandPaletteResponse {
  if !open {
    return { open: false, selected_id: None, query, selected_index, }
  }

  // 1. Text input & query update
  let mut new_query = query
  let mut new_selected_index = selected_index

  if self.input.key_pressed(Key::Backspace) {
    self.reset_caret_blink()
    let len = new_query.length()
    if len > 0 {
      new_query = string_slice(new_query, 0, len - 1)
    }
  }

  let text_in = self.input.text_input()
  if !text_in.is_empty() {
    self.reset_caret_blink()
    new_query = new_query + text_in
  }

  if new_query != query {
    new_selected_index = 0
  }

  // 2. Filter commands
  let filtered : Array[CommandItem] = []
  for item in commands {
    if new_query.is_empty() ||
      string_contains_ignore_case(item.title, new_query) ||
      string_contains_ignore_case(item.category, new_query) {
      filtered.push(item)
    }
  }
  let filtered_count = filtered.length()

  // 3. Keyboard navigation
  if filtered_count > 0 {
    if new_selected_index >= filtered_count {
      new_selected_index = filtered_count - 1
    }
    if new_selected_index < 0 {
      new_selected_index = 0
    }
    if self.input.key_pressed(Key::ArrowDown) {
      new_selected_index = (new_selected_index + 1) % filtered_count
    }
    if self.input.key_pressed(Key::ArrowUp) {
      new_selected_index = if new_selected_index <= 0 {
        filtered_count - 1
      } else {
        new_selected_index - 1
      }
    }
  } else {
    new_selected_index = 0
  }

  // 4. Escape & Enter dismissal
  if self.input.key_pressed(Key::Escape) {
    return {
      open: false,
      selected_id: None,
      query: new_query,
      selected_index: new_selected_index,
    }
  }

  if self.input.key_pressed(Key::Enter) {
    let sel = if filtered_count > 0 && new_selected_index < filtered_count {
      Some(filtered[new_selected_index].id)
    } else {
      None
    }
    return {
      open: false,
      selected_id: sel,
      query: new_query,
      selected_index: new_selected_index,
    }
  }

  // 5. Layout & geometry
  let scale = self.style.scale
  let font_sm = self.style.font_small * scale
  let font_nm = self.style.font_normal * scale
  let font_lg = self.style.font_large * scale
  let card_radius = self.style.command_palette_radius * scale
  let row_radius = self.style.radius_sm * scale

  let viewport_w = if self.available_width > 0.0 {
    self.available_width
  } else {
    800.0
  }
  let viewport_h = 800.0
  let scrim_rect = @math.Rect::new(0.0, 0.0, viewport_w, viewport_h)

  let default_palette_w = self.style.command_palette_w * scale
  let card_w = if viewport_w < default_palette_w + 20.0 * scale {
    viewport_w - 32.0 * scale
  } else {
    default_palette_w
  }
  let card_x = (viewport_w - card_w) * 0.5
  let card_y = 64.0 * scale
  let header_h = self.style.command_palette_header_h * scale
  let footer_h = self.style.command_palette_footer_h * scale
  let row_h = self.style.command_palette_row_h * scale
  let cat_h = 24.0 * scale

  let mut content_h = 0.0
  let mut prev_cat = ""
  if filtered_count == 0 {
    content_h = 48.0 * scale
  } else {
    for item in filtered {
      if !item.category.is_empty() && item.category != prev_cat {
        content_h = content_h + cat_h
        prev_cat = item.category
      }
      content_h = content_h + row_h
    }
  }

  let max_content_h = 320.0 * scale
  let visible_content_h = if content_h > max_content_h {
    max_content_h
  } else {
    content_h
  }
  let card_h = header_h + visible_content_h + footer_h + 12.0 * scale
  let card_rect = @math.Rect::new(card_x, card_y, card_w, card_h)

  // Scroll offset tracking
  let content_clip_rect = @math.Rect::new(
    card_x,
    card_y + header_h,
    card_w,
    visible_content_h + 12.0 * scale,
  )
  let scroll_id = self.id_stack.derive_id("cmd_palette_scroll")
  let mut scroll_y = self.get_scroll_offset(scroll_id)
  let max_scroll = if content_h > visible_content_h {
    content_h - visible_content_h
  } else {
    0.0
  }
  if self.is_hovered(content_clip_rect) && self.input.scroll_delta.y != 0.0 {
    scroll_y = scroll_y - self.input.scroll_delta.y
  }
  let selected_top = new_selected_index.to_double() * row_h
  if selected_top < scroll_y {
    scroll_y = selected_top
  } else if selected_top + row_h > scroll_y + visible_content_h {
    scroll_y = selected_top + row_h - visible_content_h
  }
  if scroll_y < 0.0 {
    scroll_y = 0.0
  }
  if scroll_y > max_scroll {
    scroll_y = max_scroll
  }
  self.set_scroll_offset(scroll_id, scroll_y)

  // Block hover on underlying canvas
  self.block_hover(scrim_rect)

  // Outside click dismissal
  if self.input.mouse_pressed && !card_rect.contains(self.input.mouse_pos) {
    return {
      open: false,
      selected_id: None,
      query: new_query,
      selected_index: new_selected_index,
    }
  }

  // Layout metrics & elevation offsets
  let row_pad_x = row_radius * scale
  let row_w = card_w - row_pad_x * 2.0
  let elevation_key_y = 8.0 * scale
  let elevation_ambient_y = 2.0 * scale

  // Mouse hover & click on item rows
  let mut cur_row_y = card_y + header_h + row_pad_x - scroll_y
  let mut prev_row_cat = ""
  let mut clicked_id : String? = None

  for idx = 0; idx < filtered_count; idx = idx + 1 {
    let item = filtered[idx]
    if !item.category.is_empty() && item.category != prev_row_cat {
      cur_row_y = cur_row_y + cat_h
      prev_row_cat = item.category
    }
    let row_rect = @math.Rect::new(card_x + row_pad_x, cur_row_y, row_w, row_h)
    if content_clip_rect.contains(self.input.mouse_pos) &&
      row_rect.contains(self.input.mouse_pos) {
      self.set_cursor_icon("pointer")
      new_selected_index = idx
      if self.input.mouse_pressed {
        clicked_id = Some(item.id)
      }
    }
    cur_row_y = cur_row_y + row_h
  }

  if clicked_id is Some(id) {
    return {
      open: false,
      selected_id: Some(id),
      query: new_query,
      selected_index: new_selected_index,
    }
  }

  // 6. Rendering into foreground layer
  self.begin_foreground()

  // Semi-transparent backdrop scrim
  self.draw_list.add_rect(scrim_rect, @color.Color::bg_scrim(), 0.0)

  // Drop shadows
  self.draw_list.add_rect(
    @math.Rect::new(card_x, card_y + elevation_key_y, card_w, card_h),
    @color.Color::shadow_key(),
    card_radius,
  )
  self.draw_list.add_rect(
    @math.Rect::new(card_x, card_y + elevation_ambient_y, card_w, card_h),
    @color.Color::shadow_ambient(),
    card_radius,
  )

  // Porcelain card surface and border
  self.draw_list.add_rect(card_rect, @color.Color::bg_window(), card_radius)
  self.draw_list.add_rect_stroke(
    card_rect,
    @color.Color::border_default(),
    1.0,
    card_radius,
  )

  // Search prompt icon '>'
  self.draw_list.add_text(
    @math.Vec2::new(card_x + 16.0 * scale, card_y + 14.0 * scale),
    ">",
    font_lg,
    @color.Color::accent_primary(),
  )

  // Search input text or placeholder
  if new_query.is_empty() {
    self.draw_list.add_text(
      @math.Vec2::new(card_x + 36.0 * scale, card_y + 16.0 * scale),
      "键入命令或搜索动作...",
      font_nm,
      @color.Color::text_muted(),
    )
  } else {
    self.draw_list.add_text(
      @math.Vec2::new(card_x + 36.0 * scale, card_y + 16.0 * scale),
      new_query,
      font_nm,
      @color.Color::text_primary(),
    )
    let q_size = self.measure_text(new_query, font_nm)
    let caret_x = card_x + 36.0 * scale + q_size.x + 2.0 * scale
    if self.is_caret_visible() {
      self.draw_list.add_line(
        @math.Vec2::new(caret_x, card_y + 16.0 * scale),
        @math.Vec2::new(caret_x, card_y + 31.0 * scale),
        @color.Color::accent_primary(),
        1.5,
      )
    }
  }

  // Right Esc badge
  let esc_w = 32.0 * scale
  let esc_h = 18.0 * scale
  let esc_x = card_x + card_w - esc_w - 14.0 * scale
  let esc_y = card_y + 14.0 * scale
  let esc_rect = @math.Rect::new(esc_x, esc_y, esc_w, esc_h)
  self.draw_list.add_rect(esc_rect, @color.Color::bg_surface(), row_radius)
  self.draw_list.add_rect_stroke(
    esc_rect,
    @color.Color::border_muted(),
    1.0,
    row_radius,
  )
  self.draw_list.add_text(
    @math.Vec2::new(esc_x + 6.0 * scale, esc_y + 3.0 * scale),
    "Esc",
    font_sm,
    @color.Color::text_muted(),
  )

  // Hairline divider below search bar
  self.draw_list.add_line(
    @math.Vec2::new(card_x, card_y + header_h),
    @math.Vec2::new(card_x + card_w, card_y + header_h),
    @color.Color::border_muted(),
    1.0,
  )

  // Results Stream
  self.push_clip(content_clip_rect)
  let mut draw_y = card_y + header_h + row_pad_x - scroll_y
  let mut prev_draw_cat = ""

  if filtered_count == 0 {
    let empty_text_y = draw_y + (48.0 * scale - font_nm) * 0.5
    self.draw_list.add_text(
      @math.Vec2::new(card_x + 20.0 * scale, empty_text_y),
      "未找到匹配命令",
      font_nm,
      @color.Color::text_muted(),
    )
  } else {
    let indicator_h = 20.0 * scale
    let indicator_w = 3.0 * scale
    let text_pad_left = card_x + row_pad_x + 12.0 * scale

    for idx = 0; idx < filtered_count; idx = idx + 1 {
      let item = filtered[idx]
      if !item.category.is_empty() && item.category != prev_draw_cat {
        let cat_y = draw_y + (cat_h - font_sm) * 0.5
        self.draw_list.add_text(
          @math.Vec2::new(card_x + 16.0 * scale, cat_y),
          item.category,
          font_sm,
          @color.Color::text_muted(),
        )
        draw_y = draw_y + cat_h
        prev_draw_cat = item.category
      }

      let row_rect = @math.Rect::new(card_x + row_pad_x, draw_y, row_w, row_h)
      let is_selected = idx == new_selected_index
      let text_y = draw_y + (row_h - font_nm) * 0.5

      if is_selected {
        self.draw_list.add_rect(
          row_rect,
          @color.Color::tree_row_selected(),
          row_radius,
        )
        let indicator_y = draw_y + (row_h - indicator_h) * 0.5
        self.draw_list.add_rect(
          @math.Rect::new(
            card_x + row_pad_x,
            indicator_y,
            indicator_w,
            indicator_h,
          ),
          @color.Color::accent_primary(),
          indicator_w * 0.5,
        )
        self.draw_list.add_text(
          @math.Vec2::new(text_pad_left, text_y),
          item.title,
          font_nm,
          @color.Color::text_primary(),
        )
      } else {
        self.draw_list.add_text(
          @math.Vec2::new(text_pad_left, text_y),
          item.title,
          font_nm,
          @color.Color::text_body(),
        )
      }

      if !item.shortcut.is_empty() {
        let sc_size = self.measure_text(item.shortcut, font_sm)
        let sc_x = card_x + card_w - sc_size.x - 20.0 * scale
        let sc_y = draw_y + (row_h - font_sm) * 0.5
        self.draw_list.add_text(
          @math.Vec2::new(sc_x, sc_y),
          item.shortcut,
          font_sm,
          @color.Color::text_muted(),
        )
      }

      draw_y = draw_y + row_h
    }
  }
  self.pop_clip()

  // Footer bar
  let footer_y = card_y + card_h - footer_h
  let footer_rect = @math.Rect::new(card_x, footer_y, card_w, footer_h)
  self.draw_list.add_rect(footer_rect, @color.Color::bg_surface(), card_radius)
  self.draw_list.add_line(
    @math.Vec2::new(card_x, footer_y),
    @math.Vec2::new(card_x + card_w, footer_y),
    @color.Color::border_muted(),
    1.0,
  )
  self.draw_list.add_text(
    @math.Vec2::new(card_x + 16.0 * scale, footer_y + 8.0 * scale),
    "↑↓ 导航   ↵ 选择   Esc 退出",
    font_sm,
    @color.Color::text_muted(),
  )

  self.end_foreground()

  {
    open: true,
    selected_id: None,
    query: new_query,
    selected_index: new_selected_index,
  }
}
