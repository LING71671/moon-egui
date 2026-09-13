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
fn mines_drain(frames : Int) -> Int {
  let mut last = -1
  let mut ticks = 0
  while ticks < frames {
    let f = mines_step(
      600.0, 400.0, false, false, 0.0, 0.0, 0.0, -1, 156, 1200.0, 800.0,
    )
    if f.revealed == last {
      return f.revealed
    }
    last = f.revealed
    ticks = ticks + 1
  }
  last
}

///|
test "mines_step: a click reveals tiles through the host contract" {
  // Frame 0 initializes the camera and the world
  let _ = mines_step(
    0.0, 0.0, false, false, 0.0, 0.0, 0.0, -1, 156, 1200.0, 800.0,
  )

  // Press + release at the viewport center (world tile 0,0)
  let press = mines_step(
    600.0, 400.0, true, false, 0.0, 0.0, 0.0, -1, 156, 1200.0, 800.0,
  )
  assert_true(press.draw_list.len() > 0)
  let release = mines_step(
    600.0, 400.0, false, false, 0.0, 0.0, 0.0, -1, 156, 1200.0, 800.0,
  )
  assert_true(release.revealed >= 1)

  // Idle frames drain the cascade through the per-frame budget
  let settled = mines_drain(2000)
  assert_true(settled >= 1)
}

///|
test "mines_step: mines only count hits - the world cannot end" {
  let _ = mines_step(
    0.0, 0.0, false, false, 0.0, 0.0, 0.0, -1, 156, 1200.0, 800.0,
  )

  // Sweep a line of clicks across the field; every click lands, mines just
  // count hits, and the page keeps running (no game-over state exists).
  let mut clicks = 0
  let mut px = 360.0
  while px <= 840.0 {
    let press = mines_step(
      px, 400.0, true, false, 0.0, 0.0, 0.0, -1, 156, 1200.0, 800.0,
    )
    assert_true(press.draw_list.len() > 0)
    let _ = mines_step(
      px, 400.0, false, false, 0.0, 0.0, 0.0, -1, 156, 1200.0, 800.0,
    )
    let _ = mines_drain(200)
    clicks = clicks + 1
    px = px + 60.0
  }
  assert_true(clicks >= 8)
}

///|
test "mines_step: right button flags and the action switch re-rolls" {
  let _ = mines_step(
    0.0, 0.0, false, false, 0.0, 0.0, 0.0, -1, 156, 1200.0, 800.0,
  )

  // Action 0 first: the module-level state carries over between tests, so
  // start from a guaranteed-fresh field.
  let _ = mines_step(
    600.0, 400.0, false, false, 0.0, 0.0, 0.0, 0, 156, 1200.0, 800.0,
  )

  // Right-press + right-release at a tile plants a flag
  let press = mines_step(
    600.0, 400.0, false, true, 0.0, 0.0, 0.0, -1, 156, 1200.0, 800.0,
  )
  assert_eq(press.flagged, 1)
  let release = mines_step(
    600.0, 400.0, false, false, 0.0, 0.0, 0.0, -1, 156, 1200.0, 800.0,
  )
  assert_eq(release.flagged, 1)

  // Action 0 rolls a fresh field: counters reset
  let fresh = mines_step(
    600.0, 400.0, false, false, 0.0, 0.0, 0.0, 0, 156, 1200.0, 800.0,
  )
  assert_eq(fresh.revealed, 0)
  assert_eq(fresh.flagged, 0)

  // Action 1 toggles the flag mode
  let toggled = mines_step(
    600.0, 400.0, false, false, 0.0, 0.0, 0.0, 1, 156, 1200.0, 800.0,
  )
  assert_true(toggled.flag_mode)
  let toggled_back = mines_step(
    600.0, 400.0, false, false, 0.0, 0.0, 0.0, 1, 156, 1200.0, 800.0,
  )
  assert_false(toggled_back.flag_mode)
}

///|
test "mines_step: density change re-rolls the field" {
  let _ = mines_step(
    0.0, 0.0, false, false, 0.0, 0.0, 0.0, -1, 156, 1200.0, 800.0,
  )
  let changed = mines_step(
    0.0, 0.0, false, false, 0.0, 0.0, 0.0, -1, 300, 1200.0, 800.0,
  )
  assert_eq(changed.density, 300)
}
