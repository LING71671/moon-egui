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
test "sparkline: fluent builders route into the rendered chart" {
  let ctx = @core.UIContext::new()
  ctx.begin_frame(
    @core.RawInput::from_mouse(@math.Vec2::new(-50.0, -50.0), false),
  )
  let (hovered, resp) = Sparkline::new("fluent_spark", [4.0, 9.0, 6.0, 12.0])
    .size(@math.Vec2::new(140.0, 44.0))
    .color(@color.Color::accent_primary())
    .fill(true)
    .show_hover(false)
    .show(ctx)
  let dl = ctx.end_frame()

  assert_eq(hovered, None)
  assert_eq(resp.rect.w, 140.0)
  assert_eq(resp.rect.h, 44.0)
  assert_true(dl.len() >= 8)
}

///|
test "fader: fluent builders render the configured channel" {
  let ctx = @core.UIContext::new()
  ctx.begin_frame(
    @core.RawInput::from_mouse(@math.Vec2::new(-50.0, -50.0), false),
  )
  let (val, resp) = Fader::new("fluent_fader", "GAIN", 0.6)
    .min(0.0)
    .max(1.0)
    .step(0.05)
    .default_val(0.25)
    .unit("dB")
    .show_ticks(true)
    .size(@math.Vec2::new(48.0, 160.0))
    .show(ctx)
  let dl = ctx.end_frame()

  assert_eq(val, 0.6)
  assert_eq(resp.rect.w, 48.0)
  assert_true(dl.len() > 10)
}

///|
test "knob: fluent builders include the bipolar sweep" {
  let ctx = @core.UIContext::new()
  ctx.begin_frame(
    @core.RawInput::from_mouse(@math.Vec2::new(-50.0, -50.0), false),
  )
  let (val, resp) = Knob::new("fluent_knob", "PAN", 0.25)
    .min(-1.0)
    .max(1.0)
    .step(0.05)
    .default_val(0.0)
    .unit("deg")
    .radius(24.0)
    .bipolar(true)
    .show(ctx)
  let dl = ctx.end_frame()

  assert_eq(val, 0.25)
  assert_true(resp.rect.w > 0.0)
  assert_true(dl.len() > 5)
}

///|
test "code_editor: builder options route to the sized editor" {
  let ctx = @core.UIContext::new()
  ctx.begin_frame(@core.RawInput::new())
  let (code, resp) = CodeEditor::new("fluent_ce", "let x = 1")
    .size(@math.Vec2::new(220.0, 110.0))
    .show_line_numbers(false)
    .read_only(true)
    .show(ctx)
  let _ = ctx.end_frame()

  assert_eq(code, "let x = 1")
  assert_eq(resp.rect.w, 220.0)
  assert_eq(resp.rect.h, 110.0)
}

///|
test "code_editor: the Ref binding variant renders and writes back" {
  let ctx = @core.UIContext::new()
  let target = Ref("fn main() {}")

  ctx.begin_frame(@core.RawInput::new())
  let resp = ctx.add(CodeEditor::from_ref("fluent_ce_ref", target))
  let _ = ctx.end_frame()

  assert_true(resp.rect.w > 0.0)
  assert_eq(target.val, "fn main() {}")
}
