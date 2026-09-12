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
test "layer_manager: scissor clip stack intersection" {
  let lm = LayerManager::new()
  assert_eq(lm.current_clip(), None)

  let clip1 = @math.Rect::new(0.0, 0.0, 200.0, 200.0)
  lm.push_clip(clip1)
  assert_eq(lm.current_clip(), Some(clip1))

  let clip2 = @math.Rect::new(50.0, 50.0, 200.0, 200.0)
  lm.push_clip(clip2)
  // Intersection of [0, 200] and [50, 250] is [50, 200] -> width=150, height=150
  let expected = @math.Rect::new(50.0, 50.0, 150.0, 150.0)
  assert_eq(lm.current_clip(), Some(expected))

  lm.pop_clip()
  assert_eq(lm.current_clip(), Some(clip1))

  lm.pop_clip()
  assert_eq(lm.current_clip(), None)
}

///|
test "layer_manager: foreground overlay and hover blocking lifecycle" {
  let lm = LayerManager::new()
  let block_rect = @math.Rect::new(100.0, 100.0, 50.0, 50.0)

  lm.block_hover(block_rect)
  // Not blocked in the same frame
  assert_false(lm.is_blocked_by_foreground(@math.Vec2::new(120.0, 120.0)))

  // Active in next frame
  lm.begin_frame()
  assert_true(lm.is_blocked_by_foreground(@math.Vec2::new(120.0, 120.0)))
  assert_false(lm.is_blocked_by_foreground(@math.Vec2::new(50.0, 50.0)))

  // Foreground mode switches draw list
  let clip = @math.Rect::new(10.0, 10.0, 100.0, 100.0)
  lm.push_clip(clip)
  lm.begin_foreground()
  assert_true(lm.is_foreground())
  assert_eq(lm.current_clip(), None) // clip suspended

  lm.end_foreground()
  assert_false(lm.is_foreground())
  assert_eq(lm.current_clip(), Some(clip)) // clip restored
}
