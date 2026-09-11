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
fn calc_ruler_step(zoom : Double) -> Double {
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
fn render_grid_aisles(
  dl : @draw.DrawList,
  state : BenchmarkState,
  cv_x : Double,
  cv_y : Double,
  cv_w : Double,
  cv_h : Double,
  sc_x : Double,
  sc_y : Double,
) -> Unit {
  let aisle_col = @color.Color::border_muted()
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
}

///|
fn render_cad_rulers(
  dl : @draw.DrawList,
  state : BenchmarkState,
  cv_x : Double,
  cv_y : Double,
  cv_w : Double,
  cv_h : Double,
  vp_x : Double,
  vp_y : Double,
  ruler_w : Double,
  ruler_h : Double,
  min_wx : Double,
  max_wx : Double,
  min_wy : Double,
  max_wy : Double,
  sc_x : Double,
  sc_y : Double,
) -> Unit {
  let ruler_bg = @color.Color::bg_window()
  let ruler_border = @color.Color::border_muted()
  let ruler_tick_col = @color.Color::border_strong()
  let ruler_text_col = @color.Color::text_secondary()

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
    @color.Color::bg_surface(),
    0.0,
  )
  dl.add_text(
    @math.Vec2::new(vp_x + 16.0, vp_y + 4.0),
    "px",
    10.0,
    ruler_text_col,
  )

  // Draw Top Ruler Ticks & Coordinate Labels
  let step_x = calc_ruler_step(state.zoom)
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
  let step_y = calc_ruler_step(state.zoom)
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
}

///|
fn render_ruler_projections(
  dl : @draw.DrawList,
  state : BenchmarkState,
  cv_x : Double,
  cv_y : Double,
  cv_w : Double,
  cv_h : Double,
  vp_x : Double,
  vp_y : Double,
  ruler_w : Double,
  ruler_h : Double,
  sc_x : Double,
  sc_y : Double,
  pitch : Double,
  cell_size : Double,
  grid_dim : Int,
) -> Unit {
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
}
