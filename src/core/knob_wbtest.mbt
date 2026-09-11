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
test "knob: initial value clamped within range" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::new())

  // Underflow: -5.0 clamped to min 0.0
  let (val1, _) = ctx.knob("k1", "VOL", -5.0, min_val=0.0, max_val=10.0)
  assert_eq(val1, 0.0)

  // Overflow: 15.0 clamped to max 10.0
  let (val2, _) = ctx.knob("k2", "VOL", 15.0, min_val=0.0, max_val=10.0)
  assert_eq(val2, 10.0)

  let _ = ctx.end_frame()
}

///|
test "knob: unipolar renders track, active arc, cap, tick and text" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::new())

  let (val, resp) = ctx.knob(
    "vol",
    "VOLUME",
    0.5,
    min_val=0.0,
    max_val=1.0,
    unit="%",
  )
  assert_eq(val, 0.5)
  assert_eq(resp.has_focus(), false)

  let dl = ctx.end_frame()
  // Track lines + active arc lines + shadow circle + face circle + stroke circle + tick line + 2 texts > 15
  assert_true(dl.len() >= 15)
}

///|
test "knob: bipolar mode sweeps correctly" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::new())

  // Bipolar pan at center (0.0)
  let (val_center, _) = ctx.knob(
    "pan",
    "PAN",
    0.0,
    min_val=-1.0,
    max_val=1.0,
    bipolar=true,
  )
  assert_eq(val_center, 0.0)

  // Bipolar pan at left (-0.5)
  let (val_left, _) = ctx.knob(
    "pan_left",
    "PAN",
    -0.5,
    min_val=-1.0,
    max_val=1.0,
    bipolar=true,
  )
  assert_eq(val_left, -0.5)

  let _ = ctx.end_frame()
}

///|
test "knob: mouse vertical dragging increments value" {
  let ctx = UIContext::new()

  // Frame 1: click knob to activate
  let raw1 = RawInput::from_mouse(@math.Vec2::new(30.0, 30.0), true)
  ctx.begin_frame(raw1)
  let (v1, r1) = ctx.knob(
    "gain",
    "GAIN",
    0.5,
    min_val=0.0,
    max_val=1.0,
    step=0.0,
  )
  assert_eq(v1, 0.5)
  assert_true(r1.pressed())
  let _ = ctx.end_frame()

  // Frame 2: mouse moved up by 20 pixels (delta y = -20) -> should increase
  let raw2 = {
    mouse_pos: @math.Vec2::new(30.0, 10.0),
    mouse_down: true,
    scroll_delta: @math.Vec2::zero(),
    dt: 0.0166,
    events: [],
    text_input: "",
    modifiers: Modifiers::none(),
  }
  ctx.begin_frame(raw2)
  let (v2, _) = ctx.knob("gain", "GAIN", v1, min_val=0.0, max_val=1.0, step=0.0)
  // dy = -(-20) = +20, delta = 20 * 1.0 * 0.005 = 0.1
  assert_true(v2 > 0.55)
  let _ = ctx.end_frame()
}

///|
test "knob: shift key scales drag sensitivity to fine tuning" {
  let ctx = UIContext::new()

  // Frame 1: activate
  let raw1 = RawInput::from_mouse(@math.Vec2::new(30.0, 30.0), true)
  ctx.begin_frame(raw1)
  let (v1, _) = ctx.knob(
    "tune",
    "TUNE",
    0.5,
    min_val=0.0,
    max_val=1.0,
    step=0.0,
  )
  let _ = ctx.end_frame()

  // Frame 2: move up with Shift key held
  let raw2 = {
    mouse_pos: @math.Vec2::new(30.0, 10.0),
    mouse_down: true,
    scroll_delta: @math.Vec2::zero(),
    dt: 0.0166,
    events: [],
    text_input: "",
    modifiers: { ctrl: false, shift: true, alt: false, meta: false, },
  }
  ctx.begin_frame(raw2)
  let (v2, _) = ctx.knob("tune", "TUNE", v1, min_val=0.0, max_val=1.0, step=0.0)
  // dy = +20, with shift sensitivity is 0.001 -> delta = 20 * 0.001 = 0.02
  assert_true(v2 > 0.5)
  assert_true(v2 < 0.55) // Much smaller increment than normal 0.1
  let _ = ctx.end_frame()
}

