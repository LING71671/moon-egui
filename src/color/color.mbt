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
/// Studio Light porcelain design tokens.
///
/// These are the single source of truth for the library's palette. Widgets must
/// read colours from here instead of writing literal `rgb()` calls: the library
/// previously carried a dark token set that only `window()` and `progress_bar()`
/// consumed, while every other widget hard-coded light values of its own.
pub fn Color::bg_app() -> Color {
  Color::hex(0xF8FAFC)
}

///|
/// Floating surface: window body, cards, popup panels.
pub fn Color::bg_window() -> Color {
  Color::hex(0xFFFFFF)
}

///|
/// Secondary surface: window headers, recessed grooves, badge rests.
pub fn Color::bg_surface() -> Color {
  Color::hex(0xF1F5F9)
}

///|
/// Subtle wash: hover fills and row highlights.
pub fn Color::bg_subtle() -> Color {
  Color::hex(0xF8FAFC)
}

///|
pub fn Color::bg_hover() -> Color {
  Color::hex(0xF8FAFC)
}

///|
/// Pressed or more deeply recessed fill than `bg_surface`.
pub fn Color::bg_active() -> Color {
  Color::hex(0xE2E8F0)
}

///|
/// Inverse surface for overlays that sit on top of light content: tooltips and
/// floating hints, which pair with `text_inverse`.
pub fn Color::bg_inverse() -> Color {
  Color::hex(0x1A1B23)
}

///|
/// Hairline: internal dividers and control grooves.
pub fn Color::border_muted() -> Color {
  Color::hex(0xE2E8F0)
}

///|
/// Default control outline.
pub fn Color::border_default() -> Color {
  Color::hex(0xCBD5E1)
}

///|
/// Compressed or disabled outline.
pub fn Color::border_strong() -> Color {
  Color::hex(0x94A3B8)
}

///|
pub fn Color::border_focus() -> Color {
  Color::hex(0x2563EB)
}

///|
pub fn Color::text_primary() -> Color {
  Color::hex(0x0F172A)
}

///|
pub fn Color::text_strong() -> Color {
  Color::hex(0x1E293B)
}

///|
pub fn Color::text_body() -> Color {
  Color::hex(0x334155)
}

///|
pub fn Color::text_secondary() -> Color {
  Color::hex(0x475569)
}

///|
pub fn Color::text_muted() -> Color {
  Color::hex(0x64748B)
}

///|
pub fn Color::text_disabled() -> Color {
  Color::hex(0x94A3B8)
}

///|
/// Text drawn on `accent_primary` or `bg_inverse` surfaces.
pub fn Color::text_inverse() -> Color {
  Color::hex(0xFFFFFF)
}

///|
pub fn Color::accent_primary() -> Color {
  Color::hex(0x2563EB)
}

///|
pub fn Color::accent_hover() -> Color {
  Color::hex(0x3B82F6)
}

///|
pub fn Color::accent_pressed() -> Color {
  Color::hex(0x1D4ED8)
}

///|
/// Deepest accent step, used for borders under load.
pub fn Color::accent_deep() -> Color {
  Color::hex(0x1E3A8A)
}

///|
/// Translucent accent wash: focus rings and selection glows.
pub fn Color::accent_soft() -> Color {
  Color::rgba(37, 99, 235, 45)
}

///|
/// Translucent light overlay for details drawn on top of an accent fill.
pub fn Color::accent_highlight() -> Color {
  Color::rgba(255, 255, 255, 60)
}

///|
/// Elevation shadow under floating surfaces.
pub fn Color::shadow() -> Color {
  Color::rgba(15, 23, 42, 18)
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
