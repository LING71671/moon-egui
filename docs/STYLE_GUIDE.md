# MoonBit 官方编码规范与工程风格指南 (MoonBit Style Guide)

本项目 `moon-egui` 严格遵循 [MoonBit 官方](https://docs.moonbitlang.com) 编码规范、标准库最佳实践（`moonbitlang/core`）以及工具链设计哲学。本指南作为全项目的标准代码与工程规范参考。

---

## 1. 源码组织与块级结构 (Block Style)

MoonBit 采用独特的块级组织规范（Block-based syntax），以便编译器进行增量语法分析与并行编译。

### 1.1 顶层块分隔符 `///|`
- 每个顶层类型、结构体、枚举、函数、方法及 Trait 实现之间，**必须且只能使用 `///|` 作为标准分隔符**；
- 单个文件内各个 `///|` 块之间的物理声明顺序在语义上是无关的（编译器独立解析）。

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

### 1.2 类型与实现解耦 (Separation of Types)
- 遵循官方核心库（`moonbitlang/core` Issue #1020）规范，复杂的领域模型建议优先将核心类型定义与外部扩展实现分离，保持核心类型文件轻量纯粹。

---

## 2. 命名规范 (Naming Conventions)

| 语言元素 | 命名格式 | 示例 | 禁忌 |
| :--- | :--- | :--- | :--- |
| **类型 / 结构体** | 大驼峰 `PascalCase` | `UIContext`, `Vec2`, `DrawCmd` | 禁止小写下划线（如 `ui_context`） |
| **枚举与变体** | 大驼峰 `PascalCase` | `Color::White`, `DrawCmd::Rect` | 禁止小写变体 |
| **Trait 特征** | 大驼峰 `PascalCase` | `Painter`, `Widget` | - |
| **函数与方法** | 蛇形命名 `snake_case` | `update_ui()`, `hit_test()` | 官方禁止大写开头（如 `UpdateUI`） |
| **局部变量 / 字段** | 蛇形命名 `snake_case` | `cursor_y`, `hovered_id` | 禁止驼峰命名 |
| **包名 / 目录** | 小写中划线 / 下划线 | `cmd/main`, `moon-egui` | 避免特殊符号 |

---

## 3. 可见性与类型安全 (Visibility & Immutability)

### 3.1 默认私有原则
- 所有未标注 `pub` 的函数、结构体字段、方法均为包内私有（Package-private）；
- 仅对外部调用者必需的公共 API 添加 `pub` 导出。

### 3.2 结构体字段保护
- 如果结构体字段需要对外暴露但禁止外部直接就地修改，必须使用 `pub(readonly)`：
```moonbit
///|
pub struct InputState {
  pub(readonly) mouse_x : Double
  pub(readonly) mouse_y : Double
  pub(readonly) mouse_down : Bool
}
```

### 3.3 扩展方法调用语法 (Dot Syntax)
- 库作者为类型设计方法时，推荐显式绑定类型命名空间（如 `fn Rect::contains(...)`），使外部可以直接使用优雅的点语法（`rect.contains(point)`）。

---

## 4. 字符串与字面量风格 (String Literals)

- **多行字符串**：官方要求在同一个代码块内不得混用 `$|`（插值）和 `#|`（原始多行文本）风格，整个块必须统一选用一种。
- **文档注释**：采用 `///` 开头的标准 Markdown 注释，自动支持被 IDE 悬浮提示与文档生成工具解析。

---

## 5. 错误处理与控制流 (Error Handling)

- **显式结果类型**：业务中可能失败的操作，优先返回 `Result[T, E]` 或 `Option[T]`，避免隐式崩溃；
- **纯函数优先**：UI 核心计算与布局计算保证无副作用，状态突变限制在明确的生命周期内。

---

## 6. 测试分层规范 (Testing Standards)

MoonBit 提供原生的一级测试支持，测试代码划分为两个层级：

### 6.1 白盒单元测试 (`*_wbtest.mbt`)
- 文件命名以 `_wbtest.mbt` 结尾；
- 与被测源码位于同一目录，**允许直接访问包内未导出的私有结构体、内部状态与私有算法**进行极端边界压测。

### 6.2 黑盒集成测试 (`*_test.mbt`)
- 文件命名以 `_test.mbt` 结尾；
- 仅允许调用通过 `pub` 导出的正式接口，站在终端用户视角验证功能完整性。

### 6.3 断言规范
- 确定性的算法与数值计算（如几何碰撞、坐标换算、颜色混合），一律使用 `assert_eq!` 或 `assert_true!`；
- 结构化快照调试可使用 `inspect!`，更新时配合 `moon test --update`。

---

## 7. 工具链与自动化门禁 (Tooling & CI)

代码格式化不依赖人工争论，全部交由官方工具自动化裁决：

```bash
# 1. 自动格式化项目源码（必须在每次提交前执行）
moon fmt

# 2. 检查格式是否符合官方标准（CI 门禁自动检查）
moon fmt --check

# 3. 运行全量单元测试
moon test

# 4. 更新与校验公开包接口契约文件 (.mbti)
moon info

# 5. 验证 WebAssembly 编译链路
moon build --target wasm
```

### 7.1 `.mbti` 接口契约
- 运行 `moon info` 会自动在包目录下生成 `.mbti` 文件，用于正式描述对外暴露的函数签名与类型结构；
- 每次重构后，通过 `git diff *.mbti` 检查对外公共 API 是否发生非预期破坏，确保语义化版本兼容性。

---

## 8. 代码生命周期与废弃策略 (Deprecation)

- 废弃的旧函数统一标注 `#deprecated` 属性，编译器会自动产生警告并在 IDE 中显示删除线提示；
- 废弃实现应统一收归在当前包目录下的 `deprecated.mbt` 文件中，避免污染主业务文件。
