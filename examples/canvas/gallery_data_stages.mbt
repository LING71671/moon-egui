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

///|
fn draw_node_editor_showcase(ui : @core.UIContext) -> Unit {
  let _ = ui.label_colored(
    "节点拓扑流连线编辑器 (NodeEditor)",
    @color.Color::accent_primary(),
  )
  ui.spacer(6.0)
  let _ = ui.label(
    "支持无极画布网格、节点卡片自由拖拽排布、输出/输入端口交互式连线与自适应平滑三次贝塞尔导线。",
  )
  ui.spacer(12.0)

  let editor_w = if ui.available_width() > 200.0 {
    ui.available_width()
  } else {
    560.0
  }
  let editor_h = 320.0

  let resp = @composite.node_editor(
    ui,
    "gal_node_editor",
    @math.Vec2::new(editor_w, editor_h),
    gallery_state.node_items,
    gallery_state.node_conns,
  )

  if resp.new_connection is Some(conn) {
    gallery_state.node_conns.push(conn)
    gallery_state.status_text = "New Connection: " +
      conn.from_node +
      ":" +
      conn.from_port +
      " -> " +
      conn.to_node +
      ":" +
      conn.to_port
  }

  if resp.dragged_node is Some(d_node) {
    gallery_state.status_text = "Dragging node: " + d_node
  } else if resp.selected_node is Some(s_node) {
    gallery_state.status_text = "Selected node: " + s_node
  }

  ui.spacer(10.0)
  ui.horizontal(fn(row) {
    let _ = row.label(
      "当前节点数: " +
      gallery_state.node_items.length().to_string() +
      " | 拓扑连线数: " +
      gallery_state.node_conns.length().to_string(),
    )
    row.spacer(16.0)
    if @widgets.button_sized(row, "重置拓扑", @math.Vec2::new(80.0, 24.0)).clicked {
      if gallery_state.node_items.length() >= 3 {
        gallery_state.node_items[0].set_pos(@math.Vec2::new(30.0, 40.0))
        gallery_state.node_items[1].set_pos(@math.Vec2::new(240.0, 40.0))
        gallery_state.node_items[2].set_pos(@math.Vec2::new(450.0, 70.0))
      }
      gallery_state.node_conns.clear()
      gallery_state.node_conns.push(
        @composite.NodeConnection::new(
          "audio_src", "out_wav", "dsp_filter", "in_audio",
        ),
      )
      gallery_state.node_conns.push(
        @composite.NodeConnection::new(
          "dsp_filter", "out_filtered", "sink_out", "in_sink",
        ),
      )
      gallery_state.status_text = "Topology Reset to Default"
    }
  })
}

///|
fn draw_virtual_list_showcase(
  ui : @core.UIContext,
  _cur_w : Double,
  _cur_h : Double,
) -> Unit {
  let _ = ui.label_colored(
    "一维数据虚拟化列表 (VirtualList)",
    @color.Color::accent_primary(),
  )
  ui.spacer(6.0)
  let _ = ui.label(
    "仅计算并光栅化可见视口区间条目。当前数据池总计: 10,000 行，零垃圾回收卡顿。",
  )
  ui.spacer(10.0)

  let resp = @widgets.virtual_list(
    ui,
    "gallery_vlist",
    10000,
    240.0,
    item_height=28.0,
    fn(idx, rect) {
      let is_even = idx % 2 == 0
      let bg = if is_even {
        @color.Color::bg_surface()
      } else {
        @color.Color::bg_window()
      }
      let p = ui.painter()
      p.add_rect(rect, bg, 0.0)
      let text = "条目 #" +
        idx.to_string() +
        " - 虚拟视口切片行 (Zero-GC Virtual Row Record)"
      p.add_text(
        @math.Vec2::new(rect.x + 12.0, rect.y + 6.0),
        text,
        ui.style.font_small * ui.style.scale,
        @color.Color::text_body(),
      )
    },
  )

  ui.spacer(10.0)
  ui.separator()
  ui.spacer(6.0)
  let stats_text = "当前视口切片: 行 " +
    resp.first_visible.to_string() +
    " 至 行 " +
    resp.last_visible.to_string() +
    " | 滚动偏移: " +
    resp.scroll_offset.to_int().to_string() +
    " px"
  let _ = ui.label(stats_text)
}

