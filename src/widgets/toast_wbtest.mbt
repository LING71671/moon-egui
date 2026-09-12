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

///|
test "toast: time decay advances elapsed and expires" {
  let ctx = @core.UIContext::new()
  // Construct raw input with dt = 2.0s
  let raw1 = @core.RawInput::with_events(
    @math.Vec2::zero(),
    false,
    @math.Vec2::zero(),
    [],
    "",
    @core.Modifiers::none(),
    dt=2.0,
  )
  ctx.begin_frame(raw1)

  let t = Toast::new("t1", "临时提示", duration=3.0)
  let res1 = toast_stack(ctx, [t])
  assert_eq(res1.active_toasts.length(), 1)
  assert_true(res1.active_toasts[0].elapsed >= 2.0)
  let _ = ctx.end_frame()

  // Next frame advances another 1.5s -> total 3.5s >= 3.0s, should expire
  let ctx2 = @core.UIContext::new()
  let raw2 = @core.RawInput::with_events(
    @math.Vec2::zero(),
    false,
    @math.Vec2::zero(),
    [],
    "",
    @core.Modifiers::none(),
    dt=1.5,
  )
  ctx2.begin_frame(raw2)
  let res2 = toast_stack(ctx2, res1.active_toasts)
  assert_eq(res2.active_toasts.length(), 0)
  let _ = ctx2.end_frame()
}

///|
test "toast: click close button dismisses item" {
  let ctx = @core.UIContext::new()
  // Toast width is 280, close button is at (vw - 280 - 20 + 280 - 26, vh - 20 - 38 + 6)
  // For default vw=800, vh=600:
  // x = 800 - 280 - 20 = 500
  // y = 600 - 20 - 38 = 542
  // close btn x: 500 + 280 - 26 = 754, y: 542 + 6 = 548
  let raw = @core.RawInput::from_mouse(@math.Vec2::new(760.0, 555.0), true)
  ctx.begin_frame(raw)

  let t = Toast::new("toast_dismiss_me", "可关闭提示")
  let res = toast_stack(ctx, [t])
  assert_eq(res.dismissed_id, Some("toast_dismiss_me"))
  assert_eq(res.active_toasts.length(), 0)
  let _ = ctx.end_frame()
}

///|
test "toast: detailed message vs title-only layout" {
  let ctx = @core.UIContext::new()
  ctx.begin_frame(@core.RawInput::new())

  let t_simple = Toast::info("单行通知")
  let t_detailed = Toast::info(
    "多行通知",
    message="附带详细说明信息",
  )

  let res = toast_stack(ctx, [t_simple, t_detailed])
  assert_eq(res.active_toasts.length(), 2)

  let dl = ctx.end_frame()
  assert_true(dl.len() > 10)
}

///|
test "toast: kinds color coverage" {
  let ctx = @core.UIContext::new()
  ctx.begin_frame(@core.RawInput::new())

  let t1 = Toast::info("信息")
  let t2 = Toast::success("成功")
  let t3 = Toast::warning("警告")
  let t4 = Toast::danger("错误")

  let res = toast_stack(ctx, [t1, t2, t3, t4])
  assert_eq(res.active_toasts.length(), 4)
  let _ = ctx.end_frame()
}

///|
test "toast: close button advertises the pointer cursor" {
  let ctx = @core.UIContext::new()

  // Bottom-right anchor with the default 800 x 600 viewport: the card spans
  // x 500..780, y 542..580, and the close cross sits in its top-right corner.
  ctx.begin_frame(
    @core.RawInput::from_mouse(@math.Vec2::new(760.0, 555.0), false),
  )
  let t = Toast::new("cursor_toast", "关闭我")
  let _ = toast_stack(ctx, [t])
  assert_eq(ctx.cursor_icon(), "pointer")
  let _ = ctx.end_frame()
}
