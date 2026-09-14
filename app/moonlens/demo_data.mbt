// Copyright 2026 Ling71671
// MoonLens Built-in Sample Datasets for Instant Exploration

///|
pub fn load_server_logs_sample() -> Dataset {
  let header = "timestamp,ip_address,method,status_code,latency_ms,bytes_sent,endpoint\n"
  let b = StringBuilder()
  b.write_string(header)

  let endpoints = [
    "/api/v1/query", "/api/v1/auth/login", "/static/css/app.css", "/api/v2/metrics",
    "/api/v1/export", "/dashboard/overview", "/healthz", "/api/v1/user/profile",
  ]
  let ips = [
    "192.168.1.101", "10.0.4.12", "172.16.0.55", "192.168.2.89", "10.244.0.18", "192.168.10.4",
    "172.20.1.200", "10.0.8.99",
  ]
  let methods = ["GET", "POST", "GET", "GET", "PUT", "GET", "GET", "DELETE"]
  let statuses = [200, 200, 200, 204, 200, 404, 500, 200, 304, 200]

  let mut seed : Int64 = 88123456789L
  fn next_rand() -> Int {
    seed = seed * 6364136223846793005L + 1442695040888963407L
    let v = (seed >> 33).to_int()
    if v < 0 {
      -v
    } else {
      v
    }
  }

  // Generate 2,500 realistic log lines
  for i = 0; i < 2500; i = i + 1 {
    let ep_idx = next_rand() % endpoints.length()
    let ip_idx = next_rand() % ips.length()
    let http_method = methods[ep_idx]
    let status = statuses[next_rand() % statuses.length()]
    // Latency with realistic long-tail spikes
    let base_lat = 12.0 + (next_rand() % 45).to_double()
    let latency = if next_rand() % 25 == 0 {
      base_lat + (next_rand() % 350).to_double()
    } else {
      base_lat
    }
    let bytes = 256 + next_rand() % 8192
    let sec = 10 + i / 100 % 50
    let milli = next_rand() % 1000

    b.write_string("2026-09-14T23:\{sec}:\{milli / 10},")
    b.write_string(ips[ip_idx])
    b.write_string(",")
    b.write_string(http_method)
    b.write_string(",")
    b.write_string(status.to_string())
    b.write_string(",")
    b.write_string(latency.to_string())
    b.write_string(",")
    b.write_string(bytes.to_string())
    b.write_string(",")
    b.write_string(endpoints[ep_idx])
    b.write_string("\n")
  }

  parse_csv(b.to_string(), "server_access_logs.csv")
}

///|
pub fn load_sensor_telemetry_sample() -> Dataset {
  let header = "sensor_id,temp_celsius,humidity_pct,pressure_kpa,voltage_v,vibration_hz\n"
  let b = StringBuilder()
  b.write_string(header)

  let mut seed : Int64 = 42109876543L
  fn next_rand() -> Int {
    seed = seed * 6364136223846793005L + 1442695040888963407L
    let v = (seed >> 33).to_int()
    if v < 0 {
      -v
    } else {
      v
    }
  }

  for i = 0; i < 2000; i = i + 1 {
    let sensor_num = i % 16 + 1
    let temp = 22.5 + (next_rand() % 250).to_double() / 10.0
    let hum = 45.0 + (next_rand() % 350).to_double() / 10.0
    let press = 101.3 + (next_rand() % 50).to_double() / 10.0
    let volt = 3.28 + (next_rand() % 24).to_double() / 100.0
    let vib = 12.0 + (next_rand() % 180).to_double() / 10.0

    b.write_string("SENSOR-")
    b.write_string(sensor_num.to_string())
    b.write_string(",")
    b.write_string(temp.to_string())
    b.write_string(",")
    b.write_string(hum.to_string())
    b.write_string(",")
    b.write_string(press.to_string())
    b.write_string(",")
    b.write_string(volt.to_string())
    b.write_string(",")
    b.write_string(vib.to_string())
    b.write_string("\n")
  }

  parse_csv(b.to_string(), "sensor_telemetry.csv")
}

///|
pub fn load_market_quotes_sample() -> Dataset {
  let header = "ticker,open_price,high_price,low_price,close_price,volume,change_pct\n"
  let b = StringBuilder()
  b.write_string(header)

  let tickers = ["MOON", "RUST", "WASM", "NODE", "LINUX", "FAST", "GO", "ZIG"]
  let base_prices = [185.5, 210.0, 48.2, 95.6, 340.0, 72.8, 160.0, 88.4]

  let mut seed : Int64 = 1928374650L
  fn next_rand() -> Int {
    seed = seed * 6364136223846793005L + 1442695040888963407L
    let v = (seed >> 33).to_int()
    if v < 0 {
      -v
    } else {
      v
    }
  }

  for i = 0; i < 1600; i = i + 1 {
    let t_idx = i % tickers.length()
    let base = base_prices[t_idx]
    let delta = ((next_rand() % 200).to_double() - 100.0) / 10.0
    let open_p = base + delta
    let high_p = open_p + (next_rand() % 80).to_double() / 10.0
    let low_p = open_p - (next_rand() % 80).to_double() / 10.0
    let close_p = low_p + (next_rand() % 140).to_double() / 10.0
    let vol = 10000 + next_rand() % 950000
    let chg = (close_p - open_p) / open_p * 100.0

    b.write_string(tickers[t_idx])
    b.write_string(",")
    b.write_string(open_p.to_string())
    b.write_string(",")
    b.write_string(high_p.to_string())
    b.write_string(",")
    b.write_string(low_p.to_string())
    b.write_string(",")
    b.write_string(close_p.to_string())
    b.write_string(",")
    b.write_string(vol.to_string())
    b.write_string(",")
    b.write_string(chg.to_string())
    b.write_string("\n")
  }

  parse_csv(b.to_string(), "market_quotes.csv")
}

///|
pub fn load_stress_benchmark_sample(rows : Int) -> Dataset {
  let header = "timestamp,server_id,cpu_usage,memory_mb,req_per_sec,region,status\n"
  let b = StringBuilder()
  b.write_string(header)

  let regions = [
    "us-east", "eu-central", "ap-northeast", "sa-east", "ca-central",
  ]
  let statuses = [
    "HEALTHY", "HEALTHY", "HEALTHY", "DEGRADED", "HEALTHY", "CRITICAL",
  ]

  let mut seed : Int64 = 77192837465L
  fn next_rand() -> Int {
    seed = seed * 6364136223846793005L + 1442695040888963407L
    let v = (seed >> 33).to_int()
    if v < 0 {
      -v
    } else {
      v
    }
  }

  for i = 0; i < rows; i = i + 1 {
    let srv_id = i % 128 + 1
    let cpu = 10.0 + (next_rand() % 850).to_double() / 10.0
    let mem = 1024 + next_rand() % 31744
    let rps = 500 + next_rand() % 45000
    let reg = regions[next_rand() % regions.length()]
    let st = statuses[next_rand() % statuses.length()]

    let min = i / 60 % 60
    let sec = i % 60
    let ms = next_rand() % 1000

    b.write_string("2026-09-15T00:\{min}:\{sec}.\{ms},SRV-")
    b.write_string(srv_id.to_string())
    b.write_string(",")
    b.write_string(cpu.to_string())
    b.write_string(",")
    b.write_string(mem.to_string())
    b.write_string(",")
    b.write_string(rps.to_string())
    b.write_string(",")
    b.write_string(reg)
    b.write_string(",")
    b.write_string(st)
    b.write_string("\n")
  }

  parse_csv(b.to_string(), "benchmark_\{rows}_rows.csv")
}
