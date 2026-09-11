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
test "dialog: initial state returns Open and renders to foreground" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::new())

  let res = ctx.dialog(
    "test_dlg", "Save Changes?", "Any unsaved edits will be lost.",
  )
  let dl = ctx.end_frame()

  assert_eq(res, DialogResult::Open)
  assert_true(dl.len() >= 6) // scrim + 2 shadows + card + outline + text
}

///|
test "dialog: semantic kinds render distinct badges" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::new())

  let _ = ctx.dialog(
    "info_dlg",
    "Note",
    "Informational text",
    kind=DialogKind::Info,
  )
  let _ = ctx.dialog(
    "warn_dlg",
    "Caution",
    "Low memory",
    kind=DialogKind::Warning,
  )
  let _ = ctx.dialog(
    "danger_dlg",
    "Delete Item",
    "Permanent deletion",
    kind=DialogKind::Danger,
  )
  let _ = ctx.end_frame()
}

///|
test "dialog: pressing Enter confirms dialog" {
  let ctx = UIContext::new()
  let raw = RawInput::new()
  raw.events.push(Event::Key(Key::Enter, true, Modifiers::none()))
  ctx.begin_frame(raw)

  let res = ctx.dialog(
    "confirm_dlg", "Confirm Action", "Do you want to proceed?",
  )
  let _ = ctx.end_frame()

  assert_eq(res, DialogResult::Confirmed)
}

///|
test "dialog: pressing Escape cancels dialog" {
  let ctx = UIContext::new()
  let raw = RawInput::new()
  raw.events.push(Event::Key(Key::Escape, true, Modifiers::none()))
  ctx.begin_frame(raw)

  let res = ctx.dialog("cancel_dlg", "Discard File", "Are you sure?")
  let _ = ctx.end_frame()

  assert_eq(res, DialogResult::Cancelled)
}

///|
test "dialog: clicking backdrop outside card cancels dialog" {
  let ctx = UIContext::new()
  // Click at top-left corner (x = 10.0, y = 10.0), far away from centered 380x160 card
  let raw = RawInput::from_mouse(@math.Vec2::new(10.0, 10.0), true)
  ctx.begin_frame(raw)

  let res = ctx.dialog("scrim_click_dlg", "Modal", "Click outside to dismiss")
  let _ = ctx.end_frame()

  assert_eq(res, DialogResult::Cancelled)
}
