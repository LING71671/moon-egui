///|
pub(all) enum Key {
  Backspace
  Delete
  Enter
  Escape
  Tab
  Space
  ArrowLeft
  ArrowRight
  ArrowUp
  ArrowDown
  Home
  End
  PageUp
  PageDown
  A
  B
  C
  D
  E
  F
  G
  H
  I
  J
  K
  L
  M
  N
  O
  P
  Q
  R
  S
  T
  U
  V
  W
  X
  Y
  Z
  Num0
  Num1
  Num2
  Num3
  Num4
  Num5
  Num6
  Num7
  Num8
  Num9
} derive(Eq, Debug, Hash)

///|
pub struct Modifiers {
  ctrl : Bool
  shift : Bool
  alt : Bool
  meta : Bool
} derive(Eq, Debug, Default)

///|
pub fn Modifiers::none() -> Modifiers {
  { ctrl: false, shift: false, alt: false, meta: false, }
}

///|
pub fn Modifiers::ctrl() -> Modifiers {
  { ctrl: true, shift: false, alt: false, meta: false, }
}

///|
pub fn Modifiers::shift() -> Modifiers {
  { ctrl: false, shift: true, alt: false, meta: false, }
}

///|
pub fn Modifiers::new(
  ctrl : Bool,
  shift : Bool,
  alt : Bool,
  meta : Bool,
) -> Modifiers {
  { ctrl, shift, alt, meta, }
}

///|
pub(all) enum Event {
  Key(Key, Bool, Modifiers)
  TextInput(String)
  PointerWheel(@math.Vec2)
} derive(Eq, Debug)

///|
pub struct RawInput {
  mouse_pos : @math.Vec2
  mouse_down : Bool
  scroll_delta : @math.Vec2
  dt : Double
  events : Array[Event]
  text_input : String
  modifiers : Modifiers
  mouse_secondary_down : Bool
} derive(Eq, Debug)

///|
pub fn RawInput::new() -> RawInput {
  {
    mouse_pos: @math.Vec2::zero(),
    mouse_down: false,
    scroll_delta: @math.Vec2::zero(),
    dt: 0.0166,
    events: [],
    text_input: "",
    modifiers: Modifiers::none(),
    mouse_secondary_down: false,
  }
}

///|
pub fn RawInput::from_mouse(
  mouse_pos : @math.Vec2,
  mouse_down : Bool,
  mouse_secondary_down? : Bool = false,
  dt? : Double = 0.0166,
) -> RawInput {
  {
    mouse_pos,
    mouse_down,
    scroll_delta: @math.Vec2::zero(),
    dt,
    events: [],
    text_input: "",
    modifiers: Modifiers::none(),
    mouse_secondary_down,
  }
}

///|
/// Full constructor for host drivers: pointer state plus the input events
/// collected during the frame. `Key` and `Event` are `pub(all)`, so a host
/// builds the events and passes them in; `text_input` carries the plain text
/// typed this frame and may be left empty when text arrives as events instead.
pub fn RawInput::with_events(
  mouse_pos : @math.Vec2,
  mouse_down : Bool,
  scroll_delta : @math.Vec2,
  events : Array[Event],
  text_input : String,
  modifiers : Modifiers,
  mouse_secondary_down? : Bool = false,
  dt? : Double = 0.0166,
) -> RawInput {
  {
    mouse_pos,
    mouse_down,
    scroll_delta,
    dt,
    events,
    text_input,
    modifiers,
    mouse_secondary_down,
  }
}

///|
pub struct InputState {
  mut mouse_pos : @math.Vec2
  mut mouse_prev_pos : @math.Vec2
  mut mouse_delta : @math.Vec2
  mut mouse_down : Bool
  mut mouse_pressed : Bool
  mut mouse_released : Bool
  mut mouse_secondary_down : Bool
  mut mouse_secondary_pressed : Bool
  mut mouse_secondary_released : Bool
  mut scroll_delta : @math.Vec2
  mut dt : Double
  keys_down : Array[Key]
  keys_pressed : Array[Key]
  keys_released : Array[Key]
  consumed_keys : Array[Key]
  mut text_input : String
  mut modifiers : Modifiers
  events : Array[Event]
} derive(Eq, Debug, Default)

