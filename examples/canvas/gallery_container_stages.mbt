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
// Containers, Overlays & Dialogs (ComboBox, ColorButton, CollapsingHeader, Tooltip,
// ScrollArea, Window, CommandPalette, ContextMenu, Toast, Splitter, Dialog, ColorPicker)
// ----------------------------------------------------------------------

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
    @color.Color::rgb(37, 99, 235), // Cobalt Blue
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

///|
fn draw_scroll_area_showcase(ui : @core.UIContext) -> Unit {
  let _ = ui.label_colored(
    "带视口裁剪与滑块的滚动区域 (ScrollArea)",
    @color.Color::accent_primary(),
  )
  ui.spacer(6.0)

  ui.scroll_area(
    "gallery_scroll",
    @math.Vec2::new(ui.available_width(), 200.0),
    fn(sa) {
      for i = 1; i <= 20; i = i + 1 {
        let text = "图元索引条目 #" +
          i.to_string() +
          " (Immediate-Mode Vector Render Record)"
        let _ = sa.label(text)
        sa.spacer(4.0)
      }
    },
  )
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

  let trigger_resp = ui.button_sized(
    "点击或直接右键弹出菜单",
    @math.Vec2::new(170.0, 30.0),
  )
  if trigger_resp.clicked ||
    trigger_resp.secondary_clicked ||
    (
      ui.input().mouse_secondary_pressed() &&
      ui.is_hovered(@math.Rect::new(0.0, 0.0, vp_w, vp_h))
    ) {
    gallery_state.ctx_menu_open = true
    gallery_state.ctx_menu_pos = if trigger_resp.secondary_clicked ||
      ui.input().mouse_secondary_pressed() {
      ui.input().mouse_pos()
    } else {
      @math.Vec2::new(180.0, 120.0)
    }
    gallery_state.status_text = "Context Menu Opened at Cursor"
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

///|
fn draw_splitter_showcase(ui : @core.UIContext) -> Unit {
  let _ = ui.label_colored(
    "双向可拖拽分栏容器 (Splitter Panes)",
    @color.Color::accent_primary(),
  )
  ui.spacer(6.0)
  let _ = ui.label(
    "鼠标拖拽中央把手调节比例，内置 >= 60px 物理防挤压防护与 Scissor 裁剪盒。",
  )
  ui.spacer(10.0)

  let split_size = @math.Vec2::new(ui.available_width(), 220.0)
  let new_ratio = ui.split_horizontal(
    "gal_split_h",
    gallery_state.splitter_ratio,
    split_size,
    fn(pane_ui, rect) {
      pane_ui.painter().add_rect(rect, @color.Color::bg_hover(), 4.0)
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
      pane_ui.painter().add_rect(rect, @color.Color::bg_surface(), 4.0)
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
fn draw_color_picker_showcase(ui : @core.UIContext) -> Unit {
  let _ = ui.label_colored(
    "2D HSV 拾色器 (ColorPicker)",
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
fn draw_dock_area_showcase(
  ui : @core.UIContext,
  _cur_w : Double,
  _cur_h : Double,
) -> Unit {
  let _ = ui.label_colored(
    "多视窗磁吸与分栏排版系统 (DockArea Workbench)",
    @color.Color::accent_primary(),
  )
  ui.spacer(6.0)
  let _ = ui.label(
    "基于递归 DockTree 的工作台排版：支持横向/纵向弹性分栏拖拽、标签栏切换与关闭、局部视口 Scissor 裁剪保护。",
  )
  ui.spacer(10.0)

  ui.horizontal(fn(row) {
    if row.button_sized("重置工作区布局", @math.Vec2::new(110.0, 26.0)).clicked {
      gallery_state.dock_tree = @core.DockTree::split(
        @core.DockSplitDirection::Horizontal,
        0.28,
        @core.DockTree::leaf([
          @core.DockTab::new("explorer", "资源管理器"),
          @core.DockTab::new("outline", "大纲视图"),
        ]),
        @core.DockTree::split(
          @core.DockSplitDirection::Vertical,
          0.62,
          @core.DockTree::leaf([
            @core.DockTab::new("canvas", "CAD 视口", closable=false),
            @core.DockTab::new("shader", "着色器源码", closable=true),
          ]),
          @core.DockTree::leaf([
            @core.DockTab::new(
              "console",
              "运行日志 (Output)",
              closable=true,
            ),
            @core.DockTab::new("terminal", "终端 (Terminal)", closable=true),
          ]),
        ),
      )
      gallery_state.status_text = "DockArea Layout Reset"
    }
    row.spacer(10.0)
    let _ = row.label_colored(
      "拖拽中缝发丝线可实时缩放分栏比例；点击标签可切换激活面板；点击 × 可关闭面板",
      @color.Color::text_muted(),
    )
  })

  ui.spacer(10.0)

  let dock_size = @math.Vec2::new(ui.available_width(), 260.0)
  let d_resp = ui.dock_area("gal_dock", dock_size, gallery_state.dock_tree, fn(
    pane_ui,
    tab_id,
    rect,
  ) {
    pane_ui.set_cursor(@math.Vec2::new(rect.x + 12.0, rect.y + 10.0))
    match tab_id {
      "explorer" => {
        let _ = pane_ui.label_colored(
          "项目资源",
          @color.Color::accent_primary(),
        )
        pane_ui.spacer(4.0)
        let _ = pane_ui.label("📁 src/core/")
        let _ = pane_ui.label("  📄 context.mbt")
        let _ = pane_ui.label("  📄 dock.mbt")
        let _ = pane_ui.label("📁 assets/")
        let _ = pane_ui.label("  🖼️ logo.png")
      }
      "outline" => {
        let _ = pane_ui.label_colored(
          "符号大纲",
          @color.Color::accent_primary(),
        )
        pane_ui.spacer(4.0)
        let _ = pane_ui.label("⚡ pub enum DockSplitDirection")
        let _ = pane_ui.label("⚡ pub struct DockTab")
        let _ = pane_ui.label("⚡ pub enum DockNode")
        let _ = pane_ui.label("⚡ pub struct DockTree")
      }
      "canvas" => {
        let _ = pane_ui.label_colored(
          "CAD 视口工作台 (Viewport)",
          @color.Color::accent_primary(),
        )
        pane_ui.spacer(8.0)
        pane_ui.horizontal(fn(r) {
          let _ = r.badge("60 FPS", kind=@core.BadgeKind::success())
          r.spacer(8.0)
          let _ = r.badge("Wasm-GC", kind=@core.BadgeKind::info())
          r.spacer(8.0)
          if r.button_sized("刷新着色", @math.Vec2::new(76.0, 24.0)).clicked {
            gallery_state.status_text = "Viewport Shaders Recompiled"
          }
        })
        pane_ui.spacer(8.0)
        let (z, _) = pane_ui.slider(
          "视口缩放",
          gallery_state.slider_zoom,
          0.1,
          5.0,
        )
        gallery_state.slider_zoom = z
      }
      "shader" => {
        let _ = pane_ui.label_colored(
          "WGSL 着色器",
          @color.Color::text_strong(),
        )
        pane_ui.spacer(4.0)
        let _ = pane_ui.label("@vertex fn vs_main() -> VertexOutput")
        let _ = pane_ui.label("@fragment fn fs_main() -> @location(0) vec4f")
        let _ = pane_ui.label("return vec4f(0.145, 0.388, 0.921, 1.0);")
      }
      "console" => {
        let _ = pane_ui.label_colored(
          "系统运行日志",
          @color.Color::text_muted(),
        )
        pane_ui.spacer(4.0)
        let _ = pane_ui.label("[00:01:23] [INFO] DockArea frame initialized.")
        let _ = pane_ui.label(
          "[00:01:24] [INFO] Scissor clip applied to 3 panes.",
        )
        let _ = pane_ui.label(
          "[00:01:25] [OK] Layout split ratio stable at 60 FPS.",
        )
      }
      "terminal" => {
        let _ = pane_ui.label_colored(
          "zsh - moonbit",
          @color.Color::accent_primary(),
        )
        pane_ui.spacer(4.0)
        let _ = pane_ui.label("$ moon test --target wasm-gc")
        let _ = pane_ui.label("Total tests: 195, passed: 195, failed: 0.")
      }
      _ => {
        let _ = pane_ui.label("Panel: " + tab_id)
      }
    }
  })

  if d_resp.ratio_changed {
    gallery_state.status_text = "Dock Splitter Dragged"
  }
  match d_resp.active_tab_changed {
    Some((old_id, new_id)) =>
      gallery_state.status_text = "Tab Switched: " + old_id + " -> " + new_id
    None => ()
  }
  match d_resp.tab_closed {
    Some(cid) => gallery_state.status_text = "Tab Closed: " + cid
    None => ()
  }
}
