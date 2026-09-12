# 更新日志 (Changelog)

[English](CHANGELOG.md) | [中文](CHANGELOG_zh.md)

本文件记录 `moon-egui` 项目的所有重要版本变更。

本格式基于 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.1.0/)，
并且本项目严格遵循 [语义化版本规范](https://semver.org/lang/zh-CN/)。

---

## [0.3.0] - 2026-09-13

### 破坏性变更 (Breaking Changes)
- **控件调用全面迁移到分层命名空间**：`ctx.button(...)` 等 `UIContext` 点方法移除，改为 `@widgets.button(ctx, ...)` / `@composite.knob(ctx, ...)`；控件导入从 `src/core` 迁至 `src/widgets` / `src/composite`；`src/lib.mbt` 门面保留全部类型重导出。详见 `docs/API_DESIGN.md` 与 `ARCH-06`。

### 问题修复
- **光标契约落地**：全部可交互表面按语义上报光标（按钮/标签/标签页 = `pointer`，滑杆 = `ew-resize` / `ns-resize`，分栏 = `col-resize` / `row-resize`，窗口标题栏 = `move`，文本 = `text`，HSV 取色区 = `crosshair`）；修复 ColorPicker、窗口标题栏、DockArea 标签、Toast 关闭钮、Sparkline 悬停五处缺失；**CAD 画板页（benchmark.html）宿主此前从不应用光标**，现经 `FrameOutput.cursor` 全帧同步。
- **命中测试统一走 `is_hovered`**：清除 21 处原始 `rect.contains(mouse_pos)` 命中测试，控件在 `scroll_area` 裁剪外或被窗口/前景层遮挡时不再误响应（刻意保留三处 modal「点卡片外部关闭」的原始几何判定）。
- **弹层自遮挡修复**：context menu / command palette / toast 此前会用自己的 hover blocker 在第二帧起吞掉自身 `is_hovered`——表现为菜单选不中行、面板滚轮失灵、toast 关闭钮点不掉；现将弹层交互阶段置于前景作用域，并附第二帧回归测试。
- **全局缩放覆盖补全**：`Knob` 与 `ColorPicker` 此前不随 `WidgetStyle.scale` 缩放（几何为硬编码字面量），现全部跟随，并以「scale 2 几何恰为 scale 1 两倍」的回归测试锁定。
- **构建脚本入口符号锚定**：`scripts/build_demo.*` 此前的模糊匹配会把 `window.moon_step` 错绑到 `Knob::step` 导致画板页静默失效，现锚定 `examples/canvas` 模块并重建产物。
- **文档与官网示例 API 迁移**：README（中英）、`docs/API_DESIGN*`、`docs/ARCHITECTURE*`、`docs/README_en` 与官网四页（docs / wiki / index / gallery）共约 160 处示例全部迁移至新命名空间 API。

### 新增功能与优化
- **即时模式工程图表套件 (`Plot` & `BarChart`)**：
  - `UIContext::plot`：支持折线（`Line`）、散点（`Scatter`）、面积（`Area`）多系列同图混排，支持边界自适应计算、网格细分刻度线、双轴数值标签、准心十字光标与数据浮窗。
  - `UIContext::bar_chart`：支持自适应柱条宽度与间隙计算、分类轴标签、悬停高亮色彩反馈与数值胶囊指示器。
- **数值微调器 (`DragValue`) 键盘流转与步进导航**：
  - 支持获得焦点时的方向键（ArrowLeft/Down 减少，ArrowRight/Up 增加）微调控制。
  - 支持快捷倍率：按住 Shift 实现 0.1x 精细步进，按住 Ctrl 实现 10x 快速步进。
  - 支持显式高对比焦点光环（`@color.Color::border_focus()`）。
- **控件几何与尺寸设计令牌规范化**：
  - 全面规范化 `WidgetStyle` 几何维度，引入进度条、气泡提示、标题栏、下拉框、折叠面板、标签栏、数值微调、调色盘、面包屑及图表的一级样式字段。
  - 在 `@color.Color` 中引入语义令牌 `Color::grid_line()`、`Color::guideline_wash()` 与 `Color::plot_crosshair()`。
- **垂直通道推子调节器 (`Fader` & `FaderInt`)**：
  - 新增 `UIContext::fader` 与 `UIContext::fader_int`，专用于音频调音台与连续参数控制。
  - 支持下陷导轨背景、双侧物理刻度线标尺、中心荧光指示线推子帽、垂直鼠标拖拽、滚轮微调、Shift（0.1x）/ Ctrl（10x）倍率修饰、键盘方向键/Home/End 导航与 Alt+Click 复位。
  - 补充设计令牌 `Color::fader_track_bg()`、`Color::fader_tick()`、`Color::fader_cap_line()` 及 `WidgetStyle` 字段 `fader_w`、`fader_h`、`fader_track_w`、`fader_cap_w`、`fader_cap_h`、`fader_cap_radius`。
- **底层图元文本字体与字重元数据补全 (`BUG-DRAW-03`)**：
  - 在 `DrawCmd::Text` 与 `DrawList::add_text` 中增加字体族名 (`font_family`) 与字重 (`font_weight`) 字段。
  - 支持 `RichText` 粗体真实应用 700 字重，支持 `CodeEditor` 声明等宽字体族名。
  - 更新 Web 渲染驱动（`gallery_runner.js` 与 `run.js`），支持动态装配与 LRU 字体缓存。
- **自动化测试套件扩展**：新增 `Fader` 完整白盒单元测试，使无头白盒与黑盒自动化测试总数增至 221 项（100% 通过率）。
- **分层包结构重构 (`ARCH-06`)**：
  - 依据 `ARCH-06` 将原 59 文件的 `src/core` 单体包拆分为 `src/core`（纯即时模式运行时）、`src/widgets`（标准控件）与 `src/composite`（高级组件）三层物理包，依赖方向严格单向：`math -> color -> draw -> core -> widgets -> composite -> src`。
  - `src/core` 仅保留引擎运行时（`context`、`id`、`input`、`memory`、`layout_engine`、`focus_manager`、`window_manager`、`layer_manager`、`painter`、`theme`、`response`、`unicode`、`widget`、`text_layout`）。
  - 跨包契约：控件以 `@core.Widget` 实现并经由 `ctx.add(...)` 派发，调用方使用 `@widgets.*` / `@composite.*` 命名空间函数；`WidgetStyle` 等只读结构体通过 `WidgetStyle::scaled(factor)` 等流式构建器派生，而非跨包结构体更新语法。
  - `src/lib.mbt` 作为总门面重导出全部公开类型，并通过 `pub using @core { trait Widget }` 转出引擎 trait。

---

## [0.2.0] - 2026-09-12

### 新增功能与优化
- **全自宿主 Pure Canvas Studio 工作台 (`gallery.html`)**：将组件展厅完全迁移至画布内即时模式工作台，内置分段主题切换（`studio_light` 白瓷、`slate_dark` 岩灰、`high_contrast` 高对比）、50/50 可拖拽分栏幕布（`split_horizontal`）、行号代码查看器（`code_editor`），以及覆盖 32 个组件的示例源码库。
- **输入无障碍与多指针引擎升级**：在 `RawInput` 中新增次级指针（鼠标右键）支持；实现贯穿全量交互控件的完整 Tab 焦点循环导航链；支持 Space/Enter 键盘激活与高对比焦点描边光环；新增帧事件消费机制（`consume_key`）。
- **排版与字素簇遍历引擎**：在 `rich_text.mbt` 中实现 CJK 汉字自动折行与标点避头尾换行规则；支持原子化 UTF-16 代理对字素边界双向导航（`prev_char_boundary`、`next_char_boundary`）；引入 LRU 排版度量缓存；新增浏览器原生隐藏式 IME 输入法 `<textarea>` 合成桥接。
- **控件韧性与边界自愈套件**：
  - `CodeEditor`：实现 $O(\log N)$ 二分查找字符点击命中测试、垂直滚轮滚动、光标自动跟踪居中、视口外行裁剪，以及支持拖拽框选与 Shift/Ctrl+A 快捷键的选区高亮缓冲区。
  - `ScrollArea`：支持可拖拽滚动条滑块交互与内容闭包后自愈高度裁剪。
  - `Dialog`：支持动态卡片高度自适应与确认/取消双向 Tab 焦点陷阱锁定。
  - `CommandPalette`：支持剪裁区限高滚动与 320px 视口高度安全钳位。
  - `ComboBox`：支持视口边缘碰撞检测与自适应向上翻转展开及内部滚动。
  - `ContextMenu`：支持递归级联多级子菜单（`children : Array[ContextMenuItem]`、`ContextMenuItem::submenu`）与悬停状态跟踪。
  - `Splitter`：增加零尺寸边界防护与对称最小安全像素钳位。
  - `Tooltip` 与 `Toast`：实现视口边界防溢出钳位与悬停遮挡事件捕获（`block_hover`）。
- **渲染与管线优化**：
  - 在 `DrawCmd` 与 `DrawList` 中新增 `LinearGradient` 线性渐变图元，映射至 Canvas 2D 宿主的 `createLinearGradient` 接口。
  - 剔除 `Table` 中多余的逐单元格剪裁状态压栈与出栈，每帧减少 240 次 Canvas 状态保存与恢复。
- **核心流式布局与动态主题**：
  - 新增自动换行流式容器 `UIContext::horizontal_wrapped`。
  - 新增运行时动态多主题切换机制，提供 `Theme` 结构体及 `Theme::studio_light()`、`Theme::slate_dark()`、`Theme::high_contrast()` 预设配置。
  - 新增即时模式缓动动画状态机（`animate_bool`、`animate_float`）。
- **内存与状态生命周期加固**：
  - 将所有持久化状态由线性数组重构为代际哈希表（`@hashmap.HashMap[Id, T]`），并结合帧计数器实现过期状态自动修剪（`prune_stale_state`）。
  - 实现零分配 64 位整数标识符派生（`Id::from_int`、`Id::with_int`、`IdStack::derive_int`）。
- **158 项无头白盒与黑盒测试**：实现单元测试与白盒测试 100% 通过率。

---

## [0.1.1] - 2026-09-11

### 新增功能与优化
- **全局应用菜单栏 (`menu_bar`, `menu`, `menu_item`, `menu_separator`)**：桌面级菜单栏，具备双稳态悬停切换（Hover-to-Switch）、点击外部空白收起、独立前景图层投影（`begin_foreground`）以及背景悬停遮挡阻断（`block_hover`）。
- **里程碑 3 全面交付**：交付窗口、容器与剪裁套件（`window`, `menu_bar`, `scroll_area`, `collapsing_header`, `tab_bar`）。
- **组件展厅交互集成**：在 `examples/canvas/gallery.html` 中集成菜单栏实时 CAD 工作区演示，并在 `examples/canvas/i18n.js` 中补齐双语词条。
- **Studio Light 白瓷工件设计语言**：在 `src/color/` 中统一设计令牌，更新全局设计规范文档。
- **触觉机械反馈增强**：按键 1.5px 下陷行程、巧克力按键键帽徽章与细微微铣槽轨道。
- **58 项无头自动化测试**：覆盖全部交互控件与状态分支，100% 通过。

---

## [0.1.0-alpha.1] - 2026-09-09

### 新增功能与优化
- **Canvas 2D 交互演示环境**：在 [`examples/canvas/`](examples/canvas/) 中提供完整的 HTML5 Canvas 2D 演示，以 60 FPS 运行并提供实时指针交互与遥测指标。
- **核心交互控件库**：在 `UIContext` 上提供 `label`、`label_colored`、`button`、`button_primary`、`checkbox`、`separator` 和 `spacer` 方法。
- **分层模块化架构**：在 `src/` 下划分模块化包结构（`src/math`, `src/color`, `src/draw`, `src/core`, `src/lib.mbt`），并在 `test/` 下提供黑盒集成测试。
- **数学几何基元**：提供 `Vec2` 与 `Rect`，支持 AABB 碰撞检测、矩形相交计算、外边距扩展与剪裁矩阵数学。
- **颜色系统与设计令牌**：支持 32 位 RGBA 颜色模型、十六进制颜色解析与 Alpha 混合通道。
- **平台无关绘制协议**：提供跨平台几何图元枚举（`DrawCmd`）与可复用缓冲命令队列（`DrawList`）。
- **交互状态机**：提供 `RawInput`、`InputState` 指针状态跟踪、64 位确定性 FNV-1a `Id` 哈希以及层级式 `IdStack`。
- **即时模式上下文调度器**：提供 `UIContext` 帧生命周期管理器，包含线性游标布局与 `allocate_space` 核心空间分配基元。
- **双语工程文档矩阵**：在 `docs/` 下提供架构、API 设计、设计系统、代码规范、贡献指南与路线图文档。
- **自动化 CI 流水线**：配置 GitHub Actions 工作流，验证代码格式（`moon fmt`）、单元测试（`moon test`）与 WebAssembly 目标构建（`moon build`）。
