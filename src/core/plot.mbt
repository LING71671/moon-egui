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
/// Component style descriptor for scientific plotting and charts.
pub struct PlotStyle {
  default_w : Double
  default_h : Double
  pad_left : Double
  pad_right : Double
  pad_top : Double
  pad_bottom : Double
  bar_chart_default_w : Double
  bar_chart_default_h : Double
  bar_chart_gap : Double
} derive(Eq, Debug)

///|
pub fn PlotStyle::default() -> PlotStyle {
  {
    default_w: 280.0,
    default_h: 150.0,
    pad_left: 38.0,
    pad_right: 14.0,
    pad_top: 14.0,
    pad_bottom: 24.0,
    bar_chart_default_w: 280.0,
    bar_chart_default_h: 150.0,
    bar_chart_gap: 8.0,
  }
}

///|
/// Single 2D data coordinate point for immediate-mode plotting.
pub struct PlotPoint {
  x : Double
  y : Double
} derive(Eq, Debug)

///|
/// Construct a 2D data point.
pub fn PlotPoint::new(x : Double, y : Double) -> PlotPoint {
  { x, y, }
}

///|
/// Representation style for a plotted data series.
pub enum PlotSeriesKind {
  Line
  Scatter
  Area
} derive(Eq, Debug)

///|
/// Named series of data points rendered on a coordinate canvas.
pub struct PlotSeries {
  name : String
  points : Array[PlotPoint]
  color : @color.Color
  kind : PlotSeriesKind
} derive(Eq, Debug)

///|
/// Construct a connected line series.
pub fn PlotSeries::line(
  name : String,
  points : Array[PlotPoint],
  color? : @color.Color = @color.Color::accent_primary(),
) -> PlotSeries {
  { name, points, color, kind: Line, }
}

///|
/// Construct a point marker scatter series.
pub fn PlotSeries::scatter(
  name : String,
  points : Array[PlotPoint],
  color? : @color.Color = @color.Color::accent_hover(),
) -> PlotSeries {
  { name, points, color, kind: Scatter, }
}

///|
/// Construct an area fill series with baseline shading.
pub fn PlotSeries::area(
  name : String,
  points : Array[PlotPoint],
  color? : @color.Color = @color.Color::accent_primary(),
) -> PlotSeries {
  { name, points, color, kind: Area, }
}

///|
fn format_coord_val(v : Double) -> String {
  let rounded = (v * 10.0).round() / 10.0
  let int_val = rounded.to_int()
  if (rounded - int_val.to_double()).abs() < 0.01 {
    int_val.to_string()
  } else {
    rounded.to_string()
  }
}

///|
/// Standalone 2D coordinate plot widget supporting fluent configuration.
pub struct Plot {
  id_salt : String
  series : Array[PlotSeries]
  size : @math.Vec2?
  show_grid : Bool
  show_crosshair : Bool
  show_legend : Bool
}

///|
/// Create a new 2D plot widget builder.
pub fn Plot::new(id_salt : String, series : Array[PlotSeries]) -> Plot {
  {
    id_salt,
    series,
    size: None,
    show_grid: true,
    show_crosshair: true,
    show_legend: true,
  }
}

///|
/// Override plot layout dimensions.
pub fn Plot::size(self : Plot, size : @math.Vec2) -> Plot {
  { ..self, size: Some(size), }
}

///|
/// Toggle background coordinate grid lines.
pub fn Plot::show_grid(self : Plot, show_grid : Bool) -> Plot {
  { ..self, show_grid, }
}

///|
/// Toggle interactive crosshair line and coordinate HUD tooltip.
pub fn Plot::show_crosshair(self : Plot, show_crosshair : Bool) -> Plot {
  { ..self, show_crosshair, }
}

///|
/// Toggle multi-series legend badges.
pub fn Plot::show_legend(self : Plot, show_legend : Bool) -> Plot {
  { ..self, show_legend, }
}

///|
/// Render the plot into the provided UIContext.
pub fn Plot::show(self : Plot, ctx : UIContext) -> (@math.Vec2?, Response) {
  match self.size {
    Some(s) =>
      ctx.plot(
        self.id_salt,
        self.series,
        size=s,
        show_grid=self.show_grid,
        show_crosshair=self.show_crosshair,
        show_legend=self.show_legend,
      )
    None =>
      ctx.plot(
        self.id_salt,
        self.series,
        show_grid=self.show_grid,
        show_crosshair=self.show_crosshair,
        show_legend=self.show_legend,
      )
  }
}

