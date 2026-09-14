// Copyright 2026 Ling71671
// Unit tests for MoonLens CSV & Tabular Engine

///|
test "csv parser basic and number parsing" {
  let raw = "id,name,score\n1,Alice,95.5\n2,Bob,82.0\n3,Charlie,91.0\n"
  let ds = parse_csv(raw, "test.csv")

  assert_eq(ds.col_count(), 3)
  assert_eq(ds.raw_row_count(), 3)
  assert_eq(ds.columns[0].dtype, TypeInt)
  assert_eq(ds.columns[1].dtype, TypeString)
  assert_eq(ds.columns[2].dtype, TypeFloat)

  assert_eq(ds.get_cell(0, 1), "Alice")
  assert_eq(ds.get_cell(1, 1), "Bob")
  assert_eq(ds.get_cell(2, 1), "Charlie")
}

///|
test "csv sorting by numeric column" {
  let raw = "name,score\nAlice,95.0\nBob,70.0\nCharlie,85.0\n"
  let ds = parse_csv(raw, "scores.csv")

  // Sort by score ascending
  ds.sort_by_column(1, true)
  assert_eq(ds.get_cell(0, 0), "Bob")
  assert_eq(ds.get_cell(1, 0), "Charlie")
  assert_eq(ds.get_cell(2, 0), "Alice")

  // Sort by score descending
  ds.sort_by_column(1, false)
  assert_eq(ds.get_cell(0, 0), "Alice")
  assert_eq(ds.get_cell(1, 0), "Charlie")
  assert_eq(ds.get_cell(2, 0), "Bob")
}

///|
test "csv global search filtering" {
  let raw = "city,country,population\nTokyo,Japan,37000000\nKyoto,Japan,1400000\nParis,France,2161000\n"
  let ds = parse_csv(raw, "cities.csv")

  ds.filter_global("Japan")
  assert_eq(ds.active_row_count(), 2)
  assert_eq(ds.get_cell(0, 0), "Tokyo")
  assert_eq(ds.get_cell(1, 0), "Kyoto")

  ds.filter_global("France")
  assert_eq(ds.active_row_count(), 1)
  assert_eq(ds.get_cell(0, 0), "Paris")

  ds.filter_global("")
  assert_eq(ds.active_row_count(), 3)
}

///|
test "histogram calculation" {
  let raw = "val\n10.0\n20.0\n30.0\n40.0\n50.0\n"
  let ds = parse_csv(raw, "hist.csv")
  let col = ds.columns[0]
  let buckets = compute_column_histogram(col, ds.row_indices, 5)

  assert_eq(buckets.length(), 5)
  let mut total = 0
  for b in buckets {
    let (_, _, cnt) = b
    total = total + cnt
  }
  assert_eq(total, 5)
}
