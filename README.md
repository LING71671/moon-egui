<div align="center">

# moon-egui

**面向 MoonBit 与 WebAssembly 的轻量级即时模式图形界面库**

<p>
  <a href="README.md">简体中文</a> · <a href="README_en.md">English</a>
</p>

<p>
  <a href="https://ling71671.github.io/moon-egui/"><img src="https://img.shields.io/badge/demo-live%20preview-0284c7?style=flat-square" alt="Live Demo" /></a>
  <a href="https://ling71671.github.io/moon-egui/benchmark.html"><img src="https://img.shields.io/badge/benchmark-canvas%20test-7c3aed?style=flat-square" alt="Canvas Benchmark" /></a>
  <a href="https://github.com/LING71671/moon-egui/actions"><img src="https://img.shields.io/github/actions/workflow/status/LING71671/moon-egui/ci.yml?branch=main&label=CI&style=flat-square" alt="CI Status" /></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-Apache--2.0-blue?style=flat-square" alt="License" /></a>
  <a href="https://www.moonbitlang.com/"><img src="https://img.shields.io/badge/lang-MoonBit-6B46C1?style=flat-square" alt="MoonBit" /></a>
  <img src="https://img.shields.io/badge/target-Wasm-F97316?style=flat-square" alt="Wasm" />
  <a href="https://moonbitlang.github.io/Hackathon2026/"><img src="https://img.shields.io/badge/hackathon-MoonBit%202026-10B981?style=flat-square" alt="Hackathon 2026" /></a>
</p>

<br />

<img src="media/social_preview.jpg" alt="moon-egui banner" width="100%" />

</div>

---

## 概述

