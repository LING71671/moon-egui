# Moon-EGUI 设计系统与视觉 Token 规范

<p>
  <a href="DESIGN_SYSTEM.md">English</a> · <a href="DESIGN_SYSTEM_zh.md">简体中文</a>
</p>

> 本文档系统定义 `moon-egui` 的视觉层级、设计 Token、色彩梯度、空间节奏基准、字阶排印以及交互状态机转换模型。

---

## 1. 设计美学理念与视觉风格

`moon-egui` 采用精致现代的 **Studio Light（月曜白瓷工件 / Porcelain Studio Light）** 设计语言，汲取自工业机械、精密仪器与现代 CAD 工作站的设计精髓：
- **纯净白瓷表面与微层深**：冷白底色（`#F8FAFC` ~ `#FFFFFF`）辅以微层级抬升（Elevation）与柔和漫反射投影，层次分明通透；
- **高对比语义强调色**：冷钴蓝（Cobalt Blue `#2563EB`）作为主交互点、焦点外环与激活指示，视觉指引清晰利落；
- **机械微触感与注塑质感**：控件具备 1.5px 机械下沉行程（Chiclet 键帽、段落微凹槽），杜绝塑料玩具感与虚浮扁平；
- **光学无障碍高对比**：正文文字采用深冷黑钛岩（`#0F172A`），严格达到 WCAG AA 级以上可读性标准。

---

## 2. 配色系统与设计 Token (Color Palettes)

全库只有一套调色盘（Studio Light porcelain），统一定义在 `src/color/color.mbt`。
**控件不得写死颜色值**，一律通过令牌函数取值；`color_wbtest.mbt` 的 `theme design tokens`
用例锁定关键令牌数值，防止漂移。

> 早期曾并存两套配色：`color.mbt` 里的深色令牌（只被 `window()` / `tooltip()` / `progress_bar()` 读取）
> 与控件里写死的浅色字面量。2026-09-11 合并为一套浅色令牌——控件视觉不变（令牌取值与原字面量一一对应），
> 窗口与进度条随之转为浅色。深色主题尚未实现，需要时再补第二套令牌。

### 2.1 令牌总表

| Token 标识符 | Hex / RGBA | 角色定位与场景 |
| :--- | :--- | :--- |
| **容器底色** | | |
| `BG_APP` | `#F8FAFC` | 画布 / 页面底层基色 |
| `BG_WINDOW` | `#FFFFFF` | 浮动视窗、卡片、弹出面板底色 |
| `BG_SURFACE` | `#F1F5F9` | 视窗标题栏、凹槽轨道、徽章静息底色 |
| `BG_SUBTLE` | `#F8FAFC` | 悬浮浅色底纹、列表行划过高亮 |
| `BG_HOVER` | `#F8FAFC` | 悬浮态语义别名（与 `BG_SUBTLE` 同值） |
| `BG_ACTIVE` | `#E2E8F0` | 按下态、更深的凹陷底色 |
| `BG_INVERSE` | `#1A1B23` | 反色浮层：tooltip 气泡（配 `TEXT_INVERSE`） |
| **描边** | | |
| `BORDER_MUTED` | `#E2E8F0` | 内部发丝分割线、控件凹槽 |
| `BORDER_DEFAULT` | `#CBD5E1` | 控件默认外轮廓 |
| `BORDER_STRONG` | `#94A3B8` | 按下态 / 禁用态轮廓 |
| `BORDER_FOCUS` | `#2563EB` | 键盘焦点外环 |
| **文字** | | |
| `TEXT_PRIMARY` | `#0F172A` | 主标题、正文标签、按钮核心文字 |
| `TEXT_STRONG` | `#1E293B` | 按下态强调文字 |
| `TEXT_BODY` | `#334155` | 常规正文 |
| `TEXT_SECONDARY` | `#475569` | 次级说明 |
| `TEXT_MUTED` | `#64748B` | 辅助说明、徽章文字 |
| `TEXT_DISABLED` | `#94A3B8` | 占位符、非激活状态 |
| `TEXT_INVERSE` | `#FFFFFF` | 反色浮层与强调填充之上的文字 |
| **强调色** | | |
| `ACCENT_PRIMARY` | `#2563EB` | 主强调蓝：主要按钮、激活填充、滑块进度 |
| `ACCENT_HOVER` | `#3B82F6` | 主强调元素悬浮态 |
| `ACCENT_PRESSED` | `#1D4ED8` | 主强调元素按下态 |
| `ACCENT_DEEP` | `#1E3A8A` | 按下态强调描边 |
| `ACCENT_SOFT` | `rgba(37,99,235,45)` | 半透明强调光晕：焦点环、选中辉光 |
| `ACCENT_HIGHLIGHT` | `rgba(255,255,255,60)` | 强调填充之上的半透明高光细节 |
| `SHADOW` | `rgba(15,23,42,18)` | 浮动面板投影 |
| **语义色** | | |
| `SUCCESS` | `#22C55E` | 遥测正常、正向布尔开关 |
| `WARNING` | `#F59E0B` | 注意告警、帧率超时指示 |
| `DANGER` | `#EF4444` | 错误抛出、关闭视窗、破坏性动作 |