///|
test "knob: mouse scroll wheel step advancement" {
  let ctx = UIContext::new()

  // Hover over knob at (30, 30) and scroll wheel upwards
  let raw = {
    mouse_pos: @math.Vec2::new(30.0, 30.0),
    mouse_down: false,
    scroll_delta: @math.Vec2::new(0.0, 1.0),
    dt: 0.0166,
    events: [Event::PointerWheel(@math.Vec2::new(0.0, 1.0))],
    text_input: "",
    modifiers: Modifiers::none(),
  }
  ctx.begin_frame(raw)
  let (val, _) = ctx.knob(
    "freq",
    "FREQ",
    100.0,
    min_val=20.0,
    max_val=1000.0,
    step=10.0,
  )
  assert_eq(val, 110.0)
  let _ = ctx.end_frame()
}

///|
test "knob: keyboard arrows and home/end navigation" {
  let ctx = UIContext::new()

  // Focus the knob
  let raw1 = RawInput::from_mouse(@math.Vec2::new(30.0, 30.0), true)
  ctx.begin_frame(raw1)
  let _ = ctx.knob("res", "RES", 0.5, min_val=0.0, max_val=1.0, step=0.1)
  let _ = ctx.end_frame()

  // ArrowUp
  let raw2 = {
    mouse_pos: @math.Vec2::new(0.0, 0.0),
    mouse_down: false,
    scroll_delta: @math.Vec2::zero(),
    dt: 0.0166,
    events: [Event::Key(Key::ArrowUp, true, Modifiers::none())],
    text_input: "",
    modifiers: Modifiers::none(),
  }
  ctx.begin_frame(raw2)
  let (v2, _) = ctx.knob("res", "RES", 0.5, min_val=0.0, max_val=1.0, step=0.1)
  assert_true((v2 - 0.6).abs() < 0.0001)
  let _ = ctx.end_frame()

  // End key -> max_val
  let raw3 = {
    mouse_pos: @math.Vec2::new(0.0, 0.0),
    mouse_down: false,
    scroll_delta: @math.Vec2::zero(),
    dt: 0.0166,
    events: [Event::Key(Key::End, true, Modifiers::none())],
    text_input: "",
    modifiers: Modifiers::none(),
  }
  ctx.begin_frame(raw3)
  let (v3, _) = ctx.knob("res", "RES", 0.6, min_val=0.0, max_val=1.0, step=0.1)
  assert_eq(v3, 1.0)
  let _ = ctx.end_frame()

  // Home key -> min_val
  let raw4 = {
    mouse_pos: @math.Vec2::new(0.0, 0.0),
    mouse_down: false,
    scroll_delta: @math.Vec2::zero(),
    dt: 0.0166,
    events: [Event::Key(Key::Home, true, Modifiers::none())],
    text_input: "",
    modifiers: Modifiers::none(),
  }
  ctx.begin_frame(raw4)
  let (v4, _) = ctx.knob("res", "RES", 1.0, min_val=0.0, max_val=1.0, step=0.1)
  assert_eq(v4, 0.0)
  let _ = ctx.end_frame()
}

///|
test "knob: alt+click and backspace reset to default_val" {
  let ctx = UIContext::new()

  // Alt + Click at (30, 30)
  let raw1 = {
    mouse_pos: @math.Vec2::new(30.0, 30.0),
    mouse_down: true,
    scroll_delta: @math.Vec2::zero(),
    dt: 0.0166,
    events: [],
    text_input: "",
    modifiers: { ctrl: false, shift: false, alt: true, meta: false, },
  }
  ctx.begin_frame(raw1)
  let (v1, _) = ctx.knob(
    "reset_k",
    "RESET",
    0.9,
    min_val=0.0,
    max_val=1.0,
    default_val=0.25,
  )
  assert_eq(v1, 0.25)
  let _ = ctx.end_frame()

  // Frame 2: Focus the knob and press Backspace
  let raw2 = {
    mouse_pos: @math.Vec2::zero(),
    mouse_down: false,
    scroll_delta: @math.Vec2::zero(),
    dt: 0.0166,
    events: [Event::Key(Key::Backspace, true, Modifiers::none())],
    text_input: "",
    modifiers: Modifiers::none(),
  }
  ctx.begin_frame(raw2)
  let (v2, _) = ctx.knob(
    "reset_k",
    "RESET",
    0.8,
    min_val=0.0,
    max_val=1.0,
    default_val=0.25,
  )
  assert_eq(v2, 0.25)
  let _ = ctx.end_frame()
}
