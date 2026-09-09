///|
/// Entry point for runnable demo.
/// Run with `moon run cmd/main` from the project root.
fn main {
  let ctx = @core.UIContext::new()
  let raw = @core.RawInput::from_mouse(@math.Vec2::new(10.0, 10.0), false)
  ctx.begin_frame(raw)
  let (_id, rect, resp) = ctx.allocate_space(@math.Vec2::new(100.0, 30.0))
  let dl = ctx.end_frame()
  println("moon-egui initialized successfully!")
  println(
    "Allocated rect: \{rect.w}x\{rect.h}, hovered: \{resp.hovered}, draw commands: \{dl.len()}",
  )
}
