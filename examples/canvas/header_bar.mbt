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
/// Render native immediate-mode top application header bar on the single canvas viewport.
fn render_benchmark_header_bar(
  ctx : @core.UIContext,
  state : BenchmarkState,
  cur_w : Double,
  cur_h : Double,
  top_bar_h : Double,
) -> String {
  let scale = ctx.style.scale
  let painter = ctx.painter()

  // 1. Header bar background and bottom border
  painter.add_rect(
    @math.Rect::new(0.0, 0.0, cur_w, top_bar_h),
    ctx.theme.bg_window,
    0.0,
  )
  painter.add_line(
    @math.Vec2::new(0.0, top_bar_h),
    @math.Vec2::new(cur_w, top_bar_h),
    ctx.theme.border_muted,
    1.0 * scale,
  )

  let mut nav_url = ""

  ctx.set_cursor(
    @math.Vec2::new(10.0 * scale, (top_bar_h - 26.0 * scale) * 0.5),
  )
  ctx.set_available_width(cur_w - 20.0 * scale)

  ctx.horizontal(fn(row) {
    // Brand Icon (Vector Moon Icon)
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
    let _ = @widgets.badge(row, "CAD", kind=Info)

    row.spacer(6.0 * scale)
    row.separator()
    row.spacer(6.0 * scale)

    // Navigation Links
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
    if @widgets.button_sized(
        row,
        "文档",
        @math.Vec2::new(42.0 * scale, 24.0 * scale),
      ).clicked {
      nav_url = "docs.html"
    }

    row.spacer(6.0 * scale)
    row.separator()
    row.spacer(6.0 * scale)

    // Multi-Scale Matrix Dimensions Segmented Control
    let dim_options = ["128", "256", "512", "1024"]
    let curr_dim_idx = if state.grid_dim == 128 {
      0
    } else if state.grid_dim == 256 {
      1
    } else if state.grid_dim == 512 {
      2
    } else {
      3
    }
    let (new_dim_idx, _) = @widgets.segmented_control(
      row, "bench_hdr_dim", dim_options, curr_dim_idx,
    )
    if new_dim_idx != curr_dim_idx {
      state.grid_dim = if new_dim_idx == 0 {
        128
      } else if new_dim_idx == 1 {
        256
      } else if new_dim_idx == 2 {
        512
      } else {
        1024
      }
      state.selected_id = -1
    }

    row.spacer(6.0 * scale)

    // Physics Buttons
    let pulse_str = if state.wave_pulse { "水波:开" } else { "水波:关" }
    if @widgets.button_sized(
        row,
        pulse_str,
        @math.Vec2::new(56.0 * scale, 24.0 * scale),
      ).clicked {
      state.wave_pulse = !state.wave_pulse
    }
    let repel_str = if state.magnetic_repel {
      "磁力:开"
    } else {
      "磁力:关"
    }
    if @widgets.button_sized(
        row,
        repel_str,
        @math.Vec2::new(56.0 * scale, 24.0 * scale),
      ).clicked {
      state.magnetic_repel = !state.magnetic_repel
    }

    row.spacer(6.0 * scale)

    // Camera Presets
    if @widgets.button_sized(
        row,
        "居中",
        @math.Vec2::new(42.0 * scale, 24.0 * scale),
      ).clicked {
      state.cam_x = 5000.0
      state.cam_y = 5000.0
    }
    if @widgets.button_sized(
        row,
        "全屏",
        @math.Vec2::new(42.0 * scale, 24.0 * scale),
      ).clicked {
      let min_dim = if cur_w < cur_h { cur_w } else { cur_h }
      let fit_z = (min_dim - 60.0) / 10500.0
      state.zoom = if fit_z > 0.01 { fit_z } else { 0.075 }
      state.cam_x = 5000.0
      state.cam_y = 5000.0
    }

    row.spacer(6.0 * scale)

    // Studio IMGUI Window Toggle
    let panel_btn_str = if state.show_studio {
      "隐藏面板"
    } else {
      "控制面板"
    }
    if @widgets.button_sized(
        row,
        panel_btn_str,
        @math.Vec2::new(66.0 * scale, 24.0 * scale),
      ).clicked {
      state.show_studio = !state.show_studio
    }

    row.spacer(10.0 * scale)

    // Right-aligned Telemetry Badges
    let total_nodes = state.grid_dim * state.grid_dim
    let _ = @widgets.badge(
      row,
      total_nodes.to_string() + " 节点",
      kind=Success,
    )
    row.spacer(4.0 * scale)
    let _ = @widgets.badge(
      row,
      (state.zoom * 100.0).to_int().to_string() + "% 缩放",
      kind=Default,
    )
  })

  nav_url
}
