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
fn update_studio_window_drag(
  state : BenchmarkState,
  mouse_x : Double,
  mouse_y : Double,
  mouse_down : Bool,
  cur_w : Double,
  win_w : Double,
) -> Unit {
  if state.win_pos_x < 0.0 {
    state.win_pos_x = (cur_w - win_w - 20.0).max(20.0)
    state.win_pos_y = 70.0
  }

  let win_title_rect = @math.Rect::new(
    state.win_pos_x,
    state.win_pos_y,
    win_w,
    28.0,
  )
  if mouse_down && win_title_rect.contains(@math.Vec2::new(mouse_x, mouse_y)) {
    state.win_dragging = true
  }
  if !mouse_down {
    state.win_dragging = false
  }
}

///|
fn render_studio_window(
  ctx : @core.UIContext,
  state : BenchmarkState,
  cur_w : Double,
  cur_h : Double,
  win_w : Double,
  win_h : Double,
) -> Unit {
  let win_pos = @math.Vec2::new(state.win_pos_x, state.win_pos_y)
  let win_size = @math.Vec2::new(win_w, win_h)

  ctx.window("moon-egui Studio", win_pos, win_size, fn(ui) {
    let _ = ui.label_colored("Matrix Scale", @color.Color::accent_primary())
    ui.horizontal(fn(row) {
      if row.button_sized("128", @math.Vec2::new(54.0, 24.0)).clicked {
        state.grid_dim = 128
        state.selected_id = -1
      }
      if row.button_sized("256", @math.Vec2::new(54.0, 24.0)).clicked {
        state.grid_dim = 256
        state.selected_id = -1
      }
      if row.button_sized("512", @math.Vec2::new(54.0, 24.0)).clicked {
        state.grid_dim = 512
        state.selected_id = -1
      }
      if row.button_sized("1024", @math.Vec2::new(54.0, 24.0)).clicked {
        state.grid_dim = 1024
        state.selected_id = -1
      }
    })

    ui.separator()

    let (new_zoom, _) = ui.slider("Zoom", state.zoom, 0.02, 2.0)
    state.zoom = new_zoom

    ui.separator()

    let (new_pulse, pulse_resp) = ui.checkbox(
      "Wave Pulse Dynamics",
      state.wave_pulse,
    )
    if pulse_resp.clicked {
      state.wave_pulse = new_pulse
    }
    let (new_repel, repel_resp) = ui.checkbox(
      "Magnetic Repel Field",
      state.magnetic_repel,
    )
    if repel_resp.clicked {
      state.magnetic_repel = new_repel
    }

    ui.separator()

    ui.horizontal(fn(row) {
      if row.button_sized("Fit All", @math.Vec2::new(74.0, 24.0)).clicked {
        let min_dim = if cur_w < cur_h { cur_w } else { cur_h }
        let fit_z = (min_dim - 60.0) / 10500.0
        state.zoom = if fit_z > 0.01 { fit_z } else { 0.075 }
        state.cam_x = 5000.0
        state.cam_y = 5000.0
      }
      if row.button_sized("Center", @math.Vec2::new(74.0, 24.0)).clicked {
        state.cam_x = 5000.0
        state.cam_y = 5000.0
      }
      if row.button_sized("100%", @math.Vec2::new(74.0, 24.0)).clicked {
        state.zoom = 1.0
      }
    })

    ui.separator()

    if state.selected_id >= 0 {
      let sel_col = state.selected_id % state.grid_dim
      let sel_row = state.selected_id / state.grid_dim
      let info = "Node #" +
        state.selected_id.to_string() +
        " [" +
        sel_col.to_string() +
        "," +
        sel_row.to_string() +
        "]"
      let _ = ui.label_colored(info, @color.Color::rgb(244, 63, 94))
    } else {
      let _ = ui.label_colored(
        "Click grid node to inspect",
        @color.Color::text_secondary(),
      )
    }
  })
}
