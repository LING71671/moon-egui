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
pub struct GalleryState {
  mut button_clicks : Int
  mut checkbox_gpu : Bool
  mut checkbox_grid : Bool
  mut checkbox_dark_contrast : Bool
  mut checkbox_antialiasing : Bool
  mut toggle_minimal : Bool
  mut toggle_autosave : Bool
  mut toggle_retina : Bool
  mut toggle_haptics : Bool
  mut radio_quality : Int
  mut slider_zoom : Double
  mut slider_opacity : Double
  mut drag_x : Double
  mut drag_y : Double
  mut drag_scale : Double
  mut knob_cutoff : Double
  mut knob_res : Double
  mut knob_pan : Double
  mut knob_drive : Double
  mut combo_format : Int
  mut combo_color : Int
  mut color_idx : Int
  mut progress_val : Double
  mut tree_selected : String?
  mut tree_expanded : Array[String]
  mut tab_selected : Int
  mut text_name : String
  mut text_email : String
  mut code_buffer : String
  toasts : Array[@core.Toast]
  mut cmd_open : Bool
  mut cmd_query : String
  mut cmd_idx : Int
  mut ctx_menu_open : Bool
  mut ctx_menu_pos : @math.Vec2
  mut status_text : String
  mut active_comp_id : String
  mut splitter_ratio : Double
  mut table_sort_col : String
  mut table_sort_dir : @core.TableSortDirection
  table_columns : Array[@core.TableColumn]
  mut table_selected_row : Int
  mut dialog_open : Bool
  mut dialog_last_result : String
  mut segmented_sel : Int
  mut tag1_open : Bool
  mut tag2_open : Bool
  mut tag3_open : Bool
  sparkline_data : Array[Double]
  mut color_picker_val : @color.Color
  mut breadcrumb_last_clicked : String
  mut rich_text_last_url : String
}

///|
let gallery_state : GalleryState = {
  button_clicks: 0,
  checkbox_gpu: true,
  checkbox_grid: false,
  checkbox_dark_contrast: false,
  checkbox_antialiasing: true,
  toggle_minimal: true,
  toggle_autosave: false,
  toggle_retina: true,
  toggle_haptics: false,
  radio_quality: 1,
  slider_zoom: 1.25,
  slider_opacity: 85.0,
  drag_x: 120.0,
  drag_y: 80.0,
  drag_scale: 1.0,
  knob_cutoff: 1200.0,
  knob_res: 25.0,
  knob_pan: 0.0,
  knob_drive: 6.0,
  combo_format: 0,
  combo_color: 1,
  color_idx: 0,
  progress_val: 0.68,
  tree_selected: Some("main_mbt"),
  tree_expanded: ["src", "assets"],
  tab_selected: 0,
  text_name: "MoonBit Developer",
  text_email: "dev@moonbitlang.com",
  code_buffer: "///| Welcome to moon-egui native CodeEditor\npub fn render(ui : @core.UIContext) -> Unit {\n  ui.label(\"Pure MoonBit Wasm Engine!\")\n  ui.button(\"Live Immediate-Mode\")\n}",
  toasts: [],
  cmd_open: false,
  cmd_query: "",
  cmd_idx: 0,
  ctx_menu_open: false,
  ctx_menu_pos: @math.Vec2::new(180.0, 140.0),
  status_text: "Ready",
  active_comp_id: "",
  splitter_ratio: 0.45,
  table_sort_col: "id",
  table_sort_dir: @core.TableSortDirection::Ascending,
  table_columns: [
    @core.TableColumn::new("id", "ID", 60.0, min_width=50.0),
    @core.TableColumn::new("name", "Name", 140.0, min_width=80.0),
    @core.TableColumn::new("role", "Role", 110.0, min_width=70.0),
    @core.TableColumn::new("score", "Score", 80.0, min_width=60.0),
  ],
  table_selected_row: 1,
  dialog_open: false,
  dialog_last_result: "None",
  segmented_sel: 0,
  tag1_open: true,
  tag2_open: true,
  tag3_open: true,
  sparkline_data: [
    12.0, 28.0, 19.0, 35.0, 22.0, 48.0, 38.0, 55.0, 42.0, 68.0, 60.0, 85.0,
  ],
  color_picker_val: @color.Color::rgb(79, 70, 229),
  breadcrumb_last_clicked: "None",
  rich_text_last_url: "None",
}

///|
let gallery_ctx : @core.UIContext = @core.UIContext::new()

///|
pub fn get_gallery_status() -> String {
  let s = gallery_state.status_text
  if s.is_empty() {
    "Ready"
  } else {
    s
  }
}

///|
pub fn get_gallery_cursor() -> String {
  let icon = gallery_ctx.cursor_icon()
  if icon != "default" {
    icon
  } else if gallery_ctx.hot_id() != @core.Id::zero() ||
    gallery_ctx.active_id() != @core.Id::zero() {
    "pointer"
  } else {
    "default"
  }
}

// ----------------------------------------------------------------------
// 1. Basic Input Components (Button, TextEdit, CodeEditor)
// ----------------------------------------------------------------------

