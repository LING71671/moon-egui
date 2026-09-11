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
/// Render a horizontal breadcrumb navigation strip with ancestor hover highlights,
/// smart ellipsis folding for long hierarchies, and node click detection.
pub fn UIContext::breadcrumb(
  self : UIContext,
  id_salt : String,
  items : Array[String],
  separator? : String = "/",
  max_visible? : Int = 4,
) -> (Int?, Response) {
  let count = items.length()
  if count == 0 {
    let (_id, _rect, resp) = self.allocate_space(@math.Vec2::zero())
    return (None, resp)
  }

  let font_sz = self.style.font_normal
  let sep_sz = self.measure_text(separator, font_sz)
  let sep_gap = 6.0

  // Fold middle items into "..." if exceeding max_visible
  let display_items : Array[(String, Int)] = []
  let should_fold = max_visible > 2 && count > max_visible

  if should_fold {
    display_items.push((items[0], 0))
    display_items.push(("...", -1))
    let tail_start = count - (max_visible - 2)
    for i = tail_start; i < count; i = i + 1 {
      display_items.push((items[i], i))
    }
  } else {
    for i = 0; i < count; i = i + 1 {
      display_items.push((items[i], i))
    }
  }

  // Pre-calculate total width
  let mut total_w = 0.0
  let num_display = display_items.length()
  for i = 0; i < num_display; i = i + 1 {
    let item_sz = self.measure_text(display_items[i].0, font_sz)
    total_w = total_w + item_sz.x + 8.0 // item width + pad
    if i < num_display - 1 {
      total_w = total_w + sep_sz.x + sep_gap * 2.0
    }
  }

  let h = 26.0
  self.push_id(id_salt)
  let (_id, rect, resp) = self.allocate_space(@math.Vec2::new(total_w, h))
  self.pop_id()

  let mut current_x = rect.x
  let mut clicked_idx : Int? = None

  for i = 0; i < num_display; i = i + 1 {
    let (label, orig_idx) = display_items[i]
    let item_sz = self.measure_text(label, font_sz)
    let is_last = i == num_display - 1
    let item_w = item_sz.x + 8.0
    let item_rect = @math.Rect::new(current_x, rect.y, item_w, h)

    let is_hovered = item_rect.contains(self.input.mouse_pos)

    // Last item is current location, not interactive
    if !is_last && orig_idx >= 0 {
      if is_hovered {
        self.set_cursor_icon("pointer")
        self.draw_list.add_rect(item_rect, @color.Color::bg_hover(), 4.0)
        if self.input.mouse_pressed {
          clicked_idx = Some(orig_idx)
        }
      }
    }

    let text_col = if is_last {
      @color.Color::text_strong()
    } else if is_hovered && orig_idx >= 0 {
      @color.Color::text_primary()
    } else {
      @color.Color::text_secondary()
    }

    let text_pos = @math.Vec2::new(
      current_x + 4.0,
      rect.y + (h - font_sz) * 0.5,
    )
    self.draw_list.add_text(text_pos, label, font_sz, text_col)
    current_x = current_x + item_w

    // Separator
    if !is_last {
      let sep_x = current_x + sep_gap
      let sep_pos = @math.Vec2::new(sep_x, rect.y + (h - font_sz) * 0.5)
      self.draw_list.add_text(
        sep_pos,
        separator,
        font_sz,
        @color.Color::text_disabled(),
      )
      current_x = sep_x + sep_sz.x + sep_gap
    }
  }

  (clicked_idx, resp)
}
