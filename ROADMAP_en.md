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

### Milestone 1: Scaffolding & Mathematical Foundation (Sep 9 – Sep 11)

* **Objective**: Establish pure algebraic data types, headless architecture, and zero-dependency mathematical foundations.
* **Deliverables**:
  - [x] Apache-2.0 licensing, clean package layout, and automated GitHub Actions CI pipeline;
  - [x] Bilingual technical whitepapers (`ARCHITECTURE`, `API_DESIGN`, `DESIGN_SYSTEM`, `STYLE_GUIDE`);
  - [ ] **Geometric Math** (`geom.mbt`): `Vec2` arithmetic, `Rect` (AABB) spatial algorithms (`contains`, `intersects`, `intersect`, `expand`, `shrink`);
  - [ ] **Color & Drawing Primitives** (`color.mbt`, `draw_cmd.mbt`): RGBA `Color` model, hex parsing, `DrawCmd` enum, and double-buffered `DrawList`;
  - [ ] **Input Protocol** (`input.mbt`): Normalized `RawInput` capturing pointer positions, button masks, and keys.
* **Acceptance Criteria**:
  - `moon check` and `moon fmt --check` pass with zero warnings;
  - `geom_test.mbt` and `color_test.mbt` pass with 100% test coverage.

---

### Milestone 2: Input State Machine, Layout & Core Widgets (Sep 12 – Sep 15)

* **Objective**: Implement immediate-mode frame execution, hierarchical ID hashing, and interactive controls.
* **Deliverables**:
  - [ ] **Hierarchical ID System** (`id.mbt`): 64-bit ID hashing, `push_id` / `pop_id` namespace stacks;
  - [ ] **Input State Machine** (`context.mbt`): Deterministic transitions for `hot_id` (hover), `active_id` (drag), and `focused_id` (keyboard);
  - [ ] **Linear Cursor Layout Engine** (`layout.mbt`): Single-pass cursor advancement, horizontal nesting (`horizontal`), spacing, and separators;
  - [ ] **Response Record** (`response.mbt`): Chainable interaction inspection (`clicked`, `hovered`, `dragged`);
  - [ ] **Core Widget Suite** (`widget_*.mbt`):
    - Text: `label`, `heading`, `code`
    - Buttons: `button`, `primary_button`, `small_button`
    - Toggles: `checkbox`, `toggle`
    - Value Inputs: `slider_float`, `slider_int`, Blender-style `drag_float`
    - Feedback: `progress_bar`, `sparkline`
* **Acceptance Criteria**:
  - Headless CI unit tests confirm that pointer-down, move, and release events trigger correct `Response` states.

---

### Milestone 3: Windowing, Advanced Containers & Scissor Clipping (Sep 16 – Sep 18)

* **Objective**: Support multi-window layouts with dynamic Z-Index elevation and scissor clipping masks.
* **Deliverables**:
  - [ ] **Floating Windows** (`window.mbt`):
    - Draggable title bar with AABB hit-testing and persistent origin tracking;
    - Window collapse and close toggles;
    - Dynamic Z-Index elevation bringing clicked windows to the foreground;
  - [ ] **Global Application Menu Bar** (`menu_bar.mbt`): `menu_bar`, `menu`, `menu_item` dropdown system;
  - [ ] **Collapsible Sections** (`collapsing.mbt`): `collapsing_header` with state memory;
  - [ ] **Scissor Clip Stack** (`clip.mbt`): `ClipStack` intersecting nested bounding boxes and culling out-of-bounds primitives;
  - [ ] **Scroll Area** (`scroll_area.mbt`): Smooth mouse-wheel scrolling inside clipped viewports.
* **Acceptance Criteria**:
  - Multi-window tests confirm background windows cannot be clicked through, and clipped content is properly masked.

---

### Milestone 4: HTML5 Canvas 2D Backend & Live Interactive Demo (Sep 19 – Sep 21)

* **Objective**: Connect the pure Wasm engine to the browser and launch a live interactive GitHub Pages playground.
* **Deliverables**:
  - [ ] **Canvas 2D Host Driver** (`driver/canvas2d.ts`):
    - Ultra-compact JS bridge consuming `DrawCmd` stream and rasterizing to Canvas 2D;
    - Translating native `PointerEvent`, `WheelEvent`, and `KeyboardEvent` into `RawInput`;
    - 60 FPS animation loop driven by `requestAnimationFrame`;
  - [ ] **Custom 2D Painter API** (`painter.mbt`): Direct vector drawing for lines, rectangles, circles, and bezier curves;
  - [ ] **Full Showcase Demo Application** (`cmd/main/main.mbt`):
    - Control & Inspector Window: Interactive physics parameters, buttons, toggles, and scrubbers;
    - Performance & Telemetry Window: Real-time 60 FPS readout and glowing `Sparkline` waveform;
    - 2D Vector Demo: Rotating geometric particle ring or HUD crosshair;
  - [ ] **Automated GitHub Pages Deployment**: GitHub Actions workflow to build and publish the static demo.
* **Acceptance Criteria**:
  - Live demo loads in under 100ms (<50KB Wasm binary);
  - Rock-solid 60 FPS rendering with zero memory leaks or GC stutter.

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
  - Pristine codebase ready for hackathon evaluation and open-source community adoption.

---

## 2. Post-Hackathon Long-Term Vision

Following the hackathon, `moon-egui` will continue to evolve as the primary GUI foundation for MoonBit:

### v0.2.0: Hardware-Accelerated Rendering Pipeline
* **WebGL / WebGPU Instanced Batch Renderer**: Compile `DrawCmd` directly into vertex and index buffers, supporting massive scale (10,000+ primitives at 60 FPS).

### v0.3.0: Desktop-Grade Workspace Layouts
* **Docking System**: Tabbed windows, split panes, and docking zones for building professional Web IDEs and tools;
* **Rich Text & Code Input**: Multi-line text editing with syntax highlighting and text selection.

### v0.4.0: Cross-Platform Native Desktop
* **Raylib / SDL2 Backends**: Leverage MoonBit's native C/LLVM backend to build standalone desktop GUI applications for Windows, macOS, and Linux from a single codebase.

### v1.0.0: The Standard GUI Framework for MoonBit
* Seamless integration with MoonBit game engines (WASM-4, Raylib-mbt) as the standard embedded immediate-mode GUI library.
