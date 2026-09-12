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
test "composite: fader renders channel, track and cap" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::new())

  let (val, resp) = fader(
    ctx,
    "master_fader",
    "MASTER",
    0.8,
    min_val=0.0,
    max_val=1.0,
    unit="dB",
  )
  let dl = ctx.end_frame()

  assert_eq(val, 0.8)
  assert_true(resp.rect.w >= 44.0)
  assert_true(resp.rect.h >= 150.0)
  assert_true(dl.len() > 5)
}

///|
test "composite: fader integer variant" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::new())

  let (val, _resp) = fader_int(
    ctx,
    "chan1_fader",
    "CH 1",
    50,
    min_val=0,
    max_val=100,
    unit="%",
  )
  let _ = ctx.end_frame()

  assert_eq(val, 50)
}

///|
test "composite: fader fluent builder and ref binding" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::new())

  let target = Ref(0.0)
  let f_ref = Fader::from_ref("f_bld", "GAIN", target)
    .min(-60.0)
    .max(12.0)
    .default_val(0.0)
  let resp = ctx.add(f_ref)
  let _ = ctx.end_frame()

  assert_eq(target.val, 0.0)
  assert_true(!resp.clicked())
}

///|
test "fader: initial value clamped within range" {
  let ctx = @core.UIContext::new()
  ctx.begin_frame(
    @core.RawInput::from_mouse(@math.Vec2::new(-100.0, -100.0), false),
  )

  // Underflow: -10.0 clamped to min 0.0
  let (val1, _) = Fader::new("f1", "CH1", -10.0).min(0.0).max(100.0).show(ctx)
  assert_eq(val1, 0.0)

  // Overflow: 150.0 clamped to max 100.0
  let (val2, _) = Fader::new("f2", "CH2", 150.0).min(0.0).max(100.0).show(ctx)
  assert_eq(val2, 100.0)

  let _ = ctx.end_frame()
}

///|
test "fader: renders track, active fill, cap, ticks and readouts" {
  let ctx = @core.UIContext::new()
  ctx.begin_frame(
    @core.RawInput::from_mouse(@math.Vec2::new(-100.0, -100.0), false),
  )

  let (val, resp) = Fader::new("vol", "MASTER", 0.75)
    .min(0.0)
    .max(1.0)
    .unit("dB")
    .show_ticks(true)
    .show(ctx)
  assert_eq(val, 0.75)
  assert_eq(resp.has_focus(), false)

  let dl = ctx.end_frame()
  // dl contains label, ticks, track rect/stroke, active fill, cap shadow/rect/stroke/line, readout
  assert_true(dl.len() >= 10)
}

///|
test "fader: keyboard ArrowUp and ArrowDown steps value when focused" {
  let ctx = @core.UIContext::new()

  // Frame 1: Focus by clicking on the fader
  let raw1 = @core.RawInput::from_mouse(@math.Vec2::new(20.0, 40.0), true)
  ctx.begin_frame(raw1)
  let _ = Fader::new("vol", "VOL", 50.0).min(0.0).max(100.0).step(2.0).show(ctx)
  let _ = ctx.end_frame()

  // Frame 2: ArrowUp increments value
  let input2 = @core.RawInput::with_events(
    @math.Vec2::new(-100.0, -100.0),
    false,
    @math.Vec2::zero(),
    [@core.Event::Key(@core.Key::ArrowUp, true, @core.Modifiers::none())],
    "",
    @core.Modifiers::none(),
  )
  ctx.begin_frame(input2)
  let (val_up, resp_up) = Fader::new("vol", "VOL", 50.0)
    .min(0.0)
    .max(100.0)
    .step(2.0)
    .show(ctx)
  assert_true(resp_up.has_focus())
  assert_eq(val_up, 52.0)
  let _ = ctx.end_frame()

  // Frame 3: ArrowDown decrements value
  let input3 = @core.RawInput::with_events(
    @math.Vec2::new(-100.0, -100.0),
    false,
    @math.Vec2::zero(),
    [@core.Event::Key(@core.Key::ArrowDown, true, @core.Modifiers::none())],
    "",
    @core.Modifiers::none(),
  )
  ctx.begin_frame(input3)
  let (val_down, _) = Fader::new("vol", "VOL", 50.0)
    .min(0.0)
    .max(100.0)
    .step(2.0)
    .show(ctx)
  assert_eq(val_down, 48.0)
  let _ = ctx.end_frame()
}

///|
test "fader: Home and End keys jump to boundaries" {
  let ctx = @core.UIContext::new()

  // Frame 1: Focus by clicking
  let raw1 = @core.RawInput::from_mouse(@math.Vec2::new(20.0, 40.0), true)
  ctx.begin_frame(raw1)
  let _ = Fader::new("gain", "GAIN", 20.0).min(0.0).max(100.0).show(ctx)
  let _ = ctx.end_frame()

  // Frame 2: Home key jumps to max_val
  let input2 = @core.RawInput::with_events(
    @math.Vec2::new(-100.0, -100.0),
    false,
    @math.Vec2::zero(),
    [@core.Event::Key(@core.Key::Home, true, @core.Modifiers::none())],
    "",
    @core.Modifiers::none(),
  )
  ctx.begin_frame(input2)
  let (val_max, _) = Fader::new("gain", "GAIN", 20.0)
    .min(0.0)
    .max(100.0)
    .show(ctx)
  assert_eq(val_max, 100.0)
  let _ = ctx.end_frame()

  // Frame 3: End key jumps to min_val
  let input3 = @core.RawInput::with_events(
    @math.Vec2::new(-100.0, -100.0),
    false,
    @math.Vec2::zero(),
    [@core.Event::Key(@core.Key::End, true, @core.Modifiers::none())],
    "",
    @core.Modifiers::none(),
  )
  ctx.begin_frame(input3)
  let (val_min, _) = Fader::new("gain", "GAIN", 50.0)
    .min(0.0)
    .max(100.0)
    .show(ctx)
  assert_eq(val_min, 0.0)
  let _ = ctx.end_frame()
}

///|
test "fader: Alt+Click resets to default value" {
  let ctx = @core.UIContext::new()

  // Press with Alt modifier
  let input1 = @core.RawInput::with_events(
    @math.Vec2::new(20.0, 40.0),
    true,
    @math.Vec2::zero(),
    [],
    "",
    @core.Modifiers::new(false, false, true, false),
  )
  ctx.begin_frame(input1)
  let _ = Fader::new("ch", "CH", 75.0)
    .min(0.0)
    .max(100.0)
    .default_val(50.0)
    .size(@math.Vec2::new(44.0, 150.0))
    .show(ctx)
  let _ = ctx.end_frame()

  // Release with Alt modifier -> Click event triggered
  let input2 = @core.RawInput::with_events(
    @math.Vec2::new(20.0, 40.0),
    false,
    @math.Vec2::zero(),
    [],
    "",
    @core.Modifiers::new(false, false, true, false),
  )
  ctx.begin_frame(input2)
  let (val_reset, resp) = Fader::new("ch", "CH", 75.0)
    .min(0.0)
    .max(100.0)
    .default_val(50.0)
    .size(@math.Vec2::new(44.0, 150.0))
    .show(ctx)
  assert_true(resp.clicked())
  assert_eq(val_reset, 50.0)
  let _ = ctx.end_frame()
}

///|
test "fader_int: integer rounding and step navigation" {
  let ctx = @core.UIContext::new()
  ctx.begin_frame(
    @core.RawInput::from_mouse(@math.Vec2::new(-100.0, -100.0), false),
  )

  let (val, resp) = fader_int(
    ctx,
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
