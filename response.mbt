///|
pub struct Response {
  id : Id
  rect : Rect
  hovered : Bool
  clicked : Bool
  pressed : Bool
  dragged : Bool
} derive(Eq, Debug, Default)

///|
pub fn Response::new(
  id : Id,
  rect : Rect,
  hovered : Bool,
  clicked : Bool,
  pressed : Bool,
  dragged : Bool,
) -> Response {
  { id, rect, hovered, clicked, pressed, dragged, }
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
