// Copyright 2026 Ling71671
// MoonLens Native Desktop FFI Bridge to Win32 GDI Runner

///|
extern "C" fn c_win32_init_window(width : Int, height : Int) -> Int = "c_win32_init_window"

///|
extern "C" fn c_win32_poll_events() -> Int = "c_win32_poll_events"

///|
extern "C" fn c_win32_get_mouse_x() -> Double = "c_win32_get_mouse_x"

///|
extern "C" fn c_win32_get_mouse_y() -> Double = "c_win32_get_mouse_y"

///|
extern "C" fn c_win32_get_mouse_down() -> Int = "c_win32_get_mouse_down"

///|
extern "C" fn c_win32_get_mouse_right_down() -> Int = "c_win32_get_mouse_right_down"

///|
extern "C" fn c_win32_get_wheel_delta() -> Double = "c_win32_get_wheel_delta"

///|
extern "C" fn c_win32_get_window_width() -> Double = "c_win32_get_window_width"

///|
extern "C" fn c_win32_get_window_height() -> Double = "c_win32_get_window_height"

///|
extern "C" fn c_win32_get_typed_char() -> Int = "c_win32_get_typed_char"

///|
extern "C" fn c_win32_is_key_pressed(vk : Int) -> Int = "c_win32_is_key_pressed"

///|
extern "C" fn c_win32_is_key_down(vk : Int) -> Int = "c_win32_is_key_down"

///|
extern "C" fn c_win32_set_cursor(cursor_type : Int) = "c_win32_set_cursor"

///|
extern "C" fn c_win32_render_begin(clear_r : Int, clear_g : Int, clear_b : Int) = "c_win32_render_begin"

///|
extern "C" fn c_win32_draw_rect(
  x : Double,
  y : Double,
  w : Double,
  h : Double,
  r : Int,
  g : Int,
  b : Int,
  a : Int,
  radius : Double,
) = "c_win32_draw_rect"

///|
extern "C" fn c_win32_draw_rect_stroke(
  x : Double,
  y : Double,
  w : Double,
  h : Double,
  r : Int,
  g : Int,
  b : Int,
  a : Int,
  stroke_width : Double,
  radius : Double,
) = "c_win32_draw_rect_stroke"

///|
extern "C" fn c_win32_draw_line(
  x1 : Double,
  y1 : Double,
  x2 : Double,
  y2 : Double,
  r : Int,
  g : Int,
  b : Int,
  a : Int,
  width : Double,
) = "c_win32_draw_line"

///|
extern "C" fn c_win32_draw_circle(
  cx : Double,
  cy : Double,
  radius : Double,
  r : Int,
  g : Int,
  b : Int,
  a : Int,
) = "c_win32_draw_circle"

///|
extern "C" fn c_win32_draw_circle_stroke(
  cx : Double,
  cy : Double,
  radius : Double,
  r : Int,
  g : Int,
  b : Int,
  a : Int,
  stroke_width : Double,
) = "c_win32_draw_circle_stroke"

///|
#borrow(str)
extern "C" fn c_win32_draw_text(
  x : Double,
  y : Double,
  str : String,
  font_size : Double,
  r : Int,
  g : Int,
  b : Int,
  a : Int,
  align : Int,
) = "c_win32_draw_text"

///|
extern "C" fn c_win32_push_clip(x : Double, y : Double, w : Double, h : Double) = "c_win32_push_clip"

///|
extern "C" fn c_win32_pop_clip() = "c_win32_pop_clip"

///|
extern "C" fn c_win32_render_end() = "c_win32_render_end"

///|
/// Synchronizes the active cursor icon with Windows OS cursor shape
pub fn sync_cursor(icon : String) -> Unit {
  let cid = match icon {
    "pointer" => 1
    "text" => 2
    "ew-resize" | "col-resize" => 3
    "ns-resize" | "row-resize" => 4
    "crosshair" => 5
    "move" => 6
    _ => 0
  }
  c_win32_set_cursor(cid)
}

///|
/// Maps a Windows Virtual Key code to MoonBit @core.Key
fn map_vk_to_key(vk : Int) -> @core.Key? {
  match vk {
    0x08 => Some(@core.Key::Backspace)
    0x09 => Some(@core.Key::Tab)
    0x0D => Some(@core.Key::Enter)
    0x1B => Some(@core.Key::Escape)
    0x20 => Some(@core.Key::Space)
    0x25 => Some(@core.Key::ArrowLeft)
    0x26 => Some(@core.Key::ArrowUp)
    0x27 => Some(@core.Key::ArrowRight)
    0x28 => Some(@core.Key::ArrowDown)
    0x21 => Some(@core.Key::PageUp)
    0x22 => Some(@core.Key::PageDown)
    0x24 => Some(@core.Key::Home)
    0x23 => Some(@core.Key::End)
    0x2E => Some(@core.Key::Delete)
    0x30 => Some(@core.Key::Num0)
    0x31 => Some(@core.Key::Num1)
    0x32 => Some(@core.Key::Num2)
    0x33 => Some(@core.Key::Num3)
    0x34 => Some(@core.Key::Num4)
    0x35 => Some(@core.Key::Num5)
    0x36 => Some(@core.Key::Num6)
    0x37 => Some(@core.Key::Num7)
    0x38 => Some(@core.Key::Num8)
    0x39 => Some(@core.Key::Num9)
    0x41 => Some(@core.Key::A)
    0x42 => Some(@core.Key::B)
    0x43 => Some(@core.Key::C)
    0x44 => Some(@core.Key::D)
    0x45 => Some(@core.Key::E)
    0x46 => Some(@core.Key::F)
    0x47 => Some(@core.Key::G)
    0x48 => Some(@core.Key::H)
    0x49 => Some(@core.Key::I)
    0x4A => Some(@core.Key::J)
    0x4B => Some(@core.Key::K)
    0x4C => Some(@core.Key::L)
    0x4D => Some(@core.Key::M)
    0x4E => Some(@core.Key::N)
    0x4F => Some(@core.Key::O)
    0x50 => Some(@core.Key::P)
    0x51 => Some(@core.Key::Q)
    0x52 => Some(@core.Key::R)
    0x53 => Some(@core.Key::S)
    0x54 => Some(@core.Key::T)
    0x55 => Some(@core.Key::U)
    0x56 => Some(@core.Key::V)
    0x57 => Some(@core.Key::W)
    0x58 => Some(@core.Key::X)
    0x59 => Some(@core.Key::Y)
    0x5A => Some(@core.Key::Z)
    _ => None
  }
}

