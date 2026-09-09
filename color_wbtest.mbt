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
  let bg = Color::bg_app()
  assert_eq(bg.r, 0x11)
  assert_eq(bg.g, 0x11)
  assert_eq(bg.b, 0x16)

  let accent = Color::accent_primary()
  assert_eq(accent.r, 0x4E)
  assert_eq(accent.g, 0x75)
  assert_eq(accent.b, 0xFF)
}
