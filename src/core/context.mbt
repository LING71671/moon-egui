///|
pub enum LayoutDirection {
  TopDown
  LeftToRight
} derive(Eq, Debug)

///|
pub struct LayoutScope {
  dir : LayoutDirection
  start_x : Double
  start_y : Double
  mut max_cross_size : Double
} derive(Eq, Debug)

///|
pub struct UIContext {
  input : InputState
  draw_list : @draw.DrawList
  id_stack : IdStack
  mut hot_id : Id
  mut active_id : Id
  mut focused_id : Id
  mut cursor : @math.Vec2
  mut available_width : Double
  mut item_spacing : @math.Vec2
  clip_stack : Array[@math.Rect]
  mut auto_id_counter : Int
  layout_stack : Array[LayoutScope]
  mut wants_capture_mouse : Bool
  mut prev_wants_capture_mouse : Bool
} derive(Eq, Debug)

///|
pub fn UIContext::new() -> UIContext {
  {
    input: InputState::new(),
    draw_list: @draw.DrawList::new(),
    id_stack: IdStack::new(),
    hot_id: Id::zero(),
    active_id: Id::zero(),
    focused_id: Id::zero(),
    cursor: @math.Vec2::zero(),
    available_width: 800.0,
    item_spacing: @math.Vec2::new(8.0, 8.0),
    clip_stack: [],
    auto_id_counter: 0,
    layout_stack: [
      { dir: TopDown, start_x: 0.0, start_y: 0.0, max_cross_size: 0.0, },
    ],
    wants_capture_mouse: false,
    prev_wants_capture_mouse: false,
  }
}

///|
pub fn UIContext::begin_frame(self : UIContext, raw_input : RawInput) -> Unit {
  self.input.update(raw_input)
  self.draw_list.clear()
  self.cursor = @math.Vec2::zero()
  self.clip_stack.clear()
  self.auto_id_counter = 0
  self.hot_id = Id::zero()
  self.wants_capture_mouse = false
  self.layout_stack.clear()
  self.layout_stack.push({
    dir: TopDown,
    start_x: 0.0,
    start_y: 0.0,
    max_cross_size: 0.0,
  })
}

///|
pub fn UIContext::end_frame(self : UIContext) -> @draw.DrawList {
  self.prev_wants_capture_mouse = self.wants_capture_mouse
  self.draw_list
}

///|
pub fn UIContext::push_id(self : UIContext, salt : String) -> Unit {
  self.id_stack.push(salt)
}

///|
pub fn UIContext::pop_id(self : UIContext) -> Unit {
  self.id_stack.pop()
}

///|
pub fn UIContext::cursor(self : UIContext) -> @math.Vec2 {
  self.cursor
}

///|
pub fn UIContext::set_cursor(self : UIContext, pos : @math.Vec2) -> Unit {
  self.cursor = pos
}

///|
pub fn UIContext::advance_cursor(self : UIContext, offset : @math.Vec2) -> Unit {
  self.cursor = self.cursor.add(offset)
}

///|
pub fn UIContext::item_spacing(self : UIContext) -> @math.Vec2 {
  self.item_spacing
}

///|
pub fn UIContext::set_item_spacing(
  self : UIContext,
  spacing : @math.Vec2,
) -> Unit {
  self.item_spacing = spacing
}

///|
pub fn UIContext::draw_list(self : UIContext) -> @draw.DrawList {
  self.draw_list
}

///|
pub fn UIContext::input(self : UIContext) -> InputState {
  self.input
}

///|
pub fn UIContext::hot_id(self : UIContext) -> Id {
  self.hot_id
}

///|
pub fn UIContext::active_id(self : UIContext) -> Id {
  self.active_id
}

///|
pub fn UIContext::focused_id(self : UIContext) -> Id {
  self.focused_id
}

///|
pub fn UIContext::set_focused_id(self : UIContext, id : Id) -> Unit {
  self.focused_id = id
}

///|
pub fn UIContext::available_width(self : UIContext) -> Double {
  self.available_width
}

///|
pub fn UIContext::set_available_width(self : UIContext, width : Double) -> Unit {
  self.available_width = width
}

///|
/// Core space allocator and hit-testing primitive.
/// All existing and custom third-party widgets evaluate interaction through this method.
pub fn UIContext::allocate_space(
  self : UIContext,
  size : @math.Vec2,
) -> (Id, @math.Rect, Response) {
  self.auto_id_counter = self.auto_id_counter + 1
  let id = self.id_stack.derive_id(self.auto_id_counter.to_string())
  let rect = @math.Rect::new(self.cursor.x, self.cursor.y, size.x, size.y)

  // Layout advancement based on current layout direction
  let current_scope = if self.layout_stack.is_empty() {
    None
  } else {
    Some(self.layout_stack[self.layout_stack.length() - 1])
  }

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

  // Hit-testing evaluation
  let hovered = rect.contains(self.input.mouse_pos)
  if hovered {
    self.hot_id = id
    self.wants_capture_mouse = true
  }

  // Pointer interaction state machine
  if hovered && self.input.mouse_pressed {
    self.active_id = id
  }

  let is_active = self.active_id == id
  if is_active {
    self.wants_capture_mouse = true
  }
  let pressed = is_active && self.input.mouse_down
  let clicked = is_active && self.input.mouse_released && hovered
  let dragged = is_active &&
    self.input.mouse_down &&
    self.input.mouse_delta.length_sq() > 0.0

  if self.input.mouse_released && is_active {
    self.active_id = Id::zero()
  }

  let response = Response::new(id, rect, hovered, clicked, pressed, dragged)
  (id, rect, response)
}

///|
pub fn UIContext::set_active_id(self : UIContext, id : Id) -> Unit {
  self.active_id = id
}

///|
/// Returns true if the pointer is currently hovering over or interacting with any UI widget or window.
pub fn UIContext::wants_capture_mouse(self : UIContext) -> Bool {
  self.prev_wants_capture_mouse || self.wants_capture_mouse
}

///|
/// Explicitly declare that the UI context is capturing pointer input this frame.
pub fn UIContext::set_wants_capture_mouse(
  self : UIContext,
  capture : Bool,
) -> Unit {
  self.wants_capture_mouse = capture
}

///|
/// Scoped horizontal layout flow (Left-to-Right).
/// Arranges child widgets side-by-side, tracks the maximum row height,
/// and returns the cursor to the start X position advanced downwards by row height.
pub fn UIContext::horizontal(
  self : UIContext,
  content : (UIContext) -> Unit,
) -> Unit {
  let start_x = self.cursor.x
  let start_y = self.cursor.y
  let scope : LayoutScope = {
    dir: LeftToRight,
    start_x,
    start_y,
    max_cross_size: 0.0,
  }
  self.layout_stack.push(scope)
  content(self)
  let popped = self.layout_stack.pop()
  let max_h = match popped {
    Some(s) => s.max_cross_size
    None => 0.0
  }
  self.cursor = @math.Vec2::new(start_x, start_y + max_h + self.item_spacing.y)
}

///|
/// Scoped vertical layout flow (TopDown).
pub fn UIContext::vertical(
  self : UIContext,
  content : (UIContext) -> Unit,
) -> Unit {
  let start_x = self.cursor.x
  let start_y = self.cursor.y
  let scope : LayoutScope = {
    dir: TopDown,
    start_x,
    start_y,
    max_cross_size: 0.0,
  }
  self.layout_stack.push(scope)
  content(self)
  let _ = self.layout_stack.pop()
}
