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
pub struct FrameOutput {
  draw_list : @draw.DrawList
  cam_x : Double
  cam_y : Double
  zoom : Double
  grid_dim : Int
  visible_cells : Int
  selected_id : Int
  show_studio : Bool
  is_vector : Bool
}

///|
/// Core benchmark frame update function supporting 128x128, 256x256, 512x512, 1024x1024.
///
/// Input crosses the JS boundary as primitives - pointer, the text typed this
/// frame, the named keys pressed and released this frame, and a modifier
/// bitmask - and `host_input.mbt` turns them into the library's events.
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
  text_input : String,
  keys_pressed : Array[String],
  keys_released : Array[String],
  mod_flags : Int,
) -> FrameOutput {
  state.frame_tick = state.frame_tick + 1.0

  // 1. External UI buttons & Mode Switcher
  apply_switch_mode(state, switch_mode, vp_w, vp_h)

  let cur_w = if vp_w > 100.0 { vp_w } else { 920.0 }
  let cur_h = if vp_h > 100.0 { vp_h } else { 540.0 }
  let win_w = 264.0
  let win_h = 340.0

  let vp_x = 0.0
  let vp_y = 0.0
  let ruler_h = 22.0
  let ruler_w = 48.0
  let cv_x = vp_x + ruler_w
  let cv_y = vp_y + ruler_h
  let cv_w = cur_w - ruler_w
  let cv_h = cur_h - ruler_h
  let sc_x = cv_x + cv_w * 0.5
  let sc_y = cv_y + cv_h * 0.5

  // 2. Camera Pan & Zoom updates (pinning world point under mouse cursor).
  // The floating panel now owns its own drag and viewport clamping.
  update_camera_pan(state, ctx, pan_dx, pan_dy)
  if !mouse_down {
    state.is_dragging_item = false
  }
  update_camera_zoom(state, ctx, zoom_delta, mouse_x, mouse_y, sc_x, sc_y)

  // 4. Begin GUI Frame
  let raw = host_raw_input(
    mouse_x, mouse_y, mouse_down, text_input, keys_pressed, keys_released, mod_flags,
  )
  ctx.begin_frame(raw)
  let dl = ctx.draw_list()

  let grid_dim = state.grid_dim
  let matrix_world_size = 10000.0
  let pitch = matrix_world_size / grid_dim.to_double()
  let cell_size = pitch

  let in_canvas = mouse_x >= cv_x &&
    mouse_x <= cv_x + cv_w &&
    mouse_y >= cv_y &&
    mouse_y <= cv_y + cv_h

  let mwx = state.cam_x + (mouse_x - sc_x) / state.zoom
  let mwy = state.cam_y + (mouse_y - sc_y) / state.zoom

  // 6. Node Hit Test & Ripple Physics
  handle_node_hit_test(
    state, ctx, mouse_down, in_canvas, mwx, mwy, pitch, grid_dim, matrix_world_size,
  )
  update_ripple_physics(state, matrix_world_size, pitch)

  // 7. Spatial Viewport Culling Bounds
  let (c_start, c_end, r_start, r_end, total_vis, min_wx, max_wx, min_wy, max_wy
  ) = calc_culling_bounds(state, cv_w, cv_h, pitch, grid_dim)

  // 8. Background Major Coordinate Aisles
  dl.push_clip(@math.Rect::new(cv_x, cv_y, cv_w, cv_h))
  if state.show_grid {
    render_grid_aisles(dl, state, cv_x, cv_y, cv_w, cv_h, sc_x, sc_y)
  }
  dl.pop_clip()

  // 9. Matrix Nodes (LOD Vector streaming or Background probe)
  let is_vector = render_matrix_nodes(
    dl, state, in_canvas, mouse_x, mouse_y, cv_x, cv_y, cv_w, cv_h, sc_x, sc_y, grid_dim,
    pitch, cell_size, mwx, mwy, c_start, c_end, r_start, r_end, total_vis, matrix_world_size,
  )

  // 10. Selected Item Transform Box & Floating Inspector Tag
  render_selected_transform_frame(
    dl, state, cv_x, cv_y, cv_w, cv_h, sc_x, sc_y, pitch, cell_size, grid_dim,
  )

  // 11. CAD Rulers & Projection Indicators
  render_cad_rulers(
    dl, state, cv_x, cv_y, cv_w, cv_h, vp_x, vp_y, ruler_w, ruler_h, min_wx, max_wx,
    min_wy, max_wy, sc_x, sc_y,
  )
  render_ruler_projections(
    dl, state, cv_x, cv_y, cv_w, cv_h, vp_x, vp_y, ruler_w, ruler_h, sc_x, sc_y,
    pitch, cell_size, grid_dim,
  )

  // 12. Floating In-Canvas IMGUI Controls Window
  render_studio_window(ctx, state, cur_w, cur_h, win_w, win_h)

  // 13. End Frame & Output DrawList
  let final_dl = ctx.end_frame()
  {
    draw_list: final_dl,
    cam_x: state.cam_x,
    cam_y: state.cam_y,
    zoom: state.zoom,
    grid_dim: state.grid_dim,
    visible_cells: state.visible_cells,
    selected_id: state.selected_id,
    show_studio: state.show_studio,
    is_vector,
  }
}

///|
fn main {
  let frame = step(
    580.0,
    270.0,
    false,
    0.0,
    0.0,
    1.0,
    -1,
    920.0,
    540.0,
    "",
    [],
    [],
    0,
  )
  let _ = gallery_step(
    "knob",
    0.0,
    0.0,
    false,
    0.0,
    800.0,
    600.0,
    "",
    [],
    [],
    0,
  )
  let _ = get_gallery_status()
  let _ = get_gallery_cursor()
  println(
    "Benchmark initialized, total commands: \{frame.draw_list.len()}, zoom: \{frame.zoom}",
  )
}
