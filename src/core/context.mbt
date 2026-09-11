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

///|
pub struct UIContext {
  input : InputState
  mut draw_list : @draw.DrawList
  id_stack : IdStack
  mut hot_id : Id
  mut active_id : Id
  mut focused_id : Id
  mut prev_focused_id : Id
  mut lost_focus_id : Id
  mut pending_lost_focus_id : Id
  focusable_ids : Array[Id]
  mut cursor : @math.Vec2
  mut available_width : Double
  mut item_spacing : @math.Vec2
  clip_stack : Array[@math.Rect]
  mut auto_id_counter : Int
  layout_stack : Array[LayoutScope]
  scroll_offsets : Array[(Id, Double)]
  scroll_content_heights : Array[(Id, Double)]
  window_positions : Array[(Id, @math.Vec2)]
  window_batches : Array[(Id, @draw.DrawList)]
  window_drawn : Array[Id]
  window_focus : Array[Id]
  mut win_active_z : Int
  window_rects : Array[(@math.Rect, Int)]
  prev_window_rects : Array[(@math.Rect, Int)]
  text_cursor_positions : Array[(Id, Int)]
  open_collapsing_ids : Array[(Id, Bool)]
  mut open_combo_id : Id
  mut open_menu_id : Id
  mut wants_capture_mouse : Bool
  mut prev_wants_capture_mouse : Bool
  fg_draw_list : @draw.DrawList
  mut fg_saved_draw_list : @draw.DrawList
  fg_saved_clip_stack : Array[@math.Rect]
  mut foreground : Bool
  blocking_rects : Array[@math.Rect]
  prev_blocking_rects : Array[@math.Rect]
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
    prev_focused_id: Id::zero(),
    lost_focus_id: Id::zero(),
    pending_lost_focus_id: Id::zero(),
    focusable_ids: [],
    cursor: @math.Vec2::zero(),
    available_width: 800.0,
    item_spacing: @math.Vec2::new(8.0, 8.0),
    clip_stack: [],
    auto_id_counter: 0,
    layout_stack: [
      { dir: TopDown, start_x: 0.0, start_y: 0.0, max_cross_size: 0.0, },
    ],
    scroll_offsets: [],
    scroll_content_heights: [],
    window_positions: [],
    window_batches: [],
    window_drawn: [],
    window_focus: [],
    win_active_z: -1,
    window_rects: [],
    prev_window_rects: [],
    text_cursor_positions: [],
    open_collapsing_ids: [],
    open_combo_id: Id::zero(),
    open_menu_id: Id::zero(),
    wants_capture_mouse: false,
    prev_wants_capture_mouse: false,
    fg_draw_list: @draw.DrawList::new(),
    fg_saved_draw_list: @draw.DrawList::new(),
    fg_saved_clip_stack: [],
    foreground: false,
    blocking_rects: [],
    prev_blocking_rects: [],
  }
}

