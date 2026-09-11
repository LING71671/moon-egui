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
test "segmented_control: renders track and options" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::new())

  let opts = ["Day", "Week", "Month", "Year"]
  let (sel, resp) = ctx.segmented_control("period_ctrl", opts, 0, width=240.0)
  let dl = ctx.end_frame()

  assert_eq(sel, 0)
  assert_true(resp.rect.w == 240.0)
  // track + track_stroke + pill_shadow + pill + pill_stroke + 4 texts = 9 cmds
  assert_true(dl.len() >= 9)
}

///|
test "segmented_control: clicking second segment switches index" {
  let ctx = UIContext::new()

  // Width is 200, pad is 3, 2 options -> item_w is (200 - 6) / 2 = 97.
  // Segment 1 starts at x = 3 + 97 = 100.
  // Click at (x = 130.0, y = 15.0)
  let raw = RawInput::from_mouse(@math.Vec2::new(130.0, 15.0), true)
  ctx.begin_frame(raw)

  let opts = ["Left", "Right"]
  let (sel, _resp) = ctx.segmented_control("lr_ctrl", opts, 0, width=200.0)
  let _ = ctx.end_frame()

  assert_eq(sel, 1)
}

///|
test "segmented_control: arrow key navigation when focused" {
  let ctx = UIContext::new()
  let opts = ["A", "B", "C"]

  // Frame 1: Focus the control
  let raw1 = RawInput::from_mouse(@math.Vec2::new(10.0, 10.0), true)
  ctx.begin_frame(raw1)
  let _ = ctx.segmented_control("abc_ctrl", opts, 0, width=150.0)
  let _ = ctx.end_frame()

  // Frame 2: Press ArrowRight
  let raw2 = RawInput::new()
  raw2.events.push(Event::Key(Key::ArrowRight, true, Modifiers::none()))
  ctx.begin_frame(raw2)
  let (sel2, _resp) = ctx.segmented_control("abc_ctrl", opts, 0, width=150.0)
  let _ = ctx.end_frame()

  assert_eq(sel2, 1)
}
