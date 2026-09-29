# Technical Inventory: Active Defects & Feature Roadmap

<p>
  <a href="ISSUE.md">English</a> · <a href="ISSUE_zh.md">简体中文</a>
</p>

> [!NOTE]
> **Resolved Issues Archive**: All 90+ historically resolved defects (`BUG-*`, `ARCH-*`, delivered `FEAT-*`, and resolved `AUDIT-*` items) have been archived to **[ISSUE_ARCHIVE.md](ISSUE_ARCHIVE.md)** ([中文归档](ISSUE_ARCHIVE_zh.md)).
> This document tracks exclusively **active defects**, **pending engine capabilities**, and the **milestone status matrix**.

---

# Part I: Active Defects & Code Review Audit (`bug` / `audit`)

> [!NOTE]
> All primary defects and dogfooding audit items have been resolved and archived. See [ISSUE_ARCHIVE.md](ISSUE_ARCHIVE.md).

---

## 14. User Experience & Interaction (`ux`)


---

# Part II: Engine Capabilities & Dogfooding Roadmap (`feat`)

> [!NOTE]
> All planned engine capabilities, showcase tools, and interactive visualizers (`FEAT-SHOWCASE-01` through `05`, `FEAT-CORE-01` through `05`, `FEAT-A11Y-01`) have been fully implemented and verified. See [ISSUE_ARCHIVE.md](ISSUE_ARCHIVE.md).

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
| **feat** | `FEAT-SHOWCASE-02`| Live Interactive Sandboxes in Docs | **P2** | Resolved (Iteration 15) |
| **feat** | `FEAT-SHOWCASE-03`| Native In-Canvas Studio Header Bar in Benchmark | **P3** | Resolved (Iteration 12) |
| **feat** | `FEAT-SHOWCASE-04`| Interactive Architecture & Pipeline Visualizers in Wiki | **P3** | Resolved (Iteration 17) |
| **feat** | `FEAT-SHOWCASE-05`| Embedded Interactive Micro-Playground in Hero Section | **P3** | Resolved (Iteration 17) |
| **feat** | `FEAT-CORE-01` | Multi-Window Docking Layout System (`DockArea`) | **P3** | Resolved (Phase 7) |
| **feat** | `FEAT-CORE-05` | Immediate-Mode Plotting & Charting Suite (`plot`, `bar_chart`) | **P3** | Resolved (Phase 7) |
| **arch** | `ARCH-01` | `UIContext` God-Object Subsystem Modularization | **P1** | Resolved (Phase 2) |
| **arch** | `ARCH-02` | Generic Keyed State Storage (`Memory` / `IdMap`) | **P1** | Resolved (Phase 1) |
| **arch** | `ARCH-03` | `WidgetStyle` Token Decoupling (System vs Component) | **P1** | Resolved (Phase 4) |
| **arch** | `ARCH-04` | First-Class Widget Structs & Fluent Builder Protocol | **P1** | Resolved (Phase 5) |
| **arch** | `ARCH-05` | `Painter` Rendering & Scissor Coordinate Abstraction | **P2** | Resolved (Phase 3) |
| **arch** | `ARCH-06` | Multi-Package Hierarchy (Decompose `src/core` Monolith) | **P2** | Resolved (Phase 9) |
| **arch** | `ARCH-07` | Showcase Stage Modularization (`gallery_stage.mbt`) | **P2** | Resolved (Phase 6) |
| **a11y** | `FEAT-A11Y-01` | Keyboard Reachability for Container & Overlay Widgets | **P2** | Resolved (Iteration 16) |
| **test** | `DEBT-TEST-01` | Whitebox Coverage Gaps in `src/composite` Containers | **P3** | Resolved (Iteration 14) |
| **arch** | `DEBT-ARCH-01` | Declare `composite -> widgets` Dependency Edge | **P3** | Resolved (Iteration 13) |
| **logic** | `AUDIT-LOGIC-01` | Dual-Channel Text Ingestion In Web Host Causing Input Duplication | **P0** | Resolved (Iteration 1) |
| **logic** | `AUDIT-LOGIC-02` | Key-Up Event Dropping When Key Pressed Outside Canvas Focus | **P1** | Resolved (Iteration 1) |
| **logic** | `AUDIT-LOGIC-03` | LayerManager Flat Boolean State Causing Nested Foreground Premature Exit | **P2** | Resolved (Iteration 1) |
| **robust**| `AUDIT-ROBUST-01`| Unbounded Sub-stepping Loop in `Spring::step` Under Large Frame Deltas or NaN | **P1** | Resolved (Iteration 1) |
| **robust**| `AUDIT-ROBUST-02`| Uninitialized Initial Mouse Delta Spike on Frame Zero | **P2** | Resolved (Iteration 1) |
| **robust**| `AUDIT-ROBUST-03`| Non-Finite Interpolation Parameter in `Color::lerp` Propagating Malformed RGBA | **P2** | Resolved (Iteration 1) |
| **perf** | `AUDIT-PERF-01` | High-Frequency String Allocation & Fractional Truncation in Text Cache | **P1** | Resolved (Iteration 1) |
| **perf** | `AUDIT-PERF-02` | Granular Line Segment Flooding During Node Connection Wire Drawing | **P2** | Resolved (Iteration 9) |
| **maint** | `AUDIT-MAINT-01` | Systemic Theme Bypass via Direct Semantic Palette Token Calls in Widgets | **P1** | Resolved (Iteration 10) |
| **maint** | `AUDIT-MAINT-02` | Residual Widget-Specific Identifier Fields in `UIContext` Violating Decoupling | **P1** | Resolved (Iteration 1) |
| **maint** | `AUDIT-MAINT-03` | Unscaled Metric Literals Bypassing Global Scale Invariance in Slider | **P2** | Resolved (Iteration 1) |
| **dogfood**| `AUDIT-DOGFOOD-01`| Raw HTML/DOM Top Header Bar in Benchmark Violating Pure Canvas Standard | **P1** | Resolved (Iteration 11) |
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
| **dogfood**| `AUDIT-DOGFOOD-02`| Extensive HTML/DOM Simulation of App Header, Toolbar, HUD in Minesweeper | **P1** | Resolved (Iteration 12) |
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
| **maint** | `AUDIT-MAINT-13` | Systemic Unscaled Border Strokes & Splitter Dots in Button, Checkbox, TextEdit, Splitter | **P1** | Resolved (Iteration 9) |






