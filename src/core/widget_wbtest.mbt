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
struct CustomBox {
  id_salt : String
  size : @math.Vec2
} derive(Eq, Debug)

///|
impl Widget for CustomBox with fn ui(self, ctx : UIContext) -> Response {
  ctx.push_id(self.id_salt)
  let (_id, _rect, resp) = ctx.allocate_space(self.size)
  ctx.pop_id()
  resp
}

///|
test "widget: custom struct implementing Widget trait via ui.add" {
  let ctx = UIContext::new()
  ctx.begin_frame(RawInput::from_mouse(@math.Vec2::new(20.0, 15.0), false))

  let custom = CustomBox::{
    id_salt: "box1",
    size: @math.Vec2::new(100.0, 50.0),
  }
  let resp = ctx.add(custom)

  assert_true(resp.hovered)
  assert_eq(resp.rect.w, 100.0)
  assert_eq(resp.rect.h, 50.0)

  let _ = ctx.end_frame()
}
