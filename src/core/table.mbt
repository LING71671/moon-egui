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
/// Sort direction indicator for table columns.
pub(all) enum TableSortDirection {
  Ascending
  Descending
  NoSort
} derive(Eq, Debug)

///|
/// Column definition for data table.
pub struct TableColumn {
  id : String
  title : String
  mut width : Double
  min_width : Double
  sortable : Bool
} derive(Eq, Debug)

///|
/// Creates a new table column descriptor.
pub fn TableColumn::new(
  id : String,
  title : String,
  width : Double,
  min_width? : Double = 50.0,
  sortable? : Bool = true,
) -> TableColumn {
  { id, title, width, min_width, sortable, }
}

///|
/// Interactive feedback response from table widget.
pub struct TableResponse {
  sort_changed : Bool
  sort_column : String
  sort_direction : TableSortDirection
  hovered_row : Int?
  clicked_row : Int?
} derive(Eq, Debug)

///|
/// Render a virtualized data table with resizable column headers, sorting,
/// alternating row stripes, row selection, and smooth vertical scrolling.
pub fn UIContext::table(
  self : UIContext,
  id_salt : String,
  size : @math.Vec2,
  columns : Array[TableColumn],
  row_count : Int,
  render_cell : (UIContext, Int, Int, @math.Rect) -> Unit,
  row_height? : Double = 0.0,
  header_height? : Double = 0.0,
  selected_row? : Int = -1,
  sort_column? : String = "",
  sort_direction? : TableSortDirection = NoSort,
) -> TableResponse {
  let scale = self.style.scale
  let eff_row_h = if row_height > 0.0 {
    row_height
  } else {
    self.style.table_row_h * scale
  }
  let eff_header_h = if header_height > 0.0 {
    header_height
  } else {
    self.style.table_header_h * scale
  }
  let table_radius = self.style.table_radius * scale

  self.push_id(id_salt)
  let (table_id, table_rect, _resp) = self.allocate_space(size)
  self.pop_id()

  let mut active_sort_col = sort_column
  let mut active_sort_dir = sort_direction
  let mut sort_changed = false

  // 1. Render Table Background Card
  self.draw_list.add_rect(table_rect, @color.Color::bg_surface(), table_radius)
  self.draw_list.add_rect_stroke(
    table_rect,
    @color.Color::border_default(),
    1.0,
    table_radius,
  )

  let header_rect = @math.Rect::new(
    table_rect.x,
    table_rect.y,
    table_rect.w,
    eff_header_h,
  )

  // Header background fill
  self.draw_list.add_rect(header_rect, @color.Color::bg_subtle(), table_radius)
  // Square off bottom corners of header
  let header_bottom_fill = @math.Rect::new(
    table_rect.x,
    table_rect.y + eff_header_h - table_radius,
    table_rect.w,
    table_radius,
  )
  self.draw_list.add_rect(header_bottom_fill, @color.Color::bg_subtle(), 0.0)

  // Bottom border line for header
  self.draw_list.add_line(
    @math.Vec2::new(table_rect.x, table_rect.y + eff_header_h),
    @math.Vec2::new(table_rect.x + table_rect.w, table_rect.y + eff_header_h),
    @color.Color::border_default(),
    1.0,
  )

  // 2. Interactive Column Headers
  let mut current_x = table_rect.x
  let total_cols = columns.length()

  for c = 0; c < total_cols; c = c + 1 {
    let col = columns[c]
    let col_w = col.width
    let col_header_rect = @math.Rect::new(
      current_x,
      table_rect.y,
      col_w,
      eff_header_h,
    )

    // Resize divider handle at right edge
    let handle_w = 8.0 * scale
    let handle_rect = @math.Rect::new(
      current_x + col_w - handle_w * 0.5,
      table_rect.y,
      handle_w,
      eff_header_h,
    )
    let handle_id = self.id_stack.derive_id(
      "table_col_handle::" + id_salt + "::" + col.id,
    )

    let handle_hovered = handle_rect.contains(self.input.mouse_pos)
    if handle_hovered {
      self.set_cursor_icon("col-resize")
    }
    if handle_hovered && self.input.mouse_pressed {
      self.set_active_id(handle_id)
    }

    if self.active_id == handle_id {
      self.set_cursor_icon("col-resize")
      self.set_wants_capture_mouse(true)
      if self.input.mouse_down {
        let mouse_delta = self.input.mouse_pos.x - current_x
        let clamped_w = if mouse_delta < col.min_width {
          col.min_width
        } else {
          mouse_delta
        }
        col.width = clamped_w
      }
      if self.input.mouse_released {
        self.set_active_id(Id::zero())
      }
    }

    // Header click for sorting (when not interacting with resize handle)
    let is_header_hovered = col_header_rect.contains(self.input.mouse_pos) &&
      !handle_hovered &&
      (self.active_id == Id::zero() || self.active_id == table_id)

    if is_header_hovered && col.sortable {
      self.set_cursor_icon("pointer")
      if self.input.mouse_pressed {
        if active_sort_col == col.id {
          active_sort_dir = match active_sort_dir {
            Ascending => Descending
            Descending => Ascending
            NoSort => Ascending
          }
        } else {
          active_sort_col = col.id
          active_sort_dir = Ascending
        }
        sort_changed = true
      }
    }

    // Header title text
    let font_sz = self.style.font_small * scale
    let title_pos = @math.Vec2::new(
      current_x + 10.0 * scale,
      table_rect.y + (eff_header_h - font_sz) * 0.5,
    )
    let title_color = if active_sort_col == col.id {
      @color.Color::accent_primary()
    } else if is_header_hovered {
      @color.Color::text_strong()
    } else {
      @color.Color::text_secondary()
    }
    self.draw_list.add_text(title_pos, col.title, font_sz, title_color)

    // Sort indicator arrow
    if active_sort_col == col.id {
      let arrow_str = match active_sort_dir {
        Ascending => "^"
        Descending => "v"
        NoSort => ""
      }
      if arrow_str != "" {
        let arrow_x = current_x + col.width - 16.0 * scale
        let arrow_pos = @math.Vec2::new(arrow_x, title_pos.y)
        self.draw_list.add_text(
          arrow_pos,
          arrow_str,
          font_sz,
          @color.Color::accent_primary(),
        )
      }
    }

    // Vertical column divider line
    if c < total_cols - 1 {
      let divider_x = current_x + col.width
      self.draw_list.add_line(
        @math.Vec2::new(divider_x, table_rect.y + 6.0 * scale),
        @math.Vec2::new(divider_x, table_rect.y + eff_header_h - 6.0 * scale),
        @color.Color::border_muted(),
        1.0,
      )
    }

    current_x = current_x + col.width
  }

  // 3. Virtual Data Body
  let body_y = table_rect.y + eff_header_h
  let body_h = table_rect.h - eff_header_h
  let body_rect = @math.Rect::new(table_rect.x, body_y, table_rect.w, body_h)

  let body_container_id = self.id_stack.derive_id(id_salt + "::table_body")
  let mut scroll_y = self.get_scroll_offset(body_container_id)
  let total_content_h = row_count.to_double() * eff_row_h
  let max_scroll = if total_content_h > body_h {
    total_content_h - body_h
  } else {
    0.0
  }

  // Scroll wheel handling
  if self.is_hovered(body_rect) && self.input.scroll_delta.y != 0.0 {
    scroll_y = scroll_y - self.input.scroll_delta.y
    self.set_wants_capture_mouse(true)
  }

  if scroll_y < 0.0 {
    scroll_y = 0.0
  }
  if scroll_y > max_scroll {
    scroll_y = max_scroll
  }
  self.set_scroll_offset(body_container_id, scroll_y)
  self.set_scroll_content_height(body_container_id, total_content_h)

  // Calculate virtual row window
  let start_row_raw = (scroll_y / eff_row_h).to_int()
  let start_row = if start_row_raw < 0 {
    0
  } else if start_row_raw >= row_count {
    row_count
  } else {
    start_row_raw
  }

  let visible_count = (body_h / eff_row_h).to_int() + 2
  let end_row = if start_row + visible_count > row_count {
    row_count
  } else {
    start_row + visible_count
  }

  let mut hovered_row : Int? = None
  let mut clicked_row : Int? = None

  self.push_clip(body_rect)

  for r = start_row; r < end_row; r = r + 1 {
    let row_y = body_y - scroll_y + r.to_double() * eff_row_h
    let row_rect = @math.Rect::new(body_rect.x, row_y, body_rect.w, eff_row_h)

    let is_row_hovered = self.is_hovered(body_rect) && self.is_hovered(row_rect)
    if is_row_hovered {
      hovered_row = Some(r)
      if self.input.mouse_pressed &&
        (self.active_id == Id::zero() || self.active_id == table_id) {
        clicked_row = Some(r)
      }
    }

    // Row background styling
    if r == selected_row {
      self.draw_list.add_rect(row_rect, @color.Color::table_row_selected(), 0.0)
    } else if is_row_hovered {
      self.draw_list.add_rect(row_rect, @color.Color::bg_hover(), 0.0)
    } else if r % 2 == 1 {
      self.draw_list.add_rect(row_rect, @color.Color::bg_subtle(), 0.0)
    }

    // Row bottom separator line
    self.draw_list.add_line(
      @math.Vec2::new(row_rect.x, row_rect.y + eff_row_h),
      @math.Vec2::new(row_rect.x + row_rect.w, row_rect.y + eff_row_h),
      @color.Color::border_muted(),
      1.0,
    )

    // Render cells for this row
    let mut cell_x = body_rect.x
    for c = 0; c < total_cols; c = c + 1 {
      let col = columns[c]
      let cell_rect = @math.Rect::new(cell_x, row_y, col.width, eff_row_h)

      self.push_clip(cell_rect)
      let prev_cursor = self.cursor
      let prev_avail = self.available_width

      self.set_cursor(@math.Vec2::new(cell_rect.x, cell_rect.y))
      self.set_available_width(cell_rect.w)

      render_cell(self, r, c, cell_rect)

      self.set_cursor(prev_cursor)
      self.set_available_width(prev_avail)
      self.pop_clip()

      cell_x = cell_x + col.width
    }
  }

  self.pop_clip()

  // 4. Scrollbar indicator
  if max_scroll > 0.0 && total_content_h > 0.0 {
    let scrollbar_w = 6.0
    let bar_x = body_rect.x + body_rect.w - scrollbar_w - 3.0
    let bar_track_y = body_rect.y + 2.0
    let bar_track_h = body_rect.h - 4.0

    let ratio = body_rect.h / total_content_h
    let raw_thumb_h = body_rect.h * ratio
    let thumb_h = if raw_thumb_h < 24.0 {
      24.0
    } else if raw_thumb_h > bar_track_h {
      bar_track_h
    } else {
      raw_thumb_h
    }

    let scroll_pct = if max_scroll > 0.0001 {
      scroll_y / max_scroll
    } else {
      0.0
    }
    let thumb_y = bar_track_y + scroll_pct * (bar_track_h - thumb_h)
    let thumb_rect = @math.Rect::new(bar_x, thumb_y, scrollbar_w, thumb_h)

    let is_bar_hovered = self.is_hovered(thumb_rect)
    let thumb_color = if is_bar_hovered {
      @color.Color::accent_primary()
    } else {
      @color.Color::border_muted()
    }
    self.draw_list.add_rect(thumb_rect, thumb_color, 3.0)
  }

  {
    sort_changed,
    sort_column: active_sort_col,
    sort_direction: active_sort_dir,
    hovered_row,
    clicked_row,
  }
}
