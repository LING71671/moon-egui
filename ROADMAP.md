# Moon-EGUI 研发路线图与里程碑规范 (Roadmap)

<p>
  <a href="ROADMAP.md">简体中文</a> · <a href="ROADMAP_en.md">English</a>
</p>

> 本文档详细规划了 `moon-egui` 从 2026 年 9 月 9 日至 9 月 24 日（MoonBit 黑客松周期）的核心攻坚阶段、交付物清单、验收标准，以及赛后的长期演进规划。

---

## 1. 黑客松攻坚周期规划（2026年9月9日 – 9月24日）

```
2026.09.09          09.11           09.15           09.18           09.21           09.24
    │───────────────│───────────────│───────────────│───────────────│───────────────│
    [里程碑 1: 骨架与数学] [里程碑 2: 状态机与控件] [里程碑 3: 视窗与裁剪] [里程碑 4: Canvas与演示] [里程碑 5: 压测与交付]
```

---

### 里程碑 1：工程骨架与基础数学图元（9月9日 – 9月11日）

* **核心目标**：建立严谨无全局状态的代数数据结构与零依赖数学计算底座。
* **交付清单**：
  - [x] 确立 Apache-2.0 协议、规范化目录组织与自动化 CI 流水线；
  - [x] 编写中英双语技术白皮书（`ARCHITECTURE`、`API_DESIGN`、`DESIGN_SYSTEM`、`STYLE_GUIDE`）；
  - [ ] **几何数学模块** (`geom.mbt`)：`Vec2` 向量运算、`Rect` (AABB) 空间几何计算（`contains`, `intersects`, `intersect`, `expand`, `shrink`）；
  - [ ] **颜色与图元系统** (`color.mbt`, `draw_cmd.mbt`)：RGBA `Color` 模型、十六进制色值解析、`DrawCmd` 平台无关指令枚举与 `DrawList` 双缓冲复用队列；
  - [ ] **输入原始流结构** (`input.mbt`)：归一化 `RawInput` 与按键/鼠标指针抽象。
* **验收标准**：
  - `moon check` 与 `moon fmt --check` 零告警通过；
  - `geom_test.mbt` 与 `color_test.mbt` 基础数学单测 100% 覆盖。

---

### 里程碑 2：输入状态机、游标排版与核心控件套件（9月12日 – 9月15日）

* **核心目标**：实现即时模式核心运行循环、分层 ID 哈希系统与首批可交互控件。
* **交付清单**：
  - [ ] **分层 ID 哈希体系** (`id.mbt`)：`Id` 64 位哈希计算、`push_id` / `pop_id` 作用域命名空间栈；
  - [ ] **交互状态机** (`context.mbt`)：`hot_id`（悬浮）、`active_id`（按住拖拽）、`focused_id`（键盘聚焦）生命周期演进；
  - [ ] **单向流式游标排版引擎** (`layout.mbt`)：纵向单向推进、横向流式嵌套（`horizontal`）、间距与弹性留白（`spacing`, `separator`）；
  - [ ] **交互响应对象** (`response.mbt`)：`Response` 链式状态判断（`clicked`, `hovered`, `dragged`）；
  - [ ] **核心基础控件套件** (`widget_*.mbt`)：
    - 文本类：`label`, `heading`, `code`
    - 按钮类：`button`, `primary_button`, `small_button`
    - 开关类：`checkbox`, `toggle`
    - 数值类：`slider_float`, `slider_int`, **Blender 同款 `drag_float`**
    - 进度类：`progress_bar`, `sparkline`
* **验收标准**：
  - 无头 CI 模拟环境测试通过：断言在指针按下、移动与释放时控件的 `Response` 准确触发。

---

### 里程碑 3：视窗管理、高级容器与矩形裁剪栈（9月16日 – 9月18日）

* **核心目标**：支撑桌面级多窗口应用布局，解决复杂场景下的视觉层叠与滚动裁剪。
* **交付清单**：
  - [ ] **浮动可拖拽视窗** (`window.mbt`)：
    - 视窗标题栏 AABB 拖拽命中判定与原点位置持久化更新；
    - 视窗最小化/展开折叠切换；
    - 多视窗交互时的动态 Z-Index 焦点置顶提升；
  - [ ] **全局顶层菜单栏** (`menu_bar.mbt`)：`menu_bar`, `menu`, `menu_item` 下拉弹出机制；
  - [ ] **树形折叠分组** (`collapsing.mbt`)：`collapsing_header` 状态保持与动态收纳；
  - [ ] **视口裁剪栈系统** (`clip.mbt`)：`ClipStack` 嵌套矩形相交计算，超视口图元直接舍弃（Culling）；
  - [ ] **滚动区域** (`scroll_area.mbt`)：鼠标滚轮驱动纵向平滑滚动。
