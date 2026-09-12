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
test "widgets: Label and Separator dispatch via ui.add" {
  let ctx = @core.UIContext::new()
  ctx.begin_frame(@core.RawInput::new())

  let resp_lbl = ctx.add(
    Label::new("Telemetry Active").color(@color.Color::accent_primary()),
  )
  assert_true(resp_lbl.rect.h > 10.0)

  let resp_sep = ctx.add(Separator::new())
  assert_true(resp_sep.rect.h > 0.0)

  let _ = ctx.end_frame()
}
