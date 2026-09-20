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
  id : Id
  rect : Rect
  hovered : Bool
  clicked : Bool
  pressed : Bool
  dragged : Bool
  has_focus : Bool
  gained_focus : Bool
  lost_focus : Bool
  secondary_clicked : Bool
}

fn Response::clicked(self : Response) -> Bool
fn Response::hovered(self : Response) -> Bool
fn Response::dragged(self : Response) -> Bool
fn Response::has_focus(self : Response) -> Bool
fn Response::secondary_clicked(self : Response) -> Bool
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
* `toggle`: **[Status: ✅ Implemented]**

```moonbit
// [Implemented] Standard square checkbox
pub fn @widgets.checkbox(ctx : UIContext, text : String, checked : Bool) -> (Bool, Response)

// [Implemented] Modern pill toggle switch
pub fn @widgets.toggle(ctx : UIContext, text : String, checked : Bool) -> (Bool, Response)

// [Implemented] Fluent and Ref-bound constructors
// @widgets.Checkbox::new(text, checked).show(ctx)
// @widgets.Checkbox::from_ref(text, ref_target)
// @widgets.Toggle::new(text, checked).show(ctx)
// @widgets.Toggle::from_ref(text, ref_target)
```

### 3.5 Value Selectors & Sliders
* `slider` / `slider_int`: **[Status: ✅ Implemented]**
* `stepper`: **[Status: ✅ Implemented]**
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

// [Implemented] Discrete step adjuster (Shift/Ctrl multipliers and mouse wheel scrubbing)
pub fn @widgets.stepper(
  ctx : UIContext,
  id_salt : String,
  value : Double,
  step? : Double,
  min? : Double?,
  max? : Double?,
  label? : String,
  width? : Double,
) -> (Double, Response)

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
* `text_edit` / `code_editor`: **[Status: ✅ Implemented]**

```moonbit
// [Implemented] Single-line/multi-line interactive text input field
pub fn @widgets.text_edit(
  ctx : UIContext,
  id_salt : String,
  text : String,
  placeholder? : String,
  width? : Double,
  password? : Bool,
) -> (String, Response)
```

### 3.7 Telemetry & Visual Feedback
* `rating`: **[Status: ✅ Implemented]**
* `progress_bar` / `sparkline`: **[Status: ✅ Implemented]**

```moonbit
// [Implemented] Interactive star rating widget (0.5 half-star fractional evaluation & hover preview)
pub fn @widgets.rating(
  ctx : UIContext,
  id_salt : String,
  value : Double,
  max_stars? : Int,
  allow_half? : Bool,
  star_size? : Double,
  spacing? : Double,
  read_only? : Bool,
  color? : @color.Color,
) -> (Double, Response)

// [Implemented] Continuous progress indicator (0.0 to 1.0)
pub fn @widgets.progress_bar(ctx : UIContext, fraction : Double, width? : Double, height? : Double) -> Response

// [Implemented] Sparkline real-time plot from a history slice
pub fn @composite.sparkline(
  ctx : UIContext, 
  id_salt : String, 
  data : Array[Double], 
  size? : @math.Vec2
) -> (Int, Response)

// [Proposed] Tooltip attached to the previous response
fn Response::on_hover_text(self : Response, ui : UIContext, tooltip : String) -> Unit
```

### 3.8 Professional Audio & Hardware Controls
* `knob`: **[Status: ✅ Implemented]**
* `fader`: **[Status: ✅ Implemented]**

