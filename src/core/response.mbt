///|
pub struct Response {
  id : Id
  rect : @math.Rect
  hovered : Bool
  clicked : Bool
  pressed : Bool
  dragged : Bool
  has_focus : Bool
  gained_focus : Bool
  lost_focus : Bool
  secondary_clicked : Bool
} derive(Eq, Debug, Default)

///|
pub fn Response::new(
  id : Id,
  rect : @math.Rect,
  hovered : Bool,
  clicked : Bool,
  pressed : Bool,
  dragged : Bool,
  secondary_clicked? : Bool = false,
) -> Response {
  {
    id,
    rect,
    hovered,
    clicked,
    pressed,
    dragged,
    has_focus: false,
    gained_focus: false,
    lost_focus: false,
    secondary_clicked,
  }
}

///|
pub fn Response::with_focus(
  id : Id,
  rect : @math.Rect,
  hovered : Bool,
  clicked : Bool,
  pressed : Bool,
  dragged : Bool,
  has_focus : Bool,
  gained_focus : Bool,
  lost_focus : Bool,
  secondary_clicked? : Bool = false,
) -> Response {
  {
    id,
    rect,
    hovered,
    clicked,
    pressed,
    dragged,
    has_focus,
    gained_focus,
    lost_focus,
    secondary_clicked,
  }
}

///|
pub fn Response::id(self : Response) -> Id {
  self.id
}

///|
pub fn Response::rect(self : Response) -> @math.Rect {
  self.rect
}

///|
pub fn Response::clicked(self : Response) -> Bool {
  self.clicked
}

///|
pub fn Response::hovered(self : Response) -> Bool {
  self.hovered
}

///|
pub fn Response::pressed(self : Response) -> Bool {
  self.pressed
}

///|
pub fn Response::dragged(self : Response) -> Bool {
  self.dragged
}

///|
pub fn Response::has_focus(self : Response) -> Bool {
  self.has_focus
}

///|
pub fn Response::gained_focus(self : Response) -> Bool {
  self.gained_focus
}

///|
pub fn Response::lost_focus(self : Response) -> Bool {
  self.lost_focus
}

///|
pub fn Response::secondary_clicked(self : Response) -> Bool {
  self.secondary_clicked
}
