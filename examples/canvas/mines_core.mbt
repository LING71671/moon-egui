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
/// The world is a bounded domain of DOMAIN_SIZE x DOMAIN_SIZE tiles holding
/// TARGET_MINES mines in total (the quantified identity of the shared field).
/// Outside the domain there are no mines at all.
pub const DOMAIN_SIZE = 25600

///|
pub const TARGET_MINES = 100_000_000

///|
/// Calibrated threshold: the domain contains EXACTLY TARGET_MINES mines at
/// this value (verified by the numpy calibration in scratch/calibrate.py,
/// cross-checkable via cmd/mines_calibrate). Never change it casually - it
/// is part of the quantified identity of the shared world.
pub const MINES_THRESHOLD = 655384180UL

///|
/// splitmix64 finalizer - the whole minefield derives from this hash, so the
/// board stores no mine data at all: a cell is a mine iff its hash falls
/// below the density threshold.
fn mine_mix64(z64 : UInt64) -> UInt64 {
  let mut z = z64
  z = z + 0x9E3779B97F4A7C15UL
  z = (z ^ (z >> 30)) * 0xBF58476D1CE4E5B9UL
  z = (z ^ (z >> 27)) * 0x94D049BB133111EBUL
  z ^ (z >> 31)
}

///|
fn mine_cell_hash(x : Int, y : Int, seed : UInt64) -> UInt64 {
  let hx = x.to_uint64() * 0x9E3779B97F4A7C15UL
  let hy = y.to_uint64() * 0xC2B2AE3D27D4EB4FUL
  mine_mix64(mine_mix64(hx ^ seed) + hy)
}

///|
/// One 64x64 tile of the world holding the revealed / flagged bitmaps.
/// Only touched tiles ever allocate - the board is effectively infinite.
struct MineChunk {
  revealed : Array[UInt64]
  flagged : Array[UInt64]
}

///|
/// Deterministic, effectively infinite minesweeper world.
///
/// Mine positions are derived from `mine_cell_hash(x, y, seed)`, so nothing
/// about the mines is stored: given the same seed and density every client
/// computes the exact same board, which is what makes the shared / replayable
/// variant nearly free to synchronise.
struct MineWorld {
  seed : UInt64
  chunks : Map[UInt64, MineChunk]
  mut queue : Array[(Int, Int)]
  mut queue_head : Int
  mut revealed_count : Int
  mut flagged_count : Int
  mut hits : Int
  /// The first reveal of a session. The 5x5 area around it is mine-free, so
  /// nobody's very first dig can hit anything.
  mut safe_origin : (Int, Int)?
}

///|
/// Create a world from a seed. The mine count is a property of the shared
/// domain (DOMAIN_SIZE x DOMAIN_SIZE, MINES_THRESHOLD), not a per-world knob.
fn MineWorld::new(seed : UInt64) -> MineWorld {
  {
    seed,
    chunks: Map([], capacity=64),
    queue: [],
    queue_head: 0,
    revealed_count: 0,
    flagged_count: 0,
    hits: 0,
    safe_origin: None,
  }
}

///|
fn MineWorld::chunk(self : MineWorld, x : Int, y : Int) -> MineChunk {
  // The key must carry the FULL x and enough y: the previous formulation
  // (x's high half | y's low half) dropped x's low 32 bits entirely, so
  // every positive x shared one key per y and revealed/flagged state
  // collided with a period of 64 tiles - clicking one tile also "opened"
  // the tile 64 columns over.
  let key = (x.to_uint64() << 32) | (y.to_uint64() & 0xFFFFFFFFUL)
  match self.chunks.get(key) {
    Some(c) => c
    None => {
      let c = { revealed: Array::make(64, 0UL), flagged: Array::make(64, 0UL), }
      self.chunks.set(key, c)
      c
    }
  }
}

