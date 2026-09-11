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
/// The floating control panel, rendered with the library's own window
/// container: chrome, title bar dragging, viewport clamping, z-order and
/// scissor clipping all come from `UIContext::window`, so this file only
/// describes the panel's contents.
fn render_studio_window(
  ctx : @core.UIContext,
  state : BenchmarkState,
  cur_w : Double,
  cur_h : Double,
  win_w : Double,
  win_h : Double,
) -> Unit {
  if !state.show_studio {
    return
  }

  // Only a starting point: once the panel has been dragged, the UI context owns
  // the position and this value is ignored.
  let parked_x = cur_w - win_w - 20.0
  let initial = @math.Vec2::new(
    if parked_x > 20.0 {
      parked_x
    } else {
      20.0
    },
    70.0,
  )
  let viewport = @math.Rect::new(0.0, 0.0, cur_w, cur_h)

  let _ = ctx.window(
    "控制面板",
    initial,
    @math.Vec2::new(win_w, win_h),
    fn(ui) {
      let _ = ui.label_colored("矩阵规格", @color.Color::accent_primary())
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

      let (new_zoom, _) = ui.slider("缩放比例", state.zoom, 0.02, 3.0)
      state.zoom = new_zoom

      ui.separator()

      let (new_pulse, pulse_resp) = ui.checkbox(
        "水波动态物理",
        state.wave_pulse,
      )
      if pulse_resp.clicked {
        state.wave_pulse = new_pulse
      }
      let (new_repel, repel_resp) = ui.checkbox(
        "光标磁力斥力",
        state.magnetic_repel,
      )
      if repel_resp.clicked {
        state.magnetic_repel = new_repel
      }

      ui.separator()

      ui.horizontal(fn(row) {
        if row.button_sized("全景自适应", @math.Vec2::new(74.0, 24.0)).clicked {
          let min_dim = if cur_w < cur_h { cur_w } else { cur_h }
          let fit_z = (min_dim - 60.0) / 10500.0
          state.zoom = if fit_z > 0.01 { fit_z } else { 0.075 }
          state.cam_x = 5000.0
          state.cam_y = 5000.0
        }
        if row.button_sized("居中", @math.Vec2::new(74.0, 24.0)).clicked {
          state.cam_x = 5000.0
          state.cam_y = 5000.0
        }
        if row.button_sized("1:1 像素", @math.Vec2::new(74.0, 24.0)).clicked {
          state.zoom = 1.0
        }
      })

      ui.separator()

      if state.selected_id >= 0 {
        let sel_col = state.selected_id % state.grid_dim
        let sel_row = state.selected_id / state.grid_dim
        let info = "选中节点 #" +
          state.selected_id.to_string() +
          " [列 " +
          sel_col.to_string() +
          ", 行 " +
          sel_row.to_string() +
          "]"
        // The demo's own selection accent, matching the rose marker drawn on
        // the matrix; the library palette has no equivalent step.
        let _ = ui.label_colored(info, @color.Color::rgb(225, 29, 72))
      } else {
        let _ = ui.label_colored(
          "点击网格节点查看详情",
          @color.Color::text_muted(),
        )
      }
    },
    constrain_to=viewport,
  )
}
