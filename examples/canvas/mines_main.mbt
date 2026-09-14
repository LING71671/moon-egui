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
/// Frame payload for the standalone minesweeper page (`minesweeper.html`).
pub struct MinesFrame {
  draw_list : @draw.DrawList
  revealed : Int
  flagged : Int
  hits : Int
  pending : Bool
  flag_mode : Bool
  cursor : String
  /// Tile under the pointer, so the host can print the cursor coordinate.
  tile_x : Int
  tile_y : Int
  /// Current tile size in pixels - drives the host's zoom readout.
  cell : Double
}

///|
struct MinesState {
  mut world : MineWorld
  mut cam_x : Double
  mut cam_y : Double
  mut cell : Double
  mut flag_mode : Bool
  mut prev_down : Bool
  mut prev_secondary : Bool
  mut gesture_flag : Bool
  mut drag_move : Bool
  mut inited : Bool
}

///|
/// Zoom bounds. MIN_CELL is also the legibility floor: a digit stops fitting
/// its tile below it, so gating the zoom at the same value means the board
/// can never reach an unreadable state (a blank white mass with no numbers).
const MIN_CELL : Double = 12.0

///|
const MAX_CELL : Double = 56.0

///|
/// Zoom the field starts at, and the unit the toolbar's zoom readout is a
/// percentage of.
const DEFAULT_CELL : Double = 22.0

///|
const ZOOM_STEP : Double = 1.2

///|
/// Zoom by `factor`, keeping the world point under (anchor_x, anchor_y) fixed.
/// The wheel gesture anchors at the pointer; the toolbar buttons anchor at the
/// centre of the viewport (there is no pointer to anchor on).
fn mines_zoom_about(
  st : MinesState,
  anchor_x : Double,
  anchor_y : Double,
  factor : Double,
) -> Unit {
  let old_cell = st.cell
  let scaled = old_cell * factor
  let new_cell = if scaled > MAX_CELL {
    MAX_CELL
  } else if scaled < MIN_CELL {
    MIN_CELL
  } else {
    scaled
  }
  if new_cell == old_cell {
    return
  }
  let wx = (anchor_x + st.cam_x) / old_cell
  let wy = (anchor_y + st.cam_y) / old_cell
  st.cell = new_cell
  st.cam_x = wx * new_cell - anchor_x
  st.cam_y = wy * new_cell - anchor_y
}

///|
/// Park the camera on the middle of the domain. The minefield only exists for
/// x, y >= 0, so anchoring on the origin put the domain's corner at the centre
/// of the screen and half the initial view was a mine-free void: no numbers,
/// no cascade, one tile per click - which read as "this board is empty, there
/// can't really be 100M mines".
///
/// Tiles are drawn at `t * cell - cam`, so placing tile DOMAIN_SIZE/2 at the
/// centre of the viewport means `cam = (DOMAIN_SIZE/2) * cell - vp/2`. Get the
/// sign wrong and the camera lands in the void again, one whole domain away.
fn mines_centre_camera(st : MinesState, vp_w : Double, vp_h : Double) -> Unit {
  let mid = DOMAIN_SIZE.to_double() * 0.5 * st.cell
  st.cam_x = mid - vp_w * 0.5
  st.cam_y = mid - vp_h * 0.5
}

///|
/// Number font, scaled with the tile so a digit always fits its cell.
fn mines_number_font(cell : Double) -> Double {
  let f = cell * 0.58
  if f < 9.0 {
    9.0
  } else if f > 15.0 {
    15.0
  } else {
    f
  }
}

///|
let mines_st : MinesState = {
  world: MineWorld::new(20260913UL),
  cam_x: -14.0,
  cam_y: -12.0,
  cell: 22.0,
  flag_mode: false,
  prev_down: false,
  prev_secondary: false,
  gesture_flag: false,
  drag_move: false,
  inited: false,
}

///|
let mines_ctx : @core.UIContext = @core.UIContext::new()

///|
fn mines_number_color(n : Int) -> @color.Color {
  if n == 1 {
    @color.Color::accent_primary()
  } else if n == 2 {
    @color.Color::success()
  } else if n == 3 {
    @color.Color::warning()
  } else if n == 4 {
    @color.Color::danger()
  } else if n <= 7 {
    @color.Color::text_strong()
  } else {
    @color.Color::text_secondary()
  }
}

///|
fn mines_next_seed(seed : UInt64) -> UInt64 {
  seed * 6364136223846793005UL + 1442695040888963407UL
}

