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
  let a = MineWorld::new(987654321UL)
  let b = MineWorld::new(987654321UL)
  let c = MineWorld::new(12345UL)
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
test "mines: sampled strip density tracks the calibrated threshold" {
  // expected strip density = TARGET_MINES / DOMAIN_SIZE^2 (~152.6 permille);
  // a generous +/- 20% band keeps this stable without pinning the hash.
  // divide first: TARGET_MINES * 1000 would overflow Int32
  let expected = TARGET_MINES / (DOMAIN_SIZE * DOMAIN_SIZE / 1000)
  let mut mines = 0
  for y = 0; y < 200; y = y + 1 {
    for x = 0; x < 100; x = x + 1 {
      if mines_is_mine_raw(x, y) {
        mines = mines + 1
      }
    }
  }
  assert_true(mines * 5 > expected * 80 && mines * 5 < expected * 120)
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
        // mirror the engine: the reference flood also stops at the domain
        // bounds - outside there are no mines and the flood would never end
        let in_domain = nx >= 0 &&
          ny >= 0 &&
          nx < DOMAIN_SIZE &&
          ny < DOMAIN_SIZE
        if in_domain && !w.is_mine(nx, ny) && !visited.contains((nx, ny)) {
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
  let w = MineWorld::new(20260913UL)
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
  let full = MineWorld::new(777UL)
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

  let stepwise = MineWorld::new(777UL)
  stepwise.reveal(sx, sy)
  let mut frames = 0
  while stepwise.is_cascade_pending() && frames < 10_000 {
    let _ = stepwise.pump(3)
    frames = frames + 1
  }
  let all_at_once = MineWorld::new(777UL)
  all_at_once.reveal(sx, sy)
  let _ = all_at_once.pump(1_000_000)
  assert_eq(stepwise.revealed_count(), all_at_once.revealed_count())
  assert_false(stepwise.is_cascade_pending())
}

///|
test "mines: flags block the cascade and survive re-planting" {
  let w = MineWorld::new(55UL)
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
  let w = MineWorld::new(2024UL)
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
  // the very first dig of a session is protected, so open a harmless tile
  // far away first to establish the safe zone elsewhere
  w.reveal(1000, 1000)
  let _ = w.pump(1_000_000)
  let before = w.revealed_count()
  let safe_zone_hits = w.hits()
  // now stepping on a real mine counts a hit
  w.reveal(mx, my)
  assert_eq(w.hits(), safe_zone_hits + 1)
  assert_true(w.is_revealed(mx, my))

  // the world is still alive: a flood reveal afterwards works normally
  let (sx, sy) = match safe {
    Some(p) => p
    None => (0, 0)
  }
  w.reveal(sx, sy)
  let _ = w.pump(1_000_000)
  let expected = reference_flood(w, sx, sy)
  assert_eq(w.revealed_count(), before + expected.length() + 1)
  assert_eq(w.hits(), safe_zone_hits + 1)
}

///|
test "mines: outside the domain there are no mines, but digging works" {
  let w = MineWorld::new(31337UL)
  // the void beyond the domain is deterministic and mine-free
  assert_false(w.is_mine(-1, -1))
  assert_false(w.is_mine(-33, 12))
  assert_false(w.is_mine(DOMAIN_SIZE, 0))
  assert_false(w.is_mine(0, DOMAIN_SIZE + 5))
  // a reveal in the void opens that single tile - no cascade out there
  w.reveal(-1, -1)
  let _ = w.pump(1_000_000)
  assert_true(w.is_revealed(-1, -1))
  assert_eq(w.hits(), 0)
}

///|
test "mines: the first reveal of a session can never hit a mine" {
  // find a tile that is a raw mine and dig it FIRST - the 5x5 safe zone
  // carved by the first reveal must extinguish it
  let w = MineWorld::new(777UL)
  let mut raw_mine : (Int, Int)? = None
  for y = 0; y < 64 && raw_mine is None; y = y + 1 {
    for x = 0; x < 64; x = x + 1 {
      if mines_is_mine_raw(x, y) {
        raw_mine = Some((x, y))
        break
      }
    }
  }
  let (mx, my) = match raw_mine {
    Some(p) => p
    None => (0, 0)
  }
  assert_true(mines_is_mine_raw(mx, my)) // it was a mine before the dig
  w.reveal(mx, my)
  assert_eq(w.hits(), 0)
  let _ = w.pump(1_000_000)
  assert_true(w.is_revealed(mx, my))
  assert_false(w.is_mine(mx, my)) // extinguished by the safe zone
  // and the world keeps working normally afterwards
  let mut digs = 0
  for y = 100; y < 140; y = y + 1 {
    for x = 100; x < 140; x = x + 1 {
      if !w.is_revealed(x, y) && digs == 0 {
        w.reveal(x, y)
        digs = digs + 1
      }
    }
  }
  let _ = w.pump(1_000_000)
  assert_true(w.revealed_count() > 1)
}

///|
test "mines: revealed state does not collide across a 64-tile period" {
  let w = MineWorld::new(20260913UL)
  // dig at x=5 (a single tile in the void-free band; any safe tile works)
  let mut dug = false
  for y = 200; y < 240 && !dug; y = y + 1 {
    for x = 0; x < 64; x = x + 1 {
      if !w.is_mine(x, y) {
        w.reveal(x, y)
        dug = true
        break
      }
    }
  }
  let _ = w.pump(1_000_000)
  // every tile 64 / 128 columns over with the same x mod 64 must be untouched
  let mut collided = 0
  for y = 200; y < 240; y = y + 1 {
    for x2 = 64; x2 < 192; x2 = x2 + 1 {
      if w.is_revealed(x2, y) {
        collided = collided + 1
      }
    }
  }
  assert_eq(collided, 0)
  // and the revealed set is stable: the state lives in distinct chunks now
  assert_true(w.revealed_count() >= 1)
}