///|
/// Is the tile at world coordinates (x, y) a mine? Pure with respect to the
/// world state (seed + first-reveal safe zone). Mines only exist inside the
/// domain, and never within the 5x5 area around the session's first reveal.
fn MineWorld::is_mine(self : MineWorld, x : Int, y : Int) -> Bool {
  if x < 0 || y < 0 || x >= DOMAIN_SIZE || y >= DOMAIN_SIZE {
    return false
  }
  match self.safe_origin {
    Some((fx, fy)) =>
      if (x - fx).abs() <= 2 && (y - fy).abs() <= 2 {
        return false
      }
    None => ()
  }
  // compare the upper 32 bits of the hash against the calibrated threshold
  mine_cell_hash(x, y, self.seed) >> 32 < MINES_THRESHOLD
}

///|
/// Number of mines in the 3x3 neighborhood of (x, y).
fn MineWorld::adjacent(self : MineWorld, x : Int, y : Int) -> Int {
  let mut n = 0
  for dy = -1; dy <= 1; dy = dy + 1 {
    for dx = -1; dx <= 1; dx = dx + 1 {
      if (dx != 0 || dy != 0) && self.is_mine(x + dx, y + dy) {
        n = n + 1
      }
    }
  }
  n
}

///|
fn MineWorld::is_revealed(self : MineWorld, x : Int, y : Int) -> Bool {
  let c = self.chunk(x, y)
  let word = y & 63
  let bit = x & 63
  ((c.revealed[word] >> bit) & 1UL) == 1UL
}

///|
fn MineWorld::set_revealed(self : MineWorld, x : Int, y : Int) -> Unit {
  let c = self.chunk(x, y)
  let word = y & 63
  let bit = x & 63
  c.revealed[word] = c.revealed[word] | (1UL << bit)
}

///|
fn MineWorld::is_flagged(self : MineWorld, x : Int, y : Int) -> Bool {
  let c = self.chunk(x, y)
  let word = y & 63
  let bit = x & 63
  ((c.flagged[word] >> bit) & 1UL) == 1UL
}

///|
fn MineWorld::set_flagged(
  self : MineWorld,
  x : Int,
  y : Int,
  value : Bool,
) -> Unit {
  let c = self.chunk(x, y)
  let word = y & 63
  let bit = x & 63
  if value {
    c.flagged[word] = c.flagged[word] | (1UL << bit)
  } else {
    c.flagged[word] = c.flagged[word] ^ (1UL << bit)
  }
}

///|
/// Left-click a tile: a mine ends the run, anything else enqueues the flood
/// reveal that `pump` then drains frame by frame.
/// Revealing a mine marks the tile and counts a hit - the world never ends.
/// This is a shared digging field, not a lose state.
fn MineWorld::reveal(self : MineWorld, x : Int, y : Int) -> Unit {
  if self.is_flagged(x, y) || self.is_revealed(x, y) {
    return
  }
  // First dig of a session: carve the 5x5 safe zone around it before any
  // mine classification happens, so the very first reveal can never hit.
  if self.safe_origin is None {
    self.safe_origin = Some((x, y))
  }
  if self.is_mine(x, y) {
    self.set_revealed(x, y)
    self.revealed_count = self.revealed_count + 1
    self.hits = self.hits + 1
    return
  }
  // Outside the domain a dig opens just the single tile - there are no
  // numbers or cascades in the void.
  if x < 0 || y < 0 || x >= DOMAIN_SIZE || y >= DOMAIN_SIZE {
    self.set_revealed(x, y)
    self.revealed_count = self.revealed_count + 1
    return
  }
  self.enqueue(x, y)
}

///|
/// Cascade tiles are queued here. The flood propagates ONLY inside the
/// domain: beyond its bounds there are no mines, so an unchecked flood would
/// pour into the infinite mine-free void and never terminate. Tiles outside
/// the domain can still be revealed individually, just never through a
/// cascade.
fn MineWorld::enqueue(self : MineWorld, x : Int, y : Int) -> Unit {
  if x >= 0 &&
    y >= 0 &&
    x < DOMAIN_SIZE &&
    y < DOMAIN_SIZE &&
    !self.is_revealed(x, y) &&
    !self.is_flagged(x, y) {
    self.queue.push((x, y))
  }
}

