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
/// Subsystem managing floating window stacking, dragging, draw batches, and z-ordering.
pub struct WindowManager {
  positions : @hashmap.HashMap[Id, @math.Vec2]
  batches : Array[(Id, @draw.DrawList)]
  drawn : Array[Id]
  focus : Array[Id]
  mut active_z : Int
  rects : Array[(@math.Rect, Int)]
  prev_rects : Array[(@math.Rect, Int)]
} derive(Eq, Debug)

///|
pub fn WindowManager::new() -> WindowManager {
  {
    positions: @hashmap.HashMap([], capacity=32),
    batches: [],
    drawn: [],
    focus: [],
    active_z: -1,
    rects: [],
    prev_rects: [],
  }
}

///|
pub fn WindowManager::begin_frame(self : WindowManager) -> Unit {
  self.drawn.clear()
  self.prev_rects.clear()
  for item in self.rects {
    self.prev_rects.push(item)
  }
  self.rects.clear()
  self.active_z = -1
}

///|
pub fn WindowManager::flush_to(
  self : WindowManager,
  target : @draw.DrawList,
) -> Unit {
  for id in self.focus {
    if self.drawn.contains(id) {
      for batch in self.batches {
        if batch.0 == id {
          target.append(batch.1)
        }
      }
    }
  }
}

///|
pub fn WindowManager::get_pos(
  self : WindowManager,
  id : Id,
  fallback : @math.Vec2,
) -> @math.Vec2 {
  match self.positions.get(id) {
    Some(pos) => pos
    None => fallback
  }
}

///|
pub fn WindowManager::set_pos(
  self : WindowManager,
  id : Id,
  pos : @math.Vec2,
) -> Unit {
  self.positions.set(id, pos)
}

///|
pub fn WindowManager::window_z(self : WindowManager, id : Id) -> Int {
  let mut rank = -1
  for i = 0; i < self.focus.length(); i = i + 1 {
    if self.focus[i] == id {
      rank = i
    }
  }
  if rank < 0 {
    self.focus.push(id)
    rank = self.focus.length() - 1
  }
  rank
}

///|
pub fn WindowManager::raise_window(self : WindowManager, id : Id) -> Unit {
  let kept : Array[Id] = []
  for other in self.focus {
    if other != id {
      kept.push(other)
    }
  }
  self.focus.clear()
  for other in kept {
    self.focus.push(other)
  }
  self.focus.push(id)
}

///|
pub fn WindowManager::batch(self : WindowManager, id : Id) -> @draw.DrawList {
  for b in self.batches {
    if b.0 == id {
      return b.1
    }
  }
  let list = @draw.DrawList::new()
  self.batches.push((id, list))
  list
}

///|
pub fn WindowManager::is_occluded(
  self : WindowManager,
  pt : @math.Vec2,
) -> Bool {
  let mut occluded = false
  for item in self.prev_rects {
    if item.1 > self.active_z && item.0.contains(pt) {
      occluded = true
    }
  }
  occluded
}

///|
pub fn WindowManager::record_rect(
  self : WindowManager,
  rect : @math.Rect,
  z : Int,
) -> Unit {
  self.rects.push((rect, z))
}

///|
pub fn WindowManager::mark_drawn(self : WindowManager, id : Id) -> Unit {
  self.drawn.push(id)
}

///|
pub fn WindowManager::prune_stale(self : WindowManager) -> Unit {
  let stale_ids : Array[Id] = []
  self.positions.each(fn(id, _) {
    if !self.drawn.contains(id) {
      stale_ids.push(id)
    }
  })
  for id in stale_ids {
    self.positions.remove(id)
  }
}

///|
pub fn WindowManager::active_z(self : WindowManager) -> Int {
  self.active_z
}

///|
pub fn WindowManager::set_active_z(self : WindowManager, z : Int) -> Unit {
  self.active_z = z
}
