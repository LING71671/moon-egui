# 技术归档：已解决缺陷与交付功能清册

<p>
  <a href="ISSUE_ARCHIVE.md">English</a> · <a href="ISSUE_ARCHIVE_zh.md">简体中文</a>
</p>

> 本文档完整归档了 `moon-egui` 历史上已修复的 90+ 项核心缺陷、架构重构成果与已交付里程碑。
> 当前活跃缺陷、演进中路线图与待攻坚任务清单，请参阅主文档 **[ISSUE.md](ISSUE.md)**（[中文版](ISSUE_zh.md)）。

---
### BUG-CORE-01 (P0) [已解决]: 持久化状态数组中的无界内存增长与 $O(N)$ 线性查找
- **代码位置**: [src/core/context.mbt#L35-L45](file:///a:/moonbit-project/src/core/context.mbt#L35-L45), [第 725-866 行](file:///a:/moonbit-project/src/core/context.mbt#L725-L866)
- **状态**: **已解决**（阶段 2）。将全部 5 个持久化状态数组重构为 `@hashmap.HashMap[Id, T]`，并通过 `prune_stale_state(ttl_frames)` 实现了世代垃圾回收修剪。
- **问题描述**:
  `UIContext` 跨帧存储控件持久化状态时曾使用线性关联列表：
  - `scroll_offsets : Array[(Id, Double)]`
  - `scroll_content_heights : Array[(Id, Double)]`
  - `window_positions : Array[(Id, @math.Vec2)]`
  - `text_cursor_positions : Array[(Id, Int)]`
  - `open_collapsing_ids : Array[(Id, Bool)]`
- **失效机制**:
  1. 每次状态查找与更新都执行 `for i = 0; i < len; i = i + 1` 线性扫描。
  2. 被销毁、卸载或条件隐藏的控件记录永远不会被释放，条目在整个会话中单调累积。
  3. 在具有动态导航或虚拟化视图的长时间运行应用中，内存消耗无界增长，每帧查找时间退化为 $O(N)$。
- **修复方案**:
  - 将 `Array[(Id, T)]` 替换为哈希表（`@hashmap.HashMap[Id, T]`）或分代槽位映射。
  - 实现基于帧计数器的世代跟踪：在 `end_frame` 期间修剪超过 $K$ 帧未访问 ID 的记录。

---


### BUG-CORE-02 (P0) [已解决]: 位置自增 ID 碰撞与动态渲染下的状态失效
- **代码位置**: [src/core/context.mbt#L307-L308](file:///a:/moonbit-project/src/core/context.mbt#L307-L308)
- **状态**: **已解决**（阶段 2）。实现了 `Id::from_int`、`Id::with_int` 与 `IdStack::derive_int`，使用 64 位 FNV-1a 整数哈希，彻底消除了 `allocate_space` 中的逐帧字符串分配。
- **问题描述**:
  在 `allocate_space` 中，自动派生的标识符依赖于每帧重置的单调计数器：
  ```moonbit
  self.auto_id_counter = self.auto_id_counter + 1
  let id = self.id_stack.derive_id(self.auto_id_counter.to_string())
  ```
- **失效机制**:
  1. 若有任何控件被条件分支展示（`if condition { ui.label(...) }`），所有后续控件的 `auto_id_counter` 都会偏移所分配控件的数量。
  2. 下游控件会错误继承上一帧属于完全无关控件的持久化状态（滚动位置、光标、焦点、折叠状态）。
  3. 每次调用都通过 `to_string()` 在堆上分配新 `String`。在包含 500 个控件且以 60 FPS 运行的界面中，每秒产生 30,000 次瞬态字符串分配。
- **修复方案**:
  - 提供基于整数的 ID 派生方法 `Id::derive_int(seed : UInt64, index : Int) -> Id`，消除逐帧字符串分配。
  - 为所有有状态控件（`TextEdit`、`ScrollArea`、`CollapsingHeader`、`Window`）强制要求调用方提供显式 `id_salt`。

---

## 2. 输入系统与事件调度管线


### BUG-INPUT-01 (P1) [已解决]: 单按键鼠标模型与次级/辅助指针事件（右键/中键）缺失
- **代码位置**: [src/core/input.mbt#L86-L94](file:///a:/moonbit-project/src/core/input.mbt#L86-L94), [src/core/input.mbt#L151-L165](file:///a:/moonbit-project/src/core/input.mbt#L151-L165), [examples/canvas/js/gallery_runner.js#L136-L150](file:///a:/moonbit-project/examples/canvas/js/gallery_runner.js#L136-L150)
- **状态**: **已解决**（阶段 1）。在 `RawInput`/`InputState` 中增加了次级按键跟踪，在 `Response` 中支持了 `secondary_clicked`，并原生对接了右键上下文菜单。
- **问题描述**:
  `RawInput` 与 `InputState` 最初仅支持单一布尔型鼠标按键（`mouse_down : Bool`、`mouse_pressed`、`mouse_released`）。
- **失效机制**:
  1. 次级点击（右键）与辅助点击（中键）无法在引擎中表达。
  2. 右键点击 Web Canvas 会直接触发浏览器原生右键菜单，因为 JS 驱动器未拦截 `contextmenu`。
  3. `ContextMenu` 无法原生响应右键触发，以往只能通过显式的左键按钮触发。
- **修复方案**:
  - 在 `RawInput` 与 `InputState` 中增加 `mouse_secondary_down : Bool` 与 `mouse_middle_down : Bool`。
  - 在 Canvas 驱动中增加带有 `e.preventDefault()` 的 `contextmenu` 事件拦截。
  - 更新 `context_menu_items` 以评估次级点击激活状态。

---


### BUG-INPUT-02 (P1) [已解决]: 全局事件拦截且缺乏控件事件消费机制 (`event.consume()`)
- **代码位置**: [src/core/context.mbt#L160-L182](file:///a:/moonbit-project/src/core/context.mbt#L160-L182), [src/core/code_editor.mbt#L255-L264](file:///a:/moonbit-project/src/core/code_editor.mbt#L255-L264)
- **状态**: **已解决**（阶段 1）。在 `InputState` 上实现了 `consume_key`，集成进 `CodeEditor` 处理 Tab 与 Enter，并在 `UIContext::end_frame` 中进行了消费校验。
- **问题描述**:
  输入系统缺乏在活跃控件处理完事件后将该事件标记为“已消费”的机制。
- **失效机制**:
  1. 在 `CodeEditor` 中按下 `Key::Tab` 会在文档缓冲区插入两个空格。
  2. 但在 `UIContext::end_frame` 阶段，引擎全局评估 `if self.input.key_pressed(Key::Tab)`，强制将焦点移至下一个可聚焦控件。
  3. 用户无法使用 Tab 缩进代码而不意外丢失输入焦点。
- **修复方案**:
  - 在 `InputState` 上实现事件消费机制（如 `self.input.consume_key(Key::Tab)`）。
  - 修改 `end_frame` 焦点遍历逻辑，使其仅对未被消费的 Tab 按键事件作出响应。

---


### BUG-INPUT-03 (P1) [已解决]: 交互控件间的键盘 Tab 焦点链不完整
- **代码位置**: [src/core/button.mbt#L45](file:///a:/moonbit-project/src/core/button.mbt#L45), [src/core/slider.mbt#L23](file:///a:/moonbit-project/src/core/slider.mbt#L23), [src/core/toggle.mbt#L14](file:///a:/moonbit-project/src/core/toggle.mbt#L14), [src/core/containers.mbt#L119](file:///a:/moonbit-project/src/core/containers.mbt#L119)
- **状态**: **已解决**（阶段 1）。将 `button`、`checkbox`、`toggle`、`slider` 与 `combo_box` 统一注册到 Tab 导航环中，并增加了视觉焦点指示环。
- **问题描述**:
  焦点导航子系统最初仅将 `TextEdit` 识别为可聚焦控件。
- **失效机制**:
  1. `Button`、`Checkbox`、`Toggle`、`Slider`、`ComboBox` 与 `TabBar` 等控件未调用 `register_focusable(id)`。
  2. 纯键盘用户无法通过 Tab 键导航到任何非文本控件。
  3. 违反了工程无障碍标准（A11y），使用读屏器或键盘的用户无法操作表单。
- **修复方案**:
  - 在所有交互控件的求值逻辑中调用 `self.register_focusable(id)`。
  - 为每个处于焦点状态的控件绘制符合设计系统的焦点轮廓环（`@color.Color::border_focus()`）。

---


### BUG-INPUT-04 (P1) [已解决]: 获得焦点的交互控件缺乏键盘激活处理器（Space/Enter）
- **代码位置**: [src/core/button.mbt#L40-L55](file:///a:/moonbit-project/src/core/button.mbt#L40-L55), [src/core/toggle.mbt#L15-L35](file:///a:/moonbit-project/src/core/toggle.mbt#L15-L35)
- **状态**: **已解决**（阶段 1）。为按钮和开关添加了 `Key::Space` 与 `Key::Enter` 激活处理，并支持了方向键微调数值。
- **问题描述**:
  控件在获得焦点后，其内部状态机仅对鼠标指针事件求值。
- **失效机制**:
  1. 尽管控件能够获得焦点并绘制焦点环，按下 `Space` 或 `Enter` 键完全无反应。
  2. 滑块（`Slider`）在聚焦时不支持通过 `ArrowLeft` / `ArrowRight` 步进调整数值。
- **修复方案**:
  - 当控件拥有焦点且 `key_pressed(Space)` 或 `key_pressed(Enter)` 触发时，设置 `clicked = true`。
  - 在 `Slider` 处于焦点状态时，响应左右方向键以步进值调整绑定数值。

---


### BUG-INPUT-05 (P2) [已解决]: 水平滚轮偏移与触控板手势传递缺失
- **代码位置**: [src/core/input.mbt#L42](file:///a:/moonbit-project/src/core/input.mbt#L42), [examples/canvas/js/gallery_runner.js#L140-L150](file:///a:/moonbit-project/examples/canvas/js/gallery_runner.js#L140-L150)
- **状态**: **已解决**（阶段 3）。在 `RawInput` 与 `InputState` 中增加了 `scroll_delta : @math.Vec2`，并升级了触摸指针驱动。
- **问题描述**:
  滚轮偏移曾被硬编码为标量 `mouse_wheel_delta : Double`，仅能表示垂直方向的滚动。
- **失效机制**:
  1. 触控板的双指水平平移或水平滚轮鼠标的横向滚动被完全丢弃。
  2. 宽表格（`Table`）或横向滚动视口无法响应触控手势。
- **修复方案**:
  - 将滚轮偏移升级为二维向量 `scroll_delta : @math.Vec2`。
  - 在 Web 驱动层中捕获 `wheel` 事件的 `e.deltaX` 与 `e.deltaY`。

---

## 3. 排版引擎、文本测量与国际化


### BUG-TEXT-01 (P1) [已解决]: 硬编码 ASCII 字符比例表与固定 CJK 乘数
- **代码位置**: [src/core/context.mbt#L450-L480](file:///a:/moonbit-project/src/core/context.mbt#L450-L480)
- **状态**: **已解决**（阶段 3）。引入了带有 Unicode 码段感知的 LRU 文本度量缓存，支持等宽与变宽字体的真实宽度查找。
- **问题描述**:
  文本测量函数曾依赖静态启发式公式计算字符串宽度（如假定 ASCII 字符宽度恒为 `0.55 * font_size`，中文字符宽度恒为 `1.05 * font_size`）。
- **失效机制**:
  1. 实际字体渲染受操作系统抗锯齿、字符微调（Kerning）及字体族度量影响，计算宽度与实际像素产生严重漂移。
  2. 在 `TextEdit` 与 `CodeEditor` 中导致光标定位偏离多达几个字符，文本换行提前切断或溢出视口。
- **修复方案**:
  - 引入字符度量查找表与 LRU 度量缓存。
  - 在 Web 宿主驱动中通过 `CanvasRenderingContext2D.measureText` 标定实际基准指标。

---


### BUG-TEXT-02 (P1) [已解决]: 直接切片 UTF-16 代码单元损坏代理对与字形素簇 (Graphemes)
- **代码位置**: [src/core/text_edit.mbt#L120-L145](file:///a:/moonbit-project/src/core/text_edit.mbt#L120-L145)
- **状态**: **已解决**（阶段 3）。实现了代理对感知光标步进与 Unicode 标量遍历，防止跨代码单元直接撕裂字符。
- **问题描述**:
  `TextEdit` 中的光标导航和文本切片基于原始 `String` 的下标索引操作。
- **失效机制**:
  1. 表情符号（Emoji）或生僻字占用 2 个 UTF-16 代码单元（Surrogate Pairs）。
  2. 单击或方向键将光标移动到代理对中间时，字符串切片会产生无效的代码单元（孤立高/低代理项），引发运行时异常或显示乱码 ``。
- **修复方案**:
  - 基于 Unicode 标量和字形簇边界安全推进光标。
  - 遇到代理对时原子性跳跃 2 个代码单元。

---


### BUG-TEXT-03 (P1) [已解决]: `RichText` 中的折行排版对非空格分词文本（中日韩 CJK）失效
- **代码位置**: [src/composite/rich_text.mbt#L50-L90](file:///a:/moonbit-project/src/composite/rich_text.mbt#L50-L90)
- **状态**: **已解决**（阶段 3）。实现了基于 Unicode 字符属性的双模折行引擎，非空格 CJK 字符可在任意边界安全断行。
- **问题描述**:
  `RichText` 的自动换行逻辑曾严格依赖空格字符 `' '` 作为单词边界进行分割。
- **失效机制**:
  1. 中文、日文等东亚无空格分词语言的完整段落被当成单个单词处理。
  2. 整段中文文本完全不发生折行，直接横向穿透容器边界被裁切。
- **修复方案**:
  - 实现双模折行算法：遇到拉丁词汇按词边界断行，遇到 CJK 字符则允许在任意字边界断行。

---


### BUG-TEXT-04 (P1) [已解决]: Web 运行时缺乏浏览器原生 IME 输入法组合桥接
- **代码位置**: [examples/canvas/js/gallery_runner.js#L80-L120](file:///a:/moonbit-project/examples/canvas/js/gallery_runner.js#L80-L120)
- **状态**: **已解决**（阶段 3）。在宿主中集成了隐藏的透明 textarea 输入框，完美捕获 `compositionstart` / `compositionend` 事件并将合成文本注入引擎。
- **问题描述**:
  Canvas 驱动仅监听了浏览器的 `keydown` 事件以获取单字符输入。
- **失效机制**:
  1. 中文拼音、日文假名等输入法在合成过程中无法捕获多字符选词，Canvas 无法输入非 ASCII 字符。
- **修复方案**:
  - 在 Canvas 背后维护一个隐藏的、跟随当前焦点控件光标移动的透明 `textarea`。
  - 监听 `compositionend` 事件，将完成组合的文字流作为字符串事件传递给 `RawInput`。

---

## 4. 控件边缘情况与行为缺陷


### BUG-WIDGET-01 (P2) [已解决]: `ScrollArea` 滚动条滑块不可交互（不可拖拽）
- **代码位置**: [src/core/containers.mbt#L210-L245](file:///a:/moonbit-project/src/core/containers.mbt#L210-L245)
- **状态**: **已解决**（阶段 4）。为垂直与水平滚动条滑块实现了指针捕获、拖拽位移比例映射及轨道点击分页跳转。
- **问题描述**:
  `ScrollArea` 的滚动条仅作为被动状态指示器渲染，无法用鼠标直接拖拽。
- **失效机制**:
  1. 用户尝试用鼠标按住滑块拖拽页面时无任何反应。
- **修复方案**:
  - 为滑块计算相交边界并注册交互响应。
  - 在拖拽状态下根据指针位移增量计算滚动偏移量并同步至持久化存储中。

---


### BUG-WIDGET-02 (P2) [已解决]: `ScrollArea` 内容高度存在单帧延迟导致动态折叠滞后
- **代码位置**: [src/core/containers.mbt#L190-L205](file:///a:/moonbit-project/src/core/containers.mbt#L190-L205)
- **状态**: **已解决**（阶段 4）。引入了预检和当帧内容边界钳位机制，折叠时立即平滑收缩滚动范围。
- **问题描述**:
  `ScrollArea` 的可用内容高度是在子元素布局完成后记录的，导致滚动范围的更新相比实际内容渲染滞后了一帧。
- **失效机制**:
  1. 当内部展开的折叠面板关闭时，滚动条在当前帧仍保持过长状态，滚动到底部时露出大片空白区域。
- **修复方案**:
  - 在当帧结束时立即用更新后的内容高度钳位当前帧的 `scroll_offset`，防止越界。

---


### BUG-WIDGET-03 (P2) [已解决]: `CodeEditor` 缺乏滚动与选区，且每帧重复解析行两次
- **代码位置**: [src/core/code_editor.mbt#L80-L160](file:///a:/moonbit-project/src/core/code_editor.mbt#L80-L160)
- **状态**: **已解决**（阶段 4）。引入了二分查找点击命中测试、双向视口滚动集成以及单遍标记缓存。
- **问题描述**:
  `CodeEditor` 每帧对整个源码字符串进行两次行拆分与高亮解析，且不支持视口滚动和文本范围选中。
- **失效机制**:
  1. 超过视口高度的代码行被直接裁切，用户无法编辑下方代码。
  2. 源码超过 100 行时，每帧重复文本分割导致明显的 CPU 掉帧。
- **修复方案**:
  - 缓存行偏移表，利用二分查找计算鼠标点击的行号与列号。
  - 将 `CodeEditor` 内部嵌套入可滚动的视口体系中，实现可见行裁剪渲染。

---


### BUG-WIDGET-04 (P2) [已解决]: `TextEdit` 与 `CodeEditor` 缺乏选区、剪贴板与历史撤销缓冲区
- **代码位置**: [src/core/text_edit.mbt#L60-L180](file:///a:/moonbit-project/src/core/text_edit.mbt#L60-L180), [src/core/code_editor.mbt#L180-L240](file:///a:/moonbit-project/src/core/code_editor.mbt#L180-L240)
- **状态**: **已解决**（阶段 4）。支持了鼠标拖拽高亮选区、Shift+方向键选中、Ctrl+A 全选及复制/剪切/粘贴协议。
- **问题描述**:
  文本编辑控件仅维护了单一的整数插入光标位置（`cursor_pos`），无选区范围概念。
- **失效机制**:
  1. 用户无法选中一段文本进行批量删除、替换或复制。
- **修复方案**:
  - 引入 `selection_start` 与 `selection_end`。
  - 在绘制时计算选中字符的高亮矩形背景，并在按键删除或字符键入时批量替换选区区间。

---


### BUG-WIDGET-05 (P2) [已解决]: `Dialog` 缺乏焦点陷阱与动态文本高度测量限制
- **代码位置**: [src/core/dialog.mbt#L40-L110](file:///a:/moonbit-project/src/core/dialog.mbt#L40-L110)
- **状态**: **已解决**（阶段 4）。实现了模态对话框焦点环锁定（Focus Trap）、背景遮罩点击拦截以及基于内容的动态高度自适应度量。
- **问题描述**:
  模态对话框弹窗打开时，Tab 键焦点仍会穿透到对话框下方的背景控件中，且卡片高度被固定为字面量常量。
- **失效机制**:
  1. 用户按下 Tab 键可以在不可见的背景按钮上触发操作，破坏模态安全性。
  2. 长消息正文在固定高度下发生文字重叠或溢出。
- **修复方案**:
  - 在模态打开期间接管 Tab 焦点环，只在确认/取消按钮之间循环跳转。
  - 动态计算正文排版高度并根据内容自适应展开卡片。

---


### BUG-WIDGET-06 (P2) [已解决]: `CommandPalette` 缺乏高度限制与垂直视口滚动
- **代码位置**: [src/composite/command_palette.mbt#L40-L120](file:///a:/moonbit-project/src/composite/command_palette.mbt#L40-L120)
- **状态**: **已解决**（阶段 4）。对候选结果列表设置最大可视高度，超过阈值时启用虚拟裁剪滚动，且支持上下键选中项自动滚入可视区。
- **问题描述**:
  命令面板候选条目较多时，面板卡片无限向下延伸，直接穿透屏幕底端。
- **失效机制**:
  1. 屏幕外的候选命令无法被看见和点击。
- **修复方案**:
  - 增加 `max_visible_items`，对结果列表施加 `ScrollArea` 或裁剪渲染，并保证选中的候选项始终在可视区内。

---


### BUG-WIDGET-07 (P2) [已解决]: `ComboBox` 缺乏视口边界碰撞向上翻转与长列表滚动
- **代码位置**: [src/core/combo_box.mbt#L50-L130](file:///a:/moonbit-project/src/core/combo_box.mbt#L50-L130)
- **状态**: **已解决**（阶段 4）。实现了下拉菜单边界碰撞检测：当屏幕下方空间不足时自动向上翻转弹出，且支持长列表内嵌滚动。
- **问题描述**:
  下拉选择框弹出层盲目向下方展开固定高度。
- **失效机制**:
  1. 位于页面底部的下拉框展开时超出屏幕边界，用户无法选择底部的选项。
- **修复方案**:
  - 检测 `popup_rect.y + popup_rect.h > screen_h`，若空间不足则将弹出层锚定在输入框上方展开。

---


### BUG-WIDGET-08 (P2) [已解决]: `Splitter` 零尺寸除零错误与比例约束倒置
- **代码位置**: [src/core/splitter.mbt#L40-L90](file:///a:/moonbit-project/src/core/splitter.mbt#L40-L90)
- **状态**: **已解决**（阶段 4）。添加了容器可用宽高有效性守卫、除以零防范以及分栏比例在 `[min_px, total - min_px]` 的严格钳位。
- **问题描述**:
  分栏器在容器宽度被压缩为 0 或极小像素时直接按比例除以总宽度。
- **失效机制**:
  1. 产生 `NaN` 或无穷大浮点数，破坏下游布局甚至导致浏览器渲染管线异常。
- **修复方案**:
  - 在计算分栏比例前校验容器尺寸，若小于安全阈值则回退到安全默认比例。

---


### BUG-WIDGET-09 (P2) [已解决]: `Tooltip` 视口边界溢出与 `Toast` 鼠标悬浮阻挡穿透
- **代码位置**: [src/core/tooltip.mbt#L30-L70](file:///a:/moonbit-project/src/core/tooltip.mbt#L30-L70), [src/core/toast.mbt#L40-L90](file:///a:/moonbit-project/src/core/toast.mbt#L40-L90)
- **状态**: **已解决**（阶段 4）。为工具提示增加了四向视口边界安全钳位；为 Toast 通知增加了悬停遮挡拦截，避免意外触发背景元素。
- **问题描述**:
  鼠标悬停在屏幕边缘控件时，工具提示气泡直接渲染到屏幕外部；Toast 浮动层下方的背景按钮仍能接收悬停响应。
- **失效机制**:
  1. 提示气泡文字被截断无法阅读。
  2. 用户移动鼠标到 Toast 上时误触发了底层被遮挡按钮的高亮效果。
- **修复方案**:
  - 工具提示根据屏幕边缘动态将坐标偏移到可见区域内。
  - Toast 通知在显示区域显式调用 `block_hover(rect)`。

---


### BUG-WIDGET-10 (P2) [已解决]: 辅助控件中残留的魔数与硬编码布局字面量
- **代码位置**: [src/core/badge.mbt](file:///a:/moonbit-project/src/core/badge.mbt), [src/core/tag.mbt](file:///a:/moonbit-project/src/core/tag.mbt), [src/core/steps.mbt](file:///a:/moonbit-project/src/core/steps.mbt)
- **状态**: **已解决**（阶段 4）。将所有散落的颜色、间距、字体尺寸规范化并接入 `@color.Color` 与 `WidgetStyle` 设计系统令牌。
- **问题描述**:
  部分小组件内存在内联颜色硬编码和像素魔数。
- **失效机制**:
  1. 切换主题或调整全局缩放比例时，这些组件的外观与系统整体设计语言脱节，显示比例失调。
- **修复方案**:
  - 全部替换为设计系统语义令牌。

---


### BUG-WIDGET-11 (P2) [已解决]: `ContextMenu` 缺乏多级子菜单级联支持
- **代码位置**: [src/core/context_menu.mbt#L60-L150](file:///a:/moonbit-project/src/core/context_menu.mbt#L60-L150)
- **状态**: **已解决**（阶段 4）。支持了具有悬停延迟、递归图层投影与边界自适应对齐的树状级联子菜单。
- **问题描述**:
  右键菜单仅支持单一平铺的条目列表，不支持子菜单嵌套。
- **失效机制**:
  1. 无法实现现代桌面 IDE 常见的复杂分组上下文菜单（如“重构 -> 提取函数”）。
- **修复方案**:
  - 在菜单模型中支持 `Submenu(String, Array[MenuItem])`，并在当前项悬停时递归渲染子菜单浮层。

---

## 5. 绘制命令与渲染后端


### BUG-DRAW-01 (P2) [已解决]: `DrawCmd` 中缺乏渐变、图像、纹理和多边形几何图元
- **代码位置**: [src/draw/draw_cmd.mbt#L20-L65](file:///a:/moonbit-project/src/draw/draw_cmd.mbt#L20-L65), [examples/canvas/js/gallery_runner.js#L200-L250](file:///a:/moonbit-project/examples/canvas/js/gallery_runner.js#L200-L250)
- **状态**: **已解决**（阶段 4）。在 `DrawCmd` 中引入了 `LinearGradient` 等图形基元，并在 Canvas 2D 宿主中完成了高效绘制映射。
- **问题描述**:
  `DrawCmd` 最初仅支持纯色矩形、描边矩形、圆和直线。
- **失效机制**:
  1. 颜色拾取器的饱和度/明度谱系不得不通过数十个微小纯色网格拼凑，造成绘制指令洪峰。
- **修复方案**:
  - 增加线性渐变指令及参数定义，并在后端驱动中直接调用 Canvas 原生渐变接口。

---


### BUG-DRAW-02 (P3) [已解决]: 单单元格 Scissor 裁剪导致沉重的 Canvas save/restore 上下文开销
- **代码位置**: [examples/canvas/js/gallery_runner.js#L230-L270](file:///a:/moonbit-project/examples/canvas/js/gallery_runner.js#L230-L270)
- **状态**: **已解决**（阶段 4）。消除了多余的每格裁剪，仅在视口边界层级变更时执行画布状态保存与恢复。
- **问题描述**:
  虚拟表格在渲染每一行每一个单元格时均无条件执行一次 `ctx.save()`、`ctx.clip()` 和 `ctx.restore()`。
- **失效机制**:
  1. 浏览器每秒执行数千次上下文状态切换，造成严重的 Canvas 2D 性能管线停顿与垃圾回收。
- **修复方案**:
  - 优化 Scissor 栈，将裁剪边界提升到外层容器级别，避免对内部各单元格进行无意义的重复裁剪。

---


### BUG-DRAW-03 (P3) [已解决]: `DrawCmd::Text` 缺乏字体族、字重元数据与高保真渲染标签
- **代码位置**: [src/draw/draw_cmd.mbt#L30](file:///a:/moonbit-project/src/draw/draw_cmd.mbt#L30)
- **状态**: **已解决**（阶段 8）。为 `DrawCmd::Text` 扩展了可选字体族 `font_family : String?` 与字重 `font_weight : Int`，支持粗体、代码等宽体及标题字重无缝切换。
- **问题描述**:
  绘制文本指令仅携带文字内容、坐标与字号，无法指定粗体（Bold）或等宽字体（Monospace）。
- **失效机制**:
  1. 代码编辑器的关键字高亮无法渲染粗体，界面标题与正文无法在视觉权重上形成分级。
- **修复方案**:
  - 在 `DrawCmd::Text` 中加入字体族和字重字段并在宿主正确拼接 CSS 字体描述串。


# 第二部分：引擎能力与真实业务自举路线图 (`feat`)

本节阐述高价值架构特性，以及在演示与运行时页面中用 `moon-egui` 原生 Canvas 渲染彻底替换原始 HTML/DOM 的业务自举（Dogfooding）行动。

---

## 6. 演示与展示页面自举行动 (`feat`)


### FEAT-SHOWCASE-01 (高优先级) [已解决]: `gallery.html` 纯 Canvas 自举工作台 ("Pure Canvas Studio")
- **目标文件**: [examples/canvas/gallery.html](file:///a:/moonbit-project/examples/canvas/gallery.html), [examples/canvas/gallery_stage.mbt](file:///a:/moonbit-project/examples/canvas/gallery_stage.mbt)
- **状态**: **已解决**（阶段 5）。将 `gallery_stage.mbt` 重构为完全自举的 Studio 工作台：
  1. Canvas 内建顶层标题栏，包含组件元数据、函数签名、视图模式切换与主题选择器（`studio_light`、`slate_dark`、`high_contrast`）。
  2. 交互式可拖拽分栏幕布（`split_horizontal`），左侧为交互预览，右侧为带有行号的只读 `code_editor`。
  3. 3 种视图预设（100% UI、50/50 分屏、100% 代码），在 MoonBit 与 Web 宿主之间保持同步。
  4. 底部状态栏显示遥测数据与交互响应日志。
- **问题描述**:
  旧版 `gallery.html` 依赖外部 HTML/DOM 的 `<aside>` 侧边栏和 DOM 按钮，未能展现即时模式 GUI 引擎完全接管工作区界面的实力。
- **失效机制**:
  1. 违反了纯 MoonBit 引擎全流程自举与零 DOM 模拟规范。
- **修复方案**:
  - 用纯 MoonBit 在单个 `<canvas>` 上重写全部工作台界面，废弃外部 HTML 侧边栏与控制按钮。

---


### FEAT-SHOWCASE-04 (低优先级) [已解决]: 音频工程工作站示范案例 (`AudioSynthesizerStage`)
- **目标文件**: [examples/canvas/gallery_stage.mbt](file:///a:/moonbit-project/examples/canvas/gallery_stage.mbt)
- **状态**: **已解决**（阶段 7）。实现了包含真实音量衰减推子（`fader`）、立体声电平表、旋钮微调（`knob`）及参数遥测折线图的专业音频混音合成台。

---


### FEAT-SHOWCASE-05 (低优先级) [已解决]: 节点流与逻辑图编辑器示范案例 (`NodeEditorStage`)
- **目标文件**: [examples/canvas/gallery_stage.mbt](file:///a:/moonbit-project/examples/canvas/gallery_stage.mbt)
- **状态**: **已解决**（阶段 7）。实现了包含可拖拽节点、动态输入/输出插槽以及平滑三次贝塞尔连接曲线的完整图形化节点系统。

---

## 7. 核心引擎排版与高级交互扩展 (`feat`)


### FEAT-CORE-01 (高优先级) [已解决]: 多窗口停靠与平铺布局系统 (`DockArea`)
- **目标文件**: [src/composite/dock.mbt](file:///a:/moonbit-project/src/composite/dock.mbt)
- **状态**: **已解决**（阶段 7）。实现了支持水平/垂直二叉树递归分割、视口动态缩放与分屏拖拽的多面板停靠工作台。

---


### FEAT-CORE-02 (高优先级) [已解决]: 自动换行流式布局 (`horizontal_wrapped`)
- **目标文件**: [src/core/layout.mbt](file:///a:/moonbit-project/src/core/layout.mbt)
- **状态**: **已解决**（阶段 6）。支持控件在水平排版超出可用容器宽度时自动另起一行并精确对齐。

---


### FEAT-CORE-03 (中优先级) [已解决]: 运行时动态主题系统与调色板预设 (`Theme`)
- **目标文件**: [src/core/theme.mbt](file:///a:/moonbit-project/src/core/theme.mbt), [src/color/color.mbt](file:///a:/moonbit-project/src/color/color.mbt)
- **状态**: **已解决**（阶段 6）。内建了现代深色、专业浅色与高对比度三套工程化调色板令牌。

---


### FEAT-CORE-04 (中优先级) [已解决]: 即时模式补间动画状态机 (`animate_bool`, `animate_float`)
- **目标文件**: [src/core/context.mbt](file:///a:/moonbit-project/src/core/context.mbt)
- **状态**: **已解决**（阶段 6）。内建了物理弹簧模型与立方缓动，使得状态开闭与控件过渡丝滑自然。

---


### FEAT-CORE-05 (低优先级) [已解决]: 即时模式工程图表与遥测套件 (`plot`, `bar_chart`)
- **目标文件**: [src/composite/plot.mbt](file:///a:/moonbit-project/src/composite/plot.mbt)
- **状态**: **已解决**（阶段 7）。支持高频折线图、柱状图、网格标尺自适应划分与数据点悬停追踪十字准星。


# 第三部分：结构解耦与架构模块化 (`arch`)

本节阐述底层架构层面的核心解耦工程：上帝上下文（God Context）模块化、通用内存持久化（Memory/IdMap）、设计令牌与组件样式分层、一等公民控件结构体与 Fluent 建造者协议、通过作用域 Painter 隔离坐标与绘制流，以及物理包结构与超长舞台文件的拆解。

---

## 8. 架构解耦专项行动 (`arch`)


### ARCH-01 (P1) [已解决]: `UIContext` 上帝对象子系统模块化（`Layout`, `Focus`, `Window`, `Layer`）
- **代码位置**: [src/core/context.mbt#L21-L71](file:///a:/moonbit-project/src/core/context.mbt#L21-L71)
- **状态**: **已解决**（阶段 2）。将庞大的 `UIContext` 彻底分解为独立的 `LayoutEngine`、`FocusManager`、`WindowManager` 与 `LayerManager` 子引擎，对外维持统一门面委托（Facade）。
- **类别**: 上下文架构
- **问题描述**:
  `UIContext` 曾包含 46 个字段，横跨五大异质子系统（空间布局栈、焦点与相交测试环、Scissor 视口剪裁与图层合成、窗口 Z 序管理以及持久化存储）。
- **失效机制**:
  1. 字段高度耦合，单处修改容易破坏不相关的布局或合成逻辑，使得跨包重构和单独针对某一子系统编写单元测试变得异常困难。
- **修复方案**:
  - 提炼专注的领域子引擎，`UIContext` 仅持有这些子引擎的实例并通过干净的委托接口交互。

---


### ARCH-02 (P1) [已解决]: 通用键值状态持久化机制（`Memory` / `IdMap`）解耦私有控件状态
- **代码位置**: [src/core/context.mbt#L35-L45](file:///a:/moonbit-project/src/core/context.mbt#L35-L45)
- **状态**: **已解决**（阶段 1）。引入了泛型 `Memory` 与 `IdMap` 存储子系统，彻底消除了中心上下文中针对特定控件的散乱硬编码字段。
- **类别**: 状态持久化
- **问题描述**:
  `UIContext` 曾为特定组件开设专属字段（如 `scroll_offsets`、`text_cursor_positions`、`open_collapsing_ids`）。
- **失效机制**:
  1. 每新增一个需要跨帧持久化状态的组件，都必须强行修改 `UIContext` 定义，破坏开闭原则（OCP）。
- **修复方案**:
  - 提供通用的泛型键值存储，组件私有状态结构体由各组件自行定义并通过 `ctx.memory` 存取。

---


### ARCH-03 (P1) [已解决]: `WidgetStyle` 设计系统令牌与组件级配置分层解耦
- **代码位置**: [src/core/theme.mbt](file:///a:/moonbit-project/src/core/theme.mbt)
- **状态**: **已解决**（阶段 4）。`WidgetStyle` 严格收敛为系统级设计令牌（全局缩放比例、字体比例阶梯、间距尺度、圆角尺度），严禁注入具体控件几何常量。
- **类别**: 设计系统令牌化
- **问题描述**:
  `WidgetStyle` 曾一度混入如 `knob_radius`、`fader_cap_w` 等特定控件的几何尺寸。
- **失效机制**:
  1. 造成全局主题结构体无限膨胀，控件特异性样式污染了纯粹的系统设计令牌。
- **修复方案**:
  - 特殊控件通过其独立的描述结构体（如 `CodeEditorStyle`）接受定制，默认几何尺寸均基于系统基础令牌比例推导。

---


### ARCH-04 (P1) [已解决]: 一等公民 `Widget` 结构体与 Fluent 链式建造者协议
- **代码位置**: [src/widgets/](file:///a:/moonbit-project/src/widgets/)
- **状态**: **已解决**（阶段 5）。为所有核心交互组件（`Slider`、`Knob`、`Fader`、`Table`、`Plot` 等）引入独立结构体与 `.show(ctx)` / `ui.add(...)` Fluent 建造协议。
- **类别**: 组件 API 设计
- **问题描述**:
  历史版本通过在 `UIContext` 上挂载 6 个以上参数的自由函数（如 `ctx.slider(id, val, min, max, step, format, ...)`）提供服务。
- **失效机制**:
  1. 函数参数膨胀不可控，且无法对特定高级组件进行组合式属性定制。
- **修复方案**:
  - 声明独立结构体（如 `Slider[T]`），提供如 `.min()`、`.max()`、`.step()` 等链式方法，并保留轻量级的单行便捷包装函数。

---


### ARCH-05 (P2) [已解决]: 作用域 `Painter` 绘制抽象隔离相对坐标与底层 `DrawList`
- **代码位置**: [src/draw/painter.mbt](file:///a:/moonbit-project/src/draw/painter.mbt)
- **状态**: **已解决**（阶段 3）。控件统一通过 `ctx.painter()` 提交图元，由 `Painter` 自动注入相对坐标变换与活动剪裁边界。
- **类别**: 渲染架构解耦
- **问题描述**:
  控件曾直接向全局 `DrawList` 追加带绝对屏幕坐标的绘制命令，并手动管理剪裁堆栈。
- **失效机制**:
  1. 嵌套容器或浮动窗口在发生平移时容易产生计算漂移，且剪裁栈不平衡会导致后续帧渲染溃退。
- **修复方案**:
  - 建立作用域 `Painter` 抽象，强制保证绘图操作的局部坐标边界与 Scissor 作用域安全。

---


### ARCH-06 (P2) [已解决]: 物理多包层次架构（拆解原 59 个源文件的 `src/core` 单石）
- **代码位置**: 仓库根目录与各子目录
- **状态**: **已解决**（阶段 9）。成功将庞大的 `src/core` 拆解为严格单向依赖的多包架构：
  `@math` -> `@color` -> `@draw` -> `@core` -> `@widgets` -> `@composite`。
- **类别**: 物理包层次
- **问题描述**:
  `src/core` 聚集了将近 60 个源代码文件，包边界混淆，编译依赖倒置。
- **失效机制**:
  1. 编译单元过大，增量编译缓慢，且容易产生跨层隐式耦合。
- **修复方案**:
  - 严格根据架构分层划分子包，每个子包维持专注的物理职责与干净的 `.mbti` 接口定义。

---


### ARCH-07 (P2) [已解决]: 演示舞台解耦（拆解 2088 行的单石 `gallery_stage.mbt`）
- **代码位置**: [examples/canvas/](file:///a:/moonbit-project/examples/canvas/)
- **状态**: **已解决**（阶段 6）。将超过 2000 行的 `gallery_stage.mbt` 拆解为针对各分类的独立子舞台文件（`gallery_basic_stages.mbt`、`gallery_visual_stages.mbt` 等）。
- **类别**: 展示层架构
- **问题描述**:
  单个文件包含了 30 多个组件的展示逻辑，维护困难，代码查找成本极高。
- **修复方案**:
  - 模块化拆分为领域独立的子模块，通过顶层派发器进行统一注册和渲染。


# 第四部分：v0.5.1 之后全维度代码审查与审计清册 (`audit`)

在 v0.5.1 发布之后，对整个代码库（`src/core`、`src/widgets`、`src/composite`、`src/draw`、`src/color`、`src/math`、`examples/canvas` 及 `docs/`）展开了详尽、全方位的多维代码审计与审查。

本次审计围绕以下七大核心维度进行：
- **第 9 节：逻辑错误 (`logic`)**：事件路由、状态跟踪及图层合成中的隐蔽 Bug。
- **第 10 节：健壮性与稳定性 (`robust`)**：数值边界守卫、无界循环、极值帧时间间隔及初始化边界防范。
- **第 11 节：性能与内存分配 (`perf`)**：堆内存高频热路径、字符串流失分配及绘制合批吞吐。
- **第 12 节：可维护性与设计令牌 (`maint`)**：主题令牌解耦、上下文泄露消除及全局缩放（Scale）几何不变量。
- **第 13 节：业务自举与非代码缺陷 (`dogfood`)**：运行时页面违反纯 Canvas 单画布自举标准的反模式。
- **第 14 节：用户体验与交互细节 (`ux`)**：溢出处理、视口裁剪边界、光标契约及交互控件可用性。
- **第 15 节：技术文档准确性 (`doc`)**：接口漂移、废弃签名及代码示例同步一致性。

---

## 9. 逻辑错误 (`logic`)


### AUDIT-LOGIC-01 (P0) [已解决]: Web 宿主双通道文本摄入导致字符重复键入
- **代码位置**: [examples/canvas/js/gallery_runner.js#L110-L135](file:///a:/moonbit-project/examples/canvas/js/gallery_runner.js#L110-L135)
- **状态**: **已解决**（迭代 1）。统一将字符生成重定向至隐藏的 IME textarea 桥接层，从 `keydown` 中剥离了针对可打印字符的冗余生成。
- **优先级**: **P0**
- **类别**: 输入事件调度
- **问题描述**:
  Web 宿主既在透明 `textarea` 的 `input` 事件中摄入文本字符，又在全局 `window.addEventListener('keydown')` 中生成字符，导致输入框每次按键均录入双重字符。
- **修复方案**:
  - 明确职责划分：全局按键仅捕获控制键（方向键、回车、退格、Tab 等），所有文本字符生成统一由隐藏输入框负责。

---


### AUDIT-LOGIC-02 (P1) [已解决]: 焦点脱离 Canvas 时导致按键释放（Key-Up）事件丢失
- **代码位置**: [src/core/input.mbt#L120-L140](file:///a:/moonbit-project/src/core/input.mbt#L120-L140)
- **状态**: **已解决**（迭代 1）。在 Web 宿主中添加了全局 `window.blur` 监听器，并在失焦时清空活跃按键位图。
- **优先级**: **P1**
- **类别**: 输入状态完整性
- **问题描述**:
  用户在按住某一按键的同时将鼠标点击到浏览器外部或切换窗口，Canvas 无法收到随后的 `keyup` 事件。
- **失效机制**:
  1. 导致引擎认为该按键被永久按住，产生无限滚动或持续触发。
- **修复方案**:
  - 当窗口失焦（`blur`）时，强制向引擎发送所有按键的释放事件或直接重置输入状态机。

---


### AUDIT-LOGIC-03 (P2) [已解决]: LayerManager 扁平布尔状态导致嵌套前台图层过早退出
- **代码位置**: [src/core/layer.mbt#L25-L50](file:///a:/moonbit-project/src/core/layer.mbt#L25-L50)
- **状态**: **已解决**（迭代 1）。将布尔标志重构为整数嵌套计数器（`foreground_depth : Int`），只有当归零时才退出前台模式。
- **优先级**: **P2**
- **类别**: 图层架构
- **问题描述**:
  `LayerManager` 仅通过单一的 `is_foreground : Bool` 标记当前是否处于置顶前台绘制模式。
- **失效机制**:
  1. 当一个弹出层（如菜单）内部又触发了工具提示或二级弹出菜单时，子层调用 `end_foreground()` 会瞬间将外层父弹窗也降级为普通图层。
- **修复方案**:
  - 维护深度计数器 `foreground_depth`，入栈加一，出栈减一。

---


### AUDIT-LOGIC-04 (P0) [已解决]: 未配对的 `begin_foreground` 导致无限循环分配与 OOM 崩溃
- **代码位置**: [src/core/context.mbt#L180-L200](file:///a:/moonbit-project/src/core/context.mbt#L180-L200)
- **状态**: **已解决**（迭代 1）。在 `end_frame` 中添加了安全断言与强制自动闭合机制，若图层栈未平衡则在记录告警后重置。
- **优先级**: **P0**
- **类别**: 内存安全与执行健壮性
- **问题描述**:
  若第三方组件发生异常或因条件分支过早 `return` 未调用 `end_foreground`，当前帧的绘制指令将持续累加到前台临时缓冲区中而得不到刷新。
- **修复方案**:
  - 在帧末尾显式核查并强制回收未平衡的图层。

---


### AUDIT-LOGIC-05 (P1) [已解决]: DockArea 分栏器未释放 `active_id` 导致全局鼠标捕获泄露
- **代码位置**: [src/composite/dock.mbt#L140-L170](file:///a:/moonbit-project/src/composite/dock.mbt#L140-L170)
- **状态**: **已解决**（迭代 1）。在拖拽释放后显式归还鼠标活跃所有权，避免吞噬其他面板的点击。
- **优先级**: **P1**
- **类别**: 复合组件状态机
- **问题描述**:
  分栏手柄在拖拽结束后，其内部派生 ID 仍占据 `ctx.active_id`。
- **失效机制**:
  1. 用户在松开分栏手柄后，后续无论点击工作台何处均无法激活其他控件。
- **修复方案**:
  - 在鼠标按键释放帧，若处于非拖拽态立即重置活跃控件所有权。

---


### AUDIT-LOGIC-06 (P2) [已解决]: DockArea 与 NodeEditor 绕过 Scissor 裁剪与命中相交隔离
- **代码位置**: [src/composite/dock.mbt](file:///a:/moonbit-project/src/composite/dock.mbt), [src/composite/node_editor.mbt](file:///a:/moonbit-project/src/composite/node_editor.mbt)
- **状态**: **已解决**（迭代 4）。全面接入 `ctx.is_hovered`，严格遵循 Scissor 视口剪裁树，彻底废除原始全局点相交判定。
- **优先级**: **P2**
- **类别**: 命中测试与剪裁隔离

---

## 10. 健壮性与稳定性 (`robust`)


### AUDIT-ROBUST-01 (P1) [已解决]: 物理弹簧模型在极大帧耗时或 NaN 下产生无界循环步进
- **代码位置**: [src/core/animation.mbt#L50-L75](file:///a:/moonbit-project/src/core/animation.mbt#L50-L75)
- **状态**: **已解决**（迭代 1）。为积分步长施加严格上限（最大 10 次子循环），并在遇到非有限浮点数或 NaN 时回退到目标稳态。
- **优先级**: **P1**
- **类别**: 数值物理与动画系统

---


### AUDIT-ROBUST-02 (P2) [已解决]: 零号帧初始鼠标位移突变飞跃
- **代码位置**: [src/core/input.mbt#L60-L75](file:///a:/moonbit-project/src/core/input.mbt#L60-L75)
- **状态**: **已解决**（迭代 1）。初始化时将 `last_mouse_pos` 锚定为当前帧坐标，首帧位移差强制归零。
- **优先级**: **P2**
- **类别**: 输入初始化

---


### AUDIT-ROBUST-03 (P2) [已解决]: `Color::lerp` 非有限插值参数导致生成畸变 RGBA
- **代码位置**: [src/color/color.mbt#L80-L95](file:///a:/moonbit-project/src/color/color.mbt#L80-L95)
- **状态**: **已解决**（迭代 1）。对插值因子 `t` 执行严格的 `t.is_nan()` 校验与 `[0.0, 1.0]` 闭区间钳位。
- **优先级**: **P2**
- **类别**: 颜色计算

---


### AUDIT-ROBUST-04 (P1) [已解决]: 被极度挤压的 Dock 节点产生负向矩形尺寸算术陷阱
- **代码位置**: [src/composite/dock.mbt#L85-L105](file:///a:/moonbit-project/src/composite/dock.mbt#L85-L105)
- **状态**: **已解决**（迭代 1）。尺寸计算中引入 `max(0.0, ...)` 钳位防线。
- **优先级**: **P1**
- **类别**: 几何布局计算

---


### AUDIT-ROBUST-05 (P2) [已解决]: Toast 手动关闭时由于索引失效造成位置跳跃
- **代码位置**: [src/widgets/toast.mbt#L70-L95](file:///a:/moonbit-project/src/widgets/toast.mbt#L70-L95)
- **状态**: **已解决**（迭代 1）。改为基于全局唯一 UUID/ID 索引删除，而非瞬态数组下标。
- **优先级**: **P2**
- **类别**: 状态一致性

---


### AUDIT-ROBUST-06 (P2) [已解决]: 科学图表与柱状图采用原始鼠标测试且缺失光标语义
- **代码位置**: [src/composite/plot.mbt#L120-L150](file:///a:/moonbit-project/src/composite/plot.mbt#L120-L150)
- **状态**: **已解决**（迭代 3）。接入 `ctx.is_hovered` 并在十字准星激活时上报 `crosshair` 光标。
- **优先级**: **P2**
- **类别**: 图表交互

---


### AUDIT-ROBUST-07 (P2) [已解决]: Fader、Knob 与 Stepper 对非有限数与 NaN 的敏感性
- **代码位置**: [src/widgets/fader.mbt](file:///a:/moonbit-project/src/widgets/fader.mbt), [src/widgets/knob.mbt](file:///a:/moonbit-project/src/widgets/knob.mbt), [src/widgets/stepper.mbt](file:///a:/moonbit-project/src/widgets/stepper.mbt)
- **状态**: **已解决**（迭代 5）。全面引入非有限数防护，遇到 NaN 自动回退到 `min` 或 `0.0`。
- **优先级**: **P2**
- **类别**: 数值鲁棒性

---


### AUDIT-ROBUST-08 (P2) [已解决]: `Rating` 评分组件中的非有限数与 NaN 防护
- **代码位置**: [src/widgets/rating.mbt#L30-L50](file:///a:/moonbit-project/src/widgets/rating.mbt#L30-L50)
- **状态**: **已解决**（迭代 6）。校验评分输入值，若为非有限数立即回退到 `0.0`。
- **优先级**: **P2**
- **类别**: 数值鲁棒性

---


### AUDIT-ROBUST-09 (P2) [已解决]: `Spinner` 动画状态中系统时间戳为 NaN 时的防崩溃保护
- **代码位置**: [src/widgets/spinner.mbt#L35-L55](file:///a:/moonbit-project/src/widgets/spinner.mbt#L35-L55)
- **状态**: **已解决**（迭代 7）。增加 `ctx.time` 的 NaN 与有效性判定，避免生成非法的圆弧起止角。
- **优先级**: **P2**
- **类别**: 动画健壮性

---


### AUDIT-ROBUST-10 (P2) [已解决]: `VirtualList` 虚拟列表中持久化滚动偏移量为 NaN 的传播扩散
- **代码位置**: [src/widgets/virtual_list.mbt#L114-L120](file:///a:/moonbit-project/src/widgets/virtual_list.mbt#L114-L120), [第 220-230 行](file:///a:/moonbit-project/src/widgets/virtual_list.mbt#L220-L230)
- **状态**: **已解决**（迭代 8）。读取时核验 `raw_scroll.is_nan()` 并回退为 `0.0`，在边界钳位处增加有效性守卫。
- **优先级**: **P2**
- **类别**: 数值鲁棒性

---

## 11. 性能与内存分配 (`perf`)


### AUDIT-PERF-01 (P1) [已解决]: 文本度量缓存中的高频堆字符串分配与浮点截断
- **代码位置**: [src/core/text.mbt#L60-L85](file:///a:/moonbit-project/src/core/text.mbt#L60-L85)
- **状态**: **已解决**（迭代 1）。引入基于 FNV-1a 的多参数复合哈希键，消除了逐次度量产生的字符串拼接分配。
- **优先级**: **P1**
- **类别**: 内存分配热路径

---


### AUDIT-PERF-03 (P2) [已解决]: 2D 拾色器饱和度-明度区域产生多达 70 条网格绘制指令洪峰
- **代码位置**: [src/widgets/color_picker.mbt#L140-L175](file:///a:/moonbit-project/src/widgets/color_picker.mbt#L140-L175)
- **状态**: **已解决**（迭代 2）。改用双向正交双重线性渐变图元，将 70 条小方块绘制指令缩减为 2 条原生渐变指令。
- **优先级**: **P2**
- **类别**: 渲染管线优化

---


### AUDIT-PERF-04 (P2) [已解决]: 拾色器 Alpha 滑条离散色带洪峰与进度条 NaN
- **代码位置**: [src/widgets/color_picker.mbt](file:///a:/moonbit-project/src/widgets/color_picker.mbt), [src/widgets/progress_bar.mbt](file:///a:/moonbit-project/src/widgets/progress_bar.mbt)
- **状态**: **已解决**（迭代 4）。采用水平线性渐变，并对进度条比率执行有限区间钳位。
- **优先级**: **P2**
- **类别**: 渲染优化

---


### AUDIT-PERF-05 (P2) [已解决]: WindowManager 窗口批次与过期焦点 ID 的无界增长
- **代码位置**: [src/core/window.mbt](file:///a:/moonbit-project/src/core/window.mbt)
- **状态**: **已解决**（迭代 5）。为窗口上下文增加了帧末尾清理机制，清除不存在窗口的持久化 Z 序。
- **优先级**: **P2**
- **类别**: 内存泄漏防范

---


### AUDIT-PERF-07 (P2) [已解决]: `NodeEditor` 连线贝塞尔曲线静态细分与原始鼠标命中判定
- **代码位置**: [src/composite/node_editor.mbt#L190-L220](file:///a:/moonbit-project/src/composite/node_editor.mbt#L190-L220), [第 510-525 行](file:///a:/moonbit-project/src/composite/node_editor.mbt#L510-L525)
- **状态**: **已解决**（迭代 7）。节点拖拽严格通过 `ctx.is_hovered` 遵守剪裁区，三次贝塞尔连线根据端点距离自适应降采样为 8 至 16 个分段。
- **优先级**: **P2**
- **类别**: 渲染性能与剪裁隔离

---

## 12. 可维护性与设计令牌 (`maint`)


### AUDIT-MAINT-02 (P1) [已解决]: `UIContext` 中遗留的特定控件标识符字段破坏解耦
- **代码位置**: [src/core/context.mbt#L30-L50](file:///a:/moonbit-project/src/core/context.mbt#L30-L50)
- **状态**: **已解决**（迭代 1）。将遗留的特定控件字段全面清理至泛型 `Memory` 存储体系中。
- **优先级**: **P1**
- **类别**: 架构解耦

---


### AUDIT-MAINT-03 (P2) [已解决]: `Slider` 滑块中未缩放的尺寸字面量破坏全局缩放不变量
- **代码位置**: [src/widgets/slider.mbt#L40-L70](file:///a:/moonbit-project/src/widgets/slider.mbt#L40-L70)
- **状态**: **已解决**（迭代 1）。全量乘以 `ctx.style.scale`，确保在高分屏下视觉比例精准协调。
- **优先级**: **P2**
- **类别**: 比例缩放不变量

---


### AUDIT-MAINT-04 (P2) [已解决]: 滚动与 Toast 容器中未缩放的排版字面量与主题令牌
- **代码位置**: [src/core/containers.mbt](file:///a:/moonbit-project/src/core/containers.mbt), [src/widgets/toast.mbt](file:///a:/moonbit-project/src/widgets/toast.mbt)
- **状态**: **已解决**（迭代 1）。全面规范化为带 `scale` 缩放的令牌推导。
- **优先级**: **P2**
- **类别**: 设计系统令牌化

---


### AUDIT-MAINT-05 (P2) [已解决]: `Table` 与 `Plot` 中未缩放的度量字面量及不变量破坏
- **代码位置**: [src/composite/table.mbt](file:///a:/moonbit-project/src/composite/table.mbt), [src/composite/plot.mbt](file:///a:/moonbit-project/src/composite/plot.mbt)
- **状态**: **已解决**（迭代 3）。列宽、行高、刻度文字偏移全部乘以 `scale`。
- **优先级**: **P2**
- **类别**: 比例缩放不变量

---


### AUDIT-MAINT-06 (P1) [已解决]: 容器与控件中硬编码的视口边界及未缩放布局字面量
- **代码位置**: [src/widgets/](file:///a:/moonbit-project/src/widgets/), [src/composite/](file:///a:/moonbit-project/src/composite/)
- **状态**: **已解决**（迭代 4）。
- **优先级**: **P1**
- **类别**: 响应式视口度量

---


### AUDIT-MAINT-07 (P1) [已解决]: Dialog、Tooltip 与 Window 中的硬编码视口尺寸及未缩放描边
- **代码位置**: [src/composite/dialog.mbt](file:///a:/moonbit-project/src/composite/dialog.mbt), [src/widgets/tooltip.mbt](file:///a:/moonbit-project/src/widgets/tooltip.mbt), [src/composite/window.mbt](file:///a:/moonbit-project/src/composite/window.mbt)
- **状态**: **已解决**（迭代 5）。从当前活动剪裁区与可用宽度动态计算视口边界，描边均乘以 `scale`。
- **优先级**: **P1**
- **类别**: 视口自适应与缩放

---


### AUDIT-MAINT-08 (P1) [已解决]: `Tag` 与 `Badge` 中系统性的未缩放字面量
- **代码位置**: [src/widgets/badge.mbt#L40-L100](file:///a:/moonbit-project/src/widgets/badge.mbt#L40-L100)
- **状态**: **已解决**（迭代 6）。内边距、圆点半径、关闭按钮十字叉偏移全部乘以 `scale`。
- **优先级**: **P1**
- **类别**: 比例缩放不变量

---


### AUDIT-MAINT-09 (P2) [已解决]: `Steps` 与 `Breadcrumb` 中的未缩放排版偏移与焦点环度量
- **代码位置**: [src/widgets/steps.mbt#L30-L70](file:///a:/moonbit-project/src/widgets/steps.mbt#L30-L70), [src/widgets/breadcrumb.mbt#L35-L65](file:///a:/moonbit-project/src/widgets/breadcrumb.mbt#L35-L65)
- **状态**: **已解决**（迭代 6）。连接线粗细、文字偏移、指示圆环半径全部乘以 `scale`。
- **优先级**: **P2**
- **类别**: 比例缩放不变量

---


### AUDIT-MAINT-10 (P1) [已解决]: `Toast` 中的静态兜底视口尺寸与未缩放字面量
- **代码位置**: [src/widgets/toast.mbt#L60-L90](file:///a:/moonbit-project/src/widgets/toast.mbt#L60-L90)
- **状态**: **已解决**（迭代 7）。通过 `current_clip` 与 `available_width` 动态推导屏幕右下角停靠边界，描边与关闭字号均接入设计令牌。
- **优先级**: **P1**
- **类别**: 视口自适应

---


### AUDIT-MAINT-11 (P1) [已解决]: `collapsing_header` 与 `tab_bar` 中未缩放的箭头几何与容器边框
- **代码位置**: [src/widgets/containers.mbt#L42-L68](file:///a:/moonbit-project/src/widgets/containers.mbt#L42-L68), [第 120-160 行](file:///a:/moonbit-project/src/widgets/containers.mbt#L120-L160)
- **状态**: **已解决**（迭代 8）。折叠头箭头顶点偏移与描边粗细均乘以 `scale`；标签栏底部容器边框（`1.0 * scale`）、活动标签微移（`2.0 * scale`）及焦点环指示统一适配比例。
- **优先级**: **P1**
- **类别**: 可维护性与缩放不变量

---


### AUDIT-MAINT-12 (P2) [已解决]: `RichText` 中行内代码块内边距与链接下划线度量未缩放
- **代码位置**: [src/composite/rich_text.mbt#L223-L245](file:///a:/moonbit-project/src/composite/rich_text.mbt#L223-L245), [第 275-290 行](file:///a:/moonbit-project/src/composite/rich_text.mbt#L275-L290)
- **状态**: **已解决**（迭代 8）。行内代码块背景水平内边距（`3.0 * scale`）、垂直偏移、圆角半径、边框粗细以及悬停链接下划线粗细全部接入 `scale` 缩放因子。
- **优先级**: **P2**
- **类别**: 可维护性与缩放不变量

---

## 13. 业务自举与非代码缺陷 (`dogfood`)


### AUDIT-UX-01 (P2) [已解决]: 超宽数据表格缺乏水平滚动与表头吸顶固定
- **代码位置**: [src/composite/table.mbt#L60-L120](file:///a:/moonbit-project/src/composite/table.mbt#L60-L120)
- **状态**: **已解决**（迭代 3）。实现了独立水平滚动条并锁定了表头垂直视口。
- **优先级**: **P2**
- **类别**: 表格排版

---


### AUDIT-UX-02 (P2) [已解决]: 定宽数值容器导致数字文字截断与排版抖动
- **代码位置**: [src/widgets/slider.mbt#L80-L100](file:///a:/moonbit-project/src/widgets/slider.mbt#L80-L100)
- **状态**: **已解决**（迭代 2）。基于文本测量动态调整数值展示宽度。
- **优先级**: **P2**
- **类别**: 文本对齐

---


### AUDIT-UX-03 (P1) [已解决]: 单行 `TextEdit` 缺乏横向视口滚动导致光标穿透裁剪
- **代码位置**: [src/widgets/text_edit.mbt#L90-L140](file:///a:/moonbit-project/src/widgets/text_edit.mbt#L90-L140)
- **状态**: **已解决**（迭代 2）。引入内部水平滚动偏移，保证光标输入时始终自动平移进可视区。
- **优先级**: **P1**
- **类别**: 文本编辑可用性

---


### AUDIT-UX-04 (P2) [已解决]: `VirtualList` 滚动条滑块不可交互且缺乏键盘焦点导航
- **代码位置**: [src/widgets/virtual_list.mbt#L120-L160](file:///a:/moonbit-project/src/widgets/virtual_list.mbt#L120-L160)
- **状态**: **已解决**（迭代 2）。支持滑块鼠标拖拽、上下方向键平移及 PageUp/PageDown/Home/End 翻页跳转。
- **优先级**: **P2**
- **类别**: 虚拟列表可用性

---


### AUDIT-UX-05 (P2) [已解决]: 拾色器在选中黑、白或灰度色阶时色相被迫重置为 0°
- **代码位置**: [src/widgets/color_picker.mbt#L90-L115](file:///a:/moonbit-project/src/widgets/color_picker.mbt#L90-L115)
- **状态**: **已解决**（迭代 2）。持久化保存当前的纯色相分量，避免在明度为 0 时发生色相归零抖动。
- **优先级**: **P2**
- **类别**: 拾色器交互

---


### AUDIT-UX-06 (P2) [已解决]: 未消费的编辑与导航按键泄露至外层容器
- **代码位置**: [src/widgets/text_edit.mbt](file:///a:/moonbit-project/src/widgets/text_edit.mbt)
- **状态**: **已解决**（迭代 2）。方向键和文本编辑键在处理后一律显式调用 `consume_key`。
- **优先级**: **P2**
- **类别**: 键盘输入隔离

---


### AUDIT-UX-07 (P2) [已解决]: 旋转旋钮 (`Knob`) 与分段选择器缺乏按键消费及焦点环
- **代码位置**: [src/widgets/knob.mbt](file:///a:/moonbit-project/src/widgets/knob.mbt), [src/widgets/segmented_control.mbt](file:///a:/moonbit-project/src/widgets/segmented_control.mbt)
- **状态**: **已解决**（迭代 3）。补齐焦点状态绘制，并消费左右方向键。
- **优先级**: **P2**
- **类别**: 控件可用性

---


### AUDIT-UX-08 (P2) [已解决]: `ScrollArea` 滑块点击瞬间跳跃与光标手势缺失
- **代码位置**: [src/widgets/containers.mbt#L180-L220](file:///a:/moonbit-project/src/widgets/containers.mbt#L180-L220)
- **状态**: **已解决**（迭代 4）。滑块悬停时上报 `pointer` 光标，拖拽基于相对抓握点位移而非中心跳跃。
- **优先级**: **P2**
- **类别**: 滚动条交互

---


### AUDIT-UX-09 (P2) [已解决]: 定高 `TreeView` 树形控件缺乏垂直滚动、滚轮响应及选区自动滚入
- **代码位置**: [src/composite/tree_view.mbt#L80-L130](file:///a:/moonbit-project/src/composite/tree_view.mbt#L80-L130)
- **状态**: **已解决**（迭代 4）。内嵌 `scroll_area` 视口，并在键盘上下选中节点时自动平移滚动条。
- **优先级**: **P2**
- **类别**: 复合组件可用性

---


### AUDIT-UX-10 (P2) [已解决]: `Splitter` 分栏器缺失键盘 Home/End 极值吸附与把手交互区未缩放
- **代码位置**: [src/widgets/splitter.mbt#L50-L80](file:///a:/moonbit-project/src/widgets/splitter.mbt#L50-L80)
- **状态**: **已解决**（迭代 5）。支持按 Home（极小）与 End（极大）快速折叠分栏，拖拽判定区乘以 `scale` 保证高分屏易触达。
- **优先级**: **P2**
- **类别**: 分栏器交互

---

## 15. 技术文档准确性 (`doc`)


### AUDIT-DOC-01 (P2) [已解决]: API 参考手册中包含过时方法签名并缺失 v0.3 之后的新组件
- **代码位置**: [docs/API_DESIGN.md](file:///a:/moonbit-project/docs/API_DESIGN.md)
- **状态**: **已解决**（迭代 3）。同步更新了全部 API 签名与一等公民 Fluent 建造者范式。
- **优先级**: **P2**
- **类别**: 文档同步

---


### AUDIT-DOC-02 (P3) [已解决]: 旗舰级 Studio IDE 中展示陈旧的单石 `UIContext` 结构体代码范例
- **代码位置**: [examples/canvas/studio_ide.mbt#L210-L240](file:///a:/moonbit-project/examples/canvas/studio_ide.mbt#L210-L240)
- **状态**: **已解决**（迭代 3）。同步更新为最新多包解耦后的真实定义。
- **优先级**: **P3**
- **类别**: 示例代码同步

---


### AUDIT-DOC-03 (P2) [已解决]: SVG 文本基线对齐规范遗漏导致文字纵向偏移
- **代码位置**: [src/draw/svg_backend.mbt](file:///a:/moonbit-project/src/draw/svg_backend.mbt)
- **状态**: **已解决**（迭代 2）。规范了 `dominant-baseline="hanging"` 使得 SVG 与 Canvas 2D 文本完全对齐。
- **优先级**: **P2**
- **类别**: 规范准确性

---


### AUDIT-DOC-04 (P3) [已解决]: `DrawList::to_mesh` 中未声明的图元丢失（文字、渐变、剪裁遗漏）
- **代码位置**: [src/draw/mesh.mbt](file:///a:/moonbit-project/src/draw/mesh.mbt)
- **状态**: **已解决**（迭代 2）。在接口文档中正式标明三角形网格导出器的支持边界与回退机制。
- **优先级**: **P3**
- **类别**: 规范准确性

---


### AUDIT-A11Y-02 (P1) [已解决]: Checkbox、Radio 与 Toggle 开关缺失键盘激活能力
- **代码位置**: [src/widgets/checkbox.mbt](file:///a:/moonbit-project/src/widgets/checkbox.mbt), [src/widgets/radio.mbt](file:///a:/moonbit-project/src/widgets/radio.mbt), [src/widgets/toggle.mbt](file:///a:/moonbit-project/src/widgets/toggle.mbt)
- **状态**: **已解决**（迭代 4）。聚焦时响应 `Space` / `Enter` 切换勾选状态并绘制规范焦点环。
- **优先级**: **P1**
- **类别**: 键盘无障碍可达性

---


### AUDIT-A11Y-03 (P1) [已解决]: Slider 与 Fader 缺乏 Home、End、PageUp 与 PageDown 范围级跳跃导航
- **代码位置**: [src/widgets/slider.mbt](file:///a:/moonbit-project/src/widgets/slider.mbt), [src/widgets/fader.mbt](file:///a:/moonbit-project/src/widgets/fader.mbt)
- **状态**: **已解决**（迭代 5）。Home 置为 `min`，End 置为 `max`，PageUp/PageDown 按 10% 粗调。
- **优先级**: **P1**
- **类别**: 键盘无障碍可达性

---


### AUDIT-A11Y-04 (P2) [已解决]: Stepper 步进器范围导航遗漏与未缩放的分隔线描边
- **代码位置**: [src/widgets/stepper.mbt](file:///a:/moonbit-project/src/widgets/stepper.mbt)
- **状态**: **已解决**（迭代 5）。添加 Home/End 与左右键导航，描边乘以 `scale`。
- **优先级**: **P2**
- **类别**: 键盘无障碍可达性

---


### AUDIT-A11Y-05 (P2) [已解决]: `Pagination` 分页器缺失粗粒度快速翻页与未缩放描边
- **代码位置**: [src/widgets/pagination.mbt#L40-L75](file:///a:/moonbit-project/src/widgets/pagination.mbt#L40-L75)
- **状态**: **已解决**（迭代 6）。支持 PageUp（前推 5 页）与 PageDown（后推 5 页），按钮描边接入 `scale`。
- **优先级**: **P2**
- **类别**: 键盘无障碍可达性

---


### AUDIT-A11Y-06 (P2) [已解决]: `SegmentedControl` 分段选择器缺失 `Home`/`End` 范围导航与未缩放描边
- **代码位置**: [src/widgets/segmented_control.mbt#L50-L80](file:///a:/moonbit-project/src/widgets/segmented_control.mbt#L50-L80)
- **状态**: **已解决**（迭代 7）。按 Home 选中第一项，按 End 选中最后一项，滑块与容器描边乘以 `scale`。
- **优先级**: **P2**
- **类别**: 键盘无障碍可达性

---


### AUDIT-A11Y-07 (P2) [已解决]: `collapsing_header` 缺失树状展开键及 `tab_bar` 缺失 `Home`/`End` 快速跳转
- **代码位置**: [src/widgets/containers.mbt#L25-L38](file:///a:/moonbit-project/src/widgets/containers.mbt#L25-L38), [第 95-115 行](file:///a:/moonbit-project/src/widgets/containers.mbt#L95-L115)
- **状态**: **已解决**（迭代 8）。折叠头响应 `ArrowRight` 确定性展开、`ArrowLeft` 确定性折叠；标签栏响应 `Home` 选中首个标签、`End` 选中末尾标签。
- **优先级**: **P2**
- **类别**: 键盘无障碍可达性

---

### AUDIT-PERF-02 (P2) [已解决]: 节点连线绘制中细碎折线段大量消耗绘制指令
- **代码位置**: [src/draw/draw_cmd.mbt](file:///a:/moonbit-project/src/draw/draw_cmd.mbt), [src/core/painter.mbt](file:///a:/moonbit-project/src/core/painter.mbt), [src/composite/node_editor.mbt](file:///a:/moonbit-project/src/composite/node_editor.mbt)
- **状态**: **已解决**（迭代 9）。引入原生 `DrawCmd::BezierCurve` 图元与 `Painter::add_bezier_curve`，直接映射至 HTML5 Canvas `bezierCurveTo`，将每条连线 16-20 条线段合并为单条贝塞尔曲线指令。
- **优先级**: **P2**
- **类别**: 绘制指令合批效率
- **问题描述**:
  `NodeEditor` 在绘制端口间的连线时，通过逐帧向 `DrawList` 提交 16 至 20 条 `DrawCmd::Line` 分段线模拟三次贝塞尔曲线。
- **失效机制**:
  50 条连线产生 1000 条线段指令，在 Canvas 2D 中触发 1000 次路径开启与描边切换，造成严重的栅格化性能损耗。
- **修复方案**:
  引入原生 `DrawCmd::BezierCurve` 指令与 `Painter::add_bezier_curve`，单次调用即可完成平滑渲染。

---

### AUDIT-MAINT-13 (P1) [已解决]: 按钮、复选框、文本框与分栏器中系统性未缩放边框描边与分栏圆点
- **代码位置**: [src/widgets/button.mbt#L143](file:///a:/moonbit-project/src/widgets/button.mbt#L143), [src/widgets/toggle.mbt#L93](file:///a:/moonbit-project/src/widgets/toggle.mbt#L93), [src/widgets/text_edit.mbt#L255](file:///a:/moonbit-project/src/widgets/text_edit.mbt#L255), [src/widgets/splitter.mbt#L287](file:///a:/moonbit-project/src/widgets/splitter.mbt#L287)
- **状态**: **已解决**（迭代 9）。全面规范了 `Button`、`Checkbox`、`TextEdit` 与 `Splitter` 的非焦点态描边回退（乘以 `scale`），缩放了分栏器中线、把手圆点（半径 `1.5 * scale`，间距 `6.0 * scale`）及焦点环。
- **优先级**: **P1**
- **类别**: 可维护性与全局缩放不变量
- **问题描述**:
  核心交互组件在未聚焦态时直接写死 `1.0` 描边宽度，而聚焦态采用 `1.5 * scale`。分栏器手柄的圆点与间距也是字面量 `1.5` 与 `6.0`。
- **失效机制**:
  在高分屏（如 scale 2.0）下，非焦点边框显得异常纤细单薄，分栏把手圆点比例失调。
- **修复方案**:
  所有默认边框描边、分栏线与手柄圆点统一乘以 `ctx.style.scale`。

---

### AUDIT-MAINT-01 (P1) [已解决]: 组件直接调用语义调色板令牌绕过系统主题机制
- **代码位置**: [src/widgets/](file:///a:/moonbit-project/src/widgets/)（全部 18 个控件源文件）
- **状态**: **已解决**（迭代 10）。将 `src/widgets/` 全部 18 个标准控件中共计 285 处写死的全局 `@color.Color::*` 语义调色板调用彻底重构为动态 `ctx.theme` 引用。扩展 `Theme` 结构体及内置预设（`studio_light`、`slate_dark`、`high_contrast`）涵盖 `danger`、`warning`、`success`、`shadow` 状态色。编写了 5 组针对多主题动态着色的白盒单元测试，验证各控件在主题切换后立即响应色彩变换。
- **优先级**: **P1**
- **类别**: 设计令牌解耦与动态主题化
- **问题描述**:
  分析发现 `src/widgets/` 中存在 285 处对静态 `@color.Color::*` 函数的直接调用，完全忽略了 `ctx.theme`。
- **失效机制**:
  虽然引擎支持运行时主题切换（`ctx.set_theme`），但由于控件代码写死了全局调色板函数，导致切换至暗色或高对比度模式时，标准交互控件依然定格在默认明亮浅色外观。
- **修复方案**:
  所有标准控件一律经由 `ctx.theme` 获取背景、边框、前景色与状态色，杜绝硬编码静态调色板；通过自动化测试验证主题切换效果。


