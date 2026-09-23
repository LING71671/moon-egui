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
