# Moon-EGUI 设计系统与视觉 Token 规范

<p>
  <a href="DESIGN_SYSTEM.md">English</a> · <a href="DESIGN_SYSTEM_zh.md">简体中文</a>
</p>

> 本文档系统定义 `moon-egui` 的视觉层级、设计 Token、色彩梯度、空间节奏基准、字阶排印以及交互状态机转换模型。

---

## 1. 设计美学理念与视觉风格

`moon-egui` 采用现代、精致的**低饱和度暗黑工业极客风格（Low-Saturation Dark Industrial）**，汲取自 Linear、Raycast 与虚幻引擎（Unreal Engine）的设计精髓：
- **纯净表面与微层深**：深炭黑底色辅以微妙的表面阶梯抬升（Elevation），保持层次分明；
- **高对比语义强调色**：明亮电光蓝/青色（Electric Blue/Cyan）作为主行动点与聚焦态，视觉指引清晰；
- **克制的微圆角**：采用克制利落的 4px - 8px 现代微圆角，杜绝塑料玩具感；
- **无障碍光学对比**：文字对比度严格达到 WCAG AA 级别标准，保障高对比度长久阅读不刺眼。

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
- **系统菜单栏高度**：`28.0 px`

### 3.2 圆角 Token (Corner Radii)
- **`RADIUS_NONE`**：`0.0 px`（直角，用于顶层全局贴合菜单栏）
- **`RADIUS_SM`**：`4.0 px`（按钮、复选框、文本输入框）
- **`RADIUS_MD`**：`6.0 px`（内嵌卡片、悬浮下拉菜单）
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
| **Monospace / Code 代码**| `12.0 px` | 等宽 (500) | `16.0 px` | 数值读数、十六进制色值、代码块 |

---

## 5. 确定性交互状态机 (Interactive State Machine)

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
