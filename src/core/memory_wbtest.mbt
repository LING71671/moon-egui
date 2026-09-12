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
test "memory: typed get and set with defaults" {
  let mem = Memory::new()
  let id1 = Id::from_int(101)
  let id2 = Id::from_int(102)

  // Integers
  assert_eq(mem.get_int(id1), None)
  assert_eq(mem.get_int_or_default(id1, 42), 42)
  mem.set_int(id1, 100)
  assert_eq(mem.get_int(id1), Some(100))
  assert_eq(mem.get_int_or_default(id1, 42), 100)

  // Doubles
  assert_eq(mem.get_double(id1), None)
  assert_eq(mem.get_double_or_default(id1, 3.14), 3.14)
  mem.set_double(id1, 2.718)
  assert_eq(mem.get_double(id1), Some(2.718))

  // Booleans
  assert_eq(mem.get_bool(id2), None)
  assert_eq(mem.get_bool_or_default(id2, false), false)
  mem.set_bool(id2, true)
  assert_eq(mem.get_bool(id2), Some(true))

  // Strings
  assert_eq(mem.get_string(id2), None)
  assert_eq(mem.get_string_or_default(id2, "fallback"), "fallback")
  mem.set_string(id2, "saved")
  assert_eq(mem.get_string(id2), Some("saved"))

  // IDs
  assert_eq(mem.get_id(id1), None)
  mem.set_id(id1, id2)
  assert_eq(mem.get_id(id1), Some(id2))
}

///|
test "memory: generational pruning removes stale records" {
  let mem = Memory::new()
  let id_stale = Id::from_int(201)
  let id_active = Id::from_int(202)

  // Set stale record touched at frame 10
  mem.set_int(id_stale, 999, frame=10)
  mem.set_double(id_stale, 123.45, frame=10)

  // Set active record touched at frame 50
  mem.set_int(id_active, 888, frame=50)

  // At frame 65 with TTL 30:
  // id_stale elapsed = 65 - 10 = 55 > 30 -> should be pruned
  // id_active elapsed = 65 - 50 = 15 <= 30 -> should be kept
  mem.prune_stale(65, 30)

  assert_eq(mem.get_int(id_stale), None)
  assert_eq(mem.get_double(id_stale), None)
  assert_eq(mem.get_int(id_active), Some(888))
}

///|
test "memory: remove cleans up across all typed tables" {
  let mem = Memory::new()
  let id = Id::from_int(301)

  mem.set_int(id, 10)
  mem.set_double(id, 20.0)
  mem.set_bool(id, true)
  mem.set_string(id, "data")
  mem.set_id(id, Id::zero())

  mem.remove(id)

  assert_eq(mem.get_int(id), None)
  assert_eq(mem.get_double(id), None)
  assert_eq(mem.get_bool(id), None)
  assert_eq(mem.get_string(id), None)
  assert_eq(mem.get_id(id), None)
}

///|
test "memory: tagged sub-keys and cascading removal" {
  let mem = Memory::new()
  let widget_id = Id::from_int(401)

  // Set primary and sub-key properties
  mem.set_double(widget_id, 150.0)
  mem.set_double(widget_id, 800.0, tag="content_h")
  mem.set_int(widget_id, 12, tag="cursor_pos")
  mem.set_bool(widget_id, true, tag="is_open")

  assert_eq(mem.get_double(widget_id), Some(150.0))
  assert_eq(mem.get_double(widget_id, tag="content_h"), Some(800.0))
  assert_eq(mem.get_int(widget_id, tag="cursor_pos"), Some(12))
  assert_eq(mem.get_bool(widget_id, tag="is_open"), Some(true))

  // Removing single sub-key
  mem.remove_sub_key(widget_id, "is_open")
  assert_eq(mem.get_bool(widget_id, tag="is_open"), None)
  assert_eq(mem.get_double(widget_id), Some(150.0))

  // Removing widget_id cleans all remaining sub-keys
  mem.remove(widget_id)
  assert_eq(mem.get_double(widget_id), None)
  assert_eq(mem.get_double(widget_id, tag="content_h"), None)
  assert_eq(mem.get_int(widget_id, tag="cursor_pos"), None)
}