* **验收标准**：
  - 多窗口层叠拖拽测试通过，下层视窗的控件不发生穿透点击，裁剪边界内外的指令被准确拦截。

---

### 里程碑 4：HTML5 Canvas 2D 桥接驱动与在线演示（9月19日 – 9月21日）

* **核心目标**：打通浏览器渲染管线，上线运行在 GitHub Pages 上的震撼交互式演示。
* **交付清单**：
  - [ ] **Canvas 2D 宿主驱动器** (`driver/canvas2d.ts`)：
    - 轻量 JavaScript 桥接层，接收 Wasm `DrawCmd` 指令并高速光栅化；
    - 映射浏览器原生 `PointerEvent`, `WheelEvent`, `KeyboardEvent` 到 `RawInput`；
    - 60 FPS `requestAnimationFrame` 驱动主循环；
  - [ ] **底层 2D 自由矢量手绘** (`painter.mbt`)：直接提交线段、矩形、圆弧、贝塞尔曲线图元；
  - [ ] **全功能 Showcase 演示应用** (`cmd/main/main.mbt`)：
    - 属性检视窗：实时调节物理参数、按钮操作、数值滚轮；
    - 实时遥测窗：60 FPS 动态帧率计数、实时荧光 `Sparkline` 波形波动图；
    - 矢量自绘区：旋转几何图案或游戏 HUD 准心；
  - [ ] **GitHub Pages 自动化静态部署**：配置 GitHub Actions 一键构建并上线静态页面。
* **验收标准**：
  - 评委点击 GitHub Pages 链接可在 100ms 内瞬间完成加载（Wasm < 50KB）；
  - 60 FPS 稳定流畅拖拽，无卡顿无内存泄漏。

---

### 里程碑 5：极限稳定性压测、性能基准与最终版本验收（9月22日 – 9月24日）

* **核心目标**：达成工业级代码质量，完善最终提交物。
* **交付清单**：
  - [ ] **高覆盖率自动化测试**：达成 150+ 自动化单元测试（涵盖 AABB 边缘相交、ID 冲突防御、滚动越界等极端边界）；
  - [ ] **性能基准评测 (Benchmarks)**：单帧渲染 200+ 复合控件耗时稳定控制在 1.0ms 以内（远低于 16.6ms 帧预算）；
  - [ ] **接口规范冻结**：运行 `moon info` 固化 `.mbti` 契约，确保无隐藏 Breaking Change；
  - [ ] **交付版本打标**：发布 `v0.1.0` 正式版 Release。
* **验收标准**：
  - 全量 CI 流水线测试与格式检查 100% 绿灯通过；
  - 文档、在线演示、测试用例全部完备就绪，达到顶级开源项目交付水准。

---

## 2. 赛后长期演进路线（Post-Hackathon Vision）

黑客松比赛结束后，`moon-egui` 将作为 MoonBit 官方生态中最核心的即时 GUI 基础设施持续演进：

### v0.2.0：硬件加速渲染管线
* **WebGL / WebGPU 批量实例化合批渲染器**：将 `DrawCmd` 直接编译为顶点与索引缓冲区（Vertex & Index Buffers），支持超大规模海量控件同时光栅化（10,000+ 图元稳定 60 FPS）。

### v0.3.0：IDE 级高级排版系统
* **视窗停靠系统 (Docking System)**：支持多窗口拖拽拆分、磁吸停靠与多标签页（Tabs）布局，满足专业 Web IDE 和复杂开发工具需求；
* **富文本与语法高亮输入框**：支持多行文字编辑、语法色彩标记与选区光标操作。

### v0.4.0：跨平台原生端支持 (Native Desktop)
* **Raylib / SDL2 / Minifb 原生后端接入**：借助 MoonBit 原生编译能力（C/LLVM 后端），一套 UI 代码直接编译为 Windows / macOS / Linux 桌面原生 GUI 软件。

### v1.0.0：MoonBit 游戏与工业工具标准图形套件
* 深度整合 MoonBit 游戏生态（如 WASM-4、Raylib-mbt），成为全语言首选的内嵌式即时调试界面、游戏 HUD 与工业数据监控标准库。
