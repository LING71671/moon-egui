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
test "rich_text: cjk paragraph line wrapping without spaces" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::new())

  // A 24-character Chinese paragraph with zero spaces
  let cjk_text = "这是一段用于测试中文富文本排版折行特性的纯文本内容"
  let spans = [TextSpan::normal(cjk_text)]

  // Wrap width set to 100.0px (each CJK char at font 13 is ~13.65px, so ~7 chars per line)
  let res = rich_text(ctx, "cjk_test", spans, wrap_width=100.0)
  let _ = ctx.end_frame()

  // Must wrap into at least 3 lines
  let expected_min_h = 22.0 * 3.0
  assert_true(res.resp.rect.h >= expected_min_h)
}

///|
test "rich_text: mixed english and cjk wraps without artificial gaps" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::new())

  let spans = [TextSpan::normal("MoonBit"), TextSpan::bold(" 原生引擎")]

  let res = rich_text(ctx, "mixed_test", spans, wrap_width=300.0)
  let _ = ctx.end_frame()

  // On a wide container (300px), all text fits on a single line
  assert_eq(res.resp.rect.h, 22.0)
  assert_true(res.resp.rect.w > 0.0)
}

///|
test "rich_text: scale 2.0 inline code geometry invariance" {
  let ctx1 = UIContext::new()
  ctx1.begin_frame(RawInput::new())
  let spans = [TextSpan::code("let x = 42")]
  let res1 = rich_text(ctx1, "code_scale_1", spans)
  let _ = ctx1.end_frame()

  let ctx2 = UIContext::new()
  ctx2.set_style(@core.WidgetStyle::default().scaled(2.0))
  ctx2.begin_frame(RawInput::new())
  let res2 = rich_text(ctx2, "code_scale_2", spans)
  let _ = ctx2.end_frame()

  assert_eq(res2.resp.rect.h, res1.resp.rect.h * 2.0)
}

///|
test "rich_text: keyboard navigation between links and Enter activation" {
  let ctx = UIContext::new()
  let spans = [
    TextSpan::normal("Visit "),
    TextSpan::link("Doc1", "https://example.com/1"),
    TextSpan::normal(" and "),
    TextSpan::link("Doc2", "https://example.com/2"),
  ]

  // Frame 1: Focus container via click
  let raw1 = RawInput::from_mouse(@math.Vec2::new(10.0, 10.0), true)
  ctx.begin_frame(raw1)
  let _ = rich_text(ctx, "kb_links", spans)
  let _ = ctx.end_frame()

  // Frame 2: ArrowRight moves focus to second link
  let raw2 = @core.RawInput::with_events(
    @math.Vec2::new(10.0, 10.0),
    false,
    @math.Vec2::zero(),
    [@core.Event::Key(@core.Key::ArrowRight, true, @core.Modifiers::none())],
    "",
    @core.Modifiers::none(),
  )
  ctx.begin_frame(raw2)
  let _ = rich_text(ctx, "kb_links", spans)
  assert_true(ctx.input().is_key_consumed(@core.Key::ArrowRight))
  let _ = ctx.end_frame()

  // Frame 3: Press Enter to follow the focused second link
  let raw3 = @core.RawInput::with_events(
    @math.Vec2::new(10.0, 10.0),
    false,
    @math.Vec2::zero(),
    [@core.Event::Key(@core.Key::Enter, true, @core.Modifiers::none())],
    "",
    @core.Modifiers::none(),
  )
  ctx.begin_frame(raw3)
  let res3 = rich_text(ctx, "kb_links", spans)
  assert_true(ctx.input().is_key_consumed(@core.Key::Enter))
  let dl3 = ctx.end_frame()

  assert_eq(res3.clicked_url, Some("https://example.com/2"))

  // Verify focus ring on the active link is in draw list
  let mut has_focus_ring = false
  for i = 0; i < dl3.len(); i = i + 1 {
    if dl3.get_command(i) is Some(@draw.DrawCmd::RectStroke(_)) {
      has_focus_ring = true
    }
  }
  assert_true(has_focus_ring)
}

///|
test "hyperlink: keyboard focus and Space activation with focus ring" {
  let ctx = UIContext::new()

  // Frame 1: Focus hyperlink
  let raw1 = RawInput::from_mouse(@math.Vec2::new(10.0, 10.0), true)
  ctx.begin_frame(raw1)
  let _ = hyperlink(ctx, "Learn More", "https://moonbitlang.com")
  let _ = ctx.end_frame()

  // Frame 2: Press Space to activate
  let raw2 = @core.RawInput::with_events(
    @math.Vec2::new(10.0, 10.0),
    false,
    @math.Vec2::zero(),
    [@core.Event::Key(@core.Key::Space, true, @core.Modifiers::none())],
    "",
    @core.Modifiers::none(),
  )
  ctx.begin_frame(raw2)
  let (clicked, resp) = hyperlink(ctx, "Learn More", "https://moonbitlang.com")
  assert_true(ctx.input().is_key_consumed(@core.Key::Space))
  assert_true(clicked)
  assert_true(resp.has_focus() || ctx.has_focus(resp.id))
  let dl2 = ctx.end_frame()

  // Verify focus ring stroke in draw list
  let mut has_focus_ring = false
  for i = 0; i < dl2.len(); i = i + 1 {
    if dl2.get_command(i) is Some(@draw.DrawCmd::RectStroke(_)) {
      has_focus_ring = true
    }
  }
  assert_true(has_focus_ring)
}