`moon-egui` 是面向 [MoonBit](https://www.moonbitlang.com/) 编程语言的轻量级**即时模式图形界面库（Immediate-Mode GUI）**，面向 WebAssembly 与 HTML5 Canvas 2D 等图形交互场景设计。

设计灵感源自 Rust 社区的 `egui` 与 C++ `Dear ImGui`。`moon-egui` 采用即时模式范式：**代码即界面，界面即状态**。通过逐帧声明式构建，提供直观的 UI 开发体验、轻量级的运行时占用与平稳的渲染表现。

### 为什么选择 moon-egui？

在 WebAssembly 与 Canvas 绘图场景下构建交互界面时，开发者通常面临以下挑战：

- **传统 Canvas 逻辑的维护负担**：手写按钮坐标计算、命中碰撞检测与图层排序，代码量大且极易产生状态不同步缺陷。
- **DOM / 虚拟 DOM 的性能抖动**：在 60 FPS 高频画布应用中引入保留模式框架，跨语言/跨边界调用与垃圾回收（GC）容易引发偶发掉帧。
- **C/C++ 绑定的工具链门槛**：基于 FFI 的外部 GUI 包装依赖复杂的本地编译链，产物体积较大，且无法享受纯粹的包管理体验。

### 核心特性

- **即时模式心智**：逐帧声明界面，无需维护生命周期回调与双向同步，交互判定就地完成（例如 `if ui.button("保存").clicked { ... }`）。
- **零 FFI 原生依赖**：100% 纯 MoonBit 编写，内核解耦宿主环境，零外部运行时依赖，一行 `moon add` 即装即用。
- **微秒级帧管线**：内置视口空间裁剪与图元合并，单帧内核开销低至 0.1ms，在百万节点画布下稳定跑满 60 FPS。
- **开箱即用套件**：内置层级窗口（支持拖拽置顶与视口约束）、标签栏、支持真实键盘输入的文本框、防穿透下拉框与工具提示。

---

## 安装

```bash
moon add ling71671/moon-egui
```

安装后在 `moon.pkg` 中引入即可使用：

```json
{
  "import": [
    "LING71671/moon-egui/src/core",
    "LING71671/moon-egui/src/draw",
    "LING71671/moon-egui/src/math",
    "LING71671/moon-egui/src/color"
  ]
}
```

---

## 在线演示 (Live Demos)

您可以通过现代浏览器直接体验 `moon-egui` 的交互功能与图形渲染效果：

- **[在线交互主页 (Interactive Demo)](https://ling71671.github.io/moon-egui/)**
  包含即时模式基础控件展示、菜单栏、浮动窗口与轻量画板交互预览。
- **[画板与多尺度矩阵测试 (Canvas & Multi-Scale Benchmark)](https://ling71671.github.io/moon-egui/benchmark.html)**
  包含 128² 至 1024²（16,384 ~ 1,048,576 节点）多尺度像素晶格阵列、CAD 双轴标尺、视口平移/缩放漫游、以及像素晶格分界线渲染。

---

## 快速代码示例

```moonbit
fn update_ui(ui : &mut UIContext, state : &mut AppState) {
  // 1. 全局系统菜单栏
  ui.menu_bar(fn() {
    ui.menu("文件", fn() {
      if ui.menu_item("新建项目") { state.new_project() }
      if ui.menu_item("保存配置") { state.save() }
    })
    ui.menu("视图", fn() {
      if ui.menu_item("切换主题") { state.toggle_theme() }
    })
  })

  // 2. 浮动可拖拽视窗
  ui.window("控制台 & 属性监视", 50.0, 50.0, 300.0, 420.0, fn() {
    ui.label("欢迎使用 moon-egui")
    
    if ui.button("触发测试") {
      state.counter += 1
    }
    
    // Blender 风格数值拖拽调节
    ui.drag_float("重力参数", &mut state.gravity, speed=0.1, min=0.0, max=20.0)
    ui.checkbox("开启物理碰撞", &mut state.collision_enabled)
    
    // 折叠数据面板
    ui.collapsing_header("实时渲染监控", fn() {
      ui.sparkline("实时帧率曲线", state.fps_history)
      ui.progress_bar(state.progress)
    })
  })
}
```

---

## 架构体系

`moon-egui` 将 UI 求值与宿主渲染完全解耦，采用三层严谨的单向数据流管道：

```
[ 输入事件流 (Input Events) ]
  • 鼠标指针绝对坐标与按键状态
  • 键盘按键与修饰键
  • 鼠标滚轮滑动增量 (Delta)
         │
         ▼
[ moon-egui 纯算内核 ]
  • 输入状态机 (Hover, Active, Focused)
  • 线性游标排版与 AABB 空间命中判定
  • 矩形 Scissor 裁剪栈
  • 即时模式控件逻辑求值
         │
         ▼
[ 绘制指令序列 (DrawCmd Stream) ]
  • DrawCmd::Rect(x, y, w, h, color, radius)
  • DrawCmd::Text(x, y, text, size, color)
  • DrawCmd::Line(x1, y1, x2, y2, color, width)
  • DrawCmd::Clip(x, y, w, h)
         │
         ▼
[ 可插拔渲染后端 (Render Backends) ]
  • HTML5 Canvas 2D (默认 Wasm 桥接)
  • WebGL / WebGPU (规划演进)
  • 原生窗口引擎 (Raylib / SDL / Minifb)
```

---

## 核心特性矩阵

### 已交付可用特性 (Available Now)
- **底层图形与绘制内核 (Core Draw Engine)**：纯 MoonBit 实现的 `Vec2`, `Rect`, `Color`, `DrawCmd` 平台无关指令流，支持矩形、线段、圆、文本与嵌套矩形裁剪栈（Scissor Clipping）。
- **交互状态机与多向排版 (Layout & Space Allocation)**：`UIContext` 维护 `hot_id` / `active_id` 状态机与布局作用域栈，支持单向垂直流、水平行内排版流（`horizontal`），`allocate_space()` 自动分配几何尺寸并完成鼠标交互命中判定。
- **基础控件与调节器 (Available Widgets)**：
  - **文本标签**：`label`（标准文字）、`label_colored`（自定义颜色文本）。
  - **交互按钮**：`button`（基础按钮）、`button_primary`（重点操作按钮），内置 Normal / Hover / Pressed 响应。
  - **复选框**：`checkbox`（交互式开关选框）。
  - **连续数值滑动条**：`slider`（浮点拖拽调节）、`slider_int`（整型步进滑动），支持持续鼠标拖拽捕获与百分比实时映射。
  - **排版微调**：`separator`（水平分割线）、`spacer`（垂直弹性留白）。
- **视窗容器原型 (Window Container)**：`window(title, pos, size, content)` 支持独立背景绘制、标题栏 Header、内容局部坐标系与 Scissor 视口隔离裁剪。
- **无头纯算与高覆盖测试**：核心图元与组件逻辑完全脱离浏览器，支持通过 `moon test` 进行自动化无头测试。
- **Canvas 2D 宿主驱动器**：轻量 JavaScript 桥接层与 60 FPS 渲染管线，结合 O(1) 视口边界裁剪与多尺度 LOD 架构。

### 规划与演进中特性 (Planned / In Roadmap)
- **高级调节器**：Blender 同款数值拖拽调节器（`DragValue`）。
- **多窗口调度进阶**：窗口标题栏拖拽位移、动态 Z-index 焦点置顶管理、折叠分组树形面板（`CollapsingHeader`）。
- **容器与菜单**：滚动裁剪视口（`ScrollArea`）、全局顶层菜单栏（`MenuBar`）。
- **数据与反馈**：平滑进度条（`ProgressBar`）、实时数据波动折线图（`Sparkline`）、悬浮气泡提示（`Tooltip`）。

---

## 开发路线图（2026 年 9 月 9 日 — 9 月 24 日）

- [x] **第一阶段：工程骨架与基础类型**（9月9日 – 9月11日）
  - 交付核心数据结构：`Vec2`, `Rect`, `Color`, `InputState`, `DrawCmd`, `DrawList`。
- [x] **第二阶段：输入状态机与基础排版**（9月12日 – 9月15日）
  - 交付：AABB 空间命中判定、横纵双向排版（`horizontal`/`vertical`）、`Button`, `Label`, `Checkbox`, `Slider`, `SliderInt`。
- [x] **第四阶段（提前交付）：Canvas 2D 桥接与在线 Playground**（已上线）
  - 60 FPS HTML5 Canvas 2D 驱动器、LOD 自适应架构、GitHub Pages 自动化持续交付上线。
- [>] **第三阶段（推进中）：高级视窗与容器交互**（9月16日 – 9月18日）
  - 已完成：基础视窗容器原型（`Window`）、内部局部排版与裁剪隔离。
  - 进行中：窗口标题栏拖拽位移、动态 Z-index 置顶管理、折叠树形面板。
- [ ] **第五阶段：全面自动化测试与正式交付**（9月22日 – 9月24日）
  - 达成 150+ 自动化单元测试、完整文档规范与最终版本验收交付。

> 完整攻坚指标与详细验收准则请参阅 **[ROADMAP.md](docs/ROADMAP.md)** ([English](docs/ROADMAP_en.md))。

---

## 架构与技术文档

系统完整的设计白皮书与技术规范统一整理在 [`docs/`](docs/) 目录中：

| 文档名称 | 定位与说明 | 核心覆盖范围 |
| :--- | :--- | :--- |
| **[研发路线图与里程碑](docs/ROADMAP.md)** ([English](docs/ROADMAP_en.md)) | 交付周期与规划 | 各阶段交付清单、详细验收准则与技术演进方向 |
| **[系统架构与技术白皮书](docs/ARCHITECTURE_zh.md)** ([English](docs/ARCHITECTURE.md)) | 内核运行机制 | Widget ID 哈希定位、游标排版模型、裁剪栈机制 |
| **[公共 API 参考手册](docs/API_DESIGN_zh.md)** ([English](docs/API_DESIGN.md)) | 开发者接口文档 | `UIContext` 方法签名、容器布局协议、Painter 绘图接口 |
| **[设计系统与视觉规范](docs/DESIGN_SYSTEM_zh.md)** ([English](docs/DESIGN_SYSTEM.md)) | 界面设计 Token | 深色/浅色配色方案、字阶规范、间距系统、交互状态机 |
| **[官方编码规范指南](docs/STYLE_GUIDE.md)** ([English](docs/STYLE_GUIDE_en.md)) | 官方研发标准 | 块语法（`///\|`）、命名、可见性、测试分层、`.mbti` 契约 |
| **[开源贡献规范指南](docs/CONTRIBUTING_zh.md)** ([English](docs/CONTRIBUTING.md)) | 工程协作标准 | 研发流程、测试准则、Conventional Commits 提交约定 |
| **[更新日志与版本记录](docs/CHANGELOG.md)** | 版本演进记录 | 项目发布与代码变更历史跟踪 |

---

## 开源许可证

本项目采用 [Apache License 2.0](LICENSE) 开源许可证。
