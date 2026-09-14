// Copyright 2026 Ling71671
// MoonLens High-Scale Tabular Performance & Ingestion Benchmark Suite

///|
test "benchmark 10,000 rows ingestion and sorting" {
  let ds = load_stress_benchmark_sample(10000)
  assert_eq(ds.col_count(), 7)
  assert_eq(ds.raw_row_count(), 10000)
  assert_eq(ds.active_row_count(), 10000)

  // Verify column typing
  assert_eq(ds.columns[0].dtype, TypeString) // timestamp
  assert_eq(ds.columns[1].dtype, TypeString) // server_id
  assert_eq(ds.columns[2].dtype, TypeFloat) // cpu_usage
  assert_eq(ds.columns[3].dtype, TypeInt) // memory_mb
  assert_eq(ds.columns[4].dtype, TypeInt) // req_per_sec
  assert_eq(ds.columns[5].dtype, TypeString) // region
  assert_eq(ds.columns[6].dtype, TypeString) // status

  // Sort ascending by req_per_sec
  ds.sort_by_column(4, true)
  assert_eq(ds.active_row_count(), 10000)
  let first_rps = parse_double(ds.get_cell(0, 4)).unwrap()
  let last_rps = parse_double(ds.get_cell(9999, 4)).unwrap()
  assert_true(first_rps <= last_rps)

  // Sort descending by cpu_usage
  ds.sort_by_column(2, false)
  let highest_cpu = parse_double(ds.get_cell(0, 2)).unwrap()
  let lowest_cpu = parse_double(ds.get_cell(9999, 2)).unwrap()
  assert_true(highest_cpu >= lowest_cpu)

  // Filter by "CRITICAL"
  ds.filter_global("CRITICAL")
  let crit_count = ds.active_row_count()
  assert_true(crit_count > 0 && crit_count < 10000)
  for i = 0; i < crit_count && i < 20; i = i + 1 {
    assert_eq(ds.get_cell(i, 6), "CRITICAL")
  }

  // Clear filter
  ds.filter_global("")
  assert_eq(ds.active_row_count(), 10000)

  // Distribution histogram on 10,000 rows
  let buckets = compute_column_histogram(ds.columns[2], ds.row_indices, 24)
  assert_eq(buckets.length(), 24)
  let mut total_samples = 0
  for b in buckets {
    let (_, _, cnt) = b
    total_samples = total_samples + cnt
  }
  assert_eq(total_samples, 10000)
}

///|
test "benchmark 50,000 rows large-scale stress test" {
  // Generate 50,000 rows
  let ds = load_stress_benchmark_sample(50000)
  assert_eq(ds.raw_row_count(), 50000)
  assert_eq(ds.active_row_count(), 50000)

  // Sort 50,000 rows by memory_mb
  ds.sort_by_column(3, true)
  let min_mem = parse_double(ds.get_cell(0, 3)).unwrap()
  let max_mem = parse_double(ds.get_cell(49999, 3)).unwrap()
  assert_true(min_mem <= max_mem)

  // Search filter across all 50,000 rows x 7 columns (350,000 cells)
  ds.filter_global("ap-northeast")
  let ap_count = ds.active_row_count()
  assert_true(ap_count > 5000 && ap_count < 15000)

  // Slicing viewport rows 0..35 out of filtered set
  for r = 0; r < 35; r = r + 1 {
    let reg = ds.get_cell(r, 5)
    assert_eq(reg, "ap-northeast")
  }

  // 24-bucket histogram on 50,000 rows
  ds.reset_filter()
  let hist = compute_column_histogram(ds.columns[4], ds.row_indices, 24)
  assert_eq(hist.length(), 24)
  let mut sum_h = 0
  for b in hist {
    let (_, _, c) = b
    sum_h = sum_h + c
  }
  assert_eq(sum_h, 50000)
}
