# Moon-EGUI Public API Specification & Reference Manual

<p>
  <a href="API_DESIGN.md">English</a> · <a href="API_DESIGN_zh.md">简体中文</a>
</p>

> Developer reference manual for public API signatures, widget specifications, container protocols, and event handling conventions in `moon-egui`.

---

## 1. Core Types & Context

### 1.1 Geometry & Math
```moonbit
// 2D Vector
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

// 2D Axis-Aligned Bounding Box
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

### 1.2 Color Model (RGBA)
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

## 2. Interaction Response (`Response`)

Every widget returns an informative `Response` record, allowing immediate and expressive interaction chaining:

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

## 3. Widget Suite Specifications

All widgets are invoked as methods on `UIContext`.

### 3.1 Text & Labels
* `label` / `label_colored`: **[Status: ✅ Implemented]**
* `heading` / `code`: **[Status: 🚧 Proposed]**

```moonbit
// [Implemented] Plain text label
fn UIContext::label(self : UIContext, text : String) -> Response

// [Implemented] Custom tinted text label
fn UIContext::label_colored(self : UIContext, text : String, color : Color) -> Response

// [Proposed] Styled heading with enlarged typography
fn UIContext::heading(self : UIContext, text : String) -> Response

// [Proposed] Monospaced code text
fn UIContext::code(self : UIContext, text : String) -> Response
```

### 3.2 Buttons
* `button` / `button_primary`: **[Status: ✅ Implemented]**
* `small_button`: **[Status: 🚧 Proposed]**

```moonbit
// [Implemented] Standard push button (Normal / Hover / Pressed states)
fn UIContext::button(self : UIContext, text : String) -> Response

// [Implemented] Accent button for primary CTA actions
fn UIContext::button_primary(self : UIContext, text : String) -> Response

// [Proposed] Small compact button
fn UIContext::small_button(self : UIContext, text : String) -> Response
```

### 3.3 Layout Spacing
* `separator` / `spacer`: **[Status: ✅ Implemented]**

```moonbit
// [Implemented] Full-width horizontal divider line
fn UIContext::separator(self : UIContext) -> Unit

// [Implemented] Vertical flexible padding spacer
fn UIContext::spacer(self : UIContext, height : Double) -> Unit
```

### 3.4 Booleans & Toggles
* `checkbox`: **[Status: ✅ Implemented]**
* `toggle`: **[Status: 🚧 Proposed]**

```moonbit
// [Implemented] Standard square checkbox
fn UIContext::checkbox(self : UIContext, text : String, checked : Bool) -> (Bool, Response)

// [Proposed] Modern pill toggle switch
fn UIContext::toggle(self : UIContext, text : String, active : Bool) -> (Bool, Response)
```

### 3.5 Value Selectors & Sliders
* **[Status: 🚧 Proposed]**

```moonbit
// [Proposed] Continuous floating-point slider
fn UIContext::slider_float(
  self : UIContext, 
  label : String, 
  val : Double, 
  min : Double, 
  max : Double
) -> (Double, Response)

// [Proposed] Integer step slider
fn UIContext::slider_int(
  self : UIContext, 
  label : String, 
  val : Int, 
  min : Int, 
  max : Int
) -> (Int, Response)

// [Proposed] Blender-style DragValue (horizontal scrub on number to adjust)
fn UIContext::drag_float(
  self : UIContext, 
  label : String, 
  val : Double, 
  speed : Double, 
  min : Double, 
  max : Double
) -> (Double, Response)
```

### 3.6 Text Editing
* **[Status: 🚧 Proposed]**

```moonbit
// [Proposed] Single-line text input field
fn UIContext::text_input(
  self : UIContext, 
  placeholder : String, 
  text : String
) -> (String, Response)
```

### 3.7 Telemetry & Visual Feedback
* **[Status: 🚧 Proposed]**

```moonbit
// [Proposed] Continuous progress indicator (0.0 to 1.0)
fn UIContext::progress_bar(self : UIContext, fraction : Double) -> Response

// [Proposed] Sparkline real-time plot from a history slice
fn UIContext::sparkline(
  self : UIContext, 
  label : String, 
  data : Array[Double], 
  height : Double
) -> Response

// [Proposed] Tooltip attached to the previous response
fn Response::on_hover_text(self : Response, ui : UIContext, tooltip : String) -> Unit
```

---

## 4. Containers & Windows
* **[Status: 🚧 Proposed]**

### 4.1 Floating Movable Window
```moonbit
// [Proposed]
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

### 4.2 Top Application Menu Bar
```moonbit
// [Proposed]
fn UIContext::menu_bar(self : UIContext, content : (UIContext) -> Unit) -> Unit
fn UIContext::menu(self : UIContext, title : String, content : (UIContext) -> Unit) -> Unit
fn UIContext::menu_item(self : UIContext, label : String) -> Bool
```

### 4.3 Layout Flow & Grouping
```moonbit
// [Proposed] Arrange children horizontally in a row
fn UIContext::horizontal(self : UIContext, content : (UIContext) -> Unit) -> Unit

// [Proposed] Arrange children vertically in a column (default)
fn UIContext::vertical(self : UIContext, content : (UIContext) -> Unit) -> Unit

// [Proposed] Collapsible tree section
fn UIContext::collapsing_header(
  self : UIContext, 
  title : String, 
  default_open : Bool, 
  content : (UIContext) -> Unit

// Visual horizontal separator line
fn UIContext::separator(self : &mut UIContext)

// Vertical whitespace spacer
fn UIContext::spacing(self : &mut UIContext, amount : Double)
```

### 4.4 Scroll Area
```moonbit
fn UIContext::scroll_area(
  self : &mut UIContext, 
  max_height : Double, 
  content : (&mut UIContext) -> Unit
)
```

---

## 5. Custom 2D Painter API

For game HUDs, gauges, and interactive visualizers, the `Painter` provides direct drawing inside the current container:

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

## 6. Complete End-to-End Application Example

```moonbit
struct GameTelemetry {
  mut counter : Int
  mut speed : Double
  mut show_grid : Bool
  fps_history : Array[Double]
}

fn render_frame(ui : &mut UIContext, state : &mut GameTelemetry) {
  // Top Menu
  ui.menu_bar(fn(ui) {
    ui.menu("Game", fn(ui) {
      if ui.menu_item("Reset Stats") {
        state.counter = 0
      }
    })
  })

  // Inspector Window
  ui.window("Game Inspector", 40.0, 40.0, 320.0, 400.0, fn(ui) {
    ui.heading("Physics Controls")
    ui.separator()

    ui.horizontal(fn(ui) {
      if ui.button("Increment").clicked() {
        state.counter += 1
      }
      ui.label("Clicks: \{state.counter}")
    })

    ui.slider_float("Speed (m/s)", &mut state.speed, 0.0, 120.0)
    ui.checkbox("Draw Collision Grid", &mut state.show_grid)

    ui.collapsing_header("Performance Telemetry", true, fn(ui) {
      ui.sparkline("Frame Times (ms)", state.fps_history, 50.0)
    })
  })
}
```
