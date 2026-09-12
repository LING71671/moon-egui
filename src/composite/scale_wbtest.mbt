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
test "knob: geometry follows the global scale" {
  // Scale 1.0 baseline
  let c1 = @core.UIContext::new()
  c1.begin_frame(@core.RawInput::new())
  let (_, r1) = Knob::new("k_scale_1", "GAIN", 0.5).show(c1)
  let _ = c1.end_frame()

  // Scale 2.0 must render the same knob, twice as large
  let c2 = @core.UIContext::new()
  c2.set_style(@core.WidgetStyle::default().scaled(2.0))
  c2.begin_frame(@core.RawInput::new())
  let (_, r2) = Knob::new("k_scale_2", "GAIN", 0.5).show(c2)
  let _ = c2.end_frame()

  assert_eq(r2.rect.w, r1.rect.w * 2.0)
  assert_eq(r2.rect.h, r1.rect.h * 2.0)
}

///|
test "color_picker: geometry follows the global scale" {
  let c1 = @core.UIContext::new()
  c1.begin_frame(@core.RawInput::new())
  let (_, r1) = color_picker(c1, "cp_scale_1", @color.Color::rgb(255, 0, 0))
  let _ = c1.end_frame()

  let c2 = @core.UIContext::new()
  c2.set_style(@core.WidgetStyle::default().scaled(2.0))
  c2.begin_frame(@core.RawInput::new())
  let (_, r2) = color_picker(c2, "cp_scale_2", @color.Color::rgb(255, 0, 0))
  let _ = c2.end_frame()

  assert_eq(r2.rect.w, r1.rect.w * 2.0)
  assert_eq(r2.rect.h, r1.rect.h * 2.0)
}

///|
test "color_picker: geometry follows the global scale without alpha" {
  let c1 = @core.UIContext::new()
  c1.begin_frame(@core.RawInput::new())
  let (_, r1) = color_picker(
    c1,
    "cp_scale_noalpha_1",
    @color.Color::rgb(0, 0, 255),
    show_alpha=false,
  )
  let _ = c1.end_frame()

  let c2 = @core.UIContext::new()
  c2.set_style(@core.WidgetStyle::default().scaled(2.0))
  c2.begin_frame(@core.RawInput::new())
  let (_, r2) = color_picker(
    c2,
    "cp_scale_noalpha_2",
    @color.Color::rgb(0, 0, 255),
    show_alpha=false,
  )
  let _ = c2.end_frame()

  assert_eq(r2.rect.h, r1.rect.h * 2.0)
}
