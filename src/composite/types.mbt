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
pub type UIContext = @core.UIContext

///|
pub type Response = @core.Response

///|
pub type Id = @core.Id

///|
pub type IdStack = @core.IdStack

///|
pub type Painter = @core.Painter

///|
pub type WidgetStyle = @core.WidgetStyle

///|
pub type Theme = @core.Theme

///|
pub type RawInput = @core.RawInput

///|
pub type InputState = @core.InputState

///|
pub type Key = @core.Key

///|
pub type Modifiers = @core.Modifiers

///|
pub type Event = @core.Event

///|
pub type Memory = @core.Memory

///|
pub fn string_slice(s : String, start : Int, end : Int) -> String {
  @core.string_slice(s, start, end)
}

///|
pub fn prev_char_boundary(text : String, pos : Int) -> Int {
  @core.prev_char_boundary(text, pos)
}

///|
pub fn next_char_boundary(text : String, pos : Int) -> Int {
  @core.next_char_boundary(text, pos)
}

///|
pub fn delete_prev_char(text : String, pos : Int) -> (String, Int) {
  @core.delete_prev_char(text, pos)
}

///|
pub fn delete_next_char(text : String, pos : Int) -> String {
  @core.delete_next_char(text, pos)
}

///|
pub fn is_cjk_char(code : Int) -> Bool {
  @core.is_cjk_char(code)
}

///|
pub fn is_cjk_closing_punct(code : Int) -> Bool {
  @core.is_cjk_closing_punct(code)
}
