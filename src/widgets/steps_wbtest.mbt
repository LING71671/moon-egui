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
test "widgets: steps builder and automatic status derivation" {
  let ctx = UIContext::new()
  ctx.begin_frame(@core.RawInput::new())

  let items = [
    StepItem::new("Account", description="Login info"),
    StepItem::new("Profile", description="Personal details"),
    StepItem::new("Review", description="Final check"),
  ]

  let (idx, resp) = Steps::new("test_steps", 1, items).width(360.0).show(ctx)

  assert_eq(idx, 1)
  assert_eq(resp.rect.w, 360.0)
  assert_true(resp.rect.h >= 56.0)

  let dl = ctx.end_frame()
  assert_true(dl.len() > 0)
}

///|
test "widgets: steps click to switch step" {
  let ctx = UIContext::new()
  let items = [
    StepItem::new("Step 1"),
    StepItem::new("Step 2"),
    StepItem::new("Step 3"),
  ]
  // Total width is 300.0. Each step is 100.0 wide.
  // Step 0: [0..100], Step 1: [100..200], Step 2: [200..300]

  // Frame 1: Mouse down on Step 2 (x=250.0, y=10.0)
  let raw1 = @core.RawInput::from_mouse(@math.Vec2::new(250.0, 10.0), true)
  ctx.begin_frame(raw1)
  let (idx1, _) = steps(ctx, "steps_click", 0, items, width=300.0)
  assert_eq(idx1, 0)
  let _ = ctx.end_frame()

  // Frame 2: Mouse release on Step 2 -> current switches to 2!
  let raw2 = @core.RawInput::from_mouse(@math.Vec2::new(250.0, 10.0), false)
  ctx.begin_frame(raw2)
  let (idx2, _) = steps(ctx, "steps_click", 0, items, width=300.0)
  assert_eq(idx2, 2)
  let _ = ctx.end_frame()
}

///|
test "widgets: steps keyboard navigation" {
  let ctx = UIContext::new()
  let items = [
    StepItem::new("First"),
    StepItem::new("Second"),
    StepItem::new("Third"),
    StepItem::new("Fourth"),
  ]

  // Frame 1: Tab to focus steps
  let raw_tab = @core.RawInput::with_events(
    @math.Vec2::zero(),
    false,
    @math.Vec2::zero(),
    [@core.Event::Key(@core.Key::Tab, true, @core.Modifiers::none())],
    "",
    @core.Modifiers::none(),
  )
  ctx.begin_frame(raw_tab)
  let (idx0, _) = steps(ctx, "steps_kb", 0, items, width=400.0)
  assert_eq(idx0, 0)
  let _ = ctx.end_frame()

  // Frame 2: ArrowRight steps to index 1
  let raw_right = @core.RawInput::with_events(
    @math.Vec2::zero(),
    false,
    @math.Vec2::zero(),
    [@core.Event::Key(@core.Key::ArrowRight, true, @core.Modifiers::none())],
    "",
    @core.Modifiers::none(),
  )
  ctx.begin_frame(raw_right)
  let (idx1, _) = steps(ctx, "steps_kb", 0, items, width=400.0)
  assert_eq(idx1, 1)
  let _ = ctx.end_frame()

  // Frame 3: End steps to index 3 (last)
  let raw_end = @core.RawInput::with_events(
    @math.Vec2::zero(),
    false,
    @math.Vec2::zero(),
    [@core.Event::Key(@core.Key::End, true, @core.Modifiers::none())],
    "",
    @core.Modifiers::none(),
  )
  ctx.begin_frame(raw_end)
  let (idx3, _) = steps(ctx, "steps_kb", 1, items, width=400.0)
  assert_eq(idx3, 3)
  let _ = ctx.end_frame()

  // Frame 4: ArrowLeft steps back to index 2
  let raw_left = @core.RawInput::with_events(
    @math.Vec2::zero(),
    false,
    @math.Vec2::zero(),
    [@core.Event::Key(@core.Key::ArrowLeft, true, @core.Modifiers::none())],
    "",
    @core.Modifiers::none(),
  )
  ctx.begin_frame(raw_left)
  let (idx2, _) = steps(ctx, "steps_kb", 3, items, width=400.0)
  assert_eq(idx2, 2)
  let _ = ctx.end_frame()
}

///|
test "widgets: steps non-clickable mode" {
  let ctx = UIContext::new()
  let items = [StepItem::new("A"), StepItem::new("B")]

  let raw1 = @core.RawInput::from_mouse(@math.Vec2::new(150.0, 10.0), true)
  ctx.begin_frame(raw1)
  let _ = steps(ctx, "steps_nc", 0, items, clickable=false, width=200.0)
  let _ = ctx.end_frame()

  let raw2 = @core.RawInput::from_mouse(@math.Vec2::new(150.0, 10.0), false)
  ctx.begin_frame(raw2)
  let (idx, _) = steps(ctx, "steps_nc", 0, items, clickable=false, width=200.0)
  assert_eq(idx, 0) // unchanged
  let _ = ctx.end_frame()
}

///|
test "widgets: steps from_ref binding" {
  let ctx = UIContext::new()
  let current_ref = Ref(0)
  let items = [StepItem::new("One"), StepItem::new("Two")]

  let raw1 = @core.RawInput::from_mouse(@math.Vec2::new(150.0, 10.0), true)
  ctx.begin_frame(raw1)
  let _ = ctx.add(Steps::from_ref("steps_ref", current_ref, items).width(200.0))
  let _ = ctx.end_frame()

  let raw2 = @core.RawInput::from_mouse(@math.Vec2::new(150.0, 10.0), false)
  ctx.begin_frame(raw2)
  let _ = ctx.add(Steps::from_ref("steps_ref", current_ref, items).width(200.0))
  let _ = ctx.end_frame()

  assert_eq(current_ref.val, 1)
}

///|
test "widgets: steps cursor semantics" {
  let ctx = UIContext::new()
  let items = [StepItem::new("A"), StepItem::new("B")]

  let raw = @core.RawInput::from_mouse(@math.Vec2::new(50.0, 10.0), false)
  ctx.begin_frame(raw)
  let _ = steps(ctx, "steps_cur", 0, items, width=200.0)
  let _ = ctx.end_frame()
  assert_eq(ctx.cursor_icon(), "pointer")
}

///|
test "widgets: steps vector checkmark and cross geometry" {
  let ctx = UIContext::new()
  let items = [
    StepItem::with_status("Done", StepStatus::Finish),
    StepItem::with_status("Failed", StepStatus::Error),
  ]

  ctx.begin_frame(@core.RawInput::new())
  let _ = steps(ctx, "steps_vec_test", 0, items, width=200.0)
  let dl = ctx.end_frame()

  // Verify that vector lines are emitted for both Finish (2 lines) and Error (2 lines)
  let mut line_count = 0
  for cmd in dl.commands() {
    match cmd {
      @draw.DrawCmd::Line(_, _, _, _) => line_count = line_count + 1
      _ => ()
    }
  }
  // At least 1 rail line + 2 checkmark lines + 2 cross lines = 5 lines
  assert_true(line_count >= 5)
}
