---
target: examples/canvas
total_score: 29
max_score: 40
na_heuristics: 
p0_count: 1
p1_count: 1
target_identity: "file:A:\\moonbit-project\\examples\\canvas"
timestamp: 2026-09-10T01-45-56Z
slug: examples-canvas
---
### Design Health Score

| # | Heuristic | Score | Key Issue |
|---|-----------|-------|-----------|
| 1 | Visibility of System Status | 3 | Real-time FPS, kernel time, and active node counts are live, but canvas LOD transition lacks subtle progress indication |
| 2 | Match System / Real World | 3 | CAD coordinate rulers and grid aisles match technical canvas conventions, but dark-mode styling conflicted with user's light-mode expectations |
| 3 | User Control and Freedom | 4 | Pan, zoom, center, fit-view, 100%, and drag mode affordances provide complete spatial freedom |
| 4 | Consistency and Standards | 2 | Severe visual dissonance between clean white homepage (`index.html`) and dark obsidian laboratory (`benchmark.html`) |
| 5 | Error Prevention | 3 | Bounds checking prevents camera from getting lost in infinite void; mode transitions are constrained |
| 6 | Recognition Rather Than Recall | 3 | Mode buttons and coordinates are always visible, though keyboard accelerators currently lack visible tooltips |
| 7 | Flexibility and Efficiency | 3 | Quick camera presets (Fit, Center, 1:1) and multi-scale selectors (128² to 1024²) offer fast navigation, but hotkeys are missing |
| 8 | Aesthetic and Minimalist Design | 2 | Dark-mode canvas with excessive contrast and overused fonts (`Inter`, `Plus Jakarta Sans`) dilutes MoonBit brand character |
| 9 | Error Recovery | 3 | Safe zoom and pan clamps prevent broken canvas states; resetting camera is a single click away |
| 10 | Help and Documentation | 3 | Footer shortcut pill provides essential gestures, with direct navigation link back to homepage |
| **Total** | | **29/40** | **Good** |

### Design Specificity Verdict

- **LLM assessment**: The MoonBit mascot logo (the magenta rabbit with `<>` visor) is an exceptional, highly specific brand asset with immense personality. However, placing it inside a generic dark-obsidian sci-fi container made it look like an off-the-shelf AI demo rather than the flagship GUI showcase of a world-class programming language. Moving to a crisp, high-craft **Studio Light Palette (浅色工作室级工程画板)** elevates the mascot, creating clean visual harmony with the MoonBit compiler tooling.
- **Deterministic scan**: `detect.mjs` detected 5 findings:
  - `overused-font`: `Inter` in `index.html` (lines 9, 32) and `Plus Jakarta Sans` in `benchmark.html` (lines 9, 37) — ubiquitous AI-cliche fonts that strip personality.
  - `dark-glow`: Colored box-shadow glow (`#2563eb`) on dark background in `index.html` (line 243).
- **Visual inspection**: The light theme in `index.html` is clean, welcoming, and legible, while `benchmark.html` was previously trapped in dark mode with dark rulers and dark background cells, creating a jarring, disorienting experience.

### Overall Impression

The core technical capability of `moon-egui` is extraordinary—rendering 1.05 million nodes at 160+ FPS in MoonBit WebAssembly is breathtaking. But the visual presentation suffered from a split personality: a bright modern homepage connected to a dark, gloomy benchmark room. Unifying the entire experience into a cohesive, radiant, professional **Studio Light CAD environment** will transform this from a technical experiment into an inspiring, production-grade product experience.

### What's Working

1. **Pixel-Perfect MoonBit Mascot Identity**: Transforming the 100-block abstract wall into the authentic MoonBit official logo matrix (128² / 256² / 512² / 1024²) instantly injects identity, delight, and technical credibility.
2. **Infinite Canvas Navigation & Telemetry**: Pan/zoom physics, dynamic water ripple pulses, magnetic repulsion, and truthful `performance.now()` telemetry provide an immediate, tangible sense of power.
3. **Engineering Affordances**: Millimeter-accurate CAD coordinate rulers and selected node bounding boxes with corner resize handles make this feel like a professional vector design tool.

