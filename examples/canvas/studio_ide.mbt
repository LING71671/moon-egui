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
struct StudioFile {
  id : String
  path : String
  name : String
  mut content : String
}

///|
struct TerminalLine {
  text : String
  color : @color.Color
}

///|
let code_steps_sample : String =
  #|// MoonBit Immediate-Mode Steps Navigation Widget
  #|pub struct Steps {
  #|  id_salt : String
  #|  current : Int
  #|  items : Array[StepItem]
  #|}
  #|
  #|pub fn Steps::show(self : Steps, ctx : @core.UIContext) -> Response {
  #|  let p = ctx.painter()
  #|  let count = self.items.length()
  #|  for i = 0; i < count; i = i + 1 {
  #|    let center = self.step_center(i)
  #|    let r = 12.0 * ctx.style.scale
  #|    if i < self.current {
  #|      // Centered vector checkmark geometry
  #|      p.add_circle(center, r, @color.Color::accent_primary())
  #|      let p1 = @math.Vec2::new(center.x - r * 0.42, center.y - r * 0.04)
  #|      let p2 = @math.Vec2::new(center.x - r * 0.10, center.y + r * 0.32)
  #|      let p3 = @math.Vec2::new(center.x + r * 0.44, center.y - r * 0.32)
  #|      p.add_line(p1, p2, @color.Color::white(), 1.8)
  #|      p.add_line(p2, p3, @color.Color::white(), 1.8)
  #|    }
  #|  }
  #|  ctx.allocate_space(@math.Vec2::new(ctx.available_width(), 48.0))
  #|}

///|
let code_mesh_sample : String =
  #|// WebGL 2.0 2D Mesh Batching & Tessellation Pipeline
  #|pub struct Vertex {
  #|  x : Float
  #|  y : Float
  #|  u : Float
  #|  v : Float
  #|  r : Float
  #|  g : Float
  #|  b : Float
  #|  a : Float
  #|} derive(Eq, Debug)
  #|
  #|pub struct Mesh {
  #|  vertices : Array[Vertex]
  #|  indices : Array[Int]
  #|} derive(Eq, Debug)
  #|
  #|pub fn tessellate_rect(
  #|  rect : @math.Rect,
  #|  color : @color.Color,
  #|  radius : Double
  #|) -> Mesh {
  #|  let mesh = Mesh::new()
  #|  // Direct zero-copy triangulation into GPU vertex buffer
  #|  mesh.append_rect_triangles(rect, color, radius)
  #|  mesh
  #|}

///|
let code_context_sample : String =
  #|// Moon-EGUI Immediate-Mode Core Execution Context
  #|pub struct UIContext {
  #|  input : InputState
  #|  id_stack : IdStack
  #|  layout : LayoutEngine
  #|  focus : FocusManager
  #|  layers : LayerManager
  #|  windows : WindowManager
  #|  memory : Memory
  #|  mut style : WidgetStyle
  #|  mut theme : Theme
  #|  mut cursor_icon : String
  #|  mut time : Double
  #|  mut frame_counter : Int
  #|}
  #|
  #|pub fn UIContext::allocate_space(
  #|  self : UIContext,
  #|  size : @math.Vec2
  #|) -> (Id, @math.Rect, Response) {
  #|  let id = self.next_auto_id()
  #|  let rect = self.layout.allocate_rect(size)
  #|  // Hit-testing, focus, and pointer state evaluation
  #|  let resp = self.interact(id, rect)
  #|  (id, rect, resp)
  #|}

///|
let code_mod_sample : String =
  #|module "LING71671/moon-egui"
  #|
  #|version = "0.5.1"
  #|
  #|license = "Apache-2.0"
  #|readme = "README.md"
  #|repository = "https://github.com/LING71671/moon-egui"
  #|description = "High-performance, pure MoonBit Immediate-Mode GUI library for WebAssembly, Canvas, and Games."
  #|keywords = ["gui", "egui", "imgui", "canvas", "wasm", "immediate-mode", "ui"]

///|
let code_readme_sample : String =
  #|# moon-egui
  #|
  #|**Lightweight Immediate-Mode GUI Library for MoonBit & WebAssembly**
  #|
  #|- 100% Pure MoonBit implementation with zero FFI dependencies
  #|- 42+ production-grade standard and composite widgets
  #|- Hardware-accelerated WebGL 2.0 mesh tessellation pipeline
  #|- 335 automated unit and headless integration tests (100% passing)
  #|
  #|```bash
  #|moon add LING71671/moon-egui@0.5.1
  #|```

