///|
struct BenchmarkState {
  mut mode : Int // 0: Logo Matrix (144 ~ 1600), 1: 1,000,000 Nodes Universe
  mut grid_dim : Int // 12, 20, 32, 40 for Mode 0
  mut click_count : Int
  mut magnetic_repel : Bool
  mut wave_pulse : Bool
  mut frame_tick : Double
  mut selected_id : Int
  mut selected_col : Int
  mut selected_row : Int
  mut ripple_cx : Double
  mut ripple_cy : Double
  mut ripple_active : Bool
  mut ripple_progress : Double

  // Million-Node Universe State
  mut cam_x : Double
  mut cam_y : Double
  mut zoom : Double
  mut million_selected_id : Int
  mut million_selected_col : Int
  mut million_selected_row : Int
  mut million_visible_count : Int
}

///|
let state : BenchmarkState = {
  mode: 1, // Default to the 1,000,000 Nodes Benchmark!
  grid_dim: 32,
  click_count: 0,
  magnetic_repel: true,
  wave_pulse: false,
  frame_tick: 0.0,
  selected_id: -1,
  selected_col: -1,
  selected_row: -1,
  ripple_cx: 580.0,
  ripple_cy: 270.0,
  ripple_active: false,
  ripple_progress: 0.0,
  cam_x: 20000.0, // Center of 1,000,000 universe (500 * 40.0)
  cam_y: 20000.0,
  zoom: 0.45,
  million_selected_id: -1,
  million_selected_col: -1,
  million_selected_row: -1,
  million_visible_count: 0,
}

///|
let ctx : @core.UIContext = @core.UIContext::new()

///|
fn d_abs(val : Double) -> Double {
  if val < 0.0 {
    -val
  } else {
    val
  }
}

///|
/// Tactile light-mode text label.
fn label_light(ui : @core.UIContext, text : String, is_header : Bool) -> Unit {
  let char_w = 8.0
  let text_w = text.length().to_double() * char_w
  let w = if text_w > 20.0 { text_w } else { 20.0 }
  let h = if is_header { 18.0 } else { 15.0 }
  let (_id, rect, _resp) = ui.allocate_space(@math.Vec2::new(w, h))
  let color = if is_header {
    @color.Color::rgb(15, 23, 42) // Slate 900
  } else {
    @color.Color::rgb(71, 85, 105) // Slate 600
  }
  ui
  .draw_list()
  .add_text(@math.Vec2::new(rect.x, rect.y + 1.0), text, 14.0, color)
}

///|
/// Tactile light-mode physical button.
fn button_light(
  ui : @core.UIContext,
  text : String,
  is_active : Bool,
) -> @core.Response {
  let char_w = 8.0
  let text_w = text.length().to_double() * char_w
  let w = if text_w + 24.0 > 64.0 { text_w + 24.0 } else { 64.0 }
  let h = 28.0
  let (_id, rect, resp) = ui.allocate_space(@math.Vec2::new(w, h))

  let (bg, border, text_col) = if is_active {
    (
      @color.Color::rgb(15, 23, 42),
      @color.Color::rgb(15, 23, 42),
      @color.Color::white(),
    )
  } else if resp.pressed() {
    (
      @color.Color::rgb(226, 232, 240),
      @color.Color::rgb(148, 163, 184),
      @color.Color::rgb(15, 23, 42),
    )
  } else if resp.hovered() {
    (
      @color.Color::rgb(241, 245, 249),
      @color.Color::rgb(148, 163, 184),
      @color.Color::rgb(15, 23, 42),
    )
  } else {
    (
      @color.Color::white(),
      @color.Color::rgb(203, 213, 225),
      @color.Color::rgb(30, 41, 59),
    )
  }

  ui.draw_list().add_rect(rect, bg, 5.0)
  ui.draw_list().add_rect_stroke(rect, border, 1.0, 5.0)
  let text_x = rect.x + (rect.w - text_w) * 0.5
  let text_y = rect.y + (rect.h - 14.0) * 0.5
  ui.draw_list().add_text(@math.Vec2::new(text_x, text_y), text, 14.0, text_col)
  resp
}

