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
/// One key press crossing the host boundary (used by the keyboard tests).
fn kb_key_input(k : @core.Key) -> @core.RawInput {
  @core.RawInput::with_events(
    @math.Vec2::zero(),
    false,
    @math.Vec2::zero(),
    [@core.Event::Key(k, true, @core.Modifiers::none())],
    "",
    @core.Modifiers::none(),
  )
}

///|
test "splitter: keyboard arrows resize the focused divider" {
  let ctx = @core.UIContext::new()
  let size = @math.Vec2::new(400.0, 200.0)

  // Frame 1: Tab focuses the only focusable - the divider
  ctx.begin_frame(kb_key_input(@core.Key::Tab))
  let r1 = split_horizontal(ctx, "kb_split", 0.5, size, fn(_ui, _rect) {  }, fn(
    _ui,
    _rect,
  ) {

  })
  let _ = ctx.end_frame()
  assert_eq(r1, 0.5)

  // Frame 2: ArrowRight nudges the ratio up, ArrowLeft brings it back
  ctx.begin_frame(kb_key_input(@core.Key::ArrowRight))
  let r2 = split_horizontal(ctx, "kb_split", r1, size, fn(_ui, _rect) {  }, fn(
    _ui,
    _rect,
  ) {

  })
  let _ = ctx.end_frame()
  assert_eq(r2, 0.52)

  ctx.begin_frame(kb_key_input(@core.Key::ArrowLeft))
  let r3 = split_horizontal(ctx, "kb_split", r2, size, fn(_ui, _rect) {  }, fn(
    _ui,
    _rect,
  ) {

  })
  let _ = ctx.end_frame()
  assert_eq(r3, 0.5)
}

///|
test "splitter: vertical keyboard resize follows the same contract" {
  let ctx = @core.UIContext::new()
  let size = @math.Vec2::new(300.0, 300.0)

  ctx.begin_frame(kb_key_input(@core.Key::Tab))
  let r1 = split_vertical(ctx, "kb_vsplit", 0.4, size, fn(_ui, _rect) {  }, fn(
    _ui,
    _rect,
  ) {

  })
  let _ = ctx.end_frame()
  assert_eq(r1, 0.4)

  ctx.begin_frame(kb_key_input(@core.Key::ArrowDown))
  let r2 = split_vertical(ctx, "kb_vsplit", r1, size, fn(_ui, _rect) {  }, fn(
    _ui,
    _rect,
  ) {

  })
  let _ = ctx.end_frame()
  assert_true((r2 - 0.42).abs() < 0.0001)
}

///|
test "scroll_area: keyboard scrolling while the viewport holds focus" {
  let ctx = @core.UIContext::new()
  let size = @math.Vec2::new(200.0, 60.0)

  // Frame 1: render scrollable content and Tab-focus the viewport
  ctx.begin_frame(kb_key_input(@core.Key::Tab))
  scroll_area(ctx, "kb_scroll", size, fn(s) {
    for i = 0; i < 8; i = i + 1 {
      let _ = s.label("Item " + i.to_string())
    }
  })
  let _ = ctx.end_frame()

  // Frame 2: ArrowDown scrolls the viewport by the keyboard step
  ctx.begin_frame(kb_key_input(@core.Key::ArrowDown))
  scroll_area(ctx, "kb_scroll", size, fn(s) {
    for i = 0; i < 8; i = i + 1 {
      let _ = s.label("Item " + i.to_string())
    }
  })
  let _ = ctx.end_frame()
  let scrolled = ctx.get_scroll_offset(ctx.id_stack.derive_id("kb_scroll"))
  assert_true(scrolled > 0.0)

  // Home jumps back to the top
  ctx.begin_frame(kb_key_input(@core.Key::Home))
  scroll_area(ctx, "kb_scroll", size, fn(s) {
    for i = 0; i < 8; i = i + 1 {
      let _ = s.label("Item " + i.to_string())
    }
  })
  let _ = ctx.end_frame()
  assert_eq(ctx.get_scroll_offset(ctx.id_stack.derive_id("kb_scroll")), 0.0)
}

///|
test "scroll_area: focused viewport does not steal keys without scrollable content" {
  let ctx = @core.UIContext::new()

  // Content fits the viewport: nothing to scroll, so ArrowDown is left for
  // whatever actually holds focus.
  ctx.begin_frame(kb_key_input(@core.Key::Tab))
  scroll_area(ctx, "kb_noscroll", @math.Vec2::new(200.0, 60.0), fn(s) {
    let _ = s.label("Short")
  })
  let _ = ctx.end_frame()

  ctx.begin_frame(kb_key_input(@core.Key::ArrowDown))
  scroll_area(ctx, "kb_noscroll", @math.Vec2::new(200.0, 60.0), fn(s) {
    let _ = s.label("Short")
  })
  let _ = ctx.end_frame()
  assert_eq(ctx.get_scroll_offset(ctx.id_stack.derive_id("kb_noscroll")), 0.0)
}

