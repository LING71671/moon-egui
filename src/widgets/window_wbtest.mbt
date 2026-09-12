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
test "window: container sets local origin and clip" {
  let ctx = @core.UIContext::new()
  ctx.begin_frame(@core.RawInput::new())

  let win_pos = @math.Vec2::new(50.0, 50.0)
  let win_size = @math.Vec2::new(200.0, 150.0)

  let mut inside_cur_x = 0.0
  let mut inside_cur_y = 0.0
  let mut inside_avail_w = 0.0
  let mut after_label_y = 0.0

  let win_resp = window(ctx, "Test Window", win_pos, win_size, fn(ui) {
    // Inside window, cursor starts at pos.x + pad(12), pos.y + title_h(28) + pad(12) = (62.0, 90.0)
    inside_cur_x = ui.cursor().x
    inside_cur_y = ui.cursor().y
    inside_avail_w = ui.available_width()
    let _ = ui.label("Inside Window")
    after_label_y = ui.cursor().y
  })

  // Pointer sits at (0, 0), the window at (50, 50)
  assert_true(!win_resp.hovered())
  assert_eq(win_resp.rect.x, 50.0)
  assert_eq(win_resp.rect.y, 50.0)

  assert_eq(inside_cur_x, 62.0)
  assert_eq(inside_cur_y, 90.0)
  assert_eq(inside_avail_w, 200.0 - 24.0)
  assert_eq(after_label_y, 90.0 + 18.0 + 8.0)

  // Outside window, cursor returns to previous position (0, 0)
  assert_eq(ctx.cursor().x, 0.0)
  assert_eq(ctx.cursor().y, 0.0)

  let dl = ctx.end_frame()
  assert_true(dl.len() > 5)
}

///|
test "window: title bar drag moves and persists the position" {
  let ctx = @core.UIContext::new()
  let size = @math.Vec2::new(200.0, 150.0)
  let start = @math.Vec2::new(100.0, 100.0)

  // Frame 1: press on the title bar (spans y..y+28)
  ctx.begin_frame(
    @core.RawInput::from_mouse(@math.Vec2::new(150.0, 110.0), true),
  )
  let resp1 = window(ctx, "Panel", start, size, fn(_ui) {  })
  assert_true(resp1.hovered())
  let _ = ctx.end_frame()

  // Frame 2: pointer moves while held -> the window follows the delta
  ctx.begin_frame(
    @core.RawInput::from_mouse(@math.Vec2::new(180.0, 130.0), true),
  )
  let resp2 = window(ctx, "Panel", start, size, fn(_ui) {  })
  assert_true(resp2.dragged())
  assert_eq(resp2.rect.x, 130.0)
  assert_eq(resp2.rect.y, 120.0)
  let _ = ctx.end_frame()

  // Frame 3: release, the window stays where it was dropped
  ctx.begin_frame(
    @core.RawInput::from_mouse(@math.Vec2::new(180.0, 130.0), false),
  )
  let resp3 = window(ctx, "Panel", start, size, fn(_ui) {  })
  assert_true(!resp3.dragged())
  assert_eq(resp3.rect.x, 130.0)
  assert_eq(resp3.rect.y, 120.0)
  let _ = ctx.end_frame()

  // The moved position survives: `start` is only the initial position
  ctx.begin_frame(@core.RawInput::from_mouse(@math.Vec2::new(0.0, 0.0), false))
  let resp4 = window(ctx, "Panel", start, size, fn(_ui) {  })
  assert_eq(resp4.rect.x, 130.0)
  assert_eq(resp4.rect.y, 120.0)
  let _ = ctx.end_frame()
}

///|
test "window: content is not draggable and separate salts keep separate positions" {
  let ctx = @core.UIContext::new()
  let size = @math.Vec2::new(200.0, 150.0)
  let start = @math.Vec2::new(0.0, 0.0)

  // Press inside the content region: not a drag
  ctx.begin_frame(
    @core.RawInput::from_mouse(@math.Vec2::new(100.0, 100.0), true),
  )
  let resp = window(ctx, "Panel", start, size, fn(_ui) {  })
  assert_true(resp.hovered())
  assert_true(!resp.dragged())
  let _ = ctx.end_frame()

  // Two windows sharing a title keep independent positions when salted
  ctx.begin_frame(@core.RawInput::new())
  let a = window(ctx, "Panel", start, size, fn(_ui) {  }, id_salt="a")
  let b = window(
    ctx,
    "Panel",
    @math.Vec2::new(400.0, 300.0),
    size,
    fn(_ui) {  },
    id_salt="b",
  )
  assert_eq(a.rect.x, 0.0)
  assert_eq(b.rect.x, 400.0)
  let _ = ctx.end_frame()
}

///|
/// Collect the window titles in draw order. Each window emits exactly one text
/// command (its title), so the sequence mirrors the compositing order.
fn window_title_order(dl : @draw.DrawList) -> Array[String] {
  let titles : Array[String] = []
  for i = 0; i < dl.len(); i = i + 1 {
    match dl.get_command(i) {
      Some(@draw.DrawCmd::Text(_pos, text, _size, _color, _, _)) =>
        titles.push(text)
      _ => ()
    }
  }
  titles
}

