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
/// Semantic intent category of dialog modal.
pub(all) enum DialogKind {
  Info
  Warning
  Danger
  Confirm
} derive(Eq, Debug)

///|
pub fn DialogKind::info() -> DialogKind {
  Info
}

///|
pub fn DialogKind::warning() -> DialogKind {
  Warning
}

///|
pub fn DialogKind::danger() -> DialogKind {
  Danger
}

///|
pub fn DialogKind::confirm() -> DialogKind {
  Confirm
}

///|
/// Result returned from dialog interaction on the current frame.
pub(all) enum DialogResult {
  Confirmed
  Cancelled
  Open
} derive(Eq, Debug)

///|
fn wrap_dialog_message(
  ctx : UIContext,
  message : String,
  max_w : Double,
  font_size : Double,
) -> Array[String] {
  let lines : Array[String] = []
  let raw_paragraphs = message.split("\n")
  for p in raw_paragraphs {
    let p_str = p.to_owned()
    if p_str.is_empty() {
      lines.push("")
      continue
    }
    let mut cur = ""
    let mut i = 0
    let len = p_str.length()
    while i < len {
      let next_i = @core.next_char_boundary(p_str, i)
      let ch = @core.string_slice(p_str, i, next_i)
      let test_str = cur + ch
      let w = ctx.measure_text(test_str, font_size).x
      if w > max_w && !cur.is_empty() {
        lines.push(cur)
        cur = ch
      } else {
        cur = test_str
      }
      i = next_i
    }
    if !cur.is_empty() {
      lines.push(cur)
    }
  }
  lines
}

///|
/// Standalone modal dialog widget supporting fluent configuration.
pub struct Dialog {
  id_salt : String
  title : String
  message : String
  kind : DialogKind
  confirm_label : String
  cancel_label : String
  width : Double
} derive(Eq, Debug)

///|
/// Create a new dialog configuration.
pub fn Dialog::new(
  id_salt : String,
  title : String,
  message : String,
) -> Dialog {
  {
    id_salt,
    title,
    message,
    kind: DialogKind::Info,
    confirm_label: "Confirm",
    cancel_label: "Cancel",
    width: 440.0,
  }
}

///|
/// Configure semantic kind (Info, Warning, Danger, Confirm).
pub fn Dialog::kind(self : Dialog, kind : DialogKind) -> Dialog {
  { ..self, kind, }
}

///|
/// Configure confirm action button label.
pub fn Dialog::confirm_label(self : Dialog, confirm_label : String) -> Dialog {
  { ..self, confirm_label, }
}

///|
/// Configure cancel action button label.
pub fn Dialog::cancel_label(self : Dialog, cancel_label : String) -> Dialog {
  { ..self, cancel_label, }
}

///|
/// Configure dialog card width.
pub fn Dialog::width(self : Dialog, width : Double) -> Dialog {
  { ..self, width, }
}

///|
/// Show the dialog modal and return the user interaction result.
pub fn Dialog::show(self : Dialog, ctx : UIContext) -> DialogResult {
  dialog(
    ctx,
    self.id_salt,
    self.title,
    self.message,
    kind=self.kind,
    confirm_label=self.confirm_label,
    cancel_label=self.cancel_label,
    width=self.width,
  )
}

