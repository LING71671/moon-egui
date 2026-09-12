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
  - Keyboard-only navigation smoothly cycles through interactive controls with passing headless test suites (167/167 tests passing).

---

### Milestone 6: Workstation Layout & Docking Architecture (Sep 16 – Sep 18)

* **Objective**: Advance from isolated windows to flexible, multi-viewport workspace partitioning.
* **Deliverables**:
  - [ ] **Nested Draggable Splitter (`SplitPane`)**: Horizontal and vertical viewport splits with ratio preservation and minimum dimension guards;
  - [ ] **Window Docking & Snapping Prototype (`Docking`)**: Drop guide visual previews when dragging near viewport edges and tabbed pane grouping;
  - [ ] **Damped Momentum Physics (`Spring Physics`)**: Controlled physical spring-damper easing for window dragging and scrolling.
* **Acceptance Criteria**:
  - Windows snap cleanly into tiled docks and split panes preserve proportional layouts across window resizing.

---

### Milestone 7: Data-Dense Components & Visualization Engine (Sep 19 – Sep 21)

* **Objective**: Validate immediate-mode performance under heavy data volume and topological graph structures.
* **Deliverables**:
  - [ ] **Virtualized Data Table (`VirtualTable`)**: Viewport-culled rasterization processing tens of thousands of rows with column resizing and sorting;
  - [ ] **Node-Based Blueprint Editor Prototype (`NodeEditor`)**: Infinite canvas, node dragging, port connection validation, and smooth cubic Bezier link splines;
  - [x] **Engineering Plotting Suite (`Plot` / `Sparkline`)** [Delivered]: Multi-series plotting (Line, Scatter, Area) and bar charts (`BarChart`) with adaptive grid lines, numeric tick labels, crosshairs, and data hover tooltips;
  - [ ] **Vector SVG Exporter (`SvgExporter`)**: Export active frame command streams into clean, standard `.svg` vector files.
* **Acceptance Criteria**:
  - Sustained 60 FPS under large data sets and multi-node connection graphs with stable memory footprints.

---

### Milestone 8: Hardware-Accelerated Rendering & Production Scenarios (Sep 22 – Sep 24)

* **Objective**: Explore hardware acceleration feasibility and provide real-world reference application shells.
* **Deliverables**:
  - [ ] **WebGL 2.0 Batched Geometry Pipeline**: Prototype assembling vertex and index buffers in Wasm to batch UI primitives into single GPU draw calls;
  - [ ] **Reference Application Showcase (Deployed to Gallery)**:
    - CAD mechanical vector workbench (rulers, snapping, inspector);
    - Node-based visual logic stream demo;
    - Audio synthesizer / timeline studio prototype;
    - Lightweight online code workstation shell.
* **Acceptance Criteria**:
  - All reference demos run smoothly on the interactive showcase gallery with clear architectural patterns.

---

### Milestone 9: Verification, Benchmarking & Official Release (Sep 25)

* **Objective**: Ensure industrial code reliability, freeze API contracts, and finalize project deliverables.
* **Deliverables**:
  - [x] **Expanded Test Suite** [Delivered]: Reach 167 automated whitebox and blackbox test cases (100% passing rate);
  - [ ] **Micro-Benchmark Telemetry (Benchmarks)**: Measure nanosecond and microsecond compute budgets across typical workloads;
  - [ ] **Interface Stabilization**: Run `moon info && moon fmt`, freeze `.mbti` signatures, and finalize bilingual documentation;
  - [ ] **Release Packaging**: Tag and publish official `v0.2.0` release.
* **Acceptance Criteria**:
  - 100% passing CI workflow with complete documentation, demos, and test suites archived.

---

## 2. Future Work

- **Multi-Backend Maturation**: Deepen WebGL / WebGPU custom shader pipelines and texture atlas support;
- **Native Desktop Backends**: Explore desktop windowing bindings (Raylib / SDL3) via MoonBit native targets;
- **Vertical Domain Widgets**: Expand immediate-mode widget offerings for scientific computing, robotics telemetry, and game tools.

