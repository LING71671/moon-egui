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
/// Standalone button widget struct supporting fluent configuration.
pub struct Button {
  text : String
  shortcut : String
  primary : Bool
  size : @math.Vec2
} derive(Eq, Debug)

///|
/// Create a new button widget with default styling.
pub fn Button::new(text : String) -> Button {
  { text, shortcut: "", primary: false, size: @math.Vec2::zero(), }
}

///|
/// Configure an Apple-grade chiclet keyboard shortcut badge (e.g. "⌘S", "Esc").
pub fn Button::shortcut(self : Button, shortcut : String) -> Button {
  { ..self, shortcut, }
}

///|
/// Configure button as high-contrast cold cobalt primary action.
pub fn Button::primary(self : Button, primary : Bool) -> Button {
  { ..self, primary, }
}

///|
/// Explicitly override the button's layout dimensions.
pub fn Button::size(self : Button, size : @math.Vec2) -> Button {
  { ..self, size, }
}

///|
/// Render the button into the provided UIContext.
pub impl @core.Widget for Button with fn ui(self, ctx : UIContext) -> Response {
  let scale = ctx.style.scale
  let font_size = ctx.style.font_normal * scale
  let text_size = ctx.measure_text(self.text, font_size)
  let text_w = text_size.x
  let has_shortcut = self.shortcut.length() > 0
  let kbd_font_size = ctx.style.font_small * scale
  let kbd_w = if has_shortcut {
    ctx.measure_text(self.shortcut, kbd_font_size).x + 14.0 * scale
  } else {
    0.0
  }

  let min_w = if has_shortcut { 88.0 * scale } else { 68.0 * scale }
  let pad_w = if has_shortcut {
    36.0 * scale
  } else {
    (ctx.style.spacing_sm + ctx.style.radius_md) * 2.0 * scale
  }
  let content_w = if has_shortcut {
    text_w + kbd_w + pad_w
  } else {
    text_w + pad_w
  }
  let auto_w = if content_w > min_w { content_w } else { min_w }
  let w = if self.size.x > 0.0 { self.size.x } else { auto_w }
  let h = if self.size.y > 0.0 {
    self.size.y
  } else {
    ctx.style.control_h_md * scale
  }

  let (id, rect, resp) = ctx.allocate_space(@math.Vec2::new(w, h))
  ctx.register_focusable(id)
  if resp.hovered {
    ctx.set_cursor_icon("pointer")
  }

  // 1.5px Mechanical Press Travel & Tactile Actuation Displacement
  let press_offset = if resp.pressed { 1.5 * scale } else { 0.0 }
  let draw_rect = @math.Rect::new(
    rect.x,
    rect.y + press_offset,
    rect.w,
    rect.h - press_offset,
  )

  // Studio Light Lunar Porcelain Palette
  let bg_color = if self.primary {
    if resp.pressed {
      @color.Color::accent_pressed() // Deep cobalt under load
    } else if resp.hovered {
      @color.Color::accent_hover() // Vibrant azure excitation
    } else {
      @color.Color::accent_primary() // Precision cold cobalt base
    }
  } else if resp.pressed {
    @color.Color::bg_surface() // Sunken active porcelain
  } else if resp.hovered {
    @color.Color::bg_subtle() // Floating porcelain highlight
  } else {
    @color.Color::bg_window() // Pure bone porcelain surface
  }

  let border_color = if resp.has_focus() {
    @color.Color::border_focus()
  } else if self.primary {
    if resp.pressed {
      @color.Color::accent_deep()
    } else {
      @color.Color::accent_pressed()
    }
  } else if resp.pressed {
    @color.Color::border_strong() // Compressed border
  } else if resp.hovered {
    @color.Color::accent_primary() // Precision cobalt halo
  } else {
    @color.Color::border_default() // Milled cold-slate hairline
  }

  let text_color = if self.primary {
    @color.Color::text_inverse()
  } else if resp.pressed {
    @color.Color::text_strong()
  } else if resp.hovered {
    @color.Color::text_primary()
  } else {
    @color.Color::text_body()
  }

  let painter = ctx.painter()
  let radius = ctx.style.radius_md * scale
  painter.add_rect(draw_rect, bg_color, radius)
  let stroke_w = if resp.has_focus() { 1.5 * scale } else { 1.0 }
  painter.add_rect_stroke(draw_rect, border_color, stroke_w, radius)

