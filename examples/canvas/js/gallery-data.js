// Copyright 2026 Ling71671
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Registry of Components with Code & Metadata (100% Native MoonBit Canvas Engine)
const COMPONENTS = {
  button: {
    titleKey: 'comp.button.title',
    signature: "@widgets.button(ui, text, shortcut~, primary~, size~) -> Response",
    code: {
      zh: `///|
pub fn draw_buttons(ui : @core.UIContext, state : AppState) -> Unit {
  // 主要按钮（支持快捷键）
  let res_primary = @widgets.button(ui, "提交", shortcut="⌘S", primary=true)
  if res_primary.clicked {
    state.count += 1
  }

  // 次要按钮
  let res_default = @widgets.button(ui, "重置", shortcut="Esc")
  if res_default.clicked {
    state.count = 0
  }

  // 自定义尺寸
  let res_sized = @widgets.button(ui, "自定义尺寸", size=@math.Vec2::new(140.0, 36.0))
}`,
      en: `///|
pub fn draw_buttons(ui : @core.UIContext, state : AppState) -> Unit {
  // primary button (with a keyboard shortcut)
  let res_primary = @widgets.button(ui, "Submit", shortcut="⌘S", primary=true)
  if res_primary.clicked {
    state.count += 1
  }

  // secondary button
  let res_default = @widgets.button(ui, "Reset", shortcut="Esc")
  if res_default.clicked {
    state.count = 0
  }

  // custom size
  let res_sized = @widgets.button(ui, "Custom size", size=@math.Vec2::new(140.0, 36.0))
}`
    }
  },
  text_edit: {
    titleKey: 'comp.text_edit.title',
    signature: "@widgets.text_edit(ui, text, placeholder~) -> (String, Response)",
    code: {
      zh: `///|
pub fn draw_text_edit(ui : @core.UIContext, state : AppState) -> Unit {
  let (new_text, res) = @widgets.text_edit(ui, 
    state.username,
    placeholder="请输入用户名...",
  )
  if res.changed {
    state.username = new_text
  }
}`,
      en: `///|
pub fn draw_text_edit(ui : @core.UIContext, state : AppState) -> Unit {
  let (new_text, res) = @widgets.text_edit(ui, 
    state.username,
    placeholder="Enter a username...",
  )
  if res.changed {
    state.username = new_text
  }
}`
    }
  },
  code_editor: {
    titleKey: 'comp.code_editor.title',
    signature: "@composite.code_editor(ui, id_salt, text, size?~, show_line_numbers?~, read_only?~) -> (String, Response)",
    code: {
      zh: `///|
pub fn draw_script_workbench(ui : @core.UIContext, state : AppState) -> Unit {
  // 头部状态提示
  ui.label("CAD 脚本控制台 (MoonBit 0.1.0)")

  // 多行带行号代码编辑器
  let (updated_code, resp) = @composite.code_editor(ui, 
    "cad_script",
    state.script_source,
    size=@math.Vec2::new(ui.available_width(), 240.0),
    show_line_numbers=true,
    read_only=false,
  )

  // 状态同步
  if resp.changed() {
    state.script_source = updated_code
    state.dirty = true
  }

  // 编译并执行按钮
  let btn = @widgets.button(ui, "编译并运行 (⌘R)", primary=true)
  if btn.clicked {
    execute_wasm_script(state.script_source)
  }
}`,
      en: `///|
pub fn draw_script_workbench(ui : @core.UIContext, state : AppState) -> Unit {
  // Header status prompt
  ui.label("CAD Script Console (MoonBit 0.1.0)")

  // Multi-line code editor with gutter and line numbers
  let (updated_code, resp) = @composite.code_editor(ui, 
    "cad_script",
    state.script_source,
    size=@math.Vec2::new(ui.available_width(), 240.0),
    show_line_numbers=true,
    read_only=false,
  )

  // State synchronization
  if resp.changed() {
    state.script_source = updated_code
    state.dirty = true
  }

  // Compile and run button
  let btn = @widgets.button(ui, "Compile & Run (⌘R)", primary=true)
  if btn.clicked {
    execute_wasm_script(state.script_source)
  }
}`
    }
  },
  checkbox: {
    titleKey: 'comp.checkbox.title',
    signature: "@widgets.checkbox(ui, label, is_checked) -> (Bool, Response)",
    code: {
      zh: `///|
pub fn draw_checkbox(ui : @core.UIContext, state : AppState) -> Unit {
  let (checked, res) = @widgets.checkbox(ui, "硬件加速", state.gpu)
  if res.changed {
    state.gpu = checked
  }

  let (vsync, res2) = @widgets.checkbox(ui, "垂直同步", state.vsync)
  if res2.changed {
    state.vsync = vsync
  }
}`,
      en: `///|
pub fn draw_checkbox(ui : @core.UIContext, state : AppState) -> Unit {
  let (checked, res) = @widgets.checkbox(ui, "Hardware acceleration", state.gpu)
  if res.changed {
    state.gpu = checked
  }

  let (vsync, res2) = @widgets.checkbox(ui, "Vertical sync", state.vsync)
  if res2.changed {
    state.vsync = vsync
  }
}`
    }
  },
  toggle: {
    titleKey: 'comp.toggle.title',
    signature: "@widgets.toggle(ui, label, is_checked) -> (Bool, Response)",
    code: {
      zh: `///|
pub fn draw_toggles(ui : @core.UIContext, state : AppState) -> Unit {
  let (snap, res1) = @widgets.toggle(ui, "网格对齐", state.grid_snap)
  if res1.changed {
    state.grid_snap = snap
  }

  let (normals, res2) = @widgets.toggle(ui, "显示法线", state.normals)
  if res2.changed {
    state.normals = normals
  }
}`,
      en: `///|
pub fn draw_toggles(ui : @core.UIContext, state : AppState) -> Unit {
  let (snap, res1) = @widgets.toggle(ui, "Snap to grid", state.grid_snap)
  if res1.changed {
    state.grid_snap = snap
  }

  let (normals, res2) = @widgets.toggle(ui, "Show normals", state.normals)
  if res2.changed {
    state.normals = normals
  }
}`
    }
  },
  radio: {
    titleKey: 'comp.radio.title',
    signature: "@widgets.radio(ui, label, is_selected) -> (Bool, Response)",
    code: {
      zh: `///|
pub fn draw_radio(ui : @core.UIContext, state : AppState) -> Unit {
  let (_, r1) = @widgets.radio(ui, "浅色模式", state.theme == 0)
  if r1.clicked { state.theme = 0 }

  let (_, r2) = @widgets.radio(ui, "深色模式", state.theme == 1)
  if r2.clicked { state.theme = 1 }

  let (_, r3) = @widgets.radio(ui, "跟随系统", state.theme == 2)
  if r3.clicked { state.theme = 2 }
}`,
      en: `///|
pub fn draw_radio(ui : @core.UIContext, state : AppState) -> Unit {
  let (_, r1) = @widgets.radio(ui, "Light", state.theme == 0)
  if r1.clicked { state.theme = 0 }

  let (_, r2) = @widgets.radio(ui, "Dark", state.theme == 1)
  if r2.clicked { state.theme = 1 }

  let (_, r3) = @widgets.radio(ui, "Follow the system", state.theme == 2)
  if r3.clicked { state.theme = 2 }
}`
    }
  },
  slider: {
    titleKey: 'comp.slider.title',
    signature: "@widgets.slider(ui, val, min~, max~) / @widgets.slider_int(ui, val, min~, max~) -> (T, Response)",
    code: {
      zh: `///|
pub fn draw_drag_values(ui : @core.UIContext, state : AppState) -> Unit {
  let (x, _) = @widgets.drag_value(ui, "X 坐标", state.pos_x, speed=0.5, min=-1000.0, max=1000.0)
  let (y, _) = @widgets.drag_value(ui, "Y 坐标", state.pos_y, speed=0.5, min=-1000.0, max=1000.0)
  let (scale, _) = @widgets.drag_value(ui, "缩放", state.scale, speed=0.05, min=0.1, max=10.0)
}`,
      en: `///|
pub fn draw_drag_values(ui : @core.UIContext, state : AppState) -> Unit {
  let (x, _) = @widgets.drag_value(ui, "X", state.pos_x, speed=0.5, min=-1000.0, max=1000.0)
  let (y, _) = @widgets.drag_value(ui, "Y", state.pos_y, speed=0.5, min=-1000.0, max=1000.0)
  let (scale, _) = @widgets.drag_value(ui, "Scale", state.scale, speed=0.05, min=0.1, max=10.0)
}`
    }
  },
  drag_value: {
    titleKey: 'comp.drag_value.title',
    signature: "@widgets.drag_value(ui, label, val, speed~, min~, max~) -> (Double, Response)",
    code: {
      zh: `///|
pub fn draw_drag_values(ui : @core.UIContext, state : AppState) -> Unit {
  let (x, _) = @widgets.drag_value(ui, "X 坐标", state.pos_x, speed=0.5, min=-1000.0, max=1000.0)
  let (y, _) = @widgets.drag_value(ui, "Y 坐标", state.pos_y, speed=0.5, min=-1000.0, max=1000.0)
  let (scale, _) = @widgets.drag_value(ui, "缩放", state.scale, speed=0.05, min=0.1, max=10.0)
}`,
      en: `///|
pub fn draw_drag_values(ui : @core.UIContext, state : AppState) -> Unit {
  let (x, _) = @widgets.drag_value(ui, "X", state.pos_x, speed=0.5, min=-1000.0, max=1000.0)
  let (y, _) = @widgets.drag_value(ui, "Y", state.pos_y, speed=0.5, min=-1000.0, max=1000.0)
  let (scale, _) = @widgets.drag_value(ui, "Scale", state.scale, speed=0.05, min=0.1, max=10.0)
}`
    }
  },
  knob: {
    titleKey: 'comp.knob.title',
    signature: "@composite.knob(ui, id, label, value, min_val~, max_val~, step~, default_val~, unit~, radius~, bipolar~) -> (Double, Response)",
    code: {
      zh: `///|
pub fn draw_synth_rack(ui : @core.UIContext, state : SynthState) -> Unit {
  ui.horizontal(fn(row) {
    let (c, _) = row.knob("cutoff", "CUTOFF", state.cutoff, min_val=20.0, max_val=20000.0, step=10.0, default_val=1200.0, unit="Hz")
    let (r, _) = row.knob("res", "RESONANCE", state.resonance, min_val=0.0, max_val=100.0, step=1.0, default_val=25.0, unit="%")
    let (p, _) = row.knob("pan", "PAN", state.pan, min_val=-100.0, max_val=100.0, step=1.0, default_val=0.0, unit="%", bipolar=true)
    let (d, _) = row.knob("drive", "DRIVE", state.drive, min_val=0.0, max_val=24.0, step=0.5, default_val=6.0, unit="dB")
    state.cutoff = c
    state.resonance = r
    state.pan = p
    state.drive = d
  })
}`,
      en: `///|
pub fn draw_synth_rack(ui : @core.UIContext, state : SynthState) -> Unit {
  ui.horizontal(fn(row) {
    let (c, _) = row.knob("cutoff", "CUTOFF", state.cutoff, min_val=20.0, max_val=20000.0, step=10.0, default_val=1200.0, unit="Hz")
    let (r, _) = row.knob("res", "RESONANCE", state.resonance, min_val=0.0, max_val=100.0, step=1.0, default_val=25.0, unit="%")
    let (p, _) = row.knob("pan", "PAN", state.pan, min_val=-100.0, max_val=100.0, step=1.0, default_val=0.0, unit="%", bipolar=true)
    let (d, _) = row.knob("drive", "DRIVE", state.drive, min_val=0.0, max_val=24.0, step=0.5, default_val=6.0, unit="dB")
    state.cutoff = c
    state.resonance = r
    state.pan = p
    state.drive = d
  })
}`
    }
  },
  fader: {
    titleKey: 'comp.fader.title',
    signature: "@composite.fader(ui, id_salt, label, value, min_val~, max_val~, step~, default_val~, unit~, show_ticks~, size~) -> (Double, Response)",
    code: {
      zh: `///|
pub fn draw_faders(ui : @core.UIContext, state : AudioState) -> Unit {
  ui.horizontal(fn(row) {
    let (v, _) = row.fader("master_vol", "MASTER", state.master_vol, min_val=0.0, max_val=1.0, step=0.01, default_val=0.75, unit="%")
    let (g, _) = row.fader("gain", "GAIN", state.gain, min_val=-60.0, max_val=12.0, step=0.5, default_val=0.0, unit="dB")
    let (l, _) = row.fader("left", "LEFT", state.vol_left, min_val=0.0, max_val=1.0, step=0.01, default_val=0.65, unit="%")
    let (r, _) = row.fader("right", "RIGHT", state.vol_right, min_val=0.0, max_val=1.0, step=0.01, default_val=0.65, unit="%")
    state.master_vol = v
    state.gain = g
    state.vol_left = l
    state.vol_right = r
  })
}`,
      en: `///|
pub fn draw_faders(ui : @core.UIContext, state : AudioState) -> Unit {
  ui.horizontal(fn(row) {
    let (v, _) = row.fader("master_vol", "MASTER", state.master_vol, min_val=0.0, max_val=1.0, step=0.01, default_val=0.75, unit="%")
    let (g, _) = row.fader("gain", "GAIN", state.gain, min_val=-60.0, max_val=12.0, step=0.5, default_val=0.0, unit="dB")
    let (l, _) = row.fader("left", "LEFT", state.vol_left, min_val=0.0, max_val=1.0, step=0.01, default_val=0.65, unit="%")
    let (r, _) = row.fader("right", "RIGHT", state.vol_right, min_val=0.0, max_val=1.0, step=0.01, default_val=0.65, unit="%")
    state.master_vol = v
    state.gain = g
    state.vol_left = l
    state.vol_right = r
  })
}`
    }
  },
  combo_box: {
    titleKey: 'comp.combo_box.title',
    signature: "@widgets.combo_box(ui, id, label, selected_idx, options) -> (Int, Response)",
    code: {
      zh: `///|
pub fn draw_combo_box(ui : @core.UIContext, state : AppState) -> Unit {
  let formats = ["PNG", "SVG", "WebP", "PDF"]
  let (selected_idx, res) = @widgets.combo_box(ui, 
    "format",
    "格式",
    state.format_idx,
    formats,
  )
  if res.changed {
    state.format_idx = selected_idx
  }
}`,
      en: `///|
pub fn draw_combo_box(ui : @core.UIContext, state : AppState) -> Unit {
  let formats = ["PNG", "SVG", "WebP", "PDF"]
  let (selected_idx, res) = @widgets.combo_box(ui, 
    "format",
    "Format",
    state.format_idx,
    formats,
  )
  if res.changed {
    state.format_idx = selected_idx
  }
}`
    }
  },
  color_button: {
    titleKey: 'comp.color_button.title',
    signature: "@widgets.color_button(ui, id, color) -> (Bool, Response)",
    code: {
      zh: `///|
pub fn draw_collapsing(ui : @core.UIContext, state : AppState) -> Unit {
  @widgets.collapsing_header(ui, "advanced", "高级设置", default_open=true, fn(ui) {
    let (msaa, _) = @widgets.checkbox(ui, "抗锯齿", state.msaa)
    let (shadows, _) = @widgets.checkbox(ui, "阴影", state.shadows)
  })
}`,
      en: `///|
pub fn draw_collapsing(ui : @core.UIContext, state : AppState) -> Unit {
  @widgets.collapsing_header(ui, "advanced", "Advanced", default_open=true, fn(ui) {
    let (msaa, _) = @widgets.checkbox(ui, "Antialiasing", state.msaa)
    let (shadows, _) = @widgets.checkbox(ui, "Shadows", state.shadows)
  })
}`
    }
  },
  progress_bar: {
    titleKey: 'comp.progress_bar.title',
    signature: "@widgets.progress_bar(ui, fraction, text~) -> Response",
    code: {
      zh: `///|
pub fn draw_collapsing(ui : @core.UIContext, state : AppState) -> Unit {
  @widgets.collapsing_header(ui, "advanced", "高级设置", default_open=true, fn(ui) {
    let (msaa, _) = @widgets.checkbox(ui, "抗锯齿", state.msaa)
    let (shadows, _) = @widgets.checkbox(ui, "阴影", state.shadows)
  })
}`,
      en: `///|
pub fn draw_collapsing(ui : @core.UIContext, state : AppState) -> Unit {
  @widgets.collapsing_header(ui, "advanced", "Advanced", default_open=true, fn(ui) {
    let (msaa, _) = @widgets.checkbox(ui, "Antialiasing", state.msaa)
    let (shadows, _) = @widgets.checkbox(ui, "Shadows", state.shadows)
  })
}`
    }
  },
  collapsing_header: {
    titleKey: 'comp.collapsing_header.title',
    signature: "@widgets.collapsing_header(ui, id, title, default_open~, content)",
    code: {
      zh: `///|
pub fn draw_collapsing(ui : @core.UIContext, state : AppState) -> Unit {
  @widgets.collapsing_header(ui, "advanced", "高级设置", default_open=true, fn(ui) {
    let (msaa, _) = @widgets.checkbox(ui, "抗锯齿", state.msaa)
    let (shadows, _) = @widgets.checkbox(ui, "阴影", state.shadows)
  })
}`,
      en: `///|
pub fn draw_collapsing(ui : @core.UIContext, state : AppState) -> Unit {
  @widgets.collapsing_header(ui, "advanced", "Advanced", default_open=true, fn(ui) {
    let (msaa, _) = @widgets.checkbox(ui, "Antialiasing", state.msaa)
    let (shadows, _) = @widgets.checkbox(ui, "Shadows", state.shadows)
  })
}`
    }
  },
  tree_view: {
    titleKey: 'comp.tree_view.title',
    signature: "@composite.tree_view(ui, id_salt, nodes, selected_id~, expanded_ids~, indent_step~, item_height~, size?) -> TreeViewResponse",
    code: {
      zh: `///|
pub fn draw_cad_outliner(ui : @core.UIContext, state : AppState) -> Unit {
  // 构建三维 CAD 场景资产层级树
  let nodes = [
    @composite.TreeNode::new("scene_root", "场景装配体 (Root Scene)", icon="[S]", children=[
      @composite.TreeNode::new("cam_grp", "摄影机组 (Cameras)", icon="[G]", children=[
        @composite.TreeNode::leaf("main_cam", "透视主摄影机", icon="[C]"),
        @composite.TreeNode::leaf("ortho_top", "正交顶视图", icon="[C]"),
      ]),
      @composite.TreeNode::new("geo_grp", "几何体实体 (Geometry)", icon="[G]", children=[
        @composite.TreeNode::leaf("bezier_curve", "三次贝塞尔曲线", icon="[M]"),
        @composite.TreeNode::new("robot_arm", "机械臂总成", icon="[G]", children=[
          @composite.TreeNode::leaf("joint_1", "基座旋转关节", icon="[M]"),
          @composite.TreeNode::leaf("gripper", "气动末端执行器", icon="[M]"),
        ]),
        @composite.TreeNode::leaf("mesh_torus", "环面图元", icon="[M]"),
      ]),
      @composite.TreeNode::new("mat_grp", "材质与着色器", icon="[G]", children=[
        @composite.TreeNode::leaf("pbr_metal", "PBR 导电金属材质", icon="[T]"),
        @composite.TreeNode::leaf("glass_mat", "次表面透光玻璃", icon="[T]"),
      ]),
      @composite.TreeNode::leaf("env_light", "HDRI 环境光照", icon="[L]"),
    ]),
  ]

  // 即时模式分层树渲染：支持记忆展开、发丝引导线与键盘上下/左右极速导航
  let resp = @composite.tree_view(ui, 
    "cad_outliner",
    nodes,
    selected_id=state.selected_node,
    expanded_ids=state.expanded_nodes,
  )

  state.selected_node = resp.selected_id
  state.expanded_nodes = resp.expanded_ids

  if resp.clicked_id is Some(node_id) {
    println("选中 CAD 节点: \{node_id}")
  }
}`,
      en: `///|
pub fn draw_cad_outliner(ui : @core.UIContext, state : AppState) -> Unit {
  // Construct 3D CAD hierarchy tree
  let nodes = [
    @composite.TreeNode::new("scene_root", "Root Assembly (Scene)", icon="[S]", children=[
      @composite.TreeNode::new("cam_grp", "Cameras", icon="[G]", children=[
        @composite.TreeNode::leaf("main_cam", "Perspective Camera", icon="[C]"),
        @composite.TreeNode::leaf("ortho_top", "Orthographic Top", icon="[C]"),
      ]),
      @composite.TreeNode::new("geo_grp", "Geometry Entities", icon="[G]", children=[
        @composite.TreeNode::leaf("bezier_curve", "Cubic Bezier Spline", icon="[M]"),
        @composite.TreeNode::new("robot_arm", "Robot Arm Assembly", icon="[G]", children=[
          @composite.TreeNode::leaf("joint_1", "Rotary Base Joint", icon="[M]"),
          @composite.TreeNode::leaf("gripper", "Pneumatic Gripper", icon="[M]"),
        ]),
        @composite.TreeNode::leaf("mesh_torus", "Torus Topology", icon="[M]"),
      ]),
      @composite.TreeNode::new("mat_grp", "Materials & Shaders", icon="[G]", children=[
        @composite.TreeNode::leaf("pbr_metal", "PBR Metallic Material", icon="[T]"),
        @composite.TreeNode::leaf("glass_mat", "Subsurface Glass", icon="[T]"),
      ]),
      @composite.TreeNode::leaf("env_light", "HDRI Environment Light", icon="[L]"),
    ]),
  ]

  // Immediate-mode TreeView: expand memory, guide lines, and full keyboard navigation
  let resp = @composite.tree_view(ui, 
    "cad_outliner",
    nodes,
    selected_id=state.selected_node,
    expanded_ids=state.expanded_nodes,
  )

  state.selected_node = resp.selected_id
  state.expanded_nodes = resp.expanded_ids

  if resp.clicked_id is Some(node_id) {
    println("Selected CAD node: \{node_id}")
  }
}`
    }
  },
  tooltip: {
    titleKey: 'comp.tooltip.title',
    signature: "@widgets.tooltip(ui, text)",
    code: {
      zh: `///|
pub fn draw_tooltips(ui : @core.UIContext, state : AppState) -> Unit {
  let res_export = @widgets.button(ui, "导出")
  if res_export.hovered {
    @widgets.tooltip(ui, "导出 SVG 矢量图")
  }

  let res_mesh = @widgets.button(ui, "网格")
  if res_mesh.hovered {
    @widgets.tooltip(ui, "重新计算三角网格")
  }
}`,
      en: `///|
pub fn draw_tooltips(ui : @core.UIContext, state : AppState) -> Unit {
  let res_export = @widgets.button(ui, "Export")
  if res_export.hovered {
    @widgets.tooltip(ui, "Export a vector SVG")
  }

  let res_mesh = @widgets.button(ui, "Mesh")
  if res_mesh.hovered {
    @widgets.tooltip(ui, "Recompute the triangle mesh")
  }
}`
    }
  },
  tab_bar: {
    titleKey: 'comp.tab_bar.title',
    signature: "@widgets.tab_bar(ui, id, tabs, selected_idx) -> (Int, Response)",
    code: {
      zh: `///|
pub fn draw_tabs(ui : @core.UIContext, state : AppState) -> Unit {
  let tabs = ["属性", "视口", "图层", "输出"]
  let (active_tab, res) = @widgets.tab_bar(ui, "tabs", tabs, state.tab_idx)
  if res.changed {
    state.tab_idx = active_tab
  }
}`,
      en: `///|
pub fn draw_tabs(ui : @core.UIContext, state : AppState) -> Unit {
  let tabs = ["Properties", "Viewport", "Layers", "Output"]
  let (active_tab, res) = @widgets.tab_bar(ui, "tabs", tabs, state.tab_idx)
  if res.changed {
    state.tab_idx = active_tab
  }
}`
    }
  },
  menu_bar: {
    titleKey: 'comp.menu_bar.title',
    signature: "@composite.menu_bar(ui, height~, content) -> Response",
    code: {
      zh: `///|
pub fn draw_app_menu(ui : @core.UIContext, state : AppState) -> Unit {
  @composite.menu_bar(ui, fn(ui) {
    @composite.menu(ui, "文件", fn(ui) {
      if @composite.menu_item(ui, "新建画板", shortcut="⌘N").clicked {
        state.new_canvas()
      }
      if @composite.menu_item(ui, "打开工程...", shortcut="⌘O").clicked {
        state.open_project()
      }
      @composite.menu_separator(ui, )
      if @composite.menu_item(ui, "保存设计", shortcut="⌘S").clicked {
        state.save_design()
      }
      if @composite.menu_item(ui, "导出 SVG...", shortcut="⇧⌘E").clicked {
        state.export_svg()
      }
    })
    @composite.menu(ui, "编辑", fn(ui) {
      if @composite.menu_item(ui, "撤销", shortcut="⌘Z").clicked {
        state.undo()
      }
      if @composite.menu_item(ui, "重做", shortcut="⇧⌘Z").clicked {
        state.redo()
      }
      @composite.menu_separator(ui, )
      if @composite.menu_item(ui, "复制选中", shortcut="⌘C").clicked {
        state.copy()
      }
    })
    @composite.menu(ui, "视图", fn(ui) {
      if @composite.menu_item(ui, "重置视口", shortcut="⌘0").clicked {
        state.reset_viewport()
      }
      if @composite.menu_item(ui, "适应全屏", shortcut="⌘1").clicked {
        state.fit_all()
      }
    })
    @composite.menu(ui, "帮助", fn(ui) {
      if @composite.menu_item(ui, "快捷键速查", shortcut="?").clicked {
        state.show_shortcuts()
      }
      if @composite.menu_item(ui, "关于 moon-egui").clicked {
        state.show_about()
      }
    })
  })
}`,
      en: `///|
pub fn draw_app_menu(ui : @core.UIContext, state : AppState) -> Unit {
  @composite.menu_bar(ui, fn(ui) {
    @composite.menu(ui, "File", fn(ui) {
      if @composite.menu_item(ui, "New Canvas", shortcut="⌘N").clicked {
        state.new_canvas()
      }
      if @composite.menu_item(ui, "Open Project...", shortcut="⌘O").clicked {
        state.open_project()
      }
      @composite.menu_separator(ui, )
      if @composite.menu_item(ui, "Save Design", shortcut="⌘S").clicked {
        state.save_design()
      }
      if @composite.menu_item(ui, "Export SVG...", shortcut="⇧⌘E").clicked {
        state.export_svg()
      }
    })
    @composite.menu(ui, "Edit", fn(ui) {
      if @composite.menu_item(ui, "Undo", shortcut="⌘Z").clicked {
        state.undo()
      }
      if @composite.menu_item(ui, "Redo", shortcut="⇧⌘Z").clicked {
        state.redo()
      }
      @composite.menu_separator(ui, )
      if @composite.menu_item(ui, "Copy Selection", shortcut="⌘C").clicked {
        state.copy()
      }
    })
    @composite.menu(ui, "View", fn(ui) {
      if @composite.menu_item(ui, "Reset Viewport", shortcut="⌘0").clicked {
        state.reset_viewport()
      }
      if @composite.menu_item(ui, "Fit to Screen", shortcut="⌘1").clicked {
        state.fit_all()
      }
    })
    @composite.menu(ui, "Help", fn(ui) {
      if @composite.menu_item(ui, "Keyboard Shortcuts", shortcut="?").clicked {
        state.show_shortcuts()
      }
      if @composite.menu_item(ui, "About moon-egui").clicked {
        state.show_about()
      }
    })
  })
}`
    }
  },
  scroll_area: {
    titleKey: 'comp.scroll_area.title',
    signature: "@widgets.scroll_area(ui, id, width~, height~, content)",
    code: {
      zh: `///|
pub fn draw_scroll_area(ui : @core.UIContext, state : AppState) -> Unit {
  @widgets.scroll_area(ui, "logs", width=360.0, height=200.0, fn(ui) {
    for i = 0; i < 30; i = i + 1 {
      ui.label("日志项 [\{i}]")
    }
  })
}`,
      en: `///|
pub fn draw_scroll_area(ui : @core.UIContext, state : AppState) -> Unit {
  @widgets.scroll_area(ui, "logs", width=360.0, height=200.0, fn(ui) {
    for i = 0; i < 30; i = i + 1 {
      ui.label("Log entry [\{i}]")
    }
  })
}`
    }
  },
  window: {
    titleKey: 'comp.window.title',
    signature: "@widgets.window(ui, id, title, content)",
    code: {
      zh: `///|
pub fn draw_window(ui : @core.UIContext, state : AppState) -> Unit {
  @widgets.window(ui, "inspector", "属性检查器", fn(ui) {
    ui.label("当前选中: 样条曲线")
    let (w, _) = @widgets.slider(ui, state.curve_width, min=1.0, max=10.0)
    let (closed, _) = @widgets.checkbox(ui, "闭合路径", state.curve_closed)
  })
}`,
      en: `///|
pub fn draw_window(ui : @core.UIContext, state : AppState) -> Unit {
  @widgets.window(ui, "inspector", "Inspector", fn(ui) {
    ui.label("Selected: spline curve")
    let (w, _) = @widgets.slider(ui, state.curve_width, min=1.0, max=10.0)
    let (closed, _) = @widgets.checkbox(ui, "Closed path", state.curve_closed)
  })
}`
    }
  },
  command_palette: {
    titleKey: 'comp.command_palette.title',
    signature: "@composite.command_palette(ui, open, query, commands, selected_index~) -> CommandPaletteResponse",
    code: {
      zh: `///|
pub fn draw_command_palette(ui : @core.UIContext, state : AppState) -> Unit {
  // 定义可用命令集合
  let commands = [
    @composite.CommandItem::new("new_file", "新建画板文件", category="文件", shortcut="⌘N"),
    @composite.CommandItem::new("save_file", "保存当前工程", category="文件", shortcut="⌘S"),
    @composite.CommandItem::new("export_svg", "导出矢量图元", category="文件", shortcut="⇧⌘E"),
    @composite.CommandItem::new("zoom_fit", "缩放至全屏画板", category="视图", shortcut="⌘0"),
    @composite.CommandItem::new("toggle_fps", "切换微秒级帧监视器", category="视图", shortcut="⌥F"),
    @composite.CommandItem::new("moon_fmt", "格式化 MoonBit 源码", category="工具", shortcut="⌥⇧F"),
  ]

  // 即时模式调用全局命令面板
  let res = @composite.command_palette(ui, 
    state.palette_open,
    state.palette_query,
    commands,
    selected_index=state.palette_index,
  )

  // 状态同步
  state.palette_open = res.open
  state.palette_query = res.query
  state.palette_index = res.selected_index

  // 处理选中命令
  if res.selected_id is Some(cmd_id) {
    execute_command(state, cmd_id)
  }
}`,
      en: `///|
pub fn draw_command_palette(ui : @core.UIContext, state : AppState) -> Unit {
  // Define available command catalog
  let commands = [
    @composite.CommandItem::new("new_file", "New Canvas File", category="File", shortcut="⌘N"),
    @composite.CommandItem::new("save_file", "Save Project", category="File", shortcut="⌘S"),
    @composite.CommandItem::new("export_svg", "Export SVG Vectors", category="File", shortcut="⇧⌘E"),
    @composite.CommandItem::new("zoom_fit", "Fit View to Canvas", category="View", shortcut="⌘0"),
    @composite.CommandItem::new("toggle_fps", "Toggle Frame Monitor", category="View", shortcut="⌥F"),
    @composite.CommandItem::new("moon_fmt", "Format MoonBit Code", category="Tools", shortcut="⌥⇧F"),
  ]

  // Immediate mode invocation
  let res = @composite.command_palette(ui, 
    state.palette_open,
    state.palette_query,
    commands,
    selected_index=state.palette_index,
  )

  // State synchronization
  state.palette_open = res.open
  state.palette_query = res.query
  state.palette_index = res.selected_index

  // Dispatch executed command
  if res.selected_id is Some(cmd_id) {
    execute_command(state, cmd_id)
  }
}`
    }
  },
  context_menu: {
    titleKey: 'comp.context_menu.title',
    signature: "@composite.context_menu_items(ui, id_salt, open, pos, items, menu_width?~) -> ContextMenuResponse",
    code: {
      zh: `///|
pub fn draw_cad_nodes(ui : @core.UIContext, state : AppState) -> Unit {
  // 渲染画板节点
  let node_resp = @widgets.window(ui, "变换矩阵", @math.Vec2::new(120.0, 80.0), @math.Vec2::new(200.0, 120.0), fn(w) {
    w.label("平移: (10.0, 20.0)")
    w.label("缩放: 1.0x")
  })

  // 右键命中检测
  if node_resp.clicked && ui.input().mouse_down() {
    state.menu_open = true
    state.menu_pos = ui.input().mouse_pos()
  }

  // 定义上下文菜单项
  let items = [
    @composite.ContextMenuItem::new("copy", "复制节点", shortcut="⌘C"),
    @composite.ContextMenuItem::new("clone", "克隆分支", shortcut="⌘D"),
    @composite.ContextMenuItem::separator(),
    @composite.ContextMenuItem::new("reset", "重置参数", shortcut="⌥R"),
    @composite.ContextMenuItem::new("delete", "删除图元", shortcut="⌫"),
  ]

  // 调用自适应边界翻转上下文菜单
  let res = @composite.context_menu_items(ui, "node_ctx", state.menu_open, state.menu_pos, items)
  state.menu_open = res.open

  if res.selected_id is Some(action) {
    handle_node_action(state, action)
  }
}`,
      en: `///|
pub fn draw_cad_nodes(ui : @core.UIContext, state : AppState) -> Unit {
  // Render canvas node
  let node_resp = @widgets.window(ui, "Matrix Transform", @math.Vec2::new(120.0, 80.0), @math.Vec2::new(200.0, 120.0), fn(w) {
    w.label("Translation: (10.0, 20.0)")
    w.label("Scale: 1.0x")
  })

  // Right click trigger
  if node_resp.clicked && ui.input().mouse_down() {
    state.menu_open = true
    state.menu_pos = ui.input().mouse_pos()
  }

  // Context menu item catalog
  let items = [
    @composite.ContextMenuItem::new("copy", "Copy Node", shortcut="⌘C"),
    @composite.ContextMenuItem::new("clone", "Duplicate", shortcut="⌘D"),
    @composite.ContextMenuItem::separator(),
    @composite.ContextMenuItem::new("reset", "Reset Parameters", shortcut="⌥R"),
    @composite.ContextMenuItem::new("delete", "Delete Element", shortcut="⌫"),
  ]

  // Context menu with automatic collision boundary flipping
  let res = @composite.context_menu_items(ui, "node_ctx", state.menu_open, state.menu_pos, items)
  state.menu_open = res.open

  if res.selected_id is Some(action) {
    handle_node_action(state, action)
  }
}`
    }
  },
  toast: {
    titleKey: 'comp.toast.title',
    signature: "@widgets.toast_stack(ui, toasts, anchor?~, viewport_size?~) -> ToastResponse",
    code: {
      zh: `///|
pub fn draw_notifications(ui : @core.UIContext, state : AppState) -> Unit {
  // 业务事件触发通知入栈
  if state.need_notify {
    state.toasts.push(@widgets.Toast::success("保存完成", message="设计已同步至云端工程"))
    state.need_notify = false
  }

  // 渲染全局浮动通知栈，支持时间衰减与点击关闭
  let resp = @widgets.toast_stack(ui, 
    state.toasts,
    anchor=@widgets.ToastAnchor::BottomRight,
  )

  // 更新活跃通知列表
  state.toasts = resp.active_toasts

  if resp.dismissed_id is Some(id) {
    println("通知已手动关闭: \{id}")
  }
}`,
      en: `///|
pub fn draw_notifications(ui : @core.UIContext, state : AppState) -> Unit {
  // Trigger notification when event occurs
  if state.need_notify {
    state.toasts.push(@widgets.Toast::success("Save Complete", message="Design synced to cloud repository"))
    state.need_notify = false
  }

  // Render floating toast stack with time decay and dismiss handling
  let resp = @widgets.toast_stack(ui, 
    state.toasts,
    anchor=@widgets.ToastAnchor::BottomRight,
  )

  // Update active toasts
  state.toasts = resp.active_toasts

  if resp.dismissed_id is Some(id) {
    println("Toast dismissed manually: \{id}")
  }
}`
    }
  },
  splitter: {
    titleKey: 'comp.splitter.title',
    signature: "@widgets.split_horizontal(ui, id, ratio, size, left, right, min_ratio?~, max_ratio?~, min_px?~) -> Double",
    code: {
      zh: `///|
pub fn draw_splitters(ui : @core.UIContext, state : AppState) -> Unit {
  // 水平双栏可拖拽分栏容器，具有物理防挤压底线保护与视口裁剪
  let new_ratio = @widgets.split_horizontal(ui, 
    "main_split",
    state.ratio,
    @math.Vec2::new(600.0, 300.0),
    fn(pane_ui, rect) {
      pane_ui.label("左侧工作区")
    },
    fn(pane_ui, rect) {
      pane_ui.label("右侧属性区")
    },
  )
  state.ratio = new_ratio
}`,
      en: `///|
pub fn draw_splitters(ui : @core.UIContext, state : AppState) -> Unit {
  // Horizontal resizable split panes with physical pixel clamping and viewport clipping
  let new_ratio = @widgets.split_horizontal(ui, 
    "main_split",
    state.ratio,
    @math.Vec2::new(600.0, 300.0),
    fn(pane_ui, rect) {
      pane_ui.label("Left Workspace")
    },
    fn(pane_ui, rect) {
      pane_ui.label("Right Inspector")
    },
  )
  state.ratio = new_ratio
}`
    }
  },
  dock_area: {
    titleKey: 'comp.dock_area.title',
    signature: "@composite.dock_area(ui, id, size, tree, render_tab) -> DockResponse",
    code: {
      zh: `///|
pub fn draw_workbench(ui : @core.UIContext, state : AppState) -> Unit {
  // 构建分栏工作台停靠树：左侧资源管理器，右侧视口与运行日志
  let tree = @composite.DockTree::split(
    @composite.DockSplitDirection::Horizontal,
    0.3,
    @composite.DockTree::leaf([@composite.DockTab::new("explorer", "资源管理器")]),
    @composite.DockTree::split(
      @composite.DockSplitDirection::Vertical,
      0.65,
      @composite.DockTree::leaf([@composite.DockTab::new("canvas", "CAD 视口")]),
      @composite.DockTree::leaf([@composite.DockTab::new("console", "运行日志")]),
    ),
  )

  // 渲染多视窗工作台，每个面板自带 Scissor 剪裁与标签页切换
  let resp = @composite.dock_area(ui, 
    "workbench_dock",
    @math.Vec2::new(640.0, 320.0),
    tree,
    fn(pane_ui, tab_id, rect) {
      pane_ui.label("当前激活工作面板: \{tab_id}")
    },
  )
}`,
      en: `///|
pub fn draw_workbench(ui : @core.UIContext, state : AppState) -> Unit {
  // Construct hierarchical multi-window docking tree
  let tree = @composite.DockTree::split(
    @composite.DockSplitDirection::Horizontal,
    0.3,
    @composite.DockTree::leaf([@composite.DockTab::new("explorer", "Explorer")]),
    @composite.DockTree::split(
      @composite.DockSplitDirection::Vertical,
      0.65,
      @composite.DockTree::leaf([@composite.DockTab::new("canvas", "CAD Viewport")]),
      @composite.DockTree::leaf([@composite.DockTab::new("console", "Console Logs")]),
    ),
  )

  // Render multi-pane dock area with tab bars, dragging splitters, and Scissor clipping
  let resp = @composite.dock_area(ui, 
    "workbench_dock",
    @math.Vec2::new(640.0, 320.0),
    tree,
    fn(pane_ui, tab_id, rect) {
      pane_ui.label("Active Dock Panel: \{tab_id}")
    },
  )
}`
    }
  },
  table: {
    titleKey: 'comp.table.title',
    signature: "@composite.table(ui, id, size, columns, row_count, render_cell, ...) -> TableResponse",
    code: {
      zh: `///|
pub fn draw_data_table(ui : @core.UIContext, state : AppState) -> Unit {
  let cols = [
    @composite.TableColumn::new("id", "ID", 60.0),
    @composite.TableColumn::new("name", "用户名", 140.0),
    @composite.TableColumn::new("role", "权限角色", 100.0),
  ]

  // 10,000 行虚拟滚动表格，仅按需计算视口行
  let resp = @composite.table(ui, 
    "user_table",
    @math.Vec2::new(500.0, 260.0),
    cols,
    10000,
    fn(cell_ui, row, col, rect) {
      cell_ui.label("R\{row} C\{col}")
    },
    selected_row=state.selected_row,
  )
  if resp.clicked_row is Some(r) {
    state.selected_row = r
  }
}`,
      en: `///|
pub fn draw_data_table(ui : @core.UIContext, state : AppState) -> Unit {
  let cols = [
    @composite.TableColumn::new("id", "ID", 60.0),
    @composite.TableColumn::new("name", "Username", 140.0),
    @composite.TableColumn::new("role", "Role", 100.0),
  ]

  // 10,000 items virtual data table with on-demand viewport clipping
  let resp = @composite.table(ui, 
    "user_table",
    @math.Vec2::new(500.0, 260.0),
    cols,
    10000,
    fn(cell_ui, row, col, rect) {
      cell_ui.label("R\{row} C\{col}")
    },
    selected_row=state.selected_row,
  )
  if resp.clicked_row is Some(r) {
    state.selected_row = r
  }
}`
    }
  },
  dialog: {
    titleKey: 'comp.dialog.title',
    signature: "@widgets.dialog(ui, id, title, message, kind?~, confirm_label?~, cancel_label?~) -> DialogResult",
    code: {
      zh: `///|
pub fn draw_modal(ui : @core.UIContext, state : AppState) -> Unit {
  if state.show_confirm {
    // 模态对话框：全屏暗色遮罩、物理事件阻断、Esc/Enter 键盘快速操作
    let res = @widgets.dialog(ui, 
      "delete_confirm",
      "确认删除文件？",
      "该操作不可撤销，文件将从云端永久移除。",
      kind=@widgets.DialogKind::Danger,
    )
    match res {
      Confirmed => { state.show_confirm = false; delete_target(state) }
      Cancelled => { state.show_confirm = false }
      Open => ()
    }
  }
}`,
      en: `///|
pub fn draw_modal(ui : @core.UIContext, state : AppState) -> Unit {
  if state.show_confirm {
    // Modal dialog: backdrop scrim, interaction blocking, Esc/Enter shortcuts
    let res = @widgets.dialog(ui, 
      "delete_confirm",
      "Delete file?",
      "This action cannot be undone. The file will be permanently removed.",
      kind=@widgets.DialogKind::Danger,
    )
    match res {
      Confirmed => { state.show_confirm = false; delete_target(state) }
      Cancelled => { state.show_confirm = false }
      Open => ()
    }
  }
}`
    }
  },
  spinner: {
    titleKey: 'comp.spinner.title',
    signature: "@widgets.spinner(ui, size?~, color?~, stroke_width?~) -> Response",
    code: {
      zh: `///|
pub fn draw_spinners(ui : @core.UIContext) -> Unit {
  // 纯时间驱动的平滑非对称呼吸伸缩公转圆环
  let _ = @widgets.spinner(ui, size=24.0)

  // 附带说明文案的水平内联加载指示器
  let _ = @widgets.spinner_with_label(ui, "正在同步远程数据...", size=18.0)
}`,
      en: `///|
pub fn draw_spinners(ui : @core.UIContext) -> Unit {
  // Time-driven smooth non-linear breathing sweep loading animation
  let _ = @widgets.spinner(ui, size=24.0)

  // Inline spinner with adjacent label text
  let _ = @widgets.spinner_with_label(ui, "Syncing remote repository...", size=18.0)
}`
    }
  },
  sparkline: {
    titleKey: 'comp.sparkline.title',
    signature: "@composite.sparkline(ui, id, values, size?~, color?~, fill?~, show_hover?~) -> (Int?, Response)",
    code: {
      zh: `///|
pub fn draw_sparklines(ui : @core.UIContext, state : AppState) -> Unit {
  // 实时微型折线图：极值归一化映射、零差值防崩溃、鼠标十字吸附
  let (hovered, resp) = @composite.sparkline(ui, 
    "cpu_monitor",
    state.cpu_history,
    size=@math.Vec2::new(160.0, 42.0),
    fill=true,
  )
  if hovered is Some(idx) {
    println("当前准心节点: \{idx}")
  }
}`,
      en: `///|
pub fn draw_sparklines(ui : @core.UIContext, state : AppState) -> Unit {
  // Real-time micro sparkline: normalized scaling, flat protection, hover snapping
  let (hovered, resp) = @composite.sparkline(ui, 
    "cpu_monitor",
    state.cpu_history,
    size=@math.Vec2::new(160.0, 42.0),
    fill=true,
  )
  if hovered is Some(idx) {
    println("Hovered node index: \{idx}")
  }
}`
    }
  },
  segmented_control: {
    titleKey: 'comp.segmented_control.title',
    signature: "@widgets.segmented_control(ui, id, options, selected_index, height?~, width?~) -> (Int, Response)",
    code: {
      zh: `///|
pub fn draw_segments(ui : @core.UIContext, state : AppState) -> Unit {
  let views = ["日", "周", "月", "年"]
  // 凹槽底座 + 悬浮白瓷药丸，支持键盘左右方向键轮转
  let (new_sel, resp) = @widgets.segmented_control(ui, 
    "time_range",
    views,
    state.selected_view,
    width=280.0,
  )
  state.selected_view = new_sel
}`,
      en: `///|
pub fn draw_segments(ui : @core.UIContext, state : AppState) -> Unit {
  let views = ["Day", "Week", "Month", "Year"]
  // Recessed track with floating porcelain pill and arrow key rotation
  let (new_sel, resp) = @widgets.segmented_control(ui, 
    "time_range",
    views,
    state.selected_view,
    width=280.0,
  )
  state.selected_view = new_sel
}`
    }
  },
  badge: {
    titleKey: 'comp.badge.title',
    signature: "@widgets.badge(ui, text, kind?~, dot?~, pill?~) -> Response",
    code: {
      zh: `///|
pub fn draw_badges(ui : @core.UIContext, state : AppState) -> Unit {
  // 5 类低饱和语义状态胶囊，前置呼吸圆点
  let _ = @widgets.badge(ui, "活跃", kind=@widgets.BadgeKind::Success, dot=true, pill=true)

  // 支持关闭移除的交互标签
  let (closed, _) = @widgets.tag(ui, "pkg_tag", "Wasm 32", closable=true)
  if closed {
    state.tag_visible = false
  }
}`,
      en: `///|
pub fn draw_badges(ui : @core.UIContext, state : AppState) -> Unit {
  // 5 soft semantic palettes with status dot and pill radius
  let _ = @widgets.badge(ui, "Active", kind=@widgets.BadgeKind::Success, dot=true, pill=true)

  // Interactive tag chip with click-to-close button
  let (closed, _) = @widgets.tag(ui, "pkg_tag", "Wasm 32", closable=true)
  if closed {
    state.tag_visible = false
  }
}`
    }
  },
  breadcrumb: {
    titleKey: 'comp.breadcrumb.title',
    signature: "@widgets.breadcrumb(ui, id, items, separator?~, max_visible?~) -> (Int?, Response)",
    code: {
      zh: `///|
pub fn draw_breadcrumbs(ui : @core.UIContext, state : AppState) -> Unit {
  let path = ["工作区", "moon-egui", "src", "core", "table.mbt"]
  // 单行层级路径，悬停底色高光，超长路径自动折叠为 "..."
  let (clicked, resp) = @widgets.breadcrumb(ui, "nav_bc", path, separator="/")
  if clicked is Some(idx) {
    navigate_to(path[idx])
  }
}`,
      en: `///|
pub fn draw_breadcrumbs(ui : @core.UIContext, state : AppState) -> Unit {
  let path = ["Workspace", "moon-egui", "src", "core", "table.mbt"]
  // Horizontal path strip with ancestor hover highlight and middle ellipsis folding
  let (clicked, resp) = @widgets.breadcrumb(ui, "nav_bc", path, separator="/")
  if clicked is Some(idx) {
    navigate_to(path[idx])
  }
}`
    }
  },
  color_picker: {
    titleKey: 'comp.color_picker.title',
    signature: "@composite.color_picker(ui, id, color, show_alpha?~) -> (Color, Response)",
    code: {
      zh: `///|
pub fn draw_color_picker(ui : @core.UIContext, state : AppState) -> Unit {
  // 2D HSV 饱和度-明度渐变盘、彩虹色相槽、Alpha 棋盘格与双环取色游标
  let (new_color, resp) = @composite.color_picker(ui, 
    "main_picker",
    state.current_color,
    show_alpha=true,
  )
  state.current_color = new_color

  // 弹窗按钮模式
  let (btn_color, _) = @composite.color_picker_button(ui, "picker_btn", state.current_color)
}`,
      en: `///|
pub fn draw_color_picker(ui : @core.UIContext, state : AppState) -> Unit {
  // 2D HSV Sat/Val square, hue rainbow slider, alpha checkerboard, and dual-ring grip
  let (new_color, resp) = @composite.color_picker(ui, 
    "main_picker",
    state.current_color,
    show_alpha=true,
  )
  state.current_color = new_color

  // Popup button variant
  let (btn_color, _) = @composite.color_picker_button(ui, "picker_btn", state.current_color)
}`
    }
  },
  rich_text: {
    titleKey: 'comp.rich_text.title',
    signature: "@composite.rich_text(ui, id, spans, wrap_width?~) -> RichTextResponse",
    code: {
      zh: `///|
pub fn draw_rich_text(ui : @core.UIContext) -> Unit {
  let spans = [
    @composite.TextSpan::normal("当前渲染管线为"),
    @composite.TextSpan::code("moon-egui"),
    @composite.TextSpan::bold("即时模式引擎。"),
    @composite.TextSpan::normal("点击"),
    @composite.TextSpan::link("官方网站", "https://moonbitlang.com"),
    @composite.TextSpan::normal("查阅更多细节。"),
  ]

  // 流式自适应折行混排富文本
  let resp = @composite.rich_text(ui, "article_rt", spans)
  if resp.clicked_url is Some(url) {
    println("点击超链接: \{url}")
  }
}`,
      en: `///|
pub fn draw_rich_text(ui : @core.UIContext) -> Unit {
  let spans = [
    @composite.TextSpan::normal("Running on"),
    @composite.TextSpan::code("moon-egui"),
    @composite.TextSpan::bold("Immediate-Mode engine."),
    @composite.TextSpan::normal("Visit"),
    @composite.TextSpan::link("Official Website", "https://moonbitlang.com"),
    @composite.TextSpan::normal("for more details."),
  ]

  // Inline word-wrapped rich text with inline code blocks and hyperlinks
  let resp = @composite.rich_text(ui, "article_rt", spans)
  if resp.clicked_url is Some(url) {
    println("Clicked URL: \{url}")
  }
}`
    }
  },
  },
};
