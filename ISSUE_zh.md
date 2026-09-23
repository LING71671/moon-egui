# 技术清单：活跃缺陷与功能特性路线图

<p>
  <a href="ISSUE.md">English</a> · <a href="ISSUE_zh.md">简体中文</a>
</p>

> [!NOTE]
> **已解决缺陷与历史归档**：全部 90 余项已修复的技术缺陷（`BUG-*`、`ARCH-*`、已交付 `FEAT-*` 以及审计修复条目）均已归档至独立文件 **[ISSUE_ARCHIVE.md](ISSUE_ARCHIVE.md)**（[中文归档](ISSUE_ARCHIVE_zh.md)）。
> 本文档专注文档化跟踪**当前活跃缺陷**、**待演进引擎能力**与**里程碑交付矩阵**。

---

# 第一部分：活跃缺陷与代码审查审计 (`bug` / `audit`)


### AUDIT-DOGFOOD-01 (P1) [待处理]: 跑分页面 (`benchmark.html`) 中的原生 HTML/DOM 顶栏违反纯 Canvas 标准
- **代码位置**: [examples/canvas/benchmark.html](file:///a:/moonbit-project/examples/canvas/benchmark.html)
- **状态**: **待处理**。

---


### AUDIT-DOGFOOD-02 (P1) [待处理]: 扫雷游戏 (`minesweeper.html`) 大量模拟 HTML/DOM 顶栏、工具条与 HUD
- **代码位置**: [examples/canvas/minesweeper.html](file:///a:/moonbit-project/examples/canvas/minesweeper.html)
- **状态**: **待处理**。

---

## 14. 用户体验与交互细节 (`ux`)


---

# 第二部分：引擎能力与业务自举路线图 (`feat`)

### FEAT-SHOWCASE-02 (中优先级) [待处理]: 在官方文档中内嵌即时交互式沙箱
- **目标文件**: [examples/canvas/docs.html](file:///a:/moonbit-project/examples/canvas/docs.html)
- **状态**: **待处理**（积压中）。
- **问题描述**:
  文档页面目前仅展示静态 API 文本与代码高亮，缺乏即时内嵌运行的组件沙箱。
- **修复方案**:
  - 为关键组件引入微型嵌入式 Canvas 演示实例，允许开发者在文档内直接与控件交互并实时修改参数查看反馈。

---


### FEAT-SHOWCASE-03 (低优先级) [待处理]: 跑分页面 (`benchmark.html`) 的 Canvas 原生标题栏自举
- **目标文件**: [examples/canvas/benchmark.html](file:///a:/moonbit-project/examples/canvas/benchmark.html)
- **状态**: **待处理**（积压中）。参见 AUDIT-DOGFOOD-01。
- **问题描述**:
  基准跑分页面的顶部控制栏与统计数据条目仍由原生 HTML DOM 标签渲染。
- **修复方案**:
  - 将控制栏迁移到 Canvas 内部绘制，确保整个跑分页面仅存在单一 `<canvas>` 视口。

---


### FEAT-A11Y-01 (P2) [进行中]: 容器与浮动浮层的全量键盘可达性规范
- **目标文件**: [src/core/](file:///a:/moonbit-project/src/core/), [src/widgets/](file:///a:/moonbit-project/src/widgets/), [src/composite/](file:///a:/moonbit-project/src/composite/)
- **状态**: **进行中**（16 个交互表面已落地 15 个）。为输入框、选择框、折叠头、分栏器、表格、树形视图等全量控件补齐焦点与快捷键。

---


### DEBT-TEST-01 (P3) [待处理]: `src/composite` 复合容器的无头白盒测试覆盖率补齐
- **目标文件**: [src/composite/](file:///a:/moonbit-project/src/composite/)
- **状态**: **待处理**（已在逐步推进并集成）。

---


### DEBT-ARCH-01 (P3) [待处理]: 声明 `composite -> widgets` 单向物理依赖边
- **目标文件**: [src/composite/moon.pkg](file:///a:/moonbit-project/src/composite/moon.pkg)
- **状态**: **待处理**。

---


---


## 16. 全量优先级路线图与里程碑矩阵表

| 追踪类别 | 编号 | 标题 | 优先级 | 状态 |
| :--- | :--- | :--- | :--- | :--- |
| **bug** | `BUG-CORE-01` | 分代哈希表持久化存储与失效记录清理 | **P0** | 已解决（阶段 2） |
| **bug** | `BUG-CORE-02` | 零分配整数 ID 派生与栈哈希 | **P0** | 已解决（阶段 2） |
| **bug** | `BUG-INPUT-01` | 次级指针事件（右键）与上下文菜单 | **P1** | 已解决（阶段 1） |
| **bug** | `BUG-INPUT-02` | 事件消费机制（防止代码编辑器中丢失 Tab） | **P1** | 已解决（阶段 1） |
| **bug** | `BUG-INPUT-03` | 全量组件的完整 Tab 焦点导航链 | **P1** | 已解决（阶段 1） |
| **bug** | `BUG-INPUT-04` | 聚焦控件的键盘激活处理器（Space/Enter） | **P1** | 已解决（阶段 1） |
| **bug** | `BUG-INPUT-05` | 触控手势与横向触控板滚轮偏移转发 | **P2** | 已解决（阶段 3） |
| **bug** | `BUG-TEXT-01` | LRU 排版测量缓存与 Unicode 码段度量 | **P1** | 已解决（阶段 3） |
| **bug** | `BUG-TEXT-02` | 原子级代理对导航与字形素簇遍历 | **P1** | 已解决（阶段 3） |
| **bug** | `BUG-TEXT-03` | 富文本中的 CJK 中日韩无空格自动折行 | **P1** | 已解决（阶段 3） |
| **bug** | `BUG-TEXT-04` | Web 运行时的隐藏输入法（IME）组合桥接 | **P1** | 已解决（阶段 3） |
| **bug** | `BUG-WIDGET-01`| 滚动条滑块拖拽交互与轨道分页点击 | **P2** | 已解决（阶段 4） |
| **bug** | `BUG-WIDGET-02`| 滚动区域动态折叠后的内容高度即时收缩 | **P2** | 已解决（阶段 4） |
| **bug** | `BUG-WIDGET-03`| 代码编辑器的二分查找命中测试与视口滚动 | **P2** | 已解决（阶段 4） |
| **bug** | `BUG-WIDGET-04`| 代码编辑器与文本框的拖拽选区高亮与剪贴板 | **P2** | 已解决（阶段 4） |
| **bug** | `BUG-WIDGET-05`| 对话框动态高度测量与模态焦点陷阱 | **P2** | 已解决（阶段 4） |
| **bug** | `BUG-WIDGET-06`| 命令面板高度限制与结果列表垂直滚动 | **P2** | 已解决（阶段 4） |
| **bug** | `BUG-WIDGET-07`| 下拉框视口边界碰撞向上翻转与长列表滚动 | **P2** | 已解决（阶段 4） |
| **bug** | `BUG-WIDGET-08`| 分栏器零尺寸守卫与安全最小像素限制 | **P2** | 已解决（阶段 4） |
| **bug** | `BUG-WIDGET-09`| 工具提示视口边界钳位与通知悬停穿透阻断 | **P2** | 已解决（阶段 4） |
| **bug** | `BUG-WIDGET-10`| 辅助控件设计系统令牌全面规范化 | **P2** | 已解决（阶段 4） |
| **bug** | `BUG-WIDGET-11`| 上下文菜单的多级树状子菜单级联 | **P2** | 已解决（阶段 4） |
| **bug** | `BUG-DRAW-01` | DrawCmd 与 Canvas 后端的线性渐变图元 | **P2** | 已解决（阶段 4） |
| **bug** | `BUG-DRAW-02` | 消除虚拟表格中冗余的单格 Save/Restore 状态开销 | **P3** | 已解决（阶段 4） |
| **bug** | `BUG-DRAW-03` | 文本绘制指令中的字体族与字重元数据 | **P3** | 已解决（阶段 8） |
| **feat** | `FEAT-SHOWCASE-01`| 纯 Canvas 彻底自举的 Gallery Studio 交互工作台 | **P1** | 已解决（阶段 5） |
| **feat** | `FEAT-CORE-02` | 自动折行流式排版 (`horizontal_wrapped`) | **P1** | 已解决（阶段 6） |
| **feat** | `FEAT-CORE-03` | 运行时多主题系统 (`studio_light`, `slate_dark`) | **P2** | 已解决（阶段 6） |
| **feat** | `FEAT-CORE-04` | 即时模式动画物理弹簧与缓动状态机 | **P2** | 已解决（阶段 6） |
| **feat** | `FEAT-SHOWCASE-02`| 官方参考文档内嵌即时交互式组件沙箱 | **P2** | 积压中 |
| **feat** | `FEAT-SHOWCASE-03`| 跑分基准页面的 Canvas 原生顶层工作栏 | **P3** | 积压中 |
| **feat** | `FEAT-CORE-01` | 多视口停靠与二叉树平铺分屏系统 (`DockArea`) | **P3** | 已解决（阶段 7） |
| **feat** | `FEAT-CORE-05` | 即时模式科学工程图表套件 (`plot`, `bar_chart`) | **P3** | 已解决（阶段 7） |
| **arch** | `ARCH-01` | 上帝对象 `UIContext` 领域子引擎模块化 | **P1** | 已解决（阶段 2） |
| **arch** | `ARCH-02` | 泛型键值状态持久化机制 (`Memory` / `IdMap`) | **P1** | 已解决（阶段 1） |
| **arch** | `ARCH-03` | `WidgetStyle` 系统设计令牌与组件样式分层解耦 | **P1** | 已解决（阶段 4） |
| **arch** | `ARCH-04` | 一等公民组件结构体与 Fluent 建造者协议 | **P1** | 已解决（阶段 5） |
| **arch** | `ARCH-05` | `Painter` 绘制抽象解耦局部坐标与全局命令流 | **P2** | 已解决（阶段 3） |
| **arch** | `ARCH-06` | 物理多包层次架构（彻底拆解 59 个源文件的 core 单石） | **P2** | 已解决（阶段 9） |
| **arch** | `ARCH-07` | 演示舞台模块化（拆解 2088 行超长舞台文件） | **P2** | 已解决（阶段 6） |
| **a11y** | `FEAT-A11Y-01` | 复合容器与浮动层的全量键盘无障碍可达性 | **P2** | 进行中（16 个表面已落地 15 个） |
| **test** | `DEBT-TEST-01` | 补齐 `src/composite` 复合容器的无头白盒测试覆盖 | **P3** | 积压中 |
| **arch** | `DEBT-ARCH-01` | 声明 `composite -> widgets` 单向物理依赖边 | **P3** | 积压中 |
| **logic** | `AUDIT-LOGIC-01` | Web 宿主双通道文本摄入导致字符重复键入 | **P0** | 已解决（迭代 1） |
| **logic** | `AUDIT-LOGIC-02` | 焦点脱离 Canvas 时导致按键释放（Key-Up）事件丢失 | **P1** | 已解决（迭代 1） |
| **logic** | `AUDIT-LOGIC-03` | LayerManager 扁平布尔状态导致嵌套前台图层过早退出 | **P2** | 已解决（迭代 1） |
| **robust**| `AUDIT-ROBUST-01`| 物理弹簧模型在极大帧耗时或 NaN 下产生无界循环步进 | **P1** | 已解决（迭代 1） |
| **robust**| `AUDIT-ROBUST-02`| 零号帧初始鼠标位移突变飞跃 | **P2** | 已解决（迭代 1） |
| **robust**| `AUDIT-ROBUST-03`| `Color::lerp` 非有限插值参数导致生成畸变 RGBA | **P2** | 已解决（迭代 1） |
| **perf** | `AUDIT-PERF-01` | 文本度量缓存中的高频堆字符串分配与浮点截断 | **P1** | 已解决（迭代 1） |
| **perf** | `AUDIT-PERF-02` | 节点连线绘制中细碎折线段大量消耗绘制指令 | **P2** | 已解决（迭代 9） |
| **maint** | `AUDIT-MAINT-01` | 组件直接调用语义调色板令牌绕过系统主题机制 | **P1** | 积压中 |
| **maint** | `AUDIT-MAINT-02` | `UIContext` 中遗留的特定控件标识符字段破坏解耦 | **P1** | 已解决（迭代 1） |
| **maint** | `AUDIT-MAINT-03` | `Slider` 滑块中未缩放的尺寸字面量破坏全局缩放不变量 | **P2** | 已解决（迭代 1） |
| **dogfood**| `AUDIT-DOGFOOD-01`| 跑分页面 (`benchmark.html`) 中的原生 HTML/DOM 顶栏 | **P1** | 积压中 |
| **ux** | `AUDIT-UX-01` | 超宽数据表格缺乏水平滚动与表头吸顶固定 | **P2** | 已解决（迭代 3） |
| **ux** | `AUDIT-UX-02` | 定宽数值容器导致数字文字截断与排版抖动 | **P2** | 已解决（迭代 2） |
| **doc** | `AUDIT-DOC-01` | API 参考手册中包含过时方法签名并缺失新组件 | **P2** | 已解决（迭代 3） |
| **doc** | `AUDIT-DOC-02` | 旗舰级 Studio IDE 中展示陈旧的单石 `UIContext` 范例 | **P3** | 已解决（迭代 3） |
| **logic** | `AUDIT-LOGIC-04` | 未配对的 `begin_foreground` 导致无限循环分配与 OOM | **P0** | 已解决（迭代 1） |
| **logic** | `AUDIT-LOGIC-05` | DockArea 分栏器未释放 `active_id` 导致全局鼠标捕获泄露 | **P1** | 已解决（迭代 1） |
| **robust**| `AUDIT-ROBUST-04`| 被极度挤压的 Dock 节点产生负向矩形尺寸算术陷阱 | **P1** | 已解决（迭代 1） |
| **robust**| `AUDIT-ROBUST-05`| Toast 手动关闭时由于索引失效造成位置跳跃 | **P2** | 已解决（迭代 1） |
| **perf** | `AUDIT-PERF-03` | 2D 拾色器饱和度-明度区域产生 70 条网格绘制指令洪峰 | **P2** | 已解决（迭代 2） |
| **maint** | `AUDIT-MAINT-04` | 滚动与 Toast 容器中未缩放的排版字面量与主题令牌 | **P2** | 已解决（迭代 1） |
| **dogfood**| `AUDIT-DOGFOOD-02`| 扫雷游戏 (`minesweeper.html`) 大量模拟 HTML/DOM 顶栏与 HUD | **P1** | 积压中 |
| **ux** | `AUDIT-UX-03` | 单行 `TextEdit` 缺乏横向视口滚动导致光标穿透裁剪 | **P1** | 已解决（迭代 2） |
| **ux** | `AUDIT-UX-04` | `VirtualList` 滚动条滑块不可交互且缺乏键盘焦点导航 | **P2** | 已解决（迭代 2） |
| **ux** | `AUDIT-UX-05` | 拾色器在选中黑、白或灰度色阶时色相被迫重置为 0° | **P2** | 已解决（迭代 2） |
| **ux** | `AUDIT-UX-06` | 未消费的编辑与导航按键泄露至外层容器 | **P2** | 已解决（迭代 2） |
| **doc** | `AUDIT-DOC-03` | SVG 文本基线对齐规范遗漏导致文字纵向偏移 | **P2** | 已解决（迭代 2） |
| **doc** | `AUDIT-DOC-04` | `DrawList::to_mesh` 中未声明的图元丢失（文字、渐变等） | **P3** | 已解决（迭代 2） |
| **robust**| `AUDIT-ROBUST-06`| 科学图表与柱状图采用原始鼠标测试且缺失光标语义 | **P2** | 已解决（迭代 3） |
| **maint** | `AUDIT-MAINT-05` | `Table` 与 `Plot` 中未缩放的度量字面量及不变量破坏 | **P2** | 已解决（迭代 3） |
| **ux** | `AUDIT-UX-07` | 旋钮与分段选择器缺乏按键消费及焦点环 | **P2** | 已解决（迭代 3） |
| **a11y** | `AUDIT-A11Y-02` | Checkbox、Radio 与 Toggle 开关缺失键盘激活能力 | **P1** | 已解决（迭代 4） |
| **maint** | `AUDIT-MAINT-06` | 容器与控件中硬编码的视口边界及未缩放布局字面量 | **P1** | 已解决（迭代 4） |
| **ux** | `AUDIT-UX-08` | `ScrollArea` 滑块点击瞬间跳跃与光标手势缺失 | **P2** | 已解决（迭代 4） |
| **logic** | `AUDIT-LOGIC-06` | DockArea 与 NodeEditor 绕过 Scissor 裁剪与相交隔离 | **P2** | 已解决（迭代 4） |
| **ux** | `AUDIT-UX-09` | 定高 `TreeView` 缺乏垂直滚动、滚轮响应及选区自动滚入 | **P2** | 已解决（迭代 4） |
| **perf** | `AUDIT-PERF-04` | 拾色器 Alpha 滑条离散色带洪峰与进度条 NaN | **P2** | 已解决（迭代 4） |
| **a11y** | `AUDIT-A11Y-03` | Slider 与 Fader 缺乏 Home/End/PageUp/PageDown 范围跳跃 | **P1** | 已解决（迭代 5） |
| **maint** | `AUDIT-MAINT-07` | Dialog、Tooltip 与 Window 中的硬编码视口尺寸及未缩放描边 | **P1** | 已解决（迭代 5） |
| **ux** | `AUDIT-UX-10` | `Splitter` 分栏器缺失键盘 Home/End 极值吸附与把手未缩放 | **P2** | 已解决（迭代 5） |
| **robust**| `AUDIT-ROBUST-07`| Fader、Knob 与 Stepper 对非有限数与 NaN 的敏感性 | **P2** | 已解决（迭代 5） |
| **a11y** | `AUDIT-A11Y-04` | Stepper 步进器范围导航遗漏与未缩放的分隔线描边 | **P2** | 已解决（迭代 5） |
| **perf** | `AUDIT-PERF-05` | WindowManager 窗口批次与过期焦点 ID 的无界增长 | **P2** | 已解决（迭代 5） |
| **maint** | `AUDIT-MAINT-08` | `Tag` 与 `Badge` 中系统性的未缩放字面量 | **P1** | 已解决（迭代 6） |
| **robust**| `AUDIT-ROBUST-08`| `Rating` 评分组件中的非有限数与 NaN 防护 | **P2** | 已解决（迭代 6） |
| **a11y** | `AUDIT-A11Y-05` | `Pagination` 分页器缺失粗粒度快速翻页与未缩放描边 | **P2** | 已解决（迭代 6） |
| **maint** | `AUDIT-MAINT-09` | `Steps` 与 `Breadcrumb` 中的未缩放排版偏移与焦点环度量 | **P2** | 已解决（迭代 6） |
| **robust**| `AUDIT-ROBUST-09`| `Spinner` 动画状态中系统时间戳为 NaN 时的防崩溃保护 | **P2** | 已解决（迭代 7） |
| **a11y** | `AUDIT-A11Y-06` | `SegmentedControl` 分段选择器缺失 `Home`/`End` 范围导航与未缩放描边 | **P2** | 已解决（迭代 7） |
| **maint** | `AUDIT-MAINT-10` | `Toast` 中的静态兜底视口尺寸与未缩放字面量 | **P1** | 已解决（迭代 7） |
| **perf** | `AUDIT-PERF-07` | `NodeEditor` 连线贝塞尔曲线静态细分与原始鼠标命中判定 | **P2** | 已解决（迭代 7） |
| **maint** | `AUDIT-MAINT-11` | `collapsing_header` 与 `tab_bar` 中未缩放的箭头几何与容器边框 | **P1** | 已解决（迭代 8） |
| **a11y** | `AUDIT-A11Y-07` | `collapsing_header` 缺失树状展开键及 `tab_bar` 缺失 `Home`/`End` 快速跳转 | **P2** | 已解决（迭代 8） |
| **robust**| `AUDIT-ROBUST-10`| `VirtualList` 虚拟列表中持久化滚动偏移量为 NaN 的传播扩散 | **P2** | 已解决（迭代 8） |
| **maint** | `AUDIT-MAINT-12` | `RichText` 中行内代码块内边距与链接下划线度量未缩放 | **P2** | 已解决（迭代 8） |
| **maint** | `AUDIT-MAINT-13` | 按钮、复选框、文本框与分栏器系统性未缩放描边与分栏圆点 | **P1** | 已解决（迭代 9） |

