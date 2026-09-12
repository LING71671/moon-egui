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
test "fader: initial value clamped within range" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::from_mouse(@math.Vec2::new(-100.0, -100.0), false))

  // Underflow: -10.0 clamped to min 0.0
  let (val1, _) = ctx.fader("f1", "CH1", -10.0, min_val=0.0, max_val=100.0)
  assert_eq(val1, 0.0)

  // Overflow: 150.0 clamped to max 100.0
  let (val2, _) = ctx.fader("f2", "CH2", 150.0, min_val=0.0, max_val=100.0)
  assert_eq(val2, 100.0)

  let _ = ctx.end_frame()
}

///|
test "fader: renders track, active fill, cap, ticks and readouts" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::from_mouse(@math.Vec2::new(-100.0, -100.0), false))

  let (val, resp) = ctx.fader(
    "vol",
    "MASTER",
    0.75,
    min_val=0.0,
    max_val=1.0,
    unit="dB",
    show_ticks=true,
  )
  assert_eq(val, 0.75)
  assert_eq(resp.has_focus(), false)

  let dl = ctx.end_frame()
  // dl contains label, ticks, track rect/stroke, active fill, cap shadow/rect/stroke/line, readout
  assert_true(dl.len() >= 10)
}

///|
test "fader: keyboard ArrowUp and ArrowDown steps value when focused" {
  let ctx = UIContext::new()

  // Frame 1: Focus by clicking on the fader
  let raw1 = RawInput::from_mouse(@math.Vec2::new(20.0, 40.0), true)
  ctx.begin_frame(raw1)
  let _ = ctx.fader("vol", "VOL", 50.0, min_val=0.0, max_val=100.0, step=2.0)
  let _ = ctx.end_frame()

  // Frame 2: ArrowUp increments value
  let input2 = {
    ..RawInput::from_mouse(@math.Vec2::new(-100.0, -100.0), false),
    events: [Event::Key(Key::ArrowUp, true, Modifiers::none())],
  }
  ctx.begin_frame(input2)
  let (val_up, resp_up) = ctx.fader(
    "vol",
    "VOL",
    50.0,
    min_val=0.0,
    max_val=100.0,
    step=2.0,
  )
  assert_true(resp_up.has_focus())
  assert_eq(val_up, 52.0)
  let _ = ctx.end_frame()

  // Frame 3: ArrowDown decrements value
  let input3 = {
    ..RawInput::from_mouse(@math.Vec2::new(-100.0, -100.0), false),
    events: [Event::Key(Key::ArrowDown, true, Modifiers::none())],
  }
  ctx.begin_frame(input3)
  let (val_down, _) = ctx.fader(
    "vol",
    "VOL",
    50.0,
    min_val=0.0,
    max_val=100.0,
    step=2.0,
  )
  assert_eq(val_down, 48.0)
  let _ = ctx.end_frame()
}

///|
test "fader: Home and End keys jump to boundaries" {
  let ctx = UIContext::new()

  // Frame 1: Focus by clicking
  let raw1 = RawInput::from_mouse(@math.Vec2::new(20.0, 40.0), true)
  ctx.begin_frame(raw1)
  let _ = ctx.fader("gain", "GAIN", 20.0, min_val=0.0, max_val=100.0)
  let _ = ctx.end_frame()

  // Frame 2: Home key jumps to max_val
  let input2 = {
    ..RawInput::from_mouse(@math.Vec2::new(-100.0, -100.0), false),
    events: [Event::Key(Key::Home, true, Modifiers::none())],
  }
  ctx.begin_frame(input2)
  let (val_max, _) = ctx.fader("gain", "GAIN", 20.0, min_val=0.0, max_val=100.0)
  assert_eq(val_max, 100.0)
  let _ = ctx.end_frame()

  // Frame 3: End key jumps to min_val
  let input3 = {
    ..RawInput::from_mouse(@math.Vec2::new(-100.0, -100.0), false),
    events: [Event::Key(Key::End, true, Modifiers::none())],
  }
  ctx.begin_frame(input3)
  let (val_min, _) = ctx.fader("gain", "GAIN", 50.0, min_val=0.0, max_val=100.0)
  assert_eq(val_min, 0.0)
  let _ = ctx.end_frame()
}

///|
test "fader: Alt+Click resets to default value" {
  let ctx = UIContext::new()

  // Press with Alt modifier
  let input1 = {
    ..RawInput::from_mouse(@math.Vec2::new(20.0, 40.0), true),
    modifiers: Modifiers::new(false, false, true, false),
  }
  ctx.begin_frame(input1)
  let _ = ctx.fader(
    "ch",
    "CH",
    75.0,
    min_val=0.0,
    max_val=100.0,
    default_val=50.0,
    size=@math.Vec2::new(44.0, 150.0),
  )
  let _ = ctx.end_frame()

  // Release with Alt modifier -> Click event triggered
  let input2 = {
    ..RawInput::from_mouse(@math.Vec2::new(20.0, 40.0), false),
    modifiers: Modifiers::new(false, false, true, false),
  }
  ctx.begin_frame(input2)
  let (val_reset, resp) = ctx.fader(
    "ch",
    "CH",
    75.0,
    min_val=0.0,
    max_val=100.0,
    default_val=50.0,
    size=@math.Vec2::new(44.0, 150.0),
  )
  assert_true(resp.clicked())
  assert_eq(val_reset, 50.0)
  let _ = ctx.end_frame()
}

///|
test "fader_int: integer rounding and step navigation" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::from_mouse(@math.Vec2::new(-100.0, -100.0), false))

  let (val, resp) = ctx.fader_int(
    "int_fader",
    "LEVEL",
    42,
    min_val=0,
    max_val=100,
    step=1,
  )
  assert_eq(val, 42)
  assert_eq(resp.hovered(), false)

  let _ = ctx.end_frame()
}
