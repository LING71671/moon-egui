// Copyright 2026 Ling71671
// MoonLens High-Performance In-Memory Tabular Data & CSV Engine

///|
pub enum DataType {
  TypeInt
  TypeFloat
  TypeString
} derive(Eq, Debug)

///|
pub fn DataType::to_string(self : DataType) -> String {
  match self {
    TypeInt => "INT"
    TypeFloat => "FLOAT"
    TypeString => "STR"
  }
}

///|
pub struct Column {
  name : String
  dtype : DataType
  values : Array[String]
  num_values : Array[Double]
  min_val : Double
  max_val : Double
  mean_val : Double
  sum_val : Double
  valid_num_count : Int
} derive(Eq, Debug)

///|
pub fn Column::new(name : String, dtype : DataType) -> Column {
  {
    name,
    dtype,
    values: [],
    num_values: [],
    min_val: 0.0,
    max_val: 0.0,
    mean_val: 0.0,
    sum_val: 0.0,
    valid_num_count: 0,
  }
}

///|
pub struct Dataset {
  name : String
  columns : Array[Column]
  mut total_rows : Int
  // Filtered & sorted row index indirection mapping
  row_indices : Array[Int]
} derive(Eq, Debug)

///|
pub fn Dataset::new(name : String) -> Dataset {
  { name, columns: [], total_rows: 0, row_indices: [], }
}

///|
/// Returns the number of columns in the dataset
pub fn Dataset::col_count(self : Dataset) -> Int {
  self.columns.length()
}

///|
/// Returns the total raw row count
pub fn Dataset::raw_row_count(self : Dataset) -> Int {
  self.total_rows
}

///|
/// Returns the active filtered/view row count
pub fn Dataset::active_row_count(self : Dataset) -> Int {
  self.row_indices.length()
}

///|
/// Retrieves a cell value given active row index and column index
pub fn Dataset::get_cell(
  self : Dataset,
  active_row : Int,
  col_idx : Int,
) -> String {
  if col_idx < 0 || col_idx >= self.columns.length() {
    return ""
  }
  if active_row < 0 || active_row >= self.row_indices.length() {
    return ""
  }
  let actual_row = self.row_indices[active_row]
  let col = self.columns[col_idx]
  if actual_row < 0 || actual_row >= col.values.length() {
    return ""
  }
  col.values[actual_row]
}

///|
/// Resets active row indices to show all rows
pub fn Dataset::reset_filter(self : Dataset) -> Unit {
  self.row_indices.clear()
  for i = 0; i < self.total_rows; i = i + 1 {
    self.row_indices.push(i)
  }
}

///|
fn contains_ignore_case(haystack : String, needle_lower : String) -> Bool {
  let h_len = haystack.length()
  let n_len = needle_lower.length()
  if n_len == 0 {
    return true
  }
  if h_len < n_len {
    return false
  }
  let limit = h_len - n_len
  for i = 0; i <= limit; i = i + 1 {
    let mut matched = true
    for j = 0; j < n_len; j = j + 1 {
      let mut c1 = haystack[i + j].to_int()
      if c1 >= 'A'.to_int() && c1 <= 'Z'.to_int() {
        c1 = c1 + 32
      }
      let c2 = needle_lower[j].to_int()
      if c1 != c2 {
        matched = false
        break
      }
    }
    if matched {
      return true
    }
  }
  false
}

///|
/// Filters rows by global query across all columns (case-insensitive substring)
pub fn Dataset::filter_global(self : Dataset, query : String) -> Unit {
  if query.is_empty() {
    self.reset_filter()
    return
  }
  let q_lower = query.to_lower()
  self.row_indices.clear()

  for r = 0; r < self.total_rows; r = r + 1 {
    let mut matched = false
    for col in self.columns {
      if contains_ignore_case(col.values[r], q_lower) {
        matched = true
        break
      }
    }
    if matched {
      self.row_indices.push(r)
    }
  }
}

