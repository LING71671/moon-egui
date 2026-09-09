///|
test "integration: full immediate-mode gui frame lifecycle" {
  // 1. Initialize UIContext
  let ctx = @core.UIContext::new()
  assert_eq(ctx.available_width(), 800.0)

  // 2. Begin frame with simulated mouse pointer at (50, 15)
  let raw_input = @core.RawInput::from_mouse(@math.Vec2::new(50.0, 15.0), false)
  ctx.begin_frame(raw_input)

  // 3. Allocate space for Button 1 (size: 120 x 36)
  let (id1, rect1, resp1) = ctx.allocate_space(@math.Vec2::new(120.0, 36.0))
  assert_eq(rect1.x, 0.0)
  assert_eq(rect1.y, 0.0)
  assert_eq(rect1.w, 120.0)
  assert_eq(rect1.h, 36.0)
  assert_true(resp1.hovered)
  assert_true(!resp1.clicked)
  assert_true(!resp1.pressed)
  assert_eq(ctx.hot_id(), id1)

  // 4. Render button based on interaction state
  let bg_color = if resp1.hovered {
    @color.Color::accent_hover()
  } else {
    @color.Color::accent_primary()
  }
  let dl = ctx.draw_list()
  dl.add_rect(rect1, bg_color, 6.0)
  dl.add_text(
    @math.Vec2::new(rect1.x + 12.0, rect1.y + 10.0),
    "Click Me",
    14.0,
    @color.Color::white(),
  )
  assert_eq(dl.len(), 2)

  // 5. Cursor should have advanced downwards by 36 + 8 = 44
  assert_eq(ctx.cursor().y, 44.0)

  // 6. Allocate space for Button 2
  let (id2, rect2, resp2) = ctx.allocate_space(@math.Vec2::new(120.0, 36.0))
  assert_eq(rect2.y, 44.0)
  assert_true(!resp2.hovered)
  assert_true(id1.val != id2.val)

  // 7. End frame and retrieve draw list
  let final_drawlist = ctx.end_frame()
  assert_eq(final_drawlist.len(), 2)
  let cmd0 = final_drawlist.get_command(0)
  assert_true(cmd0 is Some(@draw.DrawCmd::Rect(_)))
}

///|
test "integration: facade re-exports verification" {
  let v : @gui.Vec2 = @math.Vec2::new(10.0, 20.0)
  assert_eq(v.x, 10.0)
  let r : @gui.Rect = @math.Rect::new(0.0, 0.0, 100.0, 50.0)
  assert_eq(r.w, 100.0)
  let c : @gui.Color = @color.Color::rgb(255, 0, 0)
  assert_eq(c.r, 255)
}

///|
test "integration: geometry scissor clipping math" {
  let window_rect = @math.Rect::new(100.0, 100.0, 400.0, 300.0)
  let child = @math.Rect::new(450.0, 350.0, 100.0, 100.0)

  // Scissor clip calculation
  let clipped_rect = window_rect.intersect(child)
  assert_eq(clipped_rect.x, 450.0)
  assert_eq(clipped_rect.y, 350.0)
  assert_eq(clipped_rect.w, 50.0)
  assert_eq(clipped_rect.h, 50.0)
}

///|
test "integration: color palette and hex parsing" {
  let c1 = @color.Color::hex(0x3B82F6)
  assert_eq(c1.r, 59)
  assert_eq(c1.g, 130)
  assert_eq(c1.b, 246)
  assert_eq(c1.a, 255)

  let c2 = @color.Color::accent_primary()
  assert_eq(c2.r, 78)
  assert_eq(c2.g, 117)
  assert_eq(c2.b, 255)

  let blended = c1.lerp(@color.Color::white(), 0.5)
  assert_eq(blended.r, 157)
  assert_eq(blended.g, 192)
  assert_eq(blended.b, 250)
}
