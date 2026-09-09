<div align="center">

# moon-egui

**专为 MoonBit 与 WebAssembly 打造的高性能即时模式图形界面引擎**

<p>
  <a href="README.md">简体中文</a> · <a href="README_en.md">English</a>
</p>

<p>
  <a href="https://ling71671.github.io/moon-egui/"><img src="https://img.shields.io/badge/demo-live%20benchmark-0284c7?style=flat-square" alt="Live Demo" /></a>
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

`moon-egui` 是专为 [MoonBit](https://www.moonbitlang.com/) 编程语言打造的轻量级**即时模式图形界面引擎（Immediate-Mode GUI）**，面向 WebAssembly、HTML5 Canvas 2D 及高性能游戏与图形工具场景设计。

设计灵感源自 Rust 著名图形库 `egui` 与 C++ `Dear ImGui`。`moon-egui` 采用即时模式范式：**代码即界面，界面即状态**。与维护沉重 DOM 树的传统保留模式框架不同，`moon-egui` 采用逐帧声明式构建，具备零 DOM 开销、极低内存占用与 60 FPS 稳定流畅渲染能力。

### 核心规格一览

| 维度 | 规格指标 | 说明 |
| :--- | :--- | :--- |
| **交互范式** | 即时模式（IMGUI） | 逐帧声明式求值，无状态生命周期困扰 |
| **编程语言** | MoonBit（100% 纯逻辑） | 内核无头设计，解耦宿主环境 |
| **运行目标** | WebAssembly / JS | 后续可无缝扩展至原生端（Raylib / SDL） |
| **渲染后端** | HTML5 Canvas 2D（默认） | 输出紧凑图元指令流（`DrawCmd`） |
| **产物体积** | < 50 KB（目标） | 零外部运行时依赖 |
| **帧率目标** | 60 FPS（16.6ms 帧预算） | 严格控制每帧动态内存分配 |

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

### 桌面与 IDE 级布局系统
- **系统菜单栏（Menu Bar）**：全局顶部应用菜单，支持多级悬浮下拉交互项。
- **侧边栏与多栏网格（Side Panels & Columns）**：固定宽度侧边栏与多列自动等宽分栏。
- **浮动视窗（Floating Windows）**：按住标题栏自由拖拽、动态 Z-index 焦点置顶、折叠与收起。
- **滚动裁剪视口（ScrollArea & Clipping）**：鼠标滚轮平滑滚动与像素级 Scissor 遮罩裁剪。

### 交互控件套件
- **基础控件**：文本标签、多态交互按钮（正常/悬浮/按下/禁用）、复选框、胶囊开关。
- **精准调节**：整型与浮点滑动条（Slider）、**Blender 同款数值拖拽调节器（DragValue）**。
- **数据反馈**：平滑进度条、**实时数据波动折线图（Sparkline Plot）**、悬浮气泡提示（Tooltip）。
- **结构容器**：折叠分组面板（CollapsingHeader）、分割线（Separator）、弹性占位空白（Spacer）。

### 底层自由手绘引擎（Painter API）
支持在任意布局容器内直接调用 2D 矢量图元绘制接口（矩形、圆形、贝塞尔曲线、多边形填充、线段与文字），满足游戏 HUD、自定义仪表盘与小地图渲染需求。

### 无头纯算与高覆盖测试
由于核心逻辑仅生成纯 `DrawCmd` 图元指令流，不绑定任何浏览器 API，每项布局计算、AABB 碰撞检测与状态机流转均可通过 `moon test` 进行自动化无头测试。

---

## 开发路线图（2026 年 9 月 9 日 — 9 月 24 日）

- [x] **第一阶段：工程骨架与基础类型**（9月9日 – 9月11日）
  - 初始化核心数据结构：`Vec2`, `Rect`, `Color`, `InputState`, `DrawCmd`。
- [ ] **第二阶段：输入状态机与基础排版**（9月12日 – 9月15日）
  - AABB 空间命中判定、单向流式排版、`Button`, `Label`, `Checkbox`, `Slider`。
- [ ] **第三阶段：高级视窗与容器交互**（9月16日 – 9月18日）
  - 浮动可拖拽视窗、动态 Z-index 置顶管理、折叠分组树形面板。
- [ ] **第四阶段：Canvas 2D 桥接与在线 Playground**（9月19日 – 9月21日）
  - 60 FPS HTML5 Canvas 2D 驱动器、GitHub Pages 交互式 WebAssembly 在线演示。
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