///|
/// Sorts the active row indices by a column (asc: true for ascending, false for descending)
pub fn Dataset::sort_by_column(
  self : Dataset,
  col_idx : Int,
  ascending : Bool,
) -> Unit {
  if col_idx < 0 || col_idx >= self.columns.length() {
    return
  }
  let col = self.columns[col_idx]
  let n = self.row_indices.length()
  if n <= 1 {
    return
  }

  quicksort_indices(
    self.row_indices,
    0,
    n - 1,
    col.dtype,
    col.values,
    col.num_values,
    ascending,
  )
}

///|
fn quicksort_indices(
  arr : Array[Int],
  low : Int,
  high : Int,
  dtype : DataType,
  str_vals : Array[String],
  num_vals : Array[Double],
  asc : Bool,
) -> Unit {
  if low < high {
    // Median-of-three or middle pivot swap to avoid O(N^2) on pre-sorted data
    let mid = low + (high - low) / 2
    let tmp = arr[mid]
    arr[mid] = arr[high]
    arr[high] = tmp

    let p = partition_indices(arr, low, high, dtype, str_vals, num_vals, asc)
    quicksort_indices(arr, low, p - 1, dtype, str_vals, num_vals, asc)
    quicksort_indices(arr, p + 1, high, dtype, str_vals, num_vals, asc)
  }
}

///|
fn compare_rows(
  r1 : Int,
  r2 : Int,
  dtype : DataType,
  str_vals : Array[String],
  num_vals : Array[Double],
) -> Int {
  match dtype {
    TypeInt | TypeFloat => {
      let v1 = num_vals[r1]
      let v2 = num_vals[r2]
      if v1 < v2 {
        -1
      } else if v1 > v2 {
        1
      } else {
        0
      }
    }
    TypeString => {
      let s1 = str_vals[r1]
      let s2 = str_vals[r2]
      if s1 < s2 {
        -1
      } else if s1 > s2 {
        1
      } else {
        0
      }
    }
  }
}

///|
fn partition_indices(
  arr : Array[Int],
  low : Int,
  high : Int,
  dtype : DataType,
  str_vals : Array[String],
  num_vals : Array[Double],
  asc : Bool,
) -> Int {
  let pivot_row = arr[high]
  let mut i = low - 1

  for j = low; j < high; j = j + 1 {
    let cmp = compare_rows(arr[j], pivot_row, dtype, str_vals, num_vals)
    let should_swap = if asc { cmp <= 0 } else { cmp >= 0 }
    if should_swap {
      i = i + 1
      let temp = arr[i]
      arr[i] = arr[j]
      arr[j] = temp
    }
  }

  let temp = arr[i + 1]
  arr[i + 1] = arr[high]
  arr[high] = temp
  i + 1
}

///|
/// Fast parser for double values
pub fn parse_double(s : String) -> Double? {
  if s.is_empty() {
    return None
  }
  let len = s.length()
  let mut i = 0
  let mut neg = false

  let first_code = s[0].to_int()
  if first_code == '-'.to_int() {
    neg = true
    i = 1
  } else if first_code == '+'.to_int() {
    i = 1
  }

  if i >= len {
    return None
  }

  let mut int_part = 0.0
  let mut has_digits = false
  while i < len {
    let code = s[i].to_int()
    if code >= '0'.to_int() && code <= '9'.to_int() {
      has_digits = true
      int_part = int_part * 10.0 + (code - '0'.to_int()).to_double()
      i = i + 1
    } else {
      break
    }
  }

  let mut frac_part = 0.0
  let mut frac_div = 1.0
  if i < len && s[i].to_int() == '.'.to_int() {
    i = i + 1
    while i < len {
      let code = s[i].to_int()
      if code >= '0'.to_int() && code <= '9'.to_int() {
        has_digits = true
        frac_div = frac_div * 10.0
        frac_part = frac_part + (code - '0'.to_int()).to_double() / frac_div
        i = i + 1
      } else {
        break
      }
    }
  }

  if !has_digits || i < len {
    return None
  }

  let total = int_part + frac_part
  Some(if neg { -total } else { total })
}

