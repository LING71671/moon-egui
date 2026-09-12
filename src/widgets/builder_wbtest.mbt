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
test "widget: Button builder and ui.add dispatch" {
  let ctx = @core.UIContext::new()
  ctx.begin_frame(
    @core.RawInput::from_mouse(@math.Vec2::new(30.0, 15.0), false),
  )

  // Dispatch standard button via ui.add
  let resp1 = ctx.add(Button::new("Action").primary(true))
  assert_true(resp1.hovered())

  // Dispatch button with keyboard shortcut
  let resp2 = ctx.add(Button::new("Save").shortcut("⌘S"))
  assert_false(resp2.hovered())

  let _ = ctx.end_frame()
}

///|
test "widget: Slider and SliderRef bidirectional state binding" {
  let ctx = @core.UIContext::new()
  let vol = Ref(50.0)

  // Frame 1: Mouse hovering over slider track zone
  ctx.begin_frame(
    @core.RawInput::from_mouse(@math.Vec2::new(50.0, 10.0), false),
  )
  let resp1 = ctx.add(Slider::from_ref("Vol", vol, 0.0, 100.0).step(5.0))
  assert_eq(vol.val, 50.0)
  assert_true(resp1.rect.w > 100.0)
  let _ = ctx.end_frame()

  // Frame 2: Direct Slider builder with show(ctx)
  let ctx2 = @core.UIContext::new()
  ctx2.begin_frame(@core.RawInput::new())
  let (val2, _resp2) = Slider::new("Gain", 2.5, 0.0, 10.0).step(0.1).show(ctx2)
  assert_eq(val2, 2.5)
  let _ = ctx2.end_frame()
}

///|
test "widget: Checkbox and Toggle with Ref binding" {
  let ctx = @core.UIContext::new()
  let chk = Ref(false)
  let tog = Ref(true)

  // Frame 1: idle
  ctx.begin_frame(@core.RawInput::new())
  let _ = ctx.add(Checkbox::from_ref("Enable Sync", chk))
  let _ = ctx.add(Toggle::from_ref("Auto Save", tog))
  assert_false(chk.val)
  assert_true(tog.val)
  let _ = ctx.end_frame()

  // Frame 2: mouse press down on checkbox
  let ctx2 = @core.UIContext::new()
  let chk2 = Ref(false)
  ctx2.begin_frame(@core.RawInput::from_mouse(@math.Vec2::new(5.0, 5.0), true))
  let _ = ctx2.add(Checkbox::from_ref("Enable Sync", chk2))
  assert_false(chk2.val)
  let _ = ctx2.end_frame()

  // Frame 3: mouse release on checkbox -> click event fired and Ref updated
  ctx2.begin_frame(@core.RawInput::from_mouse(@math.Vec2::new(5.0, 5.0), false))
  let _ = ctx2.add(Checkbox::from_ref("Enable Sync", chk2))
  assert_true(chk2.val)
  let _ = ctx2.end_frame()
}

///|
test "widget: Label, Separator, Badge, and ProgressBar with ui.add" {
  let ctx = @core.UIContext::new()
  ctx.begin_frame(@core.RawInput::new())

  let resp_lbl = ctx.add(
    Label::new("Telemetry Active").color(@color.Color::accent_primary()),
  )
  assert_true(resp_lbl.rect.h > 10.0)

  let resp_sep = ctx.add(Separator::new())
  assert_true(resp_sep.rect.h > 0.0)

  let resp_bdg = ctx.add(
    Badge::new("Ready").kind(BadgeKind::success()).dot(true).pill(true),
  )
  assert_true(resp_bdg.rect.w > 20.0)

  let resp_pb = ctx.add(ProgressBar::new(0.65).text("65% Loaded"))
  assert_true(resp_pb.rect.w > 0.0)

  let _ = ctx.end_frame()
}
