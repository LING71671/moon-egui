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
/// Standalone read-only text label widget supporting custom colors and fluent configuration.
pub struct Label {
  text : String
  color : @color.Color?
} derive(Eq, Debug)

///|
/// Create a new text label widget.
pub fn Label::new(text : String) -> Label {
  { text, color: None, }
}

///|
/// Set custom text color.
pub fn Label::color(self : Label, color : @color.Color) -> Label {
  { ..self, color: Some(color), }
}

///|
/// Render the label into the provided UIContext.
pub impl @core.Widget for Label with fn ui(self, ctx : UIContext) -> Response {
  match self.color {
    Some(c) => ctx.label_colored(self.text, c)
    None => ctx.label(self.text)
  }
}

///|
/// Standalone horizontal divider line widget implementing the Widget trait.
pub struct Separator {} derive(Eq, Debug)

///|
/// Create a new horizontal separator widget.
pub fn Separator::new() -> Separator {
  Separator::{ }
}

///|
/// Render the separator into the provided UIContext.
pub impl @core.Widget for Separator with fn ui(_self, ctx : UIContext) -> Response {
  let w = ctx.available_width()
  let h = 9.0
  let (_id, rect, resp) = ctx.allocate_space(@math.Vec2::new(w, h))
  let y = rect.y + 4.5
  ctx
  .painter()
  .add_line(
    @math.Vec2::new(rect.x, y),
    @math.Vec2::new(rect.x + rect.w, y),
    @color.Color::border_muted(),
    1.0,
  )
  resp
}
