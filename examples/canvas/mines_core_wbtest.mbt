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
test "mines: same seed produces the same board, different seed differs" {
  let a = MineWorld::new(987654321UL, 150)
  let b = MineWorld::new(987654321UL, 150)
  let c = MineWorld::new(12345UL, 150)
  let mut same = true
  let mut diff = false
  for y = 0; y < 30; y = y + 1 {
    for x = 0; x < 30; x = x + 1 {
      if a.is_mine(x, y) != b.is_mine(x, y) {
        same = false
      }
      if a.is_mine(x, y) != c.is_mine(x, y) {
        diff = true
      }
    }
  }
  assert_true(same)
  assert_true(diff)
}

///|
test "mines: sampled density tracks the configured permille" {
  let w = MineWorld::new(42UL, 150)
  let mut mines = 0
  for y = 0; y < 200; y = y + 1 {
    for x = 0; x < 100; x = x + 1 {
      if w.is_mine(x, y) {
        mines = mines + 1
      }
    }
  }
  // expected 3000 (15% of 20000); generous +/- 20% band keeps this stable
  assert_true(mines > 2400 && mines < 3600)
}

///|
/// Reference flood reveal computed straight from `is_mine` - independent of
/// the queue machinery under test.
fn reference_flood(w : MineWorld, sx : Int, sy : Int) -> Set[(Int, Int)] {
  let visited : Set[(Int, Int)] = Set([], capacity=64)
  if w.is_mine(sx, sy) {
    return visited
  }
  visited.add((sx, sy))
  let queue : Array[(Int, Int)] = [(sx, sy)]
  let mut head = 0
  while head < queue.length() {
    let (x, y) = queue[head]
    head = head + 1
    if w.adjacent(x, y) != 0 {
      continue
    }
    for dy = -1; dy <= 1; dy = dy + 1 {
      for dx = -1; dx <= 1; dx = dx + 1 {
        if dx == 0 && dy == 0 {
          continue
        }
        let nx = x + dx
        let ny = y + dy
        if !w.is_mine(nx, ny) && !visited.contains((nx, ny)) {
          visited.add((nx, ny))
          queue.push((nx, ny))
        }
      }
    }
  }
  visited
}

///|
test "mines: flood reveal matches the reference traversal" {
  let w = MineWorld::new(20260913UL, 156)
  let mut start : (Int, Int)? = None
  for y in 0..<60 {
    for x in 0..<60 {
      if !w.is_mine(x, y) && w.adjacent(x, y) == 0 {
        start = Some((x, y))
        break
      }
    }
    if start is Some(_) {
      break
    }
  }
  let (sx, sy) = match start {
    Some(p) => p
    None => (0, 0)
  }
  w.reveal(sx, sy)
  let _ = w.pump(1_000_000)
  let expected = reference_flood(w, sx, sy)
  assert_true(expected.length() > 0)
  assert_eq(w.revealed_count(), expected.length())
  for cell in expected {
    assert_true(w.is_revealed(cell.0, cell.1))
  }
  // no mines were revealed by the flood:
  // expected holds only safe tiles and the count matches exactly
}

///|
test "mines: pump budget spreads the cascade across frames" {
  let full = MineWorld::new(777UL, 140)
  let mut start : (Int, Int)? = None
  for y in 0..<60 {
    for x in 0..<60 {
      if !full.is_mine(x, y) && full.adjacent(x, y) == 0 {
        start = Some((x, y))
        break
      }
    }
    if start is Some(_) {
      break
    }
  }
  let (sx, sy) = match start {
    Some(p) => p
    None => (0, 0)
  }

  let stepwise = MineWorld::new(777UL, 140)
  stepwise.reveal(sx, sy)
  let mut frames = 0
  while stepwise.is_cascade_pending() && frames < 10_000 {
    let _ = stepwise.pump(3)
    frames = frames + 1
  }
  let all_at_once = MineWorld::new(777UL, 140)
  all_at_once.reveal(sx, sy)
  let _ = all_at_once.pump(1_000_000)
  assert_eq(stepwise.revealed_count(), all_at_once.revealed_count())
  assert_false(stepwise.is_cascade_pending())
}

///|
test "mines: flags block the cascade and survive re-planting" {
  let w = MineWorld::new(55UL, 120)
  let mut safe : (Int, Int)? = None
  for y in 0..<60 {
    for x in 0..<60 {
      if !w.is_mine(x, y) && w.adjacent(x, y) == 0 {
        safe = Some((x + 1, y + 1))
        break
      }
    }
    if safe is Some(_) {
      break
    }
  }
  let (fx, fy) = match safe {
    Some(p) => p
    None => (0, 0)
  }

  w.toggle_flag(fx, fy)
  assert_true(w.is_flagged(fx, fy))
  assert_eq(w.flagged_count(), 1)

  w.reveal(fx, fy)
  let _ = w.pump(1_000_000)
  // the flagged tile is never auto-revealed by the flood
  assert_false(w.is_revealed(fx, fy))

  // unflag, re-flag: counts stay consistent
  w.toggle_flag(fx, fy)
  assert_eq(w.flagged_count(), 0)
  w.toggle_flag(fx, fy)
  assert_eq(w.flagged_count(), 1)
}

///|
test "mines: revealing a mine marks it, counts a hit and the world goes on" {
  let w = MineWorld::new(2024UL, 200)
  let mut mine : (Int, Int)? = None
  let mut safe : (Int, Int)? = None
  for y = 0; y < 40; y = y + 1 {
    for x = 0; x < 40; x = x + 1 {
      if w.is_mine(x, y) {
        mine = Some((x, y))
      } else if w.adjacent(x, y) == 0 && safe is None {
        safe = Some((x, y))
      }
    }
  }
  let (mx, my) = match mine {
    Some(p) => p
    None => (0, 0)
  }
  w.reveal(mx, my)
  assert_eq(w.hits(), 1)
  assert_true(w.is_revealed(mx, my))

  // the world is still alive: a flood reveal afterwards works normally
  let (sx, sy) = match safe {
    Some(p) => p
    None => (0, 0)
  }
  w.reveal(sx, sy)
  let _ = w.pump(1_000_000)
  let expected = reference_flood(w, sx, sy)
  assert_eq(w.revealed_count(), expected.length() + 1)
  assert_eq(w.hits(), 1)
}

///|
test "mines: negative coordinates are first-class citizens" {
  let w = MineWorld::new(31337UL, 150)
  // deterministic across identical calls on negative tiles
  assert_eq(w.is_mine(-1, -1), w.is_mine(-1, -1))
  assert_eq(w.is_mine(-33, 12), w.is_mine(-33, 12))
  // and a reveal there just works
  w.reveal(-1, -1)
  let _ = w.pump(1_000_000)
  assert_true(w.revealed_count() >= 1)
}

///|
test "mines: density is clamped into the playable band" {
  let low = MineWorld::new(1UL, 0)
  let high = MineWorld::new(1UL, 5000)
  let mut low_mines = 0
  let mut high_mines = 0
  for y = 0; y < 50; y = y + 1 {
    for x = 0; x < 50; x = x + 1 {
      if low.is_mine(x, y) {
        low_mines = low_mines + 1
      }
      if high.is_mine(x, y) {
        high_mines = high_mines + 1
      }
    }
  }
  // clamped to 1 permille: ~2.5 expected in 2500 tiles
  assert_true(low_mines < 15)
  // clamped to 999 permille: only a handful of safe tiles remain
  assert_true(high_mines > 2400)
}
