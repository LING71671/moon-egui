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
/// Component style descriptor for data table controls.
pub struct TableStyle {
  header_h : Double
  row_h : Double
  radius : Double
} derive(Eq, Debug)

///|
pub fn TableStyle::default() -> TableStyle {
  { header_h: 32.0, row_h: 30.0, radius: 6.0, }
}

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
/// Standalone virtualized data table widget supporting fluent configuration.
pub struct Table {
  id_salt : String
  size : @math.Vec2
  columns : Array[TableColumn]
  row_count : Int
  render_cell : (UIContext, Int, Int, @math.Rect) -> Unit
  row_height : Double
  header_height : Double
  selected_row : Int
  sort_column : String
  sort_direction : TableSortDirection
}

///|
/// Create a new virtualized data table builder.
pub fn Table::new(
  id_salt : String,
  size : @math.Vec2,
  columns : Array[TableColumn],
  row_count : Int,
  render_cell : (UIContext, Int, Int, @math.Rect) -> Unit,
) -> Table {
  {
    id_salt,
    size,
    columns,
    row_count,
    render_cell,
    row_height: 0.0,
    header_height: 0.0,
    selected_row: -1,
    sort_column: "",
    sort_direction: NoSort,
  }
}

///|
/// Set row height in pixels.
pub fn Table::row_height(self : Table, row_height : Double) -> Table {
  { ..self, row_height, }
}

///|
/// Set header height in pixels.
pub fn Table::header_height(self : Table, header_height : Double) -> Table {
  { ..self, header_height, }
}

///|
/// Set index of currently selected row.
pub fn Table::selected_row(self : Table, selected_row : Int) -> Table {
  { ..self, selected_row, }
}

///|
/// Set column identifier used for active sorting.
pub fn Table::sort_column(self : Table, sort_column : String) -> Table {
  { ..self, sort_column, }
}

///|
/// Set sort direction (Ascending, Descending, NoSort).
pub fn Table::sort_direction(
  self : Table,
  sort_direction : TableSortDirection,
) -> Table {
  { ..self, sort_direction, }
}

///|
/// Render the table into the provided UIContext.
pub fn Table::show(self : Table, ctx : UIContext) -> TableResponse {
  table(
    ctx,
    self.id_salt,
    self.size,
    self.columns,
    self.row_count,
    self.render_cell,
    row_height=self.row_height,
    header_height=self.header_height,
    selected_row=self.selected_row,
    sort_column=self.sort_column,
    sort_direction=self.sort_direction,
  )
}