///|
/// Render an immediate-mode 2D coordinate plot with multi-series support,
/// automatic axis scaling, divide-by-zero protection, background grid,
/// scissor-clipped curve drawing, and interactive crosshair coordinates.
pub fn UIContext::plot(
  self : UIContext,
  id_salt : String,
  series : Array[PlotSeries],
  size? : @math.Vec2,
  show_grid? : Bool = true,
  show_crosshair? : Bool = true,
  show_legend? : Bool = true,
) -> (@math.Vec2?, Response) {
  let scale = self.style.scale
  let p_style = PlotStyle::default()
  let default_w = p_style.default_w * scale
  let default_h = p_style.default_h * scale
  let chosen_size = match size {
    Some(s) => s
    None => @math.Vec2::new(default_w, default_h)
  }

  self.push_id(id_salt)
  let (_id, rect, resp) = self.allocate_space(chosen_size)
  self.pop_id()

  let radius = self.style.radius_md * scale
  let pad_left = p_style.pad_left * scale
  let pad_right = p_style.pad_right * scale
  let pad_top = p_style.pad_top * scale
  let pad_bottom = p_style.pad_bottom * scale
  let font_sz = self.style.font_small * scale

  // 1. Draw Container Surface
  self.painter().add_rect(rect, @color.Color::bg_surface(), radius)
  self
  .painter()
  .add_rect_stroke(rect, @color.Color::border_muted(), 1.0, radius)

  // Inner Plot Coordinate Rect
  let plot_w = rect.w - pad_left - pad_right
  let plot_h = rect.h - pad_top - pad_bottom
  if plot_w <= 10.0 || plot_h <= 10.0 {
    return (None, resp)
  }
  let plot_rect = @math.Rect::new(
    rect.x + pad_left,
    rect.y + pad_top,
    plot_w,
    plot_h,
  )
  let plot_right = plot_rect.x + plot_rect.w
  let plot_bottom = plot_rect.y + plot_rect.h

  // 2. Compute Auto Bounds with Flat-Data Protection
  let mut min_x = 0.0
  let mut max_x = 1.0
  let mut min_y = 0.0
  let mut max_y = 1.0
  let mut first = true

  for s in series {
    for pt in s.points {
      if first {
        min_x = pt.x
        max_x = pt.x
        min_y = pt.y
        max_y = pt.y
        first = false
      } else {
        if pt.x < min_x {
          min_x = pt.x
        }
        if pt.x > max_x {
          max_x = pt.x
        }
        if pt.y < min_y {
          min_y = pt.y
        }
        if pt.y > max_y {
          max_y = pt.y
        }
      }
    }
  }

  if (max_x - min_x).abs() < 0.0001 {
    max_x = min_x + 1.0
  }
  if (max_y - min_y).abs() < 0.0001 {
    max_y = min_y + 1.0
  }

  let span_x = max_x - min_x
  let span_y = max_y - min_y

  // Helper coordinate mapper
  let map_data_to_screen = fn(pt : PlotPoint) -> @math.Vec2 {
    let norm_x = (pt.x - min_x) / span_x
    let norm_y = (pt.y - min_y) / span_y
    let sx = plot_rect.x + norm_x * plot_rect.w
    let sy = plot_bottom - norm_y * plot_rect.h
    @math.Vec2::new(sx, sy)
  }

  // 3. Grid Lines & Axis Ticks
  if show_grid {
    // 4 Horizontal lines
    let num_h_ticks = 4
    for i = 0; i <= num_h_ticks; i = i + 1 {
      let t = i.to_double() / num_h_ticks.to_double()
      let gy = plot_bottom - t * plot_rect.h
      self
      .painter()
      .add_line(
        @math.Vec2::new(plot_rect.x, gy),
        @math.Vec2::new(plot_right, gy),
        @color.Color::grid_line(),
        1.0,
      )

      let tick_val = min_y + t * span_y
      let label = format_coord_val(tick_val)
      let label_sz = self.measure_text(label, font_sz)
      self
      .painter()
      .add_text(
        @math.Vec2::new(
          plot_rect.x - label_sz.x - 4.0 * scale,
          gy - font_sz * 0.45,
        ),
        label,
        font_sz,
        @color.Color::text_muted(),
      )
    }

    // 4 Vertical lines
    let num_v_ticks = 4
    for i = 0; i <= num_v_ticks; i = i + 1 {
      let t = i.to_double() / num_v_ticks.to_double()
      let gx = plot_rect.x + t * plot_rect.w
      self
      .painter()
      .add_line(
        @math.Vec2::new(gx, plot_rect.y),
        @math.Vec2::new(gx, plot_bottom),
        @color.Color::grid_line(),
        1.0,
      )

      let tick_val = min_x + t * span_x
      let label = format_coord_val(tick_val)
      let label_sz = self.measure_text(label, font_sz)
      self
      .painter()
      .add_text(
        @math.Vec2::new(gx - label_sz.x * 0.5, plot_bottom + 4.0 * scale),
        label,
        font_sz,
        @color.Color::text_muted(),
      )
    }
  }

  // 4. Draw Plotted Series (Scissor Clipped)
  self.push_clip(plot_rect)

  for s in series {
    let pts = s.points
    let count = pts.length()
    if count == 0 {
      continue
    }

    match s.kind {
      Line => {
        let mut prev_screen = map_data_to_screen(pts[0])
        for i = 1; i < count; i = i + 1 {
          let curr_screen = map_data_to_screen(pts[i])
          self
          .painter()
          .add_line(prev_screen, curr_screen, s.color, 2.0 * scale)
          prev_screen = curr_screen
        }
      }
      Scatter => {
        let r = 3.5 * scale
        for i = 0; i < count; i = i + 1 {
          let pt_screen = map_data_to_screen(pts[i])
          self.painter().add_circle(pt_screen, r, s.color)
        }
      }
      Area => {
        let base_y = plot_bottom
        let mut prev_screen = map_data_to_screen(pts[0])
        for i = 1; i < count; i = i + 1 {
          let curr_screen = map_data_to_screen(pts[i])
          let p_top = if prev_screen.y < curr_screen.y {
            prev_screen.y
          } else {
            curr_screen.y
          }
          let seg_rect = @math.Rect::new(
            prev_screen.x,
            p_top,
            curr_screen.x - prev_screen.x,
            base_y - p_top,
          )
          self
          .painter()
          .add_linear_gradient(
            seg_rect,
            @math.Vec2::new(seg_rect.x, seg_rect.y),
            @math.Vec2::new(seg_rect.x, seg_rect.y + seg_rect.h),
            s.color.with_alpha(100),
            s.color.with_alpha(15),
            0.0,
          )
          self
          .painter()
          .add_line(prev_screen, curr_screen, s.color, 2.0 * scale)
          prev_screen = curr_screen
        }
      }
    }
  }

  self.pop_clip()

  // 4.5 Legend Rendering
  if show_legend && series.length() > 0 {
    let mut leg_x = plot_right - 8.0 * scale
    for i = series.length() - 1; i >= 0; i = i - 1 {
      let s = series[i]
      let name_sz = self.measure_text(s.name, font_sz)
      let leg_w = name_sz.x + 16.0 * scale
      leg_x = leg_x - leg_w
      let dot_r = 3.0 * scale
      let dot_center = @math.Vec2::new(
        leg_x + 5.0 * scale,
        plot_rect.y + 10.0 * scale,
      )
      self.painter().add_circle(dot_center, dot_r, s.color)
      self
      .painter()
      .add_text(
        @math.Vec2::new(leg_x + 12.0 * scale, plot_rect.y + 4.0 * scale),
        s.name,
        font_sz,
        @color.Color::text_muted(),
      )
      leg_x = leg_x - 8.0 * scale
    }
  }

  // 5. Interactive Crosshair & Tooltip Readout
  let mouse_pos = self.input.mouse_pos
  let is_hovered = plot_rect.contains(mouse_pos)
  let mut hovered_coord : @math.Vec2? = None

  if is_hovered && show_crosshair {
    hovered_coord = Some(
      @math.Vec2::new(
        min_x + (mouse_pos.x - plot_rect.x) / plot_rect.w * span_x,
        min_y + (plot_bottom - mouse_pos.y) / plot_rect.h * span_y,
      ),
    )

    // Vertical Hairline
    self
    .painter()
    .add_line(
      @math.Vec2::new(mouse_pos.x, plot_rect.y),
      @math.Vec2::new(mouse_pos.x, plot_bottom),
      @color.Color::plot_crosshair(),
      1.0,
    )
    // Horizontal Hairline
    self
    .painter()
    .add_line(
      @math.Vec2::new(plot_rect.x, mouse_pos.y),
      @math.Vec2::new(plot_right, mouse_pos.y),
      @color.Color::plot_crosshair(),
      1.0,
    )

    // Floating Coordinate Tooltip Badge
    let hx = hovered_coord.unwrap().x
    let hy = hovered_coord.unwrap().y
    let text = "(" + format_coord_val(hx) + ", " + format_coord_val(hy) + ")"
    let text_sz = self.measure_text(text, font_sz)
    let tip_pad_x = 6.0 * scale
    let tip_pad_y = 3.0 * scale
    let tip_w = text_sz.x + tip_pad_x * 2.0
    let tip_h = text_sz.y + tip_pad_y * 2.0
    let mut tip_x = mouse_pos.x + 8.0 * scale
    let mut tip_y = mouse_pos.y - tip_h - 6.0 * scale
    if tip_x + tip_w > plot_right {
      tip_x = mouse_pos.x - tip_w - 8.0 * scale
    }
    if tip_y < plot_rect.y {
      tip_y = mouse_pos.y + 8.0 * scale
    }
    let tip_rect = @math.Rect::new(tip_x, tip_y, tip_w, tip_h)
    let tip_radius = self.style.radius_sm * scale
    self.painter().add_rect(tip_rect, @color.Color::text_strong(), tip_radius)
    self
    .painter()
    .add_text(
      @math.Vec2::new(tip_x + tip_pad_x, tip_y + tip_pad_y),
      text,
      font_sz,
      @color.Color::text_inverse(),
    )
  }

  (hovered_coord, resp)
}

