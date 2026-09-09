///|
test "vec2 arithmetic and operations" {
  let v1 = Vec2::new(3.0, 4.0)
  let v2 = Vec2::new(1.0, 2.0)

  // Addition & subtraction
  let sum = v1.add(v2)
  assert_eq(sum.x, 4.0)
  assert_eq(sum.y, 6.0)

  let diff = v1.sub(v2)
  assert_eq(diff.x, 2.0)
  assert_eq(diff.y, 2.0)

  // Scaling
  let scaled = v1.scale(2.0)
  assert_eq(scaled.x, 6.0)
  assert_eq(scaled.y, 8.0)

  // Dot product & length squared
  assert_eq(v1.dot(v2), 11.0)
  assert_eq(v1.length_sq(), 25.0)

  // Min & Max
  let min_v = v1.min(v2)
  assert_eq(min_v.x, 1.0)
  assert_eq(min_v.y, 2.0)

  let max_v = v1.max(v2)
  assert_eq(max_v.x, 3.0)
  assert_eq(max_v.y, 4.0)

  // Lerp
  let mid = v1.lerp(v2, 0.5)
  assert_eq(mid.x, 2.0)
  assert_eq(mid.y, 3.0)
}

///|
test "rect containment and bounding box math" {
  let r = Rect::new(10.0, 20.0, 100.0, 50.0)

  // Min, Max, Center, Size
  assert_eq(r.min().x, 10.0)
  assert_eq(r.min().y, 20.0)
  assert_eq(r.max().x, 110.0)
  assert_eq(r.max().y, 70.0)
  assert_eq(r.center().x, 60.0)
  assert_eq(r.center().y, 45.0)
  assert_eq(r.size().x, 100.0)
  assert_eq(r.size().y, 50.0)

  // Contains points
  assert_true(r.contains(Vec2::new(10.0, 20.0))) // Top-left corner
  assert_true(r.contains(Vec2::new(110.0, 70.0))) // Bottom-right corner
  assert_true(r.contains(Vec2::new(50.0, 30.0))) // Inside
  assert_true(!r.contains(Vec2::new(9.9, 20.0))) // Outside left
  assert_true(!r.contains(Vec2::new(110.1, 30.0))) // Outside right
  assert_true(!r.contains(Vec2::new(50.0, 19.9))) // Outside top
  assert_true(!r.contains(Vec2::new(50.0, 70.1))) // Outside bottom

  // Rect from min max
  let r2 = Rect::from_min_max(Vec2::new(20.0, 30.0), Vec2::new(80.0, 90.0))
  assert_eq(r2.x, 20.0)
  assert_eq(r2.y, 30.0)
  assert_eq(r2.w, 60.0)
  assert_eq(r2.h, 60.0)
}

///|
test "rect intersections and scissor clipping" {
  let r1 = Rect::new(0.0, 0.0, 100.0, 100.0)
  let r2 = Rect::new(50.0, 50.0, 100.0, 100.0)
  let r_disjoint = Rect::new(200.0, 200.0, 50.0, 50.0)

  // Intersects
  assert_true(r1.intersects(r2))
  assert_true(r2.intersects(r1))
  assert_true(!r1.intersects(r_disjoint))

  // Intersect (clipping region)
  let clip = r1.intersect(r2)
  assert_eq(clip.x, 50.0)
  assert_eq(clip.y, 50.0)
  assert_eq(clip.w, 50.0)
  assert_eq(clip.h, 50.0)

  let disjoint_clip = r1.intersect(r_disjoint)
  assert_eq(disjoint_clip.w, 0.0)
  assert_eq(disjoint_clip.h, 0.0)

  // Expand and shrink
  let expanded = r1.expand(5.0)
  assert_eq(expanded.x, -5.0)
  assert_eq(expanded.y, -5.0)
  assert_eq(expanded.w, 110.0)
  assert_eq(expanded.h, 110.0)

  let shrunk = r1.shrink(10.0)
  assert_eq(shrunk.x, 10.0)
  assert_eq(shrunk.y, 10.0)
  assert_eq(shrunk.w, 80.0)
  assert_eq(shrunk.h, 80.0)

  // Translate
  let shifted = r1.translate(Vec2::new(25.0, 30.0))
  assert_eq(shifted.x, 25.0)
  assert_eq(shifted.y, 30.0)
  assert_eq(shifted.w, 100.0)
  assert_eq(shifted.h, 100.0)
}
