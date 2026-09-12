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
fn sample_commands() -> Array[CommandItem] {
  [
    CommandItem::new(
      "new_file",
      "新建文件",
      category="文件",
      shortcut="⌘N",
    ),
    CommandItem::new("save_file", "保存", category="文件", shortcut="⌘S"),
    CommandItem::new(
      "zoom_in",
      "放大视图",
      category="视图",
      shortcut="⌘+",
    ),
    CommandItem::new(
      "zoom_out",
      "缩小视图",
      category="视图",
      shortcut="⌘-",
    ),
    CommandItem::new(
      "reset_view",
      "重置画板",
      category="视图",
      shortcut="⌘0",
    ),
  ]
}

///|
test "command_palette: closed idle does not render or capture" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::new())

  let res = command_palette(ctx, false, "", sample_commands())
  assert_eq(res.open, false)
  assert_eq(res.selected_id, None)

  let dl = ctx.end_frame()
  assert_eq(dl.len(), 0)
}

///|
test "command_palette: open renders scrim card and items into foreground" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::new())

  let res = command_palette(ctx, true, "", sample_commands())
  assert_eq(res.open, true)
  assert_eq(res.selected_id, None)
  assert_eq(res.selected_index, 0)

  let dl = ctx.end_frame()
  // Must render backdrop, card, borders, texts, and footer items
  assert_true(dl.len() >= 10)
}

///|
test "command_palette: arrow down and up navigation cycles through items" {
  let ctx = UIContext::new()

  // Frame 1: Arrow Down moves from 0 to 1
  let raw_down = RawInput::with_events(
    @math.Vec2::zero(),
    false,
    @math.Vec2::zero(),
    [Event::Key(Key::ArrowDown, true, Modifiers::none())],
    "",
    Modifiers::none(),
  )
  ctx.begin_frame(raw_down)
  let res1 = command_palette(ctx, true, "", sample_commands(), selected_index=0)
  assert_eq(res1.open, true)
  assert_eq(res1.selected_index, 1)
  let _ = ctx.end_frame()

  // Frame 2: Arrow Up from 0 wraps around to end (index 4)
  let raw_up = RawInput::with_events(
    @math.Vec2::zero(),
    false,
    @math.Vec2::zero(),
    [Event::Key(Key::ArrowUp, true, Modifiers::none())],
    "",
    Modifiers::none(),
  )
  ctx.begin_frame(raw_up)
  let res2 = command_palette(ctx, true, "", sample_commands(), selected_index=0)
  assert_eq(res2.open, true)
  assert_eq(res2.selected_index, 4)
  let _ = ctx.end_frame()
}

///|
test "command_palette: enter executes active item and closes" {
  let ctx = UIContext::new()

  let raw_enter = RawInput::with_events(
    @math.Vec2::zero(),
    false,
    @math.Vec2::zero(),
    [Event::Key(Key::Enter, true, Modifiers::none())],
    "",
    Modifiers::none(),
  )
  ctx.begin_frame(raw_enter)
  let res = command_palette(ctx, true, "", sample_commands(), selected_index=2)
  assert_eq(res.open, false)
  assert_eq(res.selected_id, Some("zoom_in"))
  let _ = ctx.end_frame()
}

///|
test "command_palette: escape cancels and closes without selection" {
  let ctx = UIContext::new()

  let raw_esc = RawInput::with_events(
    @math.Vec2::zero(),
    false,
    @math.Vec2::zero(),
    [Event::Key(Key::Escape, true, Modifiers::none())],
    "",
    Modifiers::none(),
  )
  ctx.begin_frame(raw_esc)
  let res = command_palette(ctx, true, "", sample_commands(), selected_index=1)
  assert_eq(res.open, false)
  assert_eq(res.selected_id, None)
  let _ = ctx.end_frame()
}

///|
test "command_palette: outside click dismisses modal" {
  let ctx = UIContext::new()

  // Click at (10, 10), which is outside the centered spotlight card
  let raw_click = RawInput::from_mouse(@math.Vec2::new(10.0, 10.0), true)
  ctx.begin_frame(raw_click)
  let res = command_palette(ctx, true, "", sample_commands())
  assert_eq(res.open, false)
  assert_eq(res.selected_id, None)
  let _ = ctx.end_frame()
}

///|
test "command_palette: query filtering matches title and category" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::new())

  // Filtering with query "保存"
  let res = command_palette(ctx, true, "保存", sample_commands())
  assert_eq(res.open, true)
  assert_eq(res.selected_index, 0)
  let _ = ctx.end_frame()

  // Pressing enter should execute the filtered item "save_file"
  let raw_enter = RawInput::with_events(
    @math.Vec2::zero(),
    false,
    @math.Vec2::zero(),
    [Event::Key(Key::Enter, true, Modifiers::none())],
    "",
    Modifiers::none(),
  )
  ctx.begin_frame(raw_enter)
  let res2 = command_palette(
    ctx,
    true,
    "保存",
    sample_commands(),
    selected_index=0,
  )
  assert_eq(res2.open, false)
  assert_eq(res2.selected_id, Some("save_file"))
  let _ = ctx.end_frame()
}
