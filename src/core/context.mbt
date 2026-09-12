///|
pub enum LayoutDirection {
  TopDown
  LeftToRight
  LeftToRightWrapped
} derive(Eq, Debug)

///|
pub struct LayoutScope {
  dir : LayoutDirection
  start_x : Double
  start_y : Double
  mut max_cross_size : Double
  mut current_row_h : Double
  wrap_width : Double
} derive(Eq, Debug)

///|

///|
pub struct UIContext {
  input : InputState
  mut draw_list : @draw.DrawList
  id_stack : IdStack
  layout : LayoutEngine
  focus : FocusManager
  layers : LayerManager
  windows : WindowManager
  memory : Memory
  mut style : WidgetStyle
  mut theme : Theme
  mut cursor_icon : String
  mut time : Double
  mut frame_counter : Int
  mut last_caret_activity : Double
  text_measure_cache : @hashmap.HashMap[String, Double]
  mut open_combo_id : Id
  mut open_menu_id : Id
  mut active_submenu_id : String
} derive(Eq, Debug)

///|
pub fn UIContext::new() -> UIContext {
  let layers = LayerManager::new()
  {
    input: InputState::new(),
    draw_list: layers.draw_list(),
    id_stack: IdStack::new(),
    layout: LayoutEngine::new(),
    focus: FocusManager::new(),
    layers,
    windows: WindowManager::new(),
    memory: Memory::new(),
    style: WidgetStyle::default(),
    theme: Theme::studio_light(),
    cursor_icon: "default",
    time: 0.0,
    frame_counter: 0,
    last_caret_activity: 0.0,
    text_measure_cache: @hashmap.HashMap([], capacity=256),
    open_combo_id: Id::zero(),
    open_menu_id: Id::zero(),
    active_submenu_id: "",
  }
}

///|
pub fn UIContext::begin_frame(self : UIContext, raw_input : RawInput) -> Unit {
  self.cursor_icon = "default"
  self.frame_counter = self.frame_counter + 1
  self.input.update(raw_input)
  self.time = self.time + self.input.dt
  self.layers.begin_frame()
  self.draw_list = self.layers.draw_list()
  self.windows.begin_frame()
  self.layout.begin_frame(0.0)
  self.focus.begin_frame()
}

