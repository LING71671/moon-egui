# Changelog

[English](CHANGELOG.md) | [中文](CHANGELOG_zh.md)

All notable changes to `moon-egui` will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Added
- **Immediate-Mode Plotting Suite (`Plot` & `BarChart`)**:
  - `UIContext::plot` supporting multi-series composite rendering (`PlotSeriesKind::Line`, `PlotSeriesKind::Scatter`, `PlotSeriesKind::Area`) with automatic bounds calculation, adaptive grid subdivisions, numeric coordinate tick labels, hover crosshairs, and data value tooltips.
  - `UIContext::bar_chart` featuring dynamic column width calculation, proportional gutter spacing, category axis labels, hover highlight indicators, and value capsule indicators.
- **Keyboard Navigation & Scrubbing for `DragValue`**:
  - Added ArrowLeft/ArrowDown (decrement) and ArrowRight/ArrowUp (increment) keyboard navigation when focused.
  - Multiplier acceleration: Shift key for fine-stepping (0.1x) and Ctrl key for coarse-stepping (10x).
  - Explicit visual focus ring (`@color.Color::border_focus()`).
- **Geometry & Sizing Design Token Normalization**:
  - Formalized widget dimensions across `WidgetStyle` (`progress_bar_h`, `tooltip_pad_x`, `tooltip_pad_y`, `tooltip_radius`, `window_title_bar_h`, `combo_box_w`, `combo_box_h`, `collapsing_header_h`, `collapsing_header_indent`, `tab_bar_h`, `tab_bar_pad_x`, `drag_value_w`, `drag_value_h`, `color_picker_w`, `color_picker_btn_h`, `breadcrumb_h`, `breadcrumb_sep_gap`, `plot_default_w`, `plot_default_h`, `plot_pad_left`, `plot_pad_right`, `plot_pad_top`, `plot_pad_bottom`, `bar_chart_default_w`, `bar_chart_default_h`, `bar_chart_gap`).
  - Added semantic palette tokens `Color::grid_line()`, `Color::guideline_wash()`, and `Color::plot_crosshair()`.
- **Vertical Channel Fader Regulator (`Fader` & `FaderInt`)**:
  - Implemented `UIContext::fader` and `UIContext::fader_int` for audio and parameter mixing channels.
  - Features recessed track groove, calibrated tick marks, tactile fader cap with center indicator line, vertical drag delta, scroll wheel stepping, Shift (0.1x) / Ctrl (10x) modifiers, Arrow/Home/End keyboard navigation, and Alt+Click reset.
  - Added semantic design tokens `Color::fader_track_bg()`, `Color::fader_tick()`, `Color::fader_cap_line()`, and `WidgetStyle` fields `fader_w`, `fader_h`, `fader_track_w`, `fader_cap_w`, `fader_cap_h`, `fader_cap_radius`.
- **Graphical Primitive Typographical Metadata (`BUG-DRAW-03`)**:
  - Added `font_family : String` and `font_weight : Int` metadata to `DrawCmd::Text` and `DrawList::add_text`.
  - Enabled bold font weight (700) in `RichText` and explicit monospace typeface in `CodeEditor` line numbers and code text.
  - Updated HTML5 Canvas 2D runners (`gallery_runner.js` and `run.js`) with LRU font string assembly and caching.
- **Test Suite Expansion**: Added comprehensive whitebox tests for `Fader` (`src/core/fader_wbtest.mbt`), bringing total automated test coverage to 167 tests (100% pass rate).

---

## [0.2.0] - 2026-09-12

### Added
- **Full Self-Hosted "Pure Canvas Studio" (`gallery.html`)**: Complete migration of the component gallery to an in-canvas workbench featuring segmented theme switching (`studio_light`, `slate_dark`, `high_contrast`), 50/50 draggable curtain splitter (`split_horizontal`), line-numbered code viewer (`code_editor`), and full 32-widget code repository.
- **Input Accessibility & Multi-Pointer Overhaul**: Secondary pointer click (right-click) support in `RawInput`, complete Tab focus navigation chain across all widgets, Space/Enter keyboard activation with focus stroke rings, and event consumption (`consume_key`).
- **Typography & Grapheme Traversal Engine**: CJK word-wrapping and line breaking with punctuation avoidance in `rich_text.mbt`, atomic UTF-16 surrogate cluster traversal (`prev_char_boundary`, `next_char_boundary`), LRU typographical measurement caching, and native browser IME `<textarea>` composition bridge.
- **Widget Resiliency Suite**:
  - `CodeEditor`: Binary search character hit-testing, vertical wheel scrolling, auto-scrolling to caret, line culling, and text selection buffers with pointer drag and Shift/Ctrl+A key shortcuts.
  - `ScrollArea`: Interactive vertical scrollbar thumb dragging and post-closure content height clamping.
  - `Dialog`: Dynamic card height computation and Tab focus trapping.
  - `CommandPalette`: Scissor-clipped scrolling and 320px maximum height clamping.
  - `ComboBox`: Boundary collision detection with automatic upward flipping and internal scrolling.
  - `ContextMenu`: Recursive cascading submenus (`children : Array[ContextMenuItem]`, `ContextMenuItem::submenu`) with hover tracking.
  - `Splitter`: Zero-dimension guards and safe minimum padding clamping.
  - `Tooltip` & `Toast`: Viewport boundary clamping and hover occlusion blocking.
- **Rendering & Pipeline Optimizations**:
  - Added `DrawCmd::LinearGradient` primitive and `DrawList::add_linear_gradient`, mapped to `ctx.createLinearGradient` in JS backends.
  - Removed redundant per-cell `push_clip`/`pop_clip` in `Table`, saving 240 canvas state save/restores per frame.
- **Advanced Core Layout & Dynamic Theming**:
  - Auto-wrapping flow layout `UIContext::horizontal_wrapped`.
  - Dynamic runtime theme switching with `Theme` struct (`Theme::studio_light()`, `Theme::slate_dark()`, `Theme::high_contrast()`).
  - Immediate-mode animation tweening state machine (`animate_bool`, `animate_float`).
- **Memory & State Hardening**:
  - Replaced persistent state arrays with generational hash maps (`@hashmap.HashMap[Id, T]`) and frame-counter pruning (`prune_stale_state`).
  - Non-allocating 64-bit integer ID derivation (`Id::from_int`, `Id::with_int`, `IdStack::derive_int`).
- **158 Headless Tests**: 100% test pass rate across unit and whitebox test suites.

---

## [0.1.1] - 2026-09-11

### Added
- **Global Application Menu Bar (`menu_bar`, `menu`, `menu_item`, `menu_separator`)**: Desktop-grade menu strip featuring bistable Hover-to-Switch transitions, outside-click dismissal, deferred foreground layer elevation, and occlusion hover blocking.
- **Milestone 3 Full Delivery**: Completion of Windowing, Advanced Containers, and Scissor Clipping suite (`window`, `menu_bar`, `scroll_area`, `collapsing_header`, `tab_bar`).
- **Interactive Component Gallery Integration**: Added MenuBar showcase with real-time CAD workspace demo in `examples/canvas/gallery.html` and bilingual entries in `examples/canvas/i18n.js`.
- **Studio Light Porcelain Design Unification**: Design token consolidation in `src/color/` and refreshed specifications across design system documentation.
- **Enhanced Tactile Physics**: 1.5px sunken stroke on button press, chiclet keycaps, and micro-grooves.
- **58 Headless Tests**: 100% passing automated test suite covering all interaction states.

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
