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
test "widgets: slider rendering and interaction" {
  let ctx = @core.UIContext::new()
  ctx.begin_frame(@core.RawInput::new())
  let (val, resp) = slider(ctx, "Volume", 50.0, 0.0, 100.0)
  assert_eq(val, 50.0)
  assert_true(resp.rect.w > 100.0)
  let dl = ctx.end_frame()
  assert_true(dl.len() >= 3)
}

///|
test "widgets: slider builder and ref binding" {
  let ctx = @core.UIContext::new()
  let target = Ref(25.0)
  ctx.begin_frame(@core.RawInput::new())
  let resp = ctx.add(Slider::from_ref("Level", target, 0.0, 100.0).step(5.0))
  assert_eq(target.val, 25.0)
  assert_true(!resp.clicked())
  let dl = ctx.end_frame()
  assert_true(dl.len() >= 3)
}

///|
test "widgets: slider dynamic val_w expands for large numbers" {
  let ctx = @core.UIContext::new()

  ctx.begin_frame(@core.RawInput::new())
  let (_, resp_small) = slider(ctx, "Small", 5.0, 0.0, 10.0)
  let _ = ctx.end_frame()

  ctx.begin_frame(@core.RawInput::new())
  let (_, resp_large) = slider(ctx, "Small", 25000.0, 10000.0, 50000.0)
  let _ = ctx.end_frame()

  // Slider with 5-digit numbers allocates wider total_w to accommodate the value text
  assert_true(resp_large.rect.w > resp_small.rect.w)
}

///|
test "widgets: slider Home, End, PageUp, and PageDown keyboard navigation" {
  let ctx = @core.UIContext::new()
  let target = Ref(50.0)

  // Frame 1: Focus slider via Tab
  let input1 = @core.RawInput::with_events(
    @math.Vec2::zero(),
    false,
    @math.Vec2::zero(),
    [@core.Event::Key(@core.Key::Tab, true, @core.Modifiers::none())],
    "",
    @core.Modifiers::none(),
  )
  ctx.begin_frame(input1)
  let _ = ctx.add(Slider::from_ref("Level", target, 0.0, 100.0).step(1.0))
  let _ = ctx.end_frame()

  // Frame 2: Home key snaps to min (0.0)
  let input2 = @core.RawInput::with_events(
    @math.Vec2::zero(),
    false,
    @math.Vec2::zero(),
    [@core.Event::Key(@core.Key::Home, true, @core.Modifiers::none())],
    "",
    @core.Modifiers::none(),
  )
  ctx.begin_frame(input2)
  let _ = ctx.add(Slider::from_ref("Level", target, 0.0, 100.0).step(1.0))
  let _ = ctx.end_frame()
  assert_eq(target.val, 0.0)

  // Frame 3: End key snaps to max (100.0)
  let input3 = @core.RawInput::with_events(
    @math.Vec2::zero(),
    false,
    @math.Vec2::zero(),
    [@core.Event::Key(@core.Key::End, true, @core.Modifiers::none())],
    "",
    @core.Modifiers::none(),
  )
  ctx.begin_frame(input3)
  let _ = ctx.add(Slider::from_ref("Level", target, 0.0, 100.0).step(1.0))
  let _ = ctx.end_frame()
  assert_eq(target.val, 100.0)

  // Frame 4: PageDown key steps down by 10x step (10.0 -> 90.0)
  let input4 = @core.RawInput::with_events(
    @math.Vec2::zero(),
    false,
    @math.Vec2::zero(),
    [@core.Event::Key(@core.Key::PageDown, true, @core.Modifiers::none())],
    "",
    @core.Modifiers::none(),
  )
  ctx.begin_frame(input4)
  let _ = ctx.add(Slider::from_ref("Level", target, 0.0, 100.0).step(1.0))
  let _ = ctx.end_frame()
  assert_eq(target.val, 90.0)

  // Frame 5: PageUp key steps up by 10x step (10.0 -> 100.0)
  let input5 = @core.RawInput::with_events(
    @math.Vec2::zero(),
    false,
    @math.Vec2::zero(),
    [@core.Event::Key(@core.Key::PageUp, true, @core.Modifiers::none())],
    "",
    @core.Modifiers::none(),
  )
  ctx.begin_frame(input5)
  let _ = ctx.add(Slider::from_ref("Level", target, 0.0, 100.0).step(1.0))
  let _ = ctx.end_frame()
  assert_eq(target.val, 100.0)
}
