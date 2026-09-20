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
test "svg_exporter: empty draw list and background" {
  let dl = DrawList::new()
  let svg = dl.to_svg(400.0, 300.0, background=@color.Color::white())
  assert_true(svg.contains("<svg xmlns=\"http://www.w3.org/2000/svg\""))
  assert_true(svg.contains("viewBox=\"0 0 400 300\""))
  assert_true(
    svg.contains("<rect width=\"400\" height=\"300\" fill=\"rgb(255,255,255)\""),
  )
  assert_true(svg.contains("</svg>"))
}

///|
test "svg_exporter: primitives serialization" {
  let dl = DrawList::new()
  dl.add_rect(
    @math.Rect::new(10.0, 20.0, 100.0, 50.0),
    @color.Color::rgb(255, 0, 0),
    4.0,
  )
  dl.add_rect_stroke(
    @math.Rect::new(12.0, 22.0, 96.0, 46.0),
    @color.Color::black(),
    1.5,
    2.0,
  )
  dl.add_circle(@math.Vec2::new(50.0, 50.0), 15.0, @color.Color::rgb(0, 255, 0))
  dl.add_circle_stroke(
    @math.Vec2::new(50.0, 50.0),
    15.0,
    @color.Color::rgb(0, 0, 255),
    2.0,
  )
  dl.add_line(
    @math.Vec2::new(0.0, 0.0),
    @math.Vec2::new(100.0, 100.0),
    @color.Color::black(),
    1.0,
  )

  let svg = dl.to_svg(200.0, 200.0)
  assert_true(
    svg.contains(
      "<rect x=\"10\" y=\"20\" width=\"100\" height=\"50\" rx=\"4\" ry=\"4\" fill=\"rgb(255,0,0)\"",
    ),
  )
  assert_true(
    svg.contains(
      "<rect x=\"12\" y=\"22\" width=\"96\" height=\"46\" rx=\"2\" ry=\"2\" fill=\"none\" stroke=\"rgb(0,0,0)\" stroke-width=\"1.5\"",
    ),
  )
  assert_true(
    svg.contains("<circle cx=\"50\" cy=\"50\" r=\"15\" fill=\"rgb(0,255,0)\""),
  )
  assert_true(
    svg.contains(
      "<circle cx=\"50\" cy=\"50\" r=\"15\" fill=\"none\" stroke=\"rgb(0,0,255)\" stroke-width=\"2\"",
    ),
  )
  assert_true(
    svg.contains(
      "<line x1=\"0\" y1=\"0\" x2=\"100\" y2=\"100\" stroke=\"rgb(0,0,0)\" stroke-width=\"1\"",
    ),
  )
}

///|
test "svg_exporter: text with xml escaping" {
  let dl = DrawList::new()
  dl.add_text(
    @math.Vec2::new(15.0, 30.0),
    "Alert <Important> & \"Special\"",
    14.0,
    @color.Color::black(),
  )

  let svg = dl.to_svg(300.0, 100.0)
  assert_true(svg.contains("Alert &lt;Important&gt; &amp; &quot;Special&quot;"))
  assert_true(svg.contains("font-size=\"14\""))
  assert_true(svg.contains("dominant-baseline=\"hanging\""))
}

///|
test "svg_exporter: scoped clipping hierarchy" {
  let dl = DrawList::new()
  dl.push(DrawCmd::Clip(@math.Rect::new(10.0, 10.0, 80.0, 80.0)))
  dl.add_rect(
    @math.Rect::new(0.0, 0.0, 100.0, 100.0),
    @color.Color::rgb(100, 100, 100),
    0.0,
  )
  dl.push(DrawCmd::ResetClip)

  let svg = dl.to_svg(200.0, 200.0)
  assert_true(
    svg.contains(
      "<clipPath id=\"clip_1\"><rect x=\"10\" y=\"10\" width=\"80\" height=\"80\"/></clipPath>",
    ),
  )
  assert_true(svg.contains("<g clip-path=\"url(#clip_1)\">"))
  assert_true(svg.contains("</g>"))
}