///|
/// Standalone categorical bar chart widget supporting fluent configuration.
pub struct BarChart {
  id_salt : String
  labels : Array[String]
  values : Array[Double]
  size : @math.Vec2?
  bar_color : @color.Color
}

///|
/// Create a new categorical bar chart builder.
pub fn BarChart::new(
  id_salt : String,
  labels : Array[String],
  values : Array[Double],
) -> BarChart {
  {
    id_salt,
    labels,
    values,
    size: None,
    bar_color: @color.Color::accent_primary(),
  }
}

///|
/// Override bar chart layout dimensions.
pub fn BarChart::size(self : BarChart, size : @math.Vec2) -> BarChart {
  { ..self, size: Some(size), }
}

///|
/// Set custom bar fill color.
pub fn BarChart::bar_color(
  self : BarChart,
  bar_color : @color.Color,
) -> BarChart {
  { ..self, bar_color, }
}

///|
/// Render the bar chart into the provided UIContext.
pub fn BarChart::show(self : BarChart, ctx : UIContext) -> (Int?, Response) {
  match self.size {
    Some(s) =>
      ctx.bar_chart(
        self.id_salt,
        self.labels,
        self.values,
        size=s,
        bar_color=self.bar_color,
      )
    None =>
      ctx.bar_chart(
        self.id_salt,
        self.labels,
        self.values,
        bar_color=self.bar_color,
      )
  }
}

