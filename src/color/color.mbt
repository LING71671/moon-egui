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

///|
/// Destructive action button hover fill.
pub fn Color::danger_hover() -> Color {
  Color::rgba(239, 68, 68, 220)
}

///|
/// Modal backdrop blocking layer.
pub fn Color::bg_scrim() -> Color {
  Color::rgba(15, 23, 42, 115)
}

///|
/// Ambient soft elevation shadow.
pub fn Color::shadow_ambient() -> Color {
  Color::rgba(15, 23, 42, 30)
}

///|
/// Key directional elevation shadow.
pub fn Color::shadow_key() -> Color {
  Color::rgba(15, 23, 42, 45)
}

///|
/// Surface fill for active segmented control pill.
pub fn Color::pill_active_bg() -> Color {
  Color::hex(0xFFFFFF)
}

///|
/// Subtle border outline for active segmented control pill.
pub fn Color::pill_active_border() -> Color {
  Color::rgba(203, 213, 225, 120)
}

///|
/// Ambient micro-shadow under active segmented pill.
pub fn Color::pill_ambient_shadow() -> Color {
  Color::rgba(15, 23, 42, 35)
}

///|
/// Subtle wash overlay for item hover.
pub fn Color::wash_hover() -> Color {
  Color::rgba(248, 250, 252, 60)
}

///|
/// Semantic badge wash backgrounds.
pub fn Color::badge_info_bg() -> Color {
  Color::rgba(37, 99, 235, 150)
}

///|
pub fn Color::badge_warning_bg() -> Color {
  Color::rgba(245, 158, 11, 40)
}

///|
pub fn Color::badge_danger_bg() -> Color {
  Color::rgba(239, 68, 68, 40)
}

///|
/// Selection wash for active tree view node.
pub fn Color::tree_row_selected() -> Color {
  Color::hex(0xEFF6FF)
}

///|
/// Selection fill for active table row.
pub fn Color::table_row_selected() -> Color {
  Color::rgba(37, 99, 235, 100)
}

///|
/// Low-contrast border for recessed grooves and spinner tracks.
pub fn Color::border_track() -> Color {
  Color::rgba(226, 232, 240, 150)
}

///|
/// Subtle background wash for sparkline graphs.
pub fn Color::sparkline_wash() -> Color {
  Color::rgba(248, 250, 252, 80)
}

///|
/// Area wash overlay for charts and sparkline plots.
pub fn Color::area_wash(base : Color) -> Color {
  { r: base.r, g: base.g, b: base.b, a: 30, }
}

///|
pub fn Color::badge_success_bg() -> Color {
  Color::hex(0xF0FDF4)
}

///|
pub fn Color::badge_success_border() -> Color {
  Color::hex(0xBBF7D0)
}

///|
pub fn Color::badge_success_text() -> Color {
  Color::hex(0x166534)
}

///|
pub fn Color::badge_warning_border() -> Color {
  Color::hex(0xFEF08A)
}

///|
pub fn Color::badge_warning_text() -> Color {
  Color::hex(0x854D0E)
}

///|
pub fn Color::badge_danger_border() -> Color {
  Color::hex(0xFECACA)
}

///|
pub fn Color::badge_danger_text() -> Color {
  Color::hex(0x991B1B)
}

///|
pub fn Color::badge_info_border() -> Color {
  Color::hex(0xBFDBFE)
}

///|

///|
pub fn Color::badge_info_text() -> Color {
  Color::hex(0x1E40AF)
}

///|
/// Subtle wash for tag and badge close button hover.
pub fn Color::tag_close_hover() -> Color {
  Color::rgba(15, 23, 42, 25)
}