---

## 3. 空间节奏与尺寸规范 (Spatial Rhythm)

排版系统基于严谨的 **4px 基准网格** 进行空间推演：

```
间距体系 (基准模数: 4px):
  • Space_XS  = 4.0 px   (紧凑内部间隙，如复选框方框至文字间距)
  • Space_SM  = 8.0 px   (标准纵向控件堆叠间隙)
  • Space_MD  = 12.0 px  (视窗内部安全内边距 Padding、区块分割间距)
  • Space_LG  = 16.0 px  (大业务组件间距)
  • Space_XL  = 24.0 px  (窗口与窗口之间的最小边界 Margin)
```

### 3.1 常用控件标准高度 (Control Heights)
- **标准按钮高度**：`28.0 px`（紧凑型桌面级标准）
- **输入框 / 滑动条高度**：`26.0 px`
- **视窗标题栏高度**：`32.0 px`（保障舒适平稳的拖拽命中面积）
- **系统全局菜单栏高度**：`28.0 px`（贴合视口顶端，无圆角直边通栏）
- **下拉菜单项行高**：`24.0 px`（内嵌 4px 键帽徽标）

### 3.2 圆角 Token (Corner Radii)
- **`RADIUS_NONE`**：`0.0 px`（直角，用于顶层全局贴合菜单栏）
- **`RADIUS_SM`**：`4.0 px`（按钮、复选框、文本输入框、菜单单项）
- **`RADIUS_MD`**：`6.0 px`（内嵌卡片、悬浮下拉菜单卡片）
- **`RADIUS_LG`**：`8.0 px`（浮动视窗外部边缘）
- **`RADIUS_PILL`**：`999.0 px`（胶囊开关、状态指示药丸标签）

---

## 4. 字阶排印体系 (Typography)

字体渲染映射至底层 Canvas 2D 字体栈（优先回退至系统 UI 无衬线字体：`Inter, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif`）：

| 字阶角色 | 字号大小 | 字重 | 行高 | 适用场景 |
| :--- | :--- | :--- | :--- | :--- |
| **Heading 1 一级标题** | `18.0 px` | 加粗 (600) | `24.0 px` | 视窗主标题、重大配置分区 |
| **Heading 2 二级标题** | `15.0 px` | 半粗 (600) | `20.0 px` | 次级分组标题、卡片头部 |
| **Body / Label 正文** | `13.0 px` | 常规 (400) | `18.0 px` | 标准控件文本、按钮文字 |
| **Caption / Small 辅助**| `11.0 px` | 常规 (400) | `14.0 px` | 浮动气泡、遥测图表图例、微缩提示 |
| **Monospace / Code 代码**| `12.0 px` | 等宽 (500) | `16.0 px` | 数值读数、十六进制色值、快捷键徽标 |

---

## 5. 确定性交互状态机 (Interactive State Machine)

### 5.1 基础交互控件状态流转

每一个交互式控件都经历完全确定性的视觉状态演化路径：

```
[默认态 Default / Idle] 
       │
       ├─► [光标移入 AABB 范围] ────► [悬浮态 Hovered State] (表面亮度微升 + 边框轻微高亮)
       │                                     │
       │                                     ├─► [指针按下 Pointer Down] ────► [按下态 Active / Pressed] (内阴影下沉 / 强调色高亮)
       │                                     │                                      │
       │                                     │                                      ├─► [在控件内松开抬起] ──► 触发业务响应 (`clicked = true`)
       │                                     │                                      └─► [移出控件后松开] ──► 取消本次交互
       │
       └─► [不可用 Disabled == true] ───────► [禁用态 Disabled State] (50% 降低半透明度，丢弃所有指针相交事件)
```

### 5.2 弹出浮层与菜单随动流转 (Popup & Hover-to-Switch)

顶层全局菜单栏采用桌面级双稳态流转模型：

```
[全部闭合 Closed] ──(点击任一菜单标题)──► [展开态 Opened: Menu A]
                                                │
       ┌────────────────────────────────────────┴────────────────────────────────────────┐
       │                                        │                                        │
[点击外部区域或选中菜单项]             [光标滑动悬停至相邻 Menu B]                     [再次点击 Menu A]
       │                                        │                                        │
       ▼                                        ▼                                        ▼
 [返回 Closed 态]                        [自动流转展开 Menu B]                       [收起返回 Closed 态]
```
- **前台图层隔离**：弹出菜单卡片脱离普通布局流，绘制于顶层前台图层（`Foreground Layer`），自带白瓷背景与多阶深度阴影。
- **背景遮挡拦截**：浮层生效期间通过 `block_hover` 拦截下方控件的穿透拾取。