///|
/// Render a modal confirmation dialog in Studio Light porcelain style.
pub fn dialog(
  ctx : UIContext,
  id_salt : String,
  title : String,
  message : String,
  kind? : DialogKind = Info,
  confirm_label? : String = "Confirm",
  cancel_label? : String = "Cancel",
  width? : Double = 440.0,
  viewport_size? : @math.Vec2 = @math.Vec2::zero(),
) -> DialogResult {
  let vp_w = if viewport_size.x > 0.0 {
    viewport_size.x
  } else if ctx.available_width() > 0.0 {
    ctx.available_width()
  } else {
    800.0
  }
  let vp_h = if viewport_size.y > 0.0 { viewport_size.y } else { 600.0 }
  let scrim_rect = @math.Rect::new(0.0, 0.0, vp_w, vp_h)
  ctx.block_hover(scrim_rect)

  let cancel_id = ctx.id_stack.derive_id(id_salt + "::cancel")
  let confirm_id = ctx.id_stack.derive_id(id_salt + "::confirm")

  // Modal focus trapping: clear previous background focusable IDs and constrain to dialog buttons
  ctx.clear_focusable()
  ctx.register_focusable(cancel_id)
  ctx.register_focusable(confirm_id)

  if ctx.focused_id() != cancel_id && ctx.focused_id() != confirm_id {
    ctx.request_focus(confirm_id)
  }

  let scale = ctx.style.scale
  let eff_w = if width * scale > vp_w - 32.0 * scale {
    if vp_w > 32.0 * scale {
      vp_w - 32.0 * scale
    } else {
      vp_w
    }
  } else {
    width * scale
  }

  let text_max_w = eff_w - 84.0 * scale
  let msg_font_sz = ctx.style.font_normal * scale
  let msg_lines = wrap_dialog_message(ctx, message, text_max_w, msg_font_sz)
  let msg_line_h = 20.0 * scale
  let msg_total_h = msg_lines.length().to_double() * msg_line_h
  let pad_top = 24.0 * scale
  let title_sz = ctx.measure_text(title, ctx.style.font_large * scale)
  let title_h = if title_sz.y > 0.0 {
    title_sz.y
  } else {
    ctx.style.font_large * scale
  }
  let msg_gap = 10.0 * scale
  let btn_radius = ctx.style.radius_md * scale
  let btn_h = ctx.style.control_h_md * scale
  let btn_w = ctx.style.control_h_lg * 2.0 * scale
  let btn_pad_right = 16.0 * scale
  let btn_gap = 8.0 * scale
  let btn_margin_top = 18.0 * scale
  let btn_pad_y = 16.0 * scale

  let content_needed_h = pad_top +
    title_h +
    msg_gap +
    msg_total_h +
    btn_margin_top +
    btn_h +
    btn_pad_y
  let min_h = 160.0 * scale
  let max_allowed_h = if vp_h > 80.0 * scale {
    vp_h - 40.0 * scale
  } else {
    min_h
  }
  let card_h = if content_needed_h < min_h {
    min_h
  } else if content_needed_h > max_allowed_h {
    max_allowed_h
  } else {
    content_needed_h
  }

  let card_radius = ctx.style.radius_xl * scale
  let card_x = (vp_w - eff_w) * 0.5
  let card_y = (vp_h - card_h) * 0.5
  let card_rect = @math.Rect::new(card_x, card_y, eff_w, card_h)

  ctx.begin_foreground()

  // 1. Fullscreen Backdrop Scrim
  ctx.painter().add_rect(scrim_rect, @color.Color::bg_scrim(), 0.0)

  // 2. Multi-layer Studio Light Shadows
  ctx
  .painter()
  .add_rect(
    @math.Rect::new(card_x, card_y + 4.0 * scale, eff_w, card_h),
    @color.Color::shadow_key(),
    card_radius,
  )
  ctx
  .painter()
  .add_rect(
    @math.Rect::new(card_x, card_y + 12.0 * scale, eff_w, card_h),
    @color.Color::shadow_ambient(),
    card_radius,
  )

  // 3. Card Base & Outline
  ctx.painter().add_rect(card_rect, @color.Color::bg_surface(), card_radius)
  ctx
  .painter()
  .add_rect_stroke(card_rect, @color.Color::border_default(), 1.0, card_radius)

  // 4. Semantic Badge Icon
  let icon_center = @math.Vec2::new(
    card_x + 32.0 * scale,
    card_y + 36.0 * scale,
  )
  let (badge_bg, badge_sym, badge_fg) = match kind {
    Info => (@color.Color::badge_info_bg(), "i", @color.Color::accent_primary())
    Warning => (@color.Color::badge_warning_bg(), "!", @color.Color::warning())
    Danger => (@color.Color::badge_danger_bg(), "x", @color.Color::danger())
    Confirm =>
      (@color.Color::badge_info_bg(), "?", @color.Color::accent_primary())
  }

  ctx.painter().add_circle(icon_center, 16.0 * scale, badge_bg)
  let sym_offset = ctx.measure_text(badge_sym, ctx.style.font_normal * scale)
  let sym_pos = @math.Vec2::new(
    icon_center.x - sym_offset.x * 0.5,
    icon_center.y - sym_offset.y * 0.5,
  )
  ctx
  .painter()
  .add_text(sym_pos, badge_sym, ctx.style.font_normal * scale, badge_fg)

  // 5. Title & Message Text
  let title_pos = @math.Vec2::new(card_x + 60.0 * scale, card_y + pad_top)
  ctx
  .painter()
  .add_text(
    title_pos,
    title,
    ctx.style.font_large * scale,
    @color.Color::text_strong(),
  )

  let btn_y = card_y + card_h - btn_h - btn_pad_y
  let msg_start_y = card_y + pad_top + title_h + msg_gap
  for idx = 0; idx < msg_lines.length(); idx = idx + 1 {
    let line_y = msg_start_y + idx.to_double() * msg_line_h
    if line_y + msg_line_h <= btn_y - 6.0 * scale {
      ctx
      .painter()
      .add_text(
        @math.Vec2::new(card_x + 60.0 * scale, line_y),
        msg_lines[idx],
        msg_font_sz,
        @color.Color::text_secondary(),
      )
    }
  }

  // 6. Action Footer Buttons
  let confirm_rect = @math.Rect::new(
    card_x + eff_w - btn_w - btn_pad_right,
    btn_y,
    btn_w,
    btn_h,
  )
  let cancel_rect = @math.Rect::new(
    confirm_rect.x - btn_w - btn_gap,
    btn_y,
    btn_w,
    btn_h,
  )

  let cancel_hovered = cancel_rect.contains(ctx.input.mouse_pos)
  let confirm_hovered = confirm_rect.contains(ctx.input.mouse_pos)
  if cancel_hovered || confirm_hovered {
    ctx.set_cursor_icon("pointer")
  }
  let cancel_bg = if cancel_hovered {
    @color.Color::bg_hover()
  } else {
    @color.Color::bg_subtle()
  }
  ctx.painter().add_rect(cancel_rect, cancel_bg, btn_radius)
  ctx
  .painter()
  .add_rect_stroke(cancel_rect, @color.Color::border_default(), 1.0, btn_radius)
  if ctx.has_focus(cancel_id) {
    ctx
    .painter()
    .add_rect_stroke(
      cancel_rect.expand(2.0),
      @color.Color::border_focus(),
      1.5,
      btn_radius + 2.0,
    )
  }
  let cancel_sz = ctx.measure_text(cancel_label, ctx.style.font_normal * scale)
  let cancel_text_pos = @math.Vec2::new(
    cancel_rect.x + (cancel_rect.w - cancel_sz.x) * 0.5,
    cancel_rect.y + (cancel_rect.h - cancel_sz.y) * 0.5,
  )
  ctx
  .painter()
  .add_text(
    cancel_text_pos,
    cancel_label,
    ctx.style.font_normal * scale,
    @color.Color::text_body(),
  )
  let cancel_clicked = cancel_hovered && ctx.input.mouse_pressed
  let confirm_bg = match kind {
    Danger =>
      if confirm_hovered {
        @color.Color::danger_hover()
      } else {
        @color.Color::danger()
      }
    _ =>
      if confirm_hovered {
        @color.Color::accent_hover()
      } else {
        @color.Color::accent_primary()
      }
  }
  ctx.painter().add_rect(confirm_rect, confirm_bg, btn_radius)
  if ctx.has_focus(confirm_id) {
    ctx
    .painter()
    .add_rect_stroke(
      confirm_rect.expand(2.0),
      @color.Color::border_focus(),
      1.5,
      btn_radius + 2.0,
    )
  }
  let confirm_sz = ctx.measure_text(
    confirm_label,
    ctx.style.font_normal * scale,
  )
  let confirm_text_pos = @math.Vec2::new(
    confirm_rect.x + (confirm_rect.w - confirm_sz.x) * 0.5,
    confirm_rect.y + (confirm_rect.h - confirm_sz.y) * 0.5,
  )
  ctx
  .painter()
  .add_text(
    confirm_text_pos,
    confirm_label,
    ctx.style.font_normal * scale,
    @color.Color::text_inverse(),
  )
  let confirm_clicked = confirm_hovered && ctx.input.mouse_pressed

  // 7. Interaction and Result Decision
  let esc_pressed = ctx.input.key_pressed(Key::Escape)
  let enter_pressed = ctx.input.key_pressed(Key::Enter)
  let space_pressed = ctx.input.key_pressed(Key::Space)
  let backdrop_clicked = ctx.input.mouse_pressed &&
    !card_rect.contains(ctx.input.mouse_pos)

  let cancel_key = ctx.has_focus(cancel_id) && (enter_pressed || space_pressed)
  let confirm_key = ctx.has_focus(confirm_id) &&
    (enter_pressed || space_pressed)

  let result = if confirm_clicked ||
    confirm_key ||
    (enter_pressed && !ctx.has_focus(cancel_id)) {
    DialogResult::Confirmed
  } else if cancel_clicked || cancel_key || esc_pressed || backdrop_clicked {
    DialogResult::Cancelled
  } else {
    DialogResult::Open
  }

  ctx.end_foreground()
  result
}