///|
/// Render a virtualized data table with resizable column headers, sorting,
/// alternating row stripes, row selection, and smooth vertical scrolling.
pub fn table(
  ctx : UIContext,
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
  let scale = ctx.style.scale
  let t_style = TableStyle::default()
  let eff_row_h = if row_height > 0.0 {
    row_height
  } else {
    t_style.row_h * scale
  }
  let eff_header_h = if header_height > 0.0 {
    header_height
  } else {
    t_style.header_h * scale
  }
  let table_radius = t_style.radius * scale

  ctx.push_id(id_salt)
  let (table_id, table_rect, _resp) = ctx.allocate_space(size)
  ctx.pop_id()

  let mut active_sort_col = sort_column
  let mut active_sort_dir = sort_direction
  let mut sort_changed = false

  // 1. Render Table Background Card
  ctx.painter().add_rect(table_rect, @color.Color::bg_surface(), table_radius)
  ctx
  .painter()
  .add_rect_stroke(
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
  ctx.painter().add_rect(header_rect, @color.Color::bg_subtle(), table_radius)
  // Square off bottom corners of header
  let header_bottom_fill = @math.Rect::new(
    table_rect.x,
    table_rect.y + eff_header_h - table_radius,
    table_rect.w,
    table_radius,
  )
  ctx.painter().add_rect(header_bottom_fill, @color.Color::bg_subtle(), 0.0)

  // Bottom border line for header
  ctx
  .painter()
  .add_line(
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
    let handle_id = ctx.id_stack.derive_id(
      "table_col_handle::" + id_salt + "::" + col.id,
    )

    let handle_hovered = handle_rect.contains(ctx.input.mouse_pos)
    if handle_hovered {
      ctx.set_cursor_icon("col-resize")
    }
    if handle_hovered && ctx.input.mouse_pressed {
      ctx.set_active_id(handle_id)
    }

    if ctx.active_id() == handle_id {
      ctx.set_cursor_icon("col-resize")
      ctx.set_wants_capture_mouse(true)
      if ctx.input.mouse_down {
        let mouse_delta = ctx.input.mouse_pos.x - current_x
        let clamped_w = if mouse_delta < col.min_width {
          col.min_width
        } else {
          mouse_delta
        }
        col.width = clamped_w
      }
      if ctx.input.mouse_released {
        ctx.set_active_id(Id::zero())
      }
    }

    // Header click for sorting (when not interacting with resize handle)
    let is_header_hovered = col_header_rect.contains(ctx.input.mouse_pos) &&
      !handle_hovered &&
      (ctx.active_id() == Id::zero() || ctx.active_id() == table_id)

    if is_header_hovered && col.sortable {
      ctx.set_cursor_icon("pointer")
      if ctx.input.mouse_pressed {
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
    let font_sz = ctx.style.font_small * scale
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
    ctx.painter().add_text(title_pos, col.title, font_sz, title_color)

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
        ctx
        .painter()
        .add_text(arrow_pos, arrow_str, font_sz, @color.Color::accent_primary())
      }
    }

    // Vertical column divider line
    if c < total_cols - 1 {
      let divider_x = current_x + col.width
      ctx
      .painter()
      .add_line(
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

  let body_container_id = ctx.id_stack.derive_id(id_salt + "::table_body")
  let mut scroll_y = ctx.get_scroll_offset(body_container_id)
  let total_content_h = row_count.to_double() * eff_row_h
  let max_scroll = if total_content_h > body_h {
    total_content_h - body_h
  } else {
    0.0
  }

  // Scroll wheel handling
  if ctx.is_hovered(body_rect) && ctx.input.scroll_delta.y != 0.0 {
    scroll_y = scroll_y - ctx.input.scroll_delta.y
    ctx.set_wants_capture_mouse(true)
  }

  if scroll_y < 0.0 {
    scroll_y = 0.0
  }
  if scroll_y > max_scroll {
    scroll_y = max_scroll
  }
  ctx.set_scroll_offset(body_container_id, scroll_y)
  ctx.set_scroll_content_height(body_container_id, total_content_h)

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

  ctx.push_clip(body_rect)

  for r = start_row; r < end_row; r = r + 1 {
    let row_y = body_y - scroll_y + r.to_double() * eff_row_h
    let row_rect = @math.Rect::new(body_rect.x, row_y, body_rect.w, eff_row_h)

    let is_row_hovered = ctx.is_hovered(body_rect) && ctx.is_hovered(row_rect)
    if is_row_hovered {
      hovered_row = Some(r)
      if ctx.input.mouse_pressed &&
        (ctx.active_id() == Id::zero() || ctx.active_id() == table_id) {
        clicked_row = Some(r)
      }
    }

    // Row background styling
    if r == selected_row {
      ctx.painter().add_rect(row_rect, @color.Color::table_row_selected(), 0.0)
    } else if is_row_hovered {
      ctx.painter().add_rect(row_rect, @color.Color::bg_hover(), 0.0)
    } else if r % 2 == 1 {
      ctx.painter().add_rect(row_rect, @color.Color::bg_subtle(), 0.0)
    }

    // Row bottom separator line
    ctx
    .painter()
    .add_line(
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

      let prev_cursor = ctx.cursor()
      let prev_avail = ctx.available_width()

      ctx.set_cursor(@math.Vec2::new(cell_rect.x, cell_rect.y))
      ctx.set_available_width(cell_rect.w)

      render_cell(ctx, r, c, cell_rect)

      ctx.set_cursor(prev_cursor)
      ctx.set_available_width(prev_avail)

      cell_x = cell_x + col.width
    }
  }

  ctx.pop_clip()

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

    let is_bar_hovered = ctx.is_hovered(thumb_rect)
    let thumb_color = if is_bar_hovered {
      @color.Color::accent_primary()
    } else {
      @color.Color::border_muted()
    }
    ctx.painter().add_rect(thumb_rect, thumb_color, 3.0)
  }

  {
    sort_changed,
    sort_column: active_sort_col,
    sort_direction: active_sort_dir,
    hovered_row,
    clicked_row,
  }
}
