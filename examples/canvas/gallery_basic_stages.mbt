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

// ----------------------------------------------------------------------
// Basic Input & Status Components (Button, Checkbox, Toggle, Radio, Slider, DragValue, ProgressBar, Spinner, Badge)
// ----------------------------------------------------------------------

///|
fn draw_button_showcase(ui : @core.UIContext) -> Unit {
  let _ = ui.label_colored(
    "即时模式按钮与微下沉行程 (Button Suite)",
    @color.Color::accent_primary(),
  )
  ui.spacer(10.0)

  ui.horizontal(fn(row) {
    if @widgets.button_primary(row, "主要按钮 (Primary)").clicked {
      gallery_state.button_clicks = gallery_state.button_clicks + 1
      gallery_state.status_text = "Primary Button clicked: " +
        gallery_state.button_clicks.to_string()
    }
    row.spacer(10.0)
    if @widgets.button(row, "次级按钮 (Normal)").clicked {
      gallery_state.button_clicks = gallery_state.button_clicks + 1
      gallery_state.status_text = "Normal Button clicked: " +
        gallery_state.button_clicks.to_string()
    }
    row.spacer(10.0)
    if @widgets.button_with_shortcut(row, "保存工程", "⌘S").clicked {
      gallery_state.button_clicks = gallery_state.button_clicks + 1
      gallery_state.status_text = "Shortcut Button (⌘S) clicked!"
    }
  })

  ui.spacer(16.0)
  ui.separator()
  ui.spacer(8.0)
  let _ = ui.label(
    "累计点击次数: " + gallery_state.button_clicks.to_string(),
  )
}

///|
fn draw_checkbox_showcase(ui : @core.UIContext) -> Unit {
  let _ = ui.label_colored(
    "复选选项框 (Checkbox Matrix)",
    @color.Color::accent_primary(),
  )
  ui.spacer(10.0)

  let (g, r1) = @widgets.checkbox(
    ui,
    "启用 GPU WebGL 2.0 硬件加速",
    gallery_state.checkbox_gpu,
  )
  if r1.clicked {
    gallery_state.checkbox_gpu = g
    gallery_state.status_text = "GPU Acceleration: " + g.to_string()
  }

  ui.spacer(8.0)

  let (grid, r2) = @widgets.checkbox(
    ui,
    "显示对齐辅助参考网格 (Align Grid)",
    gallery_state.checkbox_grid,
  )
  if r2.clicked {
    gallery_state.checkbox_grid = grid
    gallery_state.status_text = "Grid Guide: " + grid.to_string()
  }

  ui.spacer(8.0)

  let (dark, r3) = @widgets.checkbox(
    ui,
    "视网膜高对比度强化 (High Contrast)",
    gallery_state.checkbox_dark_contrast,
  )
  if r3.clicked {
    gallery_state.checkbox_dark_contrast = dark
    gallery_state.status_text = "High Contrast: " + dark.to_string()
  }

  ui.spacer(8.0)

  let (aa, r4) = @widgets.checkbox(
    ui,
    "高品质矢量抗锯齿 (Subpixel AA)",
    gallery_state.checkbox_antialiasing,
  )
  if r4.clicked {
    gallery_state.checkbox_antialiasing = aa
    gallery_state.status_text = "Subpixel AA: " + aa.to_string()
  }
}

///|
fn draw_toggle_showcase(ui : @core.UIContext) -> Unit {
  let _ = ui.label_colored(
    "胶囊式状态切换开关 (Toggle Switch)",
    @color.Color::accent_primary(),
  )
  ui.spacer(10.0)

  let (min, r1) = @widgets.toggle(
    ui,
    "极简专注模式 (Zen Mode)",
    gallery_state.toggle_minimal,
  )
  if r1.clicked {
    gallery_state.toggle_minimal = min
    gallery_state.status_text = "Zen Mode: " + min.to_string()
  }

  ui.spacer(8.0)

  let (auto, r2) = @widgets.toggle(
    ui,
    "云端自动同步保存 (Cloud Sync)",
    gallery_state.toggle_autosave,
  )
  if r2.clicked {
    gallery_state.toggle_autosave = auto
    gallery_state.status_text = "Auto-save: " + auto.to_string()
  }

  ui.spacer(8.0)

  let (retina, r3) = @widgets.toggle(
    ui,
    "视网膜高分屏自适应 (Retina High-DPR)",
    gallery_state.toggle_retina,
  )
  if r3.clicked {
    gallery_state.toggle_retina = retina
    gallery_state.status_text = "Retina DPR: " + retina.to_string()
  }

  ui.spacer(8.0)

  let (hap, r4) = @widgets.toggle(
    ui,
    "微触觉反馈模拟 (Micro-haptics)",
    gallery_state.toggle_haptics,
  )
  if r4.clicked {
    gallery_state.toggle_haptics = hap
    gallery_state.status_text = "Haptics: " + hap.to_string()
  }
}

