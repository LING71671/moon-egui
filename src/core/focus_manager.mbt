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
/// Subsystem managing keyboard focus ring, active pointer ownership, and mouse capture.
pub struct FocusManager {
  mut hot_id : Id
  mut active_id : Id
  mut focused_id : Id
  mut prev_focused_id : Id
  mut lost_focus_id : Id
  mut pending_lost_focus_id : Id
  focusable_ids : Array[Id]
  mut wants_capture_mouse : Bool
  mut prev_wants_capture_mouse : Bool
} derive(Eq, Debug)

///|
pub fn FocusManager::new() -> FocusManager {
  {
    hot_id: Id::zero(),
    active_id: Id::zero(),
    focused_id: Id::zero(),
    prev_focused_id: Id::zero(),
    lost_focus_id: Id::zero(),
    pending_lost_focus_id: Id::zero(),
    focusable_ids: [],
    wants_capture_mouse: false,
    prev_wants_capture_mouse: false,
  }
}

///|
pub fn FocusManager::begin_frame(self : FocusManager) -> Unit {
  self.prev_focused_id = self.focused_id
  self.lost_focus_id = self.pending_lost_focus_id
  self.pending_lost_focus_id = Id::zero()
  self.focusable_ids.clear()
  self.wants_capture_mouse = false
}

///|
pub fn FocusManager::end_frame(self : FocusManager) -> Unit {
  self.prev_wants_capture_mouse = self.wants_capture_mouse
}

///|
/// Request focus for `id`. Returns `true` if focus was transferred to a new target.
pub fn FocusManager::request_focus(self : FocusManager, id : Id) -> Bool {
  if self.focused_id != id {
    if self.focused_id != Id::zero() {
      self.pending_lost_focus_id = self.focused_id
    }
    self.focused_id = id
    true
  } else {
    false
  }
}

///|
pub fn FocusManager::surrender_focus(self : FocusManager, id : Id) -> Unit {
  if self.focused_id == id {
    self.pending_lost_focus_id = id
    self.focused_id = Id::zero()
  }
}

///|
pub fn FocusManager::has_focus(self : FocusManager, id : Id) -> Bool {
  self.focused_id == id
}

///|
pub fn FocusManager::lost_focus(self : FocusManager, id : Id) -> Bool {
  self.lost_focus_id == id ||
  (self.pending_lost_focus_id == id && self.focused_id != id)
}

///|
pub fn FocusManager::register_focusable(self : FocusManager, id : Id) -> Unit {
  if !self.focusable_ids.contains(id) {
    self.focusable_ids.push(id)
  }
}

///|
pub fn FocusManager::clear_focusable(self : FocusManager) -> Unit {
  self.focusable_ids.clear()
}

///|
pub fn FocusManager::process_tab_traversal(
  self : FocusManager,
  shift : Bool,
) -> Bool {
  if self.focusable_ids.is_empty() {
    return false
  }
  let count = self.focusable_ids.length()
  let mut current_idx = -1
  for i = 0; i < count; i = i + 1 {
    if self.focusable_ids[i] == self.focused_id {
      current_idx = i
      break
    }
  }
  let next_idx = if shift {
    if current_idx <= 0 {
      count - 1
    } else {
      current_idx - 1
    }
  } else if current_idx < 0 || current_idx >= count - 1 {
    0
  } else {
    current_idx + 1
  }
  self.request_focus(self.focusable_ids[next_idx])
}

///|
pub fn FocusManager::hot_id(self : FocusManager) -> Id {
  self.hot_id
}

///|
pub fn FocusManager::set_hot_id(self : FocusManager, id : Id) -> Unit {
  self.hot_id = id
}

///|
pub fn FocusManager::active_id(self : FocusManager) -> Id {
  self.active_id
}

///|
pub fn FocusManager::set_active_id(self : FocusManager, id : Id) -> Unit {
  self.active_id = id
}

///|
pub fn FocusManager::focused_id(self : FocusManager) -> Id {
  self.focused_id
}

///|
pub fn FocusManager::set_focused_id(self : FocusManager, id : Id) -> Unit {
  self.focused_id = id
}

///|
pub fn FocusManager::prev_focused_id(self : FocusManager) -> Id {
  self.prev_focused_id
}

///|
pub fn FocusManager::wants_capture_mouse(self : FocusManager) -> Bool {
  self.wants_capture_mouse
}

///|
pub fn FocusManager::set_wants_capture_mouse(
  self : FocusManager,
  val : Bool,
) -> Unit {
  self.wants_capture_mouse = val
}

///|
pub fn FocusManager::prev_wants_capture_mouse(self : FocusManager) -> Bool {
  self.prev_wants_capture_mouse
}

///|
pub fn FocusManager::focusable_ids(self : FocusManager) -> Array[Id] {
  self.focusable_ids
}
