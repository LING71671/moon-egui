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
// Navigation & Menu Components (TabBar, MenuBar, SegmentedControl, Breadcrumb)
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
  let (cur, _) = @widgets.tab_bar(
    ui,
    "demo_tab",
    tabs,
    gallery_state.tab_selected,
  )
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

  @composite.menu_bar(ui, fn(bar) {
    @composite.menu(bar, "文件 (File)", fn(m) {
      if @composite.menu_item(m, "新建图纸", shortcut="⌘N").clicked {
        gallery_state.status_text = "Menu: New File"
      }
      if @composite.menu_item(m, "保存图元", shortcut="⌘S").clicked {
        gallery_state.status_text = "Menu: Save File"
      }
      @composite.menu_separator(m)
      if @composite.menu_item(m, "退出", shortcut="⌘Q").clicked {
        gallery_state.status_text = "Menu: Quit"
      }
    })

    @composite.menu(bar, "编辑 (Edit)", fn(m) {
      if @composite.menu_item(m, "撤销", shortcut="⌘Z").clicked {
        gallery_state.status_text = "Menu: Undo"
      }
      if @composite.menu_item(m, "重做", shortcut="⌘Y").clicked {
        gallery_state.status_text = "Menu: Redo"
      }
      @composite.menu_separator(m)
      if @composite.menu_item(m, "复制", shortcut="⌘C").clicked {
        gallery_state.status_text = "Menu: Copy"
      }
      if @composite.menu_item(m, "粘贴", shortcut="⌘V").clicked {
        gallery_state.status_text = "Menu: Paste"
      }
    })

    @composite.menu(bar, "视图 (View)", fn(m) {
      if @composite.menu_item(m, "全景自适应", shortcut="⌘0").clicked {
        gallery_state.status_text = "Menu: Fit All"
      }
      if @composite.menu_item(m, "网格吸附").clicked {
        gallery_state.status_text = "Menu: Snap to Grid"
      }
    })

    @composite.menu(bar, "帮助 (Help)", fn(m) {
      if @composite.menu_item(m, "关于 moon-egui").clicked {
        gallery_state.status_text = "Menu: About moon-egui"
      }
      if @composite.menu_item(m, "MoonBit 官方文档").clicked {
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
  let (sel, _) = @widgets.segmented_control(
    ui,
    "gal_seg",
    views,
    gallery_state.segmented_sel,
    width=480.0,
    height=34.0,
  )
  if sel != gallery_state.segmented_sel {
    gallery_state.segmented_sel = sel
    gallery_state.status_text = "Segment Selected: " + views[sel]
  }
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
  let (c1, _) = @widgets.breadcrumb(ui, "gal_bc1", path1)
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
  let (c2, _) = @widgets.breadcrumb(
    ui,
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
fn draw_steps_showcase(ui : @core.UIContext) -> Unit {
  let _ = ui.label_colored(
    "任务流步骤导航条 (Steps & Timeline)",
    @color.Color::accent_primary(),
  )
  ui.spacer(6.0)
  let _ = ui.label(
    "提供节点状态自动推导、导轨连线、节点图标、点击切换以及键盘左右方向键流转支持。",
  )
  ui.spacer(14.0)

  let _ = ui.label("1. 任务向导步骤流 (支持点击与左右键切换):")
  ui.spacer(8.0)

  let items1 = [
    @widgets.StepItem::new("1. 账号认证", description="企业凭证校验"),
    @widgets.StepItem::new("2. 资源配额", description="选择算力节点"),
    @widgets.StepItem::new("3. 编译发布", description="构建 Wasm 产物"),
    @widgets.StepItem::new("4. 运行上线", description="服务健康检查"),
  ]

  let (idx1, _) = @widgets.steps(
    ui,
    "gallery_steps_wizard",
    gallery_state.steps_current,
    items1,
    width=560.0,
  )
  if idx1 != gallery_state.steps_current {
    gallery_state.steps_current = idx1
    gallery_state.status_text = "Step switched to: " + items1[idx1].title
  }

  ui.spacer(16.0)
  ui.horizontal(fn(row) {
    if @widgets.button_sized(row, "上一步", @math.Vec2::new(80.0, 26.0)).clicked {
      if gallery_state.steps_current > 0 {
        gallery_state.steps_current = gallery_state.steps_current - 1
        gallery_state.status_text = "Prev step: " +
          items1[gallery_state.steps_current].title
      }
    }
    row.spacer(10.0)
    if @widgets.button_primary_sized(
        row,
        "下一步",
        @math.Vec2::new(80.0, 26.0),
      ).clicked {
      if gallery_state.steps_current < items1.length() - 1 {
        gallery_state.steps_current = gallery_state.steps_current + 1
        gallery_state.status_text = "Next step: " +
          items1[gallery_state.steps_current].title
      }
    }
  })

  ui.spacer(18.0)
  let _ = ui.label("2. 显式状态节点 (Explicit Status with Error):")
  ui.spacer(8.0)

  let items2 = [
    @widgets.StepItem::with_status("代码扫描", @widgets.StepStatus::Finish),
    @widgets.StepItem::with_status("单元测试", @widgets.StepStatus::Finish),
    @widgets.StepItem::with_status(
      "安全审计",
      @widgets.StepStatus::Error,
      description="存在潜在依赖告警",
    ),
    @widgets.StepItem::with_status("镜像打包", @widgets.StepStatus::Wait),
  ]
  let _ = @widgets.steps(
    ui,
    "gallery_steps_explicit",
    2,
    items2,
    clickable=false,
    width=560.0,
  )
}

///|
fn draw_pagination_showcase(ui : @core.UIContext) -> Unit {
  let _ = ui.label_colored(
    "数据分页控件 (Pagination)",
    @color.Color::accent_primary(),
  )
  ui.spacer(6.0)
  let _ = ui.label(
    "支持智能折叠省略号、前驱/后继步进翻页、全键盘方向键无障碍操作与双向状态绑定。",
  )
  ui.spacer(14.0)

  let _ = ui.label("1. 基础分页条 (Basic Pagination · 10 页):")
  ui.spacer(8.0)

  let (p1, _) = @widgets.pagination(
    ui,
    "gal_pg_basic",
    gallery_state.pagination_page,
    10,
  )
  if p1 != gallery_state.pagination_page {
    gallery_state.pagination_page = p1
    gallery_state.status_text = "Page switched to: " + p1.to_string()
  }

  ui.spacer(10.0)
  ui.horizontal(fn(row) {
    let _ = row.label(
      "当前选中页码: " +
      gallery_state.pagination_page.to_string() +
      " / 10",
    )
    row.spacer(16.0)
    if @widgets.button_sized(row, "首页", @math.Vec2::new(56.0, 24.0)).clicked {
      gallery_state.pagination_page = 1
      gallery_state.status_text = "Jump to page 1"
    }
    row.spacer(6.0)
    if @widgets.button_sized(row, "末页", @math.Vec2::new(56.0, 24.0)).clicked {
      gallery_state.pagination_page = 10
      gallery_state.status_text = "Jump to page 10"
    }
  })

  ui.spacer(20.0)
  ui.separator()
  ui.spacer(14.0)

  let _ = ui.label(
    "2. 多页智能折叠省略号 (Intelligent Ellipsis · 25 页):",
  )
  ui.spacer(8.0)

  let pg_ref = Ref(gallery_state.pagination_page)
  let _ = ui.add(
    @widgets.Pagination::from_ref("gal_pg_multi", pg_ref, 25)
    .item_size(30.0)
    .spacing(4.0),
  )
  if pg_ref.val != gallery_state.pagination_page {
    gallery_state.pagination_page = pg_ref.val
    gallery_state.status_text = "Page switched to: " + pg_ref.val.to_string()
  }

  ui.spacer(14.0)
  let _ = ui.label(
    "提示：支持 Tab 聚焦后使用 ArrowLeft / ArrowRight / Home / End 键盘无障碍导航。",
  )
}
