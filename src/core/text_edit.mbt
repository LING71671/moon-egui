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
  if resp.hovered {
    self.set_cursor_icon("text")
  }
  let scale = self.style.scale
  let padding_x = self.style.text_edit_pad_x * scale
  let font_size = self.style.font_normal * scale
  let caret_h = self.style.caret_h * scale
  let radius = self.style.text_edit_radius * scale

  // Manage cursor position stored in UIContext
  let mut cursor_pos = self.get_text_cursor_pos(id, text.length())
  let mut current_text = text

  if resp.pressed() || resp.clicked() {
    self.request_focus(id)
  }
  if self.input.mouse_pressed && (resp.hovered() || resp.pressed()) {
    let click_x = self.input.mouse_pos.x - (rect.x + padding_x)
    let total_text_w = measure_text_size(current_text, font_size).x
    if click_x <= 0.0 {
      cursor_pos = 0
    } else if click_x >= total_text_w {
      cursor_pos = current_text.length()
    } else {
      let mut best_i = 0
      let mut best_dist = click_x
      for i = 1; i <= current_text.length(); i = i + 1 {
        let sub = string_slice(current_text, 0, i)
        let w = measure_text_size(sub, font_size).x
        let dist = if click_x > w { click_x - w } else { w - click_x }
        if dist < best_dist {
          best_dist = dist
          best_i = i
        }
      }
      cursor_pos = best_i
    }
  }
  let is_focused = self.has_focus(id)

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

  // Rendering in Studio Light
  let bg_color = @color.Color::white()

  let border_color = if is_focused {
    @color.Color::accent_primary()
  } else if resp.hovered() {
    @color.Color::border_strong()
  } else {
    @color.Color::border_default()
  }

  let border_width = if is_focused { 1.5 } else { 1.0 }

  // Draw background and border
  self.draw_list.add_rect(rect, bg_color, radius)
  self.draw_list.add_rect_stroke(rect, border_color, border_width, radius)

  // Scissor clip for text inside input box
  let inner_clip = @math.Rect::new(
    rect.x + padding_x - 2.0,
    rect.y,
    rect.w - (padding_x * 2.0 - 4.0),
    rect.h,
  )
  self.push_clip(inner_clip)

  let text_y = rect.y + (rect.h - font_size) * 0.5

  if current_text.is_empty() {
    if !placeholder.is_empty() {
      self.draw_list.add_text(
        @math.Vec2::new(rect.x + padding_x, text_y),
        placeholder,
        font_size,
        @color.Color::text_disabled(),
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

  // Draw blinking/solid cursor caret when focused (Cobalt blue in Studio Light)
  if is_focused {
    let sub = string_slice(current_text, 0, cursor_pos)
    let measured_prefix = measure_text_size(sub, font_size)
    let caret_x = rect.x + padding_x + measured_prefix.x
    let caret_top = rect.y + (rect.h - caret_h) * 0.5
    let caret_bottom = caret_top + caret_h
    self.draw_list.add_line(
      @math.Vec2::new(caret_x, caret_top),
      @math.Vec2::new(caret_x, caret_bottom),
      @color.Color::accent_primary(),
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
  let default_w = 200.0 * self.style.scale
  let w = if self.available_width > default_w {
    default_w
  } else {
    self.available_width
  }
  let h = self.style.text_edit_h * self.style.scale
  self.text_edit_sized(id_salt, text, placeholder, @math.Vec2::new(w, h))
}
