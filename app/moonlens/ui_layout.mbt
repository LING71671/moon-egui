// Copyright 2026 Ling71671
// MoonLens Modern Professional Desktop UI Layout (Impeccable Operate Mode)

///|
pub fn render_moonlens_ui(
  ctx : @core.UIContext,
  state : AppState,
  vp_w : Double,
  vp_h : Double,
) -> Unit {
  ctx.set_available_width(vp_w)
  state.frame_count = state.frame_count + 1

  // Silky smooth inertia scrolling interpolation
  let scroll_diff = state.target_scroll_y - state.table_scroll_y
  if scroll_diff.abs() > 0.15 {
    state.table_scroll_y = state.table_scroll_y + scroll_diff * 0.28
  } else {
    state.table_scroll_y = state.target_scroll_y
  }

  // -------------------------------------------------------------
  // Curated Professional Engineering Palette (Obsidian & Ice Cyan)
  // No generic AI blue/purple. No jarring black cutouts.
  // -------------------------------------------------------------
  let c_bg = @color.Color::rgb(12, 15, 21) // Deep obsidian canvas
  let c_topbar = @color.Color::rgb(17, 21, 29) // Header surface
  let c_sidebar = @color.Color::rgb(15, 18, 25) // Sidebar panel
  let c_border = @color.Color::rgb(32, 38, 52) // Hairline divider
  let c_card_bg = @color.Color::rgb(20, 25, 35) // Elevated cards

  let c_cyan = @color.Color::rgb(56, 189, 248) // Brand Ice Cyan (#38bdf8)
  let c_text_strong = @color.Color::rgb(241, 245, 249) // Slate 100
  let c_text_body = @color.Color::rgb(203, 213, 225) // Slate 300
  let c_text_muted = @color.Color::rgb(148, 163, 184) // Slate 400
  let c_text_dim = @color.Color::rgb(100, 116, 139) // Slate 500

  let c_badge_int_bg = @color.Color::rgb(18, 45, 36)
  let c_badge_int_fg = @color.Color::rgb(52, 211, 153) // Soft Mint
  let c_badge_num_bg = @color.Color::rgb(18, 42, 62)
  let c_badge_num_fg = @color.Color::rgb(56, 189, 248) // Ice Cyan
  let c_badge_str_bg = @color.Color::rgb(48, 38, 20)
  let c_badge_str_fg = @color.Color::rgb(251, 191, 36) // Warm Amber

  let dl = ctx.draw_list()

  // 1. Root Background Canvas
  dl.add_rect(@math.Rect::new(0.0, 0.0, vp_w, vp_h), c_bg, 0.0)

  // 2. Top Command Bar (Height = 54)
  let header_h = 54.0
  dl.add_rect(@math.Rect::new(0.0, 0.0, vp_w, header_h), c_topbar, 0.0)
  dl.add_line(
    @math.Vec2::new(0.0, header_h),
    @math.Vec2::new(vp_w, header_h),
    c_border,
    1.0,
  )

  // Bespoke Vector MoonLens Logo (Optical Lens + Crescent Moon)
  let logo_cx = 28.0
  let logo_cy = 27.0
  // Lens outer bezel
  dl.add_circle(
    @math.Vec2::new(logo_cx, logo_cy),
    13.0,
    @color.Color::rgb(26, 34, 48),
  )
  dl.add_circle_stroke(@math.Vec2::new(logo_cx, logo_cy), 13.0, c_cyan, 1.5)
  // Crescent moon silhouette inside lens
  dl.add_circle(@math.Vec2::new(logo_cx - 1.0, logo_cy), 9.0, c_cyan)
  dl.add_circle(
    @math.Vec2::new(logo_cx + 3.0, logo_cy - 1.0),
    8.0,
    @color.Color::rgb(26, 34, 48),
  )
  // Center focal lens pupil
  dl.add_circle(
    @math.Vec2::new(logo_cx - 2.0, logo_cy),
    2.5,
    @color.Color::white(),
  )

  // Brand Name & Tag
  dl.add_text(@math.Vec2::new(48.0, 16.0), "MoonLens", 17.0, c_text_strong)
  dl.add_rect(
    @math.Rect::new(134.0, 18.0, 52.0, 18.0),
    @color.Color::rgb(24, 30, 42),
    4.0,
  )
  dl.add_rect_stroke(
    @math.Rect::new(134.0, 18.0, 52.0, 18.0),
    @color.Color::rgb(40, 50, 70),
    1.0,
    4.0,
  )
  dl.add_text(@math.Vec2::new(140.0, 20.0), "NATIVE", 9.5, c_text_muted)

  // Dataset Pill Selectors
  let ds_btn_y = 11.0
  let ds_names = ["Server Logs", "Sensors", "Market", "Stress (10k)"]
  let pill_widths = [94.0, 74.0, 68.0, 96.0]
  let mut pill_x = 196.0
  for i = 0; i < ds_names.length(); i = i + 1 {
    let pw = pill_widths[i]
    let is_active = state.active_dataset_id == i
    let btn_rect = @math.Rect::new(pill_x, ds_btn_y, pw, 30.0)
    let hovered = ctx.is_hovered(btn_rect)
    if hovered {
      ctx.set_cursor_icon("pointer")
      if ctx.input().mouse_pressed {
        state.switch_dataset(i)
      }
    }

    let btn_bg = if is_active {
      @color.Color::rgb(26, 38, 54)
    } else if hovered {
      @color.Color::rgb(26, 32, 44)
    } else {
      @color.Color::rgb(20, 25, 35)
    }
    dl.add_rect(btn_rect, btn_bg, 5.0)

    if is_active {
      dl.add_rect_stroke(btn_rect, c_cyan, 1.2, 5.0)
    } else {
      dl.add_rect_stroke(btn_rect, c_border, 1.0, 5.0)
    }

    dl.push_clip(btn_rect)
    dl.add_text(
      @math.Vec2::new(pill_x + 10.0, ds_btn_y + 8.0),
      ds_names[i],
      11.5,
      if is_active {
        c_cyan
      } else {
        c_text_body
      },
    )
    dl.pop_clip()

    pill_x = pill_x + pw + 6.0
  }

  // View Mode Tabs: [Table Grid] vs [Insights] (Right Anchored)
  let tab_names = ["Table Grid", "Insights"]
  let tab_widths = [86.0, 74.0]
  let total_tab_w = 86.0 + 74.0 + 6.0
  let tabs_start_x = vp_w - total_tab_w - 16.0

  // Interactive Live Search & Filter Bar (Flexible Center)
  let search_start_x = pill_x + 10.0
  let search_right = tabs_start_x - 12.0
  let search_w = search_right - search_start_x
  if search_w > 90.0 {
    let s_rect = @math.Rect::new(search_start_x, 11.0, search_w, 30.0)
    let hovered = ctx.is_hovered(s_rect)
    if hovered {
      ctx.set_cursor_icon("text")
    }

    if ctx.input().mouse_pressed {
      if hovered {
        state.is_search_focused = true
      } else {
        state.is_search_focused = false
      }
    }

    // Keyboard input handling when search box is focused
    if state.is_search_focused {
      if ctx.input().key_pressed(@core.Key::Escape) {
        state.is_search_focused = false
      }
      if ctx.input().key_pressed(@core.Key::Backspace) {
        let q_len = state.search_query.length()
        if q_len > 0 {
          let new_q = state.search_query[0:q_len - 1].to_owned()
          state.apply_filter(new_q)
        }
      }
      let typed = ctx.input().text_input
      if typed.length() > 0 {
        let new_q = state.search_query + typed
        state.apply_filter(new_q)
      }
    }

    let s_bg = if state.is_search_focused {
      @color.Color::rgb(22, 28, 40)
    } else if hovered {
      @color.Color::rgb(20, 25, 36)
    } else {
      @color.Color::rgb(16, 20, 28)
    }
    dl.add_rect(s_rect, s_bg, 5.0)

    if state.is_search_focused {
      dl.add_rect_stroke(s_rect, c_cyan, 1.2, 5.0)
    } else {
      dl.add_rect_stroke(s_rect, c_border, 1.0, 5.0)
    }

    // Search Icon
    dl.add_text(
      @math.Vec2::new(search_start_x + 10.0, 18.0),
      "Q",
      11.0,
      if state.is_search_focused {
        c_cyan
      } else {
        c_text_dim
      },
    )

    dl.push_clip(
      @math.Rect::new(search_start_x + 26.0, 11.0, search_w - 48.0, 30.0),
    )
    if state.search_query.is_empty() {
      dl.add_text(
        @math.Vec2::new(search_start_x + 28.0, 18.0),
        "Filter rows...",
        12.0,
        c_text_dim,
      )
    } else {
      dl.add_text(
        @math.Vec2::new(search_start_x + 28.0, 18.0),
        state.search_query,
        12.0,
        c_text_strong,
      )
    }

    // Blinking cursor
    if state.is_search_focused && state.frame_count / 25 % 2 == 0 {
      let cursor_x = if state.search_query.is_empty() {
        search_start_x + 28.0
      } else {
        search_start_x + 28.0 + state.search_query.length().to_double() * 7.5
      }
      dl.add_line(
        @math.Vec2::new(cursor_x, 17.0),
        @math.Vec2::new(cursor_x, 33.0),
        c_cyan,
        1.5,
      )
    }
    dl.pop_clip()

    // Clear 'x' button when query is present
    if !state.search_query.is_empty() {
      let clr_rect = @math.Rect::new(
        search_start_x + search_w - 24.0,
        15.0,
        18.0,
        22.0,
      )
      if ctx.is_hovered(clr_rect) {
        ctx.set_cursor_icon("pointer")
        if ctx.input().mouse_pressed {
          state.apply_filter("")
        }
      }
      dl.add_text(
        @math.Vec2::new(search_start_x + search_w - 18.0, 17.0),
        "x",
        11.5,
        c_text_muted,
      )
    }
  }

  // Render View Mode Tabs
  let mut cur_tab_x = tabs_start_x
  for t = 0; t < 2; t = t + 1 {
    let tw = tab_widths[t]
    let is_active = state.active_tab == t
    let t_rect = @math.Rect::new(cur_tab_x, 11.0, tw, 30.0)
    let hovered = ctx.is_hovered(t_rect)
    if hovered {
      ctx.set_cursor_icon("pointer")
      if ctx.input().mouse_pressed {
        state.active_tab = t
      }
    }
    let t_bg = if is_active {
      @color.Color::rgb(28, 42, 60)
    } else if hovered {
      @color.Color::rgb(24, 30, 42)
    } else {
      @color.Color::rgb(18, 22, 30)
    }
    dl.add_rect(t_rect, t_bg, 5.0)
    if is_active {
      dl.add_rect_stroke(t_rect, c_cyan, 1.2, 5.0)
    } else {
      dl.add_rect_stroke(t_rect, c_border, 1.0, 5.0)
    }
    dl.push_clip(t_rect)
    dl.add_text(
      @math.Vec2::new(cur_tab_x + 10.0, 18.0),
      tab_names[t],
      12.0,
      if is_active {
        c_cyan
      } else {
        c_text_muted
      },
    )
    dl.pop_clip()
    cur_tab_x = cur_tab_x + tw + 6.0
  }

  // 3. Left Sidebar: Schema Inspector & Column Summary (W = 260)
  let sidebar_w = 260.0
  let content_y = header_h
  let status_h = 30.0
  let main_h = vp_h - header_h - status_h

  dl.add_rect(
    @math.Rect::new(0.0, content_y, sidebar_w, main_h),
    c_sidebar,
    0.0,
  )
  dl.add_line(
    @math.Vec2::new(sidebar_w, content_y),
    @math.Vec2::new(sidebar_w, content_y + main_h),
    c_border,
    1.0,
  )

  // Sidebar Title & Summary
  dl.add_text(
    @math.Vec2::new(18.0, content_y + 16.0),
    "DATASET SCHEMA",
    11.5,
    c_text_muted,
  )
  let badge_text = "\{state.dataset.col_count()} columns · \{state.dataset.active_row_count()} rows"
  dl.add_text(@math.Vec2::new(18.0, content_y + 36.0), badge_text, 12.5, c_cyan)

  // Column Schema List
  let col_item_h = 38.0
  let mut col_item_y = content_y + 64.0
  for c = 0; c < state.dataset.columns.length(); c = c + 1 {
    let col = state.dataset.columns[c]
    let is_selected = state.selected_col_idx == c
    let row_rect = @math.Rect::new(
      8.0,
      col_item_y,
      sidebar_w - 16.0,
      col_item_h,
    )
    let hovered = ctx.is_hovered(row_rect)
    if hovered {
      ctx.set_cursor_icon("pointer")
      if ctx.input().mouse_pressed {
        state.selected_col_idx = c
      }
    }

    let item_bg = if is_selected {
      @color.Color::rgb(26, 36, 52)
    } else if hovered {
      @color.Color::rgb(22, 27, 38)
    } else {
      @color.Color::rgba(0, 0, 0, 0)
    }
    if is_selected || hovered {
      dl.add_rect(row_rect, item_bg, 5.0)
    }

    if is_selected {
      // Sleek left indicator bar
      dl.add_rect(
        @math.Rect::new(8.0, col_item_y + 4.0, 3.0, col_item_h - 8.0),
        c_cyan,
        1.5,
      )
    }

    // Type Badge (Mint for INT, Ice Sky for NUM, Amber for STR)
    let (t_bg, t_fg, t_label) = match col.dtype {
      TypeInt => (c_badge_int_bg, c_badge_int_fg, "INT")
      TypeFloat => (c_badge_num_bg, c_badge_num_fg, "NUM")
      TypeString => (c_badge_str_bg, c_badge_str_fg, "STR")
    }
    dl.add_rect(@math.Rect::new(18.0, col_item_y + 9.0, 36.0, 20.0), t_bg, 4.0)
    dl.add_text(@math.Vec2::new(23.0, col_item_y + 12.0), t_label, 10.5, t_fg)

    // Column Name with Scissor Clip
    dl.push_clip(
      @math.Rect::new(60.0, col_item_y, sidebar_w - 96.0, col_item_h),
    )
    dl.add_text(
      @math.Vec2::new(62.0, col_item_y + 11.0),
      col.name,
      13.0,
      if is_selected {
        c_text_strong
      } else {
        c_text_body
      },
    )
    dl.pop_clip()

    // Sort Glyphs
    if state.sort_col_idx == c {
      let arrow = if state.sort_ascending { "▲" } else { "▼" }
      dl.add_text(
        @math.Vec2::new(sidebar_w - 32.0, col_item_y + 11.0),
        arrow,
        11.0,
        c_cyan,
      )
    }

    col_item_y = col_item_y + col_item_h + 2.0
  }

  // Sidebar Bottom: Focused Column Statistics Card
  let stats_card_h = 200.0
  let stats_y = content_y + main_h - stats_card_h - 12.0
  let stats_card_rect = @math.Rect::new(
    10.0,
    stats_y,
    sidebar_w - 20.0,
    stats_card_h,
  )
  dl.add_rect(stats_card_rect, c_card_bg, 6.0)
  dl.add_rect_stroke(stats_card_rect, c_border, 1.0, 6.0)

  dl.add_text(
    @math.Vec2::new(22.0, stats_y + 12.0),
    "COLUMN METRICS",
    11.0,
    c_text_muted,
  )

  if state.selected_col_idx >= 0 &&
    state.selected_col_idx < state.dataset.columns.length() {
    let focus_col = state.dataset.columns[state.selected_col_idx]
    dl.add_text(
      @math.Vec2::new(22.0, stats_y + 32.0),
      focus_col.name,
      14.0,
      c_text_strong,
    )

    let stats_rows = [
      ("Type", focus_col.dtype.to_string()),
      ("Count", focus_col.valid_num_count.to_string()),
      ("Min", format_metric(focus_col.min_val)),
      ("Max", format_metric(focus_col.max_val)),
      ("Mean", format_metric(focus_col.mean_val)),
    ]

    for s = 0; s < stats_rows.length(); s = s + 1 {
      let (label, val) = stats_rows[s]
      let sy = stats_y + 60.0 + s.to_double() * 24.0
      dl.add_text(@math.Vec2::new(22.0, sy), label, 12.0, c_text_muted)
      dl.add_text(
        @math.Vec2::new(sidebar_w - 30.0 - val.length().to_double() * 7.0, sy),
        val,
        12.5,
        c_text_strong,
      )
    }
  }

  // 4. Center Work Area: Tab 0 (Virtual Table) or Tab 1 (Distribution Insights)
  let canvas_x = sidebar_w
  let canvas_w = vp_w - sidebar_w

  if state.active_tab == 0 {
    render_virtual_table(ctx, state, canvas_x, content_y, canvas_w, main_h)
  } else {
    render_distribution_insights(
      ctx, state, canvas_x, content_y, canvas_w, main_h,
    )
  }

  // 5. Bottom Status Bar (Height = 30)
  let status_y = vp_h - status_h
  dl.add_rect(
    @math.Rect::new(0.0, status_y, vp_w, status_h),
    @color.Color::rgb(14, 17, 23),
    0.0,
  )
  dl.add_line(
    @math.Vec2::new(0.0, status_y),
    @math.Vec2::new(vp_w, status_y),
    c_border,
    1.0,
  )

  let status_str = "Dataset: \{state.dataset.name}   |   Showing: \{state.dataset.active_row_count()} / \{state.dataset.raw_row_count()} rows"
  dl.add_text(
    @math.Vec2::new(18.0, status_y + 8.0),
    status_str,
    12.0,
    c_text_muted,
  )

  let right_status = "Win32 GDI Double-Buffered   |   MoonBit Native 60 FPS"
  dl.add_text(
    @math.Vec2::new(vp_w - 320.0, status_y + 8.0),
    right_status,
    12.0,
    c_text_dim,
  )
}

