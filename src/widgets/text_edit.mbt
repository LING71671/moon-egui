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
/// Standalone single-line text input widget supporting fluent configuration.
pub struct TextEdit {
  id_salt : String
  text : String
  placeholder : String
  size : @math.Vec2
} derive(Eq, Debug)

///|
/// Create a new text edit widget with initial text.
pub fn TextEdit::new(id_salt : String, text : String) -> TextEdit {
  { id_salt, text, placeholder: "", size: @math.Vec2::zero(), }
}

///|
/// Configure placeholder text shown when the input field is empty.
pub fn TextEdit::placeholder(self : TextEdit, placeholder : String) -> TextEdit {
  { ..self, placeholder, }
}

///|
/// Explicitly override the text edit dimensions.
pub fn TextEdit::size(self : TextEdit, size : @math.Vec2) -> TextEdit {
  { ..self, size, }
}

///|
/// Reference-bound text edit widget for uniform `ui.add(...)` dispatch.
pub struct TextEditRef {
  id_salt : String
  target : Ref[String]
  placeholder : String
  size : @math.Vec2
}

///|
/// Create a text edit bound directly to a `Ref[String]` variable.
pub fn TextEdit::from_ref(
  id_salt : String,
  target : Ref[String],
) -> TextEditRef {
  { id_salt, target, placeholder: "", size: @math.Vec2::zero(), }
}

///|
/// Configure placeholder text for reference-bound text edit.
pub fn TextEditRef::placeholder(
  self : TextEditRef,
  placeholder : String,
) -> TextEditRef {
  { ..self, placeholder, }
}

///|
/// Explicitly override the dimensions for reference-bound text edit.
pub fn TextEditRef::size(self : TextEditRef, size : @math.Vec2) -> TextEditRef {
  { ..self, size, }
}

///|
/// Render the reference-bound text edit into the provided UIContext.
pub impl @core.Widget for TextEditRef with fn ui(self, ctx : UIContext) -> Response {
  let (new_text, resp) = if self.size.x > 0.0 && self.size.y > 0.0 {
    text_edit_sized(
      ctx,
      self.id_salt,
      self.target.val,
      self.placeholder,
      self.size,
    )
  } else {
    text_edit_val(
      ctx,
      self.id_salt,
      self.target.val,
      placeholder=self.placeholder,
    )
  }
  self.target.val = new_text
  resp
}

