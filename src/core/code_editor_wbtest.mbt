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
test "code_editor: initial render produces background, gutter and lines" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::new())

  let code = "fn main {\n  println(\"Hello\")\n}"
  let (text, resp) = ctx.code_editor("editor1", code)
  assert_eq(text, code)
  assert_eq(resp.has_focus(), false)

  let dl = ctx.end_frame()
  assert_true(dl.len() >= 6)
}

///|
test "code_editor: enter inserts newline and splits text" {
  let ctx = UIContext::new()

  // Frame 1: click to focus editor
  let raw1 = RawInput::from_mouse(@math.Vec2::new(100.0, 20.0), true)
  ctx.begin_frame(raw1)
  let (text1, resp1) = ctx.code_editor("editor1", "hello world")
  assert_true(resp1.pressed())
  let _ = ctx.end_frame()

  // Set cursor to pos 5 (after "hello")
  let id = ctx.id_stack.derive_id("code_editor::editor1")
  ctx.set_text_cursor_pos(id, 5)

  // Frame 2: press Enter key
  let raw2 = RawInput::with_events(
    @math.Vec2::new(100.0, 20.0),
    false,
    @math.Vec2::zero(),
    [Event::Key(Key::Enter, true, Modifiers::none())],
    "",
    Modifiers::none(),
  )
  ctx.begin_frame(raw2)
  let (text2, _) = ctx.code_editor("editor1", text1)
  assert_eq(text2, "hello\n world")
  let _ = ctx.end_frame()
}

///|
test "code_editor: tab key inserts two soft spaces" {
  let ctx = UIContext::new()

  // Focus editor
  let raw1 = RawInput::from_mouse(@math.Vec2::new(100.0, 20.0), true)
  ctx.begin_frame(raw1)
  let (text1, _) = ctx.code_editor("editor1", "let x = 1")
  let _ = ctx.end_frame()

  // Set cursor to position 0
  let id = ctx.id_stack.derive_id("code_editor::editor1")
  ctx.set_text_cursor_pos(id, 0)

  // Press Tab
  let raw2 = RawInput::with_events(
    @math.Vec2::new(100.0, 20.0),
    false,
    @math.Vec2::zero(),
    [Event::Key(Key::Tab, true, Modifiers::none())],
    "",
    Modifiers::none(),
  )
  ctx.begin_frame(raw2)
  let (text2, _) = ctx.code_editor("editor1", text1)
  assert_eq(text2, "  let x = 1")
  let _ = ctx.end_frame()
}

///|
test "code_editor: arrow up and down navigates lines" {
  let ctx = UIContext::new()

  // Focus editor
  let raw1 = RawInput::from_mouse(@math.Vec2::new(100.0, 20.0), true)
  ctx.begin_frame(raw1)
  let initial = "line 1\nsecond line"
  let _ = ctx.code_editor("editor1", initial)
  let _ = ctx.end_frame()

  let id = ctx.id_stack.derive_id("code_editor::editor1")
  // Set cursor at pos 2 ("li|ne 1")
  ctx.set_text_cursor_pos(id, 2)

  // ArrowDown to move to second line at same column
  let raw_down = RawInput::with_events(
    @math.Vec2::new(100.0, 20.0),
    false,
    @math.Vec2::zero(),
    [Event::Key(Key::ArrowDown, true, Modifiers::none())],
    "",
    Modifiers::none(),
  )
  ctx.begin_frame(raw_down)
  let _ = ctx.code_editor("editor1", initial)
  let pos_after_down = ctx.get_text_cursor_pos(id, initial.length())
  // line 1 is 6 chars + '\n' = 7. Pos on second line col 2 = 7 + 2 = 9
  assert_eq(pos_after_down, 9)
  let _ = ctx.end_frame()

  // ArrowUp to move back to first line
  let raw_up = RawInput::with_events(
    @math.Vec2::new(100.0, 20.0),
    false,
    @math.Vec2::zero(),
    [Event::Key(Key::ArrowUp, true, Modifiers::none())],
    "",
    Modifiers::none(),
  )
  ctx.begin_frame(raw_up)
  let _ = ctx.code_editor("editor1", initial)
  let pos_after_up = ctx.get_text_cursor_pos(id, initial.length())
  assert_eq(pos_after_up, 2)
  let _ = ctx.end_frame()
}

///|
test "code_editor: home and end jump within line" {
  let ctx = UIContext::new()

  let raw1 = RawInput::from_mouse(@math.Vec2::new(100.0, 20.0), true)
  ctx.begin_frame(raw1)
  let initial = "abc\ndefgh"
  let _ = ctx.code_editor("editor1", initial)
  let _ = ctx.end_frame()

  let id = ctx.id_stack.derive_id("code_editor::editor1")
  // Set cursor in middle of second line ("defgh" starts at 4, set to 6)
  ctx.set_text_cursor_pos(id, 6)

  // Press Home: moves to start of line 2 (pos 4)
  let raw_home = RawInput::with_events(
    @math.Vec2::new(100.0, 20.0),
    false,
    @math.Vec2::zero(),
    [Event::Key(Key::Home, true, Modifiers::none())],
    "",
    Modifiers::none(),
  )
  ctx.begin_frame(raw_home)
  let _ = ctx.code_editor("editor1", initial)
  let pos_home = ctx.get_text_cursor_pos(id, initial.length())
  assert_eq(pos_home, 4)
  let _ = ctx.end_frame()

  // Press End: moves to end of line 2 (pos 4 + 5 = 9)
  let raw_end = RawInput::with_events(
    @math.Vec2::new(100.0, 20.0),
    false,
    @math.Vec2::zero(),
    [Event::Key(Key::End, true, Modifiers::none())],
    "",
    Modifiers::none(),
  )
  ctx.begin_frame(raw_end)
  let _ = ctx.code_editor("editor1", initial)
  let pos_end = ctx.get_text_cursor_pos(id, initial.length())
  assert_eq(pos_end, 9)
  let _ = ctx.end_frame()
}