### Priority Issues

#### [P0] 全站色彩断层：官网浅色 vs 实验室深色导致视觉割裂
- **Why it matters**: 用户从纯白清爽的官网进入深黑曜石实验室，产生强烈的视觉刺眼感与风格断层。用户明确提出“都说了不要这种配色，要浅色”，说明深色在当前工程语境下严重不符预期。
- **Fix**: 彻底移除 `benchmark.html` 中的深色变量，全面重构成 **Studio Light (浅色极简画板)**：画板背景改为 `#f8fafc`，非 logo 节点为 `#ffffff` 与 `#f1f5f9` 棋盘格，标尺为纯白底配灰黑刻度，浮动控制栏为磨砂玻璃浅色质感。
- **Suggested command**: `/impeccable colorize examples/canvas`

#### [P1] 机械化探测器告警：滥用通用 AI 字体与高饱和辉光
- **Why it matters**: `detect.mjs` 检测出 `Inter` 与 `Plus Jakarta Sans` 属于过度滥用的“AI 模版字体”，同时官网存在蓝色发光阴影 (`dark-glow`)，让技术极度硬核的 MoonBit 项目看起来像普通的开源玩具模版。
- **Fix**: 引入具有工程师严谨美感与高辨识度的字体组合，如用 `Outfit` 作为标题、`JetBrains Mono` 作为代码与标尺刻度，替换滥用字体，并将彩色外发光改为真实物理环境的漫反射阴影。
- **Suggested command**: `/impeccable typeset examples/canvas`

#### [P2] 实验室控制栏信息密度过载（14个控件平铺）
- **Why it matters**: 认知负荷法则指出单一决策点不应超过 4 项。目前顶部导航栏将尺寸切换（4个）、物理模式（2个）、交互模式（2个）、视角切换（3个）、遥测与语言并列，在中等屏幕下极易拥挤换行。
- **Fix**: 将“视角控制”（居中/适应/100%）与“物理动效”（脉冲/排斥）整合为轻量浮动子工具组，保持主控制栏核心聚焦于尺寸（128² ~ 1024²）与性能指标。
- **Suggested command**: `/impeccable layout examples/canvas`

#### [P3] 缺少键盘快捷键与无障碍辅助
- **Why it matters**: 专业工程师与重度用户（Alex）习惯用快捷键操作（如数字键 1-4 切尺寸，F 全屏自适应，C 居中），纯鼠标点击在频繁测试时操作笨拙。
- **Fix**: 添加全局键盘监听（`1-4`, `F`, `C`, `Space`），并在悬浮气泡中清晰提示快捷键。
- **Suggested command**: `/impeccable harden examples/canvas`

### Persona Red Flags

- **Alex (极客/重度用户)**: 想要快速测试 1024² 极限性能时，必须移动鼠标去点顶部细长按钮；缺乏键盘快捷键切换与全屏快捷键；频繁拖拽缩放时希望有平滑动量阻尼。
- **Jordan (初次体验者)**: 从浅色官网点击“百万节点性能压测”跳转后，页面突然全黑，会误以为页面加载失败或崩溃；对 128/256/512/1024 数字缺乏直观概念（不知道 1024² 意味着 105 万个独立像素节点）。
- **Sam (无障碍与对比度依赖者)**: 深色标尺上的灰色细字（`#94a3b8` on `#0f141c`）对比度较低；画布内的节点缺乏键盘 Tab 焦点指示。

### Minor Observations

- 浏览器缺少 `favicon.ico` 导致控制台出现 404 资源请求警告，建议嵌入 SVG 数据图标。
- 移动端窄屏（< 768px）时，顶部控制栏宽度超出视口，建议加入响应式滚动或折叠菜单。

### Questions to Consider

1. 是否应该将 1024² 节点作为“极限压测模式”特意给予高亮视觉勋章，让用户一眼感知到“这是真实计算的 1,048,576 空间节点”？
2. 在浅色工作室画板风格下，是否可以加入像 Figma/Miro 一样的微妙画板阴影与多选框选功能？
