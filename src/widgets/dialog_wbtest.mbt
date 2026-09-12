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
test "widgets: dialog initial state returns Open and renders" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::new())

  let res = dialog(
    ctx, "test_dlg", "Save Changes?", "Any unsaved edits will be lost.",
  )
  let dl = ctx.end_frame()

  assert_eq(res, DialogResult::Open)
  assert_true(dl.len() >= 6)
}

///|
test "widgets: dialog semantic kinds render" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::new())

  let _ = dialog(
    ctx,
    "info_dlg",
    "Note",
    "Informational text",
    kind=DialogKind::Info,
  )
  let _ = dialog(
    ctx,
    "warn_dlg",
    "Caution",
    "Low memory",
    kind=DialogKind::Warning,
  )
  let _ = dialog(
    ctx,
    "danger_dlg",
    "Delete Item",
    "Permanent deletion",
    kind=DialogKind::Danger,
  )
  let _ = ctx.end_frame()
}

///|
test "widgets: dialog enter confirms" {
  let ctx = UIContext::new()
  let raw = RawInput::with_events(
    @math.Vec2::zero(),
    false,
    @math.Vec2::zero(),
    [@core.Event::Key(Key::Enter, true, Modifiers::none())],
    "",
    Modifiers::none(),
  )
  ctx.begin_frame(raw)

  let res = dialog(ctx, "dlg_enter", "Confirm", "Press Enter")
  let _ = ctx.end_frame()

  assert_eq(res, DialogResult::Confirmed)
}

///|
test "widgets: dialog escape cancels" {
  let ctx = UIContext::new()
  let raw = RawInput::with_events(
    @math.Vec2::zero(),
    false,
    @math.Vec2::zero(),
    [@core.Event::Key(Key::Escape, true, Modifiers::none())],
    "",
    Modifiers::none(),
  )
  ctx.begin_frame(raw)

  let res = dialog(ctx, "dlg_esc", "Cancel", "Press Escape")
  let _ = ctx.end_frame()

  assert_eq(res, DialogResult::Cancelled)
}
