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
      600.0, 400.0, false, false, 0.0, 0.0, 0.0, -1, 1200.0, 800.0,
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
  let _ = mines_step(0.0, 0.0, false, false, 0.0, 0.0, 0.0, -1, 1200.0, 800.0)

  // Press + release at the viewport center (world tile 0,0)
  let press = mines_step(
    600.0, 400.0, true, false, 0.0, 0.0, 0.0, -1, 1200.0, 800.0,
  )
  assert_true(press.draw_list.len() > 0)
  let release = mines_step(
    600.0, 400.0, false, false, 0.0, 0.0, 0.0, -1, 1200.0, 800.0,
  )
  assert_true(release.revealed >= 1)

  // Idle frames drain the cascade through the per-frame budget
  let settled = mines_drain(2000)
  assert_true(settled >= 1)
}

///|
test "mines_step: mines only count hits - the world cannot end" {
  let _ = mines_step(0.0, 0.0, false, false, 0.0, 0.0, 0.0, -1, 1200.0, 800.0)

  // Sweep a line of clicks across the field; every click lands, mines just
  // count hits, and the page keeps running (no game-over state exists).
  let mut clicks = 0
  let mut px = 360.0
  while px <= 840.0 {
    let press = mines_step(
      px, 400.0, true, false, 0.0, 0.0, 0.0, -1, 1200.0, 800.0,
    )
    assert_true(press.draw_list.len() > 0)
    let _ = mines_step(
      px, 400.0, false, false, 0.0, 0.0, 0.0, -1, 1200.0, 800.0,
    )
    let _ = mines_drain(200)
    clicks = clicks + 1
    px = px + 60.0
  }
  assert_true(clicks >= 8)
}

///|
fn mines_text_count(frame : MinesFrame) -> Int {
  let mut n = 0
  for i = 0; i < frame.draw_list.len(); i = i + 1 {
    match frame.draw_list.get_command(i) {
      Some(@draw.Text(_, _, _, _, _, _)) => n = n + 1
      _ => ()
    }
  }
  n
}

///|
fn mines_color_count(frame : MinesFrame, want : @color.Color) -> Int {
  let mut n = 0
  for i = 0; i < frame.draw_list.len(); i = i + 1 {
    match frame.draw_list.get_command(i) {
      Some(@draw.Rect(_, color, _)) => if color == want { n = n + 1 }
      _ => ()
    }
  }
  n
}

///|
test "mines_step: numbers and flag glyphs survive the far end of the zoom" {
  // The zoom clamps at MIN_CELL, which is also the legibility floor. Before
  // that, zooming out walked past a level-of-detail cutoff and the board
  // turned into a blank white mass - no numbers, no flags, no hover - which
  // is what the user reported as "it's all blank".
  let vw = 1200.0
  let vh = 800.0
  let _ = mines_step(0.0, 0.0, false, false, 0.0, 0.0, 0.0, -1, vw, vh)
  // action 0 rolls a fresh field so the assertions do not depend on test order
  let _ = mines_step(600.0, 400.0, false, false, 0.0, 0.0, 0.0, 0, vw, vh)
  for z = 0; z < 40; z = z + 1 {
    let _ = mines_step(600.0, 400.0, false, false, 0.0, 0.0, -1.0, -1, vw, vh)
  }

  // dig, drain, then look at the frame
  let _ = mines_step(600.0, 400.0, true, false, 0.0, 0.0, 0.0, -1, vw, vh)
  let _ = mines_step(600.0, 400.0, false, false, 0.0, 0.0, 0.0, -1, vw, vh)
  let mut frame = mines_step(
    600.0, 400.0, false, false, 0.0, 0.0, 0.0, -1, vw, vh,
  )
  let mut spins = 0
  while frame.pending && spins < 4000 {
    frame = mines_step(600.0, 400.0, false, false, 0.0, 0.0, 0.0, -1, vw, vh)
    spins = spins + 1
  }
  assert_true(frame.revealed > 1)
  assert_true(mines_text_count(frame) > 0)

  // a right-press must still paint the pennant at the minimum zoom
  let _ = mines_step(700.0, 300.0, false, true, 0.0, 0.0, 0.0, -1, vw, vh)
  let flagged = mines_step(700.0, 300.0, false, true, 0.0, 0.0, 0.0, -1, vw, vh)
  assert_true(flagged.flagged >= 1)
  assert_true(mines_color_count(flagged, @color.Color::accent_primary()) >= 4)
}

///|
test "mines_step: right button flags and the action switch re-rolls" {
  let _ = mines_step(0.0, 0.0, false, false, 0.0, 0.0, 0.0, -1, 1200.0, 800.0)

  // Action 0 first: the module-level state carries over between tests, so
  // start from a guaranteed-fresh field.
  let _ = mines_step(
    600.0, 400.0, false, false, 0.0, 0.0, 0.0, 0, 1200.0, 800.0,
  )

  // Right-press + right-release at a tile plants a flag
  let press = mines_step(
    600.0, 400.0, false, true, 0.0, 0.0, 0.0, -1, 1200.0, 800.0,
  )
  assert_eq(press.flagged, 1)
  let release = mines_step(
    600.0, 400.0, false, false, 0.0, 0.0, 0.0, -1, 1200.0, 800.0,
  )
  assert_eq(release.flagged, 1)

  // Action 0 rolls a fresh field: counters reset
  let fresh = mines_step(
    600.0, 400.0, false, false, 0.0, 0.0, 0.0, 0, 1200.0, 800.0,
  )
  assert_eq(fresh.revealed, 0)
  assert_eq(fresh.flagged, 0)

  // Action 1 toggles the flag mode
  let toggled = mines_step(
    600.0, 400.0, false, false, 0.0, 0.0, 0.0, 1, 1200.0, 800.0,
  )
  assert_true(toggled.flag_mode)
  let toggled_back = mines_step(
    600.0, 400.0, false, false, 0.0, 0.0, 0.0, 1, 1200.0, 800.0,
  )
  assert_false(toggled_back.flag_mode)
}