///|
test "window: windows composite in stacking order and raise on press" {
  let ctx = @core.UIContext::new()
  let size = @math.Vec2::new(100.0, 100.0)

  // Frame 1: A is declared first, so B is stacked on top of it
  ctx.begin_frame(@core.RawInput::new())
  let _ = window(ctx, "A", @math.Vec2::zero(), size, fn(_ui) {  }, id_salt="a")
  let _ = window(
    ctx,
    "B",
    @math.Vec2::new(50.0, 50.0),
    size,
    fn(_ui) {  },
    id_salt="b",
  )
  let titles1 = window_title_order(ctx.end_frame())
  assert_eq(titles1.length(), 2)
  assert_eq(titles1[0], "A")
  assert_eq(titles1[1], "B")

  // Frame 2: pressing inside A raises it above B, even though B is declared
  // later in the frame
  ctx.begin_frame(@core.RawInput::from_mouse(@math.Vec2::new(10.0, 10.0), true))
  let _ = window(ctx, "A", @math.Vec2::zero(), size, fn(_ui) {  }, id_salt="a")
  let _ = window(
    ctx,
    "B",
    @math.Vec2::new(50.0, 50.0),
    size,
    fn(_ui) {  },
    id_salt="b",
  )
  let titles2 = window_title_order(ctx.end_frame())
  assert_eq(titles2[0], "B")
  assert_eq(titles2[1], "A")
}

///|
test "window: a raised window hides the window and the widgets underneath it" {
  let ctx = @core.UIContext::new()
  let size = @math.Vec2::new(200.0, 200.0)

  // Frame 1: A and B cover the same area, B declared last and therefore on top
  ctx.begin_frame(@core.RawInput::new())
  let _ = window(ctx, "A", @math.Vec2::zero(), size, fn(_ui) {  }, id_salt="a")
  let _ = window(ctx, "B", @math.Vec2::zero(), size, fn(_ui) {  }, id_salt="b")
  let _ = ctx.end_frame()

  // Frame 2: the pointer lands on both
  ctx.begin_frame(
    @core.RawInput::from_mouse(@math.Vec2::new(50.0, 50.0), false),
  )
  let a = window(ctx, "A", @math.Vec2::zero(), size, fn(_ui) {  }, id_salt="a")
  let b = window(ctx, "B", @math.Vec2::zero(), size, fn(_ui) {  }, id_salt="b")
  assert_true(!a.hovered())
  assert_true(b.hovered())

  // Content on the main layer sits below every window
  ctx.set_cursor(@math.Vec2::zero())
  let (_id, rect, resp) = ctx.allocate_space(size)
  assert_true(rect.contains(@math.Vec2::new(50.0, 50.0)))
  assert_true(!resp.hovered())
  let _ = ctx.end_frame()
}

///|
test "window: drag is clamped to the constrain_to bounds" {
  let ctx = @core.UIContext::new()
  let size = @math.Vec2::new(100.0, 100.0)
  let start = @math.Vec2::zero()
  let bounds = @math.Rect::new(0.0, 0.0, 300.0, 300.0)

  // Frame 1: grab the title bar
  ctx.begin_frame(@core.RawInput::from_mouse(@math.Vec2::new(50.0, 10.0), true))
  let _ = window(ctx, "Panel", start, size, fn(_ui) {  }, constrain_to=bounds)
  let _ = ctx.end_frame()

  // Frame 2: drag well past the bottom-right corner of the bounds
  ctx.begin_frame(
    @core.RawInput::from_mouse(@math.Vec2::new(900.0, 900.0), true),
  )
  let resp = window(
    ctx,
    "Panel",
    start,
    size,
    fn(_ui) {  },
    constrain_to=bounds,
  )
  let _ = ctx.end_frame()

  // Pinned to 300 - 100 on both axes
  assert_eq(resp.rect.x, 200.0)
  assert_eq(resp.rect.y, 200.0)
}

///|
test "window: a drag that stays inside the bounds passes through the clamp untouched" {
  let ctx = @core.UIContext::new()
  let size = @math.Vec2::new(100.0, 100.0)
  let start = @math.Vec2::new(40.0, 40.0)
  let bounds = @math.Rect::new(0.0, 0.0, 600.0, 600.0)

  // Frame 1: grab the title bar
  ctx.begin_frame(@core.RawInput::from_mouse(@math.Vec2::new(80.0, 50.0), true))
  let _ = window(ctx, "Panel", start, size, fn(_ui) {  }, constrain_to=bounds)
  let _ = ctx.end_frame()

  // Frame 2: a small move well inside the bounds
  ctx.begin_frame(
    @core.RawInput::from_mouse(@math.Vec2::new(100.0, 70.0), true),
  )
  let resp = window(
    ctx,
    "Panel",
    start,
    size,
    fn(_ui) {  },
    constrain_to=bounds,
  )
  let _ = ctx.end_frame()

  // 40 + (100 - 80) and 40 + (70 - 50): the clamp must not nudge either axis
  assert_eq(resp.rect.x, 60.0)
  assert_eq(resp.rect.y, 60.0)
}

///|
test "window: a window declared inside a clip stack ignores that clip" {
  let ctx = @core.UIContext::new()
  let size = @math.Vec2::new(100.0, 100.0)
  let win_pos = @math.Vec2::new(200.0, 200.0)

  ctx.begin_frame(
    @core.RawInput::from_mouse(@math.Vec2::new(250.0, 210.0), false),
  )

  // A tiny clip that excludes the window entirely
  ctx.push_clip(@math.Rect::new(0.0, 0.0, 50.0, 50.0))
  let resp = window(ctx, "Panel", win_pos, size, fn(_ui) {  })
  ctx.pop_clip()

  // Floating windows are composited unclipped, so their pointer test has to
  // ignore the clip too, and the caller's clip stack must come back intact.
  assert_true(resp.hovered())
  assert_true(ctx.current_clip() is None)
}
