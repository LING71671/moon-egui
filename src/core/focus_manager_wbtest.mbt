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
test "focus_manager: focus transfer and lost_focus lifecycle" {
  let fm = FocusManager::new()
  let id_a = Id::from_int(10)
  let id_b = Id::from_int(20)

  assert_eq(fm.focused_id(), Id::zero())
  assert_false(fm.has_focus(id_a))

  // Transfer focus to id_a
  assert_true(fm.request_focus(id_a))
  assert_true(fm.has_focus(id_a))
  assert_false(fm.request_focus(id_a)) // idempotent

  // Transfer focus to id_b
  assert_true(fm.request_focus(id_b))
  assert_true(fm.has_focus(id_b))

  // Begin next frame: id_a should report lost_focus
  fm.begin_frame()
  assert_true(fm.lost_focus(id_a))
  assert_false(fm.lost_focus(id_b))

  // Subsequent frame: lost_focus cleared
  fm.begin_frame()
  assert_false(fm.lost_focus(id_a))
}

///|
test "focus_manager: tab traversal cycling" {
  let fm = FocusManager::new()
  let id1 = Id::from_int(1)
  let id2 = Id::from_int(2)
  let id3 = Id::from_int(3)

  fm.register_focusable(id1)
  fm.register_focusable(id2)
  fm.register_focusable(id3)

  // Initial tab moves to first focusable
  let _ = fm.process_tab_traversal(false)
  assert_eq(fm.focused_id(), id1)

  // Next tab moves to second
  let _ = fm.process_tab_traversal(false)
  assert_eq(fm.focused_id(), id2)

  // Shift-tab moves back to first
  let _ = fm.process_tab_traversal(true)
  assert_eq(fm.focused_id(), id1)

  // Shift-tab from first wraps to last
  let _ = fm.process_tab_traversal(true)
  assert_eq(fm.focused_id(), id3)

  // Tab from last wraps to first
  let _ = fm.process_tab_traversal(false)
  assert_eq(fm.focused_id(), id1)
}