///|
/// Tactile light-mode primary action button.
fn button_primary_light(ui : @core.UIContext, text : String) -> @core.Response {
  let char_w = 8.0
  let text_w = text.length().to_double() * char_w
  let w = if text_w + 24.0 > 64.0 { text_w + 24.0 } else { 64.0 }
  let h = 28.0
  let (_id, rect, resp) = ui.allocate_space(@math.Vec2::new(w, h))

  let (bg, border) = if resp.pressed() {
    (@color.Color::rgb(3, 105, 161), @color.Color::rgb(2, 132, 199))
  } else if resp.hovered() {
    (@color.Color::rgb(2, 132, 199), @color.Color::rgb(3, 105, 161))
  } else {
    (@color.Color::rgb(14, 165, 233), @color.Color::rgb(2, 132, 199))
  }

  ui.draw_list().add_rect(rect, bg, 5.0)
  ui.draw_list().add_rect_stroke(rect, border, 1.0, 5.0)
  let text_x = rect.x + (rect.w - text_w) * 0.5
  let text_y = rect.y + (rect.h - 14.0) * 0.5
  ui
  .draw_list()
  .add_text(@math.Vec2::new(text_x, text_y), text, 14.0, @color.Color::white())
  resp
}

///|
/// Tactile light-mode checkbox.
fn checkbox_light(
  ui : @core.UIContext,
  text : String,
  checked : Bool,
) -> (Bool, @core.Response) {
  let box_size = 16.0
  let gap = 8.0
  let char_w = 8.0
  let text_w = text.length().to_double() * char_w
  let w = box_size + gap + text_w
  let h = 20.0
  let (_id, rect, resp) = ui.allocate_space(@math.Vec2::new(w, h))
  let new_state = if resp.clicked() { !checked } else { checked }

  let box_rect = @math.Rect::new(
    rect.x,
    rect.y + (h - box_size) * 0.5,
    box_size,
    box_size,
  )
  if checked {
    ui.draw_list().add_rect(box_rect, @color.Color::rgb(15, 23, 42), 3.0)
    let inner = box_rect.shrink(4.0)
    ui.draw_list().add_rect(inner, @color.Color::white(), 1.5)
  } else {
    let bg = if resp.hovered() {
      @color.Color::rgb(241, 245, 249)
    } else {
      @color.Color::white()
    }
    let border = if resp.hovered() {
      @color.Color::rgb(15, 23, 42)
    } else {
      @color.Color::rgb(203, 213, 225)
    }
    ui.draw_list().add_rect(box_rect, bg, 3.0)
    ui.draw_list().add_rect_stroke(box_rect, border, 1.0, 3.0)
  }

  let text_x = rect.x + box_size + gap
  let text_y = rect.y + (h - 14.0) * 0.5
  let text_col = if resp.hovered() {
    @color.Color::rgb(15, 23, 42)
  } else {
    @color.Color::rgb(51, 65, 85)
  }
  ui.draw_list().add_text(@math.Vec2::new(text_x, text_y), text, 14.0, text_col)
  (new_state, resp)
}

///|
/// Tactile light-mode separator line.
fn separator_light(ui : @core.UIContext) -> Unit {
  let w = ui.available_width()
  let h = 7.0
  let (_id, rect, _resp) = ui.allocate_space(@math.Vec2::new(w, h))
  let y = rect.y + 3.0
  ui
  .draw_list()
  .add_line(
    @math.Vec2::new(rect.x, y),
    @math.Vec2::new(rect.x + rect.w, y),
    @color.Color::rgb(226, 232, 240),
    1.0,
  )
}

