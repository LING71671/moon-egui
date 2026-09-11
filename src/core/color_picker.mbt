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
/// Convert HSV color components (h in [0, 360], s in [0, 1], v in [0, 1]) to standard RGB.
pub fn hsv_to_rgb(h : Double, s : Double, v : Double) -> (Int, Int, Int) {
  let h_clamped = (h % 360.0 + 360.0) % 360.0
  let s_clamped = if s < 0.0 { 0.0 } else if s > 1.0 { 1.0 } else { s }
  let v_clamped = if v < 0.0 { 0.0 } else if v > 1.0 { 1.0 } else { v }

  let c = v_clamped * s_clamped
  let h_sector = h_clamped / 60.0
  let x = c * (1.0 - (h_sector % 2.0 - 1.0).abs())
  let m = v_clamped - c

  let (r1, g1, b1) = if h_sector < 1.0 {
    (c, x, 0.0)
  } else if h_sector < 2.0 {
    (x, c, 0.0)
  } else if h_sector < 3.0 {
    (0.0, c, x)
  } else if h_sector < 4.0 {
    (0.0, x, c)
  } else if h_sector < 5.0 {
    (x, 0.0, c)
  } else {
    (c, 0.0, x)
  }

  let r = ((r1 + m) * 255.0 + 0.5).to_int()
  let g = ((g1 + m) * 255.0 + 0.5).to_int()
  let b = ((b1 + m) * 255.0 + 0.5).to_int()
  (r, g, b)
}

///|
/// Convert RGB integer components (0..255) to HSV color representation.
pub fn rgb_to_hsv(r : Int, g : Int, b : Int) -> (Double, Double, Double) {
  let rf = r.to_double() / 255.0
  let gf = g.to_double() / 255.0
  let bf = b.to_double() / 255.0

  let cmax = if rf > gf {
    if rf > bf {
      rf
    } else {
      bf
    }
  } else if gf > bf {
    gf
  } else {
    bf
  }

  let cmin = if rf < gf {
    if rf < bf {
      rf
    } else {
      bf
    }
  } else if gf < bf {
    gf
  } else {
    bf
  }

  let delta = cmax - cmin
  let v = cmax
  let s = if cmax > 0.00001 { delta / cmax } else { 0.0 }

  let h = if delta < 0.00001 {
    0.0
  } else if cmax == rf {
    let mut val = 60.0 * ((gf - bf) / delta)
    if val < 0.0 {
      val = val + 360.0
    }
    val
  } else if cmax == gf {
    60.0 * ((bf - rf) / delta) + 120.0
  } else {
    60.0 * ((rf - gf) / delta) + 240.0
  }

  (h, s, v)
}

///|
fn hex_byte(val : Int) -> String {
  let hex_digits = "0123456789ABCDEF"
  let hi = (val >> 4) & 0xF
  let lo = val & 0xF
  let hi_s = hex_digits[hi:hi + 1].to_owned()
  let lo_s = hex_digits[lo:lo + 1].to_owned()
  hi_s + lo_s
}

