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
/// Cardinal placement direction for floating tooltips.
pub(all) enum TooltipPlacement {
  Top
  Bottom
  Left
  Right
} derive(Eq, Debug)

///|
/// Component-level style configuration for tooltips, derived from foundational design tokens.
pub struct TooltipStyle {
  padding_x : Double
  padding_y : Double
  corner_radius : Double
  font_size : Double
  offset : Double
  delay_frames : Int
} derive(Eq, Debug)

///|
/// Derives the standard tooltip style from the active UIContext widget style tokens.
pub fn TooltipStyle::default_for(style : @core.WidgetStyle) -> TooltipStyle {
  let scale = style.scale
  {
    padding_x: style.spacing_sm * scale,
    padding_y: style.spacing_xs * scale,
    corner_radius: style.radius_sm * scale,
    font_size: style.font_small * scale,
    offset: (style.spacing_xs + 2.0) * scale,
    delay_frames: 6,
  }
}

///|
/// Tooltip widget providing floating contextual hints on hover with delayed revelation.
pub struct Tooltip {
  text : String
  mut placement_val : TooltipPlacement
  mut custom_style : TooltipStyle?
  mut delay_frames_val : Int
} derive(Eq, Debug)

///|
pub fn Tooltip::new(text : String) -> Tooltip {
  { text, placement_val: Top, custom_style: None, delay_frames_val: 6, }
}

///|
pub fn Tooltip::placement(self : Tooltip, p : TooltipPlacement) -> Tooltip {
  self.placement_val = p
  self
}

///|
pub fn Tooltip::delay(self : Tooltip, frames : Int) -> Tooltip {
  self.delay_frames_val = frames
  self
}

///|
pub fn Tooltip::style(self : Tooltip, s : TooltipStyle) -> Tooltip {
  self.custom_style = Some(s)
  self
}

///|
/// Helper to draw a tooltip box in the foreground layer at a given position.
fn render_tooltip_box(
  ctx : UIContext,
  rect : @math.Rect,
  text : String,
  style : TooltipStyle,
) -> Unit {
  ctx.begin_foreground()
  let p = ctx.painter()

  let radius = style.corner_radius
  let scale = ctx.style.scale

  // Drop shadow
  let shadow_rect = @math.Rect::new(
    rect.x,
    rect.y + 2.0 * scale,
    rect.w,
    rect.h,
  )
  p.add_rect(shadow_rect, @color.Color::shadow(), radius)

  // Surface fill & boundary
  p.add_rect(rect, @color.Color::tooltip_bg(), radius)
  p.add_rect_stroke(rect, @color.Color::tooltip_border(), 1.0 * scale, radius)

  // Label text
  let text_x = rect.x + style.padding_x
  let text_y = rect.y + style.padding_y
  p.add_text(
    @math.Vec2::new(text_x, text_y),
    text,
    style.font_size,
    @color.Color::text_inverse(),
  )

  ctx.end_foreground()
}

///|
/// Show the tooltip bubble at current cursor position (immediate or delayed).
pub fn Tooltip::show(self : Tooltip, ctx : UIContext) -> Unit {
  let style = match self.custom_style {
    Some(s) => s
    None => TooltipStyle::default_for(ctx.style)
  }

  let text_sz = ctx.measure_text(self.text, style.font_size)
  let tip_w = text_sz.x + style.padding_x * 2.0
  let tip_h = style.font_size + style.padding_y * 2.0

  let mouse = ctx.input.mouse_pos
  let scale = ctx.style.scale
  let mut tip_x = mouse.x + 12.0 * scale
  let mut tip_y = mouse.y + 12.0 * scale

  let clip_opt = ctx.current_clip()
  let vp_w = if ctx.available_width() > 0.0 {
    ctx.available_width()
  } else {
    match clip_opt {
      Some(c) => if c.w > 0.0 { c.x + c.w } else { 800.0 * scale }
      None => 800.0 * scale
    }
  }
  let vp_h = match clip_opt {
    Some(c) => if c.h > 0.0 { c.y + c.h } else { 600.0 * scale }
    None => 600.0 * scale
  }

  if tip_x + tip_w > vp_w {
    tip_x = mouse.x - tip_w - 4.0 * scale
    if tip_x < 4.0 * scale {
      tip_x = 4.0 * scale
    }
  }
  if tip_y + tip_h > vp_h {
    tip_y = mouse.y - tip_h - 4.0 * scale
    if tip_y < 4.0 * scale {
      tip_y = 4.0 * scale
    }
  }
  let tip_rect = @math.Rect::new(tip_x, tip_y, tip_w, tip_h)
  render_tooltip_box(ctx, tip_rect, self.text, style)
}

