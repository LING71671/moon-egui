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
/// Core dispatch trait for first-class widgets that return a Response.
/// Implementing this trait allows any widget to be added to a UIContext
/// via `ui.add(widget)`.
pub trait Widget {
  fn ui(Self, UIContext) -> Response
}

///|
/// Add a widget implementing the `Widget` trait to the current UI container.
pub fn[W : Widget] UIContext::add(self : UIContext, widget : W) -> Response {
  widget.ui(self)
}