///|
/// Render a full interactive 2D HSV color picker panel featuring a 2D sat/val square,
/// rainbow hue slider, alpha opacity slider, and dual-ring high-contrast grip.
pub fn UIContext::color_picker(
  self : UIContext,
  id_salt : String,
  color : @color.Color,
  show_alpha? : Bool = true,
) -> (@color.Color, Response) {
  let width = 180.0
  let height = if show_alpha { 230.0 } else { 206.0 }

  self.push_id(id_salt)
  let (_panel_id, rect, resp) = self.allocate_space(
    @math.Vec2::new(width, height),
  )
  self.pop_id()

  // Panel background card
  self.draw_list.add_rect(rect, @color.Color::bg_surface(), 8.0)
  self.draw_list.add_rect_stroke(rect, @color.Color::border_default(), 1.0, 8.0)

  let pad = 10.0
  let sq_x = rect.x + pad
  let sq_y = rect.y + pad
  let sq_w = rect.w - pad * 2.0
  let sq_h = 126.0
  let sq_rect = @math.Rect::new(sq_x, sq_y, sq_w, sq_h)

  let (init_h, init_s, init_v) = rgb_to_hsv(color.r, color.g, color.b)
  let mut h = init_h
  let mut s = init_s
  let mut v = init_v
  let mut a = color.a

  // 1. 2D Saturation/Value Area Interaction
  let sv_id = self.id_stack.derive_id("cp_sv::" + id_salt)
  let sv_hovered = sq_rect.contains(self.input.mouse_pos)
  if sv_hovered && self.input.mouse_pressed {
    self.set_active_id(sv_id)
  }

  if self.active_id == sv_id {
    self.set_wants_capture_mouse(true)
    if self.input.mouse_down {
      let raw_s = (self.input.mouse_pos.x - sq_x) / sq_w
      let raw_v = 1.0 - (self.input.mouse_pos.y - sq_y) / sq_h
      s = if raw_s < 0.0 { 0.0 } else if raw_s > 1.0 { 1.0 } else { raw_s }
      v = if raw_v < 0.0 { 0.0 } else if raw_v > 1.0 { 1.0 } else { raw_v }
    }
    if self.input.mouse_released {
      self.set_active_id(Id::zero())
    }
  }

  // Draw 2D Sat/Val Mesh
  let grid_x = 10
  let grid_y = 7
  let cell_w = sq_w / grid_x.to_double()
  let cell_h = sq_h / grid_y.to_double()

  for gx = 0; gx < grid_x; gx = gx + 1 {
    let cell_s = gx.to_double() / (grid_x - 1).to_double()
    for gy = 0; gy < grid_y; gy = gy + 1 {
      let cell_v = 1.0 - gy.to_double() / (grid_y - 1).to_double()
      let (cr, cg, cb) = hsv_to_rgb(h, cell_s, cell_v)
      let c_rect = @math.Rect::new(
        sq_x + gx.to_double() * cell_w,
        sq_y + gy.to_double() * cell_h,
        cell_w + 0.5,
        cell_h + 0.5,
      )
      self.draw_list.add_rect(c_rect, @color.Color::rgb(cr, cg, cb), 0.0)
    }
  }

  // Border outline for SV square
  self.draw_list.add_rect_stroke(
    sq_rect,
    @color.Color::border_muted(),
    1.0,
    4.0,
  )

  // Dual-ring cursor on SV area
  let cur_x = sq_x + s * sq_w
  let cur_y = sq_y + (1.0 - v) * sq_h
  let cur_center = @math.Vec2::new(cur_x, cur_y)
  self.draw_list.add_circle_stroke(cur_center, 5.0, @color.Color::white(), 1.6)
  self.draw_list.add_circle_stroke(cur_center, 3.5, @color.Color::black(), 1.2)

  // 2. Hue Rainbow Slider
  let hue_y = sq_y + sq_h + 8.0
  let hue_h = 12.0
  let hue_rect = @math.Rect::new(sq_x, hue_y, sq_w, hue_h)
  let hue_id = self.id_stack.derive_id("cp_hue::" + id_salt)

  let hue_hovered = hue_rect.contains(self.input.mouse_pos)
  if hue_hovered && self.input.mouse_pressed {
    self.set_active_id(hue_id)
  }

  if self.active_id == hue_id {
    self.set_wants_capture_mouse(true)
    if self.input.mouse_down {
      let raw_h = (self.input.mouse_pos.x - sq_x) / sq_w * 360.0
      h = if raw_h < 0.0 { 0.0 } else if raw_h > 360.0 { 360.0 } else { raw_h }
    }
    if self.input.mouse_released {
      self.set_active_id(Id::zero())
    }
  }

  // Draw Rainbow Slices
  let hue_steps = 24
  let hue_step_w = sq_w / hue_steps.to_double()
  for step = 0; step < hue_steps; step = step + 1 {
    let step_h = step.to_double() / hue_steps.to_double() * 360.0
    let (hr, hg, hb) = hsv_to_rgb(step_h, 1.0, 1.0)
    let slice_rect = @math.Rect::new(
      sq_x + step.to_double() * hue_step_w,
      hue_y,
      hue_step_w + 0.5,
      hue_h,
    )
    self.draw_list.add_rect(slice_rect, @color.Color::rgb(hr, hg, hb), 0.0)
  }
  self.draw_list.add_rect_stroke(
    hue_rect,
    @color.Color::border_muted(),
    1.0,
    3.0,
  )

  // Hue Slider Thumb
  let hue_thumb_x = sq_x + h / 360.0 * sq_w
  let hue_thumb_center = @math.Vec2::new(hue_thumb_x, hue_y + hue_h * 0.5)
  self.draw_list.add_circle(hue_thumb_center, 6.0, @color.Color::white())
  self.draw_list.add_circle_stroke(
    hue_thumb_center,
    6.0,
    @color.Color::border_default(),
    1.0,
  )

  // 3. Alpha Slider (Optional)
  if show_alpha {
    let alpha_y = hue_y + hue_h + 8.0
    let alpha_h = 12.0
    let alpha_rect = @math.Rect::new(sq_x, alpha_y, sq_w, alpha_h)
    let alpha_id = self.id_stack.derive_id("cp_alpha::" + id_salt)

    let alpha_hovered = alpha_rect.contains(self.input.mouse_pos)
    if alpha_hovered && self.input.mouse_pressed {
      self.set_active_id(alpha_id)
    }

    if self.active_id == alpha_id {
      self.set_wants_capture_mouse(true)
      if self.input.mouse_down {
        let raw_a = (self.input.mouse_pos.x - sq_x) / sq_w * 255.0
        let val_a = raw_a.to_int()
        a = if val_a < 0 { 0 } else if val_a > 255 { 255 } else { val_a }
      }
      if self.input.mouse_released {
        self.set_active_id(Id::zero())
      }
    }

    // Alpha Bar Background & Gradient
    self.draw_list.add_rect(alpha_rect, @color.Color::bg_subtle(), 3.0)
    let alpha_steps = 16
    let alpha_step_w = sq_w / alpha_steps.to_double()
    let (cur_r, cur_g, cur_b) = hsv_to_rgb(h, s, v)

    for step = 0; step < alpha_steps; step = step + 1 {
      let step_a = (step.to_double() / alpha_steps.to_double() * 255.0).to_int()
      let slice_rect = @math.Rect::new(
        sq_x + step.to_double() * alpha_step_w,
        alpha_y,
        alpha_step_w + 0.5,
        alpha_h,
      )
      self.draw_list.add_rect(
        slice_rect,
        @color.Color::rgba(cur_r, cur_g, cur_b, step_a),
        0.0,
      )
    }
    self.draw_list.add_rect_stroke(
      alpha_rect,
      @color.Color::border_muted(),
      1.0,
      3.0,
    )

    // Alpha Slider Thumb
    let alpha_thumb_x = sq_x + a.to_double() / 255.0 * sq_w
    let alpha_thumb_center = @math.Vec2::new(
      alpha_thumb_x,
      alpha_y + alpha_h * 0.5,
    )
    self.draw_list.add_circle(alpha_thumb_center, 6.0, @color.Color::white())
    self.draw_list.add_circle_stroke(
      alpha_thumb_center,
      6.0,
      @color.Color::border_default(),
      1.0,
    )
  }

  // 4. Color Swatch & Hex Display
  let (final_r, final_g, final_b) = hsv_to_rgb(h, s, v)
  let updated_color = @color.Color::rgba(final_r, final_g, final_b, a)

  let footer_y = if show_alpha {
    hue_y + hue_h + 8.0 + 12.0 + 8.0
  } else {
    hue_y + hue_h + 8.0
  }
  let swatch_rect = @math.Rect::new(sq_x, footer_y, 22.0, 22.0)
  self.draw_list.add_rect(swatch_rect, updated_color, 4.0)
  self.draw_list.add_rect_stroke(
    swatch_rect,
    @color.Color::border_default(),
    1.0,
    4.0,
  )

  let hex_text = if show_alpha {
    "#" +
    hex_byte(final_r) +
    hex_byte(final_g) +
    hex_byte(final_b) +
    hex_byte(a)
  } else {
    "#" + hex_byte(final_r) + hex_byte(final_g) + hex_byte(final_b)
  }

  let font_sz = self.style.font_small
  let hex_pos = @math.Vec2::new(sq_x + 30.0, footer_y + (22.0 - font_sz) * 0.5)
  self.draw_list.add_text(
    hex_pos,
    hex_text,
    font_sz,
    @color.Color::text_strong(),
  )

  (updated_color, resp)
}

