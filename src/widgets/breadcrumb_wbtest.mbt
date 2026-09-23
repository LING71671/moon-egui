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

///|
test "widgets: breadcrumb keyboard navigation with Home, End, and Space" {
  let ctx = UIContext::new()
  let path = ["Root", "Folder", "Subfolder", "File"]

  // Frame 1: Tab to focus breadcrumb
  let raw_tab = @core.RawInput::with_events(
    @math.Vec2::zero(),
    false,
    @math.Vec2::zero(),
    [@core.Event::Key(@core.Key::Tab, true, @core.Modifiers::none())],
    "",
    @core.Modifiers::none(),
  )
  ctx.begin_frame(raw_tab)
  let (c0, _) = breadcrumb(ctx, "bc_kb", path)
  let _ = ctx.end_frame()
  assert_eq(c0, None)

  // Frame 2: End jumps to last selectable ancestor ("Subfolder" index 2)
  let raw_end = @core.RawInput::with_events(
    @math.Vec2::zero(),
    false,
    @math.Vec2::zero(),
    [@core.Event::Key(@core.Key::End, true, @core.Modifiers::none())],
    "",
    @core.Modifiers::none(),
  )
  ctx.begin_frame(raw_end)
  let (c1, _) = breadcrumb(ctx, "bc_kb", path)
  let _ = ctx.end_frame()
  assert_eq(c1, None)

  // Frame 3: Space activates currently focused node (index 2)
  let raw_space = @core.RawInput::with_events(
    @math.Vec2::zero(),
    false,
    @math.Vec2::zero(),
    [@core.Event::Key(@core.Key::Space, true, @core.Modifiers::none())],
    "",
    @core.Modifiers::none(),
  )
  ctx.begin_frame(raw_space)
  let (c2, _) = breadcrumb(ctx, "bc_kb", path)
  let _ = ctx.end_frame()
  assert_eq(c2, Some(2))

  // Frame 4: Home jumps to first ancestor (index 0) and Enter activates it
  let raw_home_enter = @core.RawInput::with_events(
    @math.Vec2::zero(),
    false,
    @math.Vec2::zero(),
    [
      @core.Event::Key(@core.Key::Home, true, @core.Modifiers::none()),
      @core.Event::Key(@core.Key::Enter, true, @core.Modifiers::none()),
    ],
    "",
    @core.Modifiers::none(),
  )
  ctx.begin_frame(raw_home_enter)
  let (c3, _) = breadcrumb(ctx, "bc_kb", path)
  let _ = ctx.end_frame()
  assert_eq(c3, Some(0))
}
