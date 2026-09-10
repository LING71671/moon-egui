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
fn handle_node_hit_test(
  state : BenchmarkState,
  ctx : @core.UIContext,
  mouse_down : Bool,
  in_canvas : Bool,
  mwx : Double,
  mwy : Double,
  pitch : Double,
  grid_dim : Int,
  matrix_world_size : Double,
) -> Unit {
  let can_hit_nodes = in_canvas &&
    !ctx.wants_capture_mouse() &&
    mwx >= 0.0 &&
    mwx < matrix_world_size &&
    mwy >= 0.0 &&
    mwy < matrix_world_size

  if can_hit_nodes {
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
}

///|
fn update_ripple_physics(
  state : BenchmarkState,
  matrix_world_size : Double,
  pitch : Double,
) -> Unit {
  if state.ripple_active {
    state.ripple_progress = state.ripple_progress + pitch * 1.6
    if state.ripple_progress > matrix_world_size * 0.6 {
      state.ripple_active = false
      state.ripple_progress = 0.0
    }
  }
}

///|
fn calc_culling_bounds(
  state : BenchmarkState,
  cv_w : Double,
  cv_h : Double,
  pitch : Double,
  grid_dim : Int,
) -> (Int, Int, Int, Int, Int, Double, Double, Double, Double) {
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

  let total_vis = if c_end > c_start && r_end > r_start {
    (c_end - c_start) * (r_end - r_start)
  } else {
    0
  }
  state.visible_cells = total_vis

  (c_start, c_end, r_start, r_end, total_vis, min_wx, max_wx, min_wy, max_wy)
}

///|
fn render_matrix_nodes(
  dl : @draw.DrawList,
  state : BenchmarkState,
  in_canvas : Bool,
  mouse_x : Double,
  mouse_y : Double,
  cv_x : Double,
  cv_y : Double,
  cv_w : Double,
  cv_h : Double,
  sc_x : Double,
  sc_y : Double,
  grid_dim : Int,
  pitch : Double,
  cell_size : Double,
  mwx : Double,
  mwy : Double,
  c_start : Int,
  c_end : Int,
  r_start : Int,
  r_end : Int,
  total_vis : Int,
  matrix_world_size : Double,
) -> Bool {
  dl.push_clip(@math.Rect::new(cv_x, cv_y, cv_w, cv_h))

  let repel_radius = pitch * 4.5
  let repel_radius_sq = repel_radius * repel_radius

  let is_micro_vector = total_vis <= 4000

  if is_micro_vector {
    let on_screen_cell_w = cell_size * state.zoom
    let on_screen_cell_h = cell_size * state.zoom
    let rect_radius = 0.0

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

        if is_hovered {
          dl.add_rect_stroke(
            @math.Rect::new(sx, sy, on_screen_cell_w, on_screen_cell_h),
            @color.Color::rgb(37, 99, 235),
            1.5,
            0.0,
          )
        }
      }
    }
  } else {
    // Macro / Texture LOD Mode:
    // Render dynamic hover indicator, ripple wavefront & magnetic indicator on top of texture
    if in_canvas &&
      mwx >= 0.0 &&
      mwx < matrix_world_size &&
      mwy >= 0.0 &&
      mwy < matrix_world_size {
      let h_col = (mwx / pitch).to_int()
      let h_row = (mwy / pitch).to_int()
      if h_col >= 0 && h_col < grid_dim && h_row >= 0 && h_row < grid_dim {
        let h_base_wx = h_col.to_double() * pitch
        let h_base_wy = h_row.to_double() * pitch
        let hs_x = sc_x + (h_base_wx - state.cam_x) * state.zoom
        let hs_y = sc_y + (h_base_wy - state.cam_y) * state.zoom
        let hs_w = (cell_size * state.zoom).max(4.0)
        let hs_h = (cell_size * state.zoom).max(4.0)
        dl.add_rect(
          @math.Rect::new(hs_x, hs_y, hs_w, hs_h),
          @color.Color::rgb(56, 189, 248),
          0.0,
        )
      }
    }
    if state.ripple_active {
      let rip_sx = sc_x + (state.ripple_cx - state.cam_x) * state.zoom
      let rip_sy = sc_y + (state.ripple_cy - state.cam_y) * state.zoom
      let rip_r = state.ripple_progress * state.zoom
      if rip_r > 1.0 {
        dl.add_circle_stroke(
          @math.Vec2::new(rip_sx, rip_sy),
          rip_r,
          @color.Color::rgb(251, 146, 60),
          2.0,
        )
      }
    }
    if state.magnetic_repel && in_canvas {
      dl.add_circle_stroke(
        @math.Vec2::new(mouse_x, mouse_y),
        repel_radius * state.zoom,
        @color.Color::rgba(249, 115, 22, 180),
        1.5,
      )
    }
  }

  // End matrix cell clipping
  dl.pop_clip()
  is_micro_vector
}

///|
fn render_selected_transform_frame(
  dl : @draw.DrawList,
  state : BenchmarkState,
  cv_x : Double,
  cv_y : Double,
  cv_w : Double,
  cv_h : Double,
  sc_x : Double,
  sc_y : Double,
  pitch : Double,
  cell_size : Double,
  grid_dim : Int,
) -> Unit {
  if state.selected_id >= 0 {
    dl.push_clip(@math.Rect::new(cv_x, cv_y, cv_w, cv_h))
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
      "拖拽中 #\{sel_id} [列:\{c}, 行:\{r}]"
    } else {
      "#\{sel_id} [列:\{c}, 行:\{r}]"
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
    dl.pop_clip()
  }
}