```moonbit
// [Implemented] Rotary knob controller with polar arc, bipolar mode, and key consumption
pub fn @composite.knob(
  ctx : UIContext,
  id_salt : String,
  label : String,
  value : Double,
  min_val? : Double = 0.0,
  max_val? : Double = 1.0,
  step? : Double = 0.01,
  default_val? : Double = 0.0,
  unit? : String = "",
  radius? : Double = 22.0,
  bipolar? : Bool = false,
) -> (Double, Response)

// [Implemented] Vertical audio channel fader with track, cap, and tick marks
pub fn @composite.fader(
  ctx : UIContext,
  id_salt : String,
  label : String,
  value : Double,
  min_val? : Double = 0.0,
  max_val? : Double = 1.0,
  step? : Double = 0.01,
  default_val? : Double = 0.0,
  unit? : String = "",
  show_ticks? : Bool = true,
  size? : @math.Vec2,
) -> (Double, Response)
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

### 4.5 Steps & Pagination
* `steps`: **[Status: ✅ Implemented]**
* `pagination`: **[Status: ✅ Implemented]**

```moonbit
// [Implemented] Workflow process step indicator (auto status derivation and accessible keyboard navigation)
pub fn @widgets.steps(
  ctx : UIContext,
  id_salt : String,
  current : Int,
  items : Array[StepItem],
  clickable? : Bool,
  width? : Double,
) -> (Int, Response)

// [Implemented] Data pagination controller (intelligent ellipsis folding and keyboard navigation)
pub fn @widgets.pagination(
  ctx : UIContext,
  id_salt : String,
  current_page : Int,
  total_pages : Int,
  item_size? : Double,
  spacing? : Double,
  show_prev_next? : Bool,
) -> (Int, Response)
```

### 4.6 Node Flow Graph Editor (NodeEditor)
* `node_editor`: **[Status: ✅ Implemented]**

```moonbit
// [Implemented] Blueprint node flow graph editor (draggable cards, port link wiring, and smooth cubic Bézier curves)
pub fn @composite.node_editor(
  ctx : UIContext,
  id_salt : String,
  size : @math.Vec2,
  nodes : Array[NodeItem],
  connections : Array[NodeConnection],
  custom_style? : NodeEditorStyle?,
  selected_node? : String?,
) -> NodeEditorResponse
```

### 4.7 Virtualized 1D List (VirtualList)
* `virtual_list`: **[Status: ✅ Implemented]**

```moonbit
// [Implemented] High-performance virtualized 1D list rendering only visible items
pub fn @widgets.virtual_list(
  ctx : UIContext,
  id_salt : String,
  total_items : Int,
  height : Double,
  item_height? : Double = 28.0,
  item_renderer : (Int, @math.Rect) -> Unit,
) -> VirtualListResponse

// Fluent builder pattern:
// @widgets.VirtualList::new(id_salt, total_items, height)
//   .item_height(32.0)
//   .width(400.0)
//   .overscan(2)
//   .render(ctx, fn(idx, rect) { ... })
```

### 4.8 Virtualized Data Table (Table)
* `table`: **[Status: ✅ Implemented]**

```moonbit
// [Implemented] Virtualized data table with sortable columns, horizontal & vertical scrolling, and custom cell renderer
pub fn @composite.table(
  ctx : UIContext,
  id_salt : String,
  size : @math.Vec2,
  columns : Array[TableColumn],
  row_count : Int,
  render_cell : (UIContext, Int, Int, @math.Rect) -> Unit,
  row_height? : Double = 30.0,
  header_height? : Double = 32.0,
  selected_row? : Int = -1,
  sort_column? : String = "",
  sort_direction? : TableSortDirection = NoSort,
) -> TableResponse
```

### 4.9 Multi-Window Docking (DockArea)
* `dock_area`: **[Status: ✅ Implemented]**

```moonbit
// [Implemented] Recursive multi-window docking layout supporting splits, tabs, and panel resizing
pub fn @composite.dock_area(
  ctx : UIContext,
  id_salt : String,
  size : @math.Vec2,
  tree : DockTree,
  render_tab : (UIContext, String, @math.Rect) -> Unit,
) -> DockResponse
```

### 4.10 Scientific Plot & Categorical Bar Chart (Plot & BarChart)
* `plot`: **[Status: ✅ Implemented]**
* `bar_chart`: **[Status: ✅ Implemented]**

```moonbit
// [Implemented] Immediate-mode 2D scientific coordinate plot with multi-series and crosshair HUD
pub fn @composite.plot(
  ctx : UIContext,
  id_salt : String,
  series : Array[PlotSeries],
  size? : @math.Vec2,
  show_grid? : Bool = true,
  show_crosshair? : Bool = true,
  show_legend? : Bool = true,
) -> (@math.Vec2?, Response)

