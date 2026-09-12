<div align="center">

# moon-egui

**A Lightweight Immediate-Mode GUI Library for MoonBit and WebAssembly**

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

## Overview

`moon-egui` is a lightweight **immediate-mode GUI (IMGUI) library** designed for the [MoonBit](https://www.moonbitlang.com/) programming language, targeting WebAssembly and HTML5 Canvas 2D graphics environments.

Inspired by Rust's `egui` and C++'s `Dear ImGui`, `moon-egui` follows the immediate-mode paradigm: **code is UI, and UI is state**. By evaluating the interface frame-by-frame declaratively, it delivers a direct developer experience, modest runtime footprint, and stable rendering.

### Why moon-egui?

When building interactive user interfaces within WebAssembly and HTML5 Canvas environments, developers typically face several trade-offs:

- **Maintenance burden of raw Canvas code**: Manually computing layout coordinates, writing hit-testing routines, and handling z-ordering quickly becomes verbose and error-prone.
- **Performance jitter of DOM / Virtual DOM**: In high-frequency 60 FPS graphical canvases, retained-mode UI trees incur cross-boundary overhead and garbage collection (GC) pauses.
- **Toolchain friction of C/C++ bindings**: FFI-based GUI wrappers introduce heavy external C toolchains and bloated binaries, breaking MoonBit's clean native package manager workflow.

### Key Features

- **Immediate-Mode Ergonomics**: UI is declared frame-by-frame with zero lifecycle callbacks or two-way synchronization. Handling user interactions is as simple as `if ui.button("Save").clicked { ... }`.
- **Zero FFI Dependencies**: 100% pure MoonBit with a headless core decoupled from host runtimes. Installable in one command (`moon add ling71671/moon-egui`).
- **Microsecond Frame Pipeline**: Viewport spatial culling and command batching keep per-frame kernel cost at ~0.1ms, maintaining a locked 60 FPS.
- **Production-Ready Widgets**: Movable windows with z-ordering and viewport clamping, tab bars, keyboard-driven text inputs, click-outside-dismiss combo boxes, and tooltips.

---

## Installation

```bash
# Install the latest stable release
moon add LING71671/moon-egui

# Or pin to an exact version
moon add LING71671/moon-egui@0.2.0
```

Import the layers you need in your `moon.pkg`: `src/core` is the bare immediate-mode runtime, `src/widgets` adds the standard controls, and `src/composite` the advanced components.

```json
{
  "import": [
    "LING71671/moon-egui/src/core",
    "LING71671/moon-egui/src/widgets",
    "LING71671/moon-egui/src/composite",
    "LING71671/moon-egui/src/draw",
    "LING71671/moon-egui/src/math",
    "LING71671/moon-egui/src/color"
  ]
}
```

---

## Live Demos

Experience the interactive capabilities and rendering performance of `moon-egui` in any modern browser:

- **[Interactive Demo Homepage](https://ling71671.github.io/moon-egui/)**
  Immediate-mode widgets showcase, application menu bar, floating inspector window, and lightweight canvas playground.
- **[Canvas & Multi-Scale Matrix Benchmark](https://ling71671.github.io/moon-egui/benchmark.html)**
  128² to 1024² (16,384 to 1,048,576 nodes) multi-scale pixel matrix, CAD dual-axis rulers, viewport pan & zoom navigation, and CAD pixel grid lines.

---

## Quick Example

```moonbit
fn update_ui(ui : &mut UIContext, state : &mut AppState) {
  // 1. Global top-level application menu bar
  ui.menu_bar(fn() {
    ui.menu("File", fn() {
      if ui.menu_item("New Project") { state.new_project() }
      if ui.menu_item("Save Config") { state.save() }
    })
    ui.menu("View", fn() {
      if ui.menu_item("Toggle Theme") { state.toggle_theme() }
    })
  })

  // 2. Floating draggable inspector window
  ui.window("Console & Properties", 50.0, 50.0, 300.0, 420.0, fn() {
    ui.label("Welcome to moon-egui")
    
    if ui.button("Trigger Action") {
      state.counter += 1
    }
    
    // Blender-style DragValue adjustment
    ui.drag_float("Gravity", &mut state.gravity, speed=0.1, min=0.0, max=20.0)
    ui.checkbox("Enable Collision", &mut state.collision_enabled)
    
    // Collapsible telemetry panel
    ui.collapsing_header("Runtime Monitor", fn() {
      ui.sparkline("FPS History", state.fps_history)
      ui.progress_bar(state.progress)
    })
  })
}
```

---

## Architecture

`moon-egui` separates UI logic from host rendering via a three-tier unidirectional pipeline:

```
[ Input Events ]
  • Pointer coordinates & button state
  • Keyboard keys & modifiers
  • Mouse wheel scroll delta
         │
         ▼
[ moon-egui Core ]
  • Input state machine (Hover, Active, Focused)
  • Linear cursor layout & AABB hit-testing
  • Scissor clip rectangle stack
  • Immediate-mode widget evaluation
         │
         ▼
[ DrawCmd Stream ]
  • DrawCmd::Rect(x, y, w, h, color, radius)
  • DrawCmd::Text(x, y, text, size, color)
  • DrawCmd::Line(x1, y1, x2, y2, color, width)
  • DrawCmd::Clip(x, y, w, h)
         │
         ▼
[ Render Backends ]
  • HTML5 Canvas 2D (Default Wasm bridge)
  • WebGL / WebGPU (Planned)
  • Native Windowing (Raylib / SDL / Minifb)
```

---

## Core Capabilities
 
### Available Now
- **Core Draw Engine**: Pure MoonBit implementation of `Vec2`, `Rect`, `Color`, and platform-agnostic `DrawCmd` stream, supporting rectangles, lines, circles, text, and nested scissor clip stacks.
- **Layout & Space Allocation**: `UIContext` manages `hot_id` / `active_id` state machine and layout scope stacks, supporting vertical and horizontal flow layouts (`horizontal`). `allocate_space()` computes geometry bounds and automatic cursor placement.
- **Core Widget Suite (35 Available Widgets)**:
  - **Inputs & Editing**: `button` (with keyboard shortcuts, primary/default variants, and custom sizing), `text_edit` (single-line porcelain text entry with hidden IME bridge), `code_editor` (multi-line code editor with line numbers, syntax styling, selection highlight, caret scroll, select-all, and shortcuts), `label` / `label_colored`.
  - **Selection & Values**: `checkbox` (precision toggle box), `toggle` (bistable capsule switch), `radio` (concentric option button), `slider` / `slider_int` (continuous/stepped numeric scrubbers), `drag_value` (fine-grained numeric drag with arrow navigation), `knob` (270° arc rotary dial), `fader` / `fader_int` (vertical channel fader regulator), `combo_box` (adaptive upward-flipping dropdown), `color_button` / `color_picker` (HSV color picker and palette).
  - **Feedback & Notifications**: `progress_bar` (smooth progress indicator), `badge` (status badges and dot indicators), `toast` (floating notification toasts with hover occlusion blocking), `tooltip` (floating bubble hints with boundary clipping prevention), `spinner` (rotary loading indicator).
  - **Data Visualization & Plotting**: `sparkline` (real-time telemetry sparkline), `plot` (immediate-mode plotting with line, scatter, and area series, dual-axis ticks, and crosshairs), `bar_chart` (adaptive bar chart).
  - **Advanced Navigation & Interactions**: `menu_bar` (desktop-grade menu bar), `context_menu` (recursive cascading multi-level right-click menu), `command_palette` (global fuzzy search palette), `tree_view` (hierarchical asset tree), `segmented_control` (pill segmented switcher), `breadcrumb` (hierarchical breadcrumb).
  - **Layout Spacing & Flow**: `separator` (hairline divider), `spacer` (flexible spacing), `horizontal_wrapped` (auto-wrapping flow layout).
- **Windows & Container Architecture**:
  - **Global Application Menu Bar**: `menu_bar`, `menu`, `menu_item`, `menu_separator` featuring isolated foreground layer projection, desktop-grade Hover-to-Switch transitions, and outside-click dismissal;
  - **Free-Floating Windows**: `window` supporting title-bar drag repositioning, dynamic Z-Index elevation, local coordinate scoping, and scissor clipping;
  - **Advanced Containers**: `splitter` (bidirectional draggable divider), `table` (high-performance virtualized data table with resizable columns), `collapsing_header` (tree groupings with persistent open memory), `scroll_area` (wheel and thumb draggable viewport scrolling), `tab_bar` (tab navigation), `dialog` (modal confirmation dialog with focus trap).
- **Headless & Automated Testing**: Core logic produces pure `DrawCmd` streams without browser bindings, backed by 211 automated headless unit and integration tests (100% passing).
- **Canvas 2D Host Driver**: Lightweight JavaScript bridge and 60 FPS rendering pipeline, coupled with O(1) viewport spatial culling and adaptive LOD architecture.

### Planned & In Roadmap
- **Hardware-Accelerated Backends**: WebGL / WebGPU batched geometry rasterizers and custom shader pipelines.
- **Cross-Platform Native Desktop**: Raylib / SDL3 windowing integration.
- **Node Graph & Flow Editing**: Node graph pipeline editor (`NodeEditor`).

---

## Development Roadmap (Sep 9 – Sep 25, 2026)

### Phase 1: Core Scaffolding & Foundation Suite (Sep 9 – Sep 11) [All Delivered]
- [x] **Milestone 1: Scaffolding & Mathematical Foundation**: `Vec2`, `Rect`, `Color`, `InputState`, `DrawCmd`, `DrawList`.
- [x] **Milestone 2: Input State Machine, Layout & Core Widgets**: AABB hit-testing, bi-directional layouts, `Button`, `Label`, `Checkbox`, `Slider`, `SliderInt`.
- [x] **Milestone 3: Windowing, Advanced Containers & Scissor Clipping**: Draggable `Window`, global `MenuBar`, `ScrollArea`, `CollapsingHeader`.
- [x] **Milestone 4: Canvas 2D Backend & Live Interactive Demo**: 60 FPS Canvas 2D host driver, adaptive LOD, automated GitHub Pages deployment.

### Phase 2: Workstation & Industrial Capabilities (Sep 12 – Sep 25)
- [x] **Milestone 5: Desktop Input System & Productivity Controls** (Fully Delivered): `CommandPalette` (`⌘K`), context menus (`ContextMenu`), code editor (`CodeEditor`), tree view (`TreeView`), rotary knob (`Knob`), vertical fader (`Fader`), pure Canvas Studio.
- [x] **Milestone 6: Workstation Layout & Resilient Widgets** (Delivered): draggable splitter (`Splitter`), data table (`Table`), modal dialog (`Dialog`), notifications (`Toast`), flow layout (`horizontal_wrapped`), dynamic multi-theming (`Theme`).
- [x] **Milestone 9: Verification, Benchmarking & Official Release** (Delivered): 167 automated unit tests (100% passing), Wasm-GC compatibility, published `v0.2.0`.
- [ ] **Milestone 7: Data-Dense Components & Advanced Visualizations** (In Roadmap): node graph editor (`NodeEditor`), telemetry plots (`Plot` & `BarChart`) [Delivered], vector SVG exporter (`SvgExporter`).
- [ ] **Milestone 8: Hardware-Accelerated Rendering & Production Scenarios** (In Roadmap): WebGL 2.0 batched geometry pipeline, integrated multi-scenario showcases.

> For full milestone metrics and acceptance criteria, see **[ROADMAP.md](docs/ROADMAP.md)** ([English](docs/ROADMAP_en.md)).

---

## Architecture & Technical Documentation

Comprehensive design specifications and technical whitepapers are available in the [`docs/`](docs/) directory:

| Document | Description | Key Focus |
| :--- | :--- | :--- |
| **[Roadmap & Milestones](docs/ROADMAP_en.md)** ([中文](docs/ROADMAP.md)) | Timeline & Deliverables | Hackathon milestones, acceptance criteria, long-term evolution |
| **[Architecture Whitepaper](docs/ARCHITECTURE.md)** ([中文](docs/ARCHITECTURE_zh.md)) | Engine Internals | Widget ID hashing, frame lifecycle, cursor layout, clip stack |
| **[API Reference Manual](docs/API_DESIGN.md)** ([中文](docs/API_DESIGN_zh.md)) | Developer API Docs | `UIContext` method signatures, layout protocols, Painter API |
| **[Design System & Tokens](docs/DESIGN_SYSTEM.md)** ([中文](docs/DESIGN_SYSTEM_zh.md)) | Visual Tokens | Color schemes, typography scales, spacing rules, state styles |
| **[Style Guide](docs/STYLE_GUIDE_en.md)** ([中文](docs/STYLE_GUIDE.md)) | Coding Standards | Block syntax (`///\|`), naming, visibility, `.mbti` contracts |
| **[Contributing Guide](docs/CONTRIBUTING.md)** ([中文](docs/CONTRIBUTING_zh.md)) | Engineering Protocols | Development workflow, test guidelines, Conventional Commits |
| **[Changelog](docs/CHANGELOG.md)** ([中文](docs/CHANGELOG_zh.md)) | Release History | Notable changes and release tracking |

---

## License

This project is licensed under the [Apache License 2.0](LICENSE).