  if has_shortcut {
    // Left-align text when shortcut badge exists
    let text_x = draw_rect.x + 12.0 * scale
    let text_y = draw_rect.y + (draw_rect.h - font_size) * 0.5
    painter.add_text(
      @math.Vec2::new(text_x, text_y),
      self.text,
      font_size,
      text_color,
    )

    // Chiclet Shortcut Badge (synchronously moves down on press)
    let kbd_h = 18.0 * scale
    let kbd_rect = @math.Rect::new(
      draw_rect.x + draw_rect.w - kbd_w - 10.0 * scale,
      draw_rect.y + (draw_rect.h - kbd_h) * 0.5,
      kbd_w,
      kbd_h,
    )
    let (kbd_bg, kbd_col) = if self.primary {
      (@color.Color::accent_highlight(), @color.Color::text_inverse())
    } else {
      (
        if resp.pressed {
          @color.Color::border_muted()
        } else if resp.hovered {
          @color.Color::bg_active()
        } else {
          @color.Color::bg_surface()
        },
        if resp.hovered {
          @color.Color::text_primary()
        } else {
          @color.Color::text_muted()
        },
      )
    }
    painter.add_rect(kbd_rect, kbd_bg, ctx.style.radius_sm * scale)
    let sc_w = ctx.measure_text(self.shortcut, kbd_font_size).x
    let kbd_text_x = kbd_rect.x + (kbd_rect.w - sc_w) * 0.5
    let kbd_text_y = kbd_rect.y + (kbd_rect.h - kbd_font_size) * 0.5
    painter.add_text(
      @math.Vec2::new(kbd_text_x, kbd_text_y),
      self.shortcut,
      kbd_font_size,
      kbd_col,
    )
  } else {
    // Center-align text in standard button
    let text_x = draw_rect.x + (draw_rect.w - text_w) * 0.5
    let text_y = draw_rect.y + (draw_rect.h - font_size) * 0.5
    painter.add_text(
      @math.Vec2::new(text_x, text_y),
      self.text,
      font_size,
      text_color,
    )
  }

  resp
}

///|
/// Render an interactive button with modern Studio Light porcelain aesthetic and 1.5px physical mechanical actuation travel.
pub fn button(
  ctx : UIContext,
  text : String,
  shortcut? : String = "",
  primary? : Bool = false,
  size? : @math.Vec2 = @math.Vec2::zero(),
) -> Response {
  ctx.add(Button::new(text).shortcut(shortcut).primary(primary).size(size))
}

///|
/// Render an interactive button with an explicitly specified size.
pub fn button_sized(
  ctx : UIContext,
  text : String,
  size : @math.Vec2,
) -> Response {
  button(ctx, text, size~)
}

///|
/// Render an emphasized primary button with an explicitly specified size.
pub fn button_primary_sized(
  ctx : UIContext,
  text : String,
  size : @math.Vec2,
) -> Response {
  button(ctx, text, primary=true, size~)
}

///|
/// Render an emphasized call-to-action primary button using accent colors.
pub fn button_primary(ctx : UIContext, text : String) -> Response {
  button(ctx, text, primary=true)
}

///|
/// Render an interactive button with a desktop-grade shortcut badge (e.g. "⌘S" or "Esc").
pub fn button_with_shortcut(
  ctx : UIContext,
  text : String,
  shortcut : String,
) -> Response {
  button(ctx, text, shortcut~)
}

///|
/// Render an interactive color preview button.
pub fn color_button(
  ctx : UIContext,
  _id_str : String,
  color : @color.Color,
) -> (Bool, Response) {
  let size = 22.0
  let (_id, rect, resp) = ctx.allocate_space(@math.Vec2::new(size, size))
  if resp.hovered {
    ctx.set_cursor_icon("pointer")
  }

  let press_offset = if resp.pressed { 1.0 } else { 0.0 }
  let btn_rect = @math.Rect::new(
    rect.x,
    rect.y + press_offset,
    size,
    size - press_offset,
  )
  let border_color = if resp.pressed {
    @color.Color::accent_primary()
  } else if resp.hovered {
    @color.Color::accent_primary()
  } else {
    @color.Color::border_default()
  }

  // Draw color swatch with clean white rim
  let swatch_radius = ctx.style.radius_md * ctx.style.scale
  let p = ctx.painter()
  p.add_rect(btn_rect, color, swatch_radius)
  p.add_rect_stroke(btn_rect, border_color, 1.5, swatch_radius)

  (resp.clicked, resp)
}
