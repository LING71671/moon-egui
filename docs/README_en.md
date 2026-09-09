<div align="center">

# moon-egui

**High-Performance Immediate-Mode GUI Engine for MoonBit and WebAssembly**

<p>
  <a href="../README.md">简体中文</a> · <a href="README_en.md">English</a>
</p>

<p>
  <a href="https://github.com/LING71671/moon-egui/actions"><img src="https://img.shields.io/github/actions/workflow/status/LING71671/moon-egui/ci.yml?branch=main&label=CI&style=flat-square" alt="CI Status" /></a>
  <a href="../LICENSE"><img src="https://img.shields.io/badge/license-Apache--2.0-blue?style=flat-square" alt="License" /></a>
  <a href="https://www.moonbitlang.com/"><img src="https://img.shields.io/badge/lang-MoonBit-6B46C1?style=flat-square" alt="MoonBit" /></a>
  <img src="https://img.shields.io/badge/target-Wasm-F97316?style=flat-square" alt="Wasm" />
  <a href="https://moonbitlang.github.io/Hackathon2026/"><img src="https://img.shields.io/badge/hackathon-MoonBit%202026-10B981?style=flat-square" alt="Hackathon 2026" /></a>
</p>

<br />

<img src="../media/social_preview.jpg" alt="moon-egui banner" width="100%" />

</div>

---

## Overview

`moon-egui` is an Immediate-Mode GUI (IMGUI) library written in pure [MoonBit](https://www.moonbitlang.com/), targeting WebAssembly, HTML5 Canvas 2D, and game development.

Inspired by Rust's `egui` and C++'s `Dear ImGui`, `moon-egui` operates on an immediate-mode paradigm: **code is UI, and UI is state**. Unlike retained-mode frameworks that construct and maintain heavy DOM hierarchies, `moon-egui` reconstructs its layout frame-by-frame with zero DOM overhead, deterministic memory usage, and 60-FPS rendering.

### At a Glance

| Metric / Dimension | Specification | Notes |
| :--- | :--- | :--- |
| **Paradigm** | Immediate-Mode (IMGUI) | Declarative, stateless frame evaluation |
| **Language** | MoonBit (100% Pure) | Headless core, host-independent |
| **Target Runtime** | WebAssembly / JS | Extensible to Native (Raylib, SDL) |
| **Rendering Backend** | HTML5 Canvas 2D (Default) | Render-agnostic `DrawCmd` stream |
| **Binary Footprint** | < 50 KB (Target) | Zero external dependencies |
| **Framerate Target** | 60 FPS (16.6 ms budget) | Minimal allocations per frame |

---

## Quick Example

```moonbit
fn update_ui(ui : &mut UIContext, state : &mut AppState) {
  // Top-level application menu bar
  ui.menu_bar(fn() {
    ui.menu("File", fn() {
      if ui.menu_item("New") { state.new_project() }
      if ui.menu_item("Save") { state.save() }
    })
  })

  // Floating draggable inspector window
  ui.window("Inspector & Control", 50.0, 50.0, 300.0, 420.0, fn() {
    ui.label("Welcome to moon-egui")
    
    if ui.button("Trigger Action") {
      state.counter += 1
    }
    
    // Blender-style DragValue adjustment
    ui.drag_float("Gravity", &mut state.gravity, speed=0.1, min=0.0, max=20.0)
    ui.checkbox("Enable Physics", &mut state.physics_enabled)
    
    // Collapsible telemetry panel
    ui.collapsing_header("Telemetry", fn() {
      ui.sparkline("FPS History", state.fps_history)
      ui.progress_bar(state.progress)
    })
  })
}
```

---

## Architecture

`moon-egui` separates UI evaluation from rendering through a strict three-tier pipeline:

```
[ Input Events ]
  • Pointer position & buttons
  • Keyboard inputs & modifiers
  • Scroll wheel delta
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
[ Pluggable Backends ]
  • HTML5 Canvas 2D (Default Wasm target)
  • WebGL / WebGPU (Planned)
  • Native Windowing (Raylib / SDL / Minifb)
```

---

## Core Capabilities

### Desktop & IDE-Grade Layouts
- **Menu Bar**: Global top-level application menus with dropdown entries.
- **Side Panels & Columns**: Left/right collapsible sidebars and multi-column grid layouts.
- **Floating Windows**: Draggable title bars, dynamic Z-index elevation, and collapsible bodies.
- **ScrollArea & Clipping**: Smooth mouse-wheel scrolling with scissor clipping masks.

### Widget Suite
- **Controls**: Labels, multi-state buttons (normal, hover, pressed, disabled), checkboxes, and toggles.
- **Precision Inputs**: Sliders (integer and float) and Blender-style `DragValue` number scrubbers.
- **Telemetry & Feedback**: Progress bars, real-time sparkline graphs, and hover tooltips.
- **Layout Helpers**: Collapsible headers, horizontal separators, and flexible spacers.

### Custom Painter API
Direct 2D vector primitives—circles, bezier curves, convex polygons, lines, and text—embedded directly into any container for custom gauges, nodes, or game HUDs.

### Headless & Testable
Because the core produces pure `DrawCmd` tokens without browser dependencies, every layout calculation, AABB collision, and state transition is verifiable via `moon test`.

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
  - Comprehensive unit test coverage, performance validation, and final acceptance.

> For full milestone metrics, detailed acceptance criteria, and future exploration, refer to **[ROADMAP.md](ROADMAP_en.md)** ([中文](ROADMAP.md)).

---

## Documentation

Comprehensive design specifications and technical whitepapers are organized in this directory:

| Document | Description | Key Focus |
| :--- | :--- | :--- |
| **[Roadmap & Milestones](ROADMAP_en.md)** ([中文](ROADMAP.md)) | Timeline & Deliverables | Hackathon milestones, acceptance criteria, future work |
| **[Architecture Whitepaper](ARCHITECTURE.md)** ([中文](ARCHITECTURE_zh.md)) | Core engine internals | ID hashing, frame lifecycle, cursor layout, clip stack |
| **[API Reference](API_DESIGN.md)** ([中文](API_DESIGN_zh.md)) | Complete public interface | `UIContext`, widget signatures, containers, Painter API |
| **[Design System](DESIGN_SYSTEM.md)** ([中文](DESIGN_SYSTEM_zh.md)) | Visual design tokens | Dark/Light palettes, typography scale, spacing rules |
| **[Style Guide](STYLE_GUIDE_en.md)** ([中文](STYLE_GUIDE.md)) | Official coding conventions | Block style (`///|`), naming, testing tiers, `.mbti` |
| **[Contributing Guide](CONTRIBUTING.md)** ([中文](CONTRIBUTING_zh.md)) | Development workflows | MoonBit conventions, code formatting, test criteria |
| **[Changelog](CHANGELOG.md)** | Release tracking | Record of all notable changes and releases |

---

## License

This project is licensed under the [Apache License 2.0](../LICENSE).