///|
pub struct StudioState {
  files : Array[StudioFile]
  open_tabs : Array[Int]
  mut active_tab : Int
  mut split_h_ratio : Double
  mut split_v_ratio : Double
  terminal_lines : Array[TerminalLine]
  term_tab : Int
  mut cmd_palette_open : Bool
  mut cmd_query : String
  mut cmd_index : Int
  mut tree_expanded : Array[String]
  mut initialized : Bool
}

///|
let studio_state : StudioState = {
  files: [
    {
      id: "steps_mbt",
      path: "src/widgets/steps.mbt",
      name: "steps.mbt",
      content: code_steps_sample,
    },
    {
      id: "mesh_mbt",
      path: "src/draw/mesh.mbt",
      name: "mesh.mbt",
      content: code_mesh_sample,
    },
    {
      id: "context_mbt",
      path: "src/core/context.mbt",
      name: "context.mbt",
      content: code_context_sample,
    },
    {
      id: "moon_mod",
      path: "moon.mod",
      name: "moon.mod",
      content: code_mod_sample,
    },
    {
      id: "readme_md",
      path: "README.md",
      name: "README.md",
      content: code_readme_sample,
    },
  ],
  open_tabs: [0, 1, 2],
  active_tab: 0,
  split_h_ratio: 0.22,
  split_v_ratio: 0.72,
  terminal_lines: [
    {
      text: "=== Moon-EGUI Studio (100% Pure Canvas 2D / Wasm-GC) ===",
      color: @color.Color::accent_primary(),
    },
    {
      text: "Zero HTML DOM elements. Full immediate-mode pipeline active.",
      color: @color.Color::text_secondary(),
    },
    {
      text: "Click files on left to switch, edit code in center, run commands below.",
      color: @color.Color::text_muted(),
    },
    { text: "$ moon test", color: @color.Color::accent_hover(), },
    {
      text: "Total tests: 335, passed: 335, failed: 0 (100% passing).",
      color: @color.Color::success(),
    },
  ],
  term_tab: 0,
  cmd_palette_open: false,
  cmd_query: "",
  cmd_index: 0,
  tree_expanded: ["root", "src", "widgets", "draw", "core"],
  initialized: false,
}

///|
let studio_ctx : @core.UIContext = @core.UIContext::new()

///|
fn build_studio_tree_nodes() -> Array[@composite.TreeNode] {
  [
    @composite.TreeNode::new(
      "root",
      "moon-project",
      children=[
        @composite.TreeNode::leaf("moon_mod", "moon.mod", icon="📦"),
        @composite.TreeNode::leaf("readme_md", "README.md", icon="📝"),
        @composite.TreeNode::new(
          "src",
          "src",
          children=[
            @composite.TreeNode::new(
              "core",
              "core",
              children=[
                @composite.TreeNode::leaf(
                  "context_mbt",
                  "context.mbt",
                  icon="📄",
                ),
              ],
              icon="📁",
            ),
            @composite.TreeNode::new(
              "widgets",
              "widgets",
              children=[
                @composite.TreeNode::leaf("steps_mbt", "steps.mbt", icon="📄"),
              ],
              icon="📁",
            ),
            @composite.TreeNode::new(
              "draw",
              "draw",
              children=[
                @composite.TreeNode::leaf("mesh_mbt", "mesh.mbt", icon="📄"),
              ],
              icon="📁",
            ),
          ],
          icon="📁",
        ),
      ],
      icon="📂",
    ),
  ]
}

