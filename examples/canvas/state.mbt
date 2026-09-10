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
  mut visible_cells : Int

  // In-Canvas Floating IMGUI Window State
  mut win_pos_x : Double
  mut win_pos_y : Double
  mut win_dragging : Bool
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
  visible_cells: 0,
  win_pos_x: -1.0,
  win_pos_y: -1.0,
  win_dragging: false,
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
pub fn get_visible_cells() -> Int {
  state.visible_cells
}

///|
pub fn get_state() -> BenchmarkState {
  state
}
