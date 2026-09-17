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
test "tooltip: delay frames and hover lifecycle" {
  let ctx = @core.UIContext::new()
  let target_rect = @math.Rect::new(100.0, 100.0, 80.0, 30.0)
  let id = ctx.id_stack.derive_id("test_btn")

  let tip = Tooltip::new("Help text").delay(3)

  // Frame 1: Not hovered -> does not show
  ctx.begin_frame(@core.RawInput::from_mouse(@math.Vec2::new(0.0, 0.0), false))
  let shown1 = tip.show_for(ctx, id, target_rect, false)
  let _ = ctx.end_frame()
  assert_false(shown1)

  // Frames 2..4: Hovered but delay not reached (count = 1, 2, 3 <= 3)
  for _ in 0..<3 {
    ctx.begin_frame(
      @core.RawInput::from_mouse(@math.Vec2::new(110.0, 110.0), false),
    )
    let shown = tip.show_for(ctx, id, target_rect, true)
    let _ = ctx.end_frame()
    assert_false(shown)
  }

  // Frame 5: Hovered and count = 4 > 3 -> shows!
  ctx.begin_frame(
    @core.RawInput::from_mouse(@math.Vec2::new(110.0, 110.0), false),
  )
  let shown5 = tip.show_for(ctx, id, target_rect, true)
  let dl5 = ctx.end_frame()
  assert_true(shown5)
  // Drop shadow, background, border, text
  assert_true(dl5.len() >= 4)

  // Frame 6: Mouse leaves -> count resets to 0 -> does not show
  ctx.begin_frame(@core.RawInput::from_mouse(@math.Vec2::new(0.0, 0.0), false))
  let shown6 = tip.show_for(ctx, id, target_rect, false)
  let _ = ctx.end_frame()
  assert_false(shown6)
}

///|
test "tooltip: placement variants" {
  let ctx = @core.UIContext::new()
  let target_rect = @math.Rect::new(200.0, 200.0, 100.0, 40.0)
  let id = ctx.id_stack.derive_id("placement_btn")

  for
    placement in [
      TooltipPlacement::Top,
      TooltipPlacement::Bottom,
      TooltipPlacement::Left,
      TooltipPlacement::Right,
    ] {
    let tip = Tooltip::new("Placement test").delay(0).placement(placement)
    ctx.begin_frame(
      @core.RawInput::from_mouse(@math.Vec2::new(210.0, 210.0), false),
    )
    let shown = tip.show_for(ctx, id, target_rect, true)
    let dl = ctx.end_frame()
    assert_true(shown)
    assert_true(dl.len() >= 4)
  }
}

///|
test "tooltip: on_hover_text helper" {
  let ctx = @core.UIContext::new()
  ctx.begin_frame(
    @core.RawInput::from_mouse(@math.Vec2::new(50.0, 50.0), false),
  )

  let id = ctx.id_stack.derive_id("btn_hover")
  let rect = @math.Rect::new(20.0, 20.0, 80.0, 30.0)
  let resp = @core.Response::new(id, rect, true, false, false, false)

  let chained_resp = on_hover_text(resp, ctx, "Quick tip", delay_frames=0)
  assert_eq(chained_resp.id, id)
  assert_true(chained_resp.hovered)

  let dl = ctx.end_frame()
  assert_true(dl.len() >= 4)
}
