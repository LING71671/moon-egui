///|
/// Entry point for runnable demo.
/// Run with `moon run cmd/main` from the project root.
fn main {
  let ctx = @core.UIContext::new()
  let raw = @core.RawInput::from_mouse(@math.Vec2::new(30.0, 55.0), false)
  ctx.begin_frame(raw)

  // Declarative immediate-mode UI frame
  let _ = ctx.label("=== Moon-EGUI Control Panel ===")
  ctx.separator()
  let btn = ctx.button("Launch System")
  let pbtn = ctx.button_primary("Deploy Wasm")
  let (fullscreen, chk_resp) = ctx.checkbox("Enable Fullscreen", false)
  let dl = ctx.end_frame()

  println("=== Moon-EGUI v0.2.0 Interactive Frame ===")
  println("Label rendered: Control Panel")
  println("Button 'Launch System' hovered: \{btn.hovered()}")
  println("Button 'Deploy Wasm' hovered: \{pbtn.hovered()}")
  println(
    "Checkbox 'Enable Fullscreen' state: \{fullscreen}, hovered: \{chk_resp.hovered()}",
  )
  println("Total Draw Commands Generated: \{dl.len()}")
}
