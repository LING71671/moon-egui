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
test "painter: coordinate offset translation" {
  let dl = @draw.DrawList::new()
  let offset = @math.Vec2::new(10.0, 20.0)
  let p = Painter::new(dl, offset~)

  p.add_rect(
    @math.Rect::new(5.0, 5.0, 50.0, 30.0),
    @color.Color::accent_primary(),
    2.0,
  )
  p.add_circle(@math.Vec2::new(15.0, 15.0), 8.0, @color.Color::accent_hover())
  p.add_line(
    @math.Vec2::new(0.0, 0.0),
    @math.Vec2::new(100.0, 100.0),
    @color.Color::border_muted(),
    1.0,
  )
  p.add_text(
    @math.Vec2::new(2.0, 4.0),
    "Hello",
    12.0,
    @color.Color::text_primary(),
  )

  assert_eq(dl.len(), 4)

  // Verify rect translated by (10, 20) -> (15, 25)
  match dl.get_command(0) {
    Some(@draw.DrawCmd::Rect(rect, _, _)) => {
      assert_eq(rect.x, 15.0)
      assert_eq(rect.y, 25.0)
      assert_eq(rect.w, 50.0)
      assert_eq(rect.h, 30.0)
    }
    _ => assert_true(false)
  }

  // Verify circle center translated by (10, 20) -> (25, 35)
  match dl.get_command(1) {
    Some(@draw.DrawCmd::Circle(center, r, _)) => {
      assert_eq(center.x, 25.0)
      assert_eq(center.y, 35.0)
      assert_eq(r, 8.0)
    }
    _ => assert_true(false)
  }

  // Verify text position translated by (10, 20) -> (12, 24)
  match dl.get_command(3) {
    Some(@draw.DrawCmd::Text(pos, text, _, _, _, _)) => {
      assert_eq(pos.x, 12.0)
      assert_eq(pos.y, 24.0)
      assert_eq(text, "Hello")
    }
    _ => assert_true(false)
  }
}

///|
test "painter: sub_painter nesting and clip intersection" {
  let dl = @draw.DrawList::new()
  let parent_clip = @math.Rect::new(0.0, 0.0, 100.0, 100.0)
  let parent_p = Painter::new(
    dl,
    clip_rect=Some(parent_clip),
    offset=@math.Vec2::new(10.0, 10.0),
  )

  let child_clip = @math.Rect::new(20.0, 20.0, 50.0, 50.0)
  let child_p = parent_p.sub_painter(
    @math.Vec2::new(5.0, 5.0),
    sub_clip=Some(child_clip),
  )

  // Cumulative offset: (10, 10) + (5, 5) = (15, 15)
  assert_eq(child_p.offset().x, 15.0)
  assert_eq(child_p.offset().y, 15.0)

  // Clip intersection: (0, 0, 100, 100) intersect (20, 20, 50, 50) = (20, 20, 50, 50)
  match child_p.clip_rect() {
    Some(clip) => {
      assert_eq(clip.x, 20.0)
      assert_eq(clip.y, 20.0)
      assert_eq(clip.w, 50.0)
      assert_eq(clip.h, 50.0)
    }
    None => assert_true(false)
  }

  child_p.add_rect(
    @math.Rect::new(0.0, 0.0, 10.0, 10.0),
    @color.Color::accent_primary(),
    0.0,
  )
  match dl.get_command(0) {
    Some(@draw.DrawCmd::Rect(rect, _, _)) => {
      assert_eq(rect.x, 15.0)
      assert_eq(rect.y, 15.0)
    }
    _ => assert_true(false)
  }
}
