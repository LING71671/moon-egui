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
test "code_editor: clicking past the line end parks the caret at the end" {
  let ctx = @core.UIContext::new()
  let text = "hello world"
  let editor_id = ctx.id_stack.derive_id("code_editor::ce_drag")

  // Frame 1: render with the pointer away
  ctx.begin_frame(
    @core.RawInput::from_mouse(@math.Vec2::new(-50.0, -50.0), false),
  )
  let (_, resp1) = CodeEditor::new("ce_drag", text)
    .size(@math.Vec2::new(300.0, 60.0))
    .show(ctx)
  let _ = ctx.end_frame()
  let _ = resp1

  // Frame 2: press far beyond the line - the caret snaps to the last column
  ctx.begin_frame(@core.RawInput::from_mouse(@math.Vec2::new(290.0, 8.0), true))
  let _ = CodeEditor::new("ce_drag", text)
    .size(@math.Vec2::new(300.0, 60.0))
    .show(ctx)
  let _ = ctx.end_frame()
  assert_eq(ctx.get_text_cursor_pos(editor_id, text.length()), 11)
}

///|
test "code_editor: read_only ignores typed characters" {
  let ctx = @core.UIContext::new()
  let render = fn(extra : @core.Event) {
    @core.RawInput::with_events(
      @math.Vec2::new(-50.0, -50.0),
      false,
      @math.Vec2::zero(),
      [extra],
      "X",
      @core.Modifiers::none(),
    )
  }

  // Tab focuses the read-only editor, then a keystroke tries to type
  ctx.begin_frame(kb_key_input(@core.Key::Tab))
  let (_, _) = CodeEditor::new("ce_ro", "abc")
    .size(@math.Vec2::new(300.0, 60.0))
    .read_only(true)
    .show(ctx)
  let _ = ctx.end_frame()

  ctx.begin_frame(render(@core.Event::TextInput("X")))
  let (code, _) = CodeEditor::new("ce_ro", "abc")
    .size(@math.Vec2::new(300.0, 60.0))
    .read_only(true)
    .show(ctx)
  let _ = ctx.end_frame()
  assert_eq(code, "abc")
}

///|
test "code_editor: show_line_numbers=false drops the gutter" {
  let ctx = @core.UIContext::new()
  let mouse = @core.RawInput::from_mouse(@math.Vec2::new(-50.0, -50.0), false)

  // NOTE: end_frame returns the shared frame draw list, so per-frame results
  // must be captured as scalars before the next begin_frame clears it.
  ctx.begin_frame(mouse)
  let (_, with_gutter) = CodeEditor::new("ce_gutter", "abc")
    .size(@math.Vec2::new(300.0, 60.0))
    .show(ctx)
  let dl = ctx.end_frame()
  let len_with = dl.len()

  ctx.begin_frame(mouse)
  let (_, without) = CodeEditor::new("ce_gutter", "abc")
    .size(@math.Vec2::new(300.0, 60.0))
    .show_line_numbers(false)
    .show(ctx)
  let dl2 = ctx.end_frame()
  let len_without = dl2.len()

  assert_eq(with_gutter.rect.w, without.rect.w)
  assert_true(len_with > len_without)
}

///|
test "dock: dragging the horizontal divider updates the ratio" {
  let ctx = @core.UIContext::new()
  let tree = DockTree::split(
    DockSplitDirection::Horizontal,
    0.5,
    DockTree::leaf([DockTab::new("t1", "One")]),
    DockTree::leaf([DockTab::new("t2", "Two")]),
  )

  // Frame 1: press on the divider (ratio 0.5 -> handle near x = 397..403)
  ctx.begin_frame(
    @core.RawInput::from_mouse(@math.Vec2::new(400.0, 250.0), true),
  )
  let _ = dock_area(ctx, "drag_dock", @math.Vec2::new(800.0, 500.0), tree, fn(
    _ui,
    _id,
    _rect,
  ) {

  })
  let _ = ctx.end_frame()

  // Frame 2: drag to the right while the button is held
  ctx.begin_frame(
    @core.RawInput::from_mouse(@math.Vec2::new(560.0, 250.0), true),
  )
  let r2 = dock_area(ctx, "drag_dock", @math.Vec2::new(800.0, 500.0), tree, fn(
    _ui,
    _id,
    _rect,
  ) {

  })
  let _ = ctx.end_frame()
  assert_true(r2.ratio_changed)

  // Frame 3: release
  ctx.begin_frame(
    @core.RawInput::from_mouse(@math.Vec2::new(560.0, 250.0), false),
  )
  let _ = dock_area(ctx, "drag_dock", @math.Vec2::new(800.0, 500.0), tree, fn(
    _ui,
    _id,
    _rect,
  ) {

  })
  let _ = ctx.end_frame()
}

///|
test "dock: dragging the vertical divider follows the same contract" {
  let ctx = @core.UIContext::new()
  let tree = DockTree::split(
    DockSplitDirection::Vertical,
    0.5,
    DockTree::leaf([DockTab::new("t1", "One")]),
    DockTree::leaf([DockTab::new("t2", "Two")]),
  )

  ctx.begin_frame(
    @core.RawInput::from_mouse(@math.Vec2::new(400.0, 250.0), true),
  )
  let _ = dock_area(ctx, "drag_vdock", @math.Vec2::new(800.0, 500.0), tree, fn(
    _ui,
    _id,
    _rect,
  ) {

  })
  let _ = ctx.end_frame()

  ctx.begin_frame(
    @core.RawInput::from_mouse(@math.Vec2::new(400.0, 150.0), true),
  )
  let r2 = dock_area(ctx, "drag_vdock", @math.Vec2::new(800.0, 500.0), tree, fn(
    _ui,
    _id,
    _rect,
  ) {

  })
  let _ = ctx.end_frame()
  assert_true(r2.ratio_changed)
}
