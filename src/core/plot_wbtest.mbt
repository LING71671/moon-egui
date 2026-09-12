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
test "plot_basic_and_flat_data_protection" {
  let ui = UIContext::new()
  ui.begin_frame(RawInput::new())

  // Flat data with identical values
  let pts = [PlotPoint::new(10.0, 50.0), PlotPoint::new(10.0, 50.0)]
  let s1 = PlotSeries::line("flat", pts)
  let (hover, resp) = ui.plot("flat_plot", [s1])

  assert_true(hover is None)
  assert_true(resp.rect.w > 0.0)
  assert_true(resp.rect.h > 0.0)

  let _ = ui.end_frame()
}

///|
test "plot_multi_series_and_crosshair_tracking" {
  let ui = UIContext::new()
  // Place mouse at (100.0, 50.0)
  let raw = RawInput::from_mouse(@math.Vec2::new(100.0, 50.0), false)
  ui.begin_frame(raw)

  let line_pts = [
    PlotPoint::new(0.0, 0.0),
    PlotPoint::new(50.0, 100.0),
    PlotPoint::new(100.0, 50.0),
  ]
  let scatter_pts = [PlotPoint::new(25.0, 75.0), PlotPoint::new(75.0, 25.0)]
  let area_pts = [
    PlotPoint::new(0.0, 10.0),
    PlotPoint::new(50.0, 30.0),
    PlotPoint::new(100.0, 20.0),
  ]

  let s_line = PlotSeries::line("Line", line_pts)
  let s_scatter = PlotSeries::scatter("Scatter", scatter_pts)
  let s_area = PlotSeries::area("Area", area_pts)

  let (hover, resp) = ui.plot(
    "multi_plot",
    [s_line, s_scatter, s_area],
    size=@math.Vec2::new(300.0, 200.0),
  )

  assert_true(resp.rect.w == 300.0)
  assert_true(resp.rect.h == 200.0)
  assert_true(hover is Some(_))
  if hover is Some(coord) {
    assert_true(coord.x >= 0.0 && coord.x <= 100.0)
    assert_true(coord.y >= 0.0 && coord.y <= 100.0)
  }

  let _ = ui.end_frame()
}

///|
test "bar_chart_layout_and_hover_interaction" {
  let ui = UIContext::new()
  let raw = RawInput::from_mouse(@math.Vec2::new(140.0, 80.0), false)
  ui.begin_frame(raw)

  let labels = ["Q1", "Q2", "Q3", "Q4"]
  let values = [120.0, 240.0, 180.0, 300.0]

  let (hover_bar, resp) = ui.bar_chart(
    "quarterly_bars",
    labels,
    values,
    size=@math.Vec2::new(280.0, 160.0),
  )

  assert_true(resp.rect.w == 280.0)
  assert_true(resp.rect.h == 160.0)
  assert_true(hover_bar is Some(_))

  let _ = ui.end_frame()
}
