///|
pub struct BenchmarkState {
  mut grid_dim : Int // 128, 256, 512, 1024
  mut wave_pulse : Bool
  mut magnetic_repel : Bool
  mut ripple_active : Bool
  mut ripple_cx : Double
  mut ripple_cy : Double
  mut ripple_progress : Double
  mut frame_tick : Double
  mut click_count : Int

  // Infinite Canvas Camera State
  mut cam_x : Double
  mut cam_y : Double
  mut zoom : Double

  // Node Selection & Inspector State
  mut selected_id : Int
  mut selected_col : Int
  mut selected_row : Int

  // Drag & Interaction State
  mut drag_mode : Int // 0: 漫游画布 (Pan), 1: 拖拽物体 (Drag)
  mut item_drag_dx : Double
  mut item_drag_dy : Double
  mut is_dragging_item : Bool
}

///|
let state : BenchmarkState = {
  grid_dim: 256, // Default to 256x256 (65,536 Nodes)
  wave_pulse: true,
  magnetic_repel: true,
  ripple_active: false,
  ripple_cx: 5000.0,
  ripple_cy: 5000.0,
  ripple_progress: 0.0,
  frame_tick: 0.0,
  click_count: 0,
  cam_x: 5000.0, // Center of 10000x10000 universe
  cam_y: 5000.0,
  zoom: 0.075, // Perfect initial fit overview
  selected_id: -1,
  selected_col: -1,
  selected_row: -1,
  drag_mode: 0,
  item_drag_dx: 0.0,
  item_drag_dy: 0.0,
  is_dragging_item: false,
}

///|
let ctx : @core.UIContext = @core.UIContext::new()

///|
fn get_ruler_step(zoom : Double) -> Double {
  let target = 80.0 / zoom
  if target > 20000.0 {
    50000.0
  } else if target > 10000.0 {
    20000.0
  } else if target > 5000.0 {
    10000.0
  } else if target > 2000.0 {
    5000.0
  } else if target > 1000.0 {
    2000.0
  } else if target > 500.0 {
    1000.0
  } else if target > 200.0 {
    500.0
  } else if target > 100.0 {
    200.0
  } else if target > 50.0 {
    100.0
  } else if target > 20.0 {
    50.0
  } else {
    20.0
  }
}

///|
fn d_abs(val : Double) -> Double {
  if val < 0.0 {
    -val
  } else {
    val
  }
}

