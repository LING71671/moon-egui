# Changelog

[English](CHANGELOG.md) | [中文](CHANGELOG_zh.md)

All notable changes to `moon-egui` will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

## [0.5.1] - 2026-09-19

### Added
- **100% Pure MoonBit Canvas Studio IDE (`examples/canvas/studio_ide.mbt`, `code_workspace.html`)**:
  - Implemented a complete desktop IDE experience rendered 100% inside a single HTML5 `<canvas>` via MoonBit immediate-mode GUI.
  - Features a top menu bar with action buttons and dropdown menus, collapsible and resizable project tree dock (`@composite.Dock`, `@composite.TreeView`), multi-tab code editor with line numbering and syntax styling, interactive terminal output drawer, quick command palette overlay (`@composite.CommandPalette`), and status bar.
  - Bespoke pure-vector geometric crescent logo badge and typography.
- **Extended Unicode Technical & Geometric Glyph Measurement (`src/core/context.mbt`)**:
  - Added width measurement rules for technical, mathematical, and geometric Unicode block glyphs (`0x2300` - `0x27BF`: `▶`, `⌘`, `●`, `✓`, arrows, etc.) with ratio `1.05`, eliminating clipping and text bounds drift.
- **Dynamic Viewport Modal Scrim (`src/composite/command_palette.mbt`)**:
  - Added optional `viewport_size? : @math.Vec2` parameter to `CommandPalette` to dynamically cover arbitrary viewport resolutions without cutoffs or truncation.
- **Semantic Theme Integration for TreeView (`src/composite/tree_view.mbt`)**:
  - Refactored `TreeView` styling to consume semantic theme tokens (`ctx.theme.bg_window`, `border_focus`, `border_muted`, `bg_hover`, `text_primary`, `text_body`), eliminating hardcoded light backgrounds in dark themes.

### Fixed
- **Button Auto-Sizing & Negative Padding Prevention (`src/widgets/button.mbt`)**:
  - Fixed button width calculation to strictly enforce natural padding from measured text bounds and prevent negative padding when explicit width is under-specified.
- **Modal Scrim Clipping**:
  - Fixed command palette and modal overlay masks cutting off at 800px on displays with height > 800px.

## [0.5.0] - 2026-09-19

### Added
- **Centered Vector Checkmark and Cross Geometry for Steps Indicator (`src/widgets/steps.mbt`)**:
  - Replaced font glyphs `"✓"` and `"✕"` with mathematically centered vector line segments (`add_line`) calculated directly from the step circle radius.
  - Eliminates platform font misalignment and DPI drift, ensuring pixel-perfect centering across all displays.
- **Harmonic Spring Physics Model (`src/math/spring.mbt`)**:
  - Implemented 1D `Spring` and 2D `Spring2D` physical oscillation solvers supporting mass, stiffness, and damping parameters.
  - Sub-step numerical integration with equilibrium detection (`is_settled`) and presets (`default_spring`, `stiff`, `gentle`, `bouncy`).
- **Vector SVG Exporter (`src/draw/svg_exporter.mbt`)**:
  - Implemented `SvgExporter` and `DrawList::to_svg` for lossless serialization of draw command streams (rects, circles, lines, text with XML escaping, linear gradients, and scoped `<clipPath>` hierarchies).
- **Core Floating Tooltip Component (`src/widgets/tooltip.mbt`)**:
  - Standalone `Tooltip` widget rendering into the foreground overlay pass with ambient drop shadow, semantic background, and subtle border.
  - Supports cardinal placements (`Top`, `Bottom`, `Left`, `Right`) with viewport boundary clamping and persistent hover delay counter.
  - Added fluent `on_hover_text` response helper and semantic palette tokens `Color::tooltip_bg()` and `Color::tooltip_border()`.
- **1D Virtualized List Container (`src/widgets/virtual_list.mbt`)**:
  - `VirtualList` container computing visible index windows (`first_visible..=last_visible`) and overscan buffers, executing item renderers exclusively for visible rows.
  - Integrated mouse wheel scrolling and interactive proportional scrollbar indicator.
- **WebGL 2.0 2D Mesh Tessellation & Vertex Buffer Pipeline (`src/draw/mesh.mbt`)**:
  - Implemented `Vertex` (2D position `x, y`, UV coordinates `u, v`, and normalized RGBA `r, g, b, a`) and `Mesh` for hardware-accelerated batch rendering.
  - 2D primitive triangulation routines: `tessellate_rect` (axis-aligned and rounded rectangles via corner fan arcs), `tessellate_circle`, and `tessellate_line` (perpendicular normal extrusion).
  - Batch generator `DrawList::to_mesh()` and serialization helper `Mesh::write_vertex_floats` for zero-copy WebGL VBO uploads.
