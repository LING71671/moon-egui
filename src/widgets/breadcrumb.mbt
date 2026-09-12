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
/// Standalone breadcrumb navigation widget supporting fluent configuration.
pub struct Breadcrumb {
  id_salt : String
  items : Array[String]
  separator : String
  max_visible : Int
} derive(Eq, Debug)

///|
/// Create a new breadcrumb widget with item list.
pub fn Breadcrumb::new(id_salt : String, items : Array[String]) -> Breadcrumb {
  { id_salt, items, separator: "/", max_visible: 4, }
}

///|
/// Configure custom separator delimiter string.
pub fn Breadcrumb::separator(
  self : Breadcrumb,
  separator : String,
) -> Breadcrumb {
  { ..self, separator, }
}

///|
/// Configure maximum visible hierarchy items before middle folding with ellipsis.
pub fn Breadcrumb::max_visible(
  self : Breadcrumb,
  max_visible : Int,
) -> Breadcrumb {
  { ..self, max_visible, }
}

///|
/// Show the breadcrumb strip and return (clicked_index?, response).
pub fn Breadcrumb::show(self : Breadcrumb, ctx : UIContext) -> (Int?, Response) {
  breadcrumb(
    ctx,
    self.id_salt,
    self.items,
    separator=self.separator,
    max_visible=self.max_visible,
  )
}

///|
/// Render a horizontal breadcrumb navigation strip with ancestor hover highlights,
/// smart ellipsis folding for long hierarchies, and node click detection.
pub fn breadcrumb(
  ctx : UIContext,
  id_salt : String,
  items : Array[String],
  separator? : String = "/",
  max_visible? : Int = 4,
) -> (Int?, Response) {
  let count = items.length()
  if count == 0 {
    let (_id, _rect, resp) = ctx.allocate_space(@math.Vec2::zero())
    return (None, resp)
  }

  let scale = ctx.style.scale
  let font_sz = ctx.style.font_normal * scale
  let sep_sz = ctx.measure_text(separator, font_sz)
  let sep_gap = 6.0 * scale
  let pad_x = ctx.style.spacing_sm * scale

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

  let mut total_w = 0.0
  let num_display = display_items.length()
  for i = 0; i < num_display; i = i + 1 {
    let item_sz = ctx.measure_text(display_items[i].0, font_sz)
    total_w = total_w + item_sz.x + pad_x
    if i < num_display - 1 {
      total_w = total_w + sep_sz.x + sep_gap * 2.0
    }
  }

  let h = (ctx.style.control_h_sm + ctx.style.radius_xs) * scale
  ctx.push_id(id_salt)
  let (_id, rect, resp) = ctx.allocate_space(@math.Vec2::new(total_w, h))
  ctx.pop_id()

  let mut current_x = rect.x
  let mut clicked_idx : Int? = None

  for i = 0; i < num_display; i = i + 1 {
    let (label, orig_idx) = display_items[i]
    let item_sz = ctx.measure_text(label, font_sz)
    let is_last = i == num_display - 1
    let item_w = item_sz.x + pad_x
    let item_rect = @math.Rect::new(current_x, rect.y, item_w, h)

    let is_hovered = ctx.is_hovered(item_rect)
    let painter = ctx.painter()

    if !is_last && orig_idx >= 0 {
      if is_hovered {
        ctx.set_cursor_icon("pointer")
        painter.add_rect(
          item_rect,
          @color.Color::bg_hover(),
          ctx.style.radius_sm * scale,
        )
        if ctx.input.mouse_pressed {
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
    painter.add_text(text_pos, label, font_sz, text_col)
    current_x = current_x + item_w

    if !is_last {
      let sep_x = current_x + sep_gap
      let sep_pos = @math.Vec2::new(sep_x, rect.y + (h - font_sz) * 0.5)
      painter.add_text(
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
