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
/// Translate a DOM `KeyboardEvent.key` value into a library `Key`.
///
/// Only named keys are mapped: printable characters travel through the text
/// channel (`Event::TextInput`) instead, which keeps this table small and lets
/// the browser handle layout, dead keys and IME composition.
fn host_key(name : String) -> @core.Key? {
  match name {
    "Tab" => Some(@core.Key::Tab)
    "Enter" => Some(@core.Key::Enter)
    "Escape" => Some(@core.Key::Escape)
    " " => Some(@core.Key::Space)
    "ArrowUp" => Some(@core.Key::ArrowUp)
    "ArrowDown" => Some(@core.Key::ArrowDown)
    "ArrowLeft" => Some(@core.Key::ArrowLeft)
    "ArrowRight" => Some(@core.Key::ArrowRight)
    "PageUp" => Some(@core.Key::PageUp)
    "PageDown" => Some(@core.Key::PageDown)
    "Home" => Some(@core.Key::Home)
    "End" => Some(@core.Key::End)
    "Backspace" => Some(@core.Key::Backspace)
    "Delete" => Some(@core.Key::Delete)
    _ => None
  }
}

///|
/// Build the input payload for one frame from the primitives the host driver
/// collects. Keeping the boundary to strings, booleans and numbers avoids
/// depending on the mangled names of library constructors from JavaScript.
fn host_raw_input(
  mouse_x : Double,
  mouse_y : Double,
  mouse_down : Bool,
  text_input : String,
  keys_pressed : Array[String],
  keys_released : Array[String],
  mod_flags : Int,
  scroll_dy? : Double = 0.0,
  mouse_secondary_down? : Bool = false,
) -> @core.RawInput {
  // mod_flags: bit 0 shift, bit 1 ctrl, bit 2 alt, bit 3 meta
  let mods = @core.Modifiers::new(
    (mod_flags & 2) != 0,
    (mod_flags & 1) != 0,
    (mod_flags & 4) != 0,
    (mod_flags & 8) != 0,
  )

  let events : Array[@core.Event] = []
  for name in keys_pressed {
    match host_key(name) {
      Some(key) => events.push(@core.Event::Key(key, true, mods))
      None => ()
    }
  }
  for name in keys_released {
    match host_key(name) {
      Some(key) => events.push(@core.Event::Key(key, false, mods))
      None => ()
    }
  }
  // Text goes through the event channel, not the `text_input` field: the field
  // is overwritten every frame while events append to whatever is pending, so
  // typing several characters inside one frame is preserved.
  if !text_input.is_empty() {
    events.push(@core.Event::TextInput(text_input))
  }

  @core.RawInput::with_events(
    @math.Vec2::new(mouse_x, mouse_y),
    mouse_down,
    @math.Vec2::new(0.0, scroll_dy),
    events,
    text_input,
    mods,
    mouse_secondary_down~,
  )
}

///|
/// Parse a non-negative decimal index. Returns None for anything else, so a
/// half-typed field never jumps somewhere surprising.
fn parse_index(text : String) -> Int? {
  if text.is_empty() {
    return None
  }
  let mut value = 0
  for i = 0; i < text.length(); i = i + 1 {
    let ch = text[i]
    if ch < '0' || ch > '9' {
      return None
    }
    value = value * 10 + (ch.to_int() - 48)
  }
  Some(value)
}