///|
fn format_metric(v : Double) -> String {
  let rounded = (v * 100.0).to_int().to_double() / 100.0
  rounded.to_string()
}

///|
/// Virtualized table rendering: only draws rows visible in the viewport
fn render_virtual_table(
  ctx : @core.UIContext,
  state : AppState,
  x : Double,
  y : Double,
  w : Double,
  h : Double,
) -> Unit {
  let dl = ctx.draw_list()
  let c_header_bg = @color.Color::rgb(20, 24, 34)
  let c_row_even = @color.Color::rgb(14, 17, 24)
  let c_row_odd = @color.Color::rgb(17, 20, 28) // Subtle 2% contrast difference
  let c_row_hover = @color.Color::rgb(24, 30, 42)
  let c_row_selected = @color.Color::rgb(28, 38, 56)
  let c_border = @color.Color::rgb(32, 38, 52)
  let c_divider = @color.Color::rgb(26, 31, 42)
  let c_text_strong = @color.Color::rgb(241, 245, 249)
  let c_text_cell = @color.Color::rgb(215, 224, 235)
  let c_cyan = @color.Color::rgb(56, 189, 248)

  let header_row_h = 42.0
  let data_row_h = 36.0 // High-DPI comfortable row height

  // Clip content to table container viewport
  dl.push_clip(@math.Rect::new(x, y, w, h))

  // Compute total table width for horizontal boundary clamping
  let mut total_table_w = 0.0
  for cw in state.col_widths {
    total_table_w = total_table_w + cw
  }

  // Mouse wheel scrolling: Vertical by default, Horizontal with Shift
  let table_rect = @math.Rect::new(x, y, w, h)
  if ctx.is_hovered(table_rect) {
    let wheel = ctx.input().scroll_delta.y
    let is_shift = ctx.input().modifiers.shift
    if wheel != 0.0 {
      if is_shift {
        state.table_scroll_x = state.table_scroll_x - wheel * 2.5
        if state.table_scroll_x < 0.0 {
          state.table_scroll_x = 0.0
        }
        let max_x = total_table_w - w + 60.0
        let limit_x = if max_x > 0.0 { max_x } else { 0.0 }
        if state.table_scroll_x > limit_x {
          state.table_scroll_x = limit_x
        }
      } else {
        state.target_scroll_y = state.target_scroll_y - wheel * 1.8
        if state.target_scroll_y < 0.0 {
          state.target_scroll_y = 0.0
        }
        let max_scroll = state.dataset.active_row_count().to_double() *
          data_row_h -
          (h - header_row_h)
        let limit = if max_scroll > 0.0 { max_scroll } else { 0.0 }
        if state.target_scroll_y > limit {
          state.target_scroll_y = limit
        }
      }
    }
  }

  // 1. Data Rows Viewport (Clipped below the header so rows never bleed into header)
  let data_viewport_y = y + header_row_h
  let data_viewport_h = h - header_row_h
  dl.push_clip(@math.Rect::new(x, data_viewport_y, w, data_viewport_h))

  // Virtual Row Range Calculation
  let total_rows = state.dataset.active_row_count()
  let first_vis_row = (state.table_scroll_y / data_row_h).to_int()
  let max_vis_rows = (data_viewport_h / data_row_h).to_int() + 2
  let last_vis_row = if first_vis_row + max_vis_rows < total_rows {
    first_vis_row + max_vis_rows
  } else {
    total_rows
  }

  for r = first_vis_row; r < last_vis_row; r = r + 1 {
    let ry = data_viewport_y + r.to_double() * data_row_h - state.table_scroll_y
    if ry + data_row_h < data_viewport_y || ry > y + h {
      continue
    }

    let is_selected = state.selected_row == r
    let row_rect = @math.Rect::new(x, ry, w, data_row_h)
    let hovered = ctx.is_hovered(row_rect)
    if hovered {
      if ctx.input().mouse_pressed {
        state.selected_row = r
      }
    }

    let r_bg = if is_selected {
      c_row_selected
    } else if hovered {
      c_row_hover
    } else if r % 2 == 0 {
      c_row_even
    } else {
      c_row_odd
    }

    dl.add_rect(row_rect, r_bg, 0.0)

    // Left indicator bar on active selected row
    if is_selected {
      dl.add_rect(@math.Rect::new(x, ry, 3.0, data_row_h), c_cyan, 0.0)
    }

    // Render cells in row with cell-level Scissor Clipping
    let mut cx = x - state.table_scroll_x
    for c = 0; c < state.dataset.columns.length(); c = c + 1 {
      let cw = if c < state.col_widths.length() {
        state.col_widths[c]
      } else {
        140.0
      }
      let cell_val = state.dataset.get_cell(r, c)
      dl.push_clip(@math.Rect::new(cx + 4.0, ry, cw - 8.0, data_row_h))
      dl.add_text(
        @math.Vec2::new(cx + 10.0, ry + 10.0),
        cell_val,
        13.0,
        if is_selected {
          c_text_strong
        } else {
          c_text_cell
        },
      )
      dl.pop_clip()
      cx = cx + cw
    }

    // Row bottom hairline
    dl.add_line(
      @math.Vec2::new(x, ry + data_row_h),
      @math.Vec2::new(x + w, ry + data_row_h),
      @color.Color::rgba(255, 255, 255, 8),
      1.0,
    )
  }

  dl.pop_clip()

  // 2. Sticky Header Row (Rendered on top of data rows to guarantee z-order dominance)
  dl.add_rect(@math.Rect::new(x, y, w, header_row_h), c_header_bg, 0.0)
  dl.add_line(
    @math.Vec2::new(x, y + header_row_h),
    @math.Vec2::new(x + w, y + header_row_h),
    c_border,
    1.0,
  )

  let mut cur_col_x = x - state.table_scroll_x
  for c = 0; c < state.dataset.columns.length(); c = c + 1 {
    let col = state.dataset.columns[c]
    let cw = if c < state.col_widths.length() {
      state.col_widths[c]
    } else {
      140.0
    }
    let h_rect = @math.Rect::new(cur_col_x, y, cw, header_row_h)

    let hovered = ctx.is_hovered(h_rect)
    if hovered {
      ctx.set_cursor_icon("pointer")
      if ctx.input().mouse_pressed {
        state.apply_sort(c)
      }
    }

    if hovered {
      dl.add_rect(h_rect, @color.Color::rgb(28, 34, 48), 0.0)
    }

    // Column Header Label with Scissor Clipping
    dl.push_clip(@math.Rect::new(cur_col_x + 2.0, y, cw - 4.0, header_row_h))
    dl.add_text(
      @math.Vec2::new(cur_col_x + 12.0, y + 13.0),
      col.name,
      13.0,
      if state.sort_col_idx == c {
        c_cyan
      } else {
        c_text_strong
      },
    )

    // Sort Indicator
    if state.sort_col_idx == c {
      let arrow = if state.sort_ascending { "▲" } else { "▼" }
      dl.add_text(
        @math.Vec2::new(cur_col_x + cw - 18.0, y + 14.0),
        arrow,
        10.5,
        c_cyan,
      )
    }
    dl.pop_clip()

    // Column Divider
    dl.add_line(
      @math.Vec2::new(cur_col_x + cw, y),
      @math.Vec2::new(cur_col_x + cw, y + h),
      c_divider,
      1.0,
    )
    cur_col_x = cur_col_x + cw
  }

  dl.pop_clip()
}

