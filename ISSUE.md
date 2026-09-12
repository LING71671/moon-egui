# Technical Inventory: Defects (bug) and Feature Capabilities (feat)

This document provides a systematic, factual audit of the codebase (`src/core`, `src/draw`, `src/color`, `src/math`, and runtime showcase pages).

It is organized into three primary tracks:
- **Part I: Defects and Technical Debt (`bug`)**: Memory leaks, state corruption, unhandled input channels, typographical drift, and widget edge-case omissions.
- **Part II: Engine Capabilities and Dogfooding Roadmap (`feat`)**: Core engine extensions, layout enhancements, and showcase pages where raw HTML/DOM should be replaced by our native MoonBit GUI engine.
- **Part III: Structural Decoupling and Architecture Modularization (`arch`)**: Subsystem modularization, generic memory persistence, design token stratification, first-class widget structs, painter rendering abstraction, package hierarchy, and showcase stage decomposition.

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

## 7. Core Engine & Widget Feature Roadmap (`feat`)

### FEAT-CORE-01 (High): Multi-Window Docking and Tiling Layout System (`DockArea`)
- **Category**: Layout & Window Management
- **Description**:
  Currently, `window()` only supports floating drag-and-drop. It cannot dock to window edges (Left, Right, Bottom), split into tabs, or tile across panes.
- **Proposed Capability**:
  Introduce a `DockArea` or `dock_node` layout abstraction supporting:
  - Splitting workspace into horizontal/vertical dock containers.
  - Tabbed window grouping.
  - Drag-to-dock preview overlays.

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

### ARCH-06 (P2): Multi-Package Architectural Hierarchy (Decomposing the 59-File `src/core` Monolith)
- **Location**: [src/core/](file:///a:/moonbit-project/src/core/)
- **Status**: Backlog
- **Category**: Package Architecture
- **Description**:
  `src/core` contains 59 source files, housing both the immediate-mode engine runtime (`Id`, `InputState`, `Layout`, `Context`, `Theme`) and all 32 specialized domain widgets (from `Button` to `Plot`, `Table`, `CodeEditor`, and `CommandPalette`).
- **Coupling Mechanism**:
  1. No physical package encapsulation exists between the runtime core and domain widgets.
  2. Developers cannot import just the core engine runtime to build bespoke widgets without pulling in all 32 built-in widgets.
- **Remediation**:
  - Structure `src/core` into layered logical packages:
    - `src/core` (pure immediate-mode runtime: `Id`, `InputState`, `Memory`, `Layout`, `UIContext`, `Painter`)
    - `src/widgets` (standard UI controls: `Button`, `Checkbox`, `Slider`, `Toggle`, `TextEdit`, `Label`, `Containers`)
    - `src/composite` (advanced widgets: `CodeEditor`, `Plot`, `Table`, `TreeView`, `ColorPicker`, `CommandPalette`)
    - `src/` (umbrella package re-exporting all components for backward compatibility)

---

### ARCH-07 (P2): Showcase Stage Modularization (Splitting 2088-Line `gallery_stage.mbt` Monolith)
- **Location**: [examples/canvas/gallery_stage.mbt](file:///a:/moonbit-project/examples/canvas/gallery_stage.mbt)
- **Status**: Backlog
- **Category**: Showcase Architecture
- **Description**:
  `gallery_stage.mbt` contains 2088 lines of code in a single file, encompassing all 32 component gallery stages, porcelain card framing, telemetry, host input conversion, and view-mode layout switching.
- **Coupling Mechanism**:
  1. Every modification to a single component's showcase triggers re-compilation of the entire 2088-line showcase unit.
  2. Monolithic `match comp_id { "button" => ..., "slider" => ..., ... }` pattern matching with 32 branches hinders modular additions.
- **Remediation**:
  - Decompose `gallery_stage.mbt` into modular stage units:
    - `examples/canvas/stages/basic_stages.mbt` (`button`, `slider`, `toggle`, `checkbox`, `radio`, `badge`)
    - `examples/canvas/stages/editor_stages.mbt` (`text_edit`, `code_editor`, `rich_text`)
    - `examples/canvas/stages/data_stages.mbt` (`table`, `tree_view`, `plot`, `sparkline`)
    - `examples/canvas/stages/audio_stages.mbt` (`knob`, `fader`)
    - `examples/canvas/stages/nav_stages.mbt` (`tabs`, `breadcrumb`, `segmented`, `menu_bar`)
    - `examples/canvas/gallery_stage.mbt` (retains only frame harness, porcelain shell, and dispatcher)

---

## 9. Prioritized Roadmap & Milestone Matrix

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
| **feat** | `FEAT-CORE-01` | Multi-Window Docking Layout System (`DockArea`) | **P3** | Backlog |
| **feat** | `FEAT-CORE-05` | Immediate-Mode Plotting & Charting Suite (`plot`, `bar_chart`) | **P3** | Resolved (Phase 7) |
| **arch** | `ARCH-01` | `UIContext` God-Object Subsystem Modularization | **P1** | Resolved (Phase 2) |
| **arch** | `ARCH-02` | Generic Keyed State Storage (`Memory` / `IdMap`) | **P1** | Resolved (Phase 1) |
| **arch** | `ARCH-03` | `WidgetStyle` Token Decoupling (System vs Component) | **P1** | Resolved (Phase 4) |
| **arch** | `ARCH-04` | First-Class Widget Structs & Fluent Builder Protocol | **P1** | Backlog |
| **arch** | `ARCH-05` | `Painter` Rendering & Scissor Coordinate Abstraction | **P2** | Resolved (Phase 3) |
| **arch** | `ARCH-06` | Multi-Package Hierarchy (Decompose `src/core` Monolith) | **P2** | Backlog |
| **arch** | `ARCH-07` | Showcase Stage Modularization (`gallery_stage.mbt`) | **P2** | Backlog |
