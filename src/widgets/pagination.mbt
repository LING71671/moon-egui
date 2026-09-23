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
/// Representation of an item within a collapsed pagination bar.
pub(all) enum PaginationItem {
  Page(Int)
  Ellipsis
} derive(Eq, Debug)

///|
/// Generates list of displayed page numbers with intelligent ellipsis folding.
fn generate_pagination_items(
  current : Int,
  total : Int,
) -> Array[PaginationItem] {
  if total <= 7 {
    let res = []
    for p = 1; p <= total; p = p + 1 {
      res.push(PaginationItem::Page(p))
    }
    res
  } else if current <= 4 {
    [
      PaginationItem::Page(1),
      PaginationItem::Page(2),
      PaginationItem::Page(3),
      PaginationItem::Page(4),
      PaginationItem::Page(5),
      PaginationItem::Ellipsis,
      PaginationItem::Page(total),
    ]
  } else if current >= total - 3 {
    [
      PaginationItem::Page(1),
      PaginationItem::Ellipsis,
      PaginationItem::Page(total - 4),
      PaginationItem::Page(total - 3),
      PaginationItem::Page(total - 2),
      PaginationItem::Page(total - 1),
      PaginationItem::Page(total),
    ]
  } else {
    [
      PaginationItem::Page(1),
      PaginationItem::Ellipsis,
      PaginationItem::Page(current - 1),
      PaginationItem::Page(current),
      PaginationItem::Page(current + 1),
      PaginationItem::Ellipsis,
      PaginationItem::Page(total),
    ]
  }
}

///|
/// Standalone data pagination bar widget supporting fluent configuration.
pub struct Pagination {
  id_salt : String
  current_page : Int
  total_pages : Int
  item_size : Double?
  spacing : Double?
  show_prev_next : Bool
} derive(Eq, Debug)

///|
/// Creates a new Pagination widget with initial page (1-indexed) and total pages count.
pub fn Pagination::new(
  id_salt : String,
  current_page : Int,
  total_pages : Int,
) -> Pagination {
  let total = if total_pages > 0 { total_pages } else { 1 }
  let current = if current_page < 1 {
    1
  } else if current_page > total {
    total
  } else {
    current_page
  }
  {
    id_salt,
    current_page: current,
    total_pages: total,
    item_size: None,
    spacing: None,
    show_prev_next: true,
  }
}

///|
/// Configures individual button square size.
pub fn Pagination::item_size(
  self : Pagination,
  item_size : Double,
) -> Pagination {
  { ..self, item_size: Some(item_size), }
}

///|
/// Sets spacing between pagination buttons.
pub fn Pagination::spacing(self : Pagination, spacing : Double) -> Pagination {
  { ..self, spacing: Some(spacing), }
}

///|
/// Configures whether Previous and Next navigation buttons are rendered.
pub fn Pagination::show_prev_next(
  self : Pagination,
  show_prev_next : Bool,
) -> Pagination {
  { ..self, show_prev_next, }
}

///|
/// Reference-bound Pagination widget for uniform `ui.add(...)` dispatch.
pub struct PaginationRef {
  pagination : Pagination
  target : Ref[Int]
}

///|
/// Creates a Pagination widget bound directly to a `Ref[Int]`.
pub fn Pagination::from_ref(
  id_salt : String,
  target : Ref[Int],
  total_pages : Int,
) -> PaginationRef {
  { pagination: Pagination::new(id_salt, target.val, total_pages), target, }
}

///|
pub fn PaginationRef::item_size(
  self : PaginationRef,
  item_size : Double,
) -> PaginationRef {
  { ..self, pagination: self.pagination.item_size(item_size), }
}

///|
pub fn PaginationRef::spacing(
  self : PaginationRef,
  spacing : Double,
) -> PaginationRef {
  { ..self, pagination: self.pagination.spacing(spacing), }
}

///|
pub fn PaginationRef::show_prev_next(
  self : PaginationRef,
  show_prev_next : Bool,
) -> PaginationRef {
  { ..self, pagination: self.pagination.show_prev_next(show_prev_next), }
}

///|
pub impl @core.Widget for PaginationRef with fn ui(self, ctx : UIContext) -> Response {
  let (new_page, resp) = { ..self.pagination, current_page: self.target.val, }.show(
    ctx,
  )
  self.target.val = new_page
  resp
}

