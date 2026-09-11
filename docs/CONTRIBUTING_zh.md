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

## 3. 单元测试与验证准则

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

## 4. Git 提交信息规范 (Conventional Commits)

本项目严格遵循 [Conventional Commits](https://www.conventionalcommits.org/) 规范：

格式要求：`<type>(<scope>): <简要描述>`

标准类型：
- `feat`：新增用户可见的功能或控件套件
- `fix`：修复 Bug 缺陷
- `docs`：文档增补或设计白皮书更新
- `test`：新增或重构测试用例
- `refactor`：非功能性重构代码
- `perf`：性能调优与零分配优化
- `chore`：构建脚本、依赖配置或工程维护

示例：
- `feat(widget): add SliderFloat and DragValue controls`
- `fix(window): correct Z-index focus sorting on pointer down`
- `test(geom): add AABB boundary intersection edge case tests`

---

## 5. 标准贡献工作流

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