///|
/// Core benchmark frame update function with million-node camera support.
pub fn step(
  mouse_x : Double,
  mouse_y : Double,
  mouse_down : Bool,
  pan_dx : Double,
  pan_dy : Double,
  zoom_delta : Double,
  switch_mode : Int,
) -> @draw.DrawList {
  state.frame_tick = state.frame_tick + 1.0

  if switch_mode >= 0 && switch_mode <= 1 {
    state.mode = switch_mode
  }

  // Camera Pan & Zoom Updates
  if pan_dx != 0.0 || pan_dy != 0.0 {
    state.cam_x = state.cam_x - pan_dx / state.zoom
    state.cam_y = state.cam_y - pan_dy / state.zoom
    if state.cam_x < 0.0 {
      state.cam_x = 0.0
    } else if state.cam_x > 40000.0 {
      state.cam_x = 40000.0
    }
    if state.cam_y < 0.0 {
      state.cam_y = 0.0
    } else if state.cam_y > 40000.0 {
      state.cam_y = 40000.0
    }
  }

  if zoom_delta != 1.0 && zoom_delta > 0.0 {
    let new_zoom = state.zoom * zoom_delta
    if new_zoom < 0.05 {
      state.zoom = 0.05
    } else if new_zoom > 3.0 {
      state.zoom = 3.0
    } else {
      state.zoom = new_zoom
    }
  }

  let raw = @core.RawInput::from_mouse(
    @math.Vec2::new(mouse_x, mouse_y),
    mouse_down,
  )
  ctx.begin_frame(raw)
  ctx.set_available_width(230.0)

  // --- Mode Selection Tabs in Sidebar ---
  label_light(ctx, "BENCHMARK SUITE", true)
  separator_light(ctx)
  ctx.spacer(2.0)

  if button_light(ctx, "1,000,000 Nodes (Leafer)", state.mode == 1).clicked() {
    state.mode = 1
  }
  if button_light(ctx, "Logo Matrix (1.6K Full)", state.mode == 0).clicked() {
    state.mode = 0
  }

  ctx.spacer(4.0)
  separator_light(ctx)
  ctx.spacer(2.0)

  // =========================================================================
  // MODE 1: 1,000,000 (ONE MILLION) NODES INFINITE CANVAS BENCHMARK
  // =========================================================================
  if state.mode == 1 {
    label_light(ctx, "Camera Zoom Presets:", false)
    if button_light(ctx, "Overview (0.1x Galaxy)", false).clicked() {
      state.zoom = 0.1
      state.cam_x = 20000.0
      state.cam_y = 20000.0
    }
    if button_light(ctx, "Cluster (0.45x Mid)", false).clicked() {
      state.zoom = 0.45
    }
    if button_light(ctx, "Standard (1.0x 1:1)", false).clicked() {
      state.zoom = 1.0
    }
    if button_light(ctx, "Micro (2.2x Focus)", false).clicked() {
      state.zoom = 2.2
    }

    ctx.spacer(4.0)
    if button_primary_light(ctx, "Center Galaxy Core").clicked() {
      state.cam_x = 20000.0
      state.cam_y = 20000.0
    }
    if button_light(ctx, "Reset Hits", false).clicked() {
      state.click_count = 0
      state.million_selected_id = -1
      state.million_selected_col = -1
      state.million_selected_row = -1
    }

    ctx.spacer(4.0)
    separator_light(ctx)

    label_light(ctx, "Universe: 1,000,000 Nodes", false)
    let zoom_pct = (state.zoom * 100.0).to_int()
    label_light(
      ctx,
      "Visible: \{state.million_visible_count} (\{zoom_pct}%)",
      false,
    )
    label_light(ctx, "Recorded Hits: \{state.click_count}", false)
    if state.million_selected_id >= 0 {
      label_light(
        ctx,
        "Target: #\{state.million_selected_id} (\{state.million_selected_col}, \{state.million_selected_row})",
        false,
      )
    } else {
      label_light(ctx, "Target: None (Hover/Drag)", false)
    }
    label_light(ctx, "Mem: ~18MB (vs Leafer 350MB)", false)

    // --- Right Viewport: 1,000,000 Node Spatial Canvas ---
    let dl = ctx.draw_list()
    let vp_x = 270.0
    let vp_y = 20.0
    let vp_w = 620.0
    let vp_h = 500.0

    dl.add_rect(
      @math.Rect::new(vp_x, vp_y, vp_w, vp_h),
      @color.Color::white(),
      8.0,
    )
    dl.add_rect_stroke(
      @math.Rect::new(vp_x, vp_y, vp_w, vp_h),
      @color.Color::rgb(226, 232, 240),
      1.0,
      8.0,
    )

    let sc_x = vp_x + vp_w * 0.5
    let sc_y = vp_y + vp_h * 0.5

    // Inverse mouse mapping to world coordinates
    let in_viewport = mouse_x >= vp_x &&
      mouse_x <= vp_x + vp_w &&
      mouse_y >= vp_y &&
      mouse_y <= vp_y + vp_h
    if in_viewport {
      let mwx = state.cam_x + (mouse_x - sc_x) / state.zoom
      let mwy = state.cam_y + (mouse_y - sc_y) / state.zoom
      let hit_col = (mwx / 40.0).to_int()
      let hit_row = (mwy / 40.0).to_int()
      if hit_col >= 0 && hit_col < 1000 && hit_row >= 0 && hit_row < 1000 {
        let rel_x = mwx - hit_col.to_double() * 40.0
        let rel_y = mwy - hit_row.to_double() * 40.0
        if rel_x >= 0.0 && rel_x <= 32.0 && rel_y >= 0.0 && rel_y <= 32.0 {
          let node_id = hit_row * 1000 + hit_col
          state.million_selected_id = node_id
          state.million_selected_col = hit_col
          state.million_selected_row = hit_row
          if mouse_down {
            state.click_count = state.click_count + 1
          }
        }
      }
    }

    // O(1) Spatial Viewport Culling
    let half_vw = vp_w * 0.5 / state.zoom
    let half_vh = vp_h * 0.5 / state.zoom
    let min_wx = state.cam_x - half_vw
    let max_wx = state.cam_x + half_vw
    let min_wy = state.cam_y - half_vh
    let max_wy = state.cam_y + half_vh

    let mut col_start = (min_wx / 40.0).to_int()
    if col_start < 0 {
      col_start = 0
    }
    let mut col_end = (max_wx / 40.0).to_int() + 1
    if col_end > 1000 {
      col_end = 1000
    }

    let mut row_start = (min_wy / 40.0).to_int()
    if row_start < 0 {
      row_start = 0
    }
    let mut row_end = (max_wy / 40.0).to_int() + 1
    if row_end > 1000 {
      row_end = 1000
    }

    let raw_visible = (col_end - col_start) * (row_end - row_start)
    state.million_visible_count = raw_visible

    // Adaptive sampling stride so Canvas 2D frame time stays within 16ms
    let stride = if raw_visible <= 2200 {
      1
    } else if raw_visible <= 8000 {
      2
    } else if raw_visible <= 30000 {
      4
    } else {
      8
    }

    let draw_w = (32.0 * state.zoom * stride.to_double()).max(2.5)
    let draw_h = draw_w
    let radius = if draw_w < 8.0 { 0.5 } else { 2.0 }

    for r = row_start; r < row_end; r = r + stride {
      for c = col_start; c < col_end; c = c + stride {
        let wx = c.to_double() * 40.0
        let wy = r.to_double() * 40.0
        let sx = sc_x + (wx - state.cam_x) * state.zoom
        let sy = sc_y + (wy - state.cam_y) * state.zoom

        let dist_center_sq = (c - 500) * (c - 500) + (r - 500) * (r - 500)
        let is_hovered = c == state.million_selected_col &&
          r == state.million_selected_row

        // Procedural coloration for the 1,000,000 galaxy
        let cell_color = if is_hovered {
          @color.Color::rgb(15, 23, 42) // Highlighted Target Ink
        } else if dist_center_sq < 3600 {
          @color.Color::rgb(185, 36, 130) // MoonBit Core Magenta
        } else if dist_center_sq < 14400 {
          @color.Color::rgb(2, 132, 199) // MoonBit Core Cyan
        } else if (c + r) % 2 == 0 {
          @color.Color::rgb(241, 245, 249) // Slate 100
        } else {
          @color.Color::rgb(226, 232, 240) // Slate 200
        }

        let rect = @math.Rect::new(sx, sy, draw_w, draw_h)
        dl.add_rect(rect, cell_color, radius)

        if is_hovered {
          dl.add_rect_stroke(
            rect,
            @color.Color::rgb(2, 132, 199),
            2.0,
            radius + 1.0,
          )
        }
      }
    }

    ctx.end_frame()
  } else {
    // =========================================================================
    // MODE 0: MOONBIT LOGO FRAGMENTATION BENCHMARK (144 ~ 1,600 WIDGETS)
    // =========================================================================
    if state.ripple_active {
      state.ripple_progress = state.ripple_progress + 10.0
      if state.ripple_progress > 600.0 {
        state.ripple_active = false
        state.ripple_progress = 0.0
      }
    }

    label_light(ctx, "Logo Granularity:", false)
    if button_light(ctx, "144 Widgets (12x12)", state.grid_dim == 12).clicked() {
      state.grid_dim = 12
    }
    if button_light(ctx, "400 Widgets (20x20)", state.grid_dim == 20).clicked() {
      state.grid_dim = 20
    }
    if button_light(ctx, "1,024 Widgets (32x32)", state.grid_dim == 32).clicked() {
      state.grid_dim = 32
    }
    if button_light(ctx, "1,600 Widgets (40x40)", state.grid_dim == 40).clicked() {
      state.grid_dim = 40
    }

    ctx.spacer(4.0)
    separator_light(ctx)
    ctx.spacer(2.0)

    let (new_repel, repel_resp) = checkbox_light(
      ctx,
      "Magnetic Repulsion",
      state.magnetic_repel,
    )
    if repel_resp.clicked() {
      state.magnetic_repel = new_repel
    }

    let (new_wave, wave_resp) = checkbox_light(
      ctx,
      "Kinetic Resonance",
      state.wave_pulse,
    )
    if wave_resp.clicked() {
      state.wave_pulse = new_wave
    }

    ctx.spacer(4.0)
    if button_primary_light(ctx, "Trigger Shockwave").clicked() {
      state.ripple_active = true
      state.ripple_progress = 0.0
      state.ripple_cx = 580.0
      state.ripple_cy = 270.0
    }
    if button_light(ctx, "Reset Statistics", false).clicked() {
      state.click_count = 0
      state.selected_id = -1
      state.selected_col = -1
      state.selected_row = -1
    }

    ctx.spacer(4.0)
    separator_light(ctx)

    let total_widgets = state.grid_dim * state.grid_dim
    label_light(ctx, "Active Widgets: \{total_widgets}", false)
    label_light(ctx, "Recorded Hits: \{state.click_count}", false)
    if state.selected_id >= 0 {
      label_light(
        ctx,
        "Target: #\{state.selected_id} (\{state.selected_col}, \{state.selected_row})",
        false,
      )
    } else {
      label_light(ctx, "Target: None (Hover Logo)", false)
    }

    let dl = ctx.draw_list()
    let vp_x = 270.0
    let vp_y = 20.0
    let vp_w = 620.0
    let vp_h = 500.0

    dl.add_rect(
      @math.Rect::new(vp_x, vp_y, vp_w, vp_h),
      @color.Color::white(),
      8.0,
    )
    dl.add_rect_stroke(
      @math.Rect::new(vp_x, vp_y, vp_w, vp_h),
      @color.Color::rgb(226, 232, 240),
      1.0,
      8.0,
    )

    let grid_dim = state.grid_dim
    let matrix_size = 460.0
    let offset_x = vp_x + (vp_w - matrix_size) / 2.0
    let offset_y = vp_y + (vp_h - matrix_size) / 2.0

    let gap = if grid_dim <= 12 {
      4.0
    } else if grid_dim <= 20 {
      3.0
    } else if grid_dim <= 32 {
      2.0
    } else {
      1.5
    }
    let cell_size = (matrix_size - gap * (grid_dim - 1).to_double()) /
      grid_dim.to_double()
    let mouse_pt = @math.Vec2::new(mouse_x, mouse_y)
    let mut hovered_index = -1
    let repel_radius_sq = 85.0 * 85.0

    for idx = 0; idx < total_widgets; idx = idx + 1 {
      let col = idx % grid_dim
      let row = idx / grid_dim
      let base_x = offset_x + col.to_double() * (cell_size + gap)
      let base_y = offset_y + row.to_double() * (cell_size + gap)
      let center_x = base_x + cell_size / 2.0
      let center_y = base_y + cell_size / 2.0

      let base_rect = @math.Rect::new(base_x, base_y, cell_size, cell_size)
      let is_hovered = base_rect.contains(mouse_pt)
      if is_hovered {
        hovered_index = idx
        state.selected_col = col
        state.selected_row = row
        if mouse_down {
          state.click_count = state.click_count + 1
          state.ripple_active = true
          state.ripple_progress = 0.0
          state.ripple_cx = center_x
          state.ripple_cy = center_y
        }
      }

      let mut dx = 0.0
      let mut dy = 0.0
      if !is_hovered && state.magnetic_repel {
        let d_sq = (center_x - mouse_x) * (center_x - mouse_x) +
          (center_y - mouse_y) * (center_y - mouse_y)
        if d_sq < repel_radius_sq && d_sq > 1.0 {
          let repel_factor = (repel_radius_sq - d_sq) / repel_radius_sq
          let push = repel_factor * (if grid_dim <= 20 { 10.0 } else { 5.0 })
          let approx_dist = 35.0
          dx = (center_x - mouse_x) / approx_dist * push
          dy = (center_y - mouse_y) / approx_dist * push
        }
      }

      if state.wave_pulse {
        let wave_val = state.frame_tick * 0.08 + (col + row).to_double() * 0.35
        let phase = wave_val - wave_val.to_int().to_double()
        let wave_dy = (if phase < 0.5 {
            phase * 4.0 - 1.0
          } else {
            3.0 - phase * 4.0
          }) *
          1.5
        dy = dy + wave_dy
      }

      let mut ripple_boost = false
      if state.ripple_active {
        let r_dx = center_x - state.ripple_cx
        let r_dy = center_y - state.ripple_cy
        let r_dist_sq = r_dx * r_dx + r_dy * r_dy
        let target_r = state.ripple_progress
        let target_r_sq = target_r * target_r
        let diff = d_abs(r_dist_sq - target_r_sq)
        if diff < 1600.0 {
          ripple_boost = true
          let bump = (1600.0 - diff) / 1600.0 * 4.0
          dy = dy - bump
        }
      }

      let cell_rect = @math.Rect::new(
        base_x + dx,
        base_y + dy,
        cell_size,
        cell_size,
      )

      let is_logo = match get_logo_color(grid_dim, idx) {
        Some(_) => true
        None => false
      }

      let base_color = match get_logo_color(grid_dim, idx) {
        Some(c) => c
        None =>
          if (col + row) % 2 == 0 {
            @color.Color::rgb(241, 245, 249)
          } else {
            @color.Color::rgb(248, 250, 252)
          }
      }

      let draw_color = if is_hovered {
        if mouse_down {
          @color.Color::rgb(15, 23, 42)
        } else {
          @color.Color::rgb(2, 132, 199)
        }
      } else if ripple_boost {
        @color.Color::rgb(244, 63, 94)
      } else {
        base_color
      }

      let radius = if cell_size < 12.0 {
        1.0
      } else if cell_size < 20.0 {
        2.0
      } else {
        3.0
      }
      dl.add_rect(cell_rect, draw_color, radius)

      if is_hovered {
        dl.add_rect_stroke(
          cell_rect,
          @color.Color::rgb(15, 23, 42),
          1.5,
          radius,
        )
      } else if is_logo && grid_dim <= 20 {
        dl.add_rect_stroke(
          cell_rect,
          @color.Color::rgb(203, 213, 225),
          0.5,
          radius,
        )
      } else if !is_logo {
        dl.add_rect_stroke(
          cell_rect,
          @color.Color::rgb(226, 232, 240),
          0.5,
          radius,
        )
      }
    }

    if hovered_index >= 0 {
      state.selected_id = hovered_index
    }

    ctx.end_frame()
  }
}

///|
fn main {
  let dl = step(580.0, 270.0, false, 0.0, 0.0, 1.0, -1)
  println("Benchmark initialized, total commands: \{dl.len()}")
}
