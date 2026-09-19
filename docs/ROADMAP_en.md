# Moon-EGUI Development Roadmap & Milestones

<p>
  <a href="ROADMAP.md">简体中文</a> · <a href="ROADMAP_en.md">English</a>
</p>

> Comprehensive development roadmap, milestones, acceptance criteria, and long-term vision for `moon-egui` (MoonBit September Hackathon 2026 and beyond).

---

## 1. Hackathon Execution Timeline (Sep 9 – Sep 24, 2026)

```
2026.09.09         09.11                  09.15              09.18              09.21              09.24         09.25
    │──────────────│──────────────────────│──────────────────│──────────────────│──────────────────│─────────────│
   [Phase 1: M1-M4]       [M5: Desktop Input]    [M6: Workstation]  [M7: Dense Data &] [M8: Hardware Accel] [M9: Release]
   [Delivered]            [System & Focus]       [Docking & Split]  [Visualization]    [& Scenario Demos]   [v0.2.0]
```

---

### Phase 1 Retrospective: Scaffolding & Foundation Suite (Sep 9 – Sep 11) [All Delivered]

Over the initial 3-day sprint, the first four milestones were completed and accepted in production ahead of schedule:
- **Milestone 1: Scaffolding & Mathematical Foundation** (`src/math/`, `src/color/`, `src/draw/`) [Delivered]
- **Milestone 2: Input State Machine, Layout & Core Widgets** (`src/core/`) [Delivered]
- **Milestone 3: Windowing, Advanced Containers & Scissor Clipping** (`window.mbt`, `menu_bar.mbt`, `containers.mbt`) [Delivered]
- **Milestone 4: HTML5 Canvas 2D Backend & Live Interactive Demo** (`examples/canvas/`) [Delivered]

---

### Phase 2 Planning: Deep Workstation & Industrial Capabilities (Sep 12 – Sep 25)

Rooted in MoonBit's language strengths and drawing from mature immediate-mode GUI practices (such as Dear ImGui and egui), the upcoming two weeks will systematically establish robust infrastructure for complex desktop and workstation environments:

---

### Milestone 5: Desktop Input System & Productivity Controls (Sep 12 – Sep 15)

* **Objective**: Reach parity with professional desktop UX standards, establishing robust keyboard focus navigation and contextual interactions.
* **Deliverables**:
  - [x] **Command Palette Prototype (`CommandPalette` / `⌘K`)** [Delivered]: Fuzzy action search, history tracking, and keyboard-driven command dispatch;
  - [x] **Context Menu & Cascading Submenus (`ContextMenu` / `SubMenu`)** [Delivered]: In-place right-click menu with multi-level hover expansion and boundary flipping;
  - [x] **Multi-line Text & Code Editing (`CodeEditor`)** [Delivered]: Multi-line layouts, line numbering column, cursor selection, and clipboard coordination;
  - [x] **Hierarchical Tree View (`TreeView` / `TreeNode`)** [Delivered]: Multi-level nesting, expansion memory, indentation guide lines, and item selection;
  - [x] **Specialized Numerical Regulators: Rotary Knob (`Knob`)** [Delivered]: 270-degree physical arc sweep, unipolar/bipolar fills, vertical drag delta, and Alt+Click reset;
  - [x] **100% Native Canvas Gallery Engine Refactoring** [Delivered]: Component gallery fully powered by pure MoonBit WebAssembly/Canvas immediate-mode pipeline, eliminating simulated DOM and CSS;
  - [x] **Linear Fader Regulator (`Fader`)** [Delivered]: Linear channel slider for audio gain and continuous parameters, with calibrated ticks, vertical drag delta, scroll wheel, and Alt+Click reset (Milestone 5 100% Delivered).
* **Acceptance Criteria**:
  - Keyboard-only navigation smoothly cycles through interactive controls with passing headless test suites (211/211 tests passing).

---

### Milestone 6: Workstation Layout & Docking Architecture (Sep 16 – Sep 18)

