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
fn split_lines(text : String) -> Array[String] {
  let lines : Array[String] = []
  let mut start = 0
  let len = text.length()
  for i = 0; i < len; i = i + 1 {
    if text[i] == '\n' {
      lines.push(string_slice(text, start, i))
      start = i + 1
    }
  }
  lines.push(string_slice(text, start, len))
  lines
}

///|
fn cursor_to_line_col(text : String, cursor_pos : Int) -> (Int, Int) {
  let mut line = 0
  let mut col = 0
  let limit = if cursor_pos > text.length() {
    text.length()
  } else if cursor_pos < 0 {
    0
  } else {
    cursor_pos
  }
  for i = 0; i < limit; i = i + 1 {
    if text[i] == '\n' {
      line = line + 1
      col = 0
    } else {
      col = col + 1
    }
  }
  (line, col)
}

///|
fn line_col_to_cursor(lines : Array[String], line : Int, col : Int) -> Int {
  let num_lines = lines.length()
  if num_lines == 0 {
    return 0
  }
  let safe_line = if line < 0 {
    0
  } else if line >= num_lines {
    num_lines - 1
  } else {
    line
  }
  let mut pos = 0
  for i = 0; i < safe_line; i = i + 1 {
    pos = pos + lines[i].length() + 1
  }
  let line_len = lines[safe_line].length()
  let safe_col = if col < 0 {
    0
  } else if col > line_len {
    line_len
  } else {
    col
  }
  pos + safe_col
}

///|
fn is_comment_line(line : String) -> Bool {
  let len = line.length()
  let mut i = 0
  while i < len && (line[i] == ' ' || line[i] == '\t') {
    i = i + 1
  }
  if i + 1 < len && line[i] == '/' && line[i + 1] == '/' {
    true
  } else {
    false
  }
}

///|
fn hit_test_char_pos(
  ctx : UIContext,
  text : String,
  click_x : Double,
  font_size : Double,
) -> Int {
  let len = text.length()
  if len == 0 || click_x <= 0.0 {
    return 0
  }
  let total_w = ctx.measure_text(text, font_size).x
  if click_x >= total_w {
    return len
  }
  let boundaries : Array[Int] = [0]
  let mut idx = 0
  while idx < len {
    idx = next_char_boundary(text, idx)
    boundaries.push(idx)
  }
  let num_b = boundaries.length()
  let mut low = 0
  let mut high = num_b - 1
  while low < high {
    let mid = (low + high) / 2
    let sub = string_slice(text, 0, boundaries[mid])
    let w = ctx.measure_text(sub, font_size).x
    if w < click_x {
      low = mid + 1
    } else {
      high = mid
    }
  }
  let c1 = boundaries[low]
  let w1 = ctx.measure_text(string_slice(text, 0, c1), font_size).x
  let d1 = if click_x > w1 { click_x - w1 } else { w1 - click_x }
  if low > 0 {
    let c0 = boundaries[low - 1]
    let w0 = ctx.measure_text(string_slice(text, 0, c0), font_size).x
    let d0 = if click_x > w0 { click_x - w0 } else { w0 - click_x }
    if d0 <= d1 {
      c0
    } else {
      c1
    }
  } else {
    c1
  }
}

