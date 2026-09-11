///|
pub struct Vec2 {
  x : Double
  y : Double
} derive(Eq, Debug, Default)

///|
pub fn Vec2::new(x : Double, y : Double) -> Vec2 {
  { x, y, }
}

///|
pub fn Vec2::zero() -> Vec2 {
  { x: 0.0, y: 0.0, }
}

///|
pub fn Vec2::add(self : Vec2, other : Vec2) -> Vec2 {
  { x: self.x + other.x, y: self.y + other.y, }
}

///|
pub fn Vec2::sub(self : Vec2, other : Vec2) -> Vec2 {
  { x: self.x - other.x, y: self.y - other.y, }
}

///|
pub fn Vec2::scale(self : Vec2, factor : Double) -> Vec2 {
  { x: self.x * factor, y: self.y * factor, }
}

///|
pub fn Vec2::dot(self : Vec2, other : Vec2) -> Double {
  self.x * other.x + self.y * other.y
}

///|
pub fn Vec2::length_sq(self : Vec2) -> Double {
  self.x * self.x + self.y * self.y
}

///|
pub fn Vec2::lerp(self : Vec2, other : Vec2, t : Double) -> Vec2 {
  { x: self.x + (other.x - self.x) * t, y: self.y + (other.y - self.y) * t, }
}

///|
pub fn Vec2::min(self : Vec2, other : Vec2) -> Vec2 {
  {
    x: if self.x < other.x {
      self.x
    } else {
      other.x
    },
    y: if self.y < other.y {
      self.y
    } else {
      other.y
    },
  }
}

///|
pub fn Vec2::max(self : Vec2, other : Vec2) -> Vec2 {
  {
    x: if self.x > other.x {
      self.x
    } else {
      other.x
    },
    y: if self.y > other.y {
      self.y
    } else {
      other.y
    },
  }
}

///|
pub struct Rect {
  x : Double
  y : Double
  w : Double
  h : Double
} derive(Eq, Debug, Default)

///|
pub fn Rect::new(x : Double, y : Double, w : Double, h : Double) -> Rect {
  { x, y, w, h, }
}

///|
pub fn Rect::from_min_max(min : Vec2, max : Vec2) -> Rect {
  let min_x = if min.x < max.x { min.x } else { max.x }
  let min_y = if min.y < max.y { min.y } else { max.y }
  let max_x = if min.x > max.x { min.x } else { max.x }
  let max_y = if min.y > max.y { min.y } else { max.y }
  { x: min_x, y: min_y, w: max_x - min_x, h: max_y - min_y, }
}

///|
pub fn Rect::min(self : Rect) -> Vec2 {
  { x: self.x, y: self.y, }
}

///|
pub fn Rect::max(self : Rect) -> Vec2 {
  { x: self.x + self.w, y: self.y + self.h, }
}

///|
pub fn Rect::size(self : Rect) -> Vec2 {
  { x: self.w, y: self.h, }
}

///|
pub fn Rect::center(self : Rect) -> Vec2 {
  { x: self.x + self.w * 0.5, y: self.y + self.h * 0.5, }
}

///|
pub fn Rect::contains(self : Rect, pt : Vec2) -> Bool {
  pt.x >= self.x &&
  pt.x <= self.x + self.w &&
  pt.y >= self.y &&
  pt.y <= self.y + self.h
}

///|
pub fn Rect::intersects(self : Rect, other : Rect) -> Bool {
  let self_max_x = self.x + self.w
  let self_max_y = self.y + self.h
  let other_max_x = other.x + other.w
  let other_max_y = other.y + other.h
  self.x < other_max_x &&
  self_max_x > other.x &&
  self.y < other_max_y &&
  self_max_y > other.y
}

///|
pub fn Rect::intersect(self : Rect, other : Rect) -> Rect {
  let min_x = if self.x > other.x { self.x } else { other.x }
  let min_y = if self.y > other.y { self.y } else { other.y }
  let self_max_x = self.x + self.w
  let self_max_y = self.y + self.h
  let other_max_x = other.x + other.w
  let other_max_y = other.y + other.h
  let max_x = if self_max_x < other_max_x { self_max_x } else { other_max_x }
  let max_y = if self_max_y < other_max_y { self_max_y } else { other_max_y }
  let w = if max_x > min_x { max_x - min_x } else { 0.0 }
  let h = if max_y > min_y { max_y - min_y } else { 0.0 }
  { x: min_x, y: min_y, w, h, }
}

///|
pub fn Rect::expand(self : Rect, margin : Double) -> Rect {
  {
    x: self.x - margin,
    y: self.y - margin,
    w: self.w + margin * 2.0,
    h: self.h + margin * 2.0,
  }
}

///|
pub fn Rect::shrink(self : Rect, margin : Double) -> Rect {
  let w = if self.w > margin * 2.0 { self.w - margin * 2.0 } else { 0.0 }
  let h = if self.h > margin * 2.0 { self.h - margin * 2.0 } else { 0.0 }
  { x: self.x + margin, y: self.y + margin, w, h, }
}

///|
pub fn Rect::translate(self : Rect, offset : Vec2) -> Rect {
  { x: self.x + offset.x, y: self.y + offset.y, w: self.w, h: self.h, }
}

///|
pub let pi : Double = 3.141592653589793

///|
pub fn sin(rad : Double) -> Double {
  let two_pi = 6.283185307179586
  let mut x = rad % two_pi
  if x > pi {
    x = x - two_pi
  } else if x < -pi {
    x = x + two_pi
  }
  let half_pi = 1.5707963267948966
  if x > half_pi {
    x = pi - x
  } else if x < -half_pi {
    x = -pi - x
  }
  let x2 = x * x
  let x3 = x * x2
  let x5 = x3 * x2
  let x7 = x5 * x2
  let x9 = x7 * x2
  let x11 = x9 * x2
  x - x3 / 6.0 + x5 / 120.0 - x7 / 5040.0 + x9 / 362880.0 - x11 / 39916800.0
}

///|
pub fn cos(rad : Double) -> Double {
  sin(rad + 1.5707963267948966)
}

///|
pub fn Vec2::from_polar(radius : Double, angle_rad : Double) -> Vec2 {
  { x: radius * cos(angle_rad), y: radius * sin(angle_rad), }
}
