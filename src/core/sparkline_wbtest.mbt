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
test "sparkline: renders line segments and fill" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::from_mouse(@math.Vec2::new(-100.0, -100.0), false))

  let data = [10.0, 25.0, 18.0, 40.0, 32.0]
  let (hovered, resp) = ctx.sparkline(
    "metric1",
    data,
    size=@math.Vec2::new(100.0, 30.0),
  )
  let dl = ctx.end_frame()

  assert_eq(hovered, None)
  assert_eq(resp.rect.w, 100.0)
  assert_eq(resp.rect.h, 30.0)
  // card + stroke + 4 fill rects + 4 line segments = 10 cmds
  assert_true(dl.len() >= 8)
}

///|
test "sparkline: zero-delta flat data does not crash" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::from_mouse(@math.Vec2::new(-100.0, -100.0), false))

  let flat_data = [50.0, 50.0, 50.0, 50.0]
  let (hovered, _resp) = ctx.sparkline("flat_metric", flat_data)
  let dl = ctx.end_frame()

  assert_eq(hovered, None)
  assert_true(dl.len() >= 5)
}

///|
test "sparkline: hovering snaps to closest data point" {
  let ctx = UIContext::new()

  // Width is 100, pad is 4, plot_w is 92.
  // 5 points: indices 0, 1, 2, 3, 4.
  // Index 2 is at middle (x ~ 50.0).
  let raw = RawInput::from_mouse(@math.Vec2::new(50.0, 15.0), false)
  ctx.begin_frame(raw)

  let data = [0.0, 20.0, 40.0, 60.0, 80.0]
  let (hovered, _resp) = ctx.sparkline(
    "hover_metric",
    data,
    size=@math.Vec2::new(100.0, 30.0),
  )
  let _ = ctx.end_frame()

  assert_eq(hovered, Some(2))
}
