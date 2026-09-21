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
test "window_manager: positions, stacking rank, and raising" {
  let wm = WindowManager::new()
  let win_a = Id::from_int(10)
  let win_b = Id::from_int(20)

  // Positions
  let fallback = @math.Vec2::new(100.0, 100.0)
  assert_eq(wm.get_pos(win_a, fallback), fallback)
  wm.set_pos(win_a, @math.Vec2::new(150.0, 200.0))
  assert_eq(wm.get_pos(win_a, fallback), @math.Vec2::new(150.0, 200.0))

  // Stacking z-rank
  let z_a = wm.window_z(win_a)
  let z_b = wm.window_z(win_b)
  assert_eq(z_a, 0)
  assert_eq(z_b, 1)

  // Raising win_a moves it to the top
  wm.raise_window(win_a)
  assert_eq(wm.window_z(win_b), 0)
  assert_eq(wm.window_z(win_a), 1)
}

///|
test "window_manager: occlusion detection and frame lifecycle" {
  let wm = WindowManager::new()
  let rect_top = @math.Rect::new(50.0, 50.0, 100.0, 100.0)

  // Record rect at z = 2
  wm.record_rect(rect_top, 2)

  // Begin new frame -> rect_top moves to prev_rects
  wm.begin_frame()

  // For main layer (active_z = -1), point inside rect_top is occluded
  wm.set_active_z(-1)
  assert_true(wm.is_occluded(@math.Vec2::new(75.0, 75.0)))
  // Point outside is not occluded
  assert_false(wm.is_occluded(@math.Vec2::new(200.0, 200.0)))

  // For window on top (active_z = 2), it is not occluded by itself
  wm.set_active_z(2)
  assert_false(wm.is_occluded(@math.Vec2::new(75.0, 75.0)))
}

///|
test "window_manager: prune_stale cleans batches, positions, and focus" {
  let wm = WindowManager::new()
  let win1 = Id::from_int(101)
  let win2 = Id::from_int(102)

  wm.set_pos(win1, @math.Vec2::new(10.0, 10.0))
  wm.set_pos(win2, @math.Vec2::new(20.0, 20.0))
  let _ = wm.window_z(win1)
  let _ = wm.window_z(win2)
  let batch1 = wm.batch(win1)
  let batch2 = wm.batch(win2)
  batch1.add_rect(
    @math.Rect::new(0.0, 0.0, 10.0, 10.0),
    @color.Color::white(),
    0.0,
  )
  batch2.add_rect(
    @math.Rect::new(0.0, 0.0, 20.0, 20.0),
    @color.Color::white(),
    0.0,
  )

  // Only win1 is drawn this frame
  wm.begin_frame()
  wm.mark_drawn(win1)
  wm.prune_stale()

  // win2 should be pruned from positions, focus, and batches
  let fallback = @math.Vec2::new(-1.0, -1.0)
  assert_eq(wm.get_pos(win1, fallback), @math.Vec2::new(10.0, 10.0))
  assert_eq(wm.get_pos(win2, fallback), fallback)

  let out_list = @draw.DrawList::new()
  wm.flush_to(out_list)
  assert_eq(out_list.len(), 1)
}
