# Moon-EGUI 开源贡献规范指南

<p>
  <a href="CONTRIBUTING.md">English</a> · <a href="CONTRIBUTING_zh.md">简体中文</a>
</p>

非常感谢您对参与建设 `moon-egui` 的兴趣！本文档详细说明了本项目的工程开发流程、代码编写规范、测试标准以及分支协作约定。

---

## 1. 本地开发环境准备

- **MoonBit 官方工具链**：请通过官方统一脚本进行安装：
  ```powershell
  irm https://cli.moonbitlang.com/install/powershell.ps1 | iex
  ```
- **Git 版本控制**：推荐 Git 2.40+
- **代码编辑器**：推荐 VS Code，并安装官方 **MoonBit Extension** 插件以获得精准的代码跳转、悬浮类型提示与行内即时诊断能力。

---

## 2. 编码风格与工程规范

MoonBit 拥有极其独特且清晰的工程范式，提交代码需严格遵守以下标准：

1. **顶层块级分隔符**：所有顶层类型、结构体、枚举、函数及 Trait 实现之间，**必须且只能使用 `///|` 作为标准分隔**。同一个包内各代码块在语义上独立解析。
2. **代码格式化**：在提交任何 Git 变更前，必须运行 `moon fmt` 格式化代码：
   ```bash
   moon fmt
   ```
3. **接口契约维护**：当修改或导出了新的公共 API 时，需运行 `moon info` 生成/刷新 `.mbti` 契约文件：
   ```bash
   moon info
   ```
   仔细检查 `.mbti` 的差异（Diff），确保未意外破坏现有公共 API 兼容性。
4. **命名与可见性**：
   - 类型、结构体与 Trait 使用大驼峰 `PascalCase`（如 `UIContext`, `DrawCmd`）；
   - 函数、方法与局部变量使用蛇形 `snake_case`（如 `button`, `slider_float`）；
   - 内部辅助函数与私有数据结构严禁添加 `pub` 导出。

---

## 3. 低耦合架构设计规范与审查清单

所有新增功能与重构必须严格遵守低耦合、高内聚原则，严禁引入上帝对象或破坏抽象边界：

1. **禁止侵入核心上下文**：严禁向 `UIContext` 添加特定控件的私有持久化字段（如滚动偏移、光标位置、折叠状态等）。跨帧状态必须封装在控件自有的状态结构体中，并通过通用内存子系统进行存取。
2. **样式设计令牌分层**：`WidgetStyle` 仅定义全库通用设计系统变量（排版阶梯、间距阶梯、圆角阶梯与基础控件基准高）。严禁将具体组件的特异尺寸常量平铺至 `WidgetStyle` 中。
3. **独立组件实体与构建器模式**：复合交互组件优先采用独立一等结构体与 Fluent Builder 链式配置（如 `Slider::new(...).step(0.1)`），禁止在 `UIContext` 扩展函数上无节制堆叠超过 5 个参数。
4. **受限绘图接口**：组件绘制严禁假定全局绝对屏幕坐标或裸调全局剪裁栈，必须通过受限的局部坐标与剪裁视口进行安全绘制。
5. **单向物理包依赖**：严格保持单向依赖流，禁止组件层与引擎核心层出现循环依赖，单个目录避免无序堆积。

### 架构合入检查清单 (PR Checklist)

- [ ] **上下文纯洁性**：本 PR 是否向 `UIContext` 添加了任何特定控件的私有字段？（若有，必须重构移出）。
- [ ] **状态自封装**：跨帧持久状态是否封装在组件自身结构体内，通过通用存储系统管理？
- [ ] **设计令牌分层**：`WidgetStyle` 是否保持仅声明系统级通用 Token，未硬编码组件特异尺寸？
- [ ] **API 参数精简**：复杂组件是否声明了结构体与构建器方法，函数参数是否控制在合理范围内？
- [ ] **绘图视口隔离**：绘制逻辑是否避免了裸露的全局绝对坐标运算与全局剪裁栈干涉？
- [ ] **包依赖单向性**：包间依赖是否符合严格单向流动，无循环引用？

---

## 4. 单元测试与验证准则

对于任何核心数学几何、流式排版、视窗交互与状态机流转，必须具备严格的自动化测试覆盖：

- **白盒单元测试 (Whitebox)**：放置在包目录下的 `*_wbtest.mbt` 中，可直接访问私有实现；
- **黑盒集成测试 (Blackbox)**：放置在包目录下的 `*_test.mbt` 中，严格从外部包调用者视角测试公共 API；
- **运行全量测试**：
  ```bash
  moon test
  ```
- **更新测试快照（Snapshots）**：当有意识修改了输出结果时：
  ```bash
  moon test --update
  ```
- 优先采用确定性断言（`assert_eq!`, `assert_true!`），避免在测试中残留调试打印。

---

## 5. Git 提交信息规范与细粒度准则 (Conventional Commits)

本项目严格遵循 [Conventional Commits](https://www.conventionalcommits.org/) 规范与原子化细粒度提交原则：

格式要求：`<type>(<scope>): <简要描述>`

提交核心原则：
- **单一职责与原子化 (Atomic Scope)**：每次提交仅覆盖一个逻辑职责。严禁将内核实现、样式令牌、测试套件、编译产物与文档混杂在单次大提交中。
- **阶段性流水线拆分**：大型任务按逻辑依赖拆分为有序提交链（`feat(core)` 核心图元 -> `style(theme)` 样式令牌 -> `test(core)` 测试用例 -> `build(demo)` 编译产物 -> `docs` 文档与路线图）。
- **控制提交规模 (Size Guardrails)**：保持提交小巧清晰、易于审查与精确回溯（单个提交涉及跨领域文件建议控制在 5-8 个以内）。

标准类型：
- `feat`：新增用户可见的功能或控件套件
- `fix`：修复 Bug 缺陷
- `style`：设计令牌、排版度量或格式整理
- `docs`：文档增补、更新日志或路线图更新
- `test`：新增或重构白盒/黑盒测试用例
- `refactor`：非功能性重构代码
- `perf`：性能调优与零分配优化
- `build`：编译构建脚本、编译目标配置或画板打包产物
- `chore`：依赖配置或工程维护

示例：
- `feat(core): add Plot and BarChart chart widgets`
- `style(theme): normalize widget sizing tokens in WidgetStyle`
- `test(core): add whitebox test suite for PlotPoint`
- `fix(window): correct Z-index focus sorting on pointer down`

---

## 6. 标准贡献工作流

1. Fork 本仓库并 Clone 到本地：
   ```bash
   git clone https://github.com/LING71671/moon-egui.git
   ```
2. 基于最新 `main` 创建特性分支：
   ```bash
   git checkout -b feat/your-feature-name
   ```
3. 参照 `ARCHITECTURE_zh.md` 架构白皮书实现功能；
4. 确保本地所有格式检查、接口更新与测试 100% 通过：
   ```bash
   moon info && moon fmt && moon test
   ```
5. 提交变更并推送至个人远程分支，提交 Pull Request 进行代码评审。
