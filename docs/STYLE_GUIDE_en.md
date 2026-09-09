# MoonBit Official Style Guide & Engineering Conventions

<p>
  <a href="STYLE_GUIDE_en.md">English</a> · <a href="STYLE_GUIDE.md">简体中文</a>
</p>

`moon-egui` strictly adheres to the official [MoonBit Documentation](https://docs.moonbitlang.com), standard library best practices (`moonbitlang/core`), and MoonBit compiler toolchain guidelines. This document serves as the standard engineering reference for all contributors.

---

## 1. Source Organization & Block Syntax

MoonBit employs a block-based syntax (`///|`) designed for incremental parsing, fast parallel compilation, and clean code generation.

### 1.1 Top-Level Block Separator `///|`
- Every top-level type, struct, enum, function, method, and trait implementation **must be preceded by `///|`** as its delimiter.
- The physical order of blocks within a file is semantically irrelevant (the compiler parses blocks independently).

```moonbit
///|
pub struct Rect {
  x : Double
  y : Double
  width : Double
  height : Double
}

///|
pub fn Rect::new(x : Double, y : Double, width : Double, height : Double) -> Rect {
  { x, y, width, height }
}
```

### 1.2 Separation of Types and Implementations
- Following core library guidelines (`moonbitlang/core`), complex domain models should separate core type definitions from extended method implementations to keep type declarations lightweight and readable.

---

## 2. Naming Conventions

| Language Element | Convention | Example | Prohibited |
| :--- | :--- | :--- | :--- |
| **Types / Structs** | `PascalCase` | `UIContext`, `Vec2`, `DrawCmd` | Lowercase snake_case (e.g. `ui_context`) |
| **Enums & Variants** | `PascalCase` | `Color::White`, `DrawCmd::Rect` | Lowercase variants |
| **Traits** | `PascalCase` | `Painter`, `Widget` | - |
| **Functions & Methods** | `snake_case` | `update_ui()`, `hit_test()` | Uppercase starting letters (`UpdateUI`) |
| **Variables & Fields** | `snake_case` | `cursor_y`, `hovered_id` | CamelCase |
| **Packages & Dirs** | Kebab/snake_case | `cmd/main`, `moon-egui` | Special characters |

---

## 3. Visibility & Immutability

### 3.1 Private by Default
- All unannotated functions, struct fields, and methods are package-private.
- Only mark APIs with `pub` if they are explicitly intended for external consumers.

### 3.2 Struct Field Protection
- If a struct field should be visible externally but protected from in-place mutation, use `pub(readonly)`:
```moonbit
///|
pub struct InputState {
  pub(readonly) mouse_x : Double
  pub(readonly) mouse_y : Double
  pub(readonly) mouse_down : Bool
}
```

### 3.3 Dot-Call Extension Syntax
- Define methods by binding to the type namespace (e.g. `fn Rect::contains(...)`), enabling ergonomic dot-call syntax on instances (`rect.contains(point)`).

---

## 4. String Literals & Doc Comments

- **Multi-line Strings**: In a single code block, do not mix `$|` (interpolation) and `#|` (raw multi-line string). Stick to one format per block.
- **Doc Comments**: Use `///` Markdown doc comments above public declarations for automatic IDE hover documentation and generated reference docs.

---

## 5. Error Handling & Control Flow

- **Explicit Result Types**: Operations that can fail should return `Result[T, E]` or `Option[T]` rather than panicking.
- **Pure Functions First**: Keep UI measurement, layout calculation, and geometry pure and deterministic without side effects.

---

## 6. Testing Standards

MoonBit provides first-class native test runner support. Test suites are organized into two distinct tiers:

### 6.1 Whitebox Unit Tests (`*_wbtest.mbt`)
- Files ending in `_wbtest.mbt`.
- Reside in the same package directory and **have access to private internal structs, state, and helper functions** for rigorous boundary testing.

### 6.2 Blackbox Integration Tests (`*_test.mbt`)
- Files ending in `_test.mbt`.
- Only interact through public `pub` APIs, verifying end-user integration behavior.

### 6.3 Assertion Practices
- For deterministic numerical and geometric calculations, always prefer `assert_eq!` or `assert_true!`.
- Structured snapshot testing uses `inspect!`, refreshed via `moon test --update`.

---

## 7. Tooling & CI Validation

Code formatting and interface stability are strictly enforced by the MoonBit toolchain:

```bash
# 1. Format project source code (run before every commit)
moon fmt

# 2. Verify formatting in CI
moon fmt --check

# 3. Run all unit and integration tests
moon test

# 4. Generate and update public package interface contracts (.mbti)
moon info

# 5. Build WebAssembly release bundle
moon build --target wasm
```

### 7.1 `.mbti` Interface Contracts
- Running `moon info` updates `.mbti` files, which formally describe the package's exported type signatures.
- Inspect `git diff *.mbti` during code reviews to verify backward compatibility.

---

## 8. Deprecation Policy

- Deprecated functions should be annotated with `#deprecated`, causing compiler warnings and IDE strikethrough styling.
- Keep deprecated blocks grouped inside a dedicated `deprecated.mbt` file in each package to avoid cluttering active code.
