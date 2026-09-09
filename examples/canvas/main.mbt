///|
struct BenchmarkState {
  mut grid_dim : Int
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
}

///|
let state : BenchmarkState = {
  grid_dim: 32, // Default 32x32 = 1,024 widgets!
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
/// Core benchmark frame update function.
pub fn step(
  mouse_x : Double,
  mouse_y : Double,
  mouse_down : Bool,
) -> @draw.DrawList {
  state.frame_tick = state.frame_tick + 1.0
  if state.ripple_active {
    state.ripple_progress = state.ripple_progress + 10.0
    if state.ripple_progress > 600.0 {
      state.ripple_active = false
      state.ripple_progress = 0.0
    }
  }

  let raw = @core.RawInput::from_mouse(
    @math.Vec2::new(mouse_x, mouse_y),
    mouse_down,
  )
  ctx.begin_frame(raw)
  ctx.set_available_width(230.0)

  // --- Sidebar Controls ---
  let _ = ctx.label("STRESS PROFILE")
  ctx.separator()
  ctx.spacer(2.0)

  let _ = ctx.label("Logo Granularity:")
  if ctx.button("144 Widgets (12x12)").clicked() {
    state.grid_dim = 12
  }
  if ctx.button("400 Widgets (20x20)").clicked() {
    state.grid_dim = 20
  }
  if ctx.button("1,024 Widgets (32x32)").clicked() {
    state.grid_dim = 32
  }
  if ctx.button("1,600 Widgets (40x40)").clicked() {
    state.grid_dim = 40
  }

  ctx.spacer(4.0)
  ctx.separator()
  ctx.spacer(2.0)

  let (new_repel, repel_resp) = ctx.checkbox(
    "Magnetic Repulsion",
    state.magnetic_repel,
  )
  if repel_resp.clicked() {
    state.magnetic_repel = new_repel
  }

  let (new_wave, wave_resp) = ctx.checkbox(
    "Kinetic Resonance",
    state.wave_pulse,
  )
  if wave_resp.clicked() {
    state.wave_pulse = new_wave
  }

  ctx.spacer(4.0)
  if ctx.button_primary("Trigger Shockwave").clicked() {
    state.ripple_active = true
    state.ripple_progress = 0.0
    state.ripple_cx = 580.0
    state.ripple_cy = 270.0
  }
  if ctx.button("Reset Statistics").clicked() {
    state.click_count = 0
    state.selected_id = -1
    state.selected_col = -1
    state.selected_row = -1
  }

  ctx.spacer(4.0)
  ctx.separator()

  let total_widgets = state.grid_dim * state.grid_dim
  let _ = ctx.label("Active Widgets: \{total_widgets}")
  let _ = ctx.label("Recorded Hits: \{state.click_count}")
  if state.selected_id >= 0 {
    let _ = ctx.label(
      "Target: #\{state.selected_id} (\{state.selected_col}, \{state.selected_row})",
    )
  } else {
    let _ = ctx.label("Target: None (Hover Logo)")
  }

  // --- Right Viewport: Logo Fragmentation Matrix ---
  let dl = ctx.draw_list()
  let vp_x = 270.0
  let vp_y = 20.0
  let vp_w = 620.0
  let vp_h = 500.0

  // Background panel for logo matrix
  dl.add_rect(
    @math.Rect::new(vp_x, vp_y, vp_w, vp_h),
    @color.Color::rgb(13, 15, 23),
    8.0,
  )
  dl.add_rect_stroke(
    @math.Rect::new(vp_x, vp_y, vp_w, vp_h),
    @color.Color::rgb(38, 43, 61),
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

    // Hit-testing against base anchor coordinates
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

    // Magnetic Repulsion Offset for neighbor cells
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

    // Kinetic Wave Pulse
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

    // Shockwave ripple effect
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
          @color.Color::rgb(20, 24, 36)
        } else {
          @color.Color::rgb(25, 30, 44)
        }
    }

    let draw_color = if is_hovered {
      if mouse_down {
        @color.Color::rgb(255, 255, 255)
      } else {
        @color.Color::rgb(56, 189, 248)
      }
    } else if ripple_boost {
      @color.Color::rgb(244, 114, 182)
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
        @color.Color::rgb(255, 255, 255),
        1.5,
        radius,
      )
    } else if is_logo && grid_dim <= 20 {
      // Light border around larger logo cells
      dl.add_rect_stroke(cell_rect, @color.Color::rgb(48, 55, 78), 0.5, radius)
    }
  }

  if hovered_index >= 0 {
    state.selected_id = hovered_index
  }

  ctx.end_frame()
}

///|
fn main {
  let dl = step(580.0, 270.0, false)
  println("Benchmark initialized, total commands: \{dl.len()}")
}
