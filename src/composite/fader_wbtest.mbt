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
test "composite: fader renders channel, track and cap" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::new())

  let (val, resp) = fader(
    ctx,
    "master_fader",
    "MASTER",
    0.8,
    min_val=0.0,
    max_val=1.0,
    unit="dB",
  )
  let dl = ctx.end_frame()

  assert_eq(val, 0.8)
  assert_true(resp.rect.w >= 44.0)
  assert_true(resp.rect.h >= 150.0)
  assert_true(dl.len() > 5)
}

///|
test "composite: fader integer variant" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::new())

  let (val, _resp) = fader_int(
    ctx,
    "chan1_fader",
    "CH 1",
    50,
    min_val=0,
    max_val=100,
    unit="%",
  )
  let _ = ctx.end_frame()

  assert_eq(val, 50)
}

///|
test "composite: fader fluent builder and ref binding" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::new())

  let target = Ref(0.0)
  let f_ref = Fader::from_ref("f_bld", "GAIN", target)
    .min(-60.0)
    .max(12.0)
    .default_val(0.0)
  let resp = ctx.add(f_ref)
  let _ = ctx.end_frame()

  assert_eq(target.val, 0.0)
  assert_true(!resp.clicked())
}
