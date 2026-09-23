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
/// Semantic execution status for individual workflow steps.
pub(all) enum StepStatus {
  Wait
  Process
  Finish
  Error
} derive(Eq, Debug)

///|
/// Descriptor for an individual step item in a Steps navigation bar.
pub struct StepItem {
  title : String
  description : String
  status : StepStatus?
} derive(Eq, Debug)

///|
/// Creates a new step descriptor with title and optional description.
pub fn StepItem::new(title : String, description? : String = "") -> StepItem {
  { title, description, status: None, }
}

///|
/// Creates a step descriptor with an explicit semantic status.
pub fn StepItem::with_status(
  title : String,
  status : StepStatus,
  description? : String = "",
) -> StepItem {
  { title, description, status: Some(status), }
}

///|
/// Standalone workflow steps navigation bar widget supporting fluent configuration.
pub struct Steps {
  id_salt : String
  current : Int
  items : Array[StepItem]
  clickable : Bool
  width : Double?
} derive(Eq, Debug)

///|
/// Creates a new Steps widget with current index and item list.
pub fn Steps::new(
  id_salt : String,
  current : Int,
  items : Array[StepItem],
) -> Steps {
  { id_salt, current, items, clickable: true, width: None, }
}

///|
/// Configures whether clicking step nodes switches active index.
pub fn Steps::clickable(self : Steps, clickable : Bool) -> Steps {
  { ..self, clickable, }
}

///|
/// Sets explicit width for the steps layout.
pub fn Steps::width(self : Steps, width : Double) -> Steps {
  { ..self, width: Some(width), }
}

///|
/// Reference-bound Steps widget for uniform `ui.add(...)` dispatch.
pub struct StepsRef {
  steps : Steps
  target : Ref[Int]
}

///|
/// Creates a Steps widget bound directly to a `Ref[Int]`.
pub fn Steps::from_ref(
  id_salt : String,
  target : Ref[Int],
  items : Array[StepItem],
) -> StepsRef {
  { steps: Steps::new(id_salt, target.val, items), target, }
}

///|
pub fn StepsRef::clickable(self : StepsRef, clickable : Bool) -> StepsRef {
  { ..self, steps: self.steps.clickable(clickable), }
}

///|
pub fn StepsRef::width(self : StepsRef, width : Double) -> StepsRef {
  { ..self, steps: self.steps.width(width), }
}

///|
pub impl @core.Widget for StepsRef with fn ui(self, ctx : UIContext) -> Response {
  let (new_idx, resp) = { ..self.steps, current: self.target.val, }.show(ctx)
  self.target.val = new_idx
  resp
}