///|
test "code_editor: backspace at start of line merges with previous line" {
  let ctx = UIContext::new()

  let raw1 = RawInput::from_mouse(@math.Vec2::new(100.0, 20.0), true)
  ctx.begin_frame(raw1)
  let initial = "hello\nworld"
  let _ = ctx.code_editor("editor1", initial)
  let _ = ctx.end_frame()

  let id = ctx.id_stack.derive_id("code_editor::editor1")
  // Set cursor at pos 6 (start of "world")
  ctx.set_text_cursor_pos(id, 6)

  let raw_bs = RawInput::with_events(
    @math.Vec2::new(100.0, 20.0),
    false,
    @math.Vec2::zero(),
    [Event::Key(Key::Backspace, true, Modifiers::none())],
    "",
    Modifiers::none(),
  )
  ctx.begin_frame(raw_bs)
  let (merged, _) = ctx.code_editor("editor1", initial)
  assert_eq(merged, "helloworld")
  let _ = ctx.end_frame()
}

///|
test "code_editor: read only mode prevents modifications" {
  let ctx = UIContext::new()

  let raw1 = RawInput::from_mouse(@math.Vec2::new(100.0, 20.0), true)
  ctx.begin_frame(raw1)
  let initial = "immutable code"
  let _ = ctx.code_editor("editor1", initial, read_only=true)
  let _ = ctx.end_frame()

  // Send Enter and typing
  let raw_mod = RawInput::with_events(
    @math.Vec2::new(100.0, 20.0),
    false,
    @math.Vec2::zero(),
    [Event::Key(Key::Enter, true, Modifiers::none())],
    "added",
    Modifiers::none(),
  )
  ctx.begin_frame(raw_mod)
  let (text_after, _) = ctx.code_editor("editor1", initial, read_only=true)
  assert_eq(text_after, initial)
  let _ = ctx.end_frame()
}

///|
test "code_editor: select all with Ctrl+A and replace with text" {
  let ctx = UIContext::new()

  // Frame 1: focus editor
  let raw1 = RawInput::from_mouse(@math.Vec2::new(100.0, 20.0), true)
  ctx.begin_frame(raw1)
  let (text1, _) = ctx.code_editor("editor_sel", "let old_val = 123")
  let _ = ctx.end_frame()

  // Frame 2: press Ctrl+A
  let ctrl_mod = Modifiers::ctrl()
  let raw_all = RawInput::with_events(
    @math.Vec2::new(100.0, 20.0),
    false,
    @math.Vec2::zero(),
    [Event::Key(Key::A, true, ctrl_mod)],
    "",
    ctrl_mod,
  )
  ctx.begin_frame(raw_all)
  let (text2, _) = ctx.code_editor("editor_sel", text1)
  let ed_id = ctx.id_stack.derive_id("code_editor::editor_sel")
  assert_eq(ctx.get_text_selection_anchor(ed_id), Some(0))
  let _ = ctx.end_frame()

  // Frame 3: type replacement text "new_val"
  let raw_type = RawInput::with_events(
    @math.Vec2::new(100.0, 20.0),
    false,
    @math.Vec2::zero(),
    [Event::TextInput("new_val")],
    "",
    Modifiers::none(),
  )
  ctx.begin_frame(raw_type)
  let (text3, _) = ctx.code_editor("editor_sel", text2)
  assert_eq(text3, "new_val")
  assert_eq(ctx.get_text_selection_anchor(ed_id), None)
  let _ = ctx.end_frame()
}

///|
test "code_editor: wheel scrolling and auto-scroll to caret" {
  let ctx = UIContext::new()
  let ed_id = ctx.id_stack.derive_id("code_editor::editor_scroll")

  // Create a 20-line document
  let doc = "line1\nline2\nline3\nline4\nline5\nline6\nline7\nline8\nline9\nline10\nline11\nline12\nline13\nline14\nline15\nline16\nline17\nline18\nline19\nline20"

  // Frame 1: hover editor and scroll down by 60px
  let raw1 = RawInput::with_events(
    @math.Vec2::new(100.0, 50.0),
    false,
    @math.Vec2::new(0.0, -60.0),
    [Event::PointerWheel(@math.Vec2::new(0.0, -60.0))],
    "",
    Modifiers::none(),
  )
  ctx.begin_frame(raw1)
  let (txt1, resp1) = ctx.code_editor(
    "editor_scroll",
    doc,
    size=@math.Vec2::new(300.0, 100.0),
  )
  assert_true(resp1.hovered())
  let offset1 = ctx.get_scroll_offset(ed_id)
  assert_true(offset1 >= 60.0)
  let _ = ctx.end_frame()

  // Frame 2: navigate to start of file with Ctrl+Home key, triggering auto-scroll to top
  ctx.request_focus(ed_id)
  let ctrl_mod = Modifiers::ctrl()
  let raw2 = RawInput::with_events(
    @math.Vec2::new(100.0, 50.0),
    false,
    @math.Vec2::zero(),
    [Event::Key(Key::Home, true, ctrl_mod)],
    "",
    ctrl_mod,
  )
  ctx.begin_frame(raw2)
  let _ = ctx.code_editor(
    "editor_scroll",
    txt1,
    size=@math.Vec2::new(300.0, 100.0),
  )
  let offset2 = ctx.get_scroll_offset(ed_id)
  assert_eq(offset2, 0.0)
  let _ = ctx.end_frame()
}