///|
/// Core benchmark frame update function supporting 128x128, 256x256, 512x512, 1024x1024.
pub fn step(
  mouse_x : Double,
  mouse_y : Double,
  mouse_down : Bool,
  pan_dx : Double,
  pan_dy : Double,
  zoom_delta : Double,
  switch_mode : Int,
  vp_w : Double,
  vp_h : Double,
) -> @draw.DrawList {
  state.frame_tick = state.frame_tick + 1.0

  // Handle external UI button actions
  if switch_mode >= 0 {
    if switch_mode == 128 {
      state.grid_dim = 128
      state.selected_id = -1
    } else if switch_mode == 256 {
      state.grid_dim = 256
      state.selected_id = -1
    } else if switch_mode == 512 {
      state.grid_dim = 512
      state.selected_id = -1
    } else if switch_mode == 1024 {
      state.grid_dim = 1024
      state.selected_id = -1
    } else if switch_mode == 1 {
      state.wave_pulse = !state.wave_pulse
    } else if switch_mode == 2 {
      state.magnetic_repel = !state.magnetic_repel
    } else if switch_mode == 3 {
      // 适应全屏 (Fit All)
      let min_dim = if vp_w < vp_h { vp_w } else { vp_h }
      let fit_z = (min_dim - 60.0) / 10500.0
      state.zoom = if fit_z > 0.01 { fit_z } else { 0.075 }
      state.cam_x = 5000.0
      state.cam_y = 5000.0
    } else if switch_mode == 4 {
      // 100% Zoom
      state.zoom = 1.0
    } else if switch_mode == 5 {
      // 居中 (Center)
      state.cam_x = 5000.0
      state.cam_y = 5000.0
    } else if switch_mode == 6 {
      state.drag_mode = 1 // 拖拽物体
    } else if switch_mode == 7 {
      state.drag_mode = 0 // 漫游画布
    }
  }

  // Camera Pan
  if pan_dx != 0.0 || pan_dy != 0.0 {
    if state.drag_mode == 1 && state.selected_id >= 0 {
      state.is_dragging_item = true
      state.item_drag_dx = state.item_drag_dx + pan_dx / state.zoom
      state.item_drag_dy = state.item_drag_dy + pan_dy / state.zoom
    } else {
      state.cam_x = state.cam_x - pan_dx / state.zoom
      state.cam_y = state.cam_y - pan_dy / state.zoom
      if state.cam_x < -2000.0 {
        state.cam_x = -2000.0
      } else if state.cam_x > 12000.0 {
        state.cam_x = 12000.0
      }
      if state.cam_y < -2000.0 {
        state.cam_y = -2000.0
      } else if state.cam_y > 12000.0 {
        state.cam_y = 12000.0
      }
    }
  }

  if !mouse_down {
    state.is_dragging_item = false
  }

  // Camera Zoom
  if zoom_delta != 1.0 && zoom_delta > 0.0 {
    let new_zoom = state.zoom * zoom_delta
    if new_zoom < 0.01 {
      state.zoom = 0.01
    } else if new_zoom > 25.0 {
      state.zoom = 25.0
    } else {
      state.zoom = new_zoom
    }
  }

  let raw = @core.RawInput::from_mouse(
    @math.Vec2::new(mouse_x, mouse_y),
    mouse_down,
  )
  ctx.begin_frame(raw)

  let dl = ctx.draw_list()
  let vp_x = 0.0
  let vp_y = 0.0
  let cur_w = if vp_w > 100.0 { vp_w } else { 920.0 }
  let cur_h = if vp_h > 100.0 { vp_h } else { 540.0 }

  let ruler_h = 22.0
  let ruler_w = 48.0
  let cv_x = vp_x + ruler_w
  let cv_y = vp_y + ruler_h
  let cv_w = cur_w - ruler_w
  let cv_h = cur_h - ruler_h

  let sc_x = cv_x + cv_w * 0.5
  let sc_y = cv_y + cv_h * 0.5

  // Matrix geometry parameters
  let grid_dim = state.grid_dim
  let matrix_world_size = 10000.0
  let pitch = matrix_world_size / grid_dim.to_double()
  let gap = if grid_dim <= 128 {
    2.0
  } else if grid_dim <= 256 {
    1.4
  } else if grid_dim <= 512 {
    0.9
  } else {
    0.5
  }
  let cell_size = (pitch - gap).max(0.6)

  // Interactive mouse mapping & hit test
  let in_canvas = mouse_x >= cv_x &&
    mouse_x <= cv_x + cv_w &&
    mouse_y >= cv_y &&
    mouse_y <= cv_y + cv_h

  let mwx = state.cam_x + (mouse_x - sc_x) / state.zoom
  let mwy = state.cam_y + (mouse_y - sc_y) / state.zoom

  if in_canvas &&
    mwx >= 0.0 &&
    mwx < matrix_world_size &&
    mwy >= 0.0 &&
    mwy < matrix_world_size {
    let col = (mwx / pitch).to_int()
    let row = (mwy / pitch).to_int()
    if col >= 0 && col < grid_dim && row >= 0 && row < grid_dim {
      let node_id = row * grid_dim + col
      if mouse_down {
        state.click_count = state.click_count + 1
        if state.selected_id != node_id {
          state.selected_id = node_id
          state.selected_col = col
          state.selected_row = row
          state.item_drag_dx = 0.0
          state.item_drag_dy = 0.0
        }
        // Launch dynamic water ripple from click origin
        state.ripple_active = true
        state.ripple_cx = col.to_double() * pitch + pitch * 0.5
        state.ripple_cy = row.to_double() * pitch + pitch * 0.5
        state.ripple_progress = 0.0
      }
    }
  }

  // Update dynamic water ripple expansion
  if state.ripple_active {
    state.ripple_progress = state.ripple_progress + pitch * 1.6
    if state.ripple_progress > matrix_world_size * 0.6 {
      state.ripple_active = false
      state.ripple_progress = 0.0
    }
  }

  // O(1) Spatial Viewport Culling Bounds
  let half_vw = cv_w * 0.5 / state.zoom
  let half_vh = cv_h * 0.5 / state.zoom
  let min_wx = state.cam_x - half_vw
  let max_wx = state.cam_x + half_vw
  let min_wy = state.cam_y - half_vh
  let max_wy = state.cam_y + half_vh

  let mut c_start = (min_wx / pitch).to_int()
  if c_start < 0 {
    c_start = 0
  }
  let mut c_end = (max_wx / pitch).to_int() + 1
  if c_end > grid_dim {
    c_end = grid_dim
  }

  let mut r_start = (min_wy / pitch).to_int()
  if r_start < 0 {
    r_start = 0
  }
  let mut r_end = (max_wy / pitch).to_int() + 1
  if r_end > grid_dim {
    r_end = grid_dim
  }

  // 1. Clip workspace content
  dl.push_clip(@math.Rect::new(cv_x, cv_y, cv_w, cv_h))

  // Major Coordinate Aisles / Network Lines
  let aisle_col = @color.Color::rgb(226, 232, 240)
  for bi = 0; bi <= 10; bi = bi + 1 {
    let aisle_wx = bi.to_double() * 1000.0
    let aisle_sx = sc_x + (aisle_wx - state.cam_x) * state.zoom
    if aisle_sx >= cv_x && aisle_sx <= cv_x + cv_w {
      dl.add_line(
        @math.Vec2::new(aisle_sx, cv_y),
        @math.Vec2::new(aisle_sx, cv_y + cv_h),
        aisle_col,
        1.0,
      )
    }
    let aisle_wy = bi.to_double() * 1000.0
    let aisle_sy = sc_y + (aisle_wy - state.cam_y) * state.zoom
    if aisle_sy >= cv_y && aisle_sy <= cv_y + cv_h {
      dl.add_line(
        @math.Vec2::new(cv_x, aisle_sy),
        @math.Vec2::new(cv_x + cv_w, aisle_sy),
        aisle_col,
        1.0,
      )
    }
  }

  // =========================================================================
  // MULTI-LOD LOGO RENDERING PIPELINE:
  // When unit_px < 4.0: High-Res GPU Offscreen Baked Texture is rendered by run.js
  // When unit_px >= 4.0: MoonBit native interactive vector cells rendered directly
  // =========================================================================
  let unit_px = pitch * state.zoom
  let repel_radius = pitch * 4.5
  let repel_radius_sq = repel_radius * repel_radius

  if unit_px >= 4.0 {
    let on_screen_cell_w = cell_size * state.zoom
    let on_screen_cell_h = cell_size * state.zoom
    let rect_radius = if on_screen_cell_w > 12.0 {
      2.5
    } else if on_screen_cell_w > 6.0 {
      1.5
    } else {
      0.0
    }

    for r = r_start; r < r_end; r = r + 1 {
      let base_wy = r.to_double() * pitch
      for c = c_start; c < c_end; c = c + 1 {
        let base_wx = c.to_double() * pitch
        let node_id = r * grid_dim + c
        let is_selected = node_id == state.selected_id
        let is_dragged = is_selected &&
          (
            state.item_drag_dx != 0.0 ||
            state.item_drag_dy != 0.0 ||
            state.is_dragging_item
          )

        // Physics: Magnetic Repel
        let mut pdx = 0.0
        let mut pdy = 0.0
        if state.magnetic_repel && in_canvas {
          let c_center_x = base_wx + pitch * 0.5
          let c_center_y = base_wy + pitch * 0.5
          let dist_sq = (c_center_x - mwx) * (c_center_x - mwx) +
            (c_center_y - mwy) * (c_center_y - mwy)
          if dist_sq < repel_radius_sq && dist_sq > 0.1 {
            let repel_factor = (repel_radius_sq - dist_sq) / repel_radius_sq
            let push = repel_factor * pitch * 0.8
            pdx = (c_center_x - mwx) / repel_radius * push
            pdy = (c_center_y - mwy) / repel_radius * push
          }
        }

        // Physics: Wave Pulse
        if state.wave_pulse {
          let wave_val = state.frame_tick * 0.07 + (c + r).to_double() * 0.25
          let phase = wave_val - (wave_val / 6.283).to_int().to_double() * 6.283
          let wave_dy = if phase < 3.14159 {
            (phase / 3.14159 * 2.0 - 1.0) * pitch * 0.12
          } else {
            (1.0 - (phase - 3.14159) / 3.14159 * 2.0) * pitch * 0.12
          }
          pdy = pdy + wave_dy
        }

        // Physics: Water Ripple Wavefront
        let mut ripple_bright = false
        if state.ripple_active {
          let rx = base_wx - state.ripple_cx
          let ry = base_wy - state.ripple_cy
          let r_dist = rx * rx + ry * ry
          let target_dist = state.ripple_progress * state.ripple_progress
          let diff = d_abs(r_dist - target_dist)
          if diff < pitch * pitch * 36.0 {
            ripple_bright = true
            pdy = pdy - pitch * 0.3
          }
        }

        let cur_wx = if is_dragged {
          base_wx + state.item_drag_dx + pdx
        } else {
          base_wx + pdx
        }
        let cur_wy = if is_dragged {
          base_wy + state.item_drag_dy + pdy
        } else {
          base_wy + pdy
        }
        let sx = sc_x + (cur_wx - state.cam_x) * state.zoom
        let sy = sc_y + (cur_wy - state.cam_y) * state.zoom

        // Determine node color
        let is_hovered = in_canvas &&
          mwx >= base_wx &&
          mwx < base_wx + pitch &&
          mwy >= base_wy &&
          mwy < base_wy + pitch
        let cell_color = if is_selected {
          @color.Color::rgb(244, 63, 94) // Active Selected Rose
        } else if is_hovered {
          @color.Color::rgb(56, 189, 248) // Hover Cyan
        } else if ripple_bright {
          @color.Color::rgb(251, 146, 60) // Ripple Amber
        } else {
          match get_logo_color(grid_dim, c, r) {
            Some(lc) => lc
            None =>
              if (c + r) % 2 == 0 {
                @color.Color::rgb(255, 255, 255) // Pure White
              } else {
                @color.Color::rgb(241, 245, 249) // Slate-100 Light Gray
              }
          }
        }

        dl.add_rect(
          @math.Rect::new(sx, sy, on_screen_cell_w, on_screen_cell_h),
          cell_color,
          rect_radius,
        )

        if on_screen_cell_w > 16.0 {
          let border_col = if is_hovered {
            @color.Color::rgb(37, 99, 235)
          } else {
            @color.Color::rgb(226, 232, 240)
          }
          dl.add_rect_stroke(
            @math.Rect::new(sx, sy, on_screen_cell_w, on_screen_cell_h),
            border_col,
            0.5,
            rect_radius,
          )
        }
      }
    }
  }

  // Selected Item Transform Frame, Corner Handles & Probe Tooltip
  if state.selected_id >= 0 {
    let sel_id = state.selected_id
    let r = sel_id / grid_dim
    let c = sel_id % grid_dim
    let is_dragged = state.item_drag_dx != 0.0 ||
      state.item_drag_dy != 0.0 ||
      state.is_dragging_item
    let sel_orig_wx = c.to_double() * pitch
    let sel_orig_wy = r.to_double() * pitch
    let sel_wx = if is_dragged {
      sel_orig_wx + state.item_drag_dx
    } else {
      sel_orig_wx
    }
    let sel_wy = if is_dragged {
      sel_orig_wy + state.item_drag_dy
    } else {
      sel_orig_wy
    }
    let sel_sx = sc_x + (sel_wx - state.cam_x) * state.zoom
    let sel_sy = sc_y + (sel_wy - state.cam_y) * state.zoom
    let sel_w = (cell_size * state.zoom).max(8.0)
    let sel_h = (cell_size * state.zoom).max(8.0)

    // 1. Purple Outline
    dl.add_rect_stroke(
      @math.Rect::new(sel_sx - 3.0, sel_sy - 3.0, sel_w + 6.0, sel_h + 6.0),
      @color.Color::rgb(139, 92, 246),
      1.5,
      2.0,
    )

    // 2. 4 Circular Corner Handles
    let handle_r = 3.0
    let h_purple = @color.Color::rgb(139, 92, 246)
    let h_white = @color.Color::white()

    let tl_pos = @math.Vec2::new(sel_sx - 3.0, sel_sy - 3.0)
    dl.add_circle(tl_pos, handle_r, h_white)
    dl.add_circle_stroke(tl_pos, handle_r, h_purple, 1.5)

    let tr_pos = @math.Vec2::new(sel_sx + sel_w + 3.0, sel_sy - 3.0)
    dl.add_circle(tr_pos, handle_r, h_white)
    dl.add_circle_stroke(tr_pos, handle_r, h_purple, 1.5)

    let bl_pos = @math.Vec2::new(sel_sx - 3.0, sel_sy + sel_h + 3.0)
    dl.add_circle(bl_pos, handle_r, h_white)
    dl.add_circle_stroke(bl_pos, handle_r, h_purple, 1.5)

    let br_pos = @math.Vec2::new(sel_sx + sel_w + 3.0, sel_sy + sel_h + 3.0)
    dl.add_circle(br_pos, handle_r, h_white)
    dl.add_circle_stroke(br_pos, handle_r, h_purple, 1.5)

    // 3. Floating Inspector Tag
    let tag_txt = if is_dragged {
      "DRAGGING #\{sel_id} [X:\{c}, Y:\{r}]"
    } else {
      "#\{sel_id} [X:\{c}, Y:\{r}]"
    }
    let tag_w = tag_txt.length().to_double() * 7.0 + 16.0
    dl.add_rect(
      @math.Rect::new(
        sel_sx + (sel_w - tag_w) * 0.5,
        sel_sy - 24.0,
        tag_w,
        18.0,
      ),
      @color.Color::rgb(255, 255, 255),
      4.0,
    )
    dl.add_rect_stroke(
      @math.Rect::new(
        sel_sx + (sel_w - tag_w) * 0.5,
        sel_sy - 24.0,
        tag_w,
        18.0,
      ),
      @color.Color::rgb(203, 213, 225),
      1.0,
      4.0,
    )
    dl.add_text(
      @math.Vec2::new(sel_sx + (sel_w - tag_w) * 0.5 + 8.0, sel_sy - 22.0),
      tag_txt,
      10.0,
      @color.Color::rgb(15, 23, 42),
    )
  }

  // End workspace clipping
  dl.pop_clip()

  // =========================================================================
  // LIGHT CAD COORDINATE RULERS (TOP & LEFT)
  // =========================================================================
  let ruler_bg = @color.Color::rgb(255, 255, 255)
  let ruler_border = @color.Color::rgb(226, 232, 240)
  let ruler_tick_col = @color.Color::rgb(148, 163, 184)
  let ruler_text_col = @color.Color::rgb(71, 85, 105)

  // Top Ruler Background & Border
  dl.add_rect(@math.Rect::new(cv_x, vp_y, cv_w, ruler_h), ruler_bg, 0.0)
  dl.add_line(
    @math.Vec2::new(cv_x, vp_y + ruler_h),
    @math.Vec2::new(cv_x + cv_w, vp_y + ruler_h),
    ruler_border,
    1.0,
  )

  // Left Ruler Background & Border
  dl.add_rect(@math.Rect::new(vp_x, cv_y, ruler_w, cv_h), ruler_bg, 0.0)
  dl.add_line(
    @math.Vec2::new(vp_x + ruler_w, cv_y),
    @math.Vec2::new(vp_x + ruler_w, cv_y + cv_h),
    ruler_border,
    1.0,
  )

  // Top-Left Corner Box
  dl.add_rect(
    @math.Rect::new(vp_x, vp_y, ruler_w, ruler_h),
    @color.Color::rgb(248, 250, 252),
    0.0,
  )
  dl.add_text(
    @math.Vec2::new(vp_x + 16.0, vp_y + 4.0),
    "px",
    10.0,
    ruler_text_col,
  )

  // Draw Top Ruler Ticks & Coordinate Labels
  let step_x = get_ruler_step(state.zoom)
  let first_tick_x = (min_wx / step_x).to_int().to_double() * step_x
  let mut cur_wx = first_tick_x
  while cur_wx <= max_wx {
    let sx = sc_x + (cur_wx - state.cam_x) * state.zoom
    if sx >= cv_x && sx <= cv_x + cv_w {
      dl.add_line(
        @math.Vec2::new(sx, vp_y + ruler_h - 8.0),
        @math.Vec2::new(sx, vp_y + ruler_h),
        ruler_tick_col,
        1.0,
      )
      let label_txt = cur_wx.to_int().to_string()
      dl.add_text(
        @math.Vec2::new(sx + 3.0, vp_y + 3.0),
        label_txt,
        9.0,
        ruler_text_col,
      )
    }
    cur_wx = cur_wx + step_x
  }

  // Draw Left Ruler Ticks & Coordinate Labels
  let step_y = get_ruler_step(state.zoom)
  let first_tick_y = (min_wy / step_y).to_int().to_double() * step_y
  let mut cur_wy = first_tick_y
  while cur_wy <= max_wy {
    let sy = sc_y + (cur_wy - state.cam_y) * state.zoom
    if sy >= cv_y && sy <= cv_y + cv_h {
      dl.add_line(
        @math.Vec2::new(vp_x + ruler_w - 8.0, sy),
        @math.Vec2::new(vp_x + ruler_w, sy),
        ruler_tick_col,
        1.0,
      )
      let label_txt = cur_wy.to_int().to_string()
      dl.add_text(
        @math.Vec2::new(vp_x + 2.0, sy - 5.0),
        label_txt,
        9.0,
        ruler_text_col,
      )
    }
    cur_wy = cur_wy + step_y
  }

  // Top & Left Ruler Projection Indicators when Selected
  if state.selected_id >= 0 {
    let sel_id = state.selected_id
    let r = sel_id / grid_dim
    let c = sel_id % grid_dim
    let is_dragged = state.item_drag_dx != 0.0 ||
      state.item_drag_dy != 0.0 ||
      state.is_dragging_item
    let sel_orig_wx = c.to_double() * pitch
    let sel_orig_wy = r.to_double() * pitch
    let sel_wx = if is_dragged {
      sel_orig_wx + state.item_drag_dx
    } else {
      sel_orig_wx
    }
    let sel_wy = if is_dragged {
      sel_orig_wy + state.item_drag_dy
    } else {
      sel_orig_wy
    }
    let sel_sx = sc_x + (sel_wx - state.cam_x) * state.zoom
    let sel_sy = sc_y + (sel_wy - state.cam_y) * state.zoom
    let sel_sw = (cell_size * state.zoom).max(8.0)
    let sel_sh = (cell_size * state.zoom).max(8.0)

    // Top Ruler Projection Highlight
    if sel_sx + sel_sw >= cv_x && sel_sx <= cv_x + cv_w {
      let proj_x = sel_sx.max(cv_x)
      let proj_w = sel_sw.max(16.0)
      dl.add_rect(
        @math.Rect::new(proj_x, vp_y, proj_w, ruler_h),
        @color.Color::rgba(139, 92, 246, 40),
        0.0,
      )
      dl.add_line(
        @math.Vec2::new(proj_x, vp_y),
        @math.Vec2::new(proj_x, vp_y + ruler_h),
        @color.Color::rgb(139, 92, 246),
        1.5,
      )
      let coord_txt = sel_wx.to_int().to_string()
      dl.add_text(
        @math.Vec2::new(proj_x + 2.0, vp_y + 2.0),
        coord_txt,
        9.0,
        @color.Color::rgb(109, 40, 217),
      )
    }

    // Left Ruler Projection Highlight
    if sel_sy + sel_sh >= cv_y && sel_sy <= cv_y + cv_h {
      let proj_y = sel_sy.max(cv_y)
      let proj_h = sel_sh.max(16.0)
      dl.add_rect(
        @math.Rect::new(vp_x, proj_y, ruler_w, proj_h),
        @color.Color::rgba(139, 92, 246, 40),
        0.0,
      )
      dl.add_line(
        @math.Vec2::new(vp_x, proj_y),
        @math.Vec2::new(vp_x + ruler_w, proj_y),
        @color.Color::rgb(139, 92, 246),
        1.5,
      )
      let coord_txt = sel_wy.to_int().to_string()
      dl.add_text(
        @math.Vec2::new(vp_x + 2.0, proj_y),
        coord_txt,
        9.0,
        @color.Color::rgb(109, 40, 217),
      )
    }
  }

  ctx.end_frame()
}

///|
pub fn get_grid_dim() -> Int {
  state.grid_dim
}

///|
pub fn get_zoom() -> Double {
  state.zoom
}

///|
pub fn get_cam_x() -> Double {
  state.cam_x
}

///|
pub fn get_cam_y() -> Double {
  state.cam_y
}

///|
pub fn get_selected_id() -> Int {
  state.selected_id
}

///|
pub fn is_wave_pulse() -> Bool {
  state.wave_pulse
}

///|
pub fn is_magnetic_repel() -> Bool {
  state.magnetic_repel
}

///|
fn main {
  let dl = step(580.0, 270.0, false, 0.0, 0.0, 1.0, -1, 920.0, 540.0)
  println("Benchmark initialized, total commands: \{dl.len()}")
}