// [Implemented] Immediate-mode categorical bar chart with automatic scaling and hover badges
pub fn @composite.bar_chart(
  ctx : UIContext,
  id_salt : String,
  labels : Array[String],
  values : Array[Double],
  size? : @math.Vec2,
  bar_color? : @color.Color = @color.Color::accent_primary(),
) -> (Int?, Response)
```

---

## 5. Rendering Primitives, Math & Export Subsystems

### 5.1 Custom 2D Painter API

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

### 5.2 GPU Triangle Mesh Tessellation (Mesh)
* `Mesh` / `Vertex`: **[Status: ✅ Implemented]**

```moonbit
// [Implemented] Contiguous 2D triangle mesh holding vertex and index buffers for WebGL rendering
pub struct Mesh {
  vertices : Array[Vertex]
  indices : Array[Int]
}

pub fn Mesh::new() -> Mesh
pub fn Mesh::tessellate_rect(self : Mesh, rect : Rect, color : Color, corner_radius : Double) -> Unit
pub fn Mesh::write_vertex_floats(self : Mesh, out : Array[Double]) -> Unit
```

### 5.3 Vector SVG Export (SvgExporter)
* `SvgExporter`: **[Status: ✅ Implemented]**

```moonbit
// [Implemented] Converts DrawList command stream into standards-compliant standalone SVG XML
pub struct SvgExporter {
  width : Double
  height : Double
  background : @color.Color?
}

pub fn SvgExporter::new(width : Double, height : Double, background? : @color.Color) -> SvgExporter
pub fn SvgExporter::render_to_string(self : SvgExporter, draw_list : DrawList) -> String
```

### 5.4 Physics Spring Animation Engine (Spring)
* `Spring` / `SpringConfig`: **[Status: ✅ Implemented]**

```moonbit
// [Implemented] Critically damped harmonic oscillator for fluid UI transitions and gesture snapping
pub struct SpringConfig {
  stiffness : Double
  damping : Double
  mass : Double
}

pub fn SpringConfig::default_spring() -> SpringConfig
pub fn SpringConfig::bouncy() -> SpringConfig

pub struct Spring { ... }
pub fn Spring::new(initial_val : Double, config? : SpringConfig) -> Spring
pub fn Spring::set_target(self : Spring, target : Double) -> Unit
pub fn Spring::step(self : Spring, dt : Double) -> Unit
pub fn Spring::value(self : Spring) -> Double
pub fn Spring::is_settled(self : Spring, tolerance? : Double, velocity_tolerance? : Double) -> Bool
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

### State Binding Contract: Controlled Values vs Ref Targets

Immediate-mode widgets are pure functions of the arguments passed each frame. Two equivalent binding styles exist, and mixing them up is the most common integration mistake:

- **Controlled** (free functions and plain builders): `@widgets.slider(win, "Speed (m/s)", state.speed, 0.0, 120.0)` returns the new value for *this* frame. The caller writes it back into their state and passes it again next frame. Keyboard and pointer changes only surface through that returned value - passing a constant silently disables drag and keyboard interaction.
- **Ref-bound** (`*::from_ref` builders): `Slider::from_ref`, `TextEdit::from_ref`, `Checkbox::from_ref`, `Toggle::from_ref`, `Knob::from_ref`, `Fader::from_ref` and `CodeEditor::from_ref` write changes directly into their `Ref` target during the frame. No feed-back loop is required.

Rule of thumb: one-off examples use the controlled form; application state binds through `from_ref`.