* **Objective**: Advance from isolated windows to flexible, multi-viewport workspace partitioning.
* **Deliverables**:
  - [x] **Nested Draggable Splitter (`SplitPane` / `splitter.mbt`)** [Delivered]: Horizontal and vertical viewport splits with ratio preservation and minimum dimension guards;
  - [x] **Multi-Window Docking & Snapping System (`DockArea` / `dock.mbt`)** [Delivered]: Hierarchical DockTree workspace partitioning with draggable splitters, tab switching/closing, and Scissor clipping;
  - [x] **Damped Momentum Physics (`Spring Physics` / `spring.mbt`)** [Delivered]: Controlled physical spring-damper easing for window dragging and scrolling with equilibrium detection;
* **Acceptance Criteria**:
  - Windows snap cleanly into tiled docks and split panes preserve proportional layouts across window resizing (327/327 tests passing).

---

### Milestone 7: Data-Dense Components & Visualization Engine (Sep 19 – Sep 21)

* **Objective**: Validate immediate-mode performance under heavy data volume and topological graph structures.
* **Deliverables**:
  - [x] **Virtualized Data Table (`VirtualTable` / `Table`)** [Delivered]: Viewport-culled rasterization processing tens of thousands of rows with column resizing and sorting;
  - [x] **1D Virtualized List Container (`VirtualList` / `virtual_list.mbt`)** [Delivered]: Dynamic visible window index slicing with overscan buffer for high-cardinality lists;
  - [x] **Node-Based Blueprint Editor Prototype (`NodeEditor`)** [Delivered]: Infinite canvas, node dragging, port connection validation, and smooth cubic Bezier link splines;
  - [x] **Engineering Plotting Suite (`Plot` / `Sparkline`)** [Delivered]: Multi-series plotting (Line, Scatter, Area) and bar charts (`BarChart`) with adaptive grid lines, numeric tick labels, crosshairs, and data hover tooltips;
  - [x] **Vector SVG Exporter (`SvgExporter` / `svg_exporter.mbt`)** [Delivered]: Lossless serialization of active frame draw command streams into clean, standard `.svg` vector files.
* **Acceptance Criteria**:
  - Sustained 60 FPS under large data sets and multi-node connection graphs with stable memory footprints.

---

### Milestone 8: Hardware-Accelerated Rendering & Production Scenarios (Sep 22 – Sep 24)

* **Objective**: Explore hardware acceleration feasibility and provide production-grade reference applications.
* **Deliverables**:
  - [x] **WebGL 2.0 Batched Rendering Backend (`src/draw/mesh.mbt`)** [Delivered]: Contiguous vertex/index buffer organization and 2D primitive triangulation (rects, circles, lines) in Wasm memory for unified batched draw dispatch;
  - [x] **Showcase Reference Applications (Live in Gallery)**:
    - Interactive 2D CAD Vector Drafting Workbench (ruler metrics, magnetic snapping, inspector) [Delivered];
    - 1,000,000-Cell Streaming Minesweeper Engine [Delivered];
    - Lightweight Online Code Workspace Prototype (`code_workspace.html`, multi-file explorer, live code editor, interactive terminal) [Delivered].
* **Acceptance Criteria**:
  - Reference applications run smoothly in the gallery showcase with idiomatic, decoupled component architectures.

---

### Milestone 9: Quality Engineering, Benchmarking & Stable Releases (Sep 25)

* **Objective**: Enforce strict engineering standards to ensure library reliability and deliver tagged milestones.
* **Deliverables**:
  - [x] **Automated Test Suite Expansion** [Delivered]: 335/335 whitebox and blackbox headless test cases passing (100% pass rate);
  - [x] **Large-Scale Performance Benchmark Suite** [Delivered]: 50,000-row stress testing verifying sub-millisecond viewport slicing and in-place sorting;
  - [x] **Interface Stabilization**: Run `moon info && moon fmt`, freeze `.mbti` signatures, and finalize bilingual documentation;
  - [x] **Release Packaging** [Delivered]: Tag and publish the `v0.5.1` release (delivering 100% pure Canvas Studio IDE, dynamic viewport modal scrims, and layout geometry polish).
* **Acceptance Criteria**:
  - 100% passing CI workflow with complete documentation, demos, and test suites archived.

---

## 2. Future Work

- **Multi-Backend Maturation**: Deepen WebGL / WebGPU custom shader pipelines and texture atlas support;
- **Native Desktop Backends**: Explore desktop windowing bindings (Raylib / SDL3) via MoonBit native targets;
- **Vertical Domain Widgets**: Expand immediate-mode widget offerings for scientific computing, robotics telemetry, and game tools.

