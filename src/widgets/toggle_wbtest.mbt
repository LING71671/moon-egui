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
test "widgets: checkbox and toggle helpers" {
  let ctx = @core.UIContext::new()
  ctx.begin_frame(@core.RawInput::new())
  let (c, r1) = checkbox(ctx, "Accept", false)
  assert_false(c)
  assert_false(r1.clicked())

  let (t, r2) = toggle(ctx, "Active", true)
  assert_true(t)
  assert_false(r2.clicked())

  let (rad, r3) = radio(ctx, "Option A", true)
  assert_true(rad)
  assert_false(r3.clicked())

  let dl = ctx.end_frame()
  assert_true(dl.len() > 0)
}

///|
test "widgets: checkbox and toggle ref builders" {
  let ctx = @core.UIContext::new()
  let checked = Ref(true)
  let toggled = Ref(false)

  ctx.begin_frame(@core.RawInput::new())
  let _ = ctx.add(Checkbox::from_ref("Agree", checked))
  let _ = ctx.add(Toggle::from_ref("Power", toggled))
  assert_true(checked.val)
  assert_false(toggled.val)
  let _ = ctx.end_frame()
}

///|
test "widgets: radio and toggle keyboard activation via Space and Enter" {
  let ctx = @core.UIContext::new()

  // Frame 1: Tab focuses the radio button
  let raw1 = @core.RawInput::with_events(
    @math.Vec2::zero(),
    false,
    @math.Vec2::zero(),
    [@core.Event::Key(@core.Key::Tab, true, @core.Modifiers::none())],
    "",
    @core.Modifiers::none(),
  )
  ctx.begin_frame(raw1)
  let (r_val1, _) = radio(ctx, "Option 1", false)
  let (t_val1, _) = toggle(ctx, "Switch", false)
  let _ = ctx.end_frame()
  assert_false(r_val1)
  assert_false(t_val1)

  // Frame 2: Radio is focused. Press Space -> selects option
  let raw2 = @core.RawInput::with_events(
    @math.Vec2::zero(),
    false,
    @math.Vec2::zero(),
    [@core.Event::Key(@core.Key::Space, true, @core.Modifiers::none())],
    "",
    @core.Modifiers::none(),
  )
  ctx.begin_frame(raw2)
  let (r_val2, r_resp2) = radio(ctx, "Option 1", false)
  let _ = toggle(ctx, "Switch", false)
  let _ = ctx.end_frame()
  assert_true(r_resp2.has_focus())
  assert_true(r_val2)

  // Frame 3: Tab to focus the Toggle switch
  let raw3 = @core.RawInput::with_events(
    @math.Vec2::zero(),
    false,
    @math.Vec2::zero(),
    [@core.Event::Key(@core.Key::Tab, true, @core.Modifiers::none())],
    "",
    @core.Modifiers::none(),
  )
  ctx.begin_frame(raw3)
  let _ = radio(ctx, "Option 1", true)
  let _ = toggle(ctx, "Switch", false)
  let _ = ctx.end_frame()

  // Frame 4: Toggle is focused. Press Enter -> toggles ON
  let raw4 = @core.RawInput::with_events(
    @math.Vec2::zero(),
    false,
    @math.Vec2::zero(),
    [@core.Event::Key(@core.Key::Enter, true, @core.Modifiers::none())],
    "",
    @core.Modifiers::none(),
  )
  ctx.begin_frame(raw4)
  let _ = radio(ctx, "Option 1", true)
  let (t_val4, t_resp4) = toggle(ctx, "Switch", false)
  let _ = ctx.end_frame()
  assert_true(t_resp4.has_focus())
  assert_true(t_val4)
}
