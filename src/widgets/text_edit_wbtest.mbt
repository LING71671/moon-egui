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
test "widgets: text_edit unicode boundary handling" {
  let text = "A\u{1F600}B"
  assert_eq(text.length(), 4)

  assert_eq(@core.next_char_boundary(text, 1), 3)
  assert_eq(@core.prev_char_boundary(text, 3), 1)

  let (after_bs, new_pos) = @core.delete_prev_char(text, 3)
  assert_eq(after_bs, "AB")
  assert_eq(new_pos, 1)

  let after_del = @core.delete_next_char(text, 1)
  assert_eq(after_del, "AB")
}

///|
test "widgets: text_edit ref binding and interaction" {
  let ctx = UIContext::new()

  let str_ref = Ref("A\u{1F600}B")
  let input1 = RawInput::from_mouse(@math.Vec2::new(20.0, 10.0), true)
  ctx.begin_frame(input1)
  let resp1 = text_edit(ctx, "edit1", str_ref)
  let _ = ctx.end_frame()
  assert_eq(str_ref.val, "A\u{1F600}B")
  let id = resp1.id

  ctx.set_text_cursor_pos(id, 3)

  let input2 = RawInput::with_events(
    @math.Vec2::zero(),
    false,
    @math.Vec2::zero(),
    [@core.Event::Key(Key::Backspace, true, Modifiers::none())],
    "",
    Modifiers::none(),
  )
  ctx.begin_frame(input2)
  let _ = text_edit(ctx, "edit1", str_ref)
  let _ = ctx.end_frame()

  assert_eq(str_ref.val, "AB")
  assert_eq(ctx.get_text_cursor_pos(id, 2), 1)
}
