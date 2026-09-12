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
test "widgets: splitter horizontal layout and ratio" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::new())

  let mut left_rendered = false
  let mut right_rendered = false
  let mut left_width = 0.0
  let mut right_width = 0.0

  let ratio = split_horizontal(
    ctx,
    "main_split",
    0.3,
    @math.Vec2::new(400.0, 200.0),
    fn(_ui, rect) {
      left_rendered = true
      left_width = rect.w
    },
    fn(_ui, rect) {
      right_rendered = true
      right_width = rect.w
    },
  )

  let dl = ctx.end_frame()

  assert_true(left_rendered)
  assert_true(right_rendered)
  assert_eq(ratio, 0.3)
  assert_eq(left_width, 120.0)
  assert_eq(right_width, 280.0)
  assert_true(dl.len() >= 4)
}

///|
test "widgets: splitter vertical layout and ratio" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::new())

  let mut top_rendered = false
  let mut bottom_rendered = false
  let mut top_h = 0.0
  let mut bottom_h = 0.0

  let ratio = split_vertical(
    ctx,
    "v_split",
    0.4,
    @math.Vec2::new(300.0, 300.0),
    fn(_ui, rect) {
      top_rendered = true
      top_h = rect.h
    },
    fn(_ui, rect) {
      bottom_rendered = true
      bottom_h = rect.h
    },
  )

  let _ = ctx.end_frame()
  assert_true(top_rendered)
  assert_true(bottom_rendered)
  assert_eq(top_h, 120.0)
  assert_eq(bottom_h, 180.0)
  assert_eq(ratio, 0.4)
}

///|
test "splitter: split_horizontal enforces physical min_px bounds" {
  let ctx = @core.UIContext::new()
  ctx.begin_frame(@core.RawInput::new())

  let mut actual_left_w = 0.0
  // Trying to set 0.02 on a 400px width would be 8px, but min_px is 60px
  let ratio = split_horizontal(
    ctx,
    "extreme_split",
    0.02,
    @math.Vec2::new(400.0, 200.0),
    fn(_ui, rect) { actual_left_w = rect.w },
    fn(_ui, _rect) { () },
    min_px=60.0,
  )

  let _ = ctx.end_frame()
  // 60 / 400 = 0.15
  assert_eq(ratio, 0.15)
  assert_true(actual_left_w >= 60.0)
}

///|
test "splitter: split_horizontal dragging updates ratio" {
  let ctx = @core.UIContext::new()

  // Frame 1: Mouse at divider bar (x = 120.0, y = 50.0), press down
  let raw1 = @core.RawInput::from_mouse(@math.Vec2::new(120.0, 50.0), true)
  ctx.begin_frame(raw1)
  let ratio1 = split_horizontal(
    ctx,
    "drag_split",
    0.3,
    @math.Vec2::new(400.0, 200.0),
    fn(_ui, _r) { () },
    fn(_ui, _r) { () },
  )
  assert_eq(ratio1, 0.3)
  let _ = ctx.end_frame()

  // Frame 2: Drag mouse to x = 200.0 (middle)
  let raw2 = @core.RawInput::from_mouse(@math.Vec2::new(200.0, 50.0), true)
  ctx.begin_frame(raw2)
  let ratio2 = split_horizontal(
    ctx,
    "drag_split",
    0.3,
    @math.Vec2::new(400.0, 200.0),
    fn(_ui, _r) { () },
    fn(_ui, _r) { () },
  )
  let _ = ctx.end_frame()
  // 200 / 400 = 0.5
  assert_eq(ratio2, 0.5)
}
