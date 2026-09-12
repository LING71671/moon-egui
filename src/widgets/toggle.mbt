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
/// Standalone checkbox toggle widget supporting fluent configuration.
pub struct Checkbox {
  text : String
  checked : Bool
} derive(Eq, Debug)

///|
/// Create a new checkbox widget.
pub fn Checkbox::new(text : String, checked : Bool) -> Checkbox {
  { text, checked, }
}

///|
/// Reference-bound checkbox widget for uniform `ui.add(...)` dispatch.
pub struct CheckboxRef {
  text : String
  target : Ref[Bool]
}

///|
/// Create a checkbox bound directly to a `Ref[Bool]`.
pub fn Checkbox::from_ref(text : String, target : Ref[Bool]) -> CheckboxRef {
  { text, target, }
}

///|
pub impl @core.Widget for CheckboxRef with fn ui(self, ctx : UIContext) -> Response {
  let (new_state, resp) = Checkbox::new(self.text, self.target.val).show(ctx)
  self.target.val = new_state
  resp
}

///|
/// Render the checkbox and return the updated checked state and interaction response.
pub fn Checkbox::show(self : Checkbox, ctx : UIContext) -> (Bool, Response) {
  let scale = ctx.style.scale
  let box_size = 18.0 * scale
  let gap = ctx.style.spacing_sm * scale
  let font_nm = ctx.style.font_normal * scale
  let text_size = ctx.measure_text(self.text, font_nm)
  let w = box_size + gap + text_size.x
  let h = (ctx.style.control_h_sm - ctx.style.radius_xs) * scale
  let (id, rect, resp) = ctx.allocate_space(@math.Vec2::new(w, h))
  ctx.register_focusable(id)
  if resp.hovered {
    ctx.set_cursor_icon("pointer")
  }
  let new_state = if resp.clicked { !self.checked } else { self.checked }

  let box_rect = @math.Rect::new(
    rect.x,
    rect.y + (h - box_size) * 0.5,
    box_size,
    box_size,
  )

  let radius = ctx.style.radius_sm * scale
  if self.checked {
    ctx.painter().add_rect(box_rect, @color.Color::accent_primary(), radius)
    let stroke_color = if resp.has_focus() {
      @color.Color::border_focus()
    } else {
      @color.Color::accent_pressed()
    }
    let stroke_w = if resp.has_focus() { 1.5 * scale } else { 1.0 }
    ctx.painter().add_rect_stroke(box_rect, stroke_color, stroke_w, radius)
    let inner = box_rect.shrink(4.0 * scale)
    ctx.painter().add_rect(inner, @color.Color::text_inverse(), 2.0 * scale)
  } else {
    let box_bg = if resp.hovered {
      @color.Color::bg_subtle()
    } else {
      @color.Color::bg_window()
    }
    let box_border = if resp.has_focus() {
      @color.Color::border_focus()
    } else if resp.hovered {
      @color.Color::accent_primary()
    } else {
      @color.Color::border_default()
    }
    let stroke_w = if resp.has_focus() { 1.5 * scale } else { 1.0 }
    ctx.painter().add_rect(box_rect, box_bg, radius)
    ctx.painter().add_rect_stroke(box_rect, box_border, stroke_w, radius)
  }

  let text_x = rect.x + box_size + gap
  let text_y = rect.y + (h - font_nm) * 0.5
  let text_color = if resp.hovered {
    @color.Color::text_primary()
  } else {
    @color.Color::text_body()
  }
  ctx
  .painter()
  .add_text(@math.Vec2::new(text_x, text_y), self.text, font_nm, text_color)

  (new_state, resp)
}

///|
/// Render an interactive toggle checkbox.
pub fn checkbox(
  ctx : UIContext,
  text : String,
  checked : Bool,
) -> (Bool, Response) {
  Checkbox::new(text, checked).show(ctx)
}

///|
/// Standalone radio button option widget supporting fluent configuration.
pub struct Radio {
  label : String
  selected : Bool
} derive(Eq, Debug)

///|
/// Create a new radio button widget.
pub fn Radio::new(label : String, selected : Bool) -> Radio {
  { label, selected, }
}

