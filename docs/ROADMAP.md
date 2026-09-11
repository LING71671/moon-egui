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

### 里程碑 1：工程骨架与基础数学图元（9月9日 – 9月11日）[已交付]

* **核心目标**：建立严谨无全局状态的代数数据结构与零依赖数学计算底座。
* **交付清单**：
  - [x] 确立 Apache-2.0 协议、规范化目录组织与自动化 CI 流水线；
  - [x] 编写中英双语技术白皮书（`ARCHITECTURE`、`API_DESIGN`、`DESIGN_SYSTEM`、`STYLE_GUIDE`）；
  - [x] **几何数学模块** (`src/math/`)：`Vec2` 向量运算、`Rect` (AABB) 空间几何计算（`contains`, `intersects`, `intersect`, `expand`, `shrink`）；
  - [x] **颜色与图元系统** (`src/color/`, `src/draw/`)：RGBA `Color` 模型、十六进制色值解析、`DrawCmd` 平台无关指令枚举与 `DrawList` 队列；
  - [x] **输入原始流结构** (`src/core/input.mbt`)：归一化 `RawInput` 与按键/鼠标指针抽象。
* **验收标准**：
  - [x] `moon fmt --check` 通过、`moon check` 0 error / 0 warning
        （按键与文本事件自 2026-09-11 起由 CAD 演示宿主真实驱动，协议不再有未使用变体）；
  - [x] `src/math/` 与 `src/core/` 基础数学单测 100% 覆盖。

---

### 里程碑 2：输入状态机、游标排版与核心控件套件（9月12日 – 9月15日）[已交付]

* **核心目标**：实现即时模式核心运行循环、分层 ID 哈希系统与核心控件套件。
* **交付清单**：
  - [x] **分层 ID 哈希体系** (`src/core/id.mbt`)：`Id` 64 位哈希计算、`push_id` / `pop_id` 作用域命名空间栈；
  - [x] **交互状态机** (`src/core/context.mbt`)：`hot_id`（悬浮）、`active_id`（按住拖拽）生命周期演进与 `allocate_space` 空间分配；
  - [x] **多向流式排版栈** (`src/core/context.mbt`)：纵向单向推进、横向行内排版流（`horizontal`）、间距与弹性留白（`separator`, `spacer`）；
  - [x] **交互响应对象** (`src/core/response.mbt`)：`Response` 链式状态判断（`clicked`, `hovered`, `pressed`, `dragged`）；
  - [x] **已交付基础控件与调节器** (`src/core/widgets.mbt`)：
    - [x] 文本类：`label`, `label_colored`
    - [x] 按钮类：`button`, `button_primary`
    - [x] 开关类：`checkbox`
    - [x] 数值类：`slider`（连续浮点滑动）、`slider_int`（步进整型滑动）
    - [x] 排版类：`separator`, `spacer`
* **验收标准**：
  - [x] 无头 CI 模拟环境测试通过：断言在指针按下、移动与释放时控件的 `Response` 与连续拖拽数值准确触发（22 项测试全通）。

---

### 里程碑 3：视窗管理、高级容器与矩形裁剪栈（9月16日 – 9月18日）[推进中]

* **核心目标**：支撑桌面级多窗口应用布局，解决复杂场景下的视觉层叠与滚动裁剪。
* **交付清单**：
  - [x] **视窗容器原型** (`src/core/window.mbt`)：
    - [x] 独立背景绘制、边框、标题栏 Header 与标题文本渲染；
    - [x] 内容区域局部坐标原点重映射与 Scissor 视口隔离裁剪（`push_clip` / `pop_clip`）；
    - [x] 视窗标题栏 AABB 拖拽命中判定与原点位置持久化更新；
    - [x] 多视窗交互时的动态 Z-Index 焦点置顶提升；
  - [ ] **全局顶层菜单栏** (`menu_bar.mbt`)：`menu_bar`, `menu`, `menu_item` 下拉弹出机制；
  - [x] **树形折叠分组** (`containers.mbt`)：`collapsing_header` 状态保持与动态收纳；
  - [x] **视口裁剪栈系统** (`src/draw/draw_cmd.mbt`)：`push_clip` / `pop_clip` 嵌套相交计算，超视口图元舍弃；
  - [x] **滚动区域** (`scroll_area.mbt`)：鼠标滚轮驱动纵向平滑滚动。
* **验收标准**：
  - 多窗口层叠拖拽测试通过，下层视窗的控件不发生穿透点击，裁剪边界内外的指令被准确拦截。

---

### 里程碑 4：HTML5 Canvas 2D 桥接驱动与在线演示（9月19日 – 9月21日）[已提前交付]

* **核心目标**：打通浏览器渲染管线，上线运行在 GitHub Pages 上的震撼交互式演示。
* **交付清单**：
  - [x] **Canvas 2D 宿主驱动器** (`examples/canvas/run.js`)：
    - [x] 轻量 JavaScript 桥接层，接收 `DrawCmd` 指令并高速光栅化；
    - [x] 映射浏览器原生 `PointerEvent`, `WheelEvent` 到 `RawInput`；
    - [x] 60 FPS `requestAnimationFrame` 驱动主循环，并独立测量展示 `Kernel` 与 `Render` 遥测耗时；
  - [x] **百万级逻辑节点大画布演示** (`examples/canvas/main.mbt`)：
    - [x] 管理 128² ~ 1024² (1,048,576) 逻辑节点大画布；
    - [x] O(1) 视口边界空间剔除 + 多尺度自适应 LOD 预烘焙技术；
    - [x] CAD 双轴刻度标尺与动态水波纹/排斥力学；
  - [x] **GitHub Pages 自动化静态部署**：配置 GitHub Actions 一键构建并上线静态页面。
* **验收标准**：
  - [x] 评委点击 GitHub Pages 链接可在 100ms 内瞬间完成加载；
  - [x] 60 FPS 稳定流畅拖拽，无卡顿无内存泄漏。

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
  - 核心文档、在线演示、单元测试全部就绪，完成黑客松全部目标交付。

---

## 2. 后续演进与技术探索 (Future Work)

- **硬件加速渲染探索**：研究 WebGL / WebGPU 批量绘制管线，降低海量图元下的光栅化开销；
- **高级容器与排版能力**：探索多窗口停靠（Docking）与分栏排版支持；
- **跨平台原生后端接入**：结合 MoonBit 原生编译能力，探索对接桌面原生图形后端（如 Raylib / SDL）。