///|
fn execute_studio_command(state : StudioState, cmd : String) -> Unit {
  state.terminal_lines.push({
    text: "$ " + cmd,
    color: @color.Color::accent_hover(),
  })
  if cmd == "moon test" {
    state.terminal_lines.push({
      text: "Running moon check ...",
      color: @color.Color::text_muted(),
    })
    state.terminal_lines.push({
      text: "Finished. moon: ran 4 tasks, now up to date",
      color: @color.Color::text_secondary(),
    })
    state.terminal_lines.push({
      text: "Total tests: 335, passed: 335, failed: 0.",
      color: @color.Color::success(),
    })
    state.terminal_lines.push({
      text: "✓ All whitebox & integration test suites passed cleanly.",
      color: @color.Color::success(),
    })
  } else if cmd == "moon fmt" {
    state.terminal_lines.push({
      text: "Running moon fmt ...",
      color: @color.Color::text_muted(),
    })
    state.terminal_lines.push({
      text: "Finished. Formatted all MoonBit source blocks cleanly.",
      color: @color.Color::success(),
    })
  } else if cmd == "moon check" {
    state.terminal_lines.push({
      text: "Running moon check --target wasm-gc ...",
      color: @color.Color::text_muted(),
    })
    state.terminal_lines.push({
      text: "Finished. 11 tasks checked, 0 type errors, 0 warnings.",
      color: @color.Color::success(),
    })
  } else if cmd == "clear" {
    state.terminal_lines.clear()
    state.terminal_lines.push({
      text: "Terminal log cleared.",
      color: @color.Color::text_muted(),
    })
  } else {
    state.terminal_lines.push({
      text: "Available studio commands: moon test, moon fmt, moon check, clear",
      color: @color.Color::text_muted(),
    })
  }
}

///|
fn open_or_activate_file(state : StudioState, file_id : String) -> Unit {
  let mut target_idx = -1
  for i = 0; i < state.files.length(); i = i + 1 {
    if state.files[i].id == file_id {
      target_idx = i
      break
    }
  }
  if target_idx < 0 {
    return
  }
  // Check if already in open_tabs
  let mut tab_pos = -1
  for i = 0; i < state.open_tabs.length(); i = i + 1 {
    if state.open_tabs[i] == target_idx {
      tab_pos = i
      break
    }
  }
  if tab_pos >= 0 {
    state.active_tab = tab_pos
  } else {
    state.open_tabs.push(target_idx)
    state.active_tab = state.open_tabs.length() - 1
  }
}