///|
fn draw_radio_showcase(ui : @core.UIContext) -> Unit {
  let _ = ui.label_colored(
    "互斥单选按钮组 (Radio Group)",
    @color.Color::accent_primary(),
  )
  ui.spacer(10.0)
  let _ = ui.label("选择当前图层渲染引擎管线：")
  ui.spacer(8.0)

  let (_, r0) = @widgets.radio(
    ui,
    "高性能光栅化模式 (WebGL 2.0 Direct Raster)",
    gallery_state.radio_quality == 0,
  )
  if r0.clicked {
    gallery_state.radio_quality = 0
    gallery_state.status_text = "Quality mode: WebGL 2.0 Direct"
  }

  ui.spacer(6.0)

  let (_, r1) = @widgets.radio(
    ui,
    "平衡矢量渲染模式 (Canvas 2D Batch)",
    gallery_state.radio_quality == 1,
  )
  if r1.clicked {
    gallery_state.radio_quality = 1
    gallery_state.status_text = "Quality mode: Canvas 2D Batch"
  }

  ui.spacer(6.0)

  let (_, r2) = @widgets.radio(
    ui,
    "纯 Wasm 软件像素保真 (Pure Software Wasm)",
    gallery_state.radio_quality == 2,
  )
  if r2.clicked {
    gallery_state.radio_quality = 2
    gallery_state.status_text = "Quality mode: Software Wasm"
  }

  ui.spacer(14.0)
  ui.separator()
  ui.spacer(8.0)
  let mode_desc = match gallery_state.radio_quality {
    0 => "已启用直接着色管线，兼具百万人偶高帧率刷新。"
    1 => "当前生效：兼顾广泛浏览器兼容性与视网膜清晰度。"
    _ => "已启用纯 CPU 标量像素仿真，保证 100% 确定性输出。"
  }
  let _ = ui.label(mode_desc)
}

///|
fn draw_slider_showcase(ui : @core.UIContext) -> Unit {
  let _ = ui.label_colored(
    "连续标量滑块 (Continuous Slider)",
    @color.Color::accent_primary(),
  )
  ui.spacer(10.0)

  let (z, _) = @widgets.slider(
    ui,
    "缩放倍率 (Zoom)",
    gallery_state.slider_zoom,
    0.1,
    5.0,
  )
  if z != gallery_state.slider_zoom {
    gallery_state.slider_zoom = z
    gallery_state.status_text = "Zoom: " + z.to_string()
  }

  ui.spacer(10.0)

  let (op, _) = @widgets.slider(
    ui,
    "图层透明度 (Opacity)",
    gallery_state.slider_opacity,
    0.0,
    100.0,
  )
  if op != gallery_state.slider_opacity {
    gallery_state.slider_opacity = op
    gallery_state.status_text = "Opacity: " + op.to_string() + "%"
  }
}

///|
fn draw_drag_value_showcase(ui : @core.UIContext) -> Unit {
  let _ = ui.label_colored(
    "水银滚动数值调节器 (DragValue Scrubber)",
    @color.Color::accent_primary(),
  )
  ui.spacer(10.0)

  let (x, _) = @widgets.drag_value(
    ui,
    "X 轴坐标",
    gallery_state.drag_x,
    speed=0.5,
    min=-1000.0,
    max=1000.0,
  )
  if x != gallery_state.drag_x {
    gallery_state.drag_x = x
    gallery_state.status_text = "X Pos: " + x.to_string()
  }

  ui.spacer(8.0)

  let (y, _) = @widgets.drag_value(
    ui,
    "Y 轴坐标",
    gallery_state.drag_y,
    speed=0.5,
    min=-1000.0,
    max=1000.0,
  )
  if y != gallery_state.drag_y {
    gallery_state.drag_y = y
    gallery_state.status_text = "Y Pos: " + y.to_string()
  }

  ui.spacer(8.0)

  let (s, _) = @widgets.drag_value(
    ui,
    "比例系数",
    gallery_state.drag_scale,
    speed=0.02,
    min=0.1,
    max=10.0,
  )
  if s != gallery_state.drag_scale {
    gallery_state.drag_scale = s
    gallery_state.status_text = "Scale: " + s.to_string() + "x"
  }
}

