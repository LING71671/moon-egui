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
test "widgets: rating builder and default show" {
  let ctx = UIContext::new()
  ctx.begin_frame(@core.RawInput::new())

  let (val, resp) = Rating::new("test_rating", 3.5)
    .max_stars(5)
    .allow_half(true)
    .show(ctx)

  assert_eq(val, 3.5)
  assert_true(resp.rect.w > 0.0)
  assert_true(resp.rect.h > 0.0)

  let dl = ctx.end_frame()
  assert_true(dl.len() > 0)
}

///|
test "widgets: rating click full and half star" {
  let ctx = UIContext::new()
  // Star size is 18.0, spacing is 4.0.
  // Star 0: [0..18], Star 1: [22..40], Star 2: [44..62], Star 3: [66..84], Star 4: [88..106]

  // Frame 1: Mouse down on star 2 (x=50.0, which is > 44 + 9 = 53? At x=58, it is right half of star 2 -> 3.0)
  let raw1 = @core.RawInput::from_mouse(@math.Vec2::new(58.0, 10.0), true)
  ctx.begin_frame(raw1)
  let (v1, _) = rating(ctx, "rate_click", 1.0)
  assert_eq(v1, 1.0)
  let _ = ctx.end_frame()

  // Frame 2: Mouse release on star 2 right half -> click triggered, score is 3.0!
  let raw2 = @core.RawInput::from_mouse(@math.Vec2::new(58.0, 10.0), false)
  ctx.begin_frame(raw2)
  let (v2, _) = rating(ctx, "rate_click", 1.0)
  assert_eq(v2, 3.0)
  let _ = ctx.end_frame()

  // Frame 3: Mouse down on star 3 left half (star 3 is [66..84], center is 75.0, so x=70.0 is left half -> 3.5)
  let raw3 = @core.RawInput::from_mouse(@math.Vec2::new(70.0, 10.0), true)
  ctx.begin_frame(raw3)
  let _ = rating(ctx, "rate_click", 3.0)
  let _ = ctx.end_frame()

  // Frame 4: Mouse release on star 3 left half -> click triggered, score is 3.5!
  let raw4 = @core.RawInput::from_mouse(@math.Vec2::new(70.0, 10.0), false)
  ctx.begin_frame(raw4)
  let (v4, _) = rating(ctx, "rate_click", 3.0)
  assert_eq(v4, 3.5)
  let _ = ctx.end_frame()
}

///|
test "widgets: rating keyboard navigation" {
  let ctx = UIContext::new()

  // Frame 1: Tab to focus rating
  let raw_tab = @core.RawInput::with_events(
    @math.Vec2::zero(),
    false,
    @math.Vec2::zero(),
    [@core.Event::Key(@core.Key::Tab, true, @core.Modifiers::none())],
    "",
    @core.Modifiers::none(),
  )
  ctx.begin_frame(raw_tab)
  let (v0, _) = rating(ctx, "rate_kb", 2.0)
  assert_eq(v0, 2.0)
  let _ = ctx.end_frame()

  // Frame 2: ArrowRight increases by 0.5
  let raw_right = @core.RawInput::with_events(
    @math.Vec2::zero(),
    false,
    @math.Vec2::zero(),
    [@core.Event::Key(@core.Key::ArrowRight, true, @core.Modifiers::none())],
    "",
    @core.Modifiers::none(),
  )
  ctx.begin_frame(raw_right)
  let (v_right, _) = rating(ctx, "rate_kb", 2.0)
  assert_eq(v_right, 2.5)
  let _ = ctx.end_frame()

  // Frame 3: ArrowDown decreases by 0.5
  let raw_down = @core.RawInput::with_events(
    @math.Vec2::zero(),
    false,
    @math.Vec2::zero(),
    [@core.Event::Key(@core.Key::ArrowDown, true, @core.Modifiers::none())],
    "",
    @core.Modifiers::none(),
  )
  ctx.begin_frame(raw_down)
  let (v_down, _) = rating(ctx, "rate_kb", 2.5)
  assert_eq(v_down, 2.0)
  let _ = ctx.end_frame()

  // Frame 4: End sets to max (5.0)
  let raw_end = @core.RawInput::with_events(
    @math.Vec2::zero(),
    false,
    @math.Vec2::zero(),
    [@core.Event::Key(@core.Key::End, true, @core.Modifiers::none())],
    "",
    @core.Modifiers::none(),
  )
  ctx.begin_frame(raw_end)
  let (v_end, _) = rating(ctx, "rate_kb", 2.0)
  assert_eq(v_end, 5.0)
  let _ = ctx.end_frame()

  // Frame 5: Home resets to 0.0
  let raw_home = @core.RawInput::with_events(
    @math.Vec2::zero(),
    false,
    @math.Vec2::zero(),
    [@core.Event::Key(@core.Key::Home, true, @core.Modifiers::none())],
    "",
    @core.Modifiers::none(),
  )
  ctx.begin_frame(raw_home)
  let (v_home, _) = rating(ctx, "rate_kb", 5.0)
  assert_eq(v_home, 0.0)
  let _ = ctx.end_frame()
}