///|
/// Renders the Steps navigation bar, draws connector rails, step nodes, titles,
/// and returns the selected step index and interaction response.
pub fn Steps::show(self : Steps, ctx : UIContext) -> (Int, Response) {
  let scale = ctx.style.scale
  let circle_r = 13.0 * scale
  let font_title = ctx.style.font_normal * scale
  let font_desc = ctx.style.font_small * scale
  let n = self.items.length()

  let has_desc = self.items
    .iter()
    .any(fn(item) { item.description.length() > 0 })
  let h = if has_desc { 56.0 * scale } else { 38.0 * scale }

  let default_w = ctx.available_width()
  let avail_w = if default_w > 100.0 * scale {
    default_w
  } else {
    320.0 * scale
  }
  let w = match self.width {
    Some(w_val) => w_val * scale
    None => avail_w
  }

  ctx.push_id(self.id_salt)
  let (id, rect, resp) = ctx.allocate_space(@math.Vec2::new(w, h))
  ctx.pop_id()

  if self.clickable {
    ctx.register_focusable(id)
  }

  let is_focused = self.clickable && (resp.has_focus() || ctx.has_focus(id))

  let mut new_current = self.current
  if new_current < 0 {
    new_current = 0
  }
  if n > 0 && new_current >= n {
    new_current = n - 1
  }

  // 1. Keyboard Navigation when focused
  if is_focused && n > 1 {
    if ctx.input.key_pressed(Key::ArrowLeft) ||
      ctx.input.key_pressed(Key::ArrowDown) {
      if new_current > 0 {
        new_current = new_current - 1
      }
      ctx.input.consume_key(Key::ArrowLeft)
      ctx.input.consume_key(Key::ArrowDown)
    }
    if ctx.input.key_pressed(Key::ArrowRight) ||
      ctx.input.key_pressed(Key::ArrowUp) {
      if new_current < n - 1 {
        new_current = new_current + 1
      }
      ctx.input.consume_key(Key::ArrowRight)
      ctx.input.consume_key(Key::ArrowUp)
    }
    if ctx.input.key_pressed(Key::Home) {
      new_current = 0
      ctx.input.consume_key(Key::Home)
    }
    if ctx.input.key_pressed(Key::End) {
      new_current = n - 1
      ctx.input.consume_key(Key::End)
    }
  }

  // 2. Mouse Click & Hover Detection
  if n > 0 {
    let step_w = rect.w / n.to_double()
    for i = 0; i < n; i = i + 1 {
      let item_rect = @math.Rect::new(
        rect.x + i.to_double() * step_w,
        rect.y,
        step_w,
        h,
      )
      if self.clickable && ctx.is_hovered(item_rect) {
        ctx.set_cursor_icon("pointer")
        if resp.clicked {
          new_current = i
        }
      }
    }
  }

  // 3. Focus Ring
  if is_focused {
    let radius = ctx.style.radius_md * scale
    ctx
    .painter()
    .add_rect_stroke(
      rect.expand(2.0 * scale),
      @color.Color::border_focus(),
      1.5 * scale,
      radius + 2.0 * scale,
    )
  }

  // 4. Drawing Nodes & Rails
  if n > 0 {
    let step_w = rect.w / n.to_double()
    let circle_y = rect.y + circle_r + 2.0 * scale

    // Draw connector rails between steps
    for i = 0; i < n - 1; i = i + 1 {
      let c1_x = rect.x + (i.to_double() + 0.5) * step_w
      let c2_x = rect.x + (i.to_double() + 1.5) * step_w
      let rail_start_x = c1_x + circle_r + 6.0 * scale
      let rail_end_x = c2_x - circle_r - 6.0 * scale

      if rail_end_x > rail_start_x {
        let rail_color = if i < new_current {
          @color.Color::accent_primary()
        } else {
          @color.Color::border_muted()
        }
        ctx
        .painter()
        .add_line(
          @math.Vec2::new(rail_start_x, circle_y),
          @math.Vec2::new(rail_end_x, circle_y),
          rail_color,
          2.0 * scale,
        )
      }
    }

    // Draw step nodes (circles and labels)
    for i = 0; i < n; i = i + 1 {
      let center_x = rect.x + (i.to_double() + 0.5) * step_w
      let center = @math.Vec2::new(center_x, circle_y)

      let item = self.items[i]
      let status = match item.status {
        Some(st) => st
        None =>
          if i < new_current {
            StepStatus::Finish
          } else if i == new_current {
            StepStatus::Process
          } else {
            StepStatus::Wait
          }
      }

      // Draw node circle
      match status {
        Finish => {
          ctx
          .painter()
          .add_circle(center, circle_r, @color.Color::accent_primary())
          // Hand-drawn vector checkmark (✓), mathematically centered within the circle
          let stroke_w = 2.0 * scale
          let p1 = @math.Vec2::new(
            center_x - circle_r * 0.38,
            circle_y - circle_r * 0.02,
          )
          let p2 = @math.Vec2::new(
            center_x - circle_r * 0.10,
            circle_y + circle_r * 0.32,
          )
          let p3 = @math.Vec2::new(
            center_x + circle_r * 0.38,
            circle_y - circle_r * 0.30,
          )
          ctx.painter().add_line(p1, p2, @color.Color::text_inverse(), stroke_w)
          ctx.painter().add_line(p2, p3, @color.Color::text_inverse(), stroke_w)
        }
        Process => {
          // Subtle halo for active process node
          ctx
          .painter()
          .add_circle_stroke(
            center,
            circle_r + 3.0 * scale,
            @color.Color::accent_soft(),
            2.0 * scale,
          )
          ctx
          .painter()
          .add_circle(center, circle_r, @color.Color::accent_primary())
          let num_str = (i + 1).to_string()
          let num_sz = ctx.measure_text(num_str, font_title)
          let num_pos = @math.Vec2::new(
            center_x - num_sz.x * 0.5,
            circle_y - num_sz.y * 0.5,
          )
          ctx
          .painter()
          .add_text(num_pos, num_str, font_title, @color.Color::text_inverse())
        }
        Wait => {
          ctx.painter().add_circle(center, circle_r, @color.Color::bg_surface())
          ctx
          .painter()
          .add_circle_stroke(
            center,
            circle_r,
            @color.Color::border_default(),
            1.0 * scale,
          )
          let num_str = (i + 1).to_string()
          let num_sz = ctx.measure_text(num_str, font_title)
          let num_pos = @math.Vec2::new(
            center_x - num_sz.x * 0.5,
            circle_y - num_sz.y * 0.5,
          )
          ctx
          .painter()
          .add_text(num_pos, num_str, font_title, @color.Color::text_muted())
        }
        Error => {
          ctx.painter().add_circle(center, circle_r, @color.Color::danger())
          // Hand-drawn vector cross (✕), symmetrically centered within the circle
          let stroke_w = 2.0 * scale
          let d = circle_r * 0.34
          let q1 = @math.Vec2::new(center_x - d, circle_y - d)
          let q2 = @math.Vec2::new(center_x + d, circle_y + d)
          let q3 = @math.Vec2::new(center_x - d, circle_y + d)
          let q4 = @math.Vec2::new(center_x + d, circle_y - d)
          ctx.painter().add_line(q1, q2, @color.Color::text_inverse(), stroke_w)
          ctx.painter().add_line(q3, q4, @color.Color::text_inverse(), stroke_w)
        }
      }

      // Draw Title below circle
      let title_color = match status {
        Process => @color.Color::text_primary()
        Finish => @color.Color::text_primary()
        Error => @color.Color::danger()
        Wait => @color.Color::text_muted()
      }
      let title_y = circle_y + circle_r + 4.0 * scale
      let title_sz = ctx.measure_text(item.title, font_title)
      let title_x = center_x - title_sz.x * 0.5
      ctx
      .painter()
      .add_text(
        @math.Vec2::new(title_x, title_y),
        item.title,
        font_title,
        title_color,
      )

      // Draw Description if present
      if item.description.length() > 0 {
        let desc_y = title_y + font_title + 2.0 * scale
        let desc_sz = ctx.measure_text(item.description, font_desc)
        let desc_x = center_x - desc_sz.x * 0.5
        ctx
        .painter()
        .add_text(
          @math.Vec2::new(desc_x, desc_y),
          item.description,
          font_desc,
          @color.Color::text_secondary(),
        )
      }
    }
  }

  (new_current, resp)
}

///|
/// Convenience functional helper to render a Steps navigation bar.
pub fn steps(
  ctx : UIContext,
  id_salt : String,
  current : Int,
  items : Array[StepItem],
  clickable? : Bool = true,
  width? : Double,
) -> (Int, Response) {
  let mut s = Steps::new(id_salt, current, items).clickable(clickable)
  if width is Some(w) {
    s = s.width(w)
  }
  s.show(ctx)
}