///|
/// Gathers Windows events from the C runner and packages them into RawInput
pub fn fetch_raw_input() -> @core.RawInput {
  let mx = c_win32_get_mouse_x()
  let my = c_win32_get_mouse_y()
  let mouse_down = c_win32_get_mouse_down() != 0
  let mouse_sec_down = c_win32_get_mouse_right_down() != 0
  let wheel = c_win32_get_wheel_delta()

  let shift = c_win32_is_key_down(0x10) != 0
  let ctrl = c_win32_is_key_down(0x11) != 0
  let alt = c_win32_is_key_down(0x12) != 0
  let modifiers = @core.Modifiers::new(ctrl, shift, alt, false)

  let events : Array[@core.Event] = []

  // Check key pressed events
  let tracked_vks = [
    0x08, 0x09, 0x0D, 0x1B, 0x20, 0x25, 0x26, 0x27, 0x28, 0x21, 0x22, 0x24, 0x23,
    0x2E, 0x41, 0x43, 0x56, 0x58, 0x5A,
  ]
  for vk in tracked_vks {
    if c_win32_is_key_pressed(vk) != 0 {
      match map_vk_to_key(vk) {
        Some(k) => events.push(@core.Event::Key(k, true, modifiers))
        None => ()
      }
    }
  }

  // Check typed character
  let typed_char = c_win32_get_typed_char()
  let text_input = if typed_char >= 32 && typed_char != 127 {
    let ch = match typed_char.to_char() {
      Some(c) => c
      None => ' '
    }
    events.push(@core.Event::TextInput(ch.to_string()))
    ch.to_string()
  } else {
    ""
  }

  let scroll_delta = if wheel != 0.0 {
    let sd = @math.Vec2::new(0.0, wheel * 36.0)
    events.push(@core.Event::PointerWheel(sd))
    sd
  } else {
    @math.Vec2::zero()
  }

  @core.RawInput::with_events(
    @math.Vec2::new(mx, my),
    mouse_down,
    scroll_delta,
    events,
    text_input,
    modifiers,
    mouse_secondary_down=mouse_sec_down,
    dt=0.0166,
  )
}

///|
/// Renders an engine DrawList to the Windows offscreen buffer and presents it
pub fn render_native_draw_list(
  dl : @draw.DrawList,
  bg_color : @color.Color,
) -> Unit {
  c_win32_render_begin(bg_color.r, bg_color.g, bg_color.b)

  for cmd in dl.commands() {
    match cmd {
      @draw.DrawCmd::Rect(rect, color, radius) =>
        c_win32_draw_rect(
          rect.x,
          rect.y,
          rect.w,
          rect.h,
          color.r,
          color.g,
          color.b,
          color.a,
          radius,
        )
      @draw.DrawCmd::RectStroke(rect, color, stroke_w, radius) =>
        c_win32_draw_rect_stroke(
          rect.x,
          rect.y,
          rect.w,
          rect.h,
          color.r,
          color.g,
          color.b,
          color.a,
          stroke_w,
          radius,
        )
      @draw.DrawCmd::Line(p1, p2, color, width) =>
        c_win32_draw_line(
          p1.x,
          p1.y,
          p2.x,
          p2.y,
          color.r,
          color.g,
          color.b,
          color.a,
          width,
        )
      @draw.DrawCmd::Circle(center, radius, color) =>
        c_win32_draw_circle(
          center.x,
          center.y,
          radius,
          color.r,
          color.g,
          color.b,
          color.a,
        )
      @draw.DrawCmd::CircleStroke(center, radius, color, stroke_w) =>
        c_win32_draw_circle_stroke(
          center.x,
          center.y,
          radius,
          color.r,
          color.g,
          color.b,
          color.a,
          stroke_w,
        )
      @draw.DrawCmd::Text(pos, text, font_size, color, _, align) =>
        c_win32_draw_text(
          pos.x,
          pos.y,
          text,
          font_size,
          color.r,
          color.g,
          color.b,
          color.a,
          align,
        )
      @draw.DrawCmd::Clip(rect) =>
        c_win32_push_clip(rect.x, rect.y, rect.w, rect.h)
      @draw.DrawCmd::ResetClip => c_win32_pop_clip()
      @draw.DrawCmd::LinearGradient(rect, _, _, c1, c2, radius) => {
        let avg_r = (c1.r + c2.r) / 2
        let avg_g = (c1.g + c2.g) / 2
        let avg_b = (c1.b + c2.b) / 2
        let avg_a = (c1.a + c2.a) / 2
        c_win32_draw_rect(
          rect.x,
          rect.y,
          rect.w,
          rect.h,
          avg_r,
          avg_g,
          avg_b,
          avg_a,
          radius,
        )
      }
    }
  }

  c_win32_render_end()
}
