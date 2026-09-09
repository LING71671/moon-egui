///|
struct BenchmarkState {
  mut mode : Int // 0: Logo Matrix (144 ~ 1600), 1: 1,000,000 Nodes Universe
  grid_dim : Int // 32
  mut click_count : Int
  magnetic_repel : Bool
  wave_pulse : Bool
  mut frame_tick : Double
  mut ripple_cx : Double
  mut ripple_cy : Double
  mut ripple_active : Bool
  mut ripple_progress : Double

  // Million-Node Universe State
  mut million_mode : Int // 0: 百万杯咖啡 (1M Coffee), 1: 百万矩形 (1M Rects)
  mut cam_x : Double
  mut cam_y : Double
  mut zoom : Double
  mut million_selected_id : Int
  mut million_selected_col : Int
  mut million_selected_row : Int
  mut million_visible_count : Int

  // Logo Matrix Selected State
  mut selected_id : Int
  mut selected_col : Int
  mut selected_row : Int

  // Drag & Interaction State
  mut drag_mode : Int // 0: 漫游画布 (Pan Canvas), 1: 拖拽单个物体 (Drag Item)
  mut item_drag_dx : Double
  mut item_drag_dy : Double
  mut is_dragging_item : Bool
}

///|
let state : BenchmarkState = {
  mode: 1, // Default to the 1,000,000 Nodes Benchmark!
  grid_dim: 32,
  click_count: 0,
  magnetic_repel: true,
  wave_pulse: false,
  frame_tick: 0.0,
  ripple_cx: 460.0,
  ripple_cy: 270.0,
  ripple_active: false,
  ripple_progress: 0.0,
  million_mode: 0, // 0: 百万杯咖啡 (1M Coffee Cups on Shelves)
  cam_x: 32000.0, // Center of 1,000,000 universe (500 * 64.0)
  cam_y: 38000.0, // (500 * 76.0)
  zoom: 0.85,
  million_selected_id: -1,
  million_selected_col: -1,
  million_selected_row: -1,
  million_visible_count: 0,
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
  if target > 50000.0 {
    100000.0
  } else if target > 20000.0 {
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
  } else {
    50.0
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
/// Core benchmark frame update function with million-node camera & drag support.
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

  if switch_mode >= 0 {
    if switch_mode == 0 {
      state.mode = 0
    } else if switch_mode == 1 {
      state.mode = 1
      state.million_mode = 0
    } else if switch_mode == 2 {
      state.mode = 1
      state.million_mode = 1
    } else if switch_mode == 3 {
      // 100% Fit Mode: All 1,000,000 Nodes Visible
      state.mode = 1
      state.zoom = 0.0062
      state.cam_x = 32000.0
      state.cam_y = 38000.0
    } else if switch_mode == 4 {
      // 100% (1.0x) Scale
      state.mode = 1
      state.zoom = 1.0
    } else if switch_mode == 5 {
      // Center Viewport
      state.cam_x = 32000.0
      state.cam_y = 38000.0
    } else if switch_mode == 6 {
      // Switch interaction to Drag Item
      state.drag_mode = 1
    } else if switch_mode == 7 {
      // Switch interaction to Pan Canvas
      state.drag_mode = 0
    }
  }

  // Camera Pan & Item Drag Updates
  if pan_dx != 0.0 || pan_dy != 0.0 {
    if state.drag_mode == 1 && state.million_selected_id >= 0 {
      // Dragging selected item across 1M universe!
      state.item_drag_dx = state.item_drag_dx + pan_dx / state.zoom
      state.item_drag_dy = state.item_drag_dy + pan_dy / state.zoom
      state.is_dragging_item = true
    } else {
      // Panning camera
      state.cam_x = state.cam_x - pan_dx / state.zoom
      state.cam_y = state.cam_y - pan_dy / state.zoom
      if state.cam_x < 0.0 {
        state.cam_x = 0.0
      } else if state.cam_x > 64000.0 {
        state.cam_x = 64000.0
      }
      if state.cam_y < 0.0 {
        state.cam_y = 0.0
      } else if state.cam_y > 76000.0 {
        state.cam_y = 76000.0
      }
    }
  }

  if !mouse_down {
    state.is_dragging_item = false
  }

  if zoom_delta != 1.0 && zoom_delta > 0.0 {
    let new_zoom = state.zoom * zoom_delta
    if new_zoom < 0.004 {
      state.zoom = 0.004
    } else if new_zoom > 4.0 {
      state.zoom = 4.0
    } else {
      state.zoom = new_zoom
    }
  }

  let raw = @core.RawInput::from_mouse(
    @math.Vec2::new(mouse_x, mouse_y),
    mouse_down,
  )
  ctx.begin_frame(raw)

  // =========================================================================
  // MODE 1: 1,000,000 NODES FULL VIEWPORT INFINITE STUDIO CANVAS
  // =========================================================================
  if state.mode == 1 {
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

    let cell_w = 64.0
    let cell_h = 76.0

    // Inverse mouse mapping to world coordinates
    let in_canvas = mouse_x >= cv_x &&
      mouse_x <= cv_x + cv_w &&
      mouse_y >= cv_y &&
      mouse_y <= cv_y + cv_h
    if in_canvas {
      let mwx = state.cam_x + (mouse_x - sc_x) / state.zoom
      let mwy = state.cam_y + (mouse_y - sc_y) / state.zoom
      let hit_col = (mwx / cell_w).to_int()
      let hit_row = (mwy / cell_h).to_int()
      if hit_col >= 0 && hit_col < 1000 && hit_row >= 0 && hit_row < 1000 {
        let rel_x = mwx - hit_col.to_double() * cell_w
        let rel_y = mwy - hit_row.to_double() * cell_h
        if rel_x >= 6.0 && rel_x <= 58.0 && rel_y >= 4.0 && rel_y <= 68.0 {
          let node_id = hit_row * 1000 + hit_col
          if state.million_selected_id != node_id {
            state.million_selected_id = node_id
            state.million_selected_col = hit_col
            state.million_selected_row = hit_row
            state.item_drag_dx = 0.0
            state.item_drag_dy = 0.0
          }
          if mouse_down {
            state.click_count = state.click_count + 1
          }
        }
      }
    }

    // O(1) Spatial Viewport Culling
    let half_vw = cv_w * 0.5 / state.zoom
    let half_vh = cv_h * 0.5 / state.zoom
    let min_wx = state.cam_x - half_vw
    let max_wx = state.cam_x + half_vw
    let min_wy = state.cam_y - half_vh
    let max_wy = state.cam_y + half_vh

    let mut col_start = (min_wx / cell_w).to_int()
    if col_start < 0 {
      col_start = 0
    }
    let mut col_end = (max_wx / cell_w).to_int() + 1
    if col_end > 1000 {
      col_end = 1000
    }

    let mut row_start = (min_wy / cell_h).to_int()
    if row_start < 0 {
      row_start = 0
    }
    let mut row_end = (max_wy / cell_h).to_int() + 1
    if row_end > 1000 {
      row_end = 1000
    }

    let raw_visible = (col_end - col_start) * (row_end - row_start)
    state.million_visible_count = raw_visible

    // Adaptive sampling stride so Canvas 2D frame time stays strictly within 16.6ms (60 FPS)
    let stride = if raw_visible <= 1200 {
      1
    } else if raw_visible <= 5000 {
      2
    } else if raw_visible <= 20000 {
      4
    } else if raw_visible <= 80000 {
      8
    } else if raw_visible <= 300000 {
      16
    } else {
      28
    }

    // 1. Clip workspace content
    dl.push_clip(@math.Rect::new(cv_x, cv_y, cv_w, cv_h))

    // Workspace Background
    dl.add_rect(
      @math.Rect::new(cv_x, cv_y, cv_w, cv_h),
      @color.Color::rgb(250, 250, 252),
      0.0,
    )

    // Draw Shelves (Horizontal Shelf Lines)
    let shelf_col = @color.Color::rgb(226, 232, 240)
    for r = row_start; r < row_end; r = r + stride {
      let shelf_wy = (r.to_double() + 1.0) * cell_h - 4.0
      let shelf_sy = sc_y + (shelf_wy - state.cam_y) * state.zoom
      dl.add_line(
        @math.Vec2::new(cv_x, shelf_sy),
        @math.Vec2::new(cv_x + cv_w, shelf_sy),
        shelf_col,
        1.5,
      )
    }

    // Draw Entities (1,000,000 Coffee Cups or Rectangles)
    let item_w = 44.0 * state.zoom * stride.to_double()
    let item_h = 58.0 * state.zoom * stride.to_double()
    let draw_w = item_w.max(2.5)
    let draw_h = item_h.max(3.0)

    if state.zoom >= 0.35 && stride == 1 {
      for r = row_start; r < row_end; r = r + stride {
        for c = col_start; c < col_end; c = c + stride {
          let is_selected = c == state.million_selected_col &&
            r == state.million_selected_row
          let is_dragged = is_selected &&
            (
              state.item_drag_dx != 0.0 ||
              state.item_drag_dy != 0.0 ||
              state.is_dragging_item
            )

          let orig_wx = c.to_double() * cell_w + 10.0
          let orig_wy = r.to_double() * cell_h + 6.0
          let wx = if is_dragged { orig_wx + state.item_drag_dx } else { orig_wx }
          let wy = if is_dragged { orig_wy + state.item_drag_dy } else { orig_wy }
          let sx = sc_x + (wx - state.cam_x) * state.zoom
          let sy = sc_y + (wy - state.cam_y) * state.zoom

          let color_mod = ((c / stride) * 7 + (r / stride) * 13) % 4
          let base_cup_color = if color_mod == 0 {
            @color.Color::rgb(16, 185, 129) // Emerald Mint
          } else if color_mod == 1 {
            @color.Color::rgb(244, 63, 94) // Strawberry Rose
          } else if color_mod == 2 {
            @color.Color::rgb(139, 92, 246) // Aurora Violet
          } else {
            @color.Color::rgb(2, 132, 199) // Glacier Cyan
          }

          let rect_radius = if draw_w < 8.0 { 1.0 } else { 2.0 }
          dl.add_rect(
            @math.Rect::new(sx, sy, draw_w, draw_h),
            base_cup_color,
            rect_radius,
          )
          if draw_w > 12.0 {
            dl.add_rect_stroke(
              @math.Rect::new(sx, sy, draw_w, draw_h),
              @color.Color::rgb(203, 213, 225),
              0.5,
              rect_radius,
            )
          }
        }
      }
    } else {
      // Macro Universe: Color-batched linear sweep for maximum Canvas 2D rasterizer efficiency!
      for target_color = 0; target_color < 4; target_color = target_color + 1 {
        let base_cup_color = if target_color == 0 {
          @color.Color::rgb(16, 185, 129) // Emerald Mint
        } else if target_color == 1 {
          @color.Color::rgb(244, 63, 94) // Strawberry Rose
        } else if target_color == 2 {
          @color.Color::rgb(139, 92, 246) // Aurora Violet
        } else {
          @color.Color::rgb(2, 132, 199) // Glacier Cyan
        }

        for r = row_start; r < row_end; r = r + stride {
          for c = col_start; c < col_end; c = c + stride {
            if ((c / stride) * 7 + (r / stride) * 13) % 4 != target_color {
              continue
            }
            let is_selected = c == state.million_selected_col &&
              r == state.million_selected_row
            let is_dragged = is_selected &&
              (
                state.item_drag_dx != 0.0 ||
                state.item_drag_dy != 0.0 ||
                state.is_dragging_item
              )

            let orig_wx = c.to_double() * cell_w + 10.0
            let orig_wy = r.to_double() * cell_h + 6.0
            let wx = if is_dragged { orig_wx + state.item_drag_dx } else { orig_wx }
            let wy = if is_dragged { orig_wy + state.item_drag_dy } else { orig_wy }
            let sx = sc_x + (wx - state.cam_x) * state.zoom
            let sy = sc_y + (wy - state.cam_y) * state.zoom

            dl.add_rect(
              @math.Rect::new(sx, sy, draw_w, draw_h),
              base_cup_color,
              0.0,
            )
          }
        }
      }
    }

    // Figma/CAD-style Selection Bounding Box, Circular Handles & Action Button
    if state.million_selected_id >= 0 {
      let is_dragged = state.item_drag_dx != 0.0 ||
        state.item_drag_dy != 0.0 ||
        state.is_dragging_item
      let sel_orig_wx = state.million_selected_col.to_double() * cell_w + 10.0
      let sel_orig_wy = state.million_selected_row.to_double() * cell_h + 6.0
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
      let sel_w = 44.0 * state.zoom
      let sel_h = 58.0 * state.zoom

      // 1. Purple Outline
      dl.add_rect_stroke(
        @math.Rect::new(sel_sx - 4.0, sel_sy - 4.0, sel_w + 8.0, sel_h + 8.0),
        @color.Color::rgb(139, 92, 246),
        1.5,
        4.0,
      )

      // 2. 4 Circular Corner Handles (white circle with purple border)
      let handle_r = 3.5
      let h_purple = @color.Color::rgb(139, 92, 246)
      let h_white = @color.Color::white()

      // TL
      let tl_pos = @math.Vec2::new(sel_sx - 4.0, sel_sy - 4.0)
      dl.add_circle(tl_pos, handle_r, h_white)
      dl.add_circle_stroke(tl_pos, handle_r, h_purple, 1.5)

      // TR
      let tr_pos = @math.Vec2::new(sel_sx + sel_w + 4.0, sel_sy - 4.0)
      dl.add_circle(tr_pos, handle_r, h_white)
      dl.add_circle_stroke(tr_pos, handle_r, h_purple, 1.5)

      // BL
      let bl_pos = @math.Vec2::new(sel_sx - 4.0, sel_sy + sel_h + 4.0)
      dl.add_circle(bl_pos, handle_r, h_white)
      dl.add_circle_stroke(bl_pos, handle_r, h_purple, 1.5)

      // BR
      let br_pos = @math.Vec2::new(sel_sx + sel_w + 4.0, sel_sy + sel_h + 4.0)
      dl.add_circle(br_pos, handle_r, h_white)
      dl.add_circle_stroke(br_pos, handle_r, h_purple, 1.5)

      // Bottom Center Circular Action Handle (matching user reference)
      let bc_pos = @math.Vec2::new(sel_sx + sel_w * 0.5, sel_sy + sel_h + 8.0)
      dl.add_circle(bc_pos, handle_r, h_white)
      dl.add_circle_stroke(bc_pos, handle_r, h_purple, 1.5)

      // 3. Floating Inspector Tag
      let tag_txt = if is_dragged {
        "DRAGGING #\{state.million_selected_id} [\{sel_wx.to_int()}, \{sel_wy.to_int()}]"
      } else {
        "#\{state.million_selected_id} [\{sel_wx.to_int()}, \{sel_wy.to_int()}]"
      }
      let tag_w = tag_txt.length().to_double() * 7.0 + 16.0
      dl.add_rect(
        @math.Rect::new(
          sel_sx + (sel_w - tag_w) * 0.5,
          sel_sy - 24.0,
          tag_w,
          18.0,
        ),
        @color.Color::rgb(15, 23, 42),
        4.0,
      )
      dl.add_text(
        @math.Vec2::new(sel_sx + (sel_w - tag_w) * 0.5 + 8.0, sel_sy - 22.0),
        tag_txt,
        10.0,
        @color.Color::white(),
      )
    }

    // End workspace clipping
    dl.pop_clip()

    // =========================================================================
    // CAD COORDINATE RULERS (TOP & LEFT)
    // =========================================================================
    let ruler_bg = @color.Color::rgb(248, 250, 252)
    let ruler_border = @color.Color::rgb(226, 232, 240)
    let ruler_tick_col = @color.Color::rgb(148, 163, 184)
    let ruler_text_col = @color.Color::rgb(100, 116, 139)

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
      @color.Color::rgb(241, 245, 249),
      0.0,
    )
    dl.add_text(
      @math.Vec2::new(vp_x + 12.0, vp_y + 4.0),
      "px",
      10.0,
      ruler_text_col,
    )

    // Top Ruler Ticks & Coordinate Labels
    let step_x = get_ruler_step(state.zoom)
    let first_tick_x = (min_wx / step_x).to_int().to_double() * step_x
    let mut cur_wx = first_tick_x
    while cur_wx <= max_wx {
      let sx = sc_x + (cur_wx - state.cam_x) * state.zoom
      if sx >= cv_x && sx <= cv_x + cv_w {
        dl.add_line(
          @math.Vec2::new(sx, vp_y + 14.0),
          @math.Vec2::new(sx, vp_y + ruler_h),
          ruler_tick_col,
          1.0,
        )
        let label_txt = cur_wx.to_int().to_string()
        dl.add_text(
          @math.Vec2::new(sx + 2.0, vp_y + 2.0),
          label_txt,
          9.0,
          ruler_text_col,
        )
      }
      cur_wx = cur_wx + step_x
    }

    // Left Ruler Ticks & Coordinate Labels
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

    // Top & Left Ruler Projection Indicators when Selected (Tracking drag position)
    if state.million_selected_id >= 0 {
      let is_dragged = state.item_drag_dx != 0.0 ||
        state.item_drag_dy != 0.0 ||
        state.is_dragging_item
      let sel_orig_wx = state.million_selected_col.to_double() * cell_w + 10.0
      let sel_orig_wy = state.million_selected_row.to_double() * cell_h + 6.0
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
      let sel_sw = 44.0 * state.zoom
      let sel_sh = 58.0 * state.zoom

      // Top Ruler Projection Highlight
      if sel_sx + sel_sw >= cv_x && sel_sx <= cv_x + cv_w {
        let proj_x = sel_sx.max(cv_x)
        let proj_w = sel_sw.max(16.0)
        dl.add_rect(
          @math.Rect::new(proj_x, vp_y, proj_w, ruler_h),
          @color.Color::rgba(139, 92, 246, 70),
          0.0,
        )
        dl.add_line(
          @math.Vec2::new(proj_x, vp_y),
          @math.Vec2::new(proj_x, vp_y + ruler_h),
          @color.Color::rgb(109, 40, 217),
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
        let proj_h = sel_sh.max(12.0)
        dl.add_rect(
          @math.Rect::new(vp_x, proj_y, ruler_w, proj_h),
          @color.Color::rgba(139, 92, 246, 70),
          0.0,
        )
        dl.add_line(
          @math.Vec2::new(vp_x, proj_y),
          @math.Vec2::new(vp_x + ruler_w, proj_y),
          @color.Color::rgb(109, 40, 217),
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

    let dl = ctx.draw_list()
    let vp_x = 0.0
    let vp_y = 0.0
    let cur_w = if vp_w > 100.0 { vp_w } else { 920.0 }
    let cur_h = if vp_h > 100.0 { vp_h } else { 540.0 }

    dl.add_rect(
      @math.Rect::new(vp_x, vp_y, cur_w, cur_h),
      @color.Color::white(),
      8.0,
    )
    dl.add_rect_stroke(
      @math.Rect::new(vp_x, vp_y, cur_w, cur_h),
      @color.Color::rgb(226, 232, 240),
      1.0,
      8.0,
    )

    let grid_dim = state.grid_dim
    let matrix_size = cur_h.min(cur_w) * 0.8
    let offset_x = vp_x + (cur_w - matrix_size) / 2.0
    let offset_y = vp_y + (cur_h - matrix_size) / 2.0

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
    let total_widgets = grid_dim * grid_dim

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
  let dl = step(580.0, 270.0, false, 0.0, 0.0, 1.0, -1, 920.0, 540.0)
  println("Benchmark initialized, total commands: \{dl.len()}")
}
