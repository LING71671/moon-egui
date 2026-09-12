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
/// Subsystem managing scissor clipping, foreground overlays, and blocking hit-test rects.
pub struct LayerManager {
  mut draw_list : @draw.DrawList
  fg_draw_list : @draw.DrawList
  mut fg_saved_draw_list : @draw.DrawList
  clip_stack : Array[@math.Rect]
  fg_saved_clip_stack : Array[@math.Rect]
  mut foreground : Bool
  blocking_rects : Array[@math.Rect]
  prev_blocking_rects : Array[@math.Rect]
} derive(Eq, Debug)

///|
pub fn LayerManager::new() -> LayerManager {
  {
    draw_list: @draw.DrawList::new(),
    fg_draw_list: @draw.DrawList::new(),
    fg_saved_draw_list: @draw.DrawList::new(),
    clip_stack: [],
    fg_saved_clip_stack: [],
    foreground: false,
    blocking_rects: [],
    prev_blocking_rects: [],
  }
}

///|
pub fn LayerManager::begin_frame(self : LayerManager) -> Unit {
  self.draw_list.clear()
  self.fg_draw_list.clear()
  self.clip_stack.clear()
  self.foreground = false
  self.prev_blocking_rects.clear()
  for rect in self.blocking_rects {
    self.prev_blocking_rects.push(rect)
  }
  self.blocking_rects.clear()
}

///|
pub fn LayerManager::push_clip(self : LayerManager, rect : @math.Rect) -> Unit {
  let effective_rect = if self.clip_stack.is_empty() {
    rect
  } else {
    let parent_clip = self.clip_stack[self.clip_stack.length() - 1]
    parent_clip.intersect(rect)
  }
  self.clip_stack.push(effective_rect)
  self.draw_list.push_clip(effective_rect)
}

///|
pub fn LayerManager::pop_clip(self : LayerManager) -> Unit {
  if !self.clip_stack.is_empty() {
    let _ = self.clip_stack.pop()
    self.draw_list.pop_clip()
  }
}

///|
pub fn LayerManager::current_clip(self : LayerManager) -> @math.Rect? {
  if self.clip_stack.is_empty() {
    None
  } else {
    Some(self.clip_stack[self.clip_stack.length() - 1])
  }
}

///|
pub fn LayerManager::begin_foreground(self : LayerManager) -> Unit {
  if self.foreground {
    return
  }
  self.fg_saved_draw_list = self.draw_list
  self.fg_saved_clip_stack.clear()
  for rect in self.clip_stack {
    self.fg_saved_clip_stack.push(rect)
  }
  self.clip_stack.clear()
  self.draw_list = self.fg_draw_list
  self.foreground = true
}

///|
pub fn LayerManager::end_foreground(self : LayerManager) -> Unit {
  if !self.foreground {
    return
  }
  self.draw_list = self.fg_saved_draw_list
  self.clip_stack.clear()
  for rect in self.fg_saved_clip_stack {
    self.clip_stack.push(rect)
  }
  self.fg_saved_clip_stack.clear()
  self.foreground = false
}

///|
pub fn LayerManager::block_hover(
  self : LayerManager,
  rect : @math.Rect,
) -> Unit {
  self.blocking_rects.push(rect)
}

///|
pub fn LayerManager::is_blocked_by_foreground(
  self : LayerManager,
  pt : @math.Vec2,
) -> Bool {
  let mut blocked = false
  for rect in self.prev_blocking_rects {
    if rect.contains(pt) {
      blocked = true
    }
  }
  blocked
}

///|
pub fn LayerManager::draw_list(self : LayerManager) -> @draw.DrawList {
  self.draw_list
}

///|
pub fn LayerManager::set_draw_list(
  self : LayerManager,
  list : @draw.DrawList,
) -> Unit {
  self.draw_list = list
}

///|
pub fn LayerManager::fg_draw_list(self : LayerManager) -> @draw.DrawList {
  self.fg_draw_list
}

///|
pub fn LayerManager::clip_stack(self : LayerManager) -> Array[@math.Rect] {
  self.clip_stack
}

///|
pub fn LayerManager::is_foreground(self : LayerManager) -> Bool {
  self.foreground
}
