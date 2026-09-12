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
