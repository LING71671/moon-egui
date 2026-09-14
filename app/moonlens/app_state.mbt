// Copyright 2026 Ling71671
// MoonLens Application State Model

///|
pub struct AppState {
  mut dataset : Dataset
  mut search_query : String
  mut is_search_focused : Bool
  mut selected_col_idx : Int
  mut sort_col_idx : Int
  mut sort_ascending : Bool
  mut table_scroll_y : Double
  mut target_scroll_y : Double
  mut table_scroll_x : Double
  mut selected_row : Int
  mut active_dataset_id : Int
  mut active_tab : Int // 0: Grid, 1: Insights & Distribution
  col_widths : Array[Double]
  last_frame_time : Double
  fps : Double
  mut frame_count : Int
} derive(Eq, Debug)

///|
pub fn AppState::new() -> AppState {
  let initial_ds = load_server_logs_sample()
  let widths : Array[Double] = []
  for _ in initial_ds.columns {
    widths.push(140.0)
  }
  if widths.length() > 0 {
    widths[0] = 180.0 // timestamp
  }
  if widths.length() > 6 {
    widths[6] = 220.0 // endpoint
  }

  {
    dataset: initial_ds,
    search_query: "",
    is_search_focused: false,
    selected_col_idx: 4, // latency_ms by default
    sort_col_idx: -1,
    sort_ascending: true,
    table_scroll_y: 0.0,
    target_scroll_y: 0.0,
    table_scroll_x: 0.0,
    selected_row: 0,
    active_dataset_id: 0,
    active_tab: 0,
    col_widths: widths,
    last_frame_time: 0.0,
    fps: 60.0,
    frame_count: 0,
  }
}

///|
pub fn AppState::switch_dataset(self : AppState, dataset_id : Int) -> Unit {
  self.active_dataset_id = dataset_id
  self.dataset = match dataset_id {
    1 => load_sensor_telemetry_sample()
    2 => load_market_quotes_sample()
    3 => load_stress_benchmark_sample(10000)
    _ => load_server_logs_sample()
  }

  self.col_widths.clear()
  for _ in self.dataset.columns {
    self.col_widths.push(130.0)
  }
  if self.col_widths.length() > 0 {
    self.col_widths[0] = 160.0
  }

  self.selected_col_idx = if self.dataset.columns.length() > 1 { 1 } else { 0 }
  self.sort_col_idx = -1
  self.sort_ascending = true
  self.table_scroll_y = 0.0
  self.target_scroll_y = 0.0
  self.table_scroll_x = 0.0
  self.search_query = ""
  self.is_search_focused = false
  self.selected_row = 0
}

///|
pub fn AppState::apply_sort(self : AppState, col_idx : Int) -> Unit {
  if self.sort_col_idx == col_idx {
    self.sort_ascending = !self.sort_ascending
  } else {
    self.sort_col_idx = col_idx
    self.sort_ascending = true
  }
  self.dataset.sort_by_column(self.sort_col_idx, self.sort_ascending)
}

///|
pub fn AppState::apply_filter(self : AppState, query : String) -> Unit {
  self.search_query = query
  self.dataset.filter_global(query)
  if self.sort_col_idx >= 0 {
    self.dataset.sort_by_column(self.sort_col_idx, self.sort_ascending)
  }
  self.table_scroll_y = 0.0
  self.target_scroll_y = 0.0
  self.selected_row = 0
}
