# Moon-EGUI 公共 API 设计规范与参考手册

<p>
  <a href="API_DESIGN.md">English</a> · <a href="API_DESIGN_zh.md">简体中文</a>
</p>

> 本文档为 `moon-egui` 面向开发者的公共 API 规范手册，涵盖基础几何模型、交互响应契约、控件套件签名、容器布局流式协议以及底层自由绘图接口。

---

## 1. 核心数学与几何类型

### 1.1 2D 向量与坐标运算 (`Vec2`)
```moonbit
// 二维浮点向量
struct Vec2 {
  x : Double
  y : Double
}

fn Vec2::new(x : Double, y : Double) -> Vec2
fn Vec2::zero() -> Vec2
fn Vec2::add(self : Vec2, other : Vec2) -> Vec2
fn Vec2::sub(self : Vec2, other : Vec2) -> Vec2
fn Vec2::scale(self : Vec2, factor : Double) -> Vec2
fn Vec2::length(self : Vec2) -> Double
fn Vec2::dist(self : Vec2, other : Vec2) -> Double
```

### 1.2 轴对齐外接矩形 (`Rect`)
```moonbit
// 二维 AABB 外接矩形
struct Rect {
  x : Double
  y : Double
  w : Double
  h : Double
}

fn Rect::new(x : Double, y : Double, w : Double, h : Double) -> Rect
fn Rect::from_min_max(min : Vec2, max : Vec2) -> Rect
fn Rect::contains(self : Rect, pt : Vec2) -> Bool
fn Rect::intersects(self : Rect, other : Rect) -> Bool
fn Rect::intersect(self : Rect, other : Rect) -> Rect
fn Rect::expand(self : Rect, margin : Double) -> Rect
fn Rect::shrink(self : Rect, margin : Double) -> Rect
```

### 1.3 颜色模型 (`Color` - RGBA)
```moonbit
struct Color {
  r : Int // 0 - 255
  g : Int // 0 - 255
  b : Int // 0 - 255
  a : Int // 0 - 255
}

fn Color::rgb(r : Int, g : Int, b : Int) -> Color
fn Color::rgba(r : Int, g : Int, b : Int, a : Int) -> Color
fn Color::hex(hex_code : Int) -> Color
fn Color::with_alpha(self : Color, alpha : Int) -> Color
```

---

## 2. 交互响应结构体 (`Response`)

在即时模式中，每个控件方法在求值后均会即刻返回一个富状态记录 `Response`，支持流畅的交互链式判断：

```moonbit
struct Response {
  id : UInt64
  rect : Rect
  hovered : Bool
  clicked : Bool
  pressed : Bool
  dragged : Bool
  double_clicked : Bool
}

fn Response::clicked(self : Response) -> Bool
fn Response::hovered(self : Response) -> Bool
fn Response::dragged(self : Response) -> Bool
```

---

## 3. 核心控件套件规范 (Widgets)

所有交互式控件均以方法形式挂载在上下文 `UIContext` 上。

### 3.1 文本与标签 (Text & Labels)
* `label` / `label_colored`：**[状态: ✅ 已实现 (Implemented)]**
* `heading` / `code`：**[状态: 🚧 规划中 (Proposed)]**

```moonbit
// [已实现] 普通纯文本标签
fn UIContext::label(self : UIContext, text : String) -> Response

// [已实现] 自定义颜色纯文本标签
fn UIContext::label_colored(self : UIContext, text : String, color : Color) -> Response

// [规划中] 视觉加粗放大的标题文本
fn UIContext::heading(self : UIContext, text : String) -> Response

// [规划中] 等宽代码格式文本
fn UIContext::code(self : UIContext, text : String) -> Response
```

### 3.2 交互按钮 (Buttons)
* `button` / `button_primary`：**[状态: ✅ 已实现 (Implemented)]**
* `small_button`：**[状态: 🚧 规划中 (Proposed)]**

```moonbit
// [已实现] 标准紧凑型下压按钮（Normal / Hover / Pressed 响应）
fn UIContext::button(self : UIContext, text : String) -> Response

// [已实现] 主行动点（Primary CTA）强调按钮
fn UIContext::button_primary(self : UIContext, text : String) -> Response

// [规划中] 小型紧凑微缩按钮
fn UIContext::small_button(self : UIContext, text : String) -> Response
```

### 3.3 布局辅助 (Layout Spacing)
* `separator` / `spacer`：**[状态: ✅ 已实现 (Implemented)]**

```moonbit
// [已实现] 全宽水平分割线
fn UIContext::separator(self : UIContext) -> Unit

// [已实现] 垂直弹性留白占位
fn UIContext::spacer(self : UIContext, height : Double) -> Unit
```

### 3.4 布尔与开关控制 (Booleans & Toggles)
* `checkbox`：**[状态: ✅ 已实现 (Implemented)]**
* `toggle`：**[状态: 🚧 规划中 (Proposed)]**

```moonbit
// [已实现] 标准方框复选框
fn UIContext::checkbox(self : UIContext, text : String, checked : Bool) -> (Bool, Response)

// [规划中] 现代胶囊型滑动开关
fn UIContext::toggle(self : UIContext, text : String, active : Bool) -> (Bool, Response)
```

### 3.5 数值调节与滑动条 (Value Selectors)
* **[状态: 🚧 规划中 (Proposed)]**