///|
test "widgets: rating read_only mode ignores clicks" {
  let ctx = UIContext::new()

  let raw1 = @core.RawInput::from_mouse(@math.Vec2::new(58.0, 10.0), true)
  ctx.begin_frame(raw1)
  let _ = rating(ctx, "rate_ro", 3.0, read_only=true)
  let _ = ctx.end_frame()

  let raw2 = @core.RawInput::from_mouse(@math.Vec2::new(58.0, 10.0), false)
  ctx.begin_frame(raw2)
  let (v_ro, _) = rating(ctx, "rate_ro", 3.0, read_only=true)
  assert_eq(v_ro, 3.0) // unchanged!
  let _ = ctx.end_frame()
}

///|
test "widgets: rating from_ref binding" {
  let ctx = UIContext::new()
  let target = Ref(2.0)

  // Click on star 4 right half (x=100.0 -> 5.0 stars)
  let raw1 = @core.RawInput::from_mouse(@math.Vec2::new(100.0, 10.0), true)
  ctx.begin_frame(raw1)
  let _ = ctx.add(Rating::from_ref("rate_ref", target))
  let _ = ctx.end_frame()

  let raw2 = @core.RawInput::from_mouse(@math.Vec2::new(100.0, 10.0), false)
  ctx.begin_frame(raw2)
  let _ = ctx.add(Rating::from_ref("rate_ref", target))
  let _ = ctx.end_frame()

  assert_eq(target.val, 5.0)
}

///|
test "widgets: rating cursor semantics" {
  let ctx = UIContext::new()

  // Hover over editable rating -> pointer
  let raw_hover = @core.RawInput::from_mouse(@math.Vec2::new(30.0, 10.0), false)
  ctx.begin_frame(raw_hover)
  let _ = rating(ctx, "rate_cur", 2.0)
  let _ = ctx.end_frame()
  assert_eq(ctx.cursor_icon(), "pointer")
}

///|
test "widgets: rating NaN guard and PageUp/PageDown stepping" {
  let ctx = UIContext::new()
  // NaN value should safely normalize to 0.0 without crash
  ctx.begin_frame(@core.RawInput::new())
  let nan_val = 0.0 / 0.0
  let (v_nan, _) = rating(ctx, "rate_nan", nan_val)
  let _ = ctx.end_frame()
  assert_eq(v_nan, 0.0)

  // Test PageUp (+2.0) and PageDown (-2.0)
  let ctx_page = UIContext::new()
  // Frame 1: Tab to focus
  let raw_tab = @core.RawInput::with_events(
    @math.Vec2::zero(),
    false,
    @math.Vec2::zero(),
    [@core.Event::Key(@core.Key::Tab, true, @core.Modifiers::none())],
    "",
    @core.Modifiers::none(),
  )
  ctx_page.begin_frame(raw_tab)
  let (v0, _) = rating(ctx_page, "rate_page", 1.0)
  let _ = ctx_page.end_frame()
  assert_eq(v0, 1.0)

  // Frame 2: PageUp increases by 2.0 -> 3.0
  let raw_pgup = @core.RawInput::with_events(
    @math.Vec2::zero(),
    false,
    @math.Vec2::zero(),
    [@core.Event::Key(@core.Key::PageUp, true, @core.Modifiers::none())],
    "",
    @core.Modifiers::none(),
  )
  ctx_page.begin_frame(raw_pgup)
  let (v1, _) = rating(ctx_page, "rate_page", 1.0)
  let _ = ctx_page.end_frame()
  assert_eq(v1, 3.0)

  // Frame 3: PageDown decreases by 2.0 -> 1.0
  let raw_pgdn = @core.RawInput::with_events(
    @math.Vec2::zero(),
    false,
    @math.Vec2::zero(),
    [@core.Event::Key(@core.Key::PageDown, true, @core.Modifiers::none())],
    "",
    @core.Modifiers::none(),
  )
  ctx_page.begin_frame(raw_pgdn)
  let (v2, _) = rating(ctx_page, "rate_page", 3.0)
  let _ = ctx_page.end_frame()
  assert_eq(v2, 1.0)
}
