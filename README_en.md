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

## Live Demos

Experience the interactive capabilities and rendering performance of `moon-egui` in any modern browser:

- **[Interactive Demo Homepage](https://ling71671.github.io/moon-egui/)**
  Immediate-mode widgets showcase, application menu bar, floating inspector window, and lightweight canvas playground.
- **[Canvas & Multi-Scale Matrix Benchmark](https://ling71671.github.io/moon-egui/benchmark.html)**
  128² to 1024² (16,384 to 1,048,576 nodes) multi-scale pixel matrix, CAD dual-axis rulers, viewport pan & zoom navigation, and CAD pixel grid lines.

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

### Layout System
- **Menu Bar**: Top-level application menu with multi-level hover dropdowns.
- **Side Panels & Columns**: Fixed-width sidebars and equal-width column layouts.
- **Floating Windows**: Draggable title bars, dynamic Z-index elevation, and collapsible bodies.
- **ScrollArea & Clipping**: Smooth scrolling with pixel-precise scissor clipping.

### Widget Suite
- **Basic Widgets**: Text labels, multi-state buttons (normal/hover/active/disabled), checkboxes, and toggles.
- **Precision Inputs**: Integer and float sliders, Blender-style `DragValue` number scrubbers.
- **Feedback & Telemetry**: Progress bars, real-time sparkline curves, hover tooltips.
- **Structural Containers**: Collapsible headers, horizontal separators, flexible spacers.

### Custom Painter API
Supports direct 2D vector drawing within any layout container (rectangles, circles, bezier curves, polygon fills, lines, and text) for custom telemetry, gauges, or game HUDs.

### Headless & Automated Testing
Because the core produces a pure `DrawCmd` primitive stream without browser bindings, layout calculations, AABB hit-testing, and state transitions are verifiable via `moon test`.

---

## Development Roadmap (Sep 9 – Sep 24, 2026)

- [x] **Milestone 1: Scaffolding & Mathematical Primitives** (Sep 9 – Sep 11)
  - Core data structures: `Vec2`, `Rect`, `Color`, `InputState`, `DrawCmd`.
- [ ] **Milestone 2: Input State Machine & Basic Widgets** (Sep 12 – Sep 15)
  - AABB hit-testing, single-pass cursor layout, `Button`, `Label`, `Checkbox`, `Slider`.
- [ ] **Milestone 3: Windowing & Container Management** (Sep 16 – Sep 18)
  - Floating draggable windows, dynamic Z-index management, collapsible sections.
- [ ] **Milestone 4: Canvas 2D Backend & Live Playground** (Sep 19 – Sep 21)
  - 60 FPS HTML5 Canvas 2D bridge, interactive WebAssembly demo on GitHub Pages.
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
