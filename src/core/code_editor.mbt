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
/// Render a multi-line code and script editor in Studio Light porcelain style.
/// Features a left line-number gutter with active line highlighting,
/// monospace font baseline alignment, 2D arrow key navigation, soft Tab
/// indentation, and character clipping.
pub fn UIContext::code_editor(
  self : UIContext,
  id_salt : String,
  text : String,
  size? : @math.Vec2,
  show_line_numbers? : Bool = true,
  read_only? : Bool = false,
) -> (String, Response) {
  let default_w = if self.available_width > 0.0 {
    self.available_width
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
  let mut current_text = text
  let lines = split_lines(current_text)

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
    let (cur_line, cur_col) = cursor_to_line_col(current_text, cursor_pos)

    // Horizontal character navigation
    if self.input.key_pressed(Key::ArrowLeft) {
      if cursor_pos > 0 {
        cursor_pos = cursor_pos - 1
      }
    }
    if self.input.key_pressed(Key::ArrowRight) {
      if cursor_pos < current_text.length() {
        cursor_pos = cursor_pos + 1
      }
    }

    // Vertical line navigation
    if self.input.key_pressed(Key::ArrowUp) {
      if cur_line > 0 {
        cursor_pos = line_col_to_cursor(lines, cur_line - 1, cur_col)
      } else {
        cursor_pos = 0
      }
    }
    if self.input.key_pressed(Key::ArrowDown) {
      if cur_line < lines.length() - 1 {
        cursor_pos = line_col_to_cursor(lines, cur_line + 1, cur_col)
      } else {
        cursor_pos = current_text.length()
      }
    }

    // Line boundary jumps
    if self.input.key_pressed(Key::Home) {
      cursor_pos = line_col_to_cursor(lines, cur_line, 0)
    }
    if self.input.key_pressed(Key::End) {
      cursor_pos = line_col_to_cursor(lines, cur_line, lines[cur_line].length())
    }

    if !read_only {
      // Enter key (newline insertion)
      if self.input.key_pressed(Key::Enter) {
        let left = string_slice(current_text, 0, cursor_pos)
        let right = string_slice(
          current_text,
          cursor_pos,
          current_text.length(),
        )
        current_text = left + "\n" + right
        cursor_pos = cursor_pos + 1
      }

      // Tab key (soft indentation: 2 spaces)
      if self.input.key_pressed(Key::Tab) {
        let left = string_slice(current_text, 0, cursor_pos)
        let right = string_slice(
          current_text,
          cursor_pos,
          current_text.length(),
        )
        current_text = left + "  " + right
        cursor_pos = cursor_pos + 2
      }

      // Backspace deletion
      if self.input.key_pressed(Key::Backspace) {
        if cursor_pos > 0 && current_text.length() > 0 {
          let left = string_slice(current_text, 0, cursor_pos - 1)
          let right = string_slice(
            current_text,
            cursor_pos,
            current_text.length(),
          )
          current_text = left + right
          cursor_pos = cursor_pos - 1
        }
      }

      // Delete key
      if self.input.key_pressed(Key::Delete) {
        if cursor_pos < current_text.length() {
          let left = string_slice(current_text, 0, cursor_pos)
          let right = string_slice(
            current_text,
            cursor_pos + 1,
            current_text.length(),
          )
          current_text = left + right
        }
      }

      // Text input insertion
      let input_str = self.input.text_input()
      if !input_str.is_empty() {
        let left = string_slice(current_text, 0, cursor_pos)
        let right = string_slice(
          current_text,
          cursor_pos,
          current_text.length(),
        )
        current_text = left + input_str + right
        cursor_pos = cursor_pos + input_str.length()
      }
    }
  }

  self.set_text_cursor_pos(id, cursor_pos)

  // 2. Rendering phase
  let border_col = if is_focused {
    @color.Color::border_focus()
  } else if resp.hovered() {
    @color.Color::border_strong()
  } else {
    @color.Color::border_default()
  }

  // Editor frame background & border
  self.draw_list.add_rect(rect, @color.Color::white(), 6.0)
  self.draw_list.add_rect_stroke(rect, border_col, 1.0, 6.0)

  // Scissor clip for editor interior
  let clip_rect = @math.Rect::new(
    rect.x + 1.0,
    rect.y + 1.0,
    rect.w - 2.0,
    rect.h - 2.0,
  )
  self.push_clip(clip_rect)

  let render_lines = split_lines(current_text)
  let (active_line, active_col) = cursor_to_line_col(current_text, cursor_pos)

  let gutter_w = if show_line_numbers { 38.0 } else { 0.0 }
  let line_h = 20.0
  let pad_top = 8.0
  let pad_code_x = 10.0

  // Draw Gutter
  if show_line_numbers {
    let gutter_rect = @math.Rect::new(rect.x, rect.y, gutter_w, rect.h)
    self.draw_list.add_rect(gutter_rect, @color.Color::hex(0xF8FAFC), 0.0)
    self.draw_list.add_line(
      @math.Vec2::new(rect.x + gutter_w, rect.y),
      @math.Vec2::new(rect.x + gutter_w, rect.y + rect.h),
      @color.Color::border_muted(),
      1.0,
    )
  }

  // Active Line Highlight Wash
  if is_focused && active_line < render_lines.length() {
    let active_y = rect.y + pad_top + active_line.to_double() * line_h
    let wash_rect = @math.Rect::new(
      rect.x + gutter_w + 1.0,
      active_y,
      rect.w - gutter_w - 2.0,
      line_h,
    )
    self.draw_list.add_rect(wash_rect, @color.Color::hex(0xF1F5F9), 0.0)
  }

  // Render each line
  for idx = 0; idx < render_lines.length(); idx = idx + 1 {
    let line_text = render_lines[idx]
    let line_y = rect.y + pad_top + idx.to_double() * line_h

    // Stop rendering lines that fall completely below the visible clip rect
    if line_y > rect.y + rect.h {
      break
    }

    // Line number in gutter
    if show_line_numbers {
      let num_str = (idx + 1).to_string()
      let num_size = self.measure_text(num_str, 11.0)
      let num_x = rect.x + gutter_w - num_size.x - 8.0
      let num_col = if idx == active_line && is_focused {
        @color.Color::accent_primary()
      } else {
        @color.Color::text_disabled()
      }
      self.draw_list.add_text(
        @math.Vec2::new(num_x, line_y + 3.0),
        num_str,
        11.0,
        num_col,
      )
    }

    // Code text
    let code_x = rect.x + gutter_w + pad_code_x
    let text_col = if is_comment_line(line_text) {
      @color.Color::text_muted()
    } else {
      @color.Color::text_primary()
    }

    self.draw_list.add_text(
      @math.Vec2::new(code_x, line_y + 3.0),
      line_text,
      12.5,
      text_col,
    )
  }

  // Render Caret
  if is_focused &&
    self.is_caret_visible() &&
    active_line < render_lines.length() {
    let active_str = render_lines[active_line]
    let prefix = string_slice(active_str, 0, active_col)
    let prefix_w = self.measure_text(prefix, 12.5).x
    let caret_x = rect.x + gutter_w + pad_code_x + prefix_w
    let caret_y = rect.y + pad_top + active_line.to_double() * line_h + 3.0

    self.draw_list.add_line(
      @math.Vec2::new(caret_x, caret_y),
      @math.Vec2::new(caret_x, caret_y + 14.0),
      @color.Color::accent_primary(),
      1.5,
    )
  }

  self.pop_clip()

  (current_text, resp)
}
