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
* `slider` / `slider_int`: **[Status: ✅ Implemented]**
* `drag_float`: **[Status: 🚧 Proposed]**

```moonbit
// [Implemented] Continuous floating-point slider
fn UIContext::slider(
  self : UIContext, 
  label : String, 
  value : Double, 
  min : Double, 
  max : Double
) -> (Double, Response)

// [Implemented] Integer step slider
fn UIContext::slider_int(
  self : UIContext, 
  label : String, 
  value : Int, 
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

### 4.1 Floating Window
* `window`: **[Status: ✅ Implemented]**

```moonbit
// [Implemented] Window container with background card, header bar, local scoping, and clipping
fn UIContext::window(
  self : UIContext, 
  title : String, 
  pos : Vec2, 
  size : Vec2, 
  content : (UIContext) -> Unit
) -> Unit
```

### 4.2 Top Application Menu Bar
* **[Status: ✅ Implemented]**

```moonbit
// [Implemented] Top application menu strip (customizable height, default 28.0px)
pub fn UIContext::menu_bar(
  self : UIContext, 
  height? : Double, 
  content : (UIContext) -> Unit
) -> Response

// [Implemented] Menu header and popup card (with desktop Hover-to-Switch and foreground occlusion)
pub fn UIContext::menu(
  self : UIContext, 
  title : String, 
  content : (UIContext) -> Unit
) -> Response

// [Implemented] Menu item (optional shortcut badge, returns interaction Response)
pub fn UIContext::menu_item(
  self : UIContext, 
  label : String, 
  shortcut? : String
) -> Response

// [Implemented] Menu internal hairline divider
pub fn UIContext::menu_separator(self : UIContext) -> Unit
```

### 4.3 Layout Flow & Grouping
* `horizontal` / `vertical`: **[Status: ✅ Implemented]**
* `collapsing_header`: **[Status: ✅ Implemented]**

```moonbit
// [Implemented] Arrange children horizontally in a row (wraps upon exit)
pub fn UIContext::horizontal(self : UIContext, content : (UIContext) -> Unit) -> Unit

// [Implemented] Arrange children vertically in a column (default)
pub fn UIContext::vertical(self : UIContext, content : (UIContext) -> Unit) -> Unit

// [Implemented] Collapsible tree section (with persistent open state and chevron indicator)
pub fn UIContext::collapsing_header(
  self : UIContext, 
  id : String, 
  title : String, 
  content : (UIContext) -> Unit, 
  default_open? : Bool
) -> Response

// [Implemented] Visual horizontal separator line
pub fn UIContext::separator(self : UIContext) -> Unit

// [Implemented] Vertical/horizontal whitespace spacer
pub fn UIContext::spacer(self : UIContext, amount : Double) -> Unit
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

fn render_frame(ctx : @core.UIContext, state : GameTelemetry) {
  // Top Menu (src/composite)
  @composite.menu_bar(ctx, fn(top) {
    @composite.menu(top, "Game", fn(menu) {
      if @composite.menu_item(menu, "Reset Stats").clicked {
        state.counter = 0
      }
    })
  })

  // Inspector Window (src/widgets)
  @widgets.window(ctx, "Game Inspector", @math.Vec2::new(40.0, 40.0), @math.Vec2::new(320.0, 400.0), fn(win) {
    let _ = win.label_colored("Physics Controls", @color.Color::text_strong())
    win.separator()

    win.horizontal(fn(row) {
      if @widgets.button(row, "Increment").clicked {
        state.counter += 1
      }
      let _ = row.label("Clicks: " + state.counter.to_string())
    })

    let (speed, _) = @widgets.slider(win, "Speed (m/s)", state.speed, 0.0, 120.0)
    state.speed = speed
    let (grid, _) = @widgets.checkbox(win, "Draw Collision Grid", state.show_grid)
    state.show_grid = grid

    @widgets.collapsing_header(win, "telemetry", "Performance Telemetry", true, fn(panel) {
      let (_, _) = @composite.sparkline(panel, "frame_times", state.fps_history, size=@math.Vec2::new(240.0, 50.0))
    })
  })
}
```
