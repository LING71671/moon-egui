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
test "tooltip: composites on the foreground layer and escapes clipping" {
  let ctx = @core.UIContext::new()
  ctx.begin_frame(
    @core.RawInput::from_mouse(@math.Vec2::new(50.0, 50.0), false),
  )

  ctx.push_clip(@math.Rect::new(0.0, 0.0, 10.0, 10.0))
  tooltip(ctx, "tip")
  ctx.pop_clip()
  let dl = ctx.end_frame()

  // 0..1 are the main layer clip pair, 2..4 the deferred tooltip bubble
  assert_eq(dl.len(), 5)
  assert_true(dl.get_command(0) is Some(@draw.DrawCmd::Clip(_)))
  assert_true(dl.get_command(1) is Some(@draw.DrawCmd::ResetClip))
  assert_true(dl.get_command(2) is Some(@draw.DrawCmd::Rect(_, _, _)))
  assert_true(dl.get_command(3) is Some(@draw.DrawCmd::RectStroke(_, _, _, _)))
  assert_true(dl.get_command(4) is Some(@draw.DrawCmd::Text(_)))

  // The main layer's clip stack is restored after the foreground pass
  assert_true(ctx.current_clip() is None)
}
