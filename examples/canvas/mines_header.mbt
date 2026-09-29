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
/// Render native immediate-mode top application header bar on the minesweeper canvas.
fn render_mines_header_bar(
  ctx : @core.UIContext,
  st : MinesState,
  vp_w : Double,
  vp_h : Double,
  top_bar_h : Double,
) -> String {
  let scale = ctx.style.scale
  let painter = ctx.painter()

  // 1. Header bar background and bottom border
  painter.add_rect(
    @math.Rect::new(0.0, 0.0, vp_w, top_bar_h),
    ctx.theme.bg_window,
    0.0,
  )
  painter.add_line(
    @math.Vec2::new(0.0, top_bar_h),
    @math.Vec2::new(vp_w, top_bar_h),
    ctx.theme.border_muted,
    1.0 * scale,
  )

  let mut nav_url = ""

  ctx.set_cursor(
    @math.Vec2::new(10.0 * scale, (top_bar_h - 26.0 * scale) * 0.5),
  )
  ctx.set_available_width(vp_w - 20.0 * scale)

  ctx.horizontal(fn(row) {
    // Brand Vector Moon Icon
    let icon_rect = @math.Rect::new(
      row.cursor().x,
      row.cursor().y + 3.0 * scale,
      20.0 * scale,
      20.0 * scale,
    )
    painter.add_rect(icon_rect, @color.Color::hex(0x0F172A), 4.0 * scale)
    painter.add_rect_stroke(
      icon_rect,
      @color.Color::hex(0x38BDF8),
      1.0,
      4.0 * scale,
    )
    let icon_center = @math.Vec2::new(
      icon_rect.x + 10.0 * scale,
      icon_rect.y + 10.0 * scale,
    )
    painter.add_circle(icon_center, 5.5 * scale, @color.Color::hex(0x38BDF8))
    painter.add_circle(
      @math.Vec2::new(icon_center.x + 2.5 * scale, icon_center.y - 1.5 * scale),
      4.2 * scale,
      @color.Color::hex(0x0F172A),
    )
    let _ = row.allocate_space(@math.Vec2::new(20.0 * scale, 24.0 * scale))

    row.spacer(4.0 * scale)
    let _ = row.label_colored("moon-egui", ctx.theme.text_primary)
    let _ = @widgets.badge(row, "扫雷", kind=Info)
    let _ = @widgets.badge(row, "1 亿颗雷", kind=Success)

    row.spacer(6.0 * scale)
    row.separator()
    row.spacer(6.0 * scale)

    // Navigation links
    if @widgets.button_sized(
        row,
        "首页",
        @math.Vec2::new(42.0 * scale, 24.0 * scale),
      ).clicked {
      nav_url = "index.html"
    }
    if @widgets.button_sized(
        row,
        "展厅",
        @math.Vec2::new(42.0 * scale, 24.0 * scale),
      ).clicked {
      nav_url = "gallery.html"
    }

    row.spacer(6.0 * scale)
    row.separator()
    row.spacer(6.0 * scale)

    // Zoom controls: -, reset %, +
    if @widgets.button_sized(
        row,
        "-",
        @math.Vec2::new(24.0 * scale, 24.0 * scale),
      ).clicked {
      mines_zoom_about(st, vp_w * 0.5, vp_h * 0.5, 1.0 / ZOOM_STEP)
    }
    let zoom_pct = (st.cell / DEFAULT_CELL * 100.0).round().to_int()
    if @widgets.button_sized(
        row,
        "\{zoom_pct}%",
        @math.Vec2::new(48.0 * scale, 24.0 * scale),
      ).clicked {
      mines_zoom_about(st, vp_w * 0.5, vp_h * 0.5, DEFAULT_CELL / st.cell)
    }
    if @widgets.button_sized(
        row,
        "+",
        @math.Vec2::new(24.0 * scale, 24.0 * scale),
      ).clicked {
      mines_zoom_about(st, vp_w * 0.5, vp_h * 0.5, ZOOM_STEP)
    }

    row.spacer(6.0 * scale)
    row.separator()
    row.spacer(6.0 * scale)

    // Camera center and restart
    if @widgets.button_sized(
        row,
        "居中",
        @math.Vec2::new(42.0 * scale, 24.0 * scale),
      ).clicked {
      mines_centre_camera(st, vp_w, vp_h)
    }
    if @widgets.button_sized(
        row,
        "重开",
        @math.Vec2::new(42.0 * scale, 24.0 * scale),
      ).clicked {
      st.world = MineWorld::new(mines_next_seed(st.world.seed()))
    }

    row.spacer(6.0 * scale)
    row.separator()
    row.spacer(6.0 * scale)

    // Mode toggles
    let flag_btn = @widgets.button_sized(
      row,
      if st.flag_mode {
        "🚩 插旗:开"
      } else {
        "🚩 插旗:关"
      },
      @math.Vec2::new(76.0 * scale, 24.0 * scale),
    )
    if flag_btn.clicked {
      st.flag_mode = !st.flag_mode
    }

    let pan_btn = @widgets.button_sized(
      row,
      if st.pan_mode {
        "✋ 手形:开"
      } else {
        "✋ 手形:关"
      },
      @math.Vec2::new(76.0 * scale, 24.0 * scale),
    )
    if pan_btn.clicked {
      st.pan_mode = !st.pan_mode
    }

    row.spacer(8.0 * scale)

    // Telemetry Badges
    let rev_str = "翻开: \{st.world.revealed_count()}"
    let _ = @widgets.badge(row, rev_str, kind=Default)
    let flag_str = "旗: \{st.world.flagged_count()}"
    let _ = @widgets.badge(row, flag_str, kind=Info)
    let hits_str = "踩雷: \{st.world.hits()}"
    let _ = @widgets.badge(
      row,
      hits_str,
      kind=if st.world.hits() > 0 { Danger } else { Default },
    )
  })

  nav_url
}

