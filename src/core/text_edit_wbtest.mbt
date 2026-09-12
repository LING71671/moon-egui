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
test "text_edit: unicode boundary functions handle surrogate pairs atomically" {
  // "A😀B": 'A' at 0, '😀' surrogate pair at 1..2, 'B' at 3
  let text = "A\u{1F600}B"
  assert_eq(text.length(), 4)

  // Stepping forward from 1 should jump over the surrogate pair to 3
  assert_eq(next_char_boundary(text, 1), 3)
  // Stepping backward from 3 should jump over the surrogate pair to 1
  assert_eq(prev_char_boundary(text, 3), 1)

  // Stepping forward from 0 lands at 1 ('A')
  assert_eq(next_char_boundary(text, 0), 1)
  // Stepping backward from 1 lands at 0 ('A')
  assert_eq(prev_char_boundary(text, 1), 0)

  // Backspacing after emoji (cursor at 3) deletes both surrogate code units
  let (after_bs, new_pos) = delete_prev_char(text, 3)
  assert_eq(after_bs, "AB")
  assert_eq(new_pos, 1)

  // Delete key before emoji (cursor at 1) deletes both surrogate code units
  let after_del = delete_next_char(text, 1)
  assert_eq(after_del, "AB")
}

///|
test "text_edit: interactive widget protects surrogate pairs during keyboard navigation and editing" {
  let ctx = UIContext::new()

  // Frame 1: Render TextEdit with emoji content, focus it
  let input1 = RawInput::from_mouse(@math.Vec2::new(20.0, 10.0), true)
  ctx.begin_frame(input1)
  let initial_text = "A\u{1F600}B"
  let (t1, resp1) = ctx.text_edit("edit1", initial_text, "")
  let _ = ctx.end_frame()
  assert_eq(t1, initial_text)
  let id = resp1.id

  // Move cursor to position 3 (immediately after emoji)
  ctx.set_text_cursor_pos(id, 3)

  // Frame 2: Backspace pressed -> deletes entire emoji, not just low surrogate
  let input2 = {
    ..RawInput::new(),
    events: [Event::Key(Key::Backspace, true, Modifiers::none())],
  }
  ctx.begin_frame(input2)
  let (t2, _) = ctx.text_edit("edit1", initial_text, "")
  let _ = ctx.end_frame()

  assert_eq(t2, "AB")
  assert_eq(ctx.get_text_cursor_pos(id, 2), 1)
}