///|
pub fn UIContext::end_frame(self : UIContext) -> @draw.DrawList {
  // Process Tab key focus traversal (skip if consumed by an active widget like CodeEditor)
  if self.input.key_pressed(Key::Tab) && !self.input.is_key_consumed(Key::Tab) {
    if self.focus.process_tab_traversal(self.input.modifiers.shift) {
      self.reset_caret_blink()
    }
  }

  self.focus.end_frame()

  // Composite the deferred layers: floating windows bottom-up, then the
  // foreground layer (popups, tooltips) above everything.
  self.windows.flush_to(self.layers.draw_list())
  self.layers.draw_list().append(self.layers.fg_draw_list())

  // Periodic generational cleanup every 300 frames (~5 seconds at 60 FPS)
  if self.frame_counter % 300 == 0 {
    self.prune_stale_state(600)
  }

  self.layers.draw_list()
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
pub fn UIContext::layout(self : UIContext) -> LayoutEngine {
  self.layout
}

///|
pub fn UIContext::focus(self : UIContext) -> FocusManager {
  self.focus
}

///|
pub fn UIContext::layers(self : UIContext) -> LayerManager {
  self.layers
}

///|
pub fn UIContext::windows(self : UIContext) -> WindowManager {
  self.windows
}

///|
pub fn UIContext::cursor(self : UIContext) -> @math.Vec2 {
  self.layout.cursor()
}

///|
pub fn UIContext::set_cursor(self : UIContext, pos : @math.Vec2) -> Unit {
  self.layout.set_cursor(pos)
}

///|
pub fn UIContext::advance_cursor(self : UIContext, offset : @math.Vec2) -> Unit {
  self.layout.set_cursor(self.layout.cursor().add(offset))
}

///|
pub fn UIContext::item_spacing(self : UIContext) -> @math.Vec2 {
  self.layout.item_spacing()
}

///|
pub fn UIContext::set_item_spacing(
  self : UIContext,
  spacing : @math.Vec2,
) -> Unit {
  self.layout.set_item_spacing(spacing)
}

///|
pub fn UIContext::style(self : UIContext) -> WidgetStyle {
  self.style
}

///|
pub fn UIContext::set_style(self : UIContext, style : WidgetStyle) -> Unit {
  self.style = style
  self.layout.set_item_spacing(style.item_spacing)
}

///|
pub fn UIContext::cursor_icon(self : UIContext) -> String {
  self.cursor_icon
}

///|
pub fn UIContext::set_cursor_icon(self : UIContext, icon : String) -> Unit {
  self.cursor_icon = icon
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
  self.focus.hot_id()
}

///|
pub fn UIContext::set_hot_id(self : UIContext, id : Id) -> Unit {
  self.focus.set_hot_id(id)
}

///|
pub fn UIContext::active_id(self : UIContext) -> Id {
  self.focus.active_id()
}

///|
pub fn UIContext::set_active_id(self : UIContext, id : Id) -> Unit {
  self.focus.set_active_id(id)
}

///|
pub fn UIContext::focused_id(self : UIContext) -> Id {
  self.focus.focused_id()
}

///|
pub fn UIContext::set_focused_id(self : UIContext, id : Id) -> Unit {
  self.focus.set_focused_id(id)
}

///|
pub fn UIContext::prev_focused_id(self : UIContext) -> Id {
  self.focus.prev_focused_id()
}

///|
pub fn UIContext::focusable_ids(self : UIContext) -> Array[Id] {
  self.focus.focusable_ids()
}

///|
pub fn UIContext::available_width(self : UIContext) -> Double {
  self.layout.available_width()
}

///|
pub fn UIContext::set_available_width(self : UIContext, width : Double) -> Unit {
  self.layout.set_available_width(width)
}

///|
pub fn UIContext::next_auto_id(self : UIContext) -> Id {
  self.id_stack.derive_int(self.layout.next_auto_id_counter())
}

///|
/// Core space allocator and hit-testing primitive.
/// All existing and custom third-party widgets evaluate interaction through this method.
pub fn UIContext::allocate_space(
  self : UIContext,
  size : @math.Vec2,
) -> (Id, @math.Rect, Response) {
  let id = self.next_auto_id()
  let rect = self.layout.allocate_rect(size)

  // Hit-testing evaluation
  let hovered = self.is_hovered(rect)
  if hovered {
    self.focus.set_hot_id(id)
    self.focus.set_wants_capture_mouse(true)
  }

  // Pointer interaction state machine
  if hovered && self.input.mouse_pressed {
    self.focus.set_active_id(id)
  }

  let is_active = self.focus.active_id() == id
  if is_active {
    self.focus.set_wants_capture_mouse(true)
  }
  let pressed = is_active && self.input.mouse_down
  let mouse_clicked = is_active && self.input.mouse_released && hovered
  let dragged = is_active &&
    self.input.mouse_down &&
    self.input.mouse_delta.length_sq() > 0.0

  if self.input.mouse_released && is_active {
    self.focus.set_active_id(Id::zero())
  }

  let is_focused = self.focus.focused_id() == id
  let gained_focus = is_focused && self.focus.prev_focused_id() != id
  let lost_focus = self.focus.lost_focus(id)

  // Keyboard activation (Space or Enter on focused control)
  let key_activated = is_focused &&
    !self.input.is_key_consumed(Key::Space) &&
    !self.input.is_key_consumed(Key::Enter) &&
    (self.input.key_pressed(Key::Space) || self.input.key_pressed(Key::Enter))
  if key_activated {
    self.input.consume_key(Key::Space)
    self.input.consume_key(Key::Enter)
  }

  let clicked = mouse_clicked || key_activated
  let secondary_clicked = hovered && self.input.mouse_secondary_pressed

  if clicked {
    self.request_focus(id)
  }

  let response = Response::with_focus(
    id,
    rect,
    hovered,
    clicked,
    pressed,
    dragged,
    is_focused,
    gained_focus,
    lost_focus,
    secondary_clicked~,
  )
  (id, rect, response)
}

///|
/// Returns true if the pointer is currently hovering over or interacting with any UI widget or window.
pub fn UIContext::wants_capture_mouse(self : UIContext) -> Bool {
  self.focus.prev_wants_capture_mouse() || self.focus.wants_capture_mouse()
}

///|
/// Explicitly declare that the UI context is capturing pointer input this frame.
pub fn UIContext::set_wants_capture_mouse(
  self : UIContext,
  capture : Bool,
) -> Unit {
  self.focus.set_wants_capture_mouse(capture)
}

///|
/// Scoped horizontal layout flow (Left-to-Right).
/// Arranges child widgets side-by-side, tracks the maximum row height,
/// and returns the cursor to the start X position advanced downwards by row height.
pub fn UIContext::horizontal(
  self : UIContext,
  content : (UIContext) -> Unit,
) -> Unit {
  let start_x = self.layout.cursor().x
  let start_y = self.layout.cursor().y
  let scope : LayoutScope = {
    dir: LeftToRight,
    start_x,
    start_y,
    max_cross_size: 0.0,
    current_row_h: 0.0,
    wrap_width: 0.0,
  }
  self.layout.push_scope(scope)
  content(self)
  let popped = self.layout.pop_scope()
  let max_h = match popped {
    Some(s) => s.max_cross_size
    None => 0.0
  }
  self.layout.set_cursor(
    @math.Vec2::new(start_x, start_y + max_h + self.layout.item_spacing().y),
  )
}

///|
/// Scoped horizontal layout with automatic line wrapping.
/// Arranges child widgets horizontally, wrapping to the next line when
/// the row exceeds `wrap_width` (defaults to `available_width`).
pub fn UIContext::horizontal_wrapped(
  self : UIContext,
  content : (UIContext) -> Unit,
  wrap_width? : Double,
) -> Unit {
  let start_x = self.layout.cursor().x
  let start_y = self.layout.cursor().y
  let w = match wrap_width {
    Some(val) => val
    None => self.layout.available_width()
  }
  let scope : LayoutScope = {
    dir: LeftToRightWrapped,
    start_x,
    start_y,
    max_cross_size: 0.0,
    current_row_h: 0.0,
    wrap_width: w,
  }
  self.layout.push_scope(scope)
  content(self)
  let popped = self.layout.pop_scope()
  let (total_cross, last_row_h) = match popped {
    Some(s) => (s.max_cross_size, s.current_row_h)
    None => (0.0, 0.0)
  }
  let total_h = total_cross + last_row_h
  self.layout.set_cursor(
    @math.Vec2::new(start_x, start_y + total_h + self.layout.item_spacing().y),
  )
}

///|
/// Scoped vertical layout flow (TopDown).
pub fn UIContext::vertical(
  self : UIContext,
  content : (UIContext) -> Unit,
) -> Unit {
  let start_x = self.layout.cursor().x
  let start_y = self.layout.cursor().y
  let scope : LayoutScope = {
    dir: TopDown,
    start_x,
    start_y,
    max_cross_size: 0.0,
    current_row_h: 0.0,
    wrap_width: 0.0,
  }
  self.layout.push_scope(scope)
  content(self)
  let _ = self.layout.pop_scope()
}

///|
pub fn UIContext::request_focus(self : UIContext, id : Id) -> Unit {
  if self.focus.request_focus(id) {
    self.reset_caret_blink()
  }
}

///|
pub fn UIContext::surrender_focus(self : UIContext, id : Id) -> Unit {
  self.focus.surrender_focus(id)
}

///|
pub fn UIContext::has_focus(self : UIContext, id : Id) -> Bool {
  self.focus.has_focus(id)
}

///|
pub fn UIContext::lost_focus(self : UIContext, id : Id) -> Bool {
  self.focus.lost_focus(id)
}

///|
pub fn UIContext::register_focusable(self : UIContext, id : Id) -> Unit {
  self.focus.register_focusable(id)
}

///|
pub fn UIContext::clear_focusable(self : UIContext) -> Unit {
  self.focus.clear_focusable()
}

///|
pub fn UIContext::push_clip(self : UIContext, rect : @math.Rect) -> Unit {
  self.layers.push_clip(rect)
  self.draw_list = self.layers.draw_list()
}

///|
pub fn UIContext::pop_clip(self : UIContext) -> Unit {
  self.layers.pop_clip()
  self.draw_list = self.layers.draw_list()
}

///|
pub fn UIContext::current_clip(self : UIContext) -> @math.Rect? {
  self.layers.current_clip()
}

///|
/// Clip-aware hover test. The pointer hovers `rect` only when it is inside the
/// rect, inside the active scissor clip, and neither covered by a foreground
/// blocking region nor by a window stacked above the current draw target.
/// Widgets that scroll out of a container or spill outside a window therefore
/// stop responding to the pointer.
pub fn UIContext::is_hovered(self : UIContext, rect : @math.Rect) -> Bool {
  let visible = match self.layers.current_clip() {
    Some(clip) => rect.intersect(clip)
    None => rect
  }
  let in_visible_rect = visible.w > 0.0 &&
    visible.h > 0.0 &&
    visible.contains(self.input.mouse_pos)
  in_visible_rect &&
  (
    self.layers.is_foreground() ||
    (
      !self.layers.is_blocked_by_foreground(self.input.mouse_pos) &&
      !self.windows.is_occluded(self.input.mouse_pos)
    )
  )
}

///|
pub fn UIContext::window_z(self : UIContext, id : Id) -> Int {
  self.windows.window_z(id)
}

///|
pub fn UIContext::raise_window(self : UIContext, id : Id) -> Unit {
  self.windows.raise_window(id)
}

///|
fn UIContext::window_batch(self : UIContext, id : Id) -> @draw.DrawList {
  self.windows.batch(id)
}

///|
pub fn UIContext::block_hover(self : UIContext, rect : @math.Rect) -> Unit {
  self.layers.block_hover(rect)
}

///|
pub fn UIContext::begin_foreground(self : UIContext) -> Unit {
  self.layers.begin_foreground()
  self.draw_list = self.layers.draw_list()
}

///|
pub fn UIContext::end_foreground(self : UIContext) -> Unit {
  self.layers.end_foreground()
  self.draw_list = self.layers.draw_list()
}

///|
fn ascii_char_ratio(code : Int) -> Double {
  match code {
    32 => 0.26 // space
    33 | 39 | 44 | 46 | 58 | 59 | 105 | 108 | 124 => 0.28 // ! ' , . : ; i l |
    34 => 0.36 // "
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
fn char_width_ratio(code : Int) -> Double {
  if code <= 127 {
    ascii_char_ratio(code)
  } else if code <= 0x024F {
    // Latin-1 Supplement and Latin Extended-A/B (e.g. é, à, ü, ø, ñ, ç, ß)
    match code {
      160 => 0.26 // non-breaking space
      161 => 0.28 // ¡
      171 | 187 => 0.48 // « »
      191 => 0.53 // ¿
      223 => 0.64 // ß
      _ => if code >= 192 && code <= 222 { 0.68 } else { 0.58 }
    }
  } else if code >= 0x0370 && code <= 0x04FF {
    // Greek and Cyrillic
    0.62
  } else if code >= 0x2000 && code <= 0x206F {
    // General Punctuation
    match code {
      0x2000 | 0x2001 | 0x2002 | 0x2003 => 0.50
      0x2004 | 0x2005 | 0x2006 | 0x2007 | 0x2008 | 0x2009 | 0x200A => 0.26
      0x2013 => 0.55 // en-dash
      0x2014 => 0.85 // em-dash
      0x2018 | 0x2019 | 0x201A => 0.28 // single quotes
      0x201C | 0x201D | 0x201E => 0.45 // double quotes
      0x2026 => 0.75 // ellipsis …
      _ => 0.50
    }
  } else if code >= 0x2200 && code <= 0x22FF {
    // Mathematical Operators
    0.68
  } else if code >= 0xFF61 && code <= 0xFF9F {
    // Halfwidth CJK Katakana
    0.50
  } else if (code >= 0x4E00 && code <= 0x9FFF) ||
    (code >= 0x3400 && code <= 0x4DBF) ||
    (code >= 0xF900 && code <= 0xFAFF) ||
    (code >= 0x3000 && code <= 0x303F) ||
    (code >= 0x3040 && code <= 0x309F) ||
    (code >= 0x30A0 && code <= 0x30FF) ||
    (code >= 0xAC00 && code <= 0xD7AF) ||
    (code >= 0xFF01 && code <= 0xFF60) ||
    (code >= 0xFFE0 && code <= 0xFFEE) {
    // Fullwidth CJK ideographs, kana, punctuation, and fullwidth forms
    1.05
  } else {
    0.65
  }
}

///|
pub fn measure_text_size(text : String, font_size : Double) -> @math.Vec2 {
  let mut total_w = 0.0
  let mut i = 0
  let len = text.length()
  while i < len {
    let ch = text[i]
    let code = ch.to_int()
    if is_leading_surrogate(code) &&
      i + 1 < len &&
      is_trailing_surrogate(text[i + 1].to_int()) {
      // 4-byte UTF-16 surrogate pair (e.g. Emoji / Supplementary CJK)
      total_w = total_w + font_size * 1.05
      i = i + 2
    } else {
      total_w = total_w + char_width_ratio(code) * font_size
      i = i + 1
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
  if text.is_empty() {
    return @math.Vec2::new(0.0, font_size * 1.25)
  }
  let key = text + "@" + font_size.to_int().to_string()
  let w = match self.text_measure_cache.get(key) {
    Some(cached) => cached
    None => {
      let measured = measure_text_size(text, font_size).x
      if self.text_measure_cache.length() > 2048 {
        self.text_measure_cache.clear()
      }
      self.text_measure_cache.set(key, measured)
      measured
    }
  }
  let h = font_size * 1.25
  @math.Vec2::new(w, h)
}

///|
pub fn UIContext::set_cached_text_width(
  self : UIContext,
  text : String,
  font_size : Double,
  width : Double,
) -> Unit {
  let key = text + "@" + font_size.to_int().to_string()
  if self.text_measure_cache.length() > 2048 {
    self.text_measure_cache.clear()
  }
  self.text_measure_cache.set(key, width)
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
  self.memory.touch(id, self.frame_counter)
  self.windows.get_pos(id, fallback)
}

///|
pub fn UIContext::set_window_pos(
  self : UIContext,
  id : Id,
  pos : @math.Vec2,
) -> Unit {
  self.memory.touch(id, self.frame_counter)
  self.windows.set_pos(id, pos)
}

///|
pub fn UIContext::get_scroll_offset(self : UIContext, id : Id) -> Double {
  self.memory.touch(id, self.frame_counter)
  self.memory.get_double_or_default(id, 0.0)
}

///|
pub fn UIContext::set_scroll_offset(
  self : UIContext,
  id : Id,
  offset : Double,
) -> Unit {
  self.memory.set_double(id, offset, frame=self.frame_counter)
}

///|
pub fn UIContext::get_scroll_content_height(
  self : UIContext,
  id : Id,
) -> Double {
  self.memory.touch(id, self.frame_counter)
  self.memory.get_double_or_default(id, 0.0, tag="content_h")
}

///|
pub fn UIContext::set_scroll_content_height(
  self : UIContext,
  id : Id,
  height : Double,
) -> Unit {
  self.memory.set_double(id, height, tag="content_h", frame=self.frame_counter)
}

///|
pub fn UIContext::get_text_cursor_pos(
  self : UIContext,
  id : Id,
  max_len : Int,
) -> Int {
  self.memory.touch(id, self.frame_counter)
  match self.memory.get_int(id, tag="cursor_pos") {
    Some(p) => if p > max_len { max_len } else if p < 0 { 0 } else { p }
    None => max_len
  }
}

///|
pub fn UIContext::set_text_cursor_pos(
  self : UIContext,
  id : Id,
  pos : Int,
) -> Unit {
  self.memory.set_int(id, pos, tag="cursor_pos", frame=self.frame_counter)
}

///|
pub fn UIContext::is_collapsing_open(
  self : UIContext,
  id : Id,
  default_open : Bool,
) -> Bool {
  self.memory.touch(id, self.frame_counter)
  self.memory.get_bool_or_default(id, default_open, tag="collapsing")
}

///|
pub fn UIContext::set_collapsing_open(
  self : UIContext,
  id : Id,
  is_open : Bool,
) -> Unit {
  self.memory.set_bool(id, is_open, tag="collapsing", frame=self.frame_counter)
}

///|
/// Prune persistent widget states that have not been active for more than `ttl_frames` frames.
pub fn UIContext::prune_stale_state(self : UIContext, ttl_frames : Int) -> Unit {
  self.memory.prune_stale(self.frame_counter, ttl_frames)
  self.windows.prune_stale()
}

///|
pub fn UIContext::active_submenu_id(self : UIContext) -> String {
  self.active_submenu_id
}

///|
pub fn UIContext::set_active_submenu_id(self : UIContext, id : String) -> Unit {
  self.active_submenu_id = id
}

///|
pub fn UIContext::get_text_selection_anchor(self : UIContext, id : Id) -> Int? {
  self.memory.touch(id, self.frame_counter)
  self.memory.get_int(id, tag="sel_anchor")
}

///|
pub fn UIContext::set_text_selection_anchor(
  self : UIContext,
  id : Id,
  anchor : Int?,
) -> Unit {
  match anchor {
    Some(a) =>
      self.memory.set_int(id, a, tag="sel_anchor", frame=self.frame_counter)
    None => self.memory.remove_sub_key(id, "sel_anchor")
  }
}

///|
pub fn UIContext::clear_text_selection(self : UIContext, id : Id) -> Unit {
  self.memory.remove_sub_key(id, "sel_anchor")
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

///|
pub fn UIContext::time(self : UIContext) -> Double {
  self.time
}

///|
pub fn UIContext::set_time(self : UIContext, t : Double) -> Unit {
  self.time = t
}

///|
pub fn UIContext::reset_caret_blink(self : UIContext) -> Unit {
  self.last_caret_activity = self.time
}

///|
pub fn UIContext::is_caret_visible(self : UIContext) -> Bool {
  let elapsed = self.time - self.last_caret_activity
  let interval = if self.style.caret_blink_interval > 0.0 {
    self.style.caret_blink_interval
  } else {
    0.53
  }
  if elapsed < interval {
    true
  } else {
    let half_cycles = ((elapsed - interval) / interval).to_int()
    half_cycles % 2 == 1
  }
}

///|
pub fn UIContext::theme(self : UIContext) -> Theme {
  self.theme
}

///|
pub fn UIContext::set_theme(self : UIContext, theme : Theme) -> Unit {
  self.theme = theme
}

///|
pub fn UIContext::memory(self : UIContext) -> Memory {
  self.memory
}

///|
/// Smooth immediate-mode boolean animation tweening over `duration` seconds.
/// Returns a scalar factor in `[0.0, 1.0]` that transitions smoothly when `target` changes.
pub fn UIContext::animate_bool(
  self : UIContext,
  id : Id,
  target : Bool,
  duration : Double,
) -> Double {
  let target_val = if target { 1.0 } else { 0.0 }
  let current = match self.memory.get_double(id, tag="anim") {
    Some(v) => v
    None => {
      self.memory.set_double(
        id,
        target_val,
        tag="anim",
        frame=self.frame_counter,
      )
      target_val
    }
  }
  if current == target_val || duration <= 0.0 {
    current
  } else {
    let dt = self.input.dt
    let step = dt / duration
    let next_val = if current < target_val {
      let v = current + step
      if v > target_val {
        target_val
      } else {
        v
      }
    } else {
      let v = current - step
      if v < target_val {
        target_val
      } else {
        v
      }
    }
    self.memory.set_double(id, next_val, tag="anim", frame=self.frame_counter)
    next_val
  }
}

///|
/// Smooth immediate-mode float animation tweening towards `target` over `duration` seconds.
pub fn UIContext::animate_float(
  self : UIContext,
  id : Id,
  target : Double,
  duration : Double,
) -> Double {
  let current = match self.memory.get_double(id, tag="anim") {
    Some(v) => v
    None => {
      self.memory.set_double(id, target, tag="anim", frame=self.frame_counter)
      target
    }
  }
  if current == target || duration <= 0.0 {
    current
  } else {
    let dt = self.input.dt
    let diff = target - current
    let abs_diff = if diff < 0.0 { -diff } else { diff }
    let step = abs_diff * (dt / duration)
    let min_step = 0.001
    let actual_step = if step < min_step { min_step } else { step }
    let next_val = if diff > 0.0 {
      let v = current + actual_step
      if v > target {
        target
      } else {
        v
      }
    } else {
      let v = current - actual_step
      if v < target {
        target
      } else {
        v
      }
    }
    self.memory.set_double(id, next_val, tag="anim", frame=self.frame_counter)
    next_val
  }
}