///|
fn draw_progress_bar_showcase(ui : @core.UIContext) -> Unit {
  let _ = ui.label_colored(
    "进度加载指示器 (ProgressBar)",
    @color.Color::accent_primary(),
  )
  ui.spacer(10.0)

  let pct_text = (gallery_state.progress_val * 100.0).to_int().to_string() + "%"
  let _ = @widgets.progress_bar(
    ui,
    gallery_state.progress_val,
    text="渲染合成进度 " + pct_text,
  )

  ui.spacer(16.0)
  ui.horizontal(fn(row) {
    if @widgets.button_sized(row, "步进 +10%", @math.Vec2::new(80.0, 26.0)).clicked {
      let mut nv = gallery_state.progress_val + 0.1
      if nv > 1.0 {
        nv = 1.0
      }
      gallery_state.progress_val = nv
      gallery_state.status_text = "Progress: " +
        (nv * 100.0).to_int().to_string() +
        "%"
    }
    row.spacer(8.0)
    if @widgets.button_sized(row, "倒退 -10%", @math.Vec2::new(80.0, 26.0)).clicked {
      let mut nv = gallery_state.progress_val - 0.1
      if nv < 0.0 {
        nv = 0.0
      }
      gallery_state.progress_val = nv
      gallery_state.status_text = "Progress: " +
        (nv * 100.0).to_int().to_string() +
        "%"
    }
    row.spacer(8.0)
    if @widgets.button_sized(row, "重置为 0", @math.Vec2::new(80.0, 26.0)).clicked {
      gallery_state.progress_val = 0.0
      gallery_state.status_text = "Progress reset to 0%"
    }
  })
}

///|
fn draw_spinner_showcase(ui : @core.UIContext) -> Unit {
  let _ = ui.label_colored(
    "时间驱动呼吸微加载动画 (Spinner Animation)",
    @color.Color::accent_primary(),
  )
  ui.spacer(6.0)
  let _ = ui.label(
    "纯时间物理驱动的非对称伸缩公转弧线，60 FPS 平滑无卡顿，无额外定时器开销。",
  )
  ui.spacer(14.0)

  ui.horizontal(fn(row) {
    let _ = @widgets.spinner(row, size=18.0)
    row.spacer(16.0)
    let _ = @widgets.spinner(row, size=24.0, color=@color.Color::success())
    row.spacer(16.0)
    let _ = @widgets.spinner(
      row,
      size=32.0,
      color=@color.Color::danger(),
      stroke_width=3.0,
    )
  })

  ui.spacer(16.0)
  let _ = @widgets.spinner_with_label(
    ui,
    "正在同步远程 MoonBit 模块索引...",
    size=18.0,
  )
}

///|
fn draw_badge_showcase(ui : @core.UIContext) -> Unit {
  let _ = ui.label_colored(
    "状态胶囊与交互标签 (Badge & Tag)",
    @color.Color::accent_primary(),
  )
  ui.spacer(6.0)
  let _ = ui.label(
    "5 种语义状态调色板，支持前置呼吸状态圆点与右侧小叉号关闭移除。",
  )
  ui.spacer(12.0)

  // Badges row
  ui.horizontal(fn(row) {
    let _ = @widgets.badge(row, "Default", kind=@widgets.BadgeKind::default())
    row.spacer(8.0)
    let _ = @widgets.badge(
      row,
      "Success",
      kind=@widgets.BadgeKind::success(),
      dot=true,
    )
    row.spacer(8.0)
    let _ = @widgets.badge(
      row,
      "Warning",
      kind=@widgets.BadgeKind::warning(),
      dot=true,
    )
    row.spacer(8.0)
    let _ = @widgets.badge(
      row,
      "Danger",
      kind=@widgets.BadgeKind::danger(),
      pill=true,
    )
    row.spacer(8.0)
    let _ = @widgets.badge(
      row,
      "v0.3.0",
      kind=@widgets.BadgeKind::info(),
      dot=true,
      pill=true,
    )
  })

  ui.spacer(14.0)

  // Tags row
  ui.horizontal(fn(row) {
    if gallery_state.tag1_open {
      let (c1, _) = @widgets.tag(
        row,
        "tag1",
        "Wasm 32",
        kind=@widgets.BadgeKind::info(),
        closable=true,
      )
      if c1 {
        gallery_state.tag1_open = false
        gallery_state.status_text = "Tag 1 Closed"
      }
      row.spacer(8.0)
    }
    if gallery_state.tag2_open {
      let (c2, _) = @widgets.tag(
        row,
        "tag2",
        "Production",
        kind=@widgets.BadgeKind::success(),
        closable=true,
      )
      if c2 {
        gallery_state.tag2_open = false
        gallery_state.status_text = "Tag 2 Closed"
      }
      row.spacer(8.0)
    }
    if gallery_state.tag3_open {
      let (c3, _) = @widgets.tag(
        row,
        "tag3",
        "Deprecated",
        kind=@widgets.BadgeKind::warning(),
        closable=true,
      )
      if c3 {
        gallery_state.tag3_open = false
        gallery_state.status_text = "Tag 3 Closed"
      }
      row.spacer(8.0)
    }
    if !gallery_state.tag1_open ||
      !gallery_state.tag2_open ||
      !gallery_state.tag3_open {
      if @widgets.button_sized(
          row,
          "恢复所有标签",
          @math.Vec2::new(96.0, 24.0),
        ).clicked {
        gallery_state.tag1_open = true
        gallery_state.tag2_open = true
        gallery_state.tag3_open = true
      }
    }
  })
}
