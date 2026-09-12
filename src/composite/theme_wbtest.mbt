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
test "composite: component style descriptors derive from foundation tokens" {
  let code_style = CodeEditorStyle::default()
  assert_eq(code_style.font_size, 12.5)
  assert_eq(code_style.gutter_w, 44.0)

  let plot_style = PlotStyle::default()
  assert_eq(plot_style.default_w, 280.0)
  assert_eq(plot_style.default_h, 150.0)

  let table_style = TableStyle::default()
  assert_eq(table_style.header_h, 32.0)
  assert_eq(table_style.row_h, 30.0)

  let fader_style = FaderStyle::default()
  assert_eq(fader_style.width, 44.0)
  assert_eq(fader_style.height, 150.0)

  let knob_style = KnobStyle::default()
  assert_eq(knob_style.radius, 20.0)
}
