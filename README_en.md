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

### Specifications at a Glance

| Dimension | Specification | Description |
| :--- | :--- | :--- |
| **Paradigm** | Immediate-Mode (IMGUI) | Declarative frame evaluation, stateless lifecycle |
| **Language** | MoonBit (100% Pure Logic) | Headless design, decoupled from host environment |
| **Target Runtime** | WebAssembly / JS | Clean architecture for native extensions (Raylib / SDL) |
| **Rendering Backend** | HTML5 Canvas 2D (Default) | Outputs compact primitive command stream (`DrawCmd`) |
| **Binary Footprint** | < 50 KB (Target) | Zero external runtime dependencies |
| **Framerate Target** | 60 FPS (16.6ms frame budget) | Controlled dynamic memory allocations per frame |

---

## Installation

```bash
moon add ling71671/moon-egui
```

Then import the packages in your `moon.pkg`:

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
- **Available Widget Suite**:
  - **Labels**: `label` (standard text) and `label_colored` (custom tinted text).
  - **Buttons**: `button` (standard button) and `button_primary` (accentuated CTA button) with Normal / Hover / Pressed responses.
  - **Checkbox**: `checkbox` (interactive toggle box).
  - **Continuous Sliders**: `slider` (floating-point scrub) and `slider_int` (stepped integer slider) with continuous drag tracking and percentage mapping.
  - **Layout Spacing**: `separator` (horizontal divider) and `spacer` (vertical flexible padding).
- **Window Container**: `window(title, pos, size, content)` provides background cards, header bar, local cursor scoping, and scissor viewport clipping.
- **Headless & Automated Testing**: Core logic produces pure `DrawCmd` streams without browser bindings, verifiable via `moon test`.
- **Canvas 2D Host Driver**: Lightweight JavaScript bridge and 60 FPS rendering pipeline, coupled with O(1) viewport spatial culling and multi-scale LOD architecture.

### Planned & In Roadmap
- **Advanced Inputs**: Blender-style numeric scrubbers (`DragValue`).
- **Advanced Windowing**: Window title-bar drag repositioning, dynamic Z-index elevation, and collapsible tree sections (`CollapsingHeader`).
- **Layout Containers**: Scrollable scissor viewports (`ScrollArea`) and top-level menus (`MenuBar`).
- **Data & Telemetry**: Smooth progress bars (`ProgressBar`), live sparkline plots (`Sparkline`), and hover tooltips (`Tooltip`).

---

## Development Roadmap (Sep 9 – Sep 24, 2026)

- [x] **Milestone 1: Scaffolding & Mathematical Primitives** (Sep 9 – Sep 11)
  - Core data structures delivered: `Vec2`, `Rect`, `Color`, `InputState`, `DrawCmd`, `DrawList`.
- [x] **Milestone 2: Input State Machine & Basic Widgets** (Sep 12 – Sep 15)
  - Delivered: AABB hit-testing, bi-directional layouts (`horizontal`/`vertical`), `Button`, `Label`, `Checkbox`, `Slider`, `SliderInt`.
- [x] **Milestone 4 (Delivered Ahead): Canvas 2D Backend & Live Playground** (Deployed)
  - 60 FPS HTML5 Canvas 2D bridge, multi-scale LOD architecture, and automated GitHub Pages deployment.
- [>] **Milestone 3 (In Progress): Windowing & Container Management** (Sep 16 – Sep 18)
  - Delivered: Foundation `Window` container with local scoping and clipping.
  - In Progress: Window dragging, dynamic Z-index management, collapsible sections.
- [ ] **Milestone 5: Verification, Benchmarks & Release** (Sep 22 – Sep 24)
  - Comprehensive unit test coverage, documentation specs, and final acceptance.

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
| **[Changelog](docs/CHANGELOG.md)** | Release History | Notable changes and release tracking |

---

## License

This project is licensed under the [Apache License 2.0](LICENSE).
