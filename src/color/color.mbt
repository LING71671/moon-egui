///|
pub struct Color {
  r : Int
  g : Int
  b : Int
  a : Int
} derive(Eq, Debug, Default)

///|
pub fn Color::rgb(r : Int, g : Int, b : Int) -> Color {
  { r, g, b, a: 255, }
}

///|
pub fn Color::rgba(r : Int, g : Int, b : Int, a : Int) -> Color {
  { r, g, b, a, }
}

///|
pub fn Color::hex(code : Int) -> Color {
  let r = (code >> 16) & 0xFF
  let g = (code >> 8) & 0xFF
  let b = code & 0xFF
  { r, g, b, a: 255, }
}

///|
pub fn Color::hex_alpha(code : Int) -> Color {
  let r = (code >> 24) & 0xFF
  let g = (code >> 16) & 0xFF
  let b = (code >> 8) & 0xFF
  let a = code & 0xFF
  { r, g, b, a, }
}

///|
pub fn Color::with_alpha(self : Color, a : Int) -> Color {
  { r: self.r, g: self.g, b: self.b, a, }
}

///|
pub fn Color::lerp(self : Color, other : Color, t : Double) -> Color {
  let clamp_t = if t < 0.0 { 0.0 } else if t > 1.0 { 1.0 } else { t }
  let r = (self.r.to_double() + (other.r - self.r).to_double() * clamp_t).to_int()
  let g = (self.g.to_double() + (other.g - self.g).to_double() * clamp_t).to_int()
  let b = (self.b.to_double() + (other.b - self.b).to_double() * clamp_t).to_int()
  let a = (self.a.to_double() + (other.a - self.a).to_double() * clamp_t).to_int()
  { r, g, b, a, }
}

///|
pub fn Color::transparent() -> Color {
  { r: 0, g: 0, b: 0, a: 0, }
}

///|
pub fn Color::black() -> Color {
  { r: 0, g: 0, b: 0, a: 255, }
}

///|
pub fn Color::white() -> Color {
  { r: 255, g: 255, b: 255, a: 255, }
}

///|
pub fn Color::bg_app() -> Color {
  Color::hex(0x111116)
}

///|
pub fn Color::bg_window() -> Color {
  Color::hex(0x1A1B23)
}

///|
pub fn Color::bg_surface() -> Color {
  Color::hex(0x232530)
}

///|
pub fn Color::bg_hover() -> Color {
  Color::hex(0x2D303E)
}

///|
pub fn Color::bg_active() -> Color {
  Color::hex(0x393D4F)
}

///|
pub fn Color::border_muted() -> Color {
  Color::hex(0x2E303D)
}

///|
pub fn Color::border_focus() -> Color {
  Color::hex(0x5C617B)
}

///|
pub fn Color::text_primary() -> Color {
  Color::hex(0xEEEEF2)
}

///|
pub fn Color::text_secondary() -> Color {
  Color::hex(0xC4C7D7)
}

///|
pub fn Color::text_muted() -> Color {
  Color::hex(0x9497A8)
}

///|
pub fn Color::accent_primary() -> Color {
  Color::hex(0x4E75FF)
}

///|
pub fn Color::accent_hover() -> Color {
  Color::hex(0x6689FF)
}

///|
pub fn Color::success() -> Color {
  Color::hex(0x22C55E)
}

///|
pub fn Color::warning() -> Color {
  Color::hex(0xF59E0B)
}

///|
pub fn Color::danger() -> Color {
  Color::hex(0xEF4444)
}
