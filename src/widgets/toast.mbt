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
pub(all) enum ToastKind {
  Info
  Success
  Warning
  Danger
} derive(Eq, Debug)

///|
pub struct Toast {
  id : String
  title : String
  message : String
  kind : ToastKind
  mut elapsed : Double
  duration : Double
} derive(Eq, Debug)

///|
pub fn Toast::new(
  id : String,
  title : String,
  message? : String = "",
  kind? : ToastKind = Info,
  duration? : Double = 3.0,
) -> Toast {
  { id, title, message, kind, elapsed: 0.0, duration, }
}

///|
pub fn Toast::info(
  title : String,
  message? : String = "",
  duration? : Double = 3.0,
) -> Toast {
  Toast::new(title, title, message~, kind=Info, duration~)
}

///|
pub fn Toast::success(
  title : String,
  message? : String = "",
  duration? : Double = 3.0,
) -> Toast {
  Toast::new(title, title, message~, kind=Success, duration~)
}

///|
pub fn Toast::warning(
  title : String,
  message? : String = "",
  duration? : Double = 3.0,
) -> Toast {
  Toast::new(title, title, message~, kind=Warning, duration~)
}

///|
pub fn Toast::danger(
  title : String,
  message? : String = "",
  duration? : Double = 3.0,
) -> Toast {
  Toast::new(title, title, message~, kind=Danger, duration~)
}

///|
pub(all) enum ToastAnchor {
  TopRight
  BottomRight
  BottomCenter
} derive(Eq, Debug)

///|
pub struct ToastResponse {
  active_toasts : Array[Toast]
  dismissed_id : String?
} derive(Eq, Debug)

///|
/// Render a floating toast stack in Studio Light porcelain style.
/// Toasts automatically decay over elapsed frames, stack gracefully according
/// to the chosen anchor, and allow manual dismissal via the close button.
pub fn toast_stack(
  ctx : UIContext,
  toasts : Array[Toast],
  anchor? : ToastAnchor = BottomRight,
  viewport_size? : @math.Vec2,
) -> ToastResponse {
  let dt = ctx.input.dt()
  let next_active : Array[Toast] = []
  let mut dismissed_id : String? = None

  // 1. Advance elapsed time and filter expired toasts
  for toast in toasts {
    toast.elapsed = toast.elapsed + dt
    if toast.elapsed < toast.duration {
      next_active.push(toast)
    }
  }

  if next_active.is_empty() {
    return { active_toasts: [], dismissed_id: None, }
  }

  // 2. Viewport and layout calculation
  let vw = match viewport_size {
    Some(vp) => vp.x
    None =>
      if ctx.available_width() > 0.0 {
        ctx.available_width()
      } else {
        800.0
      }
  }
  let vh = match viewport_size {
    Some(vp) => vp.y
    None => 600.0
  }

  let toast_w = 280.0
  let spacing = 8.0

  let placed_rects : Array[@math.Rect] = []
  match anchor {
    BottomRight => {
      let x = vw - toast_w - 20.0
      let mut cur_bottom = vh - 20.0
      for toast in next_active {
        let h = if toast.message.is_empty() { 38.0 } else { 54.0 }
        let y = cur_bottom - h
        placed_rects.push(@math.Rect::new(x, y, toast_w, h))
        cur_bottom = cur_bottom - h - spacing
      }
    }
    TopRight => {
      let x = vw - toast_w - 20.0
      let mut cur_top = 20.0
      for toast in next_active {
        let h = if toast.message.is_empty() { 38.0 } else { 54.0 }
        let y = cur_top
        placed_rects.push(@math.Rect::new(x, y, toast_w, h))
        cur_top = cur_top + h + spacing
      }
    }
    BottomCenter => {
      let x = (vw - toast_w) * 0.5
      let mut cur_bottom = vh - 20.0
      for toast in next_active {
        let h = if toast.message.is_empty() { 38.0 } else { 54.0 }
        let y = cur_bottom - h
        placed_rects.push(@math.Rect::new(x, y, toast_w, h))
        cur_bottom = cur_bottom - h - spacing
      }
    }
  }

  for rect in placed_rects {
    ctx.block_hover(rect)
  }

  ctx.begin_foreground()

  // Close-button hit-testing runs inside the foreground pass: on the main
  // layer the toast's own hover blocker (registered one frame earlier) would
  // swallow is_hovered and the cross could never be clicked again after the
  // first frame.
  for i = 0; i < next_active.length(); i = i + 1 {
    let rect = placed_rects[i]
    let close_btn_rect = @math.Rect::new(
      rect.x + toast_w - 26.0,
      rect.y + 6.0,
      20.0,
      20.0,
    )
    if ctx.is_hovered(close_btn_rect) {
      ctx.set_cursor_icon("pointer")
      if ctx.input.mouse_pressed {
        dismissed_id = Some(next_active[i].id)
        break
      }
    }
    if ctx.is_hovered(rect) {
      ctx.set_wants_capture_mouse(true)
    }
  }

  let final_active : Array[Toast] = []
  for toast in next_active {
    if Some(toast.id) != dismissed_id {
      final_active.push(toast)
    }
  }

  for i = 0; i < final_active.length(); i = i + 1 {
    let toast = final_active[i]
    let rect = placed_rects[i]

    let scale = ctx.style.scale
    let toast_radius = (ctx.style.radius_md + 1.0) * scale

    ctx
    .painter()
    .add_rect(
      @math.Rect::new(rect.x, rect.y + 4.0 * scale, rect.w, rect.h),
      @color.Color::shadow_ambient(),
      toast_radius,
    )
    ctx
    .painter()
    .add_rect(
      @math.Rect::new(rect.x, rect.y + 1.0 * scale, rect.w, rect.h),
      @color.Color::shadow_key(),
      toast_radius,
    )

    ctx.painter().add_rect(rect, @color.Color::bg_window(), toast_radius)
    ctx
    .painter()
    .add_rect_stroke(rect, @color.Color::border_default(), 1.0, toast_radius)

    let kind_color = match toast.kind {
      Info => @color.Color::accent_primary()
      Success => @color.Color::success()
      Warning => @color.Color::warning()
      Danger => @color.Color::danger()
    }
    ctx
    .painter()
    .add_rect(
      @math.Rect::new(rect.x, rect.y + 5.0, 3.5, rect.h - 10.0),
      kind_color,
      1.5,
    )

    let has_detail = !toast.message.is_empty()
    let title_y = if has_detail { rect.y + 10.0 } else { rect.y + 12.0 }

    ctx
    .painter()
    .add_text(
      @math.Vec2::new(rect.x + 16.0, title_y),
      toast.title,
      12.5,
      @color.Color::text_primary(),
    )

    if has_detail {
      ctx
      .painter()
      .add_text(
        @math.Vec2::new(rect.x + 16.0, rect.y + 29.0),
        toast.message,
        11.0,
        @color.Color::text_muted(),
      )
    }

    let close_hover = ctx.is_hovered(
      @math.Rect::new(rect.x + toast_w - 24.0, rect.y + 6.0, 18.0, 18.0),
    )
    let close_col = if close_hover {
      @color.Color::text_primary()
    } else {
      @color.Color::text_disabled()
    }
    ctx
    .painter()
    .add_text(
      @math.Vec2::new(rect.x + toast_w - 18.0, rect.y + 9.0),
      "x",
      11.5,
      close_col,
    )
  }

  ctx.end_foreground()

  { active_toasts: final_active, dismissed_id, }
}
