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
fn string_slice(s : String, start : Int, end : Int) -> String {
  let len = s.length()
  let safe_start = if start < 0 { 0 } else if start > len { len } else { start }
  let safe_end = if end < safe_start {
    safe_start
  } else if end > len {
    len
  } else {
    end
  }
  s[safe_start:safe_end].to_owned()
}

///|
pub fn UIContext::text_edit_sized(
  self : UIContext,
  id_salt : String,
  text : String,
  placeholder : String,
  size : @math.Vec2,
) -> (String, Response) {
  self.push_id(id_salt)
  let (id, rect, resp) = self.allocate_space(size)
  self.pop_id()

  self.register_focusable(id)
  if resp.pressed() || resp.clicked() {
    self.request_focus(id)
  }
  let is_focused = self.has_focus(id)

  // Manage cursor position stored in UIContext
  let mut cursor_pos = self.get_text_cursor_pos(id, text.length())

  let mut current_text = text

  if is_focused {
    // Navigation keys
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
    if self.input.key_pressed(Key::Home) {
      cursor_pos = 0
    }
    if self.input.key_pressed(Key::End) {
      cursor_pos = current_text.length()
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

    // Delete key deletion
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
      let right = string_slice(current_text, cursor_pos, current_text.length())
      current_text = left + input_str + right
      cursor_pos = cursor_pos + input_str.length()
    }
  }

  self.set_text_cursor_pos(id, cursor_pos)

  // Rendering
  let bg_color = if is_focused {
    @color.Color::bg_surface()
  } else if resp.hovered() {
    @color.Color::bg_hover()
  } else {
    @color.Color::bg_surface()
  }

  let border_color = if is_focused {
    @color.Color::accent_primary()
  } else if resp.hovered() {
    @color.Color::accent_hover()
  } else {
    @color.Color::border_muted()
  }

  let border_width = if is_focused { 1.5 } else { 1.0 }

  // Draw background and border
  self.draw_list.add_rect(rect, bg_color, 4.0)
  self.draw_list.add_rect_stroke(rect, border_color, border_width, 4.0)

  // Scissor clip for text inside input box
  let padding_x = 8.0
  let inner_clip = @math.Rect::new(
    rect.x + padding_x - 2.0,
    rect.y,
    rect.w - (padding_x * 2.0 - 4.0),
    rect.h,
  )
  self.push_clip(inner_clip)

  let font_size = 13.0
  let text_y = rect.y + (rect.h - font_size * 1.25) * 0.5

  if current_text.is_empty() {
    if !placeholder.is_empty() {
      self.draw_list.add_text(
        @math.Vec2::new(rect.x + padding_x, text_y),
        placeholder,
        font_size,
        @color.Color::text_muted(),
      )
    }
  } else {
    self.draw_list.add_text(
      @math.Vec2::new(rect.x + padding_x, text_y),
      current_text,
      font_size,
      @color.Color::text_primary(),
    )
  }

  // Draw blinking/solid cursor caret when focused
  if is_focused {
    let sub = string_slice(current_text, 0, cursor_pos)
    let measured_prefix = measure_text_size(sub, font_size)
    let caret_x = rect.x + padding_x + measured_prefix.x
    let caret_top = rect.y + 6.0
    let caret_bottom = rect.y + rect.h - 6.0
    self.draw_list.add_line(
      @math.Vec2::new(caret_x, caret_top),
      @math.Vec2::new(caret_x, caret_bottom),
      @color.Color::white(),
      1.5,
    )
  }

  self.pop_clip()

  (current_text, resp)
}

///|
pub fn UIContext::text_edit(
  self : UIContext,
  id_salt : String,
  text : String,
  placeholder : String,
) -> (String, Response) {
  let w = if self.available_width > 200.0 {
    200.0
  } else {
    self.available_width
  }
  let h = 32.0
  self.text_edit_sized(id_salt, text, placeholder, @math.Vec2::new(w, h))
}