///|
pub fn UIContext::begin_frame(self : UIContext, raw_input : RawInput) -> Unit {
  self.input.update(raw_input)
  self.draw_list.clear()
  self.fg_draw_list.clear()
  self.foreground = false

  // Snapshot last frame's blocking regions, then reopen collection for this
  // frame. Blocking regions apply with one frame of latency so that widgets
  // drawn before a popup still see the suppression.
  self.prev_blocking_rects.clear()
  for rect in self.blocking_rects {
    self.prev_blocking_rects.push(rect)
  }
  self.blocking_rects.clear()

  // Windows are re-batched every frame and composited in z order, so the
  // previous frame's rects are the only ones that can be tested for occlusion.
  self.window_drawn.clear()
  self.win_active_z = -1
  self.prev_window_rects.clear()
  for item in self.window_rects {
    self.prev_window_rects.push(item)
  }
  self.window_rects.clear()

  self.cursor = @math.Vec2::zero()
  self.clip_stack.clear()
  self.auto_id_counter = 0
  self.hot_id = Id::zero()
  self.prev_focused_id = self.focused_id
  self.lost_focus_id = self.pending_lost_focus_id
  self.pending_lost_focus_id = Id::zero()
  self.focusable_ids.clear()
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
  // Process Tab key focus traversal
  if self.input.key_pressed(Key::Tab) && !self.focusable_ids.is_empty() {
    let count = self.focusable_ids.length()
    let mut current_idx = -1
    for i = 0; i < count; i = i + 1 {
      if self.focusable_ids[i] == self.focused_id {
        current_idx = i
        break
      }
    }
    let is_shift = self.input.modifiers.shift
    let next_idx = if is_shift {
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

  self.prev_wants_capture_mouse = self.wants_capture_mouse

  // Composite the deferred layers: floating windows bottom-up, then the
  // foreground layer (popups, tooltips) above everything.
  for id in self.window_focus {
    if self.window_drawn.contains(id) {
      for batch in self.window_batches {
        if batch.0 == id {
          self.draw_list.append(batch.1)
        }
      }
    }
  }
  self.draw_list.append(self.fg_draw_list)
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
  // Layout advancement based on current layout direction
  let current_scope = if self.layout_stack.is_empty() {
    None
  } else {
    Some(self.layout_stack[self.layout_stack.length() - 1])
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
      }
    None =>
      self.cursor = @math.Vec2::new(
        self.cursor.x,
        self.cursor.y + size.y + self.item_spacing.y,
      )
  }

  // Hit-testing evaluation
  let hovered = self.is_hovered(rect)
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

  let is_focused = self.focused_id == id
  let gained_focus = is_focused && self.prev_focused_id != id
  let lost_focus = self.lost_focus_id == id ||
    (self.pending_lost_focus_id == id && !is_focused)

  if clicked {
    self.request_focus(id)
  }

  let response = Response::with_focus(
    id, rect, hovered, clicked, pressed, dragged, is_focused, gained_focus, lost_focus,
  )
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

///|
pub fn UIContext::request_focus(self : UIContext, id : Id) -> Unit {
  if self.focused_id != id {
    if self.focused_id != Id::zero() {
      self.pending_lost_focus_id = self.focused_id
    }
    self.focused_id = id
  }
}

///|
pub fn UIContext::surrender_focus(self : UIContext, id : Id) -> Unit {
  if self.focused_id == id {
    self.pending_lost_focus_id = id
    self.focused_id = Id::zero()
  }
}

///|
pub fn UIContext::has_focus(self : UIContext, id : Id) -> Bool {
  self.focused_id == id
}

///|
pub fn UIContext::register_focusable(self : UIContext, id : Id) -> Unit {
  if !self.focusable_ids.contains(id) {
    self.focusable_ids.push(id)
  }
}

///|
pub fn UIContext::push_clip(self : UIContext, rect : @math.Rect) -> Unit {
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
pub fn UIContext::pop_clip(self : UIContext) -> Unit {
  if !self.clip_stack.is_empty() {
    let _ = self.clip_stack.pop()
  }
  self.draw_list.pop_clip()
}

///|
pub fn UIContext::current_clip(self : UIContext) -> @math.Rect? {
  if self.clip_stack.is_empty() {
    None
  } else {
    Some(self.clip_stack[self.clip_stack.length() - 1])
  }
}

///|
/// Clip-aware hover test. The pointer hovers `rect` only when it is inside the
/// rect, inside the active scissor clip, and neither covered by a foreground
/// blocking region nor by a window stacked above the current draw target.
/// Widgets that scroll out of a container or spill outside a window therefore
/// stop responding to the pointer.
pub fn UIContext::is_hovered(self : UIContext, rect : @math.Rect) -> Bool {
  let visible = match self.current_clip() {
    Some(clip) => rect.intersect(clip)
    None => rect
  }
  let in_visible_rect = visible.w > 0.0 &&
    visible.h > 0.0 &&
    visible.contains(self.input.mouse_pos)
  in_visible_rect &&
  (
    self.foreground ||
    (
      !self.is_blocked_by_foreground(self.input.mouse_pos) &&
      !self.is_occluded_by_window(self.input.mouse_pos)
    )
  )
}

///|
/// True when `pt` falls inside a blocking region registered by a popup on the
/// previous frame. Regions of the current frame are not consulted yet, because
/// widgets drawn earlier in the frame cannot retroactively lose hover.
fn UIContext::is_blocked_by_foreground(
  self : UIContext,
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
/// True when a window stacked above the current draw target covers `pt`.
/// Content on the main layer sits below every window, so `win_active_z` is -1
/// there; window content only yields to strictly higher windows.
fn UIContext::is_occluded_by_window(self : UIContext, pt : @math.Vec2) -> Bool {
  let mut occluded = false
  for item in self.prev_window_rects {
    if item.1 > self.win_active_z && item.0.contains(pt) {
      occluded = true
    }
  }
  occluded
}

///|
/// Stacking rank of a window: the index in the focus order, where a higher
/// index means closer to the viewer. Unknown windows join at the top.
pub fn UIContext::window_z(self : UIContext, id : Id) -> Int {
  let mut rank = -1
  for i = 0; i < self.window_focus.length(); i = i + 1 {
    if self.window_focus[i] == id {
      rank = i
    }
  }
  if rank < 0 {
    self.window_focus.push(id)
    rank = self.window_focus.length() - 1
  }
  rank
}

///|
/// Move a window to the top of the stacking order. Called when the pointer
/// presses anywhere inside the window.
pub fn UIContext::raise_window(self : UIContext, id : Id) -> Unit {
  let kept : Array[Id] = []
  for other in self.window_focus {
    if other != id {
      kept.push(other)
    }
  }
  self.window_focus.clear()
  for other in kept {
    self.window_focus.push(other)
  }
  self.window_focus.push(id)
}

///|
/// The draw batch of a window, created on first use and reused afterwards.
fn UIContext::window_batch(self : UIContext, id : Id) -> @draw.DrawList {
  for batch in self.window_batches {
    if batch.0 == id {
      return batch.1
    }
  }
  let list = @draw.DrawList::new()
  self.window_batches.push((id, list))
  list
}

///|
/// Declare `rect` as a foreground blocking region: while it is registered,
/// pointer hover inside it is suppressed for every widget drawn on the main
/// layer. Popups call this so the widgets underneath stop responding.
/// The region takes effect from the next frame.
pub fn UIContext::block_hover(self : UIContext, rect : @math.Rect) -> Unit {
  self.blocking_rects.push(rect)
}

///|
/// Redirect subsequent draw commands to the foreground layer, which is
/// composited on top of the main layer at `end_frame`. The scissor clip stack
/// is suspended for the duration so a popup is never clipped away by the
/// container that spawned it.
pub fn UIContext::begin_foreground(self : UIContext) -> Unit {
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
/// Leave the foreground layer and restore the draw target and scissor clip
/// stack that were active before the matching `begin_foreground`.
pub fn UIContext::end_foreground(self : UIContext) -> Unit {
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
fn ascii_char_ratio(code : Int) -> Double {
  match code {
    32 => 0.24 // space
    33 | 39 | 44 | 46 | 58 | 59 | 105 | 108 | 124 => 0.28 // ! ' , . : ; i l |
    106 | 114 | 116 | 102 | 73 => 0.38 // j r t f I
    40 | 41 | 91 | 93 | 123 | 125 | 49 | 45 | 96 => 0.40 // ( ) [ ] { } 1 - `
    47 | 92 | 42 | 122 => 0.48 // / \ * z
    115 | 118 | 120 | 121 | 63 => 0.53 // s v x y ?
    107 | 117 | 97 | 101 => 0.58 // k u a e
    98 | 99 | 100 | 103 | 104 | 110 | 111 | 112 | 113 => 0.64 // b c d g h n o p q
    48 | 50 | 51 | 52 | 53 | 54 | 55 | 56 | 57 => 0.60 // 0-9
    43 | 60 | 61 | 62 | 94 | 95 | 126 => 0.62 // + < = > ^ _ ~
    69 | 70 | 76 | 84 | 90 => 0.58 // E F L T Z
    65 | 66 | 75 | 80 | 82 | 83 | 86 | 88 | 89 => 0.66 // A B K P R S V X Y
    67 | 68 | 71 | 72 | 78 | 85 => 0.74 // C D G H N U
    79 | 81 => 0.82 // O Q
    77 | 87 | 119 => 0.88 // M W w
    109 => 0.92 // m
    64 | 37 => 0.94 // @ %
    35 | 36 | 38 => 0.78 // # $ &
    _ => 0.58
  }
}

///|
pub fn measure_text_size(text : String, font_size : Double) -> @math.Vec2 {
  let mut total_w = 0.0
  let cjk_w = font_size * 1.05
  for i = 0; i < text.length(); i = i + 1 {
    let ch = text[i]
    let code = ch.to_int()
    if code > 255 {
      total_w = total_w + cjk_w
    } else {
      total_w = total_w + ascii_char_ratio(code) * font_size
    }
  }
  let h = font_size * 1.25
  @math.Vec2::new(total_w, h)
}

///|
pub fn UIContext::measure_text(
  self : UIContext,
  text : String,
  font_size : Double,
) -> @math.Vec2 {
  let _ = self
  measure_text_size(text, font_size)
}

///|
/// Position of a window, falling back to `fallback` until the window has been
/// moved for the first time. Windows are dragged by their title bar, so the
/// position is owned by the context rather than passed in by the caller.
pub fn UIContext::get_window_pos(
  self : UIContext,
  id : Id,
  fallback : @math.Vec2,
) -> @math.Vec2 {
  for item in self.window_positions {
    if item.0 == id {
      return item.1
    }
  }
  fallback
}

///|
pub fn UIContext::set_window_pos(
  self : UIContext,
  id : Id,
  pos : @math.Vec2,
) -> Unit {
  for i = 0; i < self.window_positions.length(); i = i + 1 {
    if self.window_positions[i].0 == id {
      self.window_positions[i] = (id, pos)
      return
    }
  }
  self.window_positions.push((id, pos))
}

///|
pub fn UIContext::get_scroll_offset(self : UIContext, id : Id) -> Double {
  for item in self.scroll_offsets {
    if item.0 == id {
      return item.1
    }
  }
  0.0
}

///|
pub fn UIContext::set_scroll_offset(
  self : UIContext,
  id : Id,
  offset : Double,
) -> Unit {
  for i = 0; i < self.scroll_offsets.length(); i = i + 1 {
    if self.scroll_offsets[i].0 == id {
      self.scroll_offsets[i] = (id, offset)
      return
    }
  }
  self.scroll_offsets.push((id, offset))
}

///|
pub fn UIContext::get_scroll_content_height(
  self : UIContext,
  id : Id,
) -> Double {
  for item in self.scroll_content_heights {
    if item.0 == id {
      return item.1
    }
  }
  0.0
}

///|
pub fn UIContext::set_scroll_content_height(
  self : UIContext,
  id : Id,
  height : Double,
) -> Unit {
  for i = 0; i < self.scroll_content_heights.length(); i = i + 1 {
    if self.scroll_content_heights[i].0 == id {
      self.scroll_content_heights[i] = (id, height)
      return
    }
  }
  self.scroll_content_heights.push((id, height))
}

///|
pub fn UIContext::get_text_cursor_pos(
  self : UIContext,
  id : Id,
  max_len : Int,
) -> Int {
  for item in self.text_cursor_positions {
    if item.0 == id {
      let p = item.1
      if p > max_len {
        return max_len
      }
      return if p < 0 { 0 } else { p }
    }
  }
  max_len
}

///|
pub fn UIContext::set_text_cursor_pos(
  self : UIContext,
  id : Id,
  pos : Int,
) -> Unit {
  for i = 0; i < self.text_cursor_positions.length(); i = i + 1 {
    if self.text_cursor_positions[i].0 == id {
      self.text_cursor_positions[i] = (id, pos)
      return
    }
  }
  self.text_cursor_positions.push((id, pos))
}

///|
pub fn UIContext::is_collapsing_open(
  self : UIContext,
  id : Id,
  default_open : Bool,
) -> Bool {
  for item in self.open_collapsing_ids {
    if item.0 == id {
      return item.1
    }
  }
  default_open
}

///|
pub fn UIContext::set_collapsing_open(
  self : UIContext,
  id : Id,
  is_open : Bool,
) -> Unit {
  for i = 0; i < self.open_collapsing_ids.length(); i = i + 1 {
    if self.open_collapsing_ids[i].0 == id {
      self.open_collapsing_ids[i] = (id, is_open)
      return
    }
  }
  self.open_collapsing_ids.push((id, is_open))
}

///|
pub fn UIContext::open_combo_id(self : UIContext) -> Id {
  self.open_combo_id
}

///|
pub fn UIContext::set_open_combo_id(self : UIContext, id : Id) -> Unit {
  self.open_combo_id = id
}

///|
pub fn UIContext::open_menu_id(self : UIContext) -> Id {
  self.open_menu_id
}

///|
pub fn UIContext::set_open_menu_id(self : UIContext, id : Id) -> Unit {
  self.open_menu_id = id
}
