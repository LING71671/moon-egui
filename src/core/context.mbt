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
    item_spacing: @math.Vec2::new(0.0, 8.0),
    clip_stack: [],
    auto_id_counter: 0,
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
}

///|
pub fn UIContext::end_frame(self : UIContext) -> @draw.DrawList {
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

  // Advance linear layout cursor downwards
  self.cursor = @math.Vec2::new(
    self.cursor.x,
    self.cursor.y + size.y + self.item_spacing.y,
  )

  // Hit-testing evaluation
  let hovered = rect.contains(self.input.mouse_pos)
  if hovered {
    self.hot_id = id
  }

  // Pointer interaction state machine
  if hovered && self.input.mouse_pressed {
    self.active_id = id
  }

  let is_active = self.active_id == id
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