///|
/// A flag tile: a mast with a pennant hanging off its top, pointing right.
/// The pennant is a filled right triangle drawn as horizontal bars (the
/// painter has no polygon primitive). The bar count tracks the cell size
/// instead of being fixed: with a fixed handful of bars the hypotenuse came
/// out as four visible treads, which at the top of the zoom range read as a
/// staircase rather than a flag. Every other coordinate is a fraction of the
/// cell, so the glyph holds its shape at any zoom.
fn mines_draw_flag(
  painter : @core.Painter,
  sx : Double,
  sy : Double,
  cell : Double,
) -> Unit {
  let raw_mast = cell * 0.075
  let mast_w = if raw_mast < 1.2 {
    1.2
  } else if raw_mast > 3.0 {
    3.0
  } else {
    raw_mast
  }
  let left = sx + cell * 0.28
  // mast: a hair-thin rounded bar, dark so it reads against the ground
  painter.add_rect(
    @math.Rect::new(left, sy + cell * 0.15, mast_w, cell * 0.70),
    @color.Color::text_secondary(),
    mast_w * 0.5,
  )
  let steps = (cell * 0.55).to_int()
  let steps = if steps < 6 { 6 } else if steps > 26 { 26 } else { steps }
  let height = cell * 0.42
  // Each bar overshoots its slice slightly so antialiasing cannot open a
  // hairline seam between two neighbouring bars.
  let bar = height / steps.to_double() + 0.6
  for k = 0; k < steps; k = k + 1 {
    let t = k.to_double() / steps.to_double()
    let w = cell * (0.46 - 0.40 * t)
    if w > 0.4 {
      painter.add_rect(
        @math.Rect::new(left + mast_w, sy + cell * 0.15 + height * t, w, bar),
        @color.Color::accent_primary(),
        0.0,
      )
    }
  }
}

