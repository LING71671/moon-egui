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
test "dialog: every semantic kind renders and defaults to cancelled" {
  let ctx = @core.UIContext::new()
  let kinds = [
    DialogKind::info(),
    DialogKind::warning(),
    DialogKind::danger(),
    DialogKind::confirm(),
  ]
  for kind in kinds {
    ctx.begin_frame(
      @core.RawInput::from_mouse(@math.Vec2::new(-50.0, -50.0), false),
    )
    let result = Dialog::new("fluent_dialog", "Title", "Body")
      .kind(kind)
      .confirm_label("Go")
      .cancel_label("Stay")
      .width(360.0)
      .show(ctx)
    let dl = ctx.end_frame()
    assert_eq(result, DialogResult::Open)
    assert_true(dl.len() > 5)
  }

  // Escape cancels the open dialog
  ctx.begin_frame(kb_key_input(@core.Key::Escape))
  let cancelled = Dialog::new("fluent_dialog", "Title", "Body")
    .kind(DialogKind::info())
    .show(ctx)
  let _ = ctx.end_frame()
  assert_eq(cancelled, DialogResult::Cancelled)
}

///|
test "segmented_control: height and width builders plus keyboard wrap" {
  let ctx = @core.UIContext::new()
  let options = ["A", "B", "C"]
  let render = fn() {
    segmented_control(ctx, "fluent_seg", options, 2, height=28.0, width=180.0)
  }

  // Frame 1: Tab focuses the control
  ctx.begin_frame(kb_key_input(@core.Key::Tab))
  let (sel1, _) = render()
  let _ = ctx.end_frame()
  assert_eq(sel1, 2)

  // Frame 2: ArrowRight on the last option wraps back to the first
  ctx.begin_frame(kb_key_input(@core.Key::ArrowRight))
  let (sel2, _) = render()
  let _ = ctx.end_frame()
  assert_eq(sel2, 0)
}

///|
test "slider: keyboard arrows adjust the focused slider" {
  let ctx = @core.UIContext::new()
  // Frame 1: Tab focuses the slider. The slider is a controlled component:
  // the caller feeds the returned value back on the next frame.
  let mut value = 0.5
  ctx.begin_frame(kb_key_input(@core.Key::Tab))
  let (v1, _) = slider(ctx, "fluent_slider", value, 0.0, 1.0)
  let _ = ctx.end_frame()
  assert_eq(v1, 0.5)
  value = v1

  // Frame 2: ArrowRight steps the value up (range 1.0 -> step 0.05)
  ctx.begin_frame(kb_key_input(@core.Key::ArrowRight))
  let (v2, _) = slider(ctx, "fluent_slider", value, 0.0, 1.0)
  let _ = ctx.end_frame()
  assert_true((v2 - 0.55).abs() < 0.0001)
  value = v2

  // Frame 3: ArrowLeft steps it back down
  ctx.begin_frame(kb_key_input(@core.Key::ArrowLeft))
  let (v3, _) = slider(ctx, "fluent_slider", value, 0.0, 1.0)
  let _ = ctx.end_frame()
  assert_eq(v3, 0.5)
}

///|
test "combo_box: keyboard opens, walks and commits a selection" {
  let ctx = @core.UIContext::new()
  let options = ["WebGL", "Canvas", "WebGPU"]
  // The combo is a controlled component: the caller feeds the returned
  // selection back as selected_index on the next frame.
  let mut sel = 0
  let render2 = fn() { combo_box(ctx, "fluent_combo", "Backend", sel, options) }

  // Frame 1: Tab focuses the combo
  ctx.begin_frame(kb_key_input(@core.Key::Tab))
  let (s1, _) = render2()
  sel = s1
  let _ = ctx.end_frame()
  assert_eq(s1, 0)

  // Frame 2: Enter opens the option list
  ctx.begin_frame(kb_key_input(@core.Key::Enter))
  let (s2, _) = render2()
  sel = s2
  let _ = ctx.end_frame()
  assert_eq(s2, 0)

  // Frame 3: ArrowDown walks to the second option while the list is open
  ctx.begin_frame(kb_key_input(@core.Key::ArrowDown))
  let (s3, _) = render2()
  sel = s3
  let _ = ctx.end_frame()
  assert_eq(s3, 1)

  // Frame 4: Enter commits and closes
  ctx.begin_frame(kb_key_input(@core.Key::Enter))
  let (s4, _) = render2()
  sel = s4
  let _ = ctx.end_frame()
  assert_eq(s4, 1)
}