///|
test "tag: keyboard Space and Enter close the focused closable tag" {
  let ctx = @core.UIContext::new()

  ctx.begin_frame(kb_key_input(@core.Key::Tab))
  let (c1, _) = tag(ctx, "kb_tag", "dismiss me", closable=true)
  let _ = ctx.end_frame()
  assert_false(c1)

  ctx.begin_frame(kb_key_input(@core.Key::Enter))
  let (c2, _) = tag(ctx, "kb_tag", "dismiss me", closable=true)
  let _ = ctx.end_frame()
  assert_true(c2)
}

///|
test "breadcrumb: arrows walk the ancestors and Enter follows them" {
  let ctx = @core.UIContext::new()
  let items = ["Home", "Library", "Reports"]

  // Frame 1: Tab focuses the trail; ArrowRight highlights the first ancestor
  ctx.begin_frame(kb_key_input(@core.Key::Tab))
  let (c1, _) = breadcrumb(ctx, "kb_crumbs", items)
  let _ = ctx.end_frame()
  assert_eq(c1, None)

  ctx.begin_frame(kb_key_input(@core.Key::ArrowRight))
  let (c2, _) = breadcrumb(ctx, "kb_crumbs", items)
  let _ = ctx.end_frame()
  assert_eq(c2, None)

  // Frame 3: Enter follows the highlighted ancestor ("Library")
  ctx.begin_frame(kb_key_input(@core.Key::Enter))
  let (c3, _) = breadcrumb(ctx, "kb_crumbs", items)
  let _ = ctx.end_frame()
  assert_eq(c3, Some(1))
}

///|
test "window: keyboard arrows move the focused window" {
  let ctx = @core.UIContext::new()
  let pos = @math.Vec2::new(50.0, 50.0)
  let size = @math.Vec2::new(200.0, 150.0)
  let win_id = ctx.id_stack.derive_id("window::KBWin")

  // Frame 1: Tab focuses the window
  ctx.begin_frame(kb_key_input(@core.Key::Tab))
  let _ = window(ctx, "KBWin", pos, size, fn(w) { let _ = w.label("body") })
  let _ = ctx.end_frame()

  // Frame 2: ArrowRight moves the window 8px right
  ctx.begin_frame(kb_key_input(@core.Key::ArrowRight))
  let _ = window(ctx, "KBWin", pos, size, fn(w) { let _ = w.label("body") })
  let _ = ctx.end_frame()
  let moved = ctx.get_window_pos(win_id, pos)
  assert_eq(moved.x, 58.0)
  assert_eq(moved.y, 50.0)
}

///|
test "collapsing_header: builder default_open and Space toggling" {
  let ctx = @core.UIContext::new()
  let mut content_ran = 0
  let render = fn() {
    CollapsingHeader::new("fluent_coll", "Section")
    .default_open(true)
    .show(ctx, fn(panel) {
      content_ran = content_ran + 1
      let _ = panel.label("inner")
    })
  }

  // default_open(true) runs the content on the very first frame
  ctx.begin_frame(@core.RawInput::new())
  let _ = render()
  let _ = ctx.end_frame()
  assert_eq(content_ran, 1)

  // Tab focuses the header; Space toggles it closed
  ctx.begin_frame(kb_key_input(@core.Key::Tab))
  let _ = render()
  let _ = ctx.end_frame()

  ctx.begin_frame(kb_key_input(@core.Key::Space))
  let _ = render()
  let _ = ctx.end_frame()

  // Re-open with Space; the content runs again
  ctx.begin_frame(kb_key_input(@core.Key::Space))
  let _ = render()
  let _ = ctx.end_frame()
  assert_true(content_ran >= 3)
}

///|
test "combo_box: builder label, Escape close and ArrowUp clamp" {
  let ctx = @core.UIContext::new()
  let options = ["One", "Two", "Three"]
  let mut sel = 0
  let render = fn() {
    let (s, _) = ComboBox::new("fluent_combo_b", sel, options)
      .label("Choice")
      .show(ctx)
    sel = s
    s
  }

  ctx.begin_frame(kb_key_input(@core.Key::Tab))
  let _ = render()
  let _ = ctx.end_frame()

  // Enter opens, ArrowDown walks to index 1
  ctx.begin_frame(kb_key_input(@core.Key::Enter))
  let _ = render()
  let _ = ctx.end_frame()
  ctx.begin_frame(kb_key_input(@core.Key::ArrowDown))
  assert_eq(render(), 1)

  // ArrowUp walks back to index 0 and clamps there
  ctx.begin_frame(kb_key_input(@core.Key::ArrowUp))
  assert_eq(render(), 0)
  ctx.begin_frame(kb_key_input(@core.Key::ArrowUp))
  assert_eq(render(), 0)

  // Escape closes the list without changing the selection
  ctx.begin_frame(kb_key_input(@core.Key::Escape))
  assert_eq(render(), 0)
}

///|
test "combo_box: an empty label renders the box alone" {
  let ctx = @core.UIContext::new()
  ctx.begin_frame(@core.RawInput::new())
  let (sel, resp) = ComboBox::new("fluent_combo_empty", 1, ["X", "Y"]).show(ctx)
  let _ = ctx.end_frame()
  assert_eq(sel, 1)
  assert_true(resp.rect.w > 0.0)
}
