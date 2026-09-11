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
  width? : Double = 380.0,
  viewport_size? : @math.Vec2 = @math.Vec2::new(800.0, 600.0),
) -> DialogResult {
  let scrim_rect = @math.Rect::new(0.0, 0.0, viewport_size.x, viewport_size.y)
  self.block_hover(scrim_rect)

  let card_h = 160.0
  let card_x = (viewport_size.x - width) * 0.5
  let card_y = (viewport_size.y - card_h) * 0.5
  let card_rect = @math.Rect::new(card_x, card_y, width, card_h)

  self.begin_foreground()

  // 1. Fullscreen Backdrop Scrim
  self.draw_list.add_rect(scrim_rect, @color.Color::rgba(15, 23, 42, 115), 0.0)

  // 2. Multi-layer Studio Light Shadows
  self.draw_list.add_rect(
    @math.Rect::new(card_x, card_y + 4.0, width, card_h),
    @color.Color::shadow().with_alpha(45),
    12.0,
  )
  self.draw_list.add_rect(
    @math.Rect::new(card_x, card_y + 12.0, width, card_h),
    @color.Color::shadow().with_alpha(30),
    12.0,
  )

  // 3. Card Base & Outline
  self.draw_list.add_rect(card_rect, @color.Color::bg_surface(), 12.0)
  self.draw_list.add_rect_stroke(
    card_rect,
    @color.Color::border_default(),
    1.0,
    12.0,
  )

  // 4. Semantic Badge Icon
  let icon_center = @math.Vec2::new(card_x + 32.0, card_y + 36.0)
  let (badge_bg, badge_sym, badge_fg) = match kind {
    Info =>
      (
        @color.Color::accent_soft().with_alpha(150),
        "i",
        @color.Color::accent_primary(),
      )
    Warning =>
      (@color.Color::warning().with_alpha(40), "!", @color.Color::warning())
    Danger =>
      (@color.Color::danger().with_alpha(40), "x", @color.Color::danger())
    Confirm =>
      (
        @color.Color::accent_soft().with_alpha(150),
        "?",
        @color.Color::accent_primary(),
      )
  }

  self.draw_list.add_circle(icon_center, 16.0, badge_bg)
  let sym_offset = self.measure_text(badge_sym, self.style.font_normal)
  let sym_pos = @math.Vec2::new(
    icon_center.x - sym_offset.x * 0.5,
    icon_center.y - sym_offset.y * 0.5,
  )
  self.draw_list.add_text(sym_pos, badge_sym, self.style.font_normal, badge_fg)

  // 5. Title & Message Text
  let title_pos = @math.Vec2::new(card_x + 60.0, card_y + 24.0)
  self.draw_list.add_text(
    title_pos,
    title,
    self.style.font_large,
    @color.Color::text_strong(),
  )

  let msg_pos = @math.Vec2::new(card_x + 60.0, card_y + 50.0)
  self.draw_list.add_text(
    msg_pos,
    message,
    self.style.font_normal,
    @color.Color::text_secondary(),
  )

  // 6. Action Footer Buttons
  let btn_y = card_y + card_h - 46.0
  let cancel_rect = @math.Rect::new(card_x + width - 184.0, btn_y, 80.0, 32.0)
  let confirm_rect = @math.Rect::new(card_x + width - 96.0, btn_y, 80.0, 32.0)

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
  self.draw_list.add_rect(cancel_rect, cancel_bg, 6.0)
  self.draw_list.add_rect_stroke(
    cancel_rect,
    @color.Color::border_default(),
    1.0,
    6.0,
  )
  let cancel_sz = self.measure_text(cancel_label, self.style.font_normal)
  let cancel_text_pos = @math.Vec2::new(
    cancel_rect.x + (cancel_rect.w - cancel_sz.x) * 0.5,
    cancel_rect.y + (cancel_rect.h - cancel_sz.y) * 0.5,
  )
  self.draw_list.add_text(
    cancel_text_pos,
    cancel_label,
    self.style.font_normal,
    @color.Color::text_body(),
  )
  let cancel_clicked = cancel_hovered && self.input.mouse_pressed
  let confirm_bg = match kind {
    Danger =>
      if confirm_hovered {
        @color.Color::danger().with_alpha(220)
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
  self.draw_list.add_rect(confirm_rect, confirm_bg, 6.0)
  let confirm_sz = self.measure_text(confirm_label, self.style.font_normal)
  let confirm_text_pos = @math.Vec2::new(
    confirm_rect.x + (confirm_rect.w - confirm_sz.x) * 0.5,
    confirm_rect.y + (confirm_rect.h - confirm_sz.y) * 0.5,
  )
  self.draw_list.add_text(
    confirm_text_pos,
    confirm_label,
    self.style.font_normal,
    @color.Color::white(),
  )
  let confirm_clicked = confirm_hovered && self.input.mouse_pressed

  // 7. Interaction and Result Decision
  let esc_pressed = self.input.key_pressed(Key::Escape)
  let enter_pressed = self.input.key_pressed(Key::Enter)
  let backdrop_clicked = self.input.mouse_pressed &&
    !card_rect.contains(self.input.mouse_pos)

  let result = if confirm_clicked || enter_pressed {
    DialogResult::Confirmed
  } else if cancel_clicked || esc_pressed || backdrop_clicked {
    DialogResult::Cancelled
  } else {
    DialogResult::Open
  }

  self.end_foreground()
  result
}
