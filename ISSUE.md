# Technical Inventory: Defects (bug) and Feature Capabilities (feat)

This document provides a systematic, factual audit of the codebase (`src/core`, `src/draw`, `src/color`, `src/math`, and runtime showcase pages).

It is organized into four primary tracks:
- **Part I: Defects and Technical Debt (`bug`)**: Memory leaks, state corruption, unhandled input channels, typographical drift, and widget edge-case omissions.
- **Part II: Engine Capabilities and Dogfooding Roadmap (`feat`)**: Core engine extensions, layout enhancements, and showcase pages where raw HTML/DOM should be replaced by our native MoonBit GUI engine.
- **Part III: Structural Decoupling and Architecture Modularization (`arch`)**: Subsystem modularization, generic memory persistence, design token stratification, first-class widget structs, painter rendering abstraction, package hierarchy, and showcase stage decomposition.
- **Part IV: Post-v0.5.1 Comprehensive Code Review Audit (`audit`)**: Robustness, maintainability, performance, technical documentation, non-code dogfooding bugs, logical errors, and UX impact.

---

# Part I: Defects and Technical Debt (`bug`)

Items are prioritized as:
- **P0**: Memory leaks, unbounded allocation, state corruption, or arithmetic crashes.
- **P1**: Incomplete core subsystems, missing standard input channels, or typographical measurement flaws.
- **P2**: Widget functional omissions, accessibility barriers, or edge-case layout failures.
- **P3**: Performance optimization opportunities and rendering primitive expressiveness gaps.

---

## 1. Core Architecture and State Management

