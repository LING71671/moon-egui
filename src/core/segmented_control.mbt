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
/// Render a segmented control widget featuring a recessed porcelain track,
/// a floating white porcelain pill indicator with ambient shadow, and keyboard arrow switching.
pub fn UIContext::segmented_control(
  self : UIContext,
  id_salt : String,
  options : Array[String],
  selected_index : Int,
  height? : Double = 32.0,
  width? : Double = 0.0,
) -> (Int, Response) {
  let count = options.length()
  if count == 0 {
    let (_id, _rect, resp) = self.allocate_space(@math.Vec2::zero())
    return (selected_index, resp)
  }

  let font_sz = self.style.font_normal
  let pad = 3.0

  // Calculate item width
  let item_w = if width > 0.0 {
    (width - pad * 2.0) / count.to_double()
  } else {
    let mut max_txt_w = 0.0
    for opt in options {
      let sz = self.measure_text(opt, font_sz)
      if sz.x > max_txt_w {
        max_txt_w = sz.x
      }
    }
    max_txt_w + 24.0
  }

  let total_w = if width > 0.0 {
    width
  } else {
    item_w * count.to_double() + pad * 2.0
  }

  self.push_id(id_salt)
  let (id, track_rect, resp) = self.allocate_space(
    @math.Vec2::new(total_w, height),
  )
  self.pop_id()
  self.register_focusable(id)

  let mut current_sel = selected_index
  if current_sel < 0 {
    current_sel = 0
  } else if current_sel >= count {
    current_sel = count - 1
  }

  // 1. Keyboard navigation when focused
  if self.has_focus(id) {
    if self.input.key_pressed(Key::ArrowLeft) {
      current_sel = if current_sel > 0 { current_sel - 1 } else { count - 1 }
    }
    if self.input.key_pressed(Key::ArrowRight) {
      current_sel = if current_sel < count - 1 { current_sel + 1 } else { 0 }
    }
  }

  // 2. Track Background
  self.draw_list.add_rect(track_rect, @color.Color::bg_subtle(), 7.0)
  self.draw_list.add_rect_stroke(
    track_rect,
    @color.Color::border_muted().with_alpha(90),
    1.0,
    7.0,
  )

  // 3. Floating Active Porcelain Pill
  let pill_h = track_rect.h - pad * 2.0
  let pill_x = track_rect.x + pad + current_sel.to_double() * item_w
  let pill_y = track_rect.y + pad
  let pill_rect = @math.Rect::new(pill_x, pill_y, item_w, pill_h)

  // Pill subtle ambient shadow
  self.draw_list.add_rect(
    @math.Rect::new(pill_x, pill_y + 1.5, item_w, pill_h),
    @color.Color::shadow().with_alpha(35),
    5.0,
  )
  // Pill surface fill
  self.draw_list.add_rect(pill_rect, @color.Color::white(), 5.0)
  // Pill outline
  self.draw_list.add_rect_stroke(
    pill_rect,
    @color.Color::border_default().with_alpha(120),
    1.0,
    5.0,
  )

  // 4. Options Text & Hit-Testing
  for i = 0; i < count; i = i + 1 {
    let opt_x = track_rect.x + pad + i.to_double() * item_w
    let opt_rect = @math.Rect::new(opt_x, pill_y, item_w, pill_h)

    let is_hovered = opt_rect.contains(self.input.mouse_pos)
    if is_hovered {
      self.set_cursor_icon("pointer")
      if i != current_sel {
        self.draw_list.add_rect(
          opt_rect,
          @color.Color::bg_hover().with_alpha(60),
          5.0,
        )
      }
      if self.input.mouse_pressed {
        current_sel = i
        self.request_focus(id)
      }
    }

    let text_col = if i == current_sel {
      @color.Color::text_strong()
    } else if is_hovered {
      @color.Color::text_primary()
    } else {
      @color.Color::text_secondary()
    }

    let text_sz = self.measure_text(options[i], font_sz)
    let text_pos = @math.Vec2::new(
      opt_x + (item_w - text_sz.x) * 0.5,
      pill_y + (pill_h - text_sz.y) * 0.5,
    )
    self.draw_list.add_text(text_pos, options[i], font_sz, text_col)
  }

  (current_sel, resp)
}
