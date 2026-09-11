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
/// Jump to a node by index and optionally reframe the camera on it. Called when
/// the jump field commits, so a typed index drives the same state a click does.
fn apply_node_jump(state : BenchmarkState, index : Int, after : Int) -> Unit {
  let total = state.grid_dim * state.grid_dim
  if index < 0 || index >= total {
    return
  }
  state.selected_id = index
  state.selected_col = index % state.grid_dim
  state.selected_row = index / state.grid_dim
  if after >= 1 {
    state.cam_x = 5000.0
    state.cam_y = 5000.0
  }
  if after >= 2 {
    state.zoom = 1.0
  }
}

///|
/// The 视图 tab: matrix density, zoom and the view presets.
fn panel_view_tab(
  ui : @core.UIContext,
  state : BenchmarkState,
  cur_w : Double,
  cur_h : Double,
) -> Unit {
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
}

///|
/// The 输入 tab: type a node index to select it, choose what the jump does to
/// the camera, and toggle the background grid. This is also the part of the demo
/// that exercises the library's keyboard and text-input path end to end.
fn panel_input_tab(ui : @core.UIContext, state : BenchmarkState) -> Unit {
  let _ = ui.label_colored("跳转节点序号", @color.Color::accent_primary())
  let (new_text, field_resp) = ui.text_edit(
    "jump_field",
    state.jump_text,
    "例如 4321",
  )
  state.jump_text = new_text
  if field_resp.has_focus() && ui.input().key_pressed(@core.Key::Enter) {
    match parse_index(state.jump_text) {
      Some(index) => apply_node_jump(state, index, state.jump_after)
      None => ()
    }
  }
  if field_resp.hovered() {
    ui.tooltip("输入序号后按回车，选中该节点")
  }

  ui.separator()

  let (new_after, _) = ui.combo_box(
    "jump_after",
    "跳转后",
    state.jump_after,
    ["仅选中", "居中", "居中并放大"],
  )
  state.jump_after = new_after

  ui.separator()

  let (new_grid, grid_resp) = ui.toggle("显示网格", state.show_grid)
  if grid_resp.clicked {
    state.show_grid = new_grid
  }

  ui.separator()

  if state.selected_id >= 0 {
    let info = "选中节点 #" +
      state.selected_id.to_string() +
      " [列 " +
      state.selected_col.to_string() +
      ", 行 " +
      state.selected_row.to_string() +
      "]"
    // The demo's own selection accent, matching the rose marker drawn on the
    // matrix; the library palette has no equivalent step.
    let _ = ui.label_colored(info, @color.Color::rgb(225, 29, 72))
  } else {
    let _ = ui.label_colored(
      "点击网格节点或输入序号",
      @color.Color::text_muted(),
    )
  }
}

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
      let (new_tab, _) = ui.tab_bar(
        "panel_tabs",
        ["视图", "输入"],
        state.panel_tab,
      )
      state.panel_tab = new_tab

      ui.separator()

      if state.panel_tab == 0 {
        panel_view_tab(ui, state, cur_w, cur_h)
      } else {
        panel_input_tab(ui, state)
      }
    },
    constrain_to=viewport,
  )
}
