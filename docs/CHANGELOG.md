# Changelog

All notable changes to `moon-egui` will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Added
- **Global Application Menu Bar (`menu_bar`, `menu`, `menu_item`, `menu_separator`)**: Desktop-grade menu strip featuring bistable Hover-to-Switch transitions, outside-click dismissal, deferred foreground layer elevation, and occlusion hover blocking.
- **Milestone 3 Full Delivery**: Completion of Windowing, Advanced Containers, and Scissor Clipping suite (`window`, `menu_bar`, `scroll_area`, `collapsing_header`, `tab_bar`).
- **Interactive Component Gallery Integration**: Added MenuBar showcase with real-time CAD workspace demo in `examples/canvas/gallery.html` and bilingual entries in `examples/canvas/i18n.js`.
- **Studio Light Porcelain Design Unification**: Design token consolidation in `src/color/` and refreshed specifications across design system documentation.

---

## [0.1.0-alpha.1] - 2026-09-09

### Added
- **Canvas 2D Interactive Web Playground**: Full working HTML5 Canvas 2D live demo in [`examples/canvas/`](examples/canvas/) running 60 FPS in browser with real-time pointer interaction and telemetry.
- **Core Interactive Widgets**: Ergonomic `label`, `label_colored`, `button`, `button_primary`, `checkbox`, `separator`, and `spacer` methods on `UIContext`.
- **Multi-Tier Architecture**: Modular package organization under `src/` (`src/math`, `src/color`, `src/draw`, `src/core`, `src/lib.mbt`) and blackbox integration suite under `test/`.
- **Mathematical Primitives**: `Vec2` and `Rect` with AABB hit-testing, intersection, margins, and scissor clipping math.
- **Color System & Tokens**: 32-bit RGBA color model, hex parsing, alpha blending, and industrial dark mode design tokens.
- **Render-Agnostic Draw Protocol**: Geometric primitive token enum (`DrawCmd`) and buffer-reusable command queue (`DrawList`).
- **Interaction State Machine**: `RawInput`, `InputState` pointer transition tracking, 64-bit deterministic FNV-1a `Id` hashing, and hierarchical `IdStack`.
- **IMGUI Context Coordinator**: `UIContext` lifecycle manager with linear cursor layout and `allocate_space` core extensibility primitive.
- **Documentation Suite**: Comprehensive bilingual documentation in `docs/` covering architecture, API design, design system, coding style, contributing guide, and engineering roadmap.
- **Automated CI Workflow**: GitHub Actions pipeline verifying formatting (`moon fmt`), unit/integration test suites (`moon test`), and WebAssembly build (`moon build`).
