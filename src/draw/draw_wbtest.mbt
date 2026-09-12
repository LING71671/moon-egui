///|
test "drawlist command accumulation and clear" {
  let dl = DrawList::new()
  assert_true(dl.is_empty())
  assert_eq(dl.len(), 0)

  dl.add_rect(
    @math.Rect::new(10.0, 10.0, 50.0, 20.0),
    @color.Color::white(),
    4.0,
  )
  dl.add_line(
    @math.Vec2::new(0.0, 0.0),
    @math.Vec2::new(100.0, 100.0),
    @color.Color::accent_primary(),
    2.0,
  )
  assert_eq(dl.len(), 2)
  assert_true(!dl.is_empty())

  let cmd0 = dl.get_command(0)
  assert_true(cmd0 is Some(DrawCmd::Rect(_)))

  dl.clear()
  assert_eq(dl.len(), 0)
  assert_true(dl.is_empty())
}

///|
test "drawlist linear gradient command" {
  let dl = DrawList::new()
  dl.add_linear_gradient(
    @math.Rect::new(0.0, 0.0, 100.0, 50.0),
    @math.Vec2::new(0.0, 0.0),
    @math.Vec2::new(100.0, 0.0),
    @color.Color::accent_primary(),
    @color.Color::accent_pressed(),
    8.0,
  )
  assert_eq(dl.len(), 1)
  let cmd = dl.get_command(0)
  assert_true(cmd is Some(DrawCmd::LinearGradient(_)))
}
