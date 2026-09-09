///|
pub enum DrawCmd {
  Rect(@math.Rect, @color.Color, Double)
  RectStroke(@math.Rect, @color.Color, Double, Double)
  Circle(@math.Vec2, Double, @color.Color)
  CircleStroke(@math.Vec2, Double, @color.Color, Double)
  Line(@math.Vec2, @math.Vec2, @color.Color, Double)
  Text(@math.Vec2, String, Double, @color.Color)
  Clip(@math.Rect)
  ResetClip
} derive(Eq, Debug)

///|
pub struct DrawList {
  commands : Array[DrawCmd]
} derive(Eq, Debug)

///|
pub fn DrawList::new() -> DrawList {
  { commands: [], }
}

///|
pub fn DrawList::clear(self : DrawList) -> Unit {
  self.commands.clear()
}

///|
pub fn DrawList::len(self : DrawList) -> Int {
  self.commands.length()
}

///|
pub fn DrawList::is_empty(self : DrawList) -> Bool {
  self.commands.is_empty()
}

///|
pub fn DrawList::push(self : DrawList, cmd : DrawCmd) -> Unit {
  self.commands.push(cmd)
}

///|
pub fn DrawList::add_rect(
  self : DrawList,
  rect : @math.Rect,
  color : @color.Color,
  corner_radius : Double,
) -> Unit {
  self.commands.push(DrawCmd::Rect(rect, color, corner_radius))
}

///|
pub fn DrawList::add_rect_stroke(
  self : DrawList,
  rect : @math.Rect,
  color : @color.Color,
  stroke_width : Double,
  corner_radius : Double,
) -> Unit {
  self.commands.push(
    DrawCmd::RectStroke(rect, color, stroke_width, corner_radius),
  )
}

///|
pub fn DrawList::add_circle(
  self : DrawList,
  center : @math.Vec2,
  radius : Double,
  color : @color.Color,
) -> Unit {
  self.commands.push(DrawCmd::Circle(center, radius, color))
}

///|
pub fn DrawList::add_circle_stroke(
  self : DrawList,
  center : @math.Vec2,
  radius : Double,
  color : @color.Color,
  stroke_width : Double,
) -> Unit {
  self.commands.push(DrawCmd::CircleStroke(center, radius, color, stroke_width))
}

///|
pub fn DrawList::add_line(
  self : DrawList,
  start : @math.Vec2,
  end : @math.Vec2,
  color : @color.Color,
  stroke_width : Double,
) -> Unit {
  self.commands.push(DrawCmd::Line(start, end, color, stroke_width))
}

///|
pub fn DrawList::add_text(
  self : DrawList,
  pos : @math.Vec2,
  text : String,
  font_size : Double,
  color : @color.Color,
) -> Unit {
  self.commands.push(DrawCmd::Text(pos, text, font_size, color))
}

///|
pub fn DrawList::push_clip(self : DrawList, rect : @math.Rect) -> Unit {
  self.commands.push(DrawCmd::Clip(rect))
}

///|
pub fn DrawList::pop_clip(self : DrawList) -> Unit {
  self.commands.push(DrawCmd::ResetClip)
}

///|
pub fn DrawList::get_command(self : DrawList, index : Int) -> DrawCmd? {
  if index >= 0 && index < self.commands.length() {
    Some(self.commands[index])
  } else {
    None
  }
}