///|
fn draw_spring_physics_showcase(
  ui : @core.UIContext,
  cur_w : Double,
  _cur_h : Double,
) -> Unit {
  let _ = ui.label_colored(
    "简谐物理弹簧与动力学衰减沙盒 (Spring Physics)",
    @color.Color::accent_primary(),
  )
  ui.spacer(6.0)
  let _ = ui.label(
    "基于二阶质点-弹簧-阻尼系统（mẍ + cẋ + kx = 0）。鼠标拖拽圆球并在任意位置松手：",
  )
  ui.spacer(10.0)

  // Sliders for stiffness and damping
  ui.horizontal(fn(row) {
    let (stiff, _) = @widgets.slider(
      row,
      "刚度 (Stiffness)",
      gallery_state.spring_stiffness,
      40.0,
      400.0,
    )
    gallery_state.spring_stiffness = stiff
    row.spacer(16.0)
    let (damp, _) = @widgets.slider(
      row,
      "阻尼比 (Damping)",
      gallery_state.spring_damping,
      2.0,
      60.0,
    )
    gallery_state.spring_damping = damp
  })

  ui.spacer(12.0)

  // Interactive 2D simulation canvas
  let sim_w = if cur_w > 80.0 { cur_w - 60.0 } else { 300.0 }
  let sim_h = 160.0
  let (_id, sim_rect, _resp) = ui.allocate_space(@math.Vec2::new(sim_w, sim_h))

  let p = ui.painter()
  p.add_rect(sim_rect, @color.Color::bg_surface(), 6.0)
  p.add_rect_stroke(sim_rect, @color.Color::border_default(), 1.0, 6.0)

  // Origin target marker (center of canvas)
  let center_pos = @math.Vec2::new(
    sim_rect.x + sim_rect.w * 0.5,
    sim_rect.y + sim_rect.h * 0.5,
  )
  p.add_circle(center_pos, 4.0, @color.Color::accent_primary())

  let mouse_pos = ui.input.mouse_pos
  let puck_r = 14.0
  let current_puck = @math.Vec2::new(
    gallery_state.spring_puck_x,
    gallery_state.spring_puck_y,
  )

  // Hit test puck
  let puck_hit_rect = @math.Rect::new(
    current_puck.x - puck_r - 6.0,
    current_puck.y - puck_r - 6.0,
    (puck_r + 6.0) * 2.0,
    (puck_r + 6.0) * 2.0,
  )

  if ui.is_hovered(puck_hit_rect) {
    ui.set_cursor_icon("pointer")
    if ui.input.mouse_pressed {
      gallery_state.spring_dragging = true
    }
  }

  if gallery_state.spring_dragging {
    ui.set_cursor_icon("pointer")
    gallery_state.spring_puck_x = mouse_pos.x
    gallery_state.spring_puck_y = mouse_pos.y
    gallery_state.spring_model.reset(mouse_pos)
    if !ui.input.mouse_down {
      gallery_state.spring_dragging = false
      gallery_state.spring_model.set_target(center_pos)
    }
  } else {
    // Advance spring physics
    gallery_state.spring_model.set_target(center_pos)
    gallery_state.spring_model.step(0.016)
    let val = gallery_state.spring_model.value()
    gallery_state.spring_puck_x = val.x
    gallery_state.spring_puck_y = val.y
  }

  // Draw tether line
  p.add_line(
    center_pos,
    @math.Vec2::new(gallery_state.spring_puck_x, gallery_state.spring_puck_y),
    @color.Color::accent_soft(),
    2.0,
  )

  // Draw puck with shadow and border
  let puck_center = @math.Vec2::new(
    gallery_state.spring_puck_x,
    gallery_state.spring_puck_y,
  )
  p.add_circle(
    @math.Vec2::new(puck_center.x, puck_center.y + 2.0),
    puck_r,
    @color.Color::shadow(),
  )
  let puck_color = if gallery_state.spring_dragging {
    @color.Color::accent_hover()
  } else {
    @color.Color::accent_primary()
  }
  p.add_circle(puck_center, puck_r, puck_color)
  p.add_circle_stroke(puck_center, puck_r, @color.Color::white(), 2.0)

  ui.spacer(8.0)
  let is_settled = gallery_state.spring_model.is_settled()
  let settle_status = if is_settled {
    "状态: 动能平衡已归位 (Settled at equilibrium point)"
  } else {
    "状态: 简谐振荡衰减中 (Oscillating with spring-damper physics)"
  }
  let _ = ui.label(settle_status)
}

