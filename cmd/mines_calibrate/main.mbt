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
/// One-shot development tool: prints the smallest mine threshold whose
/// domain holds at least TARGET_MINES mines, plus the exact count at that
/// threshold. Paste the result into MINES_THRESHOLD in mines_core.mbt.
///
/// Run: moon run cmd/mines_calibrate --target js
fn main {
  let t = @canvas.mines_calibrate_threshold(100_000_000)
  let n = @canvas.mines_count_for_threshold(t)
  println("MINES_THRESHOLD = \{t}UL")
  println("exact count     = \{n}")
}
