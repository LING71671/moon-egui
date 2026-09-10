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
fn apply_switch_mode(
  state : BenchmarkState,
  switch_mode : Int,
  vp_w : Double,
  vp_h : Double,
) -> Unit {
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
    } else if switch_mode == 8 {
      state.show_studio = !state.show_studio // 切换控制面板
    } else if switch_mode == 9 {
      state.show_studio = true
    } else if switch_mode == 10 {
      state.show_studio = false
    }
  }
}

///|
fn update_camera_pan(
  state : BenchmarkState,
  ctx : @core.UIContext,
  pan_dx : Double,
  pan_dy : Double,
  cur_w : Double,
  cur_h : Double,
  win_w : Double,
  win_h : Double,
) -> Unit {
  if pan_dx != 0.0 || pan_dy != 0.0 {
    if state.win_dragging && state.show_studio {
      state.win_pos_x = state.win_pos_x + pan_dx
      state.win_pos_y = state.win_pos_y + pan_dy
      if state.win_pos_x < 0.0 {
        state.win_pos_x = 0.0
      } else if state.win_pos_x > cur_w - win_w {
        state.win_pos_x = cur_w - win_w
      }
      if state.win_pos_y < 0.0 {
        state.win_pos_y = 0.0
      } else if state.win_pos_y > cur_h - win_h {
        state.win_pos_y = cur_h - win_h
      }
    } else if ctx.wants_capture_mouse() {
      // Pointer captured by in-canvas GUI window / widgets
    } else if state.drag_mode == 1 && state.selected_id >= 0 {
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
}

///|
fn update_camera_zoom(
  state : BenchmarkState,
  ctx : @core.UIContext,
  zoom_delta : Double,
  mouse_x : Double,
  mouse_y : Double,
  sc_x : Double,
  sc_y : Double,
) -> Unit {
  if zoom_delta != 1.0 && zoom_delta > 0.0 && !ctx.wants_capture_mouse() {
    let old_zoom = state.zoom
    let mut new_zoom = old_zoom * zoom_delta
    if new_zoom < 0.02 {
      new_zoom = 0.02
    } else if new_zoom > 8.0 {
      new_zoom = 8.0
    }
    if new_zoom != old_zoom {
      // Pin world coordinate under mouse cursor
      let mwx = state.cam_x + (mouse_x - sc_x) / old_zoom
      let mwy = state.cam_y + (mouse_y - sc_y) / old_zoom
      state.zoom = new_zoom
      state.cam_x = mwx - (mouse_x - sc_x) / new_zoom
      state.cam_y = mwy - (mouse_y - sc_y) / new_zoom
    }
  }
}