///|
/// Per-frame entry point of the standalone minesweeper page. The host only
/// feeds pointer / wheel / button state - everything else (procedural board,
/// cascade, rendering) lives in this deterministic core.
pub fn mines_step(
  mouse_x : Double,
  mouse_y : Double,
  mouse_down : Bool,
  mouse_secondary_down : Bool,
  pan_dx : Double,
  pan_dy : Double,
  zoom_delta : Double,
  action_switch : Int,
  vp_w : Double,
  vp_h : Double,
) -> MinesFrame {
  let st = mines_st
  let raw = @core.RawInput::from_mouse(
    @math.Vec2::new(mouse_x, mouse_y),
    mouse_down,
    mouse_secondary_down~,
  )
  mines_ctx.begin_frame(raw)

  if !st.inited {
    st.inited = true
    // Camera is in PIXELS: world tile t renders at t * cell - cam, so the
    // inverse map for hit testing is (screen + cam) / cell. Both sides must
    // agree or clicks land off the tile they visually target.
    mines_centre_camera(st, vp_w, vp_h)
  }

  // 1. HTML controls -> world actions
  if action_switch == 0 {
    st.world = MineWorld::new(mines_next_seed(st.world.seed()))
  }
  if action_switch == 1 {
    st.flag_mode = !st.flag_mode
  }
  // Toolbar zoom: 2 = in, 3 = out, 4 = back to DEFAULT_CELL, 5 = recentre.
  // Buttons have no pointer to anchor on, so they zoom about the middle of
  // the viewport.
  if action_switch == 2 || action_switch == 3 {
    let factor = if action_switch == 2 { ZOOM_STEP } else { 1.0 / ZOOM_STEP }
    mines_zoom_about(st, vp_w * 0.5, vp_h * 0.5, factor)
  }
  if action_switch == 4 {
    mines_zoom_about(st, vp_w * 0.5, vp_h * 0.5, DEFAULT_CELL / st.cell)
  }
  if action_switch == 5 {
    mines_centre_camera(st, vp_w, vp_h)
  }

  // 2. camera: pan + zoom anchored at the pointer
  st.cam_x = st.cam_x - pan_dx
  st.cam_y = st.cam_y - pan_dy
  let pressed = mouse_down && !st.prev_down
  let released = !mouse_down && st.prev_down
  let secondary_pressed = mouse_secondary_down && !st.prev_secondary
  let secondary_released = !mouse_secondary_down && st.prev_secondary
  if pressed || secondary_pressed {
    st.drag_move = false
    st.gesture_flag = st.flag_mode || mouse_secondary_down
  }
  // The right button plants a flag the moment it goes down (no right-drag
  // gesture exists, so there is nothing to disambiguate).
  if secondary_pressed && !st.drag_move {
    let wx = (mouse_x + st.cam_x) / st.cell
    let wy = (mouse_y + st.cam_y) / st.cell
    st.world.toggle_flag(wx.floor().to_int(), wy.floor().to_int())
  }
  if mouse_down && (pan_dx != 0.0 || pan_dy != 0.0) {
    st.drag_move = true
  }
  if zoom_delta != 0.0 {
    // wheel zoom anchors on the pointer, so the tile under the cursor stays put
    let factor = if zoom_delta > 0.0 { ZOOM_STEP } else { 1.0 / ZOOM_STEP }
    mines_zoom_about(st, mouse_x, mouse_y, factor)
  }

  // 3. click resolution on release (a dragged gesture is a pan, not a click)
  let world = st.world
  let tx = ((mouse_x + st.cam_x) / st.cell).floor().to_int()
  let ty = ((mouse_y + st.cam_y) / st.cell).floor().to_int()
  // Pointer feedback: digging feels live only if the unopened earth says
  // "clickable". The pointer leaves the canvas as a far-out sentinel rather
  // than a flag, so it has to be range-checked - otherwise the off-canvas
  // sentinel lands on some unopened tile out in the void and the cursor keeps
  // claiming "pointer" while the mouse is nowhere near the board.
  let inside = mouse_x >= 0.0 &&
    mouse_y >= 0.0 &&
    mouse_x <= vp_w &&
    mouse_y <= vp_h
  let cursor = if !inside {
    "default"
  } else if !world.is_revealed(tx, ty) {
    "pointer"
  } else {
    "default"
  }
  // Left gesture: release reveals - or flags while the flag mode is on
  if released && !st.drag_move {
    let cx = ((mouse_x + st.cam_x) / st.cell).floor().to_int()
    let cy = ((mouse_y + st.cam_y) / st.cell).floor().to_int()
    if st.gesture_flag {
      world.toggle_flag(cx, cy)
    } else {
      world.reveal(cx, cy)
    }
  }
  if released || secondary_released {
    st.drag_move = false
  }
  st.prev_down = mouse_down
  st.prev_secondary = mouse_secondary_down

  // 4. advance the animated cascade
  let _ = world.pump(8000)

  // 5. render the visible window of the board
  let painter = mines_ctx.painter()
  // The backdrop is the seam between tiles, not the tile itself: every
  // unopened tile then paints over it one pixel short, so the backdrop is
  // what shows through as a hairline grid. Painting the tiles themselves was
  // the point - an untouched field is ~99% unopened at this zoom, and with
  // no seams it read as one blank grey slab.
  painter.add_rect(
    @math.Rect::new(0.0, 0.0, vp_w, vp_h),
    @color.Color::mines_grid(),
    0.0,
  )
  let cell = st.cell
  let col0 = (st.cam_x / cell).floor().to_int()
  let row0 = (st.cam_y / cell).floor().to_int()
  let cols = (vp_w / cell).to_int() + 2
  let rows = (vp_h / cell).to_int() + 2
  // Everything below the legibility floor is unreachable (the zoom clamps at
  // MIN_CELL), so numbers, flags and the hover tile are drawn on every frame
  // instead of being switched off by a level-of-detail test. A zoomed-out
  // board stays readable instead of turning into a blank white mass.
  let num_font = mines_number_font(cell)
  for r = row0; r < row0 + rows; r = r + 1 {
    for c = col0; c < col0 + cols; c = c + 1 {
      let sx = c.to_double() * cell - st.cam_x
      let sy = r.to_double() * cell - st.cam_y
      let tile = @math.Rect::new(sx, sy, cell - 1.0, cell - 1.0)
      if world.is_revealed(c, r) {
        painter.add_rect(tile, @color.Color::bg_window(), 0.0)
        if world.is_mine(c, r) {
          painter.add_rect(tile, @color.Color::danger(), 0.0)
          painter.add_line(
            @math.Vec2::new(sx + cell * 0.3, sy + cell * 0.3),
            @math.Vec2::new(sx + cell * 0.7, sy + cell * 0.7),
            @color.Color::bg_window(),
            1.5,
          )
          painter.add_line(
            @math.Vec2::new(sx + cell * 0.7, sy + cell * 0.3),
            @math.Vec2::new(sx + cell * 0.3, sy + cell * 0.7),
            @color.Color::bg_window(),
            1.5,
          )
        } else {
          let adj = world.adjacent(c, r)
          if adj > 0 {
            let label = adj.to_string()
            let ty = sy + (cell - num_font) * 0.5
            let tx = sx +
              (cell - mines_ctx.measure_text(label, num_font).x) * 0.5
            painter.add_text(
              @math.Vec2::new(tx, ty),
              label,
              num_font,
              mines_number_color(adj),
              font_family="monospace",
            )
          }
        }
      } else {
        // Unopened tile. Drawn one pixel short of the cell so the grid
        // backdrop shows through as its seam; the pointer tile lifts to a
        // lighter earth tone that is still clearly not a dug-out pit.
        let is_hover = ((mouse_x + st.cam_x) / cell).floor().to_int() == c &&
          ((mouse_y + st.cam_y) / cell).floor().to_int() == r
        painter.add_rect(
          tile,
          if is_hover {
            @color.Color::mines_ground_hover()
          } else {
            @color.Color::mines_ground()
          },
          0.0,
        )
        if world.is_flagged(c, r) {
          mines_draw_flag(painter, sx, sy, cell)
        }
      }
    }
  }

  {
    draw_list: mines_ctx.end_frame(),
    revealed: world.revealed_count(),
    flagged: world.flagged_count(),
    hits: world.hits(),
    pending: world.is_cascade_pending(),
    flag_mode: st.flag_mode,
    cursor,
    tile_x: tx,
    tile_y: ty,
    cell: st.cell,
  }
}
