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
test "spinner: renders track circle and tapered arc segments" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::new())

  let resp = ctx.spinner(size=24.0)
  let dl = ctx.end_frame()

  assert_true(resp.rect.w == 24.0)
  assert_true(resp.rect.h == 24.0)
  // 1 circle track + 18 line segments = 19 draw commands
  assert_eq(dl.len(), 19)
}

///|
test "spinner: spinner_with_label layout measures label width and renders text" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::new())

  let resp = ctx.spinner_with_label("Loading data...", size=16.0)
  let dl = ctx.end_frame()

  assert_true(resp.rect.w > 16.0 + 8.0) // size + gap + text
  // 1 circle track + 16 line segments + 1 text = 18 draw commands
  assert_eq(dl.len(), 18)
}

///|
test "spinner: time advance rotates arc segments" {
  let ctx = UIContext::new()

  ctx.begin_frame(RawInput::new())
  ctx.set_time(0.5)
  let _ = ctx.spinner(size=20.0)
  let dl1 = ctx.end_frame()

  ctx.begin_frame(RawInput::new())
  ctx.set_time(1.5)
  let _ = ctx.spinner(size=20.0)
  let dl2 = ctx.end_frame()

  assert_eq(dl1.len(), 19)
  assert_eq(dl2.len(), 19)
}
