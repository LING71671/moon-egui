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
test "badge: renders text and status dot with pill radius" {
  let ctx = @core.UIContext::new()
  ctx.begin_frame(@core.RawInput::new())

  let resp = badge(ctx, "Active", kind=BadgeKind::Success, dot=true, pill=true)
  let dl = ctx.end_frame()

  assert_true(resp.rect.w > 40.0)
  assert_eq(resp.rect.h, 22.0)
  assert_eq(dl.len(), 4)
}

///|
test "badge: all 5 semantic kinds produce valid commands" {
  let ctx = @core.UIContext::new()
  ctx.begin_frame(@core.RawInput::new())

  let _ = badge(ctx, "Default", kind=BadgeKind::default())
  let _ = badge(ctx, "Success", kind=BadgeKind::success())
  let _ = badge(ctx, "Warning", kind=BadgeKind::warning())
  let _ = badge(ctx, "Danger", kind=BadgeKind::danger())
  let _ = badge(ctx, "Info", kind=BadgeKind::info())
  let dl = ctx.end_frame()

  assert_eq(dl.len(), 15)
}

///|
test "tag: closable close button click returns closed = true" {
  let ctx = @core.UIContext::new()

  // Render tag to find position
  ctx.begin_frame(@core.RawInput::new())
  let (_, resp1) = tag(ctx, "my_tag", "MoonBit", closable=true)
  let _ = ctx.end_frame()

  // Click on the close button near the right edge of the tag
  let close_x = resp1.rect.x + resp1.rect.w - 15.0
  let close_y = resp1.rect.y + 12.0
  let raw2 = @core.RawInput::from_mouse(@math.Vec2::new(close_x, close_y), true)
  ctx.begin_frame(raw2)
  let (closed, _resp2) = tag(ctx, "my_tag", "MoonBit", closable=true)
  let _ = ctx.end_frame()

  assert_true(closed)
}
