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
test "widgets: breadcrumb renders hierarchy nodes and separators" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::from_mouse(@math.Vec2::new(-100.0, -100.0), false))

  let path = ["Home", "Components", "Table"]
  let (clicked, resp) = breadcrumb(ctx, "bc1", path, separator="/")
  let dl = ctx.end_frame()

  assert_eq(clicked, None)
  assert_true(resp.rect.w > 100.0)
  assert_eq(resp.rect.h, 26.0)
  assert_eq(dl.len(), 5)
}

///|
test "widgets: breadcrumb click ancestor node returns index" {
  let ctx = UIContext::new()

  let raw = RawInput::from_mouse(@math.Vec2::new(15.0, 10.0), true)
  ctx.begin_frame(raw)

  let path = ["Home", "Settings", "Account"]
  let (clicked, _resp) = breadcrumb(ctx, "bc_click", path)
  let _ = ctx.end_frame()

  assert_eq(clicked, Some(0))
}

///|
test "widgets: breadcrumb long hierarchy folds with ellipsis" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::from_mouse(@math.Vec2::new(-100.0, -100.0), false))

  let long_path = ["Root", "Users", "Admin", "Projects", "MoonBit", "Core"]
  let (_clicked, _resp) = breadcrumb(ctx, "bc_fold", long_path, max_visible=4)
  let dl = ctx.end_frame()

  assert_eq(dl.len(), 7)
}