- **Gallery Showcase Closures & Online Code Workspace (`examples/canvas/`)**:
  - Integrated interactive gallery stages for `VirtualList` (10,000 items viewport slicing), `Spring Physics` (2D spring-damper tethered puck simulation), and `SvgExporter` (vector SVG serialization).
  - Upgraded `code_workspace.html` into a full-width dark theme IDE layout with project explorer, syntax editor, and interactive terminal.
- **Pure Engine Dogfooding & Interface Harmony Standard (`AGENTS.md`, `docs/DESIGN_SYSTEM*.md`)**:
  - Formally mandated that all official showcases and tools must be written 100% in MoonBit and rendered via `moon-egui` Canvas pipeline.
  - Strictly banned HTML/CSS DOM mockups and discordant or unlinked preview viewports.
- **Automated Tests**:
  - Added 24 new whitebox test cases across `spring_wbtest.mbt`, `svg_exporter_wbtest.mbt`, `tooltip_wbtest.mbt`, `virtual_list_wbtest.mbt`, `mesh_wbtest.mbt`, and `steps_wbtest.mbt`.
  - Expanded total automated tests from 311 to **335 tests with 100% pass rate**.

## [0.4.0] - 2026-09-16

### Added
- **Discrete Step Input Widget (`Stepper`, `src/widgets/stepper.mbt`)**:
  - Immediate-mode stepper control featuring `[+]` and `[-]` buttons, numerical bounds clamping (`min`/`max`), precision formatting, prefix/suffix labels, and mouse wheel scrubbing.
  - Multiplier modifier support: Shift increments by 10× step, Ctrl increments by 0.1× step.
  - Full keyboard reachability (`ArrowLeft`, `ArrowRight`, `Home`, `End`) and focus ring indicator.
  - Reference-bound variant `StepperRef` with fluent builder methods (`Stepper::from_ref`).
- **Interactive Star Rating Widget (`Rating`, `src/widgets/rating.mbt`)**:
  - Star rating component supporting 0.5 half-star fractional evaluation via sub-rect vector scissor clipping.
  - Real-time hover preview (Live Hover Preview) reflecting potential selection prior to click commit.
  - Read-only display mode, configurable star size, spacing, and maximum star count.
  - Keyboard step navigation and bidirectional `RatingRef` binding.
- **Workflow & Process Steps Indicator (`Steps`, `src/widgets/steps.mbt`)**:
  - Directional process steps navigation component supporting dynamic step titles, descriptions, and active connector rails.
  - Automatic status derivation across `Wait`, `Process`, `Finish`, and `Error` states.
  - Step click switching and keyboard arrow navigation with focus ring styling.
- **Data Pagination Controller (`Pagination`, `src/widgets/pagination.mbt`)**:
  - Data pagination bar featuring intelligent ellipsis folding (`1 ... 4 [5] 6 ... 20`).
  - Next/Previous button stepper navigation with automatic bounds disablement and semantic cursor updates.
  - Accessible keyboard navigation (`ArrowLeft`, `ArrowRight`, `Home`, `End`).
- **Blueprint Node Flow Graph Editor Prototype (`NodeEditor`, `src/composite/node_editor.mbt`)**:
  - Milestone 7 deliverable: infinite/bounded canvas with subtle studio dot grid rasterization and scissor clip isolation.
  - Draggable node cards with header displacement tracking, title labels, and `Memory`-backed interaction persistence.
  - Input and output terminal connection ports with localized hover hit testing and `"crosshair"` cursor feedback.
  - Smooth multi-step cubic Bézier curve wire rasterization with adaptive horizontal curvature.
  - Interactive link wire drawing (dragging from output port to destination input port).
- **Test Suite Expansion**:
  - 31 new multi-frame whitebox and blackbox test cases across `stepper_wbtest.mbt`, `rating_wbtest.mbt`, `steps_wbtest.mbt`, `pagination_wbtest.mbt`, and `node_editor_wbtest.mbt`.
  - Expanded total test count from 280 to **311 tests with 100% pass rate**.
- **Interactive Web Gallery Showcase (`examples/canvas/`)**:
  - Integrated showcases for `Stepper`, `Rating`, `Steps`, `Pagination`, and `NodeEditor` into `gallery.html`.
  - Added bilingual translations and code signatures to `js/gallery-data.js` and `js/i18n.js`.
  - Rebuilt standalone `examples/canvas/canvas.js` bundle via `pwsh scripts/build_demo.ps1`.

## [0.3.2] - 2026-09-15

### Added
- **High-Performance Streaming Tabular & CSV Utilities (`src/widgets/table.mbt`)**:
  - High-performance tabular data structures with delimiter auto-detection (`,`, `\t`, `;`), quoted cell escaping, and automatic data type inference (`INT`, `FLOAT`, `STR`).
  - Zero-copy index indirection table (`row_indices : Array[Int]`) for $O(1)$ copy multi-column in-place quicksort and sub-millisecond virtualized viewport slicing.
