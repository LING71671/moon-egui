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
/// Physical spring configuration parameters governing harmonic oscillation and damping.
pub struct SpringConfig {
  stiffness : Double
  damping : Double
  mass : Double
} derive(Eq, Debug, Default)

///|
pub fn SpringConfig::new(
  stiffness : Double,
  damping : Double,
  mass? : Double = 1.0,
) -> SpringConfig {
  let m = if mass <= 0.0 { 1.0 } else { mass }
  let k = if stiffness <= 0.0 { 100.0 } else { stiffness }
  let d = if damping < 0.0 { 0.0 } else { damping }
  { stiffness: k, damping: d, mass: m, }
}

///|
/// Default balanced spring (critically damped feel for interactive UI).
pub fn SpringConfig::default_spring() -> SpringConfig {
  { stiffness: 180.0, damping: 26.0, mass: 1.0, }
}

///|
/// Stiff spring with high responsiveness and minimal overshoot.
pub fn SpringConfig::stiff() -> SpringConfig {
  { stiffness: 320.0, damping: 35.0, mass: 1.0, }
}

///|
/// Gentle spring for smooth transitions and subtle deceleration.
pub fn SpringConfig::gentle() -> SpringConfig {
  { stiffness: 120.0, damping: 20.0, mass: 1.0, }
}

///|
/// Bouncy spring with lower damping for noticeable recoil.
pub fn SpringConfig::bouncy() -> SpringConfig {
  { stiffness: 200.0, damping: 14.0, mass: 1.0, }
}

///|
/// Single-degree-of-freedom spring simulation state.
pub struct Spring {
  config : SpringConfig
  mut current : Double
  mut target : Double
  mut velocity : Double
} derive(Eq, Debug)

///|
pub fn Spring::new(
  initial_val : Double,
  config? : SpringConfig = SpringConfig::default_spring(),
) -> Spring {
  { config, current: initial_val, target: initial_val, velocity: 0.0, }
}

///|
pub fn Spring::set_target(self : Spring, target : Double) -> Unit {
  self.target = target
}

///|
pub fn Spring::value(self : Spring) -> Double {
  self.current
}

///|
pub fn Spring::target_value(self : Spring) -> Double {
  self.target
}

///|
pub fn Spring::velocity_value(self : Spring) -> Double {
  self.velocity
}

///|
pub fn Spring::reset(self : Spring, value : Double) -> Unit {
  self.current = value
  self.target = value
  self.velocity = 0.0
}

///|
pub fn Spring::is_settled(
  self : Spring,
  tolerance? : Double = 0.001,
  velocity_tolerance? : Double = 0.001,
) -> Bool {
  let diff = self.current - self.target
  let abs_diff = if diff < 0.0 { -diff } else { diff }
  let abs_v = if self.velocity < 0.0 { -self.velocity } else { self.velocity }
  abs_diff < tolerance && abs_v < velocity_tolerance
}

///|
/// Advances the spring simulation by dt seconds using semi-implicit Euler integration
/// with adaptive sub-stepping to prevent numerical instability.
pub fn Spring::step(self : Spring, dt : Double) -> Unit {
  if dt <= 0.0 {
    return
  }
  // If already at target with negligible velocity, snap to target
  if self.is_settled() {
    self.current = self.target
    self.velocity = 0.0
    return
  }

  // Use a fixed sub-step of at most 1/120s for numerical stability
  let max_sub_dt = 1.0 / 120.0
  let mut remaining = dt
  while remaining > 0.0 {
    let sub_dt = if remaining < max_sub_dt { remaining } else { max_sub_dt }
    let disp = self.current - self.target
    let spring_force = -self.config.stiffness * disp
    let damping_force = -self.config.damping * self.velocity
    let total_force = spring_force + damping_force
    let accel = total_force / self.config.mass

    self.velocity = self.velocity + accel * sub_dt
    self.current = self.current + self.velocity * sub_dt
    remaining = remaining - sub_dt
  }

  // Snap if reached threshold
  if self.is_settled() {
    self.current = self.target
    self.velocity = 0.0
  }
}

///|
/// Two-dimensional spring simulation for positions and coordinates.
pub struct Spring2D {
  x : Spring
  y : Spring
} derive(Eq, Debug)

///|
pub fn Spring2D::new(
  initial_pos : Vec2,
  config? : SpringConfig = SpringConfig::default_spring(),
) -> Spring2D {
  {
    x: Spring::new(initial_pos.x, config~),
    y: Spring::new(initial_pos.y, config~),
  }
}

///|
pub fn Spring2D::set_target(self : Spring2D, target : Vec2) -> Unit {
  self.x.set_target(target.x)
  self.y.set_target(target.y)
}

///|
pub fn Spring2D::value(self : Spring2D) -> Vec2 {
  Vec2::new(self.x.value(), self.y.value())
}

///|
pub fn Spring2D::target_value(self : Spring2D) -> Vec2 {
  Vec2::new(self.x.target_value(), self.y.target_value())
}

///|
pub fn Spring2D::reset(self : Spring2D, pos : Vec2) -> Unit {
  self.x.reset(pos.x)
  self.y.reset(pos.y)
}

///|
pub fn Spring2D::is_settled(
  self : Spring2D,
  tolerance? : Double = 0.001,
  velocity_tolerance? : Double = 0.001,
) -> Bool {
  self.x.is_settled(tolerance~, velocity_tolerance~) &&
  self.y.is_settled(tolerance~, velocity_tolerance~)
}

///|
pub fn Spring2D::step(self : Spring2D, dt : Double) -> Unit {
  self.x.step(dt)
  self.y.step(dt)
}