///|
/// Render an immediate-mode categorical bar chart with automatic scaling,
/// category labels, hover highlights, and interactive bar indices.
pub fn UIContext::bar_chart(
  self : UIContext,
  id_salt : String,
  labels : Array[String],
  values : Array[Double],
  size? : @math.Vec2,
  bar_color? : @color.Color = @color.Color::accent_primary(),
) -> (Int?, Response) {
  let scale = self.style.scale
  let p_style = PlotStyle::default()
  let default_w = p_style.bar_chart_default_w * scale
  let default_h = p_style.bar_chart_default_h * scale
  let chosen_size = match size {
    Some(s) => s
    None => @math.Vec2::new(default_w, default_h)
  }

  self.push_id(id_salt)
  let (_id, rect, resp) = self.allocate_space(chosen_size)
  self.pop_id()

  let radius = self.style.radius_md * scale
  let pad_left = p_style.pad_left * scale
  let pad_right = p_style.pad_right * scale
  let pad_top = p_style.pad_top * scale
  let pad_bottom = p_style.pad_bottom * scale
  let font_sz = self.style.font_small * scale
  let gap = p_style.bar_chart_gap * scale

  // Container Surface
  self.painter().add_rect(rect, @color.Color::bg_surface(), radius)
  self
  .painter()
  .add_rect_stroke(rect, @color.Color::border_muted(), 1.0, radius)

  let count = values.length()
  if count == 0 {
    return (None, resp)
  }

  let plot_w = rect.w - pad_left - pad_right
  let plot_h = rect.h - pad_top - pad_bottom
  if plot_w <= 10.0 || plot_h <= 10.0 {
    return (None, resp)
  }
  let plot_rect = @math.Rect::new(
    rect.x + pad_left,
    rect.y + pad_top,
    plot_w,
    plot_h,
  )
  let plot_right = plot_rect.x + plot_rect.w
  let plot_bottom = plot_rect.y + plot_rect.h

  // Max value calculation
  let mut max_val = 1.0
  for v in values {
    if v > max_val {
      max_val = v
    }
  }

  // Draw Grid Lines (3 horizontal guidelines)
  let num_guidelines = 3
  for i = 0; i <= num_guidelines; i = i + 1 {
    let t = i.to_double() / num_guidelines.to_double()
    let gy = plot_bottom - t * plot_rect.h
    self
    .painter()
    .add_line(
      @math.Vec2::new(plot_rect.x, gy),
      @math.Vec2::new(plot_right, gy),
      @color.Color::grid_line(),
      1.0,
    )
    let val = t * max_val
    let label = format_coord_val(val)
    let label_sz = self.measure_text(label, font_sz)
    self
    .painter()
    .add_text(
      @math.Vec2::new(
        plot_rect.x - label_sz.x - 4.0 * scale,
        gy - font_sz * 0.45,
      ),
      label,
      font_sz,
      @color.Color::text_muted(),
    )
  }

  // Bar Layout
  let total_gap = gap * (count - 1).to_double()
  let bar_w = if total_gap < plot_w {
    (plot_w - total_gap) / count.to_double()
  } else {
    4.0 * scale
  }

  let mouse_pos = self.input.mouse_pos
  let mut hovered_idx : Int? = None

  for i = 0; i < count; i = i + 1 {
    let val = values[i]
    let norm_val = if max_val > 0.0 { val / max_val } else { 0.0 }
    let bar_h = norm_val * plot_rect.h
    let bx = plot_rect.x + i.to_double() * (bar_w + gap)
    let by = plot_bottom - bar_h
    let bar_rect = @math.Rect::new(bx, by, bar_w, bar_h)

    let is_bar_hovered = bar_rect.contains(mouse_pos)
    if is_bar_hovered {
      hovered_idx = Some(i)
      self.set_cursor_icon("pointer")
    }

    let col = if is_bar_hovered {
      @color.Color::accent_hover()
    } else {
      bar_color
    }

    let bar_radius = self.style.radius_sm * scale
    self.painter().add_rect(bar_rect, col, bar_radius)

    // Category Label
    if i < labels.length() {
      let lbl = labels[i]
      let lbl_sz = self.measure_text(lbl, font_sz)
      let lx = bx + (bar_w - lbl_sz.x) * 0.5
      let ly = plot_bottom + 4.0 * scale
      self
      .painter()
      .add_text(
        @math.Vec2::new(lx, ly),
        lbl,
        font_sz,
        @color.Color::text_secondary(),
      )
    }

    // Hover value tooltip badge on active bar
    if is_bar_hovered {
      let val_str = format_coord_val(val)
      let val_sz = self.measure_text(val_str, font_sz)
      let badge_pad_x = 6.0 * scale
      let badge_pad_y = 2.0 * scale
      let badge_w = val_sz.x + badge_pad_x * 2.0
      let badge_h = val_sz.y + badge_pad_y * 2.0
      let badge_x = bx + (bar_w - badge_w) * 0.5
      let badge_y = by - badge_h - 4.0 * scale
      let badge_rect = @math.Rect::new(badge_x, badge_y, badge_w, badge_h)
      self
      .painter()
      .add_rect(
        badge_rect,
        @color.Color::text_strong(),
        self.style.radius_sm * scale,
      )
      self
      .painter()
      .add_text(
        @math.Vec2::new(badge_x + badge_pad_x, badge_y + badge_pad_y),
        val_str,
        font_sz,
        @color.Color::text_inverse(),
      )
    }
  }

  (hovered_idx, resp)
}
