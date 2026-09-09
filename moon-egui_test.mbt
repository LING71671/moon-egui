///|
test "blackbox public api smoke test" {
  let ctx = @moon-egui.UIContext::new()
  let raw = @moon-egui.RawInput::from_mouse(
    @moon-egui.Vec2::new(10.0, 10.0),
    false,
  )
  ctx.begin_frame(raw)
  let (id, rect, resp) = ctx.allocate_space(@moon-egui.Vec2::new(100.0, 25.0))
  assert_true(resp.hovered())
  assert_true(id.is_valid())
  assert_eq(rect.w, 100.0)

  let dl = ctx.draw_list()
  dl.add_rect(rect, @moon-egui.Color::accent_primary(), 4.0)
  let result = ctx.end_frame()
  assert_eq(result.len(), 1)
}
