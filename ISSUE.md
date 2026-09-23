# Technical Inventory: Active Defects & Feature Roadmap

<p>
  <a href="ISSUE.md">English</a> · <a href="ISSUE_zh.md">简体中文</a>
</p>

> [!NOTE]
> **Resolved Issues Archive**: All 90+ historically resolved defects (`BUG-*`, `ARCH-*`, delivered `FEAT-*`, and resolved `AUDIT-*` items) have been archived to **[ISSUE_ARCHIVE.md](ISSUE_ARCHIVE.md)** ([中文归档](ISSUE_ARCHIVE_zh.md)).
> This document tracks exclusively **active defects**, **pending engine capabilities**, and the **milestone status matrix**.

---

# Part I: Active Defects & Code Review Audit (`bug` / `audit`)

### AUDIT-PERF-02 (P2) [OPEN]: Granular Line Segment Flooding During Node Connection Wire Drawing
- **Location**: [src/composite/node_editor.mbt#L204-L218](file:///a:/moonbit-project/src/composite/node_editor.mbt#L204-L218), [L528-L558](file:///a:/moonbit-project/src/composite/node_editor.mbt#L528-L558)
- **Status**: **Backlog**
- **Priority**: **P2**
- **Category**: Draw Command Batching Efficiency
- **Description**:
  `NodeEditor` approximates cubic bezier curve connections between node ports by emitting 16 to 20 individual `DrawCmd::Line` commands per wire into `DrawList`.
- **Failure Mechanism**:
  For a graph with 50 connections, this generates 1,000 discrete line commands per frame. In `canvas.js`, each line command triggers separate `ctx.beginPath()`, `ctx.moveTo()`, `ctx.lineTo()`, and `ctx.stroke()` state transitions, severely degrading Canvas 2D rasterization throughput.
- **Remediation**:
  Introduce a native `DrawCmd::BezierCurve { p0, p1, p2, p3, stroke }` command in `@draw`, mapping directly to HTML5 Canvas `bezierCurveTo` in a single GPU/Canvas path.

---


### AUDIT-MAINT-01 (P1) [OPEN]: Systemic Theme Bypass via Direct Semantic Palette Token Calls in Widgets
- **Location**: [src/widgets/](file:///a:/moonbit-project/src/widgets/) (all 18 files)
- **Status**: **Backlog**
- **Priority**: **P1**
- **Category**: Design Token Decoupling & Theming
- **Description**:
  Direct analysis reveals 285 calls to `@color.Color::*` palette functions directly across `src/widgets/` and 0 calls referencing `ctx.theme.*`.
- **Failure Mechanism**:
  Although `FEAT-CORE-03` introduced runtime theme switching (`studio_light`, `slate_dark`, `high_contrast`) via `ctx.theme`, standard widgets query static global palette constructors rather than the active theme configured on `UIContext`. Consequently, toggling `ctx.set_theme(...)` leaves standard widgets visually stuck in the default palette.
- **Remediation**:
  Route widget surface coloring through `ctx.theme` (or provide `ctx.color_accent()`, `ctx.color_surface()` delegates) across all standard widgets, ensuring that changing the active theme dynamically recolors all UI surfaces.

---


### AUDIT-DOGFOOD-01 (P1) [OPEN]: Raw HTML/DOM Top Header Bar in Benchmark Violating Pure Canvas Dogfooding Standard
- **Location**: [examples/canvas/benchmark.html#L244-L321](file:///a:/moonbit-project/examples/canvas/benchmark.html#L244-L321)
- **Status**: **Backlog**
- **Priority**: **P1**
- **Category**: Dogfooding Standard Compliance
- **Description**:
  `examples/canvas/benchmark.html` renders a simulated top application header using raw HTML/CSS DOM: `<header class="studio-header"><div class="brand">...</div><div class="metrics">...</div></header>`.
- **Failure Mechanism**:
  This directly violates Section 1 of the *Pure MoonBit Engine Dogfooding & Interface Harmony Standard* ("Strictly Forbid HTML/CSS DOM Simulation... All window chrome, docking panels, tree views, code editors, menu bars, and command palettes must be driven directly by MoonBit's UIContext").
- **Remediation**:
  Replace the HTML DOM `.studio-header` in `benchmark.html` with a native MoonBit immediate-mode header bar rendered directly on the single canvas viewport.

---


### AUDIT-DOGFOOD-02 (P1) [OPEN]: Extensive HTML/DOM Simulation of App Header, Toolbar, and HUD in Minesweeper
- **Location**: [examples/canvas/minesweeper.html#L373-L487](file:///a:/moonbit-project/examples/canvas/minesweeper.html#L373-L487)
- **Status**: **Backlog**
- **Priority**: **P1**
- **Category**: Dogfooding Standard Compliance
- **Description**:
  `examples/canvas/minesweeper.html` implements application chrome (top header bar, segmented zoom controls, center/restart buttons, flag/pan toggle tools, and bottom telemetry capsule HUD) entirely using HTML/CSS DOM elements (`<header class="studio-header">`, `<div class="segmented-control">`, `<div class="studio-footer-pill">`) floating on top of the canvas, synchronized via JS event bridges.
- **Failure Mechanism**:
  This directly violates Section 1 of the *Pure MoonBit Engine Dogfooding & Interface Harmony Standard* ("Strictly Forbid HTML/CSS DOM Simulation... All window chrome, docking panels, tree views, code editors, menu bars, command palettes, and interactive consoles must be driven directly by MoonBit's UIContext").
- **Remediation**:
  Re-engineer the entire chrome and HUD of Minesweeper in native MoonBit using `UIContext` widgets (`@widgets.segmented_control`, `@composite.menu_bar`, `@widgets.badge`), rendering entirely within a single `<canvas>` viewport.

---

## 14. User Experience & Interaction (`ux`)


---

# Part II: Engine Capabilities & Dogfooding Roadmap (`feat`)

### FEAT-SHOWCASE-02 (Medium): Live Interactive Component Sandboxes in `docs.html`
- **Target File**: [examples/canvas/docs.html](file:///a:/moonbit-project/examples/canvas/docs.html)
- **Current State**:
  `docs.html` is a 44.5 KB static HTML document with zero Wasm runtime execution. Developers reading API signatures only see static text code snippets.
- **Proposed Enhancement**:
  Embed interactive micro-canvas instances underneath each widget's API section:
  - Users reading `Slider` documentation can drag the live slider on the page.
  - Users reading `ColorPicker` can interact with the HSV canvas in-place.
  - Users reading `Table` can sort and resize columns directly inside the documentation.
- **Value**: Transforms static documentation into an interactive developer showcase, aligned with modern UI documentation standards.

---


### FEAT-SHOWCASE-03 (Medium): Native In-Canvas Studio Header Bar for `benchmark.html`
- **Target File**: [examples/canvas/benchmark.html](file:///a:/moonbit-project/examples/canvas/benchmark.html), [examples/canvas/main.mbt](file:///a:/moonbit-project/examples/canvas/main.mbt)
- **Current State**:
  The CAD matrix viewport is rendered by MoonBit, but the top floating control bar (`.studio-header` containing preset scales 1,600/10,000/1M, modes, theme toggle, and FPS metrics HUD) is an HTML DOM overlay.
- **Proposed Enhancement**:
  Render the top bar directly inside the canvas using `ui.menu_bar(...)`, `ui.segmented_control(...)`, and `ui.badge(...)`.
- **Value**: Makes the CAD benchmark 100% standalone and portable (embeddable into any WebGL/WebGPU surface or native desktop window with zero DOM dependencies).

---


### FEAT-SHOWCASE-04 (Low): Interactive Architecture & Pipeline Visualizers in `wiki.html`
- **Target File**: [examples/canvas/wiki.html](file:///a:/moonbit-project/examples/canvas/wiki.html)
- **Current State**:
  `wiki.html` is a 29.5 KB static HTML document containing text and ASCII flowcharts.
- **Proposed Enhancement**:
  Embed interactive MoonBit visualizers:
  1. **Frame Lifecycle Step Runner**: Step through `begin_frame` -> `allocate_space` -> `clip_stack` -> `end_frame` with forward/back buttons.
  2. **DrawCmd Stream Inspector**: Live inspector displaying the command queue generated by active widgets in real-time.
  3. **Spatial Culling LOD Visualizer**: Live camera pan/zoom sandbox showing how world coordinates are culled into `(c_start, c_end, r_start, r_end)`.

---


### FEAT-SHOWCASE-05 (Low): Embedded Interactive Micro-Playground in `index.html` Hero Section
- **Target File**: [examples/canvas/index.html](file:///a:/moonbit-project/examples/canvas/index.html)
- **Current State**:
  The landing page is 100% static HTML. Visitors must navigate away to subpages to see MoonBit in action.
- **Proposed Enhancement**:
  Embed a responsive live sandbox card directly in the Hero banner showcasing sliders, badges, toggles, and live sparkline charts.

---


### FEAT-A11Y-01 (P2): Keyboard Reachability for Container & Overlay Widgets
- **Location**: [src/widgets/](file:///a:/moonbit-project/src/widgets/), [src/composite/](file:///a:/moonbit-project/src/composite/)
- **Status**: In Progress (2026-09-13). Delivered: `badge` / `tag` (keyboard close), `breadcrumb` (arrows + Enter navigation), `scroll_area` (arrows / PageUp / PageDown / Home / End scrolling), `splitter` (arrow resize, both directions), `window` (arrow move), `menu_bar` (Enter / ArrowDown opens the focused trigger, Tab walks the dropdown items, Enter activates, Escape closes), `table` (arrows move the highlighted row with auto-scroll, Enter activates). Remaining: `rich_text` (selection editing - feature-sized), `toast` (deliberately deferred: transient, auto-dismissing). `dock` delivered 2026-09-13: tabs are Tab-focusable with Enter / Space switching, and the split divider is arrow-resizable like the standalone splitter.
- **Current State**:
  Core input controls (button, slider, toggle, checkbox, radio, text_edit, knob, fader, dialog, segmented_control, tree_view, code_editor, color_picker) register focusables and handle Space / Enter / arrows. Twelve interactive surfaces never call `register_focusable`, so Tab cannot reach them: `badge` / `tag` close buttons, `breadcrumb` items, `scroll_area` (keyboard scrolling), `splitter` (keyboard resize), `toast` close, `window` (keyboard move), `context_menu`, `dock`, `menu_bar` dropdowns, `rich_text` (selection), `table` (row navigation).
- **Why it matters**:
  Keyboard-only operation is a stated milestone acceptance criterion, and containers are the gap.
- **Remediation**:
  - Follow the established pattern: `register_focusable` + explicit key consumption + focus ring rendering, per widget, with a whitebox test each.
  - Modals that already own full keyboard flows (`command_palette`) are exempt.
  - Feature-sized work: schedule as a dedicated pass rather than drive-by fixes.

---


### DEBT-TEST-01 (P3): Whitebox Coverage Gaps in `src/composite` Containers
- **Location**: [src/composite/](file:///a:/moonbit-project/src/composite/)
- **Status**: Backlog
- **Category**: Test Infrastructure
- **Current State**:
  `moon coverage analyze` reports 622 uncovered lines in `src/`, concentrated in `dock` (59), `code_editor` (54), `context_menu` (52), `containers` (35), `splitter` (32), `rich_text` (31), `color_picker` (29), `command_palette` (28) — mostly interaction branches (dragging, clipping, sub-menus).
- **Why it matters**:
  The ARCH-06 migration and the 2026-09-13 interaction fixes both showed that "tests pass" can hide real defects; these files carry the largest untested surface.
- **Remediation**:
  - Cover drag / clip / occlusion branches per widget with headless frame sequences (scripted `RawInput`), following the toast close-button frame-two regression test as the template.

---


### DEBT-ARCH-01 (P3): `composite -> widgets` Dependency Edge Not Yet Declared
- **Location**: [src/composite/moon.pkg](file:///a:/moonbit-project/src/composite/moon.pkg)
- **Status**: Backlog
- **Category**: Package Architecture
- **Current State**:
  The layering rules permit `composite -> widgets`, but no composite component embeds a standard control in production code, and whitebox-test usage does not count as import usage (an unused import triggers `unused_package`). The edge is exercised only from the blackbox suite ([test/smoke_test.mbt](file:///a:/moonbit-project/test/smoke_test.mbt)).
- **Remediation**:
  Declare the import the first time a composite component embeds a standard control (for example an empty-dock placeholder rendered with `@widgets`).

---


---


## 16. Prioritized Roadmap & Milestone Matrix

| Track | ID | Title | Priority | Status |
| :--- | :--- | :--- | :--- | :--- |
| **bug** | `BUG-CORE-01` | Generational Hash Map Persistent State & Frame Pruning | **P0** | Resolved (Phase 2) |
| **bug** | `BUG-CORE-02` | Zero-Allocation Integer ID Derivation & Stack Hashing | **P0** | Resolved (Phase 2) |
| **bug** | `BUG-INPUT-01` | Secondary Pointer Events (Right-Click) & Context Menu | **P1** | Resolved (Phase 1) |
| **bug** | `BUG-INPUT-02` | Event Consumption (Prevent Tab loss in CodeEditor) | **P1** | Resolved (Phase 1) |
| **bug** | `BUG-INPUT-03` | Complete Tab Focus Navigation Chain Across All Widgets | **P1** | Resolved (Phase 1) |
| **bug** | `BUG-INPUT-04` | Keyboard Activation (Space/Enter) on Focused Controls | **P1** | Resolved (Phase 1) |
| **bug** | `BUG-INPUT-05` | Touch Gestures & Horizontal Trackpad Delta Forwarding | **P2** | Resolved (Phase 3) |
| **bug** | `BUG-TEXT-01` | LRU Typographical Measurement Cache & Unicode Block Sizing | **P1** | Resolved (Phase 3) |
| **bug** | `BUG-TEXT-02` | Atomic Surrogate Navigation & Grapheme Editing Traversal | **P1** | Resolved (Phase 3) |
| **bug** | `BUG-TEXT-03` | CJK Word-Wrapping & Line Breaking in RichText | **P1** | Resolved (Phase 3) |
| **bug** | `BUG-TEXT-04` | Hidden Browser IME Textarea Bridge in Web Runner | **P1** | Resolved (Phase 3) |
| **bug** | `BUG-WIDGET-01`| Interactive Scrollbar Thumb Dragging & Page Stepping | **P2** | Resolved (Phase 4) |
| **bug** | `BUG-WIDGET-02`| Post-Closure Content Height Clamping in ScrollArea | **P2** | Resolved (Phase 4) |
| **bug** | `BUG-WIDGET-03`| CodeEditor Binary Search Hit-Testing & Viewport Scrolling | **P2** | Resolved (Phase 4) |
| **bug** | `BUG-WIDGET-04`| CodeEditor Range Selection Buffers & Drag Highlighting | **P2** | Resolved (Phase 4) |
| **bug** | `BUG-WIDGET-05`| Dialog Dynamic Height Measurement & Tab Focus Trapping | **P2** | Resolved (Phase 4) |
| **bug** | `BUG-WIDGET-06`| CommandPalette Scissor-Clipped Height Clamping & Scrolling | **P2** | Resolved (Phase 4) |
| **bug** | `BUG-WIDGET-07`| ComboBox Upward Boundary Collision Flipping & Scrolling | **P2** | Resolved (Phase 4) |
| **bug** | `BUG-WIDGET-08`| Splitter Zero-Dimension Guards & Safe Min-Px Clamping | **P2** | Resolved (Phase 4) |
| **bug** | `BUG-WIDGET-09`| Tooltip Viewport Boundary Clamping & Toast Hover Blocking | **P2** | Resolved (Phase 4) |
| **bug** | `BUG-WIDGET-10`| Design Tokens Normalization Across Auxiliary Widgets | **P2** | Resolved (Phase 4) |
| **bug** | `BUG-WIDGET-11`| ContextMenu Cascading Multi-Level Submenus | **P2** | Resolved (Phase 4) |
| **bug** | `BUG-DRAW-01` | LinearGradient Primitive in DrawCmd & Canvas Backends | **P2** | Resolved (Phase 4) |
| **bug** | `BUG-DRAW-02` | Elimination of Redundant Per-Cell Canvas Save/Restores | **P3** | Resolved (Phase 4) |
| **bug** | `BUG-DRAW-03` | `DrawCmd::Text` Font Family and Weight Metadata | **P3** | Resolved (Phase 8) |
| **feat** | `FEAT-SHOWCASE-01`| Full Self-Hosted Pure Canvas Studio Workbench | **P1** | Resolved (Phase 5) |
| **feat** | `FEAT-CORE-02` | Auto-Wrapping Flow Layout (`horizontal_wrapped`) | **P1** | Resolved (Phase 6) |
| **feat** | `FEAT-CORE-03` | Runtime Dynamic Theming (`studio_light`, `slate_dark`) | **P2** | Resolved (Phase 6) |
| **feat** | `FEAT-CORE-04` | Immediate-Mode Animation Tweening State Machine | **P2** | Resolved (Phase 6) |
| **feat** | `FEAT-SHOWCASE-02`| Live Interactive Sandboxes in Docs | **P2** | Backlog |
| **feat** | `FEAT-SHOWCASE-03`| Native In-Canvas Studio Header Bar in Benchmark | **P3** | Backlog |
| **feat** | `FEAT-CORE-01` | Multi-Window Docking Layout System (`DockArea`) | **P3** | Resolved (Phase 7) |
| **feat** | `FEAT-CORE-05` | Immediate-Mode Plotting & Charting Suite (`plot`, `bar_chart`) | **P3** | Resolved (Phase 7) |
| **arch** | `ARCH-01` | `UIContext` God-Object Subsystem Modularization | **P1** | Resolved (Phase 2) |
| **arch** | `ARCH-02` | Generic Keyed State Storage (`Memory` / `IdMap`) | **P1** | Resolved (Phase 1) |
| **arch** | `ARCH-03` | `WidgetStyle` Token Decoupling (System vs Component) | **P1** | Resolved (Phase 4) |
| **arch** | `ARCH-04` | First-Class Widget Structs & Fluent Builder Protocol | **P1** | Resolved (Phase 5) |
| **arch** | `ARCH-05` | `Painter` Rendering & Scissor Coordinate Abstraction | **P2** | Resolved (Phase 3) |
| **arch** | `ARCH-06` | Multi-Package Hierarchy (Decompose `src/core` Monolith) | **P2** | Resolved (Phase 9) |
| **arch** | `ARCH-07` | Showcase Stage Modularization (`gallery_stage.mbt`) | **P2** | Resolved (Phase 6) |
| **a11y** | `FEAT-A11Y-01` | Keyboard Reachability for Container & Overlay Widgets | **P2** | In Progress (15 of 16 surfaces) |
| **test** | `DEBT-TEST-01` | Whitebox Coverage Gaps in `src/composite` Containers | **P3** | Backlog |
| **arch** | `DEBT-ARCH-01` | Declare `composite -> widgets` Dependency Edge | **P3** | Backlog |
| **logic** | `AUDIT-LOGIC-01` | Dual-Channel Text Ingestion In Web Host Causing Input Duplication | **P0** | Resolved (Iteration 1) |
| **logic** | `AUDIT-LOGIC-02` | Key-Up Event Dropping When Key Pressed Outside Canvas Focus | **P1** | Resolved (Iteration 1) |
| **logic** | `AUDIT-LOGIC-03` | LayerManager Flat Boolean State Causing Nested Foreground Premature Exit | **P2** | Resolved (Iteration 1) |
| **robust**| `AUDIT-ROBUST-01`| Unbounded Sub-stepping Loop in `Spring::step` Under Large Frame Deltas or NaN | **P1** | Resolved (Iteration 1) |
| **robust**| `AUDIT-ROBUST-02`| Uninitialized Initial Mouse Delta Spike on Frame Zero | **P2** | Resolved (Iteration 1) |
| **robust**| `AUDIT-ROBUST-03`| Non-Finite Interpolation Parameter in `Color::lerp` Propagating Malformed RGBA | **P2** | Resolved (Iteration 1) |
| **perf** | `AUDIT-PERF-01` | High-Frequency String Allocation & Fractional Truncation in Text Cache | **P1** | Resolved (Iteration 1) |
| **perf** | `AUDIT-PERF-02` | Granular Line Segment Flooding During Node Connection Wire Drawing | **P2** | Backlog |
| **maint** | `AUDIT-MAINT-01` | Systemic Theme Bypass via Direct Semantic Palette Token Calls in Widgets | **P1** | Backlog |
| **maint** | `AUDIT-MAINT-02` | Residual Widget-Specific Identifier Fields in `UIContext` Violating Decoupling | **P1** | Resolved (Iteration 1) |
| **maint** | `AUDIT-MAINT-03` | Unscaled Metric Literals Bypassing Global Scale Invariance in Slider | **P2** | Resolved (Iteration 1) |
| **dogfood**| `AUDIT-DOGFOOD-01`| Raw HTML/DOM Top Header Bar in Benchmark Violating Pure Canvas Standard | **P1** | Backlog |
| **ux** | `AUDIT-UX-01` | Missing Horizontal Scrolling and Header Clamping in Wide Composite Tables | **P2** | Resolved (Iteration 3) |
| **ux** | `AUDIT-UX-02` | Fixed-Width Value Text Container Causing Numeric Clipping & Layout Jitter | **P2** | Resolved (Iteration 2) |
| **doc** | `AUDIT-DOC-01` | Obsolete Method Signatures and Missing Post-v0.3 Components in API Reference | **P2** | Resolved (Iteration 3) |
| **doc** | `AUDIT-DOC-02` | Stale Monolithic `UIContext` Struct Code Sample in Flagship Studio IDE | **P3** | Resolved (Iteration 3) |
| **logic** | `AUDIT-LOGIC-04` | Infinite Allocation Loop & OOM Crash on Unbalanced `begin_foreground` | **P0** | Resolved (Iteration 1) |
| **logic** | `AUDIT-LOGIC-05` | Unreleased `active_id` in DockArea Splitter Causing Mouse Capture Leaks | **P1** | Resolved (Iteration 1) |
| **robust**| `AUDIT-ROBUST-04`| Negative Rect Dimension Arithmetic Trap Under Squeezed Dock Nodes | **P1** | Resolved (Iteration 1) |
| **robust**| `AUDIT-ROBUST-05`| Stale Index Mismatch & Positional Jumping on Toast Manual Dismissal | **P2** | Resolved (Iteration 1) |
| **perf** | `AUDIT-PERF-03` | 70-Command Quad Mesh Flood in 2D Color Picker Sat/Val Surface | **P2** | Resolved (Iteration 2) |
| **maint** | `AUDIT-MAINT-04` | Unscaled Layout Literals and Theme Tokens in Scroll & Toast Containers | **P2** | Resolved (Iteration 1) |
| **dogfood**| `AUDIT-DOGFOOD-02`| Extensive HTML/DOM Simulation of App Header, Toolbar, HUD in Minesweeper | **P1** | Backlog |
| **ux** | `AUDIT-UX-03` | Lack of Horizontal Scrolling in Single-Line `TextEdit` Causing Caret Clipping | **P1** | Resolved (Iteration 2) |
| **ux** | `AUDIT-UX-04` | Non-Interactive Scrollbar Thumb & Missing Keyboard Focus in VirtualList | **P2** | Resolved (Iteration 2) |
| **ux** | `AUDIT-UX-05` | Hue Reset to 0° When Selecting Black, White, or Grayscale in ColorPicker | **P2** | Resolved (Iteration 2) |
| **ux** | `AUDIT-UX-06` | Unconsumed Editing & Navigation Keys Leaking into Parent Containers | **P2** | Resolved (Iteration 2) |
| **doc** | `AUDIT-DOC-03` | Missing SVG Text Baseline Alignment Causing Vertical Text Misplacement | **P2** | Resolved (Iteration 2) |
| **doc** | `AUDIT-DOC-04` | Undocumented Primitive Loss in `DrawList::to_mesh` (Text, Gradient Omissions) | **P3** | Resolved (Iteration 2) |
| **robust**| `AUDIT-ROBUST-06`| Raw Mouse Position Hit-Testing & Missing Cursor in Plot/BarChart | **P2** | Resolved (Iteration 3) |
| **maint** | `AUDIT-MAINT-05` | Unscaled Metric Literals and Invariant Violations in Table and Plot | **P2** | Resolved (Iteration 3) |
| **ux** | `AUDIT-UX-07` | Unconsumed Navigation Keys & Missing Focus Indicator in Knob and SegmentedControl | **P2** | Resolved (Iteration 3) |
| **a11y** | `AUDIT-A11Y-02` | Keyboard Activation Missing in Checkbox, Radio, Toggle & Unreachable color_button | **P1** | Resolved (Iteration 4) |
| **maint** | `AUDIT-MAINT-06` | Hardcoded Viewport Boundaries & Unscaled Layout Literals in Containers & Controls | **P1** | Resolved (Iteration 4) |
| **ux** | `AUDIT-UX-08` | Positional Thumb Snapping and Zero Cursor Affordance in ScrollArea | **P2** | Resolved (Iteration 4) |
| **logic** | `AUDIT-LOGIC-06` | Scissor Clipping and Hit-Test Isolation Bypass in DockArea and NodeEditor | **P2** | Resolved (Iteration 4) |
| **ux** | `AUDIT-UX-09` | Missing Vertical Scrolling, Wheel Ingestion & Auto-Scroll in Fixed-Size TreeView | **P2** | Resolved (Iteration 4) |
| **perf** | `AUDIT-PERF-04` | 16-Command Discrete Strip Flood in ColorPicker Alpha Slider & ProgressBar NaN | **P2** | Resolved (Iteration 4) |
| **a11y** | `AUDIT-A11Y-03` | Missing Home, End, PageUp, PageDown Range Navigation in Slider & Fader | **P1** | Resolved (Iteration 5) |
| **maint** | `AUDIT-MAINT-07` | Hardcoded Viewport Boundaries, Unscaled Strokes in Dialog, Tooltip, Window | **P1** | Resolved (Iteration 5) |
| **ux** | `AUDIT-UX-10` | Splitter Missing Home/End Ratio Snapping & Unscaled Handle Hover Zone | **P2** | Resolved (Iteration 5) |
| **robust**| `AUDIT-ROBUST-07`| Non-Finite & NaN Sensitivity in Fader, Knob, and Stepper Controls | **P2** | Resolved (Iteration 5) |
| **a11y** | `AUDIT-A11Y-04` | Stepper Range Navigation Omission & Unscaled Divider Strokes | **P2** | Resolved (Iteration 5) |
| **perf** | `AUDIT-PERF-05` | Unbounded Growth of Window Batches & Stale Focus IDs in WindowManager | **P2** | Resolved (Iteration 5) |
| **maint** | `AUDIT-MAINT-08` | Systemic Unscaled Literals in `Tag` and `Badge` | **P1** | Resolved (Iteration 6) |
| **robust**| `AUDIT-ROBUST-08`| Non-Finite & NaN Sensitivity in `Rating` | **P2** | Resolved (Iteration 6) |
| **a11y** | `AUDIT-A11Y-05` | Missing Coarse Range Stepping in `Pagination` & Unscaled Strokes | **P2** | Resolved (Iteration 6) |
| **maint** | `AUDIT-MAINT-09` | Unscaled Layout Offsets & Focus Ring Metrics in `Steps` and `Breadcrumb` | **P2** | Resolved (Iteration 6) |
| **robust**| `AUDIT-ROBUST-09`| Non-finite & NaN Sensitivity in `Spinner` Animation State | **P2** | Resolved (Iteration 7) |
| **a11y** | `AUDIT-A11Y-06` | Missing `Home`/`End` Range Navigation & Unscaled Strokes in `SegmentedControl` | **P2** | Resolved (Iteration 7) |
| **maint** | `AUDIT-MAINT-10` | Static Fallback Viewport Dimensions & Unscaled Literals in `Toast` | **P1** | Resolved (Iteration 7) |
| **perf** | `AUDIT-PERF-07` | Raw Mouse Hit Testing & Static Wire Sub-segment Flood in `NodeEditor` | **P2** | Resolved (Iteration 7) |
| **maint** | `AUDIT-MAINT-11` | Unscaled Arrow Geometries & Container Borders in `collapsing_header`/`tab_bar` | **P1** | Resolved (Iteration 8) |
| **a11y** | `AUDIT-A11Y-07` | Missing `ArrowRight`/`ArrowLeft` in `collapsing_header` & `Home`/`End` in `tab_bar` | **P2** | Resolved (Iteration 8) |
| **robust**| `AUDIT-ROBUST-10`| Non-Finite & NaN Scroll Offset Propagation in `VirtualList` | **P2** | Resolved (Iteration 8) |
| **maint** | `AUDIT-MAINT-12` | Unscaled Inline Code Padding & Link Underline Metrics in `RichText` | **P2** | Resolved (Iteration 8) |