- **Large-Scale Data Benchmark Suite**:
  - Synthetic benchmark tests verifying 10,000-row and 50,000-row tabular ingestion, multi-column sorting, and substring search with 100% test coverage.

### Fixed
- **Quicksort Worst-Case Degradation**: Added median pivot selection in tabular engine to prevent $O(N^2)$ recursion degradation on pre-sorted large datasets.
- **Zero-Allocation Search**: Replaced per-cell string allocation during global filtering with zero-allocation character scanning (`contains_ignore_case`).

## [0.3.1] - 2026-09-13

### Added
- **Keyboard reachability (FEAT-A11Y-01)**: menu bar (trigger toggle, dropdown item traversal, Escape close), data table (arrow-key row highlight with auto-scroll, Enter to activate), context menu (arrow navigation while open, disabled rows skipped, Enter opens submenus), DockArea (tab switching, arrow-resizable dividers) plus standalone splitter, scroll_area, tag, breadcrumb and window. 15 new frame-sequence tests.
- **Interaction test infrastructure**: drag-sequence (press -> drag -> release) and controlled-component feed-back tests; `AGENTS.md` now codifies the Widget Interaction Standard (cursor contract, hit testing, popup foreground scope, global scale, keyboard reachability, controlled widgets, multi-frame test patterns).

### Fixed
- None (accessibility and test-coverage hardening release).

### Other
- **README restructure**: the primary `README.md` is now English (what mooncakes.io and GitHub display by default); the Chinese version moved to `README_zh.md` with the language switcher preserved.
- Test count 246 -> 263 (100% passing).

## [0.3.0] - 2026-09-13

### Breaking Changes
- **All widget calls migrate to the layered namespaces**: the `ctx.button(...)` style `UIContext` methods are gone; use `@widgets.button(ctx, ...)` / `@composite.knob(ctx, ...)` instead, and import widgets from `src/widgets` / `src/composite` rather than `src/core`. The `src/lib.mbt` facade keeps every type re-exported. See `docs/API_DESIGN.md` and `ARCH-06`.

### Fixed
- **Cursor contract**: every interactive surface reports a semantic cursor (buttons/labels/tabs = `pointer`, sliders = `ew-resize` / `ns-resize`, splitters = `col-resize` / `row-resize`, window title bars = `move`, text = `text`, HSV area = `crosshair`); fixes five missing spots (ColorPicker, window title bar, DockArea tabs, Toast close, Sparkline hover) and **benchmark.html, whose host never applied the cursor at all**, now synced every frame via `FrameOutput.cursor`.
- **Hit tests unified through `is_hovered`**: removed 21 raw `rect.contains(mouse_pos)` hit tests so widgets stop reacting while scrolled out of a `scroll_area` or covered by windows/foreground layers (the three intentional modal outside-click checks keep raw geometry).
- **Popups no longer swallow their own hover**: context menu / command palette / toast registered hover blockers over themselves, so from the second frame on `is_hovered` failed - menu rows could not be selected, the palette wheel died, a toast close cross became unclickable. Their interaction phases now run in the foreground scope, with frame-two regression tests.
- **Global scale coverage**: `Knob` and `ColorPicker` ignored `WidgetStyle.scale` (hard-coded literal geometry); both follow it now, locked by "scale 2 geometry is exactly twice scale 1" regression tests.
- **Build script entry anchoring**: the loose symbol match in `scripts/build_demo.*` bound `window.moon_step` to `Knob::step`, silently breaking the CAD page; the pattern now anchors the `examples/canvas` module and the bundle was rebuilt.
- **Docs and site examples migrated**: README (zh/en), `docs/API_DESIGN*`, `docs/ARCHITECTURE*`, `docs/README_en` and the four site pages (docs / wiki / index / gallery) - about 160 examples now teach the new namespace API.

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
- **Test Suite Expansion**: Added comprehensive whitebox tests for `Fader`, bringing total automated test coverage to 221 tests (100% pass rate).
- **Layered Package Restructure (`ARCH-06`)**:
  - Split the former 59-file `src/core` monolith into three physical packages: `src/core` (bare immediate-mode runtime), `src/widgets` (standard controls) and `src/composite` (advanced components), with a strictly unidirectional dependency flow `math -> color -> draw -> core -> widgets -> composite -> src`.
  - `src/core` now contains only the engine runtime (`context`, `id`, `input`, `memory`, `layout_engine`, `focus_manager`, `window_manager`, `layer_manager`, `painter`, `theme`, `response`, `unicode`, `widget`, `text_layout`).
  - Cross-package contract: widgets implement `@core.Widget` and dispatch through `ctx.add(...)`, callers use the `@widgets.*` / `@composite.*` namespace helpers, and read-only structs such as `WidgetStyle` are derived through fluent builders like `WidgetStyle::scaled(factor)` instead of struct update syntax.
  - `src/lib.mbt` acts as the umbrella facade re-exporting every public type and the `Widget` trait via `pub using @core { trait Widget }`.

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