///|
test "scroll_area: page and arrow keys cover the full keyboard scroll set" {
  let ctx = @core.UIContext::new()
  let size = @math.Vec2::new(200.0, 60.0)
  let render = fn() {
    scroll_area(ctx, "fluent_scroll", size, fn(s) {
      for i = 0; i < 12; i = i + 1 {
        let _ = s.label("Item " + i.to_string())
      }
    })
  }

  ctx.begin_frame(kb_key_input(@core.Key::Tab))
  render()
  let _ = ctx.end_frame()

  // PageDown scrolls most of a viewport
  ctx.begin_frame(kb_key_input(@core.Key::PageDown))
  render()
  let _ = ctx.end_frame()
  let after_page_down = ctx.get_scroll_offset(
    ctx.id_stack.derive_id("fluent_scroll"),
  )
  assert_true(after_page_down > 0.0)

  // PageUp scrolls back
  ctx.begin_frame(kb_key_input(@core.Key::PageUp))
  render()
  let _ = ctx.end_frame()
  let after_page_up = ctx.get_scroll_offset(
    ctx.id_stack.derive_id("fluent_scroll"),
  )
  assert_true(after_page_up < after_page_down)

  // ArrowUp cannot go below the top
  ctx.begin_frame(kb_key_input(@core.Key::ArrowUp))
  render()
  let _ = ctx.end_frame()
  assert_eq(ctx.get_scroll_offset(ctx.id_stack.derive_id("fluent_scroll")), 0.0)
}

///|
test "window: every arrow key moves the focused window" {
  let ctx = @core.UIContext::new()
  let pos = @math.Vec2::new(50.0, 50.0)
  let size = @math.Vec2::new(200.0, 150.0)
  let win_id = ctx.id_stack.derive_id("window::FluentWin")
  let render = fn() {
    let _ = window(ctx, "FluentWin", pos, size, fn(w) {
      let _ = w.label("body")
    })
  }

  ctx.begin_frame(kb_key_input(@core.Key::Tab))
  render()
  let _ = ctx.end_frame()

  ctx.begin_frame(kb_key_input(@core.Key::ArrowRight))
  render()
  let _ = ctx.end_frame()
  assert_eq(ctx.get_window_pos(win_id, pos).x, 58.0)

  ctx.begin_frame(kb_key_input(@core.Key::ArrowLeft))
  render()
  let _ = ctx.end_frame()
  assert_eq(ctx.get_window_pos(win_id, pos).x, 50.0)

  ctx.begin_frame(kb_key_input(@core.Key::ArrowDown))
  render()
  let _ = ctx.end_frame()
  assert_eq(ctx.get_window_pos(win_id, pos).y, 58.0)

  ctx.begin_frame(kb_key_input(@core.Key::ArrowUp))
  render()
  let _ = ctx.end_frame()
  assert_eq(ctx.get_window_pos(win_id, pos).y, 50.0)
}

///|
test "breadcrumb: ArrowLeft clamps at the first ancestor" {
  let ctx = @core.UIContext::new()
  let items = ["Home", "Library", "Reports"]

  ctx.begin_frame(kb_key_input(@core.Key::Tab))
  let (c1, _) = breadcrumb(ctx, "fluent_crumbs", items)
  let _ = ctx.end_frame()
  assert_eq(c1, None)

  // ArrowLeft with the highlight already on the first ancestor stays there
  ctx.begin_frame(kb_key_input(@core.Key::ArrowLeft))
  let (c2, _) = breadcrumb(ctx, "fluent_crumbs", items)
  let _ = ctx.end_frame()
  assert_eq(c2, None)

  ctx.begin_frame(kb_key_input(@core.Key::Enter))
  let (c3, _) = breadcrumb(ctx, "fluent_crumbs", items)
  let _ = ctx.end_frame()
  assert_eq(c3, Some(0))
}
