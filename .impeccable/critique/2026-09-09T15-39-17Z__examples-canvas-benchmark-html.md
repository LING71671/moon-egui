---
target: examples/canvas/benchmark.html
total_score: 24
max_score: 40
na_heuristics: 
p0_count: 1
p1_count: 2
target_identity: "file:A:\\moonbit-project\\examples\\canvas\\benchmark.html"
target_fingerprint: "sha256:929d80a39d81153c7d87e0d8619ca77b66945967db55770c415d3d1a6d8eda08"
target_path: "A:\\moonbit-project\\examples\\canvas\\benchmark.html"
timestamp: 2026-09-09T15-39-17Z
slug: examples-canvas-benchmark-html
---
# Impeccable Design Critique: moon-egui Canvas Benchmark Studio

Target: `examples/canvas/benchmark.html`
Date: 2026-09-09

## Design Health Score (Nielsen's 10 Usability Heuristics)

| # | Heuristic | Score (0-4) | Key Finding / Issue |
|---|-----------|-------------|---------------------|
| 1 | Visibility of System Status | 3/4 | 遥测数据实时展示 (FPS、内核耗时、指令数)，但缺乏画布加载态与帧丢失预警反馈 |
| 2 | Match System & Real World | 3/4 | CAD 标尺与坐标系映射符合图形软件直觉，但部分英文专业词汇混杂干扰中文用户认知 |
| 3 | User Control and Freedom | 2/4 | 视角缩放过浅或过深时缺乏平滑恢复机制，且缺少一键重置当前交互状态的撤销手段 |
| 4 | Consistency and Standards | 2/4 | 界面控制栏与 Canvas 内部逻辑存在多套并行的状态切换入口，语义层级不一致 |
| 5 | Error Prevention | 3/4 | 缩放比例设有 0.004~4.0 边界保护，但滚轮在极端倍率下容易触发越界抖动 |
| 6 | Recognition Rather Than Recall | 2/4 | 模式切换按钮缺乏明确的高亮持久态，用户难以从界面一眼看出当前处于何种视图模式 |
| 7 | Flexibility and Efficiency | 3/4 | 支持滚轮缩放与鼠标拖拽平移，但缺乏常用键盘快捷键加速器 (如 Space+Drag 漫游、F 聚焦) |
| 8 | Aesthetic & Minimalist Design | 2/4 | 界面文字噪音严重，包含双语混排括号与重度黑色卡片容器，视觉层级过于嘈杂 |
| 9 | Error Recovery | 2/4 | 脚本编译异常或加载失败时，Canvas 呈现静止白板，无任何友好的恢复指引或重试按钮 |
| 10 | Help and Documentation | 2/4 | 画布底部仅有一行单薄的静态快捷键提示，缺乏针对百万节点操作的交互引导 |
| **总分** | | **24/40** | **Acceptable (及格 - 亟需去噪与交互重构)** |

## Design Specificity Verdict

- **LLM Assessment**: 该界面核心技术实力雄厚 (MoonBit + Wasm/JS 超大规模节点渲染)，但现有前端呈现缺乏成熟工业级工具的克制感。大量双语混排标签、卡片嵌套卡片、以及过于显眼的遥测监控卡片，让页面更像一个临时原型调试器，而非一款充满 Swiss 精密美学的高性能渲染引擎展示台。
- **Deterministic Scan (`detect.mjs`)**:
  - `overused-font`: 在 `benchmark.html` 中过度依赖 `Inter` 字体，缺乏体现 MoonBit 现代工程质感与排版层次的字体系统。
  - 界面中残留竞争对手与自夸标签，干扰了产品本身的专注度。

## Overall Impression
技术内核极其惊艳 (千万级点位空间索引与亚毫秒级计算)，但外层 UI 过于嘈杂混乱，且在全景缩放时由于 Canvas2D 未进行批处理合并与频繁的 CSS 字体/颜色字符串解析，导致主线程发生掉帧（不足 60 FPS）。

## What's Working
1. **CAD 精密标尺投影**: 选中物体时的十字投影尺标与动态尺寸标识具备极佳的工程专业感。
2. **直观的几何拾取交互**: 鼠标点击咖啡杯后的四角圆形控制柄与底座发光光晕提供了清晰的操作反馈。

## Priority Issues
1. **[P0] 渲染性能掉帧 (<60 FPS) 与编译阻断**:
   - 原因: `main.mbt` 存在语法错误阻断了 `moon build`，同时 `run.js` 中每帧对 2,000+ 指令进行无缓存 `ctx.font` 设置与高频字符串拼接，引发浏览器 CSS 解析抖动与光栅化瓶颈。
   - 修复: 修复 MoonBit 编译；在 `run.js` 中实施同色路径合并 (Path Batching) 与字体/颜色解析缓存；优化全景 LOD 步长。
2. **[P1] 文字噪音严重与双语混排夹杂**:
   - 原因: 按钮中充斥 `[漫游] (move)`、`[拖拽] (drag)` 等双重标注，版面拥挤刺眼。
   - 修复: 默认界面彻底回归 100% 纯净中文，右上角提供单一优雅的语言切换开关 (`[EN]` / `[中]`)。
3. **[P1] 交互控制分散混乱**:
   - 原因: 外部卡片、顶部工具条、浮动控制器功能重叠，用户不知道在哪里操作。
   - 修复: 收敛为顶部单一一体化 Studio 控制栏（分段控制器：视图模式、交互模式、缩放控制、极简遥测胶囊）。

## Persona Red Flags
- **Alex (硬核工程师/极客)**: 打开全景测试时 FPS 跌至 20-30 帧，认为渲染引擎存在性能虚标，失去进一步探究的耐心。
- **Jordan (首次访问者)**: 看到一堆重叠的卡片、指标与双语标签，完全不知道先点哪里，容易产生认知超载而直接离开。

## Questions to Consider
1. 能否将所有操作收敛到顶部仅 44px 高度的极简分段控制器中？
2. 在全景视图（缩放比例极小时），是否可以用纯色微点合并绘制，把 2000 次 draw call 骤降至 4 次？