///|
/// Render a single-line text input with explicit dimensions in Studio Light porcelain style.
pub fn text_edit_sized(
  ctx : UIContext,
  id_salt : String,
  text : String,
  placeholder : String,
  size : @math.Vec2,
) -> (String, Response) {
  ctx.push_id(id_salt)
  let (id, rect, resp) = ctx.allocate_space(size)
  ctx.pop_id()

  ctx.register_focusable(id)
  if resp.hovered {
    ctx.set_cursor_icon("text")
  }
  let scale = ctx.style.scale
  let padding_x = (ctx.style.spacing_sm + ctx.style.radius_xs) * scale
  let font_size = ctx.style.font_normal * scale
  let caret_h = ctx.style.spacing_lg * scale
  let radius = ctx.style.radius_md * scale

  let mut cursor_pos = ctx.get_text_cursor_pos(id, text.length())
  let mut current_text = text

  if resp.pressed() || resp.clicked() {
    ctx.request_focus(id)
    ctx.reset_caret_blink()
  }
  if ctx.input.mouse_pressed && (resp.hovered() || resp.pressed()) {
    ctx.reset_caret_blink()
    let click_x = ctx.input.mouse_pos.x - (rect.x + padding_x)
    let total_text_w = ctx.measure_text(current_text, font_size).x
    if click_x <= 0.0 {
      cursor_pos = 0
    } else if click_x >= total_text_w {
      cursor_pos = current_text.length()
    } else {
      let mut best_i = 0
      let mut best_dist = click_x
      let mut i = 0
      while i <= current_text.length() {
        let sub = @core.string_slice(current_text, 0, i)
        let w = ctx.measure_text(sub, font_size).x
        let dist = if click_x > w { click_x - w } else { w - click_x }
        if dist < best_dist {
          best_dist = dist
          best_i = i
        }
        if i >= current_text.length() {
          break
        }
        i = @core.next_char_boundary(current_text, i)
      }
      cursor_pos = best_i
    }
  }
  let is_focused = ctx.has_focus(id)

  if is_focused {
    if ctx.input.key_pressed(Key::ArrowLeft) ||
      ctx.input.key_pressed(Key::ArrowRight) ||
      ctx.input.key_pressed(Key::Home) ||
      ctx.input.key_pressed(Key::End) ||
      ctx.input.key_pressed(Key::Backspace) ||
      ctx.input.key_pressed(Key::Delete) ||
      !ctx.input.text_input().is_empty() {
      ctx.reset_caret_blink()
    }

    if ctx.input.key_pressed(Key::ArrowLeft) {
      cursor_pos = @core.prev_char_boundary(current_text, cursor_pos)
    }
    if ctx.input.key_pressed(Key::ArrowRight) {
      cursor_pos = @core.next_char_boundary(current_text, cursor_pos)
    }
    if ctx.input.key_pressed(Key::Home) {
      cursor_pos = 0
    }
    if ctx.input.key_pressed(Key::End) {
      cursor_pos = current_text.length()
    }

    if ctx.input.key_pressed(Key::Backspace) {
      if cursor_pos > 0 && current_text.length() > 0 {
        let (new_text, new_pos) = @core.delete_prev_char(
          current_text, cursor_pos,
        )
        current_text = new_text
        cursor_pos = new_pos
      }
    }

    if ctx.input.key_pressed(Key::Delete) {
      if cursor_pos < current_text.length() {
        current_text = @core.delete_next_char(current_text, cursor_pos)
      }
    }

    let input_str = ctx.input.text_input()
    if !input_str.is_empty() {
      let left = @core.string_slice(current_text, 0, cursor_pos)
      let right = @core.string_slice(
        current_text,
        cursor_pos,
        current_text.length(),
      )
      current_text = left + input_str + right
      cursor_pos = cursor_pos + input_str.length()
    }
  }

  ctx.set_text_cursor_pos(id, cursor_pos)

  let bg_color = @color.Color::bg_window()
  let border_color = if is_focused {
    @color.Color::accent_primary()
  } else if resp.hovered() {
    @color.Color::border_strong()
  } else {
    @color.Color::border_default()
  }

  let border_width = if is_focused { 1.5 } else { 1.0 }

  ctx.painter().add_rect(rect, bg_color, radius)
  ctx.painter().add_rect_stroke(rect, border_color, border_width, radius)

  let inner_clip = @math.Rect::new(
    rect.x + padding_x - 2.0,
    rect.y,
    rect.w - (padding_x * 2.0 - 4.0),
    rect.h,
  )
  ctx.push_clip(inner_clip)

  let text_y = rect.y + (rect.h - font_size) * 0.5

  if current_text.is_empty() {
    if !placeholder.is_empty() {
      ctx
      .painter()
      .add_text(
        @math.Vec2::new(rect.x + padding_x, text_y),
        placeholder,
        font_size,
        @color.Color::text_disabled(),
      )
    }
  } else {
    ctx
    .painter()
    .add_text(
      @math.Vec2::new(rect.x + padding_x, text_y),
      current_text,
      font_size,
      @color.Color::text_primary(),
    )
  }

  if is_focused && ctx.is_caret_visible() {
    let sub = @core.string_slice(current_text, 0, cursor_pos)
    let measured_prefix = ctx.measure_text(sub, font_size)
    let caret_x = rect.x + padding_x + measured_prefix.x
    let caret_top = rect.y + (rect.h - caret_h) * 0.5
    let caret_bottom = caret_top + caret_h
    ctx
    .painter()
    .add_line(
      @math.Vec2::new(caret_x, caret_top),
      @math.Vec2::new(caret_x, caret_bottom),
      @color.Color::accent_primary(),
      1.5,
    )
  }

  ctx.pop_clip()

  (current_text, resp)
}

///|
/// Render a single-line text input with automatic width layout.
pub fn text_edit_val(
  ctx : UIContext,
  id_salt : String,
  text : String,
  placeholder? : String = "",
) -> (String, Response) {
  let default_w = 200.0 * ctx.style.scale
  let w = if ctx.available_width() > default_w {
    default_w
  } else {
    ctx.available_width()
  }
  let h = ctx.style.control_h_md * ctx.style.scale
  text_edit_sized(ctx, id_salt, text, placeholder, @math.Vec2::new(w, h))
}

///|
/// Render a single-line text input bound to a `Ref[String]`.
pub fn text_edit(
  ctx : UIContext,
  id_salt : String,
  text : Ref[String],
  placeholder? : String = "",
) -> Response {
  ctx.add(TextEdit::from_ref(id_salt, text).placeholder(placeholder))
}
