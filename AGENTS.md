# Project Agents.md Guide

This is a [MoonBit](https://docs.moonbitlang.com) project.

You can browse and install extra skills here:
<https://github.com/moonbitlang/skills>

## Project Structure

- MoonBit packages are organized per directory; each directory contains a
  `moon.pkg` file listing its dependencies. Each package has its files and
  blackbox test files (ending in `_test.mbt`) and whitebox test files (ending in
  `_wbtest.mbt`).

- In the toplevel directory, there is a `moon.mod` file listing module
  metadata.

## Coding convention

- MoonBit code is organized in block style, each block is separated by `///|`,
  the order of each block is irrelevant. In some refactorings, you can process
  block by block independently.

- Try to keep deprecated blocks in file called `deprecated.mbt` in each
  directory.

## Tooling

- `moon fmt` is used to format your code properly.

- `moon ide` provides project navigation helpers like `peek-def`, `outline`, and
  `find-references`. See $moonbit-agent-guide for details.

- `moon info` is used to update the generated interface of the package, each
  package has a generated interface file `.mbti`, it is a brief formal
  description of the package. If nothing in `.mbti` changes, this means your
  change does not bring the visible changes to the external package users, it is
  typically a safe refactoring.

- In the last step, run `moon info && moon fmt` to update the interface and
  format the code. Check the diffs of `.mbti` file to see if the changes are
  expected.

- Run `moon test` to check tests pass. MoonBit supports snapshot testing; when
  changes affect outputs, run `moon test --update` to refresh snapshots.

- Prefer `assert_eq` or `assert_true(pattern is Pattern(...))` for results that
  are stable or very unlikely to change. For snapshot tests that record
  structured debugging output, derive `Debug` and use `debug_inspect`, rather
  than deriving `Show` for debugging. For solid, well-defined results (e.g.
  scientific computations), prefer assertion tests. You can use
  `moon coverage analyze > uncovered.log` to see which parts of your code are
  not covered by tests.

## UI/UX Design & Presentation Standard

All UI/UX design, visual styling, web layouts, and showcase presentation interfaces in this project **MUST** invoke and follow the `impeccable` skill (`C:/Users/www17/.gemini/config/skills/impeccable/SKILL.md`). Deliver out-of-distribution craft, production-grade aesthetics, intentional visual hierarchy, and refined interactive details.

## Copywriting and Technical Tone Standard (Mandatory)

- **Strictly Zero Exaggeration / Factual Tone**: Strictly forbid sensationalism or exaggerated buzzwords such as "工业级", "专业级", "顶级", "极致", "海量数据", "军工级", or similar marketing jargon across all code, documentation, web UI text, showcase component descriptions, and commit messages.
- **Accurate & Restrained**: Use clean, factual, professional engineering terminology (e.g., "核心交互控件", "数据虚拟化表格", "HSV 拾色器", "开发规范").

## Anti-Hardcoding and Design Tokens Standard (Mandatory)

Hardcoding arbitrary constants (magic numbers, raw color literals, fixed layout offsets) is strictly forbidden across all engine packages (`src/core`, `src/draw`, `src/color`, `src/math`) and example stages (`examples/canvas`). All implementations must strictly adhere to the following rules:

1. **Geometry and Sizing via `WidgetStyle`**:
   - Forbid raw float literals for widget dimensions (e.g. heights, line heights, inner paddings, corner radii, gutter widths).
   - Every layout metric must derive from `self.style` (`WidgetStyle` in `src/core/theme.mbt`) and be scalable via `self.style.scale`.
   - When introducing or updating any UI widget, all associated sizing, spacing, and radius constants must be formally declared as fields in `WidgetStyle` with appropriate defaults, rather than inline magic numbers.

2. **Colors, Translucency, and Elevation via `@color.Color`**:
   - Forbid inline `Color::rgba(...)`, `Color::rgb(...)`, raw `Color::white()` / `black()`, and ad-hoc integer `.with_alpha(...)` calls within widget drawing logic.
   - All colors must use semantic palette tokens defined in `src/color/color.mbt` (e.g. `bg_surface()`, `bg_window()`, `border_muted()`, `accent_primary()`, `text_strong()`).
   - If an interaction state or overlay requires a specific translucent layer (e.g. modal scrim, hover wash, focus ring, ambient shadow), declare a semantic token in `src/color/color.mbt` instead of inlining magic alpha values.

3. **Dynamic Viewport and Container Boundaries**:
   - Forbid assuming static screen or window resolutions (e.g. default `(800.0, 600.0)` or `(1920.0, 1080.0)`).
   - Modals, popups, dialogs, and background scrims must compute dimensions dynamically from `self.input.screen_rect` or explicit container bounds passed by the caller.

4. **Typography and Text Measurements**:
   - Typography sizes must reference tokenized style metrics (`self.style.font_normal`, `self.style.font_small`, `self.style.font_large`).
   - Forbid arbitrary literal font sizes (e.g. `10.5`, `11.5`, `12.5`, `13.5`) scattered across widget implementations.
   - Precision-critical text components (such as `CodeEditor`) must compute positions through structured monospace metrics or layout contexts, avoiding manual ad-hoc character offset tables.

5. **Showcase and Demo Layouts**:
   - Example stages in `examples/canvas/` must use structured container queries and `available_width` instead of arbitrary manual subtractions (e.g. `card_w - 32.0`, `card_w - 40.0`).

## Low-Coupling Architecture & Structural Decoupling Standard (Mandatory)

All structural and component implementations in this repository **MUST** strictly adhere to low-coupling, high-cohesion architectural principles. Anti-patterns such as God Objects, leaking widget-private state into central contexts, flat monolithic style tokens, and unconstrained coordinate mutation are strictly forbidden.

1. **Context Decoupling & Zero Private Widget State in `UIContext`**:
   - `UIContext` must exclusively house core engine runtime primitives (frame lifecycle, layout stack, focus ring, layer composition, and window manager).
   - **Strictly Forbid adding widget-specific fields** (e.g. `foo_scroll_offset`, `bar_cursor_pos`, `baz_open_id`) to `UIContext`.
   - All cross-frame persistent widget state must be encapsulated within widget-defined state structs and stored via the generic `Memory` / `IdMap` key-value subsystem.

2. **Design Tokens vs. Component Configuration Stratification**:
   - `WidgetStyle` must only hold foundational, systemic design tokens (scale factor, typography scales `font_sm/md/lg`, spacing scales `spacing_xs/sm/md/lg`, radius scales `radius_sm/md/lg`, elevation, and base control heights `control_h_sm/md/lg`).
   - **Strictly Forbid adding widget-specific geometry fields** directly to `WidgetStyle` (e.g. `knob_r`, `fader_cap_w`, `dialog_btn_w`).
   - Widgets must derive their layout metrics proportionally from foundational tokens, or accept an optional component-level style descriptor (e.g. `CodeEditorStyle`).

3. **First-Class Widget Structs & Fluent Builder Protocol**:
   - Complex interactive widgets must be declared as standalone first-class structs (e.g. `Slider[T]`, `Knob`, `Fader`, `Plot`, `Table`) with fluent builder methods (`.step(...)`, `.min(...)`, `.max(...)`, `.primary(...)`).
   - **Strictly Forbid expanding function signatures** with more than 4-5 positional/optional parameters on `UIContext` methods.
   - Support uniform `ui.add(widget)` dispatch while retaining lightweight `ctx.widget(...)` convenience one-liners.

4. **Rendering & Scissor Isolation via `Painter`**:
   - Widgets must not directly mutate global coordinate arithmetic on `DrawList` or manually manage scissor clipping stacks.
   - Drawing operations must be routed through scoped `Painter` abstractions that automatically enforce relative coordinate offsets and active clip bounds.

5. **Physical Package & Directory Layering**:
   - Maintain strict unidirectional dependency flow across packages (`math` -> `color` -> `draw` -> `core/engine` -> `core/widgets` -> `core/composite`).
   - Prevent circular dependencies and avoid flat directory accumulation (no single directory should exceed ~15-20 source files).

### Architectural Decoupling Checklist (Mandatory for PRs and Reviews)

Before proposing, reviewing, or committing any structural changes, every developer and agent must verify this checklist:

- [ ] **Context Integrity**: Does this change add any new fields to `UIContext`? (If YES, reject unless it is a universal engine subsystem primitive).
- [ ] **State Encapsulation**: Is widget persistence handled via generic `Memory` / `IdMap` with self-contained state structs rather than central context fields?
- [ ] **Token Stratification**: Does `WidgetStyle` remain free of component-specific geometry constants? Are component metrics derived from foundational tokens?
- [ ] **Widget API Surface**: Are complex widgets defined as standalone structs with fluent builder methods rather than sprawling 6+ parameter functions?
- [ ] **Drawing Scoping**: Does drawing logic avoid hardcoded absolute screen coordinate assumptions and direct scissor stack manipulations?
- [ ] **Package Boundary**: Does this change respect unidirectional package dependencies without introducing circular dependencies or cross-layer private leaks?

## Synchronous Release and Publishing Standard (Mandatory)

Every version release of this library **MUST** execute a synchronized dual-channel release across MoonBit Mooncake Registry and Git remote repository in strict lockstep. Releasing to one channel without the other is strictly prohibited.

The canonical release procedure is defined as follows:

1. **Version Declaration & Documentation Synchronization Checklist**:
   - **Module Manifest**: Bump `version = "X.Y.Z"` in `moon.mod` adhering to Semantic Versioning (`MAJOR.MINOR.PATCH`).
   - **CLI Console Output**: Update version string in `cmd/main/main.mbt` (`println("=== Moon-EGUI vX.Y.Z Interactive Frame ===")`) to prevent drift.
   - **Release Changelog**: Insert new release section `## [X.Y.Z] - YYYY-MM-DD` in `docs/CHANGELOG.md` with complete Added/Fixed/Changed entries.
   - **Project READMEs**: In both `README.md` and `README_en.md`, update:
     - Versioned installation commands (`moon add LING71671/moon-egui@X.Y.Z`).
     - Delivered widget count (e.g. 32 Available Widgets) and automated test count.
     - Milestone checklist status in the Development Roadmap section.
   - **Roadmap Documents**: Update `docs/ROADMAP.md` and `docs/ROADMAP_en.md` delivery checkboxes.
   - **Web Showcase Brand Badges & Cache Busters**:
     - `examples/canvas/index.html`: Update navigation `<span class="brand-tag">vX.Y.Z</span>` and quickstart copy command.
     - `examples/canvas/gallery.html`: Update navigation `<span class="brand-tag">vX.Y.Z</span>` and script/CSS query strings (`canvas.js?v=X.Y.Z`, `css/gallery.css?v=X.Y.Z`).
     - `examples/canvas/docs.html`: Update navigation `<span class="brand-tag">vX.Y.Z</span>` and page header `<span class="page-badge">MOON-EGUI API REFERENCE · vX.Y.Z</span>`.
     - `examples/canvas/benchmark.html`: Update script query strings (`canvas.js?v=X.Y.Z`, `js/run.js?v=X.Y.Z`).

2. **Interface Generation and Code Formatting**:
   - Execute `moon info && moon fmt`.
   - Review package `.mbti` diffs to ensure no unintended breaking changes or interface drift.

3. **Compilation and Test Suite Verification**:
   - Execute `moon test` and ensure 100% test pass rate across all unit and whitebox tests.
   - Verify Wasm-GC compatibility via `moon check --target wasm-gc`.
   - Rebuild demo bundle synchronously using both `pwsh scripts/build_demo.ps1` (local) and `sh scripts/build_demo.sh` (Linux CI compatibility) to keep runtime assets in sync.

4. **Mooncake Central Registry Publishing**:
   - Run `moon publish --dry-run` to validate package archive construction and server pre-flight checks (verifying `Server status: 202 Accepted`).
   - Run `moon publish` to formally upload the package archive. Verify `Server status: 200 OK`.
   - Run `moon update` to refresh the local registry index and verify that the new version appears in `$env:USERPROFILE\.moon\registry\index\user\LING71671\moon-egui.index`.

5. **Git Commit, Tagging, and Synchronous Remote Push**:
   - Stage all modified files (`moon.mod`, `.mbti`, source files, demo bundles, HTML showcase pages, changelog, READMEs).
   - Commit using Conventional Commits: `release: vX.Y.Z - <summary>`.
   - Create an annotated Git tag: `git tag -a vX.Y.Z -m "<release-notes>"`.
   - Push both the main branch and release tags synchronously: `git push origin main && git push origin vX.Y.Z` (or `git push && git push --tags`).
   - Ensure working tree is clean and `origin/main` is in lockstep with local HEAD.
   - Verify that the `Deploy GitHub Pages` and `CI` GitHub Actions workflows both pass with 100% green status.

6. **GitHub Official Release Publication**:
   - Create the official GitHub Release associated with the Git tag:
     `gh release create vX.Y.Z -t "vX.Y.Z — <Title>" -F scratch/release_notes_vX.Y.Z.md`
   - Verify that the release displays as `Latest` on `https://github.com/LING71671/moon-egui/releases`.

## Commit Granularity and Categorization Standard (Mandatory)

All commits in this repository must strictly adhere to fine-grained categorization and size constraints. Monolithic, omnibus, or catch-all commits are strictly prohibited:

1. **Single Concern & Atomic Scope**:
   - Each commit must encapsulate exactly one logical concern or architectural layer.
   - Forbid mixing unrelated changes into a single commit (e.g. core widget implementations, style token normalization, test suites, compiled runtime bundles, and documentation updates must never be merged into one commit).

2. **Sequential Multi-Stage Commit Pipeline**:
   When implementing features or refactoring, break the work down into a logical sequence of small, atomic commits:
   - **Step 1 (Core)**: `feat(core): ...` or `refactor(core): ...` — pure MoonBit engine primitives, structs, or layout logic.
   - **Step 2 (Styles & Tokens)**: `style(theme): ...` or `style(core): ...` — design tokens, sizing metrics, or palette extensions.
   - **Step 3 (Automated Tests)**: `test(core): ...` — whitebox (`_wbtest.mbt`) and blackbox (`_test.mbt`) suites with 100% pass verification.
   - **Step 4 (Showcase & Bundles)**: `build(demo): ...` or `feat(gallery): ...` — example gallery integration and synchronized runtime assets (`canvas.js`).
   - **Step 5 (Documentation)**: `docs: ...` — updates to READMEs, ROADMAP, CHANGELOG, or ISSUE tracking.

3. **Conventional Commits Categorization**:
   - `feat(<scope>)`: New widget or public API capability.
   - `fix(<scope>)`: Bug fixes or edge-case handling.
   - `refactor(<scope>)`: Structural cleanup without behavioral changes.
   - `style(<scope>)`: Theme tokens, formatting, or metric definitions.
   - `test(<scope>)`: Test suite additions, snapshots, or coverage improvements.
   - `build(<scope>)`: Build scripts, compiler targets, or compiled demo assets.
   - `docs(<scope>)`: Technical documentation, changelogs, roadmaps, or specifications.
   - `chore(<scope>)`: Minor maintenance or configuration updates.

4. **Commit Size Guardrails**:
   - Keep commits small, readable, and easily bisectable.
   - If a change touches more than ~5-8 files across different directory domains (e.g. `src/core`, `examples/`, `docs/`), it MUST be decomposed by domain into separate atomic commits.