///|
fn draw_svg_export_showcase(ui : @core.UIContext) -> Unit {
  let _ = ui.label_colored(
    "几何矢量无损 SVG 导出器 (SvgExporter)",
    @color.Color::accent_primary(),
  )
  ui.spacer(6.0)
  let _ = ui.label(
    "将即时模式图元指令序列无损序列化为标准 SVG 矢量 XML 文本：",
  )
  ui.spacer(12.0)

  // Sample graphic card
  let card_w = 320.0
  let card_h = 90.0
  let (_id, preview_rect, _resp) = ui.allocate_space(
    @math.Vec2::new(card_w, card_h),
  )
  let p = ui.painter()
  p.add_rect(preview_rect, @color.Color::bg_surface(), 8.0)
  p.add_rect_stroke(preview_rect, @color.Color::border_default(), 1.0, 8.0)
  p.add_circle(
    @math.Vec2::new(preview_rect.x + 40.0, preview_rect.y + 45.0),
    20.0,
    @color.Color::accent_primary(),
  )
  p.add_line(
    @math.Vec2::new(preview_rect.x + 80.0, preview_rect.y + 45.0),
    @math.Vec2::new(preview_rect.x + 180.0, preview_rect.y + 45.0),
    @color.Color::success(),
    3.0,
  )
  p.add_text(
    @math.Vec2::new(preview_rect.x + 200.0, preview_rect.y + 38.0),
    "Vector SVG",
    14.0,
    @color.Color::text_primary(),
  )

  ui.spacer(14.0)

  ui.horizontal(fn(row) {
    if @widgets.button_primary(row, "生成当前图元 SVG 标记").clicked {
      let sample_dl = @draw.DrawList::new()
      sample_dl.add_rect(
        @math.Rect::new(0.0, 0.0, card_w, card_h),
        @color.Color::bg_surface(),
        8.0,
      )
      sample_dl.add_rect_stroke(
        @math.Rect::new(0.0, 0.0, card_w, card_h),
        @color.Color::border_default(),
        1.0,
        8.0,
      )
      sample_dl.add_circle(
        @math.Vec2::new(40.0, 45.0),
        20.0,
        @color.Color::accent_primary(),
      )
      sample_dl.add_line(
        @math.Vec2::new(80.0, 45.0),
        @math.Vec2::new(180.0, 45.0),
        @color.Color::success(),
        3.0,
      )
      sample_dl.add_text(
        @math.Vec2::new(200.0, 38.0),
        "Vector SVG",
        14.0,
        @color.Color::text_primary(),
      )
      let svg_str = sample_dl.to_svg(card_w, card_h)
      gallery_state.code_buffer = svg_str
      gallery_state.svg_export_done = true
      gallery_state.status_text = "SVG 导出成功 (已载入代码对比栏)"
    }
  })

  if gallery_state.svg_export_done {
    ui.spacer(8.0)
    let _ = ui.label(
      "SVG 矢量标记已生成！请拖动中央滑块至右侧查看生成的源码。",
    )
  }
}
