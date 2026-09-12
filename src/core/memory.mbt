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
/// Generic, decoupled immediate-mode widget memory subsystem.
///
/// Stores cross-frame persistent widget state (scroll positions, cursor offsets,
/// toggle states, animation curves) indexed by `Id`, completely decoupling
/// concrete widgets from the central `UIContext` struct.
/// Supports tagged sub-keys for multiple properties per widget ID and generational
/// frame-counter pruning to prevent memory leaks in long-running dynamic interfaces.
pub struct Memory {
  integers : @hashmap.HashMap[Id, Int]
  doubles : @hashmap.HashMap[Id, Double]
  booleans : @hashmap.HashMap[Id, Bool]
  strings : @hashmap.HashMap[Id, String]
  ids : @hashmap.HashMap[Id, Id]
  last_accessed : @hashmap.HashMap[Id, Int]
  sub_keys : @hashmap.HashMap[Id, Array[Id]]
} derive(Eq, Debug)

///|
pub fn Memory::new() -> Memory {
  {
    integers: @hashmap.HashMap([], capacity=128),
    doubles: @hashmap.HashMap([], capacity=128),
    booleans: @hashmap.HashMap([], capacity=128),
    strings: @hashmap.HashMap([], capacity=64),
    ids: @hashmap.HashMap([], capacity=32),
    last_accessed: @hashmap.HashMap([], capacity=256),
    sub_keys: @hashmap.HashMap([], capacity=64),
  }
}

///|
fn Memory::resolve_key(id : Id, tag : String) -> Id {
  if tag == "" {
    id
  } else {
    id.with_tag(tag)
  }
}

///|
fn Memory::track_access(
  self : Memory,
  id : Id,
  effective_key : Id,
  tag : String,
  frame : Int,
) -> Unit {
  if frame > 0 {
    self.last_accessed.set(id, frame)
  }
  if tag != "" {
    match self.sub_keys.get(id) {
      Some(arr) => if !arr.contains(effective_key) { arr.push(effective_key) }
      None => self.sub_keys.set(id, [effective_key])
    }
  }
}

///|
pub fn Memory::get_int(self : Memory, id : Id, tag? : String = "") -> Int? {
  self.integers.get(Memory::resolve_key(id, tag))
}

///|
pub fn Memory::get_int_or_default(
  self : Memory,
  id : Id,
  default : Int,
  tag? : String = "",
) -> Int {
  match self.integers.get(Memory::resolve_key(id, tag)) {
    Some(v) => v
    None => default
  }
}

///|
pub fn Memory::set_int(
  self : Memory,
  id : Id,
  value : Int,
  tag? : String = "",
  frame? : Int = 0,
) -> Unit {
  let key = Memory::resolve_key(id, tag)
  self.integers.set(key, value)
  self.track_access(id, key, tag, frame)
}

///|
pub fn Memory::get_double(
  self : Memory,
  id : Id,
  tag? : String = "",
) -> Double? {
  self.doubles.get(Memory::resolve_key(id, tag))
}

///|
pub fn Memory::get_double_or_default(
  self : Memory,
  id : Id,
  default : Double,
  tag? : String = "",
) -> Double {
  match self.doubles.get(Memory::resolve_key(id, tag)) {
    Some(v) => v
    None => default
  }
}

///|
pub fn Memory::set_double(
  self : Memory,
  id : Id,
  value : Double,
  tag? : String = "",
  frame? : Int = 0,
) -> Unit {
  let key = Memory::resolve_key(id, tag)
  self.doubles.set(key, value)
  self.track_access(id, key, tag, frame)
}

///|
pub fn Memory::get_bool(self : Memory, id : Id, tag? : String = "") -> Bool? {
  self.booleans.get(Memory::resolve_key(id, tag))
}

///|
pub fn Memory::get_bool_or_default(
  self : Memory,
  id : Id,
  default : Bool,
  tag? : String = "",
) -> Bool {
  match self.booleans.get(Memory::resolve_key(id, tag)) {
    Some(v) => v
    None => default
  }
}

///|
pub fn Memory::set_bool(
  self : Memory,
  id : Id,
  value : Bool,
  tag? : String = "",
  frame? : Int = 0,
) -> Unit {
  let key = Memory::resolve_key(id, tag)
  self.booleans.set(key, value)
  self.track_access(id, key, tag, frame)
}

///|
pub fn Memory::get_string(
  self : Memory,
  id : Id,
  tag? : String = "",
) -> String? {
  self.strings.get(Memory::resolve_key(id, tag))
}

///|
pub fn Memory::get_string_or_default(
  self : Memory,
  id : Id,
  default : String,
  tag? : String = "",
) -> String {
  match self.strings.get(Memory::resolve_key(id, tag)) {
    Some(v) => v
    None => default
  }
}

///|
pub fn Memory::set_string(
  self : Memory,
  id : Id,
  value : String,
  tag? : String = "",
  frame? : Int = 0,
) -> Unit {
  let key = Memory::resolve_key(id, tag)
  self.strings.set(key, value)
  self.track_access(id, key, tag, frame)
}

///|
pub fn Memory::get_id(self : Memory, id : Id, tag? : String = "") -> Id? {
  self.ids.get(Memory::resolve_key(id, tag))
}

///|
pub fn Memory::set_id(
  self : Memory,
  id : Id,
  target : Id,
  tag? : String = "",
  frame? : Int = 0,
) -> Unit {
  let key = Memory::resolve_key(id, tag)
  self.ids.set(key, target)
  self.track_access(id, key, tag, frame)
}

///|
pub fn Memory::touch(self : Memory, id : Id, frame : Int) -> Unit {
  self.last_accessed.set(id, frame)
}

///|
pub fn Memory::remove_sub_key(self : Memory, id : Id, tag : String) -> Unit {
  let key = id.with_tag(tag)
  self.integers.remove(key)
  self.doubles.remove(key)
  self.booleans.remove(key)
  self.strings.remove(key)
  self.ids.remove(key)
}

///|
pub fn Memory::remove(self : Memory, id : Id) -> Unit {
  self.integers.remove(id)
  self.doubles.remove(id)
  self.booleans.remove(id)
  self.strings.remove(id)
  self.ids.remove(id)
  self.last_accessed.remove(id)
  match self.sub_keys.get(id) {
    Some(sub_list) => {
      for sub_id in sub_list {
        self.integers.remove(sub_id)
        self.doubles.remove(sub_id)
        self.booleans.remove(sub_id)
        self.strings.remove(sub_id)
        self.ids.remove(sub_id)
      }
      self.sub_keys.remove(id)
    }
    None => ()
  }
}

///|
pub fn Memory::prune_stale(
  self : Memory,
  current_frame : Int,
  ttl_frames : Int,
) -> Unit {
  if ttl_frames <= 0 {
    return
  }
  let stale_ids : Array[Id] = []
  self.last_accessed.each(fn(id, last_frame) {
    if current_frame - last_frame > ttl_frames {
      stale_ids.push(id)
    }
  })
  for id in stale_ids {
    self.remove(id)
  }
}
