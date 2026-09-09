///|
struct AppState {
  mut counter : Int
  mut glow_enabled : Bool
  mut sound_enabled : Bool
}

///|
let state : AppState = { counter: 0, glow_enabled: true, sound_enabled: false, }

///|
let ctx : @core.UIContext = @core.UIContext::new()

///|
/// Core frame update function exported for web/canvas.
pub fn step(
  mouse_x : Double,
  mouse_y : Double,
  mouse_down : Bool,
) -> @draw.DrawList {
  let raw = @core.RawInput::from_mouse(
    @math.Vec2::new(mouse_x, mouse_y),
    mouse_down,
  )
  ctx.begin_frame(raw)

  // 1. Header
  let _ = ctx.label("⚡ Moon-EGUI v0.1.0 • Immediate-Mode Canvas Demo")
  ctx.separator()
  ctx.spacer(4.0)

  // 2. Interactive Counter Section
  let btn_text = "🚀 Click Me (+1)  [Count: \{state.counter}]"
  let btn_resp = ctx.button(btn_text)
  if btn_resp.clicked() {
    state.counter = state.counter + 1
  }

  ctx.spacer(4.0)
  let pbtn_resp = ctx.button_primary("Reset Counter")
  if pbtn_resp.clicked() {
    state.counter = 0
  }

  ctx.spacer(8.0)
  ctx.separator()
  ctx.spacer(4.0)

  // 3. Checkbox Options
  let (new_glow, glow_resp) = ctx.checkbox(
    "Enable Cyberpunk Glow",
    state.glow_enabled,
  )
  if glow_resp.clicked() {
    state.glow_enabled = new_glow
  }

  let (new_sound, sound_resp) = ctx.checkbox(
    "Simulate Audio Haptics",
    state.sound_enabled,
  )
  if sound_resp.clicked() {
    state.sound_enabled = new_sound
  }

  ctx.spacer(8.0)
  ctx.separator()

  // 4. Live Telemetry
  let status_text = "Cursor: (\{mouse_x.to_int()}, \{mouse_y.to_int()}) | Down: \{mouse_down}"
  let _ = ctx.label(status_text)

  ctx.end_frame()
}

///|
fn main {
  let dl = step(100.0, 50.0, false)
  println("Canvas demo initialized, emitted \{dl.len()} commands.")
}
