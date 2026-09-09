# Contributing to Moon-EGUI

<p>
  <a href="CONTRIBUTING.md">English</a> · <a href="CONTRIBUTING_zh.md">简体中文</a>
</p>

Thank you for your interest in contributing to `moon-egui`! This document outlines our development process, coding standards, and testing conventions.

---

## 1. Development Prerequisites

- **MoonBit Toolchain**: Install via the official installer:
  ```powershell
  irm https://cli.moonbitlang.com/install/powershell.ps1 | iex
  ```
- **Git**: Version 2.40+
- **VS Code** with the official **MoonBit Extension** for IDE navigation, jump-to-definition, and inline diagnostics.

---

## 2. Coding Conventions

MoonBit follows specific idiomatic conventions:

1. **Block Organization**: Code is grouped in logical blocks separated by `///|`. The order of blocks within a package file is independent.
2. **Formatting**: Always format code using `moon fmt` before committing:
   ```bash
   moon fmt
   ```
3. **Interface Maintenance**: When modifying public APIs, run `moon info` to update generated `.mbti` package interface files:
   ```bash
   moon info
   ```
   Inspect any `.mbti` diffs to ensure no unintended breaking changes are introduced.
4. **Style**:
   - Types and traits use `UpperCamelCase` (e.g. `UIContext`, `DrawCmd`).
   - Functions, methods, and variables use `snake_case` (e.g. `button`, `slider_float`).
   - Private helper functions should be marked without `pub`.

---

## 3. Testing Standards

High test coverage is mandatory for all core geometric, layout, and state machine algorithms:

- **Whitebox tests** live in `*_wbtest.mbt` files inside the package directory.
- **Blackbox / integration tests** live in `*_test.mbt` files.
- Run tests:
  ```bash
  moon test
  ```
- Snapshot updates (when intentionally changing outputs):
  ```bash
  moon test --update
  ```
- Prefer deterministic assertions (`assert_eq!`, `assert_true!`) over print statements.

---

## 4. Git Commit Message Conventions

We strictly enforce [Conventional Commits](https://www.conventionalcommits.org/):

Format: `<type>(<scope>): <short summary>`

Common types:
- `feat`: A new user-facing feature or widget
- `fix`: A bug fix
- `docs`: Documentation updates or design specs
- `test`: Adding or refactoring unit tests
- `refactor`: Code restructuring without functional change
- `perf`: Performance optimizations
- `chore`: Tooling, build system, or dependency updates

Examples:
- `feat(widget): add SliderFloat and DragValue controls`
- `fix(window): correct Z-index focus sorting on pointer down`
- `test(geom): add AABB boundary intersection edge case tests`

---

## 5. Development Workflow

1. Fork or clone the repository:
   ```bash
   git clone https://github.com/LING71671/moon-egui.git
   ```
2. Create a feature branch:
   ```bash
   git checkout -b feat/your-feature-name
   ```
3. Implement your changes following the architectural specs in `docs/ARCHITECTURE.md`.
4. Ensure all tests and formatters pass:
   ```bash
   moon info && moon fmt && moon test
   ```
5. Commit and push your changes, then open a Pull Request.
