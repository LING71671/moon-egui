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
test "rich_text: mixed spans render text, code boxes, and links" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::from_mouse(@math.Vec2::new(-100.0, -100.0), false))

  let spans = [
    TextSpan::normal("Welcome to"),
    TextSpan::code("moon-egui"),
    TextSpan::bold("GUI framework."),
    TextSpan::link("Learn more", "https://moonbitlang.com"),
  ]

  let resp = ctx.rich_text("rt1", spans)
  let dl = ctx.end_frame()

  assert_eq(resp.clicked_url, None)
  assert_true(resp.resp.rect.w > 100.0)
  // code box (rect + stroke) + texts for words
  assert_true(dl.len() >= 6)
}

///|
test "rich_text: wraps words onto multiple lines when constrained" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::from_mouse(@math.Vec2::new(-100.0, -100.0), false))

  let spans = [
    TextSpan::normal(
      "This is a rather long sentence that must wrap onto multiple lines.",
    ),
  ]

  // Narrow width of 100.0 forces multiple lines
  let resp = ctx.rich_text("wrap_rt", spans, wrap_width=100.0)
  let _ = ctx.end_frame()

  assert_true(resp.resp.rect.h > 40.0) // at least 2 lines (line_h = 22.0)
}

///|
test "rich_text: clicking link span returns clicked_url" {
  let ctx = UIContext::new()

  // First check where the link appears
  ctx.begin_frame(RawInput::from_mouse(@math.Vec2::new(-100.0, -100.0), false))
  let spans = [TextSpan::link("ClickHere", "https://docs.moonbitlang.com")]
  let _ = ctx.rich_text("link_rt", spans)
  let _ = ctx.end_frame()

  // Click at (x = 20.0, y = 10.0)
  let raw = RawInput::from_mouse(@math.Vec2::new(20.0, 10.0), true)
  ctx.begin_frame(raw)
  let resp = ctx.rich_text("link_rt", spans)
  let _ = ctx.end_frame()

  assert_eq(resp.clicked_url, Some("https://docs.moonbitlang.com"))
}

///|
test "hyperlink: standalone link click detection" {
  let ctx = UIContext::new()

  // Click on the link
  let raw = RawInput::from_mouse(@math.Vec2::new(15.0, 10.0), true)
  ctx.begin_frame(raw)
  let (clicked, resp) = ctx.hyperlink("Documentation", "https://example.com")
  let _ = ctx.end_frame()

  assert_true(clicked)
  assert_true(resp.rect.w > 40.0)
}
