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
test "spring: initial state and targets" {
  let s = Spring::new(0.0)
  assert_eq(s.value(), 0.0)
  assert_eq(s.target_value(), 0.0)
  assert_eq(s.velocity_value(), 0.0)
  assert_true(s.is_settled())

  s.set_target(100.0)
  assert_eq(s.target_value(), 100.0)
  assert_false(s.is_settled())
}

///|
test "spring: convergence under stepping" {
  let s = Spring::new(0.0, config=SpringConfig::stiff())
  s.set_target(50.0)

  // Step 120 frames at 60fps (2.0 seconds)
  for _ in 0..<120 {
    s.step(1.0 / 60.0)
  }

  assert_true(s.is_settled())
  assert_eq(s.value(), 50.0)
  assert_eq(s.velocity_value(), 0.0)
}

///|
test "spring: reset functionality" {
  let s = Spring::new(10.0)
  s.set_target(100.0)
  s.step(0.1)
  assert_true(s.value() > 10.0)

  s.reset(25.0)
  assert_eq(s.value(), 25.0)
  assert_eq(s.target_value(), 25.0)
  assert_eq(s.velocity_value(), 0.0)
  assert_true(s.is_settled())
}

///|
test "spring: config presets validation" {
  let def = SpringConfig::default_spring()
  assert_eq(def.mass, 1.0)
  assert_true(def.stiffness > 0.0)
  assert_true(def.damping > 0.0)

  let stiff = SpringConfig::stiff()
  assert_true(stiff.stiffness > def.stiffness)

  let gentle = SpringConfig::gentle()
  assert_true(gentle.stiffness < def.stiffness)

  let custom = SpringConfig::new(-10.0, -5.0, mass=0.0)
  assert_eq(custom.mass, 1.0)
  assert_eq(custom.stiffness, 100.0)
  assert_eq(custom.damping, 0.0)
}

///|
test "spring: zero or negative dt does not mutate" {
  let s = Spring::new(0.0)
  s.set_target(10.0)
  s.step(0.0)
  assert_eq(s.value(), 0.0)
  s.step(-0.016)
  assert_eq(s.value(), 0.0)
}

///|
test "spring2d: 2D vector convergence" {
  let s2 = Spring2D::new(Vec2::new(0.0, 0.0))
  assert_eq(s2.value(), Vec2::new(0.0, 0.0))
  assert_true(s2.is_settled())

  s2.set_target(Vec2::new(200.0, 150.0))
  assert_eq(s2.target_value(), Vec2::new(200.0, 150.0))
  assert_false(s2.is_settled())

  // Advance simulation by 2 seconds
  for _ in 0..<120 {
    s2.step(1.0 / 60.0)
  }

  assert_true(s2.is_settled())
  let val = s2.value()
  assert_eq(val.x, 200.0)
  assert_eq(val.y, 150.0)

  s2.reset(Vec2::new(10.0, 20.0))
  assert_eq(s2.value(), Vec2::new(10.0, 20.0))
  assert_true(s2.is_settled())
}

///|
test "spring: nan and large dt protection" {
  let s = Spring::new(0.0)
  s.set_target(100.0)
  // NaN should be ignored
  let nan = 0.0 / 0.0
  s.step(nan)
  assert_eq(s.value(), 0.0)

  // Huge dt (e.g. 100.0s background tab) should be clamped safely without infinite loop
  s.step(100.0)
  assert_true(s.value() > 0.0)
  assert_false(s.value().is_nan())
}