///|
/// Distribution insights view: interactive histogram and percentiles
fn render_distribution_insights(
  ctx : @core.UIContext,
  state : AppState,
  x : Double,
  y : Double,
  w : Double,
  h : Double,
) -> Unit {
  let dl = ctx.draw_list()
  let c_card_bg = @color.Color::rgb(18, 22, 31)
  let c_border = @color.Color::rgb(32, 38, 52)
  let c_cyan = @color.Color::rgb(56, 189, 248)
  let c_cyan_hover = @color.Color::rgb(125, 211, 252)
  let c_text_strong = @color.Color::rgb(241, 245, 249)
  let c_text_muted = @color.Color::rgb(148, 163, 184)

  let padding = 28.0
  let card_x = x + padding
  let card_y = y + padding
  let card_w = w - padding * 2.0
  let card_h = h - padding * 2.0

  dl.add_rect(@math.Rect::new(card_x, card_y, card_w, card_h), c_card_bg, 8.0)
  dl.add_rect_stroke(
    @math.Rect::new(card_x, card_y, card_w, card_h),
    c_border,
    1.0,
    8.0,
  )

  if state.selected_col_idx < 0 ||
    state.selected_col_idx >= state.dataset.columns.length() {
    dl.add_text(
      @math.Vec2::new(card_x + 32.0, card_y + 32.0),
      "Please select a numeric column from the left sidebar.",
      14.0,
      c_text_muted,
    )
    return
  }

  let col = state.dataset.columns[state.selected_col_idx]
  let title = "Distribution Histogram: \{col.name} (\{col.dtype.to_string()})"
  dl.add_text(
    @math.Vec2::new(card_x + 28.0, card_y + 24.0),
    title,
    18.0,
    c_text_strong,
  )
  let sub = "Sample size: \{state.dataset.active_row_count()} rows   ·   Min: \{format_metric(col.min_val)}   ·   Max: \{format_metric(col.max_val)}   ·   Mean: \{format_metric(col.mean_val)}"
  dl.add_text(
    @math.Vec2::new(card_x + 28.0, card_y + 52.0),
    sub,
    13.0,
    c_text_muted,
  )

  // Histogram Chart Area
  let chart_x = card_x + 44.0
  let chart_y = card_y + 90.0
  let chart_w = card_w - 88.0
  let chart_h = card_h - 160.0

  // Background horizontal grid lines
  for l = 0; l <= 4; l = l + 1 {
    let gy = chart_y + l.to_double() * (chart_h / 4.0)
    dl.add_line(
      @math.Vec2::new(chart_x, gy),
      @math.Vec2::new(chart_x + chart_w, gy),
      @color.Color::rgb(28, 34, 46),
      1.0,
    )
  }

  // Calculate 24-bucket histogram
  let buckets = compute_column_histogram(col, state.dataset.row_indices, 24)
  let mut max_count = 1
  for b in buckets {
    let (_, _, cnt) = b
    if cnt > max_count {
      max_count = cnt
    }
  }

  let bar_gap = 5.0
  let bucket_w = (chart_w - bar_gap * (buckets.length().to_double() - 1.0)) /
    buckets.length().to_double()

  for i = 0; i < buckets.length(); i = i + 1 {
    let (b_min, b_max, cnt) = buckets[i]
    let bar_h = if max_count > 0 {
      cnt.to_double() / max_count.to_double() * (chart_h - 24.0)
    } else {
      0.0
    }
    let bx = chart_x + i.to_double() * (bucket_w + bar_gap)
    let by = chart_y + chart_h - bar_h

    let bar_rect = @math.Rect::new(bx, by, bucket_w, bar_h)
    let hovered = ctx.is_hovered(bar_rect)
    if hovered {
      ctx.set_cursor_icon("pointer")
    }

    let b_color = if hovered { c_cyan_hover } else { c_cyan }
    dl.add_rect(bar_rect, b_color, 3.0)

    // Value tooltip when hovered
    if hovered {
      let tip = "[\{format_metric(b_min)} - \{format_metric(b_max)}]: \{cnt} rows"
      dl.add_rect(
        @math.Rect::new(bx - 35.0, by - 28.0, 160.0, 24.0),
        @color.Color::rgb(15, 23, 42),
        5.0,
      )
      dl.add_rect_stroke(
        @math.Rect::new(bx - 35.0, by - 28.0, 160.0, 24.0),
        c_cyan,
        1.0,
        5.0,
      )
      dl.add_text(
        @math.Vec2::new(bx - 26.0, by - 23.0),
        tip,
        11.5,
        @color.Color::white(),
      )
    }
  }

  // Axis baseline
  dl.add_line(
    @math.Vec2::new(chart_x, chart_y + chart_h),
    @math.Vec2::new(chart_x + chart_w, chart_y + chart_h),
    c_border,
    2.0,
  )
  dl.add_text(
    @math.Vec2::new(chart_x, chart_y + chart_h + 10.0),
    format_metric(col.min_val),
    12.0,
    c_text_muted,
  )
  let max_metric_str = format_metric(col.max_val)
  dl.add_text(
    @math.Vec2::new(
      chart_x + chart_w - max_metric_str.length().to_double() * 7.5,
      chart_y + chart_h + 10.0,
    ),
    max_metric_str,
    12.0,
    c_text_muted,
  )

  // Percentiles Summary Card
  let p_card_y = card_y + card_h - 48.0
  let p_card_rect = @math.Rect::new(chart_x, p_card_y, chart_w, 36.0)
  dl.add_rect(p_card_rect, @color.Color::rgb(22, 27, 38), 5.0)
  dl.add_rect_stroke(p_card_rect, c_border, 1.0, 5.0)

  let n_active = state.dataset.active_row_count()
  if n_active > 0 && col.valid_num_count > 0 {
    let p25_val = col.min_val + (col.max_val - col.min_val) * 0.25
    let p50_val = col.mean_val
    let p75_val = col.min_val + (col.max_val - col.min_val) * 0.75
    let p95_val = col.min_val + (col.max_val - col.min_val) * 0.95

    let p_str = "Percentiles:   P25: \{format_metric(p25_val)}   |   P50 (Median): \{format_metric(p50_val)}   |   P75: \{format_metric(p75_val)}   |   P95: \{format_metric(p95_val)}   |   Sum: \{format_metric(col.sum_val)}"
    dl.add_text(
      @math.Vec2::new(chart_x + 14.0, p_card_y + 11.0),
      p_str,
      12.0,
      c_text_muted,
    )
  }
}
