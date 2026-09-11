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
/// Semantic styling role of an inline text span.
pub(all) enum TextSpanKind {
  Normal
  Bold
  Code
  Link(String)
} derive(Eq, Debug)

///|
/// Segment of rich inline text.
pub struct TextSpan {
  text : String
  kind : TextSpanKind
} derive(Eq, Debug)

///|
pub fn TextSpan::normal(text : String) -> TextSpan {
  { text, kind: Normal, }
}

///|
pub fn TextSpan::bold(text : String) -> TextSpan {
  { text, kind: Bold, }
}

///|
pub fn TextSpan::code(text : String) -> TextSpan {
  { text, kind: Code, }
}

///|
pub fn TextSpan::link(text : String, url : String) -> TextSpan {
  { text, kind: Link(url), }
}

///|
/// Response from interactive rich text layout containing clicked URL.
pub struct RichTextResponse {
  clicked_url : String?
  resp : Response
} derive(Eq, Debug)

///|
/// Render inline rich text with word-wrapping, mixed formatting (normal, bold,
/// inline code pills, hyperlinks), and link click detection.
pub fn UIContext::rich_text(
  self : UIContext,
  id_salt : String,
  spans : Array[TextSpan],
  wrap_width? : Double = 0.0,
) -> RichTextResponse {
  let font_sz = self.style.font_normal
  let line_h = 22.0
  let max_w = if wrap_width > 0.0 { wrap_width } else { self.available_width }

  // Pre-calculate line breaking and item positioning
  let mut current_x = 0.0
  let mut current_line = 0
  let mut measured_max_w = 0.0

  // (text, kind, rel_rect)
  let layout_items : Array[(String, TextSpanKind, @math.Rect)] = []

  for span in spans {
    let words = span.text.split(" ")
    for word in words {
      let word_str = word.to_owned()
      if word_str == "" {
        continue
      }
      let sz = self.measure_text(word_str, font_sz)
      let word_w = sz.x + (if span.kind == Code { 6.0 } else { 0.0 })

      if current_x + word_w > max_w && current_x > 0.0 {
        current_line = current_line + 1
        current_x = 0.0
      }

      let rel_rect = @math.Rect::new(
        current_x,
        current_line.to_double() * line_h,
        word_w,
        line_h,
      )
      layout_items.push((word_str, span.kind, rel_rect))

      current_x = current_x + word_w + 6.0 // word spacing
      if current_x > measured_max_w {
        measured_max_w = current_x
      }
    }
  }

  let total_h = (current_line + 1).to_double() * line_h
  let total_w = if wrap_width > 0.0 { wrap_width } else { measured_max_w }

  self.push_id(id_salt)
  let (_id, container_rect, resp) = self.allocate_space(
    @math.Vec2::new(total_w, total_h),
  )
  self.pop_id()

  let mut clicked_url : String? = None

  for item in layout_items {
    let (text, kind, rel) = item
    let abs_rect = @math.Rect::new(
      container_rect.x + rel.x,
      container_rect.y + rel.y,
      rel.w,
      rel.h,
    )
    let is_hovered = abs_rect.contains(self.input.mouse_pos)

    match kind {
      Normal => {
        let text_pos = @math.Vec2::new(
          abs_rect.x,
          abs_rect.y + (line_h - font_sz) * 0.5,
        )
        self.draw_list.add_text(
          text_pos,
          text,
          font_sz,
          @color.Color::text_body(),
        )
      }
      Bold => {
        let text_pos = @math.Vec2::new(
          abs_rect.x,
          abs_rect.y + (line_h - font_sz) * 0.5,
        )
        self.draw_list.add_text(
          text_pos,
          text,
          font_sz,
          @color.Color::text_strong(),
        )
      }
      Code => {
        let pad_x = 3.0
        let code_bg_rect = @math.Rect::new(
          abs_rect.x,
          abs_rect.y + 2.0,
          abs_rect.w,
          line_h - 4.0,
        )
        self.draw_list.add_rect(code_bg_rect, @color.Color::bg_subtle(), 3.0)
        self.draw_list.add_rect_stroke(
          code_bg_rect,
          @color.Color::border_muted(),
          1.0,
          3.0,
        )

        let text_pos = @math.Vec2::new(
          abs_rect.x + pad_x,
          abs_rect.y + (line_h - font_sz) * 0.5,
        )
        self.draw_list.add_text(
          text_pos,
          text,
          font_sz,
          @color.Color::accent_deep(),
        )
      }
      Link(url) => {
        if is_hovered {
          self.set_cursor_icon("pointer")
          if self.input.mouse_pressed {
            clicked_url = Some(url)
          }
        }

        let link_col = if is_hovered {
          @color.Color::accent_hover()
        } else {
          @color.Color::accent_primary()
        }

        let text_pos = @math.Vec2::new(
          abs_rect.x,
          abs_rect.y + (line_h - font_sz) * 0.5,
        )
        self.draw_list.add_text(text_pos, text, font_sz, link_col)

        // Underline when hovered
        if is_hovered {
          let line_y = abs_rect.y + line_h - 3.0
          self.draw_list.add_line(
            @math.Vec2::new(abs_rect.x, line_y),
            @math.Vec2::new(abs_rect.x + abs_rect.w, line_y),
            link_col,
            1.0,
          )
        }
      }
    }
  }

  { clicked_url, resp, }
}

///|
/// Render a standalone text hyperlink with hover underline and pointer cursor.
pub fn UIContext::hyperlink(
  self : UIContext,
  text : String,
  _url : String,
) -> (Bool, Response) {
  let font_sz = self.style.font_normal
  let text_sz = self.measure_text(text, font_sz)
  let h = 20.0
  let w = text_sz.x

  let (_id, rect, resp) = self.allocate_space(@math.Vec2::new(w, h))
  let is_hovered = self.is_hovered(rect)

  if is_hovered {
    self.set_cursor_icon("pointer")
  }

  let link_col = if is_hovered {
    @color.Color::accent_hover()
  } else {
    @color.Color::accent_primary()
  }

  let text_pos = @math.Vec2::new(rect.x, rect.y + (h - font_sz) * 0.5)
  self.draw_list.add_text(text_pos, text, font_sz, link_col)

  if is_hovered {
    let line_y = rect.y + h - 2.0
    self.draw_list.add_line(
      @math.Vec2::new(rect.x, line_y),
      @math.Vec2::new(rect.x + w, line_y),
      link_col,
      1.0,
    )
  }

  let clicked = is_hovered && self.input.mouse_pressed
  (clicked, resp)
}