///|
/// Render the radio button option.
pub fn Radio::show(self : Radio, ctx : UIContext) -> (Bool, Response) {
  let scale = ctx.style.scale
  let circle_r = 7.0 * scale
  let gap = ctx.style.spacing_sm * scale
  let font_nm = ctx.style.font_normal * scale
  let text_size = ctx.measure_text(self.label, font_nm)
  let total_w = circle_r * 2.0 + gap + text_size.x
  let total_h = (ctx.style.control_h_sm - ctx.style.radius_xs) * scale
  let (id, rect, resp) = ctx.allocate_space(@math.Vec2::new(total_w, total_h))
  if resp.hovered {
    ctx.set_cursor_icon("pointer")
  }
  ctx.register_focusable(id)

  let new_selected = if resp.clicked() { true } else { self.selected }

  let center = @math.Vec2::new(
    rect.x + circle_r + 1.0 * scale,
    rect.y + total_h * 0.5,
  )

  let outer_color = if resp.has_focus() || self.selected {
    @color.Color::accent_primary()
  } else if resp.hovered {
    @color.Color::accent_primary()
  } else {
    @color.Color::border_default()
  }

  let bg_circle_color = if resp.hovered {
    @color.Color::bg_subtle()
  } else {
    @color.Color::bg_window()
  }

  ctx.painter().add_circle(center, circle_r, bg_circle_color)
  ctx.painter().add_circle_stroke(center, circle_r, outer_color, 1.5 * scale)

  if self.selected {
    ctx
    .painter()
    .add_circle(center, circle_r * 0.5, @color.Color::accent_primary())
  }

  let text_pos = @math.Vec2::new(
    rect.x + circle_r * 2.0 + gap + 1.0 * scale,
    rect.y + (total_h - font_nm) * 0.5,
  )
  let text_color = if resp.hovered {
    @color.Color::text_primary()
  } else {
    @color.Color::text_body()
  }
  ctx.painter().add_text(text_pos, self.label, font_nm, text_color)

  (new_selected, resp)
}

///|
/// Render an interactive radio button option.
pub fn radio(
  ctx : UIContext,
  label : String,
  selected : Bool,
) -> (Bool, Response) {
  Radio::new(label, selected).show(ctx)
}

///|
/// Standalone toggle switch pill widget supporting fluent configuration.
pub struct Toggle {
  text : String
  checked : Bool
} derive(Eq, Debug)

///|
/// Create a new toggle switch pill widget.
pub fn Toggle::new(text : String, checked : Bool) -> Toggle {
  { text, checked, }
}

///|
/// Reference-bound toggle switch widget for uniform `ui.add(...)` dispatch.
pub struct ToggleRef {
  text : String
  target : Ref[Bool]
}

///|
/// Create a toggle switch bound directly to a `Ref[Bool]`.
pub fn Toggle::from_ref(text : String, target : Ref[Bool]) -> ToggleRef {
  { text, target, }
}

///|
pub impl @core.Widget for ToggleRef with fn ui(self, ctx : UIContext) -> Response {
  let (new_state, resp) = Toggle::new(self.text, self.target.val).show(ctx)
  self.target.val = new_state
  resp
}

///|
/// Render the toggle switch pill and return updated checked state alongside interaction response.
pub fn Toggle::show(self : Toggle, ctx : UIContext) -> (Bool, Response) {
  let scale = ctx.style.scale
  let font_nm = ctx.style.font_normal * scale
  let switch_w = 36.0 * scale
  let switch_h = 20.0 * scale
  let gap = ctx.style.spacing_sm * scale
  let text_size = ctx.measure_text(self.text, font_nm)
  let total_w = switch_w + gap + text_size.x
  let h = ctx.style.control_h_sm * scale
  let (id, rect, resp) = ctx.allocate_space(@math.Vec2::new(total_w, h))
  ctx.register_focusable(id)
  if resp.hovered {
    ctx.set_cursor_icon("pointer")
  }
  let new_state = if resp.clicked { !self.checked } else { self.checked }

  let switch_rect = @math.Rect::new(
    rect.x,
    rect.y + (h - switch_h) * 0.5,
    switch_w,
    switch_h,
  )

  let bg_color = if self.checked {
    if resp.hovered {
      @color.Color::accent_pressed()
    } else {
      @color.Color::accent_primary()
    }
  } else if resp.hovered {
    @color.Color::border_default()
  } else {
    @color.Color::border_muted()
  }

  ctx.painter().add_rect(switch_rect, bg_color, switch_h * 0.5)
  if resp.has_focus() {
    ctx
    .painter()
    .add_rect_stroke(
      switch_rect,
      @color.Color::border_focus(),
      1.5 * scale,
      switch_h * 0.5,
    )
  }

  let thumb_radius = (switch_h - 4.0 * scale) * 0.5
  let thumb_cx = if self.checked {
    switch_rect.x + switch_w - 2.0 * scale - thumb_radius
  } else {
    switch_rect.x + 2.0 * scale + thumb_radius
  }
  let thumb_cy = switch_rect.y + switch_h * 0.5
  let thumb_rect = @math.Rect::new(
    thumb_cx - thumb_radius,
    thumb_cy - thumb_radius,
    thumb_radius * 2.0,
    thumb_radius * 2.0,
  )
  ctx.painter().add_rect(thumb_rect, @color.Color::bg_window(), thumb_radius)

  let text_x = rect.x + switch_w + gap
  let text_y = rect.y + (h - font_nm) * 0.5
  let text_color = if resp.hovered {
    @color.Color::text_primary()
  } else {
    @color.Color::text_body()
  }
  ctx
  .painter()
  .add_text(@math.Vec2::new(text_x, text_y), self.text, font_nm, text_color)

  (new_state, resp)
}

///|
/// Render an interactive toggle pill switch.
pub fn toggle(
  ctx : UIContext,
  text : String,
  checked : Bool,
) -> (Bool, Response) {
  Toggle::new(text, checked).show(ctx)
}