///|
/// Renders the pagination bar, handles clicks, keyboard navigation,
/// and returns the updated current page and interaction response.
pub fn Pagination::show(self : Pagination, ctx : UIContext) -> (Int, Response) {
  let scale = ctx.style.scale
  let btn_sz = match self.item_size {
    Some(sz) => sz * scale
    None => (ctx.style.control_h_sm - ctx.style.radius_xs) * scale
  }
  let spacing = match self.spacing {
    Some(sp) => sp * scale
    None => ctx.style.spacing_xs * scale
  }
  let radius = ctx.style.radius_sm * scale
  let font_sz = ctx.style.font_small * scale

  let total = if self.total_pages > 0 { self.total_pages } else { 1 }
  let mut new_page = if self.current_page < 1 {
    1
  } else if self.current_page > total {
    total
  } else {
    self.current_page
  }

  let items = generate_pagination_items(new_page, total)
  let total_buttons = items.length() + (if self.show_prev_next { 2 } else { 0 })
  let total_w = total_buttons.to_double() * btn_sz +
    (total_buttons - 1).to_double() * spacing
  let h = btn_sz

  ctx.push_id(self.id_salt)
  let (id, rect, resp) = ctx.allocate_space(@math.Vec2::new(total_w, h))
  ctx.pop_id()
  ctx.register_focusable(id)

  let is_focused = resp.has_focus() || ctx.has_focus(id)

  // 1. Keyboard Navigation when focused
  if is_focused {
    if ctx.input.key_pressed(Key::ArrowLeft) ||
      ctx.input.key_pressed(Key::ArrowDown) {
      if new_page > 1 {
        new_page = new_page - 1
      }
      ctx.input.consume_key(Key::ArrowLeft)
      ctx.input.consume_key(Key::ArrowDown)
    }
    if ctx.input.key_pressed(Key::ArrowRight) ||
      ctx.input.key_pressed(Key::ArrowUp) {
      if new_page < total {
        new_page = new_page + 1
      }
      ctx.input.consume_key(Key::ArrowRight)
      ctx.input.consume_key(Key::ArrowUp)
    }
    if ctx.input.key_pressed(Key::PageDown) {
      new_page = if new_page + 5 <= total { new_page + 5 } else { total }
      ctx.input.consume_key(Key::PageDown)
    }
    if ctx.input.key_pressed(Key::PageUp) {
      new_page = if new_page > 5 { new_page - 5 } else { 1 }
      ctx.input.consume_key(Key::PageUp)
    }
    if ctx.input.key_pressed(Key::Home) {
      new_page = 1
      ctx.input.consume_key(Key::Home)
    }
    if ctx.input.key_pressed(Key::End) {
      new_page = total
      ctx.input.consume_key(Key::End)
    }
  }

  // 2. Focus Ring
  let theme = ctx.theme
  if is_focused {
    ctx
    .painter()
    .add_rect_stroke(
      rect.expand(2.0 * scale),
      theme.border_focus,
      1.5 * scale,
      radius + 2.0 * scale,
    )
  }

  let mut curr_x = rect.x

  // 3. Render Previous Button
  if self.show_prev_next {
    let prev_rect = @math.Rect::new(curr_x, rect.y, btn_sz, h)
    let is_prev_enabled = new_page > 1
    let is_prev_hovered = is_prev_enabled && ctx.is_hovered(prev_rect)

    if is_prev_hovered {
      ctx.set_cursor_icon("pointer")
      if resp.clicked {
        new_page = new_page - 1
      }
    }

    let prev_bg = if is_prev_hovered {
      theme.bg_hover
    } else {
      theme.bg_surface
    }
    ctx.painter().add_rect(prev_rect, prev_bg, radius)
    let prev_border = if is_prev_enabled {
      theme.border_default
    } else {
      theme.border_muted
    }
    ctx.painter().add_rect_stroke(prev_rect, prev_border, 1.0 * scale, radius)

    let sym = "‹"
    let sym_sz = ctx.measure_text(sym, font_sz)
    let sym_pos = @math.Vec2::new(
      curr_x + (btn_sz - sym_sz.x) * 0.5,
      rect.y + (h - font_sz) * 0.5,
    )
    let sym_color = if is_prev_enabled {
      theme.text_primary
    } else {
      theme.text_disabled
    }
    ctx.painter().add_text(sym_pos, sym, font_sz, sym_color)

    curr_x = curr_x + btn_sz + spacing
  }

  // 4. Render Page Number & Ellipsis Buttons
  for item in items {
    let item_rect = @math.Rect::new(curr_x, rect.y, btn_sz, h)

    match item {
      Page(p) => {
        let is_active = p == new_page
        let is_hovered = !is_active && ctx.is_hovered(item_rect)

        if is_hovered {
          ctx.set_cursor_icon("pointer")
          if resp.clicked {
            new_page = p
          }
        }

        if is_active {
          ctx.painter().add_rect(item_rect, theme.accent_primary, radius)
          let p_str = p.to_string()
          let p_sz = ctx.measure_text(p_str, font_sz)
          let p_pos = @math.Vec2::new(
            curr_x + (btn_sz - p_sz.x) * 0.5,
            rect.y + (h - font_sz) * 0.5,
          )
          ctx.painter().add_text(p_pos, p_str, font_sz, theme.text_inverse)
        } else {
          let bg = if is_hovered { theme.bg_hover } else { theme.bg_surface }
          ctx.painter().add_rect(item_rect, bg, radius)
          ctx
          .painter()
          .add_rect_stroke(item_rect, theme.border_default, 1.0 * scale, radius)
          let p_str = p.to_string()
          let p_sz = ctx.measure_text(p_str, font_sz)
          let p_pos = @math.Vec2::new(
            curr_x + (btn_sz - p_sz.x) * 0.5,
            rect.y + (h - font_sz) * 0.5,
          )
          ctx.painter().add_text(p_pos, p_str, font_sz, theme.text_primary)
        }
      }
      Ellipsis => {
        let sym = "..."
        let sym_sz = ctx.measure_text(sym, font_sz)
        let sym_pos = @math.Vec2::new(
          curr_x + (btn_sz - sym_sz.x) * 0.5,
          rect.y + (h - font_sz) * 0.5,
        )
        ctx.painter().add_text(sym_pos, sym, font_sz, theme.text_muted)
      }
    }

    curr_x = curr_x + btn_sz + spacing
  }

  // 5. Render Next Button
  if self.show_prev_next {
    let next_rect = @math.Rect::new(curr_x, rect.y, btn_sz, h)
    let is_next_enabled = new_page < total
    let is_next_hovered = is_next_enabled && ctx.is_hovered(next_rect)

    if is_next_hovered {
      ctx.set_cursor_icon("pointer")
      if resp.clicked {
        new_page = new_page + 1
      }
    }

    let next_bg = if is_next_hovered {
      theme.bg_hover
    } else {
      theme.bg_surface
    }
    ctx.painter().add_rect(next_rect, next_bg, radius)
    let next_border = if is_next_enabled {
      theme.border_default
    } else {
      theme.border_muted
    }
    ctx.painter().add_rect_stroke(next_rect, next_border, 1.0 * scale, radius)

    let sym = "›"
    let sym_sz = ctx.measure_text(sym, font_sz)
    let sym_pos = @math.Vec2::new(
      curr_x + (btn_sz - sym_sz.x) * 0.5,
      rect.y + (h - font_sz) * 0.5,
    )
    let sym_color = if is_next_enabled {
      theme.text_primary
    } else {
      theme.text_disabled
    }
    ctx.painter().add_text(sym_pos, sym, font_sz, sym_color)
  }

  (new_page, resp)
}

///|
/// Convenience functional helper to render a Pagination component.
pub fn pagination(
  ctx : UIContext,
  id_salt : String,
  current_page : Int,
  total_pages : Int,
  item_size? : Double,
  spacing? : Double,
  show_prev_next? : Bool = true,
) -> (Int, Response) {
  let mut p = Pagination::new(id_salt, current_page, total_pages).show_prev_next(
    show_prev_next,
  )
  if item_size is Some(sz) {
    p = p.item_size(sz)
  }
  if spacing is Some(sp) {
    p = p.spacing(sp)
  }
  p.show(ctx)
}