///|
pub fn InputState::new() -> InputState {
  {
    mouse_pos: @math.Vec2::zero(),
    mouse_prev_pos: @math.Vec2::zero(),
    mouse_delta: @math.Vec2::zero(),
    mouse_down: false,
    mouse_pressed: false,
    mouse_released: false,
    mouse_secondary_down: false,
    mouse_secondary_pressed: false,
    mouse_secondary_released: false,
    scroll_delta: @math.Vec2::zero(),
    dt: 0.0166,
    keys_down: [],
    keys_pressed: [],
    keys_released: [],
    consumed_keys: [],
    text_input: "",
    modifiers: Modifiers::none(),
    events: [],
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

  let was_sec_down = self.mouse_secondary_down
  self.mouse_secondary_down = raw.mouse_secondary_down
  self.mouse_secondary_pressed = raw.mouse_secondary_down && !was_sec_down
  self.mouse_secondary_released = !raw.mouse_secondary_down && was_sec_down

  self.scroll_delta = raw.scroll_delta
  self.dt = if raw.dt > 0.0 { raw.dt } else { 0.0166 }

  self.keys_pressed.clear()
  self.keys_released.clear()
  self.consumed_keys.clear()
  self.text_input = raw.text_input
  self.modifiers = raw.modifiers
  self.events.clear()

  for ev in raw.events {
    self.events.push(ev)
    match ev {
      Key(k, is_pressed, _mods) =>
        if is_pressed {
          if !self.keys_down.contains(k) {
            self.keys_down.push(k)
          }
          self.keys_pressed.push(k)
        } else {
          // Remove from keys_down
          let mut found_idx = -1
          for i = 0; i < self.keys_down.length(); i = i + 1 {
            if self.keys_down[i] == k {
              found_idx = i
              break
            }
          }
          if found_idx >= 0 {
            let _ = self.keys_down.remove(found_idx)
            self.keys_released.push(k)
          }
        }
      TextInput(s) =>
        if self.text_input.is_empty() {
          self.text_input = s
        } else {
          self.text_input = self.text_input + s
        }
      PointerWheel(delta) => self.scroll_delta = self.scroll_delta.add(delta)
    }
  }
}

///|
pub fn InputState::mouse_pos(self : InputState) -> @math.Vec2 {
  self.mouse_pos
}

///|
pub fn InputState::mouse_down(self : InputState) -> Bool {
  self.mouse_down
}

///|
pub fn InputState::mouse_pressed(self : InputState) -> Bool {
  self.mouse_pressed
}

///|
pub fn InputState::mouse_released(self : InputState) -> Bool {
  self.mouse_released
}

///|
pub fn InputState::mouse_secondary_down(self : InputState) -> Bool {
  self.mouse_secondary_down
}

///|
pub fn InputState::mouse_secondary_pressed(self : InputState) -> Bool {
  self.mouse_secondary_pressed
}

///|
pub fn InputState::mouse_secondary_released(self : InputState) -> Bool {
  self.mouse_secondary_released
}

///|
pub fn InputState::consume_key(self : InputState, key : Key) -> Unit {
  if !self.consumed_keys.contains(key) {
    self.consumed_keys.push(key)
  }
}

///|
pub fn InputState::is_key_consumed(self : InputState, key : Key) -> Bool {
  self.consumed_keys.contains(key)
}

///|
pub fn InputState::mouse_delta(self : InputState) -> @math.Vec2 {
  self.mouse_delta
}

///|
pub fn InputState::scroll_delta(self : InputState) -> @math.Vec2 {
  self.scroll_delta
}

///|
pub fn InputState::dt(self : InputState) -> Double {
  self.dt
}

///|
pub fn InputState::key_down(self : InputState, key : Key) -> Bool {
  self.keys_down.contains(key)
}

///|
pub fn InputState::key_pressed(self : InputState, key : Key) -> Bool {
  self.keys_pressed.contains(key)
}

///|
pub fn InputState::key_released(self : InputState, key : Key) -> Bool {
  self.keys_released.contains(key)
}

///|
pub fn InputState::text_input(self : InputState) -> String {
  self.text_input
}

///|
pub fn InputState::modifiers(self : InputState) -> Modifiers {
  self.modifiers
}

///|
pub fn InputState::events(self : InputState) -> Array[Event] {
  self.events
}