///|
fn draw_button_showcase(ui : @core.UIContext) -> Unit {
  let _ = ui.label_colored(
    "即时模式按钮与微下沉行程 (Button Suite)",
    @color.Color::accent_primary(),
  )
  ui.spacer(10.0)

  ui.horizontal(fn(row) {
    if row.button_primary("主要按钮 (Primary)").clicked {
      gallery_state.button_clicks = gallery_state.button_clicks + 1
      gallery_state.status_text = "Primary Button clicked: " +
        gallery_state.button_clicks.to_string()
    }
    row.spacer(10.0)
    if row.button("次级按钮 (Normal)").clicked {
      gallery_state.button_clicks = gallery_state.button_clicks + 1
      gallery_state.status_text = "Normal Button clicked: " +
        gallery_state.button_clicks.to_string()
    }
    row.spacer(10.0)
    if row.button_with_shortcut("保存工程", "⌘S").clicked {
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
fn draw_text_edit_showcase(ui : @core.UIContext) -> Unit {
  let _ = ui.label_colored(
    "单行文本输入框 (TextEdit)",
    @color.Color::accent_primary(),
  )
  ui.spacer(10.0)

  let (n, r1) = ui.text_edit(
    "name_input",
    gallery_state.text_name,
    "请输入开发者姓名",
  )
  gallery_state.text_name = n
  if r1.has_focus {
    gallery_state.status_text = "Editing Name: " + n
  }

  ui.spacer(10.0)

  let (e, r2) = ui.text_edit(
    "email_input",
    gallery_state.text_email,
    "dev@moonbitlang.com",
  )
  gallery_state.text_email = e
  if r2.has_focus {
    gallery_state.status_text = "Editing Email: " + e
  }

  ui.spacer(16.0)
  ui.separator()
  ui.spacer(8.0)
  let _ = ui.label(
    "支持光标精确定位、文本追加、退格以及焦点切换。",
  )
}

///|
fn draw_code_editor_showcase(ui : @core.UIContext, card_w : Double) -> Unit {
  let _ = ui.label_colored(
    "多行代码与行号标尺编辑器 (CodeEditor)",
    @color.Color::accent_primary(),
  )
  ui.spacer(6.0)

  let (new_code, resp) = ui.code_editor(
    "gallery_code",
    gallery_state.code_buffer,
    size=@math.Vec2::new(card_w - 32.0, 210.0),
    show_line_numbers=true,
  )
  gallery_state.code_buffer = new_code
  if resp.has_focus {
    gallery_state.status_text = "CodeEditor Focused"
  }
}

// ----------------------------------------------------------------------
// 2. Values & Selection Components
// ----------------------------------------------------------------------

///|
fn draw_checkbox_showcase(ui : @core.UIContext) -> Unit {
  let _ = ui.label_colored(
    "复选选项框 (Checkbox Matrix)",
    @color.Color::accent_primary(),
  )
  ui.spacer(10.0)

  let (g, r1) = ui.checkbox(
    "启用 GPU WebGL 2.0 硬件加速",
    gallery_state.checkbox_gpu,
  )
  if r1.clicked {
    gallery_state.checkbox_gpu = g
    gallery_state.status_text = "GPU Acceleration: " + g.to_string()
  }

  ui.spacer(8.0)

  let (grid, r2) = ui.checkbox(
    "显示对齐辅助参考网格 (Align Grid)",
    gallery_state.checkbox_grid,
  )
  if r2.clicked {
    gallery_state.checkbox_grid = grid
    gallery_state.status_text = "Grid Guide: " + grid.to_string()
  }

  ui.spacer(8.0)

  let (dark, r3) = ui.checkbox(
    "视网膜高对比度强化 (High Contrast)",
    gallery_state.checkbox_dark_contrast,
  )
  if r3.clicked {
    gallery_state.checkbox_dark_contrast = dark
    gallery_state.status_text = "High Contrast: " + dark.to_string()
  }

  ui.spacer(8.0)

  let (aa, r4) = ui.checkbox(
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

  let (min, r1) = ui.toggle(
    "极简专注模式 (Zen Mode)",
    gallery_state.toggle_minimal,
  )
  if r1.clicked {
    gallery_state.toggle_minimal = min
    gallery_state.status_text = "Zen Mode: " + min.to_string()
  }

  ui.spacer(8.0)

  let (auto, r2) = ui.toggle(
    "云端自动同步保存 (Cloud Sync)",
    gallery_state.toggle_autosave,
  )
  if r2.clicked {
    gallery_state.toggle_autosave = auto
    gallery_state.status_text = "Auto-save: " + auto.to_string()
  }

  ui.spacer(8.0)

  let (retina, r3) = ui.toggle(
    "视网膜高分屏自适应 (Retina High-DPR)",
    gallery_state.toggle_retina,
  )
  if r3.clicked {
    gallery_state.toggle_retina = retina
    gallery_state.status_text = "Retina DPR: " + retina.to_string()
  }

  ui.spacer(8.0)

  let (hap, r4) = ui.toggle(
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

  let (_, r0) = ui.radio(
    "高性能光栅化模式 (WebGL 2.0 Direct Raster)",
    gallery_state.radio_quality == 0,
  )
  if r0.clicked {
    gallery_state.radio_quality = 0
    gallery_state.status_text = "Quality mode: WebGL 2.0 Direct"
  }

  ui.spacer(6.0)

  let (_, r1) = ui.radio(
    "平衡矢量渲染模式 (Canvas 2D Batch)",
    gallery_state.radio_quality == 1,
  )
  if r1.clicked {
    gallery_state.radio_quality = 1
    gallery_state.status_text = "Quality mode: Canvas 2D Batch"
  }

  ui.spacer(6.0)

  let (_, r2) = ui.radio(
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

  let (z, _) = ui.slider(
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

  let (op, _) = ui.slider(
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

  let (x, _) = ui.drag_value(
    "X 轴坐标",
    gallery_state.drag_x,
    0.5,
    -1000.0,
    1000.0,
  )
  if x != gallery_state.drag_x {
    gallery_state.drag_x = x
    gallery_state.status_text = "X Pos: " + x.to_string()
  }

  ui.spacer(8.0)

  let (y, _) = ui.drag_value(
    "Y 轴坐标",
    gallery_state.drag_y,
    0.5,
    -1000.0,
    1000.0,
  )
  if y != gallery_state.drag_y {
    gallery_state.drag_y = y
    gallery_state.status_text = "Y Pos: " + y.to_string()
  }

  ui.spacer(8.0)

  let (s, _) = ui.drag_value(
    "比例系数",
    gallery_state.drag_scale,
    0.02,
    0.1,
    10.0,
  )
  if s != gallery_state.drag_scale {
    gallery_state.drag_scale = s
    gallery_state.status_text = "Scale: " + s.to_string() + "x"
  }
}

///|
fn draw_knob_showcase(ui : @core.UIContext) -> Unit {
  let _ = ui.label_colored(
    "270° 弧形物理电位器机架 (Audio / CAD Rack)",
    @color.Color::accent_primary(),
  )
  ui.spacer(8.0)
  ui.horizontal(fn(row) {
    let (c, _) = row.knob(
      "cutoff",
      "CUTOFF",
      gallery_state.knob_cutoff,
      min_val=20.0,
      max_val=20000.0,
      step=10.0,
      default_val=1200.0,
      unit="Hz",
      radius=24.0,
    )
    if c != gallery_state.knob_cutoff {
      gallery_state.knob_cutoff = c
      gallery_state.status_text = "CUTOFF: " + c.to_string() + " Hz"
    }

    row.spacer(16.0)

    let (r, _) = row.knob(
      "res",
      "RESONANCE",
      gallery_state.knob_res,
      min_val=0.0,
      max_val=100.0,
      step=1.0,
      default_val=25.0,
      unit="%",
      radius=24.0,
    )
    if r != gallery_state.knob_res {
      gallery_state.knob_res = r
      gallery_state.status_text = "RESONANCE: " + r.to_string() + "%"
    }

    row.spacer(16.0)

    let (p, _) = row.knob(
      "pan",
      "PAN",
      gallery_state.knob_pan,
      min_val=-100.0,
      max_val=100.0,
      step=1.0,
      default_val=0.0,
      unit="%",
      radius=24.0,
      bipolar=true,
    )
    if p != gallery_state.knob_pan {
      gallery_state.knob_pan = p
      gallery_state.status_text = "PAN (Bipolar): " + p.to_string() + "%"
    }

    row.spacer(16.0)

    let (d, _) = row.knob(
      "drive",
      "DRIVE",
      gallery_state.knob_drive,
      min_val=0.0,
      max_val=24.0,
      step=0.5,
      default_val=6.0,
      unit="dB",
      radius=24.0,
    )
    if d != gallery_state.knob_drive {
      gallery_state.knob_drive = d
      gallery_state.status_text = "DRIVE: " + d.to_string() + " dB"
    }
  })
  ui.spacer(14.0)
  ui.separator()
  ui.spacer(8.0)
  ui.horizontal(fn(row) {
    if row.button_sized("默认预设", @math.Vec2::new(84.0, 26.0)).clicked {
      gallery_state.knob_cutoff = 1200.0
      gallery_state.knob_res = 25.0
      gallery_state.knob_pan = 0.0
      gallery_state.knob_drive = 6.0
      gallery_state.status_text = "Preset applied: Default"
    }
    row.spacer(10.0)
    if row.button_sized("暖调低音", @math.Vec2::new(84.0, 26.0)).clicked {
      gallery_state.knob_cutoff = 380.0
      gallery_state.knob_res = 45.0
      gallery_state.knob_pan = 0.0
      gallery_state.knob_drive = 14.0
      gallery_state.status_text = "Preset applied: Warm Bass"
    }
    row.spacer(10.0)
    if row.button_sized("亮音主导", @math.Vec2::new(84.0, 26.0)).clicked {
      gallery_state.knob_cutoff = 8500.0
      gallery_state.knob_res = 65.0
      gallery_state.knob_pan = 20.0
      gallery_state.knob_drive = 8.0
      gallery_state.status_text = "Preset applied: Bright Lead"
    }
  })
}

///|
fn draw_combo_box_showcase(ui : @core.UIContext) -> Unit {
  let _ = ui.label_colored(
    "下拉单选菜单 (ComboBox)",
    @color.Color::accent_primary(),
  )
  ui.spacer(10.0)

  let formats = [
    "PNG 无损位图", "SVG 矢量图形", "WebP 高效压缩", "PDF 文档格式",
  ]
  let (f, _) = ui.combo_box(
    "fmt",
    "导出格式",
    gallery_state.combo_format,
    formats,
  )
  if f != gallery_state.combo_format {
    gallery_state.combo_format = f
    gallery_state.status_text = "Format selected: " + formats[f]
  }

  ui.spacer(12.0)

  let spaces = [
    "sRGB (标准色彩)", "Display P3 (广色域)", "Adobe RGB (专业印刷)",
  ]
  let (c, _) = ui.combo_box(
    "color_space",
    "色彩空间",
    gallery_state.combo_color,
    spaces,
  )
  if c != gallery_state.combo_color {
    gallery_state.combo_color = c
    gallery_state.status_text = "Color space: " + spaces[c]
  }
}

///|
fn draw_color_button_showcase(ui : @core.UIContext) -> Unit {
  let _ = ui.label_colored(
    "调色板拾取器 (ColorButton Palette)",
    @color.Color::accent_primary(),
  )
  ui.spacer(10.0)
  let _ = ui.label("点击色块选择主题主色：")
  ui.spacer(10.0)

  let palette = [
    @color.Color::rgb(37, 99, 235), // Blue
    @color.Color::rgb(16, 185, 129), // Emerald
    @color.Color::rgb(245, 158, 11), // Amber
    @color.Color::rgb(244, 63, 94), // Rose
    @color.Color::rgb(100, 116, 139), // Slate
    @color.Color::rgb(139, 92, 246), // Violet
  ]
  let names = [
    "Cobalt Blue", "Emerald Green", "Amber Gold", "Rose Coral", "Slate Dark", "Violet Purple",
  ]

  ui.horizontal(fn(row) {
    for i = 0; i < palette.length(); i = i + 1 {
      let (clicked, _) = row.color_button("pal_" + i.to_string(), palette[i])
      if clicked {
        gallery_state.color_idx = i
        gallery_state.status_text = "Selected Color: " + names[i]
      }
      row.spacer(12.0)
    }
  })

  ui.spacer(16.0)
  ui.separator()
  ui.spacer(8.0)
  let active_col = palette[gallery_state.color_idx]
  let active_name = names[gallery_state.color_idx]
  let _ = ui.label_colored("当前生效色调: " + active_name, active_col)
}

// ----------------------------------------------------------------------
// 3. Feedback & Presentation Components
// ----------------------------------------------------------------------

///|
fn draw_progress_bar_showcase(ui : @core.UIContext) -> Unit {
  let _ = ui.label_colored(
    "进度加载指示器 (ProgressBar)",
    @color.Color::accent_primary(),
  )
  ui.spacer(10.0)

  let pct_text = (gallery_state.progress_val * 100.0).to_int().to_string() + "%"
  let _ = ui.progress_bar(
    gallery_state.progress_val,
    "渲染合成进度 " + pct_text,
  )

  ui.spacer(16.0)
  ui.horizontal(fn(row) {
    if row.button_sized("步进 +10%", @math.Vec2::new(80.0, 26.0)).clicked {
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
    if row.button_sized("倒退 -10%", @math.Vec2::new(80.0, 26.0)).clicked {
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
    if row.button_sized("重置为 0", @math.Vec2::new(80.0, 26.0)).clicked {
      gallery_state.progress_val = 0.0
      gallery_state.status_text = "Progress reset to 0%"
    }
  })
}

///|
fn draw_collapsing_header_showcase(ui : @core.UIContext) -> Unit {
  let _ = ui.label_colored(
    "折叠信息面板 (CollapsingHeader)",
    @color.Color::accent_primary(),
  )
  ui.spacer(8.0)

  let _ = ui.collapsing_header("sec_render", "图形着色管线配置", true, fn(
    sec,
  ) {
    sec.spacer(4.0)
    let (g, _) = sec.checkbox(
      "开启矢量纹理多级渐远 (Mipmapping)",
      gallery_state.checkbox_gpu,
    )
    gallery_state.checkbox_gpu = g
    sec.spacer(4.0)
    let (z, _) = sec.slider(
      "视口平移阻尼系数",
      gallery_state.slider_zoom,
      0.1,
      3.0,
    )
    gallery_state.slider_zoom = z
    sec.spacer(4.0)
  })

  ui.spacer(8.0)

  let _ = ui.collapsing_header("sec_grid", "辅助网格剖分参数", false, fn(
    sec,
  ) {
    sec.spacer(4.0)
    let (x, _) = sec.drag_value(
      "网格间距",
      gallery_state.drag_x,
      1.0,
      5.0,
      100.0,
    )
    gallery_state.drag_x = x
    sec.spacer(4.0)
    let (gr, _) = sec.checkbox(
      "开启极简背景",
      gallery_state.checkbox_grid,
    )
    gallery_state.checkbox_grid = gr
    sec.spacer(4.0)
  })
}

///|
fn draw_tree_view_showcase(ui : @core.UIContext, card_w : Double) -> Unit {
  let _ = ui.label_colored(
    "分层引导线资产树 (Hierarchy TreeView)",
    @color.Color::accent_primary(),
  )
  ui.spacer(6.0)

  let tree_data = [
    @core.TreeNode::new(
      "src",
      "src",
      children=[
        @core.TreeNode::new(
          "core",
          "core",
          children=[
            @core.TreeNode::leaf("button_mbt", "button.mbt", icon="mbt"),
            @core.TreeNode::leaf("knob_mbt", "knob.mbt", icon="mbt"),
            @core.TreeNode::leaf("tree_view_mbt", "tree_view.mbt", icon="mbt"),
            @core.TreeNode::leaf(
              "code_editor_mbt",
              "code_editor.mbt",
              icon="mbt",
            ),
          ],
          icon="folder",
        ),
        @core.TreeNode::new(
          "draw",
          "draw",
          children=[
            @core.TreeNode::leaf("draw_list_mbt", "draw_list.mbt", icon="mbt"),
            @core.TreeNode::leaf("command_mbt", "command.mbt", icon="mbt"),
          ],
          icon="folder",
        ),
        @core.TreeNode::leaf("main_mbt", "main.mbt", icon="mbt"),
      ],
      icon="folder",
    ),
    @core.TreeNode::new(
      "assets",
      "assets",
      children=[
        @core.TreeNode::leaf("logo_png", "logo.png", icon="img"),
        @core.TreeNode::leaf("shader_wgsl", "shader.wgsl", icon="code"),
        @core.TreeNode::leaf("theme_json", "theme.json", icon="json"),
      ],
      icon="folder",
    ),
    @core.TreeNode::leaf("moon_mod", "moon.mod", icon="doc"),
    @core.TreeNode::leaf("readme_md", "README.md", icon="doc"),
  ]

  let tree_resp = ui.tree_view(
    "gallery_tree",
    tree_data,
    selected_id=gallery_state.tree_selected,
    expanded_ids=gallery_state.tree_expanded,
    size=@math.Vec2::new(card_w - 32.0, 220.0),
  )

  gallery_state.tree_expanded = tree_resp.expanded_ids
  if tree_resp.selected_id is Some(sid) {
    gallery_state.tree_selected = Some(sid)
    gallery_state.status_text = "Selected: " + sid
  }
}

///|
fn draw_tooltip_showcase(ui : @core.UIContext) -> Unit {
  let _ = ui.label_colored(
    "即时浮动微型提示气泡 (Tooltip Bubble)",
    @color.Color::accent_primary(),
  )
  ui.spacer(8.0)
  let _ = ui.label(
    "将鼠标悬停在下方各控制按钮上查看即时气泡提示：",
  )
  ui.spacer(12.0)

  ui.horizontal(fn(row) {
    let r1 = row.button_sized(
      "图元渲染统计",
      @math.Vec2::new(110.0, 28.0),
    )
    if r1.hovered {
      row.tooltip("当前视口活跃图元: 1,024 Rects, 32 Texts")
    }

    row.spacer(10.0)

    let r2 = row.button_sized("GC 运行状态", @math.Vec2::new(110.0, 28.0))
    if r2.hovered {
      row.tooltip("MoonBit 自动内存管理正常，零垃圾回收卡顿")
    }

    row.spacer(10.0)

    let r3 = row.button_sized(
      "导出设计令牌",
      @math.Vec2::new(110.0, 28.0),
    )
    if r3.hovered {
      row.tooltip("导出符合 Studio Light 规范的标准 Token JSON")
    }
  })

  ui.spacer(16.0)
  ui.separator()
  ui.spacer(8.0)
  let _ = ui.label(
    "气泡在顶层前景渲染层自动绘制，带精准像素避让与轻量投影。",
  )
}

// ----------------------------------------------------------------------
// 4. Containers & Layout Components
// ----------------------------------------------------------------------

///|
fn draw_tab_bar_showcase(ui : @core.UIContext) -> Unit {
  let _ = ui.label_colored(
    "分段式导航标签栏 (TabBar)",
    @color.Color::accent_primary(),
  )
  ui.spacer(8.0)

  let tabs = [
    "规范概览 Overview", "内核性能 Metrics", "运行日志 Logs",
  ]
  let (cur, _) = ui.tab_bar("demo_tab", tabs, gallery_state.tab_selected)
  if cur != gallery_state.tab_selected {
    gallery_state.tab_selected = cur
    gallery_state.status_text = "Tab switched: " + tabs[cur]
  }

  ui.spacer(14.0)
  ui.separator()
  ui.spacer(10.0)

  match gallery_state.tab_selected {
    0 => {
      let _ = ui.label(
        "【规范概览】Moon-EGUI 遵循 Studio Light 极简陶瓷质感标准。",
      )
      ui.spacer(4.0)
      let _ = ui.label(
        "采用精准 8px 网格步进系统，高透光微投影与 1px 细发丝描边。",
      )
    }
    1 => {
      let _ = ui.label(
        "【内核性能】微秒级布局计算，零中间虚拟 DOM 分配开销。",
      )
      ui.spacer(4.0)
      let _ = ui.label(
        "全量 DrawList 矢量原语管线，满帧稳定运行于 60 FPS。",
      )
    }
    _ => {
      let _ = ui.label(
        "【运行日志】[INFO] Canvas Host Mounted successfully.",
      )
      ui.spacer(4.0)
      let _ = ui.label(
        "[INFO] Immediate-mode engine tick: 0.28ms dispatch time.",
      )
    }
  }
}

///|
fn draw_menu_bar_showcase(ui : @core.UIContext) -> Unit {
  let _ = ui.label_colored(
    "桌面级顶层系统菜单栏 (MenuBar)",
    @color.Color::accent_primary(),
  )
  ui.spacer(8.0)

  ui.menu_bar(fn(bar) {
    bar.menu("文件 (File)", fn(m) {
      if m.menu_item("新建图纸", shortcut="⌘N").clicked {
        gallery_state.status_text = "Menu: New File"
      }
      if m.menu_item("保存图元", shortcut="⌘S").clicked {
        gallery_state.status_text = "Menu: Save File"
      }
      m.menu_separator()
      if m.menu_item("退出", shortcut="⌘Q").clicked {
        gallery_state.status_text = "Menu: Quit"
      }
    })

    bar.menu("编辑 (Edit)", fn(m) {
      if m.menu_item("撤销", shortcut="⌘Z").clicked {
        gallery_state.status_text = "Menu: Undo"
      }
      if m.menu_item("重做", shortcut="⌘Y").clicked {
        gallery_state.status_text = "Menu: Redo"
      }
      m.menu_separator()
      if m.menu_item("复制", shortcut="⌘C").clicked {
        gallery_state.status_text = "Menu: Copy"
      }
      if m.menu_item("粘贴", shortcut="⌘V").clicked {
        gallery_state.status_text = "Menu: Paste"
      }
    })

    bar.menu("视图 (View)", fn(m) {
      if m.menu_item("全景自适应", shortcut="⌘0").clicked {
        gallery_state.status_text = "Menu: Fit All"
      }
      if m.menu_item("网格吸附").clicked {
        gallery_state.status_text = "Menu: Snap to Grid"
      }
    })

    bar.menu("帮助 (Help)", fn(m) {
      if m.menu_item("关于 moon-egui").clicked {
        gallery_state.status_text = "Menu: About moon-egui"
      }
      if m.menu_item("MoonBit 官方文档").clicked {
        gallery_state.status_text = "Menu: MoonBit Docs"
      }
    })
  })

  ui.spacer(14.0)
  ui.separator()
  ui.spacer(8.0)
  let _ = ui.label(
    "支持桌面原生 hover 联动切换下拉、快捷键标识与分割线。",
  )
}

///|
fn draw_scroll_area_showcase(ui : @core.UIContext, card_w : Double) -> Unit {
  let _ = ui.label_colored(
    "带视口裁剪与滑块的滚动区域 (ScrollArea)",
    @color.Color::accent_primary(),
  )
  ui.spacer(6.0)

  ui.scroll_area("gallery_scroll", @math.Vec2::new(card_w - 32.0, 200.0), fn(
    sa,
  ) {
    for i = 1; i <= 20; i = i + 1 {
      let text = "图元索引条目 #" +
        i.to_string() +
        " (Immediate-Mode Vector Render Record)"
      let _ = sa.label(text)
      sa.spacer(4.0)
    }
  })
  ui.spacer(8.0)
  let _ = ui.label(
    "支持鼠标滚轮滚动、精确局部 Scissor 剪裁与按需滚动条。",
  )
}

///|
fn draw_window_showcase(
  ui : @core.UIContext,
  vp_w : Double,
  vp_h : Double,
) -> Unit {
  let _ = ui.label_colored(
    "浮动视窗与拖拽吸附 (Floating Window)",
    @color.Color::accent_primary(),
  )
  ui.spacer(6.0)
  let _ = ui.label(
    "按住标题栏可在 Canvas 画布内任意拖动，具有层级抬升与边界约束。",
  )

  let win_pos = @math.Vec2::new(80.0, 80.0)
  let win_size = @math.Vec2::new(260.0, 180.0)
  let _ = ui.window(
    "CAD 属性面板 (Window)",
    win_pos,
    win_size,
    fn(w) {
      let _ = w.label("即时模式浮动视窗")
      w.spacer(4.0)
      let (z, _) = w.slider("缩放", gallery_state.slider_zoom, 0.1, 5.0)
      gallery_state.slider_zoom = z
      w.spacer(4.0)
      if w.button("置中镜头").clicked {
        gallery_state.status_text = "Window Action: Recenter"
      }
    },
    id_salt="gallery_win",
    constrain_to=@math.Rect::new(0.0, 0.0, vp_w, vp_h),
  )
}

///|
fn draw_command_palette_showcase(ui : @core.UIContext) -> Unit {
  let _ = ui.label_colored(
    "全局模糊指令面板 (CommandPalette ⌘K)",
    @color.Color::accent_primary(),
  )
  ui.spacer(10.0)

  if ui.button_primary_sized(
      "唤起命令面板 (⌘K)",
      @math.Vec2::new(160.0, 32.0),
    ).clicked {
    gallery_state.cmd_open = true
    gallery_state.status_text = "Command Palette Opened"
  }

  let commands = [
    @core.CommandItem::new(
      "new_file",
      "新建工程图纸 (New Canvas)",
      category="文件",
      shortcut="⌘N",
    ),
    @core.CommandItem::new(
      "save",
      "保存当前工程 (Save Project)",
      category="文件",
      shortcut="⌘S",
    ),
    @core.CommandItem::new(
      "zoom_fit",
      "全景自适应视图 (Fit All)",
      category="视图",
      shortcut="⌘0",
    ),
    @core.CommandItem::new(
      "theme_light",
      "切换白瓷工件风格 (Porcelain Theme)",
      category="外观",
    ),
    @core.CommandItem::new(
      "export_svg",
      "导出矢量 SVG 绘图 (Export Vector)",
      category="导出",
      shortcut="⌘E",
    ),
  ]

  let resp = ui.command_palette(
    gallery_state.cmd_open,
    gallery_state.cmd_query,
    commands,
    selected_index=gallery_state.cmd_idx,
  )

  gallery_state.cmd_open = resp.open
  gallery_state.cmd_query = resp.query
  gallery_state.cmd_idx = resp.selected_index
  if resp.selected_id is Some(cid) {
    gallery_state.status_text = "Command Executed: " + cid
  }
}

///|
fn draw_context_menu_showcase(
  ui : @core.UIContext,
  vp_w : Double,
  vp_h : Double,
) -> Unit {
  let _ = ui.label_colored(
    "上下文弹出菜单 (ContextMenu)",
    @color.Color::accent_primary(),
  )
  ui.spacer(8.0)
  let _ = ui.label(
    "点击下方按钮触发上下文菜单弹窗，带有屏幕碰撞反转检测：",
  )
  ui.spacer(10.0)

  if ui.button_sized("点击弹出右键菜单", @math.Vec2::new(150.0, 30.0)).clicked {
    gallery_state.ctx_menu_open = true
    gallery_state.ctx_menu_pos = @math.Vec2::new(180.0, 120.0)
    gallery_state.status_text = "Context Menu Opened"
  }

  let items = [
    @core.ContextMenuItem::new(
      "copy",
      "复制当前组件代码",
      shortcut="⌘C",
    ),
    @core.ContextMenuItem::new("paste", "粘贴图元属性", shortcut="⌘V"),
    @core.ContextMenuItem::separator(),
    @core.ContextMenuItem::new("inspect", "审查图元层级", shortcut="F12"),
    @core.ContextMenuItem::new("delete", "重置控件状态"),
  ]

  let resp = ui.context_menu_items(
    "demo_ctx",
    gallery_state.ctx_menu_open,
    gallery_state.ctx_menu_pos,
    items,
    menu_width=180.0,
    viewport_size=@math.Vec2::new(vp_w, vp_h),
  )

  gallery_state.ctx_menu_open = resp.open
  if resp.selected_id is Some(sid) {
    gallery_state.status_text = "ContextMenu Action: " + sid
  }
}

///|
fn draw_toast_showcase(
  ui : @core.UIContext,
  vp_w : Double,
  vp_h : Double,
) -> Unit {
  let _ = ui.label_colored(
    "全局胶囊通知堆栈与平滑衰减 (Toast Notifications)",
    @color.Color::accent_primary(),
  )
  ui.spacer(10.0)

  ui.horizontal(fn(row) {
    if row.button_sized("触发信息通知", @math.Vec2::new(104.0, 28.0)).clicked {
      let t = @core.Toast::info(
        "工程提示",
        message="Canvas 2D 光栅化管线就绪",
        duration=4.0,
      )
      gallery_state.toasts.push(t)
      gallery_state.status_text = "Triggered: Info Toast"
    }
    row.spacer(8.0)
    if row.button_sized("触发成功通知", @math.Vec2::new(104.0, 28.0)).clicked {
      let t = @core.Toast::success(
        "编译完成",
        message="Wasm 内核输出 0 警告",
        duration=4.0,
      )
      gallery_state.toasts.push(t)
      gallery_state.status_text = "Triggered: Success Toast"
    }
    row.spacer(8.0)
    if row.button_sized("触发警告通知", @math.Vec2::new(104.0, 28.0)).clicked {
      let t = @core.Toast::warning(
        "内存警告",
        message="视口包含超过 65,536 节点",
        duration=4.0,
      )
      gallery_state.toasts.push(t)
      gallery_state.status_text = "Triggered: Warning Toast"
    }
    row.spacer(8.0)
    if row.button_sized("触发错误通知", @math.Vec2::new(104.0, 28.0)).clicked {
      let t = @core.Toast::danger(
        "连接中断",
        message="WebSocket 帧丢失",
        duration=4.0,
      )
      gallery_state.toasts.push(t)
      gallery_state.status_text = "Triggered: Danger Toast"
    }
  })

  ui.spacer(16.0)
  ui.separator()
  ui.spacer(8.0)
  let _ = ui.label(
    "通知将自动悬浮在右上方，带有时间进度衰减条与手动关闭按钮。",
  )

  let _ = ui.toast_stack(
    gallery_state.toasts,
    anchor=@core.ToastAnchor::TopRight,
    viewport_size=@math.Vec2::new(vp_w, vp_h),
  )
}

// ----------------------------------------------------------------------
// 5. Extended Core Components (10 New Professional Widgets)
// ----------------------------------------------------------------------

///|
fn draw_splitter_showcase(ui : @core.UIContext, card_w : Double) -> Unit {
  let _ = ui.label_colored(
    "双向可拖拽分栏容器 (Splitter Panes)",
    @color.Color::accent_primary(),
  )
  ui.spacer(6.0)
  let _ = ui.label(
    "鼠标拖拽中央把手调节比例，内置 >= 60px 物理防挤压防护与 Scissor 裁剪盒。",
  )
  ui.spacer(10.0)

  let split_size = @math.Vec2::new(card_w - 40.0, 220.0)
  let new_ratio = ui.split_horizontal(
    "gal_split_h",
    gallery_state.splitter_ratio,
    split_size,
    fn(pane_ui, rect) {
      pane_ui.draw_list().add_rect(rect, @color.Color::rgb(241, 245, 249), 4.0)
      pane_ui.set_cursor(@math.Vec2::new(rect.x + 12.0, rect.y + 12.0))
      let _ = pane_ui.label_colored(
        "左侧主导航栏",
        @color.Color::accent_primary(),
      )
      pane_ui.spacer(6.0)
      let _ = pane_ui.label("项目文件 (src/)")
      let _ = pane_ui.label("资源目录 (assets/)")
    },
    fn(pane_ui, rect) {
      pane_ui.draw_list().add_rect(rect, @color.Color::rgb(248, 250, 252), 4.0)
      pane_ui.set_cursor(@math.Vec2::new(rect.x + 12.0, rect.y + 12.0))
      let _ = pane_ui.label_colored(
        "右侧工作区画布",
        @color.Color::text_strong(),
      )
      pane_ui.spacer(6.0)
      let _ = pane_ui.label(
        "实时分栏比例: " +
        (gallery_state.splitter_ratio * 100.0).to_int().to_string() +
        "%",
      )
    },
  )
  gallery_state.splitter_ratio = new_ratio
}

///|
fn draw_table_showcase(ui : @core.UIContext, card_w : Double) -> Unit {
  let _ = ui.label_colored(
    "海量数据虚拟化表格 (Virtual Table)",
    @color.Color::accent_primary(),
  )
  ui.spacer(6.0)
  let _ = ui.label(
    "支持 10,000 行极速虚拟滚动（只渲染视口行），支持列宽拖拽与表头排序。",
  )
  ui.spacer(10.0)

  let resp = ui.table(
    "gal_table",
    @math.Vec2::new(card_w - 40.0, 220.0),
    gallery_state.table_columns,
    10000,
    fn(cell_ui, r, c, rect) {
      let cell_text = match c {
        0 => "#" + r.to_string()
        1 => "User_" + r.to_string()
        2 =>
          if r % 3 == 0 {
            "Admin"
          } else if r % 3 == 1 {
            "Developer"
          } else {
            "Viewer"
          }
        3 => (80 + r * 7 % 20).to_string() + " pts"
        _ => ""
      }
      cell_ui.set_cursor(@math.Vec2::new(rect.x + 8.0, rect.y + 7.0))
      let _ = cell_ui.label(cell_text)
    },
    selected_row=gallery_state.table_selected_row,
    sort_column=gallery_state.table_sort_col,
    sort_direction=gallery_state.table_sort_dir,
  )

  if resp.sort_changed {
    gallery_state.table_sort_col = resp.sort_column
    gallery_state.table_sort_dir = resp.sort_direction
    gallery_state.status_text = "Table Sorted: " + resp.sort_column
  }
  match resp.clicked_row {
    Some(r) => {
      gallery_state.table_selected_row = r
      gallery_state.status_text = "Row Selected: " + r.to_string()
    }
    None => ()
  }
}

///|
fn draw_dialog_showcase(
  ui : @core.UIContext,
  cur_w : Double,
  cur_h : Double,
) -> Unit {
  let _ = ui.label_colored(
    "模态二次确认对话框 (Dialog System)",
    @color.Color::accent_primary(),
  )
  ui.spacer(6.0)
  let _ = ui.label(
    "全屏暗色半透明遮罩与物理事件阻断，支持 Esc 快捷取消与 Enter 快速确认。",
  )
  ui.spacer(12.0)

  if ui.button_primary("触发警示对话框 (Open Dialog)").clicked {
    gallery_state.dialog_open = true
    gallery_state.status_text = "Dialog Opened"
  }

  ui.spacer(8.0)
  let _ = ui.label("最后交互状态: " + gallery_state.dialog_last_result)

  if gallery_state.dialog_open {
    let res = ui.dialog(
      "gal_confirm_dlg",
      "重置工程配置文件？",
      "此操作将清除所有自定义键位绑定并恢复出厂默认值。",
      kind=@core.DialogKind::Warning,
      viewport_size=@math.Vec2::new(cur_w, cur_h),
    )
    match res {
      Confirmed => {
        gallery_state.dialog_open = false
        gallery_state.dialog_last_result = "Confirmed (已确认)"
        gallery_state.status_text = "Action Confirmed"
      }
      Cancelled => {
        gallery_state.dialog_open = false
        gallery_state.dialog_last_result = "Cancelled (已取消)"
        gallery_state.status_text = "Action Cancelled"
      }
      Open => ()
    }
  }
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
    let _ = row.spinner(size=18.0)
    row.spacer(16.0)
    let _ = row.spinner(size=24.0, color=@color.Color::success())
    row.spacer(16.0)
    let _ = row.spinner(
      size=32.0,
      color=@color.Color::danger(),
      stroke_width=3.0,
    )
  })

  ui.spacer(16.0)
  let _ = ui.spinner_with_label(
    "正在同步远程 MoonBit 模块索引...",
    size=18.0,
  )
}

///|
fn draw_sparkline_showcase(ui : @core.UIContext) -> Unit {
  let _ = ui.label_colored(
    "实时微型折线走势图 (Sparkline Metrics)",
    @color.Color::accent_primary(),
  )
  ui.spacer(6.0)
  let _ = ui.label(
    "归一化极值自适应映射，浅晕投影，内置零差值防崩溃与鼠标就近吸附准心。",
  )
  ui.spacer(12.0)

  ui.horizontal(fn(row) {
    let (h1, _) = row.sparkline(
      "spk_cpu",
      gallery_state.sparkline_data,
      size=@math.Vec2::new(140.0, 42.0),
    )
    row.spacer(16.0)
    let (h2, _) = row.sparkline(
      "spk_fps",
      [58.0, 59.0, 60.0, 60.0, 59.0, 60.0, 60.0, 60.0, 59.0, 60.0],
      size=@math.Vec2::new(140.0, 42.0),
      color=@color.Color::success(),
    )
    row.spacer(16.0)
    let (h3, _) = row.sparkline(
      "spk_mem",
      [120.0, 125.0, 130.0, 140.0, 142.0, 138.0, 145.0, 150.0],
      size=@math.Vec2::new(140.0, 42.0),
      color=@color.Color::warning(),
    )

    match h1 {
      Some(idx) =>
        gallery_state.status_text = "CPU Sparkline Node: #" + idx.to_string()
      None =>
        match h2 {
          Some(idx) =>
            gallery_state.status_text = "FPS Sparkline Node: #" +
              idx.to_string()
          None =>
            match h3 {
              Some(idx) =>
                gallery_state.status_text = "Memory Sparkline Node: #" +
                  idx.to_string()
              None => ()
            }
        }
    }
  })
}

///|
fn draw_segmented_control_showcase(ui : @core.UIContext) -> Unit {
  let _ = ui.label_colored(
    "分段控制器 (SegmentedControl)",
    @color.Color::accent_primary(),
  )
  ui.spacer(6.0)
  let _ = ui.label(
    "微凹浅灰底槽 + 悬浮纯白瓷药丸，支持鼠标点击与左右方向键轮转选项。",
  )
  ui.spacer(12.0)

  let views = [
    "日视图 (Day)", "周视图 (Week)", "月视图 (Month)", "年趋势 (Year)",
  ]
  let (sel, _) = ui.segmented_control(
    "gal_seg",
    views,
    gallery_state.segmented_sel,
    width=360.0,
  )
  if sel != gallery_state.segmented_sel {
    gallery_state.segmented_sel = sel
    gallery_state.status_text = "Segment Selected: " + views[sel]
  }
}

///|
fn draw_badge_showcase(ui : @core.UIContext) -> Unit {
  let _ = ui.label_colored(
    "状态胶囊与交互标签 (Badge & Tag)",
    @color.Color::accent_primary(),
  )
  ui.spacer(6.0)
  let _ = ui.label(
    "5 种低饱和专业双色阶调色板，支持前置呼吸状态圆点与右侧小叉号关闭移除。",
  )
  ui.spacer(12.0)

  // Badges row
  ui.horizontal(fn(row) {
    let _ = row.badge("Default", kind=@core.BadgeKind::default())
    row.spacer(8.0)
    let _ = row.badge("Success", kind=@core.BadgeKind::success(), dot=true)
    row.spacer(8.0)
    let _ = row.badge("Warning", kind=@core.BadgeKind::warning(), dot=true)
    row.spacer(8.0)
    let _ = row.badge("Danger", kind=@core.BadgeKind::danger(), pill=true)
    row.spacer(8.0)
    let _ = row.badge(
      "Beta v0.2.0",
      kind=@core.BadgeKind::info(),
      dot=true,
      pill=true,
    )
  })

  ui.spacer(14.0)

  // Tags row
  ui.horizontal(fn(row) {
    if gallery_state.tag1_open {
      let (c1, _) = row.tag(
        "tag1",
        "Wasm 32",
        kind=@core.BadgeKind::info(),
        closable=true,
      )
      if c1 {
        gallery_state.tag1_open = false
        gallery_state.status_text = "Tag 1 Closed"
      }
      row.spacer(8.0)
    }
    if gallery_state.tag2_open {
      let (c2, _) = row.tag(
        "tag2",
        "Production",
        kind=@core.BadgeKind::success(),
        closable=true,
      )
      if c2 {
        gallery_state.tag2_open = false
        gallery_state.status_text = "Tag 2 Closed"
      }
      row.spacer(8.0)
    }
    if gallery_state.tag3_open {
      let (c3, _) = row.tag(
        "tag3",
        "Deprecated",
        kind=@core.BadgeKind::warning(),
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
      if row.button_sized("恢复所有标签", @math.Vec2::new(96.0, 24.0)).clicked {
        gallery_state.tag1_open = true
        gallery_state.tag2_open = true
        gallery_state.tag3_open = true
      }
    }
  })
}

///|
fn draw_breadcrumb_showcase(ui : @core.UIContext) -> Unit {
  let _ = ui.label_colored(
    "层级路径面包屑 (Breadcrumb)",
    @color.Color::accent_primary(),
  )
  ui.spacer(6.0)
  let _ = ui.label(
    "横向单行层级导航条，祖先项悬停底色微光与快速回退，超长路径自动折叠。",
  )
  ui.spacer(12.0)

  let path1 = ["工作区", "moon-egui", "src", "core", "table.mbt"]
  let (c1, _) = ui.breadcrumb("gal_bc1", path1)
  match c1 {
    Some(idx) => {
      gallery_state.breadcrumb_last_clicked = path1[idx]
      gallery_state.status_text = "Navigated to: " + path1[idx]
    }
    None => ()
  }

  ui.spacer(14.0)

  let long_path = [
    "Root", "Volumes", "ling71671", "Projects", "moon-egui", "examples", "canvas",
    "gallery.html",
  ]
  let (c2, _) = ui.breadcrumb(
    "gal_bc2",
    long_path,
    separator=">",
    max_visible=4,
  )
  match c2 {
    Some(idx) => {
      gallery_state.breadcrumb_last_clicked = long_path[idx]
      gallery_state.status_text = "Navigated to: " + long_path[idx]
    }
    None => ()
  }

  ui.spacer(8.0)
  let _ = ui.label(
    "最后点击节点: " + gallery_state.breadcrumb_last_clicked,
  )
}

///|
fn draw_color_picker_showcase(ui : @core.UIContext) -> Unit {
  let _ = ui.label_colored(
    "专业级 2D HSV 拾色器 (ColorPicker)",
    @color.Color::accent_primary(),
  )
  ui.spacer(6.0)
  let _ = ui.label(
    "2D 饱和度-明度渐变方盘，彩虹色相槽，Alpha 棋盘格，双环高对比取色游标。",
  )
  ui.spacer(12.0)

  ui.horizontal(fn(row) {
    let (c1, _) = row.color_picker(
      "gal_cp",
      gallery_state.color_picker_val,
      show_alpha=true,
    )
    gallery_state.color_picker_val = c1
    row.spacer(24.0)
    let (c2, _) = row.color_picker_button(
      "gal_cp_btn",
      gallery_state.color_picker_val,
      show_alpha=true,
    )
    gallery_state.color_picker_val = c2
  })
}

///|
fn draw_rich_text_showcase(ui : @core.UIContext, card_w : Double) -> Unit {
  let _ = ui.label_colored(
    "流式排版富文本与超链接 (RichText & Hyperlink)",
    @color.Color::accent_primary(),
  )
  ui.spacer(6.0)
  let _ = ui.label(
    "支持单词自适应折行、行内代码块质感与悬停柔和下划线超链接。",
  )
  ui.spacer(12.0)

  let spans = [
    @core.TextSpan::normal("当前运行环境为"),
    @core.TextSpan::code("MoonBit Wasm"),
    @core.TextSpan::bold("即时模式渲染管线。"),
    @core.TextSpan::normal(
      "它直接向原生 HTML5 Canvas 提交绘制指令。欲了解更多细节，请访问",
    ),
    @core.TextSpan::link("MoonBit 官方主页", "https://www.moonbitlang.cn"),
    @core.TextSpan::normal("或查看"),
    @core.TextSpan::link("API 手册", "https://docs.moonbitlang.com"),
    @core.TextSpan::normal("。"),
  ]

  let resp = ui.rich_text("gal_rt", spans, wrap_width=card_w - 60.0)
  match resp.clicked_url {
    Some(url) => {
      gallery_state.rich_text_last_url = url
      gallery_state.status_text = "Clicked URL: " + url
    }
    None => ()
  }

  ui.spacer(16.0)
  let (clicked, _) = ui.hyperlink(
    "独立超链接组件: moon-egui GitHub Repository", "https://github.com/LING71671/moon-egui",
  )
  if clicked {
    gallery_state.rich_text_last_url = "https://github.com/LING71671/moon-egui"
    gallery_state.status_text = "Clicked GitHub Link"
  }

  ui.spacer(8.0)
  let _ = ui.label("最后激活链接: " + gallery_state.rich_text_last_url)
}

// ----------------------------------------------------------------------
// Frame Step Dispatcher
// ----------------------------------------------------------------------

///|
/// Native MoonBit Component Showcase Frame Entry Point.
/// Evaluates native widgets and returns pure @draw.DrawList to JavaScript.
pub fn gallery_step(
  comp_id : String,
  mouse_x : Double,
  mouse_y : Double,
  mouse_down : Bool,
  scroll_dy : Double,
  vp_w : Double,
  vp_h : Double,
  text_input : String,
  keys_pressed : Array[String],
  keys_released : Array[String],
  mod_flags : Int,
) -> @draw.DrawList {
  let cur_w = if vp_w > 100.0 { vp_w } else { 800.0 }
  let cur_h = if vp_h > 100.0 { vp_h } else { 500.0 }

  // 1. Convert host inputs to RawInput
  let raw = host_raw_input(
    mouse_x,
    mouse_y,
    mouse_down,
    text_input,
    keys_pressed,
    keys_released,
    mod_flags,
    scroll_dy~,
  )

  // 2. Begin Frame
  if comp_id != gallery_state.active_comp_id {
    gallery_state.active_comp_id = comp_id
    gallery_state.cmd_open = false
    gallery_state.ctx_menu_open = false
    gallery_ctx.set_open_combo_id(@core.Id::zero())
    gallery_ctx.set_open_menu_id(@core.Id::zero())
  }
  gallery_ctx.begin_frame(raw)

  // 3. Render Subtle Studio Light Grid Background
  let dl = gallery_ctx.draw_list
  dl.add_rect(
    @math.Rect::new(0.0, 0.0, cur_w, cur_h),
    @color.Color::bg_subtle(),
    0.0,
  )

  // 4. Centered White Porcelain Card Container
  let pad_x = if cur_w > 560.0 { 32.0 } else { 12.0 }
  let pad_y = 24.0
  let card_w = cur_w - pad_x * 2.0
  let card_h = cur_h - pad_y * 2.0
  let card_rect = @math.Rect::new(pad_x, pad_y, card_w, card_h)

  // Porcelain Card Disc & Border Shadow
  dl.add_rect(
    @math.Rect::new(pad_x, pad_y + 2.0, card_w, card_h),
    @color.Color::shadow(),
    8.0,
  )
  dl.add_rect(card_rect, @color.Color::white(), 8.0)
  dl.add_rect_stroke(card_rect, @color.Color::border_default(), 1.0, 8.0)

  // Layout Cursor within Porcelain Card
  gallery_ctx.set_cursor(@math.Vec2::new(pad_x + 20.0, pad_y + 18.0))
  gallery_ctx.set_available_width(card_w - 40.0)

  // 5. Component Showcase Dispatcher for ALL 22 components
  match comp_id {
    // Basic Input
    "button" => draw_button_showcase(gallery_ctx)
    "text_edit" => draw_text_edit_showcase(gallery_ctx)
    "code_editor" => draw_code_editor_showcase(gallery_ctx, card_w)

    // Values & Selection
    "checkbox" => draw_checkbox_showcase(gallery_ctx)
    "toggle" => draw_toggle_showcase(gallery_ctx)
    "radio" => draw_radio_showcase(gallery_ctx)
    "slider" => draw_slider_showcase(gallery_ctx)
    "drag_value" => draw_drag_value_showcase(gallery_ctx)
    "knob" => draw_knob_showcase(gallery_ctx)
    "combo_box" => draw_combo_box_showcase(gallery_ctx)
    "color_button" => draw_color_button_showcase(gallery_ctx)

    // Feedback & Presentation
    "progress_bar" => draw_progress_bar_showcase(gallery_ctx)
    "collapsing_header" => draw_collapsing_header_showcase(gallery_ctx)
    "tree_view" => draw_tree_view_showcase(gallery_ctx, card_w)
    "tooltip" => draw_tooltip_showcase(gallery_ctx)

    // Containers & Layout
    "tab_bar" => draw_tab_bar_showcase(gallery_ctx)
    "menu_bar" => draw_menu_bar_showcase(gallery_ctx)
    "scroll_area" => draw_scroll_area_showcase(gallery_ctx, card_w)
    "window" => draw_window_showcase(gallery_ctx, cur_w, cur_h)
    "command_palette" => draw_command_palette_showcase(gallery_ctx)
    "context_menu" => draw_context_menu_showcase(gallery_ctx, cur_w, cur_h)
    "toast" => draw_toast_showcase(gallery_ctx, cur_w, cur_h)
    "splitter" => draw_splitter_showcase(gallery_ctx, card_w)
    "table" => draw_table_showcase(gallery_ctx, card_w)
    "dialog" => draw_dialog_showcase(gallery_ctx, cur_w, cur_h)
    "spinner" => draw_spinner_showcase(gallery_ctx)
    "sparkline" => draw_sparkline_showcase(gallery_ctx)
    "segmented_control" => draw_segmented_control_showcase(gallery_ctx)
    "badge" => draw_badge_showcase(gallery_ctx)
    "breadcrumb" => draw_breadcrumb_showcase(gallery_ctx)
    "color_picker" => draw_color_picker_showcase(gallery_ctx)
    "rich_text" => draw_rich_text_showcase(gallery_ctx, card_w)
    _ => {
      let _ = gallery_ctx.label_colored(
        "MoonBit 原生组件: " + comp_id,
        @color.Color::accent_primary(),
      )
      gallery_ctx.spacer(10.0)
      draw_button_showcase(gallery_ctx)
    }
  }

  // 6. End Frame & Output DrawList
  gallery_ctx.end_frame()
}
