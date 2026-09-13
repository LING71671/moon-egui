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
  density : Int
  boom : Bool
  pending : Bool
  flag_mode : Bool
  cursor : String
}

///|
struct MinesState {
  mut world : MineWorld
  mut cam_x : Double
  mut cam_y : Double
  mut cell : Double
  mut density : Int
  mut flag_mode : Bool
  mut prev_down : Bool
  mut prev_secondary : Bool
  mut gesture_flag : Bool
  mut drag_move : Bool
  mut inited : Bool
}

///|
let mines_st : MinesState = {
  world: MineWorld::new(20260913UL, 156),
  cam_x: -14.0,
  cam_y: -12.0,
  cell: 22.0,
  density: 156,
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
  density_permille : Int,
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
    st.cam_x = -vp_w * 0.5 / st.cell
    st.cam_y = -vp_h * 0.5 / st.cell
  }

  // 1. HTML controls -> world actions
  if action_switch == 0 {
    st.world = MineWorld::new(mines_next_seed(st.world.seed()), st.density)
  }
  if action_switch == 1 {
    st.flag_mode = !st.flag_mode
  }
  let density_in = if density_permille < 1 {
    1
  } else if density_permille > 999 {
    999
  } else {
    density_permille
  }
  if density_in != st.density {
    st.density = density_in
    st.world = MineWorld::new(mines_next_seed(st.world.seed()), st.density)
  }

  // 2. camera: pan + zoom anchored at the pointer
  st.cam_x = st.cam_x - pan_dx
  st.cam_y = st.cam_y - pan_dy
  let pressed = mouse_down && !st.prev_down
  let released = !mouse_down && st.prev_down
  let secondary_pressed = mouse_secondary_down && !st.prev_secondary
  if pressed {
    st.drag_move = false
    st.gesture_flag = st.flag_mode || mouse_secondary_down
  }
  if mouse_down && (pan_dx != 0.0 || pan_dy != 0.0) {
    st.drag_move = true
  }
  if zoom_delta != 0.0 {
    let old_cell = st.cell
    let factor = if zoom_delta > 0.0 { 1.2 } else { 1.0 / 1.2 }
    let new_cell = if old_cell * factor > 56.0 {
      56.0
    } else if old_cell * factor < 8.0 {
      8.0
    } else {
      old_cell * factor
    }
    let wx = st.cam_x + mouse_x / old_cell
    let wy = st.cam_y + mouse_y / old_cell
    st.cell = new_cell
    st.cam_x = wx - mouse_x / new_cell
    st.cam_y = wy - mouse_y / new_cell
  }

  // 3. click resolution on release (a dragged gesture is a pan, not a click)
  let world = st.world
  let cursor = if world.status() is Playing {
    let tx = (st.cam_x + mouse_x / st.cell).floor().to_int()
    let ty = (st.cam_y + mouse_y / st.cell).floor().to_int()
    if !world.is_revealed(tx, ty) {
      "pointer"
    } else {
      "default"
    }
  } else {
    "default"
  }
  if released && !st.drag_move {
    let wx = st.cam_x + mouse_x / st.cell
    let wy = st.cam_y + mouse_y / st.cell
    let cx = wx.floor().to_int()
    let cy = wy.floor().to_int()
    if st.gesture_flag || secondary_pressed {
      world.toggle_flag(cx, cy)
    } else {
      world.reveal(cx, cy)
    }
  }
  if released {
    st.drag_move = false
  }
  st.prev_down = mouse_down
  st.prev_secondary = mouse_secondary_down

  // 4. advance the animated cascade
  let _ = world.pump(8000)

  // 5. render the visible window of the board (LOD: below 12px per tile the
  // unopened mass is drawn as a single background pass)
  let painter = mines_ctx.painter()
  painter.add_rect(
    @math.Rect::new(0.0, 0.0, vp_w, vp_h),
    @color.Color::bg_window(),
    0.0,
  )
  let cell = st.cell
  let lod_min = cell >= 12.0
  let col0 = (st.cam_x / cell).floor().to_int()
  let row0 = (st.cam_y / cell).floor().to_int()
  let cols = (vp_w / cell).to_int() + 2
  let rows = (vp_h / cell).to_int() + 2
  let num_font = if cell >= 18.0 {
    mines_ctx.style.font_normal
  } else if cell >= 12.0 {
    mines_ctx.style.font_small
  } else {
    mines_ctx.style.font_small
  }
  for r = row0; r < row0 + rows; r = r + 1 {
    for c = col0; c < col0 + cols; c = c + 1 {
      let sx = c.to_double() * cell - st.cam_x
      let sy = r.to_double() * cell - st.cam_y
      let tile = @math.Rect::new(sx, sy, cell - 1.0, cell - 1.0)
      if world.is_revealed(c, r) {
        painter.add_rect(tile, @color.Color::bg_window(), 0.0)
        if world.status() is Boom && world.is_mine(c, r) {
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
          if adj > 0 && lod_min {
            let ty = sy + (cell - num_font) * 0.5
            let tx = sx +
              (cell - mines_ctx.measure_text(adj.to_string(), num_font).x) * 0.5
            painter.add_text(
              @math.Vec2::new(tx, ty),
              adj.to_string(),
              num_font,
              mines_number_color(adj),
              font_family="monospace",
            )
          }
        }
      } else if lod_min {
        let is_hover = (mouse_x / cell).floor().to_int() == c &&
          (mouse_y / cell).floor().to_int() == r
        painter.add_rect(
          tile,
          if is_hover {
            @color.Color::bg_hover()
          } else {
            @color.Color::bg_subtle()
          },
          0.0,
        )
        if world.is_flagged(c, r) {
          let pole_x = sx + cell * 0.62
          painter.add_line(
            @math.Vec2::new(pole_x, sy + cell * 0.18),
            @math.Vec2::new(pole_x, sy + cell * 0.78),
            @color.Color::text_secondary(),
            1.2,
          )
          painter.add_line(
            @math.Vec2::new(sx + cell * 0.28, sy + cell * 0.2),
            @math.Vec2::new(pole_x, sy + cell * 0.4),
            @color.Color::accent_primary(),
            2.4,
          )
          painter.add_line(
            @math.Vec2::new(sx + cell * 0.28, sy + cell * 0.2),
            @math.Vec2::new(sx + cell * 0.28, sy + cell * 0.55),
            @color.Color::accent_primary(),
            2.4,
          )
        }
      }
    }
  }

  // 6. boom banner
  if world.status() is Boom {
    painter.add_rect(
      @math.Rect::new(0.0, vp_h - 64.0, vp_w, 40.0),
      @color.Color::bg_window(),
      mines_ctx.style.radius_md,
    )
    painter.add_text(
      @math.Vec2::new(16.0, vp_h - 64.0 + 13.0),
      "踩雷！点顶栏「新雷区」重开 — 已翻开区域保留",
      mines_ctx.style.font_normal,
      @color.Color::danger(),
    )
  }

  {
    draw_list: mines_ctx.end_frame(),
    revealed: world.revealed_count(),
    flagged: world.flagged_count(),
    density: st.density,
    boom: world.status() is Boom,
    pending: world.is_cascade_pending(),
    flag_mode: st.flag_mode,
    cursor,
  }
}
