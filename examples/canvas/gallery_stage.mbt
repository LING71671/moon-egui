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
pub struct GalleryState {
  mut button_clicks : Int
  mut checkbox_gpu : Bool
  mut checkbox_grid : Bool
  mut checkbox_dark_contrast : Bool
  mut checkbox_antialiasing : Bool
  mut toggle_minimal : Bool
  mut toggle_autosave : Bool
  mut toggle_retina : Bool
  mut toggle_haptics : Bool
  mut radio_quality : Int
  mut slider_zoom : Double
  mut slider_opacity : Double
  mut drag_x : Double
  mut drag_y : Double
  mut drag_scale : Double
  mut knob_cutoff : Double
  mut knob_res : Double
  mut knob_pan : Double
  mut knob_drive : Double
  mut fader_vol : Double
  mut fader_gain : Double
  mut fader_l : Double
  mut fader_r : Double
  mut combo_format : Int
  mut combo_color : Int
  mut color_idx : Int
  mut progress_val : Double
  mut tree_selected : String?
  mut tree_expanded : Array[String]
  mut tab_selected : Int
  mut text_name : String
  mut text_email : String
  mut code_buffer : String
  toasts : Array[@core.Toast]
  mut cmd_open : Bool
  mut cmd_query : String
  mut cmd_idx : Int
  mut ctx_menu_open : Bool
  mut ctx_menu_pos : @math.Vec2
  mut status_text : String
  mut active_comp_id : String
  mut splitter_ratio : Double
  mut table_sort_col : String
  mut table_sort_dir : @core.TableSortDirection
  table_columns : Array[@core.TableColumn]
  mut table_selected_row : Int
  mut dialog_open : Bool
  mut dialog_last_result : String
  mut segmented_sel : Int
  mut tag1_open : Bool
  mut tag2_open : Bool
  mut tag3_open : Bool
  sparkline_data : Array[Double]
  mut color_picker_val : @color.Color
  mut breadcrumb_last_clicked : String
  mut rich_text_last_url : String
}

///|
let gallery_state : GalleryState = {
  button_clicks: 0,
  checkbox_gpu: true,
  checkbox_grid: false,
  checkbox_dark_contrast: false,
  checkbox_antialiasing: true,
  toggle_minimal: true,
  toggle_autosave: false,
  toggle_retina: true,
  toggle_haptics: false,
  radio_quality: 1,
  slider_zoom: 1.25,
  slider_opacity: 85.0,
  drag_x: 120.0,
  drag_y: 80.0,
  drag_scale: 1.0,
  knob_cutoff: 1200.0,
  knob_res: 25.0,
  knob_pan: 0.0,
  knob_drive: 6.0,
  fader_vol: 0.75,
  fader_gain: 0.0,
  fader_l: 0.65,
  fader_r: 0.65,
  combo_format: 0,
  combo_color: 1,
  color_idx: 0,
  progress_val: 0.68,
  tree_selected: Some("main_mbt"),
  tree_expanded: ["src", "assets"],
  tab_selected: 0,
  text_name: "MoonBit Developer",
  text_email: "dev@moonbitlang.com",
  code_buffer: "///| Welcome to moon-egui native CodeEditor\npub fn render(ui : @core.UIContext) -> Unit {\n  ui.label(\"Pure MoonBit Wasm Engine!\")\n  ui.button(\"Live Immediate-Mode\")\n}",
  toasts: [],
  cmd_open: false,
  cmd_query: "",
  cmd_idx: 0,
  ctx_menu_open: false,
  ctx_menu_pos: @math.Vec2::new(180.0, 140.0),
  status_text: "Ready",
  active_comp_id: "",
  splitter_ratio: 0.45,
  table_sort_col: "id",
  table_sort_dir: @core.TableSortDirection::Ascending,
  table_columns: [
    @core.TableColumn::new("id", "ID", 60.0, min_width=50.0),
    @core.TableColumn::new("name", "Name", 140.0, min_width=80.0),
    @core.TableColumn::new("role", "Role", 110.0, min_width=70.0),
    @core.TableColumn::new("score", "Score", 80.0, min_width=60.0),
  ],
  table_selected_row: 1,
  dialog_open: false,
  dialog_last_result: "None",
  segmented_sel: 0,
  tag1_open: true,
  tag2_open: true,
  tag3_open: true,
  sparkline_data: [
    12.0, 28.0, 19.0, 35.0, 22.0, 48.0, 38.0, 55.0, 42.0, 68.0, 60.0, 85.0,
  ],
  color_picker_val: @color.Color::rgb(79, 70, 229),
  breadcrumb_last_clicked: "None",
  rich_text_last_url: "None",
}

///|
let gallery_ctx : @core.UIContext = @core.UIContext::new()

///|
pub fn get_gallery_status() -> String {
  let s = gallery_state.status_text
  if s.is_empty() {
    "Ready"
  } else {
    s
  }
}

///|
pub fn get_gallery_cursor() -> String {
  gallery_ctx.cursor_icon()
}

// ----------------------------------------------------------------------
// Frame Step Dispatcher
// ----------------------------------------------------------------------

