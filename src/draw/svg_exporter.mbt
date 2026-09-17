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
/// Helper to convert a Color to standard CSS rgb(...) string.
fn color_to_rgb(c : @color.Color) -> String {
  "rgb(" + c.r.to_string() + "," + c.g.to_string() + "," + c.b.to_string() + ")"
}

///|
/// Helper to compute opacity string from alpha byte.
fn color_to_opacity(c : @color.Color) -> String {
  if c.a == 255 {
    "1"
  } else if c.a == 0 {
    "0"
  } else {
    // 2 decimal places approximation
    let pct = (c.a.to_double() / 255.0 * 100.0).to_int()
    let int_part = pct / 100
    let dec_part = pct % 100
    let dec_str = if dec_part < 10 {
      "0" + dec_part.to_string()
    } else {
      dec_part.to_string()
    }
    int_part.to_string() + "." + dec_str
  }
}

///|
/// Escape standard XML entities for safe SVG output.
fn escape_xml(s : String) -> String {
  let buf = StringBuilder()
  for c in s {
    match c {
      '&' => buf.write_string("&amp;")
      '<' => buf.write_string("&lt;")
      '>' => buf.write_string("&gt;")
      '"' => buf.write_string("&quot;")
      '\'' => buf.write_string("&apos;")
      _ => buf.write_char(c)
    }
  }
  buf.to_string()
}

///|
/// SvgExporter converts a DrawList into compliant standalone SVG XML markup.
pub struct SvgExporter {
  width : Double
  height : Double
  background : @color.Color?
} derive(Eq, Debug)

///|
pub fn SvgExporter::new(
  width : Double,
  height : Double,
  background? : @color.Color,
) -> SvgExporter {
  { width, height, background, }
}