```moonbit
// [规划中] 连续型浮点滑动条
fn UIContext::slider_float(
  self : UIContext, 
  label : String, 
  val : Double, 
  min : Double, 
  max : Double
) -> (Double, Response)

// [规划中] 步进整型滑动条
fn UIContext::slider_int(
  self : UIContext, 
  label : String, 
  val : Int, 
  min : Int, 
  max : Int
) -> (Int, Response)

// [规划中] Blender 风格的数字微调滑轮（按住数值横向拖拽增减）
fn UIContext::drag_float(
  self : UIContext, 
  label : String, 
  val : Double, 
  speed : Double, 
  min : Double, 
  max : Double
) -> (Double, Response)
```

### 3.6 文本输入 (Text Editing)
* **[状态: 🚧 规划中 (Proposed)]**

```moonbit
// [规划中] 单行交互式文本输入框
fn UIContext::text_input(
  self : UIContext, 
  placeholder : String, 
  text : String
) -> (String, Response)
```

### 3.7 遥测反馈与数据可视化 (Telemetry & Feedback)
* **[状态: 🚧 规划中 (Proposed)]**

```moonbit
// [规划中] 连续进度条指示器（取值范围 0.0 至 1.0）
fn UIContext::progress_bar(self : UIContext, fraction : Double) -> Response

// [规划中] 历史波动数据实时折线图（Sparkline）
fn UIContext::sparkline(
  self : UIContext, 
  label : String, 
  data : Array[Double], 
  height : Double
) -> Response

// [规划中] 悬浮气泡提示（挂载在任意控件响应对象之后）
fn Response::on_hover_text(self : Response, ui : UIContext, tooltip : String) -> Unit
```

---

## 4. 容器与视窗系统 (Containers & Windows)
* **[状态: 🚧 规划中 (Proposed)]**

### 4.1 自由浮动可拖拽视窗 (Floating Window)
```moonbit
// [规划中]
fn UIContext::window(
  self : UIContext, 
  title : String, 
  default_x : Double, 
  default_y : Double, 
  width : Double, 
  height : Double, 
  content : (UIContext) -> Unit
) -> Unit
```

### 4.2 顶部全局应用程序菜单栏 (Application Menu Bar)
```moonbit
// [规划中]
fn UIContext::menu_bar(self : UIContext, content : (UIContext) -> Unit) -> Unit
fn UIContext::menu(self : UIContext, title : String, content : (UIContext) -> Unit) -> Unit
fn UIContext::menu_item(self : UIContext, label : String) -> Bool
```

### 4.3 流式排版组织与分组 (Layout Flow)
```moonbit
// [规划中] 横向排列子元素（水平流式展开）
fn UIContext::horizontal(self : UIContext, content : (UIContext) -> Unit) -> Unit

// [规划中] 纵向排列子元素（默认垂直堆叠）
fn UIContext::vertical(self : UIContext, content : (UIContext) -> Unit) -> Unit

// [规划中] 可折叠树形分组面板
fn UIContext::collapsing_header(
  self : UIContext, 
  title : String, 
  default_open : Bool, 
  content : (UIContext) -> Unit
)

// 视觉水平分割横线
fn UIContext::separator(self : &mut UIContext)

// 垂直/水平空白占位间隔
fn UIContext::spacing(self : &mut UIContext, amount : Double)
```

### 4.4 滚动视图视口 (Scroll Area)
```moonbit
fn UIContext::scroll_area(
  self : &mut UIContext, 
  max_height : Double, 
  content : (&mut UIContext) -> Unit
)
```

---

## 5. 底层自由矢量手绘接口 (Painter API)

针对游戏 HUD、仪表盘、小地图或自绘节点图，`Painter` 提供了在当前容器上下文内直接提交 2D 图元的能力：

```moonbit
struct Painter { ... }

fn UIContext::painter(self : &mut UIContext) -> Painter

fn Painter::rect_filled(self : Painter, rect : Rect, color : Color, corner_radius : Double)
fn Painter::rect_stroke(self : Painter, rect : Rect, color : Color, width : Double, corner_radius : Double)
fn Painter::line(self : Painter, start : Vec2, end : Vec2, color : Color, width : Double)
fn Painter::circle_filled(self : Painter, center : Vec2, radius : Double, color : Color)
fn Painter::circle_stroke(self : Painter, center : Vec2, radius : Double, color : Color, width : Double)
fn Painter::text(self : Painter, pos : Vec2, text : String, font_size : Double, color : Color)
```

---

## 6. 端到端完整示例代码 (Complete Example)

```moonbit
struct GameTelemetry {
  mut counter : Int
  mut speed : Double
  mut show_grid : Bool
  fps_history : Array[Double]
}

fn render_frame(ui : &mut UIContext, state : &mut GameTelemetry) {
  // 1. 顶部全局菜单栏
  ui.menu_bar(fn(ui) {
    ui.menu("游戏控制", fn(ui) {
      if ui.menu_item("重置数据") {
        state.counter = 0
      }
    })
  })

  // 2. 属性监视悬浮窗口
  ui.window("物理调试监视器", 40.0, 40.0, 320.0, 400.0, fn(ui) {
    ui.heading("物理引擎参数")
    ui.separator()

    ui.horizontal(fn(ui) {
      if ui.button("增加点击").clicked() {
        state.counter += 1
      }
      ui.label("累计点击次数: \{state.counter}")
    })

    ui.slider_float("运行速度 (m/s)", &mut state.speed, 0.0, 120.0)
    ui.checkbox("显示碰撞网格", &mut state.show_grid)

    ui.collapsing_header("实时渲染遥测", true, fn(ui) {
      ui.sparkline("逐帧耗时曲线 (ms)", state.fps_history, 50.0)
    })
  })
}
```
