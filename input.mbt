///|
pub struct RawInput {
  mouse_pos : Vec2
  mouse_down : Bool
  scroll_delta : Vec2
  dt : Double
} derive(Eq, Debug, Default)

///|
pub fn RawInput::new() -> RawInput {
  {
    mouse_pos: Vec2::zero(),
    mouse_down: false,
    scroll_delta: Vec2::zero(),
    dt: 0.0166,
  }
}

///|
pub fn RawInput::from_mouse(mouse_pos : Vec2, mouse_down : Bool) -> RawInput {
  { mouse_pos, mouse_down, scroll_delta: Vec2::zero(), dt: 0.0166, }
}

///|
pub struct InputState {
  mut mouse_pos : Vec2
  mut mouse_prev_pos : Vec2
  mut mouse_delta : Vec2
  mut mouse_down : Bool
  mut mouse_pressed : Bool
  mut mouse_released : Bool
  mut scroll_delta : Vec2
  mut dt : Double
} derive(Eq, Debug, Default)

///|
pub fn InputState::new() -> InputState {
  {
    mouse_pos: Vec2::zero(),
    mouse_prev_pos: Vec2::zero(),
    mouse_delta: Vec2::zero(),
    mouse_down: false,
    mouse_pressed: false,
    mouse_released: false,
    scroll_delta: Vec2::zero(),
    dt: 0.0166,
  }
}

///|
pub fn InputState::update(self : InputState, raw : RawInput) -> Unit {
  self.mouse_prev_pos = self.mouse_pos
  self.mouse_pos = raw.mouse_pos
  self.mouse_delta = self.mouse_pos.sub(self.mouse_prev_pos)
  let was_down = self.mouse_down
  self.mouse_down = raw.mouse_down
  self.mouse_pressed = raw.mouse_down && !was_down
  self.mouse_released = !raw.mouse_down && was_down
  self.scroll_delta = raw.scroll_delta
  self.dt = if raw.dt > 0.0 { raw.dt } else { 0.0166 }
}
