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
test "widgets: stepper builder and default show" {
  let ctx = UIContext::new()
  ctx.begin_frame(@core.RawInput::new())

  let (val, resp) = Stepper::new("test_stepper", 10.0)
    .step(2.0)
    .range(0.0, 100.0)
    .suffix(" px")
    .show(ctx)

  assert_eq(val, 10.0)
  assert_true(resp.rect.w >= 100.0)
  assert_true(resp.rect.h > 0.0)

  let dl = ctx.end_frame()
  assert_true(dl.len() > 0)
}

///|
test "widgets: stepper click minus and plus buttons" {
  let ctx = UIContext::new()

  // Frame 1: Mouse down on plus button (right end of stepper at x=105.0, y=10.0, total w=112)
  let raw1 = @core.RawInput::from_mouse(@math.Vec2::new(105.0, 10.0), true)
  ctx.begin_frame(raw1)
  let (v1, _) = stepper(ctx, "step1", 5.0, step=1.0)
  assert_eq(v1, 5.0)
  let _ = ctx.end_frame()

  // Frame 2: Release mouse on plus button -> click triggered!
  let raw2 = @core.RawInput::from_mouse(@math.Vec2::new(105.0, 10.0), false)
  ctx.begin_frame(raw2)
  let (v2, r2) = stepper(ctx, "step1", 5.0, step=1.0)
  assert_eq(v2, 6.0)
  assert_true(r2.hovered())
  let _ = ctx.end_frame()

  // Frame 3: Mouse down on minus button (left end at x=5.0, y=10.0)
  let raw3 = @core.RawInput::from_mouse(@math.Vec2::new(5.0, 10.0), true)
  ctx.begin_frame(raw3)
  let (v3, _) = stepper(ctx, "step1", 6.0, step=1.0)
  assert_eq(v3, 6.0)
  let _ = ctx.end_frame()

  // Frame 4: Release mouse on minus button -> click triggered!
  let raw4 = @core.RawInput::from_mouse(@math.Vec2::new(5.0, 10.0), false)
  ctx.begin_frame(raw4)
  let (v4, _) = stepper(ctx, "step1", 6.0, step=1.0)
  assert_eq(v4, 5.0)
  let _ = ctx.end_frame()
}

///|
test "widgets: stepper modifiers Shift and Ctrl" {
  let ctx = UIContext::new()

  // Frame 1: Shift held down on plus button -> 10x step
  let raw_shift = @core.RawInput::with_events(
    @math.Vec2::new(105.0, 10.0),
    true,
    @math.Vec2::zero(),
    [],
    "",
    @core.Modifiers::shift(),
  )
  ctx.begin_frame(raw_shift)
  let _ = stepper(ctx, "mod_step", 10.0, step=1.0)
  let _ = ctx.end_frame()

  let raw_shift_rel = @core.RawInput::with_events(
    @math.Vec2::new(105.0, 10.0),
    false,
    @math.Vec2::zero(),
    [],
    "",
    @core.Modifiers::shift(),
  )
  ctx.begin_frame(raw_shift_rel)
  let (v_shift, _) = stepper(ctx, "mod_step", 10.0, step=1.0)
  assert_eq(v_shift, 20.0) // 10 + 1 * 10
  let _ = ctx.end_frame()

  // Frame 2: Ctrl held down on plus button -> 0.1x step
  let raw_ctrl = @core.RawInput::with_events(
    @math.Vec2::new(105.0, 10.0),
    true,
    @math.Vec2::zero(),
    [],
    "",
    @core.Modifiers::ctrl(),
  )
  ctx.begin_frame(raw_ctrl)
  let _ = stepper(ctx, "mod_step", 20.0, step=1.0)
  let _ = ctx.end_frame()

  let raw_ctrl_rel = @core.RawInput::with_events(
    @math.Vec2::new(105.0, 10.0),
    false,
    @math.Vec2::zero(),
    [],
    "",
    @core.Modifiers::ctrl(),
  )
  ctx.begin_frame(raw_ctrl_rel)
  let (v_ctrl, _) = stepper(ctx, "mod_step", 20.0, step=1.0)
  assert_eq(v_ctrl, 20.1) // 20 + 1 * 0.1
  let _ = ctx.end_frame()
}

///|
test "widgets: stepper bounds clamping" {
  let ctx = UIContext::new()

  // Click plus at max limit
  let raw1 = @core.RawInput::from_mouse(@math.Vec2::new(105.0, 10.0), true)
  ctx.begin_frame(raw1)
  let _ = stepper(ctx, "clamp_step", 9.5, step=1.0, max=10.0)
  let _ = ctx.end_frame()

  let raw2 = @core.RawInput::from_mouse(@math.Vec2::new(105.0, 10.0), false)
  ctx.begin_frame(raw2)
  let (v_max, _) = stepper(ctx, "clamp_step", 9.5, step=1.0, max=10.0)
  assert_eq(v_max, 10.0)
  let _ = ctx.end_frame()

  // Click minus at min limit
  let raw3 = @core.RawInput::from_mouse(@math.Vec2::new(5.0, 10.0), true)
  ctx.begin_frame(raw3)
  let _ = stepper(ctx, "clamp_step", 0.5, step=1.0, min=0.0)
  let _ = ctx.end_frame()

  let raw4 = @core.RawInput::from_mouse(@math.Vec2::new(5.0, 10.0), false)
  ctx.begin_frame(raw4)
  let (v_min, _) = stepper(ctx, "clamp_step", 0.5, step=1.0, min=0.0)
  assert_eq(v_min, 0.0)
  let _ = ctx.end_frame()
}