### BUG-CORE-01 (P0) [RESOLVED]: Unbounded Memory Growth and $O(N)$ Linear Lookups in Persistent State Arrays
- **Location**: [src/core/context.mbt#L35-L45](file:///a:/moonbit-project/src/core/context.mbt#L35-L45), [Lines 725-866](file:///a:/moonbit-project/src/core/context.mbt#L725-L866)
- **Status**: **RESOLVED** (Phase 2). Upgraded all 5 persistent state arrays to `@hashmap.HashMap[Id, T]` and implemented generational pruning via `prune_stale_state(ttl_frames)`.
- **Description**:
  `UIContext` stores persistent widget state across frames using linear association lists:
  - `scroll_offsets : Array[(Id, Double)]`
  - `scroll_content_heights : Array[(Id, Double)]`
  - `window_positions : Array[(Id, @math.Vec2)]`
  - `text_cursor_positions : Array[(Id, Int)]`
  - `open_collapsing_ids : Array[(Id, Bool)]`
- **Failure Mechanism**:
  1. Every lookup and update performs a linear scan `for i = 0; i < len; i = i + 1`.
  2. Widgets that are destroyed, unmounted, or conditionally hidden never release their records. Entries accumulate monotonically throughout the session.
  3. In long-running applications with dynamic navigation or virtualized views, memory consumption grows unbounded and frame lookup times degrade to $O(N)$.
- **Remediation**:
  - Replace `Array[(Id, T)]` with a hash table (`@hashmap.HashMap[Id, T]`) or generational slot map.
  - Implement frame-counter generational tracking: prune records whose IDs were not touched for more than $K$ frames during `end_frame`.

---

### BUG-CORE-02 (P0) [RESOLVED]: Positional Auto-ID Collisions and State Invalidation Under Dynamic Rendering
- **Location**: [src/core/context.mbt#L307-L308](file:///a:/moonbit-project/src/core/context.mbt#L307-L308)
- **Status**: **RESOLVED** (Phase 2). Implemented `Id::from_int`, `Id::with_int`, and `IdStack::derive_int` using 64-bit FNV-1a integer hashing, completely eliminating per-frame string allocations in `allocate_space`.
- **Description**:
  In `allocate_space`, auto-derived identifiers depend on a monotonic counter reset every frame:
  ```moonbit
  self.auto_id_counter = self.auto_id_counter + 1
  let id = self.id_stack.derive_id(self.auto_id_counter.to_string())
  ```
- **Failure Mechanism**:
  1. If any widget is conditionally displayed (`if condition { ui.label(...) }`), every downstream widget's `auto_id_counter` shifts by the number of allocated widgets.
  2. Downstream widgets inherit persistent state (scroll position, text cursor, focus, collapsing state) belonging to an unrelated widget from the previous frame.
  3. Every call allocates a new heap `String` via `self.auto_id_counter.to_string()`. In an interface with 500 widgets running at 60 FPS, this generates 30,000 transient string allocations per second.
- **Remediation**:
  - Provide an integer-based ID derivation method `Id::derive_int(seed : UInt64, index : Int) -> Id` to eliminate per-frame string allocations.
  - Mandate explicit caller-provided `id_salt` for all state-bearing widgets (`TextEdit`, `ScrollArea`, `CollapsingHeader`, `Window`).

---

## 2. Input System and Event Dispatch Pipeline

### BUG-INPUT-01 (P1) [RESOLVED]: Single-Button Mouse Model and Absence of Secondary / Auxiliary Pointer Events
- **Location**: [src/core/input.mbt#L86-L94](file:///a:/moonbit-project/src/core/input.mbt#L86-L94), [src/core/input.mbt#L151-L165](file:///a:/moonbit-project/src/core/input.mbt#L151-L165), [examples/canvas/js/gallery_runner.js#L136-L150](file:///a:/moonbit-project/examples/canvas/js/gallery_runner.js#L136-L150)
- **Status**: **RESOLVED** (Phase 1). Added secondary mouse tracking to `RawInput`/`InputState`, `secondary_clicked` to `Response`, and right-click context menu handling.
- **Description**:
  `RawInput` and `InputState` only support a single boolean mouse button (`mouse_down : Bool`, `mouse_pressed`, `mouse_released`).
- **Failure Mechanism**:
  1. Secondary click (right-click) and auxiliary click (middle-click) cannot be represented.
  2. Right-clicking the web canvas triggers the browser's native context menu because `contextmenu` is not prevented in the JS driver.
  3. `ContextMenu` cannot be triggered natively via right-click; `examples/canvas/gallery_stage.mbt` works around this by triggering menus via an explicit primary-click push button.
- **Remediation**:
  - Add `mouse_secondary_down : Bool` and `mouse_middle_down : Bool` (or a bitmask `mouse_buttons : Int`) to `RawInput` and `InputState`.
  - Add `contextmenu` event interception with `e.preventDefault()` to the canvas driver.
  - Update `context_menu_items` to evaluate secondary click activation.

---

### BUG-INPUT-02 (P1) [RESOLVED]: Global Event Interception Without Widget Event Consumption (`event.consume()`)
- **Location**: [src/core/context.mbt#L160-L182](file:///a:/moonbit-project/src/core/context.mbt#L160-L182), [src/core/code_editor.mbt#L255-L264](file:///a:/moonbit-project/src/core/code_editor.mbt#L255-L264)
- **Status**: **RESOLVED** (Phase 1). Implemented `consume_key` on `InputState`, integrated into `CodeEditor` for Tab and Enter, and checked in `UIContext::end_frame`.
- **Description**:
  The input system does not support consuming an event once handled by an active widget.
- **Failure Mechanism**:
  1. In `CodeEditor`, pressing `Key::Tab` inserts two spaces into the document buffer.
  2. However, at `UIContext::end_frame`, the engine evaluates `if self.input.key_pressed(Key::Tab)` globally and moves focus to the next focusable widget.
  3. The user cannot use Tab for code indentation without inadvertently losing focus.
- **Remediation**:
  - Implement an event consumption mechanism on `InputState` (e.g. `self.input.consume_key(Key::Tab)`).
  - Modify `end_frame` focus traversal to only act on unconsumed Tab key events.

---

### BUG-INPUT-03 (P1) [RESOLVED]: Incomplete Keyboard Focus Chain Across Interactive Widgets
- **Location**: [src/core/button.mbt#L45](file:///a:/moonbit-project/src/core/button.mbt#L45), [src/core/slider.mbt#L23](file:///a:/moonbit-project/src/core/slider.mbt#L23), [src/core/toggle.mbt#L14](file:///a:/moonbit-project/src/core/toggle.mbt#L14), [src/core/containers.mbt#L119](file:///a:/moonbit-project/src/core/containers.mbt#L119)
- **Status**: **RESOLVED** (Phase 1). Registered `button`, `checkbox`, `toggle`, `slider`, and `combo_box` into the Tab navigation ring and added visual focus indicators.
- **Description**:
  Only 6 of 22 widgets register themselves into the Tab navigation ring via `self.register_focusable(id)` (`code_editor`, `knob`, `segmented_control`, `text_edit`, `radio`, `tree_view`).
- **Failure Mechanism**:
  - `Button`, `Checkbox`, `Toggle` (switch), `Slider`, `ComboBox`, `ColorButton`, `Breadcrumb`, and `Table` never register with `register_focusable`.
  - Keyboard users navigating with `Tab` or `Shift+Tab` completely skip all buttons, checkboxes, and sliders.
- **Remediation**:
  - Register all primary interactive controls in `register_focusable`.
  - Provide a visual focus ring (`@color.Color::border_focus()`) on all controls when `resp.has_focus()`.

---

### BUG-INPUT-04 (P1) [RESOLVED]: Focused Interactive Widgets Lack Keyboard Activation Handlers
- **Location**: [src/core/button.mbt#L45-L58](file:///a:/moonbit-project/src/core/button.mbt#L45-L58), [src/core/toggle.mbt#L18](file:///a:/moonbit-project/src/core/toggle.mbt#L18), [src/core/toggle.mbt#L91](file:///a:/moonbit-project/src/core/toggle.mbt#L91)
- **Status**: **RESOLVED** (Phase 1). Unified keyboard activation (Space/Enter) in `allocate_space`, added ArrowLeft/Right to `Slider`, and dropdown keyboard controls to `ComboBox`.
- **Description**:
  Even when widgets receive focus, click detection is strictly tied to pointer interaction:
  ```moonbit
  let clicked = is_active && self.input.mouse_released && hovered
  ```
- **Failure Mechanism**:
  - A focused `Button` does not activate upon pressing `Key::Enter` or `Key::Space`.
  - A focused `Checkbox` or `Radio` does not toggle upon pressing `Key::Space`.
  - A focused `Slider` does not respond to `Key::ArrowLeft` or `Key::ArrowRight`.
- **Remediation**:
  - In `allocate_space` or widget response handling, recognize `has_focus && (key_pressed(Space) || key_pressed(Enter))` as a click event.
  - Implement left/right arrow increment and decrement logic in `Slider`.

---

### BUG-INPUT-05 (P2) [RESOLVED]: Missing Horizontal Scroll Delta and Touch Gestures
- **Location**: [src/core/input.mbt#L89](file:///a:/moonbit-project/src/core/input.mbt#L89), [src/core/scroll_area.mbt#L40](file:///a:/moonbit-project/src/core/scroll_area.mbt#L40), [examples/canvas/js/gallery_runner.js#L157-L160](file:///a:/moonbit-project/examples/canvas/js/gallery_runner.js#L157-L160)
- **Status**: **RESOLVED** (Phase 3). Bound touch gestures (`touchstart`, `touchmove`, `touchend`, `touchcancel`) and horizontal trackpad wheel delta (`deltaX`) in `gallery_runner.js`.
- **Description**:
  The JS driver only accumulates `e.deltaY` (`scrollDy += e.deltaY`), discarding `e.deltaX`. Touch gestures (`touchstart`, `touchmove`, `touchend`) are not bound.
- **Failure Mechanism**:
  - Two-finger horizontal trackpad scrolling and shift-wheel horizontal scrolling are dropped.
  - Mobile touch screens cannot interact with canvas sliders, scrollbars, or text fields.
- **Remediation**:
  - Forward both `deltaX` and `deltaY` in `PointerWheel`.
  - Add touch event mapping in `gallery_runner.js` to emulate pointer movement and click states.

---

## 3. Typography and Text Measurement Engine

### BUG-TEXT-01 (P1) [RESOLVED]: Hardcoded ASCII Ratio Tables and Fixed CJK Multipliers
- **Location**: [src/core/context.mbt#L669-L709](file:///a:/moonbit-project/src/core/context.mbt#L669-L709)
- **Status**: **RESOLVED** (Phase 3). Expanded typographical ratios into categorized Unicode blocks (Fullwidth, CJK, Halfwidth Katakana, Latin-1, Punctuation), added single-width emoji surrogate handling, and implemented bounded string measurement caching in `UIContext::measure_text`.
- **Description**:
  `measure_text_size` estimates string bounding boxes via a hardcoded table `ascii_char_ratio(code)` and treats all non-ASCII characters (`code > 255`) with a constant factor of `font_size * 1.05`.
- **Failure Mechanism**:
  1. Font metrics vary significantly across typefaces and operating system renderers.
  2. Over strings of 20+ characters, cumulative measurement errors reach 5px to 15px relative to actual HTML5 Canvas `ctx.measureText` output.
  3. Caret placement and click-to-cursor hit testing in `TextEdit` and `CodeEditor` drift away from visual character boundaries.
- **Remediation**:
  - Provide a host measurement callback bridge for web environments (`ctx.measureText`) to retrieve true typographical metrics.
  - Cache measured widths using an LRU string measurement cache.

---

### BUG-TEXT-02 (P1) [RESOLVED]: Direct UTF-16 Code-Unit Slicing Corrupts Surrogate Pairs and Graphemes
- **Location**: [src/core/text_edit.mbt#L16-L27](file:///a:/moonbit-project/src/core/text_edit.mbt#L16-L27), [src/core/text_edit.mbt#L114-L138](file:///a:/moonbit-project/src/core/text_edit.mbt#L114-L138), [src/core/code_editor.mbt#L16-L28](file:///a:/moonbit-project/src/core/code_editor.mbt#L16-L28)
- **Status**: **RESOLVED** (Phase 3). Added `prev_char_boundary`, `next_char_boundary`, `delete_prev_char`, and `delete_next_char` in `src/core/unicode.mbt`. Integrated atomic surrogate navigation, backspace, delete, and hit-testing in `TextEdit` and `CodeEditor`.
- **Description**:
  String manipulation functions (`string_slice`) slice strings by raw index:
  ```moonbit
  s[safe_start:safe_end].to_owned()
  ```
- **Failure Mechanism**:
  1. Unicode characters outside the Basic Multilingual Plane (such as emojis or rare CJK characters) require two UTF-16 code units (surrogate pair).
  2. Cursor movement advances by 1 code unit, positioning the caret between surrogate halves.
  3. Backspacing deletes half of a surrogate pair, generating invalid lone surrogates that corrupt the string buffer.
- **Remediation**:
  - Implement Unicode scalar / grapheme cluster boundary traversal for text editing operations.

---

### BUG-TEXT-03 (P1) [RESOLVED]: Word-Wrapping in `RichText` Fails for Non-Spaced Scripts (CJK)
- **Location**: [src/core/rich_text.mbt#L80-L92](file:///a:/moonbit-project/src/core/rich_text.mbt#L80-L92)
- **Status**: **RESOLVED** (Phase 3). Implemented CJK character-by-character tokenization and wrapping, eliminated artificial 6px inter-character gaps, derived metrics from `self.style.rich_text_line_h`, and added CJK closing punctuation avoidance.
- **Description**:
  Line breaking in `rich_text` relies on splitting the input string by space:
  ```moonbit
  let words = span.text.split(" ")
  ```
- **Failure Mechanism**:
  - Chinese, Japanese, and Thai scripts do not delimit words with spaces.
  - An entire CJK paragraph contains zero spaces, producing an array of length 1.
  - The entire paragraph is treated as a single indivisible token, failing to wrap and overflowing the container boundary.
  - In English text, consecutive spaces or tabs are collapsed into single spaces and drawn with a fixed `6.0px` gap instead of true space glyph widths.
- **Remediation**:
  - Implement character-by-character line breaking for CJK ranges (`\u4e00` - `\u9fff`).

---

### BUG-TEXT-04 (P1) [RESOLVED]: Absence of Browser IME Composition in Web Runner
- **Location**: [examples/canvas/js/gallery_runner.js#L162-L178](file:///a:/moonbit-project/examples/canvas/js/gallery_runner.js#L162-L178)
- **Status**: **RESOLVED** (Phase 3). Implemented an off-screen hidden `<textarea id="canvasImeInput">` focused upon canvas interaction, capturing `compositionstart`, `compositionend`, and `input` events and seamlessly feeding composed text into `pendingText`.
- **Description**:
  The web runner listens directly to `keydown` on `<canvas>` and appends `e.key` to `pendingText`.
- **Failure Mechanism**:
  - No hidden `<input>` or `<textarea>` element is used to receive browser IME composition events (`compositionstart`, `compositionupdate`, `compositionend`).
  - Users cannot enter Chinese, Japanese, Korean, or accented characters into `TextEdit` or `CodeEditor`.
- **Remediation**:
  - Integrate a hidden, off-screen text input element synced with the active widget position to handle native IME composition.

---

## 4. Widget Functional Completeness and Edge Cases

### BUG-WIDGET-01 (P2) [RESOLVED]: `ScrollArea` Scrollbar Thumb is Non-Interactive
- **Location**: [src/core/scroll_area.mbt#L81-L112](file:///a:/moonbit-project/src/core/scroll_area.mbt#L81-L112)
- **Status**: **RESOLVED** (Phase 4). Allocated interactive Id for thumb rect, tracked vertical pointer dragging with cursor offset, and updated scroll_y proportionally.
- **Description**:
  The scrollbar thumb is drawn purely as a visual indicator.
- **Remediation**:
  - Allocate an interactive ID for the thumb rect, track vertical pointer dragging when active, and update `scroll_y` proportionally.

---

### BUG-WIDGET-02 (P2) [RESOLVED]: One-Frame Latency on `ScrollArea` Content Height and Dynamic Collapse Stalling
- **Location**: [src/core/scroll_area.mbt#L31-L52](file:///a:/moonbit-project/src/core/scroll_area.mbt#L31-L52), [src/core/scroll_area.mbt#L73-L75](file:///a:/moonbit-project/src/core/scroll_area.mbt#L73-L75)
- **Status**: **RESOLVED** (Phase 4). Implemented post-closure scroll position clamping against `final_content_h` before rendering thumb.
- **Description**:
  `max_scroll` was calculated from `prev_content_h` before executing `content(self)`.
- **Remediation**:
  - Perform post-closure scroll position clamping or clamp before drawing the scrollbar thumb.

---

### BUG-WIDGET-03 (P2) [RESOLVED]: `CodeEditor` Lacks Scrolling, Selection, and Re-Parses Lines Twice Every Frame
- **Location**: [src/core/code_editor.mbt#L133](file:///a:/moonbit-project/src/core/code_editor.mbt#L133), [src/core/code_editor.mbt#L334](file:///a:/moonbit-project/src/core/code_editor.mbt#L334)
- **Status**: **RESOLVED** (Phase 4). Implemented single-pass line splitting, vertical wheel scrolling, auto-scrolling to keep active caret in view, line culling outside viewport, and scrollbar thumb rendering.
- **Description**:
  `split_lines(current_text)` was called twice every frame without internal scrolling.
- **Remediation**:
  - Cache split lines, add vertical/horizontal scroll offsets, and auto-scroll to cursor.

---

### BUG-WIDGET-04 (P2) [RESOLVED]: `TextEdit` and `CodeEditor` Lack Selection, Clipboard, and History Buffers
- **Location**: [src/core/text_edit.mbt#L51-L81](file:///a:/moonbit-project/src/core/text_edit.mbt#L51-L81), [src/core/code_editor.mbt#L131-L187](file:///a:/moonbit-project/src/core/code_editor.mbt#L131-L187)
- **Status**: **RESOLVED** (Phase 4). Implemented binary search character hit-testing (`hit_test_char_pos`), range selection buffers (`selection_anchor`), `Ctrl+A`, Shift+Arrows, pointer drag selection, and selection wash highlighting.
- **Description**:
  Editors previously stored only a scalar cursor position without range selection.
- **Remediation**:
  - Introduce `selection_anchor`, implement binary search hit testing, and support range selection.

---

### BUG-WIDGET-05 (P2) [RESOLVED]: `Dialog` Lacks Focus Trapping and Dynamic Text Height Clamping
- **Location**: [src/core/dialog.mbt#L79-L88](file:///a:/moonbit-project/src/core/dialog.mbt#L79-L88), [src/core/dialog.mbt#L244-L245](file:///a:/moonbit-project/src/core/dialog.mbt#L244-L245)
- **Status**: **RESOLVED** (Phase 4). Added `wrap_dialog_message`, dynamic `card_h` calculation clamped against viewport, Tab focus trapping alternating between action buttons, and visual focus stroke rings.
- **Description**:
  Dialog previously used fixed card height and lacked Tab focus trapping.
- **Remediation**:
  - Dynamically calculate `card_h` and trap Tab focus within action buttons.

---

### BUG-WIDGET-06 (P2) [RESOLVED]: `CommandPalette` Lacks Height Clamping and Vertical Scrolling
- **Location**: [src/core/command_palette.mbt#L201-L215](file:///a:/moonbit-project/src/core/command_palette.mbt#L201-L215)
- **Status**: **RESOLVED** (Phase 4). Capped visible content height at 320px with scissor-clipped scrolling and automatic keyboard navigation centering.
- **Description**:
  Palette card height previously scaled linearly with filtered commands.
- **Remediation**:
  - Cap content height and wrap in scissor-clipped scrolling.

---

### BUG-WIDGET-07 (P2) [RESOLVED]: `ComboBox` Lacks Boundary Collision Flipping and Long-List Scrolling
- **Location**: [src/core/containers.mbt#L114](file:///a:/moonbit-project/src/core/containers.mbt#L114), [src/core/containers.mbt#L202-L210](file:///a:/moonbit-project/src/core/containers.mbt#L202-L210)
- **Status**: **RESOLVED** (Phase 4). Added upward boundary collision flipping and internal dropdown scrolling with scissor clipping.
- **Description**:
  ComboBox previously opened strictly downward and lacked scrolling for long lists.
- **Remediation**:
  - Add collision detection for upward flip and constrain menu height with scrolling.

---

### BUG-WIDGET-08 (P2) [RESOLVED]: `Splitter` Zero-Dimension Division and Constraint Inversion
- **Location**: [src/core/splitter.mbt#L54](file:///a:/moonbit-project/src/core/splitter.mbt#L54), [src/core/splitter.mbt#L89](file:///a:/moonbit-project/src/core/splitter.mbt#L89), [src/core/splitter.mbt#L207](file:///a:/moonbit-project/src/core/splitter.mbt#L207)
- **Status**: **RESOLVED** (Phase 4). Added `w <= 0.0 || h <= 0.0` guards and symmetric `safe_min_px` clamping to prevent dimension inversion.
- **Description**:
  Division `effective_ratio = left_w / w` was performed without checking `w > 0.0`.
- **Remediation**:
  - Add guard `if w <= 0.0 { return min_ratio }` and clamp `min_px`.

---

### BUG-WIDGET-09 (P2) [RESOLVED]: `Tooltip` Viewport Clamping and `Toast` Hover Pass-Through
- **Location**: [src/core/feedback.mbt#L77](file:///a:/moonbit-project/src/core/feedback.mbt#L77), [src/core/toast.mbt#L108-L150](file:///a:/moonbit-project/src/core/toast.mbt#L108-L150)
- **Status**: **RESOLVED** (Phase 4). Tooltip coordinates clamped within viewport bounds; Toast registered `block_hover(rect)` and mouse capture.
- **Description**:
  Tooltip drew partially off-screen at edges; toast allowed click-through to underlying layers.
- **Remediation**:
  - Clamp tooltip bounds against viewport; register `block_hover` on toast cards.

---

### BUG-WIDGET-10 (P2) [RESOLVED]: Remaining Magic Numbers and Hardcoded Geometry Literals
- **Location**: [src/core/toggle.mbt#L9-L13](file:///a:/moonbit-project/src/core/toggle.mbt#L9-L13), [src/core/badge.mbt#L99-L105](file:///a:/moonbit-project/src/core/badge.mbt#L99-L105), [src/core/menu_bar.mbt#L22-L65](file:///a:/moonbit-project/src/core/menu_bar.mbt#L22-L65), [src/core/sparkline.mbt#L98](file:///a:/moonbit-project/src/core/sparkline.mbt#L98)
- **Status**: **RESOLVED** (Phase 4). Added `Color::area_wash`, auxiliary sizing tokens to `WidgetStyle`, and updated `Checkbox`, `Radio`, `Badge`, `MenuBar`, and `Sparkline`.
- **Description**:
  Several auxiliary components retained inline literals.
- **Remediation**:
  - Formalize metrics in `WidgetStyle` and replace inline alphas with semantic tokens.

---

### BUG-WIDGET-11 (P2) [RESOLVED]: `ContextMenu` Lacks Multi-Level Submenu Support
- **Location**: [src/core/context_menu.mbt#L16-L37](file:///a:/moonbit-project/src/core/context_menu.mbt#L16-L37)
- **Status**: **RESOLVED** (Phase 4). Added `children : Array[ContextMenuItem]`, `ContextMenuItem::submenu`, cascading flyout positioning, chevron indicators, and hover tracking.
- **Description**:
  `ContextMenuItem` was a flat data record without hierarchical nesting.
- **Remediation**:
  - Add `children : Array[ContextMenuItem]` and flyout opening logic.

---

## 5. Rendering Pipeline and Graphical Primitives

### BUG-DRAW-01 (P2) [RESOLVED]: Lack of Gradient, Image, Texture, and Polygon Primitives in `DrawCmd`
- **Location**: [src/draw/draw_cmd.mbt#L2-L11](file:///a:/moonbit-project/src/draw/draw_cmd.mbt#L2-L11)
- **Status**: **RESOLVED** (Phase 4). Added `LinearGradient(@math.Rect, @math.Vec2, @math.Vec2, @color.Color, @color.Color, Double)` to `DrawCmd`, implemented `DrawList::add_linear_gradient`, and mapped `ctx.createLinearGradient` in JS drivers.
- **Description**:
  `DrawCmd` previously lacked gradient drawing primitives.
- **Remediation**:
  - Add `LinearGradient` to `DrawCmd` and map in canvas backends.

---

### BUG-DRAW-02 (P3) [RESOLVED]: Per-Cell Scissor Clipping Incurs Heavy Canvas 2D State Save / Restore Overhead
- **Location**: [src/core/table.mbt#L335-L347](file:///a:/moonbit-project/src/core/table.mbt#L335-L347), [examples/canvas/js/gallery_runner.js#L278-L294](file:///a:/moonbit-project/examples/canvas/js/gallery_runner.js#L278-L294)
- **Status**: **RESOLVED** (Phase 4). Eliminated redundant per-cell `push_clip` and `pop_clip` in `src/core/table.mbt`, saving 240 canvas state save/restores per frame.
- **Description**:
  In `table`, every rendered cell pushed and popped a scissor clip (`push_clip(cell_rect)` / `pop_clip()`).
- **Remediation**:
  - Clip at the table body level once; perform cell text clipping mathematically.

---

### BUG-DRAW-03 (P3) [RESOLVED]: `DrawCmd::Text` Lacks Font Family, Font Weight, and Alignment Metadata
- **Location**: [src/draw/draw_cmd.mbt#L8](file:///a:/moonbit-project/src/draw/draw_cmd.mbt#L8), [examples/canvas/js/gallery_runner.js#L53-L60](file:///a:/moonbit-project/examples/canvas/js/gallery_runner.js#L53-L60)
- **Status**: **RESOLVED** (Phase 8). Added `font_family` and `font_weight` fields to `DrawCmd::Text`, optional arguments to `DrawList::add_text`, mapped `Bold` rich text span to weight 700, and mapped `CodeEditor` line numbers and code buffer to monospace font family with dynamic JS font string caching.
- **Description**:
  `DrawCmd::Text(@math.Vec2, String, Double, @color.Color)` only conveys position, string, size, and color.
- **Failure Mechanism**:
  - `TextSpanKind::Bold` in `rich_text.mbt` cannot alter font weight to bold; it merely colors text darker via `Color::text_strong()`.
  - `CodeEditor` cannot declare monospace font family in `DrawCmd`; the web driver applies `Plus Jakarta Sans` globally unless manually intercepted.
- **Remediation**:
  - Add `font_family : String?` and `font_weight : Int` (e.g. 400, 600, 700) to `DrawCmd::Text`.

---

# Part II: Engine Capabilities and Dogfooding Roadmap (`feat`)

Items in this section describe high-value architectural capabilities and showcase opportunities where `moon-egui` should replace raw HTML / DOM implementations to achieve full self-hosting ("dogfooding").

---

## 6. Showcase & Demonstration Dogfooding Initiatives (`feat`)

### FEAT-SHOWCASE-01 (High) [RESOLVED]: Full Self-Hosted "Pure Canvas Studio" for `gallery.html`
- **Target File**: [examples/canvas/gallery.html](file:///a:/moonbit-project/examples/canvas/gallery.html), [examples/canvas/gallery_stage.mbt](file:///a:/moonbit-project/examples/canvas/gallery_stage.mbt)
- **Status**: **RESOLVED** (Phase 5). Transformed `gallery_stage.mbt` into a full self-hosted Studio workbench featuring:
  1. In-Canvas porcelain header bar with component metadata, signature, view mode switcher, and theme switcher (`studio_light`, `slate_dark`, `high_contrast`).
  2. Interactive draggable curtain splitter (`split_horizontal`) with left preview and right read-only `code_editor` with line numbers.
  3. Seamless 3-way view presets (100% UI, 50/50 Split, 100% Code) synchronized between MoonBit and web host.
  4. Footer status bar with telemetry and interaction responses.
- **Description**:
  Self-hosted developer studio workbench implemented directly inside the MoonBit canvas pipeline.

---

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

### FEAT-CORE-01 (High) [RESOLVED]: Multi-Window Docking and Tiling Layout System (`DockArea`)
- **Location**: [src/core/dock.mbt](file:///a:/moonbit-project/src/core/dock.mbt), [src/core/dock_wbtest.mbt](file:///a:/moonbit-project/src/core/dock_wbtest.mbt), [examples/canvas/gallery_container_stages.mbt](file:///a:/moonbit-project/examples/canvas/gallery_container_stages.mbt)
- **Status**: **RESOLVED** (Phase 7). Implemented recursive `DockTree` (`Leaf`, `Split`), `DockTab`, interactive splitter dividers with dragging handles, compact tab bars with close buttons and switching, scoped Scissor clipping per pane, fluent `DockArea` builder, and `UIContext::dock_area` primitive.
- **Category**: Layout & Window Management
- **Description**:
  Provides a native immediate-mode multi-pane docking and tiling layout system (`DockArea`), enabling developers to divide workspaces into flexible, tabbed, and split-pane hierarchical layouts with interactive splitter handles, tab switching, and Scissor-clipped pane rendering.

---

### FEAT-CORE-02 (High) [RESOLVED]: Auto-Wrapping Flow Layout (`horizontal_wrapped`)
- **Location**: [src/core/containers.mbt](file:///a:/moonbit-project/src/core/containers.mbt)
- **Status**: **RESOLVED** (Phase 6). Implemented `horizontal_wrapped` auto-wrapping flow layout container tracking line heights, available width, and cursor offsets.
- **Category**: Layout Engine
- **Description**:
  `horizontal_wrapped` automatically wraps items to the next line when exceeding container width.

---

### FEAT-CORE-03 (Medium) [RESOLVED]: Runtime Dynamic Theming & Palette Profiles (Light / Dark / High-Contrast)
- **Location**: [src/core/theme.mbt](file:///a:/moonbit-project/src/core/theme.mbt)
- **Status**: **RESOLVED** (Phase 6). Added `Theme` struct holding semantic color slots, `UIContext::set_theme`, and pre-configured profiles: `Theme::studio_light()`, `Theme::slate_dark()`, and `Theme::high_contrast()`.
- **Category**: Theme & Color System
- **Description**:
  Provides complete runtime dynamic theme switching across all widgets.

---

### FEAT-CORE-04 (Medium) [RESOLVED]: Immediate-Mode Animation Tweening State Machine (`animate_bool`, `animate_float`)
- **Location**: [src/core/context.mbt](file:///a:/moonbit-project/src/core/context.mbt)
- **Status**: **RESOLVED** (Phase 6). Added immediate-mode animation helpers `animate_bool` and `animate_float` with smooth easing interpolation.
- **Category**: Animation Engine
- **Description**:
  Provides frame-rate-independent immediate-mode animation state transitions.

---

### FEAT-CORE-05 (Low) [RESOLVED]: Immediate-Mode Plotting & Charting Suite (`plot`, `bar_chart`)
- **Location**: [src/core/plot.mbt](file:///a:/moonbit-project/src/core/plot.mbt), [src/core/plot_wbtest.mbt](file:///a:/moonbit-project/src/core/plot_wbtest.mbt), [examples/canvas/gallery_stage.mbt](file:///a:/moonbit-project/examples/canvas/gallery_stage.mbt)
- **Status**: **RESOLVED** (Phase 7). Implemented `UIContext::plot` (multi-series line, scatter, and area plotting with automatic bounds, adaptive grid subdivisions, numeric coordinate tick labels, hover crosshairs, and data tooltips) and `UIContext::bar_chart` (adaptive column widths, category labels, hover pill indicators, and value displays).
- **Category**: Data Visualization
- **Description**:
  The engine provides full immediate-mode coordinate plotting and category bar charting.

---

# Part III: Structural Decoupling and Architecture Modularization (`arch`)

Items in this section address foundational decoupling across the engine: modularizing the God Context, generalizing state persistence, separating design tokens from component configurations, introducing first-class widget structs with builder APIs, isolating rendering through a scoped Painter abstraction, and breaking down monolithic packages and stages.

---

## 8. Architectural Decoupling Initiatives (`arch`)

### ARCH-01 (P1) [RESOLVED]: `UIContext` God-Object Subsystem Modularization (`Layout`, `Focus`, `Window`, `Layer`)
- **Location**: [src/core/context.mbt#L21-L71](file:///a:/moonbit-project/src/core/context.mbt#L21-L71)
- **Status**: **RESOLVED** (Phase 2). Decomposed `UIContext` into dedicated `LayoutEngine`, `FocusManager`, `WindowManager`, and `LayerManager` sub-engines with facade delegation.
- **Category**: Context Architecture
- **Description**:
  `UIContext` contains 46 fields spanning five distinct subsystems (spatial layout stack, focus/hit-testing ring, scissor clipping/layer composition, window z-compositing, and persistent storage).
- **Coupling Mechanism**:
  1. Any change to a sub-engine (such as adding flexbox/grid layout properties or updating window z-ordering) directly mutates the monolithic `UIContext` struct definition.
  2. Subsystems cannot be independently unit-tested or mocked in isolation without spinning up a complete 46-field context.
- **Remediation**:
  - Decompose `UIContext` internally into dedicated composite sub-structs:
    - `LayoutState`: manages `layout_stack`, `LayoutScope`, `cursor`, `available_width`, and `item_spacing`.
    - `FocusState`: manages `hot_id`, `active_id`, `focused_id`, `prev_focused_id`, `lost_focus_id`, and `focusable_ids`.
    - `WindowState`: manages `window_positions`, `window_batches`, `window_drawn`, `window_focus`, `win_active_z`, and `window_rects`.
    - `LayerState`: manages `draw_list`, `fg_draw_list`, `fg_saved_draw_list`, `clip_stack`, `foreground`, and `blocking_rects`.
  - Maintain external facade methods on `UIContext` to preserve API compatibility while delegating execution to the respective sub-structs.

---

### ARCH-02 (P1) [RESOLVED]: Generic Keyed State Storage (`Memory` / `IdMap`) Decoupling Widget Persistence
- **Location**: [src/core/context.mbt#L38-L54](file:///a:/moonbit-project/src/core/context.mbt#L38-L54), [src/core/text_edit.mbt](file:///a:/moonbit-project/src/core/text_edit.mbt), [src/core/scroll_area.mbt](file:///a:/moonbit-project/src/core/scroll_area.mbt), [src/core/code_editor.mbt](file:///a:/moonbit-project/src/core/code_editor.mbt), [src/core/containers.mbt](file:///a:/moonbit-project/src/core/containers.mbt)
- **Status**: **RESOLVED** (Phase 1). Introduced generic `Memory` / `IdMap` subsystem with generational eviction, decoupled all 8 widget storage tables out of `UIContext`.
- **Category**: State Management Decoupling
- **Description**:
  `UIContext` hardcodes 8 widget-specific storage tables:
  - `scroll_offsets : HashMap[Id, Double]`
  - `scroll_content_heights : HashMap[Id, Double]`
  - `text_cursor_positions : HashMap[Id, Int]`
  - `text_selection_anchors : HashMap[Id, Int]`
  - `open_collapsing_ids : HashMap[Id, Bool]`
  - `open_combo_id : Id`
  - `open_menu_id : Id`
  - `active_submenu_id : String`
  Accompanied by 16+ dedicated getter/setter glue methods (`get_text_cursor_pos`, `set_text_cursor_pos`, `get_scroll_offset`, etc.).
- **Coupling Mechanism**:
  1. Adding a new stateful widget (e.g. tree node expansion, tab selection, virtual list offset) forces schema changes and new fields inside the core `UIContext` struct.
  2. Third-party or userland widgets cannot declare persistent cross-frame state because state storage is closed to extension.
- **Remediation**:
  - Introduce a generic `Memory` / `IdMap` subsystem that allows any widget to declare and persist its own state struct:
    ```moonbit
    struct TextEditState {
      cursor_pos : Int
      selection_anchor : Int?
    }
    ```
  - Provide generic lookup and insertion APIs: `ctx.memory.get_or_default(id, fn() { ... })` and `ctx.memory.set(id, state)`.
  - Migrate all 8 widget-specific tables out of `UIContext` and into the generic memory subsystem with generational frame pruning.

---

### ARCH-03 (P1) [RESOLVED]: `WidgetStyle` Token Decoupling (System Design Tokens vs. Component Configuration)
- **Location**: [src/core/theme.mbt#L17-L116](file:///a:/moonbit-project/src/core/theme.mbt#L17-L116)
- **Status**: **RESOLVED** (Phase 4). Stratified `WidgetStyle` into foundational systemic tokens (`control_h_sm/md/lg`, `font_*`, `spacing_*`, `radius_*`, `scale`, `elevation`) and dedicated component style descriptors (`CodeEditorStyle`, `PlotStyle`, `TableStyle`, `FaderStyle`, `KnobStyle`).
- **Category**: Design System Decoupling
- **Description**:
  `WidgetStyle` is a flat structure containing 70+ fields enumerating specific geometric metrics for 32 widgets (`button_h`, `button_pad_x`, `slider_track_w`, `knob_r`, `fader_cap_w`, `dialog_btn_w`, `code_editor_gutter_w`, `table_row_h`, etc.).
- **Coupling Mechanism**:
  1. The central style definition possesses exhaustive knowledge of every concrete widget in the library.
  2. Introducing or refactoring a widget requires modifying `WidgetStyle`, its constructor `WidgetStyle::default()`, and all associated test assertions.
  3. External packages cannot add styling metrics for their custom widgets.
- **Remediation**:
  - Stratify the styling architecture into two distinct tiers:
    1. **Foundation Design Tokens** (in `WidgetStyle`): scale factor, font size scales (`font_sm`, `font_md`, `font_lg`), spacing scale (`spacing_xs`, `spacing_sm`, `spacing_md`, `spacing_lg`), radius scale (`radius_sm`, `radius_md`, `radius_lg`), and base interactive control heights (`control_h_sm`, `control_h_md`, `control_h_lg`).
    2. **Component Style Descriptors**: specialized widgets derive their default dimensions proportionally from foundation tokens, or accept an optional component-level style descriptor (e.g. `CodeEditorStyle`, `PlotStyle`).

---

### ARCH-04 (P1) [RESOLVED]: First-Class `Widget` Structs and Fluent Builder Protocol (`ui.add(widget)`)
- **Location**: [src/core/button.mbt](file:///a:/moonbit-project/src/core/button.mbt), [src/core/slider.mbt](file:///a:/moonbit-project/src/core/slider.mbt), [src/core/knob.mbt](file:///a:/moonbit-project/src/core/knob.mbt), [src/core/fader.mbt](file:///a:/moonbit-project/src/core/fader.mbt), [src/core/table.mbt](file:///a:/moonbit-project/src/core/table.mbt), [src/core/plot.mbt](file:///a:/moonbit-project/src/core/plot.mbt), [src/core/widget.mbt](file:///a:/moonbit-project/src/core/widget.mbt)
- **Status**: **RESOLVED** (Phase 5). Introduced `pub trait Widget { fn ui(Self, UIContext) -> Response }` and `pub fn[W : Widget] UIContext::add(self, widget) -> Response`. Created standalone first-class structs with fluent builders (`Button`, `Slider`, `Knob`, `Fader`, `Checkbox`, `Toggle`, `Radio`, `Table`, `Plot`, `BarChart`, `Label`, `Separator`, `Badge`, `ProgressBar`) and bidirectional `Ref[T]` bindings.
- **Category**: Widget API Decoupling
- **Description**:
  All 32 widgets currently exist strictly as extension methods on `UIContext` (`ctx.button(...)`, `ctx.knob(...)`). Complex widgets take up to 11 positional and optional arguments (e.g. `knob` has 11 parameters, `fader` has 11 parameters, `code_editor` has 6 parameters).
- **Coupling Mechanism**:
  1. Widgets cannot be instantiated as independent values, passed as arguments, stored in collections, or lazily evaluated.
  2. Adding any new configuration option inflates the method signature for all callers.
  3. No polymorphic composition protocol exists (such as `ui.add(widget)`).
- **Remediation**:
  - Define standalone first-class structs for each widget with builder methods:
    ```moonbit
    pub struct Slider[T] {
      label : String
      value : T
      min_val : T
      max_val : T
      step : T?
    }
    pub fn Slider::new(label : String, value : Double, min : Double, max : Double) -> Slider[Double]
    pub fn Slider::step(self : Slider[Double], step : Double) -> Slider[Double]
    ```
  - Provide a uniform dispatch protocol `pub fn UIContext::add[W : Widget](self : UIContext, widget : W) -> Response`.
  - Retain existing `ctx.button(...)`, `ctx.slider(...)` methods as lightweight ergonomic one-liner forwarders.

---

### ARCH-05 (P2) [RESOLVED]: `Painter` Rendering Abstraction Decoupling Widgets from Screen Coordinates and Global `DrawList`
- **Location**: [src/core/context.mbt#L23](file:///a:/moonbit-project/src/core/context.mbt#L23), [src/draw/draw_cmd.mbt](file:///a:/moonbit-project/src/draw/draw_cmd.mbt), all widget files
- **Status**: **RESOLVED** (Phase 3). Introduced scoped `Painter` abstraction (`painter.add_rect`, `painter.add_text`, `painter.with_offset`, etc.) and migrated all 29 widget files.
- **Category**: Rendering Subsystem Decoupling
- **Description**:
  All widgets directly access `self.draw_list` and manually perform global coordinate offsets and scissor stack management (`push_clip` / `pop_clip`).
- **Coupling Mechanism**:
  1. Widgets must know about global absolute screen coordinates and raw `DrawList` command queues.
  2. Implementing local coordinate systems (e.g. canvas panning, canvas zooming, sub-pixel offsetting, or cached layer rendering) requires auditing and modifying every widget's coordinate arithmetic.
- **Remediation**:
  - Introduce a `Painter` struct:
    ```moonbit
    pub struct Painter {
      draw_list : @draw.DrawList
      clip_rect : @math.Rect
      layer_id : Int
      offset : @math.Vec2
    }
    ```
  - Widgets interact solely through the `Painter` interface (`painter.rect(...)`, `painter.text(...)`, `painter.line(...)`), which automatically enforces active scissor clipping and coordinate translation.

---

### ARCH-06 (P2) [RESOLVED]: Multi-Package Architectural Hierarchy (Decomposing the 59-File `src/core` Monolith)
- **Location**: [src/core/](file:///a:/moonbit-project/src/core/), [src/widgets/](file:///a:/moonbit-project/src/widgets/), [src/composite/](file:///a:/moonbit-project/src/composite/)
- **Status**: **RESOLVED** (Phase 9). The monolithic package is split into three physical packages with a strict unidirectional dependency flow `math -> color -> draw -> core -> widgets -> composite -> src`, and `examples/canvas/canvas.js` was rebuilt from the new layout.
- **Category**: Package Architecture
- **Description**:
  `src/core` used to contain 59 source files, housing both the immediate-mode engine runtime (`Id`, `InputState`, `Layout`, `Context`, `Theme`) and all 32 specialized domain widgets (from `Button` to `Plot`, `Table`, `CodeEditor`, and `CommandPalette`).
- **Coupling Mechanism**:
  1. No physical package encapsulation existed between the runtime core and domain widgets.
  2. Developers could not import just the core engine runtime to build bespoke widgets without pulling in all 32 built-in widgets.
- **Remediation**:
  - `src/core` now holds the engine runtime only: `context.mbt`, `id.mbt`, `input.mbt`, `memory.mbt`, `layout_engine.mbt`, `focus_manager.mbt`, `window_manager.mbt`, `layer_manager.mbt`, `painter.mbt`, `theme.mbt`, `response.mbt`, `unicode.mbt`, `widget.mbt`, plus `text_layout.mbt` (the `label` / `label_colored` / `separator` / `spacer` primitives that every widget builds on). 14 source files, no widget structs.
  - `src/widgets` holds the standard controls: `Button`, `Checkbox`, `Toggle`, `Slider`, `TextEdit`, `Label`, `Separator`, `Badge`, `ProgressBar`, `Container` family, `ScrollArea`, `Splitter`, `Window`, `Dialog`, `Toast`, `Tooltip`, `Breadcrumb`, `SegmentedControl`.
  - `src/composite` holds the advanced components: `CodeEditor`, `Plot` / `BarChart` / `Sparkline`, `Table`, `TreeView`, `ColorPicker`, `CommandPalette`, `DockArea`, `Knob`, `Fader`, `MenuBar`, `ContextMenu`, `RichText`.
  - `src/` is the umbrella facade re-exporting every public type, and it also re-exports the `Widget` trait via `pub using @core { trait Widget }`.
  - Because MoonBit forbids dot-methods on foreign types and `pub struct` literals outside their package, the cross-package contract is: widgets implement `@core.Widget` through `ctx.add(...)`, callers use namespace helpers (`@widgets.button(ctx, "...")`), and style derivation goes through fluent builders such as `WidgetStyle::scaled(factor)` instead of struct update syntax.
  - Whitebox tests moved with their subjects; the cross-layer composition assert (Tab consumed by the code editor must not leak focus to a neighbouring button) lives in the blackbox suite at [test/smoke_test.mbt](file:///a:/moonbit-project/test/smoke_test.mbt).

---

### ARCH-07 (P2) [RESOLVED]: Showcase Stage Modularization (Splitting 2088-Line `gallery_stage.mbt` Monolith)
- **Location**: [examples/canvas/gallery_stage.mbt](file:///a:/moonbit-project/examples/canvas/gallery_stage.mbt)
- **Status**: **RESOLVED** (Phase 6). Decomposed 2088-line monolithic `gallery_stage.mbt` into 6 dedicated domain stage modules (`gallery_basic_stages.mbt`, `gallery_editor_stages.mbt`, `gallery_audio_stages.mbt`, `gallery_data_stages.mbt`, `gallery_nav_stages.mbt`, `gallery_container_stages.mbt`), reducing `gallery_stage.mbt` to ~300 lines of pure frame lifecycle and dispatcher harness.
- **Category**: Showcase Architecture
- **Description**:
  `gallery_stage.mbt` contains 2088 lines of code in a single file, encompassing all 32 component gallery stages, porcelain card framing, telemetry, host input conversion, and view-mode layout switching.
- **Coupling Mechanism**:
  1. Every modification to a single component's showcase triggers re-compilation of the entire 2088-line showcase unit.
  2. Monolithic `match comp_id { "button" => ..., "slider" => ..., ... }` pattern matching with 32 branches hinders modular additions.
- **Remediation**:
  - Decompose `gallery_stage.mbt` into modular stage units:
    - `examples/canvas/gallery_basic_stages.mbt` (`button`, `slider`, `toggle`, `checkbox`, `radio`, `badge`, `progress_bar`, `spinner`)
    - `examples/canvas/gallery_editor_stages.mbt` (`text_edit`, `code_editor`, `rich_text`)
    - `examples/canvas/gallery_data_stages.mbt` (`table`, `tree_view`, `plot`, `bar_chart`, `sparkline`)
    - `examples/canvas/gallery_audio_stages.mbt` (`knob`, `fader`)
    - `examples/canvas/gallery_nav_stages.mbt` (`tab_bar`, `breadcrumb`, `segmented_control`, `menu_bar`)
    - `examples/canvas/gallery_container_stages.mbt` (`window`, `dialog`, `toast`, `splitter`, `scroll_area`, `command_palette`, `context_menu`, `tooltip`, `color_picker`, `combo_box`, `color_button`, `collapsing_header`)
    - `examples/canvas/gallery_stage.mbt` (retains only frame harness, porcelain shell, and dispatcher)

---

---

# Part IV: Post-v0.5.1 Comprehensive Code Review Audit (`audit`)

Following the v0.5.1 release, an exhaustive, multi-dimensional code review was executed across the entire codebase (`src/core`, `src/widgets`, `src/composite`, `src/draw`, `src/color`, `src/math`, `examples/canvas`, and `docs/`).

This review evaluates seven foundational dimensions:
- **Section 9: Logical Errors (`logic`)**: Bugs in event routing, state tracking, and layer compositing.
- **Section 10: Robustness & Stability (`robust`)**: Numeric guards, unbounded loops, extreme frame deltas, and initialization boundaries.
- **Section 11: Performance & Allocations (`perf`)**: Heap allocation hot paths, string thrashing, and batching efficiency.
- **Section 12: Maintainability & Design Tokens (`maint`)**: Theme token decoupling, remaining Context leaks, and scale scaling invariants.
- **Section 13: Dogfooding & Non-Code Defects (`dogfood`)**: Violations of the pure single-canvas standard in runtime pages.
- **Section 14: User Experience & Interaction (`ux`)**: Overflow handling, clipping, and control usability boundaries.
- **Section 15: Technical Documentation Accuracy (`doc`)**: Interface drift, obsolete signatures, and sample code synchronization.

---

## 9. Logical Errors (`logic`)

### AUDIT-LOGIC-01 (P0) [RESOLVED]: Dual-Channel Text Ingestion In Web Host Causing Input Character Duplication
- **Location**: [examples/canvas/host_input.mbt#L80-L93](file:///a:/moonbit-project/examples/canvas/host_input.mbt#L80-L93), [src/core/input.mbt#L234-L266](file:///a:/moonbit-project/src/core/input.mbt#L234-L266)
- **Status**: **RESOLVED**. `host_input.mbt` now passes `""` into `raw.text_input`, and `InputState::update` initializes `self.text_input = ""` and only falls back to `raw.text_input` if no `TextInput` events were present.
- **Priority**: **P0**
- **Category**: Input Subsystem Logic
- **Description**:
  In `examples/canvas/host_input.mbt`, `parse_raw_input` maps incoming JS text events into both `raw.text_input = char_str` and `raw.events.push(Event::TextInput(char_str))`.
- **Failure Mechanism**:
  In `src/core/input.mbt` (`InputState::update`):
  ```moonbit
  for event in raw.events {
    match event {
      TextInput(text) => self.text_input = self.text_input + text
      ...
    }
  }
  self.text_input = self.text_input + raw.text_input
  ```
  When both `raw.text_input` and `raw.events` are populated by the web runner, every typed character is appended twice (`"a"` becomes `"aa"`). This doubles keystrokes in `TextEdit`, `CodeEditor`, and `CommandPalette` when running on the web canvas.
- **Remediation**:
  Deprecate or remove the redundant scalar `raw.text_input` field from `RawInput`. Route all incoming character inputs exclusively through discrete `Event::TextInput(s)` entries in `raw.events`.

---

### AUDIT-LOGIC-02 (P1) [RESOLVED]: Key-Up Event Dropping When Key Pressed Outside Canvas Focus
- **Location**: [src/core/input.mbt#L247-L260](file:///a:/moonbit-project/src/core/input.mbt#L247-L260)
- **Status**: **RESOLVED**. Key release events unconditionally push to `self.keys_released`, ensuring modifiers and interaction termination signals are never lost.
- **Priority**: **P1**
- **Category**: Event State Logic
- **Description**:
  In `InputState::update`, release events (`Key(key, false, _)`) are conditionally filtered against `keys_down`.
- **Failure Mechanism**:
  ```moonbit
  Key(key, false, _) => {
    if self.keys_down.contains(key) {
      self.keys_released.push(key)
      self.keys_down.remove(key)
    }
  }
  ```
  If a user holds a key (or modifier like Shift/Control/Alt) before the browser window or canvas element gains focus, `keys_down` does not register the initial down transition. When the key is subsequently released inside the canvas, `self.keys_down.contains(key)` evaluates to `false`, and the release event is discarded without being recorded in `self.keys_released`. Widgets monitoring `ctx.key_released(key)` to conclude an interaction (e.g. modifier-drag, multi-selection, shortcut cancellation) never receive the release signal.
- **Remediation**:
  Unconditionally push the key to `self.keys_released` on `Key(key, false, _)`, regardless of whether `keys_down` previously tracked the key:
  ```moonbit
  Key(key, false, _) => {
    self.keys_released.push(key)
    self.keys_down.remove(key)
  }
  ```

---

### AUDIT-LOGIC-03 (P2) [RESOLVED]: LayerManager Flat Boolean State Causing Nested Foreground Premature Exit
- **Location**: [src/core/layer_manager.mbt#L85-L111](file:///a:/moonbit-project/src/core/layer_manager.mbt#L85-L111)
- **Status**: **RESOLVED**. Replaced flat `foreground : Bool` with re-entrant `mut foreground_depth : Int`, safely supporting nested overlays and popups without premature termination.
- **Priority**: **P2**
- **Category**: Layer Compositing Logic
- **Description**:
  `LayerManager` tracks foreground layer activation via a single flat boolean field `foreground : Bool`.
- **Failure Mechanism**:
  When a modal popup, dialog, or floating window invokes `begin_foreground()`, `self.foreground` is set to `true`. If any nested child component within that modal (e.g. a `Tooltip`, a nested context menu, or an embedded `ComboBox`) also invokes `begin_foreground()` and subsequently `end_foreground()`, `end_foreground()` unconditionally sets `self.foreground = false`. This terminates foreground mode prematurely for the remaining draw commands of the parent modal dialog, causing them to fall back into the default background `draw_list` and be occluded by standard widgets.
- **Remediation**:
  Replace `foreground : Bool` with a re-entrant depth counter `foreground_depth : Int = 0`. Increment on `begin_foreground` and decrement on `end_foreground`, only restoring drawing to the background list when `foreground_depth == 0`.

---

### AUDIT-LOGIC-04 (P0) [RESOLVED]: Infinite Allocation Loop and Memory Exhaustion on Unbalanced `begin_foreground`
- **Location**: [src/core/layer_manager.mbt#L85-L111](file:///a:/moonbit-project/src/core/layer_manager.mbt#L85-L111), [src/core/context.mbt#L90-L92](file:///a:/moonbit-project/src/core/context.mbt#L90-L92), [src/draw/draw_cmd.mbt#L125-L135](file:///a:/moonbit-project/src/draw/draw_cmd.mbt#L125-L135)
- **Status**: **RESOLVED**. `DrawList::append` iterates over a pre-captured `let count = other.commands.length()`, eliminating array growth loops. `UIContext::end_frame` cleans up any unbalanced foreground frames before list merging.
- **Priority**: **P0**
- **Category**: Layer Compositing Logic & Memory Safety
- **Description**:
  When `begin_foreground()` is called, `LayerManager` redirects `self.draw_list` to point directly to `self.fg_draw_list`.
- **Failure Mechanism**:
  If a widget or stage encounters an early return, error, or unhandled branch without calling `end_foreground()`, `self.foreground` remains `true` at the end of the frame. In `UIContext::end_frame`:
  ```moonbit
  self.layers.draw_list().append(self.layers.fg_draw_list())
  ```
  Because `self.layers.draw_list()` and `self.layers.fg_draw_list()` point to the exact same `DrawList` reference, `DrawList::append` iterates `for cmd in other.commands { self.commands.push(cmd) }`, pushing commands into the array while iterating over it. The loop never terminates, exhausting available Wasm heap memory until a fatal allocation trap crashes the application.
- **Remediation**:
  Guard `DrawList::append` against pointer/array identity aliasing (`if physical_equal(self.commands, other.commands) { return }`), and in `UIContext::end_frame`, forcefully check `if self.layers.is_foreground() { self.layers.end_foreground() }` to guarantee layer restoration before list compositing.

---

### AUDIT-LOGIC-05 (P1) [RESOLVED]: Unreleased `active_id` in DockArea Splitter Causing Global Mouse Capture Leaks
- **Location**: [src/composite/dock.mbt#L540-L586](file:///a:/moonbit-project/src/composite/dock.mbt#L540-L586), [src/widgets/slider.mbt#L130-L150](file:///a:/moonbit-project/src/widgets/slider.mbt#L130-L150)
- **Status**: **RESOLVED**. Added explicit `else { ctx.set_active_id(Id::zero()) }` when mouse is released in both `dock.mbt` and `slider.mbt`.
- **Priority**: **P1**
- **Category**: Interaction State Machine Logic
- **Description**:
  When dragging a dock splitter divider in `DockArea`, line 540 executes `ctx.set_active_id(handle_id)`.
- **Failure Mechanism**:
  Unlike standard interactive controls, `DockArea` contains no logic to release `ctx.set_active_id(Id::zero())` when `!ctx.input().mouse_down`. Once the splitter handle is clicked, `ctx.active_id()` remains locked to `handle_id` indefinitely across all subsequent frames until another widget happens to set it. As a result:
  1. `ctx.set_cursor_icon(cursor_icon)` is continuously enforced across the whole canvas.
  2. Other interactive surfaces guarding against background pointer activity (such as `Table`: `(ctx.active_id() == Id::zero() || ctx.active_id() == table_id)`) believe an active drag is perpetually in progress, permanently disabling table row hover, column resizing, and selection.
- **Remediation**:
  In `DockArea`'s splitter drag block, explicitly release active ownership when mouse is released: `if is_active && !ctx.input().mouse_down { ctx.set_active_id(Id::zero()) }`. In addition, enhance `FocusManager::begin_frame` to automatically clear `active_id` if `!ctx.input.mouse_down`.

---

## 10. Robustness & Stability (`robust`)

### AUDIT-ROBUST-01 (P1) [RESOLVED]: Unbounded Sub-stepping Loop in `Spring::step` Under Large Frame Deltas or NaN
- **Location**: [src/math/spring.mbt#L118-L150](file:///a:/moonbit-project/src/math/spring.mbt#L118-L150)
- **Status**: **RESOLVED**. Clamped `safe_dt = if dt > 0.2 { 0.2 } else { dt }`, added `dt.is_nan()` check, and capped integration iterations at 30 per frame.
- **Priority**: **P1**
- **Category**: Numerical & Runtime Stability
- **Description**:
  `Spring::step(self, dt : Double)` accumulates delta time via `self.accum = self.accum + dt` and executes a sub-stepping integration loop with `fixed_dt = 1.0 / 120.0`.
- **Failure Mechanism**:
  ```moonbit
  while remaining > 0.0 {
    let step_dt = if remaining < fixed_dt { remaining } else { fixed_dt }
    ...
    remaining = remaining - step_dt
  }
  ```
  1. When a browser tab returns from background suspension or machine sleep, `dt` can be 10–60 seconds. At `1/120s` sub-steps, this executes 1,200 to 7,200 iterations in a single frame, causing significant main-thread lag.
  2. If `dt` contains a non-finite value (`NaN` or `Infinity`), `remaining > 0.0` or arithmetic failure can lock the runtime into an infinite loop or throw a Wasm runtime trap.
- **Remediation**:
  Clamp incoming delta time to a safe maximum (e.g. `let safe_dt = @math.clamp(dt, 0.0, 0.2)`), cap the maximum integration iterations to at most 16–24 per frame, and guard against `is_nan()`.

---

### AUDIT-ROBUST-02 (P2) [RESOLVED]: Uninitialized Initial Mouse Delta Spike on Frame Zero
- **Location**: [src/core/input.mbt#L192-L225](file:///a:/moonbit-project/src/core/input.mbt#L192-L225)
- **Status**: **RESOLVED**. Added `mouse_initialized : Bool`. On frame zero, sets `mouse_prev_pos = mouse_pos` and `mouse_delta = Vec2::zero()`, eliminating delta spikes.
- **Priority**: **P2**
- **Category**: Input Robustness
- **Description**:
  `InputState::new` initializes `mouse_prev_pos` to `(0.0, 0.0)`.
- **Failure Mechanism**:
  On the first frame where the cursor enters the canvas at `(960.0, 540.0)` (center of a 1080p display), `InputState::update` computes:
  ```moonbit
  self.mouse_delta = self.mouse_pos - self.mouse_prev_pos // (960.0, 540.0)
  ```
  Any widget or viewport relying on `mouse_delta` (pan/zoom canvasses, splitters, 3D orbit controls, continuous sliders) experiences an immediate 960px jump on initial cursor contact.
- **Remediation**:
  Track an initialization state flag `mouse_initialized : Bool`. On the first received pointer position, initialize both `mouse_pos` and `mouse_prev_pos` to the incoming coordinates and set `mouse_delta = Vec2::zero()`.

---

### AUDIT-ROBUST-03 (P2) [RESOLVED]: Non-Finite Interpolation Parameter in `Color::lerp` Propagating Malformed RGBA
- **Location**: [src/color/color.mbt#L42-L49](file:///a:/moonbit-project/src/color/color.mbt#L42-L49)
- **Status**: **RESOLVED**. Added `if t.is_nan() || t < 0.0 { 0.0 } else if t > 1.0 { 1.0 } else { t }` in `Color::lerp`.
- **Priority**: **P2**
- **Category**: Color Arithmetic Robustness
- **Description**:
  `Color::lerp(a, b, t)` performs linear interpolation between channel values.
- **Failure Mechanism**:
  ```moonbit
  let r = a.r.to_double() + (b.r.to_double() - a.r.to_double()) * t
  ```
  If an animation tween, physics spring, or external computation produces `t = NaN` or non-finite values, `r.round().to_int()` emits invalid integers or traps in Wasm-GC, bypassing downstream clamp assertions and feeding corrupted color commands into `DrawCmd`.
- **Remediation**:
  Enforce finite number validation: `let t_clamped = if t.is_nan() { 0.0 } else { @math.clamp(t, 0.0, 1.0) }`.

---

### AUDIT-ROBUST-04 (P1) [RESOLVED]: Negative Rect Dimension Arithmetic Trap Under Squeezed Dock Nodes
- **Location**: [src/composite/dock.mbt#L480-L525](file:///a:/moonbit-project/src/composite/dock.mbt#L480-L525)
- **Status**: **RESOLVED**. Clamped `total_w <= 0.0` to `(0.0, 0.0)` and guarded `total_w < min_pane_size * 2.0` by halving available space rather than subtracting and producing negative widths.
- **Priority**: **P1**
- **Category**: Geometry Arithmetic Robustness
- **Description**:
  In `DockArea`'s `Split` node calculation, child pane widths are computed against `min_pane_size`:
  ```moonbit
  let total_w = rect.w - handle_thick
  let mut w1 = total_w * cur_ratio
  if w1 < min_pane_size { w1 = min_pane_size }
  if total_w - w1 < min_pane_size { w1 = total_w - min_pane_size }
  let w2 = total_w - w1
  ```
- **Failure Mechanism**:
  When a dock node is deeply nested or the container is resized such that `total_w < min_pane_size` (e.g. `total_w = 30.0` while `min_pane_size = 40.0`):
  `w1 = total_w - min_pane_size = 30.0 - 40.0 = -10.0`!
  This constructs negative-width rectangles `Rect::new(rect.x, rect.y, -10.0, rect.h)` and `w2 = 40.0`, resulting in inverted scissor boundaries, inverted mouse hit-testing coordinates, and visual glitches. The same arithmetic failure occurs in the vertical split direction when `total_h < min_pane_size`.
- **Remediation**:
  Enforce boundary safeguards: `if total_w <= min_pane_size * 2.0`, assign `w1 = total_w * 0.5` and clamp both `w1` and `w2` to `>= 0.0`.

---

### AUDIT-ROBUST-05 (P2) [RESOLVED]: Stale Index Mismatch and Positional Jumping on Toast Manual Dismissal
- **Location**: [src/widgets/toast.mbt#L201-L215](file:///a:/moonbit-project/src/widgets/toast.mbt#L201-L215)
- **Status**: **RESOLVED**. Filtered `placed_rects` synchronously into `final_rects` alongside `final_active`, maintaining 1:1 physical positional alignment when a toast is closed.
- **Priority**: **P2**
- **Category**: Rendering Consistency & Array Alignment
- **Description**:
  In `toast_stack`, `placed_rects` is computed based on the initial `next_active` array.
- **Failure Mechanism**:
  When a user clicks the close button of a toast, that toast is filtered out to produce `final_active`. Then:
  ```moonbit
  for i = 0; i < final_active.length(); i = i + 1 {
    let toast = final_active[i]
    let rect = placed_rects[i] // BUG: placed_rects contains the dismissed toast's position!
  ```
  If `toast[0]` is dismissed, `toast[1]` is drawn at `placed_rects[0]`, causing all subsequent toasts to abruptly jump to the coordinate of the toast before them in the same frame rather than maintaining their visual coordinates.
- **Remediation**:
  Filter or rebuild `placed_rects` synchronously after deciding `dismissed_id`, ensuring indices in `placed_rects` strictly correspond to the drawn toasts.

---

### AUDIT-ROBUST-06 (P2) [RESOLVED]: Raw Mouse Position Hit-Testing and Missing Cursor Affordance in Scientific Plot & BarChart
- **Location**: [src/composite/plot.mbt#L254-L260](file:///a:/moonbit-project/src/composite/plot.mbt#L254-L260), [L683-L689](file:///a:/moonbit-project/src/composite/plot.mbt#L683-L689)
- **Status**: **RESOLVED** (Iteration 3). Replaced raw `rect.contains(mouse_pos)` with `ctx.is_hovered(...)` conforming to Widget Interaction Standard Rule 2; reported `crosshair` cursor when hovering over plot area and `pointer` cursor on bar hover; scaled layout threshold checks by `scale`.
- **Priority**: **P2**
- **Category**: Widget Interaction Standard & Hit-Testing
- **Description**:
  In `plot.mbt`, hit testing for interactive crosshair coordinates and bar chart hover indices used raw `plot_rect.contains(mouse_pos)` and `bar_rect.contains(mouse_pos)`.
- **Failure Mechanism**:
  Direct `rect.contains(mouse_pos)` bypasses `ctx.is_hovered`, causing hover state to trigger even when the chart is scrolled outside a container's scissor clip or occluded by an active modal/popup. Additionally, neither `Plot` nor `BarChart` reported cursor affordances via `ctx.set_cursor_icon(...)`, violating the Widget Interaction Standard.
- **Remediation**:
  Route all hit-testing through `ctx.is_hovered(rect)`, set `crosshair` cursor while hovering over the 2D plot area, and set `pointer` cursor while hovering over chart bars.

---

## 11. Performance & Allocations (`perf`)

### AUDIT-PERF-01 (P1) [RESOLVED]: High-Frequency String Allocation and Fractional Truncation in Text Measurement Cache
- **Location**: [src/core/context.mbt#L35](file:///a:/moonbit-project/src/core/context.mbt#L35), [L650-L685](file:///a:/moonbit-project/src/core/context.mbt#L650-L685)
- **Status**: **RESOLVED**. Upgraded `text_measure_cache` key from heap `String` concatenation to `(String, Int)` tuple with millipoint precision `(font_size * 100.0 + 0.5).to_int()`, eliminating transient string allocations on cache hits and misses.
- **Priority**: **P1**
- **Category**: Heap Allocation & Typographical Precision
- **Description**:
  `UIContext::measure_text` queries font sizing via string key concatenation:
  ```moonbit
  let key = text + "@" + font_size.to_int().to_string()
  ```
- **Failure Mechanism**:
  1. In a UI frame rendering 200–300 labels, buttons, and table cells, this concatenation allocates hundreds of temporary strings per frame (>18,000 strings/sec at 60 FPS), triggering GC pressure in Wasm-GC.
  2. Casting `font_size.to_int()` truncates fractional sizes (e.g. `13.5` and `13.8` both produce `"13"`), causing cache key collisions and inaccurate text layout widths.
- **Remediation**:
  Refactor the LRU cache key from a string concatenation to a compound tuple `(String, Int)` (using scaled millipoints e.g. `(font_size * 100.0).to_int()`) or custom key struct with integer hash computation, eliminating heap string allocations on cache queries.

---

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

### AUDIT-PERF-03 (P2) [RESOLVED]: 70-Command Quad Mesh Flood in 2D Color Picker Saturation-Value Surface
- **Location**: [src/composite/color_picker.mbt#L178-L196](file:///a:/moonbit-project/src/composite/color_picker.mbt#L178-L196)
- **Status**: **RESOLVED** (Iteration 2). Replaced 70-tile quad mesh and 24-step rainbow with continuous linear gradients (base hue rect + horizontal white gradient + vertical black gradient; 6 multi-stop spectrum slices for hue slider), achieving continuous smooth rendering and reducing draw list commands by 90%.
- **Priority**: **P2**
- **Category**: Draw Command Batching Efficiency
- **Description**:
  To render the 2D saturation/value picking square, `color_picker` executes a nested loop over a $10 \times 7$ grid:
  ```moonbit
  for gx = 0; gx < grid_x; gx = gx + 1 {
    for gy = 0; gy < grid_y; gy = gy + 1 {
      ctx.painter().add_rect(c_rect, Color::rgb(cr, cg, cb), 0.0)
    }
  }
  ```
- **Failure Mechanism**:
  This emits 70 separate `DrawCmd::Rect` commands and generates 70 `fillRect` calls on the Canvas 2D context every frame. In addition to high command overhead, the resulting surface displays visible blocky color banding instead of a continuous gradient.
- **Remediation**:
  Replace the 70-rectangle grid with two layered `DrawCmd::LinearGradient` passes (a horizontal gradient from white to pure hue overlaid with a vertical gradient from transparent to black) or a dedicated bilinear gradient primitive.

---

## 12. Maintainability & Design Tokens (`maint`)

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

### AUDIT-MAINT-02 (P1) [RESOLVED]: Residual Widget-Specific Identifier Fields in `UIContext` Violating Decoupling Standard
- **Location**: [src/core/context.mbt#L30-L40](file:///a:/moonbit-project/src/core/context.mbt#L30-L40), [L785-L840](file:///a:/moonbit-project/src/core/context.mbt#L785-L840)
- **Status**: **RESOLVED**. Removed `open_combo_id`, `open_menu_id`, and `active_submenu_id` from `UIContext` struct. Re-routed their public accessors through `self.memory` with namespaced tags.
- **Priority**: **P1**
- **Category**: Architectural Decoupling Compliance
- **Description**:
  `UIContext` directly declares three widget-specific fields:
  - `open_combo_id : Id`
  - `open_menu_id : Id`
  - `active_submenu_id : String`
  along with dedicated getter/setter methods.
- **Failure Mechanism**:
  This directly violates Section 1 of the *Low-Coupling Architecture & Structural Decoupling Standard* ("UIContext must exclusively house core engine runtime primitives... Strictly Forbid adding widget-specific fields to UIContext").
- **Remediation**:
  Migrate `open_combo_id`, `open_menu_id`, and `active_submenu_id` into `ctx.memory` using a private or widget-namespaced state struct (`ComboBoxState`, `MenuState`).

---

### AUDIT-MAINT-03 (P2) [RESOLVED]: Unscaled Metric Literals Bypassing Global Scale Invariance in Slider
- **Location**: [src/widgets/slider.mbt#L190-L325](file:///a:/moonbit-project/src/widgets/slider.mbt#L190-L325), [L510-L525](file:///a:/moonbit-project/src/widgets/slider.mbt#L510-L525)
- **Status**: **RESOLVED**. Scaled label font, track radius, tick radius, thumb strokes, bubble metrics, and value text position by `scale`.
- **Priority**: **P2**
- **Category**: Anti-Hardcoding & Geometry Scale
- **Description**:
  In `src/widgets/slider.mbt`, while primary dimensions use `scale`, several internal layout offsets are hardcoded as raw float literals:
  - line 191: `let thumb_pad = 1.5`
  - line 208: `let val_text_pad = 10.0`
  - line 224: `let handle_r = 13.0`
  - line 241: `let track_h = 12.0`
- **Failure Mechanism**:
  At non-default DPI scale factors (`scale = 1.5` or `2.0`), unscaled padding causes the slider handle to clip into the track border and misalign with the label baseline.
- **Remediation**:
  Derive all internal offsets and radii from `self.style` tokens or multiply by `scale` (e.g. `1.5 * scale`, `10.0 * scale`).

---

### AUDIT-MAINT-04 (P2) [RESOLVED]: Unscaled Layout Literals and Theme Tokens in Auxiliary Scroll and Toast Containers
- **Location**: [src/widgets/scroll_area.mbt#L88-L195](file:///a:/moonbit-project/src/widgets/scroll_area.mbt#L88-L195), [src/widgets/toast.mbt#L134-L290](file:///a:/moonbit-project/src/widgets/toast.mbt#L134-L290)
- **Status**: **RESOLVED**. Scaled scrollbar width, track padding, min thumb height, and radii in `scroll_area.mbt`. Scaled toast dimensions, spacing, margins, indicator bar, typography, and close button in `toast.mbt`.
- **Priority**: **P2**
- **Category**: Anti-Hardcoding & Geometry Scale
- **Description**:
  Direct audit reveals multiple raw unscaled float literals in container sizing:
  - `scroll_area.mbt#L88`: `let scrollbar_w = 6.0` (unscaled)
  - `scroll_area.mbt#L90`: `inner_w = size.x - scrollbar_w - 4.0` (unscaled `4.0`)
  - `scroll_area.mbt#L175`: `bar_x = container_rect.x + size.x - scrollbar_w - 2.0` (unscaled `2.0`)
  - `scroll_area.mbt#L181`: `thumb_h < 24.0` (unscaled `24.0`)
  - `scroll_area.mbt#L169`: `ctx.style.radius_md` (passed without `* scale`)
  - `toast.mbt#L134-L146`: `toast_w = 280.0`, `spacing = 8.0`, `h = 38.0 / 54.0` (all unscaled)
- **Failure Mechanism**:
  At non-default DPI scale factors (`scale = 1.5` or `2.0`), scrollbar tracks become disproportionately thin and toast cards become cramped, causing text lines to overflow their boxes.
- **Remediation**:
  Normalize all layout constants to derive from `self.style` tokens scaled via `scale`.

---

### AUDIT-MAINT-05 (P2) [RESOLVED]: Unscaled Metric Literals and Invariant Violations in Table and Plot Dimensions
- **Location**: [src/composite/table.mbt#L305-L480](file:///a:/moonbit-project/src/composite/table.mbt#L305-L480), [src/composite/plot.mbt#L225-L230](file:///a:/moonbit-project/src/composite/plot.mbt#L225-L230)
- **Status**: **RESOLVED** (Iteration 3). Scaled layout threshold checks (`10.0 * scale`), table row heights, scrollbar widths, grab offsets, and padding in `table.mbt` and `plot.mbt`.
- **Priority**: **P2**
- **Category**: Anti-Hardcoding & Sizing Metrics
- **Description**:
  Layout dimension checks in `table.mbt` (header height fallback, minimum scrollbar thumb sizes, grab threshold) and `plot.mbt` (minimum plot width/height guards) used unscaled float literals (`10.0`, `18.0`, `20.0`).
- **Failure Mechanism**:
  At non-default DPI scale factors (`scale = 1.5` or `2.0`), unscaled thresholds cause layout guards to trigger prematurely or create disproportionately thin scrollbars and cramped table rows, violating scale invariance.
- **Remediation**:
  Multiply all geometry checks, padding, and minimum thumb metrics by `scale`.

---

## 13. Dogfooding & Non-Code Defects (`dogfood`)

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

### AUDIT-UX-01 (P2) [RESOLVED]: Missing Horizontal Scrolling and Header Clamping in Wide Composite Tables
- **Location**: [src/composite/table.mbt#L237-L420](file:///a:/moonbit-project/src/composite/table.mbt#L237-L420)
- **Status**: **RESOLVED** (Iteration 3). Implemented horizontal scrolling (`scroll_x` in `Memory`), Shift+wheel and horizontal gesture support, Left/Right arrow navigation with `consume_key`, scissor-clipped header (`push_clip(header_rect)`), and interactive horizontal + vertical scrollbars with thumb dragging, pointer cursors, and grab offsets.
- **Priority**: **P2**
- **Category**: UX & Boundary Handling
- **Description**:
  `Table` computes layout based on cumulative column widths.
- **Failure Mechanism**:
  When total table column width exceeds the container's `available_width`, columns beyond the right boundary are clipped by the scissor rectangle. Because `Table` only manages a vertical `scroll_y` offset without horizontal `scroll_x` support, wide columns or user-expanded columns become permanently inaccessible.
- **Remediation**:
  Integrate two-dimensional scroll support (`scroll_x`, `scroll_y`) in `Table` with synchronized header row translation, or automatically wrap wide tables in an interactive horizontal scroll area.

---

### AUDIT-UX-02 (P2) [RESOLVED]: Fixed-Width Value Text Container Causing Numeric Clipping and Layout Jitter
- **Location**: [src/widgets/slider.mbt#L94-L242](file:///a:/moonbit-project/src/widgets/slider.mbt#L94-L242)
- **Status**: **RESOLVED** (Iteration 2). Dynamically computed numeric reservation width from `max(ctx.measure_text(min_str), ctx.measure_text(max_str)) + 8.0 * scale`, eliminating label clipping and layout jitter.
- **Priority**: **P2**
- **Category**: UX Typography & Layout Stability
- **Description**:
  In `Slider::ui`, the numeric display label reservation is hardcoded to a fixed width of `42.0 * scale`.
- **Failure Mechanism**:
  When displaying values with negative signs, large ranges (e.g. `-10000.0`), or precision formatting (`0.0001`), the text measurement exceeds 42px, causing the value text to visibly overflow the slider container or violently push the track boundary on value changes.
- **Remediation**:
  Dynamically measure the formatted string width using `ctx.measure_text` or calculate reservation width based on `max(measure(min_val), measure(max_val)) + padding`.

---

### AUDIT-UX-03 (P1) [RESOLVED]: Lack of Horizontal Scrolling in Single-Line `TextEdit` Causing Text and Caret Clipping
- **Location**: [src/widgets/text_edit.mbt#L227-L275](file:///a:/moonbit-project/src/widgets/text_edit.mbt#L227-L275)
- **Status**: **RESOLVED** (Iteration 2). Persisted `scroll_x` in `ctx.memory`, dynamically auto-scrolled to keep active caret in view, clamped scroll offset, and adjusted pointer click hit testing with scroll offset.
- **Priority**: **P1**
- **Category**: UX Usability & Input Boundary
- **Description**:
  `TextEdit` always draws its text starting at fixed position `rect.x + padding_x` without managing a horizontal scroll offset (`scroll_x`).
- **Failure Mechanism**:
  When user input exceeds the container's width (e.g. typing 40 characters in a 200px field), text is clipped by `inner_clip`, and the cursor caret `caret_x = rect.x + padding_x + prefix_w` is rendered outside the visible area. The user cannot see what they are typing, cannot see the caret, and navigating with right arrow/End moves into an invisible void.
- **Remediation**:
  Introduce dynamic `scroll_x` tracking in `TextEdit` (storing offset in `Memory`), automatically scrolling the text window to keep the active cursor caret visible within `[rect.x + padding_x, rect.x + rect.w - padding_x]`.

---

### AUDIT-UX-04 (P2) [RESOLVED]: Non-Interactive Scrollbar Thumb and Missing Keyboard Reachability in VirtualList
- **Location**: [src/widgets/virtual_list.mbt#L180-L204](file:///a:/moonbit-project/src/widgets/virtual_list.mbt#L180-L204)
- **Status**: **RESOLVED** (Iteration 2). Added interactive scrollbar thumb dragging with grab offset tracking, pointer cursor icon, focusable registration with focus ring, and keyboard page/arrow scrolling with event consumption.
- **Priority**: **P2**
- **Category**: UX Accessibility & Interaction
- **Description**:
  `VirtualList` renders a scrollbar thumb purely as a passive rectangle (`p.add_rect(thumb_rect, ...)`).
- **Failure Mechanism**:
  Unlike `ScrollArea`, `VirtualList` does not support thumb hover highlights, dragging, or page jumping on track click. Furthermore, `VirtualList` never registers itself as focusable (`ctx.register_focusable`), making it completely unreachable via keyboard (PageUp / PageDown / Up / Down arrow keys fail to scroll).
- **Remediation**:
  Implement thumb hit-testing and dragging state machine in `VirtualList` matching `ScrollArea`, register container focusability, and support keyboard page/arrow scrolling.

---

### AUDIT-UX-05 (P2) [RESOLVED]: Hue Reset to 0° When Selecting Black, White, or Grayscale in ColorPicker
- **Location**: [src/composite/color_picker.mbt#L148-L151](file:///a:/moonbit-project/src/composite/color_picker.mbt#L148-L151)
- **Status**: **RESOLVED** (Iteration 2). Persisted selected hue in `ctx.memory` with tag `"hue"`, preventing achromatic fallback to 0° and preserving user hue selection across black, white, and gray states.
- **Priority**: **P2**
- **Category**: UX Interaction & Color State
- **Description**:
  `ColorPicker` computes HSV from the caller's incoming RGB on every frame via `rgb_to_hsv(color.r, color.g, color.b)`.
- **Failure Mechanism**:
  For any achromatic color (where `r == g == b`, e.g. pure black `(0,0,0)`, pure white `(255,255,255)`, or gray), `delta = 0`, causing `rgb_to_hsv` to return `h = 0.0`. If a user selects a blue or green hue and then drags saturation to 0 or value to 0, the active hue immediately jumps to 0° (red), resetting the hue slider and 2D picker surface.
- **Remediation**:
  Persist the active `hue : Double` across frames in `ctx.memory` keyed by the color picker's ID, preserving the selected hue angle even when saturation or value drops to zero.

---

### AUDIT-UX-06 (P2) [RESOLVED]: Unconsumed Editing and Navigation Keys Leaking into Parent Containers
- **Location**: [src/widgets/text_edit.mbt#L169-L196](file:///a:/moonbit-project/src/widgets/text_edit.mbt#L169-L196), [src/composite/tree_view.mbt#L178-L198](file:///a:/moonbit-project/src/composite/tree_view.mbt#L178-L198), [src/composite/code_editor.mbt#L411-L467](file:///a:/moonbit-project/src/composite/code_editor.mbt#L411-L467)
- **Status**: **RESOLVED** (Iteration 2). Called `ctx.input.consume_key(...)` for all intercepted editing and navigation keys in `TextEdit`, `CodeEditor`, and `TreeView`, preventing key events from leaking to parent containers.
- **Priority**: **P2**
- **Category**: Event Consumption & Focus Isolation
- **Description**:
  In `TextEdit`, `TreeView`, and `CodeEditor`, navigation keys (ArrowLeft, ArrowRight, ArrowUp, ArrowDown, Home, End, Backspace, Delete) are intercepted to mutate internal state.
- **Failure Mechanism**:
  `ctx.input.consume_key(...)` is never called for these navigation keys. When these widgets are embedded inside a scrollable area, window, or table, pressing arrow keys moves the internal cursor/selection AND simultaneously scrolls the parent viewport.
- **Remediation**:
  Call `ctx.input.consume_key(key)` for every handled navigation or editing key event.

---

### AUDIT-UX-07 (P2) [RESOLVED]: Unconsumed Navigation Keys and Missing Focus Indicator in Rotary Knob and Segmented Control
- **Location**: [src/composite/knob.mbt#L190-L245](file:///a:/moonbit-project/src/composite/knob.mbt#L190-L245), [src/widgets/segmented_control.mbt#L125-L165](file:///a:/moonbit-project/src/widgets/segmented_control.mbt#L125-L165)
- **Status**: **RESOLVED** (Iteration 3). Added `ctx.input.consume_key(...)` for all navigation keys (ArrowUp/Down/Left/Right, Home, End, Backspace, Delete) in `Knob` and `SegmentedControl`; added visible focus rings for both widgets.
- **Priority**: **P2**
- **Category**: Keyboard Reachability & Event Consumption
- **Description**:
  In `Knob` and `SegmentedControl`, keyboard interaction altered values without consuming the key events or rendering proper focus rings.
- **Failure Mechanism**:
  When a knob or segmented control was focused inside a scrollable view or dock area, pressing Arrow keys adjusted the widget value while simultaneously scrolling the parent container. Furthermore, `SegmentedControl` lacked an outer focus ring, leaving users unable to visually identify which control currently held keyboard focus.
- **Remediation**:
  Call `ctx.input.consume_key(...)` for all handled keys and render a focus ring stroke when `resp.has_focus() || ctx.has_focus(id)`.

---

## 15. Technical Documentation Accuracy (`doc`)

### AUDIT-DOC-01 (P2) [RESOLVED]: Obsolete Method Signatures and Missing Post-v0.3 Components in API Reference
- **Location**: [docs/API_DESIGN.md](file:///a:/moonbit-project/docs/API_DESIGN.md), [docs/API_DESIGN_zh.md](file:///a:/moonbit-project/docs/API_DESIGN_zh.md)
- **Status**: **RESOLVED** (Iteration 3). Synchronized `docs/API_DESIGN.md` and `docs/API_DESIGN_zh.md` with current v0.5.1 API signatures, updating `Response.id : Id`, marking `toggle` as implemented, and adding complete specifications for `VirtualList`, `Table`, `Plot`, `BarChart`, `Knob`, `Fader`, `DockArea`, `Mesh`, `SvgExporter`, and `Spring`.
- **Priority**: **P2**
- **Category**: Documentation Drift
- **Description**:
  The official API design specifications still document outdated pre-refactoring signatures.
- **Failure Mechanism**:
  - Documents `Response.id : UInt64` instead of `Id`.
  - Documents `ctx.button(id, label)` instead of `Button::new(label)` / `ctx.button(label)`.
  - Missing formal API documentation for 10+ major components delivered in v0.4 and v0.5: `Rating`, `Steps`, `VirtualList`, `Spring`, `Mesh`, `SvgExporter`, `DockArea`, `NodeEditor`, `Plot`, and `Table`.
- **Remediation**:
  Synchronize `docs/API_DESIGN.md` and `docs/API_DESIGN_zh.md` to reflect current v0.5.1 package layouts (`@core`, `@widgets`, `@composite`), modern builder signatures, and new component APIs.

---

### AUDIT-DOC-02 (P3) [RESOLVED]: Stale Monolithic `UIContext` Struct Code Sample in Flagship Studio IDE
- **Location**: [examples/canvas/studio_ide.mbt#L88-L100](file:///a:/moonbit-project/examples/canvas/studio_ide.mbt#L88-L100)
- **Status**: **RESOLVED** (Iteration 3). Updated the embedded source code string in `examples/canvas/studio_ide.mbt` to display the actual decomposed modular engine architecture (`LayoutEngine`, `FocusManager`, `LayerManager`, `WindowManager`, `Memory`, `Painter`).
- **Priority**: **P3**
- **Category**: Code Sample Drift
- **Description**:
  In the flagship Studio IDE showcase (`examples/canvas/studio_ide.mbt`), the embedded "Context Architecture" source viewer displays a mock string representing the old monolithic `UIContext` definition with flat fields (`layout_stack`, `clip_stack`, `scroll_offsets`).
- **Failure Mechanism**:
  Users inspecting the in-engine source code sample see a stale, pre-decoupling context representation rather than the modularized v0.5.1 architecture (`LayoutEngine`, `FocusManager`, `LayerManager`, `WindowManager`, `Memory`).
- **Remediation**:
  Update the embedded source string in `studio_ide.mbt` to display the actual decomposed engine architecture.

---

### AUDIT-DOC-03 (P2) [RESOLVED]: Missing SVG Text Baseline Alignment Specification Causing Vertical Text Misplacement
- **Location**: [src/draw/svg_exporter.mbt#L210-L234](file:///a:/moonbit-project/src/draw/svg_exporter.mbt#L210-L234)
- **Status**: **RESOLVED** (Iteration 2). Added `dominant-baseline="hanging"` attribute to exported `<text>` tags in `SvgExporter`, aligning SVG text rendering with top-origin layout coordinates.
- **Priority**: **P2**
- **Category**: SVG Standard Compliance & Documentation
- **Description**:
  In `SvgExporter`, text is emitted as `<text x="..." y="..." font-size="...">`.
- **Failure Mechanism**:
  In SVG, default text alignment aligns the font baseline to `y`, whereas `moon-egui`'s layout coordinates define `pos.y` as the top of the text bounding box (rendered with `textBaseline = 'middle'` and `y + fontSize * 0.48` in Canvas 2D). Consequently, when exported to SVG, all text strings are rendered shifted upwards by approximately one font height, clipping out of containers or overlapping preceding lines.
- **Remediation**:
  Add `dominant-baseline="hanging"` (or adjust `y` to `pos.y + font_size * 0.8` with `dominant-baseline="alphabetic"`) in SVG `<text>` elements.

---

### AUDIT-DOC-04 (P3) [RESOLVED]: Undocumented Primitive Loss in `DrawList::to_mesh` (Text, Gradient, Clip Omissions)
- **Location**: [src/draw/mesh.mbt#L308-L327](file:///a:/moonbit-project/src/draw/mesh.mbt#L308-L327)
- **Status**: **RESOLVED** (Iteration 2). Formally documented tessellation limitations in `Mesh::tessellate_draw_list` docstrings, specifying that `LinearGradient` is approximated as a solid rect, `Text` requires font atlas glyph quad generation, and `Clip` requires scissor testing.
- **Priority**: **P3**
- **Category**: API Technical Documentation Accuracy
- **Description**:
  `DrawList::to_mesh()` claims to batch convert an entire `DrawList` into a single contiguous `Mesh`.
- **Failure Mechanism**:
  `LinearGradient` is flattened to a plain monochrome `start_col` rect, and `Text` and `Clip` commands are silently discarded (`_ => ()`). This lossy conversion is neither documented in the public API docstrings nor guarded with warnings.
- **Remediation**:
  Formally document the tessellation limitations in `Mesh::tessellate_draw_list` docstrings, or implement vertex-color gradient interpolation for `LinearGradient`.

---

### AUDIT-A11Y-02 (P1) [RESOLVED]: Keyboard Activation Missing in Checkbox, Radio, and Toggle Switches
- **Location**: [src/widgets/toggle.mbt#L58-L64](file:///a:/moonbit-project/src/widgets/toggle.mbt#L58-L64), [L150-L156](file:///a:/moonbit-project/src/widgets/toggle.mbt#L150-L156), [L254-L259](file:///a:/moonbit-project/src/widgets/toggle.mbt#L254-L259), [src/widgets/button.mbt#L258-L290](file:///a:/moonbit-project/src/widgets/button.mbt#L258-L290)
- **Status**: **RESOLVED** (Iteration 4). Added `Key::Space` and `Key::Enter` detection, key consumption, and focus rings to `Checkbox`, `Radio`, and `Toggle`. Added `register_focusable(id)`, Space/Enter activation, and focus indicator to `color_button`.
- **Priority**: **P1**
- **Category**: Keyboard Reachability & Accessibility Standard
- **Description**:
  `Checkbox`, `Radio`, and `Toggle` call `ctx.register_focusable(id)` and display focus styling, but only toggle their state on pointer click (`resp.clicked`). They do not handle `Key::Space` or `Key::Enter`.
- **Failure Mechanism**:
  A keyboard/screen-reader user tabbing onto a `Checkbox`, `Radio`, or `Toggle` cannot toggle or activate the control with standard keyboard inputs. The keystrokes leak unconsumed to outer containers. In addition, `color_button` never calls `register_focusable`, remaining completely unreachable by keyboard navigation.
- **Remediation**:
  Check `is_focused && (ctx.input.key_pressed(Key::Space) || ctx.input.key_pressed(Key::Enter))`, consume the keys, and trigger toggle. Call `register_focusable` and draw focus indicator in `color_button`.

---

### AUDIT-MAINT-06 (P1) [RESOLVED]: Hardcoded Viewport Boundaries and Unscaled Layout Literals in Containers & Controls
- **Location**: [src/widgets/containers.mbt#L341-L440](file:///a:/moonbit-project/src/widgets/containers.mbt#L341-L440), [src/widgets/spinner.mbt#L18-L80](file:///a:/moonbit-project/src/widgets/spinner.mbt#L18-L80), [src/composite/menu_bar.mbt#L335-L348](file:///a:/moonbit-project/src/composite/menu_bar.mbt#L335-L348), [src/widgets/button.mbt#L263-L289](file:///a:/moonbit-project/src/widgets/button.mbt#L263-L289)
- **Status**: **RESOLVED** (Iteration 4). Dynamically derived screen height from `ctx.current_clip()` in `combo_box`, and scaled all item heights, padding, font sizes, radii, and chevron coordinates by `scale`. Scaled `spinner`, `menu_separator`, and `color_button` layout metrics.
- **Priority**: **P1**
- **Category**: Anti-Hardcoding & Scale Invariance
- **Description**:
  Widespread hardcoded screen dimensions, unscaled geometry literals, and unscaled theme tokens:
  - `combo_box` assumes a static `600.0` screen height for dropdown upward collision flipping (`menu_y + menu_h > 600.0`), has unscaled item heights (`24.0`), font sizes (`font_small` without `* scale`), and radii (`radius_md` / `radius_sm` without `* scale`).
  - `spinner` completely ignores `ctx.style.scale`, drawing identical 20px spinners regardless of DPI scale.
  - `menu_separator` uses raw `sep_h = 7.0`, `line_y = rect.y + 3.0`, and unscaled padding/strokes.
  - `color_button` uses unscaled `22.0`, `1.0` press offset, and `1.5` stroke.
- **Failure Mechanism**:
  At non-default DPI scale factors (1.5x, 2.0x), dropdown items appear tiny and unscaled, spinners do not scale with the host UI density, and combo popups flip inappropriately on high-resolution displays.
- **Remediation**:
  Dynamically query `ctx.input.screen_rect.h` for viewport bounds, and multiply all layout metrics, padding, font sizes, and radii by `scale`.

---

### AUDIT-UX-08 (P2) [RESOLVED]: Positional Thumb Snapping and Zero Cursor Affordance in `ScrollArea`
- **Location**: [src/widgets/scroll_area.mbt#L207-L245](file:///a:/moonbit-project/src/widgets/scroll_area.mbt#L207-L245)
- **Status**: **RESOLVED** (Iteration 4). Persisted `grab_offset` in `Memory` upon mouse press on the thumb, calculated drag offset relative to `grab_offset`, and reported `ctx.set_cursor_icon("pointer")` on thumb and track hover/active states.
- **Priority**: **P2**
- **Category**: UX Drag Stability & Cursor Contract
- **Description**:
  `ScrollArea` thumb dragging uses `thumb_h * 0.5` centering instead of tracking the initial mouse click grab offset (`grab_offset`). Furthermore, hovering and dragging the thumb or track reports no cursor icon.
- **Failure Mechanism**:
  Clicking anywhere on the scrollbar thumb abruptly snaps its center to the cursor, causing a jarring visual jump and disorientation in scroll position. Lack of `pointer` cursor violates Section 1 of the Widget Interaction Standard.
- **Remediation**:
  Persist `grab_offset` in `Memory` upon mouse press on the thumb, calculate drag offset relative to `grab_offset`, and report `ctx.set_cursor_icon("pointer")` on thumb and track hover/active states.

---

### AUDIT-LOGIC-06 (P2) [RESOLVED]: Scissor Clipping and Hit-Test Isolation Bypass in DockArea and NodeEditor
- **Location**: [src/composite/dock.mbt#L461-L470](file:///a:/moonbit-project/src/composite/dock.mbt#L461-L470), [src/composite/node_editor.mbt#L326-L725](file:///a:/moonbit-project/src/composite/node_editor.mbt#L326-L725)
- **Status**: **RESOLVED** (Iteration 4). Pushed and popped scissor clip on `UIContext` via `ctx.push_clip` and `ctx.pop_clip` in both `DockArea` tab content rendering and `NodeEditor` canvas scope so `is_hovered` respects container clips.
- **Priority**: **P2**
- **Category**: Scissor Clipping & Scoped Hit-Testing
- **Description**:
  In `DockArea` leaf tab content rendering, clipping is pushed to a local sub-painter (`content_painter.push_clip(content_rect)`), but `ctx.push_clip(content_rect)` is never invoked on `UIContext`. In `NodeEditor`, `painter.push_clip(canvas_rect)` is called instead of `ctx.push_clip(canvas_rect)`.
- **Failure Mechanism**:
  Because `ctx.layers.clip_stack` remains unaffected, `ctx.is_hovered(...)` called by child widgets inside dock panels or node canvas cannot detect that widgets are clipped outside `content_rect`. Widgets spilling outside the panel boundary continue responding to mouse hover and clicks.
- **Remediation**:
  Invoke `ctx.push_clip(content_rect)` and `ctx.pop_clip()` on `UIContext` around child content rendering.

---

### AUDIT-UX-09 (P2) [RESOLVED]: Missing Vertical Scrolling, Mouse Wheel Ingestion, and Selection Auto-Scroll in Fixed-Size TreeView
- **Location**: [src/composite/tree_view.mbt#L130-L245](file:///a:/moonbit-project/src/composite/tree_view.mbt#L130-L245)
- **Status**: **RESOLVED** (Iteration 4). Scaled `indent_step`, added persistent `scroll_y` offset tracking, mouse wheel delta handling, auto-scrolling during keyboard navigation, and interactive scrollbar thumb with pointer cursor.
- **Priority**: **P2**
- **Category**: Container Usability & Dynamic Viewports
- **Description**:
  When `TreeView` is allocated with an explicit height constraint (`size = Some(...)`), it does not support vertical scrolling: `scroll_y` is neither tracked nor applied, mouse wheel delta (`scroll_delta.y`) is discarded, and no scrollbar is rendered.
- **Failure Mechanism**:
  In project sidebars (such as the Studio IDE explorer) with dozens of files, items below the container height are permanently clipped and inaccessible. Navigating with keyboard down-arrow selects off-screen items that remain invisible.
- **Remediation**:
  Track `scroll_y` in `Memory`, handle mouse wheel delta, auto-scroll to keep the selected item in view during keyboard traversal, and render an interactive scrollbar thumb when content overflows.

---

### AUDIT-PERF-04 (P2) [RESOLVED]: 16-Command Discrete Strip Flood in ColorPicker Alpha Slider & ProgressBar NaN Sensitivity
- **Location**: [src/composite/color_picker.mbt#L341-L356](file:///a:/moonbit-project/src/composite/color_picker.mbt#L341-L356), [src/widgets/feedback.mbt#L52-L58](file:///a:/moonbit-project/src/widgets/feedback.mbt#L52-L58)
- **Status**: **RESOLVED** (Iteration 4). Replaced 16-slice rect strip loop in `ColorPicker` Alpha slider with single continuous `LinearGradient` primitive with `inner_radius`. Added `fraction.is_nan()` validation in `ProgressBar`.
- **Priority**: **P2**
- **Category**: Rendering Performance & Arithmetic Robustness
- **Description**:
  The Alpha slider in `ColorPicker` renders 16 separate small rectangle strips with `0.0` corner radius to fake a transparency gradient, flooding `DrawList` with 16 draw commands per frame and bleeding out of rounded container corners. In `ProgressBar`, `fraction` lacks `is_nan()` validation.
- **Failure Mechanism**:
  The discrete alpha slices produce visible banding and corner bleed. In `ProgressBar`, passing `NaN` bypasses `< 0.0` and `> 1.0` checks, leading to `NaN.to_int()` crashes or malformed text formatting.
- **Remediation**:
  Replace the 16 rectangle strips with a single continuous `LinearGradient` primitive with `inner_radius`. Add `is_nan()` guard in `ProgressBar`.

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




