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
/// Density is expressed in permille (1..999). The threshold maps it onto the
/// upper 32 bits of the hash space.
fn mine_threshold(permille : Int) -> UInt64 {
  permille.to_uint64() * 4294967296UL / 1000UL
}

///|
/// One 64x64 tile of the world holding the revealed / flagged bitmaps.
/// Only touched tiles ever allocate - the board is effectively infinite.
struct MineChunk {
  revealed : Array[UInt64]
  flagged : Array[UInt64]
}

///|
/// Game lifecycle state.
pub(all) enum MineStatus {
  Playing
  Boom
} derive(Eq, Debug)

///|
/// Deterministic, effectively infinite minesweeper world.
///
/// Mine positions are derived from `mine_cell_hash(x, y, seed)`, so nothing
/// about the mines is stored: given the same seed and density every client
/// computes the exact same board, which is what makes the shared / replayable
/// variant nearly free to synchronise.
struct MineWorld {
  seed : UInt64
  threshold : UInt64
  chunks : Map[UInt64, MineChunk]
  mut queue : Array[(Int, Int)]
  mut queue_head : Int
  mut revealed_count : Int
  mut flagged_count : Int
  mut status : MineStatus
}

///|
/// Create a world from a seed and a mine density in permille (mines per
/// thousand tiles). 150 is a classic expert-ish density.
fn MineWorld::new(seed : UInt64, density_permille : Int) -> MineWorld {
  let density_permille = if density_permille < 1 {
    1
  } else if density_permille > 999 {
    999
  } else {
    density_permille
  }
  {
    seed,
    threshold: mine_threshold(density_permille),
    chunks: Map([], capacity=64),
    queue: [],
    queue_head: 0,
    revealed_count: 0,
    flagged_count: 0,
    status: Playing,
  }
}

///|
fn MineWorld::chunk(self : MineWorld, x : Int, y : Int) -> MineChunk {
  let key = (x.to_uint64() & 0xFFFFFFFF00000000UL) |
    (y.to_uint64() & 0xFFFFFFFFUL)
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
/// Is the tile at world coordinates (x, y) a mine? Pure - safe to call for
/// any coordinates, including negatives.
fn MineWorld::is_mine(self : MineWorld, x : Int, y : Int) -> Bool {
  // compare the upper 32 bits of the hash against the threshold
  mine_cell_hash(x, y, self.seed) >> 32 < self.threshold
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
fn MineWorld::reveal(self : MineWorld, x : Int, y : Int) -> Unit {
  if !(self.status is Playing) {
    return
  }
  if self.is_flagged(x, y) || self.is_revealed(x, y) {
    return
  }
  if self.is_mine(x, y) {
    self.status = Boom
    self.set_revealed(x, y)
    self.revealed_count = self.revealed_count + 1
    return
  }
  self.enqueue(x, y)
}

///|
fn MineWorld::enqueue(self : MineWorld, x : Int, y : Int) -> Unit {
  if !self.is_revealed(x, y) && !self.is_flagged(x, y) {
    self.queue.push((x, y))
  }
}

///|
/// Drain up to `budget` tiles from the cascade queue. Returns the number of
/// tiles revealed in this call - the caller pumps once per frame, which turns
/// a million-tile flood into an animated ripple instead of a freeze.
fn MineWorld::pump(self : MineWorld, budget : Int) -> Int {
  if !(self.status is Playing) {
    return 0
  }
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
  if !(self.status is Playing) || self.is_revealed(x, y) {
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
fn MineWorld::revealed_count(self : MineWorld) -> Int {
  self.revealed_count
}

///|
fn MineWorld::flagged_count(self : MineWorld) -> Int {
  self.flagged_count
}

///|
fn MineWorld::status(self : MineWorld) -> MineStatus {
  self.status
}

///|
fn MineWorld::is_cascade_pending(self : MineWorld) -> Bool {
  self.queue_head < self.queue.length()
}

///|
fn MineWorld::seed(self : MineWorld) -> UInt64 {
  self.seed
}
