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
      let boundary = next_char_boundary(p_str, i)
      let ch_str = string_slice(p_str, i, boundary)
      let test_str = cur + ch_str
      let sz = ctx.measure_text(test_str, font_size)
      if sz.x > max_w && !cur.is_empty() {
        lines.push(cur)
        cur = ch_str
      } else {
        cur = test_str
      }
      i = boundary
    }
    if !cur.is_empty() {
      lines.push(cur)
    }
  }
  if lines.is_empty() {
    lines.push("")
  }
  lines
}

///|
/// Render a modal dialog overlay with backdrop blocking, semantic header styling,
/// Esc/Enter keyboard shortcuts, and Cancel/Confirm action buttons.
pub fn UIContext::dialog(
  self : UIContext,
  _id_salt : String,
  title : String,
  message : String,
  kind? : DialogKind = Confirm,
  confirm_label? : String = "Confirm",
  cancel_label? : String = "Cancel",
  width? : Double = 0.0,
  viewport_size? : @math.Vec2 = @math.Vec2::zero(),
) -> DialogResult {
  let scale = self.style.scale
  let eff_w = if width > 0.0 { width } else { self.style.dialog_w * scale }
  let vp_w = if viewport_size.x > 0.0 {
    viewport_size.x
  } else if self.available_width > 0.0 {
    self.available_width
  } else {
    800.0
  }
  let vp_h = if viewport_size.y > 0.0 { viewport_size.y } else { 600.0 }
  let scrim_rect = @math.Rect::new(0.0, 0.0, vp_w, vp_h)
  self.block_hover(scrim_rect)

  let cancel_id = self.id_stack.derive_id(_id_salt + "::cancel")
  let confirm_id = self.id_stack.derive_id(_id_salt + "::confirm")

  // Modal focus trapping: clear previous background focusable IDs and constrain to dialog buttons
  self.focusable_ids.clear()
  self.register_focusable(cancel_id)
  self.register_focusable(confirm_id)

  if self.focused_id != cancel_id && self.focused_id != confirm_id {
    self.request_focus(confirm_id)
  }

  let text_max_w = eff_w - 84.0 * scale
  let msg_font_sz = self.style.font_normal * scale
  let msg_lines = wrap_dialog_message(self, message, text_max_w, msg_font_sz)
  let msg_line_h = 20.0 * scale
  let msg_total_h = msg_lines.length().to_double() * msg_line_h
  let pad_top = 24.0 * scale
  let title_sz = self.measure_text(title, self.style.font_large * scale)
  let title_h = if title_sz.y > 0.0 {
    title_sz.y
  } else {
    self.style.font_large * scale
  }
  let msg_gap = 10.0 * scale
  let btn_radius = self.style.button_radius * scale
  let btn_h = self.style.button_h * scale
  let btn_w = self.style.dialog_btn_w * scale
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
  let min_h = self.style.dialog_min_h * scale
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

  let card_radius = self.style.dialog_radius * scale
  let card_x = (vp_w - eff_w) * 0.5
  let card_y = (vp_h - card_h) * 0.5
  let card_rect = @math.Rect::new(card_x, card_y, eff_w, card_h)

  self.begin_foreground()

  // 1. Fullscreen Backdrop Scrim
  self.draw_list.add_rect(scrim_rect, @color.Color::bg_scrim(), 0.0)

  // 2. Multi-layer Studio Light Shadows
  self.draw_list.add_rect(
    @math.Rect::new(card_x, card_y + 4.0 * scale, eff_w, card_h),
    @color.Color::shadow_key(),
    card_radius,
  )
  self.draw_list.add_rect(
    @math.Rect::new(card_x, card_y + 12.0 * scale, eff_w, card_h),
    @color.Color::shadow_ambient(),
    card_radius,
  )

  // 3. Card Base & Outline
  self.draw_list.add_rect(card_rect, @color.Color::bg_surface(), card_radius)
  self.draw_list.add_rect_stroke(
    card_rect,
    @color.Color::border_default(),
    1.0,
    card_radius,
  )

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

  self.draw_list.add_circle(icon_center, 16.0 * scale, badge_bg)
  let sym_offset = self.measure_text(badge_sym, self.style.font_normal * scale)
  let sym_pos = @math.Vec2::new(
    icon_center.x - sym_offset.x * 0.5,
    icon_center.y - sym_offset.y * 0.5,
  )
  self.draw_list.add_text(
    sym_pos,
    badge_sym,
    self.style.font_normal * scale,
    badge_fg,
  )

  // 5. Title & Message Text
  let title_pos = @math.Vec2::new(card_x + 60.0 * scale, card_y + pad_top)
  self.draw_list.add_text(
    title_pos,
    title,
    self.style.font_large * scale,
    @color.Color::text_strong(),
  )

  let btn_y = card_y + card_h - btn_h - btn_pad_y
  let msg_start_y = card_y + pad_top + title_h + msg_gap
  for idx = 0; idx < msg_lines.length(); idx = idx + 1 {
    let line_y = msg_start_y + idx.to_double() * msg_line_h
    if line_y + msg_line_h <= btn_y - 6.0 * scale {
      self.draw_list.add_text(
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

  let cancel_hovered = cancel_rect.contains(self.input.mouse_pos)
  let confirm_hovered = confirm_rect.contains(self.input.mouse_pos)
  if cancel_hovered || confirm_hovered {
    self.set_cursor_icon("pointer")
  }
  let cancel_bg = if cancel_hovered {
    @color.Color::bg_hover()
  } else {
    @color.Color::bg_subtle()
  }
  self.draw_list.add_rect(cancel_rect, cancel_bg, btn_radius)
  self.draw_list.add_rect_stroke(
    cancel_rect,
    @color.Color::border_default(),
    1.0,
    btn_radius,
  )
  if self.has_focus(cancel_id) {
    self.draw_list.add_rect_stroke(
      cancel_rect.expand(2.0),
      @color.Color::border_focus(),
      1.5,
      btn_radius + 2.0,
    )
  }
  let cancel_sz = self.measure_text(
    cancel_label,
    self.style.font_normal * scale,
  )
  let cancel_text_pos = @math.Vec2::new(
    cancel_rect.x + (cancel_rect.w - cancel_sz.x) * 0.5,
    cancel_rect.y + (cancel_rect.h - cancel_sz.y) * 0.5,
  )
  self.draw_list.add_text(
    cancel_text_pos,
    cancel_label,
    self.style.font_normal * scale,
    @color.Color::text_body(),
  )
  let cancel_clicked = cancel_hovered && self.input.mouse_pressed
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
  self.draw_list.add_rect(confirm_rect, confirm_bg, btn_radius)
  if self.has_focus(confirm_id) {
    self.draw_list.add_rect_stroke(
      confirm_rect.expand(2.0),
      @color.Color::border_focus(),
      1.5,
      btn_radius + 2.0,
    )
  }
  let confirm_sz = self.measure_text(
    confirm_label,
    self.style.font_normal * scale,
  )
  let confirm_text_pos = @math.Vec2::new(
    confirm_rect.x + (confirm_rect.w - confirm_sz.x) * 0.5,
    confirm_rect.y + (confirm_rect.h - confirm_sz.y) * 0.5,
  )
  self.draw_list.add_text(
    confirm_text_pos,
    confirm_label,
    self.style.font_normal * scale,
    @color.Color::text_inverse(),
  )
  let confirm_clicked = confirm_hovered && self.input.mouse_pressed

  // 7. Interaction and Result Decision
  let esc_pressed = self.input.key_pressed(Key::Escape)
  let enter_pressed = self.input.key_pressed(Key::Enter)
  let space_pressed = self.input.key_pressed(Key::Space)
  let backdrop_clicked = self.input.mouse_pressed &&
    !card_rect.contains(self.input.mouse_pos)

  let cancel_key = self.has_focus(cancel_id) && (enter_pressed || space_pressed)
  let confirm_key = self.has_focus(confirm_id) &&
    (enter_pressed || space_pressed)

  let result = if confirm_clicked ||
    confirm_key ||
    (enter_pressed && !self.has_focus(cancel_id)) {
    DialogResult::Confirmed
  } else if cancel_clicked || cancel_key || esc_pressed || backdrop_clicked {
    DialogResult::Cancelled
  } else {
    DialogResult::Open
  }

  self.end_foreground()
  result
}