///|
fn draw_component_preview(
  ui : @core.UIContext,
  comp_id : String,
  cur_w : Double,
  cur_h : Double,
) -> Unit {
  match comp_id {
    // Basic Input (gallery_basic_stages.mbt & gallery_editor_stages.mbt)
    "button" => draw_button_showcase(ui)
    "text_edit" => draw_text_edit_showcase(ui)
    "code_editor" => draw_code_editor_showcase(ui)

    // Values & Selection (gallery_basic_stages.mbt & gallery_audio_stages.mbt & gallery_container_stages.mbt)
    "checkbox" => draw_checkbox_showcase(ui)
    "toggle" => draw_toggle_showcase(ui)
    "radio" => draw_radio_showcase(ui)
    "slider" => draw_slider_showcase(ui)
    "drag_value" => draw_drag_value_showcase(ui)
    "knob" => draw_knob_showcase(ui)
    "fader" => draw_fader_showcase(ui)
    "combo_box" => draw_combo_box_showcase(ui)
    "color_button" => draw_color_button_showcase(ui)

    // Feedback & Presentation (gallery_basic_stages.mbt & gallery_container_stages.mbt & gallery_data_stages.mbt)
    "progress_bar" => draw_progress_bar_showcase(ui)
    "collapsing_header" => draw_collapsing_header_showcase(ui)
    "tree_view" => draw_tree_view_showcase(ui)
    "tooltip" => draw_tooltip_showcase(ui)

    // Containers & Layout (gallery_nav_stages.mbt & gallery_container_stages.mbt & gallery_data_stages.mbt)
    "tab_bar" => draw_tab_bar_showcase(ui)
    "menu_bar" => draw_menu_bar_showcase(ui)
    "scroll_area" => draw_scroll_area_showcase(ui)
    "window" => draw_window_showcase(ui, cur_w, cur_h)
    "command_palette" => draw_command_palette_showcase(ui)
    "context_menu" => draw_context_menu_showcase(ui, cur_w, cur_h)
    "toast" => draw_toast_showcase(ui, cur_w, cur_h)
    "splitter" => draw_splitter_showcase(ui)
    "table" => draw_table_showcase(ui)
    "dialog" => draw_dialog_showcase(ui, cur_w, cur_h)
    "spinner" => draw_spinner_showcase(ui)
    "sparkline" => draw_sparkline_showcase(ui)
    "plot" => draw_plot_showcase(ui)
    "bar_chart" => draw_bar_chart_showcase(ui)
    "segmented_control" => draw_segmented_control_showcase(ui)
    "badge" => draw_badge_showcase(ui)
    "breadcrumb" => draw_breadcrumb_showcase(ui)
    "color_picker" => draw_color_picker_showcase(ui)
    "rich_text" => draw_rich_text_showcase(ui)
    _ => {
      let _ = ui.label_colored(
        "MoonBit 原生组件: " + comp_id,
        @color.Color::accent_primary(),
      )
      ui.spacer(10.0)
      draw_button_showcase(ui)
    }
  }
}

///|
/// Native MoonBit Component Showcase Frame Entry Point.
/// Evaluates native widgets and returns pure @draw.DrawList to JavaScript.
pub fn gallery_step(
  comp_id : String,
  mouse_x : Double,
  mouse_y : Double,
  mouse_down : Bool,
  scroll_dy : Double,
  vp_w : Double,
  vp_h : Double,
  text_input : String,
  keys_pressed : Array[String],
  keys_released : Array[String],
  mod_flags : Int,
  mouse_secondary_down? : Bool = false,
) -> @draw.DrawList {
  let cur_w = if vp_w > 100.0 { vp_w } else { 800.0 }
  let cur_h = if vp_h > 100.0 { vp_h } else { 500.0 }

  // 1. Convert host inputs to RawInput
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

  // 2. Begin Frame
  if comp_id != gallery_state.active_comp_id {
    gallery_state.active_comp_id = comp_id
    gallery_state.cmd_open = false
    gallery_state.ctx_menu_open = false
    gallery_ctx.set_open_combo_id(@core.Id::zero())
    gallery_ctx.set_open_menu_id(@core.Id::zero())
  }
  gallery_ctx.begin_frame(raw)

  // 3. Render Subtle Studio Light Grid Background
  let painter = gallery_ctx.painter()
  painter.add_rect(
    @math.Rect::new(0.0, 0.0, cur_w, cur_h),
    @color.Color::bg_subtle(),
    0.0,
  )

  // 4. Centered White Porcelain Card Container
  let pad_x = if cur_w > 560.0 { 32.0 } else { 12.0 }
  let pad_y = 24.0
  let card_w = cur_w - pad_x * 2.0
  let card_h = cur_h - pad_y * 2.0
  let card_rect = @math.Rect::new(pad_x, pad_y, card_w, card_h)

  // Porcelain Card Disc & Border Shadow
  painter.add_rect(
    @math.Rect::new(pad_x, pad_y + 2.0, card_w, card_h),
    @color.Color::shadow(),
    8.0,
  )
  painter.add_rect(card_rect, @color.Color::bg_window(), 8.0)
  painter.add_rect_stroke(card_rect, @color.Color::border_default(), 1.0, 8.0)

  // Layout Cursor within Porcelain Card
  gallery_ctx.set_cursor(@math.Vec2::new(pad_x + 20.0, pad_y + 18.0))
  gallery_ctx.set_available_width(card_w - 40.0)

  // 5. Component Showcase Dispatcher for ALL components
  draw_component_preview(gallery_ctx, comp_id, card_w, card_h)

  // 6. End Frame & Output DrawList
  gallery_ctx.end_frame()
}