///|
/// Renders the given DrawList as a standard standalone SVG string.
pub fn SvgExporter::render_to_string(
  self : SvgExporter,
  draw_list : DrawList,
) -> String {
  let buf = StringBuilder()

  buf.write_string("<svg xmlns=\"http://www.w3.org/2000/svg\" ")
  buf.write_string("viewBox=\"0 0 ")
  buf.write_string(self.width.to_string())
  buf.write_string(" ")
  buf.write_string(self.height.to_string())
  buf.write_string("\" width=\"")
  buf.write_string(self.width.to_string())
  buf.write_string("\" height=\"")
  buf.write_string(self.height.to_string())
  buf.write_string("\">\n")

  // Optional background rectangle
  match self.background {
    Some(bg) => {
      buf.write_string("  <rect width=\"")
      buf.write_string(self.width.to_string())
      buf.write_string("\" height=\"")
      buf.write_string(self.height.to_string())
      buf.write_string("\" fill=\"")
      buf.write_string(color_to_rgb(bg))
      buf.write_string("\" fill-opacity=\"")
      buf.write_string(color_to_opacity(bg))
      buf.write_string("\"/>\n")
    }
    None => ()
  }

  let mut clip_depth = 0
  let mut id_counter = 0

  for cmd in draw_list.commands {
    match cmd {
      DrawCmd::Rect(rect, color, radius) => {
        buf.write_string("  <rect x=\"")
        buf.write_string(rect.x.to_string())
        buf.write_string("\" y=\"")
        buf.write_string(rect.y.to_string())
        buf.write_string("\" width=\"")
        buf.write_string(rect.w.to_string())
        buf.write_string("\" height=\"")
        buf.write_string(rect.h.to_string())
        buf.write_string("\"")
        if radius > 0.0 {
          buf.write_string(" rx=\"")
          buf.write_string(radius.to_string())
          buf.write_string("\" ry=\"")
          buf.write_string(radius.to_string())
          buf.write_string("\"")
        }
        buf.write_string(" fill=\"")
        buf.write_string(color_to_rgb(color))
        buf.write_string("\" fill-opacity=\"")
        buf.write_string(color_to_opacity(color))
        buf.write_string("\"/>\n")
      }
      DrawCmd::RectStroke(rect, color, stroke_width, radius) => {
        buf.write_string("  <rect x=\"")
        buf.write_string(rect.x.to_string())
        buf.write_string("\" y=\"")
        buf.write_string(rect.y.to_string())
        buf.write_string("\" width=\"")
        buf.write_string(rect.w.to_string())
        buf.write_string("\" height=\"")
        buf.write_string(rect.h.to_string())
        buf.write_string("\"")
        if radius > 0.0 {
          buf.write_string(" rx=\"")
          buf.write_string(radius.to_string())
          buf.write_string("\" ry=\"")
          buf.write_string(radius.to_string())
          buf.write_string("\"")
        }
        buf.write_string(" fill=\"none\" stroke=\"")
        buf.write_string(color_to_rgb(color))
        buf.write_string("\" stroke-width=\"")
        buf.write_string(stroke_width.to_string())
        buf.write_string("\" stroke-opacity=\"")
        buf.write_string(color_to_opacity(color))
        buf.write_string("\"/>\n")
      }
      DrawCmd::Circle(center, radius, color) => {
        buf.write_string("  <circle cx=\"")
        buf.write_string(center.x.to_string())
        buf.write_string("\" cy=\"")
        buf.write_string(center.y.to_string())
        buf.write_string("\" r=\"")
        buf.write_string(radius.to_string())
        buf.write_string("\" fill=\"")
        buf.write_string(color_to_rgb(color))
        buf.write_string("\" fill-opacity=\"")
        buf.write_string(color_to_opacity(color))
        buf.write_string("\"/>\n")
      }
      DrawCmd::CircleStroke(center, radius, color, stroke_width) => {
        buf.write_string("  <circle cx=\"")
        buf.write_string(center.x.to_string())
        buf.write_string("\" cy=\"")
        buf.write_string(center.y.to_string())
        buf.write_string("\" r=\"")
        buf.write_string(radius.to_string())
        buf.write_string("\" fill=\"none\" stroke=\"")
        buf.write_string(color_to_rgb(color))
        buf.write_string("\" stroke-width=\"")
        buf.write_string(stroke_width.to_string())
        buf.write_string("\" stroke-opacity=\"")
        buf.write_string(color_to_opacity(color))
        buf.write_string("\"/>\n")
      }
      DrawCmd::Line(start, end, color, stroke_width) => {
        buf.write_string("  <line x1=\"")
        buf.write_string(start.x.to_string())
        buf.write_string("\" y1=\"")
        buf.write_string(start.y.to_string())
        buf.write_string("\" x2=\"")
        buf.write_string(end.x.to_string())
        buf.write_string("\" y2=\"")
        buf.write_string(end.y.to_string())
        buf.write_string("\" stroke=\"")
        buf.write_string(color_to_rgb(color))
        buf.write_string("\" stroke-width=\"")
        buf.write_string(stroke_width.to_string())
        buf.write_string("\" stroke-opacity=\"")
        buf.write_string(color_to_opacity(color))
        buf.write_string("\"/>\n")
      }
      DrawCmd::Text(pos, text, font_size, color, font_family, font_weight) => {
        buf.write_string("  <text x=\"")
        buf.write_string(pos.x.to_string())
        buf.write_string("\" y=\"")
        buf.write_string(pos.y.to_string())
        buf.write_string("\" font-size=\"")
        buf.write_string(font_size.to_string())
        buf.write_string("\" fill=\"")
        buf.write_string(color_to_rgb(color))
        buf.write_string("\" fill-opacity=\"")
        buf.write_string(color_to_opacity(color))
        buf.write_string("\"")
        if font_family != "" {
          buf.write_string(" font-family=\"")
          buf.write_string(escape_xml(font_family))
          buf.write_string("\"")
        }
        if font_weight > 0 {
          buf.write_string(" font-weight=\"")
          buf.write_string(font_weight.to_string())
          buf.write_string("\"")
        }
        buf.write_string(">")
        buf.write_string(escape_xml(text))
        buf.write_string("</text>\n")
      }
      DrawCmd::Clip(rect) => {
        id_counter = id_counter + 1
        let clip_id = "clip_" + id_counter.to_string()
        buf.write_string("  <defs><clipPath id=\"")
        buf.write_string(clip_id)
        buf.write_string("\"><rect x=\"")
        buf.write_string(rect.x.to_string())
        buf.write_string("\" y=\"")
        buf.write_string(rect.y.to_string())
        buf.write_string("\" width=\"")
        buf.write_string(rect.w.to_string())
        buf.write_string("\" height=\"")
        buf.write_string(rect.h.to_string())
        buf.write_string("\"/></clipPath></defs>\n")
        buf.write_string("  <g clip-path=\"url(#")
        buf.write_string(clip_id)
        buf.write_string(")\">\n")
        clip_depth = clip_depth + 1
      }
      DrawCmd::ResetClip =>
        if clip_depth > 0 {
          buf.write_string("  </g>\n")
          clip_depth = clip_depth - 1
        }
      DrawCmd::LinearGradient(rect, p0, p1, start_col, end_col, radius) => {
        id_counter = id_counter + 1
        let grad_id = "grad_" + id_counter.to_string()
        buf.write_string("  <defs><linearGradient id=\"")
        buf.write_string(grad_id)
        buf.write_string("\" x1=\"")
        buf.write_string(p0.x.to_string())
        buf.write_string("\" y1=\"")
        buf.write_string(p0.y.to_string())
        buf.write_string("\" x2=\"")
        buf.write_string(p1.x.to_string())
        buf.write_string("\" y2=\"")
        buf.write_string(p1.y.to_string())
        buf.write_string("\" gradientUnits=\"userSpaceOnUse\">\n")
        buf.write_string("    <stop offset=\"0%\" stop-color=\"")
        buf.write_string(color_to_rgb(start_col))
        buf.write_string("\" stop-opacity=\"")
        buf.write_string(color_to_opacity(start_col))
        buf.write_string("\"/>\n")
        buf.write_string("    <stop offset=\"100%\" stop-color=\"")
        buf.write_string(color_to_rgb(end_col))
        buf.write_string("\" stop-opacity=\"")
        buf.write_string(color_to_opacity(end_col))
        buf.write_string("\"/>\n")
        buf.write_string("  </linearGradient></defs>\n")

        buf.write_string("  <rect x=\"")
        buf.write_string(rect.x.to_string())
        buf.write_string("\" y=\"")
        buf.write_string(rect.y.to_string())
        buf.write_string("\" width=\"")
        buf.write_string(rect.w.to_string())
        buf.write_string("\" height=\"")
        buf.write_string(rect.h.to_string())
        buf.write_string("\"")
        if radius > 0.0 {
          buf.write_string(" rx=\"")
          buf.write_string(radius.to_string())
          buf.write_string("\" ry=\"")
          buf.write_string(radius.to_string())
          buf.write_string("\"")
        }
        buf.write_string(" fill=\"url(#")
        buf.write_string(grad_id)
        buf.write_string(")\"/>\n")
      }
    }
  }

  // Close any unclosed clip groups
  while clip_depth > 0 {
    buf.write_string("  </g>\n")
    clip_depth = clip_depth - 1
  }

  buf.write_string("</svg>\n")
  buf.to_string()
}

///|
/// Convenience extension method on DrawList to render directly to SVG.
pub fn DrawList::to_svg(
  self : DrawList,
  width : Double,
  height : Double,
  background? : @color.Color,
) -> String {
  let exporter = SvgExporter::new(width, height, background?)
  exporter.render_to_string(self)
}
