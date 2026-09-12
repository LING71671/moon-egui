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
test "widgets: segmented_control renders track and options" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::new())

  let opts = ["Day", "Week", "Month", "Year"]
  let (sel, resp) = segmented_control(ctx, "period_ctrl", opts, 0, width=240.0)
  let dl = ctx.end_frame()

  assert_eq(sel, 0)
  assert_true(resp.rect.w == 240.0)
  assert_true(dl.len() >= 9)
}

///|
test "widgets: segmented_control clicking second segment switches index" {
  let ctx = UIContext::new()

  let raw = RawInput::from_mouse(@math.Vec2::new(130.0, 15.0), true)
  ctx.begin_frame(raw)

  let opts = ["Left", "Right"]
  let (sel, _resp) = segmented_control(ctx, "lr_ctrl", opts, 0, width=200.0)
  let _ = ctx.end_frame()

  assert_eq(sel, 1)
}

///|
test "widgets: segmented_control arrow key navigation when focused" {
  let ctx = UIContext::new()
  let opts = ["A", "B", "C"]

  let raw1 = RawInput::from_mouse(@math.Vec2::new(10.0, 10.0), true)
  ctx.begin_frame(raw1)
  let _ = segmented_control(ctx, "abc_ctrl", opts, 0, width=150.0)
  let _ = ctx.end_frame()

  let raw2 = RawInput::with_events(
    @math.Vec2::zero(),
    false,
    @math.Vec2::zero(),
    [@core.Event::Key(Key::ArrowRight, true, Modifiers::none())],
    "",
    Modifiers::none(),
  )
  ctx.begin_frame(raw2)
  let (sel2, _resp) = segmented_control(ctx, "abc_ctrl", opts, 0, width=150.0)
  let _ = ctx.end_frame()

  assert_eq(sel2, 1)
}