///|
/// Drain up to `budget` tiles from the cascade queue. Returns the number of
/// tiles revealed in this call - the caller pumps once per frame, which turns
/// a million-tile flood into an animated ripple instead of a freeze.
fn MineWorld::pump(self : MineWorld, budget : Int) -> Int {
  let mut processed = 0
  while processed < budget && self.queue_head < self.queue.length() {
    let (x, y) = self.queue[self.queue_head]
    self.queue_head = self.queue_head + 1
    if self.queue_head > 8192 && self.queue_head * 2 > self.queue.length() {
      let rest : Array[(Int, Int)] = []
      for i = self.queue_head; i < self.queue.length(); i = i + 1 {
        rest.push(self.queue[i])
      }
      self.queue = rest
      self.queue_head = 0
    }
    if self.is_revealed(x, y) {
      continue
    }
    self.set_revealed(x, y)
    self.revealed_count = self.revealed_count + 1
    processed = processed + 1
    if self.adjacent(x, y) == 0 {
      self.enqueue(x - 1, y - 1)
      self.enqueue(x, y - 1)
      self.enqueue(x + 1, y - 1)
      self.enqueue(x - 1, y)
      self.enqueue(x + 1, y)
      self.enqueue(x - 1, y + 1)
      self.enqueue(x, y + 1)
      self.enqueue(x + 1, y + 1)
    }
  }
  processed
}

///|
/// Right-click a tile: toggles the flag. Revealed tiles never take flags.
fn MineWorld::toggle_flag(self : MineWorld, x : Int, y : Int) -> Unit {
  if self.is_revealed(x, y) {
    return
  }
  let was = self.is_flagged(x, y)
  self.set_flagged(x, y, !was)
  self.flagged_count = if was {
    self.flagged_count - 1
  } else {
    self.flagged_count + 1
  }
}

///|
fn MineWorld::hits(self : MineWorld) -> Int {
  self.hits
}

///|
fn MineWorld::revealed_count(self : MineWorld) -> Int {
  self.revealed_count
}

///|
fn MineWorld::flagged_count(self : MineWorld) -> Int {
  self.flagged_count
}

///|

///|
fn MineWorld::is_cascade_pending(self : MineWorld) -> Bool {
  self.queue_head < self.queue.length()
}

///|
/// Raw hash classification without world state - the calibration tool and
/// the sampling test both count through this.
pub fn mines_is_mine_raw(x : Int, y : Int) -> Bool {
  x >= 0 &&
  y >= 0 &&
  x < DOMAIN_SIZE &&
  y < DOMAIN_SIZE &&
  mine_cell_hash(x, y, 20260913UL) >> 32 < MINES_THRESHOLD
}

///|
/// Count mines over the whole domain for a given threshold (calibration).
pub fn mines_count_for_threshold(threshold : UInt64) -> Int {
  let mut n = 0
  for y = 0; y < DOMAIN_SIZE; y = y + 1 {
    for x = 0; x < DOMAIN_SIZE; x = x + 1 {
      if mine_cell_hash(x, y, 20260913UL) >> 32 < threshold {
        n = n + 1
      }
    }
  }
  n
}

///|
/// Binary-search the smallest threshold whose domain holds at least
/// `target` mines. Runs once at development time (cmd/mines_calibrate).
pub fn mines_calibrate_threshold(target : Int) -> UInt64 {
  let mut lo = 1UL
  let mut hi = 0xFFFFFFFFUL
  // invariant: count(hi) >= target, count(lo) < target
  while lo + 1UL < hi {
    let mid = (lo + hi) >> 1
    if mines_count_for_threshold(mid) >= target {
      hi = mid
    } else {
      lo = mid
    }
  }
  hi
}

///|
fn MineWorld::seed(self : MineWorld) -> UInt64 {
  self.seed
}