///|
pub fn studio_step(
  cur_w : Double,
  cur_h : Double,
  mouse_x : Double,
  mouse_y : Double,
  mouse_down : Bool,
  scroll_dy : Double,
  text_input : String,
  keys_pressed : Array[String],
  keys_released : Array[String],
  mod_flags : Int,
  mouse_secondary_down? : Bool = false,
) -> @draw.DrawList {
  // 1. Initialize dark studio theme on first run
  if !studio_state.initialized {
    studio_ctx.set_theme(@core.Theme::slate_dark())
    studio_state.initialized = true
  }

  // 2. Keyboard shortcut for Command Palette (Ctrl+P or Cmd+P)
  if keys_pressed.contains("p") &&
    ((mod_flags & 1) != 0 || (mod_flags & 8) != 0) {
    studio_state.cmd_palette_open = !studio_state.cmd_palette_open
  }

  // 3. Begin immediate-mode GUI frame
  let raw = host_raw_input(
    mouse_x,
    mouse_y,
    mouse_down,
    text_input,
    keys_pressed,
    keys_released,
    mod_flags,
    scroll_dy~,
    mouse_secondary_down~,
  )
  studio_ctx.begin_frame(raw)

  let painter = studio_ctx.painter()
  let scale = studio_ctx.style.scale

  // Background full canvas fill (Studio Dark Theme)
  painter.add_rect(
    @math.Rect::new(0.0, 0.0, cur_w, cur_h),
    @color.Color::hex(0x181818),
    0.0,
  )

  let top_bar_h = 36.0 * scale
  let status_bar_h = 24.0 * scale
  let main_h = cur_h - top_bar_h - status_bar_h

  // --------------------------------------------------------------------------
  // TOP MENU & TOOLBAR
  // --------------------------------------------------------------------------
  studio_ctx.set_cursor(@math.Vec2::new(0.0, 0.0))
  studio_ctx.set_available_width(cur_w)

  // Top header bar background & border
  painter.add_rect(
    @math.Rect::new(0.0, 0.0, cur_w, top_bar_h),
    @color.Color::hex(0x181818),
    0.0,
  )
  painter.add_line(
    @math.Vec2::new(0.0, top_bar_h),
    @math.Vec2::new(cur_w, top_bar_h),
    @color.Color::hex(0x2B2B2B),
    1.0,
  )

  studio_ctx.set_cursor(@math.Vec2::new(12.0 * scale, 6.0 * scale))
  studio_ctx.horizontal(fn(row) {
    // 1. Vector Moon Brand Icon (precision geometry, no unicode glitched glyphs)
    let icon_rect = @math.Rect::new(
      row.cursor().x,
      row.cursor().y + 2.0 * scale,
      20.0 * scale,
      20.0 * scale,
    )
    painter.add_rect(icon_rect, @color.Color::hex(0x0F172A), 4.0 * scale)
    painter.add_rect_stroke(
      icon_rect,
      @color.Color::hex(0x38BDF8),
      1.0,
      4.0 * scale,
    )
    let icon_center = @math.Vec2::new(
      icon_rect.x + 10.0 * scale,
      icon_rect.y + 10.0 * scale,
    )
    painter.add_circle(icon_center, 5.5 * scale, @color.Color::hex(0x38BDF8))
    painter.add_circle(
      @math.Vec2::new(icon_center.x + 2.5 * scale, icon_center.y - 1.5 * scale),
      4.2 * scale,
      @color.Color::hex(0x0F172A),
    )
    let _ = row.allocate_space(@math.Vec2::new(20.0 * scale, 24.0 * scale))

    row.spacer(4.0 * scale)
    let _ = row.label_colored("moon-egui", @color.Color::white())

    // STUDIO Pill Badge
    let badge_rect = @math.Rect::new(
      row.cursor().x,
      row.cursor().y + 3.0 * scale,
      50.0 * scale,
      18.0 * scale,
    )
    painter.add_rect(badge_rect, @color.Color::hex(0x1E293B), 9.0 * scale)
    painter.add_rect_stroke(
      badge_rect,
      @color.Color::hex(0x334155),
      1.0,
      9.0 * scale,
    )
    painter.add_text(
      @math.Vec2::new(badge_rect.x + 8.0 * scale, badge_rect.y + 3.0 * scale),
      "STUDIO",
      studio_ctx.style.font_xs * scale,
      @color.Color::hex(0x38BDF8),
    )
    let _ = row.allocate_space(@math.Vec2::new(50.0 * scale, 24.0 * scale))

    row.spacer(16.0 * scale)

    // Top Menus (auto-sized text triggers)
    if @widgets.Button::new("文件")
      .size(@math.Vec2::new(0.0, 24.0 * scale))
      .ui(row).clicked {
      studio_state.terminal_lines.push({
        text: "Menu: File -> All open buffers saved.",
        color: @color.Color::text_secondary(),
      })
    }
    if @widgets.Button::new("编辑")
      .size(@math.Vec2::new(0.0, 24.0 * scale))
      .ui(row).clicked {
      execute_studio_command(studio_state, "moon fmt")
    }
    if @widgets.Button::new("运行")
      .size(@math.Vec2::new(0.0, 24.0 * scale))
      .ui(row).clicked {
      execute_studio_command(studio_state, "moon test")
    }

    row.spacer(16.0 * scale)

    // Quick Action Buttons (clean labels, dynamic sizing, generous padding)
    if @widgets.Button::new("▶ 运行测试")
      .size(@math.Vec2::new(0.0, 24.0 * scale))
      .primary(true)
      .ui(row).clicked {
      execute_studio_command(studio_state, "moon test")
    }
    if @widgets.Button::new("格式化代码")
      .size(@math.Vec2::new(0.0, 24.0 * scale))
      .ui(row).clicked {
      execute_studio_command(studio_state, "moon fmt")
    }
    if @widgets.Button::new("⌘K 快捷面板")
      .size(@math.Vec2::new(0.0, 24.0 * scale))
      .ui(row).clicked {
      studio_state.cmd_palette_open = !studio_state.cmd_palette_open
    }
  })

  // --------------------------------------------------------------------------
  // MAIN WORKBENCH (HORIZONTAL SPLIT: EXPLORER vs EDITOR/TERMINAL)
  // --------------------------------------------------------------------------
  studio_ctx.set_cursor(@math.Vec2::new(0.0, top_bar_h))
  studio_ctx.set_available_width(cur_w)

  let main_size = @math.Vec2::new(cur_w, main_h)

  studio_state.split_h_ratio = @widgets.Splitter::horizontal(
      "studio_h_split",
      studio_state.split_h_ratio,
      main_size,
    )
    .min_ratio(0.12)
    .max_ratio(0.40)
    .min_px(160.0 * scale)
    .show(
      studio_ctx,
      fn(left_ctx, left_rect) {
        // Left Pane: File Explorer
        painter.add_rect(left_rect, @color.Color::hex(0x181818), 0.0)

        left_ctx.set_cursor(
          @math.Vec2::new(left_rect.x + 8.0 * scale, left_rect.y + 8.0 * scale),
        )
        left_ctx.set_available_width(left_rect.w - 16.0 * scale)

        let _ = left_ctx.label_colored(
          "工程资源管理器 (EXPLORER)",
          @color.Color::text_muted(),
        )
        left_ctx.separator()

        let nodes = build_studio_tree_nodes()
        let active_file_id = if studio_state.open_tabs.length() > 0 &&
          studio_state.active_tab < studio_state.open_tabs.length() {
          let f_idx = studio_state.open_tabs[studio_state.active_tab]
          Some(studio_state.files[f_idx].id)
        } else {
          None
        }

        let tree_resp = @composite.tree_view(
          left_ctx,
          "studio_tree",
          nodes,
          selected_id=active_file_id,
          expanded_ids=studio_state.tree_expanded,
        )

        studio_state.tree_expanded = tree_resp.expanded_ids
        match tree_resp.clicked_id {
          Some(cid) => open_or_activate_file(studio_state, cid)
          None => ()
        }
      },
      fn(right_ctx, right_rect) {
        // Right Pane: Vertical Split (Editor on Top, Terminal on Bottom)
        studio_state.split_v_ratio = @widgets.Splitter::vertical(
            "studio_v_split",
            studio_state.split_v_ratio,
            @math.Vec2::new(right_rect.w, right_rect.h),
          )
          .min_ratio(0.35)
          .max_ratio(0.85)
          .min_px(100.0 * scale)
          .show(
            right_ctx,
            fn(ed_ctx, ed_rect) {
              // Top: Editor Tabs + Code Editor Viewport
              painter.add_rect(ed_rect, @color.Color::hex(0x1E1E1E), 0.0)

              let tab_bar_h = 32.0 * scale
              painter.add_rect(
                @math.Rect::new(ed_rect.x, ed_rect.y, ed_rect.w, tab_bar_h),
                @color.Color::hex(0x181818),
                0.0,
              )
              painter.add_line(
                @math.Vec2::new(ed_rect.x, ed_rect.y + tab_bar_h),
                @math.Vec2::new(ed_rect.x + ed_rect.w, ed_rect.y + tab_bar_h),
                @color.Color::hex(0x2B2B2B),
                1.0,
              )

              // Editor Tabs
              ed_ctx.set_cursor(
                @math.Vec2::new(
                  ed_rect.x + 4.0 * scale,
                  ed_rect.y + 4.0 * scale,
                ),
              )
              ed_ctx.set_available_width(ed_rect.w - 8.0 * scale)

              ed_ctx.horizontal(fn(tab_row) {
                for t_idx = 0
                    t_idx < studio_state.open_tabs.length()
                    t_idx = t_idx + 1 {
                  let f_idx = studio_state.open_tabs[t_idx]
                  let file = studio_state.files[f_idx]
                  let is_active = t_idx == studio_state.active_tab

                  let tab_title = if is_active {
                    "● " + file.name
                  } else {
                    file.name
                  }
                  let tab_btn = @widgets.Button::new(tab_title)
                    .size(@math.Vec2::new(0.0, 24.0 * scale))
                    .primary(is_active)
                    .ui(tab_row)
                  if tab_btn.clicked {
                    studio_state.active_tab = t_idx
                  }
                }
              })

              // Active File Breadcrumb
              let breadcrumb_y = ed_rect.y + tab_bar_h
              let breadcrumb_h = 22.0 * scale
              painter.add_rect(
                @math.Rect::new(
                  ed_rect.x,
                  breadcrumb_y,
                  ed_rect.w,
                  breadcrumb_h,
                ),
                @color.Color::hex(0x1F1F1F),
                0.0,
              )
              painter.add_line(
                @math.Vec2::new(ed_rect.x, breadcrumb_y + breadcrumb_h),
                @math.Vec2::new(
                  ed_rect.x + ed_rect.w,
                  breadcrumb_y + breadcrumb_h,
                ),
                @color.Color::hex(0x282828),
                1.0,
              )

              ed_ctx.set_cursor(
                @math.Vec2::new(
                  ed_rect.x + 12.0 * scale,
                  breadcrumb_y + 4.0 * scale,
                ),
              )
              if studio_state.open_tabs.length() > 0 &&
                studio_state.active_tab < studio_state.open_tabs.length() {
                let f_idx = studio_state.open_tabs[studio_state.active_tab]
                let path_str = "moon-project > " +
                  studio_state.files[f_idx].path
                let _ = ed_ctx.label_colored(
                  path_str,
                  @color.Color::text_secondary(),
                )
              }

              // Code Editor Area
              let editor_y = breadcrumb_y + breadcrumb_h
              let editor_h = ed_rect.h - (tab_bar_h + breadcrumb_h)
              ed_ctx.set_cursor(@math.Vec2::new(ed_rect.x, editor_y))
              ed_ctx.set_available_width(ed_rect.w)

              if studio_state.open_tabs.length() > 0 &&
                studio_state.active_tab < studio_state.open_tabs.length() {
                let f_idx = studio_state.open_tabs[studio_state.active_tab]
                let current_text = studio_state.files[f_idx].content
                let (new_text, _) = @composite.code_editor(
                  ed_ctx,
                  "code_ed_" + studio_state.files[f_idx].id,
                  current_text,
                  size=@math.Vec2::new(ed_rect.w, editor_h),
                  show_line_numbers=true,
                )
                studio_state.files[f_idx].content = new_text
              }
            },
            fn(term_ctx, term_rect) {
              // Bottom: Terminal & Output Panel
              painter.add_rect(term_rect, @color.Color::hex(0x181818), 0.0)

              let term_bar_h = 28.0 * scale
              painter.add_rect(
                @math.Rect::new(
                  term_rect.x,
                  term_rect.y,
                  term_rect.w,
                  term_bar_h,
                ),
                @color.Color::hex(0x1F1F1F),
                0.0,
              )
              painter.add_line(
                @math.Vec2::new(term_rect.x, term_rect.y + term_bar_h),
                @math.Vec2::new(
                  term_rect.x + term_rect.w,
                  term_rect.y + term_bar_h,
                ),
                @color.Color::hex(0x2B2B2B),
                1.0,
              )

              // Terminal Header Tabs & Action Buttons
              term_ctx.set_cursor(
                @math.Vec2::new(
                  term_rect.x + 8.0 * scale,
                  term_rect.y + 2.0 * scale,
                ),
              )
              term_ctx.set_available_width(term_rect.w - 16.0 * scale)

              term_ctx.horizontal(fn(t_row) {
                let _ = t_row.label_colored(
                  "终端控制台 (TERMINAL)",
                  @color.Color::accent_primary(),
                )
                t_row.spacer(16.0 * scale)

                if @widgets.Button::new("moon test")
                  .size(@math.Vec2::new(0.0, 22.0 * scale))
                  .ui(t_row).clicked {
                  execute_studio_command(studio_state, "moon test")
                }
                if @widgets.Button::new("moon check")
                  .size(@math.Vec2::new(0.0, 22.0 * scale))
                  .ui(t_row).clicked {
                  execute_studio_command(studio_state, "moon check")
                }
                if @widgets.Button::new("moon fmt")
                  .size(@math.Vec2::new(0.0, 22.0 * scale))
                  .ui(t_row).clicked {
                  execute_studio_command(studio_state, "moon fmt")
                }
                if @widgets.Button::new("Clear")
                  .size(@math.Vec2::new(0.0, 22.0 * scale))
                  .ui(t_row).clicked {
                  execute_studio_command(studio_state, "clear")
                }
              })

              // Terminal Output Log Lines
              let term_body_y = term_rect.y + term_bar_h + 4.0 * scale
              term_ctx.set_cursor(
                @math.Vec2::new(term_rect.x + 12.0 * scale, term_body_y),
              )
              term_ctx.set_available_width(term_rect.w - 24.0 * scale)

              let lines_to_show = studio_state.terminal_lines
              let start_idx = if lines_to_show.length() > 8 {
                lines_to_show.length() - 8
              } else {
                0
              }

              for l_idx = start_idx
                  l_idx < lines_to_show.length()
                  l_idx = l_idx + 1 {
                let line = lines_to_show[l_idx]
                let _ = term_ctx.label_colored(line.text, line.color)
              }
            },
          )
      },
    )

  // --------------------------------------------------------------------------
  // BOTTOM STATUS BAR
  // --------------------------------------------------------------------------
  let status_y = cur_h - status_bar_h
  painter.add_rect(
    @math.Rect::new(0.0, status_y, cur_w, status_bar_h),
    @color.Color::hex(0x007ACC),
    0.0,
  )

  studio_ctx.set_cursor(@math.Vec2::new(12.0 * scale, status_y + 4.0 * scale))
  studio_ctx.set_available_width(cur_w - 24.0 * scale)
  studio_ctx.horizontal(fn(stat_row) {
    let _ = stat_row.label_colored("⎇ main*", @color.Color::white())
    stat_row.spacer(14.0 * scale)
    let _ = stat_row.label_colored(
      "✓ 335 / 335 Tests Passed",
      @color.Color::white(),
    )
    stat_row.spacer(14.0 * scale)
    let _ = stat_row.label_colored("MoonBit v0.5.1", @color.Color::white())
    stat_row.spacer(14.0 * scale)
    let _ = stat_row.label_colored(
      "WebAssembly (wasm-gc)",
      @color.Color::white(),
    )
    stat_row.spacer(14.0 * scale)
    let _ = stat_row.label_colored(
      "60 FPS Immediate Mode Canvas",
      @color.Color::white(),
    )
  })

  // --------------------------------------------------------------------------
  // FOREGROUND COMMAND PALETTE (Ctrl+P / ⌘K)
  // --------------------------------------------------------------------------
  if studio_state.cmd_palette_open {
    let cmd_items = [
      @composite.CommandItem::new(
        "open_steps",
        "Open src/widgets/steps.mbt",
        category="File",
        shortcut="Enter",
      ),
      @composite.CommandItem::new(
        "open_mesh",
        "Open src/draw/mesh.mbt",
        category="File",
        shortcut="Enter",
      ),
      @composite.CommandItem::new(
        "open_context",
        "Open src/core/context.mbt",
        category="File",
        shortcut="Enter",
      ),
      @composite.CommandItem::new(
        "open_mod",
        "Open moon.mod",
        category="File",
        shortcut="Enter",
      ),
      @composite.CommandItem::new(
        "cmd_test",
        "Run moon test",
        category="Command",
        shortcut="F5",
      ),
      @composite.CommandItem::new(
        "cmd_fmt",
        "Run moon fmt",
        category="Command",
        shortcut="Shift+Alt+F",
      ),
      @composite.CommandItem::new(
        "cmd_check",
        "Run moon check",
        category="Command",
      ),
      @composite.CommandItem::new(
        "cmd_clear",
        "Clear Terminal",
        category="Terminal",
      ),
    ]

    let pal_resp = @composite.command_palette(
      studio_ctx,
      studio_state.cmd_palette_open,
      studio_state.cmd_query,
      cmd_items,
      selected_index=studio_state.cmd_index,
      viewport_size=@math.Vec2::new(cur_w, cur_h),
    )

    studio_state.cmd_palette_open = pal_resp.open
    studio_state.cmd_query = pal_resp.query
    studio_state.cmd_index = pal_resp.selected_index

    match pal_resp.selected_id {
      Some("open_steps") => {
        open_or_activate_file(studio_state, "steps_mbt")
        studio_state.cmd_palette_open = false
      }
      Some("open_mesh") => {
        open_or_activate_file(studio_state, "mesh_mbt")
        studio_state.cmd_palette_open = false
      }
      Some("open_context") => {
        open_or_activate_file(studio_state, "context_mbt")
        studio_state.cmd_palette_open = false
      }
      Some("open_mod") => {
        open_or_activate_file(studio_state, "moon_mod")
        studio_state.cmd_palette_open = false
      }
      Some("cmd_test") => {
        execute_studio_command(studio_state, "moon test")
        studio_state.cmd_palette_open = false
      }
      Some("cmd_fmt") => {
        execute_studio_command(studio_state, "moon fmt")
        studio_state.cmd_palette_open = false
      }
      Some("cmd_check") => {
        execute_studio_command(studio_state, "moon check")
        studio_state.cmd_palette_open = false
      }
      Some("cmd_clear") => {
        execute_studio_command(studio_state, "clear")
        studio_state.cmd_palette_open = false
      }
      _ => ()
    }
  }

  // 4. End Frame & Output DrawList
  studio_ctx.end_frame()
}

///|
pub fn get_studio_cursor() -> String {
  studio_ctx.cursor_icon()
}
