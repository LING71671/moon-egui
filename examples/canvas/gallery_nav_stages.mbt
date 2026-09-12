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