///|
fn is_integer_string(s : String) -> Bool {
  if s.is_empty() {
    return false
  }
  let mut start = 0
  let first_code = s[0].to_int()
  if first_code == '-'.to_int() || first_code == '+'.to_int() {
    start = 1
  }
  if start >= s.length() {
    return false
  }
  for i = start; i < s.length(); i = i + 1 {
    let code = s[i].to_int()
    if code < '0'.to_int() || code > '9'.to_int() {
      return false
    }
  }
  true
}

///|
fn split_lines(s : String) -> Array[String] {
  let res : Array[String] = []
  let mut start = 0
  let len = s.length()

  for i = 0; i < len; i = i + 1 {
    let code = s[i].to_int()
    if code == '\n'.to_int() {
      let mut end = i
      if end > start && s[end - 1].to_int() == '\r'.to_int() {
        end = end - 1
      }
      res.push(s[start:end].to_owned())
      start = i + 1
    }
  }
  if start < len {
    res.push(s[start:len].to_owned())
  }
  res
}

///|
fn extract_quoted_cell(line : String, start : Int, end : Int) -> String {
  let b = StringBuilder()
  let mut in_quotes = false
  let mut i = start
  while i < end {
    let code = line[i].to_int()
    if code == '"'.to_int() {
      if in_quotes && i + 1 < end && line[i + 1].to_int() == '"'.to_int() {
        b.write_char('"')
        i = i + 1
      } else {
        in_quotes = !in_quotes
      }
    } else {
      match code.to_char() {
        Some(c) => b.write_char(c)
        None => ()
      }
    }
    i = i + 1
  }
  b.to_string().trim().to_owned()
}

///|
fn split_row(line : String, sep_code : Int) -> Array[String] {
  let cells : Array[String] = []
  let len = line.length()
  let mut in_quotes = false
  let mut cell_start = 0
  let mut has_quotes = false

  for i = 0; i < len; i = i + 1 {
    let code = line[i].to_int()
    if code == '"'.to_int() {
      has_quotes = true
      in_quotes = !in_quotes
    } else if code == sep_code && !in_quotes {
      if !has_quotes {
        cells.push(line[cell_start:i].trim().to_owned())
      } else {
        cells.push(extract_quoted_cell(line, cell_start, i))
      }
      cell_start = i + 1
      has_quotes = false
    }
  }
  if cell_start <= len {
    if !has_quotes {
      cells.push(line[cell_start:len].trim().to_owned())
    } else {
      cells.push(extract_quoted_cell(line, cell_start, len))
    }
  }
  cells
}

