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
test "widgets: toast empty stack renders nothing" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::new())

  let res = toast_stack(ctx, [])
  assert_eq(res.active_toasts.length(), 0)
  assert_eq(res.dismissed_id, None)

  let dl = ctx.end_frame()
  assert_eq(dl.len(), 0)
}

///|
test "widgets: toast single toast renders" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::new())

  let t = Toast::success("保存成功", message="文件已同步至云端")
  let res = toast_stack(ctx, [t])
  assert_eq(res.active_toasts.length(), 1)
  assert_eq(res.dismissed_id, None)

  let dl = ctx.end_frame()
  assert_true(dl.len() >= 7)
}

///|
test "widgets: toast anchor layout" {
  let vp = @math.Vec2::new(1000.0, 800.0)

  let ctx1 = UIContext::new()
  ctx1.begin_frame(RawInput::new())
  let t1 = Toast::info("TopRight Toast")
  let res1 = toast_stack(ctx1, [t1], anchor=TopRight, viewport_size=vp)
  assert_eq(res1.active_toasts.length(), 1)
  let _ = ctx1.end_frame()

  let ctx2 = UIContext::new()
  ctx2.begin_frame(RawInput::new())
  let t2 = Toast::warning("BottomRight Toast")
  let res2 = toast_stack(ctx2, [t2], anchor=BottomRight, viewport_size=vp)
  assert_eq(res2.active_toasts.length(), 1)
  let _ = ctx2.end_frame()
}
