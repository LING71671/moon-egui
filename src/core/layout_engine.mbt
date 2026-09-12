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
/// Subsystem managing cursor positioning, layout scopes (TopDown, LeftToRight, Wrapped),
/// available width, and automatic ID sequencing.
pub struct LayoutEngine {
  layout_stack : Array[LayoutScope]
  mut cursor : @math.Vec2
  mut available_width : Double
  mut item_spacing : @math.Vec2
  mut auto_id_counter : Int
} derive(Eq, Debug)

///|
pub fn LayoutEngine::new() -> LayoutEngine {
  {
    layout_stack: [
      {
        dir: TopDown,
        start_x: 0.0,
        start_y: 0.0,
        max_cross_size: 0.0,
        current_row_h: 0.0,
        wrap_width: 0.0,
      },
    ],
    cursor: @math.Vec2::zero(),
    available_width: 800.0,
    item_spacing: @math.Vec2::new(8.0, 8.0),
    auto_id_counter: 0,
  }
}

///|
pub fn LayoutEngine::begin_frame(
  self : LayoutEngine,
  screen_w : Double,
) -> Unit {
  self.cursor = @math.Vec2::zero()
  self.available_width = if screen_w > 0.0 { screen_w } else { 800.0 }
  self.auto_id_counter = 0
  self.layout_stack.clear()
  self.layout_stack.push({
    dir: TopDown,
    start_x: 0.0,
    start_y: 0.0,
    max_cross_size: 0.0,
    current_row_h: 0.0,
    wrap_width: 0.0,
  })
}

///|
pub fn LayoutEngine::current_scope(self : LayoutEngine) -> LayoutScope? {
  if self.layout_stack.is_empty() {
    None
  } else {
    Some(self.layout_stack[self.layout_stack.length() - 1])
  }
}

///|
pub fn LayoutEngine::push_scope(
  self : LayoutEngine,
  scope : LayoutScope,
) -> Unit {
  self.layout_stack.push(scope)
}

///|
pub fn LayoutEngine::pop_scope(self : LayoutEngine) -> LayoutScope? {
  if self.layout_stack.is_empty() {
    None
  } else {
    self.layout_stack.pop()
  }
}

///|
pub fn LayoutEngine::allocate_rect(
  self : LayoutEngine,
  size : @math.Vec2,
) -> @math.Rect {
  let current_scope = self.current_scope()

  // Pre-allocation line wrapping for LeftToRightWrapped
  match current_scope {
    Some(scope) =>
      if scope.dir == LeftToRightWrapped {
        let wrap_w = if scope.wrap_width > 0.0 {
          scope.wrap_width
        } else {
          self.available_width
        }
        if self.cursor.x > scope.start_x &&
          self.cursor.x + size.x > scope.start_x + wrap_w {
          let next_y = self.cursor.y + scope.current_row_h + self.item_spacing.y
          scope.max_cross_size = scope.max_cross_size +
            scope.current_row_h +
            self.item_spacing.y
          scope.current_row_h = 0.0
          self.cursor = @math.Vec2::new(scope.start_x, next_y)
        }
      }
    None => ()
  }

  let item_y = match current_scope {
    Some(scope) =>
      if scope.dir == LeftToRight {
        scope.start_y
      } else {
        self.cursor.y
      }
    None => self.cursor.y
  }
  let rect = @math.Rect::new(self.cursor.x, item_y, size.x, size.y)

  match current_scope {
    Some(scope) =>
      match scope.dir {
        TopDown => {
          if size.x > scope.max_cross_size {
            scope.max_cross_size = size.x
          }
          self.cursor = @math.Vec2::new(
            self.cursor.x,
            self.cursor.y + size.y + self.item_spacing.y,
          )
        }
        LeftToRight => {
          if size.y > scope.max_cross_size {
            scope.max_cross_size = size.y
          }
          self.cursor = @math.Vec2::new(
            self.cursor.x + size.x + self.item_spacing.x,
            scope.start_y,
          )
        }
        LeftToRightWrapped => {
          if size.y > scope.current_row_h {
            scope.current_row_h = size.y
          }
          self.cursor = @math.Vec2::new(
            self.cursor.x + size.x + self.item_spacing.x,
            self.cursor.y,
          )
        }
      }
    None =>
      self.cursor = @math.Vec2::new(
        self.cursor.x,
        self.cursor.y + size.y + self.item_spacing.y,
      )
  }

  rect
}

///|
pub fn LayoutEngine::cursor(self : LayoutEngine) -> @math.Vec2 {
  self.cursor
}

///|
pub fn LayoutEngine::set_cursor(self : LayoutEngine, pos : @math.Vec2) -> Unit {
  self.cursor = pos
}

///|
pub fn LayoutEngine::available_width(self : LayoutEngine) -> Double {
  self.available_width
}

///|
pub fn LayoutEngine::set_available_width(
  self : LayoutEngine,
  w : Double,
) -> Unit {
  self.available_width = w
}

///|
pub fn LayoutEngine::item_spacing(self : LayoutEngine) -> @math.Vec2 {
  self.item_spacing
}

///|
pub fn LayoutEngine::set_item_spacing(
  self : LayoutEngine,
  spacing : @math.Vec2,
) -> Unit {
  self.item_spacing = spacing
}

///|
pub fn LayoutEngine::next_auto_id_counter(self : LayoutEngine) -> Int {
  self.auto_id_counter = self.auto_id_counter + 1
  self.auto_id_counter
}

///|
pub fn LayoutEngine::layout_stack(self : LayoutEngine) -> Array[LayoutScope] {
  self.layout_stack
}
