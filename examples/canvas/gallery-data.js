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
    signature: "ui.button(text, shortcut~, primary~, size~) -> Response",
    code: {
      zh: `///|
pub fn draw_buttons(ui : @core.UIContext, state : AppState) -> Unit {
  // 主要按钮（支持快捷键）
  let res_primary = ui.button("提交", shortcut="⌘S", primary=true)
  if res_primary.clicked {
    state.count += 1
  }

  // 次要按钮
  let res_default = ui.button("重置", shortcut="Esc")
  if res_default.clicked {
    state.count = 0
  }

  // 自定义尺寸
  let res_sized = ui.button("自定义尺寸", size=Some(@math.Vec2::new(140.0, 36.0)))
}`,
      en: `///|
pub fn draw_buttons(ui : @core.UIContext, state : AppState) -> Unit {
  // primary button (with a keyboard shortcut)
  let res_primary = ui.button("Submit", shortcut="⌘S", primary=true)
  if res_primary.clicked {
    state.count += 1
  }

  // secondary button
  let res_default = ui.button("Reset", shortcut="Esc")
  if res_default.clicked {
    state.count = 0
  }

  // custom size
  let res_sized = ui.button("Custom size", size=Some(@math.Vec2::new(140.0, 36.0)))
}`
    }
  },
  text_edit: {
    titleKey: 'comp.text_edit.title',
    signature: "ui.text_edit(text, placeholder~) -> (String, Response)",
    code: {
      zh: `///|
pub fn draw_text_edit(ui : @core.UIContext, state : AppState) -> Unit {
  let (new_text, res) = ui.text_edit(
    state.username,
    placeholder="请输入用户名...",
  )
  if res.changed {
    state.username = new_text
  }
}`,
      en: `///|
pub fn draw_text_edit(ui : @core.UIContext, state : AppState) -> Unit {
  let (new_text, res) = ui.text_edit(
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
    signature: "ui.code_editor(id_salt, text, size?~, show_line_numbers?~, read_only?~) -> (String, Response)",
    code: {
      zh: `///|
pub fn draw_script_workbench(ui : @core.UIContext, state : AppState) -> Unit {
  // 头部状态提示
  ui.label("CAD 脚本控制台 (MoonBit 0.1.0)")

  // 多行带行号代码编辑器
  let (updated_code, resp) = ui.code_editor(
    "cad_script",
    state.script_source,
    size=Some(@math.Vec2::new(ui.available_width(), 240.0)),
    show_line_numbers=true,
    read_only=false,
  )

  // 状态同步
  if resp.changed() {
    state.script_source = updated_code
    state.dirty = true
  }

  // 编译并执行按钮
  let btn = ui.button("编译并运行 (⌘R)", primary=true)
  if btn.clicked {
    execute_wasm_script(state.script_source)
  }
}`,
      en: `///|
pub fn draw_script_workbench(ui : @core.UIContext, state : AppState) -> Unit {
  // Header status prompt
  ui.label("CAD Script Console (MoonBit 0.1.0)")

  // Multi-line code editor with gutter and line numbers
  let (updated_code, resp) = ui.code_editor(
    "cad_script",
    state.script_source,
    size=Some(@math.Vec2::new(ui.available_width(), 240.0)),
    show_line_numbers=true,
    read_only=false,
  )

  // State synchronization
  if resp.changed() {
    state.script_source = updated_code
    state.dirty = true
  }

  // Compile and run button
  let btn = ui.button("Compile & Run (⌘R)", primary=true)
  if btn.clicked {
    execute_wasm_script(state.script_source)
  }
}`
    }
  },
  checkbox: {
    titleKey: 'comp.checkbox.title',
    signature: "ui.checkbox(label, is_checked) -> (Bool, Response)",
    code: {
      zh: `///|
pub fn draw_checkbox(ui : @core.UIContext, state : AppState) -> Unit {
  let (checked, res) = ui.checkbox("硬件加速", state.gpu)
  if res.changed {
    state.gpu = checked
  }

  let (vsync, res2) = ui.checkbox("垂直同步", state.vsync)
  if res2.changed {
    state.vsync = vsync
  }
}`,
      en: `///|
pub fn draw_checkbox(ui : @core.UIContext, state : AppState) -> Unit {
  let (checked, res) = ui.checkbox("Hardware acceleration", state.gpu)
  if res.changed {
    state.gpu = checked
  }

  let (vsync, res2) = ui.checkbox("Vertical sync", state.vsync)
  if res2.changed {
    state.vsync = vsync
  }
}`
    }
  },
  toggle: {
    titleKey: 'comp.toggle.title',
    signature: "ui.toggle(label, is_checked) -> (Bool, Response)",
    code: {
      zh: `///|
pub fn draw_toggles(ui : @core.UIContext, state : AppState) -> Unit {
  let (snap, res1) = ui.toggle("网格对齐", state.grid_snap)
  if res1.changed {
    state.grid_snap = snap
  }

  let (normals, res2) = ui.toggle("显示法线", state.normals)
  if res2.changed {
    state.normals = normals
  }
}`,
      en: `///|
pub fn draw_toggles(ui : @core.UIContext, state : AppState) -> Unit {
  let (snap, res1) = ui.toggle("Snap to grid", state.grid_snap)
  if res1.changed {
    state.grid_snap = snap
  }

  let (normals, res2) = ui.toggle("Show normals", state.normals)
  if res2.changed {
    state.normals = normals
  }
}`
    }
  },
  radio: {
    titleKey: 'comp.radio.title',
    signature: "ui.radio(label, is_selected) -> (Bool, Response)",
    code: {
      zh: `///|
pub fn draw_radio(ui : @core.UIContext, state : AppState) -> Unit {
  let (_, r1) = ui.radio("浅色模式", state.theme == 0)
  if r1.clicked { state.theme = 0 }

  let (_, r2) = ui.radio("深色模式", state.theme == 1)
  if r2.clicked { state.theme = 1 }

  let (_, r3) = ui.radio("跟随系统", state.theme == 2)
  if r3.clicked { state.theme = 2 }
}`,
      en: `///|
pub fn draw_radio(ui : @core.UIContext, state : AppState) -> Unit {
  let (_, r1) = ui.radio("Light", state.theme == 0)
  if r1.clicked { state.theme = 0 }

  let (_, r2) = ui.radio("Dark", state.theme == 1)
  if r2.clicked { state.theme = 1 }

  let (_, r3) = ui.radio("Follow the system", state.theme == 2)
  if r3.clicked { state.theme = 2 }
}`
    }
  },
  slider: {
    titleKey: 'comp.slider.title',
    signature: "ui.slider(val, min~, max~) / ui.slider_int(val, min~, max~) -> (T, Response)",
    code: {
      zh: `///|
pub fn draw_drag_values(ui : @core.UIContext, state : AppState) -> Unit {
  let (x, _) = ui.drag_value("X 坐标", state.pos_x, speed=0.5, min=-1000.0, max=1000.0)
  let (y, _) = ui.drag_value("Y 坐标", state.pos_y, speed=0.5, min=-1000.0, max=1000.0)
  let (scale, _) = ui.drag_value("缩放", state.scale, speed=0.05, min=0.1, max=10.0)
}`,
      en: `///|
pub fn draw_drag_values(ui : @core.UIContext, state : AppState) -> Unit {
  let (x, _) = ui.drag_value("X", state.pos_x, speed=0.5, min=-1000.0, max=1000.0)
  let (y, _) = ui.drag_value("Y", state.pos_y, speed=0.5, min=-1000.0, max=1000.0)
  let (scale, _) = ui.drag_value("Scale", state.scale, speed=0.05, min=0.1, max=10.0)
}`
    }
  },
  drag_value: {
    titleKey: 'comp.drag_value.title',
    signature: "ui.drag_value(label, val, speed~, min~, max~) -> (Double, Response)",
    code: {
      zh: `///|
pub fn draw_drag_values(ui : @core.UIContext, state : AppState) -> Unit {
  let (x, _) = ui.drag_value("X 坐标", state.pos_x, speed=0.5, min=-1000.0, max=1000.0)
  let (y, _) = ui.drag_value("Y 坐标", state.pos_y, speed=0.5, min=-1000.0, max=1000.0)
  let (scale, _) = ui.drag_value("缩放", state.scale, speed=0.05, min=0.1, max=10.0)
}`,
      en: `///|
pub fn draw_drag_values(ui : @core.UIContext, state : AppState) -> Unit {
  let (x, _) = ui.drag_value("X", state.pos_x, speed=0.5, min=-1000.0, max=1000.0)
  let (y, _) = ui.drag_value("Y", state.pos_y, speed=0.5, min=-1000.0, max=1000.0)
  let (scale, _) = ui.drag_value("Scale", state.scale, speed=0.05, min=0.1, max=10.0)
}`
    }
  },
  knob: {
    titleKey: 'comp.knob.title',
    signature: "ui.knob(id, label, value, min_val~, max_val~, step~, default_val~, unit~, radius~, bipolar~) -> (Double, Response)",
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
  combo_box: {
    titleKey: 'comp.combo_box.title',
    signature: "ui.combo_box(id, label, selected_idx, options) -> (Int, Response)",
    code: {
      zh: `///|
pub fn draw_combo_box(ui : @core.UIContext, state : AppState) -> Unit {
  let formats = ["PNG", "SVG", "WebP", "PDF"]
  let (selected_idx, res) = ui.combo_box(
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
  let (selected_idx, res) = ui.combo_box(
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
    signature: "ui.color_button(id, color) -> (Bool, Response)",
    code: {
      zh: `///|
pub fn draw_collapsing(ui : @core.UIContext, state : AppState) -> Unit {
  ui.collapsing_header("advanced", "高级设置", default_open=true, fn(ui) {
    let (msaa, _) = ui.checkbox("抗锯齿", state.msaa)
    let (shadows, _) = ui.checkbox("阴影", state.shadows)
  })
}`,
      en: `///|
pub fn draw_collapsing(ui : @core.UIContext, state : AppState) -> Unit {
  ui.collapsing_header("advanced", "Advanced", default_open=true, fn(ui) {
    let (msaa, _) = ui.checkbox("Antialiasing", state.msaa)
    let (shadows, _) = ui.checkbox("Shadows", state.shadows)
  })
}`
    }
  },
  progress_bar: {
    titleKey: 'comp.progress_bar.title',
    signature: "ui.progress_bar(fraction, text~) -> Response",
    code: {
      zh: `///|
pub fn draw_collapsing(ui : @core.UIContext, state : AppState) -> Unit {
  ui.collapsing_header("advanced", "高级设置", default_open=true, fn(ui) {
    let (msaa, _) = ui.checkbox("抗锯齿", state.msaa)
    let (shadows, _) = ui.checkbox("阴影", state.shadows)
  })
}`,
      en: `///|
pub fn draw_collapsing(ui : @core.UIContext, state : AppState) -> Unit {
  ui.collapsing_header("advanced", "Advanced", default_open=true, fn(ui) {
    let (msaa, _) = ui.checkbox("Antialiasing", state.msaa)
    let (shadows, _) = ui.checkbox("Shadows", state.shadows)
  })
}`
    }
  },
  collapsing_header: {
    titleKey: 'comp.collapsing_header.title',
    signature: "ui.collapsing_header(id, title, default_open~, content)",
    code: {
      zh: `///|
pub fn draw_collapsing(ui : @core.UIContext, state : AppState) -> Unit {
  ui.collapsing_header("advanced", "高级设置", default_open=true, fn(ui) {
    let (msaa, _) = ui.checkbox("抗锯齿", state.msaa)
    let (shadows, _) = ui.checkbox("阴影", state.shadows)
  })
}`,
      en: `///|
pub fn draw_collapsing(ui : @core.UIContext, state : AppState) -> Unit {
  ui.collapsing_header("advanced", "Advanced", default_open=true, fn(ui) {
    let (msaa, _) = ui.checkbox("Antialiasing", state.msaa)
    let (shadows, _) = ui.checkbox("Shadows", state.shadows)
  })
}`
    }
  },
  tree_view: {
    titleKey: 'comp.tree_view.title',
    signature: "ui.tree_view(id_salt, nodes, selected_id~, expanded_ids~, indent_step~, item_height~, size?) -> TreeViewResponse",
    code: {
      zh: `///|
pub fn draw_cad_outliner(ui : @core.UIContext, state : AppState) -> Unit {
  // 构建三维 CAD 场景资产层级树
  let nodes = [
    @core.TreeNode::new("scene_root", "场景装配体 (Root Scene)", icon="[S]", children=[
      @core.TreeNode::new("cam_grp", "摄影机组 (Cameras)", icon="[G]", children=[
        @core.TreeNode::leaf("main_cam", "透视主摄影机", icon="[C]"),
        @core.TreeNode::leaf("ortho_top", "正交顶视图", icon="[C]"),
      ]),
      @core.TreeNode::new("geo_grp", "几何体实体 (Geometry)", icon="[G]", children=[
        @core.TreeNode::leaf("bezier_curve", "三次贝塞尔曲线", icon="[M]"),
        @core.TreeNode::new("robot_arm", "机械臂总成", icon="[G]", children=[
          @core.TreeNode::leaf("joint_1", "基座旋转关节", icon="[M]"),
          @core.TreeNode::leaf("gripper", "气动末端执行器", icon="[M]"),
        ]),
        @core.TreeNode::leaf("mesh_torus", "环面图元", icon="[M]"),
      ]),
      @core.TreeNode::new("mat_grp", "材质与着色器", icon="[G]", children=[
        @core.TreeNode::leaf("pbr_metal", "PBR 导电金属材质", icon="[T]"),
        @core.TreeNode::leaf("glass_mat", "次表面透光玻璃", icon="[T]"),
      ]),
      @core.TreeNode::leaf("env_light", "HDRI 环境光照", icon="[L]"),
    ]),
  ]

  // 即时模式分层树渲染：支持记忆展开、发丝引导线与键盘上下/左右极速导航
  let resp = ui.tree_view(
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
    @core.TreeNode::new("scene_root", "Root Assembly (Scene)", icon="[S]", children=[
      @core.TreeNode::new("cam_grp", "Cameras", icon="[G]", children=[
        @core.TreeNode::leaf("main_cam", "Perspective Camera", icon="[C]"),
        @core.TreeNode::leaf("ortho_top", "Orthographic Top", icon="[C]"),
      ]),
      @core.TreeNode::new("geo_grp", "Geometry Entities", icon="[G]", children=[
        @core.TreeNode::leaf("bezier_curve", "Cubic Bezier Spline", icon="[M]"),
        @core.TreeNode::new("robot_arm", "Robot Arm Assembly", icon="[G]", children=[
          @core.TreeNode::leaf("joint_1", "Rotary Base Joint", icon="[M]"),
          @core.TreeNode::leaf("gripper", "Pneumatic Gripper", icon="[M]"),
        ]),
        @core.TreeNode::leaf("mesh_torus", "Torus Topology", icon="[M]"),
      ]),
      @core.TreeNode::new("mat_grp", "Materials & Shaders", icon="[G]", children=[
        @core.TreeNode::leaf("pbr_metal", "PBR Metallic Material", icon="[T]"),
        @core.TreeNode::leaf("glass_mat", "Subsurface Glass", icon="[T]"),
      ]),
      @core.TreeNode::leaf("env_light", "HDRI Environment Light", icon="[L]"),
    ]),
  ]

  // Immediate-mode TreeView: expand memory, guide lines, and full keyboard navigation
  let resp = ui.tree_view(
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
    signature: "ui.tooltip(text)",
    code: {
      zh: `///|
pub fn draw_tooltips(ui : @core.UIContext, state : AppState) -> Unit {
  let res_export = ui.button("导出")
  if res_export.hovered {
    ui.tooltip("导出 SVG 矢量图")
  }

  let res_mesh = ui.button("网格")
  if res_mesh.hovered {
    ui.tooltip("重新计算三角网格")
  }
}`,
      en: `///|
pub fn draw_tooltips(ui : @core.UIContext, state : AppState) -> Unit {
  let res_export = ui.button("Export")
  if res_export.hovered {
    ui.tooltip("Export a vector SVG")
  }

  let res_mesh = ui.button("Mesh")
  if res_mesh.hovered {
    ui.tooltip("Recompute the triangle mesh")
  }
}`
    }
  },
  tab_bar: {
    titleKey: 'comp.tab_bar.title',
    signature: "ui.tab_bar(id, tabs, selected_idx) -> (Int, Response)",
    code: {
      zh: `///|
pub fn draw_tabs(ui : @core.UIContext, state : AppState) -> Unit {
  let tabs = ["属性", "视口", "图层", "输出"]
  let (active_tab, res) = ui.tab_bar("tabs", tabs, state.tab_idx)
  if res.changed {
    state.tab_idx = active_tab
  }
}`,
      en: `///|
pub fn draw_tabs(ui : @core.UIContext, state : AppState) -> Unit {
  let tabs = ["Properties", "Viewport", "Layers", "Output"]
  let (active_tab, res) = ui.tab_bar("tabs", tabs, state.tab_idx)
  if res.changed {
    state.tab_idx = active_tab
  }
}`
    }
  },
  menu_bar: {
    titleKey: 'comp.menu_bar.title',
    signature: "ui.menu_bar(height~, content) -> Response",
    code: {
      zh: `///|
pub fn draw_app_menu(ui : @core.UIContext, state : AppState) -> Unit {
  ui.menu_bar(fn(ui) {
    ui.menu("文件", fn(ui) {
      if ui.menu_item("新建画板", shortcut="⌘N").clicked {
        state.new_canvas()
      }
      if ui.menu_item("打开工程...", shortcut="⌘O").clicked {
        state.open_project()
      }
      ui.menu_separator()
      if ui.menu_item("保存设计", shortcut="⌘S").clicked {
        state.save_design()
      }
      if ui.menu_item("导出 SVG...", shortcut="⇧⌘E").clicked {
        state.export_svg()
      }
    })
    ui.menu("编辑", fn(ui) {
      if ui.menu_item("撤销", shortcut="⌘Z").clicked {
        state.undo()
      }
      if ui.menu_item("重做", shortcut="⇧⌘Z").clicked {
        state.redo()
      }
      ui.menu_separator()
      if ui.menu_item("复制选中", shortcut="⌘C").clicked {
        state.copy()
      }
    })
    ui.menu("视图", fn(ui) {
      if ui.menu_item("重置视口", shortcut="⌘0").clicked {
        state.reset_viewport()
      }
      if ui.menu_item("适应全屏", shortcut="⌘1").clicked {
        state.fit_all()
      }
    })
    ui.menu("帮助", fn(ui) {
      if ui.menu_item("快捷键速查", shortcut="?").clicked {
        state.show_shortcuts()
      }
      if ui.menu_item("关于 moon-egui").clicked {
        state.show_about()
      }
    })
  })
}`,
      en: `///|
pub fn draw_app_menu(ui : @core.UIContext, state : AppState) -> Unit {
  ui.menu_bar(fn(ui) {
    ui.menu("File", fn(ui) {
      if ui.menu_item("New Canvas", shortcut="⌘N").clicked {
        state.new_canvas()
      }
      if ui.menu_item("Open Project...", shortcut="⌘O").clicked {
        state.open_project()
      }
      ui.menu_separator()
      if ui.menu_item("Save Design", shortcut="⌘S").clicked {
        state.save_design()
      }
      if ui.menu_item("Export SVG...", shortcut="⇧⌘E").clicked {
        state.export_svg()
      }
    })
    ui.menu("Edit", fn(ui) {
      if ui.menu_item("Undo", shortcut="⌘Z").clicked {
        state.undo()
      }
      if ui.menu_item("Redo", shortcut="⇧⌘Z").clicked {
        state.redo()
      }
      ui.menu_separator()
      if ui.menu_item("Copy Selection", shortcut="⌘C").clicked {
        state.copy()
      }
    })
    ui.menu("View", fn(ui) {
      if ui.menu_item("Reset Viewport", shortcut="⌘0").clicked {
        state.reset_viewport()
      }
      if ui.menu_item("Fit to Screen", shortcut="⌘1").clicked {
        state.fit_all()
      }
    })
    ui.menu("Help", fn(ui) {
      if ui.menu_item("Keyboard Shortcuts", shortcut="?").clicked {
        state.show_shortcuts()
      }
      if ui.menu_item("About moon-egui").clicked {
        state.show_about()
      }
    })
  })
}`
    }
  },
  scroll_area: {
    titleKey: 'comp.scroll_area.title',
    signature: "ui.scroll_area(id, width~, height~, content)",
    code: {
      zh: `///|
pub fn draw_scroll_area(ui : @core.UIContext, state : AppState) -> Unit {
  ui.scroll_area("logs", width=360.0, height=200.0, fn(ui) {
    for i = 0; i < 30; i = i + 1 {
      ui.label("日志项 [\{i}]")
    }
  })
}`,
      en: `///|
pub fn draw_scroll_area(ui : @core.UIContext, state : AppState) -> Unit {
  ui.scroll_area("logs", width=360.0, height=200.0, fn(ui) {
    for i = 0; i < 30; i = i + 1 {
      ui.label("Log entry [\{i}]")
    }
  })
}`
    }
  },
  window: {
    titleKey: 'comp.window.title',
    signature: "ui.window(id, title, content)",
    code: {
      zh: `///|
pub fn draw_window(ui : @core.UIContext, state : AppState) -> Unit {
  ui.window("inspector", "属性检查器", fn(ui) {
    ui.label("当前选中: 样条曲线")
    let (w, _) = ui.slider(state.curve_width, min=1.0, max=10.0)
    let (closed, _) = ui.checkbox("闭合路径", state.curve_closed)
  })
}`,
      en: `///|
pub fn draw_window(ui : @core.UIContext, state : AppState) -> Unit {
  ui.window("inspector", "Inspector", fn(ui) {
    ui.label("Selected: spline curve")
    let (w, _) = ui.slider(state.curve_width, min=1.0, max=10.0)
    let (closed, _) = ui.checkbox("Closed path", state.curve_closed)
  })
}`
    }
  },
  command_palette: {
    titleKey: 'comp.command_palette.title',
    signature: "ui.command_palette(open, query, commands, selected_index~) -> CommandPaletteResponse",
    code: {
      zh: `///|
pub fn draw_command_palette(ui : @core.UIContext, state : AppState) -> Unit {
  // 定义可用命令集合
  let commands = [
    @core.CommandItem::new("new_file", "新建画板文件", category="文件", shortcut="⌘N"),
    @core.CommandItem::new("save_file", "保存当前工程", category="文件", shortcut="⌘S"),
    @core.CommandItem::new("export_svg", "导出矢量图元", category="文件", shortcut="⇧⌘E"),
    @core.CommandItem::new("zoom_fit", "缩放至全屏画板", category="视图", shortcut="⌘0"),
    @core.CommandItem::new("toggle_fps", "切换微秒级帧监视器", category="视图", shortcut="⌥F"),
    @core.CommandItem::new("moon_fmt", "格式化 MoonBit 源码", category="工具", shortcut="⌥⇧F"),
  ]

  // 即时模式调用全局命令面板
  let res = ui.command_palette(
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
    @core.CommandItem::new("new_file", "New Canvas File", category="File", shortcut="⌘N"),
    @core.CommandItem::new("save_file", "Save Project", category="File", shortcut="⌘S"),
    @core.CommandItem::new("export_svg", "Export SVG Vectors", category="File", shortcut="⇧⌘E"),
    @core.CommandItem::new("zoom_fit", "Fit View to Canvas", category="View", shortcut="⌘0"),
    @core.CommandItem::new("toggle_fps", "Toggle Frame Monitor", category="View", shortcut="⌥F"),
    @core.CommandItem::new("moon_fmt", "Format MoonBit Code", category="Tools", shortcut="⌥⇧F"),
  ]

  // Immediate mode invocation
  let res = ui.command_palette(
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
    signature: "ui.context_menu_items(id_salt, open, pos, items, menu_width?~) -> ContextMenuResponse",
    code: {
      zh: `///|
pub fn draw_cad_nodes(ui : @core.UIContext, state : AppState) -> Unit {
  // 渲染画板节点
  let node_resp = ui.window("变换矩阵", @math.Vec2::new(120.0, 80.0), @math.Vec2::new(200.0, 120.0), fn(w) {
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
    @core.ContextMenuItem::new("copy", "复制节点", shortcut="⌘C"),
    @core.ContextMenuItem::new("clone", "克隆分支", shortcut="⌘D"),
    @core.ContextMenuItem::separator(),
    @core.ContextMenuItem::new("reset", "重置参数", shortcut="⌥R"),
    @core.ContextMenuItem::new("delete", "删除图元", shortcut="⌫"),
  ]

  // 调用自适应边界翻转上下文菜单
  let res = ui.context_menu_items("node_ctx", state.menu_open, state.menu_pos, items)
  state.menu_open = res.open

  if res.selected_id is Some(action) {
    handle_node_action(state, action)
  }
}`,
      en: `///|
pub fn draw_cad_nodes(ui : @core.UIContext, state : AppState) -> Unit {
  // Render canvas node
  let node_resp = ui.window("Matrix Transform", @math.Vec2::new(120.0, 80.0), @math.Vec2::new(200.0, 120.0), fn(w) {
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
    @core.ContextMenuItem::new("copy", "Copy Node", shortcut="⌘C"),
    @core.ContextMenuItem::new("clone", "Duplicate", shortcut="⌘D"),
    @core.ContextMenuItem::separator(),
    @core.ContextMenuItem::new("reset", "Reset Parameters", shortcut="⌥R"),
    @core.ContextMenuItem::new("delete", "Delete Element", shortcut="⌫"),
  ]

  // Context menu with automatic collision boundary flipping
  let res = ui.context_menu_items("node_ctx", state.menu_open, state.menu_pos, items)
  state.menu_open = res.open

  if res.selected_id is Some(action) {
    handle_node_action(state, action)
  }
}`
    }
  },
  toast: {
    titleKey: 'comp.toast.title',
    signature: "ui.toast_stack(toasts, anchor?~, viewport_size?~) -> ToastResponse",
    code: {
      zh: `///|
pub fn draw_notifications(ui : @core.UIContext, state : AppState) -> Unit {
  // 业务事件触发通知入栈
  if state.need_notify {
    state.toasts.push(@core.Toast::success("保存完成", message="设计已同步至云端工程"))
    state.need_notify = false
  }

  // 渲染全局浮动通知栈，支持时间衰减与点击关闭
  let resp = ui.toast_stack(
    state.toasts,
    anchor=@core.ToastAnchor::BottomRight,
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
    state.toasts.push(@core.Toast::success("Save Complete", message="Design synced to cloud repository"))
    state.need_notify = false
  }

  // Render floating toast stack with time decay and dismiss handling
  let resp = ui.toast_stack(
    state.toasts,
    anchor=@core.ToastAnchor::BottomRight,
  )

  // Update active toasts
  state.toasts = resp.active_toasts

  if resp.dismissed_id is Some(id) {
    println("Toast dismissed manually: \{id}")
  }
}`
    }
  },
};
