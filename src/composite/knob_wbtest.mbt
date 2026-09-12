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
test "composite: knob renders dial, track, label and readout" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::new())

  let (val, resp) = knob(
    ctx,
    "vol_knob",
    "VOLUME",
    0.75,
    min_val=0.0,
    max_val=1.0,
    unit="%",
  )
  let dl = ctx.end_frame()

  assert_eq(val, 0.75)
  assert_true(resp.rect.w > 40.0)
  assert_true(resp.rect.h > 40.0)
  assert_true(dl.len() > 5)
}

///|
test "composite: knob integer variant" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::new())

  let (val, _resp) = knob_int(
    ctx,
    "freq_knob",
    "FREQ",
    440,
    min_val=20,
    max_val=20000,
    step=10,
    unit="Hz",
  )
  let _ = ctx.end_frame()

  assert_eq(val, 440)
}

///|
test "composite: knob fluent builder and ref binding" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::new())

  let target = Ref(0.5)
  let k_ref = Knob::from_ref("k_bld", "PAN", target)
    .min(-1.0)
    .max(1.0)
    .bipolar(true)
  let resp = ctx.add(k_ref)
  let _ = ctx.end_frame()

  assert_eq(target.val, 0.5)
  assert_true(!resp.clicked())
}
