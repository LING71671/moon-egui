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
test "widgets: button rendering and interaction" {
  let ctx = @core.UIContext::new()
  ctx.begin_frame(@core.RawInput::new())
  let resp = button(ctx, "Submit")
  assert_eq(resp.rect.h, 32.0)
  let dl = ctx.end_frame()
  assert_eq(dl.len(), 3)
}

///|
test "widgets: button builder protocol" {
  let ctx = @core.UIContext::new()
  ctx.begin_frame(@core.RawInput::new())
  let resp = ctx.add(Button::new("Save").primary(true))
  assert_true(!resp.clicked())
  let dl = ctx.end_frame()
  assert_eq(dl.len(), 3)
}