///|
/// Render native immediate-mode bottom status bar and minimap on the minesweeper canvas.
fn render_mines_footer_bar(
  ctx : @core.UIContext,
  st : MinesState,
  vp_w : Double,
  vp_h : Double,
  bottom_bar_h : Double,
  mouse_x : Double,
  mouse_y : Double,
  mouse_down : Bool,
  view_cols : Int,
  view_rows : Int,
) -> Unit {
  let scale = ctx.style.scale
  let painter = ctx.painter()
  let y0 = vp_h - bottom_bar_h

  // 1. Background & top border
  painter.add_rect(
    @math.Rect::new(0.0, y0, vp_w, bottom_bar_h),
    ctx.theme.bg_window,
    0.0,
  )
  painter.add_line(
    @math.Vec2::new(0.0, y0),
    @math.Vec2::new(vp_w, y0),
    ctx.theme.border_muted,
    1.0 * scale,
  )

  ctx.set_cursor(
    @math.Vec2::new(10.0 * scale, y0 + (bottom_bar_h - 20.0 * scale) * 0.5),
  )
  ctx.set_available_width(vp_w - 20.0 * scale)

  let tx = ((mouse_x + st.cam_x) / st.cell).floor().to_int()
  let ty = ((mouse_y + st.cam_y) / st.cell).floor().to_int()
  let in_board = mouse_x >= 0.0 &&
    mouse_x <= vp_w &&
    mouse_y >= 38.0 * scale &&
    mouse_y <= y0

  ctx.horizontal(fn(row) {
    // Coords
    let coords_str = if in_board {
      "光标: (\{tx}, \{ty})"
    } else {
      "光标: —"
    }
    let _ = row.label_colored(coords_str, ctx.theme.text_secondary)

    row.spacer(6.0 * scale)
    row.separator()
    row.spacer(6.0 * scale)

    // Viewport
    let on_screen = view_cols * view_rows
    let view_str = "视口: \{view_cols} × \{view_rows} = \{on_screen}"
    let _ = row.label_colored(view_str, ctx.theme.text_secondary)

    row.spacer(6.0 * scale)
    row.separator()
    row.spacer(6.0 * scale)

    // Domain
    let domain_total = DOMAIN_SIZE * DOMAIN_SIZE
    let ratio = if on_screen > 0 { domain_total / on_screen } else { 0 }
    let domain_str = "全场: 25,600 × 25,600 (≈ 1/\{ratio})"
    let _ = row.label_colored(domain_str, ctx.theme.text_secondary)

    row.spacer(6.0 * scale)
    row.separator()
    row.spacer(6.0 * scale)

    // State
    let state_str = if st.world.is_cascade_pending() {
      "状态: 展开中"
    } else {
      "状态: 就绪"
    }
    let _ = row.label_colored(
      state_str,
      if st.world.is_cascade_pending() {
        @color.Color::accent_primary()
      } else {
        ctx.theme.text_muted
      },
    )

    // Interactive Minimap
    row.spacer(8.0 * scale)
    let map_w = 40.0 * scale
    let map_h = 18.0 * scale
    let map_rect = @math.Rect::new(row.cursor().x, row.cursor().y, map_w, map_h)
    let _ = row.allocate_space(@math.Vec2::new(map_w, map_h))

    // Minimap background & border
    painter.add_rect(map_rect, @color.Color::mines_ground(), 2.0 * scale)
    painter.add_rect_stroke(map_rect, ctx.theme.border_muted, 1.0, 2.0 * scale)

    // Current viewport rectangle in minimap
    let s_x = map_w / DOMAIN_SIZE.to_double()
    let s_y = map_h / DOMAIN_SIZE.to_double()
    let col0 = (st.cam_x / st.cell).floor().to_int()
    let row0 = (st.cam_y / st.cell).floor().to_int()
    let mut vw_box = view_cols.to_double() * s_x
    let mut vh_box = view_rows.to_double() * s_y
    if vw_box < 3.0 * scale {
      vw_box = 3.0 * scale
    }
    if vh_box < 3.0 * scale {
      vh_box = 3.0 * scale
    }
    let mut vx_box = map_rect.x + col0.to_double() * s_x
    let mut vy_box = map_rect.y + row0.to_double() * s_y
    if vx_box < map_rect.x {
      vx_box = map_rect.x
    }
    if vx_box + vw_box > map_rect.x + map_w {
      vx_box = map_rect.x + map_w - vw_box
    }
    if vy_box < map_rect.y {
      vy_box = map_rect.y
    }
    if vy_box + vh_box > map_rect.y + map_h {
      vy_box = map_rect.y + map_h - vh_box
    }
    painter.add_rect(
      @math.Rect::new(vx_box, vy_box, vw_box, vh_box),
      @color.Color::accent_primary(),
      1.0 * scale,
    )

    // Minimap click to jump camera
    if map_rect.contains(@math.Vec2::new(mouse_x, mouse_y)) && mouse_down {
      let fx = (mouse_x - map_rect.x) / map_w
      let fy = (mouse_y - map_rect.y) / map_h
      let target_x = fx * DOMAIN_SIZE.to_double() * st.cell
      let target_y = fy * DOMAIN_SIZE.to_double() * st.cell
      st.cam_x = target_x - vp_w * 0.5
      st.cam_y = target_y - vp_h * 0.5
    }

    row.spacer(8.0 * scale)
    row.separator()
    row.spacer(6.0 * scale)

    // Legend
    let legend = "左键翻开 · 右键插旗 · 拖拽平移 · 滚轮缩放"
    let _ = row.label_colored(legend, ctx.theme.text_muted)
  })
}
