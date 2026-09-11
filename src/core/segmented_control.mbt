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
  height? : Double = 0.0,
  width? : Double = 0.0,
) -> (Int, Response) {
  let count = options.length()
  if count == 0 {
    let (_id, _rect, resp) = self.allocate_space(@math.Vec2::zero())
    return (selected_index, resp)
  }

  let scale = self.style.scale
  let eff_h = if height > 0.0 { height } else { self.style.segmented_h * scale }
  let font_sz = self.style.font_normal * scale
  let pad = self.style.segmented_pad * scale
  let item_pad_x = self.style.segmented_item_pad_x * scale
  let track_radius = self.style.segmented_radius * scale
  let pill_radius = self.style.segmented_pill_radius * scale

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
    max_txt_w + item_pad_x * 2.0
  }

  let total_w = if width > 0.0 {
    width
  } else {
    item_w * count.to_double() + pad * 2.0
  }

  self.push_id(id_salt)
  let (id, track_rect, resp) = self.allocate_space(
    @math.Vec2::new(total_w, eff_h),
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
  self.draw_list.add_rect(track_rect, @color.Color::bg_subtle(), track_radius)
  self.draw_list.add_rect_stroke(
    track_rect,
    @color.Color::border_muted(),
    1.0,
    track_radius,
  )

  // 3. Floating Active Porcelain Pill
  let pill_h = track_rect.h - pad * 2.0
  let pill_x = track_rect.x + pad + current_sel.to_double() * item_w
  let pill_y = track_rect.y + pad
  let pill_rect = @math.Rect::new(pill_x, pill_y, item_w, pill_h)

  // Pill subtle ambient shadow
  self.draw_list.add_rect(
    @math.Rect::new(pill_x, pill_y + 1.0 * scale, item_w, pill_h),
    @color.Color::pill_ambient_shadow(),
    pill_radius,
  )
  // Pill surface fill
  self.draw_list.add_rect(
    pill_rect,
    @color.Color::pill_active_bg(),
    pill_radius,
  )
  // Pill outline
  self.draw_list.add_rect_stroke(
    pill_rect,
    @color.Color::pill_active_border(),
    1.0,
    pill_radius,
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
          @color.Color::wash_hover(),
          pill_radius,
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