///|
/// Parses a CSV / TSV text string into a structured Dataset
pub fn parse_csv(content : String, name : String) -> Dataset {
  let ds = Dataset::new(name)
  let lines = split_lines(content)
  if lines.is_empty() {
    return ds
  }

  let header_line = lines[0]
  let sep_code = if header_line.contains("\t") {
    '\t'.to_int()
  } else if header_line.contains(";") {
    ';'.to_int()
  } else {
    ','.to_int()
  }

  let headers = split_row(header_line, sep_code)
  if headers.is_empty() {
    return ds
  }

  let col_count = headers.length()
  let raw_cols : Array[Array[String]] = []
  for _ in headers {
    raw_cols.push([])
  }

  for r = 1; r < lines.length(); r = r + 1 {
    let line = lines[r].trim().to_owned()
    if line.is_empty() {
      continue
    }
    let cells = split_row(line, sep_code)
    for c = 0; c < col_count; c = c + 1 {
      let cell = if c < cells.length() { cells[c] } else { "" }
      raw_cols[c].push(cell)
    }
  }

  let parsed_row_count = if col_count > 0 { raw_cols[0].length() } else { 0 }
  ds.total_rows = parsed_row_count

  // Type inference & statistics
  for c = 0; c < col_count; c = c + 1 {
    let header_name = headers[c]
    let vals = raw_cols[c]

    let mut is_int = true
    let mut is_float = true
    let num_vals : Array[Double] = []
    let mut sum = 0.0
    let mut min_val = 1.0e30
    let mut max_val = -1.0e30
    let mut valid_count = 0

    for v in vals {
      let trimmed = v.trim().to_owned()
      if trimmed.is_empty() {
        num_vals.push(0.0)
        continue
      }

      match parse_double(trimmed) {
        Some(num) => {
          num_vals.push(num)
          sum = sum + num
          valid_count = valid_count + 1
          if num < min_val {
            min_val = num
          }
          if num > max_val {
            max_val = num
          }
          if is_int && !is_integer_string(trimmed) {
            is_int = false
          }
        }
        None => {
          is_int = false
          is_float = false
          num_vals.push(0.0)
        }
      }
    }

    let dtype = if valid_count > 0 && is_int {
      TypeInt
    } else if valid_count > 0 && is_float {
      TypeFloat
    } else {
      TypeString
    }

    let mean_val = if valid_count > 0 {
      sum / valid_count.to_double()
    } else {
      0.0
    }

    let col : Column = {
      name: header_name,
      dtype,
      values: vals,
      num_values: num_vals,
      min_val: if valid_count > 0 {
        min_val
      } else {
        0.0
      },
      max_val: if valid_count > 0 {
        max_val
      } else {
        0.0
      },
      mean_val,
      sum_val: sum,
      valid_num_count: valid_count,
    }
    ds.columns.push(col)
  }

  ds.reset_filter()
  ds
}

///|
/// Computes distribution buckets for a column to plot as a histogram
pub fn compute_column_histogram(
  col : Column,
  active_indices : Array[Int],
  bucket_count : Int,
) -> Array[(Double, Double, Int)] {
  let buckets : Array[(Double, Double, Int)] = []
  if active_indices.is_empty() || col.valid_num_count == 0 {
    return buckets
  }

  let min = col.min_val
  let max = col.max_val
  let range = max - min
  let step = if range > 0.0 { range / bucket_count.to_double() } else { 1.0 }

  let counts = Array::make(bucket_count, 0)
  for idx in active_indices {
    let v = col.num_values[idx]
    let mut b = ((v - min) / step).to_int()
    if b < 0 {
      b = 0
    }
    if b >= bucket_count {
      b = bucket_count - 1
    }
    counts[b] = counts[b] + 1
  }

  for b = 0; b < bucket_count; b = b + 1 {
    let b_start = min + b.to_double() * step
    let b_end = b_start + step
    buckets.push((b_start, b_end, counts[b]))
  }

  buckets
}

///|
/// Computes optimal column widths dynamically based on header and cell content length
pub fn Dataset::compute_column_widths(self : Dataset) -> Array[Double] {
  let widths : Array[Double] = []
  let sample_limit = if self.row_indices.length() < 60 {
    self.row_indices.length()
  } else {
    60
  }
  for c = 0; c < self.columns.length(); c = c + 1 {
    let col = self.columns[c]
    let mut max_chars = col.name.length()
    for r = 0; r < sample_limit; r = r + 1 {
      let cell = self.get_cell(r, c)
      if cell.length() > max_chars {
        max_chars = cell.length()
      }
    }
    // Base width: max_chars * 8.2 + 34px cell padding, clamped to [100.0, 320.0]
    let w = max_chars.to_double() * 8.2 + 34.0
    let clamped_w = if w < 100.0 {
      100.0
    } else if w > 320.0 {
      320.0
    } else {
      w
    }
    widths.push(clamped_w)
  }
  widths
}
