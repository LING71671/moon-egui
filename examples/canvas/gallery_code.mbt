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
pub fn get_gallery_component_info(comp_id : String) -> (String, String, String) {
  match comp_id {
    "button" =>
      (
        "Button 按钮", "ui.button(text, shortcut~, primary~, size~) -> Response",
        "///| Button 交互示例\npub fn draw_buttons(ui : @core.UIContext, state : AppState) -> Unit {\n  // 主要按钮（支持快捷键）\n  let res_primary = ui.button(\"提交操作\", shortcut=\"⌘S\", primary=true)\n  if res_primary.clicked {\n    state.count = state.count + 1\n  }\n\n  // 次要重置按钮\n  let res_reset = ui.button(\"重置状态\", shortcut=\"Esc\")\n  if res_reset.clicked {\n    state.count = 0\n  }\n\n  // 自定义尺寸按钮\n  let _ = ui.button(\"自定义尺寸\", size=Some(@math.Vec2::new(140.0, 36.0)))\n}",
      )
    "text_edit" =>
      (
        "TextEdit 文本输入", "ui.text_edit(id_salt, text, placeholder~) -> (String, Response)",
        "///| TextEdit 文本编辑示例\npub fn draw_text_edit(ui : @core.UIContext, state : AppState) -> Unit {\n  let (new_text, res) = ui.text_edit(\n    \"user_input\",\n    state.username,\n    placeholder=\"请输入用户名...\",\n  )\n  if res.changed {\n    state.username = new_text\n  }\n}",
      )
    "code_editor" =>
      (
        "CodeEditor 代码编辑器", "ui.code_editor(id_salt, text, size~, show_line_numbers~, read_only~) -> (String, Response)",
        "///| CodeEditor 代码编辑示例\npub fn draw_code_editor(ui : @core.UIContext, state : AppState) -> Unit {\n  let (updated_code, resp) = ui.code_editor(\n    \"cad_script\",\n    state.script_source,\n    size=Some(@math.Vec2::new(ui.available_width(), 240.0)),\n    show_line_numbers=true,\n    read_only=false,\n  )\n  if resp.changed() {\n    state.script_source = updated_code\n  }\n}",
      )
    "rich_text" =>
      (
        "RichText 流式富文本", "ui.rich_text(spans, wrap_width~) -> Response",
        "///| RichText 富文本示例\npub fn draw_rich_text(ui : @core.UIContext) -> Unit {\n  let spans = [\n    @core.TextSpan::bold(\"MoonBit Native GUI \"),\n    @core.TextSpan::normal(\"提供高性能立即模式排版与 \"),\n    @core.TextSpan::code(\"Wasm-GC\"),\n    @core.TextSpan::normal(\" 运行时支持。\"),\n  ]\n  let _ = ui.rich_text(spans, wrap_width=ui.available_width())\n}",
      )
    "checkbox" =>
      (
        "Checkbox 复选框", "ui.checkbox(label, is_checked) -> (Bool, Response)",
        "///| Checkbox 复选框示例\npub fn draw_checkbox(ui : @core.UIContext, state : AppState) -> Unit {\n  let (checked, res) = ui.checkbox(\"启用硬件加速渲染\", state.gpu_enabled)\n  if res.changed {\n    state.gpu_enabled = checked\n  }\n}",
      )
    "toggle" =>
      (
        "Toggle 胶囊开关", "ui.toggle(label, is_checked) -> (Bool, Response)",
        "///| Toggle 开关示例\npub fn draw_toggles(ui : @core.UIContext, state : AppState) -> Unit {\n  let (snap, res) = ui.toggle(\"吸附到网格节点\", state.grid_snap)\n  if res.changed {\n    state.grid_snap = snap\n  }\n}",
      )
    "radio" =>
      (
        "Radio 单选按钮", "ui.radio(label, is_selected) -> (Bool, Response)",
        "///| Radio 单选框示例\npub fn draw_radio(ui : @core.UIContext, state : AppState) -> Unit {\n  let (r1, _) = ui.radio(\"性能优先 (60 FPS)\", state.quality == 0)\n  if r1 { state.quality = 0 }\n  let (r2, _) = ui.radio(\"均衡模式 (渲染优化)\", state.quality == 1)\n  if r2 { state.quality = 1 }\n}",
      )
    "segmented_control" =>
      (
        "SegmentedControl 分段单选", "ui.segmented_control(id_salt, selected_index, options) -> (Int, Response)",
        "///| SegmentedControl 分段单选示例\npub fn draw_segmented(ui : @core.UIContext, state : AppState) -> Unit {\n  let (sel, res) = ui.segmented_control(\n    \"view_mode\",\n    state.selected_view,\n    [\"设计视图\", \"拆分对比\", \"代码查看\"],\n  )\n  if res.changed {\n    state.selected_view = sel\n  }\n}",
      )
    "slider" =>
      (
        "Slider 滑动条", "ui.slider(label, value, min, max, format~) -> (Double, Response)",
        "///| Slider 滑动条示例\npub fn draw_slider(ui : @core.UIContext, state : AppState) -> Unit {\n  let (new_val, res) = ui.slider(\"缩放倍率\", state.zoom, 0.1, 5.0, format=\"%.2fx\")\n  if res.changed {\n    state.zoom = new_val\n  }\n}",
      )
    "drag_value" =>
      (
        "DragValue 数字微调", "ui.drag_value(label, value, speed~, min~, max~) -> (Double, Response)",
        "///| DragValue 拖拽微调示例\npub fn draw_drag_value(ui : @core.UIContext, state : AppState) -> Unit {\n  let (new_val, res) = ui.drag_value(\"画板 X 偏移\", state.offset_x, speed=1.0)\n  if res.changed {\n    state.offset_x = new_val\n  }\n}",
      )
    "knob" =>
      (
        "Knob 旋钮调节器", "ui.knob(id_salt, label, value, min, max, unit~) -> (Double, Response)",
        "///| Knob 旋转音频/滤镜控制器示例\npub fn draw_knob(ui : @core.UIContext, state : AppState) -> Unit {\n  let (cutoff, res) = ui.knob(\"cutoff_knob\", \"低通截止\", state.cutoff, 20.0, 20000.0, unit=\"Hz\")\n  if res.changed {\n    state.cutoff = cutoff\n  }\n}",
      )
    "combo_box" =>
      (
        "ComboBox 下拉选择框", "ui.combo_box(id_salt, selected_index, options) -> (Int, Response)",
        "///| ComboBox 下拉选择器示例\npub fn draw_combo_box(ui : @core.UIContext, state : AppState) -> Unit {\n  let (sel, res) = ui.combo_box(\n    \"export_fmt\",\n    state.selected_format,\n    [\"SVG 矢量图像\", \"PNG 光栅切图\", \"PDF 工程图纸\"],\n  )\n  if res.changed {\n    state.selected_format = sel\n  }\n}",
      )
    "color_button" =>
      (
        "ColorButton 调色板按钮", "ui.color_button(id_salt, color, size~) -> (@color.Color, Response)",
        "///| ColorButton 颜色预设按钮示例\npub fn draw_color_button(ui : @core.UIContext, state : AppState) -> Unit {\n  let (c, res) = ui.color_button(\"theme_color\", state.accent)\n  if res.clicked {\n    state.show_palette = true\n  }\n}",
      )
    "color_picker" =>
      (
        "ColorPicker HSV 拾色器", "ui.color_picker(id_salt, color) -> (@color.Color, Response)",
        "///| ColorPicker HSV 连续拾色器示例\npub fn draw_color_picker(ui : @core.UIContext, state : AppState) -> Unit {\n  let (new_col, res) = ui.color_picker(\"active_color_picker\", state.color)\n  if res.changed {\n    state.color = new_col\n  }\n}",
      )
    "progress_bar" =>
      (
        "ProgressBar 进度条", "ui.progress_bar(progress, text~) -> Unit", "///| ProgressBar 进度条示例\npub fn draw_progress_bar(ui : @core.UIContext, state : AppState) -> Unit {\n  ui.progress_bar(state.load_progress, text=\"加载资产资源 68%\")\n}",
      )
    "spinner" =>
      (
        "Spinner 微加载动画", "ui.spinner(radius~, color~) -> Unit", "///| Spinner 加载动画示例\npub fn draw_spinner(ui : @core.UIContext) -> Unit {\n  ui.spinner(radius=12.0, color=@color.Color::accent_primary())\n}",
      )
    "badge" =>
      (
        "Badge / Tag 徽章标签", "ui.badge(text, kind~) -> Unit", "///| Badge 徽章标签示例\npub fn draw_badges(ui : @core.UIContext) -> Unit {\n  ui.badge(\"运行正常\", kind=@core.BadgeKind::Success)\n  ui.badge(\"需要关注\", kind=@core.BadgeKind::Warning)\n}",
      )
    "sparkline" =>
      (
        "Sparkline 迷你走势图", "ui.sparkline(data, width, height, color~) -> Unit",
        "///| Sparkline 走势图示例\npub fn draw_sparkline(ui : @core.UIContext, state : AppState) -> Unit {\n  ui.sparkline(state.fps_history, 240.0, 48.0, color=@color.Color::accent_primary())\n}",
      )
    "collapsing_header" =>
      (
        "CollapsingHeader 折叠树", "ui.collapsing_header(id_salt, label, content, default_open~) -> Unit",
        "///| CollapsingHeader 折叠树示例\npub fn draw_collapsing(ui : @core.UIContext) -> Unit {\n  ui.collapsing_header(\"geom_group\", \"几何图元属性\", fn(ui_sub) {\n    let _ = ui_sub.label(\"顶点数量: 16,384\")\n    let _ = ui_sub.label(\"面片索引: 32,768\")\n  }, default_open=true)\n}",
      )
    "tree_view" =>
      (
        "TreeView 资产层级树", "ui.tree_view(id_salt, root_node, expanded_ids, selected_id) -> (String?, Response)",
        "///| TreeView 树状资源管理示例\npub fn draw_tree(ui : @core.UIContext, state : AppState) -> Unit {\n  let (sel, res) = ui.tree_view(\n    \"project_tree\",\n    state.project_root,\n    state.expanded_nodes,\n    state.selected_file,\n  )\n  if res.changed {\n    state.selected_file = sel\n  }\n}",
      )
    "tooltip" =>
      (
        "Tooltip 悬浮提示", "ui.tooltip(target_rect, text) -> Unit", "///| Tooltip 提示浮层示例\npub fn draw_tooltip_button(ui : @core.UIContext) -> Unit {\n  let resp = ui.button(\"查看帮助文档\")\n  if resp.hovered() {\n    ui.tooltip(resp.rect, \"点击在侧边栏打开 MoonBit API 参考手册\")\n  }\n}",
      )
    "splitter" =>
      (
        "Splitter 分割面板", "ui.split_horizontal(id_salt, ratio, left, right) -> Double",
        "///| Splitter 分割视图示例\npub fn draw_splitter(ui : @core.UIContext, state : AppState) -> Unit {\n  let new_ratio = ui.split_horizontal(\n    \"main_split\",\n    state.ratio,\n    fn(ui_left, w, h) { draw_viewport(ui_left, w, h) },\n    fn(ui_right, w, h) { draw_inspector(ui_right, w, h) },\n  )\n  state.ratio = new_ratio\n}",
      )
    "table" =>
      (
        "Table 虚拟化数据表格", "ui.table(id_salt, columns, row_count, row_height~, cell_renderer) -> Unit",
        "///| Table 数据表格示例\npub fn draw_table(ui : @core.UIContext, state : AppState) -> Unit {\n  ui.table(\n    \"telemetry_table\",\n    state.columns,\n    state.rows.length(),\n    row_height=28.0,\n    fn(ui_cell, row_idx, col_idx, rect) {\n      draw_cell(ui_cell, row_idx, col_idx, rect)\n    },\n  )\n}",
      )
    "tab_bar" =>
      (
        "TabBar 标签页导航", "ui.tab_bar(id_salt, selected_index, tabs) -> (Int, Response)",
        "///| TabBar 选项卡导航示例\npub fn draw_tab_bar(ui : @core.UIContext, state : AppState) -> Unit {\n  let (sel, res) = ui.tab_bar(\n    \"studio_tabs\",\n    state.current_tab,\n    [\"图纸层\", \"物理碰撞\", \"渲染管线\"],\n  )\n  if res.changed {\n    state.current_tab = sel\n  }\n}",
      )
    "menu_bar" =>
      (
        "MenuBar 顶层菜单栏", "ui.menu_bar(menus) -> Unit", "///| MenuBar 顶层菜单示例\npub fn draw_menu_bar(ui : @core.UIContext) -> Unit {\n  ui.menu_bar([\n    { title: \"文件\", items: [{ id: \"open\", label: \"打开工程...\", shortcut: \"⌘O\" }] },\n    { title: \"编辑\", items: [{ id: \"undo\", label: \"撤销\", shortcut: \"⌘Z\" }] },\n  ])\n}",
      )
    "scroll_area" =>
      (
        "ScrollArea 滚动区域", "ui.scroll_area(id_salt, size, content) -> Unit",
        "///| ScrollArea 滚动裁剪容器示例\npub fn draw_scroll_area(ui : @core.UIContext) -> Unit {\n  ui.scroll_area(\n    \"log_scroll\",\n    @math.Vec2::new(320.0, 200.0),\n    fn(ui_inner) { draw_long_list(ui_inner) },\n  )\n}",
      )
    "breadcrumb" =>
      (
        "Breadcrumb 面包屑导航", "ui.breadcrumb(items) -> (String?, Response)",
        "///| Breadcrumb 路径导航示例\npub fn draw_breadcrumb(ui : @core.UIContext) -> Unit {\n  let (clicked, _) = ui.breadcrumb([\n    { id: \"root\", label: \"工作区\" },\n    { id: \"canvas\", label: \"画板演示\" },\n    { id: \"active\", label: \"组件配置\" },\n  ])\n  if clicked is Some(target) { navigate_to(target) }\n}",
      )
    "window" =>
      (
        "Window 浮动窗口", "ui.window(title, pos, size, content) -> Response",
        "///| Window 可拖拽悬浮窗示例\npub fn draw_floating_window(ui : @core.UIContext, state : AppState) -> Unit {\n  let _ = ui.window(\n    \"调试控制台\",\n    state.win_pos,\n    @math.Vec2::new(260.0, 320.0),\n    fn(ui_win) { draw_debug_controls(ui_win) },\n  )\n}",
      )
    "dialog" =>
      (
        "Dialog 模态对话框", "ui.dialog(title, message, is_open, show_cancel~) -> DialogResult",
        "///| Dialog 模态对话框示例\npub fn draw_dialog(ui : @core.UIContext, state : AppState) -> Unit {\n  let res = ui.dialog(\n    \"确认清空画板\",\n    \"该操作将清除当前所有未保存的几何图元，是否继续？\",\n    state.dialog_open,\n    show_cancel=true,\n  )\n  match res {\n    Confirmed => { clear_canvas(); state.dialog_open = false }\n    Cancelled => state.dialog_open = false\n    Dismissed => ()\n  }\n}",
      )
    "command_palette" =>
      (
        "CommandPalette 命令面板", "ui.command_palette(id_salt, query, items, is_open) -> CommandPaletteResult",
        "///| CommandPalette 快捷命令搜寻器示例\npub fn draw_palette(ui : @core.UIContext, state : AppState) -> Unit {\n  let res = ui.command_palette(\"global_commands\", state.query, state.command_list, state.open)\n  match res {\n    Execute(cmd) => execute(cmd)\n    Close => state.open = false\n    None => ()\n  }\n}",
      )
    "context_menu" =>
      (
        "ContextMenu 上下文菜单", "ui.context_menu(is_open, pos, items) -> (String?, Response)",
        "///| ContextMenu 右键级联菜单示例\npub fn draw_context_menu(ui : @core.UIContext, state : AppState) -> Unit {\n  let (selected, _) = ui.context_menu(state.open, state.pos, state.menu_items)\n  if selected is Some(act) {\n    handle_action(act)\n    state.open = false\n  }\n}",
      )
    "toast" =>
      (
        "Toast 全局通知", "ui.toast_stack(toasts, screen_size) -> Unit", "///| Toast 状态通知条示例\npub fn draw_toasts(ui : @core.UIContext, state : AppState) -> Unit {\n  ui.toast_stack(state.toasts, ui.screen_rect().size())\n}",
      )
    _ =>
      (
        "MoonBit 基础组件: " + comp_id,
        "ui." + comp_id,
        "///| 默认组件代码\npub fn render(ui : @core.UIContext) -> Unit {\n  let _ = ui.button(\"操作按钮\")\n}",
      )
  }
}
