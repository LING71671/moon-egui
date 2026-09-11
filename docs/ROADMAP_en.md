# Moon-EGUI Development Roadmap & Milestones

<p>
  <a href="ROADMAP.md">简体中文</a> · <a href="ROADMAP_en.md">English</a>
</p>

> Comprehensive development roadmap, milestones, acceptance criteria, and long-term vision for `moon-egui` (MoonBit September Hackathon 2026 and beyond).

---

## 1. Hackathon Execution Timeline (Sep 9 – Sep 24, 2026)

```
2026.09.09          09.11           09.15           09.18           09.21           09.24
    │───────────────│───────────────│───────────────│───────────────│───────────────│
    [Milestone 1]   [Milestone 2]   [Milestone 3]   [Milestone 4]   [Milestone 5]
    Scaffolding &   State Machine   Windowing &     Canvas 2D &     Hardening &
    Math Primitives & Core Widgets  Clip Stack      Live Demo       Final Release
```

---

### Milestone 1: Scaffolding & Mathematical Foundation (Sep 9 – Sep 11) [Delivered]

* **Objective**: Establish pure algebraic data types, headless architecture, and zero-dependency mathematical foundations.
* **Deliverables**:
  - [x] Apache-2.0 licensing, clean package layout, and automated GitHub Actions CI pipeline;
  - [x] Bilingual technical whitepapers (`ARCHITECTURE`, `API_DESIGN`, `DESIGN_SYSTEM`, `STYLE_GUIDE`);
  - [x] **Geometric Math** (`src/math/`): `Vec2` arithmetic, `Rect` (AABB) spatial algorithms (`contains`, `intersects`, `intersect`, `expand`, `shrink`);
  - [x] **Color & Drawing Primitives** (`src/color/`, `src/draw/`): RGBA `Color` model, hex parsing, `DrawCmd` enum, and `DrawList` command queue;
  - [x] **Input Protocol** (`src/core/input.mbt`): Normalized `RawInput` capturing pointer positions and button masks.
* **Acceptance Criteria**:
  - [x] `moon fmt --check` passes and `moon check` reports 0 errors / 0 warnings
        (the key and text events have been driven for real by the CAD demo host
        since 2026-09-11, so the protocol no longer carries unused variants);
  - [x] `src/math/` and `src/core/` pass with comprehensive test coverage.

---

### Milestone 2: Input State Machine, Layout & Core Widgets (Sep 12 – Sep 15) [Delivered]

* **Objective**: Implement immediate-mode frame execution, hierarchical ID hashing, and interactive controls.
* **Deliverables**:
  - [x] **Hierarchical ID System** (`src/core/id.mbt`): 64-bit ID hashing, `push_id` / `pop_id` namespace stacks;
  - [x] **Input State Machine** (`src/core/context.mbt`): Deterministic transitions for `hot_id` (hover), `active_id` (drag) and `allocate_space`;
  - [x] **Multi-Directional Layout Stacks** (`src/core/context.mbt`): Vertical and scoped horizontal layout flows (`horizontal`), spacing, and separators;
  - [x] **Response Record** (`src/core/response.mbt`): Chainable interaction inspection (`clicked`, `hovered`, `pressed`, `dragged`);
  - [x] **Delivered Core Widgets & Sliders** (`src/core/widgets.mbt`):
    - [x] Text: `label`, `label_colored`
    - [x] Buttons: `button`, `button_primary`
    - [x] Toggles: `checkbox`
    - [x] Numeric inputs: continuous `slider` and stepped `slider_int`
    - [x] Layout: `separator`, `spacer`
* **Acceptance Criteria**:
  - [x] Headless CI unit tests confirm that pointer-down, move, and release events trigger correct `Response` states and slider interpolation (22 tests pass).

---

### Milestone 3: Windowing, Advanced Containers & Scissor Clipping (Sep 16 – Sep 18) [In Progress]

* **Objective**: Support multi-window layouts with dynamic Z-Index elevation and scissor clipping masks.
* **Deliverables**:
  - [x] **Window Container Prototype** (`src/core/window.mbt`):
    - [x] Background card, border, header bar, and title rendering;
    - [x] Local cursor origin scoping and scissor viewport clipping (`push_clip` / `pop_clip`);
    - [x] Title bar draggable AABB hit-testing and persistent position tracking;
    - [x] Dynamic Z-Index elevation bringing clicked windows to foreground;
  - [ ] **Global Application Menu Bar** (`menu_bar.mbt`): `menu_bar`, `menu`, `menu_item` dropdown system;
  - [x] **Collapsible Sections** (`containers.mbt`): `collapsing_header` with state memory;
  - [x] **Scissor Clip Stack** (`src/draw/draw_cmd.mbt`): `push_clip` / `pop_clip` intersecting nested bounding boxes and culling out-of-bounds primitives;
  - [x] **Scroll Area** (`scroll_area.mbt`): Smooth mouse-wheel scrolling inside clipped viewports.
* **Acceptance Criteria**:
  - Multi-window tests confirm background windows cannot be clicked through, and clipped content is properly masked.

---

### Milestone 4: HTML5 Canvas 2D Backend & Live Interactive Demo (Sep 19 – Sep 21) [Delivered Ahead]

* **Objective**: Connect the pure Wasm engine to the browser and launch a live interactive GitHub Pages playground.
* **Deliverables**:
  - [x] **Canvas 2D Host Driver** (`examples/canvas/run.js`):
    - [x] Ultra-compact JS bridge consuming `DrawCmd` stream and rasterizing to Canvas 2D;
    - [x] Translating native `PointerEvent`, `WheelEvent` into `RawInput`;
    - [x] 60 FPS animation loop driven by `requestAnimationFrame`, with independent `Kernel` and `Render` telemetry metrics;
  - [x] **Million-Node Canvas Benchmark** (`examples/canvas/main.mbt`):
    - [x] Managing 128² to 1024² (1,048,576) logical node arrays;
    - [x] O(1) viewport spatial culling + multi-scale adaptive LOD baked textures;
    - [x] CAD dual-axis rulers and dynamic wave/repel physics;
  - [x] **Automated GitHub Pages Deployment**: GitHub Actions workflow to build and publish the static demo.
* **Acceptance Criteria**:
  - [x] Live demo loads in under 100ms;
  - [x] Rock-solid 60 FPS rendering with zero memory leaks or GC stutter.

---

### Milestone 5: Hardening, Benchmarking & Official Release (Sep 22 – Sep 24)

* **Objective**: Deliver production-grade quality, comprehensive documentation, and official v0.1.0 release.
* **Deliverables**:
  - [ ] **Extensive Test Coverage**: 150+ automated unit and integration tests covering edge cases;
  - [ ] **Performance Benchmarks**: Sustained frame budget under 1.0ms for 200+ active widgets;
  - [ ] **Interface Stabilization**: Freeze `.mbti` contract via `moon info` to guarantee zero breaking changes;
  - [ ] **Release Packaging**: Tag and publish `v0.1.0` GitHub release with live demo links.
* **Acceptance Criteria**:
  - 100% passing CI suite (formatting, build, test, Wasm compilation);
  - Complete documentation, runnable demo, and test suite fulfilling all hackathon goals.

---

## 2. Future Work

- **Hardware-Accelerated Rendering**: Explore WebGL / WebGPU batch rendering pipelines to minimize rasterization overhead for large primitive counts;
- **Advanced Containers & Layouts**: Explore multi-window docking and tabbed layout capabilities;
- **Cross-Platform Native Backends**: Leverage MoonBit's native compilation to explore desktop backends (Raylib, SDL).