///|
/// Render a compact color picker button which opens a floating popup color picker when clicked.
pub fn UIContext::color_picker_button(
  self : UIContext,
  id_salt : String,
  color : @color.Color,
  show_alpha? : Bool = true,
) -> (@color.Color, Response) {
  let font_sz = self.style.font_small
  let hex_text = if show_alpha {
    "#" +
    hex_byte(color.r) +
    hex_byte(color.g) +
    hex_byte(color.b) +
    hex_byte(color.a)
  } else {
    "#" + hex_byte(color.r) + hex_byte(color.g) + hex_byte(color.b)
  }

  let txt_sz = self.measure_text(hex_text, font_sz)
  let btn_w = 20.0 + 8.0 + txt_sz.x + 16.0
  let btn_h = 28.0

  self.push_id(id_salt)
  let (id, rect, resp) = self.allocate_space(@math.Vec2::new(btn_w, btn_h))
  self.pop_id()

  let is_hovered = self.is_hovered(rect)
  let btn_bg = if is_hovered {
    @color.Color::bg_hover()
  } else {
    @color.Color::bg_surface()
  }
  self.draw_list.add_rect(rect, btn_bg, 5.0)
  self.draw_list.add_rect_stroke(rect, @color.Color::border_default(), 1.0, 5.0)

  // Color Swatch Pill
  let swatch_rect = @math.Rect::new(rect.x + 6.0, rect.y + 6.0, 16.0, 16.0)
  self.draw_list.add_rect(swatch_rect, color, 3.0)
  self.draw_list.add_rect_stroke(
    swatch_rect,
    @color.Color::border_muted(),
    1.0,
    3.0,
  )

  // Hex Text
  let text_y = rect.y + (btn_h - font_sz) * 0.5
  self.draw_list.add_text(
    @math.Vec2::new(rect.x + 28.0, text_y),
    hex_text,
    font_sz,
    @color.Color::text_body(),
  )

  let is_open = self.open_combo_id == id
  let mut next_color = color

  if resp.clicked {
    if is_open {
      self.open_combo_id = Id::zero()
    } else {
      self.open_combo_id = id
    }
  }

  if is_open {
    self.begin_foreground()
    let popup_pos = @math.Vec2::new(rect.x, rect.y + btn_h + 4.0)
    let prev_cursor = self.cursor
    self.cursor = popup_pos
    let (c, _) = self.color_picker(id_salt + "::popup", color, show_alpha~)
    next_color = c
    self.cursor = prev_cursor
    self.end_foreground()

    if self.input.key_pressed(Key::Escape) {
      self.open_combo_id = Id::zero()
    }
  }

  (next_color, resp)
}