///|
/// Evaluates hover timing and renders the tooltip adjacent to target_rect if visible.
/// Returns true if the tooltip was displayed during the current frame.
pub fn Tooltip::show_for(
  self : Tooltip,
  ctx : UIContext,
  id : Id,
  target_rect : @math.Rect,
  is_hovered : Bool,
) -> Bool {
  let style = match self.custom_style {
    Some(s) => s
    None => TooltipStyle::default_for(ctx.style)
  }
  let delay = self.delay_frames_val

  // Retrieve persistent hover frame counter from Memory
  let prev_count = ctx.memory.get_int_or_default(id, 0, tag="tooltip_hover")
  let current_count = if is_hovered { prev_count + 1 } else { 0 }
  ctx.memory.set_int(id, current_count, tag="tooltip_hover")

  if current_count <= delay || !is_hovered {
    return false
  }

  // Measure content
  let font_sz = style.font_size
  let text_sz = ctx.measure_text(self.text, font_sz)
  let tip_w = text_sz.x + style.padding_x * 2.0
  let tip_h = font_sz + style.padding_y * 2.0

  // Viewport boundaries
  let scale = ctx.style.scale
  let clip_opt = ctx.current_clip()
  let vp_w = if ctx.available_width() > 0.0 {
    ctx.available_width()
  } else {
    match clip_opt {
      Some(c) => if c.w > 0.0 { c.x + c.w } else { 800.0 * scale }
      None => 800.0 * scale
    }
  }
  let vp_h = match clip_opt {
    Some(c) => if c.h > 0.0 { c.y + c.h } else { 600.0 * scale }
    None => 600.0 * scale
  }
  let edge_margin = 4.0 * scale

  // Compute position based on placement and boundary clamping
  let (raw_x, raw_y) = match self.placement_val {
    Top => {
      let x = target_rect.x + (target_rect.w - tip_w) * 0.5
      let y = target_rect.y - tip_h - style.offset
      if y < edge_margin {
        (x, target_rect.y + target_rect.h + style.offset)
      } else {
        (x, y)
      }
    }
    Bottom => {
      let x = target_rect.x + (target_rect.w - tip_w) * 0.5
      let y = target_rect.y + target_rect.h + style.offset
      if y + tip_h > vp_h - edge_margin {
        (x, target_rect.y - tip_h - style.offset)
      } else {
        (x, y)
      }
    }
    Left => {
      let x = target_rect.x - tip_w - style.offset
      let y = target_rect.y + (target_rect.h - tip_h) * 0.5
      if x < edge_margin {
        (target_rect.x + target_rect.w + style.offset, y)
      } else {
        (x, y)
      }
    }
    Right => {
      let x = target_rect.x + target_rect.w + style.offset
      let y = target_rect.y + (target_rect.h - tip_h) * 0.5
      if x + tip_w > vp_w - edge_margin {
        (target_rect.x - tip_w - style.offset, y)
      } else {
        (x, y)
      }
    }
  }

  // Clamp within screen boundaries
  let min_x = edge_margin
  let max_x = if vp_w > tip_w + edge_margin {
    vp_w - tip_w - edge_margin
  } else {
    edge_margin
  }
  let clamped_x = if raw_x < min_x {
    min_x
  } else if raw_x > max_x {
    max_x
  } else {
    raw_x
  }

  let min_y = edge_margin
  let max_y = if vp_h > tip_h + edge_margin {
    vp_h - tip_h - edge_margin
  } else {
    edge_margin
  }
  let clamped_y = if raw_y < min_y {
    min_y
  } else if raw_y > max_y {
    max_y
  } else {
    raw_y
  }

  let tip_rect = @math.Rect::new(clamped_x, clamped_y, tip_w, tip_h)
  render_tooltip_box(ctx, tip_rect, self.text, style)
  true
}

///|
/// Render an on-hover floating tooltip bubble at cursor position.
pub fn tooltip(ctx : UIContext, text : String) -> Unit {
  let tip = Tooltip::new(text).delay(0)
  tip.show(ctx)
}

///|
/// Fluent helper function to attach floating hover text to a Response.
pub fn on_hover_text(
  resp : Response,
  ctx : UIContext,
  text : String,
  placement? : TooltipPlacement = Top,
  delay_frames? : Int = 6,
) -> Response {
  let tip = Tooltip::new(text).placement(placement).delay(delay_frames)
  let _ = tip.show_for(ctx, resp.id, resp.rect, resp.hovered)
  resp
}

///|
/// Convenience helper function to display a tooltip for a specified target rect.
pub fn tooltip_for(
  ctx : UIContext,
  id_salt : String,
  target_rect : @math.Rect,
  is_hovered : Bool,
  text : String,
  placement? : TooltipPlacement = Top,
  delay_frames? : Int = 6,
) -> Bool {
  let id = ctx.id_stack.derive_id(id_salt)
  let tip = Tooltip::new(text).placement(placement).delay(delay_frames)
  tip.show_for(ctx, id, target_rect, is_hovered)
}
