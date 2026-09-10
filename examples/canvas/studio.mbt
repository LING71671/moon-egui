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
  if !state.show_studio {
    state.win_dragging = false
    return
  }

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
    // Check if clicking close button
    let close_rect = @math.Rect::new(
      state.win_pos_x + win_w - 26.0,
      state.win_pos_y + 4.0,
      20.0,
      20.0,
    )
    if close_rect.contains(@math.Vec2::new(mouse_x, mouse_y)) {
      state.show_studio = false
      state.win_dragging = false
    } else {
      state.win_dragging = true
    }
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
  if !state.show_studio {
    return
  }

  let win_pos = @math.Vec2::new(state.win_pos_x, state.win_pos_y)
  let win_size = @math.Vec2::new(win_w, win_h)
  let window_rect = @math.Rect::new(
    win_pos.x,
    win_pos.y,
    win_size.x,
    win_size.y,
  )
  let title_bar_h = 28.0
  let title_bar_rect = @math.Rect::new(
    win_pos.x,
    win_pos.y,
    win_size.x,
    title_bar_h,
  )

  if window_rect.contains(ctx.input().mouse_pos) {
    ctx.set_wants_capture_mouse(true)
  }

  let dl = ctx.draw_list()

  // 1. Light Workstation Panel Card
  let bg_color = @color.Color::rgba(255, 255, 255, 248)
  let border_color = @color.Color::rgb(203, 213, 225)
  let header_color = @color.Color::rgb(241, 245, 249)

  dl.add_rect(window_rect, bg_color, 8.0)
  dl.add_rect_stroke(window_rect, border_color, 1.0, 8.0)

  // 2. Title Bar Header
  dl.add_rect(title_bar_rect, header_color, 8.0)
  let filler_rect = @math.Rect::new(
    win_pos.x,
    win_pos.y + title_bar_h - 4.0,
    win_size.x,
    4.0,
  )
  dl.add_rect(filler_rect, header_color, 0.0)
  dl.add_line(
    @math.Vec2::new(win_pos.x, win_pos.y + title_bar_h),
    @math.Vec2::new(win_pos.x + win_size.x, win_pos.y + title_bar_h),
    border_color,
    1.0,
  )

  // 3. Title Text
  dl.add_text(
    @math.Vec2::new(win_pos.x + 12.0, win_pos.y + 7.0),
    "控制面板",
    12.0,
    @color.Color::rgb(15, 23, 42),
  )

  // 4. Close Button [✕]
  let close_rect = @math.Rect::new(
    win_pos.x + win_size.x - 24.0,
    win_pos.y + 5.0,
    18.0,
    18.0,
  )
  let is_close_hover = close_rect.contains(ctx.input().mouse_pos)
  if is_close_hover {
    dl.add_rect(close_rect, @color.Color::rgb(226, 232, 240), 4.0)
    if ctx.input().mouse_down {
      state.show_studio = false
    }
  }
  dl.add_text(
    @math.Vec2::new(win_pos.x + win_size.x - 19.0, win_pos.y + 6.0),
    "✕",
    12.0,
    if is_close_hover {
      @color.Color::rgb(239, 68, 68)
    } else {
      @color.Color::rgb(148, 163, 184)
    },
  )

  // 5. Scissor Clipped Content Region
  let pad = 12.0
  let content_x = win_pos.x + pad
  let content_y = win_pos.y + title_bar_h + pad
  let content_w = win_size.x - pad * 2.0
  let content_h = win_size.y - title_bar_h - pad * 2.0

  let clip_rect = @math.Rect::new(content_x, content_y, content_w, content_h)
  dl.push_clip(clip_rect)

  let prev_cursor = ctx.cursor()
  let prev_avail_w = ctx.available_width()

  ctx.set_cursor(@math.Vec2::new(content_x, content_y))
  ctx.set_available_width(content_w)

  // Panel Content in Pure Chinese
  let _ = ctx.label_colored("矩阵规格", @color.Color::rgb(37, 99, 235))
  ctx.horizontal(fn(row) {
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

  ctx.separator()

  let (new_zoom, _) = ctx.slider("缩放比例", state.zoom, 0.02, 3.0)
  state.zoom = new_zoom

  ctx.separator()

  let (new_pulse, pulse_resp) = ctx.checkbox(
    "水波动态物理",
    state.wave_pulse,
  )
  if pulse_resp.clicked {
    state.wave_pulse = new_pulse
  }
  let (new_repel, repel_resp) = ctx.checkbox(
    "光标磁力斥力",
    state.magnetic_repel,
  )
  if repel_resp.clicked {
    state.magnetic_repel = new_repel
  }

  ctx.separator()

  ctx.horizontal(fn(row) {
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

  ctx.separator()

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
    let _ = ctx.label_colored(info, @color.Color::rgb(225, 29, 72))
  } else {
    let _ = ctx.label_colored(
      "点击网格节点查看详情",
      @color.Color::rgb(100, 116, 139),
    )
  }

  ctx.set_cursor(prev_cursor)
  ctx.set_available_width(prev_avail_w)
  dl.pop_clip()
}
