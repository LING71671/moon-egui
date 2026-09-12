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
// Data & Visualization Components (TreeView, Table, Sparkline, Plot, BarChart)
// ----------------------------------------------------------------------

///|
fn draw_tree_view_showcase(ui : @core.UIContext) -> Unit {
  let _ = ui.label_colored(
    "分层引导线资产树 (Hierarchy TreeView)",
    @color.Color::accent_primary(),
  )
  ui.spacer(6.0)

  let tree_data = [
    @composite.TreeNode::new("src", "src", children=[], icon="folder"),
    @composite.TreeNode::new(
      "assets",
      "assets",
      children=[
        @composite.TreeNode::leaf("logo_png", "logo.png", icon="img"),
        @composite.TreeNode::leaf("shader_wgsl", "shader.wgsl", icon="code"),
        @composite.TreeNode::leaf("theme_json", "theme.json", icon="json"),
      ],
      icon="folder",
    ),
    @composite.TreeNode::leaf("moon_mod", "moon.mod", icon="doc"),
    @composite.TreeNode::leaf("readme_md", "README.md", icon="doc"),
  ]

  let tree_resp = @composite.tree_view(
    ui,
    "gallery_tree",
    tree_data,
    selected_id=gallery_state.tree_selected,
    expanded_ids=gallery_state.tree_expanded,
    size=@math.Vec2::new(ui.available_width(), 290.0),
  )

  gallery_state.tree_expanded = tree_resp.expanded_ids
  if tree_resp.selected_id is Some(sid) {
    gallery_state.tree_selected = Some(sid)
    gallery_state.status_text = "Selected: " + sid
  }
}

///|
fn draw_table_showcase(ui : @core.UIContext) -> Unit {
  let _ = ui.label_colored(
    "虚拟化数据表格 (Virtual Table)",
    @color.Color::accent_primary(),
  )
  ui.spacer(6.0)
  let _ = ui.label(
    "支持 10,000 行极速虚拟滚动（只渲染视口行），支持列宽拖拽与表头排序。",
  )
  ui.spacer(10.0)

  let resp = @composite.table(
    ui,
    "gal_table",
    @math.Vec2::new(ui.available_width(), 220.0),
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
    let (h1, _) = @composite.sparkline(
      row,
      "spk_cpu",
      gallery_state.sparkline_data,
      size=@math.Vec2::new(140.0, 42.0),
    )
    row.spacer(16.0)
    let (h2, _) = @composite.sparkline(
      row,
      "spk_fps",
      [58.0, 59.0, 60.0, 60.0, 59.0, 60.0, 60.0, 60.0, 59.0, 60.0],
      size=@math.Vec2::new(140.0, 42.0),
      color=@color.Color::success(),
    )
    row.spacer(16.0)
    let (h3, _) = @composite.sparkline(
      row,
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
fn draw_plot_showcase(ui : @core.UIContext) -> Unit {
  let _ = ui.label_colored(
    "高性能即时交互图表 (Interactive Plot)",
    @color.Color::accent_primary(),
  )
  ui.spacer(6.0)
  let _ = ui.label(
    "支持折线 (Line)、散点 (Scatter) 与面积 (Area) 多系列同图混排，网格辅助线、数值刻度、准心十字光标与数据浮窗。",
  )
  ui.spacer(12.0)

  let line_pts = [
    @composite.PlotPoint::new(0.0, 15.0),
    @composite.PlotPoint::new(20.0, 42.0),
    @composite.PlotPoint::new(40.0, 35.0),
    @composite.PlotPoint::new(60.0, 78.0),
    @composite.PlotPoint::new(80.0, 60.0),
    @composite.PlotPoint::new(100.0, 92.0),
    @composite.PlotPoint::new(120.0, 85.0),
    @composite.PlotPoint::new(140.0, 110.0),
  ]
  let scatter_pts = [
    @composite.PlotPoint::new(10.0, 25.0),
    @composite.PlotPoint::new(30.0, 50.0),
    @composite.PlotPoint::new(50.0, 45.0),
    @composite.PlotPoint::new(70.0, 85.0),
    @composite.PlotPoint::new(90.0, 70.0),
    @composite.PlotPoint::new(110.0, 98.0),
    @composite.PlotPoint::new(130.0, 90.0),
  ]
  let area_pts = [
    @composite.PlotPoint::new(0.0, 8.0),
    @composite.PlotPoint::new(20.0, 20.0),
    @composite.PlotPoint::new(40.0, 18.0),
    @composite.PlotPoint::new(60.0, 35.0),
    @composite.PlotPoint::new(80.0, 30.0),
    @composite.PlotPoint::new(100.0, 48.0),
    @composite.PlotPoint::new(120.0, 42.0),
    @composite.PlotPoint::new(140.0, 55.0),
  ]

  let s_area = @composite.PlotSeries::area(
    "Baseline",
    area_pts,
    color=@color.Color::accent_primary(),
  )
  let s_line = @composite.PlotSeries::line(
    "Throughput",
    line_pts,
    color=@color.Color::success(),
  )
  let s_scatter = @composite.PlotSeries::scatter(
    "Samples",
    scatter_pts,
    color=@color.Color::warning(),
  )

  let plot_w = if ui.available_width() > 200.0 {
    ui.available_width()
  } else {
    480.0
  }
  let (hover_pt, _) = @composite.plot(
    ui,
    "gal_plot_main",
    [s_area, s_line, s_scatter],
    size=@math.Vec2::new(plot_w, 220.0),
    show_legend=true,
    show_grid=true,
  )

  if hover_pt is Some(pt) {
    let x_int = pt.x.to_int()
    let y_int = pt.y.to_int()
    gallery_state.status_text = "Plot Crosshair: X=" +
      x_int.to_string() +
      ", Y=" +
      y_int.to_string()
  }
}

///|
fn draw_bar_chart_showcase(ui : @core.UIContext) -> Unit {
  let _ = ui.label_colored(
    "交互式柱状统计图 (Bar Chart)",
    @color.Color::accent_primary(),
  )
  ui.spacer(6.0)
  let _ = ui.label(
    "柱条自适应宽度与间隙，悬停高亮色彩微过渡，顶部即时数值指示胶囊与分类标签。",
  )
  ui.spacer(12.0)

  let labels = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug"]
  let values = [45.0, 78.0, 62.0, 95.0, 84.0, 110.0, 92.0, 130.0]

  let chart_w = if ui.available_width() > 200.0 {
    ui.available_width()
  } else {
    480.0
  }
  let (hover_bar, _) = @composite.bar_chart(
    ui,
    "gal_bar_main",
    labels,
    values,
    size=@math.Vec2::new(chart_w, 210.0),
  )

  if hover_bar is Some(idx) {
    if idx >= 0 && idx < labels.length() {
      gallery_state.status_text = "Bar Hovered: " +
        labels[idx] +
        " = " +
        values[idx].to_int().to_string()
    }
  }
}
