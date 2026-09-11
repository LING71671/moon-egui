///|
test "color creation and hex parsing" {
  let c1 = Color::rgb(10, 20, 30)
  assert_eq(c1.r, 10)
  assert_eq(c1.g, 20)
  assert_eq(c1.b, 30)
  assert_eq(c1.a, 255)

  let c2 = Color::rgba(100, 150, 200, 128)
  assert_eq(c2.r, 100)
  assert_eq(c2.g, 150)
  assert_eq(c2.b, 200)
  assert_eq(c2.a, 128)

  // Hex decoding
  let c_hex = Color::hex(0x112233)
  assert_eq(c_hex.r, 0x11)
  assert_eq(c_hex.g, 0x22)
  assert_eq(c_hex.b, 0x33)
  assert_eq(c_hex.a, 255)

  let c_hex_alpha = Color::hex_alpha(0x11223344)
  assert_eq(c_hex_alpha.r, 0x11)
  assert_eq(c_hex_alpha.g, 0x22)
  assert_eq(c_hex_alpha.b, 0x33)
  assert_eq(c_hex_alpha.a, 0x44)

  // Alpha override
  let c_alpha = c1.with_alpha(100)
  assert_eq(c_alpha.a, 100)
  assert_eq(c_alpha.r, 10)
}

///|
test "color linear interpolation (lerp)" {
  let black = Color::rgb(0, 0, 0)
  let white = Color::rgb(200, 200, 200)

  let mid = black.lerp(white, 0.5)
  assert_eq(mid.r, 100)
  assert_eq(mid.g, 100)
  assert_eq(mid.b, 100)

  let at_start = black.lerp(white, 0.0)
  assert_eq(at_start.r, 0)

  let at_end = black.lerp(white, 1.0)
  assert_eq(at_end.r, 200)
}

///|
test "theme design tokens" {
  // Studio Light porcelain: the token set is light, and color.mbt is the only
  // place in the library where the palette is defined.
  let bg = Color::bg_app()
  assert_eq(bg.r, 0xF8)
  assert_eq(bg.g, 0xFA)
  assert_eq(bg.b, 0xFC)

  let accent = Color::accent_primary()
  assert_eq(accent.r, 0x25)
  assert_eq(accent.g, 0x63)
  assert_eq(accent.b, 0xEB)

  // The window chrome must match the widgets it hosts, otherwise a window on a
  // light canvas renders dark.
  let surface = Color::bg_window()
  assert_eq(surface.r, 0xFF)
  assert_eq(surface.g, 0xFF)
  assert_eq(surface.b, 0xFF)

  let text = Color::text_primary()
  assert_eq(text.r, 0x0F)
  assert_eq(text.g, 0x17)
  assert_eq(text.b, 0x2A)

  // Overlays stay dark so they keep contrast against light content.
  let inverse = Color::bg_inverse()
  assert_eq(inverse.r, 0x1A)
  assert_eq(inverse.g, 0x1B)
  assert_eq(inverse.b, 0x23)

  // Semantic layer tokens
  let scrim = Color::bg_scrim()
  assert_eq(scrim.r, 15)
  assert_eq(scrim.g, 23)
  assert_eq(scrim.b, 42)
  assert_eq(scrim.a, 115)

  let pill = Color::pill_active_bg()
  assert_eq(pill.r, 255)
  assert_eq(pill.g, 255)
  assert_eq(pill.b, 255)

  let tree_sel = Color::tree_row_selected()
  assert_eq(tree_sel.r, 0xEF)
  assert_eq(tree_sel.g, 0xF6)
  assert_eq(tree_sel.b, 0xFF)

  let tag_hover = Color::tag_close_hover()
  assert_eq(tag_hover.a, 25)
}
