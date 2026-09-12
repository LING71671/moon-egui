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
test "widgets: checkbox and toggle helpers" {
  let ctx = @core.UIContext::new()
  ctx.begin_frame(@core.RawInput::new())
  let (c, r1) = checkbox(ctx, "Accept", false)
  assert_false(c)
  assert_false(r1.clicked())

  let (t, r2) = toggle(ctx, "Active", true)
  assert_true(t)
  assert_false(r2.clicked())

  let (rad, r3) = radio(ctx, "Option A", true)
  assert_true(rad)
  assert_false(r3.clicked())

  let dl = ctx.end_frame()
  assert_true(dl.len() > 0)
}

///|
test "widgets: checkbox and toggle ref builders" {
  let ctx = @core.UIContext::new()
  let checked = Ref(true)
  let toggled = Ref(false)

  ctx.begin_frame(@core.RawInput::new())
  let _ = ctx.add(Checkbox::from_ref("Agree", checked))
  let _ = ctx.add(Toggle::from_ref("Power", toggled))
  assert_true(checked.val)
  assert_false(toggled.val)
  let _ = ctx.end_frame()
}