///|
/// Render a multi-line code and script editor in Studio Light porcelain style.
/// Features a left line-number gutter with active line highlighting,
/// monospace font baseline alignment, 2D arrow key navigation, soft Tab
/// indentation, range selection, vertical scrolling, and character clipping.
pub fn UIContext::code_editor(
  self : UIContext,
  id_salt : String,
  text : String,
  size? : @math.Vec2,
  show_line_numbers? : Bool = true,
  read_only? : Bool = false,
) -> (String, Response) {
  let default_w = if self.available_width() > 0.0 {
    self.available_width()
  } else {
    480.0
  }
  let default_h = 220.0
  let editor_size = match size {
    Some(s) => s
    None => @math.Vec2::new(default_w, default_h)
  }

  let id = self.id_stack.derive_id("code_editor::" + id_salt)
  let (_anon_id, rect, resp) = self.allocate_space(editor_size)
  if resp.hovered {
    self.set_cursor_icon("text")
  }

  self.register_focusable(id)
  if resp.pressed() || resp.clicked() {
    self.request_focus(id)
    self.reset_caret_blink()
  }
  let is_focused = self.has_focus(id)

  let mut cursor_pos = self.get_text_cursor_pos(id, text.length())
  let mut selection_anchor = self.get_text_selection_anchor(id)
  let mut current_text = text
  let mut lines = split_lines(current_text)

  let scale = self.style.scale
  let code_font_sz = self.style.code_editor_font_size * scale
  let gutter_font_sz = self.style.code_editor_gutter_font_size * scale
  let gutter_w = if show_line_numbers {
    self.style.code_editor_gutter_w * scale
  } else {
    0.0
  }
  let line_h = self.style.code_editor_line_h * scale
  let pad_top = 8.0 * scale
  let pad_code_x = 10.0 * scale

  // 1. Vertical Scrolling
  let mut scroll_y = self.get_scroll_offset(id)
  if (resp.hovered() || resp.pressed()) && self.input.scroll_delta.y != 0.0 {
    scroll_y = scroll_y - self.input.scroll_delta.y
  }
  let total_lines = lines.length()
  let content_h = pad_top * 2.0 + total_lines.to_double() * line_h
  let max_scroll = if content_h > rect.h { content_h - rect.h } else { 0.0 }

  // 2. Mouse click & drag hit testing
  let code_x = rect.x + gutter_w + pad_code_x
  let click_x = self.input.mouse_pos.x - code_x
  let my = self.input.mouse_pos.y - (rect.y + pad_top) + scroll_y
  let click_line = if my < 0.0 {
    0
  } else {
    let l = (my / line_h).to_int()
    if l >= lines.length() {
      lines.length() - 1
    } else {
      l
    }
  }
  let target_line = if click_line < 0 { 0 } else { click_line }
  let line_str = if target_line < lines.length() {
    lines[target_line]
  } else {
    ""
  }
  let target_col = hit_test_char_pos(self, line_str, click_x, code_font_sz)
  let hit_cursor = line_col_to_cursor(lines, target_line, target_col)

  if self.input.mouse_pressed && (resp.hovered() || resp.pressed()) {
    self.request_focus(id)
    self.reset_caret_blink()
    if self.input.modifiers.shift {
      if selection_anchor is None {
        selection_anchor = Some(cursor_pos)
      }
    } else {
      selection_anchor = None
    }
    cursor_pos = hit_cursor
  } else if resp.dragged() {
    if selection_anchor is None {
      selection_anchor = Some(cursor_pos)
    }
    cursor_pos = hit_cursor
  }

  // 3. Keyboard input and navigation
  if is_focused {
    if self.input.key_pressed(Key::ArrowLeft) ||
      self.input.key_pressed(Key::ArrowRight) ||
      self.input.key_pressed(Key::ArrowUp) ||
      self.input.key_pressed(Key::ArrowDown) ||
      self.input.key_pressed(Key::Home) ||
      self.input.key_pressed(Key::End) ||
      self.input.key_pressed(Key::Enter) ||
      self.input.key_pressed(Key::Tab) ||
      self.input.key_pressed(Key::Backspace) ||
      self.input.key_pressed(Key::Delete) ||
      !self.input.text_input().is_empty() {
      self.reset_caret_blink()
    }

    let shift_held = self.input.modifiers.shift
    let ctrl_held = self.input.modifiers.ctrl || self.input.modifiers.meta

    // Select All: Ctrl+A
    if ctrl_held && self.input.key_pressed(Key::A) {
      self.input.consume_key(Key::A)
      selection_anchor = Some(0)
      cursor_pos = current_text.length()
    }

    let (cur_line, cur_col) = cursor_to_line_col(current_text, cursor_pos)

    // Horizontal character navigation
    if self.input.key_pressed(Key::ArrowLeft) {
      if shift_held && selection_anchor is None {
        selection_anchor = Some(cursor_pos)
      } else if !shift_held {
        selection_anchor = None
      }
      cursor_pos = prev_char_boundary(current_text, cursor_pos)
    }
    if self.input.key_pressed(Key::ArrowRight) {
      if shift_held && selection_anchor is None {
        selection_anchor = Some(cursor_pos)
      } else if !shift_held {
        selection_anchor = None
      }
      cursor_pos = next_char_boundary(current_text, cursor_pos)
    }

    // Vertical line navigation
    if self.input.key_pressed(Key::ArrowUp) {
      if shift_held && selection_anchor is None {
        selection_anchor = Some(cursor_pos)
      } else if !shift_held {
        selection_anchor = None
      }
      if cur_line > 0 {
        cursor_pos = line_col_to_cursor(lines, cur_line - 1, cur_col)
      } else {
        cursor_pos = 0
      }
    }
    if self.input.key_pressed(Key::ArrowDown) {
      if shift_held && selection_anchor is None {
        selection_anchor = Some(cursor_pos)
      } else if !shift_held {
        selection_anchor = None
      }
      if cur_line < lines.length() - 1 {
        cursor_pos = line_col_to_cursor(lines, cur_line + 1, cur_col)
      } else {
        cursor_pos = current_text.length()
      }
    }

    // Line boundary and document boundary jumps
    if self.input.key_pressed(Key::Home) {
      if shift_held && selection_anchor is None {
        selection_anchor = Some(cursor_pos)
      } else if !shift_held {
        selection_anchor = None
      }
      if ctrl_held {
        cursor_pos = 0
      } else {
        cursor_pos = line_col_to_cursor(lines, cur_line, 0)
      }
    }
    if self.input.key_pressed(Key::End) {
      if shift_held && selection_anchor is None {
        selection_anchor = Some(cursor_pos)
      } else if !shift_held {
        selection_anchor = None
      }
      if ctrl_held {
        cursor_pos = current_text.length()
      } else {
        cursor_pos = line_col_to_cursor(
          lines,
          cur_line,
          lines[cur_line].length(),
        )
      }
    }

    if !read_only {
      // Determine active selection range
      let (has_sel, s_start, s_end) = match selection_anchor {
        Some(a) =>
          if a != cursor_pos {
            let s = if a < cursor_pos { a } else { cursor_pos }
            let e = if a > cursor_pos { a } else { cursor_pos }
            (true, s, e)
          } else {
            (false, 0, 0)
          }
        None => (false, 0, 0)
      }

      // Enter key (newline insertion)
      if self.input.key_pressed(Key::Enter) {
        self.input.consume_key(Key::Enter)
        let (insert_at, left, right) = if has_sel {
          (
            s_start,
            string_slice(current_text, 0, s_start),
            string_slice(current_text, s_end, current_text.length()),
          )
        } else {
          (
            cursor_pos,
            string_slice(current_text, 0, cursor_pos),
            string_slice(current_text, cursor_pos, current_text.length()),
          )
        }
        current_text = left + "\n" + right
        cursor_pos = insert_at + 1
        selection_anchor = None
        lines = split_lines(current_text)
      }

      // Tab key (soft indentation: 2 spaces)
      if self.input.key_pressed(Key::Tab) {
        self.input.consume_key(Key::Tab)
        let (insert_at, left, right) = if has_sel {
          (
            s_start,
            string_slice(current_text, 0, s_start),
            string_slice(current_text, s_end, current_text.length()),
          )
        } else {
          (
            cursor_pos,
            string_slice(current_text, 0, cursor_pos),
            string_slice(current_text, cursor_pos, current_text.length()),
          )
        }
        current_text = left + "  " + right
        cursor_pos = insert_at + 2
        selection_anchor = None
        lines = split_lines(current_text)
      }

      // Backspace deletion
      if self.input.key_pressed(Key::Backspace) {
        if has_sel {
          let left = string_slice(current_text, 0, s_start)
          let right = string_slice(current_text, s_end, current_text.length())
          current_text = left + right
          cursor_pos = s_start
          selection_anchor = None
          lines = split_lines(current_text)
        } else if cursor_pos > 0 && current_text.length() > 0 {
          let (new_text, new_pos) = delete_prev_char(current_text, cursor_pos)
          current_text = new_text
          cursor_pos = new_pos
          lines = split_lines(current_text)
        }
      }

      // Delete key
      if self.input.key_pressed(Key::Delete) {
        if has_sel {
          let left = string_slice(current_text, 0, s_start)
          let right = string_slice(current_text, s_end, current_text.length())
          current_text = left + right
          cursor_pos = s_start
          selection_anchor = None
          lines = split_lines(current_text)
        } else if cursor_pos < current_text.length() {
          current_text = delete_next_char(current_text, cursor_pos)
          lines = split_lines(current_text)
        }
      }

      // Text input insertion
      let input_str = self.input.text_input()
      if !input_str.is_empty() {
        let (insert_at, left, right) = if has_sel {
          (
            s_start,
            string_slice(current_text, 0, s_start),
            string_slice(current_text, s_end, current_text.length()),
          )
        } else {
          (
            cursor_pos,
            string_slice(current_text, 0, cursor_pos),
            string_slice(current_text, cursor_pos, current_text.length()),
          )
        }
        current_text = left + input_str + right
        cursor_pos = insert_at + input_str.length()
        selection_anchor = None
        lines = split_lines(current_text)
      }
    }
  }

  // 4. Auto-scroll to keep caret in view
  let (active_line, active_col) = cursor_to_line_col(current_text, cursor_pos)
  if is_focused {
    let caret_rel_y = pad_top + active_line.to_double() * line_h
    if caret_rel_y - scroll_y < pad_top {
      scroll_y = caret_rel_y - pad_top
    } else if caret_rel_y + line_h - scroll_y > rect.h - pad_top {
      scroll_y = caret_rel_y + line_h - (rect.h - pad_top)
    }
  }
  if scroll_y > max_scroll {
    scroll_y = max_scroll
  }
  if scroll_y < 0.0 {
    scroll_y = 0.0
  }
  self.set_scroll_offset(id, scroll_y)

  self.set_text_cursor_pos(id, cursor_pos)
  self.set_text_selection_anchor(id, selection_anchor)

  // 5. Active selection intervals for rendering
  let (has_selection, sel_start, sel_end) = match selection_anchor {
    Some(a) =>
      if a != cursor_pos {
        let s = if a < cursor_pos { a } else { cursor_pos }
        let e = if a > cursor_pos { a } else { cursor_pos }
        (true, s, e)
      } else {
        (false, 0, 0)
      }
    None => (false, 0, 0)
  }

  // 6. Rendering phase
  let border_col = if is_focused {
    @color.Color::border_focus()
  } else if resp.hovered() {
    @color.Color::border_strong()
  } else {
    @color.Color::border_default()
  }

  let editor_radius = self.style.code_editor_radius * scale

  // Editor frame background & border
  self.draw_list.add_rect(rect, @color.Color::bg_window(), editor_radius)
  self.draw_list.add_rect_stroke(rect, border_col, 1.0, editor_radius)

  // Scissor clip for editor interior
  let clip_rect = @math.Rect::new(
    rect.x + 1.0,
    rect.y + 1.0,
    rect.w - 2.0,
    rect.h - 2.0,
  )
  self.push_clip(clip_rect)

  // Draw Gutter
  if show_line_numbers {
    let gutter_rect = @math.Rect::new(rect.x, rect.y, gutter_w, rect.h)
    self.draw_list.add_rect(gutter_rect, @color.Color::bg_subtle(), 0.0)
    self.draw_list.add_line(
      @math.Vec2::new(rect.x + gutter_w, rect.y),
      @math.Vec2::new(rect.x + gutter_w, rect.y + rect.h),
      @color.Color::border_muted(),
      1.0,
    )
  }

  // Active Line Highlight Wash (rendered only when no range selection exists)
  if is_focused && !has_selection && active_line < lines.length() {
    let active_y = rect.y +
      pad_top +
      active_line.to_double() * line_h -
      scroll_y
    if active_y + line_h >= rect.y && active_y <= rect.y + rect.h {
      let wash_rect = @math.Rect::new(
        rect.x + gutter_w + 1.0,
        active_y,
        rect.w - gutter_w - 2.0,
        line_h,
      )
      self.draw_list.add_rect(wash_rect, @color.Color::bg_surface(), 0.0)
    }
  }

  // Selection Highlight Wash
  if has_selection {
    let mut offset = 0
    for idx = 0; idx < lines.length(); idx = idx + 1 {
      let line_len = lines[idx].length()
      let line_start = offset
      let line_end = offset + line_len
      offset = line_end + 1 // +1 for newline separator
      let o_start = if sel_start > line_start { sel_start } else { line_start }
      let o_end = if sel_end < line_end { sel_end } else { line_end }
      if o_start < o_end {
        let line_y = rect.y + pad_top + idx.to_double() * line_h - scroll_y
        if line_y + line_h >= rect.y && line_y <= rect.y + rect.h {
          let pre = string_slice(lines[idx], 0, o_start - line_start)
          let sel = string_slice(
            lines[idx],
            o_start - line_start,
            o_end - line_start,
          )
          let pre_w = self.measure_text(pre, code_font_sz).x
          let sel_w = self.measure_text(sel, code_font_sz).x
          let sel_rect = @math.Rect::new(code_x + pre_w, line_y, sel_w, line_h)
          self.draw_list.add_rect(sel_rect, @color.Color::accent_soft(), 0.0)
        }
      }
    }
  }

  // Render each visible line
  for idx = 0; idx < lines.length(); idx = idx + 1 {
    let line_text = lines[idx]
    let line_y = rect.y + pad_top + idx.to_double() * line_h - scroll_y

    // Skip lines culled above
    if line_y + line_h < rect.y {
      continue
    }
    // Stop rendering lines that fall completely below the visible clip rect
    if line_y > rect.y + rect.h {
      break
    }

    // Line number in gutter
    if show_line_numbers {
      let num_str = (idx + 1).to_string()
      let num_size = self.measure_text(num_str, gutter_font_sz)
      let num_x = rect.x + gutter_w - num_size.x - 8.0 * scale
      let num_col = if idx == active_line && is_focused {
        @color.Color::accent_primary()
      } else {
        @color.Color::text_disabled()
      }
      self.draw_list.add_text(
        @math.Vec2::new(num_x, line_y + 3.0 * scale),
        num_str,
        gutter_font_sz,
        num_col,
        font_family="monospace",
      )
    }

    // Code text
    let text_col = if is_comment_line(line_text) {
      @color.Color::text_muted()
    } else {
      @color.Color::text_primary()
    }

    self.draw_list.add_text(
      @math.Vec2::new(code_x, line_y + 3.0 * scale),
      line_text,
      code_font_sz,
      text_col,
      font_family="monospace",
    )
  }

  // Render Caret
  if is_focused && self.is_caret_visible() && active_line < lines.length() {
    let active_str = lines[active_line]
    let prefix = string_slice(active_str, 0, active_col)
    let prefix_w = self.measure_text(prefix, code_font_sz).x
    let caret_x = rect.x + gutter_w + pad_code_x + prefix_w
    let caret_y = rect.y +
      pad_top +
      active_line.to_double() * line_h -
      scroll_y +
      3.0 * scale

    if caret_y + self.style.caret_h * scale >= rect.y &&
      caret_y <= rect.y + rect.h {
      self.draw_list.add_line(
        @math.Vec2::new(caret_x, caret_y),
        @math.Vec2::new(caret_x, caret_y + self.style.caret_h * scale),
        @color.Color::accent_primary(),
        1.5 * scale,
      )
    }
  }

  // Scrollbar thumb indicator
  if max_scroll > 0.0 && content_h > 0.0 {
    let bar_w = 4.0 * scale
    let bar_x = rect.x + rect.w - bar_w - 2.0 * scale
    let track_h = rect.h - 4.0 * scale
    let thumb_ratio = rect.h / content_h
    let raw_thumb_h = track_h * thumb_ratio
    let thumb_h = if raw_thumb_h < 20.0 * scale {
      20.0 * scale
    } else {
      raw_thumb_h
    }
    let scroll_ratio = scroll_y / max_scroll
    let thumb_y = rect.y + 2.0 * scale + (track_h - thumb_h) * scroll_ratio
    let thumb_rect = @math.Rect::new(bar_x, thumb_y, bar_w, thumb_h)
    self.draw_list.add_rect(
      thumb_rect,
      @color.Color::border_default(),
      self.style.radius_sm * scale,
    )
  }

  self.pop_clip()

  let editor_resp = Response::with_focus(
    id,
    rect,
    resp.hovered,
    resp.clicked,
    resp.pressed,
    resp.dragged,
    is_focused,
    is_focused && self.prev_focused_id() != id,
    self.lost_focus(id),
    secondary_clicked=resp.secondary_clicked,
  )

  (current_text, editor_resp)
}