///|
test "widgets: stepper mouse wheel stepping" {
  let ctx = UIContext::new()

  // Hover over stepper with negative scroll delta (wheel up -> increment)
  let raw_up = @core.RawInput::with_events(
    @math.Vec2::new(50.0, 10.0),
    false,
    @math.Vec2::new(0.0, -10.0),
    [],
    "",
    @core.Modifiers::none(),
  )
  ctx.begin_frame(raw_up)
  let (v_up, _) = stepper(ctx, "wheel_step", 15.0, step=2.0)
  assert_eq(v_up, 17.0)
  let _ = ctx.end_frame()

  // Hover over stepper with positive scroll delta (wheel down -> decrement)
  let raw_down = @core.RawInput::with_events(
    @math.Vec2::new(50.0, 10.0),
    false,
    @math.Vec2::new(0.0, 10.0),
    [],
    "",
    @core.Modifiers::none(),
  )
  ctx.begin_frame(raw_down)
  let (v_down, _) = stepper(ctx, "wheel_step", 17.0, step=2.0)
  assert_eq(v_down, 15.0)
  let _ = ctx.end_frame()
}

///|
test "widgets: stepper keyboard arrow navigation" {
  let ctx = UIContext::new()

  // Frame 1: Tab to focus the stepper
  let raw_tab = @core.RawInput::with_events(
    @math.Vec2::zero(),
    false,
    @math.Vec2::zero(),
    [@core.Event::Key(@core.Key::Tab, true, @core.Modifiers::none())],
    "",
    @core.Modifiers::none(),
  )
  ctx.begin_frame(raw_tab)
  let (v0, _) = stepper(ctx, "kb_step", 50.0, step=5.0)
  assert_eq(v0, 50.0)
  let _ = ctx.end_frame()

  // Frame 2: Stepper has focus; press ArrowRight to increment
  let raw_right = @core.RawInput::with_events(
    @math.Vec2::zero(),
    false,
    @math.Vec2::zero(),
    [@core.Event::Key(@core.Key::ArrowRight, true, @core.Modifiers::none())],
    "",
    @core.Modifiers::none(),
  )
  ctx.begin_frame(raw_right)
  let (v_right, _) = stepper(ctx, "kb_step", 50.0, step=5.0)
  assert_eq(v_right, 55.0)
  let _ = ctx.end_frame()

  // Frame 3: Press ArrowDown to decrement
  let raw_down = @core.RawInput::with_events(
    @math.Vec2::zero(),
    false,
    @math.Vec2::zero(),
    [@core.Event::Key(@core.Key::ArrowDown, true, @core.Modifiers::none())],
    "",
    @core.Modifiers::none(),
  )
  ctx.begin_frame(raw_down)
  let (v_down, _) = stepper(ctx, "kb_step", 55.0, step=5.0)
  assert_eq(v_down, 50.0)
  let _ = ctx.end_frame()
}

///|
test "widgets: stepper from_ref binding" {
  let ctx = UIContext::new()
  let target = Ref(42.0)

  // Frame 1: mouse down on plus
  let raw1 = @core.RawInput::from_mouse(@math.Vec2::new(105.0, 10.0), true)
  ctx.begin_frame(raw1)
  let _ = ctx.add(Stepper::from_ref("ref_step", target).step(2.0))
  let _ = ctx.end_frame()

  // Frame 2: mouse release on plus -> target updated!
  let raw2 = @core.RawInput::from_mouse(@math.Vec2::new(105.0, 10.0), false)
  ctx.begin_frame(raw2)
  let _ = ctx.add(Stepper::from_ref("ref_step", target).step(2.0))
  let _ = ctx.end_frame()

  assert_eq(target.val, 44.0)
}

///|
test "widgets: stepper cursor semantics" {
  let ctx = UIContext::new()

  // Hover on minus button
  let raw_minus = @core.RawInput::from_mouse(@math.Vec2::new(5.0, 10.0), false)
  ctx.begin_frame(raw_minus)
  let _ = stepper(ctx, "cursor_step", 0.0)
  let _ = ctx.end_frame()
  assert_eq(ctx.cursor_icon(), "pointer")

  // Hover on value box (center at x=50.0, y=10.0)
  let raw_val = @core.RawInput::from_mouse(@math.Vec2::new(50.0, 10.0), false)
  ctx.begin_frame(raw_val)
  let _ = stepper(ctx, "cursor_step", 0.0)
  let _ = ctx.end_frame()
  assert_eq(ctx.cursor_icon(), "ew-resize")
}
