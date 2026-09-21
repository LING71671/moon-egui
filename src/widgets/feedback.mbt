// Copyright 2026 Ling71671
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

///|
/// Standalone progress bar widget supporting fluent configuration.
pub struct ProgressBar {
  fraction : Double
  text : String
} derive(Eq, Debug)

///|
/// Create a new progress bar widget with a normalized 0.0-1.0 fraction.
pub fn ProgressBar::new(fraction : Double) -> ProgressBar {
  { fraction, text: "", }
}

///|
/// Set custom display label text (defaults to percentage if empty).
pub fn ProgressBar::text(self : ProgressBar, text : String) -> ProgressBar {
  { ..self, text, }
}

///|
/// Render the progress bar into the provided UIContext.
pub impl @core.Widget for ProgressBar with fn ui(self, ctx : UIContext) -> Response {
  progress_bar(ctx, self.fraction, text=self.text)
}

///|
/// Render a styled progress bar with progress fill and label.
pub fn progress_bar(
  ctx : UIContext,
  fraction : Double,
  text? : String = "",
) -> Response {
  let scale = ctx.style.scale
  let w = ctx.available_width()
  let h = (ctx.style.control_h_sm - ctx.style.radius_md) * scale
  let (_id, rect, resp) = ctx.allocate_space(@math.Vec2::new(w, h))

  let clamped_pct = if fraction.is_nan() || fraction < 0.0 {
    0.0
  } else if fraction > 1.0 {
    1.0
  } else {
    fraction
  }

  let bar_radius = ctx.style.radius_sm * scale
  let p = ctx.painter()
  p.add_rect(rect, @color.Color::bg_surface(), bar_radius)
  p.add_rect_stroke(rect, @color.Color::border_muted(), 1.0 * scale, bar_radius)

  let fill_w = rect.w * clamped_pct
  if fill_w > 0.0 {
    let fill_rect = @math.Rect::new(rect.x, rect.y, fill_w, rect.h)
    p.add_rect(fill_rect, @color.Color::accent_primary(), bar_radius)
  }

  let display_text = if text.is_empty() {
    (clamped_pct * 100.0).to_int().to_string() + "%"
  } else {
    text
  }

  let font_sz = ctx.style.font_small * scale
  let text_size = ctx.measure_text(display_text, font_sz)
  let text_x = rect.x + (rect.w - text_size.x) * 0.5
  let text_y = rect.y + (rect.h - font_sz) * 0.5
  let text_color = if clamped_pct >= 0.5 {
    @color.Color::text_inverse()
  } else {
    @color.Color::text_primary()
  }
  p.add_text(@math.Vec2::new(text_x, text_y), display_text, font_sz, text_color)

  resp
}
