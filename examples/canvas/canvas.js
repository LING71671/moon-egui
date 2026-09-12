function _M0TP49LING7167111moon_2degui3src5color5Color(param0, param1, param2, param3) {
  this.r = param0;
  this.g = param1;
  this.b = param2;
  this.a = param3;
}
function _M0TP49LING7167111moon_2degui3src4math4Vec2(param0, param1) {
  this.x = param0;
  this.y = param1;
}
function _M0TP49LING7167111moon_2degui3src4core2Id(param0) {
  this.val = param0;
}
function _M0TP49LING7167111moon_2degui3src4core9Modifiers(param0, param1, param2, param3) {
  this.ctrl = param0;
  this.shift = param1;
  this.alt = param2;
  this.meta = param3;
}
function _M0TP49LING7167111moon_2degui8examples6canvas14BenchmarkState(param0, param1, param2, param3, param4, param5, param6, param7, param8, param9, param10, param11, param12, param13, param14, param15, param16, param17, param18, param19, param20, param21, param22, param23, param24) {
  this.grid_dim = param0;
  this.wave_pulse = param1;
  this.magnetic_repel = param2;
  this.ripple_active = param3;
  this.ripple_cx = param4;
  this.ripple_cy = param5;
  this.ripple_progress = param6;
  this.frame_tick = param7;
  this.click_count = param8;
  this.cam_x = param9;
  this.cam_y = param10;
  this.zoom = param11;
  this.selected_id = param12;
  this.selected_col = param13;
  this.selected_row = param14;
  this.drag_mode = param15;
  this.item_drag_dx = param16;
  this.item_drag_dy = param17;
  this.is_dragging_item = param18;
  this.visible_cells = param19;
  this.show_studio = param20;
  this.panel_tab = param21;
  this.jump_text = param22;
  this.jump_after = param23;
  this.show_grid = param24;
}
function _M0TP49LING7167111moon_2degui8examples6canvas12GalleryState(param0, param1, param2, param3, param4, param5, param6, param7, param8, param9, param10, param11, param12, param13, param14, param15, param16, param17, param18, param19, param20, param21, param22, param23, param24, param25, param26, param27, param28, param29, param30, param31, param32, param33, param34, param35, param36, param37, param38, param39, param40, param41, param42, param43, param44, param45, param46, param47, param48, param49, param50, param51, param52, param53, param54) {
  this.button_clicks = param0;
  this.checkbox_gpu = param1;
  this.checkbox_grid = param2;
  this.checkbox_dark_contrast = param3;
  this.checkbox_antialiasing = param4;
  this.toggle_minimal = param5;
  this.toggle_autosave = param6;
  this.toggle_retina = param7;
  this.toggle_haptics = param8;
  this.radio_quality = param9;
  this.slider_zoom = param10;
  this.slider_opacity = param11;
  this.drag_x = param12;
  this.drag_y = param13;
  this.drag_scale = param14;
  this.knob_cutoff = param15;
  this.knob_res = param16;
  this.knob_pan = param17;
  this.knob_drive = param18;
  this.combo_format = param19;
  this.combo_color = param20;
  this.color_idx = param21;
  this.progress_val = param22;
  this.tree_selected = param23;
  this.tree_expanded = param24;
  this.tab_selected = param25;
  this.text_name = param26;
  this.text_email = param27;
  this.code_buffer = param28;
  this.toasts = param29;
  this.cmd_open = param30;
  this.cmd_query = param31;
  this.cmd_idx = param32;
  this.ctx_menu_open = param33;
  this.ctx_menu_pos = param34;
  this.status_text = param35;
  this.active_comp_id = param36;
  this.splitter_ratio = param37;
  this.table_sort_col = param38;
  this.table_sort_dir = param39;
  this.table_columns = param40;
  this.table_selected_row = param41;
  this.dialog_open = param42;
  this.dialog_last_result = param43;
  this.segmented_sel = param44;
  this.tag1_open = param45;
  this.tag2_open = param46;
  this.tag3_open = param47;
  this.sparkline_data = param48;
  this.color_picker_val = param49;
  this.breadcrumb_last_clicked = param50;
  this.rich_text_last_url = param51;
  this.view_mode = param52;
  this.curtain_ratio = param53;
  this.theme_idx = param54;
}
function _M0DTPC16option6OptionGdE4None() {}
_M0DTPC16option6OptionGdE4None.prototype.$tag = 0;
const _M0DTPC16option6OptionGdE4None__ = new _M0DTPC16option6OptionGdE4None();
function _M0DTPC16option6OptionGdE4Some(param0) {
  this._0 = param0;
}
_M0DTPC16option6OptionGdE4Some.prototype.$tag = 1;
function _M0TPB13StringBuilder(param0) {
  this.val = param0;
}
function _M0TPC16string10StringView(param0, param1, param2) {
  this.str = param0;
  this.start = param1;
  this.end = param2;
}
class $PanicError extends Error {}
function $panic() {
  throw new $PanicError();
}
const _M0FPB12random__seed = () => {
  if (globalThis.crypto?.getRandomValues) {
    const array = new Uint32Array(1);
    globalThis.crypto.getRandomValues(array);
    return array[0] | 0; // Convert to signed 32
  } else {
    return Math.floor(Math.random() * 0x100000000) | 0; // Fallback to Math.random
  }
};
function _M0TPB6Hasher(param0) {
  this.acc = param0;
}
const _M0FPB19int__to__string__js = (x, radix) => {
  return x.toString(radix);
};
function _M0TPB4IterGRPC16string10StringViewE(param0, param1) {
  this.f = param0;
  this.size_hint = param1;
}
function _M0TPB4IterGcE(param0, param1) {
  this.f = param0;
  this.size_hint = param1;
}
function $oob() {
  throw new Error("Index out of bounds");
}
function _M0TPB8MutLocalGiE(param0) {
  this.val = param0;
}
function $make_array_len_and_init(a, b) {
  const arr = new Array(a);
  arr.fill(b);
  return arr;
}
const _M0MPB7JSArray4push = (arr, val) => { arr.push(val); };
function _M0TPB8MutLocalGORPC16string10StringViewE(param0) {
  this.val = param0;
}
const _M0MPB7JSArray4copy = (arr) => arr.slice(0);
const _M0MPC16double6Double8mod__ffi = (a, b) => (a % b);
const _M0MPB7JSArray11set__length = (arr, len) => { arr.length = len; };
const _M0MPB7JSArray3pop = (arr) => arr.pop();
const _M0MPB7JSArray6splice = (arr, idx, cnt) => arr.splice(idx, cnt);
function _M0TPC17hashmap7HashMapGRP49LING7167111moon_2degui3src4core2IddE(param0, param1, param2, param3) {
  this.entries = param0;
  this.capacity = param1;
  this.capacity_mask = param2;
  this.size = param3;
}
function _M0TPC17hashmap7HashMapGRP49LING7167111moon_2degui3src4core2IdRP49LING7167111moon_2degui3src4math4Vec2E(param0, param1, param2, param3) {
  this.entries = param0;
  this.capacity = param1;
  this.capacity_mask = param2;
  this.size = param3;
}
function _M0TPC17hashmap7HashMapGRP49LING7167111moon_2degui3src4core2IdiE(param0, param1, param2, param3) {
  this.entries = param0;
  this.capacity = param1;
  this.capacity_mask = param2;
  this.size = param3;
}
function _M0TPC17hashmap7HashMapGRP49LING7167111moon_2degui3src4core2IdbE(param0, param1, param2, param3) {
  this.entries = param0;
  this.capacity = param1;
  this.capacity_mask = param2;
  this.size = param3;
}
function _M0TPC17hashmap7HashMapGsdE(param0, param1, param2, param3) {
  this.entries = param0;
  this.capacity = param1;
  this.capacity_mask = param2;
  this.size = param3;
}
function _M0TPC17hashmap5EntryGsdE(param0, param1, param2, param3) {
  this.psl = param0;
  this.hash = param1;
  this.key = param2;
  this.value = param3;
}
function _M0TPC17hashmap5EntryGRP49LING7167111moon_2degui3src4core2IdiE(param0, param1, param2, param3) {
  this.psl = param0;
  this.hash = param1;
  this.key = param2;
  this.value = param3;
}
function _M0TPC17hashmap5EntryGRP49LING7167111moon_2degui3src4core2IddE(param0, param1, param2, param3) {
  this.psl = param0;
  this.hash = param1;
  this.key = param2;
  this.value = param3;
}
function _M0TPC17hashmap5EntryGRP49LING7167111moon_2degui3src4core2IdRP49LING7167111moon_2degui3src4math4Vec2E(param0, param1, param2, param3) {
  this.psl = param0;
  this.hash = param1;
  this.key = param2;
  this.value = param3;
}
function _M0TPC17hashmap5EntryGRP49LING7167111moon_2degui3src4core2IdbE(param0, param1, param2, param3) {
  this.psl = param0;
  this.hash = param1;
  this.key = param2;
  this.value = param3;
}
function _M0TP49LING7167111moon_2degui3src4math4Rect(param0, param1, param2, param3) {
  this.x = param0;
  this.y = param1;
  this.w = param2;
  this.h = param3;
}
function _M0TP49LING7167111moon_2degui3src4draw8DrawList(param0) {
  this.commands = param0;
}
function _M0DTP49LING7167111moon_2degui3src4draw7DrawCmd4Rect(param0, param1, param2) {
  this._0 = param0;
  this._1 = param1;
  this._2 = param2;
}
_M0DTP49LING7167111moon_2degui3src4draw7DrawCmd4Rect.prototype.$tag = 0;
function _M0DTP49LING7167111moon_2degui3src4draw7DrawCmd10RectStroke(param0, param1, param2, param3) {
  this._0 = param0;
  this._1 = param1;
  this._2 = param2;
  this._3 = param3;
}
_M0DTP49LING7167111moon_2degui3src4draw7DrawCmd10RectStroke.prototype.$tag = 1;
function _M0DTP49LING7167111moon_2degui3src4draw7DrawCmd6Circle(param0, param1, param2) {
  this._0 = param0;
  this._1 = param1;
  this._2 = param2;
}
_M0DTP49LING7167111moon_2degui3src4draw7DrawCmd6Circle.prototype.$tag = 2;
function _M0DTP49LING7167111moon_2degui3src4draw7DrawCmd12CircleStroke(param0, param1, param2, param3) {
  this._0 = param0;
  this._1 = param1;
  this._2 = param2;
  this._3 = param3;
}
_M0DTP49LING7167111moon_2degui3src4draw7DrawCmd12CircleStroke.prototype.$tag = 3;
function _M0DTP49LING7167111moon_2degui3src4draw7DrawCmd4Line(param0, param1, param2, param3) {
  this._0 = param0;
  this._1 = param1;
  this._2 = param2;
  this._3 = param3;
}
_M0DTP49LING7167111moon_2degui3src4draw7DrawCmd4Line.prototype.$tag = 4;
function _M0DTP49LING7167111moon_2degui3src4draw7DrawCmd4Text(param0, param1, param2, param3) {
  this._0 = param0;
  this._1 = param1;
  this._2 = param2;
  this._3 = param3;
}
_M0DTP49LING7167111moon_2degui3src4draw7DrawCmd4Text.prototype.$tag = 5;
function _M0DTP49LING7167111moon_2degui3src4draw7DrawCmd4Clip(param0) {
  this._0 = param0;
}
_M0DTP49LING7167111moon_2degui3src4draw7DrawCmd4Clip.prototype.$tag = 6;
function _M0DTP49LING7167111moon_2degui3src4draw7DrawCmd9ResetClip() {}
_M0DTP49LING7167111moon_2degui3src4draw7DrawCmd9ResetClip.prototype.$tag = 7;
const _M0DTP49LING7167111moon_2degui3src4draw7DrawCmd9ResetClip__ = new _M0DTP49LING7167111moon_2degui3src4draw7DrawCmd9ResetClip();
function _M0DTP49LING7167111moon_2degui3src4draw7DrawCmd14LinearGradient(param0, param1, param2, param3, param4, param5) {
  this._0 = param0;
  this._1 = param1;
  this._2 = param2;
  this._3 = param3;
  this._4 = param4;
  this._5 = param5;
}
_M0DTP49LING7167111moon_2degui3src4draw7DrawCmd14LinearGradient.prototype.$tag = 8;
function _M0TP49LING7167111moon_2degui3src4core8Response(param0, param1, param2, param3, param4, param5, param6, param7, param8, param9) {
  this.id = param0;
  this.rect = param1;
  this.hovered = param2;
  this.clicked = param3;
  this.pressed = param4;
  this.dragged = param5;
  this.has_focus = param6;
  this.gained_focus = param7;
  this.lost_focus = param8;
  this.secondary_clicked = param9;
}
function _M0TP49LING7167111moon_2degui3src4core8TreeNode(param0, param1, param2, param3) {
  this.id = param0;
  this.label = param1;
  this.icon = param2;
  this.children = param3;
}
function _M0TP49LING7167111moon_2degui3src4core12FlatTreeNode(param0, param1, param2, param3, param4) {
  this.node = param0;
  this.depth = param1;
  this.is_expanded = param2;
  this.has_children = param3;
  this.parent_id = param4;
}
function _M0TP49LING7167111moon_2degui3src4core16TreeViewResponse(param0, param1, param2, param3, param4) {
  this.selected_id = param0;
  this.expanded_ids = param1;
  this.clicked_id = param2;
  this.toggled_id = param3;
  this.response = param4;
}
function _M0TP49LING7167111moon_2degui3src4core5Toast(param0, param1, param2, param3, param4, param5) {
  this.id = param0;
  this.title = param1;
  this.message = param2;
  this.kind = param3;
  this.elapsed = param4;
  this.duration = param5;
}
function _M0TP49LING7167111moon_2degui3src4core13ToastResponse(param0, param1) {
  this.active_toasts = param0;
  this.dismissed_id = param1;
}
function _M0TP49LING7167111moon_2degui3src4core11WidgetStyle(param0, param1, param2, param3, param4, param5, param6, param7, param8, param9, param10, param11, param12, param13, param14, param15, param16, param17, param18, param19, param20, param21, param22, param23, param24, param25, param26, param27, param28, param29, param30, param31, param32, param33, param34, param35, param36, param37, param38, param39, param40, param41, param42, param43, param44, param45, param46, param47, param48, param49, param50, param51, param52, param53, param54, param55, param56, param57, param58, param59, param60, param61, param62, param63, param64, param65) {
  this.scale = param0;
  this.button_h = param1;
  this.button_pad_x = param2;
  this.button_radius = param3;
  this.button_min_w = param4;
  this.text_edit_h = param5;
  this.text_edit_pad_x = param6;
  this.text_edit_radius = param7;
  this.caret_h = param8;
  this.slider_h = param9;
  this.slider_track_w = param10;
  this.slider_track_h = param11;
  this.slider_thumb_r = param12;
  this.toggle_w = param13;
  this.toggle_h = param14;
  this.toggle_thumb_r = param15;
  this.knob_r = param16;
  this.code_editor_line_h = param17;
  this.code_editor_gutter_w = param18;
  this.font_normal = param19;
  this.font_small = param20;
  this.font_large = param21;
  this.item_spacing = param22;
  this.radius_sm = param23;
  this.radius_md = param24;
  this.radius_lg = param25;
  this.radius_xl = param26;
  this.segmented_h = param27;
  this.segmented_pad = param28;
  this.segmented_radius = param29;
  this.segmented_pill_radius = param30;
  this.segmented_item_pad_x = param31;
  this.dialog_w = param32;
  this.dialog_min_h = param33;
  this.dialog_radius = param34;
  this.dialog_btn_w = param35;
  this.code_editor_font_size = param36;
  this.code_editor_gutter_font_size = param37;
  this.code_editor_radius = param38;
  this.command_palette_w = param39;
  this.command_palette_radius = param40;
  this.command_palette_row_h = param41;
  this.command_palette_header_h = param42;
  this.command_palette_footer_h = param43;
  this.toast_radius = param44;
  this.table_header_h = param45;
  this.table_row_h = param46;
  this.table_radius = param47;
  this.tree_view_row_h = param48;
  this.tree_view_radius = param49;
  this.rich_text_line_h = param50;
  this.checkbox_size = param51;
  this.checkbox_gap = param52;
  this.checkbox_h = param53;
  this.checkbox_radius = param54;
  this.radio_r = param55;
  this.radio_gap = param56;
  this.radio_h = param57;
  this.badge_dot_w = param58;
  this.badge_pad_x = param59;
  this.badge_h = param60;
  this.badge_radius = param61;
  this.menu_bar_h = param62;
  this.menu_bar_btn_h = param63;
  this.menu_bar_popup_w = param64;
  this.menu_bar_radius = param65;
}
function _M0TP49LING7167111moon_2degui3src4core5Theme(param0, param1, param2, param3, param4, param5, param6, param7, param8, param9, param10, param11, param12, param13, param14, param15, param16, param17, param18, param19, param20, param21, param22, param23, param24) {
  this.name = param0;
  this.bg_app = param1;
  this.bg_window = param2;
  this.bg_surface = param3;
  this.bg_subtle = param4;
  this.bg_hover = param5;
  this.bg_active = param6;
  this.bg_inverse = param7;
  this.border_muted = param8;
  this.border_default = param9;
  this.border_strong = param10;
  this.border_focus = param11;
  this.text_primary = param12;
  this.text_strong = param13;
  this.text_body = param14;
  this.text_secondary = param15;
  this.text_muted = param16;
  this.text_disabled = param17;
  this.text_inverse = param18;
  this.accent_primary = param19;
  this.accent_hover = param20;
  this.accent_pressed = param21;
  this.accent_deep = param22;
  this.accent_soft = param23;
  this.accent_light = param24;
}
function _M0TP49LING7167111moon_2degui3src4core11TableColumn(param0, param1, param2, param3, param4) {
  this.id = param0;
  this.title = param1;
  this.width = param2;
  this.min_width = param3;
  this.sortable = param4;
}
function _M0TP49LING7167111moon_2degui3src4core13TableResponse(param0, param1, param2, param3, param4) {
  this.sort_changed = param0;
  this.sort_column = param1;
  this.sort_direction = param2;
  this.hovered_row = param3;
  this.clicked_row = param4;
}
function _M0TP49LING7167111moon_2degui3src4core8TextSpan(param0, param1) {
  this.text = param0;
  this.kind = param1;
}
function _M0DTP49LING7167111moon_2degui3src4core12TextSpanKind6Normal() {}
_M0DTP49LING7167111moon_2degui3src4core12TextSpanKind6Normal.prototype.$tag = 0;
const _M0DTP49LING7167111moon_2degui3src4core12TextSpanKind6Normal__ = new _M0DTP49LING7167111moon_2degui3src4core12TextSpanKind6Normal();
function _M0DTP49LING7167111moon_2degui3src4core12TextSpanKind4Bold() {}
_M0DTP49LING7167111moon_2degui3src4core12TextSpanKind4Bold.prototype.$tag = 1;
const _M0DTP49LING7167111moon_2degui3src4core12TextSpanKind4Bold__ = new _M0DTP49LING7167111moon_2degui3src4core12TextSpanKind4Bold();
function _M0DTP49LING7167111moon_2degui3src4core12TextSpanKind4Code() {}
_M0DTP49LING7167111moon_2degui3src4core12TextSpanKind4Code.prototype.$tag = 2;
const _M0DTP49LING7167111moon_2degui3src4core12TextSpanKind4Code__ = new _M0DTP49LING7167111moon_2degui3src4core12TextSpanKind4Code();
function _M0DTP49LING7167111moon_2degui3src4core12TextSpanKind4Link(param0) {
  this._0 = param0;
}
_M0DTP49LING7167111moon_2degui3src4core12TextSpanKind4Link.prototype.$tag = 3;
function _M0TP49LING7167111moon_2degui3src4core9RichToken(param0, param1, param2, param3) {
  this.text = param0;
  this.kind = param1;
  this.is_cjk = param2;
  this.has_trailing_space = param3;
}
function _M0TP49LING7167111moon_2degui3src4core16RichTextResponse(param0, param1) {
  this.clicked_url = param0;
  this.resp = param1;
}
function _M0TP49LING7167111moon_2degui3src4core11LayoutScope(param0, param1, param2, param3, param4, param5) {
  this.dir = param0;
  this.start_x = param1;
  this.start_y = param2;
  this.max_cross_size = param3;
  this.current_row_h = param4;
  this.wrap_width = param5;
}
function _M0TP49LING7167111moon_2degui3src4core8RawInput(param0, param1, param2, param3, param4, param5, param6, param7) {
  this.mouse_pos = param0;
  this.mouse_down = param1;
  this.scroll_delta = param2;
  this.dt = param3;
  this.events = param4;
  this.text_input = param5;
  this.modifiers = param6;
  this.mouse_secondary_down = param7;
}
function _M0TP49LING7167111moon_2degui3src4core10InputState(param0, param1, param2, param3, param4, param5, param6, param7, param8, param9, param10, param11, param12, param13, param14, param15, param16, param17) {
  this.mouse_pos = param0;
  this.mouse_prev_pos = param1;
  this.mouse_delta = param2;
  this.mouse_down = param3;
  this.mouse_pressed = param4;
  this.mouse_released = param5;
  this.mouse_secondary_down = param6;
  this.mouse_secondary_pressed = param7;
  this.mouse_secondary_released = param8;
  this.scroll_delta = param9;
  this.dt = param10;
  this.keys_down = param11;
  this.keys_pressed = param12;
  this.keys_released = param13;
  this.consumed_keys = param14;
  this.text_input = param15;
  this.modifiers = param16;
  this.events = param17;
}
function _M0TP49LING7167111moon_2degui3src4core7IdStack(param0) {
  this.stack = param0;
}
function _M0TP49LING7167111moon_2degui3src4core15ContextMenuItem(param0, param1, param2, param3, param4, param5) {
  this.id = param0;
  this.label = param1;
  this.shortcut = param2;
  this.disabled = param3;
  this.is_separator = param4;
  this.children = param5;
}
function _M0TP49LING7167111moon_2degui3src4core19ContextMenuResponse(param0, param1, param2, param3) {
  this.open = param0;
  this.selected_id = param1;
  this.pos = param2;
  this.size = param3;
}
function _M0TP49LING7167111moon_2degui3src4core9UIContext(param0, param1, param2, param3, param4, param5, param6, param7, param8, param9, param10, param11, param12, param13, param14, param15, param16, param17, param18, param19, param20, param21, param22, param23, param24, param25, param26, param27, param28, param29, param30, param31, param32, param33, param34, param35, param36, param37, param38, param39, param40, param41, param42, param43, param44, param45, param46, param47) {
  this.input = param0;
  this.draw_list = param1;
  this.id_stack = param2;
  this.hot_id = param3;
  this.active_id = param4;
  this.focused_id = param5;
  this.prev_focused_id = param6;
  this.lost_focus_id = param7;
  this.pending_lost_focus_id = param8;
  this.focusable_ids = param9;
  this.cursor = param10;
  this.available_width = param11;
  this.item_spacing = param12;
  this.clip_stack = param13;
  this.auto_id_counter = param14;
  this.layout_stack = param15;
  this.scroll_offsets = param16;
  this.scroll_content_heights = param17;
  this.window_positions = param18;
  this.window_batches = param19;
  this.window_drawn = param20;
  this.window_focus = param21;
  this.win_active_z = param22;
  this.window_rects = param23;
  this.prev_window_rects = param24;
  this.text_cursor_positions = param25;
  this.open_collapsing_ids = param26;
  this.last_active_frame = param27;
  this.frame_counter = param28;
  this.open_combo_id = param29;
  this.open_menu_id = param30;
  this.active_submenu_id = param31;
  this.text_selection_anchors = param32;
  this.wants_capture_mouse = param33;
  this.prev_wants_capture_mouse = param34;
  this.fg_draw_list = param35;
  this.fg_saved_draw_list = param36;
  this.fg_saved_clip_stack = param37;
  this.foreground = param38;
  this.blocking_rects = param39;
  this.prev_blocking_rects = param40;
  this.style = param41;
  this.theme = param42;
  this.cursor_icon = param43;
  this.time = param44;
  this.last_caret_activity = param45;
  this.text_measure_cache = param46;
  this.animation_states = param47;
}
function _M0TPB9ArrayViewGURP49LING7167111moon_2degui3src4core2IddEE(param0, param1, param2) {
  this.buf = param0;
  this.start = param1;
  this.end = param2;
}
function _M0TPB9ArrayViewGURP49LING7167111moon_2degui3src4core2IdRP49LING7167111moon_2degui3src4math4Vec2EE(param0, param1, param2) {
  this.buf = param0;
  this.start = param1;
  this.end = param2;
}
function _M0TPB9ArrayViewGURP49LING7167111moon_2degui3src4core2IdiEE(param0, param1, param2) {
  this.buf = param0;
  this.start = param1;
  this.end = param2;
}
function _M0TPB9ArrayViewGURP49LING7167111moon_2degui3src4core2IdbEE(param0, param1, param2) {
  this.buf = param0;
  this.start = param1;
  this.end = param2;
}
function _M0TPB9ArrayViewGUsdEE(param0, param1, param2) {
  this.buf = param0;
  this.start = param1;
  this.end = param2;
}
function _M0TP49LING7167111moon_2degui3src4core11CommandItem(param0, param1, param2, param3) {
  this.id = param0;
  this.title = param1;
  this.category = param2;
  this.shortcut = param3;
}
function _M0TP49LING7167111moon_2degui3src4core22CommandPaletteResponse(param0, param1, param2, param3) {
  this.open = param0;
  this.selected_id = param1;
  this.query = param2;
  this.selected_index = param3;
}
function _M0DTP49LING7167111moon_2degui3src4core5Event3Key(param0, param1, param2) {
  this._0 = param0;
  this._1 = param1;
  this._2 = param2;
}
_M0DTP49LING7167111moon_2degui3src4core5Event3Key.prototype.$tag = 0;
function _M0DTP49LING7167111moon_2degui3src4core5Event9TextInput(param0) {
  this._0 = param0;
}
_M0DTP49LING7167111moon_2degui3src4core5Event9TextInput.prototype.$tag = 1;
function _M0DTP49LING7167111moon_2degui3src4core5Event12PointerWheel(param0) {
  this._0 = param0;
}
_M0DTP49LING7167111moon_2degui3src4core5Event12PointerWheel.prototype.$tag = 2;
function _M0TP49LING7167111moon_2degui8examples6canvas11FrameOutput(param0, param1, param2, param3, param4, param5, param6, param7, param8) {
  this.draw_list = param0;
  this.cam_x = param1;
  this.cam_y = param2;
  this.zoom = param3;
  this.grid_dim = param4;
  this.visible_cells = param5;
  this.selected_id = param6;
  this.show_studio = param7;
  this.is_vector = param8;
}
function _M0DTPC16option6OptionGRPB5ArrayGRP49LING7167111moon_2degui3src4core15ContextMenuItemEE4None() {}
_M0DTPC16option6OptionGRPB5ArrayGRP49LING7167111moon_2degui3src4core15ContextMenuItemEE4None.prototype.$tag = 0;
const _M0DTPC16option6OptionGRPB5ArrayGRP49LING7167111moon_2degui3src4core15ContextMenuItemEE4None__ = new _M0DTPC16option6OptionGRPB5ArrayGRP49LING7167111moon_2degui3src4core15ContextMenuItemEE4None();
function _M0DTPC16option6OptionGRPB5ArrayGRP49LING7167111moon_2degui3src4core15ContextMenuItemEE4Some(param0) {
  this._0 = param0;
}
_M0DTPC16option6OptionGRPB5ArrayGRP49LING7167111moon_2degui3src4core15ContextMenuItemEE4Some.prototype.$tag = 1;
const _M0FP092moonbitlang_2fcore_2fbuiltin_2fStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger = { method_0: _M0IPB13StringBuilderPB6Logger13write__string, method_1: _M0IP016_24default__implPB6Logger16write__substringGRPB13StringBuilderE, method_2: _M0IPB13StringBuilderPB6Logger11write__view, method_3: _M0IPB13StringBuilderPB6Logger11write__char, method_4: _M0IP016_24default__implPB6Logger28write__string__interpolationGRPB13StringBuilderE, method_5: _M0IP016_24default__implPB6Logger5writeGRPB13StringBuilderE };
const _M0MPB4Iter4nextN6constrS9855GRPC16string10StringViewE = 0;
const _M0MPB4Iter4nextN6constrS9856GRPC16string10StringViewE = 0;
const _M0MPB4Iter4nextN6constrS9855GcE = 0;
const _M0MPB4Iter4nextN6constrS9856GcE = 0;
const _M0MPB4Iter3newN6constrS9863GRPC16string10StringViewE = 0;
const _M0MPB4Iter3newN6constrS9863GcE = 0;
const _M0MP49LING7167111moon_2degui3src5color5Color11transparentN6recordS35 = new _M0TP49LING7167111moon_2degui3src5color5Color(0, 0, 0, 0);
const _M0FP49LING7167111moon_2degui3src4math2pi = 3.1415926535897931;
const _M0MP49LING7167111moon_2degui3src4math4Vec24zeroN6recordS89 = new _M0TP49LING7167111moon_2degui3src4math4Vec2(0, 0);
const _M0MP49LING7167111moon_2degui3src4core2Id10with__seedN5primeS1169 = 1099511628211n;
const _M0MP49LING7167111moon_2degui3src4core2Id9with__intN5primeS1148 = 1099511628211n;
const _M0FP49LING7167111moon_2degui3src4core21wrap__dialog__messageN7_2abindS3564 = "\n";
const _M0FP49LING7167111moon_2degui3src4core9hex__byteN11hex__digitsS416 = "0123456789ABCDEF";
const _M0MP49LING7167111moon_2degui3src4core2Id4zeroN6recordS4226 = new _M0TP49LING7167111moon_2degui3src4core2Id(0n);
const _M0MP49LING7167111moon_2degui3src4core9Modifiers4noneN6recordS4227 = new _M0TP49LING7167111moon_2degui3src4core9Modifiers(false, false, false, false);
const _M0FP49LING7167111moon_2degui8examples6canvas5state = new _M0TP49LING7167111moon_2degui8examples6canvas14BenchmarkState(256, true, true, false, 5000, 5000, 0, 0, 0, 5000, 5000, 0.075, -1, -1, -1, 0, 0, 0, false, 0, false, 0, "", 1, true);
const _M0FP49LING7167111moon_2degui8examples6canvas15logo__grid__128 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29041796, 29107075, 28976258, 28976258, 28910722, 28910466, 28910466, 28910723, 29042051, 29172870, 29172355, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29304199, 29107076, 29041795, 28976258, 28910466, 28910466, 28976258, 28976258, 28976258, 29041795, 29107845, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29107076, 29107331, 29566601, 29763467, 29501064, 29238661, 29107588, 29107588, 29173125, 29304198, 29566601, 29763467, 29435527, 29172868, 29107332, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29173123, 29107333, 29435528, 29763467, 29566601, 29304198, 29173124, 29107588, 29107588, 29238661, 29501064, 29763467, 29566601, 29041795, 29238405, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29107332, 29172869, 29763467, 29173125, 28910721, 28844930, 28910722, 28910722, 28845185, 28845185, 28845185, 28910722, 28910721, 28844930, 28845186, 29304198, 29763467, 29238661, 28778879, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28844931, 29303941, 29828747, 29304198, 28845186, 28844930, 28910721, 28910722, 28845185, 28845185, 28845185, 28910722, 28910722, 28844930, 28910721, 29173125, 29763467, 29238661, 29107331, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29172869, 29829004, 28976259, 28844930, 28845185, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28844930, 29369735, 29304198, 28844930, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28910466, 29369735, 29304199, 28844930, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845185, 28844930, 29042051, 29829004, 29238405, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28779904, 29304198, 29435528, 28779393, 28845186, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845185, 28910723, 29829004, 28845186, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28779392, 29829004, 28910722, 28845186, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845185, 28779393, 29501064, 29303942, 28845185, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28779392, 29501064, 29041795, 28845185, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845185, 28910722, 29763211, 28713855, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28713856, 29829004, 28910722, 28845185, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845185, 29107588, 29435527, 28844928, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28648063, 29632138, 29041795, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845185, 29107331, 29238406, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29238661, 29041795, 28845185, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845186, 28976259, 29566601, 28648576, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28779391, 29435527, 29041795, 28845185, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845185, 29566601, 28779393, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28910722, 29501064, 28845185, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845185, 29107331, 29304198, 28582783, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29172868, 29107588, 28845186, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28844930, 29697674, 28844931, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28910979, 29697931, 28844930, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845186, 29173125, 29173124, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28910722, 29501065, 28845185, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 29435272, 28779392, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28779393, 29369735, 28845186, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28844929, 29566601, 28910722, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28714112, 29829004, 28779393, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 29304198, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28910207, 29369735, 28845186, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28779393, 29829004, 28779136, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29172869, 29041795, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28844930, 29763467, 28845186, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28910466, 29763211, 28844930, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845186, 29107331, 29173125, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28845184, 29632137, 28844929, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845186, 29632138, 28845185, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28844929, 29632137, 28910721, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28844929, 29697674, 28714112, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28975745, 29435272, 28910721, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845186, 29369735, 28910467, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28844929, 29304198, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28976258, 29304198, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28845185, 29566601, 28910721, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845186, 29041795, 28845185, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28910466, 28976259, 28845186, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910721, 29632138, 28779649, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29238662, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 29369991, 28976769, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28976514, 29501064, 28845186, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 29173125, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28910465, 29697675, 28844930, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28844930, 29763467, 28910722, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28910466, 29763467, 28844930, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28844930, 29763211, 28910465, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28910722, 29107588, 28845185, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28844930, 29697675, 28845186, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28910722, 29697674, 28844930, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845185, 29173125, 28845185, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28713602, 29632138, 28844929, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845186, 29435528, 28910722, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28910721, 29369991, 28845186, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845185, 29566601, 28844930, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28779905, 29697674, 28844930, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845185, 29107588, 28845186, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28844930, 29041796, 28845186, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28844930, 29697675, 28910977, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28779649, 29238662, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845185, 29173125, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29304198, 28845185, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 29304198, 28845185, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29041795, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28844930, 29697674, 28910723, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28844929, 29697931, 28844930, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28976259, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28910979, 29632138, 28844930, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28844930, 29763211, 28910722, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28844929, 29697675, 28844930, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845185, 29632138, 28910210, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28910722, 29763211, 28844930, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 29501065, 28844929, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28844930, 29501064, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28844930, 29763211, 28844930, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28910464, 29632138, 28845186, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845185, 29173125, 28910465, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28779393, 29173125, 28845185, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28844930, 29697674, 28779393, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28910465, 29501064, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 29041795, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29107588, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910721, 29566601, 28844930, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28910721, 29369735, 28845186, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910721, 29632137, 28844928, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28910208, 29697674, 28910721, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845186, 29435528, 28910722, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28845185, 29369735, 28845186, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845186, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28844930, 29763211, 28845185, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28844929, 29763467, 28844930, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845186, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845186, 29435528, 28910722, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28910722, 29501064, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845185, 28976258, 29304198, 28779649, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910721, 29566601, 28910466, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28844930, 29501065, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845185, 29304199, 28910722, 28845186, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 29501065, 28910722, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28910722, 29632138, 28910721, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845185, 29107332, 28910466, 28910722, 29304198, 28779649, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 29238662, 28844929, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28844930, 29238661, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28779649, 29304198, 28910465, 28844930, 29041796, 28845186, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28844929, 29697674, 28910721, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28844929, 29763211, 28844930, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845186, 28910466, 29894540, 28845185, 0, 29107332, 29238662, 28845186, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845186, 28976259, 28910466, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28976258, 28976258, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845186, 29369735, 29041794, 0, 28845185, 29894541, 28910466, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28844930, 29763211, 28910466, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28910722, 29632138, 28844929, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845185, 28910723, 29894540, 28910465, 0, 0, 28975745, 29369735, 28976259, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 29501064, 28975746, 0, 0, 0, 0, 0, 0, 0, 0, 28779906, 29566601, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28976259, 29304199, 0, 0, 0, 28910466, 29894540, 28910722, 28845185, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28844929, 29566601, 28779649, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28910466, 28976259, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845185, 28976258, 29697931, 28910723, 0, 0, 0, 0, 28713856, 29829004, 28844929, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28844930, 29763467, 28910466, 0, 0, 0, 0, 0, 0, 0, 0, 28910466, 29763467, 28844930, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28779394, 29829003, 28844928, 0, 0, 0, 0, 28910722, 29763467, 28976259, 28845185, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 29041795, 28845186, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28844930, 29697674, 28779394, 28910722, 28910722, 28910722, 28910722, 28910722, 28845185, 28844929, 29369735, 29238406, 28910721, 0, 0, 0, 0, 0, 0, 29041795, 29369734, 28845186, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28844930, 29632138, 28910722, 0, 0, 0, 0, 0, 0, 0, 0, 28845186, 29632138, 28910721, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845185, 29369735, 28910466, 0, 0, 0, 0, 0, 0, 28976258, 29304198, 29369735, 28779393, 28845185, 28910722, 28910722, 28910722, 28910722, 28910722, 28779393, 29697674, 28844929, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29238662, 29041795, 28844929, 28845186, 28845186, 28844929, 28844929, 29107589, 29829004, 29238405, 0, 0, 0, 0, 0, 0, 0, 0, 28648063, 29369735, 28976258, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845186, 29369735, 28910721, 0, 0, 0, 0, 0, 0, 0, 0, 28844930, 29304198, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28976258, 29304198, 0, 0, 0, 0, 0, 0, 0, 0, 28779391, 29238405, 29829004, 29107588, 28844930, 28910465, 28845186, 28845186, 28844929, 29107332, 29107333, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28714112, 29369735, 29697675, 29369735, 29369735, 29632138, 29697675, 29107333, 29042051, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28844930, 29763467, 28844928, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845185, 29041796, 28844930, 0, 0, 0, 0, 0, 0, 0, 0, 28845186, 29041795, 28845186, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28844929, 29763468, 28845184, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29238404, 29173125, 29763211, 29632138, 29369735, 29369735, 29763211, 29435271, 28582782, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29238406, 28976515, 28976259, 29173124, 29107844, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29041796, 29304198, 28845186, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 29304199, 0, 0, 0, 0, 0, 0, 0, 28714115, 29435527, 28845186, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845186, 29304199, 28976258, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29238661, 29107587, 28976003, 29042051, 29238406, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28910209, 29435528, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28844930, 29697931, 28910467, 0, 0, 0, 0, 0, 0, 28976002, 29763467, 28844930, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 29369735, 28910207, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28779648, 29763467, 28844929, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28844930, 29697675, 28910721, 0, 0, 0, 0, 0, 0, 28976003, 29697674, 28844930, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28844930, 29763211, 28713601, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29041795, 29238662, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 29435528, 28910978, 0, 0, 0, 0, 0, 0, 28844929, 29369991, 28845186, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 29238661, 28976003, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28844928, 29632138, 28844929, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845185, 29107589, 28779393, 0, 0, 0, 0, 0, 0, 28844929, 29107588, 28845185, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910721, 29566601, 28648319, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28845185, 29697674, 28844929, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 29107588, 0, 0, 0, 0, 0, 0, 29238662, 28845185, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28844929, 29697675, 28845185, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29107588, 29172869, 28845185, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910721, 29632138, 28910208, 0, 0, 0, 0, 28910466, 29697931, 28844930, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 29173125, 29107332, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28714113, 29763211, 28844930, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28844930, 29763467, 28844931, 0, 0, 0, 0, 28910465, 29763211, 28844930, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28844930, 29697675, 28845186, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28844930, 29566601, 28844929, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910721, 29566601, 28845186, 0, 0, 0, 0, 28910721, 29501064, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28844929, 29632137, 28844928, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29238661, 29041795, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 29238661, 28844929, 0, 0, 0, 0, 28779649, 29173125, 28845185, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845186, 29107332, 29172868, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28779391, 29829003, 28844930, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28976259, 28976258, 0, 0, 0, 0, 28976259, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28844930, 29763211, 28714113, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28910721, 29369735, 28845186, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 29566601, 28910980, 0, 0, 28845186, 29632138, 28910721, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910721, 29435272, 28910465, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29304198, 28976258, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28844930, 29763467, 28910466, 0, 0, 28976514, 29763467, 28844930, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28976258, 29238662, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28714111, 29894540, 28844929, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910721, 29632138, 28976258, 0, 0, 28845186, 29566601, 28910721, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28844929, 29960077, 28779137, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29041795, 29238662, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845186, 29107588, 28910722, 28910722, 28910465, 28845186, 29041796, 28845186, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 29304198, 28910723, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28845185, 29566601, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845186, 29041796, 29697674, 29697674, 29041795, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 29501064, 29041794, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29041540, 29042051, 28976258, 28910722, 28845186, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845186, 28844930, 28844930, 28845186, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845185, 29238661, 28976259, 29041795, 29107331, 29107588, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29107332, 29041796, 29107588, 29763467, 29566601, 29107588, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845185, 28976259, 29369735, 29697675, 29566601, 29041795, 29107333, 29172870, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29238661, 29107588, 29763467, 29369735, 28845186, 28844930, 28910721, 28845185, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845186, 28844930, 28910721, 29107588, 29697674, 29435527, 29238404, 29172870, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29172869, 29238662, 29632138, 28976258, 28844930, 28845186, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845185, 28844929, 28845186, 29369735, 29697674, 29107332, 28976005, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29041796, 29238406, 29632138, 28845185, 28845185, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845186, 28844929, 29304199, 29632137, 29107333, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29173125, 29829004, 28910722, 28844929, 28910722, 28910722, 28976771, 28977028, 28977284, 28977028, 28977028, 28977028, 28977028, 28977028, 28977028, 28977028, 28977028, 28977028, 28977028, 28977028, 28977028, 28977028, 28977028, 28977028, 28977028, 28977028, 28977028, 28977028, 28977028, 28977028, 28977028, 28977028, 28977028, 28977028, 28977028, 28977028, 28977028, 28977028, 28977028, 28977028, 28977028, 28977028, 28977028, 28977028, 28977028, 28977028, 28977028, 28977284, 28977028, 28977027, 28910979, 28910722, 28845186, 28910721, 29697674, 29173124, 28779391, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29238661, 29566601, 28779393, 28845186, 28976515, 28977028, 28910722, 28712061, 28644986, 28578937, 28579193, 28579193, 28579193, 28579193, 28579193, 28579193, 28579193, 28579193, 28579193, 28579193, 28579193, 28579193, 28579193, 28579193, 28579193, 28579193, 28579193, 28579193, 28579193, 28579193, 28579193, 28579193, 28579193, 28579193, 28579193, 28579193, 28579193, 28579193, 28579193, 28579193, 28579193, 28579193, 28579193, 28579193, 28579193, 28579193, 28579193, 28579193, 28578937, 28579193, 28645499, 28778367, 28976771, 28977028, 28910722, 28844930, 29173125, 29435527, 28779650, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29304197, 29238662, 28844930, 28910722, 28977028, 28778367, 28579193, 28910722, 29706391, 30502829, 31100093, 31365316, 31431109, 31431109, 31431109, 31431109, 31431109, 31431109, 31431109, 31431109, 31431109, 31431109, 31431109, 31431109, 31431109, 31431109, 31431109, 31431109, 31431109, 31431109, 31431109, 31431109, 31431109, 31431109, 31431109, 31431109, 31431109, 31431109, 31431109, 31431109, 31431109, 31431109, 31431109, 31431109, 31431109, 31431109, 31431109, 31431109, 31431365, 31298754, 30900407, 30170787, 29309069, 28711548, 28645242, 28910722, 28976772, 28844930, 29041795, 29763211, 28779904, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29173125, 29238662, 28844929, 28976771, 28910722, 28579193, 29374862, 31232191, 32758249, 33554174, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33288695, 32161241, 30370217, 28844416, 28711548, 28977028, 28845185, 28976259, 29632138, 28779392, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28976002, 29501065, 28844929, 28976771, 28844160, 28778367, 31033787, 33222903, 33554431, 33554431, 33554431, 33488125, 33487869, 33487869, 33487869, 33487869, 33487869, 33487869, 33487869, 33487869, 33487869, 33487869, 33487869, 33487869, 33487869, 33487869, 33487869, 33487869, 33487869, 33487869, 33487869, 33487869, 33487869, 33487869, 33487869, 33487869, 33487869, 33487869, 33487869, 33487869, 33487869, 33487869, 33487869, 33487869, 33487869, 33487869, 33487869, 33487869, 33487869, 33487869, 33487869, 33487869, 33488125, 33488382, 33554431, 33554431, 33554431, 32493027, 29839772, 28579450, 28977028, 28845185, 29107332, 29173125, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28714112, 29894540, 28779393, 28976771, 28843903, 29043590, 32227803, 33554431, 33554431, 33488125, 33488382, 33554431, 33554431, 33554431, 33488125, 33488382, 33488382, 33488125, 33554431, 33554431, 33554431, 33554431, 33488382, 33488125, 33487869, 33554174, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554175, 33488125, 33554431, 33488382, 33488382, 33554431, 33554431, 33554431, 33554431, 33554431, 33554175, 33488125, 33488125, 33554431, 33488125, 30767795, 28644986, 28977028, 28844929, 29566601, 28845186, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29041795, 29041796, 28910978, 28910465, 28910722, 32426721, 33554431, 33487868, 33554175, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33488382, 33554431, 33554431, 33554431, 33554431, 33554431, 33488125, 33554175, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33488126, 33554174, 33554431, 30635953, 28579450, 28977028, 28844930, 29697931, 28779392, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28844931, 29763467, 28844930, 28977028, 28579450, 31497927, 33554431, 33422076, 33554431, 33554431, 33554431, 33554431, 33554431, 33554174, 33554431, 31630539, 29972126, 29971870, 31498184, 33554174, 33554174, 33554431, 33421820, 32625381, 31564233, 30702259, 32890604, 33554431, 33488382, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554174, 33488126, 33554431, 33488125, 31696845, 33421307, 32095448, 32691687, 33554431, 33554431, 33488126, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33488382, 33488382, 33422076, 29640598, 28712061, 28976771, 29369735, 28845184, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28845185, 29173125, 28976515, 28777854, 29574036, 33487612, 33488382, 33554175, 33554431, 33554431, 33554431, 33554431, 33488382, 33554431, 31099837, 28446326, 31232192, 31299011, 28512631, 30900407, 33554431, 33554431, 32757993, 29706904, 29109895, 28313970, 32293596, 33554431, 33488126, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33488125, 33554431, 33554431, 32360415, 29507474, 28645755, 33554431, 30701489, 28380020, 31299011, 33422076, 33554431, 33488382, 33554175, 33554431, 33554431, 33554431, 33554431, 33554431, 33488125, 33554431, 32028887, 28645499, 28976771, 28845186, 29369735, 28844929, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29041539, 29435528, 28845186, 28977028, 28579193, 31232192, 33554431, 33488125, 33554431, 33554431, 33554431, 33554431, 33554174, 33554431, 33222390, 28778110, 30701489, 33554431, 33554431, 30966969, 28645242, 33089777, 33554431, 33421820, 33554431, 31564490, 28512631, 32426721, 33554431, 33488126, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554174, 33554431, 33023985, 30502829, 28446069, 29109639, 31696588, 33554174, 32757993, 30038945, 28379763, 29375375, 32161241, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554175, 33554175, 33355771, 29441168, 28778111, 28845443, 29763467, 28910209, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28910466, 29763467, 28845186, 28976771, 28711548, 32227804, 33554431, 33488125, 33554431, 33554431, 33554431, 33554431, 33488382, 33554431, 32492770, 28446326, 31829456, 33488125, 33488125, 32028886, 28446069, 32227547, 33554431, 33421820, 33554431, 31497928, 28446069, 32426464, 33554431, 33488126, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554174, 33554174, 31697358, 29109639, 28777854, 31033531, 33223159, 33554431, 33554174, 33554431, 33554431, 32160985, 29442194, 28579193, 30502829, 33222389, 33554174, 33554175, 33554431, 33554431, 33554431, 33554431, 33488382, 33554431, 30303655, 28645243, 28911491, 29435528, 28910722, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28910466, 29632137, 28910721, 28910979, 28844160, 32559332, 33554431, 33488382, 33554431, 33554431, 33554431, 33554431, 33488125, 33554431, 32293340, 28380533, 31962324, 33554431, 33554431, 32161497, 28446326, 32028373, 33554431, 33421819, 33554175, 31497928, 28446069, 32426464, 33554431, 33488126, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554175, 29175432, 28910722, 32758762, 33554431, 33554431, 33422076, 33554431, 33488382, 33487612, 33554431, 33554431, 30502572, 28180590, 32359902, 33554431, 33488382, 33554431, 33554431, 33554431, 33554431, 33488125, 33554175, 30635697, 28644986, 28911491, 29107332, 28845185, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28844930, 29369735, 28845186, 28976771, 28711805, 32294622, 33554431, 33488126, 33554431, 33554431, 33554431, 33554431, 33488382, 33554431, 32692200, 28446839, 31630283, 33554174, 33488382, 31896018, 28446069, 32492514, 33554431, 33421820, 33554175, 31497928, 28446069, 32426464, 33554175, 33488126, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554174, 33554175, 31099837, 28712062, 29441168, 31895506, 33554431, 33554431, 33554175, 33554431, 33554431, 32758506, 30369961, 28711548, 29773210, 33023472, 33554175, 33488638, 33554431, 33554431, 33554431, 33554431, 33488382, 33554431, 30370474, 28645243, 28977027, 28910722, 28910722, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28845187, 29304198, 28910722, 28977284, 28579193, 31431878, 33554431, 33487869, 33554431, 33554431, 33554431, 33554431, 33554175, 33554174, 33421819, 29242251, 29839515, 33554431, 33554431, 30104738, 29043333, 33355257, 33554431, 33554431, 33554431, 31630283, 28512118, 32559075, 33554431, 33554175, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554175, 33554431, 32426721, 29640598, 28313714, 29905564, 32492770, 33488382, 33156340, 30967482, 28645755, 28777854, 31299267, 33422076, 33554431, 33554175, 33554431, 33554431, 33554431, 33554431, 33554431, 33554175, 33488125, 29574293, 28777853, 28911235, 28845185, 29173125, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28910722, 29304198, 28910722, 28976771, 28711549, 29840028, 33554431, 33488126, 33554431, 33554431, 33554431, 33554431, 33554431, 33488382, 33554431, 32160985, 28778110, 29839259, 29905821, 28711805, 31962324, 33554431, 33554431, 31298241, 29441168, 29308812, 28578937, 29507217, 29508243, 32492771, 33554431, 33488381, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33488382, 33554431, 33554431, 31564490, 28778111, 28977285, 33554431, 31100093, 28049515, 30436523, 32957679, 33554431, 33554431, 33554175, 33554431, 33554431, 33554431, 33554431, 33554431, 33488125, 33554431, 32360928, 28777598, 28976515, 28910722, 28845185, 29238662, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28779393, 29369735, 28845186, 28910722, 28976771, 28645756, 32028630, 33554431, 33487869, 33554431, 33554431, 33554431, 33554431, 33554431, 33554174, 33554431, 32956910, 31365060, 31299011, 32824812, 33554431, 33488382, 33554431, 32691687, 31896275, 32161241, 32293852, 32095192, 31962324, 33155827, 33488382, 33488125, 33488126, 33488125, 33488125, 33488125, 33488125, 33488126, 33488382, 33488382, 33554174, 33554175, 33554431, 33554431, 33488382, 33554175, 33554431, 33023728, 31034044, 33487869, 31829969, 31896275, 33554431, 33554431, 33488125, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554175, 33487869, 33554431, 30104481, 28645756, 28976771, 28910722, 28910722, 28910722, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28910722, 29632138, 28910721, 28910722, 28910979, 28844160, 29176458, 32957423, 33554431, 33487869, 33554431, 33554431, 33554431, 33554431, 33554431, 33488382, 33554431, 33554431, 33554431, 33554431, 33488382, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33488382, 33488125, 33488125, 33488125, 33487869, 33554431, 33554431, 33554175, 33554431, 33554431, 33488382, 33554174, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33554174, 33487869, 33554431, 31365059, 28644986, 28977028, 28910722, 28845185, 29107588, 28844929, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28910466, 29763211, 28844930, 28910722, 28910722, 28977028, 28711805, 29507730, 32890605, 33554431, 33488382, 33488125, 33554175, 33554431, 33554431, 33554431, 33488382, 33488125, 33487869, 33488125, 33488125, 33488125, 33554174, 33554431, 33554431, 33554431, 33554431, 33554431, 33487869, 33222902, 32891374, 32625638, 32360159, 32161498, 32094935, 32094679, 32161498, 32360672, 32625894, 32891374, 33223159, 33488382, 33554431, 33554431, 33554431, 33554431, 33554431, 33554174, 33422076, 33488125, 33488125, 33488125, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33553918, 33487869, 33554431, 33554431, 31497928, 28711805, 28910979, 28910722, 28910722, 28910721, 29566601, 28910465, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29107332, 28910722, 28910722, 28910722, 28910722, 28977028, 28711805, 29175945, 31829713, 33554431, 33554431, 33554431, 33488382, 33488125, 33488125, 33488125, 33488125, 33554174, 33554431, 33554431, 33554431, 33554431, 33156597, 32492770, 31696589, 30900919, 30171557, 29640342, 29242507, 28977284, 28844159, 28712061, 28711548, 28645499, 28645499, 28711548, 28777598, 28844160, 28977284, 29242507, 29640342, 30171043, 30834357, 31564233, 32294366, 33023729, 33554431, 33554431, 33554431, 33554431, 33554431, 33488125, 33488125, 33488125, 33488125, 33488125, 33554174, 33554431, 33554431, 33090035, 30569391, 28645499, 28910722, 28910978, 28910722, 28910722, 28844929, 29697675, 28976257, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28779649, 29501064, 28910721, 28910722, 28910722, 28910722, 28977028, 28844160, 28645500, 30038176, 32028117, 33288952, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 33089778, 32094936, 30901433, 29971870, 29241994, 28778110, 28579194, 28579193, 28645499, 28777598, 28844160, 28910465, 28910978, 28976771, 28976771, 28977027, 28977027, 28976771, 28911235, 28910978, 28910465, 28844160, 28777598, 28645499, 28579193, 28579193, 28711805, 29109383, 29706647, 30569391, 31630796, 32692200, 33487869, 33554431, 33554431, 33554431, 33554431, 33554431, 33554431, 32825068, 31166399, 29242251, 28579450, 28976771, 28910978, 28910722, 28910722, 28910722, 29107588, 28910466, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28910721, 29566601, 28844929, 28910722, 28910722, 28910722, 28910722, 28910979, 28976771, 28711292, 28645755, 29375119, 30370474, 31299011, 31896275, 32227291, 31431366, 30038432, 29109896, 28645500, 28579193, 28711548, 28844160, 28910979, 28977028, 28977028, 28977028, 28976771, 28910979, 28910978, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910978, 28910979, 28976771, 28977028, 28977028, 28977028, 28976771, 28844673, 28712061, 28644986, 28579450, 28910465, 29574035, 30701489, 31962324, 32161498, 31762894, 30967225, 29972126, 28977284, 28579193, 28844160, 28977028, 28910722, 28910722, 28910722, 28910722, 28779393, 29829004, 28910209, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28844929, 29632138, 28844929, 28910722, 28910722, 28910722, 28910722, 28910722, 28976771, 28976771, 28778367, 28645242, 28579193, 28645243, 28711548, 28579450, 28645756, 28844417, 28977027, 28977028, 28976771, 28910979, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910978, 28976771, 28977028, 28977028, 28910722, 28777854, 28579450, 28645499, 28711292, 28579450, 28579193, 28711548, 28910465, 28977028, 28910979, 28910722, 28910722, 28910722, 28910722, 28845185, 29501064, 28845185, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29173124, 29173125, 28845186, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910979, 28977028, 28977284, 28977028, 28976771, 28977028, 28977027, 28910978, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28976771, 28977028, 28977028, 28976771, 28977028, 28977028, 28976771, 28910978, 28910722, 28910722, 28910722, 28910722, 28910722, 28845186, 29172869, 29173125, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28714109, 29369991, 29041795, 28779649, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845186, 29041795, 29435527, 28647809, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28713858, 29566601, 28976259, 28845186, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845185, 29107332, 29369735, 28648319, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28714112, 29304198, 29173125, 28844929, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28779393, 29435527, 29303941, 28779135, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28648065, 29238662, 29632138, 28844930, 28845185, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910721, 28910722, 29829003, 29238405, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29173125, 29763211, 29107589, 28844930, 28845186, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845186, 28845185, 29435528, 29304198, 29041796, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29041795, 29173125, 29763467, 29041795, 28844930, 28845185, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28844929, 29369735, 29632394, 29238661, 28910211, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29238405, 29172868, 29763467, 29173125, 28910721, 28910979, 28910978, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910979, 28845443, 28910722, 29501064, 29632138, 29172868, 29042052, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29174151, 29107845, 29697674, 29368964, 28910209, 28911235, 28911235, 28910978, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910979, 28911235, 28910979, 28843647, 29368452, 29041795, 29108101, 29240457, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29171584, 28981135, 28978055, 29039228, 29039485, 28975232, 28910722, 28845699, 28845699, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910979, 28911235, 28910465, 28974719, 29039228, 28909182, 29244818, 29379227, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28889329, 28826614, 28829951, 28827899, 28819429, 28805826, 28858274, 28914828, 28975745, 29104765, 29105021, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 29039999, 29105022, 28846469, 28918934, 28798643, 29863897, 30926071, 31062015, 30929663, 30795000, 30793974, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28825333, 28694002, 28759539, 28759539, 28825331, 28824562, 28824563, 28761079, 28697596, 28762875, 28823279, 28813527, 28805826, 28860841, 28845955, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910209, 28925350, 28812499, 28818402, 28760822, 28960511, 30732799, 30927354, 30860535, 30861048, 30861305, 30861304, 30861305, 30861561, 30795769, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28890867, 28825331, 28825331, 28759539, 28825076, 28825075, 28825075, 28825075, 28759795, 28825075, 28824818, 28824305, 28824818, 28825075, 28765183, 28759025, 28923811, 28910466, 28910978, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910465, 28915599, 28810702, 28764927, 28693234, 29349617, 30992375, 30861560, 30927353, 30927353, 30927097, 30927097, 30993145, 30993145, 30927353, 30927352, 30926840, 30927097, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28824817, 28693748, 28759540, 28759795, 28759539, 28825332, 28890868, 28759796, 28759284, 28825075, 28759796, 28825075, 28890868, 28759796, 28759796, 28824049, 28828925, 28812756, 28912519, 29104765, 28910978, 28910722, 28910978, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910978, 28910722, 28910978, 28974975, 29104765, 28928687, 28631034, 29350646, 30992376, 31058169, 30992633, 30992633, 30992633, 30992633, 30992633, 30992633, 31058169, 30992633, 30992633, 31058681, 30729976, 28825333, 28759538, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28365556, 28628468, 28890868, 29087988, 29153780, 28825076, 28628466, 28825076, 28759539, 28825075, 28759540, 28825076, 28759540, 28759796, 28825076, 28759540, 28758769, 28763645, 28744911, 28976259, 28975232, 28845955, 28910722, 28910978, 28975745, 28975745, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 29040769, 28910722, 28910722, 28910979, 28845443, 29170302, 28793509, 29090299, 30992375, 30992631, 31058681, 31058425, 31123961, 31123961, 31058425, 30992889, 31123961, 30992889, 30992888, 31189752, 29810422, 28628211, 28759539, 28759539, 28759795, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28496626, 28956661, 29810421, 30401783, 30927096, 30993144, 31124216, 30729975, 29022196, 28628210, 28825332, 28825587, 28759539, 28825331, 28825075, 28759539, 28759539, 28759026, 28828154, 28748503, 28976515, 28975489, 28845699, 28910722, 28910978, 29041025, 28848009, 28913288, 28975745, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845442, 28849806, 28975746, 28910722, 28910722, 28910722, 28845955, 29170302, 28730795, 30536703, 31189239, 31058424, 31124216, 31124216, 31058680, 31124216, 31058680, 31058679, 31058424, 31386872, 30533111, 28825076, 28759539, 28825331, 28759284, 28759539, 28759794, 28760051, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28825334, 28693748, 29876214, 30927096, 31321336, 31321338, 31124472, 31123960, 31123960, 31321080, 30795768, 28891123, 28759795, 28890611, 28759795, 28825075, 28825332, 28825332, 28825075, 28825846, 28823022, 28849292, 29106048, 28845699, 28910722, 28910722, 28976002, 28911493, 28811217, 28850061, 29040769, 28910978, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845442, 29171328, 28805571, 28857762, 29170816, 28845698, 28910722, 28910722, 28911235, 28973950, 29332167, 31193343, 31123190, 31124474, 31123960, 31123960, 31124474, 31058424, 31123960, 31321338, 30598903, 28891123, 28694003, 28759539, 28759539, 28759539, 28825331, 28825331, 28825076, 28825332, 28890613, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28759282, 28825333, 30598648, 31386617, 31321083, 31189753, 31255289, 31189753, 31189753, 31189753, 31189497, 31452153, 30270199, 28628211, 28825331, 28759538, 28825332, 28825588, 28759795, 28758769, 28698879, 28792995, 29236608, 28845698, 28910722, 28910722, 28845698, 29301632, 28733875, 28806340, 29301632, 28845442, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845442, 29171329, 28787348, 28752352, 28976515, 28976002, 28910722, 28910722, 28910978, 29041538, 28846469, 29804775, 31388157, 31255032, 31189753, 31255289, 31255545, 31387131, 31123961, 30007799, 28759795, 28759283, 28825076, 28825075, 28825075, 28759795, 28890868, 28759539, 28825331, 28825332, 28825332, 28825331, 28694004, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28825333, 28824818, 28824820, 30598648, 31518459, 31190009, 31321081, 31321081, 31255801, 31190009, 31321081, 31321081, 31255801, 31321081, 31190009, 29022197, 28759284, 28825333, 28759540, 28825076, 28824562, 28894717, 28809934, 29041025, 28910978, 28910722, 28910722, 28910722, 29041282, 28847496, 28754407, 28915341, 29106305, 28845442, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845442, 29236609, 28809419, 28862124, 29301889, 28845442, 28910722, 28910722, 28845699, 29236608, 28725407, 29748991, 31057911, 31321081, 31189753, 30861304, 30138871, 29087988, 28627955, 28759796, 28890868, 28759284, 28825076, 28759540, 28825075, 28825332, 28759796, 28825589, 28825077, 28759539, 28694259, 28760052, 28825332, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28759797, 28825331, 28562420, 29875958, 31517945, 31320825, 31321337, 31321337, 31321337, 31386873, 31321337, 31321337, 31321337, 31386873, 31321337, 31518201, 29548022, 28562674, 28759540, 28825076, 28825332, 28824563, 28828669, 28852885, 29171585, 28910979, 28910722, 28910722, 28910979, 29367425, 28800695, 28867257, 29367681, 28845442, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845442, 29171841, 28915855, 28818147, 28977286, 28976002, 28910722, 28910722, 28910722, 28910978, 29041538, 28614866, 29091067, 29350387, 29022452, 28759796, 28562675, 28694004, 28825076, 28825076, 28759796, 28759796, 28825333, 28825332, 28694003, 28759796, 28825332, 28825076, 28825332, 28759540, 28759796, 28825076, 28759539, 28825076, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28628208, 28759282, 28825076, 28891123, 28759796, 30992632, 31518201, 31452665, 31452665, 31452153, 31452665, 31452665, 31452665, 31452665, 31452152, 31452153, 31452665, 31649529, 29810165, 28628211, 28825075, 28825075, 28759026, 28762362, 28810704, 28975745, 28910978, 28910722, 28910722, 28845442, 29172098, 28914314, 28685792, 28978055, 29041282, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910979, 29367682, 28802748, 28798127, 29498498, 28910979, 28910722, 28910722, 28910979, 29302658, 28857503, 28765951, 28561392, 28628466, 28825587, 28890868, 28825075, 28825332, 28759540, 28694004, 28825331, 28759282, 28825075, 28694003, 28693747, 28759795, 28890867, 28759795, 28759795, 28759283, 28759795, 28694003, 28825331, 28824819, 28694003, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28825843, 28759796, 28825589, 28694003, 28628210, 29219060, 31321081, 31452409, 31452666, 31386873, 31452409, 31452409, 31452409, 31452409, 31452409, 31452409, 31452409, 31386873, 31583993, 29613557, 28628467, 28759538, 28759539, 28758768, 28764415, 28861611, 29236608, 28845698, 28910722, 28910722, 28910978, 29302915, 28803003, 28861355, 29433475, 28910979, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845442, 29106818, 28913802, 28880859, 28914059, 29106818, 28845186, 28910722, 28845186, 29106818, 28848009, 28756971, 28826103, 28759794, 28759282, 28759282, 28825075, 28825589, 28694003, 28759796, 28759282, 28759796, 28759539, 28759539, 28694003, 28825075, 28759539, 28759539, 28759539, 28759539, 28759539, 28759539, 28694003, 28759282, 28759796, 28825332, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28759795, 28759797, 28825846, 28759796, 28825588, 28628468, 29416438, 31518202, 31583738, 31583738, 31583738, 31518202, 31518202, 31583738, 31518202, 31518202, 31518202, 31583994, 31583740, 31518202, 29088244, 28759795, 28825076, 28825076, 28824563, 28763133, 28920731, 29105792, 28845442, 28910722, 28910722, 28976002, 28845700, 28849292, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 29041282, 28847497, 28848265, 29041538, 28910722, 28910722, 28910722, 28910722, 28910979, 28812757, 28763391, 28758514, 28825332, 28825332, 28824820, 28824820, 28824820, 28825332, 28694004, 28694004, 28824820, 28824820, 28824820, 28694004, 28694004, 28825588, 28825334, 28759796, 28759284, 28890868, 28890868, 28825076, 28825846, 28825077, 28760053, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28759797, 28825332, 28825075, 28759795, 28890867, 28956403, 28759283, 29153781, 31452666, 31649530, 31649530, 31649530, 31649530, 31649530, 31649786, 31649530, 31649530, 31715322, 31649530, 31846650, 30664183, 28628468, 28890868, 28759796, 28825076, 28758513, 28829695, 28854425, 29302401, 28845699, 28845442, 28910722, 28910722, 28910722, 29172098, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910978, 28910978, 28910978, 28910978, 28910978, 28910978, 28910978, 28910978, 28845186, 28910722, 28910722, 28910722, 28910722, 28910722, 28845186, 29106818, 29041282, 28910722, 28910722, 28845186, 28910978, 28910723, 28976259, 28879320, 28697340, 28759281, 28890867, 28759795, 28759795, 28759283, 28890867, 28759795, 28890867, 28759795, 28759795, 28759795, 28890867, 28759795, 28759281, 28759283, 28890867, 28759796, 29022196, 28759796, 28497137, 28627699, 28759795, 28825075, 28890868, 28759284, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28759539, 28890869, 28890868, 28694002, 28694002, 28759538, 28825589, 28824821, 28562675, 30993144, 31912442, 31715322, 31781370, 31781370, 31715322, 31781370, 31780858, 31780858, 31780858, 31780858, 31583992, 29153781, 28694260, 28825332, 28825332, 28825332, 28824306, 28697597, 28803516, 29107075, 29499781, 29434245, 28910722, 28910722, 28910722, 28845442, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 29041539, 29434245, 29499781, 29434245, 29499781, 29499781, 29434245, 29434245, 29499781, 29237892, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845186, 28910722, 28910722, 28845186, 29237892, 29434245, 29630597, 28787862, 28762876, 28759026, 28694002, 28825077, 28825589, 28825589, 28825589, 28694002, 28825589, 28694002, 28825589, 28825589, 28825074, 28825077, 28760053, 28824818, 28890613, 28694005, 30335735, 31583738, 31255800, 30926840, 29744887, 28562930, 28759285, 28759282, 28825077, 28759794, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28694005, 28890870, 28824820, 28759798, 28825588, 28825588, 28825588, 28890356, 28562675, 29810679, 31912442, 31912187, 31912187, 31846650, 31912187, 31846650, 31846650, 31846394, 32174843, 31846651, 29416437, 28694003, 28890867, 28825075, 28825075, 28759539, 28825332, 28824560, 28633855, 28742600, 28989347, 28794534, 28847496, 29107075, 28845186, 28910722, 28910722, 28910722, 28910722, 28910722, 28845442, 29172355, 28848523, 28796589, 28923041, 28922528, 28792225, 28858531, 28923041, 28922527, 28926633, 28855195, 29107075, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 29041540, 28855452, 29055396, 28995507, 28628212, 28695030, 28824820, 28824820, 28824820, 28759798, 28824820, 28824820, 28824820, 28628212, 28825588, 28824820, 28825588, 28825588, 28759796, 28759540, 28759794, 28627954, 29613301, 32043771, 32043771, 32043771, 32043771, 31912442, 30599160, 28693748, 28890870, 28890870, 28825077, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28693744, 28694003, 28694003, 28759795, 28890611, 28759795, 28890611, 28694003, 28759795, 28890611, 28562419, 30533111, 32175101, 31977723, 31912443, 31977979, 31977979, 32109051, 32109051, 31321082, 29284853, 28628209, 28825587, 28825587, 28825587, 28825587, 28759538, 28760051, 28825843, 28824048, 28633599, 28770303, 28770303, 28848778, 29303429, 28910723, 28910722, 28910722, 28910722, 28910722, 28910722, 28910978, 29434502, 28917393, 28770303, 28834047, 28901375, 28901375, 28704767, 28770303, 28834047, 28704767, 28803517, 29303428, 28845186, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845186, 29303428, 28805057, 28639231, 28569599, 28694003, 28628208, 28759795, 28890611, 28890611, 28759795, 28759795, 28890611, 28694003, 28890611, 28759027, 28890611, 28759795, 28759795, 28759282, 28825587, 28825075, 28627955, 30795768, 32240637, 31912443, 31977981, 31912187, 31912187, 32174845, 30401785, 28431091, 28956403, 28694003, 28825076, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28891127, 28693493, 28824821, 28825845, 28694005, 28825077, 28694002, 28825077, 28825845, 28694002, 28890613, 28824817, 28693493, 30598903, 32043515, 32175099, 32306429, 31977979, 31255801, 29942008, 28694004, 28694004, 28825588, 28760052, 28760052, 28759539, 28694259, 28759794, 28694005, 28628466, 28825845, 28757999, 28952041, 28964863, 28790941, 29761928, 28845186, 28910722, 28910722, 28910722, 28845186, 28845186, 28910723, 29631111, 28861612, 28897535, 28952812, 28823023, 28823023, 28823020, 28823023, 28691180, 28693234, 28753124, 28912518, 29303684, 28779650, 28845186, 28910722, 28910722, 28845186, 28779650, 29369221, 28846982, 28820455, 28758002, 28823020, 28825077, 28694002, 28694002, 28694002, 28825077, 28825845, 28694005, 28694002, 28825077, 28825845, 28694002, 28825077, 28825845, 28824821, 28825075, 28759796, 28825332, 28694004, 30927097, 32175099, 32044027, 32043515, 31977979, 31977977, 32175101, 31517945, 28759283, 28759029, 28825077, 28759797, 28759540, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28760053, 28759028, 28891380, 28890356, 28825588, 28825591, 28825588, 28825588, 28825588, 28825588, 28825588, 28694004, 28759796, 28496884, 30072823, 30402041, 29810422, 29153268, 28628468, 28496882, 28825076, 28825332, 28759540, 28694260, 28694260, 28759797, 28825847, 28890867, 28956404, 28890356, 28825588, 28825588, 28890356, 28825588, 28890356, 28915598, 29696904, 29238149, 28976259, 28976258, 29041795, 29369221, 29696904, 28786836, 28896255, 28890356, 28825588, 28825588, 28825588, 28825588, 28890356, 28825588, 28955121, 0, 28866488, 29173125, 29565831, 29107332, 28976258, 28976258, 29107332, 29565831, 29173382, 28802234, 0, 28757745, 28825588, 28890356, 28628212, 28890356, 28825588, 28891380, 28825588, 28825588, 28825588, 28825588, 28825588, 28825588, 28825588, 28628212, 28694259, 28759797, 28825076, 28890868, 28562418, 30270199, 32371963, 32043259, 32043771, 32043771, 32109307, 32109307, 31714809, 29153782, 28825075, 28891380, 28759796, 28759029, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28890099, 0, 28824559, 0, 28825587, 0, 28824563, 28824563, 0, 0, 28824563, 0, 28825587, 28825587, 0, 28167920, 28365809, 28627953, 28825075, 28956659, 28825075, 28825075, 28825077, 28693745, 28759280, 28955891, 0, 28824563, 28824559, 28824563, 0, 28825587, 28825587, 28824559, 0, 0, 28988320, 29109898, 28976772, 28910722, 28976772, 29044618, 28925349, 0, 0, 28824563, 28825587, 0, 0, 28824563, 0, 0, 28825587, 28691691, 0, 28807109, 29113233, 29042823, 28910723, 28910723, 29042822, 29047954, 28677575, 0, 28691691, 0, 0, 28825587, 0, 0, 0, 0, 28824563, 28824563, 0, 0, 28824563, 0, 0, 28824563, 28824563, 28825587, 28694003, 28825076, 28693747, 28825332, 31715065, 32568827, 32175355, 32175355, 32175099, 32437757, 31321337, 28628467, 0, 28562419, 0, 28824563, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28825587, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29072080, 28805315, 28745426, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28818403, 28872135, 29002695, 28818403, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28759797, 28759538, 28759795, 28628467, 29285109, 31518457, 32635389, 32634875, 32569339, 31978233, 29745145, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28825332, 28825076, 28759795, 28628211, 28694003, 29745141, 30927095, 31517946, 29876213, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28694004, 28825073, 28891124, 28562417, 28299505, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
const _M0FP49LING7167111moon_2degui8examples6canvas9host__keyN6constrS1063 = 4;
const _M0FP49LING7167111moon_2degui8examples6canvas9host__keyN6constrS1064 = 2;
const _M0FP49LING7167111moon_2degui8examples6canvas9host__keyN6constrS1065 = 3;
const _M0FP49LING7167111moon_2degui8examples6canvas9host__keyN6constrS1066 = 5;
const _M0FP49LING7167111moon_2degui8examples6canvas9host__keyN6constrS1067 = 8;
const _M0FP49LING7167111moon_2degui8examples6canvas9host__keyN6constrS1068 = 9;
const _M0FP49LING7167111moon_2degui8examples6canvas9host__keyN6constrS1069 = 6;
const _M0FP49LING7167111moon_2degui8examples6canvas9host__keyN6constrS1070 = 7;
const _M0FP49LING7167111moon_2degui8examples6canvas9host__keyN6constrS1071 = 12;
const _M0FP49LING7167111moon_2degui8examples6canvas9host__keyN6constrS1072 = 13;
const _M0FP49LING7167111moon_2degui8examples6canvas9host__keyN6constrS1073 = 10;
const _M0FP49LING7167111moon_2degui8examples6canvas9host__keyN6constrS1074 = 11;
const _M0FP49LING7167111moon_2degui8examples6canvas9host__keyN6constrS1075 = 0;
const _M0FP49LING7167111moon_2degui8examples6canvas9host__keyN6constrS1076 = 1;
const _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1083 = { _0: "Button 按钮", _1: "ui.button(text, shortcut~, primary~, size~) -> Response", _2: "///| Button 交互示例\npub fn draw_buttons(ui : @core.UIContext, state : AppState) -> Unit {\n  // 主要按钮（支持快捷键）\n  let res_primary = ui.button(\"提交操作\", shortcut=\"⌘S\", primary=true)\n  if res_primary.clicked {\n    state.count = state.count + 1\n  }\n\n  // 次要重置按钮\n  let res_reset = ui.button(\"重置状态\", shortcut=\"Esc\")\n  if res_reset.clicked {\n    state.count = 0\n  }\n\n  // 自定义尺寸按钮\n  let _ = ui.button(\"自定义尺寸\", size=Some(@math.Vec2::new(140.0, 36.0)))\n}" };
const _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1084 = { _0: "TextEdit 文本输入", _1: "ui.text_edit(id_salt, text, placeholder~) -> (String, Response)", _2: "///| TextEdit 文本编辑示例\npub fn draw_text_edit(ui : @core.UIContext, state : AppState) -> Unit {\n  let (new_text, res) = ui.text_edit(\n    \"user_input\",\n    state.username,\n    placeholder=\"请输入用户名...\",\n  )\n  if res.changed {\n    state.username = new_text\n  }\n}" };
const _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1085 = { _0: "CodeEditor 代码编辑器", _1: "ui.code_editor(id_salt, text, size~, show_line_numbers~, read_only~) -> (String, Response)", _2: "///| CodeEditor 代码编辑示例\npub fn draw_code_editor(ui : @core.UIContext, state : AppState) -> Unit {\n  let (updated_code, resp) = ui.code_editor(\n    \"cad_script\",\n    state.script_source,\n    size=Some(@math.Vec2::new(ui.available_width(), 240.0)),\n    show_line_numbers=true,\n    read_only=false,\n  )\n  if resp.changed() {\n    state.script_source = updated_code\n  }\n}" };
const _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1086 = { _0: "RichText 流式富文本", _1: "ui.rich_text(spans, wrap_width~) -> Response", _2: "///| RichText 富文本示例\npub fn draw_rich_text(ui : @core.UIContext) -> Unit {\n  let spans = [\n    @core.TextSpan::bold(\"MoonBit Native GUI \"),\n    @core.TextSpan::normal(\"提供高性能立即模式排版与 \"),\n    @core.TextSpan::code(\"Wasm-GC\"),\n    @core.TextSpan::normal(\" 运行时支持。\"),\n  ]\n  let _ = ui.rich_text(spans, wrap_width=ui.available_width())\n}" };
const _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1087 = { _0: "Checkbox 复选框", _1: "ui.checkbox(label, is_checked) -> (Bool, Response)", _2: "///| Checkbox 复选框示例\npub fn draw_checkbox(ui : @core.UIContext, state : AppState) -> Unit {\n  let (checked, res) = ui.checkbox(\"启用硬件加速渲染\", state.gpu_enabled)\n  if res.changed {\n    state.gpu_enabled = checked\n  }\n}" };
const _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1088 = { _0: "Toggle 胶囊开关", _1: "ui.toggle(label, is_checked) -> (Bool, Response)", _2: "///| Toggle 开关示例\npub fn draw_toggles(ui : @core.UIContext, state : AppState) -> Unit {\n  let (snap, res) = ui.toggle(\"吸附到网格节点\", state.grid_snap)\n  if res.changed {\n    state.grid_snap = snap\n  }\n}" };
const _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1089 = { _0: "Radio 单选按钮", _1: "ui.radio(label, is_selected) -> (Bool, Response)", _2: "///| Radio 单选框示例\npub fn draw_radio(ui : @core.UIContext, state : AppState) -> Unit {\n  let (r1, _) = ui.radio(\"性能优先 (60 FPS)\", state.quality == 0)\n  if r1 { state.quality = 0 }\n  let (r2, _) = ui.radio(\"均衡模式 (渲染优化)\", state.quality == 1)\n  if r2 { state.quality = 1 }\n}" };
const _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1090 = { _0: "SegmentedControl 分段单选", _1: "ui.segmented_control(id_salt, selected_index, options) -> (Int, Response)", _2: "///| SegmentedControl 分段单选示例\npub fn draw_segmented(ui : @core.UIContext, state : AppState) -> Unit {\n  let (sel, res) = ui.segmented_control(\n    \"view_mode\",\n    state.selected_view,\n    [\"设计视图\", \"拆分对比\", \"代码查看\"],\n  )\n  if res.changed {\n    state.selected_view = sel\n  }\n}" };
const _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1091 = { _0: "Slider 滑动条", _1: "ui.slider(label, value, min, max, format~) -> (Double, Response)", _2: "///| Slider 滑动条示例\npub fn draw_slider(ui : @core.UIContext, state : AppState) -> Unit {\n  let (new_val, res) = ui.slider(\"缩放倍率\", state.zoom, 0.1, 5.0, format=\"%.2fx\")\n  if res.changed {\n    state.zoom = new_val\n  }\n}" };
const _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1092 = { _0: "DragValue 数字微调", _1: "ui.drag_value(label, value, speed~, min~, max~) -> (Double, Response)", _2: "///| DragValue 拖拽微调示例\npub fn draw_drag_value(ui : @core.UIContext, state : AppState) -> Unit {\n  let (new_val, res) = ui.drag_value(\"画板 X 偏移\", state.offset_x, speed=1.0)\n  if res.changed {\n    state.offset_x = new_val\n  }\n}" };
const _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1093 = { _0: "Knob 旋钮调节器", _1: "ui.knob(id_salt, label, value, min, max, unit~) -> (Double, Response)", _2: "///| Knob 旋转音频/滤镜控制器示例\npub fn draw_knob(ui : @core.UIContext, state : AppState) -> Unit {\n  let (cutoff, res) = ui.knob(\"cutoff_knob\", \"低通截止\", state.cutoff, 20.0, 20000.0, unit=\"Hz\")\n  if res.changed {\n    state.cutoff = cutoff\n  }\n}" };
const _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1094 = { _0: "ComboBox 下拉选择框", _1: "ui.combo_box(id_salt, selected_index, options) -> (Int, Response)", _2: "///| ComboBox 下拉选择器示例\npub fn draw_combo_box(ui : @core.UIContext, state : AppState) -> Unit {\n  let (sel, res) = ui.combo_box(\n    \"export_fmt\",\n    state.selected_format,\n    [\"SVG 矢量图像\", \"PNG 光栅切图\", \"PDF 工程图纸\"],\n  )\n  if res.changed {\n    state.selected_format = sel\n  }\n}" };
const _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1095 = { _0: "ColorButton 调色板按钮", _1: "ui.color_button(id_salt, color, size~) -> (@color.Color, Response)", _2: "///| ColorButton 颜色预设按钮示例\npub fn draw_color_button(ui : @core.UIContext, state : AppState) -> Unit {\n  let (c, res) = ui.color_button(\"theme_color\", state.accent)\n  if res.clicked {\n    state.show_palette = true\n  }\n}" };
const _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1096 = { _0: "ColorPicker HSV 拾色器", _1: "ui.color_picker(id_salt, color) -> (@color.Color, Response)", _2: "///| ColorPicker HSV 连续拾色器示例\npub fn draw_color_picker(ui : @core.UIContext, state : AppState) -> Unit {\n  let (new_col, res) = ui.color_picker(\"active_color_picker\", state.color)\n  if res.changed {\n    state.color = new_col\n  }\n}" };
const _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1097 = { _0: "ProgressBar 进度条", _1: "ui.progress_bar(progress, text~) -> Unit", _2: "///| ProgressBar 进度条示例\npub fn draw_progress_bar(ui : @core.UIContext, state : AppState) -> Unit {\n  ui.progress_bar(state.load_progress, text=\"加载资产资源 68%\")\n}" };
const _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1098 = { _0: "Spinner 微加载动画", _1: "ui.spinner(radius~, color~) -> Unit", _2: "///| Spinner 加载动画示例\npub fn draw_spinner(ui : @core.UIContext) -> Unit {\n  ui.spinner(radius=12.0, color=@color.Color::accent_primary())\n}" };
const _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1099 = { _0: "Badge / Tag 徽章标签", _1: "ui.badge(text, kind~) -> Unit", _2: "///| Badge 徽章标签示例\npub fn draw_badges(ui : @core.UIContext) -> Unit {\n  ui.badge(\"运行正常\", kind=@core.BadgeKind::Success)\n  ui.badge(\"需要关注\", kind=@core.BadgeKind::Warning)\n}" };
const _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1100 = { _0: "Sparkline 迷你走势图", _1: "ui.sparkline(data, width, height, color~) -> Unit", _2: "///| Sparkline 走势图示例\npub fn draw_sparkline(ui : @core.UIContext, state : AppState) -> Unit {\n  ui.sparkline(state.fps_history, 240.0, 48.0, color=@color.Color::accent_primary())\n}" };
const _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1101 = { _0: "CollapsingHeader 折叠树", _1: "ui.collapsing_header(id_salt, label, content, default_open~) -> Unit", _2: "///| CollapsingHeader 折叠树示例\npub fn draw_collapsing(ui : @core.UIContext) -> Unit {\n  ui.collapsing_header(\"geom_group\", \"几何图元属性\", fn(ui_sub) {\n    let _ = ui_sub.label(\"顶点数量: 16,384\")\n    let _ = ui_sub.label(\"面片索引: 32,768\")\n  }, default_open=true)\n}" };
const _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1102 = { _0: "TreeView 资产层级树", _1: "ui.tree_view(id_salt, root_node, expanded_ids, selected_id) -> (String?, Response)", _2: "///| TreeView 树状资源管理示例\npub fn draw_tree(ui : @core.UIContext, state : AppState) -> Unit {\n  let (sel, res) = ui.tree_view(\n    \"project_tree\",\n    state.project_root,\n    state.expanded_nodes,\n    state.selected_file,\n  )\n  if res.changed {\n    state.selected_file = sel\n  }\n}" };
const _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1103 = { _0: "Tooltip 悬浮提示", _1: "ui.tooltip(target_rect, text) -> Unit", _2: "///| Tooltip 提示浮层示例\npub fn draw_tooltip_button(ui : @core.UIContext) -> Unit {\n  let resp = ui.button(\"查看帮助文档\")\n  if resp.hovered() {\n    ui.tooltip(resp.rect, \"点击在侧边栏打开 MoonBit API 参考手册\")\n  }\n}" };
const _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1104 = { _0: "Splitter 分割面板", _1: "ui.split_horizontal(id_salt, ratio, left, right) -> Double", _2: "///| Splitter 分割视图示例\npub fn draw_splitter(ui : @core.UIContext, state : AppState) -> Unit {\n  let new_ratio = ui.split_horizontal(\n    \"main_split\",\n    state.ratio,\n    fn(ui_left, w, h) { draw_viewport(ui_left, w, h) },\n    fn(ui_right, w, h) { draw_inspector(ui_right, w, h) },\n  )\n  state.ratio = new_ratio\n}" };
const _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1105 = { _0: "Table 虚拟化数据表格", _1: "ui.table(id_salt, columns, row_count, row_height~, cell_renderer) -> Unit", _2: "///| Table 数据表格示例\npub fn draw_table(ui : @core.UIContext, state : AppState) -> Unit {\n  ui.table(\n    \"telemetry_table\",\n    state.columns,\n    state.rows.length(),\n    row_height=28.0,\n    fn(ui_cell, row_idx, col_idx, rect) {\n      draw_cell(ui_cell, row_idx, col_idx, rect)\n    },\n  )\n}" };
const _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1106 = { _0: "TabBar 标签页导航", _1: "ui.tab_bar(id_salt, selected_index, tabs) -> (Int, Response)", _2: "///| TabBar 选项卡导航示例\npub fn draw_tab_bar(ui : @core.UIContext, state : AppState) -> Unit {\n  let (sel, res) = ui.tab_bar(\n    \"studio_tabs\",\n    state.current_tab,\n    [\"图纸层\", \"物理碰撞\", \"渲染管线\"],\n  )\n  if res.changed {\n    state.current_tab = sel\n  }\n}" };
const _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1107 = { _0: "MenuBar 顶层菜单栏", _1: "ui.menu_bar(menus) -> Unit", _2: "///| MenuBar 顶层菜单示例\npub fn draw_menu_bar(ui : @core.UIContext) -> Unit {\n  ui.menu_bar([\n    { title: \"文件\", items: [{ id: \"open\", label: \"打开工程...\", shortcut: \"⌘O\" }] },\n    { title: \"编辑\", items: [{ id: \"undo\", label: \"撤销\", shortcut: \"⌘Z\" }] },\n  ])\n}" };
const _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1108 = { _0: "ScrollArea 滚动区域", _1: "ui.scroll_area(id_salt, size, content) -> Unit", _2: "///| ScrollArea 滚动裁剪容器示例\npub fn draw_scroll_area(ui : @core.UIContext) -> Unit {\n  ui.scroll_area(\n    \"log_scroll\",\n    @math.Vec2::new(320.0, 200.0),\n    fn(ui_inner) { draw_long_list(ui_inner) },\n  )\n}" };
const _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1109 = { _0: "Breadcrumb 面包屑导航", _1: "ui.breadcrumb(items) -> (String?, Response)", _2: "///| Breadcrumb 路径导航示例\npub fn draw_breadcrumb(ui : @core.UIContext) -> Unit {\n  let (clicked, _) = ui.breadcrumb([\n    { id: \"root\", label: \"工作区\" },\n    { id: \"canvas\", label: \"画板演示\" },\n    { id: \"active\", label: \"组件配置\" },\n  ])\n  if clicked is Some(target) { navigate_to(target) }\n}" };
const _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1110 = { _0: "Window 浮动窗口", _1: "ui.window(title, pos, size, content) -> Response", _2: "///| Window 可拖拽悬浮窗示例\npub fn draw_floating_window(ui : @core.UIContext, state : AppState) -> Unit {\n  let _ = ui.window(\n    \"调试控制台\",\n    state.win_pos,\n    @math.Vec2::new(260.0, 320.0),\n    fn(ui_win) { draw_debug_controls(ui_win) },\n  )\n}" };
const _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1111 = { _0: "Dialog 模态对话框", _1: "ui.dialog(title, message, is_open, show_cancel~) -> DialogResult", _2: "///| Dialog 模态对话框示例\npub fn draw_dialog(ui : @core.UIContext, state : AppState) -> Unit {\n  let res = ui.dialog(\n    \"确认清空画板\",\n    \"该操作将清除当前所有未保存的几何图元，是否继续？\",\n    state.dialog_open,\n    show_cancel=true,\n  )\n  match res {\n    Confirmed => { clear_canvas(); state.dialog_open = false }\n    Cancelled => state.dialog_open = false\n    Dismissed => ()\n  }\n}" };
const _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1112 = { _0: "CommandPalette 命令面板", _1: "ui.command_palette(id_salt, query, items, is_open) -> CommandPaletteResult", _2: "///| CommandPalette 快捷命令搜寻器示例\npub fn draw_palette(ui : @core.UIContext, state : AppState) -> Unit {\n  let res = ui.command_palette(\"global_commands\", state.query, state.command_list, state.open)\n  match res {\n    Execute(cmd) => execute(cmd)\n    Close => state.open = false\n    None => ()\n  }\n}" };
const _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1113 = { _0: "ContextMenu 上下文菜单", _1: "ui.context_menu(is_open, pos, items) -> (String?, Response)", _2: "///| ContextMenu 右键级联菜单示例\npub fn draw_context_menu(ui : @core.UIContext, state : AppState) -> Unit {\n  let (selected, _) = ui.context_menu(state.open, state.pos, state.menu_items)\n  if selected is Some(act) {\n    handle_action(act)\n    state.open = false\n  }\n}" };
const _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1114 = { _0: "Toast 全局通知", _1: "ui.toast_stack(toasts, screen_size) -> Unit", _2: "///| Toast 状态通知条示例\npub fn draw_toasts(ui : @core.UIContext, state : AppState) -> Unit {\n  ui.toast_stack(state.toasts, ui.screen_rect().size())\n}" };
const _M0FPB4seed = _M0FPB12random__seed();
const _M0MP49LING7167111moon_2degui3src4core9UIContext3newN6constrS4230 = 64;
const _M0MP49LING7167111moon_2degui3src4core9UIContext3newN6constrS4231 = 64;
const _M0MP49LING7167111moon_2degui3src4core9UIContext3newN6constrS4232 = 32;
const _M0MP49LING7167111moon_2degui3src4core9UIContext3newN6constrS4233 = 64;
const _M0MP49LING7167111moon_2degui3src4core9UIContext3newN6constrS4234 = 64;
const _M0MP49LING7167111moon_2degui3src4core9UIContext3newN6constrS4235 = 128;
const _M0MP49LING7167111moon_2degui3src4core9UIContext3newN6constrS4236 = 64;
const _M0MP49LING7167111moon_2degui3src4core9UIContext3newN6constrS4237 = 256;
const _M0MP49LING7167111moon_2degui3src4core9UIContext3newN6constrS4238 = 64;
const _M0FP49LING7167111moon_2degui8examples6canvas12gallery__ctx = _M0MP49LING7167111moon_2degui3src4core9UIContext3new();
const _M0FP49LING7167111moon_2degui8examples6canvas3ctx = _M0MP49LING7167111moon_2degui3src4core9UIContext3new();
const _M0FP49LING7167111moon_2degui8examples6canvas14gallery__stateN6constrS1062 = "main_mbt";
const _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state = new _M0TP49LING7167111moon_2degui8examples6canvas12GalleryState(0, true, false, false, true, true, false, true, false, 1, 1.25, 85, 120, 80, 1, 1200, 25, 0, 6, 0, 1, 0, 0.68, _M0FP49LING7167111moon_2degui8examples6canvas14gallery__stateN6constrS1062, ["src", "assets"], 0, "MoonBit Developer", "dev@moonbitlang.com", "///| Welcome to moon-egui native CodeEditor\npub fn render(ui : @core.UIContext) -> Unit {\n  ui.label(\"Pure MoonBit Wasm Engine!\")\n  ui.button(\"Live Immediate-Mode\")\n}", [], false, "", 0, false, _M0MP49LING7167111moon_2degui3src4math4Vec23new(180, 140), "Ready", "", 0.45, "id", 0, [_M0MP49LING7167111moon_2degui3src4core11TableColumn11new_2einner("id", "ID", 60, 50, true), _M0MP49LING7167111moon_2degui3src4core11TableColumn11new_2einner("name", "Name", 140, 80, true), _M0MP49LING7167111moon_2degui3src4core11TableColumn11new_2einner("role", "Role", 110, 70, true), _M0MP49LING7167111moon_2degui3src4core11TableColumn11new_2einner("score", "Score", 80, 60, true)], 1, false, "None", 0, true, true, true, [12, 28, 19, 35, 22, 48, 38, 55, 42, 68, 60, 85], _M0MP49LING7167111moon_2degui3src5color5Color3rgb(79, 70, 229), "None", "None", 0, 0.5, 0);
const _M0MP49LING7167111moon_2degui3src4core9UIContext15button__primaryN6constrS4240 = true;
const _M0FP49LING7167111moon_2degui8examples6canvas22draw__window__showcaseN6constrS1082 = "gallery_win";
const _M0MP49LING7167111moon_2degui3src4core9UIContext18breadcrumb_2einnerN5tupleS4241 = { _0: "...", _1: -1 };
const _M0FP49LING7167111moon_2degui8examples6canvas29draw__context__menu__showcaseN6constrS1077 = "⌘C";
const _M0FP49LING7167111moon_2degui8examples6canvas29draw__context__menu__showcaseN6constrS1078 = "⌘V";
const _M0FP49LING7167111moon_2degui8examples6canvas29draw__context__menu__showcaseN6constrS1079 = "F12";
const _M0MPC16string10StringView4findN6constrS9865 = 0;
const _M0FP49LING7167111moon_2degui8examples6canvas23draw__spinner__showcaseN6constrS1080 = new _M0DTPC16option6OptionGdE4Some(18);
const _M0FP49LING7167111moon_2degui8examples6canvas23draw__spinner__showcaseN6constrS1081 = new _M0DTPC16option6OptionGdE4Some(18);
const _M0MP49LING7167111moon_2degui3src4core9UIContext20code__editor_2einnerN6constrS4239 = 0;
function _M0FPB13consume4__acc(acc, input) {
  const _p = (acc >>> 0) + ((Math.imul(input, -1028477379) | 0) >>> 0) | 0;
  const _p$2 = 17;
  return Math.imul(_p << _p$2 | (_p >>> (32 - _p$2 | 0) | 0), 668265263) | 0;
}
function _M0MPB6Hasher8consume4(self, input) {
  self.acc = _M0FPB13consume4__acc(self.acc, input);
}
function _M0MPB13StringBuilder13write__objectGiE(self, obj) {
  _M0IP016_24default__implPB4Show6outputGiE(obj, { self: self, method_table: _M0FP092moonbitlang_2fcore_2fbuiltin_2fStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger });
}
function _M0MPB13StringBuilder13write__objectGdE(self, obj) {
  _M0IP016_24default__implPB4Show6outputGdE(obj, { self: self, method_table: _M0FP092moonbitlang_2fcore_2fbuiltin_2fStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger });
}
function _M0MPB13StringBuilder21StringBuilder_2einner(size_hint) {
  return new _M0TPB13StringBuilder("");
}
function _M0IPB13StringBuilderPB6Logger11write__char(self, ch) {
  self.val = `${self.val}${String.fromCodePoint(ch)}`;
}
function _M0IPB13StringBuilderPB6Logger13write__string(self, str) {
  self.val = `${self.val}${str}`;
}
function _M0FPB32code__point__of__surrogate__pair(leading, trailing) {
  return (((Math.imul(leading - 55296 | 0, 1024) | 0) + trailing | 0) - 56320 | 0) + 65536 | 0;
}
function _M0MPC16string10StringView12view_2einner(self, start_offset, end_offset) {
  let end_offset$2;
  if (end_offset === undefined) {
    end_offset$2 = self.end - self.start | 0;
  } else {
    const _Some = end_offset;
    end_offset$2 = _Some;
  }
  if (start_offset >= 0 && (start_offset <= end_offset$2 && end_offset$2 <= (self.end - self.start | 0))) {
    return new _M0TPC16string10StringView(self.str, self.start + start_offset | 0, self.start + end_offset$2 | 0);
  } else {
    return $panic();
  }
}
function _M0MPB6Hasher7combineGRP49LING7167111moon_2degui3src4core2IdE(self, value) {
  _M0IP49LING7167111moon_2degui3src4core2IdPB4Hash13hash__combine(value, self);
}
function _M0IP016_24default__implPB2Eq10not__equalGRP49LING7167111moon_2degui3src4core2IdE(x, y) {
  return !(BigInt.asUintN(64, x.val) === BigInt.asUintN(64, y.val));
}
function _M0IP016_24default__implPB2Eq10not__equalGOsE(x, y) {
  return !_M0IPC16option6OptionPB2Eq5equalGsE(x, y);
}
function _M0MPB6Hasher14Hasher_2einner(seed) {
  return new _M0TPB6Hasher((seed >>> 0) + (374761393 >>> 0) | 0);
}
function _M0MPB6Hasher6Hasher(seed$46$opt) {
  let seed;
  if (seed$46$opt === undefined) {
    seed = _M0FPB4seed;
  } else {
    const _Some = seed$46$opt;
    seed = _Some;
  }
  return _M0MPB6Hasher14Hasher_2einner(seed);
}
function _M0FPB14avalanche__acc(acc) {
  let acc$2 = acc;
  acc$2 = acc$2 ^ (acc$2 >>> 15 | 0);
  acc$2 = Math.imul(acc$2, -2048144777) | 0;
  acc$2 = acc$2 ^ (acc$2 >>> 13 | 0);
  acc$2 = Math.imul(acc$2, -1028477379) | 0;
  acc$2 = acc$2 ^ (acc$2 >>> 16 | 0);
  return acc$2;
}
function _M0FPB13finalize__acc(acc) {
  return _M0FPB14avalanche__acc(acc);
}
function _M0MPB6Hasher8finalize(self) {
  return _M0FPB13finalize__acc(self.acc);
}
function _M0IP016_24default__implPB4Hash4hashGRP49LING7167111moon_2degui3src4core2IdE(self) {
  const h = _M0MPB6Hasher6Hasher(undefined);
  _M0MPB6Hasher7combineGRP49LING7167111moon_2degui3src4core2IdE(h, self);
  return _M0MPB6Hasher8finalize(h);
}
function _M0IP016_24default__implPB6Logger28write__string__interpolationGRPB13StringBuilderE(self, show) {
  show.method_table.method_0(show.self, { self: self, method_table: _M0FP092moonbitlang_2fcore_2fbuiltin_2fStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger });
}
function _M0IP016_24default__implPB6Logger5writeGRPB13StringBuilderE(self, show) {
  show.method_table.method_0(show.self, { self: self, method_table: _M0FP092moonbitlang_2fcore_2fbuiltin_2fStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger });
}
function _M0MPC16string6String11sub_2einner(self, start, end) {
  const len = self.length;
  let end$2;
  if (end === undefined) {
    end$2 = len;
  } else {
    const _Some = end;
    const _end = _Some;
    end$2 = _end;
  }
  if (start >= 0 && (start <= end$2 && end$2 <= len)) {
    if (start < len) {
      const _p = self.charCodeAt(start);
      if (!(_p >= 56320 && _p <= 57343)) {
      } else {
        $panic();
      }
    }
    if (end$2 < len) {
      const _p = self.charCodeAt(end$2);
      if (!(_p >= 56320 && _p <= 57343)) {
      } else {
        $panic();
      }
    }
    return new _M0TPC16string10StringView(self, start, end$2);
  } else {
    return $panic();
  }
}
function _M0IP016_24default__implPB6Logger16write__substringGRPB13StringBuilderE(self, value, start, len) {
  _M0IPB13StringBuilderPB6Logger11write__view(self, _M0MPC16string6String11sub_2einner(value, start, start + len | 0));
}
function _M0IP016_24default__implPB4Show6outputGiE(self, logger) {
  logger.method_table.method_0(logger.self, _M0IPC13int3IntPB4Show10to__string(self));
}
function _M0IP016_24default__implPB4Show6outputGdE(self, logger) {
  logger.method_table.method_0(logger.self, _M0IPC16double6DoublePB4Show10to__string(self));
}
function _M0MPB4Iter4nextGRPC16string10StringViewE(self) {
  const _func = self.f;
  const result = _func();
  const _bind = self.size_hint;
  if (result === undefined) {
    self.size_hint = _M0MPB4Iter4nextN6constrS9856GRPC16string10StringViewE;
  } else {
    if (_bind === undefined) {
    } else {
      const _Some = _bind;
      const _n = _Some;
      self.size_hint = _n > 0 ? _n - 1 | 0 : _M0MPB4Iter4nextN6constrS9855GRPC16string10StringViewE;
    }
  }
  return result;
}
function _M0MPB4Iter4nextGcE(self) {
  const _func = self.f;
  const result = _func();
  const _bind = self.size_hint;
  if (result === -1) {
    self.size_hint = _M0MPB4Iter4nextN6constrS9856GcE;
  } else {
    if (_bind === undefined) {
    } else {
      const _Some = _bind;
      const _n = _Some;
      self.size_hint = _n > 0 ? _n - 1 | 0 : _M0MPB4Iter4nextN6constrS9855GcE;
    }
  }
  return result;
}
function _M0MPC13int3Int18to__string_2einner(self, radix) {
  return _M0FPB19int__to__string__js(self, radix);
}
function _M0MPB4Iter3newGRPC16string10StringViewE(f, size_hint) {
  let size_hint$2;
  if (size_hint === undefined) {
    size_hint$2 = undefined;
  } else {
    const _Some = size_hint;
    const _n = _Some;
    size_hint$2 = _n > 0 ? _n : _M0MPB4Iter3newN6constrS9863GRPC16string10StringViewE;
  }
  return new _M0TPB4IterGRPC16string10StringViewE(f, size_hint$2);
}
function _M0MPB4Iter3newGcE(f, size_hint) {
  let size_hint$2;
  if (size_hint === undefined) {
    size_hint$2 = undefined;
  } else {
    const _Some = size_hint;
    const _n = _Some;
    size_hint$2 = _n > 0 ? _n : _M0MPB4Iter3newN6constrS9863GcE;
  }
  return new _M0TPB4IterGcE(f, size_hint$2);
}
function _M0MPC16string10StringView9to__owned(self) {
  return self.str.substring(self.start, self.end);
}
function _M0MPC16string10StringView4iter(self) {
  const start = self.start;
  const end = self.end;
  const index = new _M0TPB8MutLocalGiE(start);
  return _M0MPB4Iter3newGcE(() => {
    if (index.val < end) {
      const c1 = self.str.charCodeAt(index.val);
      if (c1 >= 55296 && c1 <= 56319 && (index.val + 1 | 0) < self.end) {
        const c2 = self.str.charCodeAt(index.val + 1 | 0);
        if (c2 >= 56320 && c2 <= 57343) {
          index.val = index.val + 2 | 0;
          return _M0FPB32code__point__of__surrogate__pair(c1, c2);
        }
      }
      index.val = index.val + 1 | 0;
      return c1;
    } else {
      return -1;
    }
  }, undefined);
}
function _M0MPC16string6String12view_2einner(self, start_offset, end_offset) {
  let end_offset$2;
  if (end_offset === undefined) {
    end_offset$2 = self.length;
  } else {
    const _Some = end_offset;
    end_offset$2 = _Some;
  }
  if (start_offset >= 0 && (start_offset <= end_offset$2 && end_offset$2 <= self.length)) {
    return new _M0TPC16string10StringView(self, start_offset, end_offset$2);
  } else {
    return $panic();
  }
}
function _M0IPB13StringBuilderPB6Logger11write__view(self, str) {
  self.val = `${self.val}${_M0MPC16string10StringView9to__owned(str)}`;
}
function _M0FPB19kmp__failure__table(pattern) {
  const m = pattern.end - pattern.start | 0;
  const table = $make_array_len_and_init(m, 0);
  let k = 0;
  let _tmp = 1;
  while (true) {
    const i = _tmp;
    if (i < m) {
      const c = pattern.str.charCodeAt(pattern.start + i | 0);
      while (true) {
        let _tmp$2;
        if (k > 0) {
          const _p = pattern.str.charCodeAt(pattern.start + k | 0);
          _tmp$2 = c !== _p;
        } else {
          _tmp$2 = false;
        }
        if (_tmp$2) {
          const _tmp$3 = k - 1 | 0;
          k = _tmp$3 >>> 0 < table.length ? table[_tmp$3] : $oob();
          continue;
        } else {
          break;
        }
      }
      const _p = pattern.str.charCodeAt(pattern.start + k | 0);
      if (c === _p) {
        k = k + 1 | 0;
      }
      if (i >>> 0 < table.length) {
        table[i] = k;
      } else {
        $oob();
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return table;
}
function _M0FPB24find__pattern__kmp__from(target, pattern, start) {
  const n = target.end - target.start | 0;
  const m = pattern.end - pattern.start | 0;
  const table = _M0FPB19kmp__failure__table(pattern);
  let k = 0;
  let _tmp = start;
  while (true) {
    const i = _tmp;
    if (i < n) {
      const c = target.str.charCodeAt(target.start + i | 0);
      while (true) {
        let _tmp$2;
        if (k > 0) {
          const _p = pattern.str.charCodeAt(pattern.start + k | 0);
          _tmp$2 = c !== _p;
        } else {
          _tmp$2 = false;
        }
        if (_tmp$2) {
          const _tmp$3 = k - 1 | 0;
          k = _tmp$3 >>> 0 < table.length ? table[_tmp$3] : $oob();
          continue;
        } else {
          break;
        }
      }
      const _p = pattern.str.charCodeAt(pattern.start + k | 0);
      if (c === _p) {
        k = k + 1 | 0;
      }
      if (k === m) {
        return (i - m | 0) + 1 | 0;
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return undefined;
}
function _M0FPB36find__two__anchor__candidate__scalar(data, start, candidate_end, first, last_offset, last) {
  let _tmp = start;
  while (true) {
    const pos = _tmp;
    if (pos < candidate_end) {
      let _tmp$2;
      const _p = data.charCodeAt(pos);
      if (_p === first) {
        const _p$2 = data.charCodeAt(pos + last_offset | 0);
        _tmp$2 = _p$2 === last;
      } else {
        _tmp$2 = false;
      }
      if (_tmp$2) {
        return pos;
      }
      _tmp = pos + 1 | 0;
      continue;
    } else {
      return -1;
    }
  }
}
function _M0FPB42find__two__anchor__candidate__from__string(data, start, candidate_end, first, last_offset, last) {
  return _M0FPB36find__two__anchor__candidate__scalar(data, start, candidate_end, first, last_offset, last);
}
function _M0FPB21string__ranges__equal(left, left_start, right, right_start, length) {
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < length) {
      const _p = left.charCodeAt(left_start + i | 0);
      const _p$2 = right.charCodeAt(right_start + i | 0);
      if (_p !== _p$2) {
        return false;
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return true;
}
function _M0FPB22find__by__two__anchors(target, pattern) {
  const target_len = target.end - target.start | 0;
  const pattern_len = pattern.end - pattern.start | 0;
  const target_start = target.start;
  const pattern_start = pattern.start;
  const last_offset = pattern_len - 1 | 0;
  const candidate_end = ((target_start + target_len | 0) - pattern_len | 0) + 1 | 0;
  const first = pattern.str.charCodeAt(pattern.start);
  const last = pattern.str.charCodeAt(pattern.start + last_offset | 0);
  const middle_len = last_offset - 1 | 0;
  let _tmp = target_start;
  let _tmp$2 = 0;
  while (true) {
    const pos = _tmp;
    const failures = _tmp$2;
    if (pos < candidate_end) {
      const found = _M0FPB42find__two__anchor__candidate__from__string(target.str, pos, candidate_end, first, last_offset, last);
      if (found < 0) {
        return undefined;
      }
      if (_M0FPB21string__ranges__equal(target.str, found + 1 | 0, pattern.str, pattern_start + 1 | 0, middle_len)) {
        return found - target_start | 0;
      }
      const failures$2 = failures + 1 | 0;
      const scanned = found - target_start | 0;
      if (failures$2 > 64 || failures$2 > (4 + (scanned / 8 | 0) | 0)) {
        return _M0FPB24find__pattern__kmp__from(target, pattern, scanned + 1 | 0);
      }
      _tmp = found + 1 | 0;
      _tmp$2 = failures$2;
      continue;
    } else {
      return undefined;
    }
  }
}
function _M0FPB24find__code__unit__scalar(data, start, end, code) {
  let _tmp = start;
  while (true) {
    const pos = _tmp;
    if (pos < end) {
      const _p = data.charCodeAt(pos);
      if (_p === code) {
        return pos;
      }
      _tmp = pos + 1 | 0;
      continue;
    } else {
      return -1;
    }
  }
}
function _M0FPB30find__code__unit__from__string(data, start, end, code) {
  return _M0FPB24find__code__unit__scalar(data, start, end, code);
}
function _M0FPB28find__code__unit__from__view(target, start, end, code) {
  const target_start = target.start;
  const found = _M0FPB30find__code__unit__from__string(target.str, target_start + start | 0, target_start + end | 0, code);
  return found < 0 ? -1 : found - target_start | 0;
}
function _M0MPC16string10StringView4find(self, str) {
  const pattern_len = str.end - str.start | 0;
  switch (pattern_len) {
    case 0: {
      return _M0MPC16string10StringView4findN6constrS9865;
    }
    case 1: {
      const found = _M0FPB28find__code__unit__from__view(self, 0, self.end - self.start | 0, str.str.charCodeAt(str.start));
      return found < 0 ? undefined : found;
    }
    default: {
      return pattern_len > (self.end - self.start | 0) ? undefined : _M0FPB22find__by__two__anchors(self, str);
    }
  }
}
function _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(self, value) {
  _M0MPB7JSArray4push(self, value);
}
function _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core3KeyE(self, value) {
  _M0MPB7JSArray4push(self, value);
}
function _M0MPC15array5Array4pushGiE(self, value) {
  _M0MPB7JSArray4push(self, value);
}
function _M0MPB4Iter3mapGcRPC16string10StringViewE(self, f) {
  return new _M0TPB4IterGRPC16string10StringViewE(() => {
    const _bind = _M0MPB4Iter4nextGcE(self);
    if (_bind === -1) {
      return undefined;
    } else {
      const _Some = _bind;
      const _x = _Some;
      return f(_x);
    }
  }, self.size_hint);
}
function _M0IPC14char4CharPB4Show10to__string(self) {
  return String.fromCodePoint(self);
}
function _M0MPC16string10StringView5split(self, sep) {
  const sep_len = sep.end - sep.start | 0;
  if (sep_len === 0) {
    return _M0MPB4Iter3mapGcRPC16string10StringViewE(_M0MPC16string10StringView4iter(self), (c) => _M0MPC16string6String12view_2einner(_M0IPC14char4CharPB4Show10to__string(c), 0, undefined));
  }
  const remaining = new _M0TPB8MutLocalGORPC16string10StringViewE(self);
  return _M0MPB4Iter3newGRPC16string10StringViewE(() => {
    const _bind = remaining.val;
    if (_bind === undefined) {
      return undefined;
    } else {
      const _Some = _bind;
      const _view = _Some;
      const _bind$2 = _M0MPC16string10StringView4find(_view, sep);
      if (_bind$2 === undefined) {
        remaining.val = undefined;
        return _view;
      } else {
        const _Some$2 = _bind$2;
        const _end = _Some$2;
        remaining.val = _M0MPC16string10StringView12view_2einner(_view, _end + sep_len | 0, undefined);
        return _M0MPC16string10StringView12view_2einner(_view, 0, _end);
      }
    }
  }, undefined);
}
function _M0MPC16string6String5split(self, sep) {
  return _M0MPC16string10StringView5split(new _M0TPC16string10StringView(self, 0, self.length), sep);
}
function _M0IPC13int3IntPB4Show10to__string(self) {
  return _M0MPC13int3Int18to__string_2einner(self, 10);
}
function _M0IPC16option6OptionPB2Eq5equalGsE(self, other) {
  if (self === undefined) {
    return other === undefined;
  } else {
    const _Some = self;
    const _x = _Some;
    if (other === undefined) {
      return false;
    } else {
      const _Some$2 = other;
      const _y = _Some$2;
      return _x === _y;
    }
  }
}
function _M0MPC16option6Option10unwrap__orGsE(self, default_) {
  if (self === undefined) {
    return default_;
  } else {
    const _Some = self;
    const _t = _Some;
    return _t;
  }
}
function _M0MPC13int3Int20next__power__of__two(self) {
  if (self >= 0) {
    if (self <= 1) {
      return 1;
    }
    if (self > 1073741824) {
      return 1073741824;
    }
    return (2147483647 >> (Math.clz32(self - 1 | 0) - 1 | 0)) + 1 | 0;
  } else {
    return $panic();
  }
}
function _M0MPC15array10FixedArray12fill_2einnerGORPC17hashmap5EntryGsdEE(self, value, start, end) {
  const array_length = self.length;
  if (array_length > 0) {
    if (start >= 0 && start < array_length) {
      let length;
      if (end === undefined) {
        length = array_length - start | 0;
      } else {
        const _Some = end;
        const _e = _Some;
        length = _e >= start && _e <= array_length ? _e - start | 0 : $panic();
      }
      self.fill(value, start, start + length);
      return;
    } else {
      $panic();
      return;
    }
  } else {
    return;
  }
}
function _M0MPB6Hasher14combine__int64(self, value) {
  self.acc = (self.acc >>> 0) + (8 >>> 0) | 0;
  _M0MPB6Hasher8consume4(self, Number(BigInt.asUintN(32, value)) | 0);
  _M0MPB6Hasher8consume4(self, Number(BigInt.asUintN(32, BigInt.asUintN(64, BigInt.asUintN(64, value) >> BigInt(32 & 63)))) | 0);
}
function _M0MPB6Hasher15combine__uint64(self, value) {
  _M0MPB6Hasher14combine__int64(self, value);
}
function _M0IPC16string6StringPB4Hash4hash(self) {
  let acc = (_M0FPB4seed >>> 0) + (374761393 >>> 0) | 0;
  const _bind = self.length;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < _bind) {
      acc = (acc >>> 0) + (4 >>> 0) | 0;
      const v = self.charCodeAt(i);
      acc = _M0FPB13consume4__acc(acc, v);
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return _M0FPB13finalize__acc(acc);
}
function _M0IPC16uint646UInt64PB4Hash13hash__combine(self, hasher) {
  _M0MPB6Hasher15combine__uint64(hasher, self);
}
function _M0MPC16double6Double7to__int(self) {
  return self !== self ? 0 : self >= 2147483647 ? 2147483647 : self <= -2147483648 ? -2147483648 : self | 0;
}
function _M0IPC16double6DoublePB3Mod3mod(self, other) {
  return _M0MPC16double6Double8mod__ffi(self, other);
}
function _M0MPC16double6Double3max(self, other) {
  return self !== self ? other : other !== other ? self : self > other ? self : other;
}
function _M0IPC16double6DoublePB4Show10to__string(self) {
  return String(self);
}
function _M0FPB7printlnGsE(input) {
  console.log(input);
}
function _M0MPC15array5Array28unsafe__truncate__to__lengthGRP49LING7167111moon_2degui3src4math4RectE(self, new_len) {
  _M0MPB7JSArray11set__length(self, new_len);
}
function _M0MPC15array5Array28unsafe__truncate__to__lengthGRP49LING7167111moon_2degui3src4core3KeyE(self, new_len) {
  _M0MPB7JSArray11set__length(self, new_len);
}
function _M0MPC15array5Array11unsafe__popGRP49LING7167111moon_2degui3src4math4RectE(self) {
  return _M0MPB7JSArray3pop(self);
}
function _M0MPC15array5Array3popGRP49LING7167111moon_2degui3src4math4RectE(self) {
  if (self.length === 0) {
    return undefined;
  } else {
    const v = _M0MPC15array5Array11unsafe__popGRP49LING7167111moon_2degui3src4math4RectE(self);
    return v;
  }
}
function _M0MPC15array5Array6removeGRP49LING7167111moon_2degui3src4core3KeyE(self, index) {
  if (index >= 0 && index < self.length) {
    const value = index >>> 0 < self.length ? self[index] : $oob();
    _M0MPB7JSArray6splice(self, index, 1);
    return value;
  } else {
    const _string_builder = _M0MPB13StringBuilder21StringBuilder_2einner(60);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, "index out of bounds: the len is from 0 to ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, self.length);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, " but the index is ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, index);
    return $panic();
  }
}
function _M0MPC15array5Array6removeGsE(self, index) {
  if (index >= 0 && index < self.length) {
    const value = index >>> 0 < self.length ? self[index] : $oob();
    _M0MPB7JSArray6splice(self, index, 1);
    return value;
  } else {
    const _string_builder = _M0MPB13StringBuilder21StringBuilder_2einner(60);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, "index out of bounds: the len is from 0 to ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, self.length);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, " but the index is ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, index);
    return $panic();
  }
}
function _M0MPC15array5Array4copyGsE(self) {
  return _M0MPB7JSArray4copy(self);
}
function _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(self, index) {
  const len = self.length;
  return index >= 0 && index < len ? self[index] : $panic();
}
function _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core3KeyE(self, index) {
  const len = self.length;
  return index >= 0 && index < len ? self[index] : $panic();
}
function _M0MPC15array5Array2atGiE(self, index) {
  const len = self.length;
  return index >= 0 && index < len ? self[index] : $panic();
}
function _M0MPC15array5Array2atGdE(self, index) {
  const len = self.length;
  return index >= 0 && index < len ? self[index] : $panic();
}
function _M0MPC15array5Array3setGRP49LING7167111moon_2degui3src4core9RichTokenE(self, index, value) {
  const len = self.length;
  if (index >= 0 && index < len) {
    self[index] = value;
    return;
  } else {
    $panic();
    return;
  }
}
function _M0MPC15array5Array5clearGRP49LING7167111moon_2degui3src4math4RectE(self) {
  _M0MPC15array5Array28unsafe__truncate__to__lengthGRP49LING7167111moon_2degui3src4math4RectE(self, 0);
}
function _M0MPC15array5Array5clearGRP49LING7167111moon_2degui3src4core3KeyE(self) {
  _M0MPC15array5Array28unsafe__truncate__to__lengthGRP49LING7167111moon_2degui3src4core3KeyE(self, 0);
}
function _M0MPC15array5Array8containsGRP49LING7167111moon_2degui3src4core2IdE(self, value) {
  const _bind = self.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const v = self[_];
      if (BigInt.asUintN(64, v.val) === BigInt.asUintN(64, value.val)) {
        return true;
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      return false;
    }
  }
}
function _M0MPC15array5Array8containsGRP49LING7167111moon_2degui3src4core3KeyE(self, value) {
  const _bind = self.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const v = self[_];
      if (_M0IP49LING7167111moon_2degui3src4core3KeyPB2Eq5equal(v, value)) {
        return true;
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      return false;
    }
  }
}
function _M0MPC15array5Array8containsGsE(self, value) {
  const _bind = self.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const v = self[_];
      if (v === value) {
        return true;
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      return false;
    }
  }
}
function _M0MPC17hashmap7HashMap5clearGsdE(self) {
  _M0MPC15array10FixedArray12fill_2einnerGORPC17hashmap5EntryGsdEE(self.entries, undefined, 0, undefined);
  self.size = 0;
}
function _M0FPC17hashmap12new__hashmapGRP49LING7167111moon_2degui3src4core2IddE(capacity) {
  const capacity$2 = _M0MPC13int3Int20next__power__of__two(capacity);
  const _bind = $make_array_len_and_init(capacity$2, undefined);
  const _bind$2 = capacity$2 - 1 | 0;
  return new _M0TPC17hashmap7HashMapGRP49LING7167111moon_2degui3src4core2IddE(_bind, capacity$2, _bind$2, 0);
}
function _M0FPC17hashmap12new__hashmapGRP49LING7167111moon_2degui3src4core2IdRP49LING7167111moon_2degui3src4math4Vec2E(capacity) {
  const capacity$2 = _M0MPC13int3Int20next__power__of__two(capacity);
  const _bind = $make_array_len_and_init(capacity$2, undefined);
  const _bind$2 = capacity$2 - 1 | 0;
  return new _M0TPC17hashmap7HashMapGRP49LING7167111moon_2degui3src4core2IdRP49LING7167111moon_2degui3src4math4Vec2E(_bind, capacity$2, _bind$2, 0);
}
function _M0FPC17hashmap12new__hashmapGRP49LING7167111moon_2degui3src4core2IdiE(capacity) {
  const capacity$2 = _M0MPC13int3Int20next__power__of__two(capacity);
  const _bind = $make_array_len_and_init(capacity$2, undefined);
  const _bind$2 = capacity$2 - 1 | 0;
  return new _M0TPC17hashmap7HashMapGRP49LING7167111moon_2degui3src4core2IdiE(_bind, capacity$2, _bind$2, 0);
}
function _M0FPC17hashmap12new__hashmapGRP49LING7167111moon_2degui3src4core2IdbE(capacity) {
  const capacity$2 = _M0MPC13int3Int20next__power__of__two(capacity);
  const _bind = $make_array_len_and_init(capacity$2, undefined);
  const _bind$2 = capacity$2 - 1 | 0;
  return new _M0TPC17hashmap7HashMapGRP49LING7167111moon_2degui3src4core2IdbE(_bind, capacity$2, _bind$2, 0);
}
function _M0FPC17hashmap12new__hashmapGsdE(capacity) {
  const capacity$2 = _M0MPC13int3Int20next__power__of__two(capacity);
  const _bind = $make_array_len_and_init(capacity$2, undefined);
  const _bind$2 = capacity$2 - 1 | 0;
  return new _M0TPC17hashmap7HashMapGsdE(_bind, capacity$2, _bind$2, 0);
}
function _M0MPC17hashmap7HashMap10push__awayGsdE(self, idx, entry) {
  let _tmp = entry.psl + 1 | 0;
  let _tmp$2 = idx + 1 & self.capacity_mask;
  let _tmp$3 = entry;
  while (true) {
    const psl = _tmp;
    const idx$2 = _tmp$2;
    const entry$2 = _tmp$3;
    const _bind = self.entries[idx$2];
    if (_bind === undefined) {
      entry$2.psl = psl;
      self.entries[idx$2] = entry$2;
      return;
    } else {
      const _Some = _bind;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        self.entries[idx$2] = entry$2;
        _tmp = _curr_entry.psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        _tmp$3 = _curr_entry;
        continue;
      } else {
        _tmp = psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function _M0MPC17hashmap7HashMap10push__awayGRP49LING7167111moon_2degui3src4core2IdiE(self, idx, entry) {
  let _tmp = entry.psl + 1 | 0;
  let _tmp$2 = idx + 1 & self.capacity_mask;
  let _tmp$3 = entry;
  while (true) {
    const psl = _tmp;
    const idx$2 = _tmp$2;
    const entry$2 = _tmp$3;
    const _bind = self.entries[idx$2];
    if (_bind === undefined) {
      entry$2.psl = psl;
      self.entries[idx$2] = entry$2;
      return;
    } else {
      const _Some = _bind;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        self.entries[idx$2] = entry$2;
        _tmp = _curr_entry.psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        _tmp$3 = _curr_entry;
        continue;
      } else {
        _tmp = psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function _M0MPC17hashmap7HashMap10push__awayGRP49LING7167111moon_2degui3src4core2IddE(self, idx, entry) {
  let _tmp = entry.psl + 1 | 0;
  let _tmp$2 = idx + 1 & self.capacity_mask;
  let _tmp$3 = entry;
  while (true) {
    const psl = _tmp;
    const idx$2 = _tmp$2;
    const entry$2 = _tmp$3;
    const _bind = self.entries[idx$2];
    if (_bind === undefined) {
      entry$2.psl = psl;
      self.entries[idx$2] = entry$2;
      return;
    } else {
      const _Some = _bind;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        self.entries[idx$2] = entry$2;
        _tmp = _curr_entry.psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        _tmp$3 = _curr_entry;
        continue;
      } else {
        _tmp = psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function _M0MPC17hashmap7HashMap10push__awayGRP49LING7167111moon_2degui3src4core2IdRP49LING7167111moon_2degui3src4math4Vec2E(self, idx, entry) {
  let _tmp = entry.psl + 1 | 0;
  let _tmp$2 = idx + 1 & self.capacity_mask;
  let _tmp$3 = entry;
  while (true) {
    const psl = _tmp;
    const idx$2 = _tmp$2;
    const entry$2 = _tmp$3;
    const _bind = self.entries[idx$2];
    if (_bind === undefined) {
      entry$2.psl = psl;
      self.entries[idx$2] = entry$2;
      return;
    } else {
      const _Some = _bind;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        self.entries[idx$2] = entry$2;
        _tmp = _curr_entry.psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        _tmp$3 = _curr_entry;
        continue;
      } else {
        _tmp = psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function _M0MPC17hashmap7HashMap10push__awayGRP49LING7167111moon_2degui3src4core2IdbE(self, idx, entry) {
  let _tmp = entry.psl + 1 | 0;
  let _tmp$2 = idx + 1 & self.capacity_mask;
  let _tmp$3 = entry;
  while (true) {
    const psl = _tmp;
    const idx$2 = _tmp$2;
    const entry$2 = _tmp$3;
    const _bind = self.entries[idx$2];
    if (_bind === undefined) {
      entry$2.psl = psl;
      self.entries[idx$2] = entry$2;
      return;
    } else {
      const _Some = _bind;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        self.entries[idx$2] = entry$2;
        _tmp = _curr_entry.psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        _tmp$3 = _curr_entry;
        continue;
      } else {
        _tmp = psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function _M0MPC17hashmap7HashMap20rehash__place__entryGsdE(self, entry) {
  const hash = entry.hash;
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      entry.psl = psl;
      self.entries[idx] = entry;
      return undefined;
    } else {
      const _Some = _bind;
      const _curr = _Some;
      if (psl > _curr.psl) {
        _M0MPC17hashmap7HashMap10push__awayGsdE(self, idx, _curr);
        entry.psl = psl;
        self.entries[idx] = entry;
        return undefined;
      } else {
        _tmp = psl + 1 | 0;
        _tmp$2 = idx + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function _M0MPC17hashmap7HashMap20rehash__place__entryGRP49LING7167111moon_2degui3src4core2IdiE(self, entry) {
  const hash = entry.hash;
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      entry.psl = psl;
      self.entries[idx] = entry;
      return undefined;
    } else {
      const _Some = _bind;
      const _curr = _Some;
      if (psl > _curr.psl) {
        _M0MPC17hashmap7HashMap10push__awayGRP49LING7167111moon_2degui3src4core2IdiE(self, idx, _curr);
        entry.psl = psl;
        self.entries[idx] = entry;
        return undefined;
      } else {
        _tmp = psl + 1 | 0;
        _tmp$2 = idx + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function _M0MPC17hashmap7HashMap20rehash__place__entryGRP49LING7167111moon_2degui3src4core2IddE(self, entry) {
  const hash = entry.hash;
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      entry.psl = psl;
      self.entries[idx] = entry;
      return undefined;
    } else {
      const _Some = _bind;
      const _curr = _Some;
      if (psl > _curr.psl) {
        _M0MPC17hashmap7HashMap10push__awayGRP49LING7167111moon_2degui3src4core2IddE(self, idx, _curr);
        entry.psl = psl;
        self.entries[idx] = entry;
        return undefined;
      } else {
        _tmp = psl + 1 | 0;
        _tmp$2 = idx + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function _M0MPC17hashmap7HashMap20rehash__place__entryGRP49LING7167111moon_2degui3src4core2IdRP49LING7167111moon_2degui3src4math4Vec2E(self, entry) {
  const hash = entry.hash;
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      entry.psl = psl;
      self.entries[idx] = entry;
      return undefined;
    } else {
      const _Some = _bind;
      const _curr = _Some;
      if (psl > _curr.psl) {
        _M0MPC17hashmap7HashMap10push__awayGRP49LING7167111moon_2degui3src4core2IdRP49LING7167111moon_2degui3src4math4Vec2E(self, idx, _curr);
        entry.psl = psl;
        self.entries[idx] = entry;
        return undefined;
      } else {
        _tmp = psl + 1 | 0;
        _tmp$2 = idx + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function _M0MPC17hashmap7HashMap20rehash__place__entryGRP49LING7167111moon_2degui3src4core2IdbE(self, entry) {
  const hash = entry.hash;
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      entry.psl = psl;
      self.entries[idx] = entry;
      return undefined;
    } else {
      const _Some = _bind;
      const _curr = _Some;
      if (psl > _curr.psl) {
        _M0MPC17hashmap7HashMap10push__awayGRP49LING7167111moon_2degui3src4core2IdbE(self, idx, _curr);
        entry.psl = psl;
        self.entries[idx] = entry;
        return undefined;
      } else {
        _tmp = psl + 1 | 0;
        _tmp$2 = idx + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function _M0MPC17hashmap7HashMap4growGsdE(self) {
  const old_entries = self.entries;
  const new_capacity = self.capacity << 1;
  self.entries = $make_array_len_and_init(new_capacity, undefined);
  self.capacity = new_capacity;
  self.capacity_mask = new_capacity - 1 | 0;
  const _bind = old_entries.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const entry = old_entries[_];
      if (entry === undefined) {
      } else {
        const _Some = entry;
        const _entry = _Some;
        _M0MPC17hashmap7HashMap20rehash__place__entryGsdE(self, _entry);
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0MPC17hashmap7HashMap4growGRP49LING7167111moon_2degui3src4core2IdiE(self) {
  const old_entries = self.entries;
  const new_capacity = self.capacity << 1;
  self.entries = $make_array_len_and_init(new_capacity, undefined);
  self.capacity = new_capacity;
  self.capacity_mask = new_capacity - 1 | 0;
  const _bind = old_entries.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const entry = old_entries[_];
      if (entry === undefined) {
      } else {
        const _Some = entry;
        const _entry = _Some;
        _M0MPC17hashmap7HashMap20rehash__place__entryGRP49LING7167111moon_2degui3src4core2IdiE(self, _entry);
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0MPC17hashmap7HashMap4growGRP49LING7167111moon_2degui3src4core2IddE(self) {
  const old_entries = self.entries;
  const new_capacity = self.capacity << 1;
  self.entries = $make_array_len_and_init(new_capacity, undefined);
  self.capacity = new_capacity;
  self.capacity_mask = new_capacity - 1 | 0;
  const _bind = old_entries.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const entry = old_entries[_];
      if (entry === undefined) {
      } else {
        const _Some = entry;
        const _entry = _Some;
        _M0MPC17hashmap7HashMap20rehash__place__entryGRP49LING7167111moon_2degui3src4core2IddE(self, _entry);
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0MPC17hashmap7HashMap4growGRP49LING7167111moon_2degui3src4core2IdRP49LING7167111moon_2degui3src4math4Vec2E(self) {
  const old_entries = self.entries;
  const new_capacity = self.capacity << 1;
  self.entries = $make_array_len_and_init(new_capacity, undefined);
  self.capacity = new_capacity;
  self.capacity_mask = new_capacity - 1 | 0;
  const _bind = old_entries.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const entry = old_entries[_];
      if (entry === undefined) {
      } else {
        const _Some = entry;
        const _entry = _Some;
        _M0MPC17hashmap7HashMap20rehash__place__entryGRP49LING7167111moon_2degui3src4core2IdRP49LING7167111moon_2degui3src4math4Vec2E(self, _entry);
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0MPC17hashmap7HashMap4growGRP49LING7167111moon_2degui3src4core2IdbE(self) {
  const old_entries = self.entries;
  const new_capacity = self.capacity << 1;
  self.entries = $make_array_len_and_init(new_capacity, undefined);
  self.capacity = new_capacity;
  self.capacity_mask = new_capacity - 1 | 0;
  const _bind = old_entries.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const entry = old_entries[_];
      if (entry === undefined) {
      } else {
        const _Some = entry;
        const _entry = _Some;
        _M0MPC17hashmap7HashMap20rehash__place__entryGRP49LING7167111moon_2degui3src4core2IdbE(self, _entry);
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0MPC17hashmap7HashMap15set__with__hashGsdE(self, key, value, hash) {
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      if (self.size >= (self.capacity / 2 | 0)) {
        _M0MPC17hashmap7HashMap4growGsdE(self);
        _tmp = 0;
        _tmp$2 = hash & self.capacity_mask;
        continue;
      }
      const entry = new _M0TPC17hashmap5EntryGsdE(psl, hash, key, value);
      self.entries[idx] = entry;
      self.size = self.size + 1 | 0;
      return undefined;
    } else {
      const _Some = _bind;
      const _curr_entry = _Some;
      if (_curr_entry.hash === hash && _curr_entry.key === key) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        if (self.size >= (self.capacity / 2 | 0)) {
          _M0MPC17hashmap7HashMap4growGsdE(self);
          _tmp = 0;
          _tmp$2 = hash & self.capacity_mask;
          continue;
        }
        _M0MPC17hashmap7HashMap10push__awayGsdE(self, idx, _curr_entry);
        const entry = new _M0TPC17hashmap5EntryGsdE(psl, hash, key, value);
        self.entries[idx] = entry;
        self.size = self.size + 1 | 0;
        return undefined;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MPC17hashmap7HashMap15set__with__hashGRP49LING7167111moon_2degui3src4core2IdiE(self, key, value, hash) {
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      if (self.size >= (self.capacity / 2 | 0)) {
        _M0MPC17hashmap7HashMap4growGRP49LING7167111moon_2degui3src4core2IdiE(self);
        _tmp = 0;
        _tmp$2 = hash & self.capacity_mask;
        continue;
      }
      const entry = new _M0TPC17hashmap5EntryGRP49LING7167111moon_2degui3src4core2IdiE(psl, hash, key, value);
      self.entries[idx] = entry;
      self.size = self.size + 1 | 0;
      return undefined;
    } else {
      const _Some = _bind;
      const _curr_entry = _Some;
      let _tmp$3;
      if (_curr_entry.hash === hash) {
        const _p = _curr_entry.key;
        _tmp$3 = BigInt.asUintN(64, _p.val) === BigInt.asUintN(64, key.val);
      } else {
        _tmp$3 = false;
      }
      if (_tmp$3) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        if (self.size >= (self.capacity / 2 | 0)) {
          _M0MPC17hashmap7HashMap4growGRP49LING7167111moon_2degui3src4core2IdiE(self);
          _tmp = 0;
          _tmp$2 = hash & self.capacity_mask;
          continue;
        }
        _M0MPC17hashmap7HashMap10push__awayGRP49LING7167111moon_2degui3src4core2IdiE(self, idx, _curr_entry);
        const entry = new _M0TPC17hashmap5EntryGRP49LING7167111moon_2degui3src4core2IdiE(psl, hash, key, value);
        self.entries[idx] = entry;
        self.size = self.size + 1 | 0;
        return undefined;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MPC17hashmap7HashMap15set__with__hashGRP49LING7167111moon_2degui3src4core2IddE(self, key, value, hash) {
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      if (self.size >= (self.capacity / 2 | 0)) {
        _M0MPC17hashmap7HashMap4growGRP49LING7167111moon_2degui3src4core2IddE(self);
        _tmp = 0;
        _tmp$2 = hash & self.capacity_mask;
        continue;
      }
      const entry = new _M0TPC17hashmap5EntryGRP49LING7167111moon_2degui3src4core2IddE(psl, hash, key, value);
      self.entries[idx] = entry;
      self.size = self.size + 1 | 0;
      return undefined;
    } else {
      const _Some = _bind;
      const _curr_entry = _Some;
      let _tmp$3;
      if (_curr_entry.hash === hash) {
        const _p = _curr_entry.key;
        _tmp$3 = BigInt.asUintN(64, _p.val) === BigInt.asUintN(64, key.val);
      } else {
        _tmp$3 = false;
      }
      if (_tmp$3) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        if (self.size >= (self.capacity / 2 | 0)) {
          _M0MPC17hashmap7HashMap4growGRP49LING7167111moon_2degui3src4core2IddE(self);
          _tmp = 0;
          _tmp$2 = hash & self.capacity_mask;
          continue;
        }
        _M0MPC17hashmap7HashMap10push__awayGRP49LING7167111moon_2degui3src4core2IddE(self, idx, _curr_entry);
        const entry = new _M0TPC17hashmap5EntryGRP49LING7167111moon_2degui3src4core2IddE(psl, hash, key, value);
        self.entries[idx] = entry;
        self.size = self.size + 1 | 0;
        return undefined;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MPC17hashmap7HashMap15set__with__hashGRP49LING7167111moon_2degui3src4core2IdRP49LING7167111moon_2degui3src4math4Vec2E(self, key, value, hash) {
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      if (self.size >= (self.capacity / 2 | 0)) {
        _M0MPC17hashmap7HashMap4growGRP49LING7167111moon_2degui3src4core2IdRP49LING7167111moon_2degui3src4math4Vec2E(self);
        _tmp = 0;
        _tmp$2 = hash & self.capacity_mask;
        continue;
      }
      const entry = new _M0TPC17hashmap5EntryGRP49LING7167111moon_2degui3src4core2IdRP49LING7167111moon_2degui3src4math4Vec2E(psl, hash, key, value);
      self.entries[idx] = entry;
      self.size = self.size + 1 | 0;
      return undefined;
    } else {
      const _Some = _bind;
      const _curr_entry = _Some;
      let _tmp$3;
      if (_curr_entry.hash === hash) {
        const _p = _curr_entry.key;
        _tmp$3 = BigInt.asUintN(64, _p.val) === BigInt.asUintN(64, key.val);
      } else {
        _tmp$3 = false;
      }
      if (_tmp$3) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        if (self.size >= (self.capacity / 2 | 0)) {
          _M0MPC17hashmap7HashMap4growGRP49LING7167111moon_2degui3src4core2IdRP49LING7167111moon_2degui3src4math4Vec2E(self);
          _tmp = 0;
          _tmp$2 = hash & self.capacity_mask;
          continue;
        }
        _M0MPC17hashmap7HashMap10push__awayGRP49LING7167111moon_2degui3src4core2IdRP49LING7167111moon_2degui3src4math4Vec2E(self, idx, _curr_entry);
        const entry = new _M0TPC17hashmap5EntryGRP49LING7167111moon_2degui3src4core2IdRP49LING7167111moon_2degui3src4math4Vec2E(psl, hash, key, value);
        self.entries[idx] = entry;
        self.size = self.size + 1 | 0;
        return undefined;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MPC17hashmap7HashMap15set__with__hashGRP49LING7167111moon_2degui3src4core2IdbE(self, key, value, hash) {
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      if (self.size >= (self.capacity / 2 | 0)) {
        _M0MPC17hashmap7HashMap4growGRP49LING7167111moon_2degui3src4core2IdbE(self);
        _tmp = 0;
        _tmp$2 = hash & self.capacity_mask;
        continue;
      }
      const entry = new _M0TPC17hashmap5EntryGRP49LING7167111moon_2degui3src4core2IdbE(psl, hash, key, value);
      self.entries[idx] = entry;
      self.size = self.size + 1 | 0;
      return undefined;
    } else {
      const _Some = _bind;
      const _curr_entry = _Some;
      let _tmp$3;
      if (_curr_entry.hash === hash) {
        const _p = _curr_entry.key;
        _tmp$3 = BigInt.asUintN(64, _p.val) === BigInt.asUintN(64, key.val);
      } else {
        _tmp$3 = false;
      }
      if (_tmp$3) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        if (self.size >= (self.capacity / 2 | 0)) {
          _M0MPC17hashmap7HashMap4growGRP49LING7167111moon_2degui3src4core2IdbE(self);
          _tmp = 0;
          _tmp$2 = hash & self.capacity_mask;
          continue;
        }
        _M0MPC17hashmap7HashMap10push__awayGRP49LING7167111moon_2degui3src4core2IdbE(self, idx, _curr_entry);
        const entry = new _M0TPC17hashmap5EntryGRP49LING7167111moon_2degui3src4core2IdbE(psl, hash, key, value);
        self.entries[idx] = entry;
        self.size = self.size + 1 | 0;
        return undefined;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MPC17hashmap7HashMap3setGsdE(self, key, value) {
  _M0MPC17hashmap7HashMap15set__with__hashGsdE(self, key, value, _M0IPC16string6StringPB4Hash4hash(key));
}
function _M0MPC17hashmap7HashMap3setGRP49LING7167111moon_2degui3src4core2IdiE(self, key, value) {
  _M0MPC17hashmap7HashMap15set__with__hashGRP49LING7167111moon_2degui3src4core2IdiE(self, key, value, _M0IP016_24default__implPB4Hash4hashGRP49LING7167111moon_2degui3src4core2IdE(key));
}
function _M0MPC17hashmap7HashMap3setGRP49LING7167111moon_2degui3src4core2IddE(self, key, value) {
  _M0MPC17hashmap7HashMap15set__with__hashGRP49LING7167111moon_2degui3src4core2IddE(self, key, value, _M0IP016_24default__implPB4Hash4hashGRP49LING7167111moon_2degui3src4core2IdE(key));
}
function _M0MPC17hashmap7HashMap3setGRP49LING7167111moon_2degui3src4core2IdRP49LING7167111moon_2degui3src4math4Vec2E(self, key, value) {
  _M0MPC17hashmap7HashMap15set__with__hashGRP49LING7167111moon_2degui3src4core2IdRP49LING7167111moon_2degui3src4math4Vec2E(self, key, value, _M0IP016_24default__implPB4Hash4hashGRP49LING7167111moon_2degui3src4core2IdE(key));
}
function _M0MPC17hashmap7HashMap3setGRP49LING7167111moon_2degui3src4core2IdbE(self, key, value) {
  _M0MPC17hashmap7HashMap15set__with__hashGRP49LING7167111moon_2degui3src4core2IdbE(self, key, value, _M0IP016_24default__implPB4Hash4hashGRP49LING7167111moon_2degui3src4core2IdE(key));
}
function _M0MPC17hashmap7HashMap11shift__backGRP49LING7167111moon_2degui3src4core2IdiE(self, idx) {
  let _tmp = idx;
  while (true) {
    const cur = _tmp;
    const next = cur + 1 & self.capacity_mask;
    _L: {
      const _bind = self.entries[next];
      if (_bind === undefined) {
        break _L;
      } else {
        const _Some = _bind;
        const _x = _Some;
        const _x$2 = _x.psl;
        if (_x$2 === 0) {
          break _L;
        } else {
          _x.psl = _x.psl - 1 | 0;
          self.entries[cur] = _x;
          _tmp = next;
          continue;
        }
      }
    }
    self.entries[cur] = undefined;
    return;
  }
}
function _M0MPC17hashmap7HashMap11shift__backGRP49LING7167111moon_2degui3src4core2IddE(self, idx) {
  let _tmp = idx;
  while (true) {
    const cur = _tmp;
    const next = cur + 1 & self.capacity_mask;
    _L: {
      const _bind = self.entries[next];
      if (_bind === undefined) {
        break _L;
      } else {
        const _Some = _bind;
        const _x = _Some;
        const _x$2 = _x.psl;
        if (_x$2 === 0) {
          break _L;
        } else {
          _x.psl = _x.psl - 1 | 0;
          self.entries[cur] = _x;
          _tmp = next;
          continue;
        }
      }
    }
    self.entries[cur] = undefined;
    return;
  }
}
function _M0MPC17hashmap7HashMap11shift__backGRP49LING7167111moon_2degui3src4core2IdbE(self, idx) {
  let _tmp = idx;
  while (true) {
    const cur = _tmp;
    const next = cur + 1 & self.capacity_mask;
    _L: {
      const _bind = self.entries[next];
      if (_bind === undefined) {
        break _L;
      } else {
        const _Some = _bind;
        const _x = _Some;
        const _x$2 = _x.psl;
        if (_x$2 === 0) {
          break _L;
        } else {
          _x.psl = _x.psl - 1 | 0;
          self.entries[cur] = _x;
          _tmp = next;
          continue;
        }
      }
    }
    self.entries[cur] = undefined;
    return;
  }
}
function _M0MPC17hashmap7HashMap11shift__backGRP49LING7167111moon_2degui3src4core2IdRP49LING7167111moon_2degui3src4math4Vec2E(self, idx) {
  let _tmp = idx;
  while (true) {
    const cur = _tmp;
    const next = cur + 1 & self.capacity_mask;
    _L: {
      const _bind = self.entries[next];
      if (_bind === undefined) {
        break _L;
      } else {
        const _Some = _bind;
        const _x = _Some;
        const _x$2 = _x.psl;
        if (_x$2 === 0) {
          break _L;
        } else {
          _x.psl = _x.psl - 1 | 0;
          self.entries[cur] = _x;
          _tmp = next;
          continue;
        }
      }
    }
    self.entries[cur] = undefined;
    return;
  }
}
function _M0FPC17hashmap21capacity__for__length(length) {
  return _M0MPC13int3Int20next__power__of__two(Math.imul(length, 2) | 0);
}
function _M0MPC17hashmap7HashMap7HashMapGRP49LING7167111moon_2degui3src4core2IddE(arr, capacity) {
  const length = arr.end - arr.start | 0;
  let capacity$2;
  if (capacity === undefined) {
    capacity$2 = length === 0 ? 8 : _M0FPC17hashmap21capacity__for__length(length);
  } else {
    const _Some = capacity;
    const _capacity = _Some;
    const _p = _M0FPC17hashmap21capacity__for__length(length);
    capacity$2 = _capacity > _p ? _capacity : _p;
  }
  const m = _M0FPC17hashmap12new__hashmapGRP49LING7167111moon_2degui3src4core2IddE(capacity$2);
  const _p = arr.end - arr.start | 0;
  let _tmp = 0;
  while (true) {
    const _p$2 = _tmp;
    if (_p$2 < _p) {
      const _p$3 = arr.buf[arr.start + _p$2 | 0];
      _M0MPC17hashmap7HashMap3setGRP49LING7167111moon_2degui3src4core2IddE(m, _p$3._0, _p$3._1);
      _tmp = _p$2 + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return m;
}
function _M0MPC17hashmap7HashMap7HashMapGRP49LING7167111moon_2degui3src4core2IdRP49LING7167111moon_2degui3src4math4Vec2E(arr, capacity) {
  const length = arr.end - arr.start | 0;
  let capacity$2;
  if (capacity === undefined) {
    capacity$2 = length === 0 ? 8 : _M0FPC17hashmap21capacity__for__length(length);
  } else {
    const _Some = capacity;
    const _capacity = _Some;
    const _p = _M0FPC17hashmap21capacity__for__length(length);
    capacity$2 = _capacity > _p ? _capacity : _p;
  }
  const m = _M0FPC17hashmap12new__hashmapGRP49LING7167111moon_2degui3src4core2IdRP49LING7167111moon_2degui3src4math4Vec2E(capacity$2);
  const _p = arr.end - arr.start | 0;
  let _tmp = 0;
  while (true) {
    const _p$2 = _tmp;
    if (_p$2 < _p) {
      const _p$3 = arr.buf[arr.start + _p$2 | 0];
      _M0MPC17hashmap7HashMap3setGRP49LING7167111moon_2degui3src4core2IdRP49LING7167111moon_2degui3src4math4Vec2E(m, _p$3._0, _p$3._1);
      _tmp = _p$2 + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return m;
}
function _M0MPC17hashmap7HashMap7HashMapGRP49LING7167111moon_2degui3src4core2IdiE(arr, capacity) {
  const length = arr.end - arr.start | 0;
  let capacity$2;
  if (capacity === undefined) {
    capacity$2 = length === 0 ? 8 : _M0FPC17hashmap21capacity__for__length(length);
  } else {
    const _Some = capacity;
    const _capacity = _Some;
    const _p = _M0FPC17hashmap21capacity__for__length(length);
    capacity$2 = _capacity > _p ? _capacity : _p;
  }
  const m = _M0FPC17hashmap12new__hashmapGRP49LING7167111moon_2degui3src4core2IdiE(capacity$2);
  const _p = arr.end - arr.start | 0;
  let _tmp = 0;
  while (true) {
    const _p$2 = _tmp;
    if (_p$2 < _p) {
      const _p$3 = arr.buf[arr.start + _p$2 | 0];
      _M0MPC17hashmap7HashMap3setGRP49LING7167111moon_2degui3src4core2IdiE(m, _p$3._0, _p$3._1);
      _tmp = _p$2 + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return m;
}
function _M0MPC17hashmap7HashMap7HashMapGRP49LING7167111moon_2degui3src4core2IdbE(arr, capacity) {
  const length = arr.end - arr.start | 0;
  let capacity$2;
  if (capacity === undefined) {
    capacity$2 = length === 0 ? 8 : _M0FPC17hashmap21capacity__for__length(length);
  } else {
    const _Some = capacity;
    const _capacity = _Some;
    const _p = _M0FPC17hashmap21capacity__for__length(length);
    capacity$2 = _capacity > _p ? _capacity : _p;
  }
  const m = _M0FPC17hashmap12new__hashmapGRP49LING7167111moon_2degui3src4core2IdbE(capacity$2);
  const _p = arr.end - arr.start | 0;
  let _tmp = 0;
  while (true) {
    const _p$2 = _tmp;
    if (_p$2 < _p) {
      const _p$3 = arr.buf[arr.start + _p$2 | 0];
      _M0MPC17hashmap7HashMap3setGRP49LING7167111moon_2degui3src4core2IdbE(m, _p$3._0, _p$3._1);
      _tmp = _p$2 + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return m;
}
function _M0MPC17hashmap7HashMap7HashMapGsdE(arr, capacity) {
  const length = arr.end - arr.start | 0;
  let capacity$2;
  if (capacity === undefined) {
    capacity$2 = length === 0 ? 8 : _M0FPC17hashmap21capacity__for__length(length);
  } else {
    const _Some = capacity;
    const _capacity = _Some;
    const _p = _M0FPC17hashmap21capacity__for__length(length);
    capacity$2 = _capacity > _p ? _capacity : _p;
  }
  const m = _M0FPC17hashmap12new__hashmapGsdE(capacity$2);
  const _p = arr.end - arr.start | 0;
  let _tmp = 0;
  while (true) {
    const _p$2 = _tmp;
    if (_p$2 < _p) {
      const _p$3 = arr.buf[arr.start + _p$2 | 0];
      _M0MPC17hashmap7HashMap3setGsdE(m, _p$3._0, _p$3._1);
      _tmp = _p$2 + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return m;
}
function _M0MPC17hashmap7HashMap3getGsdE(self, key) {
  const hash = _M0IPC16string6StringPB4Hash4hash(key);
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      return _M0DTPC16option6OptionGdE4None__;
    } else {
      const _Some = _bind;
      const _entry = _Some;
      if (_entry.hash === hash && _entry.key === key) {
        return new _M0DTPC16option6OptionGdE4Some(_entry.value);
      }
      if (i > _entry.psl) {
        return _M0DTPC16option6OptionGdE4None__;
      }
      _tmp = i + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MPC17hashmap7HashMap3getGRP49LING7167111moon_2degui3src4core2IdiE(self, key) {
  const hash = _M0IP016_24default__implPB4Hash4hashGRP49LING7167111moon_2degui3src4core2IdE(key);
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      return undefined;
    } else {
      const _Some = _bind;
      const _entry = _Some;
      let _tmp$3;
      if (_entry.hash === hash) {
        const _p = _entry.key;
        _tmp$3 = BigInt.asUintN(64, _p.val) === BigInt.asUintN(64, key.val);
      } else {
        _tmp$3 = false;
      }
      if (_tmp$3) {
        return _entry.value;
      }
      if (i > _entry.psl) {
        return undefined;
      }
      _tmp = i + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MPC17hashmap7HashMap3getGRP49LING7167111moon_2degui3src4core2IddE(self, key) {
  const hash = _M0IP016_24default__implPB4Hash4hashGRP49LING7167111moon_2degui3src4core2IdE(key);
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      return _M0DTPC16option6OptionGdE4None__;
    } else {
      const _Some = _bind;
      const _entry = _Some;
      let _tmp$3;
      if (_entry.hash === hash) {
        const _p = _entry.key;
        _tmp$3 = BigInt.asUintN(64, _p.val) === BigInt.asUintN(64, key.val);
      } else {
        _tmp$3 = false;
      }
      if (_tmp$3) {
        return new _M0DTPC16option6OptionGdE4Some(_entry.value);
      }
      if (i > _entry.psl) {
        return _M0DTPC16option6OptionGdE4None__;
      }
      _tmp = i + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MPC17hashmap7HashMap3getGRP49LING7167111moon_2degui3src4core2IdRP49LING7167111moon_2degui3src4math4Vec2E(self, key) {
  const hash = _M0IP016_24default__implPB4Hash4hashGRP49LING7167111moon_2degui3src4core2IdE(key);
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      return undefined;
    } else {
      const _Some = _bind;
      const _entry = _Some;
      let _tmp$3;
      if (_entry.hash === hash) {
        const _p = _entry.key;
        _tmp$3 = BigInt.asUintN(64, _p.val) === BigInt.asUintN(64, key.val);
      } else {
        _tmp$3 = false;
      }
      if (_tmp$3) {
        return _entry.value;
      }
      if (i > _entry.psl) {
        return undefined;
      }
      _tmp = i + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MPC17hashmap7HashMap3getGRP49LING7167111moon_2degui3src4core2IdbE(self, key) {
  const hash = _M0IP016_24default__implPB4Hash4hashGRP49LING7167111moon_2degui3src4core2IdE(key);
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      return -1;
    } else {
      const _Some = _bind;
      const _entry = _Some;
      let _tmp$3;
      if (_entry.hash === hash) {
        const _p = _entry.key;
        _tmp$3 = BigInt.asUintN(64, _p.val) === BigInt.asUintN(64, key.val);
      } else {
        _tmp$3 = false;
      }
      if (_tmp$3) {
        return _entry.value;
      }
      if (i > _entry.psl) {
        return -1;
      }
      _tmp = i + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MPC17hashmap7HashMap18remove__with__hashGRP49LING7167111moon_2degui3src4core2IdiE(self, key, hash) {
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      return;
    } else {
      const _Some = _bind;
      const _entry = _Some;
      let _tmp$3;
      if (_entry.hash === hash) {
        const _p = _entry.key;
        _tmp$3 = BigInt.asUintN(64, _p.val) === BigInt.asUintN(64, key.val);
      } else {
        _tmp$3 = false;
      }
      if (_tmp$3) {
        _M0MPC17hashmap7HashMap11shift__backGRP49LING7167111moon_2degui3src4core2IdiE(self, idx);
        self.size = self.size - 1 | 0;
        return;
      }
      if (i > _entry.psl) {
        return;
      }
      _tmp = i + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MPC17hashmap7HashMap18remove__with__hashGRP49LING7167111moon_2degui3src4core2IddE(self, key, hash) {
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      return;
    } else {
      const _Some = _bind;
      const _entry = _Some;
      let _tmp$3;
      if (_entry.hash === hash) {
        const _p = _entry.key;
        _tmp$3 = BigInt.asUintN(64, _p.val) === BigInt.asUintN(64, key.val);
      } else {
        _tmp$3 = false;
      }
      if (_tmp$3) {
        _M0MPC17hashmap7HashMap11shift__backGRP49LING7167111moon_2degui3src4core2IddE(self, idx);
        self.size = self.size - 1 | 0;
        return;
      }
      if (i > _entry.psl) {
        return;
      }
      _tmp = i + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MPC17hashmap7HashMap18remove__with__hashGRP49LING7167111moon_2degui3src4core2IdbE(self, key, hash) {
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      return;
    } else {
      const _Some = _bind;
      const _entry = _Some;
      let _tmp$3;
      if (_entry.hash === hash) {
        const _p = _entry.key;
        _tmp$3 = BigInt.asUintN(64, _p.val) === BigInt.asUintN(64, key.val);
      } else {
        _tmp$3 = false;
      }
      if (_tmp$3) {
        _M0MPC17hashmap7HashMap11shift__backGRP49LING7167111moon_2degui3src4core2IdbE(self, idx);
        self.size = self.size - 1 | 0;
        return;
      }
      if (i > _entry.psl) {
        return;
      }
      _tmp = i + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MPC17hashmap7HashMap18remove__with__hashGRP49LING7167111moon_2degui3src4core2IdRP49LING7167111moon_2degui3src4math4Vec2E(self, key, hash) {
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      return;
    } else {
      const _Some = _bind;
      const _entry = _Some;
      let _tmp$3;
      if (_entry.hash === hash) {
        const _p = _entry.key;
        _tmp$3 = BigInt.asUintN(64, _p.val) === BigInt.asUintN(64, key.val);
      } else {
        _tmp$3 = false;
      }
      if (_tmp$3) {
        _M0MPC17hashmap7HashMap11shift__backGRP49LING7167111moon_2degui3src4core2IdRP49LING7167111moon_2degui3src4math4Vec2E(self, idx);
        self.size = self.size - 1 | 0;
        return;
      }
      if (i > _entry.psl) {
        return;
      }
      _tmp = i + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MPC17hashmap7HashMap6removeGRP49LING7167111moon_2degui3src4core2IdiE(self, key) {
  _M0MPC17hashmap7HashMap18remove__with__hashGRP49LING7167111moon_2degui3src4core2IdiE(self, key, _M0IP016_24default__implPB4Hash4hashGRP49LING7167111moon_2degui3src4core2IdE(key));
}
function _M0MPC17hashmap7HashMap6removeGRP49LING7167111moon_2degui3src4core2IddE(self, key) {
  _M0MPC17hashmap7HashMap18remove__with__hashGRP49LING7167111moon_2degui3src4core2IddE(self, key, _M0IP016_24default__implPB4Hash4hashGRP49LING7167111moon_2degui3src4core2IdE(key));
}
function _M0MPC17hashmap7HashMap6removeGRP49LING7167111moon_2degui3src4core2IdbE(self, key) {
  _M0MPC17hashmap7HashMap18remove__with__hashGRP49LING7167111moon_2degui3src4core2IdbE(self, key, _M0IP016_24default__implPB4Hash4hashGRP49LING7167111moon_2degui3src4core2IdE(key));
}
function _M0MPC17hashmap7HashMap6removeGRP49LING7167111moon_2degui3src4core2IdRP49LING7167111moon_2degui3src4math4Vec2E(self, key) {
  _M0MPC17hashmap7HashMap18remove__with__hashGRP49LING7167111moon_2degui3src4core2IdRP49LING7167111moon_2degui3src4math4Vec2E(self, key, _M0IP016_24default__implPB4Hash4hashGRP49LING7167111moon_2degui3src4core2IdE(key));
}
function _M0MP49LING7167111moon_2degui3src5color5Color3rgb(r, g, b) {
  return new _M0TP49LING7167111moon_2degui3src5color5Color(r, g, b, 255);
}
function _M0MP49LING7167111moon_2degui3src5color5Color4rgba(r, g, b, a) {
  return new _M0TP49LING7167111moon_2degui3src5color5Color(r, g, b, a);
}
function _M0MP49LING7167111moon_2degui3src5color5Color3hex(code) {
  const r = code >> 16 & 255;
  const g = code >> 8 & 255;
  const b = code & 255;
  return new _M0TP49LING7167111moon_2degui3src5color5Color(r, g, b, 255);
}
function _M0MP49LING7167111moon_2degui3src5color5Color11with__alpha(self, a) {
  return new _M0TP49LING7167111moon_2degui3src5color5Color(self.r, self.g, self.b, a);
}
function _M0MP49LING7167111moon_2degui3src5color5Color10bg__window() {
  return _M0MP49LING7167111moon_2degui3src5color5Color3hex(16777215);
}
function _M0MP49LING7167111moon_2degui3src5color5Color11bg__surface() {
  return _M0MP49LING7167111moon_2degui3src5color5Color3hex(15857145);
}
function _M0MP49LING7167111moon_2degui3src5color5Color10bg__subtle() {
  return _M0MP49LING7167111moon_2degui3src5color5Color3hex(16317180);
}
function _M0MP49LING7167111moon_2degui3src5color5Color9bg__hover() {
  return _M0MP49LING7167111moon_2degui3src5color5Color3hex(16317180);
}
function _M0MP49LING7167111moon_2degui3src5color5Color10bg__active() {
  return _M0MP49LING7167111moon_2degui3src5color5Color3hex(14870768);
}
function _M0MP49LING7167111moon_2degui3src5color5Color11bg__inverse() {
  return _M0MP49LING7167111moon_2degui3src5color5Color3hex(1710883);
}
function _M0MP49LING7167111moon_2degui3src5color5Color13border__muted() {
  return _M0MP49LING7167111moon_2degui3src5color5Color3hex(14870768);
}
function _M0MP49LING7167111moon_2degui3src5color5Color15border__default() {
  return _M0MP49LING7167111moon_2degui3src5color5Color3hex(13358561);
}
function _M0MP49LING7167111moon_2degui3src5color5Color14border__strong() {
  return _M0MP49LING7167111moon_2degui3src5color5Color3hex(9741240);
}
function _M0MP49LING7167111moon_2degui3src5color5Color13border__focus() {
  return _M0MP49LING7167111moon_2degui3src5color5Color3hex(2450411);
}
function _M0MP49LING7167111moon_2degui3src5color5Color13text__primary() {
  return _M0MP49LING7167111moon_2degui3src5color5Color3hex(988970);
}
function _M0MP49LING7167111moon_2degui3src5color5Color12text__strong() {
  return _M0MP49LING7167111moon_2degui3src5color5Color3hex(1976635);
}
function _M0MP49LING7167111moon_2degui3src5color5Color10text__body() {
  return _M0MP49LING7167111moon_2degui3src5color5Color3hex(3359061);
}
function _M0MP49LING7167111moon_2degui3src5color5Color15text__secondary() {
  return _M0MP49LING7167111moon_2degui3src5color5Color3hex(4674921);
}
function _M0MP49LING7167111moon_2degui3src5color5Color11text__muted() {
  return _M0MP49LING7167111moon_2degui3src5color5Color3hex(6583435);
}
function _M0MP49LING7167111moon_2degui3src5color5Color14text__disabled() {
  return _M0MP49LING7167111moon_2degui3src5color5Color3hex(9741240);
}
function _M0MP49LING7167111moon_2degui3src5color5Color13text__inverse() {
  return _M0MP49LING7167111moon_2degui3src5color5Color3hex(16777215);
}
function _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary() {
  return _M0MP49LING7167111moon_2degui3src5color5Color3hex(2450411);
}
function _M0MP49LING7167111moon_2degui3src5color5Color13accent__hover() {
  return _M0MP49LING7167111moon_2degui3src5color5Color3hex(3900150);
}
function _M0MP49LING7167111moon_2degui3src5color5Color15accent__pressed() {
  return _M0MP49LING7167111moon_2degui3src5color5Color3hex(1920728);
}
function _M0MP49LING7167111moon_2degui3src5color5Color12accent__deep() {
  return _M0MP49LING7167111moon_2degui3src5color5Color3hex(1981066);
}
function _M0MP49LING7167111moon_2degui3src5color5Color12accent__soft() {
  return _M0MP49LING7167111moon_2degui3src5color5Color4rgba(37, 99, 235, 45);
}
function _M0MP49LING7167111moon_2degui3src5color5Color17accent__highlight() {
  return _M0MP49LING7167111moon_2degui3src5color5Color4rgba(255, 255, 255, 60);
}
function _M0MP49LING7167111moon_2degui3src5color5Color6shadow() {
  return _M0MP49LING7167111moon_2degui3src5color5Color4rgba(15, 23, 42, 18);
}
function _M0MP49LING7167111moon_2degui3src5color5Color7success() {
  return _M0MP49LING7167111moon_2degui3src5color5Color3hex(2278750);
}
function _M0MP49LING7167111moon_2degui3src5color5Color7warning() {
  return _M0MP49LING7167111moon_2degui3src5color5Color3hex(16096779);
}
function _M0MP49LING7167111moon_2degui3src5color5Color6danger() {
  return _M0MP49LING7167111moon_2degui3src5color5Color3hex(15680580);
}
function _M0MP49LING7167111moon_2degui3src5color5Color13danger__hover() {
  return _M0MP49LING7167111moon_2degui3src5color5Color4rgba(239, 68, 68, 220);
}
function _M0MP49LING7167111moon_2degui3src5color5Color9bg__scrim() {
  return _M0MP49LING7167111moon_2degui3src5color5Color4rgba(15, 23, 42, 115);
}
function _M0MP49LING7167111moon_2degui3src5color5Color15shadow__ambient() {
  return _M0MP49LING7167111moon_2degui3src5color5Color4rgba(15, 23, 42, 30);
}
function _M0MP49LING7167111moon_2degui3src5color5Color11shadow__key() {
  return _M0MP49LING7167111moon_2degui3src5color5Color4rgba(15, 23, 42, 45);
}
function _M0MP49LING7167111moon_2degui3src5color5Color16pill__active__bg() {
  return _M0MP49LING7167111moon_2degui3src5color5Color3hex(16777215);
}
function _M0MP49LING7167111moon_2degui3src5color5Color20pill__active__border() {
  return _M0MP49LING7167111moon_2degui3src5color5Color4rgba(203, 213, 225, 120);
}
function _M0MP49LING7167111moon_2degui3src5color5Color21pill__ambient__shadow() {
  return _M0MP49LING7167111moon_2degui3src5color5Color4rgba(15, 23, 42, 35);
}
function _M0MP49LING7167111moon_2degui3src5color5Color11wash__hover() {
  return _M0MP49LING7167111moon_2degui3src5color5Color4rgba(248, 250, 252, 60);
}
function _M0MP49LING7167111moon_2degui3src5color5Color15badge__info__bg() {
  return _M0MP49LING7167111moon_2degui3src5color5Color4rgba(37, 99, 235, 150);
}
function _M0MP49LING7167111moon_2degui3src5color5Color18badge__warning__bg() {
  return _M0MP49LING7167111moon_2degui3src5color5Color4rgba(245, 158, 11, 40);
}
function _M0MP49LING7167111moon_2degui3src5color5Color17badge__danger__bg() {
  return _M0MP49LING7167111moon_2degui3src5color5Color4rgba(239, 68, 68, 40);
}
function _M0MP49LING7167111moon_2degui3src5color5Color19tree__row__selected() {
  return _M0MP49LING7167111moon_2degui3src5color5Color3hex(15726335);
}
function _M0MP49LING7167111moon_2degui3src5color5Color20table__row__selected() {
  return _M0MP49LING7167111moon_2degui3src5color5Color4rgba(37, 99, 235, 100);
}
function _M0MP49LING7167111moon_2degui3src5color5Color13border__track() {
  return _M0MP49LING7167111moon_2degui3src5color5Color4rgba(226, 232, 240, 150);
}
function _M0MP49LING7167111moon_2degui3src5color5Color15sparkline__wash() {
  return _M0MP49LING7167111moon_2degui3src5color5Color4rgba(248, 250, 252, 80);
}
function _M0MP49LING7167111moon_2degui3src5color5Color10area__wash(base) {
  return new _M0TP49LING7167111moon_2degui3src5color5Color(base.r, base.g, base.b, 30);
}
function _M0MP49LING7167111moon_2degui3src5color5Color18badge__success__bg() {
  return _M0MP49LING7167111moon_2degui3src5color5Color3hex(15793652);
}
function _M0MP49LING7167111moon_2degui3src5color5Color22badge__success__border() {
  return _M0MP49LING7167111moon_2degui3src5color5Color3hex(12318672);
}
function _M0MP49LING7167111moon_2degui3src5color5Color20badge__success__text() {
  return _M0MP49LING7167111moon_2degui3src5color5Color3hex(1467700);
}
function _M0MP49LING7167111moon_2degui3src5color5Color22badge__warning__border() {
  return _M0MP49LING7167111moon_2degui3src5color5Color3hex(16707722);
}
function _M0MP49LING7167111moon_2degui3src5color5Color20badge__warning__text() {
  return _M0MP49LING7167111moon_2degui3src5color5Color3hex(8736014);
}
function _M0MP49LING7167111moon_2degui3src5color5Color21badge__danger__border() {
  return _M0MP49LING7167111moon_2degui3src5color5Color3hex(16698058);
}
function _M0MP49LING7167111moon_2degui3src5color5Color19badge__danger__text() {
  return _M0MP49LING7167111moon_2degui3src5color5Color3hex(10033947);
}
function _M0MP49LING7167111moon_2degui3src5color5Color19badge__info__border() {
  return _M0MP49LING7167111moon_2degui3src5color5Color3hex(12573694);
}
function _M0MP49LING7167111moon_2degui3src5color5Color17badge__info__text() {
  return _M0MP49LING7167111moon_2degui3src5color5Color3hex(1982639);
}
function _M0MP49LING7167111moon_2degui3src5color5Color17tag__close__hover() {
  return _M0MP49LING7167111moon_2degui3src5color5Color4rgba(15, 23, 42, 25);
}
function _M0MP49LING7167111moon_2degui3src4math4Vec23new(x, y) {
  return new _M0TP49LING7167111moon_2degui3src4math4Vec2(x, y);
}
function _M0MP49LING7167111moon_2degui3src4math4Vec23add(self, other) {
  return new _M0TP49LING7167111moon_2degui3src4math4Vec2(self.x + other.x, self.y + other.y);
}
function _M0MP49LING7167111moon_2degui3src4math4Vec23sub(self, other) {
  return new _M0TP49LING7167111moon_2degui3src4math4Vec2(self.x - other.x, self.y - other.y);
}
function _M0MP49LING7167111moon_2degui3src4math4Rect3new(x, y, w, h) {
  return new _M0TP49LING7167111moon_2degui3src4math4Rect(x, y, w, h);
}
function _M0MP49LING7167111moon_2degui3src4math4Rect6center(self) {
  return new _M0TP49LING7167111moon_2degui3src4math4Vec2(self.x + self.w * 0.5, self.y + self.h * 0.5);
}
function _M0MP49LING7167111moon_2degui3src4math4Rect8contains(self, pt) {
  return pt.x >= self.x && (pt.x <= self.x + self.w && (pt.y >= self.y && pt.y <= self.y + self.h));
}
function _M0MP49LING7167111moon_2degui3src4math4Rect9intersect(self, other) {
  const min_x = self.x > other.x ? self.x : other.x;
  const min_y = self.y > other.y ? self.y : other.y;
  const self_max_x = self.x + self.w;
  const self_max_y = self.y + self.h;
  const other_max_x = other.x + other.w;
  const other_max_y = other.y + other.h;
  const max_x = self_max_x < other_max_x ? self_max_x : other_max_x;
  const max_y = self_max_y < other_max_y ? self_max_y : other_max_y;
  const w = max_x > min_x ? max_x - min_x : 0;
  const h = max_y > min_y ? max_y - min_y : 0;
  return new _M0TP49LING7167111moon_2degui3src4math4Rect(min_x, min_y, w, h);
}
function _M0MP49LING7167111moon_2degui3src4math4Rect6expand(self, margin) {
  return new _M0TP49LING7167111moon_2degui3src4math4Rect(self.x - margin, self.y - margin, self.w + margin * 2, self.h + margin * 2);
}
function _M0MP49LING7167111moon_2degui3src4math4Rect6shrink(self, margin) {
  const w = self.w > margin * 2 ? self.w - margin * 2 : 0;
  const h = self.h > margin * 2 ? self.h - margin * 2 : 0;
  return new _M0TP49LING7167111moon_2degui3src4math4Rect(self.x + margin, self.y + margin, w, h);
}
function _M0FP49LING7167111moon_2degui3src4math3sin(rad) {
  let x = _M0IPC16double6DoublePB3Mod3mod(rad, 6.2831853071795862);
  if (x > 3.1415926535897931) {
    x = x - 6.2831853071795862;
  } else {
    if (x < -3.1415926535897931) {
      x = x + 6.2831853071795862;
    }
  }
  if (x > 1.5707963267948966) {
    x = 3.1415926535897931 - x;
  } else {
    if (x < -1.5707963267948966) {
      x = -3.1415926535897931 - x;
    }
  }
  const x2 = x * x;
  const x3 = x * x2;
  const x5 = x3 * x2;
  const x7 = x5 * x2;
  const x9 = x7 * x2;
  const x11 = x9 * x2;
  return x - x3 / 6 + x5 / 120 - x7 / 5040 + x9 / 362880 - x11 / 39916800;
}
function _M0FP49LING7167111moon_2degui3src4math3cos(rad) {
  return _M0FP49LING7167111moon_2degui3src4math3sin(rad + 1.5707963267948966);
}
function _M0MP49LING7167111moon_2degui3src4math4Vec211from__polar(radius, angle_rad) {
  return new _M0TP49LING7167111moon_2degui3src4math4Vec2(radius * _M0FP49LING7167111moon_2degui3src4math3cos(angle_rad), radius * _M0FP49LING7167111moon_2degui3src4math3sin(angle_rad));
}
function _M0MP49LING7167111moon_2degui3src4draw8DrawList3new() {
  return new _M0TP49LING7167111moon_2degui3src4draw8DrawList([]);
}
function _M0MP49LING7167111moon_2degui3src4draw8DrawList5clear(self) {
  _M0MPC15array5Array5clearGRP49LING7167111moon_2degui3src4math4RectE(self.commands);
}
function _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self, rect, color, corner_radius) {
  _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(self.commands, new _M0DTP49LING7167111moon_2degui3src4draw7DrawCmd4Rect(rect, color, corner_radius));
}
function _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(self, rect, color, stroke_width, corner_radius) {
  _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(self.commands, new _M0DTP49LING7167111moon_2degui3src4draw7DrawCmd10RectStroke(rect, color, stroke_width, corner_radius));
}
function _M0MP49LING7167111moon_2degui3src4draw8DrawList11add__circle(self, center, radius, color) {
  _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(self.commands, new _M0DTP49LING7167111moon_2degui3src4draw7DrawCmd6Circle(center, radius, color));
}
function _M0MP49LING7167111moon_2degui3src4draw8DrawList19add__circle__stroke(self, center, radius, color, stroke_width) {
  _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(self.commands, new _M0DTP49LING7167111moon_2degui3src4draw7DrawCmd12CircleStroke(center, radius, color, stroke_width));
}
function _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(self, start, end, color, stroke_width) {
  _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(self.commands, new _M0DTP49LING7167111moon_2degui3src4draw7DrawCmd4Line(start, end, color, stroke_width));
}
function _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self, pos, text, font_size, color) {
  _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(self.commands, new _M0DTP49LING7167111moon_2degui3src4draw7DrawCmd4Text(pos, text, font_size, color));
}
function _M0MP49LING7167111moon_2degui3src4draw8DrawList10push__clip(self, rect) {
  _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(self.commands, new _M0DTP49LING7167111moon_2degui3src4draw7DrawCmd4Clip(rect));
}
function _M0MP49LING7167111moon_2degui3src4draw8DrawList9pop__clip(self) {
  _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(self.commands, _M0DTP49LING7167111moon_2degui3src4draw7DrawCmd9ResetClip__);
}
function _M0MP49LING7167111moon_2degui3src4draw8DrawList6append(self, other) {
  const _bind = other.commands;
  const _bind$2 = _bind.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$2) {
      const cmd = _bind[_];
      _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(self.commands, cmd);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0IP49LING7167111moon_2degui3src4core15LayoutDirectionPB2Eq5equal(_x_2372, _x_2373) {
  switch (_x_2372) {
    case 0: {
      if (_x_2373 === 0) {
        return true;
      } else {
        return false;
      }
    }
    case 1: {
      if (_x_2373 === 1) {
        return true;
      } else {
        return false;
      }
    }
    default: {
      if (_x_2373 === 2) {
        return true;
      } else {
        return false;
      }
    }
  }
}
function _M0IP49LING7167111moon_2degui3src4core12TextSpanKindPB2Eq5equal(_x_2320, _x_2321) {
  switch (_x_2320.$tag) {
    case 0: {
      if (_x_2321.$tag === 0) {
        return true;
      } else {
        return false;
      }
    }
    case 1: {
      if (_x_2321.$tag === 1) {
        return true;
      } else {
        return false;
      }
    }
    case 2: {
      if (_x_2321.$tag === 2) {
        return true;
      } else {
        return false;
      }
    }
    default: {
      const _Link = _x_2320;
      const _$42$x0_2322 = _Link._0;
      if (_x_2321.$tag === 3) {
        const _Link$2 = _x_2321;
        const _$42$y0_2323 = _Link$2._0;
        return _$42$x0_2322 === _$42$y0_2323;
      } else {
        return false;
      }
    }
  }
}
function _M0IP49LING7167111moon_2degui3src4core3KeyPB2Eq5equal(_x_2288, _x_2289) {
  switch (_x_2288) {
    case 0: {
      if (_x_2289 === 0) {
        return true;
      } else {
        return false;
      }
    }
    case 1: {
      if (_x_2289 === 1) {
        return true;
      } else {
        return false;
      }
    }
    case 2: {
      if (_x_2289 === 2) {
        return true;
      } else {
        return false;
      }
    }
    case 3: {
      if (_x_2289 === 3) {
        return true;
      } else {
        return false;
      }
    }
    case 4: {
      if (_x_2289 === 4) {
        return true;
      } else {
        return false;
      }
    }
    case 5: {
      if (_x_2289 === 5) {
        return true;
      } else {
        return false;
      }
    }
    case 6: {
      if (_x_2289 === 6) {
        return true;
      } else {
        return false;
      }
    }
    case 7: {
      if (_x_2289 === 7) {
        return true;
      } else {
        return false;
      }
    }
    case 8: {
      if (_x_2289 === 8) {
        return true;
      } else {
        return false;
      }
    }
    case 9: {
      if (_x_2289 === 9) {
        return true;
      } else {
        return false;
      }
    }
    case 10: {
      if (_x_2289 === 10) {
        return true;
      } else {
        return false;
      }
    }
    case 11: {
      if (_x_2289 === 11) {
        return true;
      } else {
        return false;
      }
    }
    case 12: {
      if (_x_2289 === 12) {
        return true;
      } else {
        return false;
      }
    }
    case 13: {
      if (_x_2289 === 13) {
        return true;
      } else {
        return false;
      }
    }
    case 14: {
      if (_x_2289 === 14) {
        return true;
      } else {
        return false;
      }
    }
    case 15: {
      if (_x_2289 === 15) {
        return true;
      } else {
        return false;
      }
    }
    case 16: {
      if (_x_2289 === 16) {
        return true;
      } else {
        return false;
      }
    }
    case 17: {
      if (_x_2289 === 17) {
        return true;
      } else {
        return false;
      }
    }
    case 18: {
      if (_x_2289 === 18) {
        return true;
      } else {
        return false;
      }
    }
    case 19: {
      if (_x_2289 === 19) {
        return true;
      } else {
        return false;
      }
    }
    case 20: {
      if (_x_2289 === 20) {
        return true;
      } else {
        return false;
      }
    }
    case 21: {
      if (_x_2289 === 21) {
        return true;
      } else {
        return false;
      }
    }
    case 22: {
      if (_x_2289 === 22) {
        return true;
      } else {
        return false;
      }
    }
    case 23: {
      if (_x_2289 === 23) {
        return true;
      } else {
        return false;
      }
    }
    case 24: {
      if (_x_2289 === 24) {
        return true;
      } else {
        return false;
      }
    }
    case 25: {
      if (_x_2289 === 25) {
        return true;
      } else {
        return false;
      }
    }
    case 26: {
      if (_x_2289 === 26) {
        return true;
      } else {
        return false;
      }
    }
    case 27: {
      if (_x_2289 === 27) {
        return true;
      } else {
        return false;
      }
    }
    case 28: {
      if (_x_2289 === 28) {
        return true;
      } else {
        return false;
      }
    }
    case 29: {
      if (_x_2289 === 29) {
        return true;
      } else {
        return false;
      }
    }
    case 30: {
      if (_x_2289 === 30) {
        return true;
      } else {
        return false;
      }
    }
    case 31: {
      if (_x_2289 === 31) {
        return true;
      } else {
        return false;
      }
    }
    case 32: {
      if (_x_2289 === 32) {
        return true;
      } else {
        return false;
      }
    }
    case 33: {
      if (_x_2289 === 33) {
        return true;
      } else {
        return false;
      }
    }
    case 34: {
      if (_x_2289 === 34) {
        return true;
      } else {
        return false;
      }
    }
    case 35: {
      if (_x_2289 === 35) {
        return true;
      } else {
        return false;
      }
    }
    case 36: {
      if (_x_2289 === 36) {
        return true;
      } else {
        return false;
      }
    }
    case 37: {
      if (_x_2289 === 37) {
        return true;
      } else {
        return false;
      }
    }
    case 38: {
      if (_x_2289 === 38) {
        return true;
      } else {
        return false;
      }
    }
    case 39: {
      if (_x_2289 === 39) {
        return true;
      } else {
        return false;
      }
    }
    case 40: {
      if (_x_2289 === 40) {
        return true;
      } else {
        return false;
      }
    }
    case 41: {
      if (_x_2289 === 41) {
        return true;
      } else {
        return false;
      }
    }
    case 42: {
      if (_x_2289 === 42) {
        return true;
      } else {
        return false;
      }
    }
    case 43: {
      if (_x_2289 === 43) {
        return true;
      } else {
        return false;
      }
    }
    case 44: {
      if (_x_2289 === 44) {
        return true;
      } else {
        return false;
      }
    }
    case 45: {
      if (_x_2289 === 45) {
        return true;
      } else {
        return false;
      }
    }
    case 46: {
      if (_x_2289 === 46) {
        return true;
      } else {
        return false;
      }
    }
    case 47: {
      if (_x_2289 === 47) {
        return true;
      } else {
        return false;
      }
    }
    case 48: {
      if (_x_2289 === 48) {
        return true;
      } else {
        return false;
      }
    }
    default: {
      if (_x_2289 === 49) {
        return true;
      } else {
        return false;
      }
    }
  }
}
function _M0IP49LING7167111moon_2degui3src4core2IdPB4Hash13hash__combine(_x_2272, _x_2273) {
  _M0IPC16uint646UInt64PB4Hash13hash__combine(_x_2272.val, _x_2273);
}
function _M0FP49LING7167111moon_2degui3src4core18clamp__window__pos(pos, size, bounds) {
  const max_x = bounds.x + bounds.w - size.x;
  const max_y = bounds.y + bounds.h - size.y;
  const x = pos.x < bounds.x ? bounds.x : pos.x > max_x ? max_x : pos.x;
  const y = pos.y < bounds.y ? bounds.y : pos.y > max_y ? max_y : pos.y;
  return _M0MP49LING7167111moon_2degui3src4math4Vec23new(x, y);
}
function _M0MP49LING7167111moon_2degui3src4core2Id10with__seed(seed, str) {
  let hash = seed;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < str.length) {
      const _p = i >>> 0 < str.length ? str.charCodeAt(i) : $oob();
      const char_code = BigInt.asUintN(64, BigInt(_p));
      hash = BigInt.asUintN(64, BigInt.asUintN(64, hash ^ char_code) * _M0MP49LING7167111moon_2degui3src4core2Id10with__seedN5primeS1169);
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return new _M0TP49LING7167111moon_2degui3src4core2Id(hash);
}
function _M0MP49LING7167111moon_2degui3src4core7IdStack13current__seed(self) {
  const _p = self.stack;
  if (_p.length === 0) {
    return 14695981039346656037n;
  } else {
    return _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(self.stack, self.stack.length - 1 | 0);
  }
}
function _M0MP49LING7167111moon_2degui3src4core7IdStack10derive__id(self, str) {
  return _M0MP49LING7167111moon_2degui3src4core2Id10with__seed(_M0MP49LING7167111moon_2degui3src4core7IdStack13current__seed(self), str);
}
function _M0MP49LING7167111moon_2degui3src4core8Response19with__focus_2einner(id, rect, hovered, clicked, pressed, dragged, has_focus, gained_focus, lost_focus, secondary_clicked) {
  return new _M0TP49LING7167111moon_2degui3src4core8Response(id, rect, hovered, clicked, pressed, dragged, has_focus, gained_focus, lost_focus, secondary_clicked);
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext16get__window__pos(self, id, fallback) {
  _M0MPC17hashmap7HashMap3setGRP49LING7167111moon_2degui3src4core2IdiE(self.last_active_frame, id, self.frame_counter);
  const _bind = _M0MPC17hashmap7HashMap3getGRP49LING7167111moon_2degui3src4core2IdRP49LING7167111moon_2degui3src4math4Vec2E(self.window_positions, id);
  if (_bind === undefined) {
    return fallback;
  } else {
    const _Some = _bind;
    return _Some;
  }
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext13current__clip(self) {
  const _p = self.clip_stack;
  if (_p.length === 0) {
    return undefined;
  } else {
    return _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(self.clip_stack, self.clip_stack.length - 1 | 0);
  }
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext27is__blocked__by__foreground(self, pt) {
  let blocked = false;
  const _bind = self.prev_blocking_rects;
  const _bind$2 = _bind.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$2) {
      const rect = _bind[_];
      if (_M0MP49LING7167111moon_2degui3src4math4Rect8contains(rect, pt)) {
        blocked = true;
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return blocked;
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext24is__occluded__by__window(self, pt) {
  let occluded = false;
  const _bind = self.prev_window_rects;
  const _bind$2 = _bind.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$2) {
      const item = _bind[_];
      if (item._1 > self.win_active_z && _M0MP49LING7167111moon_2degui3src4math4Rect8contains(item._0, pt)) {
        occluded = true;
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return occluded;
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext11is__hovered(self, rect) {
  const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext13current__clip(self);
  let visible;
  if (_bind === undefined) {
    visible = rect;
  } else {
    const _Some = _bind;
    const _clip = _Some;
    visible = _M0MP49LING7167111moon_2degui3src4math4Rect9intersect(rect, _clip);
  }
  const in_visible_rect = visible.w > 0 && (visible.h > 0 && _M0MP49LING7167111moon_2degui3src4math4Rect8contains(visible, self.input.mouse_pos));
  return in_visible_rect && (self.foreground || !_M0MP49LING7167111moon_2degui3src4core9UIContext27is__blocked__by__foreground(self, self.input.mouse_pos) && !_M0MP49LING7167111moon_2degui3src4core9UIContext24is__occluded__by__window(self, self.input.mouse_pos));
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext9pop__clip(self) {
  const _p = self.clip_stack;
  if (!(_p.length === 0)) {
    _M0MPC15array5Array3popGRP49LING7167111moon_2degui3src4math4RectE(self.clip_stack);
  }
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9pop__clip(self.draw_list);
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext10push__clip(self, rect) {
  let effective_rect;
  const _p = self.clip_stack;
  if (_p.length === 0) {
    effective_rect = rect;
  } else {
    const parent_clip = _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(self.clip_stack, self.clip_stack.length - 1 | 0);
    effective_rect = _M0MP49LING7167111moon_2degui3src4math4Rect9intersect(parent_clip, rect);
  }
  _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(self.clip_stack, effective_rect);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList10push__clip(self.draw_list, effective_rect);
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext13raise__window(self, id) {
  const kept = [];
  const _bind = self.window_focus;
  const _bind$2 = _bind.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$2) {
      const other = _bind[_];
      if (_M0IP016_24default__implPB2Eq10not__equalGRP49LING7167111moon_2degui3src4core2IdE(other, id)) {
        _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(kept, other);
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  _M0MPC15array5Array5clearGRP49LING7167111moon_2degui3src4math4RectE(self.window_focus);
  const _bind$3 = kept.length;
  let _tmp$2 = 0;
  while (true) {
    const _ = _tmp$2;
    if (_ < _bind$3) {
      const other = kept[_];
      _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(self.window_focus, other);
      _tmp$2 = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(self.window_focus, id);
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext15set__active__id(self, id) {
  self.active_id = id;
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext16set__window__pos(self, id, pos) {
  _M0MPC17hashmap7HashMap3setGRP49LING7167111moon_2degui3src4core2IdiE(self.last_active_frame, id, self.frame_counter);
  _M0MPC17hashmap7HashMap3setGRP49LING7167111moon_2degui3src4core2IdRP49LING7167111moon_2degui3src4math4Vec2E(self.window_positions, id, pos);
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext13window__batch(self, id) {
  const _bind = self.window_batches;
  const _bind$2 = _bind.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$2) {
      const batch = _bind[_];
      const _p = batch._0;
      if (BigInt.asUintN(64, _p.val) === BigInt.asUintN(64, id.val)) {
        return batch._1;
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const list = _M0MP49LING7167111moon_2degui3src4draw8DrawList3new();
  _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(self.window_batches, { _0: id, _1: list });
  return list;
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext9window__z(self, id) {
  let rank = -1;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < self.window_focus.length) {
      const _p = _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(self.window_focus, i);
      if (BigInt.asUintN(64, _p.val) === BigInt.asUintN(64, id.val)) {
        rank = i;
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  if (rank < 0) {
    _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(self.window_focus, id);
    rank = self.window_focus.length - 1 | 0;
  }
  return rank;
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext6window(self, title, pos, size, content, id_salt, constrain_to) {
  const id = _M0MP49LING7167111moon_2degui3src4core7IdStack10derive__id(self.id_stack, `window::${_M0MPC16option6Option10unwrap__orGsE(id_salt, title)}`);
  const saved_draw_list = self.draw_list;
  const saved_clip = [];
  const _bind = self.clip_stack;
  const _bind$2 = _bind.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$2) {
      const clip = _bind[_];
      _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(saved_clip, clip);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  _M0MPC15array5Array5clearGRP49LING7167111moon_2degui3src4math4RectE(self.clip_stack);
  let win_pos = _M0MP49LING7167111moon_2degui3src4core9UIContext16get__window__pos(self, id, pos);
  let window_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(win_pos.x, win_pos.y, size.x, size.y);
  let title_bar_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(win_pos.x, win_pos.y, size.x, 28);
  self.win_active_z = _M0MP49LING7167111moon_2degui3src4core9UIContext9window__z(self, id);
  const window_hovered = _M0MP49LING7167111moon_2degui3src4core9UIContext11is__hovered(self, window_rect);
  const bar_hovered = _M0MP49LING7167111moon_2degui3src4core9UIContext11is__hovered(self, title_bar_rect);
  if (window_hovered && self.input.mouse_pressed) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext13raise__window(self, id);
    self.win_active_z = _M0MP49LING7167111moon_2degui3src4core9UIContext9window__z(self, id);
  }
  if (bar_hovered && self.input.mouse_pressed) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext15set__active__id(self, id);
  }
  const _p = self.active_id;
  const is_active = BigInt.asUintN(64, _p.val) === BigInt.asUintN(64, id.val);
  const is_dragging = is_active && (self.input.mouse_down && !self.input.mouse_pressed);
  const clicked = is_active && (self.input.mouse_released && bar_hovered);
  if (is_dragging) {
    win_pos = _M0MP49LING7167111moon_2degui3src4math4Vec23add(win_pos, self.input.mouse_delta);
    if (constrain_to === undefined) {
    } else {
      const _Some = constrain_to;
      const _bounds = _Some;
      win_pos = _M0FP49LING7167111moon_2degui3src4core18clamp__window__pos(win_pos, size, _bounds);
    }
    _M0MP49LING7167111moon_2degui3src4core9UIContext16set__window__pos(self, id, win_pos);
    window_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(win_pos.x, win_pos.y, size.x, size.y);
    title_bar_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(win_pos.x, win_pos.y, size.x, 28);
  }
  if (is_active && self.input.mouse_released) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext15set__active__id(self, _M0MP49LING7167111moon_2degui3src4core2Id4zeroN6recordS4226);
  }
  if (window_hovered) {
    self.wants_capture_mouse = true;
  }
  _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(self.window_rects, { _0: window_rect, _1: self.win_active_z });
  const batch = _M0MP49LING7167111moon_2degui3src4core9UIContext13window__batch(self, id);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList5clear(batch);
  _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(self.window_drawn, id);
  self.draw_list = batch;
  const x = win_pos.x;
  const y = win_pos.y;
  const bg_color = _M0MP49LING7167111moon_2degui3src5color5Color10bg__window();
  const border_color = _M0MP49LING7167111moon_2degui3src5color5Color13border__muted();
  const header_color = _M0MP49LING7167111moon_2degui3src5color5Color11bg__surface();
  const win_radius = self.style.radius_md;
  const font_sz = self.style.font_normal;
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, window_rect, bg_color, win_radius);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(self.draw_list, window_rect, border_color, 1, win_radius);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, title_bar_rect, header_color, win_radius);
  const filler_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(x, y + 28 - 4, size.x, 4);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, filler_rect, header_color, 0);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(x, y + 28), _M0MP49LING7167111moon_2degui3src4math4Vec23new(x + size.x, y + 28), border_color, 1);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(x + 12, y + 7), title, font_sz, _M0MP49LING7167111moon_2degui3src5color5Color13text__primary());
  const content_x = x + 12;
  const content_y = y + 28 + 12;
  const content_w = size.x - 24;
  const content_h = size.y - 28 - 24;
  const clip_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(content_x, content_y, content_w, content_h);
  _M0MP49LING7167111moon_2degui3src4core9UIContext10push__clip(self, clip_rect);
  const prev_cursor = self.cursor;
  const prev_avail_w = self.available_width;
  self.cursor = _M0MP49LING7167111moon_2degui3src4math4Vec23new(content_x, content_y);
  self.available_width = content_w;
  content(self);
  self.cursor = prev_cursor;
  self.available_width = prev_avail_w;
  _M0MP49LING7167111moon_2degui3src4core9UIContext9pop__clip(self);
  self.draw_list = saved_draw_list;
  _M0MPC15array5Array5clearGRP49LING7167111moon_2degui3src4math4RectE(self.clip_stack);
  const _bind$3 = saved_clip.length;
  let _tmp$2 = 0;
  while (true) {
    const _ = _tmp$2;
    if (_ < _bind$3) {
      const clip = saved_clip[_];
      _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(self.clip_stack, clip);
      _tmp$2 = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  self.win_active_z = -1;
  return _M0MP49LING7167111moon_2degui3src4core8Response19with__focus_2einner(id, window_rect, window_hovered, clicked, is_dragging, is_dragging, false, false, false, false);
}
function _M0FP49LING7167111moon_2degui3src4core13string__slice(s, start, end) {
  const len = s.length;
  const safe_start = start < 0 ? 0 : start > len ? len : start;
  const safe_end = end < safe_start ? safe_start : end > len ? len : end;
  return _M0MPC16string10StringView9to__owned(_M0MPC16string6String11sub_2einner(s, safe_start, safe_end));
}
function _M0FP49LING7167111moon_2degui3src4core20prev__char__boundary(text, pos) {
  if (pos <= 0) {
    return 0;
  } else {
    let _tmp;
    if (pos >= 2) {
      let _tmp$2;
      const _tmp$3 = pos - 1 | 0;
      const _p = _tmp$3 >>> 0 < text.length ? text.charCodeAt(_tmp$3) : $oob();
      if (_p >= 56320 && _p <= 57343) {
        const _tmp$4 = pos - 2 | 0;
        const _p$2 = _tmp$4 >>> 0 < text.length ? text.charCodeAt(_tmp$4) : $oob();
        _tmp$2 = _p$2 >= 55296 && _p$2 <= 56319;
      } else {
        _tmp$2 = false;
      }
      _tmp = _tmp$2;
    } else {
      _tmp = false;
    }
    if (_tmp) {
      return pos - 2 | 0;
    } else {
      return pos - 1 | 0;
    }
  }
}
function _M0FP49LING7167111moon_2degui3src4core20next__char__boundary(text, pos) {
  const len = text.length;
  if (pos >= len) {
    return len;
  } else {
    let _tmp;
    if ((pos + 1 | 0) < len) {
      let _tmp$2;
      const _p = pos >>> 0 < text.length ? text.charCodeAt(pos) : $oob();
      if (_p >= 55296 && _p <= 56319) {
        const _tmp$3 = pos + 1 | 0;
        const _p$2 = _tmp$3 >>> 0 < text.length ? text.charCodeAt(_tmp$3) : $oob();
        _tmp$2 = _p$2 >= 56320 && _p$2 <= 57343;
      } else {
        _tmp$2 = false;
      }
      _tmp = _tmp$2;
    } else {
      _tmp = false;
    }
    if (_tmp) {
      return pos + 2 | 0;
    } else {
      return pos + 1 | 0;
    }
  }
}
function _M0FP49LING7167111moon_2degui3src4core18delete__prev__char(text, pos) {
  if (pos <= 0 || text.length === 0) {
    return { _0: text, _1: 0 };
  } else {
    const prev = _M0FP49LING7167111moon_2degui3src4core20prev__char__boundary(text, pos);
    const left = _M0FP49LING7167111moon_2degui3src4core13string__slice(text, 0, prev);
    const right = _M0FP49LING7167111moon_2degui3src4core13string__slice(text, pos, text.length);
    return { _0: `${left}${right}`, _1: prev };
  }
}
function _M0FP49LING7167111moon_2degui3src4core18delete__next__char(text, pos) {
  const len = text.length;
  if (pos >= len || len === 0) {
    return text;
  } else {
    const next = _M0FP49LING7167111moon_2degui3src4core20next__char__boundary(text, pos);
    const left = _M0FP49LING7167111moon_2degui3src4core13string__slice(text, 0, pos);
    const right = _M0FP49LING7167111moon_2degui3src4core13string__slice(text, next, len);
    return `${left}${right}`;
  }
}
function _M0FP49LING7167111moon_2degui3src4core13is__cjk__char(code) {
  return code >= 19968 && code <= 40959 || (code >= 13312 && code <= 19903 || (code >= 63744 && code <= 64255 || (code >= 12288 && code <= 12351 || (code >= 12352 && code <= 12447 || (code >= 12448 && code <= 12543 || (code >= 44032 && code <= 55215 || code >= 65280 && code <= 65519))))));
}
function _M0FP49LING7167111moon_2degui3src4core23is__cjk__closing__punct(code) {
  switch (code) {
    case 12289: {
      return true;
    }
    case 12290: {
      return true;
    }
    case 65292: {
      return true;
    }
    case 65294: {
      return true;
    }
    case 65281: {
      return true;
    }
    case 65311: {
      return true;
    }
    case 65307: {
      return true;
    }
    case 65306: {
      return true;
    }
    case 12297: {
      return true;
    }
    case 12299: {
      return true;
    }
    case 12301: {
      return true;
    }
    case 12303: {
      return true;
    }
    case 12305: {
      return true;
    }
    case 12309: {
      return true;
    }
    case 65289: {
      return true;
    }
    case 65373: {
      return true;
    }
    case 8221: {
      return true;
    }
    case 8217: {
      return true;
    }
    default: {
      return false;
    }
  }
}
function _M0MP49LING7167111moon_2degui3src4core8TreeNode11new_2einner(id, label, children, icon) {
  return new _M0TP49LING7167111moon_2degui3src4core8TreeNode(id, label, icon, children);
}
function _M0MP49LING7167111moon_2degui3src4core8TreeNode12leaf_2einner(id, label, icon) {
  return new _M0TP49LING7167111moon_2degui3src4core8TreeNode(id, label, icon, []);
}
function _M0FP49LING7167111moon_2degui3src4core20flatten__tree__nodes(nodes, expanded_ids, depth, parent_id, out) {
  const _bind = nodes.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const node = nodes[_];
      const _p = node.children;
      const has_children = !(_p.length === 0);
      const is_expanded = has_children && _M0MPC15array5Array8containsGsE(expanded_ids, node.id);
      _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(out, new _M0TP49LING7167111moon_2degui3src4core12FlatTreeNode(node, depth, is_expanded, has_children, parent_id));
      if (is_expanded) {
        _M0FP49LING7167111moon_2degui3src4core20flatten__tree__nodes(node.children, expanded_ids, depth + 1 | 0, node.id, out);
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self, key) {
  return _M0MPC15array5Array8containsGRP49LING7167111moon_2degui3src4core3KeyE(self.keys_pressed, key);
}
function _M0MP49LING7167111moon_2degui3src4core2Id9with__int(seed, index) {
  let hash = seed;
  let u = BigInt.asUintN(64, BigInt(index));
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < 8) {
      const byte_val = BigInt.asUintN(64, u & 255n);
      hash = BigInt.asUintN(64, BigInt.asUintN(64, hash ^ byte_val) * _M0MP49LING7167111moon_2degui3src4core2Id9with__intN5primeS1148);
      u = BigInt.asUintN(64, BigInt.asUintN(64, u) >> BigInt(8 & 63));
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return new _M0TP49LING7167111moon_2degui3src4core2Id(hash);
}
function _M0MP49LING7167111moon_2degui3src4core7IdStack11derive__int(self, index) {
  return _M0MP49LING7167111moon_2degui3src4core2Id9with__int(_M0MP49LING7167111moon_2degui3src4core7IdStack13current__seed(self), index);
}
function _M0MP49LING7167111moon_2degui3src4core10InputState12consume__key(self, key) {
  if (!_M0MPC15array5Array8containsGRP49LING7167111moon_2degui3src4core3KeyE(self.consumed_keys, key)) {
    _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core3KeyE(self.consumed_keys, key);
    return;
  } else {
    return;
  }
}
function _M0MP49LING7167111moon_2degui3src4core10InputState17is__key__consumed(self, key) {
  return _M0MPC15array5Array8containsGRP49LING7167111moon_2degui3src4core3KeyE(self.consumed_keys, key);
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext19reset__caret__blink(self) {
  self.last_caret_activity = self.time;
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext14request__focus(self, id) {
  if (_M0IP016_24default__implPB2Eq10not__equalGRP49LING7167111moon_2degui3src4core2IdE(self.focused_id, id)) {
    if (_M0IP016_24default__implPB2Eq10not__equalGRP49LING7167111moon_2degui3src4core2IdE(self.focused_id, _M0MP49LING7167111moon_2degui3src4core2Id4zeroN6recordS4226)) {
      self.pending_lost_focus_id = self.focused_id;
    }
    self.focused_id = id;
    _M0MP49LING7167111moon_2degui3src4core9UIContext19reset__caret__blink(self);
    return;
  } else {
    return;
  }
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext15allocate__space(self, size) {
  self.auto_id_counter = self.auto_id_counter + 1 | 0;
  const id = _M0MP49LING7167111moon_2degui3src4core7IdStack11derive__int(self.id_stack, self.auto_id_counter);
  let current_scope;
  const _p = self.layout_stack;
  if (_p.length === 0) {
    current_scope = undefined;
  } else {
    current_scope = _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(self.layout_stack, self.layout_stack.length - 1 | 0);
  }
  if (current_scope === undefined) {
  } else {
    const _Some = current_scope;
    const _scope = _Some;
    if (_M0IP49LING7167111moon_2degui3src4core15LayoutDirectionPB2Eq5equal(_scope.dir, 2)) {
      const wrap_w = _scope.wrap_width > 0 ? _scope.wrap_width : self.available_width;
      if (self.cursor.x > _scope.start_x && self.cursor.x + size.x > _scope.start_x + wrap_w) {
        const next_y = self.cursor.y + _scope.current_row_h + self.item_spacing.y;
        _scope.max_cross_size = _scope.max_cross_size + _scope.current_row_h + self.item_spacing.y;
        _scope.current_row_h = 0;
        self.cursor = _M0MP49LING7167111moon_2degui3src4math4Vec23new(_scope.start_x, next_y);
      }
    }
  }
  let item_y;
  if (current_scope === undefined) {
    item_y = self.cursor.y;
  } else {
    const _Some = current_scope;
    const _scope = _Some;
    item_y = _M0IP49LING7167111moon_2degui3src4core15LayoutDirectionPB2Eq5equal(_scope.dir, 1) ? _scope.start_y : self.cursor.y;
  }
  const rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(self.cursor.x, item_y, size.x, size.y);
  if (current_scope === undefined) {
    self.cursor = _M0MP49LING7167111moon_2degui3src4math4Vec23new(self.cursor.x, self.cursor.y + size.y + self.item_spacing.y);
  } else {
    const _Some = current_scope;
    const _scope = _Some;
    const _bind = _scope.dir;
    switch (_bind) {
      case 0: {
        if (size.x > _scope.max_cross_size) {
          _scope.max_cross_size = size.x;
        }
        self.cursor = _M0MP49LING7167111moon_2degui3src4math4Vec23new(self.cursor.x, self.cursor.y + size.y + self.item_spacing.y);
        break;
      }
      case 1: {
        if (size.y > _scope.max_cross_size) {
          _scope.max_cross_size = size.y;
        }
        self.cursor = _M0MP49LING7167111moon_2degui3src4math4Vec23new(self.cursor.x + size.x + self.item_spacing.x, _scope.start_y);
        break;
      }
      default: {
        if (size.y > _scope.current_row_h) {
          _scope.current_row_h = size.y;
        }
        self.cursor = _M0MP49LING7167111moon_2degui3src4math4Vec23new(self.cursor.x + size.x + self.item_spacing.x, self.cursor.y);
      }
    }
  }
  const hovered = _M0MP49LING7167111moon_2degui3src4core9UIContext11is__hovered(self, rect);
  if (hovered) {
    self.hot_id = id;
    self.wants_capture_mouse = true;
  }
  if (hovered && self.input.mouse_pressed) {
    self.active_id = id;
  }
  const _p$2 = self.active_id;
  const is_active = BigInt.asUintN(64, _p$2.val) === BigInt.asUintN(64, id.val);
  if (is_active) {
    self.wants_capture_mouse = true;
  }
  const pressed = is_active && self.input.mouse_down;
  const mouse_clicked = is_active && (self.input.mouse_released && hovered);
  let dragged;
  if (is_active) {
    let _tmp;
    if (self.input.mouse_down) {
      const _p$3 = self.input.mouse_delta;
      _tmp = _p$3.x * _p$3.x + _p$3.y * _p$3.y > 0;
    } else {
      _tmp = false;
    }
    dragged = _tmp;
  } else {
    dragged = false;
  }
  if (self.input.mouse_released && is_active) {
    self.active_id = _M0MP49LING7167111moon_2degui3src4core2Id4zeroN6recordS4226;
  }
  const _p$3 = self.focused_id;
  const is_focused = BigInt.asUintN(64, _p$3.val) === BigInt.asUintN(64, id.val);
  const gained_focus = is_focused && _M0IP016_24default__implPB2Eq10not__equalGRP49LING7167111moon_2degui3src4core2IdE(self.prev_focused_id, id);
  let lost_focus;
  const _p$4 = self.lost_focus_id;
  if (BigInt.asUintN(64, _p$4.val) === BigInt.asUintN(64, id.val)) {
    lost_focus = true;
  } else {
    let _tmp;
    const _p$5 = self.pending_lost_focus_id;
    if (BigInt.asUintN(64, _p$5.val) === BigInt.asUintN(64, id.val)) {
      _tmp = !is_focused;
    } else {
      _tmp = false;
    }
    lost_focus = _tmp;
  }
  const key_activated = is_focused && (!_M0MP49LING7167111moon_2degui3src4core10InputState17is__key__consumed(self.input, 5) && (!_M0MP49LING7167111moon_2degui3src4core10InputState17is__key__consumed(self.input, 2) && (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 5) || _M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 2))));
  if (key_activated) {
    _M0MP49LING7167111moon_2degui3src4core10InputState12consume__key(self.input, 5);
    _M0MP49LING7167111moon_2degui3src4core10InputState12consume__key(self.input, 2);
  }
  const clicked = mouse_clicked || key_activated;
  const secondary_clicked = hovered && self.input.mouse_secondary_pressed;
  if (clicked) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext14request__focus(self, id);
  }
  const response = _M0MP49LING7167111moon_2degui3src4core8Response19with__focus_2einner(id, rect, hovered, clicked, pressed, dragged, is_focused, gained_focus, lost_focus, secondary_clicked);
  return { _0: id, _1: rect, _2: response };
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext10has__focus(self, id) {
  const _p = self.focused_id;
  return BigInt.asUintN(64, _p.val) === BigInt.asUintN(64, id.val);
}
function _M0FP49LING7167111moon_2degui3src4core18ascii__char__ratio(code) {
  switch (code) {
    case 32: {
      return 0.26;
    }
    case 33: {
      return 0.28;
    }
    case 39: {
      return 0.28;
    }
    case 44: {
      return 0.28;
    }
    case 46: {
      return 0.28;
    }
    case 58: {
      return 0.28;
    }
    case 59: {
      return 0.28;
    }
    case 105: {
      return 0.28;
    }
    case 108: {
      return 0.28;
    }
    case 124: {
      return 0.28;
    }
    case 34: {
      return 0.36;
    }
    case 106: {
      return 0.38;
    }
    case 114: {
      return 0.38;
    }
    case 116: {
      return 0.38;
    }
    case 102: {
      return 0.38;
    }
    case 73: {
      return 0.38;
    }
    case 40: {
      return 0.4;
    }
    case 41: {
      return 0.4;
    }
    case 91: {
      return 0.4;
    }
    case 93: {
      return 0.4;
    }
    case 123: {
      return 0.4;
    }
    case 125: {
      return 0.4;
    }
    case 49: {
      return 0.4;
    }
    case 45: {
      return 0.4;
    }
    case 96: {
      return 0.4;
    }
    case 47: {
      return 0.48;
    }
    case 92: {
      return 0.48;
    }
    case 42: {
      return 0.48;
    }
    case 122: {
      return 0.48;
    }
    case 115: {
      return 0.53;
    }
    case 118: {
      return 0.53;
    }
    case 120: {
      return 0.53;
    }
    case 121: {
      return 0.53;
    }
    case 63: {
      return 0.53;
    }
    case 107: {
      return 0.58;
    }
    case 117: {
      return 0.58;
    }
    case 97: {
      return 0.58;
    }
    case 101: {
      return 0.58;
    }
    case 98: {
      return 0.64;
    }
    case 99: {
      return 0.64;
    }
    case 100: {
      return 0.64;
    }
    case 103: {
      return 0.64;
    }
    case 104: {
      return 0.64;
    }
    case 110: {
      return 0.64;
    }
    case 111: {
      return 0.64;
    }
    case 112: {
      return 0.64;
    }
    case 113: {
      return 0.64;
    }
    case 48: {
      return 0.6;
    }
    case 50: {
      return 0.6;
    }
    case 51: {
      return 0.6;
    }
    case 52: {
      return 0.6;
    }
    case 53: {
      return 0.6;
    }
    case 54: {
      return 0.6;
    }
    case 55: {
      return 0.6;
    }
    case 56: {
      return 0.6;
    }
    case 57: {
      return 0.6;
    }
    case 43: {
      return 0.62;
    }
    case 60: {
      return 0.62;
    }
    case 61: {
      return 0.62;
    }
    case 62: {
      return 0.62;
    }
    case 94: {
      return 0.62;
    }
    case 95: {
      return 0.62;
    }
    case 126: {
      return 0.62;
    }
    case 69: {
      return 0.58;
    }
    case 70: {
      return 0.58;
    }
    case 76: {
      return 0.58;
    }
    case 84: {
      return 0.58;
    }
    case 90: {
      return 0.58;
    }
    case 65: {
      return 0.66;
    }
    case 66: {
      return 0.66;
    }
    case 75: {
      return 0.66;
    }
    case 80: {
      return 0.66;
    }
    case 82: {
      return 0.66;
    }
    case 83: {
      return 0.66;
    }
    case 86: {
      return 0.66;
    }
    case 88: {
      return 0.66;
    }
    case 89: {
      return 0.66;
    }
    case 67: {
      return 0.74;
    }
    case 68: {
      return 0.74;
    }
    case 71: {
      return 0.74;
    }
    case 72: {
      return 0.74;
    }
    case 78: {
      return 0.74;
    }
    case 85: {
      return 0.74;
    }
    case 79: {
      return 0.82;
    }
    case 81: {
      return 0.82;
    }
    case 77: {
      return 0.88;
    }
    case 87: {
      return 0.88;
    }
    case 119: {
      return 0.88;
    }
    case 109: {
      return 0.92;
    }
    case 64: {
      return 0.94;
    }
    case 37: {
      return 0.94;
    }
    case 35: {
      return 0.78;
    }
    case 36: {
      return 0.78;
    }
    case 38: {
      return 0.78;
    }
    default: {
      return 0.58;
    }
  }
}
function _M0FP49LING7167111moon_2degui3src4core18char__width__ratio(code) {
  if (code <= 127) {
    return _M0FP49LING7167111moon_2degui3src4core18ascii__char__ratio(code);
  } else {
    if (code <= 591) {
      switch (code) {
        case 160: {
          return 0.26;
        }
        case 161: {
          return 0.28;
        }
        case 171: {
          return 0.48;
        }
        case 187: {
          return 0.48;
        }
        case 191: {
          return 0.53;
        }
        case 223: {
          return 0.64;
        }
        default: {
          return code >= 192 && code <= 222 ? 0.68 : 0.58;
        }
      }
    } else {
      if (code >= 880 && code <= 1279) {
        return 0.62;
      } else {
        if (code >= 8192 && code <= 8303) {
          switch (code) {
            case 8192: {
              return 0.5;
            }
            case 8193: {
              return 0.5;
            }
            case 8194: {
              return 0.5;
            }
            case 8195: {
              return 0.5;
            }
            case 8196: {
              return 0.26;
            }
            case 8197: {
              return 0.26;
            }
            case 8198: {
              return 0.26;
            }
            case 8199: {
              return 0.26;
            }
            case 8200: {
              return 0.26;
            }
            case 8201: {
              return 0.26;
            }
            case 8202: {
              return 0.26;
            }
            case 8211: {
              return 0.55;
            }
            case 8212: {
              return 0.85;
            }
            case 8216: {
              return 0.28;
            }
            case 8217: {
              return 0.28;
            }
            case 8218: {
              return 0.28;
            }
            case 8220: {
              return 0.45;
            }
            case 8221: {
              return 0.45;
            }
            case 8222: {
              return 0.45;
            }
            case 8230: {
              return 0.75;
            }
            default: {
              return 0.5;
            }
          }
        } else {
          return code >= 8704 && code <= 8959 ? 0.68 : code >= 65377 && code <= 65439 ? 0.5 : code >= 19968 && code <= 40959 || (code >= 13312 && code <= 19903 || (code >= 63744 && code <= 64255 || (code >= 12288 && code <= 12351 || (code >= 12352 && code <= 12447 || (code >= 12448 && code <= 12543 || (code >= 44032 && code <= 55215 || (code >= 65281 && code <= 65376 || code >= 65504 && code <= 65518))))))) ? 1.05 : 0.65;
        }
      }
    }
  }
}
function _M0FP49LING7167111moon_2degui3src4core19measure__text__size(text, font_size) {
  let total_w = 0;
  let i = 0;
  const len = text.length;
  while (true) {
    if (i < len) {
      const _tmp = i;
      const ch = _tmp >>> 0 < text.length ? text.charCodeAt(_tmp) : $oob();
      const code = ch;
      let _tmp$2;
      if (code >= 55296 && code <= 56319) {
        let _tmp$3;
        if ((i + 1 | 0) < len) {
          const _tmp$4 = i + 1 | 0;
          const _p = _tmp$4 >>> 0 < text.length ? text.charCodeAt(_tmp$4) : $oob();
          _tmp$3 = _p >= 56320 && _p <= 57343;
        } else {
          _tmp$3 = false;
        }
        _tmp$2 = _tmp$3;
      } else {
        _tmp$2 = false;
      }
      if (_tmp$2) {
        total_w = total_w + font_size * 1.05;
        i = i + 2 | 0;
      } else {
        total_w = total_w + _M0FP49LING7167111moon_2degui3src4core18char__width__ratio(code) * font_size;
        i = i + 1 | 0;
      }
      continue;
    } else {
      break;
    }
  }
  const h = font_size * 1.25;
  return _M0MP49LING7167111moon_2degui3src4math4Vec23new(total_w, h);
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(self, text, font_size) {
  if (text === "") {
    return _M0MP49LING7167111moon_2degui3src4math4Vec23new(0, font_size * 1.25);
  }
  const key = `${text}@${_M0MPC13int3Int18to__string_2einner(_M0MPC16double6Double7to__int(font_size), 10)}`;
  const _bind = _M0MPC17hashmap7HashMap3getGsdE(self.text_measure_cache, key);
  let w;
  if (_bind.$tag === 1) {
    const _Some = _bind;
    w = _Some._0;
  } else {
    const measured = _M0FP49LING7167111moon_2degui3src4core19measure__text__size(text, font_size).x;
    const _p = self.text_measure_cache;
    if (_p.size > 2048) {
      _M0MPC17hashmap7HashMap5clearGsdE(self.text_measure_cache);
    }
    _M0MPC17hashmap7HashMap3setGsdE(self.text_measure_cache, key, measured);
    w = measured;
  }
  const h = font_size * 1.25;
  return _M0MP49LING7167111moon_2degui3src4math4Vec23new(w, h);
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext19register__focusable(self, id) {
  if (!_M0MPC15array5Array8containsGRP49LING7167111moon_2degui3src4core2IdE(self.focusable_ids, id)) {
    _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(self.focusable_ids, id);
    return;
  } else {
    return;
  }
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext17set__cursor__icon(self, icon) {
  self.cursor_icon = icon;
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext18tree__view_2einner(self, id_salt, nodes, selected_id, expanded_ids, indent_step, item_height, size) {
  const scale = self.style.scale;
  const eff_row_h = item_height > 0 ? item_height : self.style.tree_view_row_h * scale;
  const flat_nodes = [];
  _M0FP49LING7167111moon_2degui3src4core20flatten__tree__nodes(nodes, expanded_ids, 0, undefined, flat_nodes);
  const node_count = flat_nodes.length;
  const content_height = node_count > 0 ? (node_count + 0) * eff_row_h + 4 * scale : eff_row_h + 4 * scale;
  let total_w;
  if (size === undefined) {
    total_w = self.available_width > 0 ? self.available_width : 240 * scale;
  } else {
    const _Some = size;
    const _s = _Some;
    total_w = _s.x;
  }
  let total_h;
  if (size === undefined) {
    total_h = content_height;
  } else {
    const _Some = size;
    const _s = _Some;
    total_h = _s.y;
  }
  const id = _M0MP49LING7167111moon_2degui3src4core7IdStack10derive__id(self.id_stack, `tree_view::${id_salt}`);
  const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext15allocate__space(self, _M0MP49LING7167111moon_2degui3src4math4Vec23new(total_w, total_h));
  const _rect = _bind._1;
  const _response = _bind._2;
  if (_response.hovered) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext17set__cursor__icon(self, "pointer");
  }
  _M0MP49LING7167111moon_2degui3src4core9UIContext19register__focusable(self, id);
  if (_response.pressed || _response.clicked) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext14request__focus(self, id);
  }
  const is_focused = _M0MP49LING7167111moon_2degui3src4core9UIContext10has__focus(self, id);
  const tree_radius = self.style.tree_view_radius * scale;
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, _rect, _M0MP49LING7167111moon_2degui3src5color5Color10bg__window(), tree_radius);
  const border_color = is_focused ? _M0MP49LING7167111moon_2degui3src5color5Color13border__focus() : _M0MP49LING7167111moon_2degui3src5color5Color13border__muted();
  _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(self.draw_list, _rect, border_color, 1, tree_radius);
  let cur_selected = selected_id;
  const next_expanded = _M0MPC15array5Array4copyGsE(expanded_ids);
  let clicked_id = undefined;
  let toggled_id = undefined;
  if (is_focused && node_count > 0) {
    let sel_idx = -1;
    let _tmp = 0;
    while (true) {
      const i = _tmp;
      if (i < node_count) {
        if (_M0IPC16option6OptionPB2Eq5equalGsE(_M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(flat_nodes, i).node.id, cur_selected)) {
          sel_idx = i;
          break;
        }
        _tmp = i + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 8)) {
      if (sel_idx > 0) {
        cur_selected = _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(flat_nodes, sel_idx - 1 | 0).node.id;
        clicked_id = cur_selected;
      } else {
        if (sel_idx === -1) {
          cur_selected = _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(flat_nodes, 0).node.id;
          clicked_id = cur_selected;
        }
      }
    }
    if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 9)) {
      if (sel_idx >= 0 && sel_idx < (node_count - 1 | 0)) {
        cur_selected = _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(flat_nodes, sel_idx + 1 | 0).node.id;
        clicked_id = cur_selected;
      } else {
        if (sel_idx === -1) {
          cur_selected = _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(flat_nodes, 0).node.id;
          clicked_id = cur_selected;
        }
      }
    }
    if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 7) && sel_idx >= 0) {
      const flat = _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(flat_nodes, sel_idx);
      if (flat.has_children && !flat.is_expanded) {
        _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(next_expanded, flat.node.id);
        toggled_id = flat.node.id;
      }
    }
    if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 6) && sel_idx >= 0) {
      const flat = _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(flat_nodes, sel_idx);
      if (flat.has_children && flat.is_expanded) {
        let idx_to_remove = -1;
        let _tmp$2 = 0;
        while (true) {
          const i = _tmp$2;
          if (i < next_expanded.length) {
            if (_M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(next_expanded, i) === flat.node.id) {
              idx_to_remove = i;
              break;
            }
            _tmp$2 = i + 1 | 0;
            continue;
          } else {
            break;
          }
        }
        if (idx_to_remove >= 0) {
          _M0MPC15array5Array6removeGsE(next_expanded, idx_to_remove);
          toggled_id = flat.node.id;
        }
      } else {
        const _bind$2 = flat.parent_id;
        if (_bind$2 === undefined) {
        } else {
          const _Some = _bind$2;
          const _p_id = _Some;
          cur_selected = _p_id;
          clicked_id = _p_id;
        }
      }
    }
  }
  if (node_count > 0) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext10push__clip(self, _rect);
  }
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < node_count) {
      const flat = _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(flat_nodes, i);
      const node = flat.node;
      const row_y = _rect.y + 2 * scale + (i + 0) * eff_row_h;
      const is_in_view = row_y + eff_row_h <= _rect.y + _rect.h + 2 * scale && row_y >= _rect.y;
      const row_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(_rect.x + 2 * scale, row_y, _rect.w - 4 * scale, eff_row_h);
      const is_row_hovered = is_in_view && _M0MP49LING7167111moon_2degui3src4core9UIContext11is__hovered(self, row_rect);
      const is_row_selected = _M0IPC16option6OptionPB2Eq5equalGsE(node.id, cur_selected);
      const chevron_x = row_rect.x + 4 * scale + (flat.depth + 0) * indent_step;
      const chevron_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(chevron_x, row_y, 16 * scale, eff_row_h);
      const is_chevron_hovered = flat.has_children && _M0MP49LING7167111moon_2degui3src4core9UIContext11is__hovered(self, chevron_rect);
      if (is_row_hovered || is_chevron_hovered) {
        _M0MP49LING7167111moon_2degui3src4core9UIContext17set__cursor__icon(self, "pointer");
      }
      if (self.input.mouse_pressed) {
        if (is_chevron_hovered) {
          if (flat.is_expanded) {
            let found = -1;
            let _tmp$2 = 0;
            while (true) {
              const j = _tmp$2;
              if (j < next_expanded.length) {
                if (_M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(next_expanded, j) === node.id) {
                  found = j;
                  break;
                }
                _tmp$2 = j + 1 | 0;
                continue;
              } else {
                break;
              }
            }
            if (found >= 0) {
              _M0MPC15array5Array6removeGsE(next_expanded, found);
            }
          } else {
            _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(next_expanded, node.id);
          }
          toggled_id = node.id;
        } else {
          if (is_row_hovered) {
            cur_selected = node.id;
            clicked_id = node.id;
            _M0MP49LING7167111moon_2degui3src4core9UIContext14request__focus(self, id);
          }
        }
      }
      const row_radius = self.style.radius_sm * scale;
      const font_sm = self.style.font_small * scale;
      const font_nm = self.style.font_normal * scale;
      if (is_row_selected) {
        _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, row_rect, _M0MP49LING7167111moon_2degui3src5color5Color19tree__row__selected(), row_radius);
        _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Rect3new(row_rect.x, row_rect.y + 2 * scale, 2.5 * scale, row_rect.h - 4 * scale), _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary(), 1);
      } else {
        if (is_row_hovered) {
          _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, row_rect, _M0MP49LING7167111moon_2degui3src5color5Color9bg__hover(), row_radius);
        }
      }
      let _tmp$2 = 0;
      while (true) {
        const d = _tmp$2;
        if (d < flat.depth) {
          const guide_x = row_rect.x + 4 * scale + (d + 0) * indent_step + 7.5 * scale;
          _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(guide_x, row_rect.y), _M0MP49LING7167111moon_2degui3src4math4Vec23new(guide_x, row_rect.y + row_rect.h), _M0MP49LING7167111moon_2degui3src5color5Color13border__muted(), 1);
          _tmp$2 = d + 1 | 0;
          continue;
        } else {
          break;
        }
      }
      if (flat.has_children) {
        const chevron_glyph = flat.is_expanded ? "v" : ">";
        const chevron_col = is_chevron_hovered ? _M0MP49LING7167111moon_2degui3src5color5Color13text__primary() : _M0MP49LING7167111moon_2degui3src5color5Color11text__muted();
        _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(chevron_x + 3 * scale, row_y + 5 * scale), chevron_glyph, font_sm, chevron_col);
      }
      const content_x = chevron_x + 18 * scale;
      let text_x = content_x;
      const _p = node.icon;
      if (!(_p === "")) {
        const icon_size = _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(self, node.icon, font_sm);
        const badge_w = icon_size.x + 8 * scale;
        const badge_h = 16 * scale;
        const badge_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(content_x, row_y + 4 * scale, badge_w, badge_h);
        let badge_bg;
        let badge_col;
        _L: {
          if (is_row_selected) {
            badge_bg = _M0MP49LING7167111moon_2degui3src5color5Color12accent__soft();
            badge_col = _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary();
            break _L;
          } else {
            badge_bg = _M0MP49LING7167111moon_2degui3src5color5Color10bg__subtle();
            badge_col = _M0MP49LING7167111moon_2degui3src5color5Color15text__secondary();
            break _L;
          }
        }
        _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, badge_rect, badge_bg, 3 * scale);
        _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(content_x + 4 * scale, row_y + 6 * scale), node.icon, font_sm, badge_col);
        text_x = content_x + badge_w + 6 * scale;
      }
      const label_col = is_row_selected ? _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary() : is_row_hovered ? _M0MP49LING7167111moon_2degui3src5color5Color13text__primary() : _M0MP49LING7167111moon_2degui3src5color5Color10text__body();
      _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(text_x, row_y + 5.5 * scale), node.label, font_nm, label_col);
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  if (node_count > 0) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext9pop__clip(self);
  }
  return new _M0TP49LING7167111moon_2degui3src4core16TreeViewResponse(cur_selected, next_expanded, clicked_id, toggled_id, _response);
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext8checkbox(self, text, checked) {
  const scale = self.style.scale;
  const box_size = self.style.checkbox_size * scale;
  const gap = self.style.checkbox_gap * scale;
  const font_nm = self.style.font_normal * scale;
  const text_size = _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(self, text, font_nm);
  const w = box_size + gap + text_size.x;
  const h = self.style.checkbox_h * scale;
  const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext15allocate__space(self, _M0MP49LING7167111moon_2degui3src4math4Vec23new(w, h));
  const _id = _bind._0;
  const _rect = _bind._1;
  const _resp = _bind._2;
  _M0MP49LING7167111moon_2degui3src4core9UIContext19register__focusable(self, _id);
  if (_resp.hovered) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext17set__cursor__icon(self, "pointer");
  }
  const new_state = _resp.clicked ? !checked : checked;
  const box_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(_rect.x, _rect.y + (h - box_size) * 0.5, box_size, box_size);
  const radius = self.style.checkbox_radius * scale;
  if (checked) {
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, box_rect, _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary(), radius);
    const stroke_color = _resp.has_focus ? _M0MP49LING7167111moon_2degui3src5color5Color13border__focus() : _M0MP49LING7167111moon_2degui3src5color5Color15accent__pressed();
    const stroke_w = _resp.has_focus ? 1.5 * scale : 1;
    _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(self.draw_list, box_rect, stroke_color, stroke_w, radius);
    const inner = _M0MP49LING7167111moon_2degui3src4math4Rect6shrink(box_rect, 4 * scale);
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, inner, _M0MP49LING7167111moon_2degui3src5color5Color13text__inverse(), 2 * scale);
  } else {
    const box_bg = _resp.hovered ? _M0MP49LING7167111moon_2degui3src5color5Color10bg__subtle() : _M0MP49LING7167111moon_2degui3src5color5Color10bg__window();
    const box_border = _resp.has_focus ? _M0MP49LING7167111moon_2degui3src5color5Color13border__focus() : _resp.hovered ? _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary() : _M0MP49LING7167111moon_2degui3src5color5Color15border__default();
    const stroke_w = _resp.has_focus ? 1.5 * scale : 1;
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, box_rect, box_bg, radius);
    _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(self.draw_list, box_rect, box_border, stroke_w, radius);
  }
  const text_x = _rect.x + box_size + gap;
  const text_y = _rect.y + (h - font_nm) * 0.5;
  const text_color = _resp.hovered ? _M0MP49LING7167111moon_2degui3src5color5Color13text__primary() : _M0MP49LING7167111moon_2degui3src5color5Color10text__body();
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(text_x, text_y), text, font_nm, text_color);
  return { _0: new_state, _1: _resp };
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext5radio(self, label, selected) {
  const scale = self.style.scale;
  const circle_r = self.style.radio_r * scale;
  const gap = self.style.radio_gap * scale;
  const font_nm = self.style.font_normal * scale;
  const text_size = _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(self, label, font_nm);
  const total_w = circle_r * 2 + gap + text_size.x;
  const total_h = self.style.radio_h * scale;
  const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext15allocate__space(self, _M0MP49LING7167111moon_2degui3src4math4Vec23new(total_w, total_h));
  const _id = _bind._0;
  const _rect = _bind._1;
  const _resp = _bind._2;
  if (_resp.hovered) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext17set__cursor__icon(self, "pointer");
  }
  _M0MP49LING7167111moon_2degui3src4core9UIContext19register__focusable(self, _id);
  const new_selected = _resp.clicked ? true : selected;
  const center = _M0MP49LING7167111moon_2degui3src4math4Vec23new(_rect.x + circle_r + 1 * scale, _rect.y + total_h * 0.5);
  const outer_color = _resp.has_focus || selected ? _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary() : _resp.hovered ? _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary() : _M0MP49LING7167111moon_2degui3src5color5Color15border__default();
  const bg_circle_color = _resp.hovered ? _M0MP49LING7167111moon_2degui3src5color5Color10bg__subtle() : _M0MP49LING7167111moon_2degui3src5color5Color10bg__window();
  _M0MP49LING7167111moon_2degui3src4draw8DrawList11add__circle(self.draw_list, center, circle_r, bg_circle_color);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList19add__circle__stroke(self.draw_list, center, circle_r, outer_color, 1.5 * scale);
  if (selected) {
    _M0MP49LING7167111moon_2degui3src4draw8DrawList11add__circle(self.draw_list, center, circle_r * 0.5, _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary());
  }
  const text_pos = _M0MP49LING7167111moon_2degui3src4math4Vec23new(_rect.x + circle_r * 2 + gap + 1 * scale, _rect.y + (total_h - font_nm) * 0.5);
  const text_color = _resp.hovered ? _M0MP49LING7167111moon_2degui3src5color5Color13text__primary() : _M0MP49LING7167111moon_2degui3src5color5Color10text__body();
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, text_pos, label, font_nm, text_color);
  return { _0: new_selected, _1: _resp };
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext6toggle(self, text, checked) {
  const scale = self.style.scale;
  const font_nm = self.style.font_normal * scale;
  const switch_w = self.style.toggle_w * scale;
  const switch_h = self.style.toggle_h * scale;
  const gap = 8 * scale;
  const text_size = _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(self, text, font_nm);
  const total_w = switch_w + gap + text_size.x;
  const h = 24 * scale;
  const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext15allocate__space(self, _M0MP49LING7167111moon_2degui3src4math4Vec23new(total_w, h));
  const _id = _bind._0;
  const _rect = _bind._1;
  const _resp = _bind._2;
  _M0MP49LING7167111moon_2degui3src4core9UIContext19register__focusable(self, _id);
  if (_resp.hovered) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext17set__cursor__icon(self, "pointer");
  }
  const new_state = _resp.clicked ? !checked : checked;
  const switch_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(_rect.x, _rect.y + (h - switch_h) * 0.5, switch_w, switch_h);
  const bg_color = checked ? (_resp.hovered ? _M0MP49LING7167111moon_2degui3src5color5Color15accent__pressed() : _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary()) : _resp.hovered ? _M0MP49LING7167111moon_2degui3src5color5Color15border__default() : _M0MP49LING7167111moon_2degui3src5color5Color13border__muted();
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, switch_rect, bg_color, switch_h * 0.5);
  if (_resp.has_focus) {
    _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(self.draw_list, switch_rect, _M0MP49LING7167111moon_2degui3src5color5Color13border__focus(), 1.5 * scale, switch_h * 0.5);
  }
  const thumb_radius = (switch_h - 4 * scale) * 0.5;
  const thumb_cx = checked ? switch_rect.x + switch_w - 2 * scale - thumb_radius : switch_rect.x + 2 * scale + thumb_radius;
  const thumb_cy = switch_rect.y + switch_h * 0.5;
  const thumb_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(thumb_cx - thumb_radius, thumb_cy - thumb_radius, thumb_radius * 2, thumb_radius * 2);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, thumb_rect, _M0MP49LING7167111moon_2degui3src5color5Color10bg__window(), thumb_radius);
  const text_x = _rect.x + switch_w + gap;
  const text_y = _rect.y + (h - font_nm) * 0.5;
  const text_color = _resp.hovered ? _M0MP49LING7167111moon_2degui3src5color5Color13text__primary() : _M0MP49LING7167111moon_2degui3src5color5Color10text__body();
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(text_x, text_y), text, font_nm, text_color);
  return { _0: new_state, _1: _resp };
}
function _M0MP49LING7167111moon_2degui3src4core5Toast11new_2einner(id, title, message, kind, duration) {
  return new _M0TP49LING7167111moon_2degui3src4core5Toast(id, title, message, kind, 0, duration);
}
function _M0MP49LING7167111moon_2degui3src4core5Toast12info_2einner(title, message, duration) {
  return _M0MP49LING7167111moon_2degui3src4core5Toast11new_2einner(title, title, message, 0, duration);
}
function _M0MP49LING7167111moon_2degui3src4core5Toast15success_2einner(title, message, duration) {
  return _M0MP49LING7167111moon_2degui3src4core5Toast11new_2einner(title, title, message, 1, duration);
}
function _M0MP49LING7167111moon_2degui3src4core5Toast15warning_2einner(title, message, duration) {
  return _M0MP49LING7167111moon_2degui3src4core5Toast11new_2einner(title, title, message, 2, duration);
}
function _M0MP49LING7167111moon_2degui3src4core5Toast14danger_2einner(title, message, duration) {
  return _M0MP49LING7167111moon_2degui3src4core5Toast11new_2einner(title, title, message, 3, duration);
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext17begin__foreground(self) {
  if (self.foreground) {
    return undefined;
  }
  self.fg_saved_draw_list = self.draw_list;
  _M0MPC15array5Array5clearGRP49LING7167111moon_2degui3src4math4RectE(self.fg_saved_clip_stack);
  const _bind = self.clip_stack;
  const _bind$2 = _bind.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$2) {
      const rect = _bind[_];
      _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(self.fg_saved_clip_stack, rect);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  _M0MPC15array5Array5clearGRP49LING7167111moon_2degui3src4math4RectE(self.clip_stack);
  self.draw_list = self.fg_draw_list;
  self.foreground = true;
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext12block__hover(self, rect) {
  _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(self.blocking_rects, rect);
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext15end__foreground(self) {
  if (!self.foreground) {
    return undefined;
  }
  self.draw_list = self.fg_saved_draw_list;
  _M0MPC15array5Array5clearGRP49LING7167111moon_2degui3src4math4RectE(self.clip_stack);
  const _bind = self.fg_saved_clip_stack;
  const _bind$2 = _bind.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$2) {
      const rect = _bind[_];
      _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(self.clip_stack, rect);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  _M0MPC15array5Array5clearGRP49LING7167111moon_2degui3src4math4RectE(self.fg_saved_clip_stack);
  self.foreground = false;
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext20toast__stack_2einner(self, toasts, anchor, viewport_size) {
  const _p = self.input;
  const dt = _p.dt;
  const next_active = [];
  let dismissed_id = undefined;
  const _bind = toasts.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const toast = toasts[_];
      toast.elapsed = toast.elapsed + dt;
      if (toast.elapsed < toast.duration) {
        _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(next_active, toast);
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  if (next_active.length === 0) {
    return new _M0TP49LING7167111moon_2degui3src4core13ToastResponse([], undefined);
  }
  let vw;
  if (viewport_size === undefined) {
    vw = self.available_width > 0 ? self.available_width : 800;
  } else {
    const _Some = viewport_size;
    const _vp = _Some;
    vw = _vp.x;
  }
  let vh;
  if (viewport_size === undefined) {
    vh = 600;
  } else {
    const _Some = viewport_size;
    const _vp = _Some;
    vh = _vp.y;
  }
  const placed_rects = [];
  switch (anchor) {
    case 1: {
      const x = vw - 280 - 20;
      let cur_bottom = vh - 20;
      const _bind$2 = next_active.length;
      let _tmp$2 = 0;
      while (true) {
        const _ = _tmp$2;
        if (_ < _bind$2) {
          const toast = next_active[_];
          let h;
          const _p$2 = toast.message;
          if (_p$2 === "") {
            h = 38;
          } else {
            h = 54;
          }
          const y = cur_bottom - h;
          _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(placed_rects, _M0MP49LING7167111moon_2degui3src4math4Rect3new(x, y, 280, h));
          cur_bottom = cur_bottom - h - 8;
          _tmp$2 = _ + 1 | 0;
          continue;
        } else {
          break;
        }
      }
      break;
    }
    case 0: {
      const x$2 = vw - 280 - 20;
      let cur_top = 20;
      const _bind$3 = next_active.length;
      let _tmp$3 = 0;
      while (true) {
        const _ = _tmp$3;
        if (_ < _bind$3) {
          const toast = next_active[_];
          let h;
          const _p$2 = toast.message;
          if (_p$2 === "") {
            h = 38;
          } else {
            h = 54;
          }
          const y = cur_top;
          _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(placed_rects, _M0MP49LING7167111moon_2degui3src4math4Rect3new(x$2, y, 280, h));
          cur_top = cur_top + h + 8;
          _tmp$3 = _ + 1 | 0;
          continue;
        } else {
          break;
        }
      }
      break;
    }
    default: {
      const x$3 = (vw - 280) * 0.5;
      let cur_bottom$2 = vh - 20;
      const _bind$4 = next_active.length;
      let _tmp$4 = 0;
      while (true) {
        const _ = _tmp$4;
        if (_ < _bind$4) {
          const toast = next_active[_];
          let h;
          const _p$2 = toast.message;
          if (_p$2 === "") {
            h = 38;
          } else {
            h = 54;
          }
          const y = cur_bottom$2 - h;
          _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(placed_rects, _M0MP49LING7167111moon_2degui3src4math4Rect3new(x$3, y, 280, h));
          cur_bottom$2 = cur_bottom$2 - h - 8;
          _tmp$4 = _ + 1 | 0;
          continue;
        } else {
          break;
        }
      }
    }
  }
  let _tmp$5 = 0;
  while (true) {
    const i = _tmp$5;
    if (i < next_active.length) {
      const rect = _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(placed_rects, i);
      const close_btn_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(rect.x + 280 - 26, rect.y + 6, 20, 20);
      if (_M0MP49LING7167111moon_2degui3src4math4Rect8contains(close_btn_rect, self.input.mouse_pos) && self.input.mouse_pressed) {
        dismissed_id = _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(next_active, i).id;
        break;
      }
      _tmp$5 = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const final_active = [];
  const _bind$5 = next_active.length;
  let _tmp$6 = 0;
  while (true) {
    const _ = _tmp$6;
    if (_ < _bind$5) {
      const toast = next_active[_];
      if (_M0IP016_24default__implPB2Eq10not__equalGOsE(toast.id, dismissed_id)) {
        _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(final_active, toast);
      }
      _tmp$6 = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _bind$6 = placed_rects.length;
  let _tmp$7 = 0;
  while (true) {
    const _ = _tmp$7;
    if (_ < _bind$6) {
      const rect = placed_rects[_];
      _M0MP49LING7167111moon_2degui3src4core9UIContext12block__hover(self, rect);
      if (_M0MP49LING7167111moon_2degui3src4math4Rect8contains(rect, self.input.mouse_pos)) {
        self.wants_capture_mouse = true;
      }
      _tmp$7 = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  _M0MP49LING7167111moon_2degui3src4core9UIContext17begin__foreground(self);
  let _tmp$8 = 0;
  while (true) {
    const i = _tmp$8;
    if (i < final_active.length) {
      const toast = _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(final_active, i);
      const rect = _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(placed_rects, i);
      const scale = self.style.scale;
      const toast_radius = self.style.toast_radius * scale;
      _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Rect3new(rect.x, rect.y + 4 * scale, rect.w, rect.h), _M0MP49LING7167111moon_2degui3src5color5Color15shadow__ambient(), toast_radius);
      _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Rect3new(rect.x, rect.y + 1 * scale, rect.w, rect.h), _M0MP49LING7167111moon_2degui3src5color5Color11shadow__key(), toast_radius);
      _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, rect, _M0MP49LING7167111moon_2degui3src5color5Color10bg__window(), toast_radius);
      _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(self.draw_list, rect, _M0MP49LING7167111moon_2degui3src5color5Color15border__default(), 1, toast_radius);
      const _bind$7 = toast.kind;
      let kind_color;
      switch (_bind$7) {
        case 0: {
          kind_color = _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary();
          break;
        }
        case 1: {
          kind_color = _M0MP49LING7167111moon_2degui3src5color5Color7success();
          break;
        }
        case 2: {
          kind_color = _M0MP49LING7167111moon_2degui3src5color5Color7warning();
          break;
        }
        default: {
          kind_color = _M0MP49LING7167111moon_2degui3src5color5Color6danger();
        }
      }
      _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Rect3new(rect.x, rect.y + 5, 3.5, rect.h - 10), kind_color, 1.5);
      const _p$2 = toast.message;
      const has_detail = !(_p$2 === "");
      const title_y = has_detail ? rect.y + 10 : rect.y + 12;
      _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(rect.x + 16, title_y), toast.title, 12.5, _M0MP49LING7167111moon_2degui3src5color5Color13text__primary());
      if (has_detail) {
        _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(rect.x + 16, rect.y + 29), toast.message, 11, _M0MP49LING7167111moon_2degui3src5color5Color11text__muted());
      }
      const close_hover = _M0MP49LING7167111moon_2degui3src4math4Rect8contains(_M0MP49LING7167111moon_2degui3src4math4Rect3new(rect.x + 280 - 24, rect.y + 6, 18, 18), self.input.mouse_pos);
      const close_col = close_hover ? _M0MP49LING7167111moon_2degui3src5color5Color13text__primary() : _M0MP49LING7167111moon_2degui3src5color5Color14text__disabled();
      _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(rect.x + 280 - 18, rect.y + 9), "x", 11.5, close_col);
      _tmp$8 = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  _M0MP49LING7167111moon_2degui3src4core9UIContext15end__foreground(self);
  return new _M0TP49LING7167111moon_2degui3src4core13ToastResponse(final_active, dismissed_id);
}
function _M0MP49LING7167111moon_2degui3src4core11WidgetStyle7default() {
  return new _M0TP49LING7167111moon_2degui3src4core11WidgetStyle(1, 32, 14, 6, 68, 32, 10, 5, 16, 24, 120, 4, 7, 36, 20, 8, 20, 20, 44, 13, 11, 15, _M0MP49LING7167111moon_2degui3src4math4Vec23new(8, 8), 4, 6, 10, 12, 34, 3, 7, 5, 12, 380, 160, 12, 80, 12.5, 11, 6, 540, 8, 32, 46, 28, 7, 32, 30, 6, 26, 6, 22, 18, 8, 22, 4, 7, 8, 22, 12, 8, 22, 4, 28, 22, 170, 4);
}
function _M0MP49LING7167111moon_2degui3src4core5Theme13studio__light() {
  return new _M0TP49LING7167111moon_2degui3src4core5Theme("studio_light", _M0MP49LING7167111moon_2degui3src5color5Color3hex(16317180), _M0MP49LING7167111moon_2degui3src5color5Color3hex(16777215), _M0MP49LING7167111moon_2degui3src5color5Color3hex(15857145), _M0MP49LING7167111moon_2degui3src5color5Color3hex(16317180), _M0MP49LING7167111moon_2degui3src5color5Color3hex(16317180), _M0MP49LING7167111moon_2degui3src5color5Color3hex(14870768), _M0MP49LING7167111moon_2degui3src5color5Color3hex(1710883), _M0MP49LING7167111moon_2degui3src5color5Color3hex(14870768), _M0MP49LING7167111moon_2degui3src5color5Color3hex(13358561), _M0MP49LING7167111moon_2degui3src5color5Color3hex(9741240), _M0MP49LING7167111moon_2degui3src5color5Color3hex(2450411), _M0MP49LING7167111moon_2degui3src5color5Color3hex(988970), _M0MP49LING7167111moon_2degui3src5color5Color3hex(1976635), _M0MP49LING7167111moon_2degui3src5color5Color3hex(3359061), _M0MP49LING7167111moon_2degui3src5color5Color3hex(4674921), _M0MP49LING7167111moon_2degui3src5color5Color3hex(6583435), _M0MP49LING7167111moon_2degui3src5color5Color3hex(9741240), _M0MP49LING7167111moon_2degui3src5color5Color3hex(16777215), _M0MP49LING7167111moon_2degui3src5color5Color3hex(2450411), _M0MP49LING7167111moon_2degui3src5color5Color3hex(3900150), _M0MP49LING7167111moon_2degui3src5color5Color3hex(1920728), _M0MP49LING7167111moon_2degui3src5color5Color3hex(1981066), _M0MP49LING7167111moon_2degui3src5color5Color4rgba(37, 99, 235, 45), _M0MP49LING7167111moon_2degui3src5color5Color4rgba(255, 255, 255, 140));
}
function _M0MP49LING7167111moon_2degui3src4core5Theme11slate__dark() {
  return new _M0TP49LING7167111moon_2degui3src4core5Theme("slate_dark", _M0MP49LING7167111moon_2degui3src5color5Color3hex(724761), _M0MP49LING7167111moon_2degui3src5color5Color3hex(1120295), _M0MP49LING7167111moon_2degui3src5color5Color3hex(2042167), _M0MP49LING7167111moon_2degui3src5color5Color3hex(1976635), _M0MP49LING7167111moon_2degui3src5color5Color3hex(3621201), _M0MP49LING7167111moon_2degui3src5color5Color3hex(4937059), _M0MP49LING7167111moon_2degui3src5color5Color3hex(16317180), _M0MP49LING7167111moon_2degui3src5color5Color3hex(2042167), _M0MP49LING7167111moon_2degui3src5color5Color3hex(3621201), _M0MP49LING7167111moon_2degui3src5color5Color3hex(4937059), _M0MP49LING7167111moon_2degui3src5color5Color3hex(3900150), _M0MP49LING7167111moon_2degui3src5color5Color3hex(16382715), _M0MP49LING7167111moon_2degui3src5color5Color3hex(16777215), _M0MP49LING7167111moon_2degui3src5color5Color3hex(15067115), _M0MP49LING7167111moon_2degui3src5color5Color3hex(10265519), _M0MP49LING7167111moon_2degui3src5color5Color3hex(7041664), _M0MP49LING7167111moon_2degui3src5color5Color3hex(4937059), _M0MP49LING7167111moon_2degui3src5color5Color3hex(1120295), _M0MP49LING7167111moon_2degui3src5color5Color3hex(3900150), _M0MP49LING7167111moon_2degui3src5color5Color3hex(6333946), _M0MP49LING7167111moon_2degui3src5color5Color3hex(2450411), _M0MP49LING7167111moon_2degui3src5color5Color3hex(1920728), _M0MP49LING7167111moon_2degui3src5color5Color4rgba(59, 130, 246, 50), _M0MP49LING7167111moon_2degui3src5color5Color4rgba(255, 255, 255, 180));
}
function _M0MP49LING7167111moon_2degui3src4core5Theme14high__contrast() {
  return new _M0TP49LING7167111moon_2degui3src4core5Theme("high_contrast", _M0MP49LING7167111moon_2degui3src5color5Color3hex(0), _M0MP49LING7167111moon_2degui3src5color5Color3hex(0), _M0MP49LING7167111moon_2degui3src5color5Color3hex(1184274), _M0MP49LING7167111moon_2degui3src5color5Color3hex(1973790), _M0MP49LING7167111moon_2degui3src5color5Color3hex(3026478), _M0MP49LING7167111moon_2degui3src5color5Color3hex(4473924), _M0MP49LING7167111moon_2degui3src5color5Color3hex(16777215), _M0MP49LING7167111moon_2degui3src5color5Color3hex(5592405), _M0MP49LING7167111moon_2degui3src5color5Color3hex(16777215), _M0MP49LING7167111moon_2degui3src5color5Color3hex(16777215), _M0MP49LING7167111moon_2degui3src5color5Color3hex(16776960), _M0MP49LING7167111moon_2degui3src5color5Color3hex(16777215), _M0MP49LING7167111moon_2degui3src5color5Color3hex(16777215), _M0MP49LING7167111moon_2degui3src5color5Color3hex(15790320), _M0MP49LING7167111moon_2degui3src5color5Color3hex(14540253), _M0MP49LING7167111moon_2degui3src5color5Color3hex(11184810), _M0MP49LING7167111moon_2degui3src5color5Color3hex(7829367), _M0MP49LING7167111moon_2degui3src5color5Color3hex(0), _M0MP49LING7167111moon_2degui3src5color5Color3hex(58879), _M0MP49LING7167111moon_2degui3src5color5Color3hex(8450303), _M0MP49LING7167111moon_2degui3src5color5Color3hex(45311), _M0MP49LING7167111moon_2degui3src5color5Color3hex(33023), _M0MP49LING7167111moon_2degui3src5color5Color4rgba(0, 229, 255, 80), _M0MP49LING7167111moon_2degui3src5color5Color4rgba(255, 255, 255, 220));
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext22get__text__cursor__pos(self, id, max_len) {
  _M0MPC17hashmap7HashMap3setGRP49LING7167111moon_2degui3src4core2IdiE(self.last_active_frame, id, self.frame_counter);
  const _bind = _M0MPC17hashmap7HashMap3getGRP49LING7167111moon_2degui3src4core2IdiE(self.text_cursor_positions, id);
  if (_bind === undefined) {
    return max_len;
  } else {
    const _Some = _bind;
    const _p = _Some;
    return _p > max_len ? max_len : _p < 0 ? 0 : _p;
  }
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext18is__caret__visible(self) {
  const elapsed = self.time - self.last_caret_activity;
  if (elapsed < 0.5) {
    return true;
  } else {
    const half_seconds = _M0MPC16double6Double7to__int((elapsed - 0.5) * 2);
    return (half_seconds % 2 | 0) === 1;
  }
}
function _M0MP49LING7167111moon_2degui3src4core7IdStack3pop(self) {
  if (self.stack.length > 1) {
    _M0MPC15array5Array3popGRP49LING7167111moon_2degui3src4math4RectE(self.stack);
    return;
  } else {
    return;
  }
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext7pop__id(self) {
  _M0MP49LING7167111moon_2degui3src4core7IdStack3pop(self.id_stack);
}
function _M0MP49LING7167111moon_2degui3src4core7IdStack4push(self, str) {
  const parent = _M0MP49LING7167111moon_2degui3src4core7IdStack13current__seed(self);
  const next_id = _M0MP49LING7167111moon_2degui3src4core2Id10with__seed(parent, str).val;
  _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(self.stack, next_id);
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext8push__id(self, salt) {
  _M0MP49LING7167111moon_2degui3src4core7IdStack4push(self.id_stack, salt);
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext22set__text__cursor__pos(self, id, pos) {
  _M0MPC17hashmap7HashMap3setGRP49LING7167111moon_2degui3src4core2IdiE(self.last_active_frame, id, self.frame_counter);
  _M0MPC17hashmap7HashMap3setGRP49LING7167111moon_2degui3src4core2IdiE(self.text_cursor_positions, id, pos);
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext17text__edit__sized(self, id_salt, text, placeholder, size) {
  _M0MP49LING7167111moon_2degui3src4core9UIContext8push__id(self, id_salt);
  const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext15allocate__space(self, size);
  const _id = _bind._0;
  const _rect = _bind._1;
  const _resp = _bind._2;
  _M0MP49LING7167111moon_2degui3src4core9UIContext7pop__id(self);
  _M0MP49LING7167111moon_2degui3src4core9UIContext19register__focusable(self, _id);
  if (_resp.hovered) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext17set__cursor__icon(self, "text");
  }
  const scale = self.style.scale;
  const padding_x = self.style.text_edit_pad_x * scale;
  const font_size = self.style.font_normal * scale;
  const caret_h = self.style.caret_h * scale;
  const radius = self.style.text_edit_radius * scale;
  let cursor_pos = _M0MP49LING7167111moon_2degui3src4core9UIContext22get__text__cursor__pos(self, _id, text.length);
  let current_text = text;
  if (_resp.pressed || _resp.clicked) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext14request__focus(self, _id);
    _M0MP49LING7167111moon_2degui3src4core9UIContext19reset__caret__blink(self);
  }
  if (self.input.mouse_pressed && (_resp.hovered || _resp.pressed)) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext19reset__caret__blink(self);
    const click_x = self.input.mouse_pos.x - (_rect.x + padding_x);
    const total_text_w = _M0FP49LING7167111moon_2degui3src4core19measure__text__size(current_text, font_size).x;
    if (click_x <= 0) {
      cursor_pos = 0;
    } else {
      if (click_x >= total_text_w) {
        cursor_pos = current_text.length;
      } else {
        let best_i = 0;
        let best_dist = click_x;
        let i = 0;
        while (true) {
          if (i <= current_text.length) {
            const sub = _M0FP49LING7167111moon_2degui3src4core13string__slice(current_text, 0, i);
            const w = _M0FP49LING7167111moon_2degui3src4core19measure__text__size(sub, font_size).x;
            const dist = click_x > w ? click_x - w : w - click_x;
            if (dist < best_dist) {
              best_dist = dist;
              best_i = i;
            }
            if (i >= current_text.length) {
              break;
            }
            i = _M0FP49LING7167111moon_2degui3src4core20next__char__boundary(current_text, i);
            continue;
          } else {
            break;
          }
        }
        cursor_pos = best_i;
      }
    }
  }
  const is_focused = _M0MP49LING7167111moon_2degui3src4core9UIContext10has__focus(self, _id);
  if (is_focused) {
    let _tmp;
    if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 6)) {
      _tmp = true;
    } else {
      let _tmp$2;
      if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 7)) {
        _tmp$2 = true;
      } else {
        let _tmp$3;
        if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 10)) {
          _tmp$3 = true;
        } else {
          let _tmp$4;
          if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 11)) {
            _tmp$4 = true;
          } else {
            let _tmp$5;
            if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 0)) {
              _tmp$5 = true;
            } else {
              let _tmp$6;
              if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 1)) {
                _tmp$6 = true;
              } else {
                const _p = self.input;
                const _p$2 = _p.text_input;
                _tmp$6 = !(_p$2 === "");
              }
              _tmp$5 = _tmp$6;
            }
            _tmp$4 = _tmp$5;
          }
          _tmp$3 = _tmp$4;
        }
        _tmp$2 = _tmp$3;
      }
      _tmp = _tmp$2;
    }
    if (_tmp) {
      _M0MP49LING7167111moon_2degui3src4core9UIContext19reset__caret__blink(self);
    }
    if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 6)) {
      cursor_pos = _M0FP49LING7167111moon_2degui3src4core20prev__char__boundary(current_text, cursor_pos);
    }
    if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 7)) {
      cursor_pos = _M0FP49LING7167111moon_2degui3src4core20next__char__boundary(current_text, cursor_pos);
    }
    if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 10)) {
      cursor_pos = 0;
    }
    if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 11)) {
      cursor_pos = current_text.length;
    }
    if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 0)) {
      if (cursor_pos > 0 && current_text.length > 0) {
        const _bind$2 = _M0FP49LING7167111moon_2degui3src4core18delete__prev__char(current_text, cursor_pos);
        const _new_text = _bind$2._0;
        const _new_pos = _bind$2._1;
        current_text = _new_text;
        cursor_pos = _new_pos;
      }
    }
    if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 1)) {
      if (cursor_pos < current_text.length) {
        current_text = _M0FP49LING7167111moon_2degui3src4core18delete__next__char(current_text, cursor_pos);
      }
    }
    const _p = self.input;
    const input_str = _p.text_input;
    if (!(input_str === "")) {
      const left = _M0FP49LING7167111moon_2degui3src4core13string__slice(current_text, 0, cursor_pos);
      const right = _M0FP49LING7167111moon_2degui3src4core13string__slice(current_text, cursor_pos, current_text.length);
      current_text = `${left}${input_str}${right}`;
      cursor_pos = cursor_pos + input_str.length | 0;
    }
  }
  _M0MP49LING7167111moon_2degui3src4core9UIContext22set__text__cursor__pos(self, _id, cursor_pos);
  const bg_color = _M0MP49LING7167111moon_2degui3src5color5Color10bg__window();
  const border_color = is_focused ? _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary() : _resp.hovered ? _M0MP49LING7167111moon_2degui3src5color5Color14border__strong() : _M0MP49LING7167111moon_2degui3src5color5Color15border__default();
  const border_width = is_focused ? 1.5 : 1;
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, _rect, bg_color, radius);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(self.draw_list, _rect, border_color, border_width, radius);
  const inner_clip = _M0MP49LING7167111moon_2degui3src4math4Rect3new(_rect.x + padding_x - 2, _rect.y, _rect.w - (padding_x * 2 - 4), _rect.h);
  _M0MP49LING7167111moon_2degui3src4core9UIContext10push__clip(self, inner_clip);
  const text_y = _rect.y + (_rect.h - font_size) * 0.5;
  const _p = current_text;
  if (_p === "") {
    if (!(placeholder === "")) {
      _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(_rect.x + padding_x, text_y), placeholder, font_size, _M0MP49LING7167111moon_2degui3src5color5Color14text__disabled());
    }
  } else {
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(_rect.x + padding_x, text_y), current_text, font_size, _M0MP49LING7167111moon_2degui3src5color5Color13text__primary());
  }
  if (is_focused && _M0MP49LING7167111moon_2degui3src4core9UIContext18is__caret__visible(self)) {
    const sub = _M0FP49LING7167111moon_2degui3src4core13string__slice(current_text, 0, cursor_pos);
    const measured_prefix = _M0FP49LING7167111moon_2degui3src4core19measure__text__size(sub, font_size);
    const caret_x = _rect.x + padding_x + measured_prefix.x;
    const caret_top = _rect.y + (_rect.h - caret_h) * 0.5;
    const caret_bottom = caret_top + caret_h;
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(caret_x, caret_top), _M0MP49LING7167111moon_2degui3src4math4Vec23new(caret_x, caret_bottom), _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary(), 1.5);
  }
  _M0MP49LING7167111moon_2degui3src4core9UIContext9pop__clip(self);
  return { _0: current_text, _1: _resp };
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext10text__edit(self, id_salt, text, placeholder) {
  const default_w = 200 * self.style.scale;
  const w = self.available_width > default_w ? default_w : self.available_width;
  const h = self.style.text_edit_h * self.style.scale;
  return _M0MP49LING7167111moon_2degui3src4core9UIContext17text__edit__sized(self, id_salt, text, placeholder, _M0MP49LING7167111moon_2degui3src4math4Vec23new(w, h));
}
function _M0MP49LING7167111moon_2degui3src4core11TableColumn11new_2einner(id, title, width, min_width, sortable) {
  return new _M0TP49LING7167111moon_2degui3src4core11TableColumn(id, title, width, min_width, sortable);
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext19get__scroll__offset(self, id) {
  _M0MPC17hashmap7HashMap3setGRP49LING7167111moon_2degui3src4core2IdiE(self.last_active_frame, id, self.frame_counter);
  const _bind = _M0MPC17hashmap7HashMap3getGRP49LING7167111moon_2degui3src4core2IddE(self.scroll_offsets, id);
  if (_bind.$tag === 1) {
    const _Some = _bind;
    return _Some._0;
  } else {
    return 0;
  }
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext21set__available__width(self, width) {
  self.available_width = width;
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext11set__cursor(self, pos) {
  self.cursor = pos;
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext28set__scroll__content__height(self, id, height) {
  _M0MPC17hashmap7HashMap3setGRP49LING7167111moon_2degui3src4core2IdiE(self.last_active_frame, id, self.frame_counter);
  _M0MPC17hashmap7HashMap3setGRP49LING7167111moon_2degui3src4core2IddE(self.scroll_content_heights, id, height);
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext19set__scroll__offset(self, id, offset) {
  _M0MPC17hashmap7HashMap3setGRP49LING7167111moon_2degui3src4core2IdiE(self.last_active_frame, id, self.frame_counter);
  _M0MPC17hashmap7HashMap3setGRP49LING7167111moon_2degui3src4core2IddE(self.scroll_offsets, id, offset);
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext26set__wants__capture__mouse(self, capture) {
  self.wants_capture_mouse = capture;
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext13table_2einner(self, id_salt, size, columns, row_count, render_cell, row_height, header_height, selected_row, sort_column, sort_direction) {
  const scale = self.style.scale;
  const eff_row_h = row_height > 0 ? row_height : self.style.table_row_h * scale;
  const eff_header_h = header_height > 0 ? header_height : self.style.table_header_h * scale;
  const table_radius = self.style.table_radius * scale;
  _M0MP49LING7167111moon_2degui3src4core9UIContext8push__id(self, id_salt);
  const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext15allocate__space(self, size);
  const _table_id = _bind._0;
  const _table_rect = _bind._1;
  _M0MP49LING7167111moon_2degui3src4core9UIContext7pop__id(self);
  let active_sort_col = sort_column;
  let active_sort_dir = sort_direction;
  let sort_changed = false;
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, _table_rect, _M0MP49LING7167111moon_2degui3src5color5Color11bg__surface(), table_radius);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(self.draw_list, _table_rect, _M0MP49LING7167111moon_2degui3src5color5Color15border__default(), 1, table_radius);
  const header_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(_table_rect.x, _table_rect.y, _table_rect.w, eff_header_h);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, header_rect, _M0MP49LING7167111moon_2degui3src5color5Color10bg__subtle(), table_radius);
  const header_bottom_fill = _M0MP49LING7167111moon_2degui3src4math4Rect3new(_table_rect.x, _table_rect.y + eff_header_h - table_radius, _table_rect.w, table_radius);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, header_bottom_fill, _M0MP49LING7167111moon_2degui3src5color5Color10bg__subtle(), 0);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(_table_rect.x, _table_rect.y + eff_header_h), _M0MP49LING7167111moon_2degui3src4math4Vec23new(_table_rect.x + _table_rect.w, _table_rect.y + eff_header_h), _M0MP49LING7167111moon_2degui3src5color5Color15border__default(), 1);
  let current_x = _table_rect.x;
  const total_cols = columns.length;
  let _tmp = 0;
  while (true) {
    const c = _tmp;
    if (c < total_cols) {
      const col = _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(columns, c);
      const col_w = col.width;
      const col_header_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(current_x, _table_rect.y, col_w, eff_header_h);
      const handle_w = 8 * scale;
      const handle_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(current_x + col_w - handle_w * 0.5, _table_rect.y, handle_w, eff_header_h);
      const handle_id = _M0MP49LING7167111moon_2degui3src4core7IdStack10derive__id(self.id_stack, `table_col_handle::${id_salt}::${col.id}`);
      const handle_hovered = _M0MP49LING7167111moon_2degui3src4math4Rect8contains(handle_rect, self.input.mouse_pos);
      if (handle_hovered) {
        _M0MP49LING7167111moon_2degui3src4core9UIContext17set__cursor__icon(self, "col-resize");
      }
      if (handle_hovered && self.input.mouse_pressed) {
        _M0MP49LING7167111moon_2degui3src4core9UIContext15set__active__id(self, handle_id);
      }
      const _p = self.active_id;
      if (BigInt.asUintN(64, _p.val) === BigInt.asUintN(64, handle_id.val)) {
        _M0MP49LING7167111moon_2degui3src4core9UIContext17set__cursor__icon(self, "col-resize");
        _M0MP49LING7167111moon_2degui3src4core9UIContext26set__wants__capture__mouse(self, true);
        if (self.input.mouse_down) {
          const mouse_delta = self.input.mouse_pos.x - current_x;
          const clamped_w = mouse_delta < col.min_width ? col.min_width : mouse_delta;
          col.width = clamped_w;
        }
        if (self.input.mouse_released) {
          _M0MP49LING7167111moon_2degui3src4core9UIContext15set__active__id(self, _M0MP49LING7167111moon_2degui3src4core2Id4zeroN6recordS4226);
        }
      }
      let is_header_hovered;
      if (_M0MP49LING7167111moon_2degui3src4math4Rect8contains(col_header_rect, self.input.mouse_pos)) {
        let _tmp$2;
        if (!handle_hovered) {
          let _tmp$3;
          const _p$2 = self.active_id;
          if (BigInt.asUintN(64, _p$2.val) === BigInt.asUintN(64, _M0MP49LING7167111moon_2degui3src4core2Id4zeroN6recordS4226.val)) {
            _tmp$3 = true;
          } else {
            const _p$3 = self.active_id;
            _tmp$3 = BigInt.asUintN(64, _p$3.val) === BigInt.asUintN(64, _table_id.val);
          }
          _tmp$2 = _tmp$3;
        } else {
          _tmp$2 = false;
        }
        is_header_hovered = _tmp$2;
      } else {
        is_header_hovered = false;
      }
      if (is_header_hovered && col.sortable) {
        _M0MP49LING7167111moon_2degui3src4core9UIContext17set__cursor__icon(self, "pointer");
        if (self.input.mouse_pressed) {
          if (active_sort_col === col.id) {
            const _bind$2 = active_sort_dir;
            let _tmp$2;
            switch (_bind$2) {
              case 0: {
                _tmp$2 = 1;
                break;
              }
              case 1: {
                _tmp$2 = 0;
                break;
              }
              default: {
                _tmp$2 = 0;
              }
            }
            active_sort_dir = _tmp$2;
          } else {
            active_sort_col = col.id;
            active_sort_dir = 0;
          }
          sort_changed = true;
        }
      }
      const font_sz = self.style.font_small * scale;
      const title_pos = _M0MP49LING7167111moon_2degui3src4math4Vec23new(current_x + 10 * scale, _table_rect.y + (eff_header_h - font_sz) * 0.5);
      const title_color = active_sort_col === col.id ? _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary() : is_header_hovered ? _M0MP49LING7167111moon_2degui3src5color5Color12text__strong() : _M0MP49LING7167111moon_2degui3src5color5Color15text__secondary();
      _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, title_pos, col.title, font_sz, title_color);
      if (active_sort_col === col.id) {
        const _bind$2 = active_sort_dir;
        let arrow_str;
        switch (_bind$2) {
          case 0: {
            arrow_str = "^";
            break;
          }
          case 1: {
            arrow_str = "v";
            break;
          }
          default: {
            arrow_str = "";
          }
        }
        const _p$2 = "";
        if (!(arrow_str === _p$2)) {
          const arrow_x = current_x + col.width - 16 * scale;
          const arrow_pos = _M0MP49LING7167111moon_2degui3src4math4Vec23new(arrow_x, title_pos.y);
          _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, arrow_pos, arrow_str, font_sz, _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary());
        }
      }
      if (c < (total_cols - 1 | 0)) {
        const divider_x = current_x + col.width;
        _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(divider_x, _table_rect.y + 6 * scale), _M0MP49LING7167111moon_2degui3src4math4Vec23new(divider_x, _table_rect.y + eff_header_h - 6 * scale), _M0MP49LING7167111moon_2degui3src5color5Color13border__muted(), 1);
      }
      current_x = current_x + col.width;
      _tmp = c + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const body_y = _table_rect.y + eff_header_h;
  const body_h = _table_rect.h - eff_header_h;
  const body_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(_table_rect.x, body_y, _table_rect.w, body_h);
  const body_container_id = _M0MP49LING7167111moon_2degui3src4core7IdStack10derive__id(self.id_stack, `${id_salt}::table_body`);
  let scroll_y = _M0MP49LING7167111moon_2degui3src4core9UIContext19get__scroll__offset(self, body_container_id);
  const total_content_h = (row_count + 0) * eff_row_h;
  const max_scroll = total_content_h > body_h ? total_content_h - body_h : 0;
  if (_M0MP49LING7167111moon_2degui3src4core9UIContext11is__hovered(self, body_rect) && self.input.scroll_delta.y !== 0) {
    scroll_y = scroll_y - self.input.scroll_delta.y;
    _M0MP49LING7167111moon_2degui3src4core9UIContext26set__wants__capture__mouse(self, true);
  }
  if (scroll_y < 0) {
    scroll_y = 0;
  }
  if (scroll_y > max_scroll) {
    scroll_y = max_scroll;
  }
  _M0MP49LING7167111moon_2degui3src4core9UIContext19set__scroll__offset(self, body_container_id, scroll_y);
  _M0MP49LING7167111moon_2degui3src4core9UIContext28set__scroll__content__height(self, body_container_id, total_content_h);
  const start_row_raw = _M0MPC16double6Double7to__int(scroll_y / eff_row_h);
  const start_row = start_row_raw < 0 ? 0 : start_row_raw >= row_count ? row_count : start_row_raw;
  const visible_count = _M0MPC16double6Double7to__int(body_h / eff_row_h) + 2 | 0;
  const end_row = (start_row + visible_count | 0) > row_count ? row_count : start_row + visible_count | 0;
  let hovered_row = undefined;
  let clicked_row = undefined;
  _M0MP49LING7167111moon_2degui3src4core9UIContext10push__clip(self, body_rect);
  let _tmp$2 = start_row;
  while (true) {
    const r = _tmp$2;
    if (r < end_row) {
      const row_y = body_y - scroll_y + (r + 0) * eff_row_h;
      const row_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(body_rect.x, row_y, body_rect.w, eff_row_h);
      const is_row_hovered = _M0MP49LING7167111moon_2degui3src4core9UIContext11is__hovered(self, body_rect) && _M0MP49LING7167111moon_2degui3src4core9UIContext11is__hovered(self, row_rect);
      if (is_row_hovered) {
        hovered_row = r;
        let _tmp$3;
        if (self.input.mouse_pressed) {
          let _tmp$4;
          const _p = self.active_id;
          if (BigInt.asUintN(64, _p.val) === BigInt.asUintN(64, _M0MP49LING7167111moon_2degui3src4core2Id4zeroN6recordS4226.val)) {
            _tmp$4 = true;
          } else {
            const _p$2 = self.active_id;
            _tmp$4 = BigInt.asUintN(64, _p$2.val) === BigInt.asUintN(64, _table_id.val);
          }
          _tmp$3 = _tmp$4;
        } else {
          _tmp$3 = false;
        }
        if (_tmp$3) {
          clicked_row = r;
        }
      }
      if (r === selected_row) {
        _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, row_rect, _M0MP49LING7167111moon_2degui3src5color5Color20table__row__selected(), 0);
      } else {
        if (is_row_hovered) {
          _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, row_rect, _M0MP49LING7167111moon_2degui3src5color5Color9bg__hover(), 0);
        } else {
          if ((r % 2 | 0) === 1) {
            _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, row_rect, _M0MP49LING7167111moon_2degui3src5color5Color10bg__subtle(), 0);
          }
        }
      }
      _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(row_rect.x, row_rect.y + eff_row_h), _M0MP49LING7167111moon_2degui3src4math4Vec23new(row_rect.x + row_rect.w, row_rect.y + eff_row_h), _M0MP49LING7167111moon_2degui3src5color5Color13border__muted(), 1);
      let cell_x = body_rect.x;
      let _tmp$3 = 0;
      while (true) {
        const c = _tmp$3;
        if (c < total_cols) {
          const col = _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(columns, c);
          const cell_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(cell_x, row_y, col.width, eff_row_h);
          const prev_cursor = self.cursor;
          const prev_avail = self.available_width;
          _M0MP49LING7167111moon_2degui3src4core9UIContext11set__cursor(self, _M0MP49LING7167111moon_2degui3src4math4Vec23new(cell_rect.x, cell_rect.y));
          _M0MP49LING7167111moon_2degui3src4core9UIContext21set__available__width(self, cell_rect.w);
          render_cell(self, r, c, cell_rect);
          _M0MP49LING7167111moon_2degui3src4core9UIContext11set__cursor(self, prev_cursor);
          _M0MP49LING7167111moon_2degui3src4core9UIContext21set__available__width(self, prev_avail);
          cell_x = cell_x + col.width;
          _tmp$3 = c + 1 | 0;
          continue;
        } else {
          break;
        }
      }
      _tmp$2 = r + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  _M0MP49LING7167111moon_2degui3src4core9UIContext9pop__clip(self);
  if (max_scroll > 0 && total_content_h > 0) {
    const bar_x = body_rect.x + body_rect.w - 6 - 3;
    const bar_track_y = body_rect.y + 2;
    const bar_track_h = body_rect.h - 4;
    const ratio = body_rect.h / total_content_h;
    const raw_thumb_h = body_rect.h * ratio;
    const thumb_h = raw_thumb_h < 24 ? 24 : raw_thumb_h > bar_track_h ? bar_track_h : raw_thumb_h;
    const scroll_pct = max_scroll > 0.0001 ? scroll_y / max_scroll : 0;
    const thumb_y = bar_track_y + scroll_pct * (bar_track_h - thumb_h);
    const thumb_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(bar_x, thumb_y, 6, thumb_h);
    const is_bar_hovered = _M0MP49LING7167111moon_2degui3src4core9UIContext11is__hovered(self, thumb_rect);
    const thumb_color = is_bar_hovered ? _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary() : _M0MP49LING7167111moon_2degui3src5color5Color13border__muted();
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, thumb_rect, thumb_color, 3);
  }
  return new _M0TP49LING7167111moon_2degui3src4core13TableResponse(sort_changed, active_sort_col, active_sort_dir, hovered_row, clicked_row);
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext25split__horizontal_2einner(self, id_salt, split_ratio, size, left, right, min_ratio, max_ratio, min_px) {
  _M0MP49LING7167111moon_2degui3src4core9UIContext8push__id(self, id_salt);
  const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext15allocate__space(self, size);
  const _container_rect = _bind._1;
  _M0MP49LING7167111moon_2degui3src4core9UIContext7pop__id(self);
  const w = _container_rect.w;
  const h = _container_rect.h;
  const raw_ratio = split_ratio < min_ratio ? min_ratio : split_ratio > max_ratio ? max_ratio : split_ratio;
  if (w <= 0 || h <= 0) {
    return raw_ratio;
  }
  const safe_min_px = min_px * 2 > w ? w * 0.5 : min_px;
  let left_w = w * raw_ratio;
  if (left_w < safe_min_px) {
    left_w = safe_min_px;
  }
  if (w - left_w < safe_min_px) {
    left_w = w - safe_min_px;
  }
  let effective_ratio = left_w / w;
  const bar_x = _container_rect.x + left_w;
  const hit_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(bar_x - 5, _container_rect.y, 10, h);
  const bar_id = _M0MP49LING7167111moon_2degui3src4core7IdStack10derive__id(self.id_stack, `splitter_h::${id_salt}`);
  const hovered = _M0MP49LING7167111moon_2degui3src4math4Rect8contains(hit_rect, self.input.mouse_pos);
  if (hovered) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext17set__cursor__icon(self, "col-resize");
  }
  if (hovered && self.input.mouse_pressed) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext15set__active__id(self, bar_id);
  }
  const _p = self.active_id;
  const is_active = BigInt.asUintN(64, _p.val) === BigInt.asUintN(64, bar_id.val);
  if (is_active) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext26set__wants__capture__mouse(self, true);
    _M0MP49LING7167111moon_2degui3src4core9UIContext17set__cursor__icon(self, "col-resize");
    if (self.input.mouse_down) {
      const mouse_rel_x = self.input.mouse_pos.x - _container_rect.x;
      let clamped_x = mouse_rel_x;
      if (clamped_x < safe_min_px) {
        clamped_x = safe_min_px;
      }
      if (w - clamped_x < safe_min_px) {
        clamped_x = w - safe_min_px;
      }
      effective_ratio = clamped_x / w;
      if (effective_ratio < min_ratio) {
        effective_ratio = min_ratio;
      }
      if (effective_ratio > max_ratio) {
        effective_ratio = max_ratio;
      }
    }
    if (self.input.mouse_released) {
      _M0MP49LING7167111moon_2degui3src4core9UIContext15set__active__id(self, _M0MP49LING7167111moon_2degui3src4core2Id4zeroN6recordS4226);
    }
  }
  left_w = w * effective_ratio;
  const right_w = w - left_w;
  const left_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(_container_rect.x, _container_rect.y, left_w, h);
  const right_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(_container_rect.x + left_w, _container_rect.y, right_w, h);
  const saved_cursor = self.cursor;
  const saved_avail = self.available_width;
  _M0MP49LING7167111moon_2degui3src4core9UIContext10push__clip(self, left_rect);
  _M0MP49LING7167111moon_2degui3src4core9UIContext11set__cursor(self, _M0MP49LING7167111moon_2degui3src4math4Vec23new(left_rect.x, left_rect.y));
  _M0MP49LING7167111moon_2degui3src4core9UIContext21set__available__width(self, left_rect.w);
  left(self, left_rect);
  _M0MP49LING7167111moon_2degui3src4core9UIContext9pop__clip(self);
  _M0MP49LING7167111moon_2degui3src4core9UIContext10push__clip(self, right_rect);
  _M0MP49LING7167111moon_2degui3src4core9UIContext11set__cursor(self, _M0MP49LING7167111moon_2degui3src4math4Vec23new(right_rect.x, right_rect.y));
  _M0MP49LING7167111moon_2degui3src4core9UIContext21set__available__width(self, right_rect.w);
  right(self, right_rect);
  _M0MP49LING7167111moon_2degui3src4core9UIContext9pop__clip(self);
  _M0MP49LING7167111moon_2degui3src4core9UIContext11set__cursor(self, saved_cursor);
  _M0MP49LING7167111moon_2degui3src4core9UIContext21set__available__width(self, saved_avail);
  const divider_x = _container_rect.x + left_w;
  const line_col = is_active || hovered ? _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary() : _M0MP49LING7167111moon_2degui3src5color5Color13border__muted();
  const line_w = is_active || hovered ? 2 : 1;
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(divider_x, _container_rect.y), _M0MP49LING7167111moon_2degui3src4math4Vec23new(divider_x, _container_rect.y + h), line_col, line_w);
  const mid_y = _container_rect.y + h * 0.5;
  const dot_col = is_active || hovered ? _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary() : _M0MP49LING7167111moon_2degui3src5color5Color14border__strong();
  _M0MP49LING7167111moon_2degui3src4draw8DrawList11add__circle(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(divider_x, mid_y - 6), 1.5, dot_col);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList11add__circle(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(divider_x, mid_y), 1.5, dot_col);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList11add__circle(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(divider_x, mid_y + 6), 1.5, dot_col);
  return effective_ratio;
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext15spinner_2einner(self, size, color, stroke_width) {
  const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext15allocate__space(self, _M0MP49LING7167111moon_2degui3src4math4Vec23new(size, size));
  const _rect = _bind._1;
  const _resp = _bind._2;
  const center = _M0MP49LING7167111moon_2degui3src4math4Rect6center(_rect);
  const radius = (size - stroke_width) * 0.5;
  _M0MP49LING7167111moon_2degui3src4draw8DrawList19add__circle__stroke(self.draw_list, center, radius, _M0MP49LING7167111moon_2degui3src5color5Color13border__track(), stroke_width);
  const base_rot = _M0IPC16double6DoublePB3Mod3mod(self.time * 4, 6.2831853071795862);
  const sweep_factor = (_M0FP49LING7167111moon_2degui3src4math3sin(self.time * 2.8) + 1) * 0.5;
  const sweep_len = 0.6 + sweep_factor * 4.2;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < 18) {
      const t1 = (i + 0) / (18 + 0);
      const t2 = ((i + 1 | 0) + 0) / (18 + 0);
      const a1 = base_rot + t1 * sweep_len;
      const a2 = base_rot + t2 * sweep_len;
      const p1 = _M0MP49LING7167111moon_2degui3src4math4Vec23add(center, _M0MP49LING7167111moon_2degui3src4math4Vec211from__polar(radius, a1));
      const p2 = _M0MP49LING7167111moon_2degui3src4math4Vec23add(center, _M0MP49LING7167111moon_2degui3src4math4Vec211from__polar(radius, a2));
      const alpha = _M0MPC16double6Double7to__int(80 + t2 * 175);
      const seg_color = _M0MP49LING7167111moon_2degui3src5color5Color11with__alpha(color, alpha);
      _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(self.draw_list, p1, p2, seg_color, stroke_width);
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return _resp;
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext7spinner(self, size$46$opt, color$46$opt, stroke_width$46$opt) {
  let size;
  if (size$46$opt.$tag === 1) {
    const _Some = size$46$opt;
    size = _Some._0;
  } else {
    size = 20;
  }
  let color;
  if (color$46$opt === undefined) {
    color = _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary();
  } else {
    const _Some = color$46$opt;
    color = _Some;
  }
  let stroke_width;
  if (stroke_width$46$opt.$tag === 1) {
    const _Some = stroke_width$46$opt;
    stroke_width = _Some._0;
  } else {
    stroke_width = 2.5;
  }
  return _M0MP49LING7167111moon_2degui3src4core9UIContext15spinner_2einner(self, size, color, stroke_width);
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext28spinner__with__label_2einner(self, label, size, color, stroke_width) {
  const font_sz = self.style.font_normal;
  const label_sz = _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(self, label, font_sz);
  const total_w = size + 8 + label_sz.x;
  const total_h = size > label_sz.y ? size : label_sz.y;
  const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext15allocate__space(self, _M0MP49LING7167111moon_2degui3src4math4Vec23new(total_w, total_h));
  const _rect = _bind._1;
  const _resp = _bind._2;
  const center = _M0MP49LING7167111moon_2degui3src4math4Vec23new(_rect.x + size * 0.5, _rect.y + _rect.h * 0.5);
  const radius = (size - stroke_width) * 0.5;
  _M0MP49LING7167111moon_2degui3src4draw8DrawList19add__circle__stroke(self.draw_list, center, radius, _M0MP49LING7167111moon_2degui3src5color5Color13border__track(), stroke_width);
  const base_rot = _M0IPC16double6DoublePB3Mod3mod(self.time * 4, 6.2831853071795862);
  const sweep_factor = (_M0FP49LING7167111moon_2degui3src4math3sin(self.time * 2.8) + 1) * 0.5;
  const sweep_len = 0.6 + sweep_factor * 4.2;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < 16) {
      const t1 = (i + 0) / (16 + 0);
      const t2 = ((i + 1 | 0) + 0) / (16 + 0);
      const a1 = base_rot + t1 * sweep_len;
      const a2 = base_rot + t2 * sweep_len;
      const p1 = _M0MP49LING7167111moon_2degui3src4math4Vec23add(center, _M0MP49LING7167111moon_2degui3src4math4Vec211from__polar(radius, a1));
      const p2 = _M0MP49LING7167111moon_2degui3src4math4Vec23add(center, _M0MP49LING7167111moon_2degui3src4math4Vec211from__polar(radius, a2));
      const alpha = _M0MPC16double6Double7to__int(90 + t2 * 165);
      const seg_color = _M0MP49LING7167111moon_2degui3src5color5Color11with__alpha(color, alpha);
      _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(self.draw_list, p1, p2, seg_color, stroke_width);
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const text_pos = _M0MP49LING7167111moon_2degui3src4math4Vec23new(_rect.x + size + 8, _rect.y + (_rect.h - font_sz) * 0.5);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, text_pos, label, font_sz, _M0MP49LING7167111moon_2degui3src5color5Color15text__secondary());
  return _resp;
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext20spinner__with__label(self, label, size$46$opt, color$46$opt, stroke_width$46$opt) {
  let size;
  if (size$46$opt.$tag === 1) {
    const _Some = size$46$opt;
    size = _Some._0;
  } else {
    size = 18;
  }
  let color;
  if (color$46$opt === undefined) {
    color = _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary();
  } else {
    const _Some = color$46$opt;
    color = _Some;
  }
  let stroke_width;
  if (stroke_width$46$opt.$tag === 1) {
    const _Some = stroke_width$46$opt;
    stroke_width = _Some._0;
  } else {
    stroke_width = 2;
  }
  return _M0MP49LING7167111moon_2degui3src4core9UIContext28spinner__with__label_2einner(self, label, size, color, stroke_width);
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext17sparkline_2einner(self, id_salt, values, size, color, fill, show_hover) {
  _M0MP49LING7167111moon_2degui3src4core9UIContext8push__id(self, id_salt);
  const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext15allocate__space(self, size);
  const _rect = _bind._1;
  const _resp = _bind._2;
  _M0MP49LING7167111moon_2degui3src4core9UIContext7pop__id(self);
  const count = values.length;
  const scale = self.style.scale;
  const radius = self.style.radius_sm * scale;
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, _rect, _M0MP49LING7167111moon_2degui3src5color5Color15sparkline__wash(), radius);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(self.draw_list, _rect, _M0MP49LING7167111moon_2degui3src5color5Color13border__muted(), 1, radius);
  if (count === 0) {
    return { _0: undefined, _1: _resp };
  }
  const plot_w = _rect.w - 8;
  const plot_h = _rect.h - 8;
  const base_y = _rect.y + 4 + plot_h;
  if (count === 1) {
    const mid_y = _rect.y + 4 + plot_h * 0.5;
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(_rect.x + 4, mid_y), _M0MP49LING7167111moon_2degui3src4math4Vec23new(_rect.x + 4 + plot_w, mid_y), color, 1.5);
    return { _0: undefined, _1: _resp };
  }
  let min_val = _M0MPC15array5Array2atGdE(values, 0);
  let max_val = _M0MPC15array5Array2atGdE(values, 0);
  const _bind$2 = values.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$2) {
      const v = values[_];
      if (v < min_val) {
        min_val = v;
      }
      if (v > max_val) {
        max_val = v;
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const delta = max_val - min_val;
  const is_flat = delta < 1e-005;
  const points = [];
  const denom = (count - 1 | 0) + 0;
  let _tmp$2 = 0;
  while (true) {
    const i = _tmp$2;
    if (i < count) {
      const px = _rect.x + 4 + (i + 0) / denom * plot_w;
      let py;
      if (is_flat) {
        py = _rect.y + 4 + plot_h * 0.5;
      } else {
        const norm = (_M0MPC15array5Array2atGdE(values, i) - min_val) / delta;
        py = _rect.y + 4 + (1 - norm) * plot_h;
      }
      _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(points, _M0MP49LING7167111moon_2degui3src4math4Vec23new(px, py));
      _tmp$2 = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  if (fill) {
    const fill_col = _M0MP49LING7167111moon_2degui3src5color5Color10area__wash(color);
    let _tmp$3 = 0;
    while (true) {
      const i = _tmp$3;
      if (i < (count - 1 | 0)) {
        const p1 = _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(points, i);
        const p2 = _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(points, i + 1 | 0);
        const slice_w = p2.x - p1.x;
        const avg_y = (p1.y + p2.y) * 0.5;
        const slice_h = base_y - avg_y;
        if (slice_h > 0) {
          _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Rect3new(p1.x, avg_y, slice_w, slice_h), fill_col, 0);
        }
        _tmp$3 = i + 1 | 0;
        continue;
      } else {
        break;
      }
    }
  }
  let _tmp$3 = 0;
  while (true) {
    const i = _tmp$3;
    if (i < (count - 1 | 0)) {
      _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(self.draw_list, _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(points, i), _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(points, i + 1 | 0), color, 1.8);
      _tmp$3 = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  let hovered_idx = undefined;
  if (show_hover && _M0MP49LING7167111moon_2degui3src4core9UIContext11is__hovered(self, _rect)) {
    const mouse_rel = (self.input.mouse_pos.x - (_rect.x + 4)) / plot_w;
    const raw_idx = _M0MPC16double6Double7to__int(mouse_rel * denom + 0.5);
    const snapped_idx = raw_idx < 0 ? 0 : raw_idx >= count ? count - 1 | 0 : raw_idx;
    hovered_idx = snapped_idx;
    const pt = _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(points, snapped_idx);
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(pt.x, _rect.y + 4), _M0MP49LING7167111moon_2degui3src4math4Vec23new(pt.x, base_y), _M0MP49LING7167111moon_2degui3src5color5Color11with__alpha(color, 80), 1);
    _M0MP49LING7167111moon_2degui3src4draw8DrawList11add__circle(self.draw_list, pt, 4 * scale, color);
    _M0MP49LING7167111moon_2degui3src4draw8DrawList11add__circle(self.draw_list, pt, 2 * scale, _M0MP49LING7167111moon_2degui3src5color5Color10bg__window());
  }
  return { _0: hovered_idx, _1: _resp };
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext9sparkline(self, id_salt, values, size$46$opt, color$46$opt, fill$46$opt, show_hover$46$opt) {
  let size;
  if (size$46$opt === undefined) {
    size = _M0MP49LING7167111moon_2degui3src4math4Vec23new(120, 36);
  } else {
    const _Some = size$46$opt;
    size = _Some;
  }
  let color;
  if (color$46$opt === undefined) {
    color = _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary();
  } else {
    const _Some = color$46$opt;
    color = _Some;
  }
  const fill = fill$46$opt === -1 ? true : fill$46$opt;
  const show_hover = show_hover$46$opt === -1 ? true : show_hover$46$opt;
  return _M0MP49LING7167111moon_2degui3src4core9UIContext17sparkline_2einner(self, id_salt, values, size, color, fill, show_hover);
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext6slider(self, label, value, min, max) {
  const scale = self.style.scale;
  const font_size = self.style.font_normal * scale;
  const label_size = _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(self, label, font_size);
  const label_w = label.length > 0 ? label_size.x + 12 * scale : 0;
  const track_w = self.style.slider_track_w * scale;
  const val_w = 42 * scale;
  const total_w = label_w + track_w + val_w + 8 * scale;
  const h = self.style.slider_h * scale;
  const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext15allocate__space(self, _M0MP49LING7167111moon_2degui3src4math4Vec23new(total_w, h));
  const _id = _bind._0;
  const _rect = _bind._1;
  const _resp = _bind._2;
  _M0MP49LING7167111moon_2degui3src4core9UIContext19register__focusable(self, _id);
  const track_h = 6 * scale;
  const track_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(_rect.x + label_w, _rect.y + (h - track_h) * 0.5, track_w, track_h);
  const touch_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(track_rect.x - 4 * scale, _rect.y, track_w + 8 * scale, h);
  const is_hovered = _M0MP49LING7167111moon_2degui3src4core9UIContext11is__hovered(self, touch_rect);
  if (is_hovered && self.input.mouse_pressed) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext15set__active__id(self, _id);
  }
  const _p = self.active_id;
  const is_active = BigInt.asUintN(64, _p.val) === BigInt.asUintN(64, _id.val);
  if (is_hovered || is_active) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext17set__cursor__icon(self, "ew-resize");
  }
  const clamped_min = min < max ? min : max;
  const clamped_max = max > min ? max : min;
  const range = clamped_max - clamped_min;
  const safe_range = range > 1e-006 ? range : 1;
  let new_val = value;
  if (is_active && self.input.mouse_down) {
    const mouse_x = self.input.mouse_pos.x;
    let pct = (mouse_x - track_rect.x) / track_rect.w;
    if (pct < 0) {
      pct = 0;
    } else {
      if (pct > 1) {
        pct = 1;
      }
    }
    new_val = clamped_min + pct * safe_range;
  }
  const is_focused = _resp.has_focus;
  if (is_focused) {
    const step = safe_range >= 100 ? 1 : safe_range >= 10 ? 0.5 : 0.05;
    if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 6) || _M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 9)) {
      new_val = new_val - step;
      if (new_val < clamped_min) {
        new_val = clamped_min;
      }
      _M0MP49LING7167111moon_2degui3src4core10InputState12consume__key(self.input, 6);
      _M0MP49LING7167111moon_2degui3src4core10InputState12consume__key(self.input, 9);
    }
    if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 7) || _M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 8)) {
      new_val = new_val + step;
      if (new_val > clamped_max) {
        new_val = clamped_max;
      }
      _M0MP49LING7167111moon_2degui3src4core10InputState12consume__key(self.input, 7);
      _M0MP49LING7167111moon_2degui3src4core10InputState12consume__key(self.input, 8);
    }
  }
  if (label.length > 0) {
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(_rect.x, _rect.y + (h - 13) * 0.5), label, 13, _M0MP49LING7167111moon_2degui3src5color5Color13text__primary());
  }
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, track_rect, _M0MP49LING7167111moon_2degui3src5color5Color11bg__surface(), 3);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(self.draw_list, track_rect, _M0MP49LING7167111moon_2degui3src5color5Color13border__muted(), 1, 3);
  const tick_col = _M0MP49LING7167111moon_2degui3src5color5Color15border__default();
  const _bind$2 = [0.25, 0.5, 0.75];
  const _bind$3 = _bind$2.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$3) {
      const t = _bind$2[_];
      const tick_x = track_rect.x + track_rect.w * t;
      const tick_y = track_rect.y + track_rect.h * 0.5;
      _M0MP49LING7167111moon_2degui3src4draw8DrawList11add__circle(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(tick_x, tick_y), 1.5, tick_col);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  let current_pct = (new_val - clamped_min) / safe_range;
  if (current_pct < 0) {
    current_pct = 0;
  } else {
    if (current_pct > 1) {
      current_pct = 1;
    }
  }
  const active_w = track_rect.w * current_pct;
  if (active_w > 0) {
    const fill_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(track_rect.x, track_rect.y, active_w, track_rect.h);
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, fill_rect, _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary(), 3);
  }
  let val_text;
  if (safe_range >= 10) {
    val_text = _M0MPC13int3Int18to__string_2einner(_M0MPC16double6Double7to__int(new_val), 10);
  } else {
    const int_part = _M0MPC16double6Double7to__int(new_val);
    const diff = new_val - (int_part + 0);
    const abs_diff = diff < 0 ? -diff : diff;
    const frac_part = _M0MPC16double6Double7to__int(abs_diff * 100);
    const frac_str = frac_part < 10 ? `0${_M0MPC13int3Int18to__string_2einner(frac_part, 10)}` : _M0MPC13int3Int18to__string_2einner(frac_part, 10);
    val_text = `${_M0MPC13int3Int18to__string_2einner(int_part, 10)}.${frac_str}`;
  }
  const thumb_cx = track_rect.x + active_w;
  const thumb_cy = track_rect.y + track_rect.h * 0.5;
  const scale$2 = self.style.scale;
  const font_sm = self.style.font_small * scale$2;
  const radius_sm = self.style.radius_sm * scale$2;
  const thumb_r = is_active ? 7 * scale$2 : is_hovered || is_focused ? 6.5 * scale$2 : 5.5 * scale$2;
  _M0MP49LING7167111moon_2degui3src4draw8DrawList11add__circle(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(thumb_cx, thumb_cy), thumb_r, _M0MP49LING7167111moon_2degui3src5color5Color10bg__window());
  const thumb_stroke = is_focused ? _M0MP49LING7167111moon_2degui3src5color5Color13border__focus() : _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary();
  const thumb_stroke_w = is_focused ? 2 * scale$2 : 1.5;
  _M0MP49LING7167111moon_2degui3src4draw8DrawList19add__circle__stroke(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(thumb_cx, thumb_cy), thumb_r, thumb_stroke, thumb_stroke_w);
  if (is_active) {
    const bubble_size = _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(self, val_text, font_sm);
    const bubble_w = bubble_size.x + 14 * scale$2;
    const bubble_h = 20 * scale$2;
    const bubble_x = thumb_cx - bubble_w * 0.5;
    const bubble_y = thumb_cy - thumb_r - bubble_h - 4 * scale$2;
    const bubble_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(bubble_x, bubble_y, bubble_w, bubble_h);
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, bubble_rect, _M0MP49LING7167111moon_2degui3src5color5Color10bg__window(), radius_sm);
    _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(self.draw_list, bubble_rect, _M0MP49LING7167111moon_2degui3src5color5Color15border__default(), 1, radius_sm);
    const bubble_text_pos = _M0MP49LING7167111moon_2degui3src4math4Vec23new(bubble_x + 7 * scale$2, bubble_y + (bubble_h - font_sm) * 0.5);
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, bubble_text_pos, val_text, font_sm, _M0MP49LING7167111moon_2degui3src5color5Color13text__primary());
  }
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(track_rect.x + track_w + 10, _rect.y + (h - 12) * 0.5), val_text, 12, _M0MP49LING7167111moon_2degui3src5color5Color15text__secondary());
  return { _0: new_val, _1: _resp };
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext11drag__value(self, label, value, speed, min, max) {
  const label_size = _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(self, label, 13);
  const label_w = label.length > 0 ? label_size.x + 8 : 0;
  const total_w = label_w + 64;
  const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext15allocate__space(self, _M0MP49LING7167111moon_2degui3src4math4Vec23new(total_w, 22));
  const _id = _bind._0;
  const _rect = _bind._1;
  const _resp = _bind._2;
  const box_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(_rect.x + label_w, _rect.y, 64, 22);
  const is_hovered = _M0MP49LING7167111moon_2degui3src4core9UIContext11is__hovered(self, box_rect);
  if (is_hovered && self.input.mouse_pressed) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext15set__active__id(self, _id);
  }
  const _p = self.active_id;
  const is_active = BigInt.asUintN(64, _p.val) === BigInt.asUintN(64, _id.val);
  if (is_hovered || is_active) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext17set__cursor__icon(self, "ew-resize");
  }
  let new_val = value;
  if (is_active && self.input.mouse_down) {
    const delta_x = self.input.mouse_delta.x;
    const base_speed = speed > 0.0001 ? speed : 1;
    const multiplier = self.input.modifiers.shift ? 0.1 : self.input.modifiers.ctrl ? 10 : 1;
    const step = base_speed * multiplier;
    new_val = new_val + delta_x * step;
    if (min < max) {
      if (new_val < min) {
        new_val = min;
      } else {
        if (new_val > max) {
          new_val = max;
        }
      }
    }
  }
  if (label.length > 0) {
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(_rect.x, _rect.y + 4.5), label, 13, _M0MP49LING7167111moon_2degui3src5color5Color13text__primary());
  }
  const bg_color = is_active ? _M0MP49LING7167111moon_2degui3src5color5Color11bg__surface() : is_hovered ? _M0MP49LING7167111moon_2degui3src5color5Color10bg__window() : _M0MP49LING7167111moon_2degui3src5color5Color10bg__subtle();
  const border_color = is_active || is_hovered ? _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary() : _M0MP49LING7167111moon_2degui3src5color5Color15border__default();
  const scale = self.style.scale;
  const font_nm = self.style.font_normal * scale;
  const radius_sm = self.style.radius_sm * scale;
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, box_rect, bg_color, radius_sm);
  if (min < max) {
    const range = max - min;
    const pct = (new_val - min) / range;
    const safe_pct = pct < 0 ? 0 : pct > 1 ? 1 : pct;
    const fill_w = box_rect.w * safe_pct;
    if (fill_w > 0) {
      const mercury_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(box_rect.x, box_rect.y, fill_w, box_rect.h);
      _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, mercury_rect, _M0MP49LING7167111moon_2degui3src5color5Color12accent__soft(), radius_sm);
    }
  }
  _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(self.draw_list, box_rect, border_color, 1, radius_sm);
  const rounded_int = _M0MPC16double6Double7to__int(new_val * 10);
  const whole = rounded_int / 10 | 0;
  const _p$2 = rounded_int % 10 | 0;
  const frac = _p$2 < 0 ? -_p$2 | 0 : _p$2;
  const val_str = `${_M0MPC13int3Int18to__string_2einner(whole, 10)}.${_M0MPC13int3Int18to__string_2einner(frac, 10)}`;
  const val_size = _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(self, val_str, font_nm);
  const text_x = box_rect.x + (64 - val_size.x) * 0.5;
  const text_y = box_rect.y + (22 - font_nm) * 0.5;
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(text_x, text_y), val_str, font_nm, is_active ? _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary() : _M0MP49LING7167111moon_2degui3src5color5Color13text__primary());
  return { _0: new_val, _1: _resp };
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext26segmented__control_2einner(self, id_salt, options, selected_index, height, width) {
  const count = options.length;
  if (count === 0) {
    const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext15allocate__space(self, _M0MP49LING7167111moon_2degui3src4math4Vec24zeroN6recordS89);
    const _resp = _bind._2;
    return { _0: selected_index, _1: _resp };
  }
  const scale = self.style.scale;
  const eff_h = height > 0 ? height : self.style.segmented_h * scale;
  const font_sz = self.style.font_normal * scale;
  const pad = self.style.segmented_pad * scale;
  const item_pad_x = self.style.segmented_item_pad_x * scale;
  const track_radius = self.style.segmented_radius * scale;
  const pill_radius = self.style.segmented_pill_radius * scale;
  let item_w;
  if (width > 0) {
    item_w = (width - pad * 2) / (count + 0);
  } else {
    let max_txt_w = 0;
    const _bind = options.length;
    let _tmp = 0;
    while (true) {
      const _ = _tmp;
      if (_ < _bind) {
        const opt = options[_];
        const sz = _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(self, opt, font_sz);
        if (sz.x > max_txt_w) {
          max_txt_w = sz.x;
        }
        _tmp = _ + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    item_w = max_txt_w + item_pad_x * 2;
  }
  const total_w = width > 0 ? width : item_w * (count + 0) + pad * 2;
  _M0MP49LING7167111moon_2degui3src4core9UIContext8push__id(self, id_salt);
  const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext15allocate__space(self, _M0MP49LING7167111moon_2degui3src4math4Vec23new(total_w, eff_h));
  const _id = _bind._0;
  const _track_rect = _bind._1;
  const _resp = _bind._2;
  _M0MP49LING7167111moon_2degui3src4core9UIContext7pop__id(self);
  _M0MP49LING7167111moon_2degui3src4core9UIContext19register__focusable(self, _id);
  let current_sel = selected_index;
  if (current_sel < 0) {
    current_sel = 0;
  } else {
    if (current_sel >= count) {
      current_sel = count - 1 | 0;
    }
  }
  if (_M0MP49LING7167111moon_2degui3src4core9UIContext10has__focus(self, _id)) {
    if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 6)) {
      current_sel = current_sel > 0 ? current_sel - 1 | 0 : count - 1 | 0;
    }
    if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 7)) {
      current_sel = current_sel < (count - 1 | 0) ? current_sel + 1 | 0 : 0;
    }
  }
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, _track_rect, _M0MP49LING7167111moon_2degui3src5color5Color10bg__subtle(), track_radius);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(self.draw_list, _track_rect, _M0MP49LING7167111moon_2degui3src5color5Color13border__muted(), 1, track_radius);
  const pill_h = _track_rect.h - pad * 2;
  const pill_x = _track_rect.x + pad + (current_sel + 0) * item_w;
  const pill_y = _track_rect.y + pad;
  const pill_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(pill_x, pill_y, item_w, pill_h);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Rect3new(pill_x, pill_y + 1 * scale, item_w, pill_h), _M0MP49LING7167111moon_2degui3src5color5Color21pill__ambient__shadow(), pill_radius);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, pill_rect, _M0MP49LING7167111moon_2degui3src5color5Color16pill__active__bg(), pill_radius);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(self.draw_list, pill_rect, _M0MP49LING7167111moon_2degui3src5color5Color20pill__active__border(), 1, pill_radius);
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < count) {
      const opt_x = _track_rect.x + pad + (i + 0) * item_w;
      const opt_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(opt_x, pill_y, item_w, pill_h);
      const is_hovered = _M0MP49LING7167111moon_2degui3src4math4Rect8contains(opt_rect, self.input.mouse_pos);
      if (is_hovered) {
        _M0MP49LING7167111moon_2degui3src4core9UIContext17set__cursor__icon(self, "pointer");
        if (i !== current_sel) {
          _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, opt_rect, _M0MP49LING7167111moon_2degui3src5color5Color11wash__hover(), pill_radius);
        }
        if (self.input.mouse_pressed) {
          current_sel = i;
          _M0MP49LING7167111moon_2degui3src4core9UIContext14request__focus(self, _id);
        }
      }
      const text_col = i === current_sel ? _M0MP49LING7167111moon_2degui3src5color5Color12text__strong() : is_hovered ? _M0MP49LING7167111moon_2degui3src5color5Color13text__primary() : _M0MP49LING7167111moon_2degui3src5color5Color15text__secondary();
      const text_sz = _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(self, _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(options, i), font_sz);
      const text_pos = _M0MP49LING7167111moon_2degui3src4math4Vec23new(opt_x + (item_w - text_sz.x) * 0.5, pill_y + (pill_h - text_sz.y) * 0.5);
      _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, text_pos, _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(options, i), font_sz, text_col);
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return { _0: current_sel, _1: _resp };
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext28get__scroll__content__height(self, id) {
  _M0MPC17hashmap7HashMap3setGRP49LING7167111moon_2degui3src4core2IdiE(self.last_active_frame, id, self.frame_counter);
  const _bind = _M0MPC17hashmap7HashMap3getGRP49LING7167111moon_2degui3src4core2IddE(self.scroll_content_heights, id);
  if (_bind.$tag === 1) {
    const _Some = _bind;
    return _Some._0;
  } else {
    return 0;
  }
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext12scroll__area(self, id_salt, size, content) {
  const container_id = _M0MP49LING7167111moon_2degui3src4core7IdStack10derive__id(self.id_stack, id_salt);
  const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext15allocate__space(self, size);
  const _container_rect = _bind._1;
  if (_M0MP49LING7167111moon_2degui3src4core9UIContext11is__hovered(self, _container_rect)) {
    self.wants_capture_mouse = true;
  }
  let scroll_y = _M0MP49LING7167111moon_2degui3src4core9UIContext19get__scroll__offset(self, container_id);
  const prev_content_h = _M0MP49LING7167111moon_2degui3src4core9UIContext28get__scroll__content__height(self, container_id);
  const max_scroll = prev_content_h > size.y ? prev_content_h - size.y : 0;
  if (_M0MP49LING7167111moon_2degui3src4core9UIContext11is__hovered(self, _container_rect) && self.input.scroll_delta.y !== 0) {
    scroll_y = scroll_y - self.input.scroll_delta.y;
  }
  if (scroll_y < 0) {
    scroll_y = 0;
  }
  if (max_scroll > 0 && scroll_y > max_scroll) {
    scroll_y = max_scroll;
  }
  _M0MP49LING7167111moon_2degui3src4core9UIContext19set__scroll__offset(self, container_id, scroll_y);
  _M0MP49LING7167111moon_2degui3src4core9UIContext10push__clip(self, _container_rect);
  const prev_cursor = self.cursor;
  const prev_avail_w = self.available_width;
  const inner_w = max_scroll > 0 ? size.x - 6 - 4 : size.x;
  self.cursor = _M0MP49LING7167111moon_2degui3src4math4Vec23new(_container_rect.x, _container_rect.y - scroll_y);
  self.available_width = inner_w;
  content(self);
  const measured_content_h = self.cursor.y + scroll_y - _container_rect.y;
  _M0MP49LING7167111moon_2degui3src4core9UIContext28set__scroll__content__height(self, container_id, measured_content_h);
  const real_max_scroll = measured_content_h > size.y ? measured_content_h - size.y : 0;
  if (scroll_y > real_max_scroll) {
    scroll_y = real_max_scroll;
    _M0MP49LING7167111moon_2degui3src4core9UIContext19set__scroll__offset(self, container_id, scroll_y);
  }
  self.cursor = prev_cursor;
  self.available_width = prev_avail_w;
  _M0MP49LING7167111moon_2degui3src4core9UIContext9pop__clip(self);
  if (real_max_scroll > 0 && measured_content_h > 0) {
    const bar_x = _container_rect.x + size.x - 6 - 2;
    const bar_track_y = _container_rect.y;
    const bar_track_h = size.y;
    const ratio = size.y / measured_content_h;
    const raw_thumb_h = size.y * ratio;
    const thumb_h = raw_thumb_h < 24 ? 24 : raw_thumb_h > bar_track_h ? bar_track_h : raw_thumb_h;
    const usable_h = bar_track_h - thumb_h;
    const thumb_id = _M0MP49LING7167111moon_2degui3src4core7IdStack10derive__id(self.id_stack, `${id_salt}::thumb`);
    const track_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(bar_x - 2, bar_track_y, 10, bar_track_h);
    let current_pct = real_max_scroll > 0.0001 ? scroll_y / real_max_scroll : 0;
    const thumb_y = bar_track_y + current_pct * usable_h;
    const thumb_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(bar_x, thumb_y, 6, thumb_h);
    const is_thumb_hovered = _M0MP49LING7167111moon_2degui3src4core9UIContext11is__hovered(self, thumb_rect);
    const is_track_hovered = _M0MP49LING7167111moon_2degui3src4core9UIContext11is__hovered(self, track_rect);
    if ((is_thumb_hovered || is_track_hovered) && self.input.mouse_pressed) {
      _M0MP49LING7167111moon_2degui3src4core9UIContext15set__active__id(self, thumb_id);
    }
    const _p = self.active_id;
    if (BigInt.asUintN(64, _p.val) === BigInt.asUintN(64, thumb_id.val)) {
      _M0MP49LING7167111moon_2degui3src4core9UIContext26set__wants__capture__mouse(self, true);
      if (self.input.mouse_down && usable_h > 0) {
        const rel_mouse_y = self.input.mouse_pos.y - bar_track_y - thumb_h * 0.5;
        let new_pct = rel_mouse_y / usable_h;
        if (new_pct < 0) {
          new_pct = 0;
        }
        if (new_pct > 1) {
          new_pct = 1;
        }
        scroll_y = new_pct * real_max_scroll;
        _M0MP49LING7167111moon_2degui3src4core9UIContext19set__scroll__offset(self, container_id, scroll_y);
        current_pct = new_pct;
      }
      if (self.input.mouse_released) {
        _M0MP49LING7167111moon_2degui3src4core9UIContext15set__active__id(self, _M0MP49LING7167111moon_2degui3src4core2Id4zeroN6recordS4226);
      }
    }
    const active_thumb_y = bar_track_y + current_pct * usable_h;
    const active_thumb_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(bar_x, active_thumb_y, 6, thumb_h);
    let thumb_color;
    let _tmp;
    const _p$2 = self.active_id;
    if (BigInt.asUintN(64, _p$2.val) === BigInt.asUintN(64, thumb_id.val)) {
      _tmp = true;
    } else {
      _tmp = is_thumb_hovered;
    }
    if (_tmp) {
      thumb_color = _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary();
    } else {
      thumb_color = _M0MP49LING7167111moon_2degui3src5color5Color13border__muted();
    }
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, active_thumb_rect, thumb_color, self.style.radius_sm);
    return;
  } else {
    return;
  }
}
function _M0MP49LING7167111moon_2degui3src4core8TextSpan6normal(text) {
  return new _M0TP49LING7167111moon_2degui3src4core8TextSpan(text, _M0DTP49LING7167111moon_2degui3src4core12TextSpanKind6Normal__);
}
function _M0MP49LING7167111moon_2degui3src4core8TextSpan4bold(text) {
  return new _M0TP49LING7167111moon_2degui3src4core8TextSpan(text, _M0DTP49LING7167111moon_2degui3src4core12TextSpanKind4Bold__);
}
function _M0MP49LING7167111moon_2degui3src4core8TextSpan4code(text) {
  return new _M0TP49LING7167111moon_2degui3src4core8TextSpan(text, _M0DTP49LING7167111moon_2degui3src4core12TextSpanKind4Code__);
}
function _M0MP49LING7167111moon_2degui3src4core8TextSpan4link(text, url) {
  return new _M0TP49LING7167111moon_2degui3src4core8TextSpan(text, new _M0DTP49LING7167111moon_2degui3src4core12TextSpanKind4Link(url));
}
function _M0FP49LING7167111moon_2degui3src4core20tokenize__text__span(span) {
  const tokens = [];
  const text = span.text;
  const len = text.length;
  let i = 0;
  while (true) {
    if (i < len) {
      const _tmp = i;
      const ch = _tmp >>> 0 < text.length ? text.charCodeAt(_tmp) : $oob();
      const code = ch;
      if (code === 32 || (code === 9 || code === 10)) {
        if (tokens.length > 0) {
          const last_idx = tokens.length - 1 | 0;
          const last = _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(tokens, last_idx);
          _M0MPC15array5Array3setGRP49LING7167111moon_2degui3src4core9RichTokenE(tokens, last_idx, new _M0TP49LING7167111moon_2degui3src4core9RichToken(last.text, last.kind, last.is_cjk, true));
        }
        i = i + 1 | 0;
      } else {
        if (_M0FP49LING7167111moon_2degui3src4core13is__cjk__char(code)) {
          const char_end = _M0FP49LING7167111moon_2degui3src4core20next__char__boundary(text, i);
          const char_str = _M0FP49LING7167111moon_2degui3src4core13string__slice(text, i, char_end);
          _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(tokens, new _M0TP49LING7167111moon_2degui3src4core9RichToken(char_str, span.kind, true, false));
          i = char_end;
        } else {
          const word_start = i;
          while (true) {
            if (i < len) {
              const _tmp$2 = i;
              const cur_ch = _tmp$2 >>> 0 < text.length ? text.charCodeAt(_tmp$2) : $oob();
              const cur_code = cur_ch;
              if (cur_code === 32 || (cur_code === 9 || (cur_code === 10 || _M0FP49LING7167111moon_2degui3src4core13is__cjk__char(cur_code)))) {
                break;
              }
              i = _M0FP49LING7167111moon_2degui3src4core20next__char__boundary(text, i);
              continue;
            } else {
              break;
            }
          }
          const word_str = _M0FP49LING7167111moon_2degui3src4core13string__slice(text, word_start, i);
          if (word_str.length > 0) {
            _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(tokens, new _M0TP49LING7167111moon_2degui3src4core9RichToken(word_str, span.kind, false, false));
          }
        }
      }
      continue;
    } else {
      break;
    }
  }
  return tokens;
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext18rich__text_2einner(self, id_salt, spans, wrap_width) {
  const font_sz = self.style.font_normal * self.style.scale;
  const line_h = self.style.rich_text_line_h * self.style.scale;
  const max_w = wrap_width > 0 ? wrap_width : self.available_width;
  const space_w = _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(self, " ", font_sz).x;
  let current_x = 0;
  let current_line = 0;
  let measured_max_w = 0;
  const layout_items = [];
  const _bind = spans.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const span = spans[_];
      const tokens = _M0FP49LING7167111moon_2degui3src4core20tokenize__text__span(span);
      const _bind$2 = tokens.length;
      let _tmp$2 = 0;
      while (true) {
        const _$2 = _tmp$2;
        if (_$2 < _bind$2) {
          const token = tokens[_$2];
          const sz = _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(self, token.text, font_sz);
          const token_w = sz.x + (_M0IP49LING7167111moon_2degui3src4core12TextSpanKindPB2Eq5equal(token.kind, _M0DTP49LING7167111moon_2degui3src4core12TextSpanKind4Code__) ? 6 * self.style.scale : 0);
          const trailing_w = token.has_trailing_space ? space_w : 0;
          let is_closing;
          if (token.is_cjk) {
            let _tmp$3;
            if (token.text.length > 0) {
              const _tmp$4 = token.text;
              _tmp$3 = _M0FP49LING7167111moon_2degui3src4core23is__cjk__closing__punct(0 >>> 0 < _tmp$4.length ? _tmp$4.charCodeAt(0) : $oob());
            } else {
              _tmp$3 = false;
            }
            is_closing = _tmp$3;
          } else {
            is_closing = false;
          }
          if (current_x + token_w > max_w && (current_x > 0 && !is_closing)) {
            current_line = current_line + 1 | 0;
            current_x = 0;
          }
          const rel_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(current_x, (current_line + 0) * line_h, token_w, line_h);
          _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(layout_items, { _0: token.text, _1: token.kind, _2: rel_rect });
          current_x = current_x + token_w + trailing_w;
          if (current_x > measured_max_w) {
            measured_max_w = current_x;
          }
          _tmp$2 = _$2 + 1 | 0;
          continue;
        } else {
          break;
        }
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const total_h = ((current_line + 1 | 0) + 0) * line_h;
  const total_w = wrap_width > 0 ? wrap_width : measured_max_w;
  _M0MP49LING7167111moon_2degui3src4core9UIContext8push__id(self, id_salt);
  const _bind$2 = _M0MP49LING7167111moon_2degui3src4core9UIContext15allocate__space(self, _M0MP49LING7167111moon_2degui3src4math4Vec23new(total_w, total_h));
  const _container_rect = _bind$2._1;
  const _resp = _bind$2._2;
  _M0MP49LING7167111moon_2degui3src4core9UIContext7pop__id(self);
  let clicked_url = undefined;
  const _bind$3 = layout_items.length;
  let _tmp$2 = 0;
  while (true) {
    const _ = _tmp$2;
    if (_ < _bind$3) {
      const item = layout_items[_];
      const _text = item._0;
      const _kind = item._1;
      const _rel = item._2;
      const abs_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(_container_rect.x + _rel.x, _container_rect.y + _rel.y, _rel.w, _rel.h);
      const is_hovered = _M0MP49LING7167111moon_2degui3src4math4Rect8contains(abs_rect, self.input.mouse_pos);
      if (is_hovered) {
        if (_kind.$tag === 3) {
        } else {
          _M0MP49LING7167111moon_2degui3src4core9UIContext17set__cursor__icon(self, "text");
        }
      }
      switch (_kind.$tag) {
        case 0: {
          const text_pos = _M0MP49LING7167111moon_2degui3src4math4Vec23new(abs_rect.x, abs_rect.y + (line_h - font_sz) * 0.5);
          _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, text_pos, _text, font_sz, _M0MP49LING7167111moon_2degui3src5color5Color10text__body());
          break;
        }
        case 1: {
          const text_pos$2 = _M0MP49LING7167111moon_2degui3src4math4Vec23new(abs_rect.x, abs_rect.y + (line_h - font_sz) * 0.5);
          _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, text_pos$2, _text, font_sz, _M0MP49LING7167111moon_2degui3src5color5Color12text__strong());
          break;
        }
        case 2: {
          const code_bg_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(abs_rect.x, abs_rect.y + 2, abs_rect.w, line_h - 4);
          const code_radius = self.style.radius_sm;
          _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, code_bg_rect, _M0MP49LING7167111moon_2degui3src5color5Color10bg__subtle(), code_radius);
          _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(self.draw_list, code_bg_rect, _M0MP49LING7167111moon_2degui3src5color5Color13border__muted(), 1, code_radius);
          const text_pos$3 = _M0MP49LING7167111moon_2degui3src4math4Vec23new(abs_rect.x + 3, abs_rect.y + (line_h - font_sz) * 0.5);
          _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, text_pos$3, _text, font_sz, _M0MP49LING7167111moon_2degui3src5color5Color12accent__deep());
          break;
        }
        default: {
          const _Link = _kind;
          const _url = _Link._0;
          if (is_hovered) {
            _M0MP49LING7167111moon_2degui3src4core9UIContext17set__cursor__icon(self, "pointer");
            if (self.input.mouse_pressed) {
              clicked_url = _url;
            }
          }
          const link_col = is_hovered ? _M0MP49LING7167111moon_2degui3src5color5Color13accent__hover() : _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary();
          const text_pos$4 = _M0MP49LING7167111moon_2degui3src4math4Vec23new(abs_rect.x, abs_rect.y + (line_h - font_sz) * 0.5);
          _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, text_pos$4, _text, font_sz, link_col);
          if (is_hovered) {
            const line_y = abs_rect.y + line_h - 3;
            _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(abs_rect.x, line_y), _M0MP49LING7167111moon_2degui3src4math4Vec23new(abs_rect.x + abs_rect.w, line_y), link_col, 1);
          }
        }
      }
      _tmp$2 = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return new _M0TP49LING7167111moon_2degui3src4core16RichTextResponse(clicked_url, _resp);
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext9hyperlink(self, text, _url) {
  const font_sz = self.style.font_normal;
  const text_sz = _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(self, text, font_sz);
  const w = text_sz.x;
  const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext15allocate__space(self, _M0MP49LING7167111moon_2degui3src4math4Vec23new(w, 20));
  const _rect = _bind._1;
  const _resp = _bind._2;
  const is_hovered = _M0MP49LING7167111moon_2degui3src4core9UIContext11is__hovered(self, _rect);
  if (is_hovered) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext17set__cursor__icon(self, "pointer");
  }
  const link_col = is_hovered ? _M0MP49LING7167111moon_2degui3src5color5Color13accent__hover() : _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary();
  const text_pos = _M0MP49LING7167111moon_2degui3src4math4Vec23new(_rect.x, _rect.y + (20 - font_sz) * 0.5);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, text_pos, text, font_sz, link_col);
  if (is_hovered) {
    const line_y = _rect.y + 20 - 2;
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(_rect.x, line_y), _M0MP49LING7167111moon_2degui3src4math4Vec23new(_rect.x + w, line_y), link_col, 1);
  }
  const clicked = is_hovered && self.input.mouse_pressed;
  return { _0: clicked, _1: _resp };
}
function _M0MP49LING7167111moon_2degui3src4core8Response11new_2einner(id, rect, hovered, clicked, pressed, dragged, secondary_clicked) {
  return new _M0TP49LING7167111moon_2degui3src4core8Response(id, rect, hovered, clicked, pressed, dragged, false, false, false, secondary_clicked);
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext10horizontal(self, content) {
  const start_x = self.cursor.x;
  const start_y = self.cursor.y;
  const scope = new _M0TP49LING7167111moon_2degui3src4core11LayoutScope(1, start_x, start_y, 0, 0, 0);
  _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(self.layout_stack, scope);
  content(self);
  const popped = _M0MPC15array5Array3popGRP49LING7167111moon_2degui3src4math4RectE(self.layout_stack);
  let max_h;
  if (popped === undefined) {
    max_h = 0;
  } else {
    const _Some = popped;
    const _s = _Some;
    max_h = _s.max_cross_size;
  }
  self.cursor = _M0MP49LING7167111moon_2degui3src4math4Vec23new(start_x, start_y + max_h + self.item_spacing.y);
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext9menu__bar(self, content) {
  const scale = self.style.scale;
  const bar_h = self.style.menu_bar_h * scale;
  const bar_w = self.available_width;
  const bar_pos = self.cursor;
  const bar_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(bar_pos.x, bar_pos.y, bar_w, bar_h);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, bar_rect, _M0MP49LING7167111moon_2degui3src5color5Color11bg__surface(), 0);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(bar_rect.x, bar_rect.y + bar_h), _M0MP49LING7167111moon_2degui3src4math4Vec23new(bar_rect.x + bar_w, bar_rect.y + bar_h), _M0MP49LING7167111moon_2degui3src5color5Color13border__muted(), 1);
  const prev_cursor = self.cursor;
  const prev_avail_w = self.available_width;
  const prev_spacing = self.item_spacing;
  self.cursor = _M0MP49LING7167111moon_2degui3src4math4Vec23new(bar_pos.x + 8 * scale, bar_pos.y + 3 * scale);
  self.available_width = bar_w - 16 * scale;
  self.item_spacing = _M0MP49LING7167111moon_2degui3src4math4Vec23new(4 * scale, 0);
  _M0MP49LING7167111moon_2degui3src4core9UIContext10horizontal(self, content);
  self.cursor = _M0MP49LING7167111moon_2degui3src4math4Vec23new(prev_cursor.x, bar_pos.y + bar_h);
  self.available_width = prev_avail_w;
  self.item_spacing = prev_spacing;
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext19set__open__menu__id(self, id) {
  self.open_menu_id = id;
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext8vertical(self, content) {
  const start_x = self.cursor.x;
  const start_y = self.cursor.y;
  const scope = new _M0TP49LING7167111moon_2degui3src4core11LayoutScope(0, start_x, start_y, 0, 0, 0);
  _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(self.layout_stack, scope);
  content(self);
  _M0MPC15array5Array3popGRP49LING7167111moon_2degui3src4math4RectE(self.layout_stack);
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext4menu(self, title, content) {
  const scale = self.style.scale;
  const font_nm = self.style.font_normal * scale;
  const menu_id = _M0MP49LING7167111moon_2degui3src4core7IdStack10derive__id(self.id_stack, `menu::${title}`);
  const text_size = _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(self, title, font_nm);
  const btn_w = text_size.x + 16 * scale;
  const btn_h = self.style.menu_bar_btn_h * scale;
  _M0MP49LING7167111moon_2degui3src4core9UIContext8push__id(self, title);
  const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext15allocate__space(self, _M0MP49LING7167111moon_2degui3src4math4Vec23new(btn_w, btn_h));
  const _btn_rect = _bind._1;
  _M0MP49LING7167111moon_2degui3src4core9UIContext7pop__id(self);
  const _p = self.open_menu_id;
  const is_open = BigInt.asUintN(64, _p.val) === BigInt.asUintN(64, menu_id.val);
  const hovered = _M0MP49LING7167111moon_2degui3src4core9UIContext11is__hovered(self, _btn_rect);
  if (hovered) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext17set__cursor__icon(self, "pointer");
  }
  if (_M0IP016_24default__implPB2Eq10not__equalGRP49LING7167111moon_2degui3src4core2IdE(self.open_menu_id, _M0MP49LING7167111moon_2degui3src4core2Id4zeroN6recordS4226) && (_M0IP016_24default__implPB2Eq10not__equalGRP49LING7167111moon_2degui3src4core2IdE(self.open_menu_id, menu_id) && hovered)) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext19set__open__menu__id(self, menu_id);
  } else {
    if (hovered && self.input.mouse_pressed) {
      if (is_open) {
        _M0MP49LING7167111moon_2degui3src4core9UIContext19set__open__menu__id(self, _M0MP49LING7167111moon_2degui3src4core2Id4zeroN6recordS4226);
      } else {
        _M0MP49LING7167111moon_2degui3src4core9UIContext19set__open__menu__id(self, menu_id);
      }
    }
  }
  const _p$2 = self.open_menu_id;
  const currently_open = BigInt.asUintN(64, _p$2.val) === BigInt.asUintN(64, menu_id.val);
  const btn_bg = currently_open ? _M0MP49LING7167111moon_2degui3src5color5Color10bg__active() : hovered ? _M0MP49LING7167111moon_2degui3src5color5Color10bg__subtle() : _M0MP49LING7167111moon_2degui3src5color5Color11transparentN6recordS35;
  const btn_text_col = currently_open ? _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary() : hovered ? _M0MP49LING7167111moon_2degui3src5color5Color13text__primary() : _M0MP49LING7167111moon_2degui3src5color5Color10text__body();
  const radius = self.style.menu_bar_radius * scale;
  if (currently_open || hovered) {
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, _btn_rect, btn_bg, radius);
  }
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(_btn_rect.x + 8 * scale, _btn_rect.y + (btn_h - font_nm) * 0.5), title, font_nm, btn_text_col);
  if (currently_open) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext17begin__foreground(self);
    const pad = 4 * scale;
    const popup_w = self.style.menu_bar_popup_w * scale;
    let popup_x = _btn_rect.x;
    const popup_y = _btn_rect.y + _btn_rect.h + 3 * scale;
    if (popup_x + popup_w > self.available_width) {
      const clamped = self.available_width - popup_w - 4 * scale;
      if (clamped > 4 * scale) {
        popup_x = clamped;
      }
    }
    const prev_cursor = self.cursor;
    const prev_avail_w = self.available_width;
    const prev_spacing = self.item_spacing;
    self.cursor = _M0MP49LING7167111moon_2degui3src4math4Vec23new(popup_x + pad, popup_y + pad);
    self.available_width = popup_w - pad * 2;
    self.item_spacing = _M0MP49LING7167111moon_2degui3src4math4Vec23new(0, 2 * scale);
    const item_draw_list = _M0MP49LING7167111moon_2degui3src4draw8DrawList3new();
    const saved_dl = self.draw_list;
    self.draw_list = item_draw_list;
    _M0MP49LING7167111moon_2degui3src4core9UIContext8vertical(self, content);
    self.draw_list = saved_dl;
    const content_h = self.cursor.y - (popup_y + pad);
    const total_h = content_h > 0 ? content_h + pad : 24;
    const menu_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(popup_x, popup_y, popup_w, total_h);
    _M0MP49LING7167111moon_2degui3src4core9UIContext12block__hover(self, menu_rect);
    if (self.input.mouse_pressed && (!_M0MP49LING7167111moon_2degui3src4core9UIContext11is__hovered(self, menu_rect) && !hovered)) {
      _M0MP49LING7167111moon_2degui3src4core9UIContext19set__open__menu__id(self, _M0MP49LING7167111moon_2degui3src4core2Id4zeroN6recordS4226);
    }
    const shadow_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(menu_rect.x, menu_rect.y + 2, menu_rect.w, menu_rect.h);
    const menu_radius = self.style.radius_md;
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, shadow_rect, _M0MP49LING7167111moon_2degui3src5color5Color15shadow__ambient(), menu_radius);
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, menu_rect, _M0MP49LING7167111moon_2degui3src5color5Color10bg__window(), menu_radius);
    _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(self.draw_list, menu_rect, _M0MP49LING7167111moon_2degui3src5color5Color15border__default(), 1, menu_radius);
    _M0MP49LING7167111moon_2degui3src4draw8DrawList6append(self.draw_list, item_draw_list);
    self.cursor = prev_cursor;
    self.available_width = prev_avail_w;
    self.item_spacing = prev_spacing;
    _M0MP49LING7167111moon_2degui3src4core9UIContext15end__foreground(self);
    return;
  } else {
    return;
  }
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext18menu__item_2einner(self, label, shortcut, disabled) {
  const scale = self.style.scale;
  const item_h = 24 * scale;
  const item_w = self.available_width;
  _M0MP49LING7167111moon_2degui3src4core9UIContext8push__id(self, label);
  const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext15allocate__space(self, _M0MP49LING7167111moon_2degui3src4math4Vec23new(item_w, item_h));
  const _id = _bind._0;
  const _rect = _bind._1;
  const _resp = _bind._2;
  _M0MP49LING7167111moon_2degui3src4core9UIContext7pop__id(self);
  const is_hovered = _M0MP49LING7167111moon_2degui3src4core9UIContext11is__hovered(self, _rect) && !disabled;
  const item_radius = self.style.radius_sm * scale;
  const font_nm = self.style.font_normal * scale;
  const font_sm = self.style.font_small * scale;
  if (is_hovered) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext17set__cursor__icon(self, "pointer");
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, _rect, _M0MP49LING7167111moon_2degui3src5color5Color11bg__surface(), item_radius);
  }
  const clicked = disabled ? false : is_hovered && (self.input.mouse_pressed || _resp.clicked);
  if (clicked) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext19set__open__menu__id(self, _M0MP49LING7167111moon_2degui3src4core2Id4zeroN6recordS4226);
  }
  const text_col = disabled ? _M0MP49LING7167111moon_2degui3src5color5Color14text__disabled() : is_hovered ? _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary() : _M0MP49LING7167111moon_2degui3src5color5Color13text__primary();
  const text_y = _rect.y + (item_h - font_nm) * 0.5;
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(_rect.x + 8 * scale, text_y), label, font_nm, text_col);
  if (!(shortcut === "")) {
    const sc_size = _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(self, shortcut, font_sm);
    const sc_x = _rect.x + item_w - sc_size.x - 8 * scale;
    const sc_y = _rect.y + (item_h - font_sm) * 0.5;
    const sc_col = disabled ? _M0MP49LING7167111moon_2degui3src5color5Color14text__disabled() : is_hovered ? _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary() : _M0MP49LING7167111moon_2degui3src5color5Color11text__muted();
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(sc_x, sc_y), shortcut, font_sm, sc_col);
  }
  return _M0MP49LING7167111moon_2degui3src4core8Response11new_2einner(_id, _rect, is_hovered, clicked, _resp.pressed, false, false);
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext15menu__separator(self) {
  const item_w = self.available_width;
  const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext15allocate__space(self, _M0MP49LING7167111moon_2degui3src4math4Vec23new(item_w, 7));
  const _rect = _bind._1;
  const line_y = _rect.y + 3;
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(_rect.x + 4, line_y), _M0MP49LING7167111moon_2degui3src4math4Vec23new(_rect.x + item_w - 4, line_y), _M0MP49LING7167111moon_2degui3src5color5Color13border__muted(), 1);
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext14label__colored(self, text, color) {
  const font_sz = self.style.font_normal * self.style.scale;
  const text_size = _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(self, text, font_sz);
  const w = text_size.x > 20 ? text_size.x : 20;
  const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext15allocate__space(self, _M0MP49LING7167111moon_2degui3src4math4Vec23new(w, 18));
  const _rect = _bind._1;
  const _resp = _bind._2;
  const text_pos = _M0MP49LING7167111moon_2degui3src4math4Vec23new(_rect.x, _rect.y + (18 - font_sz) * 0.5);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, text_pos, text, font_sz, color);
  return _resp;
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext5label(self, text) {
  return _M0MP49LING7167111moon_2degui3src4core9UIContext14label__colored(self, text, _M0MP49LING7167111moon_2degui3src5color5Color13text__primary());
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext9separator(self) {
  const w = self.available_width;
  const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext15allocate__space(self, _M0MP49LING7167111moon_2degui3src4math4Vec23new(w, 9));
  const _rect = _bind._1;
  const y = _rect.y + 4.5;
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(_rect.x, y), _M0MP49LING7167111moon_2degui3src4math4Vec23new(_rect.x + _rect.w, y), _M0MP49LING7167111moon_2degui3src5color5Color13border__muted(), 1);
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext15advance__cursor(self, offset) {
  self.cursor = _M0MP49LING7167111moon_2degui3src4math4Vec23add(self.cursor, offset);
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(self, amount) {
  let is_horiz;
  const _p = self.layout_stack;
  if (_p.length === 0) {
    is_horiz = false;
  } else {
    is_horiz = _M0IP49LING7167111moon_2degui3src4core15LayoutDirectionPB2Eq5equal(_M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(self.layout_stack, self.layout_stack.length - 1 | 0).dir, 1);
  }
  if (is_horiz) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext15advance__cursor(self, _M0MP49LING7167111moon_2degui3src4math4Vec23new(amount, 0));
    return;
  } else {
    _M0MP49LING7167111moon_2degui3src4core9UIContext15advance__cursor(self, _M0MP49LING7167111moon_2degui3src4math4Vec23new(0, amount));
    return;
  }
}
function _M0FP49LING7167111moon_2degui3src4core9draw__arc(dl, center, radius, start_angle, end_angle, color, width, segments) {
  const sweep = end_angle - start_angle;
  if (Math.abs(sweep) < 0.001 || segments <= 0) {
    return undefined;
  }
  const step = sweep / (segments + 0);
  let prev_p = _M0MP49LING7167111moon_2degui3src4math4Vec23add(center, _M0MP49LING7167111moon_2degui3src4math4Vec211from__polar(radius, start_angle));
  let _tmp = 1;
  while (true) {
    const i = _tmp;
    if (i <= segments) {
      const a = start_angle + step * (i + 0);
      const cur_p = _M0MP49LING7167111moon_2degui3src4math4Vec23add(center, _M0MP49LING7167111moon_2degui3src4math4Vec211from__polar(radius, a));
      _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(dl, prev_p, cur_p, color, width);
      prev_p = cur_p;
      _tmp = i + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext12knob_2einner(self, id_salt, label, value, min_val, max_val, step, default_val, unit, radius, bipolar) {
  const range = max_val > min_val ? max_val - min_val : 1;
  const clamped_initial = value < min_val ? min_val : value > max_val ? max_val : value;
  const diameter = radius * 2;
  const label_h = label === "" ? 0 : 15;
  const total_w = diameter + 16;
  const total_h = diameter + label_h + 16 + 8;
  const id = _M0MP49LING7167111moon_2degui3src4core7IdStack10derive__id(self.id_stack, `knob::${id_salt}`);
  const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext15allocate__space(self, _M0MP49LING7167111moon_2degui3src4math4Vec23new(total_w, total_h));
  const _rect = _bind._1;
  const _response = _bind._2;
  _M0MP49LING7167111moon_2degui3src4core9UIContext19register__focusable(self, id);
  if (_response.pressed || _response.clicked) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext14request__focus(self, id);
  }
  if (_response.hovered || (_response.dragged || _response.pressed)) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext17set__cursor__icon(self, "ns-resize");
  }
  const is_focused = _M0MP49LING7167111moon_2degui3src4core9UIContext10has__focus(self, id);
  let current_val = clamped_initial;
  if (!self.input.modifiers.alt && (_response.dragged || _response.pressed && self.input.mouse_down)) {
    const dy = -self.input.mouse_delta.y;
    const dx = self.input.mouse_delta.x;
    const delta = dy + dx;
    const sensitivity = self.input.modifiers.shift ? 0.001 : 0.005;
    current_val = current_val + delta * range * sensitivity;
  }
  if (_response.hovered && Math.abs(self.input.scroll_delta.y) > 0) {
    const dir = self.input.scroll_delta.y > 0 ? 1 : -1;
    current_val = current_val + dir * step;
  }
  if (is_focused) {
    if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 8) || _M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 7)) {
      current_val = current_val + step;
    }
    if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 9) || _M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 6)) {
      current_val = current_val - step;
    }
    if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 10)) {
      current_val = min_val;
    }
    if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 11)) {
      current_val = max_val;
    }
    if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 0) || _M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 1)) {
      current_val = default_val;
    }
  }
  if ((_response.pressed || _response.clicked) && self.input.modifiers.alt) {
    current_val = default_val;
  }
  if (step > 0) {
    const steps_count = _M0MPC16double6Double7to__int((current_val - min_val) / step + 0.5) + 0;
    current_val = min_val + steps_count * step;
  }
  const final_val = current_val < min_val ? min_val : current_val > max_val ? max_val : current_val;
  const center_x = _rect.x + total_w * 0.5;
  const center_y = _rect.y + label_h + 4 + radius;
  const center = _M0MP49LING7167111moon_2degui3src4math4Vec23new(center_x, center_y);
  const dial_radius = radius - 3.5;
  const start_angle = 0.75 * _M0FP49LING7167111moon_2degui3src4math2pi;
  const total_sweep = 1.5 * _M0FP49LING7167111moon_2degui3src4math2pi;
  const end_angle = start_angle + total_sweep;
  _M0FP49LING7167111moon_2degui3src4core9draw__arc(self.draw_list, center, radius, start_angle, end_angle, _M0MP49LING7167111moon_2degui3src5color5Color13border__muted(), 3.5, 20);
  const norm = (final_val - min_val) / range;
  if (bipolar) {
    const mid_angle = 1.5 * _M0FP49LING7167111moon_2degui3src4math2pi;
    const curr_angle = start_angle + norm * total_sweep;
    const segs = _M0MPC16double6Double7to__int(Math.abs(curr_angle - mid_angle) / total_sweep * 16) + 2 | 0;
    _M0FP49LING7167111moon_2degui3src4core9draw__arc(self.draw_list, center, radius, mid_angle, curr_angle, _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary(), 3.5, segs);
  } else {
    const curr_angle = start_angle + norm * total_sweep;
    const segs = _M0MPC16double6Double7to__int(norm * 20) + 2 | 0;
    _M0FP49LING7167111moon_2degui3src4core9draw__arc(self.draw_list, center, radius, start_angle, curr_angle, _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary(), 3.5, segs);
  }
  _M0MP49LING7167111moon_2degui3src4draw8DrawList11add__circle(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23add(center, _M0MP49LING7167111moon_2degui3src4math4Vec23new(0, 1.5)), dial_radius, _M0MP49LING7167111moon_2degui3src5color5Color6shadow());
  const cap_col = _response.pressed ? _M0MP49LING7167111moon_2degui3src5color5Color10bg__active() : _response.hovered ? _M0MP49LING7167111moon_2degui3src5color5Color9bg__hover() : _M0MP49LING7167111moon_2degui3src5color5Color10bg__window();
  _M0MP49LING7167111moon_2degui3src4draw8DrawList11add__circle(self.draw_list, center, dial_radius, cap_col);
  const border_col = is_focused ? _M0MP49LING7167111moon_2degui3src5color5Color13border__focus() : _M0MP49LING7167111moon_2degui3src5color5Color15border__default();
  _M0MP49LING7167111moon_2degui3src4draw8DrawList19add__circle__stroke(self.draw_list, center, dial_radius, border_col, 1);
  const pointer_angle = start_angle + norm * total_sweep;
  const tick_start = _M0MP49LING7167111moon_2degui3src4math4Vec23add(center, _M0MP49LING7167111moon_2degui3src4math4Vec211from__polar(dial_radius * 0.35, pointer_angle));
  const tick_end = _M0MP49LING7167111moon_2degui3src4math4Vec23add(center, _M0MP49LING7167111moon_2degui3src4math4Vec211from__polar(dial_radius * 0.85, pointer_angle));
  const tick_col = _response.pressed ? _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary() : _M0MP49LING7167111moon_2degui3src5color5Color15text__secondary();
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(self.draw_list, tick_start, tick_end, tick_col, 2);
  const font_sm = self.style.font_small;
  if (!(label === "")) {
    const label_w = _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(self, label, font_sm).x;
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(center_x - label_w * 0.5, _rect.y), label, font_sm, _M0MP49LING7167111moon_2degui3src5color5Color11text__muted());
  }
  const val_str = unit === "" ? String(final_val) : `${String(final_val)} ${unit}`;
  const val_w = _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(self, val_str, font_sm).x;
  const val_col = is_focused || _response.pressed ? _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary() : _M0MP49LING7167111moon_2degui3src5color5Color12text__strong();
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(center_x - val_w * 0.5, center_y + radius + 4), val_str, font_sm, val_col);
  return { _0: final_val, _1: _response };
}
function _M0MP49LING7167111moon_2degui3src4core9Modifiers3new(ctrl, shift, alt, meta) {
  return new _M0TP49LING7167111moon_2degui3src4core9Modifiers(ctrl, shift, alt, meta);
}
function _M0MP49LING7167111moon_2degui3src4core8RawInput20with__events_2einner(mouse_pos, mouse_down, scroll_delta, events, text_input, modifiers, mouse_secondary_down, dt) {
  return new _M0TP49LING7167111moon_2degui3src4core8RawInput(mouse_pos, mouse_down, scroll_delta, dt, events, text_input, modifiers, mouse_secondary_down);
}
function _M0MP49LING7167111moon_2degui3src4core10InputState3new() {
  return new _M0TP49LING7167111moon_2degui3src4core10InputState(_M0MP49LING7167111moon_2degui3src4math4Vec24zeroN6recordS89, _M0MP49LING7167111moon_2degui3src4math4Vec24zeroN6recordS89, _M0MP49LING7167111moon_2degui3src4math4Vec24zeroN6recordS89, false, false, false, false, false, false, _M0MP49LING7167111moon_2degui3src4math4Vec24zeroN6recordS89, 0.0166, [], [], [], [], "", _M0MP49LING7167111moon_2degui3src4core9Modifiers4noneN6recordS4227, []);
}
function _M0MP49LING7167111moon_2degui3src4core10InputState6update(self, raw) {
  self.mouse_prev_pos = self.mouse_pos;
  self.mouse_pos = raw.mouse_pos;
  self.mouse_delta = _M0MP49LING7167111moon_2degui3src4math4Vec23sub(self.mouse_pos, self.mouse_prev_pos);
  const was_down = self.mouse_down;
  self.mouse_down = raw.mouse_down;
  self.mouse_pressed = raw.mouse_down && !was_down;
  self.mouse_released = !raw.mouse_down && was_down;
  const was_sec_down = self.mouse_secondary_down;
  self.mouse_secondary_down = raw.mouse_secondary_down;
  self.mouse_secondary_pressed = raw.mouse_secondary_down && !was_sec_down;
  self.mouse_secondary_released = !raw.mouse_secondary_down && was_sec_down;
  self.scroll_delta = raw.scroll_delta;
  self.dt = raw.dt > 0 ? raw.dt : 0.0166;
  _M0MPC15array5Array5clearGRP49LING7167111moon_2degui3src4core3KeyE(self.keys_pressed);
  _M0MPC15array5Array5clearGRP49LING7167111moon_2degui3src4core3KeyE(self.keys_released);
  _M0MPC15array5Array5clearGRP49LING7167111moon_2degui3src4core3KeyE(self.consumed_keys);
  self.text_input = raw.text_input;
  self.modifiers = raw.modifiers;
  _M0MPC15array5Array5clearGRP49LING7167111moon_2degui3src4math4RectE(self.events);
  const _bind = raw.events;
  const _bind$2 = _bind.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$2) {
      const ev = _bind[_];
      _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(self.events, ev);
      switch (ev.$tag) {
        case 0: {
          const _Key = ev;
          const _k = _Key._0;
          const _is_pressed = _Key._1;
          if (_is_pressed) {
            if (!_M0MPC15array5Array8containsGRP49LING7167111moon_2degui3src4core3KeyE(self.keys_down, _k)) {
              _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core3KeyE(self.keys_down, _k);
            }
            _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core3KeyE(self.keys_pressed, _k);
          } else {
            let found_idx = -1;
            let _tmp$2 = 0;
            while (true) {
              const i = _tmp$2;
              if (i < self.keys_down.length) {
                if (_M0IP49LING7167111moon_2degui3src4core3KeyPB2Eq5equal(_M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core3KeyE(self.keys_down, i), _k)) {
                  found_idx = i;
                  break;
                }
                _tmp$2 = i + 1 | 0;
                continue;
              } else {
                break;
              }
            }
            if (found_idx >= 0) {
              _M0MPC15array5Array6removeGRP49LING7167111moon_2degui3src4core3KeyE(self.keys_down, found_idx);
              _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core3KeyE(self.keys_released, _k);
            }
          }
          break;
        }
        case 1: {
          const _TextInput = ev;
          const _s = _TextInput._0;
          const _p = self.text_input;
          if (_p === "") {
            self.text_input = _s;
          } else {
            self.text_input = `${self.text_input}${_s}`;
          }
          break;
        }
        default: {
          const _PointerWheel = ev;
          const _delta = _PointerWheel._0;
          self.scroll_delta = _M0MP49LING7167111moon_2degui3src4math4Vec23add(self.scroll_delta, _delta);
        }
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0MP49LING7167111moon_2degui3src4core7IdStack3new() {
  return new _M0TP49LING7167111moon_2degui3src4core7IdStack([14695981039346656037n]);
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext13progress__bar(self, fraction, text) {
  const w = self.available_width;
  const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext15allocate__space(self, _M0MP49LING7167111moon_2degui3src4math4Vec23new(w, 18));
  const _rect = _bind._1;
  const _resp = _bind._2;
  const clamped_pct = fraction < 0 ? 0 : fraction > 1 ? 1 : fraction;
  const bar_radius = self.style.radius_sm;
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, _rect, _M0MP49LING7167111moon_2degui3src5color5Color11bg__surface(), bar_radius);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(self.draw_list, _rect, _M0MP49LING7167111moon_2degui3src5color5Color13border__muted(), 1, bar_radius);
  const fill_w = _rect.w * clamped_pct;
  if (fill_w > 0) {
    const fill_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(_rect.x, _rect.y, fill_w, _rect.h);
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, fill_rect, _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary(), bar_radius);
  }
  const display_text = text === "" ? `${_M0MPC13int3Int18to__string_2einner(_M0MPC16double6Double7to__int(clamped_pct * 100), 10)}%` : text;
  const font_sz = self.style.font_small;
  const text_size = _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(self, display_text, font_sz);
  const text_x = _rect.x + (_rect.w - text_size.x) * 0.5;
  const text_y = _rect.y + (_rect.h - font_sz) * 0.5;
  const text_color = clamped_pct >= 0.5 ? _M0MP49LING7167111moon_2degui3src5color5Color13text__inverse() : _M0MP49LING7167111moon_2degui3src5color5Color13text__primary();
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(text_x, text_y), display_text, font_sz, text_color);
  return _resp;
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext7tooltip(self, text) {
  const font_size = self.style.font_small;
  const text_size = _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(self, text, font_size);
  const tip_w = text_size.x + 16;
  const tip_h = text_size.y + 8;
  const mouse = self.input.mouse_pos;
  let tip_x = mouse.x + 12;
  const tip_y = mouse.y + 12;
  const vp_w = self.available_width > 0 ? self.available_width : 800;
  if (tip_x + tip_w > vp_w) {
    tip_x = mouse.x - tip_w - 4;
    if (tip_x < 4) {
      tip_x = 4;
    }
  }
  const tip_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(tip_x, tip_y, tip_w, tip_h);
  _M0MP49LING7167111moon_2degui3src4core9UIContext17begin__foreground(self);
  const tip_radius = self.style.radius_sm;
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, tip_rect, _M0MP49LING7167111moon_2degui3src5color5Color11bg__inverse(), tip_radius);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(self.draw_list, tip_rect, _M0MP49LING7167111moon_2degui3src5color5Color13border__muted(), 1, tip_radius);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(tip_rect.x + 8, tip_rect.y + 4), text, font_size, _M0MP49LING7167111moon_2degui3src5color5Color13text__inverse());
  _M0MP49LING7167111moon_2degui3src4core9UIContext15end__foreground(self);
}
function _M0FP49LING7167111moon_2degui3src4core21wrap__dialog__message(ctx, message, max_w, font_size) {
  const lines = [];
  const raw_paragraphs = _M0MPC16string6String5split(message, new _M0TPC16string10StringView(_M0FP49LING7167111moon_2degui3src4core21wrap__dialog__messageN7_2abindS3564, 0, _M0FP49LING7167111moon_2degui3src4core21wrap__dialog__messageN7_2abindS3564.length));
  while (true) {
    const _bind = _M0MPB4Iter4nextGRPC16string10StringViewE(raw_paragraphs);
    if (_bind === undefined) {
      break;
    } else {
      const _Some = _bind;
      const _p = _Some;
      const p_str = _M0MPC16string10StringView9to__owned(_p);
      if (p_str === "") {
        _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(lines, "");
        continue;
      }
      let cur = "";
      let i = 0;
      const len = p_str.length;
      while (true) {
        if (i < len) {
          const boundary = _M0FP49LING7167111moon_2degui3src4core20next__char__boundary(p_str, i);
          const ch_str = _M0FP49LING7167111moon_2degui3src4core13string__slice(p_str, i, boundary);
          const test_str = `${cur}${ch_str}`;
          const sz = _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(ctx, test_str, font_size);
          let _tmp;
          if (sz.x > max_w) {
            const _p$2 = cur;
            _tmp = !(_p$2 === "");
          } else {
            _tmp = false;
          }
          if (_tmp) {
            _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(lines, cur);
            cur = ch_str;
          } else {
            cur = test_str;
          }
          i = boundary;
          continue;
        } else {
          break;
        }
      }
      const _p$2 = cur;
      if (!(_p$2 === "")) {
        _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(lines, cur);
      }
      continue;
    }
  }
  if (lines.length === 0) {
    _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(lines, "");
  }
  return lines;
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext14dialog_2einner(self, _id_salt, title, message, kind, confirm_label, cancel_label, width, viewport_size) {
  const scale = self.style.scale;
  const eff_w = width > 0 ? width : self.style.dialog_w * scale;
  const vp_w = viewport_size.x > 0 ? viewport_size.x : self.available_width > 0 ? self.available_width : 800;
  const vp_h = viewport_size.y > 0 ? viewport_size.y : 600;
  const scrim_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(0, 0, vp_w, vp_h);
  _M0MP49LING7167111moon_2degui3src4core9UIContext12block__hover(self, scrim_rect);
  const cancel_id = _M0MP49LING7167111moon_2degui3src4core7IdStack10derive__id(self.id_stack, `${_id_salt}::cancel`);
  const confirm_id = _M0MP49LING7167111moon_2degui3src4core7IdStack10derive__id(self.id_stack, `${_id_salt}::confirm`);
  _M0MPC15array5Array5clearGRP49LING7167111moon_2degui3src4math4RectE(self.focusable_ids);
  _M0MP49LING7167111moon_2degui3src4core9UIContext19register__focusable(self, cancel_id);
  _M0MP49LING7167111moon_2degui3src4core9UIContext19register__focusable(self, confirm_id);
  if (_M0IP016_24default__implPB2Eq10not__equalGRP49LING7167111moon_2degui3src4core2IdE(self.focused_id, cancel_id) && _M0IP016_24default__implPB2Eq10not__equalGRP49LING7167111moon_2degui3src4core2IdE(self.focused_id, confirm_id)) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext14request__focus(self, confirm_id);
  }
  const text_max_w = eff_w - 84 * scale;
  const msg_font_sz = self.style.font_normal * scale;
  const msg_lines = _M0FP49LING7167111moon_2degui3src4core21wrap__dialog__message(self, message, text_max_w, msg_font_sz);
  const msg_line_h = 20 * scale;
  const msg_total_h = (msg_lines.length + 0) * msg_line_h;
  const pad_top = 24 * scale;
  const title_sz = _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(self, title, self.style.font_large * scale);
  const title_h = title_sz.y > 0 ? title_sz.y : self.style.font_large * scale;
  const msg_gap = 10 * scale;
  const btn_radius = self.style.button_radius * scale;
  const btn_h = self.style.button_h * scale;
  const btn_w = self.style.dialog_btn_w * scale;
  const btn_pad_right = 16 * scale;
  const btn_gap = 8 * scale;
  const btn_margin_top = 18 * scale;
  const btn_pad_y = 16 * scale;
  const content_needed_h = pad_top + title_h + msg_gap + msg_total_h + btn_margin_top + btn_h + btn_pad_y;
  const min_h = self.style.dialog_min_h * scale;
  const max_allowed_h = vp_h > 80 * scale ? vp_h - 40 * scale : min_h;
  const card_h = content_needed_h < min_h ? min_h : content_needed_h > max_allowed_h ? max_allowed_h : content_needed_h;
  const card_radius = self.style.dialog_radius * scale;
  const card_x = (vp_w - eff_w) * 0.5;
  const card_y = (vp_h - card_h) * 0.5;
  const card_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(card_x, card_y, eff_w, card_h);
  _M0MP49LING7167111moon_2degui3src4core9UIContext17begin__foreground(self);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, scrim_rect, _M0MP49LING7167111moon_2degui3src5color5Color9bg__scrim(), 0);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Rect3new(card_x, card_y + 4 * scale, eff_w, card_h), _M0MP49LING7167111moon_2degui3src5color5Color11shadow__key(), card_radius);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Rect3new(card_x, card_y + 12 * scale, eff_w, card_h), _M0MP49LING7167111moon_2degui3src5color5Color15shadow__ambient(), card_radius);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, card_rect, _M0MP49LING7167111moon_2degui3src5color5Color11bg__surface(), card_radius);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(self.draw_list, card_rect, _M0MP49LING7167111moon_2degui3src5color5Color15border__default(), 1, card_radius);
  const icon_center = _M0MP49LING7167111moon_2degui3src4math4Vec23new(card_x + 32 * scale, card_y + 36 * scale);
  let badge_bg;
  let badge_sym;
  let badge_fg;
  _L: {
    switch (kind) {
      case 0: {
        badge_bg = _M0MP49LING7167111moon_2degui3src5color5Color15badge__info__bg();
        badge_sym = "i";
        badge_fg = _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary();
        break _L;
      }
      case 1: {
        badge_bg = _M0MP49LING7167111moon_2degui3src5color5Color18badge__warning__bg();
        badge_sym = "!";
        badge_fg = _M0MP49LING7167111moon_2degui3src5color5Color7warning();
        break _L;
      }
      case 2: {
        badge_bg = _M0MP49LING7167111moon_2degui3src5color5Color17badge__danger__bg();
        badge_sym = "x";
        badge_fg = _M0MP49LING7167111moon_2degui3src5color5Color6danger();
        break _L;
      }
      default: {
        badge_bg = _M0MP49LING7167111moon_2degui3src5color5Color15badge__info__bg();
        badge_sym = "?";
        badge_fg = _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary();
        break _L;
      }
    }
  }
  _M0MP49LING7167111moon_2degui3src4draw8DrawList11add__circle(self.draw_list, icon_center, 16 * scale, badge_bg);
  const sym_offset = _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(self, badge_sym, self.style.font_normal * scale);
  const sym_pos = _M0MP49LING7167111moon_2degui3src4math4Vec23new(icon_center.x - sym_offset.x * 0.5, icon_center.y - sym_offset.y * 0.5);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, sym_pos, badge_sym, self.style.font_normal * scale, badge_fg);
  const title_pos = _M0MP49LING7167111moon_2degui3src4math4Vec23new(card_x + 60 * scale, card_y + pad_top);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, title_pos, title, self.style.font_large * scale, _M0MP49LING7167111moon_2degui3src5color5Color12text__strong());
  const btn_y = card_y + card_h - btn_h - btn_pad_y;
  const msg_start_y = card_y + pad_top + title_h + msg_gap;
  let _tmp = 0;
  while (true) {
    const idx = _tmp;
    if (idx < msg_lines.length) {
      const line_y = msg_start_y + (idx + 0) * msg_line_h;
      if (line_y + msg_line_h <= btn_y - 6 * scale) {
        _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(card_x + 60 * scale, line_y), _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(msg_lines, idx), msg_font_sz, _M0MP49LING7167111moon_2degui3src5color5Color15text__secondary());
      }
      _tmp = idx + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const confirm_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(card_x + eff_w - btn_w - btn_pad_right, btn_y, btn_w, btn_h);
  const cancel_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(confirm_rect.x - btn_w - btn_gap, btn_y, btn_w, btn_h);
  const cancel_hovered = _M0MP49LING7167111moon_2degui3src4math4Rect8contains(cancel_rect, self.input.mouse_pos);
  const confirm_hovered = _M0MP49LING7167111moon_2degui3src4math4Rect8contains(confirm_rect, self.input.mouse_pos);
  if (cancel_hovered || confirm_hovered) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext17set__cursor__icon(self, "pointer");
  }
  const cancel_bg = cancel_hovered ? _M0MP49LING7167111moon_2degui3src5color5Color9bg__hover() : _M0MP49LING7167111moon_2degui3src5color5Color10bg__subtle();
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, cancel_rect, cancel_bg, btn_radius);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(self.draw_list, cancel_rect, _M0MP49LING7167111moon_2degui3src5color5Color15border__default(), 1, btn_radius);
  if (_M0MP49LING7167111moon_2degui3src4core9UIContext10has__focus(self, cancel_id)) {
    _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Rect6expand(cancel_rect, 2), _M0MP49LING7167111moon_2degui3src5color5Color13border__focus(), 1.5, btn_radius + 2);
  }
  const cancel_sz = _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(self, cancel_label, self.style.font_normal * scale);
  const cancel_text_pos = _M0MP49LING7167111moon_2degui3src4math4Vec23new(cancel_rect.x + (cancel_rect.w - cancel_sz.x) * 0.5, cancel_rect.y + (cancel_rect.h - cancel_sz.y) * 0.5);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, cancel_text_pos, cancel_label, self.style.font_normal * scale, _M0MP49LING7167111moon_2degui3src5color5Color10text__body());
  const cancel_clicked = cancel_hovered && self.input.mouse_pressed;
  let confirm_bg;
  if (kind === 2) {
    confirm_bg = confirm_hovered ? _M0MP49LING7167111moon_2degui3src5color5Color13danger__hover() : _M0MP49LING7167111moon_2degui3src5color5Color6danger();
  } else {
    confirm_bg = confirm_hovered ? _M0MP49LING7167111moon_2degui3src5color5Color13accent__hover() : _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary();
  }
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, confirm_rect, confirm_bg, btn_radius);
  if (_M0MP49LING7167111moon_2degui3src4core9UIContext10has__focus(self, confirm_id)) {
    _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Rect6expand(confirm_rect, 2), _M0MP49LING7167111moon_2degui3src5color5Color13border__focus(), 1.5, btn_radius + 2);
  }
  const confirm_sz = _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(self, confirm_label, self.style.font_normal * scale);
  const confirm_text_pos = _M0MP49LING7167111moon_2degui3src4math4Vec23new(confirm_rect.x + (confirm_rect.w - confirm_sz.x) * 0.5, confirm_rect.y + (confirm_rect.h - confirm_sz.y) * 0.5);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, confirm_text_pos, confirm_label, self.style.font_normal * scale, _M0MP49LING7167111moon_2degui3src5color5Color13text__inverse());
  const confirm_clicked = confirm_hovered && self.input.mouse_pressed;
  const esc_pressed = _M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 3);
  const enter_pressed = _M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 2);
  const space_pressed = _M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 5);
  const backdrop_clicked = self.input.mouse_pressed && !_M0MP49LING7167111moon_2degui3src4math4Rect8contains(card_rect, self.input.mouse_pos);
  const cancel_key = _M0MP49LING7167111moon_2degui3src4core9UIContext10has__focus(self, cancel_id) && (enter_pressed || space_pressed);
  const confirm_key = _M0MP49LING7167111moon_2degui3src4core9UIContext10has__focus(self, confirm_id) && (enter_pressed || space_pressed);
  const result = confirm_clicked || (confirm_key || enter_pressed && !_M0MP49LING7167111moon_2degui3src4core9UIContext10has__focus(self, cancel_id)) ? 0 : cancel_clicked || (cancel_key || (esc_pressed || backdrop_clicked)) ? 1 : 2;
  _M0MP49LING7167111moon_2degui3src4core9UIContext15end__foreground(self);
  return result;
}
function _M0MP49LING7167111moon_2degui3src4core15ContextMenuItem11new_2einner(id, label, shortcut, disabled, children) {
  return new _M0TP49LING7167111moon_2degui3src4core15ContextMenuItem(id, label, shortcut, disabled, false, children);
}
function _M0MP49LING7167111moon_2degui3src4core15ContextMenuItem3new(id, label, shortcut$46$opt, disabled$46$opt, children$46$opt) {
  let shortcut;
  if (shortcut$46$opt === undefined) {
    shortcut = "";
  } else {
    const _Some = shortcut$46$opt;
    shortcut = _Some;
  }
  const disabled = disabled$46$opt === -1 ? false : disabled$46$opt;
  let children;
  if (children$46$opt.$tag === 1) {
    const _Some = children$46$opt;
    children = _Some._0;
  } else {
    children = [];
  }
  return _M0MP49LING7167111moon_2degui3src4core15ContextMenuItem11new_2einner(id, label, shortcut, disabled, children);
}
function _M0MP49LING7167111moon_2degui3src4core15ContextMenuItem9separator() {
  return new _M0TP49LING7167111moon_2degui3src4core15ContextMenuItem("", "", "", true, true, []);
}
function _M0FP49LING7167111moon_2degui3src4core29calculate__context__menu__pos(anchor, size, viewport) {
  let x = anchor.x + 2;
  let y = anchor.y + 2;
  if (x + size.x > viewport.x) {
    const flipped_x = anchor.x - size.x - 2;
    x = flipped_x >= 4 ? flipped_x : viewport.x - size.x - 4;
  }
  if (x < 4) {
    x = 4;
  }
  if (y + size.y > viewport.y) {
    const flipped_y = anchor.y - size.y - 2;
    y = flipped_y >= 4 ? flipped_y : viewport.y - size.y - 4;
  }
  if (y < 4) {
    y = 4;
  }
  return _M0MP49LING7167111moon_2degui3src4math4Vec23new(x, y);
}
function _M0FP49LING7167111moon_2degui3src4core30compute__menu__content__height(items, item_h, sep_h, pad_y) {
  let h = 0;
  const _bind = items.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const item = items[_];
      if (item.is_separator) {
        h = h + sep_h;
      } else {
        h = h + item_h;
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return h > 0 ? h + pad_y * 2 : 32;
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext24set__active__submenu__id(self, id) {
  self.active_submenu_id = id;
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext28context__menu__items_2einner(self, id_salt, open, pos, items, menu_width, viewport_size) {
  if (!open) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext24set__active__submenu__id(self, "");
    return new _M0TP49LING7167111moon_2degui3src4core19ContextMenuResponse(false, undefined, pos, _M0MP49LING7167111moon_2degui3src4math4Vec24zeroN6recordS89);
  }
  const scale = self.style.scale;
  const item_h = 24 * scale;
  const sep_h = 7 * scale;
  const pad_y = 4 * scale;
  const total_w = menu_width * scale;
  const total_h = _M0FP49LING7167111moon_2degui3src4core30compute__menu__content__height(items, item_h, sep_h, pad_y);
  const menu_size = _M0MP49LING7167111moon_2degui3src4math4Vec23new(total_w, total_h);
  let viewport;
  if (viewport_size === undefined) {
    const vw = self.available_width > 0 ? self.available_width : 800;
    viewport = _M0MP49LING7167111moon_2degui3src4math4Vec23new(vw, 600);
  } else {
    const _Some = viewport_size;
    viewport = _Some;
  }
  const placed_pos = _M0FP49LING7167111moon_2degui3src4core29calculate__context__menu__pos(pos, menu_size, viewport);
  const menu_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(placed_pos.x, placed_pos.y, total_w, total_h);
  _M0MP49LING7167111moon_2degui3src4core9UIContext12block__hover(self, menu_rect);
  if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 3)) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext24set__active__submenu__id(self, "");
    return new _M0TP49LING7167111moon_2degui3src4core19ContextMenuResponse(false, undefined, placed_pos, menu_size);
  }
  let cur_y = placed_pos.y + pad_y;
  let active_sub_item = undefined;
  let active_sub_row_y = 0;
  let selected_id = undefined;
  const _bind = items.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const item = items[_];
      if (item.is_separator) {
        cur_y = cur_y + sep_h;
      } else {
        const row_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(placed_pos.x + 4 * scale, cur_y, total_w - 8 * scale, item_h);
        const hovered = _M0MP49LING7167111moon_2degui3src4math4Rect8contains(row_rect, self.input.mouse_pos) && !item.disabled;
        if (hovered) {
          _M0MP49LING7167111moon_2degui3src4core9UIContext17set__cursor__icon(self, "pointer");
          if (item.children.length > 0) {
            _M0MP49LING7167111moon_2degui3src4core9UIContext24set__active__submenu__id(self, item.id);
          } else {
            let _tmp$2;
            const _p = self.active_submenu_id;
            const _p$2 = "";
            if (!(_p === _p$2)) {
              const _p$3 = item.children;
              _tmp$2 = !(_p$3.length === 0) === false;
            } else {
              _tmp$2 = false;
            }
            if (_tmp$2) {
              _M0MP49LING7167111moon_2degui3src4core9UIContext24set__active__submenu__id(self, "");
            }
          }
        }
        if (self.active_submenu_id === item.id && item.children.length > 0) {
          active_sub_item = item;
          active_sub_row_y = cur_y;
        }
        let _tmp$2;
        if (hovered) {
          let _tmp$3;
          if (self.input.mouse_pressed) {
            const _p = item.children;
            _tmp$3 = _p.length === 0;
          } else {
            _tmp$3 = false;
          }
          _tmp$2 = _tmp$3;
        } else {
          _tmp$2 = false;
        }
        if (_tmp$2) {
          selected_id = item.id;
        }
        cur_y = cur_y + item_h;
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  let sub_rect_opt = undefined;
  const _bind$2 = active_sub_item;
  if (_bind$2 === undefined) {
  } else {
    const _Some = _bind$2;
    const _sub_item = _Some;
    const sub_h = _M0FP49LING7167111moon_2degui3src4core30compute__menu__content__height(_sub_item.children, item_h, sep_h, pad_y);
    let sub_x = placed_pos.x + total_w - 2 * scale;
    if (sub_x + total_w > viewport.x) {
      sub_x = placed_pos.x - total_w + 2 * scale;
    }
    if (sub_x < 4) {
      sub_x = 4;
    }
    let sub_y = active_sub_row_y - pad_y;
    if (sub_y + sub_h > viewport.y) {
      sub_y = viewport.y - sub_h - 4;
    }
    if (sub_y < 4) {
      sub_y = 4;
    }
    const sub_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(sub_x, sub_y, total_w, sub_h);
    sub_rect_opt = sub_rect;
    _M0MP49LING7167111moon_2degui3src4core9UIContext12block__hover(self, sub_rect);
    let sub_cur_y = sub_y + pad_y;
    const _bind$3 = _sub_item.children;
    const _bind$4 = _bind$3.length;
    let _tmp$2 = 0;
    while (true) {
      const _ = _tmp$2;
      if (_ < _bind$4) {
        const child = _bind$3[_];
        if (child.is_separator) {
          sub_cur_y = sub_cur_y + sep_h;
        } else {
          const child_row = _M0MP49LING7167111moon_2degui3src4math4Rect3new(sub_x + 4 * scale, sub_cur_y, total_w - 8 * scale, item_h);
          const child_hovered = _M0MP49LING7167111moon_2degui3src4math4Rect8contains(child_row, self.input.mouse_pos) && !child.disabled;
          if (child_hovered) {
            _M0MP49LING7167111moon_2degui3src4core9UIContext17set__cursor__icon(self, "pointer");
            if (self.input.mouse_pressed) {
              selected_id = child.id;
            }
          }
          sub_cur_y = sub_cur_y + item_h;
        }
        _tmp$2 = _ + 1 | 0;
        continue;
      } else {
        break;
      }
    }
  }
  if (self.input.mouse_pressed) {
    const in_main = _M0MP49LING7167111moon_2degui3src4math4Rect8contains(menu_rect, self.input.mouse_pos);
    const _bind$3 = sub_rect_opt;
    let in_sub;
    if (_bind$3 === undefined) {
      in_sub = false;
    } else {
      const _Some = _bind$3;
      const _sr = _Some;
      in_sub = _M0MP49LING7167111moon_2degui3src4math4Rect8contains(_sr, self.input.mouse_pos);
    }
    if (!in_main && !in_sub) {
      _M0MP49LING7167111moon_2degui3src4core9UIContext24set__active__submenu__id(self, "");
      return new _M0TP49LING7167111moon_2degui3src4core19ContextMenuResponse(false, undefined, placed_pos, menu_size);
    }
  }
  const _bind$3 = selected_id;
  if (_bind$3 === undefined) {
  } else {
    const _Some = _bind$3;
    const _id = _Some;
    _M0MP49LING7167111moon_2degui3src4core9UIContext24set__active__submenu__id(self, "");
    return new _M0TP49LING7167111moon_2degui3src4core19ContextMenuResponse(false, _id, placed_pos, menu_size);
  }
  _M0MP49LING7167111moon_2degui3src4core9UIContext17begin__foreground(self);
  const menu_radius = self.style.radius_md * scale;
  const row_radius = self.style.radius_sm * scale;
  const font_nm = self.style.font_normal * scale;
  const font_sm = self.style.font_small * scale;
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Rect3new(placed_pos.x, placed_pos.y + 4 * scale, total_w, total_h), _M0MP49LING7167111moon_2degui3src5color5Color15shadow__ambient(), menu_radius);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Rect3new(placed_pos.x, placed_pos.y + 1 * scale, total_w, total_h), _M0MP49LING7167111moon_2degui3src5color5Color11shadow__key(), menu_radius);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, menu_rect, _M0MP49LING7167111moon_2degui3src5color5Color10bg__window(), menu_radius);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(self.draw_list, menu_rect, _M0MP49LING7167111moon_2degui3src5color5Color15border__default(), 1, menu_radius);
  let cur_draw_y = placed_pos.y + pad_y;
  const _bind$4 = items.length;
  let _tmp$2 = 0;
  while (true) {
    const _ = _tmp$2;
    if (_ < _bind$4) {
      const item = items[_];
      if (item.is_separator) {
        const line_y = cur_draw_y + 3 * scale;
        _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(placed_pos.x + 8 * scale, line_y), _M0MP49LING7167111moon_2degui3src4math4Vec23new(placed_pos.x + total_w - 8 * scale, line_y), _M0MP49LING7167111moon_2degui3src5color5Color13border__muted(), 1);
        cur_draw_y = cur_draw_y + sep_h;
      } else {
        const row_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(placed_pos.x + 4 * scale, cur_draw_y, total_w - 8 * scale, item_h);
        const hovered = (_M0MP49LING7167111moon_2degui3src4math4Rect8contains(row_rect, self.input.mouse_pos) || self.active_submenu_id === item.id) && !item.disabled;
        if (hovered) {
          _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, row_rect, _M0MP49LING7167111moon_2degui3src5color5Color11bg__surface(), row_radius);
        }
        const text_col = item.disabled ? _M0MP49LING7167111moon_2degui3src5color5Color14text__disabled() : hovered ? _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary() : _M0MP49LING7167111moon_2degui3src5color5Color13text__primary();
        const text_y = cur_draw_y + (item_h - font_nm) * 0.5;
        _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(placed_pos.x + 12 * scale, text_y), item.label, font_nm, text_col);
        if (item.children.length > 0) {
          const chev_col = hovered ? _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary() : _M0MP49LING7167111moon_2degui3src5color5Color11text__muted();
          _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(placed_pos.x + total_w - 18 * scale, text_y), ">", font_sm, chev_col);
        } else {
          const _p = item.shortcut;
          if (!(_p === "")) {
            const sc_size = _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(self, item.shortcut, font_sm);
            const sc_x = placed_pos.x + total_w - sc_size.x - 12 * scale;
            const sc_col = item.disabled ? _M0MP49LING7167111moon_2degui3src5color5Color14text__disabled() : hovered ? _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary() : _M0MP49LING7167111moon_2degui3src5color5Color11text__muted();
            _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(sc_x, text_y + 1 * scale), item.shortcut, font_sm, sc_col);
          }
        }
        cur_draw_y = cur_draw_y + item_h;
      }
      _tmp$2 = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _bind$5 = active_sub_item;
  if (_bind$5 === undefined) {
  } else {
    const _Some = _bind$5;
    const _sub_item = _Some;
    const _bind$6 = sub_rect_opt;
    if (_bind$6 === undefined) {
    } else {
      const _Some$2 = _bind$6;
      const _sub_rect = _Some$2;
      _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Rect3new(_sub_rect.x, _sub_rect.y + 4 * scale, _sub_rect.w, _sub_rect.h), _M0MP49LING7167111moon_2degui3src5color5Color15shadow__ambient(), menu_radius);
      _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Rect3new(_sub_rect.x, _sub_rect.y + 1 * scale, _sub_rect.w, _sub_rect.h), _M0MP49LING7167111moon_2degui3src5color5Color11shadow__key(), menu_radius);
      _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, _sub_rect, _M0MP49LING7167111moon_2degui3src5color5Color10bg__window(), menu_radius);
      _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(self.draw_list, _sub_rect, _M0MP49LING7167111moon_2degui3src5color5Color15border__default(), 1, menu_radius);
      let sub_draw_y = _sub_rect.y + pad_y;
      const _bind$7 = _sub_item.children;
      const _bind$8 = _bind$7.length;
      let _tmp$3 = 0;
      while (true) {
        const _ = _tmp$3;
        if (_ < _bind$8) {
          const child = _bind$7[_];
          if (child.is_separator) {
            const line_y = sub_draw_y + 3 * scale;
            _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(_sub_rect.x + 8 * scale, line_y), _M0MP49LING7167111moon_2degui3src4math4Vec23new(_sub_rect.x + _sub_rect.w - 8 * scale, line_y), _M0MP49LING7167111moon_2degui3src5color5Color13border__muted(), 1);
            sub_draw_y = sub_draw_y + sep_h;
          } else {
            const child_row = _M0MP49LING7167111moon_2degui3src4math4Rect3new(_sub_rect.x + 4 * scale, sub_draw_y, _sub_rect.w - 8 * scale, item_h);
            const child_hovered = _M0MP49LING7167111moon_2degui3src4math4Rect8contains(child_row, self.input.mouse_pos) && !child.disabled;
            if (child_hovered) {
              _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, child_row, _M0MP49LING7167111moon_2degui3src5color5Color11bg__surface(), row_radius);
            }
            const text_col = child.disabled ? _M0MP49LING7167111moon_2degui3src5color5Color14text__disabled() : child_hovered ? _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary() : _M0MP49LING7167111moon_2degui3src5color5Color13text__primary();
            const text_y = sub_draw_y + (item_h - font_nm) * 0.5;
            _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(_sub_rect.x + 12 * scale, text_y), child.label, font_nm, text_col);
            const _p = child.shortcut;
            if (!(_p === "")) {
              const sc_size = _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(self, child.shortcut, font_sm);
              const sc_x = _sub_rect.x + _sub_rect.w - sc_size.x - 12 * scale;
              const sc_col = child.disabled ? _M0MP49LING7167111moon_2degui3src5color5Color14text__disabled() : child_hovered ? _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary() : _M0MP49LING7167111moon_2degui3src5color5Color11text__muted();
              _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(sc_x, text_y + 1 * scale), child.shortcut, font_sm, sc_col);
            }
            sub_draw_y = sub_draw_y + item_h;
          }
          _tmp$3 = _ + 1 | 0;
          continue;
        } else {
          break;
        }
      }
    }
  }
  _M0MP49LING7167111moon_2degui3src4core9UIContext15end__foreground(self);
  return new _M0TP49LING7167111moon_2degui3src4core19ContextMenuResponse(true, undefined, placed_pos, menu_size);
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext3new() {
  const _tmp = _M0MP49LING7167111moon_2degui3src4core10InputState3new();
  const _tmp$2 = _M0MP49LING7167111moon_2degui3src4draw8DrawList3new();
  const _tmp$3 = _M0MP49LING7167111moon_2degui3src4core7IdStack3new();
  const _tmp$4 = [];
  const _tmp$5 = _M0MP49LING7167111moon_2degui3src4math4Vec23new(8, 8);
  const _tmp$6 = [];
  const _tmp$7 = [new _M0TP49LING7167111moon_2degui3src4core11LayoutScope(0, 0, 0, 0, 0, 0)];
  const _bind = [];
  const _tmp$8 = _M0MPC17hashmap7HashMap7HashMapGRP49LING7167111moon_2degui3src4core2IddE(new _M0TPB9ArrayViewGURP49LING7167111moon_2degui3src4core2IddEE(_bind, 0, 0), _M0MP49LING7167111moon_2degui3src4core9UIContext3newN6constrS4230);
  const _bind$2 = [];
  const _tmp$9 = _M0MPC17hashmap7HashMap7HashMapGRP49LING7167111moon_2degui3src4core2IddE(new _M0TPB9ArrayViewGURP49LING7167111moon_2degui3src4core2IddEE(_bind$2, 0, 0), _M0MP49LING7167111moon_2degui3src4core9UIContext3newN6constrS4231);
  const _bind$3 = [];
  const _tmp$10 = _M0MPC17hashmap7HashMap7HashMapGRP49LING7167111moon_2degui3src4core2IdRP49LING7167111moon_2degui3src4math4Vec2E(new _M0TPB9ArrayViewGURP49LING7167111moon_2degui3src4core2IdRP49LING7167111moon_2degui3src4math4Vec2EE(_bind$3, 0, 0), _M0MP49LING7167111moon_2degui3src4core9UIContext3newN6constrS4232);
  const _tmp$11 = [];
  const _tmp$12 = [];
  const _tmp$13 = [];
  const _tmp$14 = [];
  const _tmp$15 = [];
  const _bind$4 = [];
  const _tmp$16 = _M0MPC17hashmap7HashMap7HashMapGRP49LING7167111moon_2degui3src4core2IdiE(new _M0TPB9ArrayViewGURP49LING7167111moon_2degui3src4core2IdiEE(_bind$4, 0, 0), _M0MP49LING7167111moon_2degui3src4core9UIContext3newN6constrS4233);
  const _bind$5 = [];
  const _tmp$17 = _M0MPC17hashmap7HashMap7HashMapGRP49LING7167111moon_2degui3src4core2IdbE(new _M0TPB9ArrayViewGURP49LING7167111moon_2degui3src4core2IdbEE(_bind$5, 0, 0), _M0MP49LING7167111moon_2degui3src4core9UIContext3newN6constrS4234);
  const _bind$6 = [];
  const _tmp$18 = _M0MPC17hashmap7HashMap7HashMapGRP49LING7167111moon_2degui3src4core2IdiE(new _M0TPB9ArrayViewGURP49LING7167111moon_2degui3src4core2IdiEE(_bind$6, 0, 0), _M0MP49LING7167111moon_2degui3src4core9UIContext3newN6constrS4235);
  const _bind$7 = [];
  const _tmp$19 = _M0MPC17hashmap7HashMap7HashMapGRP49LING7167111moon_2degui3src4core2IdiE(new _M0TPB9ArrayViewGURP49LING7167111moon_2degui3src4core2IdiEE(_bind$7, 0, 0), _M0MP49LING7167111moon_2degui3src4core9UIContext3newN6constrS4236);
  const _tmp$20 = _M0MP49LING7167111moon_2degui3src4draw8DrawList3new();
  const _tmp$21 = _M0MP49LING7167111moon_2degui3src4draw8DrawList3new();
  const _tmp$22 = [];
  const _tmp$23 = [];
  const _tmp$24 = [];
  const _tmp$25 = _M0MP49LING7167111moon_2degui3src4core11WidgetStyle7default();
  const _tmp$26 = _M0MP49LING7167111moon_2degui3src4core5Theme13studio__light();
  const _bind$8 = [];
  const _tmp$27 = _M0MPC17hashmap7HashMap7HashMapGsdE(new _M0TPB9ArrayViewGUsdEE(_bind$8, 0, 0), _M0MP49LING7167111moon_2degui3src4core9UIContext3newN6constrS4237);
  const _bind$9 = [];
  return new _M0TP49LING7167111moon_2degui3src4core9UIContext(_tmp, _tmp$2, _tmp$3, _M0MP49LING7167111moon_2degui3src4core2Id4zeroN6recordS4226, _M0MP49LING7167111moon_2degui3src4core2Id4zeroN6recordS4226, _M0MP49LING7167111moon_2degui3src4core2Id4zeroN6recordS4226, _M0MP49LING7167111moon_2degui3src4core2Id4zeroN6recordS4226, _M0MP49LING7167111moon_2degui3src4core2Id4zeroN6recordS4226, _M0MP49LING7167111moon_2degui3src4core2Id4zeroN6recordS4226, _tmp$4, _M0MP49LING7167111moon_2degui3src4math4Vec24zeroN6recordS89, 800, _tmp$5, _tmp$6, 0, _tmp$7, _tmp$8, _tmp$9, _tmp$10, _tmp$11, _tmp$12, _tmp$13, -1, _tmp$14, _tmp$15, _tmp$16, _tmp$17, _tmp$18, 0, _M0MP49LING7167111moon_2degui3src4core2Id4zeroN6recordS4226, _M0MP49LING7167111moon_2degui3src4core2Id4zeroN6recordS4226, "", _tmp$19, false, false, _tmp$20, _tmp$21, _tmp$22, false, _tmp$23, _tmp$24, _tmp$25, _tmp$26, "default", 0, 0, _tmp$27, _M0MPC17hashmap7HashMap7HashMapGRP49LING7167111moon_2degui3src4core2IddE(new _M0TPB9ArrayViewGURP49LING7167111moon_2degui3src4core2IddEE(_bind$9, 0, 0), _M0MP49LING7167111moon_2degui3src4core9UIContext3newN6constrS4238));
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext12begin__frame(self, raw_input) {
  self.cursor_icon = "default";
  self.frame_counter = self.frame_counter + 1 | 0;
  _M0MP49LING7167111moon_2degui3src4core10InputState6update(self.input, raw_input);
  self.time = self.time + self.input.dt;
  _M0MP49LING7167111moon_2degui3src4draw8DrawList5clear(self.draw_list);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList5clear(self.fg_draw_list);
  self.foreground = false;
  _M0MPC15array5Array5clearGRP49LING7167111moon_2degui3src4math4RectE(self.prev_blocking_rects);
  const _bind = self.blocking_rects;
  const _bind$2 = _bind.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$2) {
      const rect = _bind[_];
      _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(self.prev_blocking_rects, rect);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  _M0MPC15array5Array5clearGRP49LING7167111moon_2degui3src4math4RectE(self.blocking_rects);
  _M0MPC15array5Array5clearGRP49LING7167111moon_2degui3src4math4RectE(self.window_drawn);
  self.win_active_z = -1;
  _M0MPC15array5Array5clearGRP49LING7167111moon_2degui3src4math4RectE(self.prev_window_rects);
  const _bind$3 = self.window_rects;
  const _bind$4 = _bind$3.length;
  let _tmp$2 = 0;
  while (true) {
    const _ = _tmp$2;
    if (_ < _bind$4) {
      const item = _bind$3[_];
      _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(self.prev_window_rects, item);
      _tmp$2 = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  _M0MPC15array5Array5clearGRP49LING7167111moon_2degui3src4math4RectE(self.window_rects);
  self.cursor = _M0MP49LING7167111moon_2degui3src4math4Vec24zeroN6recordS89;
  _M0MPC15array5Array5clearGRP49LING7167111moon_2degui3src4math4RectE(self.clip_stack);
  self.auto_id_counter = 0;
  self.hot_id = _M0MP49LING7167111moon_2degui3src4core2Id4zeroN6recordS4226;
  self.prev_focused_id = self.focused_id;
  self.lost_focus_id = self.pending_lost_focus_id;
  self.pending_lost_focus_id = _M0MP49LING7167111moon_2degui3src4core2Id4zeroN6recordS4226;
  _M0MPC15array5Array5clearGRP49LING7167111moon_2degui3src4math4RectE(self.focusable_ids);
  self.wants_capture_mouse = false;
  _M0MPC15array5Array5clearGRP49LING7167111moon_2degui3src4math4RectE(self.layout_stack);
  _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(self.layout_stack, new _M0TP49LING7167111moon_2degui3src4core11LayoutScope(0, 0, 0, 0, 0, 0));
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext19prune__stale__state(self, ttl_frames) {
  const stale_ids = [];
  const _p = self.last_active_frame;
  const _p$2 = _p.capacity;
  let _tmp = 0;
  while (true) {
    const _p$3 = _tmp;
    if (_p$3 < _p$2) {
      const _tmp$2 = _p.entries;
      const _p$4 = _p$3 >>> 0 < _tmp$2.length ? _tmp$2[_p$3] : $oob();
      if (_p$4 === undefined) {
      } else {
        const _p$5 = _p$4;
        const _p$6 = _p$5;
        const _p$7 = _p$6.key;
        const _p$8 = _p$6.value;
        if ((self.frame_counter - _p$8 | 0) > ttl_frames) {
          _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(stale_ids, _p$7);
        }
      }
      _tmp = _p$3 + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _bind = stale_ids.length;
  let _tmp$2 = 0;
  while (true) {
    const _ = _tmp$2;
    if (_ < _bind) {
      const id = stale_ids[_];
      _M0MPC17hashmap7HashMap6removeGRP49LING7167111moon_2degui3src4core2IdiE(self.last_active_frame, id);
      _M0MPC17hashmap7HashMap6removeGRP49LING7167111moon_2degui3src4core2IddE(self.scroll_offsets, id);
      _M0MPC17hashmap7HashMap6removeGRP49LING7167111moon_2degui3src4core2IddE(self.scroll_content_heights, id);
      _M0MPC17hashmap7HashMap6removeGRP49LING7167111moon_2degui3src4core2IdiE(self.text_cursor_positions, id);
      _M0MPC17hashmap7HashMap6removeGRP49LING7167111moon_2degui3src4core2IdiE(self.text_selection_anchors, id);
      _M0MPC17hashmap7HashMap6removeGRP49LING7167111moon_2degui3src4core2IdbE(self.open_collapsing_ids, id);
      _M0MPC17hashmap7HashMap6removeGRP49LING7167111moon_2degui3src4core2IddE(self.animation_states, id);
      if (!_M0MPC15array5Array8containsGRP49LING7167111moon_2degui3src4core2IdE(self.window_drawn, id)) {
        _M0MPC17hashmap7HashMap6removeGRP49LING7167111moon_2degui3src4core2IdRP49LING7167111moon_2degui3src4math4Vec2E(self.window_positions, id);
      }
      _tmp$2 = _ + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext10end__frame(self) {
  let _tmp;
  if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 4)) {
    let _tmp$2;
    if (!_M0MP49LING7167111moon_2degui3src4core10InputState17is__key__consumed(self.input, 4)) {
      const _p = self.focusable_ids;
      _tmp$2 = !(_p.length === 0);
    } else {
      _tmp$2 = false;
    }
    _tmp = _tmp$2;
  } else {
    _tmp = false;
  }
  if (_tmp) {
    const count = self.focusable_ids.length;
    let current_idx = -1;
    let _tmp$2 = 0;
    while (true) {
      const i = _tmp$2;
      if (i < count) {
        const _p = _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(self.focusable_ids, i);
        const _p$2 = self.focused_id;
        if (BigInt.asUintN(64, _p.val) === BigInt.asUintN(64, _p$2.val)) {
          current_idx = i;
          break;
        }
        _tmp$2 = i + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    const is_shift = self.input.modifiers.shift;
    const next_idx = is_shift ? (current_idx <= 0 ? count - 1 | 0 : current_idx - 1 | 0) : current_idx < 0 || current_idx >= (count - 1 | 0) ? 0 : current_idx + 1 | 0;
    _M0MP49LING7167111moon_2degui3src4core9UIContext14request__focus(self, _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(self.focusable_ids, next_idx));
  }
  self.prev_wants_capture_mouse = self.wants_capture_mouse;
  const _bind = self.window_focus;
  const _bind$2 = _bind.length;
  let _tmp$2 = 0;
  while (true) {
    const _ = _tmp$2;
    if (_ < _bind$2) {
      const id = _bind[_];
      if (_M0MPC15array5Array8containsGRP49LING7167111moon_2degui3src4core2IdE(self.window_drawn, id)) {
        const _bind$3 = self.window_batches;
        const _bind$4 = _bind$3.length;
        let _tmp$3 = 0;
        while (true) {
          const _$2 = _tmp$3;
          if (_$2 < _bind$4) {
            const batch = _bind$3[_$2];
            const _p = batch._0;
            if (BigInt.asUintN(64, _p.val) === BigInt.asUintN(64, id.val)) {
              _M0MP49LING7167111moon_2degui3src4draw8DrawList6append(self.draw_list, batch._1);
            }
            _tmp$3 = _$2 + 1 | 0;
            continue;
          } else {
            break;
          }
        }
      }
      _tmp$2 = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  _M0MP49LING7167111moon_2degui3src4draw8DrawList6append(self.draw_list, self.fg_draw_list);
  if ((self.frame_counter % 300 | 0) === 0) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext19prune__stale__state(self, 600);
  }
  return self.draw_list;
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext20is__collapsing__open(self, id, default_open) {
  _M0MPC17hashmap7HashMap3setGRP49LING7167111moon_2degui3src4core2IdiE(self.last_active_frame, id, self.frame_counter);
  const _bind = _M0MPC17hashmap7HashMap3getGRP49LING7167111moon_2degui3src4core2IdbE(self.open_collapsing_ids, id);
  return _bind === -1 ? default_open : _bind;
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext21set__collapsing__open(self, id, is_open) {
  _M0MPC17hashmap7HashMap3setGRP49LING7167111moon_2degui3src4core2IdiE(self.last_active_frame, id, self.frame_counter);
  _M0MPC17hashmap7HashMap3setGRP49LING7167111moon_2degui3src4core2IdbE(self.open_collapsing_ids, id, is_open);
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext28get__text__selection__anchor(self, id) {
  return _M0MPC17hashmap7HashMap3getGRP49LING7167111moon_2degui3src4core2IdiE(self.text_selection_anchors, id);
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext28set__text__selection__anchor(self, id, anchor) {
  _M0MPC17hashmap7HashMap3setGRP49LING7167111moon_2degui3src4core2IdiE(self.last_active_frame, id, self.frame_counter);
  if (anchor === undefined) {
    _M0MPC17hashmap7HashMap6removeGRP49LING7167111moon_2degui3src4core2IdiE(self.text_selection_anchors, id);
    return;
  } else {
    const _Some = anchor;
    const _a = _Some;
    _M0MPC17hashmap7HashMap3setGRP49LING7167111moon_2degui3src4core2IdiE(self.text_selection_anchors, id, _a);
    return;
  }
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext20set__open__combo__id(self, id) {
  self.open_combo_id = id;
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext10set__theme(self, theme) {
  self.theme = theme;
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext18collapsing__header(self, id_salt, title, default_open, content) {
  const header_id = _M0MP49LING7167111moon_2degui3src4core7IdStack10derive__id(self.id_stack, id_salt);
  const w = self.available_width;
  _M0MP49LING7167111moon_2degui3src4core9UIContext8push__id(self, id_salt);
  const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext15allocate__space(self, _M0MP49LING7167111moon_2degui3src4math4Vec23new(w, 26));
  const _rect = _bind._1;
  const _resp = _bind._2;
  _M0MP49LING7167111moon_2degui3src4core9UIContext7pop__id(self);
  let is_open = _M0MP49LING7167111moon_2degui3src4core9UIContext20is__collapsing__open(self, header_id, default_open);
  if (_resp.clicked) {
    is_open = !is_open;
    _M0MP49LING7167111moon_2degui3src4core9UIContext21set__collapsing__open(self, header_id, is_open);
  }
  if (_resp.hovered) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext17set__cursor__icon(self, "pointer");
  }
  const bg_color = _resp.hovered ? _M0MP49LING7167111moon_2degui3src5color5Color11bg__surface() : _M0MP49LING7167111moon_2degui3src5color5Color10bg__subtle();
  const border_color = _resp.hovered ? _M0MP49LING7167111moon_2degui3src5color5Color15border__default() : _M0MP49LING7167111moon_2degui3src5color5Color13border__muted();
  const header_radius = self.style.radius_sm;
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, _rect, bg_color, header_radius);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(self.draw_list, _rect, border_color, 1, header_radius);
  const arrow_color = _resp.hovered ? _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary() : _M0MP49LING7167111moon_2degui3src5color5Color11text__muted();
  const arrow_cx = _rect.x + 12;
  const arrow_cy = _rect.y + 13;
  if (is_open) {
    const p1 = _M0MP49LING7167111moon_2degui3src4math4Vec23new(arrow_cx - 3.5, arrow_cy - 1.5);
    const p2 = _M0MP49LING7167111moon_2degui3src4math4Vec23new(arrow_cx, arrow_cy + 2);
    const p3 = _M0MP49LING7167111moon_2degui3src4math4Vec23new(arrow_cx + 3.5, arrow_cy - 1.5);
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(self.draw_list, p1, p2, arrow_color, 1.5);
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(self.draw_list, p2, p3, arrow_color, 1.5);
  } else {
    const p1 = _M0MP49LING7167111moon_2degui3src4math4Vec23new(arrow_cx - 1.5, arrow_cy - 3.5);
    const p2 = _M0MP49LING7167111moon_2degui3src4math4Vec23new(arrow_cx + 2, arrow_cy);
    const p3 = _M0MP49LING7167111moon_2degui3src4math4Vec23new(arrow_cx - 1.5, arrow_cy + 3.5);
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(self.draw_list, p1, p2, arrow_color, 1.5);
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(self.draw_list, p2, p3, arrow_color, 1.5);
  }
  const font_sz = self.style.font_normal;
  const title_x = _rect.x + 24;
  const title_y = _rect.y + (26 - font_sz) * 0.5;
  const text_color = _resp.hovered ? _M0MP49LING7167111moon_2degui3src5color5Color13text__primary() : _M0MP49LING7167111moon_2degui3src5color5Color10text__body();
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(title_x, title_y), title, font_sz, text_color);
  if (is_open) {
    const prev_cursor = self.cursor;
    const prev_avail_w = self.available_width;
    self.cursor = _M0MP49LING7167111moon_2degui3src4math4Vec23new(prev_cursor.x + 16, prev_cursor.y);
    self.available_width = prev_avail_w - 16;
    content(self);
    const final_y = self.cursor.y;
    self.cursor = _M0MP49LING7167111moon_2degui3src4math4Vec23new(prev_cursor.x, final_y);
    self.available_width = prev_avail_w;
  }
  return _resp;
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext10combo__box(self, id_salt, label, selected_index, options) {
  const combo_id = _M0MP49LING7167111moon_2degui3src4core7IdStack10derive__id(self.id_stack, id_salt);
  const combo_font_sz = self.style.font_normal;
  const label_size = !(label === "") ? _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(self, label, combo_font_sz).x + 8 : 0;
  const total_w = label_size + 140;
  _M0MP49LING7167111moon_2degui3src4core9UIContext8push__id(self, id_salt);
  const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext15allocate__space(self, _M0MP49LING7167111moon_2degui3src4math4Vec23new(total_w, 28));
  const _id = _bind._0;
  const _rect = _bind._1;
  const _resp = _bind._2;
  _M0MP49LING7167111moon_2degui3src4core9UIContext7pop__id(self);
  _M0MP49LING7167111moon_2degui3src4core9UIContext19register__focusable(self, _id);
  const box_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(_rect.x + label_size, _rect.y, 140, 28);
  const box_hovered = _M0MP49LING7167111moon_2degui3src4core9UIContext11is__hovered(self, box_rect);
  if (box_hovered) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext17set__cursor__icon(self, "pointer");
  }
  let current_idx = selected_index;
  const _p = self.open_combo_id;
  const is_open = BigInt.asUintN(64, _p.val) === BigInt.asUintN(64, combo_id.val);
  const is_focused = _resp.has_focus || _M0MP49LING7167111moon_2degui3src4core9UIContext10has__focus(self, _id);
  const key_toggle = is_focused && (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 5) || _M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 2));
  if (key_toggle) {
    _M0MP49LING7167111moon_2degui3src4core10InputState12consume__key(self.input, 5);
    _M0MP49LING7167111moon_2degui3src4core10InputState12consume__key(self.input, 2);
  }
  let _tmp;
  let _tmp$2;
  if (box_hovered) {
    const _p$2 = self.input;
    _tmp$2 = _p$2.mouse_pressed;
  } else {
    _tmp$2 = false;
  }
  if (_tmp$2) {
    _tmp = true;
  } else {
    _tmp = key_toggle;
  }
  if (_tmp) {
    if (is_open) {
      _M0MP49LING7167111moon_2degui3src4core9UIContext20set__open__combo__id(self, _M0MP49LING7167111moon_2degui3src4core2Id4zeroN6recordS4226);
    } else {
      _M0MP49LING7167111moon_2degui3src4core9UIContext20set__open__combo__id(self, combo_id);
    }
  }
  if (is_open) {
    if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 3)) {
      _M0MP49LING7167111moon_2degui3src4core9UIContext20set__open__combo__id(self, _M0MP49LING7167111moon_2degui3src4core2Id4zeroN6recordS4226);
      _M0MP49LING7167111moon_2degui3src4core10InputState12consume__key(self.input, 3);
    }
    if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 9)) {
      if (current_idx < (options.length - 1 | 0)) {
        current_idx = current_idx + 1 | 0;
      }
      _M0MP49LING7167111moon_2degui3src4core10InputState12consume__key(self.input, 9);
    }
    if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 8)) {
      if (current_idx > 0) {
        current_idx = current_idx - 1 | 0;
      }
      _M0MP49LING7167111moon_2degui3src4core10InputState12consume__key(self.input, 8);
    }
    if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 2)) {
      _M0MP49LING7167111moon_2degui3src4core9UIContext20set__open__combo__id(self, _M0MP49LING7167111moon_2degui3src4core2Id4zeroN6recordS4226);
      _M0MP49LING7167111moon_2degui3src4core10InputState12consume__key(self.input, 2);
    }
  }
  if (!(label === "")) {
    const label_y = _rect.y + (28 - combo_font_sz) * 0.5;
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(_rect.x, label_y), label, combo_font_sz, _M0MP49LING7167111moon_2degui3src5color5Color13text__primary());
  }
  const bg_color = box_hovered || is_open ? _M0MP49LING7167111moon_2degui3src5color5Color10bg__subtle() : _M0MP49LING7167111moon_2degui3src5color5Color10bg__window();
  const border_color = is_focused || is_open ? _M0MP49LING7167111moon_2degui3src5color5Color13border__focus() : box_hovered ? _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary() : _M0MP49LING7167111moon_2degui3src5color5Color15border__default();
  const box_radius = self.style.radius_sm;
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, box_rect, bg_color, box_radius);
  const stroke_w = is_focused || is_open ? 1.5 : 1;
  _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(self.draw_list, box_rect, border_color, stroke_w, box_radius);
  const selected_str = current_idx >= 0 && current_idx < options.length ? _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(options, current_idx) : "";
  const text_y = box_rect.y + (28 - combo_font_sz) * 0.5;
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(box_rect.x + 8, text_y), selected_str, combo_font_sz, _M0MP49LING7167111moon_2degui3src5color5Color13text__primary());
  const chevron_cx = box_rect.x + 140 - 14;
  const chevron_cy = box_rect.y + 14;
  const chevron_col = is_open ? _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary() : box_hovered ? _M0MP49LING7167111moon_2degui3src5color5Color13text__primary() : _M0MP49LING7167111moon_2degui3src5color5Color11text__muted();
  if (is_open) {
    const p1 = _M0MP49LING7167111moon_2degui3src4math4Vec23new(chevron_cx - 3.5, chevron_cy + 1.5);
    const p2 = _M0MP49LING7167111moon_2degui3src4math4Vec23new(chevron_cx, chevron_cy - 2);
    const p3 = _M0MP49LING7167111moon_2degui3src4math4Vec23new(chevron_cx + 3.5, chevron_cy + 1.5);
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(self.draw_list, p1, p2, chevron_col, 1.5);
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(self.draw_list, p2, p3, chevron_col, 1.5);
  } else {
    const p1 = _M0MP49LING7167111moon_2degui3src4math4Vec23new(chevron_cx - 3.5, chevron_cy - 1.5);
    const p2 = _M0MP49LING7167111moon_2degui3src4math4Vec23new(chevron_cx, chevron_cy + 2);
    const p3 = _M0MP49LING7167111moon_2degui3src4math4Vec23new(chevron_cx + 3.5, chevron_cy - 1.5);
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(self.draw_list, p1, p2, chevron_col, 1.5);
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(self.draw_list, p2, p3, chevron_col, 1.5);
  }
  if (is_open) {
    const total_options_h = 24 * (options.length + 0);
    const menu_h = total_options_h > 240 ? 240 : total_options_h;
    let menu_y = box_rect.y + box_rect.h + 2;
    if (menu_y + menu_h > 600 && box_rect.y - menu_h - 2 >= 0) {
      menu_y = box_rect.y - menu_h - 2;
    }
    const menu_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(box_rect.x, menu_y, 140, menu_h);
    _M0MP49LING7167111moon_2degui3src4core9UIContext17begin__foreground(self);
    _M0MP49LING7167111moon_2degui3src4core9UIContext12block__hover(self, menu_rect);
    const combo_scroll_id = _M0MP49LING7167111moon_2degui3src4core7IdStack10derive__id(self.id_stack, `${id_salt}::combo_scroll`);
    let combo_scroll_y = _M0MP49LING7167111moon_2degui3src4core9UIContext19get__scroll__offset(self, combo_scroll_id);
    const max_scroll = total_options_h > menu_h ? total_options_h - menu_h : 0;
    if (_M0MP49LING7167111moon_2degui3src4core9UIContext11is__hovered(self, menu_rect) && self.input.scroll_delta.y !== 0) {
      combo_scroll_y = combo_scroll_y - self.input.scroll_delta.y;
    }
    if (combo_scroll_y < 0) {
      combo_scroll_y = 0;
    }
    if (combo_scroll_y > max_scroll) {
      combo_scroll_y = max_scroll;
    }
    _M0MP49LING7167111moon_2degui3src4core9UIContext19set__scroll__offset(self, combo_scroll_id, combo_scroll_y);
    let _tmp$3;
    const _p$2 = self.input;
    if (_p$2.mouse_pressed) {
      _tmp$3 = !_M0MP49LING7167111moon_2degui3src4core9UIContext11is__hovered(self, menu_rect) && !box_hovered;
    } else {
      _tmp$3 = false;
    }
    if (_tmp$3) {
      _M0MP49LING7167111moon_2degui3src4core9UIContext20set__open__combo__id(self, _M0MP49LING7167111moon_2degui3src4core2Id4zeroN6recordS4226);
      _M0MP49LING7167111moon_2degui3src4core9UIContext15end__foreground(self);
      return { _0: current_idx, _1: _resp };
    }
    const shadow_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(menu_rect.x, menu_rect.y + 2, menu_rect.w, menu_rect.h);
    const menu_radius = self.style.radius_md;
    const item_radius = self.style.radius_sm;
    const item_font_sz = self.style.font_small;
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, shadow_rect, _M0MP49LING7167111moon_2degui3src5color5Color15shadow__ambient(), menu_radius);
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, menu_rect, _M0MP49LING7167111moon_2degui3src5color5Color10bg__window(), item_radius);
    _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(self.draw_list, menu_rect, _M0MP49LING7167111moon_2degui3src5color5Color15border__default(), 1, item_radius);
    _M0MP49LING7167111moon_2degui3src4core9UIContext10push__clip(self, menu_rect);
    let _tmp$4 = 0;
    while (true) {
      const i = _tmp$4;
      if (i < options.length) {
        const item_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(menu_rect.x, menu_rect.y + 24 * (i + 0) - combo_scroll_y, 140, 24);
        const item_hovered = _M0MP49LING7167111moon_2degui3src4core9UIContext11is__hovered(self, item_rect);
        if (item_hovered) {
          _M0MP49LING7167111moon_2degui3src4core9UIContext17set__cursor__icon(self, "pointer");
          _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, item_rect, _M0MP49LING7167111moon_2degui3src5color5Color11bg__surface(), item_radius);
          const _p$3 = self.input;
          if (_p$3.mouse_pressed) {
            current_idx = i;
            _M0MP49LING7167111moon_2degui3src4core9UIContext20set__open__combo__id(self, _M0MP49LING7167111moon_2degui3src4core2Id4zeroN6recordS4226);
          }
        }
        const item_text_col = item_hovered ? _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary() : i === current_idx ? _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary() : _M0MP49LING7167111moon_2degui3src5color5Color10text__body();
        _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(item_rect.x + 8, item_rect.y + (24 - item_font_sz) * 0.5), _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(options, i), item_font_sz, item_text_col);
        if (i === current_idx) {
          const chk_x = item_rect.x + 140 - 14;
          const chk_y = item_rect.y + 12;
          const p1 = _M0MP49LING7167111moon_2degui3src4math4Vec23new(chk_x - 4, chk_y);
          const p2 = _M0MP49LING7167111moon_2degui3src4math4Vec23new(chk_x - 1.5, chk_y + 2.5);
          const p3 = _M0MP49LING7167111moon_2degui3src4math4Vec23new(chk_x + 3.5, chk_y - 2.5);
          _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(self.draw_list, p1, p2, _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary(), 1.5);
          _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(self.draw_list, p2, p3, _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary(), 1.5);
        }
        _tmp$4 = i + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    _M0MP49LING7167111moon_2degui3src4core9UIContext9pop__clip(self);
    _M0MP49LING7167111moon_2degui3src4core9UIContext15end__foreground(self);
  }
  return { _0: current_idx, _1: _resp };
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext8tab__bar(self, _id_str, tabs, selected_idx) {
  const font_size = self.style.font_normal;
  let total_w = 0;
  const _bind = tabs.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const tab = tabs[_];
      total_w = total_w + _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(self, tab, font_size).x + 24;
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _bind$2 = _M0MP49LING7167111moon_2degui3src4core9UIContext15allocate__space(self, _M0MP49LING7167111moon_2degui3src4math4Vec23new(total_w, 28));
  const _rect = _bind$2._1;
  const _resp = _bind$2._2;
  let current_selected = selected_idx;
  const container_radius = self.style.radius_md;
  const tab_radius = self.style.radius_sm;
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, _rect, _M0MP49LING7167111moon_2degui3src5color5Color11bg__surface(), container_radius);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(self.draw_list, _rect, _M0MP49LING7167111moon_2degui3src5color5Color13border__muted(), 1, container_radius);
  let cur_x = _rect.x;
  let _tmp$2 = 0;
  while (true) {
    const i = _tmp$2;
    if (i < tabs.length) {
      const tab_text = _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(tabs, i);
      const text_w = _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(self, tab_text, font_size).x;
      const tab_w = text_w + 24;
      const tab_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(cur_x, _rect.y, tab_w, 28);
      const is_hovered = _M0MP49LING7167111moon_2degui3src4core9UIContext11is__hovered(self, tab_rect);
      const is_selected = i === current_selected;
      if (is_hovered) {
        _M0MP49LING7167111moon_2degui3src4core9UIContext17set__cursor__icon(self, "pointer");
      }
      let _tmp$3;
      if (is_hovered) {
        const _p = self.input;
        _tmp$3 = _p.mouse_pressed;
      } else {
        _tmp$3 = false;
      }
      if (_tmp$3) {
        current_selected = i;
      }
      if (is_selected) {
        const active_rect = _M0MP49LING7167111moon_2degui3src4math4Rect6shrink(tab_rect, 2);
        _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, active_rect, _M0MP49LING7167111moon_2degui3src5color5Color10bg__window(), tab_radius);
        _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(self.draw_list, active_rect, _M0MP49LING7167111moon_2degui3src5color5Color15border__default(), 1, tab_radius);
      } else {
        if (is_hovered) {
          const hover_rect = _M0MP49LING7167111moon_2degui3src4math4Rect6shrink(tab_rect, 2);
          _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, hover_rect, _M0MP49LING7167111moon_2degui3src5color5Color10bg__subtle(), tab_radius);
        }
      }
      const text_col = is_selected ? _M0MP49LING7167111moon_2degui3src5color5Color13text__primary() : is_hovered ? _M0MP49LING7167111moon_2degui3src5color5Color13text__primary() : _M0MP49LING7167111moon_2degui3src5color5Color11text__muted();
      const text_x = tab_rect.x + (tab_w - text_w) * 0.5;
      const text_y = tab_rect.y + (28 - font_size) * 0.5;
      _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(text_x, text_y), tab_text, font_size, text_col);
      cur_x = cur_x + tab_w;
      _tmp$2 = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return { _0: current_selected, _1: _resp };
}
function _M0MP49LING7167111moon_2degui3src4core11CommandItem11new_2einner(id, title, category, shortcut) {
  return new _M0TP49LING7167111moon_2degui3src4core11CommandItem(id, title, category, shortcut);
}
function _M0FP49LING7167111moon_2degui3src4core30string__contains__ignore__case(haystack, needle) {
  const n_len = needle.length;
  const h_len = haystack.length;
  if (n_len === 0) {
    return true;
  }
  if (n_len > h_len) {
    return false;
  }
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i <= (h_len - n_len | 0)) {
      let matched = true;
      let _tmp$2 = 0;
      while (true) {
        const j = _tmp$2;
        if (j < n_len) {
          const _tmp$3 = i + j | 0;
          const _p = _tmp$3 >>> 0 < haystack.length ? haystack.charCodeAt(_tmp$3) : $oob();
          const hc = _p >= 65 && _p <= 90 ? _p + 32 | 0 : _p;
          const _p$2 = j >>> 0 < needle.length ? needle.charCodeAt(j) : $oob();
          const nc = _p$2 >= 65 && _p$2 <= 90 ? _p$2 + 32 | 0 : _p$2;
          if (hc !== nc) {
            matched = false;
            break;
          }
          _tmp$2 = j + 1 | 0;
          continue;
        } else {
          break;
        }
      }
      if (matched) {
        return true;
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return false;
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext24command__palette_2einner(self, open, query, commands, selected_index) {
  if (!open) {
    return new _M0TP49LING7167111moon_2degui3src4core22CommandPaletteResponse(false, undefined, query, selected_index);
  }
  let new_query = query;
  let new_selected_index = selected_index;
  if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 0)) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext19reset__caret__blink(self);
    const len = new_query.length;
    if (len > 0) {
      new_query = _M0FP49LING7167111moon_2degui3src4core13string__slice(new_query, 0, len - 1 | 0);
    }
  }
  const _p = self.input;
  const text_in = _p.text_input;
  if (!(text_in === "")) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext19reset__caret__blink(self);
    new_query = `${new_query}${text_in}`;
  }
  const _p$2 = new_query;
  if (!(_p$2 === query)) {
    new_selected_index = 0;
  }
  const filtered = [];
  const _bind = commands.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const item = commands[_];
      let _tmp$2;
      const _p$3 = new_query;
      if (_p$3 === "") {
        _tmp$2 = true;
      } else {
        _tmp$2 = _M0FP49LING7167111moon_2degui3src4core30string__contains__ignore__case(item.title, new_query) || _M0FP49LING7167111moon_2degui3src4core30string__contains__ignore__case(item.category, new_query);
      }
      if (_tmp$2) {
        _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(filtered, item);
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const filtered_count = filtered.length;
  if (filtered_count > 0) {
    if (new_selected_index >= filtered_count) {
      new_selected_index = filtered_count - 1 | 0;
    }
    if (new_selected_index < 0) {
      new_selected_index = 0;
    }
    if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 9)) {
      new_selected_index = (new_selected_index + 1 | 0) % filtered_count | 0;
    }
    if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 8)) {
      new_selected_index = new_selected_index <= 0 ? filtered_count - 1 | 0 : new_selected_index - 1 | 0;
    }
  } else {
    new_selected_index = 0;
  }
  if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 3)) {
    return new _M0TP49LING7167111moon_2degui3src4core22CommandPaletteResponse(false, undefined, new_query, new_selected_index);
  }
  if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 2)) {
    const sel = filtered_count > 0 && new_selected_index < filtered_count ? _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(filtered, new_selected_index).id : undefined;
    return new _M0TP49LING7167111moon_2degui3src4core22CommandPaletteResponse(false, sel, new_query, new_selected_index);
  }
  const scale = self.style.scale;
  const font_sm = self.style.font_small * scale;
  const font_nm = self.style.font_normal * scale;
  const font_lg = self.style.font_large * scale;
  const card_radius = self.style.command_palette_radius * scale;
  const row_radius = self.style.radius_sm * scale;
  const viewport_w = self.available_width > 0 ? self.available_width : 800;
  const scrim_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(0, 0, viewport_w, 800);
  const default_palette_w = self.style.command_palette_w * scale;
  const card_w = viewport_w < default_palette_w + 20 * scale ? viewport_w - 32 * scale : default_palette_w;
  const card_x = (viewport_w - card_w) * 0.5;
  const card_y = 64 * scale;
  const header_h = self.style.command_palette_header_h * scale;
  const footer_h = self.style.command_palette_footer_h * scale;
  const row_h = self.style.command_palette_row_h * scale;
  const cat_h = 24 * scale;
  let content_h = 0;
  let prev_cat = "";
  if (filtered_count === 0) {
    content_h = 48 * scale;
  } else {
    const _bind$2 = filtered.length;
    let _tmp$2 = 0;
    while (true) {
      const _ = _tmp$2;
      if (_ < _bind$2) {
        const item = filtered[_];
        let _tmp$3;
        const _p$3 = item.category;
        if (!(_p$3 === "")) {
          const _p$4 = item.category;
          const _p$5 = prev_cat;
          _tmp$3 = !(_p$4 === _p$5);
        } else {
          _tmp$3 = false;
        }
        if (_tmp$3) {
          content_h = content_h + cat_h;
          prev_cat = item.category;
        }
        content_h = content_h + row_h;
        _tmp$2 = _ + 1 | 0;
        continue;
      } else {
        break;
      }
    }
  }
  const max_content_h = 320 * scale;
  const visible_content_h = content_h > max_content_h ? max_content_h : content_h;
  const card_h = header_h + visible_content_h + footer_h + 12 * scale;
  const card_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(card_x, card_y, card_w, card_h);
  const content_clip_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(card_x, card_y + header_h, card_w, visible_content_h + 12 * scale);
  const scroll_id = _M0MP49LING7167111moon_2degui3src4core7IdStack10derive__id(self.id_stack, "cmd_palette_scroll");
  let scroll_y = _M0MP49LING7167111moon_2degui3src4core9UIContext19get__scroll__offset(self, scroll_id);
  const max_scroll = content_h > visible_content_h ? content_h - visible_content_h : 0;
  if (_M0MP49LING7167111moon_2degui3src4core9UIContext11is__hovered(self, content_clip_rect) && self.input.scroll_delta.y !== 0) {
    scroll_y = scroll_y - self.input.scroll_delta.y;
  }
  const selected_top = (new_selected_index + 0) * row_h;
  if (selected_top < scroll_y) {
    scroll_y = selected_top;
  } else {
    if (selected_top + row_h > scroll_y + visible_content_h) {
      scroll_y = selected_top + row_h - visible_content_h;
    }
  }
  if (scroll_y < 0) {
    scroll_y = 0;
  }
  if (scroll_y > max_scroll) {
    scroll_y = max_scroll;
  }
  _M0MP49LING7167111moon_2degui3src4core9UIContext19set__scroll__offset(self, scroll_id, scroll_y);
  _M0MP49LING7167111moon_2degui3src4core9UIContext12block__hover(self, scrim_rect);
  if (self.input.mouse_pressed && !_M0MP49LING7167111moon_2degui3src4math4Rect8contains(card_rect, self.input.mouse_pos)) {
    return new _M0TP49LING7167111moon_2degui3src4core22CommandPaletteResponse(false, undefined, new_query, new_selected_index);
  }
  const row_pad_x = row_radius * scale;
  const row_w = card_w - row_pad_x * 2;
  const elevation_key_y = 8 * scale;
  const elevation_ambient_y = 2 * scale;
  let cur_row_y = card_y + header_h + row_pad_x - scroll_y;
  let prev_row_cat = "";
  let clicked_id = undefined;
  let _tmp$2 = 0;
  while (true) {
    const idx = _tmp$2;
    if (idx < filtered_count) {
      const item = _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(filtered, idx);
      let _tmp$3;
      const _p$3 = item.category;
      if (!(_p$3 === "")) {
        const _p$4 = item.category;
        const _p$5 = prev_row_cat;
        _tmp$3 = !(_p$4 === _p$5);
      } else {
        _tmp$3 = false;
      }
      if (_tmp$3) {
        cur_row_y = cur_row_y + cat_h;
        prev_row_cat = item.category;
      }
      const row_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(card_x + row_pad_x, cur_row_y, row_w, row_h);
      if (_M0MP49LING7167111moon_2degui3src4math4Rect8contains(content_clip_rect, self.input.mouse_pos) && _M0MP49LING7167111moon_2degui3src4math4Rect8contains(row_rect, self.input.mouse_pos)) {
        _M0MP49LING7167111moon_2degui3src4core9UIContext17set__cursor__icon(self, "pointer");
        new_selected_index = idx;
        if (self.input.mouse_pressed) {
          clicked_id = item.id;
        }
      }
      cur_row_y = cur_row_y + row_h;
      _tmp$2 = idx + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _bind$2 = clicked_id;
  if (_bind$2 === undefined) {
  } else {
    const _Some = _bind$2;
    const _id = _Some;
    return new _M0TP49LING7167111moon_2degui3src4core22CommandPaletteResponse(false, _id, new_query, new_selected_index);
  }
  _M0MP49LING7167111moon_2degui3src4core9UIContext17begin__foreground(self);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, scrim_rect, _M0MP49LING7167111moon_2degui3src5color5Color9bg__scrim(), 0);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Rect3new(card_x, card_y + elevation_key_y, card_w, card_h), _M0MP49LING7167111moon_2degui3src5color5Color11shadow__key(), card_radius);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Rect3new(card_x, card_y + elevation_ambient_y, card_w, card_h), _M0MP49LING7167111moon_2degui3src5color5Color15shadow__ambient(), card_radius);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, card_rect, _M0MP49LING7167111moon_2degui3src5color5Color10bg__window(), card_radius);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(self.draw_list, card_rect, _M0MP49LING7167111moon_2degui3src5color5Color15border__default(), 1, card_radius);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(card_x + 16 * scale, card_y + 14 * scale), ">", font_lg, _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary());
  const _p$3 = new_query;
  if (_p$3 === "") {
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(card_x + 36 * scale, card_y + 16 * scale), "键入命令或搜索动作...", font_nm, _M0MP49LING7167111moon_2degui3src5color5Color11text__muted());
  } else {
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(card_x + 36 * scale, card_y + 16 * scale), new_query, font_nm, _M0MP49LING7167111moon_2degui3src5color5Color13text__primary());
    const q_size = _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(self, new_query, font_nm);
    const caret_x = card_x + 36 * scale + q_size.x + 2 * scale;
    if (_M0MP49LING7167111moon_2degui3src4core9UIContext18is__caret__visible(self)) {
      _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(caret_x, card_y + 16 * scale), _M0MP49LING7167111moon_2degui3src4math4Vec23new(caret_x, card_y + 31 * scale), _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary(), 1.5);
    }
  }
  const esc_w = 32 * scale;
  const esc_h = 18 * scale;
  const esc_x = card_x + card_w - esc_w - 14 * scale;
  const esc_y = card_y + 14 * scale;
  const esc_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(esc_x, esc_y, esc_w, esc_h);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, esc_rect, _M0MP49LING7167111moon_2degui3src5color5Color11bg__surface(), row_radius);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(self.draw_list, esc_rect, _M0MP49LING7167111moon_2degui3src5color5Color13border__muted(), 1, row_radius);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(esc_x + 6 * scale, esc_y + 3 * scale), "Esc", font_sm, _M0MP49LING7167111moon_2degui3src5color5Color11text__muted());
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(card_x, card_y + header_h), _M0MP49LING7167111moon_2degui3src4math4Vec23new(card_x + card_w, card_y + header_h), _M0MP49LING7167111moon_2degui3src5color5Color13border__muted(), 1);
  _M0MP49LING7167111moon_2degui3src4core9UIContext10push__clip(self, content_clip_rect);
  let draw_y = card_y + header_h + row_pad_x - scroll_y;
  let prev_draw_cat = "";
  if (filtered_count === 0) {
    const empty_text_y = draw_y + (48 * scale - font_nm) * 0.5;
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(card_x + 20 * scale, empty_text_y), "未找到匹配命令", font_nm, _M0MP49LING7167111moon_2degui3src5color5Color11text__muted());
  } else {
    const indicator_h = 20 * scale;
    const indicator_w = 3 * scale;
    const text_pad_left = card_x + row_pad_x + 12 * scale;
    let _tmp$3 = 0;
    while (true) {
      const idx = _tmp$3;
      if (idx < filtered_count) {
        const item = _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(filtered, idx);
        let _tmp$4;
        const _p$4 = item.category;
        if (!(_p$4 === "")) {
          const _p$5 = item.category;
          const _p$6 = prev_draw_cat;
          _tmp$4 = !(_p$5 === _p$6);
        } else {
          _tmp$4 = false;
        }
        if (_tmp$4) {
          const cat_y = draw_y + (cat_h - font_sm) * 0.5;
          _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(card_x + 16 * scale, cat_y), item.category, font_sm, _M0MP49LING7167111moon_2degui3src5color5Color11text__muted());
          draw_y = draw_y + cat_h;
          prev_draw_cat = item.category;
        }
        const row_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(card_x + row_pad_x, draw_y, row_w, row_h);
        const is_selected = idx === new_selected_index;
        const text_y = draw_y + (row_h - font_nm) * 0.5;
        if (is_selected) {
          _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, row_rect, _M0MP49LING7167111moon_2degui3src5color5Color19tree__row__selected(), row_radius);
          const indicator_y = draw_y + (row_h - indicator_h) * 0.5;
          _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Rect3new(card_x + row_pad_x, indicator_y, indicator_w, indicator_h), _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary(), indicator_w * 0.5);
          _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(text_pad_left, text_y), item.title, font_nm, _M0MP49LING7167111moon_2degui3src5color5Color13text__primary());
        } else {
          _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(text_pad_left, text_y), item.title, font_nm, _M0MP49LING7167111moon_2degui3src5color5Color10text__body());
        }
        const _p$5 = item.shortcut;
        if (!(_p$5 === "")) {
          const sc_size = _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(self, item.shortcut, font_sm);
          const sc_x = card_x + card_w - sc_size.x - 20 * scale;
          const sc_y = draw_y + (row_h - font_sm) * 0.5;
          _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(sc_x, sc_y), item.shortcut, font_sm, _M0MP49LING7167111moon_2degui3src5color5Color11text__muted());
        }
        draw_y = draw_y + row_h;
        _tmp$3 = idx + 1 | 0;
        continue;
      } else {
        break;
      }
    }
  }
  _M0MP49LING7167111moon_2degui3src4core9UIContext9pop__clip(self);
  const footer_y = card_y + card_h - footer_h;
  const footer_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(card_x, footer_y, card_w, footer_h);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, footer_rect, _M0MP49LING7167111moon_2degui3src5color5Color11bg__surface(), card_radius);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(card_x, footer_y), _M0MP49LING7167111moon_2degui3src4math4Vec23new(card_x + card_w, footer_y), _M0MP49LING7167111moon_2degui3src5color5Color13border__muted(), 1);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(card_x + 16 * scale, footer_y + 8 * scale), "↑↓ 导航   ↵ 选择   Esc 退出", font_sm, _M0MP49LING7167111moon_2degui3src5color5Color11text__muted());
  _M0MP49LING7167111moon_2degui3src4core9UIContext15end__foreground(self);
  return new _M0TP49LING7167111moon_2degui3src4core22CommandPaletteResponse(true, undefined, new_query, new_selected_index);
}
function _M0FP49LING7167111moon_2degui3src4core12hsv__to__rgb(h, s, v) {
  const h_clamped = _M0IPC16double6DoublePB3Mod3mod(_M0IPC16double6DoublePB3Mod3mod(h, 360) + 360, 360);
  const s_clamped = s < 0 ? 0 : s > 1 ? 1 : s;
  const v_clamped = v < 0 ? 0 : v > 1 ? 1 : v;
  const c = v_clamped * s_clamped;
  const h_sector = h_clamped / 60;
  const x = c * (1 - Math.abs(_M0IPC16double6DoublePB3Mod3mod(h_sector, 2) - 1));
  const m = v_clamped - c;
  let r1;
  let g1;
  let b1;
  _L: {
    if (h_sector < 1) {
      r1 = c;
      g1 = x;
      b1 = 0;
      break _L;
    } else {
      if (h_sector < 2) {
        r1 = x;
        g1 = c;
        b1 = 0;
        break _L;
      } else {
        if (h_sector < 3) {
          r1 = 0;
          g1 = c;
          b1 = x;
          break _L;
        } else {
          if (h_sector < 4) {
            r1 = 0;
            g1 = x;
            b1 = c;
            break _L;
          } else {
            if (h_sector < 5) {
              r1 = x;
              g1 = 0;
              b1 = c;
              break _L;
            } else {
              r1 = c;
              g1 = 0;
              b1 = x;
              break _L;
            }
          }
        }
      }
    }
  }
  const r = _M0MPC16double6Double7to__int((r1 + m) * 255 + 0.5);
  const g = _M0MPC16double6Double7to__int((g1 + m) * 255 + 0.5);
  const b = _M0MPC16double6Double7to__int((b1 + m) * 255 + 0.5);
  return { _0: r, _1: g, _2: b };
}
function _M0FP49LING7167111moon_2degui3src4core12rgb__to__hsv(r, g, b) {
  const rf = (r + 0) / 255;
  const gf = (g + 0) / 255;
  const bf = (b + 0) / 255;
  const cmax = rf > gf ? (rf > bf ? rf : bf) : gf > bf ? gf : bf;
  const cmin = rf < gf ? (rf < bf ? rf : bf) : gf < bf ? gf : bf;
  const delta = cmax - cmin;
  const s = cmax > 1e-005 ? delta / cmax : 0;
  let h;
  if (delta < 1e-005) {
    h = 0;
  } else {
    if (cmax === rf) {
      let val = 60 * ((gf - bf) / delta);
      if (val < 0) {
        val = val + 360;
      }
      h = val;
    } else {
      h = cmax === gf ? 60 * ((bf - rf) / delta) + 120 : 60 * ((rf - gf) / delta) + 240;
    }
  }
  return { _0: h, _1: s, _2: cmax };
}
function _M0FP49LING7167111moon_2degui3src4core9hex__byte(val) {
  const hi = val >> 4 & 15;
  const lo = val & 15;
  const hi_s = _M0MPC16string10StringView9to__owned(_M0MPC16string6String11sub_2einner(_M0FP49LING7167111moon_2degui3src4core9hex__byteN11hex__digitsS416, hi, hi + 1 | 0));
  const lo_s = _M0MPC16string10StringView9to__owned(_M0MPC16string6String11sub_2einner(_M0FP49LING7167111moon_2degui3src4core9hex__byteN11hex__digitsS416, lo, lo + 1 | 0));
  return `${hi_s}${lo_s}`;
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext21color__picker_2einner(self, id_salt, color, show_alpha) {
  const height = show_alpha ? 230 : 206;
  _M0MP49LING7167111moon_2degui3src4core9UIContext8push__id(self, id_salt);
  const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext15allocate__space(self, _M0MP49LING7167111moon_2degui3src4math4Vec23new(180, height));
  const _rect = _bind._1;
  const _resp = _bind._2;
  _M0MP49LING7167111moon_2degui3src4core9UIContext7pop__id(self);
  const card_radius = self.style.radius_md;
  const inner_radius = self.style.radius_sm;
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, _rect, _M0MP49LING7167111moon_2degui3src5color5Color11bg__surface(), card_radius);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(self.draw_list, _rect, _M0MP49LING7167111moon_2degui3src5color5Color15border__default(), 1, card_radius);
  const sq_x = _rect.x + 10;
  const sq_y = _rect.y + 10;
  const sq_w = _rect.w - 20;
  const sq_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(sq_x, sq_y, sq_w, 126);
  const _bind$2 = _M0FP49LING7167111moon_2degui3src4core12rgb__to__hsv(color.r, color.g, color.b);
  const _init_h = _bind$2._0;
  const _init_s = _bind$2._1;
  const _init_v = _bind$2._2;
  let h = _init_h;
  let s = _init_s;
  let v = _init_v;
  let a = color.a;
  const sv_id = _M0MP49LING7167111moon_2degui3src4core7IdStack10derive__id(self.id_stack, `cp_sv::${id_salt}`);
  const sv_hovered = _M0MP49LING7167111moon_2degui3src4math4Rect8contains(sq_rect, self.input.mouse_pos);
  if (sv_hovered && self.input.mouse_pressed) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext15set__active__id(self, sv_id);
  }
  const _p = self.active_id;
  if (BigInt.asUintN(64, _p.val) === BigInt.asUintN(64, sv_id.val)) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext26set__wants__capture__mouse(self, true);
    if (self.input.mouse_down) {
      const raw_s = (self.input.mouse_pos.x - sq_x) / sq_w;
      const raw_v = 1 - (self.input.mouse_pos.y - sq_y) / 126;
      s = raw_s < 0 ? 0 : raw_s > 1 ? 1 : raw_s;
      v = raw_v < 0 ? 0 : raw_v > 1 ? 1 : raw_v;
    }
    if (self.input.mouse_released) {
      _M0MP49LING7167111moon_2degui3src4core9UIContext15set__active__id(self, _M0MP49LING7167111moon_2degui3src4core2Id4zeroN6recordS4226);
    }
  }
  const cell_w = sq_w / (10 + 0);
  const cell_h = 126 / (7 + 0);
  let _tmp = 0;
  while (true) {
    const gx = _tmp;
    if (gx < 10) {
      const cell_s = (gx + 0) / (9 + 0);
      let _tmp$2 = 0;
      while (true) {
        const gy = _tmp$2;
        if (gy < 7) {
          const cell_v = 1 - (gy + 0) / (6 + 0);
          const _bind$3 = _M0FP49LING7167111moon_2degui3src4core12hsv__to__rgb(h, cell_s, cell_v);
          const _cr = _bind$3._0;
          const _cg = _bind$3._1;
          const _cb = _bind$3._2;
          const c_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(sq_x + (gx + 0) * cell_w, sq_y + (gy + 0) * cell_h, cell_w + 0.5, cell_h + 0.5);
          _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, c_rect, _M0MP49LING7167111moon_2degui3src5color5Color3rgb(_cr, _cg, _cb), 0);
          _tmp$2 = gy + 1 | 0;
          continue;
        } else {
          break;
        }
      }
      _tmp = gx + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(self.draw_list, sq_rect, _M0MP49LING7167111moon_2degui3src5color5Color13border__muted(), 1, inner_radius);
  const cur_x = sq_x + s * sq_w;
  const cur_y = sq_y + (1 - v) * 126;
  const cur_center = _M0MP49LING7167111moon_2degui3src4math4Vec23new(cur_x, cur_y);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList19add__circle__stroke(self.draw_list, cur_center, 5, _M0MP49LING7167111moon_2degui3src5color5Color10bg__window(), 1.6);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList19add__circle__stroke(self.draw_list, cur_center, 3.5, _M0MP49LING7167111moon_2degui3src5color5Color13text__primary(), 1.2);
  const hue_y = sq_y + 126 + 8;
  const hue_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(sq_x, hue_y, sq_w, 12);
  const hue_id = _M0MP49LING7167111moon_2degui3src4core7IdStack10derive__id(self.id_stack, `cp_hue::${id_salt}`);
  const hue_hovered = _M0MP49LING7167111moon_2degui3src4math4Rect8contains(hue_rect, self.input.mouse_pos);
  if (hue_hovered && self.input.mouse_pressed) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext15set__active__id(self, hue_id);
  }
  const _p$2 = self.active_id;
  if (BigInt.asUintN(64, _p$2.val) === BigInt.asUintN(64, hue_id.val)) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext26set__wants__capture__mouse(self, true);
    if (self.input.mouse_down) {
      const raw_h = (self.input.mouse_pos.x - sq_x) / sq_w * 360;
      h = raw_h < 0 ? 0 : raw_h > 360 ? 360 : raw_h;
    }
    if (self.input.mouse_released) {
      _M0MP49LING7167111moon_2degui3src4core9UIContext15set__active__id(self, _M0MP49LING7167111moon_2degui3src4core2Id4zeroN6recordS4226);
    }
  }
  const hue_step_w = sq_w / (24 + 0);
  let _tmp$2 = 0;
  while (true) {
    const step = _tmp$2;
    if (step < 24) {
      const step_h = (step + 0) / (24 + 0) * 360;
      const _bind$3 = _M0FP49LING7167111moon_2degui3src4core12hsv__to__rgb(step_h, 1, 1);
      const _hr = _bind$3._0;
      const _hg = _bind$3._1;
      const _hb = _bind$3._2;
      const slice_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(sq_x + (step + 0) * hue_step_w, hue_y, hue_step_w + 0.5, 12);
      _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, slice_rect, _M0MP49LING7167111moon_2degui3src5color5Color3rgb(_hr, _hg, _hb), 0);
      _tmp$2 = step + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(self.draw_list, hue_rect, _M0MP49LING7167111moon_2degui3src5color5Color13border__muted(), 1, inner_radius);
  const hue_thumb_x = sq_x + h / 360 * sq_w;
  const hue_thumb_center = _M0MP49LING7167111moon_2degui3src4math4Vec23new(hue_thumb_x, hue_y + 6);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList11add__circle(self.draw_list, hue_thumb_center, 6, _M0MP49LING7167111moon_2degui3src5color5Color10bg__window());
  _M0MP49LING7167111moon_2degui3src4draw8DrawList19add__circle__stroke(self.draw_list, hue_thumb_center, 6, _M0MP49LING7167111moon_2degui3src5color5Color15border__default(), 1);
  if (show_alpha) {
    const alpha_y = hue_y + 12 + 8;
    const alpha_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(sq_x, alpha_y, sq_w, 12);
    const alpha_id = _M0MP49LING7167111moon_2degui3src4core7IdStack10derive__id(self.id_stack, `cp_alpha::${id_salt}`);
    const alpha_hovered = _M0MP49LING7167111moon_2degui3src4math4Rect8contains(alpha_rect, self.input.mouse_pos);
    if (alpha_hovered && self.input.mouse_pressed) {
      _M0MP49LING7167111moon_2degui3src4core9UIContext15set__active__id(self, alpha_id);
    }
    const _p$3 = self.active_id;
    if (BigInt.asUintN(64, _p$3.val) === BigInt.asUintN(64, alpha_id.val)) {
      _M0MP49LING7167111moon_2degui3src4core9UIContext26set__wants__capture__mouse(self, true);
      if (self.input.mouse_down) {
        const raw_a = (self.input.mouse_pos.x - sq_x) / sq_w * 255;
        const val_a = _M0MPC16double6Double7to__int(raw_a);
        a = val_a < 0 ? 0 : val_a > 255 ? 255 : val_a;
      }
      if (self.input.mouse_released) {
        _M0MP49LING7167111moon_2degui3src4core9UIContext15set__active__id(self, _M0MP49LING7167111moon_2degui3src4core2Id4zeroN6recordS4226);
      }
    }
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, alpha_rect, _M0MP49LING7167111moon_2degui3src5color5Color10bg__subtle(), inner_radius);
    const alpha_step_w = sq_w / (16 + 0);
    const _bind$3 = _M0FP49LING7167111moon_2degui3src4core12hsv__to__rgb(h, s, v);
    const _cur_r = _bind$3._0;
    const _cur_g = _bind$3._1;
    const _cur_b = _bind$3._2;
    let _tmp$3 = 0;
    while (true) {
      const step = _tmp$3;
      if (step < 16) {
        const step_a = _M0MPC16double6Double7to__int((step + 0) / (16 + 0) * 255);
        const slice_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(sq_x + (step + 0) * alpha_step_w, alpha_y, alpha_step_w + 0.5, 12);
        _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, slice_rect, _M0MP49LING7167111moon_2degui3src5color5Color4rgba(_cur_r, _cur_g, _cur_b, step_a), 0);
        _tmp$3 = step + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(self.draw_list, alpha_rect, _M0MP49LING7167111moon_2degui3src5color5Color13border__muted(), 1, inner_radius);
    const alpha_thumb_x = sq_x + (a + 0) / 255 * sq_w;
    const alpha_thumb_center = _M0MP49LING7167111moon_2degui3src4math4Vec23new(alpha_thumb_x, alpha_y + 6);
    _M0MP49LING7167111moon_2degui3src4draw8DrawList11add__circle(self.draw_list, alpha_thumb_center, 6, _M0MP49LING7167111moon_2degui3src5color5Color10bg__window());
    _M0MP49LING7167111moon_2degui3src4draw8DrawList19add__circle__stroke(self.draw_list, alpha_thumb_center, 6, _M0MP49LING7167111moon_2degui3src5color5Color15border__default(), 1);
  }
  const _bind$3 = _M0FP49LING7167111moon_2degui3src4core12hsv__to__rgb(h, s, v);
  const _final_r = _bind$3._0;
  const _final_g = _bind$3._1;
  const _final_b = _bind$3._2;
  const updated_color = _M0MP49LING7167111moon_2degui3src5color5Color4rgba(_final_r, _final_g, _final_b, a);
  const footer_y = show_alpha ? hue_y + 12 + 8 + 12 + 8 : hue_y + 12 + 8;
  const swatch_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(sq_x, footer_y, 22, 22);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, swatch_rect, updated_color, inner_radius);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(self.draw_list, swatch_rect, _M0MP49LING7167111moon_2degui3src5color5Color15border__default(), 1, inner_radius);
  const hex_text = show_alpha ? `#${_M0FP49LING7167111moon_2degui3src4core9hex__byte(_final_r)}${_M0FP49LING7167111moon_2degui3src4core9hex__byte(_final_g)}${_M0FP49LING7167111moon_2degui3src4core9hex__byte(_final_b)}${_M0FP49LING7167111moon_2degui3src4core9hex__byte(a)}` : `#${_M0FP49LING7167111moon_2degui3src4core9hex__byte(_final_r)}${_M0FP49LING7167111moon_2degui3src4core9hex__byte(_final_g)}${_M0FP49LING7167111moon_2degui3src4core9hex__byte(_final_b)}`;
  const font_sz = self.style.font_small;
  const hex_pos = _M0MP49LING7167111moon_2degui3src4math4Vec23new(sq_x + 30, footer_y + (22 - font_sz) * 0.5);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, hex_pos, hex_text, font_sz, _M0MP49LING7167111moon_2degui3src5color5Color12text__strong());
  return { _0: updated_color, _1: _resp };
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext29color__picker__button_2einner(self, id_salt, color, show_alpha) {
  const font_sz = self.style.font_small;
  const hex_text = show_alpha ? `#${_M0FP49LING7167111moon_2degui3src4core9hex__byte(color.r)}${_M0FP49LING7167111moon_2degui3src4core9hex__byte(color.g)}${_M0FP49LING7167111moon_2degui3src4core9hex__byte(color.b)}${_M0FP49LING7167111moon_2degui3src4core9hex__byte(color.a)}` : `#${_M0FP49LING7167111moon_2degui3src4core9hex__byte(color.r)}${_M0FP49LING7167111moon_2degui3src4core9hex__byte(color.g)}${_M0FP49LING7167111moon_2degui3src4core9hex__byte(color.b)}`;
  const txt_sz = _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(self, hex_text, font_sz);
  const btn_w = 28 + txt_sz.x + 16;
  _M0MP49LING7167111moon_2degui3src4core9UIContext8push__id(self, id_salt);
  const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext15allocate__space(self, _M0MP49LING7167111moon_2degui3src4math4Vec23new(btn_w, 28));
  const _id = _bind._0;
  const _rect = _bind._1;
  const _resp = _bind._2;
  _M0MP49LING7167111moon_2degui3src4core9UIContext7pop__id(self);
  const is_hovered = _M0MP49LING7167111moon_2degui3src4core9UIContext11is__hovered(self, _rect);
  const btn_bg = is_hovered ? _M0MP49LING7167111moon_2degui3src5color5Color9bg__hover() : _M0MP49LING7167111moon_2degui3src5color5Color11bg__surface();
  const btn_radius = self.style.radius_sm;
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, _rect, btn_bg, btn_radius);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(self.draw_list, _rect, _M0MP49LING7167111moon_2degui3src5color5Color15border__default(), 1, btn_radius);
  const swatch_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(_rect.x + 6, _rect.y + 6, 16, 16);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, swatch_rect, color, btn_radius);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(self.draw_list, swatch_rect, _M0MP49LING7167111moon_2degui3src5color5Color13border__muted(), 1, btn_radius);
  const text_y = _rect.y + (28 - font_sz) * 0.5;
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(_rect.x + 28, text_y), hex_text, font_sz, _M0MP49LING7167111moon_2degui3src5color5Color10text__body());
  const _p = self.open_combo_id;
  const is_open = BigInt.asUintN(64, _p.val) === BigInt.asUintN(64, _id.val);
  let next_color = color;
  if (_resp.clicked) {
    if (is_open) {
      self.open_combo_id = _M0MP49LING7167111moon_2degui3src4core2Id4zeroN6recordS4226;
    } else {
      self.open_combo_id = _id;
    }
  }
  if (is_open) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext17begin__foreground(self);
    const popup_pos = _M0MP49LING7167111moon_2degui3src4math4Vec23new(_rect.x, _rect.y + 28 + 4);
    const prev_cursor = self.cursor;
    self.cursor = popup_pos;
    const _bind$2 = _M0MP49LING7167111moon_2degui3src4core9UIContext21color__picker_2einner(self, `${id_salt}::popup`, color, show_alpha);
    const _c = _bind$2._0;
    next_color = _c;
    self.cursor = prev_cursor;
    _M0MP49LING7167111moon_2degui3src4core9UIContext15end__foreground(self);
    if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 3)) {
      self.open_combo_id = _M0MP49LING7167111moon_2degui3src4core2Id4zeroN6recordS4226;
    }
  }
  return { _0: next_color, _1: _resp };
}
function _M0FP49LING7167111moon_2degui3src4core12split__lines(text) {
  const lines = [];
  let start = 0;
  const len = text.length;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < len) {
      const _p = i >>> 0 < text.length ? text.charCodeAt(i) : $oob();
      const _p$2 = 10;
      if (_p === _p$2) {
        _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(lines, _M0FP49LING7167111moon_2degui3src4core13string__slice(text, start, i));
        start = i + 1 | 0;
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(lines, _M0FP49LING7167111moon_2degui3src4core13string__slice(text, start, len));
  return lines;
}
function _M0FP49LING7167111moon_2degui3src4core21cursor__to__line__col(text, cursor_pos) {
  let line = 0;
  let col = 0;
  const limit = cursor_pos > text.length ? text.length : cursor_pos < 0 ? 0 : cursor_pos;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < limit) {
      const _p = i >>> 0 < text.length ? text.charCodeAt(i) : $oob();
      const _p$2 = 10;
      if (_p === _p$2) {
        line = line + 1 | 0;
        col = 0;
      } else {
        col = col + 1 | 0;
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return { _0: line, _1: col };
}
function _M0FP49LING7167111moon_2degui3src4core21line__col__to__cursor(lines, line, col) {
  const num_lines = lines.length;
  if (num_lines === 0) {
    return 0;
  }
  const safe_line = line < 0 ? 0 : line >= num_lines ? num_lines - 1 | 0 : line;
  let pos = 0;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < safe_line) {
      pos = (pos + _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(lines, i).length | 0) + 1 | 0;
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const line_len = _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(lines, safe_line).length;
  const safe_col = col < 0 ? 0 : col > line_len ? line_len : col;
  return pos + safe_col | 0;
}
function _M0FP49LING7167111moon_2degui3src4core17is__comment__line(line) {
  const len = line.length;
  let i = 0;
  while (true) {
    let _tmp;
    if (i < len) {
      let _tmp$2;
      const _tmp$3 = i;
      const _p = _tmp$3 >>> 0 < line.length ? line.charCodeAt(_tmp$3) : $oob();
      const _p$2 = 32;
      if (_p === _p$2) {
        _tmp$2 = true;
      } else {
        const _tmp$4 = i;
        const _p$3 = _tmp$4 >>> 0 < line.length ? line.charCodeAt(_tmp$4) : $oob();
        const _p$4 = 9;
        _tmp$2 = _p$3 === _p$4;
      }
      _tmp = _tmp$2;
    } else {
      _tmp = false;
    }
    if (_tmp) {
      i = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  if ((i + 1 | 0) < len) {
    let _tmp;
    const _tmp$2 = i;
    const _p = _tmp$2 >>> 0 < line.length ? line.charCodeAt(_tmp$2) : $oob();
    const _p$2 = 47;
    if (_p === _p$2) {
      const _tmp$3 = i + 1 | 0;
      const _p$3 = _tmp$3 >>> 0 < line.length ? line.charCodeAt(_tmp$3) : $oob();
      const _p$4 = 47;
      _tmp = _p$3 === _p$4;
    } else {
      _tmp = false;
    }
    return _tmp;
  } else {
    return false;
  }
}
function _M0FP49LING7167111moon_2degui3src4core20hit__test__char__pos(ctx, text, click_x, font_size) {
  const len = text.length;
  if (len === 0 || click_x <= 0) {
    return 0;
  }
  const total_w = _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(ctx, text, font_size).x;
  if (click_x >= total_w) {
    return len;
  }
  const boundaries = [0];
  let idx = 0;
  while (true) {
    if (idx < len) {
      idx = _M0FP49LING7167111moon_2degui3src4core20next__char__boundary(text, idx);
      _M0MPC15array5Array4pushGiE(boundaries, idx);
      continue;
    } else {
      break;
    }
  }
  const num_b = boundaries.length;
  let low = 0;
  let high = num_b - 1 | 0;
  while (true) {
    if (low < high) {
      const mid = (low + high | 0) / 2 | 0;
      const sub = _M0FP49LING7167111moon_2degui3src4core13string__slice(text, 0, _M0MPC15array5Array2atGiE(boundaries, mid));
      const w = _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(ctx, sub, font_size).x;
      if (w < click_x) {
        low = mid + 1 | 0;
      } else {
        high = mid;
      }
      continue;
    } else {
      break;
    }
  }
  const c1 = _M0MPC15array5Array2atGiE(boundaries, low);
  const w1 = _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(ctx, _M0FP49LING7167111moon_2degui3src4core13string__slice(text, 0, c1), font_size).x;
  const d1 = click_x > w1 ? click_x - w1 : w1 - click_x;
  if (low > 0) {
    const c0 = _M0MPC15array5Array2atGiE(boundaries, low - 1 | 0);
    const w0 = _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(ctx, _M0FP49LING7167111moon_2degui3src4core13string__slice(text, 0, c0), font_size).x;
    const d0 = click_x > w0 ? click_x - w0 : w0 - click_x;
    return d0 <= d1 ? c0 : c1;
  } else {
    return c1;
  }
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext20code__editor_2einner(self, id_salt, text, size, show_line_numbers, read_only) {
  const default_w = self.available_width > 0 ? self.available_width : 480;
  let editor_size;
  if (size === undefined) {
    editor_size = _M0MP49LING7167111moon_2degui3src4math4Vec23new(default_w, 220);
  } else {
    const _Some = size;
    editor_size = _Some;
  }
  const id = _M0MP49LING7167111moon_2degui3src4core7IdStack10derive__id(self.id_stack, `code_editor::${id_salt}`);
  const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext15allocate__space(self, editor_size);
  const _rect = _bind._1;
  const _resp = _bind._2;
  if (_resp.hovered) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext17set__cursor__icon(self, "text");
  }
  _M0MP49LING7167111moon_2degui3src4core9UIContext19register__focusable(self, id);
  if (_resp.pressed || _resp.clicked) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext14request__focus(self, id);
    _M0MP49LING7167111moon_2degui3src4core9UIContext19reset__caret__blink(self);
  }
  const is_focused = _M0MP49LING7167111moon_2degui3src4core9UIContext10has__focus(self, id);
  let cursor_pos = _M0MP49LING7167111moon_2degui3src4core9UIContext22get__text__cursor__pos(self, id, text.length);
  let selection_anchor = _M0MP49LING7167111moon_2degui3src4core9UIContext28get__text__selection__anchor(self, id);
  let current_text = text;
  let lines = _M0FP49LING7167111moon_2degui3src4core12split__lines(current_text);
  const scale = self.style.scale;
  const code_font_sz = self.style.code_editor_font_size * scale;
  const gutter_font_sz = self.style.code_editor_gutter_font_size * scale;
  const gutter_w = show_line_numbers ? self.style.code_editor_gutter_w * scale : 0;
  const line_h = self.style.code_editor_line_h * scale;
  const pad_top = 8 * scale;
  const pad_code_x = 10 * scale;
  let scroll_y = _M0MP49LING7167111moon_2degui3src4core9UIContext19get__scroll__offset(self, id);
  if ((_resp.hovered || _resp.pressed) && self.input.scroll_delta.y !== 0) {
    scroll_y = scroll_y - self.input.scroll_delta.y;
  }
  const total_lines = lines.length;
  const content_h = pad_top * 2 + (total_lines + 0) * line_h;
  const max_scroll = content_h > _rect.h ? content_h - _rect.h : 0;
  const code_x = _rect.x + gutter_w + pad_code_x;
  const click_x = self.input.mouse_pos.x - code_x;
  const my = self.input.mouse_pos.y - (_rect.y + pad_top) + scroll_y;
  let click_line;
  if (my < 0) {
    click_line = 0;
  } else {
    const l = _M0MPC16double6Double7to__int(my / line_h);
    click_line = l >= lines.length ? lines.length - 1 | 0 : l;
  }
  const target_line = click_line < 0 ? 0 : click_line;
  const line_str = target_line < lines.length ? _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(lines, target_line) : "";
  const target_col = _M0FP49LING7167111moon_2degui3src4core20hit__test__char__pos(self, line_str, click_x, code_font_sz);
  const hit_cursor = _M0FP49LING7167111moon_2degui3src4core21line__col__to__cursor(lines, target_line, target_col);
  if (self.input.mouse_pressed && (_resp.hovered || _resp.pressed)) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext14request__focus(self, id);
    _M0MP49LING7167111moon_2degui3src4core9UIContext19reset__caret__blink(self);
    if (self.input.modifiers.shift) {
      const _bind$2 = selection_anchor;
      if (_bind$2 === undefined) {
        selection_anchor = cursor_pos;
      }
    } else {
      selection_anchor = undefined;
    }
    cursor_pos = hit_cursor;
  } else {
    if (_resp.dragged) {
      const _bind$2 = selection_anchor;
      if (_bind$2 === undefined) {
        selection_anchor = cursor_pos;
      }
      cursor_pos = hit_cursor;
    }
  }
  if (is_focused) {
    let _tmp;
    if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 6)) {
      _tmp = true;
    } else {
      let _tmp$2;
      if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 7)) {
        _tmp$2 = true;
      } else {
        let _tmp$3;
        if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 8)) {
          _tmp$3 = true;
        } else {
          let _tmp$4;
          if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 9)) {
            _tmp$4 = true;
          } else {
            let _tmp$5;
            if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 10)) {
              _tmp$5 = true;
            } else {
              let _tmp$6;
              if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 11)) {
                _tmp$6 = true;
              } else {
                let _tmp$7;
                if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 2)) {
                  _tmp$7 = true;
                } else {
                  let _tmp$8;
                  if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 4)) {
                    _tmp$8 = true;
                  } else {
                    let _tmp$9;
                    if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 0)) {
                      _tmp$9 = true;
                    } else {
                      let _tmp$10;
                      if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 1)) {
                        _tmp$10 = true;
                      } else {
                        const _p = self.input;
                        const _p$2 = _p.text_input;
                        _tmp$10 = !(_p$2 === "");
                      }
                      _tmp$9 = _tmp$10;
                    }
                    _tmp$8 = _tmp$9;
                  }
                  _tmp$7 = _tmp$8;
                }
                _tmp$6 = _tmp$7;
              }
              _tmp$5 = _tmp$6;
            }
            _tmp$4 = _tmp$5;
          }
          _tmp$3 = _tmp$4;
        }
        _tmp$2 = _tmp$3;
      }
      _tmp = _tmp$2;
    }
    if (_tmp) {
      _M0MP49LING7167111moon_2degui3src4core9UIContext19reset__caret__blink(self);
    }
    const shift_held = self.input.modifiers.shift;
    const ctrl_held = self.input.modifiers.ctrl || self.input.modifiers.meta;
    if (ctrl_held && _M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 14)) {
      _M0MP49LING7167111moon_2degui3src4core10InputState12consume__key(self.input, 14);
      selection_anchor = _M0MP49LING7167111moon_2degui3src4core9UIContext20code__editor_2einnerN6constrS4239;
      cursor_pos = current_text.length;
    }
    const _bind$2 = _M0FP49LING7167111moon_2degui3src4core21cursor__to__line__col(current_text, cursor_pos);
    const _cur_line = _bind$2._0;
    const _cur_col = _bind$2._1;
    if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 6)) {
      _L: {
        _L$2: {
          if (shift_held) {
            const _bind$3 = selection_anchor;
            if (_bind$3 === undefined) {
              selection_anchor = cursor_pos;
            } else {
              break _L$2;
            }
          } else {
            break _L$2;
          }
          break _L;
        }
        if (!shift_held) {
          selection_anchor = undefined;
        }
      }
      cursor_pos = _M0FP49LING7167111moon_2degui3src4core20prev__char__boundary(current_text, cursor_pos);
    }
    if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 7)) {
      _L: {
        _L$2: {
          if (shift_held) {
            const _bind$3 = selection_anchor;
            if (_bind$3 === undefined) {
              selection_anchor = cursor_pos;
            } else {
              break _L$2;
            }
          } else {
            break _L$2;
          }
          break _L;
        }
        if (!shift_held) {
          selection_anchor = undefined;
        }
      }
      cursor_pos = _M0FP49LING7167111moon_2degui3src4core20next__char__boundary(current_text, cursor_pos);
    }
    if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 8)) {
      _L: {
        _L$2: {
          if (shift_held) {
            const _bind$3 = selection_anchor;
            if (_bind$3 === undefined) {
              selection_anchor = cursor_pos;
            } else {
              break _L$2;
            }
          } else {
            break _L$2;
          }
          break _L;
        }
        if (!shift_held) {
          selection_anchor = undefined;
        }
      }
      if (_cur_line > 0) {
        cursor_pos = _M0FP49LING7167111moon_2degui3src4core21line__col__to__cursor(lines, _cur_line - 1 | 0, _cur_col);
      } else {
        cursor_pos = 0;
      }
    }
    if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 9)) {
      _L: {
        _L$2: {
          if (shift_held) {
            const _bind$3 = selection_anchor;
            if (_bind$3 === undefined) {
              selection_anchor = cursor_pos;
            } else {
              break _L$2;
            }
          } else {
            break _L$2;
          }
          break _L;
        }
        if (!shift_held) {
          selection_anchor = undefined;
        }
      }
      if (_cur_line < (lines.length - 1 | 0)) {
        cursor_pos = _M0FP49LING7167111moon_2degui3src4core21line__col__to__cursor(lines, _cur_line + 1 | 0, _cur_col);
      } else {
        cursor_pos = current_text.length;
      }
    }
    if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 10)) {
      _L: {
        _L$2: {
          if (shift_held) {
            const _bind$3 = selection_anchor;
            if (_bind$3 === undefined) {
              selection_anchor = cursor_pos;
            } else {
              break _L$2;
            }
          } else {
            break _L$2;
          }
          break _L;
        }
        if (!shift_held) {
          selection_anchor = undefined;
        }
      }
      if (ctrl_held) {
        cursor_pos = 0;
      } else {
        cursor_pos = _M0FP49LING7167111moon_2degui3src4core21line__col__to__cursor(lines, _cur_line, 0);
      }
    }
    if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 11)) {
      _L: {
        _L$2: {
          if (shift_held) {
            const _bind$3 = selection_anchor;
            if (_bind$3 === undefined) {
              selection_anchor = cursor_pos;
            } else {
              break _L$2;
            }
          } else {
            break _L$2;
          }
          break _L;
        }
        if (!shift_held) {
          selection_anchor = undefined;
        }
      }
      if (ctrl_held) {
        cursor_pos = current_text.length;
      } else {
        cursor_pos = _M0FP49LING7167111moon_2degui3src4core21line__col__to__cursor(lines, _cur_line, _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(lines, _cur_line).length);
      }
    }
    if (!read_only) {
      let has_sel;
      let s_start;
      let s_end;
      _L: {
        const _bind$3 = selection_anchor;
        if (_bind$3 === undefined) {
          has_sel = false;
          s_start = 0;
          s_end = 0;
          break _L;
        } else {
          const _Some = _bind$3;
          const _a = _Some;
          if (_a !== cursor_pos) {
            const s = _a < cursor_pos ? _a : cursor_pos;
            const e = _a > cursor_pos ? _a : cursor_pos;
            has_sel = true;
            s_start = s;
            s_end = e;
            break _L;
          } else {
            has_sel = false;
            s_start = 0;
            s_end = 0;
            break _L;
          }
        }
      }
      if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 2)) {
        _M0MP49LING7167111moon_2degui3src4core10InputState12consume__key(self.input, 2);
        let insert_at;
        let left;
        let right;
        _L$2: {
          if (has_sel) {
            insert_at = s_start;
            left = _M0FP49LING7167111moon_2degui3src4core13string__slice(current_text, 0, s_start);
            right = _M0FP49LING7167111moon_2degui3src4core13string__slice(current_text, s_end, current_text.length);
            break _L$2;
          } else {
            insert_at = cursor_pos;
            left = _M0FP49LING7167111moon_2degui3src4core13string__slice(current_text, 0, cursor_pos);
            right = _M0FP49LING7167111moon_2degui3src4core13string__slice(current_text, cursor_pos, current_text.length);
            break _L$2;
          }
        }
        current_text = `${left}\n${right}`;
        cursor_pos = insert_at + 1 | 0;
        selection_anchor = undefined;
        lines = _M0FP49LING7167111moon_2degui3src4core12split__lines(current_text);
      }
      if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 4)) {
        _M0MP49LING7167111moon_2degui3src4core10InputState12consume__key(self.input, 4);
        let insert_at;
        let left;
        let right;
        _L$2: {
          if (has_sel) {
            insert_at = s_start;
            left = _M0FP49LING7167111moon_2degui3src4core13string__slice(current_text, 0, s_start);
            right = _M0FP49LING7167111moon_2degui3src4core13string__slice(current_text, s_end, current_text.length);
            break _L$2;
          } else {
            insert_at = cursor_pos;
            left = _M0FP49LING7167111moon_2degui3src4core13string__slice(current_text, 0, cursor_pos);
            right = _M0FP49LING7167111moon_2degui3src4core13string__slice(current_text, cursor_pos, current_text.length);
            break _L$2;
          }
        }
        current_text = `${left}  ${right}`;
        cursor_pos = insert_at + 2 | 0;
        selection_anchor = undefined;
        lines = _M0FP49LING7167111moon_2degui3src4core12split__lines(current_text);
      }
      if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 0)) {
        if (has_sel) {
          const left = _M0FP49LING7167111moon_2degui3src4core13string__slice(current_text, 0, s_start);
          const right = _M0FP49LING7167111moon_2degui3src4core13string__slice(current_text, s_end, current_text.length);
          current_text = `${left}${right}`;
          cursor_pos = s_start;
          selection_anchor = undefined;
          lines = _M0FP49LING7167111moon_2degui3src4core12split__lines(current_text);
        } else {
          if (cursor_pos > 0 && current_text.length > 0) {
            const _bind$3 = _M0FP49LING7167111moon_2degui3src4core18delete__prev__char(current_text, cursor_pos);
            const _new_text = _bind$3._0;
            const _new_pos = _bind$3._1;
            current_text = _new_text;
            cursor_pos = _new_pos;
            lines = _M0FP49LING7167111moon_2degui3src4core12split__lines(current_text);
          }
        }
      }
      if (_M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(self.input, 1)) {
        if (has_sel) {
          const left = _M0FP49LING7167111moon_2degui3src4core13string__slice(current_text, 0, s_start);
          const right = _M0FP49LING7167111moon_2degui3src4core13string__slice(current_text, s_end, current_text.length);
          current_text = `${left}${right}`;
          cursor_pos = s_start;
          selection_anchor = undefined;
          lines = _M0FP49LING7167111moon_2degui3src4core12split__lines(current_text);
        } else {
          if (cursor_pos < current_text.length) {
            current_text = _M0FP49LING7167111moon_2degui3src4core18delete__next__char(current_text, cursor_pos);
            lines = _M0FP49LING7167111moon_2degui3src4core12split__lines(current_text);
          }
        }
      }
      const _p = self.input;
      const input_str = _p.text_input;
      if (!(input_str === "")) {
        let insert_at;
        let left;
        let right;
        _L$2: {
          if (has_sel) {
            insert_at = s_start;
            left = _M0FP49LING7167111moon_2degui3src4core13string__slice(current_text, 0, s_start);
            right = _M0FP49LING7167111moon_2degui3src4core13string__slice(current_text, s_end, current_text.length);
            break _L$2;
          } else {
            insert_at = cursor_pos;
            left = _M0FP49LING7167111moon_2degui3src4core13string__slice(current_text, 0, cursor_pos);
            right = _M0FP49LING7167111moon_2degui3src4core13string__slice(current_text, cursor_pos, current_text.length);
            break _L$2;
          }
        }
        current_text = `${left}${input_str}${right}`;
        cursor_pos = insert_at + input_str.length | 0;
        selection_anchor = undefined;
        lines = _M0FP49LING7167111moon_2degui3src4core12split__lines(current_text);
      }
    }
  }
  const _bind$2 = _M0FP49LING7167111moon_2degui3src4core21cursor__to__line__col(current_text, cursor_pos);
  const _active_line = _bind$2._0;
  const _active_col = _bind$2._1;
  if (is_focused) {
    const caret_rel_y = pad_top + (_active_line + 0) * line_h;
    if (caret_rel_y - scroll_y < pad_top) {
      scroll_y = caret_rel_y - pad_top;
    } else {
      if (caret_rel_y + line_h - scroll_y > _rect.h - pad_top) {
        scroll_y = caret_rel_y + line_h - (_rect.h - pad_top);
      }
    }
  }
  if (scroll_y > max_scroll) {
    scroll_y = max_scroll;
  }
  if (scroll_y < 0) {
    scroll_y = 0;
  }
  _M0MP49LING7167111moon_2degui3src4core9UIContext19set__scroll__offset(self, id, scroll_y);
  _M0MP49LING7167111moon_2degui3src4core9UIContext22set__text__cursor__pos(self, id, cursor_pos);
  _M0MP49LING7167111moon_2degui3src4core9UIContext28set__text__selection__anchor(self, id, selection_anchor);
  let has_selection;
  let sel_start;
  let sel_end;
  _L: {
    const _bind$3 = selection_anchor;
    if (_bind$3 === undefined) {
      has_selection = false;
      sel_start = 0;
      sel_end = 0;
      break _L;
    } else {
      const _Some = _bind$3;
      const _a = _Some;
      if (_a !== cursor_pos) {
        const s = _a < cursor_pos ? _a : cursor_pos;
        const e = _a > cursor_pos ? _a : cursor_pos;
        has_selection = true;
        sel_start = s;
        sel_end = e;
        break _L;
      } else {
        has_selection = false;
        sel_start = 0;
        sel_end = 0;
        break _L;
      }
    }
  }
  const border_col = is_focused ? _M0MP49LING7167111moon_2degui3src5color5Color13border__focus() : _resp.hovered ? _M0MP49LING7167111moon_2degui3src5color5Color14border__strong() : _M0MP49LING7167111moon_2degui3src5color5Color15border__default();
  const editor_radius = self.style.code_editor_radius * scale;
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, _rect, _M0MP49LING7167111moon_2degui3src5color5Color10bg__window(), editor_radius);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(self.draw_list, _rect, border_col, 1, editor_radius);
  const clip_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(_rect.x + 1, _rect.y + 1, _rect.w - 2, _rect.h - 2);
  _M0MP49LING7167111moon_2degui3src4core9UIContext10push__clip(self, clip_rect);
  if (show_line_numbers) {
    const gutter_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(_rect.x, _rect.y, gutter_w, _rect.h);
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, gutter_rect, _M0MP49LING7167111moon_2degui3src5color5Color10bg__subtle(), 0);
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(_rect.x + gutter_w, _rect.y), _M0MP49LING7167111moon_2degui3src4math4Vec23new(_rect.x + gutter_w, _rect.y + _rect.h), _M0MP49LING7167111moon_2degui3src5color5Color13border__muted(), 1);
  }
  if (is_focused && (!has_selection && _active_line < lines.length)) {
    const active_y = _rect.y + pad_top + (_active_line + 0) * line_h - scroll_y;
    if (active_y + line_h >= _rect.y && active_y <= _rect.y + _rect.h) {
      const wash_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(_rect.x + gutter_w + 1, active_y, _rect.w - gutter_w - 2, line_h);
      _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, wash_rect, _M0MP49LING7167111moon_2degui3src5color5Color11bg__surface(), 0);
    }
  }
  if (has_selection) {
    let offset = 0;
    let _tmp = 0;
    while (true) {
      const idx = _tmp;
      if (idx < lines.length) {
        const line_len = _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(lines, idx).length;
        const line_start = offset;
        const line_end = offset + line_len | 0;
        offset = line_end + 1 | 0;
        const o_start = sel_start > line_start ? sel_start : line_start;
        const o_end = sel_end < line_end ? sel_end : line_end;
        if (o_start < o_end) {
          const line_y = _rect.y + pad_top + (idx + 0) * line_h - scroll_y;
          if (line_y + line_h >= _rect.y && line_y <= _rect.y + _rect.h) {
            const pre = _M0FP49LING7167111moon_2degui3src4core13string__slice(_M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(lines, idx), 0, o_start - line_start | 0);
            const sel = _M0FP49LING7167111moon_2degui3src4core13string__slice(_M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(lines, idx), o_start - line_start | 0, o_end - line_start | 0);
            const pre_w = _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(self, pre, code_font_sz).x;
            const sel_w = _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(self, sel, code_font_sz).x;
            const sel_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(code_x + pre_w, line_y, sel_w, line_h);
            _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, sel_rect, _M0MP49LING7167111moon_2degui3src5color5Color12accent__soft(), 0);
          }
        }
        _tmp = idx + 1 | 0;
        continue;
      } else {
        break;
      }
    }
  }
  let _tmp = 0;
  while (true) {
    const idx = _tmp;
    if (idx < lines.length) {
      _L$2: {
        const line_text = _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(lines, idx);
        const line_y = _rect.y + pad_top + (idx + 0) * line_h - scroll_y;
        if (line_y + line_h < _rect.y) {
          break _L$2;
        }
        if (line_y > _rect.y + _rect.h) {
          break;
        }
        if (show_line_numbers) {
          const num_str = _M0MPC13int3Int18to__string_2einner(idx + 1 | 0, 10);
          const num_size = _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(self, num_str, gutter_font_sz);
          const num_x = _rect.x + gutter_w - num_size.x - 8 * scale;
          const num_col = idx === _active_line && is_focused ? _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary() : _M0MP49LING7167111moon_2degui3src5color5Color14text__disabled();
          _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(num_x, line_y + 3 * scale), num_str, gutter_font_sz, num_col);
        }
        const text_col = _M0FP49LING7167111moon_2degui3src4core17is__comment__line(line_text) ? _M0MP49LING7167111moon_2degui3src5color5Color11text__muted() : _M0MP49LING7167111moon_2degui3src5color5Color13text__primary();
        _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(code_x, line_y + 3 * scale), line_text, code_font_sz, text_col);
        break _L$2;
      }
      _tmp = idx + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  if (is_focused && (_M0MP49LING7167111moon_2degui3src4core9UIContext18is__caret__visible(self) && _active_line < lines.length)) {
    const active_str = _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(lines, _active_line);
    const prefix = _M0FP49LING7167111moon_2degui3src4core13string__slice(active_str, 0, _active_col);
    const prefix_w = _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(self, prefix, code_font_sz).x;
    const caret_x = _rect.x + gutter_w + pad_code_x + prefix_w;
    const caret_y = _rect.y + pad_top + (_active_line + 0) * line_h - scroll_y + 3 * scale;
    if (caret_y + self.style.caret_h * scale >= _rect.y && caret_y <= _rect.y + _rect.h) {
      _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(caret_x, caret_y), _M0MP49LING7167111moon_2degui3src4math4Vec23new(caret_x, caret_y + self.style.caret_h * scale), _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary(), 1.5 * scale);
    }
  }
  if (max_scroll > 0 && content_h > 0) {
    const bar_w = 4 * scale;
    const bar_x = _rect.x + _rect.w - bar_w - 2 * scale;
    const track_h = _rect.h - 4 * scale;
    const thumb_ratio = _rect.h / content_h;
    const raw_thumb_h = track_h * thumb_ratio;
    const thumb_h = raw_thumb_h < 20 * scale ? 20 * scale : raw_thumb_h;
    const scroll_ratio = scroll_y / max_scroll;
    const thumb_y = _rect.y + 2 * scale + (track_h - thumb_h) * scroll_ratio;
    const thumb_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(bar_x, thumb_y, bar_w, thumb_h);
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, thumb_rect, _M0MP49LING7167111moon_2degui3src5color5Color15border__default(), self.style.radius_sm * scale);
  }
  _M0MP49LING7167111moon_2degui3src4core9UIContext9pop__clip(self);
  const _tmp$2 = _resp.hovered;
  const _tmp$3 = _resp.clicked;
  const _tmp$4 = _resp.pressed;
  const _tmp$5 = _resp.dragged;
  const _tmp$6 = is_focused && _M0IP016_24default__implPB2Eq10not__equalGRP49LING7167111moon_2degui3src4core2IdE(self.prev_focused_id, id);
  const _p = self.lost_focus_id;
  const editor_resp = _M0MP49LING7167111moon_2degui3src4core8Response19with__focus_2einner(id, _rect, _tmp$2, _tmp$3, _tmp$4, _tmp$5, is_focused, _tmp$6, BigInt.asUintN(64, _p.val) === BigInt.asUintN(64, id.val), _resp.secondary_clicked);
  return { _0: current_text, _1: editor_resp };
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext14button_2einner(self, text, shortcut, primary, size) {
  const scale = self.style.scale;
  const font_size = self.style.font_normal * scale;
  const text_size = _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(self, text, font_size);
  const text_w = text_size.x;
  const has_shortcut = shortcut.length > 0;
  const kbd_font_size = self.style.font_small * scale;
  const kbd_w = has_shortcut ? _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(self, shortcut, kbd_font_size).x + 14 * scale : 0;
  const min_w = has_shortcut ? (self.style.button_min_w + 20) * scale : self.style.button_min_w * scale;
  const pad_w = has_shortcut ? 36 * scale : self.style.button_pad_x * 2 * scale;
  const content_w = has_shortcut ? text_w + kbd_w + pad_w : text_w + pad_w;
  const auto_w = content_w > min_w ? content_w : min_w;
  const w = size.x > 0 ? size.x : auto_w;
  const h = size.y > 0 ? size.y : self.style.button_h * scale;
  const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext15allocate__space(self, _M0MP49LING7167111moon_2degui3src4math4Vec23new(w, h));
  const _id = _bind._0;
  const _rect = _bind._1;
  const _resp = _bind._2;
  _M0MP49LING7167111moon_2degui3src4core9UIContext19register__focusable(self, _id);
  if (_resp.hovered) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext17set__cursor__icon(self, "pointer");
  }
  const press_offset = _resp.pressed ? 1.5 * scale : 0;
  const draw_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(_rect.x, _rect.y + press_offset, _rect.w, _rect.h - press_offset);
  const bg_color = primary ? (_resp.pressed ? _M0MP49LING7167111moon_2degui3src5color5Color15accent__pressed() : _resp.hovered ? _M0MP49LING7167111moon_2degui3src5color5Color13accent__hover() : _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary()) : _resp.pressed ? _M0MP49LING7167111moon_2degui3src5color5Color11bg__surface() : _resp.hovered ? _M0MP49LING7167111moon_2degui3src5color5Color10bg__subtle() : _M0MP49LING7167111moon_2degui3src5color5Color10bg__window();
  const border_color = _resp.has_focus ? _M0MP49LING7167111moon_2degui3src5color5Color13border__focus() : primary ? (_resp.pressed ? _M0MP49LING7167111moon_2degui3src5color5Color12accent__deep() : _M0MP49LING7167111moon_2degui3src5color5Color15accent__pressed()) : _resp.pressed ? _M0MP49LING7167111moon_2degui3src5color5Color14border__strong() : _resp.hovered ? _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary() : _M0MP49LING7167111moon_2degui3src5color5Color15border__default();
  const text_color = primary ? _M0MP49LING7167111moon_2degui3src5color5Color13text__inverse() : _resp.pressed ? _M0MP49LING7167111moon_2degui3src5color5Color12text__strong() : _resp.hovered ? _M0MP49LING7167111moon_2degui3src5color5Color13text__primary() : _M0MP49LING7167111moon_2degui3src5color5Color10text__body();
  const radius = self.style.button_radius * scale;
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, draw_rect, bg_color, radius);
  const stroke_w = _resp.has_focus ? 1.5 * scale : 1;
  _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(self.draw_list, draw_rect, border_color, stroke_w, radius);
  if (has_shortcut) {
    const text_x = draw_rect.x + 12 * scale;
    const text_y = draw_rect.y + (draw_rect.h - font_size) * 0.5;
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(text_x, text_y), text, font_size, text_color);
    const kbd_h = 18 * scale;
    const kbd_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(draw_rect.x + draw_rect.w - kbd_w - 10 * scale, draw_rect.y + (draw_rect.h - kbd_h) * 0.5, kbd_w, kbd_h);
    let kbd_bg;
    let kbd_col;
    _L: {
      if (primary) {
        kbd_bg = _M0MP49LING7167111moon_2degui3src5color5Color17accent__highlight();
        kbd_col = _M0MP49LING7167111moon_2degui3src5color5Color13text__inverse();
        break _L;
      } else {
        kbd_bg = _resp.pressed ? _M0MP49LING7167111moon_2degui3src5color5Color13border__muted() : _resp.hovered ? _M0MP49LING7167111moon_2degui3src5color5Color10bg__active() : _M0MP49LING7167111moon_2degui3src5color5Color11bg__surface();
        kbd_col = _resp.hovered ? _M0MP49LING7167111moon_2degui3src5color5Color13text__primary() : _M0MP49LING7167111moon_2degui3src5color5Color11text__muted();
        break _L;
      }
    }
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, kbd_rect, kbd_bg, self.style.radius_sm * scale);
    const sc_w = _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(self, shortcut, kbd_font_size).x;
    const kbd_text_x = kbd_rect.x + (kbd_rect.w - sc_w) * 0.5;
    const kbd_text_y = kbd_rect.y + (kbd_rect.h - kbd_font_size) * 0.5;
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(kbd_text_x, kbd_text_y), shortcut, kbd_font_size, kbd_col);
  } else {
    const text_x = draw_rect.x + (draw_rect.w - text_w) * 0.5;
    const text_y = draw_rect.y + (draw_rect.h - font_size) * 0.5;
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(text_x, text_y), text, font_size, text_color);
  }
  return _resp;
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext6button(self, text, shortcut$46$opt, primary$46$opt, size$46$opt) {
  let shortcut;
  if (shortcut$46$opt === undefined) {
    shortcut = "";
  } else {
    const _Some = shortcut$46$opt;
    shortcut = _Some;
  }
  const primary = primary$46$opt === -1 ? false : primary$46$opt;
  let size;
  if (size$46$opt === undefined) {
    size = _M0MP49LING7167111moon_2degui3src4math4Vec24zeroN6recordS89;
  } else {
    const _Some = size$46$opt;
    size = _Some;
  }
  return _M0MP49LING7167111moon_2degui3src4core9UIContext14button_2einner(self, text, shortcut, primary, size);
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext13button__sized(self, text, size) {
  return _M0MP49LING7167111moon_2degui3src4core9UIContext14button_2einner(self, text, "", false, size);
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext22button__primary__sized(self, text, size) {
  return _M0MP49LING7167111moon_2degui3src4core9UIContext14button_2einner(self, text, "", true, size);
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext15button__primary(self, text) {
  return _M0MP49LING7167111moon_2degui3src4core9UIContext6button(self, text, undefined, _M0MP49LING7167111moon_2degui3src4core9UIContext15button__primaryN6constrS4240, undefined);
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext22button__with__shortcut(self, text, shortcut) {
  return _M0MP49LING7167111moon_2degui3src4core9UIContext6button(self, text, shortcut, -1, undefined);
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext13color__button(self, _id_str, color) {
  const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext15allocate__space(self, _M0MP49LING7167111moon_2degui3src4math4Vec23new(22, 22));
  const _rect = _bind._1;
  const _resp = _bind._2;
  if (_resp.hovered) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext17set__cursor__icon(self, "pointer");
  }
  const press_offset = _resp.pressed ? 1 : 0;
  const btn_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(_rect.x, _rect.y + press_offset, 22, 22 - press_offset);
  const border_color = _resp.pressed ? _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary() : _resp.hovered ? _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary() : _M0MP49LING7167111moon_2degui3src5color5Color15border__default();
  const swatch_radius = self.style.text_edit_radius;
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, btn_rect, color, swatch_radius);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(self.draw_list, btn_rect, border_color, 1.5, swatch_radius);
  return { _0: _resp.clicked, _1: _resp };
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext18breadcrumb_2einner(self, id_salt, items, separator, max_visible) {
  const count = items.length;
  if (count === 0) {
    const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext15allocate__space(self, _M0MP49LING7167111moon_2degui3src4math4Vec24zeroN6recordS89);
    const _resp = _bind._2;
    return { _0: undefined, _1: _resp };
  }
  const font_sz = self.style.font_normal;
  const sep_sz = _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(self, separator, font_sz);
  const display_items = [];
  const should_fold = max_visible > 2 && count > max_visible;
  if (should_fold) {
    _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(display_items, { _0: _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(items, 0), _1: 0 });
    _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(display_items, _M0MP49LING7167111moon_2degui3src4core9UIContext18breadcrumb_2einnerN5tupleS4241);
    const tail_start = count - (max_visible - 2 | 0) | 0;
    let _tmp = tail_start;
    while (true) {
      const i = _tmp;
      if (i < count) {
        _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(display_items, { _0: _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(items, i), _1: i });
        _tmp = i + 1 | 0;
        continue;
      } else {
        break;
      }
    }
  } else {
    let _tmp = 0;
    while (true) {
      const i = _tmp;
      if (i < count) {
        _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(display_items, { _0: _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(items, i), _1: i });
        _tmp = i + 1 | 0;
        continue;
      } else {
        break;
      }
    }
  }
  let total_w = 0;
  const num_display = display_items.length;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < num_display) {
      const item_sz = _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(self, _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(display_items, i)._0, font_sz);
      total_w = total_w + item_sz.x + 8;
      if (i < (num_display - 1 | 0)) {
        total_w = total_w + sep_sz.x + 12;
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  _M0MP49LING7167111moon_2degui3src4core9UIContext8push__id(self, id_salt);
  const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext15allocate__space(self, _M0MP49LING7167111moon_2degui3src4math4Vec23new(total_w, 26));
  const _rect = _bind._1;
  const _resp = _bind._2;
  _M0MP49LING7167111moon_2degui3src4core9UIContext7pop__id(self);
  let current_x = _rect.x;
  let clicked_idx = undefined;
  let _tmp$2 = 0;
  while (true) {
    const i = _tmp$2;
    if (i < num_display) {
      const _bind$2 = _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(display_items, i);
      const _label = _bind$2._0;
      const _orig_idx = _bind$2._1;
      const item_sz = _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(self, _label, font_sz);
      const is_last = i === (num_display - 1 | 0);
      const item_w = item_sz.x + 8;
      const item_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(current_x, _rect.y, item_w, 26);
      const is_hovered = _M0MP49LING7167111moon_2degui3src4math4Rect8contains(item_rect, self.input.mouse_pos);
      if (!is_last && _orig_idx >= 0) {
        if (is_hovered) {
          _M0MP49LING7167111moon_2degui3src4core9UIContext17set__cursor__icon(self, "pointer");
          _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, item_rect, _M0MP49LING7167111moon_2degui3src5color5Color9bg__hover(), self.style.radius_sm);
          if (self.input.mouse_pressed) {
            clicked_idx = _orig_idx;
          }
        }
      }
      const text_col = is_last ? _M0MP49LING7167111moon_2degui3src5color5Color12text__strong() : is_hovered && _orig_idx >= 0 ? _M0MP49LING7167111moon_2degui3src5color5Color13text__primary() : _M0MP49LING7167111moon_2degui3src5color5Color15text__secondary();
      const text_pos = _M0MP49LING7167111moon_2degui3src4math4Vec23new(current_x + 4, _rect.y + (26 - font_sz) * 0.5);
      _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, text_pos, _label, font_sz, text_col);
      current_x = current_x + item_w;
      if (!is_last) {
        const sep_x = current_x + 6;
        const sep_pos = _M0MP49LING7167111moon_2degui3src4math4Vec23new(sep_x, _rect.y + (26 - font_sz) * 0.5);
        _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, sep_pos, separator, font_sz, _M0MP49LING7167111moon_2degui3src5color5Color14text__disabled());
        current_x = sep_x + sep_sz.x + 6;
      }
      _tmp$2 = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return { _0: clicked_idx, _1: _resp };
}
function _M0FP49LING7167111moon_2degui3src4core13badge__colors(kind) {
  switch (kind) {
    case 0: {
      return { _0: _M0MP49LING7167111moon_2degui3src5color5Color10bg__subtle(), _1: _M0MP49LING7167111moon_2degui3src5color5Color15border__default(), _2: _M0MP49LING7167111moon_2degui3src5color5Color15text__secondary() };
    }
    case 1: {
      return { _0: _M0MP49LING7167111moon_2degui3src5color5Color18badge__success__bg(), _1: _M0MP49LING7167111moon_2degui3src5color5Color22badge__success__border(), _2: _M0MP49LING7167111moon_2degui3src5color5Color20badge__success__text() };
    }
    case 2: {
      return { _0: _M0MP49LING7167111moon_2degui3src5color5Color18badge__warning__bg(), _1: _M0MP49LING7167111moon_2degui3src5color5Color22badge__warning__border(), _2: _M0MP49LING7167111moon_2degui3src5color5Color20badge__warning__text() };
    }
    case 3: {
      return { _0: _M0MP49LING7167111moon_2degui3src5color5Color17badge__danger__bg(), _1: _M0MP49LING7167111moon_2degui3src5color5Color21badge__danger__border(), _2: _M0MP49LING7167111moon_2degui3src5color5Color19badge__danger__text() };
    }
    default: {
      return { _0: _M0MP49LING7167111moon_2degui3src5color5Color15badge__info__bg(), _1: _M0MP49LING7167111moon_2degui3src5color5Color19badge__info__border(), _2: _M0MP49LING7167111moon_2degui3src5color5Color17badge__info__text() };
    }
  }
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext13badge_2einner(self, text, kind, dot, pill) {
  const scale = self.style.scale;
  const font_sz = self.style.font_small * scale;
  const text_sz = _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(self, text, font_sz);
  const dot_w = dot ? self.style.badge_dot_w * scale : 0;
  const pad_x = self.style.badge_pad_x * scale;
  const h = self.style.badge_h * scale;
  const w = pad_x * 2 + dot_w + text_sz.x;
  const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext15allocate__space(self, _M0MP49LING7167111moon_2degui3src4math4Vec23new(w, h));
  const _rect = _bind._1;
  const _resp = _bind._2;
  const radius = pill ? h * 0.5 : self.style.badge_radius * scale;
  const _bind$2 = _M0FP49LING7167111moon_2degui3src4core13badge__colors(kind);
  const _bg = _bind$2._0;
  const _border = _bind$2._1;
  const _fg = _bind$2._2;
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, _rect, _bg, radius);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(self.draw_list, _rect, _border, 1, radius);
  let current_x = _rect.x + pad_x;
  if (dot) {
    const dot_r = 3 * scale;
    const dot_center = _M0MP49LING7167111moon_2degui3src4math4Vec23new(current_x + dot_r, _rect.y + h * 0.5);
    _M0MP49LING7167111moon_2degui3src4draw8DrawList11add__circle(self.draw_list, dot_center, dot_r, _fg);
    current_x = current_x + dot_w;
  }
  const text_y = _rect.y + (h - font_sz) * 0.5;
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(current_x, text_y), text, font_sz, _fg);
  return _resp;
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext11tag_2einner(self, id_salt, text, kind, closable) {
  const font_sz = self.style.font_small;
  const text_sz = _M0MP49LING7167111moon_2degui3src4core9UIContext13measure__text(self, text, font_sz);
  const close_w = closable ? 16 : 0;
  const w = 16 + text_sz.x + close_w;
  _M0MP49LING7167111moon_2degui3src4core9UIContext8push__id(self, id_salt);
  const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext15allocate__space(self, _M0MP49LING7167111moon_2degui3src4math4Vec23new(w, 24));
  const _rect = _bind._1;
  const _resp = _bind._2;
  _M0MP49LING7167111moon_2degui3src4core9UIContext7pop__id(self);
  const _bind$2 = _M0FP49LING7167111moon_2degui3src4core13badge__colors(kind);
  const _bg = _bind$2._0;
  const _border = _bind$2._1;
  const _fg = _bind$2._2;
  const tag_radius = self.style.radius_sm;
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, _rect, _bg, tag_radius);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(self.draw_list, _rect, _border, 1, tag_radius);
  const text_y = _rect.y + (24 - font_sz) * 0.5;
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(_rect.x + 8, text_y), text, font_sz, _fg);
  let closed = false;
  if (closable) {
    const close_box = _M0MP49LING7167111moon_2degui3src4math4Rect3new(_rect.x + w - 8 - 14, _rect.y + 5, 14, 14);
    const is_close_hovered = _M0MP49LING7167111moon_2degui3src4math4Rect8contains(close_box, self.input.mouse_pos);
    if (is_close_hovered) {
      _M0MP49LING7167111moon_2degui3src4core9UIContext17set__cursor__icon(self, "pointer");
      _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, close_box, _M0MP49LING7167111moon_2degui3src5color5Color17tag__close__hover(), tag_radius);
      if (self.input.mouse_pressed) {
        closed = true;
      }
    }
    const x_center = _M0MP49LING7167111moon_2degui3src4math4Rect6center(close_box);
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(x_center.x - 3.5, x_center.y - 3.5), _M0MP49LING7167111moon_2degui3src4math4Vec23new(x_center.x + 3.5, x_center.y + 3.5), _fg, 1.2);
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(x_center.x - 3.5, x_center.y + 3.5), _M0MP49LING7167111moon_2degui3src4math4Vec23new(x_center.x + 3.5, x_center.y - 3.5), _fg, 1.2);
  }
  return { _0: closed, _1: _resp };
}
function _M0FP49LING7167111moon_2degui8examples6canvas17apply__node__jump(state, index, after) {
  const total = Math.imul(state.grid_dim, state.grid_dim) | 0;
  if (index < 0 || index >= total) {
    return undefined;
  }
  state.selected_id = index;
  state.selected_col = index % state.grid_dim | 0;
  state.selected_row = index / state.grid_dim | 0;
  if (after >= 1) {
    state.cam_x = 5000;
    state.cam_y = 5000;
  }
  if (after >= 2) {
    state.zoom = 1;
    return;
  } else {
    return;
  }
}
function _M0FP49LING7167111moon_2degui8examples6canvas16panel__view__tab(ui, state, cur_w, cur_h) {
  _M0MP49LING7167111moon_2degui3src4core9UIContext14label__colored(ui, "矩阵规格", _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary());
  _M0MP49LING7167111moon_2degui3src4core9UIContext10horizontal(ui, (row) => {
    if (_M0MP49LING7167111moon_2degui3src4core9UIContext13button__sized(row, "128", _M0MP49LING7167111moon_2degui3src4math4Vec23new(54, 24)).clicked) {
      state.grid_dim = 128;
      state.selected_id = -1;
    }
    if (_M0MP49LING7167111moon_2degui3src4core9UIContext13button__sized(row, "256", _M0MP49LING7167111moon_2degui3src4math4Vec23new(54, 24)).clicked) {
      state.grid_dim = 256;
      state.selected_id = -1;
    }
    if (_M0MP49LING7167111moon_2degui3src4core9UIContext13button__sized(row, "512", _M0MP49LING7167111moon_2degui3src4math4Vec23new(54, 24)).clicked) {
      state.grid_dim = 512;
      state.selected_id = -1;
    }
    if (_M0MP49LING7167111moon_2degui3src4core9UIContext13button__sized(row, "1024", _M0MP49LING7167111moon_2degui3src4math4Vec23new(54, 24)).clicked) {
      state.grid_dim = 1024;
      state.selected_id = -1;
      return;
    } else {
      return;
    }
  });
  _M0MP49LING7167111moon_2degui3src4core9UIContext9separator(ui);
  const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext6slider(ui, "缩放比例", state.zoom, 0.02, 3);
  const _new_zoom = _bind._0;
  state.zoom = _new_zoom;
  _M0MP49LING7167111moon_2degui3src4core9UIContext9separator(ui);
  const _bind$2 = _M0MP49LING7167111moon_2degui3src4core9UIContext8checkbox(ui, "水波动态物理", state.wave_pulse);
  const _new_pulse = _bind$2._0;
  const _pulse_resp = _bind$2._1;
  if (_pulse_resp.clicked) {
    state.wave_pulse = _new_pulse;
  }
  const _bind$3 = _M0MP49LING7167111moon_2degui3src4core9UIContext8checkbox(ui, "光标磁力斥力", state.magnetic_repel);
  const _new_repel = _bind$3._0;
  const _repel_resp = _bind$3._1;
  if (_repel_resp.clicked) {
    state.magnetic_repel = _new_repel;
  }
  _M0MP49LING7167111moon_2degui3src4core9UIContext9separator(ui);
  _M0MP49LING7167111moon_2degui3src4core9UIContext10horizontal(ui, (row) => {
    if (_M0MP49LING7167111moon_2degui3src4core9UIContext13button__sized(row, "全景自适应", _M0MP49LING7167111moon_2degui3src4math4Vec23new(74, 24)).clicked) {
      const min_dim = cur_w < cur_h ? cur_w : cur_h;
      const fit_z = (min_dim - 60) / 10500;
      state.zoom = fit_z > 0.01 ? fit_z : 0.075;
      state.cam_x = 5000;
      state.cam_y = 5000;
    }
    if (_M0MP49LING7167111moon_2degui3src4core9UIContext13button__sized(row, "居中", _M0MP49LING7167111moon_2degui3src4math4Vec23new(74, 24)).clicked) {
      state.cam_x = 5000;
      state.cam_y = 5000;
    }
    if (_M0MP49LING7167111moon_2degui3src4core9UIContext13button__sized(row, "1:1 像素", _M0MP49LING7167111moon_2degui3src4math4Vec23new(74, 24)).clicked) {
      state.zoom = 1;
      return;
    } else {
      return;
    }
  });
}
function _M0FP49LING7167111moon_2degui8examples6canvas12parse__index(text) {
  if (text === "") {
    return undefined;
  }
  let value = 0;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < text.length) {
      const ch = i >>> 0 < text.length ? text.charCodeAt(i) : $oob();
      if (ch < 48 || ch > 57) {
        return undefined;
      }
      value = (Math.imul(value, 10) | 0) + (ch - 48 | 0) | 0;
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return value;
}
function _M0FP49LING7167111moon_2degui8examples6canvas17panel__input__tab(ui, state) {
  _M0MP49LING7167111moon_2degui3src4core9UIContext14label__colored(ui, "跳转节点序号", _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary());
  const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext10text__edit(ui, "jump_field", state.jump_text, "例如 4321");
  const _new_text = _bind._0;
  const _field_resp = _bind._1;
  state.jump_text = _new_text;
  if (_field_resp.has_focus && _M0MP49LING7167111moon_2degui3src4core10InputState12key__pressed(ui.input, 2)) {
    const _bind$2 = _M0FP49LING7167111moon_2degui8examples6canvas12parse__index(state.jump_text);
    if (_bind$2 === undefined) {
    } else {
      const _Some = _bind$2;
      const _index = _Some;
      _M0FP49LING7167111moon_2degui8examples6canvas17apply__node__jump(state, _index, state.jump_after);
    }
  }
  if (_field_resp.hovered) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext7tooltip(ui, "输入序号后按回车，选中该节点");
  }
  _M0MP49LING7167111moon_2degui3src4core9UIContext9separator(ui);
  const _bind$2 = _M0MP49LING7167111moon_2degui3src4core9UIContext10combo__box(ui, "jump_after", "跳转后", state.jump_after, ["仅选中", "居中", "居中并放大"]);
  const _new_after = _bind$2._0;
  state.jump_after = _new_after;
  _M0MP49LING7167111moon_2degui3src4core9UIContext9separator(ui);
  const _bind$3 = _M0MP49LING7167111moon_2degui3src4core9UIContext6toggle(ui, "显示网格", state.show_grid);
  const _new_grid = _bind$3._0;
  const _grid_resp = _bind$3._1;
  if (_grid_resp.clicked) {
    state.show_grid = _new_grid;
  }
  _M0MP49LING7167111moon_2degui3src4core9UIContext9separator(ui);
  if (state.selected_id >= 0) {
    const info = `选中节点 #${_M0MPC13int3Int18to__string_2einner(state.selected_id, 10)} [列 ${_M0MPC13int3Int18to__string_2einner(state.selected_col, 10)}, 行 ${_M0MPC13int3Int18to__string_2einner(state.selected_row, 10)}]`;
    _M0MP49LING7167111moon_2degui3src4core9UIContext14label__colored(ui, info, _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary());
    return;
  } else {
    _M0MP49LING7167111moon_2degui3src4core9UIContext14label__colored(ui, "点击网格节点或输入序号", _M0MP49LING7167111moon_2degui3src5color5Color11text__muted());
    return;
  }
}
function _M0FP49LING7167111moon_2degui8examples6canvas22render__studio__window(ctx, state, cur_w, cur_h, win_w, win_h) {
  if (!state.show_studio) {
    return undefined;
  }
  const parked_x = cur_w - win_w - 20;
  const initial = _M0MP49LING7167111moon_2degui3src4math4Vec23new(parked_x > 20 ? parked_x : 20, 70);
  const viewport = _M0MP49LING7167111moon_2degui3src4math4Rect3new(0, 0, cur_w, cur_h);
  _M0MP49LING7167111moon_2degui3src4core9UIContext6window(ctx, "控制面板", initial, _M0MP49LING7167111moon_2degui3src4math4Vec23new(win_w, win_h), (ui) => {
    const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext8tab__bar(ui, "panel_tabs", ["视图", "输入"], state.panel_tab);
    const _new_tab = _bind._0;
    state.panel_tab = _new_tab;
    _M0MP49LING7167111moon_2degui3src4core9UIContext9separator(ui);
    if (state.panel_tab === 0) {
      _M0FP49LING7167111moon_2degui8examples6canvas16panel__view__tab(ui, state, cur_w, cur_h);
      return;
    } else {
      _M0FP49LING7167111moon_2degui8examples6canvas17panel__input__tab(ui, state);
      return;
    }
  }, undefined, viewport);
}
function _M0FP49LING7167111moon_2degui8examples6canvas17calc__ruler__step(zoom) {
  const target = 80 / zoom;
  return target > 20000 ? 50000 : target > 10000 ? 20000 : target > 5000 ? 10000 : target > 2000 ? 5000 : target > 1000 ? 2000 : target > 500 ? 1000 : target > 200 ? 500 : target > 100 ? 200 : target > 50 ? 100 : target > 20 ? 50 : 20;
}
function _M0FP49LING7167111moon_2degui8examples6canvas20render__grid__aisles(dl, state, cv_x, cv_y, cv_w, cv_h, sc_x, sc_y) {
  const aisle_col = _M0MP49LING7167111moon_2degui3src5color5Color13border__muted();
  let _tmp = 0;
  while (true) {
    const bi = _tmp;
    if (bi <= 10) {
      const aisle_wx = (bi + 0) * 1000;
      const aisle_sx = sc_x + (aisle_wx - state.cam_x) * state.zoom;
      if (aisle_sx >= cv_x && aisle_sx <= cv_x + cv_w) {
        _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(dl, _M0MP49LING7167111moon_2degui3src4math4Vec23new(aisle_sx, cv_y), _M0MP49LING7167111moon_2degui3src4math4Vec23new(aisle_sx, cv_y + cv_h), aisle_col, 1);
      }
      const aisle_wy = (bi + 0) * 1000;
      const aisle_sy = sc_y + (aisle_wy - state.cam_y) * state.zoom;
      if (aisle_sy >= cv_y && aisle_sy <= cv_y + cv_h) {
        _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(dl, _M0MP49LING7167111moon_2degui3src4math4Vec23new(cv_x, aisle_sy), _M0MP49LING7167111moon_2degui3src4math4Vec23new(cv_x + cv_w, aisle_sy), aisle_col, 1);
      }
      _tmp = bi + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0FP49LING7167111moon_2degui8examples6canvas19render__cad__rulers(dl, state, cv_x, cv_y, cv_w, cv_h, vp_x, vp_y, ruler_w, ruler_h, min_wx, max_wx, min_wy, max_wy, sc_x, sc_y) {
  const ruler_bg = _M0MP49LING7167111moon_2degui3src5color5Color10bg__window();
  const ruler_border = _M0MP49LING7167111moon_2degui3src5color5Color13border__muted();
  const ruler_tick_col = _M0MP49LING7167111moon_2degui3src5color5Color14border__strong();
  const ruler_text_col = _M0MP49LING7167111moon_2degui3src5color5Color15text__secondary();
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(dl, _M0MP49LING7167111moon_2degui3src4math4Rect3new(cv_x, vp_y, cv_w, ruler_h), ruler_bg, 0);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(dl, _M0MP49LING7167111moon_2degui3src4math4Vec23new(cv_x, vp_y + ruler_h), _M0MP49LING7167111moon_2degui3src4math4Vec23new(cv_x + cv_w, vp_y + ruler_h), ruler_border, 1);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(dl, _M0MP49LING7167111moon_2degui3src4math4Rect3new(vp_x, cv_y, ruler_w, cv_h), ruler_bg, 0);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(dl, _M0MP49LING7167111moon_2degui3src4math4Vec23new(vp_x + ruler_w, cv_y), _M0MP49LING7167111moon_2degui3src4math4Vec23new(vp_x + ruler_w, cv_y + cv_h), ruler_border, 1);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(dl, _M0MP49LING7167111moon_2degui3src4math4Rect3new(vp_x, vp_y, ruler_w, ruler_h), _M0MP49LING7167111moon_2degui3src5color5Color11bg__surface(), 0);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(dl, _M0MP49LING7167111moon_2degui3src4math4Vec23new(vp_x + 16, vp_y + 4), "px", 10, ruler_text_col);
  const step_x = _M0FP49LING7167111moon_2degui8examples6canvas17calc__ruler__step(state.zoom);
  const first_tick_x = (_M0MPC16double6Double7to__int(min_wx / step_x) + 0) * step_x;
  let cur_wx = first_tick_x;
  while (true) {
    if (cur_wx <= max_wx) {
      const sx = sc_x + (cur_wx - state.cam_x) * state.zoom;
      if (sx >= cv_x && sx <= cv_x + cv_w) {
        _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(dl, _M0MP49LING7167111moon_2degui3src4math4Vec23new(sx, vp_y + ruler_h - 8), _M0MP49LING7167111moon_2degui3src4math4Vec23new(sx, vp_y + ruler_h), ruler_tick_col, 1);
        const label_txt = _M0MPC13int3Int18to__string_2einner(_M0MPC16double6Double7to__int(cur_wx), 10);
        _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(dl, _M0MP49LING7167111moon_2degui3src4math4Vec23new(sx + 3, vp_y + 3), label_txt, 9, ruler_text_col);
      }
      cur_wx = cur_wx + step_x;
      continue;
    } else {
      break;
    }
  }
  const step_y = _M0FP49LING7167111moon_2degui8examples6canvas17calc__ruler__step(state.zoom);
  const first_tick_y = (_M0MPC16double6Double7to__int(min_wy / step_y) + 0) * step_y;
  let cur_wy = first_tick_y;
  while (true) {
    if (cur_wy <= max_wy) {
      const sy = sc_y + (cur_wy - state.cam_y) * state.zoom;
      if (sy >= cv_y && sy <= cv_y + cv_h) {
        _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(dl, _M0MP49LING7167111moon_2degui3src4math4Vec23new(vp_x + ruler_w - 8, sy), _M0MP49LING7167111moon_2degui3src4math4Vec23new(vp_x + ruler_w, sy), ruler_tick_col, 1);
        const label_txt = _M0MPC13int3Int18to__string_2einner(_M0MPC16double6Double7to__int(cur_wy), 10);
        _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(dl, _M0MP49LING7167111moon_2degui3src4math4Vec23new(vp_x + 2, sy - 5), label_txt, 9, ruler_text_col);
      }
      cur_wy = cur_wy + step_y;
      continue;
    } else {
      return;
    }
  }
}
function _M0FP49LING7167111moon_2degui8examples6canvas26render__ruler__projections(dl, state, cv_x, cv_y, cv_w, cv_h, vp_x, vp_y, ruler_w, ruler_h, sc_x, sc_y, pitch, cell_size, grid_dim) {
  if (state.selected_id >= 0) {
    const sel_id = state.selected_id;
    const r = sel_id / grid_dim | 0;
    const c = sel_id % grid_dim | 0;
    const is_dragged = state.item_drag_dx !== 0 || (state.item_drag_dy !== 0 || state.is_dragging_item);
    const sel_orig_wx = (c + 0) * pitch;
    const sel_orig_wy = (r + 0) * pitch;
    const sel_wx = is_dragged ? sel_orig_wx + state.item_drag_dx : sel_orig_wx;
    const sel_wy = is_dragged ? sel_orig_wy + state.item_drag_dy : sel_orig_wy;
    const sel_sx = sc_x + (sel_wx - state.cam_x) * state.zoom;
    const sel_sy = sc_y + (sel_wy - state.cam_y) * state.zoom;
    const sel_sw = _M0MPC16double6Double3max(cell_size * state.zoom, 8);
    const sel_sh = _M0MPC16double6Double3max(cell_size * state.zoom, 8);
    if (sel_sx + sel_sw >= cv_x && sel_sx <= cv_x + cv_w) {
      const proj_x = _M0MPC16double6Double3max(sel_sx, cv_x);
      const proj_w = _M0MPC16double6Double3max(sel_sw, 16);
      _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(dl, _M0MP49LING7167111moon_2degui3src4math4Rect3new(proj_x, vp_y, proj_w, ruler_h), _M0MP49LING7167111moon_2degui3src5color5Color4rgba(139, 92, 246, 40), 0);
      _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(dl, _M0MP49LING7167111moon_2degui3src4math4Vec23new(proj_x, vp_y), _M0MP49LING7167111moon_2degui3src4math4Vec23new(proj_x, vp_y + ruler_h), _M0MP49LING7167111moon_2degui3src5color5Color3rgb(139, 92, 246), 1.5);
      const coord_txt = _M0MPC13int3Int18to__string_2einner(_M0MPC16double6Double7to__int(sel_wx), 10);
      _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(dl, _M0MP49LING7167111moon_2degui3src4math4Vec23new(proj_x + 2, vp_y + 2), coord_txt, 9, _M0MP49LING7167111moon_2degui3src5color5Color3rgb(109, 40, 217));
    }
    if (sel_sy + sel_sh >= cv_y && sel_sy <= cv_y + cv_h) {
      const proj_y = _M0MPC16double6Double3max(sel_sy, cv_y);
      const proj_h = _M0MPC16double6Double3max(sel_sh, 16);
      _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(dl, _M0MP49LING7167111moon_2degui3src4math4Rect3new(vp_x, proj_y, ruler_w, proj_h), _M0MP49LING7167111moon_2degui3src5color5Color4rgba(139, 92, 246, 40), 0);
      _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(dl, _M0MP49LING7167111moon_2degui3src4math4Vec23new(vp_x, proj_y), _M0MP49LING7167111moon_2degui3src4math4Vec23new(vp_x + ruler_w, proj_y), _M0MP49LING7167111moon_2degui3src5color5Color3rgb(139, 92, 246), 1.5);
      const coord_txt = _M0MPC13int3Int18to__string_2einner(_M0MPC16double6Double7to__int(sel_wy), 10);
      _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(dl, _M0MP49LING7167111moon_2degui3src4math4Vec23new(vp_x + 2, proj_y), coord_txt, 9, _M0MP49LING7167111moon_2degui3src5color5Color3rgb(109, 40, 217));
      return;
    } else {
      return;
    }
  } else {
    return;
  }
}
function _M0FP49LING7167111moon_2degui8examples6canvas23handle__node__hit__test(state, ctx, mouse_down, in_canvas, mwx, mwy, pitch, grid_dim, matrix_world_size) {
  const can_hit_nodes = in_canvas && (!(ctx.prev_wants_capture_mouse || ctx.wants_capture_mouse) && (mwx >= 0 && (mwx < matrix_world_size && (mwy >= 0 && mwy < matrix_world_size))));
  if (can_hit_nodes) {
    const col = _M0MPC16double6Double7to__int(mwx / pitch);
    const row = _M0MPC16double6Double7to__int(mwy / pitch);
    if (col >= 0 && (col < grid_dim && (row >= 0 && row < grid_dim))) {
      const node_id = (Math.imul(row, grid_dim) | 0) + col | 0;
      if (mouse_down) {
        state.click_count = state.click_count + 1 | 0;
        if (state.selected_id !== node_id) {
          state.selected_id = node_id;
          state.selected_col = col;
          state.selected_row = row;
          state.item_drag_dx = 0;
          state.item_drag_dy = 0;
        }
        state.ripple_active = true;
        state.ripple_cx = (col + 0) * pitch + pitch * 0.5;
        state.ripple_cy = (row + 0) * pitch + pitch * 0.5;
        state.ripple_progress = 0;
        return;
      } else {
        return;
      }
    } else {
      return;
    }
  } else {
    return;
  }
}
function _M0FP49LING7167111moon_2degui8examples6canvas23update__ripple__physics(state, matrix_world_size, pitch) {
  if (state.ripple_active) {
    state.ripple_progress = state.ripple_progress + pitch * 1.6;
    if (state.ripple_progress > matrix_world_size * 0.6) {
      state.ripple_active = false;
      state.ripple_progress = 0;
      return;
    } else {
      return;
    }
  } else {
    return;
  }
}
function _M0FP49LING7167111moon_2degui8examples6canvas21calc__culling__bounds(state, cv_w, cv_h, pitch, grid_dim) {
  const half_vw = cv_w * 0.5 / state.zoom;
  const half_vh = cv_h * 0.5 / state.zoom;
  const min_wx = state.cam_x - half_vw;
  const max_wx = state.cam_x + half_vw;
  const min_wy = state.cam_y - half_vh;
  const max_wy = state.cam_y + half_vh;
  let c_start = _M0MPC16double6Double7to__int(min_wx / pitch);
  if (c_start < 0) {
    c_start = 0;
  }
  let c_end = _M0MPC16double6Double7to__int(max_wx / pitch) + 1 | 0;
  if (c_end > grid_dim) {
    c_end = grid_dim;
  }
  let r_start = _M0MPC16double6Double7to__int(min_wy / pitch);
  if (r_start < 0) {
    r_start = 0;
  }
  let r_end = _M0MPC16double6Double7to__int(max_wy / pitch) + 1 | 0;
  if (r_end > grid_dim) {
    r_end = grid_dim;
  }
  const total_vis = c_end > c_start && r_end > r_start ? Math.imul(c_end - c_start | 0, r_end - r_start | 0) | 0 : 0;
  state.visible_cells = total_vis;
  return { _0: c_start, _1: c_end, _2: r_start, _3: r_end, _4: total_vis, _5: min_wx, _6: max_wx, _7: min_wy, _8: max_wy };
}
function _M0FP49LING7167111moon_2degui8examples6canvas16get__logo__color(dim, col, row) {
  if (col < 0 || (col >= dim || (row < 0 || row >= dim))) {
    return undefined;
  }
  const c128 = (Math.imul(col, 128) | 0) / dim | 0;
  const r128 = (Math.imul(row, 128) | 0) / dim | 0;
  const idx = (Math.imul(r128, 128) | 0) + c128 | 0;
  if (idx < 0 || idx >= _M0FP49LING7167111moon_2degui8examples6canvas15logo__grid__128.length) {
    return undefined;
  }
  const val = _M0MPC15array5Array2atGiE(_M0FP49LING7167111moon_2degui8examples6canvas15logo__grid__128, idx);
  if ((val & -16777216) === 0) {
    return undefined;
  } else {
    const r = val >> 16 & 255;
    const g = val >> 8 & 255;
    const b = val & 255;
    return _M0MP49LING7167111moon_2degui3src5color5Color3rgb(r, g, b);
  }
}
function _M0FP49LING7167111moon_2degui8examples6canvas21render__matrix__nodes(dl, state, in_canvas, mouse_x, mouse_y, cv_x, cv_y, cv_w, cv_h, sc_x, sc_y, grid_dim, pitch, cell_size, mwx, mwy, c_start, c_end, r_start, r_end, total_vis, matrix_world_size) {
  _M0MP49LING7167111moon_2degui3src4draw8DrawList10push__clip(dl, _M0MP49LING7167111moon_2degui3src4math4Rect3new(cv_x, cv_y, cv_w, cv_h));
  const repel_radius = pitch * 4.5;
  const repel_radius_sq = repel_radius * repel_radius;
  const is_micro_vector = total_vis <= 4000;
  if (is_micro_vector) {
    const on_screen_cell_w = cell_size * state.zoom;
    const on_screen_cell_h = cell_size * state.zoom;
    let _tmp = r_start;
    while (true) {
      const r = _tmp;
      if (r < r_end) {
        const base_wy = (r + 0) * pitch;
        let _tmp$2 = c_start;
        while (true) {
          const c = _tmp$2;
          if (c < c_end) {
            const base_wx = (c + 0) * pitch;
            const node_id = (Math.imul(r, grid_dim) | 0) + c | 0;
            const is_selected = node_id === state.selected_id;
            const is_dragged = is_selected && (state.item_drag_dx !== 0 || (state.item_drag_dy !== 0 || state.is_dragging_item));
            let pdx = 0;
            let pdy = 0;
            if (state.magnetic_repel && in_canvas) {
              const c_center_x = base_wx + pitch * 0.5;
              const c_center_y = base_wy + pitch * 0.5;
              const dist_sq = (c_center_x - mwx) * (c_center_x - mwx) + (c_center_y - mwy) * (c_center_y - mwy);
              if (dist_sq < repel_radius_sq && dist_sq > 0.1) {
                const repel_factor = (repel_radius_sq - dist_sq) / repel_radius_sq;
                const push = repel_factor * pitch * 0.8;
                pdx = (c_center_x - mwx) / repel_radius * push;
                pdy = (c_center_y - mwy) / repel_radius * push;
              }
            }
            if (state.wave_pulse) {
              const wave_val = state.frame_tick * 0.07 + ((c + r | 0) + 0) * 0.25;
              const phase = wave_val - (_M0MPC16double6Double7to__int(wave_val / 6.283) + 0) * 6.283;
              const wave_dy = phase < 3.14159 ? (phase / 3.14159 * 2 - 1) * pitch * 0.12 : (1 - (phase - 3.14159) / 3.14159 * 2) * pitch * 0.12;
              pdy = pdy + wave_dy;
            }
            let ripple_bright = false;
            if (state.ripple_active) {
              const rx = base_wx - state.ripple_cx;
              const ry = base_wy - state.ripple_cy;
              const r_dist = rx * rx + ry * ry;
              const target_dist = state.ripple_progress * state.ripple_progress;
              const _p = r_dist - target_dist;
              const diff = _p < 0 ? -_p : _p;
              if (diff < pitch * pitch * 36) {
                ripple_bright = true;
                pdy = pdy - pitch * 0.3;
              }
            }
            const cur_wx = is_dragged ? base_wx + state.item_drag_dx + pdx : base_wx + pdx;
            const cur_wy = is_dragged ? base_wy + state.item_drag_dy + pdy : base_wy + pdy;
            const sx = sc_x + (cur_wx - state.cam_x) * state.zoom;
            const sy = sc_y + (cur_wy - state.cam_y) * state.zoom;
            const is_hovered = in_canvas && (mwx >= base_wx && (mwx < base_wx + pitch && (mwy >= base_wy && mwy < base_wy + pitch)));
            let cell_color;
            if (is_selected) {
              cell_color = _M0MP49LING7167111moon_2degui3src5color5Color3rgb(244, 63, 94);
            } else {
              if (is_hovered) {
                cell_color = _M0MP49LING7167111moon_2degui3src5color5Color3rgb(56, 189, 248);
              } else {
                if (ripple_bright) {
                  cell_color = _M0MP49LING7167111moon_2degui3src5color5Color3rgb(251, 146, 60);
                } else {
                  const _bind = _M0FP49LING7167111moon_2degui8examples6canvas16get__logo__color(grid_dim, c, r);
                  if (_bind === undefined) {
                    cell_color = ((c + r | 0) % 2 | 0) === 0 ? _M0MP49LING7167111moon_2degui3src5color5Color10bg__window() : _M0MP49LING7167111moon_2degui3src5color5Color9bg__hover();
                  } else {
                    const _Some = _bind;
                    cell_color = _Some;
                  }
                }
              }
            }
            _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(dl, _M0MP49LING7167111moon_2degui3src4math4Rect3new(sx, sy, on_screen_cell_w, on_screen_cell_h), cell_color, 0);
            if (is_hovered) {
              _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(dl, _M0MP49LING7167111moon_2degui3src4math4Rect3new(sx, sy, on_screen_cell_w, on_screen_cell_h), _M0MP49LING7167111moon_2degui3src5color5Color3rgb(37, 99, 235), 1.5, 0);
            }
            _tmp$2 = c + 1 | 0;
            continue;
          } else {
            break;
          }
        }
        _tmp = r + 1 | 0;
        continue;
      } else {
        break;
      }
    }
  } else {
    if (in_canvas && (mwx >= 0 && (mwx < matrix_world_size && (mwy >= 0 && mwy < matrix_world_size)))) {
      const h_col = _M0MPC16double6Double7to__int(mwx / pitch);
      const h_row = _M0MPC16double6Double7to__int(mwy / pitch);
      if (h_col >= 0 && (h_col < grid_dim && (h_row >= 0 && h_row < grid_dim))) {
        const h_base_wx = (h_col + 0) * pitch;
        const h_base_wy = (h_row + 0) * pitch;
        const hs_x = sc_x + (h_base_wx - state.cam_x) * state.zoom;
        const hs_y = sc_y + (h_base_wy - state.cam_y) * state.zoom;
        const hs_w = _M0MPC16double6Double3max(cell_size * state.zoom, 4);
        const hs_h = _M0MPC16double6Double3max(cell_size * state.zoom, 4);
        _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(dl, _M0MP49LING7167111moon_2degui3src4math4Rect3new(hs_x, hs_y, hs_w, hs_h), _M0MP49LING7167111moon_2degui3src5color5Color3rgb(56, 189, 248), 0);
      }
    }
    if (state.ripple_active) {
      const rip_sx = sc_x + (state.ripple_cx - state.cam_x) * state.zoom;
      const rip_sy = sc_y + (state.ripple_cy - state.cam_y) * state.zoom;
      const rip_r = state.ripple_progress * state.zoom;
      if (rip_r > 1) {
        _M0MP49LING7167111moon_2degui3src4draw8DrawList19add__circle__stroke(dl, _M0MP49LING7167111moon_2degui3src4math4Vec23new(rip_sx, rip_sy), rip_r, _M0MP49LING7167111moon_2degui3src5color5Color3rgb(251, 146, 60), 2);
      }
    }
    if (state.magnetic_repel && in_canvas) {
      _M0MP49LING7167111moon_2degui3src4draw8DrawList19add__circle__stroke(dl, _M0MP49LING7167111moon_2degui3src4math4Vec23new(mouse_x, mouse_y), repel_radius * state.zoom, _M0MP49LING7167111moon_2degui3src5color5Color4rgba(249, 115, 22, 180), 1.5);
    }
  }
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9pop__clip(dl);
  return is_micro_vector;
}
function _M0FP49LING7167111moon_2degui8examples6canvas34render__selected__transform__frame(dl, state, cv_x, cv_y, cv_w, cv_h, sc_x, sc_y, pitch, cell_size, grid_dim) {
  if (state.selected_id >= 0) {
    _M0MP49LING7167111moon_2degui3src4draw8DrawList10push__clip(dl, _M0MP49LING7167111moon_2degui3src4math4Rect3new(cv_x, cv_y, cv_w, cv_h));
    const sel_id = state.selected_id;
    const r = sel_id / grid_dim | 0;
    const c = sel_id % grid_dim | 0;
    const is_dragged = state.item_drag_dx !== 0 || (state.item_drag_dy !== 0 || state.is_dragging_item);
    const sel_orig_wx = (c + 0) * pitch;
    const sel_orig_wy = (r + 0) * pitch;
    const sel_wx = is_dragged ? sel_orig_wx + state.item_drag_dx : sel_orig_wx;
    const sel_wy = is_dragged ? sel_orig_wy + state.item_drag_dy : sel_orig_wy;
    const sel_sx = sc_x + (sel_wx - state.cam_x) * state.zoom;
    const sel_sy = sc_y + (sel_wy - state.cam_y) * state.zoom;
    const sel_w = _M0MPC16double6Double3max(cell_size * state.zoom, 8);
    const sel_h = _M0MPC16double6Double3max(cell_size * state.zoom, 8);
    _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(dl, _M0MP49LING7167111moon_2degui3src4math4Rect3new(sel_sx - 3, sel_sy - 3, sel_w + 6, sel_h + 6), _M0MP49LING7167111moon_2degui3src5color5Color3rgb(139, 92, 246), 1.5, 2);
    const h_purple = _M0MP49LING7167111moon_2degui3src5color5Color3rgb(139, 92, 246);
    const h_white = _M0MP49LING7167111moon_2degui3src5color5Color10bg__window();
    const tl_pos = _M0MP49LING7167111moon_2degui3src4math4Vec23new(sel_sx - 3, sel_sy - 3);
    _M0MP49LING7167111moon_2degui3src4draw8DrawList11add__circle(dl, tl_pos, 3, h_white);
    _M0MP49LING7167111moon_2degui3src4draw8DrawList19add__circle__stroke(dl, tl_pos, 3, h_purple, 1.5);
    const tr_pos = _M0MP49LING7167111moon_2degui3src4math4Vec23new(sel_sx + sel_w + 3, sel_sy - 3);
    _M0MP49LING7167111moon_2degui3src4draw8DrawList11add__circle(dl, tr_pos, 3, h_white);
    _M0MP49LING7167111moon_2degui3src4draw8DrawList19add__circle__stroke(dl, tr_pos, 3, h_purple, 1.5);
    const bl_pos = _M0MP49LING7167111moon_2degui3src4math4Vec23new(sel_sx - 3, sel_sy + sel_h + 3);
    _M0MP49LING7167111moon_2degui3src4draw8DrawList11add__circle(dl, bl_pos, 3, h_white);
    _M0MP49LING7167111moon_2degui3src4draw8DrawList19add__circle__stroke(dl, bl_pos, 3, h_purple, 1.5);
    const br_pos = _M0MP49LING7167111moon_2degui3src4math4Vec23new(sel_sx + sel_w + 3, sel_sy + sel_h + 3);
    _M0MP49LING7167111moon_2degui3src4draw8DrawList11add__circle(dl, br_pos, 3, h_white);
    _M0MP49LING7167111moon_2degui3src4draw8DrawList19add__circle__stroke(dl, br_pos, 3, h_purple, 1.5);
    let tag_txt;
    if (is_dragged) {
      const _string_builder = _M0MPB13StringBuilder21StringBuilder_2einner(24);
      _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, "拖拽中 #");
      _M0MPB13StringBuilder13write__objectGiE(_string_builder, sel_id);
      _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, " [列:");
      _M0MPB13StringBuilder13write__objectGiE(_string_builder, c);
      _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", 行:");
      _M0MPB13StringBuilder13write__objectGiE(_string_builder, r);
      _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, "]");
      tag_txt = _string_builder.val;
    } else {
      const _string_builder = _M0MPB13StringBuilder21StringBuilder_2einner(14);
      _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, "#");
      _M0MPB13StringBuilder13write__objectGiE(_string_builder, sel_id);
      _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, " [列:");
      _M0MPB13StringBuilder13write__objectGiE(_string_builder, c);
      _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", 行:");
      _M0MPB13StringBuilder13write__objectGiE(_string_builder, r);
      _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, "]");
      tag_txt = _string_builder.val;
    }
    const tag_w = (tag_txt.length + 0) * 7 + 16;
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(dl, _M0MP49LING7167111moon_2degui3src4math4Rect3new(sel_sx + (sel_w - tag_w) * 0.5, sel_sy - 24, tag_w, 18), _M0MP49LING7167111moon_2degui3src5color5Color10bg__window(), 4);
    _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(dl, _M0MP49LING7167111moon_2degui3src4math4Rect3new(sel_sx + (sel_w - tag_w) * 0.5, sel_sy - 24, tag_w, 18), _M0MP49LING7167111moon_2degui3src5color5Color15border__default(), 1, 4);
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(dl, _M0MP49LING7167111moon_2degui3src4math4Vec23new(sel_sx + (sel_w - tag_w) * 0.5 + 8, sel_sy - 22), tag_txt, 10, _M0MP49LING7167111moon_2degui3src5color5Color13text__primary());
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9pop__clip(dl);
    return;
  } else {
    return;
  }
}
function _M0FP49LING7167111moon_2degui8examples6canvas19apply__switch__mode(state, switch_mode, vp_w, vp_h) {
  if (switch_mode >= 0) {
    if (switch_mode === 128) {
      state.grid_dim = 128;
      state.selected_id = -1;
      return;
    } else {
      if (switch_mode === 256) {
        state.grid_dim = 256;
        state.selected_id = -1;
        return;
      } else {
        if (switch_mode === 512) {
          state.grid_dim = 512;
          state.selected_id = -1;
          return;
        } else {
          if (switch_mode === 1024) {
            state.grid_dim = 1024;
            state.selected_id = -1;
            return;
          } else {
            if (switch_mode === 1) {
              state.wave_pulse = !state.wave_pulse;
              return;
            } else {
              if (switch_mode === 2) {
                state.magnetic_repel = !state.magnetic_repel;
                return;
              } else {
                if (switch_mode === 3) {
                  const min_dim = vp_w < vp_h ? vp_w : vp_h;
                  const fit_z = (min_dim - 60) / 10500;
                  state.zoom = fit_z > 0.01 ? fit_z : 0.075;
                  state.cam_x = 5000;
                  state.cam_y = 5000;
                  return;
                } else {
                  if (switch_mode === 4) {
                    state.zoom = 1;
                    return;
                  } else {
                    if (switch_mode === 5) {
                      state.cam_x = 5000;
                      state.cam_y = 5000;
                      return;
                    } else {
                      if (switch_mode === 6) {
                        state.drag_mode = 1;
                        return;
                      } else {
                        if (switch_mode === 7) {
                          state.drag_mode = 0;
                          return;
                        } else {
                          if (switch_mode === 8) {
                            state.show_studio = !state.show_studio;
                            return;
                          } else {
                            if (switch_mode === 9) {
                              state.show_studio = true;
                              return;
                            } else {
                              if (switch_mode === 10) {
                                state.show_studio = false;
                                return;
                              } else {
                                return;
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  } else {
    return;
  }
}
function _M0FP49LING7167111moon_2degui8examples6canvas9host__key(name) {
  switch (name) {
    case "Tab": {
      return _M0FP49LING7167111moon_2degui8examples6canvas9host__keyN6constrS1063;
    }
    case "Enter": {
      return _M0FP49LING7167111moon_2degui8examples6canvas9host__keyN6constrS1064;
    }
    case "Escape": {
      return _M0FP49LING7167111moon_2degui8examples6canvas9host__keyN6constrS1065;
    }
    case " ": {
      return _M0FP49LING7167111moon_2degui8examples6canvas9host__keyN6constrS1066;
    }
    case "ArrowUp": {
      return _M0FP49LING7167111moon_2degui8examples6canvas9host__keyN6constrS1067;
    }
    case "ArrowDown": {
      return _M0FP49LING7167111moon_2degui8examples6canvas9host__keyN6constrS1068;
    }
    case "ArrowLeft": {
      return _M0FP49LING7167111moon_2degui8examples6canvas9host__keyN6constrS1069;
    }
    case "ArrowRight": {
      return _M0FP49LING7167111moon_2degui8examples6canvas9host__keyN6constrS1070;
    }
    case "PageUp": {
      return _M0FP49LING7167111moon_2degui8examples6canvas9host__keyN6constrS1071;
    }
    case "PageDown": {
      return _M0FP49LING7167111moon_2degui8examples6canvas9host__keyN6constrS1072;
    }
    case "Home": {
      return _M0FP49LING7167111moon_2degui8examples6canvas9host__keyN6constrS1073;
    }
    case "End": {
      return _M0FP49LING7167111moon_2degui8examples6canvas9host__keyN6constrS1074;
    }
    case "Backspace": {
      return _M0FP49LING7167111moon_2degui8examples6canvas9host__keyN6constrS1075;
    }
    case "Delete": {
      return _M0FP49LING7167111moon_2degui8examples6canvas9host__keyN6constrS1076;
    }
    default: {
      return undefined;
    }
  }
}
function _M0FP49LING7167111moon_2degui8examples6canvas24host__raw__input_2einner(mouse_x, mouse_y, mouse_down, text_input, keys_pressed, keys_released, mod_flags, scroll_dy, mouse_secondary_down) {
  const mods = _M0MP49LING7167111moon_2degui3src4core9Modifiers3new((mod_flags & 2) !== 0, (mod_flags & 1) !== 0, (mod_flags & 4) !== 0, (mod_flags & 8) !== 0);
  const events = [];
  const _bind = keys_pressed.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const name = keys_pressed[_];
      const _bind$2 = _M0FP49LING7167111moon_2degui8examples6canvas9host__key(name);
      if (_bind$2 === undefined) {
      } else {
        const _Some = _bind$2;
        const _key = _Some;
        _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(events, new _M0DTP49LING7167111moon_2degui3src4core5Event3Key(_key, true, mods));
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _bind$2 = keys_released.length;
  let _tmp$2 = 0;
  while (true) {
    const _ = _tmp$2;
    if (_ < _bind$2) {
      const name = keys_released[_];
      const _bind$3 = _M0FP49LING7167111moon_2degui8examples6canvas9host__key(name);
      if (_bind$3 === undefined) {
      } else {
        const _Some = _bind$3;
        const _key = _Some;
        _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(events, new _M0DTP49LING7167111moon_2degui3src4core5Event3Key(_key, false, mods));
      }
      _tmp$2 = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  if (!(text_input === "")) {
    _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(events, new _M0DTP49LING7167111moon_2degui3src4core5Event9TextInput(text_input));
  }
  return _M0MP49LING7167111moon_2degui3src4core8RawInput20with__events_2einner(_M0MP49LING7167111moon_2degui3src4math4Vec23new(mouse_x, mouse_y), mouse_down, _M0MP49LING7167111moon_2degui3src4math4Vec23new(0, scroll_dy), events, text_input, mods, mouse_secondary_down, 0.0166);
}
function _M0FP49LING7167111moon_2degui8examples6canvas19update__camera__pan(state, ctx, pan_dx, pan_dy) {
  if (pan_dx !== 0 || pan_dy !== 0) {
    if (ctx.prev_wants_capture_mouse || ctx.wants_capture_mouse) {
      return;
    } else {
      if (state.drag_mode === 1 && state.selected_id >= 0) {
        state.is_dragging_item = true;
        state.item_drag_dx = state.item_drag_dx + pan_dx / state.zoom;
        state.item_drag_dy = state.item_drag_dy + pan_dy / state.zoom;
        return;
      } else {
        state.cam_x = state.cam_x - pan_dx / state.zoom;
        state.cam_y = state.cam_y - pan_dy / state.zoom;
        if (state.cam_x < -2000) {
          state.cam_x = -2000;
        } else {
          if (state.cam_x > 12000) {
            state.cam_x = 12000;
          }
        }
        if (state.cam_y < -2000) {
          state.cam_y = -2000;
          return;
        } else {
          if (state.cam_y > 12000) {
            state.cam_y = 12000;
            return;
          } else {
            return;
          }
        }
      }
    }
  } else {
    return;
  }
}
function _M0FP49LING7167111moon_2degui8examples6canvas20update__camera__zoom(state, ctx, zoom_delta, mouse_x, mouse_y, sc_x, sc_y) {
  if (zoom_delta !== 1 && (zoom_delta > 0 && !(ctx.prev_wants_capture_mouse || ctx.wants_capture_mouse))) {
    const old_zoom = state.zoom;
    let new_zoom = old_zoom * zoom_delta;
    if (new_zoom < 0.005) {
      new_zoom = 0.005;
    } else {
      if (new_zoom > 30) {
        new_zoom = 30;
      }
    }
    if (new_zoom !== old_zoom) {
      const mwx = state.cam_x + (mouse_x - sc_x) / old_zoom;
      const mwy = state.cam_y + (mouse_y - sc_y) / old_zoom;
      state.zoom = new_zoom;
      state.cam_x = mwx - (mouse_x - sc_x) / new_zoom;
      state.cam_y = mwy - (mouse_y - sc_y) / new_zoom;
      return;
    } else {
      return;
    }
  } else {
    return;
  }
}
function _M0FP49LING7167111moon_2degui8examples6canvas4step(mouse_x, mouse_y, mouse_down, pan_dx, pan_dy, zoom_delta, switch_mode, vp_w, vp_h, text_input, keys_pressed, keys_released, mod_flags) {
  _M0FP49LING7167111moon_2degui8examples6canvas5state.frame_tick = _M0FP49LING7167111moon_2degui8examples6canvas5state.frame_tick + 1;
  _M0FP49LING7167111moon_2degui8examples6canvas19apply__switch__mode(_M0FP49LING7167111moon_2degui8examples6canvas5state, switch_mode, vp_w, vp_h);
  const cur_w = vp_w > 100 ? vp_w : 920;
  const cur_h = vp_h > 100 ? vp_h : 540;
  const cv_w = cur_w - 48;
  const cv_h = cur_h - 22;
  const sc_x = 48 + cv_w * 0.5;
  const sc_y = 22 + cv_h * 0.5;
  _M0FP49LING7167111moon_2degui8examples6canvas19update__camera__pan(_M0FP49LING7167111moon_2degui8examples6canvas5state, _M0FP49LING7167111moon_2degui8examples6canvas3ctx, pan_dx, pan_dy);
  if (!mouse_down) {
    _M0FP49LING7167111moon_2degui8examples6canvas5state.is_dragging_item = false;
  }
  _M0FP49LING7167111moon_2degui8examples6canvas20update__camera__zoom(_M0FP49LING7167111moon_2degui8examples6canvas5state, _M0FP49LING7167111moon_2degui8examples6canvas3ctx, zoom_delta, mouse_x, mouse_y, sc_x, sc_y);
  const raw = _M0FP49LING7167111moon_2degui8examples6canvas24host__raw__input_2einner(mouse_x, mouse_y, mouse_down, text_input, keys_pressed, keys_released, mod_flags, 0, false);
  _M0MP49LING7167111moon_2degui3src4core9UIContext12begin__frame(_M0FP49LING7167111moon_2degui8examples6canvas3ctx, raw);
  const dl = _M0FP49LING7167111moon_2degui8examples6canvas3ctx.draw_list;
  const grid_dim = _M0FP49LING7167111moon_2degui8examples6canvas5state.grid_dim;
  const pitch = 10000 / (grid_dim + 0);
  const in_canvas = mouse_x >= 48 && (mouse_x <= 48 + cv_w && (mouse_y >= 22 && mouse_y <= 22 + cv_h));
  const mwx = _M0FP49LING7167111moon_2degui8examples6canvas5state.cam_x + (mouse_x - sc_x) / _M0FP49LING7167111moon_2degui8examples6canvas5state.zoom;
  const mwy = _M0FP49LING7167111moon_2degui8examples6canvas5state.cam_y + (mouse_y - sc_y) / _M0FP49LING7167111moon_2degui8examples6canvas5state.zoom;
  _M0FP49LING7167111moon_2degui8examples6canvas23handle__node__hit__test(_M0FP49LING7167111moon_2degui8examples6canvas5state, _M0FP49LING7167111moon_2degui8examples6canvas3ctx, mouse_down, in_canvas, mwx, mwy, pitch, grid_dim, 10000);
  _M0FP49LING7167111moon_2degui8examples6canvas23update__ripple__physics(_M0FP49LING7167111moon_2degui8examples6canvas5state, 10000, pitch);
  const _bind = _M0FP49LING7167111moon_2degui8examples6canvas21calc__culling__bounds(_M0FP49LING7167111moon_2degui8examples6canvas5state, cv_w, cv_h, pitch, grid_dim);
  const _c_start = _bind._0;
  const _c_end = _bind._1;
  const _r_start = _bind._2;
  const _r_end = _bind._3;
  const _total_vis = _bind._4;
  const _min_wx = _bind._5;
  const _max_wx = _bind._6;
  const _min_wy = _bind._7;
  const _max_wy = _bind._8;
  _M0MP49LING7167111moon_2degui3src4draw8DrawList10push__clip(dl, _M0MP49LING7167111moon_2degui3src4math4Rect3new(48, 22, cv_w, cv_h));
  if (_M0FP49LING7167111moon_2degui8examples6canvas5state.show_grid) {
    _M0FP49LING7167111moon_2degui8examples6canvas20render__grid__aisles(dl, _M0FP49LING7167111moon_2degui8examples6canvas5state, 48, 22, cv_w, cv_h, sc_x, sc_y);
  }
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9pop__clip(dl);
  const is_vector = _M0FP49LING7167111moon_2degui8examples6canvas21render__matrix__nodes(dl, _M0FP49LING7167111moon_2degui8examples6canvas5state, in_canvas, mouse_x, mouse_y, 48, 22, cv_w, cv_h, sc_x, sc_y, grid_dim, pitch, pitch, mwx, mwy, _c_start, _c_end, _r_start, _r_end, _total_vis, 10000);
  _M0FP49LING7167111moon_2degui8examples6canvas34render__selected__transform__frame(dl, _M0FP49LING7167111moon_2degui8examples6canvas5state, 48, 22, cv_w, cv_h, sc_x, sc_y, pitch, pitch, grid_dim);
  _M0FP49LING7167111moon_2degui8examples6canvas19render__cad__rulers(dl, _M0FP49LING7167111moon_2degui8examples6canvas5state, 48, 22, cv_w, cv_h, 0, 0, 48, 22, _min_wx, _max_wx, _min_wy, _max_wy, sc_x, sc_y);
  _M0FP49LING7167111moon_2degui8examples6canvas26render__ruler__projections(dl, _M0FP49LING7167111moon_2degui8examples6canvas5state, 48, 22, cv_w, cv_h, 0, 0, 48, 22, sc_x, sc_y, pitch, pitch, grid_dim);
  _M0FP49LING7167111moon_2degui8examples6canvas22render__studio__window(_M0FP49LING7167111moon_2degui8examples6canvas3ctx, _M0FP49LING7167111moon_2degui8examples6canvas5state, cur_w, cur_h, 264, 340);
  const final_dl = _M0MP49LING7167111moon_2degui3src4core9UIContext10end__frame(_M0FP49LING7167111moon_2degui8examples6canvas3ctx);
  return new _M0TP49LING7167111moon_2degui8examples6canvas11FrameOutput(final_dl, _M0FP49LING7167111moon_2degui8examples6canvas5state.cam_x, _M0FP49LING7167111moon_2degui8examples6canvas5state.cam_y, _M0FP49LING7167111moon_2degui8examples6canvas5state.zoom, _M0FP49LING7167111moon_2degui8examples6canvas5state.grid_dim, _M0FP49LING7167111moon_2degui8examples6canvas5state.visible_cells, _M0FP49LING7167111moon_2degui8examples6canvas5state.selected_id, _M0FP49LING7167111moon_2degui8examples6canvas5state.show_studio, is_vector);
}
function _M0FP49LING7167111moon_2degui8examples6canvas21draw__badge__showcase(ui) {
  _M0MP49LING7167111moon_2degui3src4core9UIContext14label__colored(ui, "状态胶囊与交互标签 (Badge & Tag)", _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary());
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 6);
  _M0MP49LING7167111moon_2degui3src4core9UIContext5label(ui, "5 种语义状态调色板，支持前置呼吸状态圆点与右侧小叉号关闭移除。");
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 12);
  _M0MP49LING7167111moon_2degui3src4core9UIContext10horizontal(ui, (row) => {
    _M0MP49LING7167111moon_2degui3src4core9UIContext13badge_2einner(row, "Default", 0, false, false);
    _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(row, 8);
    _M0MP49LING7167111moon_2degui3src4core9UIContext13badge_2einner(row, "Success", 1, true, false);
    _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(row, 8);
    _M0MP49LING7167111moon_2degui3src4core9UIContext13badge_2einner(row, "Warning", 2, true, false);
    _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(row, 8);
    _M0MP49LING7167111moon_2degui3src4core9UIContext13badge_2einner(row, "Danger", 3, false, true);
    _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(row, 8);
    _M0MP49LING7167111moon_2degui3src4core9UIContext13badge_2einner(row, "Beta v0.2.0", 4, true, true);
  });
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 14);
  _M0MP49LING7167111moon_2degui3src4core9UIContext10horizontal(ui, (row) => {
    if (_M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.tag1_open) {
      const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext11tag_2einner(row, "tag1", "Wasm 32", 4, true);
      const _c1 = _bind._0;
      if (_c1) {
        _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.tag1_open = false;
        _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = "Tag 1 Closed";
      }
      _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(row, 8);
    }
    if (_M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.tag2_open) {
      const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext11tag_2einner(row, "tag2", "Production", 1, true);
      const _c2 = _bind._0;
      if (_c2) {
        _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.tag2_open = false;
        _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = "Tag 2 Closed";
      }
      _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(row, 8);
    }
    if (_M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.tag3_open) {
      const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext11tag_2einner(row, "tag3", "Deprecated", 2, true);
      const _c3 = _bind._0;
      if (_c3) {
        _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.tag3_open = false;
        _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = "Tag 3 Closed";
      }
      _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(row, 8);
    }
    if (!_M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.tag1_open || (!_M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.tag2_open || !_M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.tag3_open)) {
      if (_M0MP49LING7167111moon_2degui3src4core9UIContext13button__sized(row, "恢复所有标签", _M0MP49LING7167111moon_2degui3src4math4Vec23new(96, 24)).clicked) {
        _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.tag1_open = true;
        _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.tag2_open = true;
        _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.tag3_open = true;
        return;
      } else {
        return;
      }
    } else {
      return;
    }
  });
}
function _M0FP49LING7167111moon_2degui8examples6canvas26draw__breadcrumb__showcase(ui) {
  _M0MP49LING7167111moon_2degui3src4core9UIContext14label__colored(ui, "层级路径面包屑 (Breadcrumb)", _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary());
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 6);
  _M0MP49LING7167111moon_2degui3src4core9UIContext5label(ui, "横向单行层级导航条，祖先项悬停底色微光与快速回退，超长路径自动折叠。");
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 12);
  const path1 = ["工作区", "moon-egui", "src", "core", "table.mbt"];
  const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext18breadcrumb_2einner(ui, "gal_bc1", path1, "/", 4);
  const _c1 = _bind._0;
  if (_c1 === undefined) {
  } else {
    const _Some = _c1;
    const _idx = _Some;
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.breadcrumb_last_clicked = _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(path1, _idx);
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = `Navigated to: ${_M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(path1, _idx)}`;
  }
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 14);
  const long_path = ["Root", "Volumes", "ling71671", "Projects", "moon-egui", "examples", "canvas", "gallery.html"];
  const _bind$2 = _M0MP49LING7167111moon_2degui3src4core9UIContext18breadcrumb_2einner(ui, "gal_bc2", long_path, ">", 4);
  const _c2 = _bind$2._0;
  if (_c2 === undefined) {
  } else {
    const _Some = _c2;
    const _idx = _Some;
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.breadcrumb_last_clicked = _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(long_path, _idx);
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = `Navigated to: ${_M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(long_path, _idx)}`;
  }
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 8);
  _M0MP49LING7167111moon_2degui3src4core9UIContext5label(ui, `最后点击节点: ${_M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.breadcrumb_last_clicked}`);
}
function _M0FP49LING7167111moon_2degui8examples6canvas22draw__button__showcase(ui) {
  _M0MP49LING7167111moon_2degui3src4core9UIContext14label__colored(ui, "即时模式按钮与微下沉行程 (Button Suite)", _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary());
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 10);
  _M0MP49LING7167111moon_2degui3src4core9UIContext10horizontal(ui, (row) => {
    if (_M0MP49LING7167111moon_2degui3src4core9UIContext15button__primary(row, "主要按钮 (Primary)").clicked) {
      _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.button_clicks = _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.button_clicks + 1 | 0;
      _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = `Primary Button clicked: ${_M0MPC13int3Int18to__string_2einner(_M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.button_clicks, 10)}`;
    }
    _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(row, 10);
    if (_M0MP49LING7167111moon_2degui3src4core9UIContext6button(row, "次级按钮 (Normal)", undefined, -1, undefined).clicked) {
      _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.button_clicks = _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.button_clicks + 1 | 0;
      _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = `Normal Button clicked: ${_M0MPC13int3Int18to__string_2einner(_M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.button_clicks, 10)}`;
    }
    _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(row, 10);
    if (_M0MP49LING7167111moon_2degui3src4core9UIContext22button__with__shortcut(row, "保存工程", "⌘S").clicked) {
      _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.button_clicks = _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.button_clicks + 1 | 0;
      _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = "Shortcut Button (⌘S) clicked!";
      return;
    } else {
      return;
    }
  });
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 16);
  _M0MP49LING7167111moon_2degui3src4core9UIContext9separator(ui);
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 8);
  _M0MP49LING7167111moon_2degui3src4core9UIContext5label(ui, `累计点击次数: ${_M0MPC13int3Int18to__string_2einner(_M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.button_clicks, 10)}`);
}
function _M0FP49LING7167111moon_2degui8examples6canvas24draw__checkbox__showcase(ui) {
  _M0MP49LING7167111moon_2degui3src4core9UIContext14label__colored(ui, "复选选项框 (Checkbox Matrix)", _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary());
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 10);
  const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext8checkbox(ui, "启用 GPU WebGL 2.0 硬件加速", _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.checkbox_gpu);
  const _g = _bind._0;
  const _r1 = _bind._1;
  if (_r1.clicked) {
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.checkbox_gpu = _g;
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = `GPU Acceleration: ${_g ? "true" : "false"}`;
  }
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 8);
  const _bind$2 = _M0MP49LING7167111moon_2degui3src4core9UIContext8checkbox(ui, "显示对齐辅助参考网格 (Align Grid)", _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.checkbox_grid);
  const _grid = _bind$2._0;
  const _r2 = _bind$2._1;
  if (_r2.clicked) {
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.checkbox_grid = _grid;
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = `Grid Guide: ${_grid ? "true" : "false"}`;
  }
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 8);
  const _bind$3 = _M0MP49LING7167111moon_2degui3src4core9UIContext8checkbox(ui, "视网膜高对比度强化 (High Contrast)", _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.checkbox_dark_contrast);
  const _dark = _bind$3._0;
  const _r3 = _bind$3._1;
  if (_r3.clicked) {
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.checkbox_dark_contrast = _dark;
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = `High Contrast: ${_dark ? "true" : "false"}`;
  }
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 8);
  const _bind$4 = _M0MP49LING7167111moon_2degui3src4core9UIContext8checkbox(ui, "高品质矢量抗锯齿 (Subpixel AA)", _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.checkbox_antialiasing);
  const _aa = _bind$4._0;
  const _r4 = _bind$4._1;
  if (_r4.clicked) {
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.checkbox_antialiasing = _aa;
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = `Subpixel AA: ${_aa ? "true" : "false"}`;
    return;
  } else {
    return;
  }
}
function _M0FP49LING7167111moon_2degui8examples6canvas28draw__code__editor__showcase(ui) {
  _M0MP49LING7167111moon_2degui3src4core9UIContext14label__colored(ui, "多行代码与行号标尺编辑器 (CodeEditor)", _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary());
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 6);
  const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext20code__editor_2einner(ui, "gallery_code", _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.code_buffer, _M0MP49LING7167111moon_2degui3src4math4Vec23new(ui.available_width, 210), true, false);
  const _new_code = _bind._0;
  const _resp = _bind._1;
  _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.code_buffer = _new_code;
  if (_resp.has_focus) {
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = "CodeEditor Focused";
    return;
  } else {
    return;
  }
}
function _M0FP49LING7167111moon_2degui8examples6canvas34draw__collapsing__header__showcase(ui) {
  _M0MP49LING7167111moon_2degui3src4core9UIContext14label__colored(ui, "折叠信息面板 (CollapsingHeader)", _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary());
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 8);
  _M0MP49LING7167111moon_2degui3src4core9UIContext18collapsing__header(ui, "sec_render", "图形着色管线配置", true, (sec) => {
    _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(sec, 4);
    const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext8checkbox(sec, "开启矢量纹理多级渐远 (Mipmapping)", _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.checkbox_gpu);
    const _g = _bind._0;
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.checkbox_gpu = _g;
    _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(sec, 4);
    const _bind$2 = _M0MP49LING7167111moon_2degui3src4core9UIContext6slider(sec, "视口平移阻尼系数", _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.slider_zoom, 0.1, 3);
    const _z = _bind$2._0;
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.slider_zoom = _z;
    _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(sec, 4);
  });
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 8);
  _M0MP49LING7167111moon_2degui3src4core9UIContext18collapsing__header(ui, "sec_grid", "辅助网格剖分参数", false, (sec) => {
    _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(sec, 4);
    const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext11drag__value(sec, "网格间距", _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.drag_x, 1, 5, 100);
    const _x = _bind._0;
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.drag_x = _x;
    _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(sec, 4);
    const _bind$2 = _M0MP49LING7167111moon_2degui3src4core9UIContext8checkbox(sec, "开启极简背景", _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.checkbox_grid);
    const _gr = _bind$2._0;
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.checkbox_grid = _gr;
    _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(sec, 4);
  });
}
function _M0FP49LING7167111moon_2degui8examples6canvas29draw__color__button__showcase(ui) {
  _M0MP49LING7167111moon_2degui3src4core9UIContext14label__colored(ui, "调色板拾取器 (ColorButton Palette)", _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary());
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 10);
  _M0MP49LING7167111moon_2degui3src4core9UIContext5label(ui, "点击色块选择主题主色：");
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 10);
  const palette = [_M0MP49LING7167111moon_2degui3src5color5Color3rgb(37, 99, 235), _M0MP49LING7167111moon_2degui3src5color5Color3rgb(16, 185, 129), _M0MP49LING7167111moon_2degui3src5color5Color3rgb(245, 158, 11), _M0MP49LING7167111moon_2degui3src5color5Color3rgb(244, 63, 94), _M0MP49LING7167111moon_2degui3src5color5Color3rgb(100, 116, 139), _M0MP49LING7167111moon_2degui3src5color5Color3rgb(139, 92, 246)];
  const names = ["Cobalt Blue", "Emerald Green", "Amber Gold", "Rose Coral", "Slate Dark", "Violet Purple"];
  _M0MP49LING7167111moon_2degui3src4core9UIContext10horizontal(ui, (row) => {
    let _tmp = 0;
    while (true) {
      const i = _tmp;
      if (i < palette.length) {
        const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext13color__button(row, `pal_${_M0MPC13int3Int18to__string_2einner(i, 10)}`, _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(palette, i));
        const _clicked = _bind._0;
        if (_clicked) {
          _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.color_idx = i;
          _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = `Selected Color: ${_M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(names, i)}`;
        }
        _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(row, 12);
        _tmp = i + 1 | 0;
        continue;
      } else {
        return;
      }
    }
  });
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 16);
  _M0MP49LING7167111moon_2degui3src4core9UIContext9separator(ui);
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 8);
  const active_col = _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(palette, _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.color_idx);
  const active_name = _M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(names, _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.color_idx);
  _M0MP49LING7167111moon_2degui3src4core9UIContext14label__colored(ui, `当前生效色调: ${active_name}`, active_col);
}
function _M0FP49LING7167111moon_2degui8examples6canvas29draw__color__picker__showcase(ui) {
  _M0MP49LING7167111moon_2degui3src4core9UIContext14label__colored(ui, "2D HSV 拾色器 (ColorPicker)", _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary());
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 6);
  _M0MP49LING7167111moon_2degui3src4core9UIContext5label(ui, "2D 饱和度-明度渐变方盘，彩虹色相槽，Alpha 棋盘格，双环高对比取色游标。");
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 12);
  _M0MP49LING7167111moon_2degui3src4core9UIContext10horizontal(ui, (row) => {
    const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext21color__picker_2einner(row, "gal_cp", _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.color_picker_val, true);
    const _c1 = _bind._0;
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.color_picker_val = _c1;
    _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(row, 24);
    const _bind$2 = _M0MP49LING7167111moon_2degui3src4core9UIContext29color__picker__button_2einner(row, "gal_cp_btn", _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.color_picker_val, true);
    const _c2 = _bind$2._0;
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.color_picker_val = _c2;
  });
}
function _M0FP49LING7167111moon_2degui8examples6canvas26draw__combo__box__showcase(ui) {
  _M0MP49LING7167111moon_2degui3src4core9UIContext14label__colored(ui, "下拉单选菜单 (ComboBox)", _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary());
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 10);
  const formats = ["PNG 无损位图", "SVG 矢量图形", "WebP 高效压缩", "PDF 文档格式"];
  const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext10combo__box(ui, "fmt", "导出格式", _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.combo_format, formats);
  const _f = _bind._0;
  if (_f !== _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.combo_format) {
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.combo_format = _f;
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = `Format selected: ${_M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(formats, _f)}`;
  }
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 12);
  const spaces = ["sRGB (标准色彩)", "Display P3 (广色域)", "Adobe RGB (专业印刷)"];
  const _bind$2 = _M0MP49LING7167111moon_2degui3src4core9UIContext10combo__box(ui, "color_space", "色彩空间", _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.combo_color, spaces);
  const _c = _bind$2._0;
  if (_c !== _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.combo_color) {
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.combo_color = _c;
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = `Color space: ${_M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(spaces, _c)}`;
    return;
  } else {
    return;
  }
}
function _M0FP49LING7167111moon_2degui8examples6canvas32draw__command__palette__showcase(ui) {
  _M0MP49LING7167111moon_2degui3src4core9UIContext14label__colored(ui, "全局模糊指令面板 (CommandPalette ⌘K)", _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary());
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 10);
  if (_M0MP49LING7167111moon_2degui3src4core9UIContext22button__primary__sized(ui, "唤起命令面板 (⌘K)", _M0MP49LING7167111moon_2degui3src4math4Vec23new(160, 32)).clicked) {
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.cmd_open = true;
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = "Command Palette Opened";
  }
  const commands = [_M0MP49LING7167111moon_2degui3src4core11CommandItem11new_2einner("new_file", "新建工程图纸 (New Canvas)", "文件", "⌘N"), _M0MP49LING7167111moon_2degui3src4core11CommandItem11new_2einner("save", "保存当前工程 (Save Project)", "文件", "⌘S"), _M0MP49LING7167111moon_2degui3src4core11CommandItem11new_2einner("zoom_fit", "全景自适应视图 (Fit All)", "视图", "⌘0"), _M0MP49LING7167111moon_2degui3src4core11CommandItem11new_2einner("theme_light", "切换白瓷工件风格 (Porcelain Theme)", "外观", ""), _M0MP49LING7167111moon_2degui3src4core11CommandItem11new_2einner("export_svg", "导出矢量 SVG 绘图 (Export Vector)", "导出", "⌘E")];
  const resp = _M0MP49LING7167111moon_2degui3src4core9UIContext24command__palette_2einner(ui, _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.cmd_open, _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.cmd_query, commands, _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.cmd_idx);
  _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.cmd_open = resp.open;
  _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.cmd_query = resp.query;
  _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.cmd_idx = resp.selected_index;
  const _bind = resp.selected_id;
  if (_bind === undefined) {
    return;
  } else {
    const _Some = _bind;
    const _cid = _Some;
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = `Command Executed: ${_cid}`;
    return;
  }
}
function _M0FP49LING7167111moon_2degui8examples6canvas29draw__context__menu__showcase(ui, vp_w, vp_h) {
  _M0MP49LING7167111moon_2degui3src4core9UIContext14label__colored(ui, "上下文弹出菜单 (ContextMenu)", _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary());
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 8);
  _M0MP49LING7167111moon_2degui3src4core9UIContext5label(ui, "点击下方按钮触发上下文菜单弹窗，带有屏幕碰撞反转检测：");
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 10);
  const trigger_resp = _M0MP49LING7167111moon_2degui3src4core9UIContext13button__sized(ui, "点击或直接右键弹出菜单", _M0MP49LING7167111moon_2degui3src4math4Vec23new(170, 30));
  let _tmp;
  if (trigger_resp.clicked) {
    _tmp = true;
  } else {
    let _tmp$2;
    if (trigger_resp.secondary_clicked) {
      _tmp$2 = true;
    } else {
      let _tmp$3;
      const _p = ui.input;
      if (_p.mouse_secondary_pressed) {
        _tmp$3 = _M0MP49LING7167111moon_2degui3src4core9UIContext11is__hovered(ui, _M0MP49LING7167111moon_2degui3src4math4Rect3new(0, 0, vp_w, vp_h));
      } else {
        _tmp$3 = false;
      }
      _tmp$2 = _tmp$3;
    }
    _tmp = _tmp$2;
  }
  if (_tmp) {
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.ctx_menu_open = true;
    let _tmp$2;
    let _tmp$3;
    if (trigger_resp.secondary_clicked) {
      _tmp$3 = true;
    } else {
      const _p = ui.input;
      _tmp$3 = _p.mouse_secondary_pressed;
    }
    if (_tmp$3) {
      const _p = ui.input;
      _tmp$2 = _p.mouse_pos;
    } else {
      _tmp$2 = _M0MP49LING7167111moon_2degui3src4math4Vec23new(180, 120);
    }
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.ctx_menu_pos = _tmp$2;
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = "Context Menu Opened at Cursor";
  }
  const items = [_M0MP49LING7167111moon_2degui3src4core15ContextMenuItem3new("copy", "复制当前组件代码", _M0FP49LING7167111moon_2degui8examples6canvas29draw__context__menu__showcaseN6constrS1077, -1, _M0DTPC16option6OptionGRPB5ArrayGRP49LING7167111moon_2degui3src4core15ContextMenuItemEE4None__), _M0MP49LING7167111moon_2degui3src4core15ContextMenuItem3new("paste", "粘贴图元属性", _M0FP49LING7167111moon_2degui8examples6canvas29draw__context__menu__showcaseN6constrS1078, -1, _M0DTPC16option6OptionGRPB5ArrayGRP49LING7167111moon_2degui3src4core15ContextMenuItemEE4None__), _M0MP49LING7167111moon_2degui3src4core15ContextMenuItem9separator(), _M0MP49LING7167111moon_2degui3src4core15ContextMenuItem3new("inspect", "审查图元层级", _M0FP49LING7167111moon_2degui8examples6canvas29draw__context__menu__showcaseN6constrS1079, -1, _M0DTPC16option6OptionGRPB5ArrayGRP49LING7167111moon_2degui3src4core15ContextMenuItemEE4None__), _M0MP49LING7167111moon_2degui3src4core15ContextMenuItem3new("delete", "重置控件状态", undefined, -1, _M0DTPC16option6OptionGRPB5ArrayGRP49LING7167111moon_2degui3src4core15ContextMenuItemEE4None__)];
  const resp = _M0MP49LING7167111moon_2degui3src4core9UIContext28context__menu__items_2einner(ui, "demo_ctx", _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.ctx_menu_open, _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.ctx_menu_pos, items, 180, _M0MP49LING7167111moon_2degui3src4math4Vec23new(vp_w, vp_h));
  _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.ctx_menu_open = resp.open;
  const _bind = resp.selected_id;
  if (_bind === undefined) {
    return;
  } else {
    const _Some = _bind;
    const _sid = _Some;
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = `ContextMenu Action: ${_sid}`;
    return;
  }
}
function _M0FP49LING7167111moon_2degui8examples6canvas22draw__dialog__showcase(ui, cur_w, cur_h) {
  _M0MP49LING7167111moon_2degui3src4core9UIContext14label__colored(ui, "模态二次确认对话框 (Dialog System)", _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary());
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 6);
  _M0MP49LING7167111moon_2degui3src4core9UIContext5label(ui, "全屏暗色半透明遮罩与物理事件阻断，支持 Esc 快捷取消与 Enter 快速确认。");
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 12);
  if (_M0MP49LING7167111moon_2degui3src4core9UIContext15button__primary(ui, "触发警示对话框 (Open Dialog)").clicked) {
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.dialog_open = true;
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = "Dialog Opened";
  }
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 8);
  _M0MP49LING7167111moon_2degui3src4core9UIContext5label(ui, `最后交互状态: ${_M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.dialog_last_result}`);
  if (_M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.dialog_open) {
    const res = _M0MP49LING7167111moon_2degui3src4core9UIContext14dialog_2einner(ui, "gal_confirm_dlg", "重置工程配置文件？", "此操作将清除所有自定义键位绑定并恢复出厂默认值。", 1, "Confirm", "Cancel", 0, _M0MP49LING7167111moon_2degui3src4math4Vec23new(cur_w, cur_h));
    switch (res) {
      case 0: {
        _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.dialog_open = false;
        _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.dialog_last_result = "Confirmed (已确认)";
        _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = "Action Confirmed";
        return;
      }
      case 1: {
        _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.dialog_open = false;
        _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.dialog_last_result = "Cancelled (已取消)";
        _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = "Action Cancelled";
        return;
      }
      default: {
        return;
      }
    }
  } else {
    return;
  }
}
function _M0FP49LING7167111moon_2degui8examples6canvas27draw__drag__value__showcase(ui) {
  _M0MP49LING7167111moon_2degui3src4core9UIContext14label__colored(ui, "水银滚动数值调节器 (DragValue Scrubber)", _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary());
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 10);
  const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext11drag__value(ui, "X 轴坐标", _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.drag_x, 0.5, -1000, 1000);
  const _x = _bind._0;
  if (_x !== _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.drag_x) {
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.drag_x = _x;
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = `X Pos: ${String(_x)}`;
  }
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 8);
  const _bind$2 = _M0MP49LING7167111moon_2degui3src4core9UIContext11drag__value(ui, "Y 轴坐标", _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.drag_y, 0.5, -1000, 1000);
  const _y = _bind$2._0;
  if (_y !== _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.drag_y) {
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.drag_y = _y;
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = `Y Pos: ${String(_y)}`;
  }
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 8);
  const _bind$3 = _M0MP49LING7167111moon_2degui3src4core9UIContext11drag__value(ui, "比例系数", _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.drag_scale, 0.02, 0.1, 10);
  const _s = _bind$3._0;
  if (_s !== _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.drag_scale) {
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.drag_scale = _s;
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = `Scale: ${String(_s)}x`;
    return;
  } else {
    return;
  }
}
function _M0FP49LING7167111moon_2degui8examples6canvas20draw__knob__showcase(ui) {
  _M0MP49LING7167111moon_2degui3src4core9UIContext14label__colored(ui, "270° 弧形物理电位器机架 (Audio / CAD Rack)", _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary());
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 8);
  _M0MP49LING7167111moon_2degui3src4core9UIContext10horizontal(ui, (row) => {
    const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext12knob_2einner(row, "cutoff", "CUTOFF", _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.knob_cutoff, 20, 20000, 10, 1200, "Hz", 24, false);
    const _c = _bind._0;
    if (_c !== _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.knob_cutoff) {
      _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.knob_cutoff = _c;
      _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = `CUTOFF: ${String(_c)} Hz`;
    }
    _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(row, 16);
    const _bind$2 = _M0MP49LING7167111moon_2degui3src4core9UIContext12knob_2einner(row, "res", "RESONANCE", _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.knob_res, 0, 100, 1, 25, "%", 24, false);
    const _r = _bind$2._0;
    if (_r !== _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.knob_res) {
      _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.knob_res = _r;
      _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = `RESONANCE: ${String(_r)}%`;
    }
    _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(row, 16);
    const _bind$3 = _M0MP49LING7167111moon_2degui3src4core9UIContext12knob_2einner(row, "pan", "PAN", _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.knob_pan, -100, 100, 1, 0, "%", 24, true);
    const _p = _bind$3._0;
    if (_p !== _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.knob_pan) {
      _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.knob_pan = _p;
      _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = `PAN (Bipolar): ${String(_p)}%`;
    }
    _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(row, 16);
    const _bind$4 = _M0MP49LING7167111moon_2degui3src4core9UIContext12knob_2einner(row, "drive", "DRIVE", _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.knob_drive, 0, 24, 0.5, 6, "dB", 24, false);
    const _d = _bind$4._0;
    if (_d !== _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.knob_drive) {
      _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.knob_drive = _d;
      _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = `DRIVE: ${String(_d)} dB`;
      return;
    } else {
      return;
    }
  });
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 14);
  _M0MP49LING7167111moon_2degui3src4core9UIContext9separator(ui);
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 8);
  _M0MP49LING7167111moon_2degui3src4core9UIContext10horizontal(ui, (row) => {
    if (_M0MP49LING7167111moon_2degui3src4core9UIContext13button__sized(row, "默认预设", _M0MP49LING7167111moon_2degui3src4math4Vec23new(84, 26)).clicked) {
      _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.knob_cutoff = 1200;
      _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.knob_res = 25;
      _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.knob_pan = 0;
      _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.knob_drive = 6;
      _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = "Preset applied: Default";
    }
    _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(row, 10);
    if (_M0MP49LING7167111moon_2degui3src4core9UIContext13button__sized(row, "暖调低音", _M0MP49LING7167111moon_2degui3src4math4Vec23new(84, 26)).clicked) {
      _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.knob_cutoff = 380;
      _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.knob_res = 45;
      _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.knob_pan = 0;
      _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.knob_drive = 14;
      _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = "Preset applied: Warm Bass";
    }
    _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(row, 10);
    if (_M0MP49LING7167111moon_2degui3src4core9UIContext13button__sized(row, "亮音主导", _M0MP49LING7167111moon_2degui3src4math4Vec23new(84, 26)).clicked) {
      _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.knob_cutoff = 8500;
      _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.knob_res = 65;
      _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.knob_pan = 20;
      _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.knob_drive = 8;
      _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = "Preset applied: Bright Lead";
      return;
    } else {
      return;
    }
  });
}
function _M0FP49LING7167111moon_2degui8examples6canvas25draw__menu__bar__showcase(ui) {
  _M0MP49LING7167111moon_2degui3src4core9UIContext14label__colored(ui, "桌面级顶层系统菜单栏 (MenuBar)", _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary());
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 8);
  _M0MP49LING7167111moon_2degui3src4core9UIContext9menu__bar(ui, (bar) => {
    _M0MP49LING7167111moon_2degui3src4core9UIContext4menu(bar, "文件 (File)", (m) => {
      if (_M0MP49LING7167111moon_2degui3src4core9UIContext18menu__item_2einner(m, "新建图纸", "⌘N", false).clicked) {
        _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = "Menu: New File";
      }
      if (_M0MP49LING7167111moon_2degui3src4core9UIContext18menu__item_2einner(m, "保存图元", "⌘S", false).clicked) {
        _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = "Menu: Save File";
      }
      _M0MP49LING7167111moon_2degui3src4core9UIContext15menu__separator(m);
      if (_M0MP49LING7167111moon_2degui3src4core9UIContext18menu__item_2einner(m, "退出", "⌘Q", false).clicked) {
        _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = "Menu: Quit";
        return;
      } else {
        return;
      }
    });
    _M0MP49LING7167111moon_2degui3src4core9UIContext4menu(bar, "编辑 (Edit)", (m) => {
      if (_M0MP49LING7167111moon_2degui3src4core9UIContext18menu__item_2einner(m, "撤销", "⌘Z", false).clicked) {
        _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = "Menu: Undo";
      }
      if (_M0MP49LING7167111moon_2degui3src4core9UIContext18menu__item_2einner(m, "重做", "⌘Y", false).clicked) {
        _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = "Menu: Redo";
      }
      _M0MP49LING7167111moon_2degui3src4core9UIContext15menu__separator(m);
      if (_M0MP49LING7167111moon_2degui3src4core9UIContext18menu__item_2einner(m, "复制", "⌘C", false).clicked) {
        _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = "Menu: Copy";
      }
      if (_M0MP49LING7167111moon_2degui3src4core9UIContext18menu__item_2einner(m, "粘贴", "⌘V", false).clicked) {
        _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = "Menu: Paste";
        return;
      } else {
        return;
      }
    });
    _M0MP49LING7167111moon_2degui3src4core9UIContext4menu(bar, "视图 (View)", (m) => {
      if (_M0MP49LING7167111moon_2degui3src4core9UIContext18menu__item_2einner(m, "全景自适应", "⌘0", false).clicked) {
        _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = "Menu: Fit All";
      }
      if (_M0MP49LING7167111moon_2degui3src4core9UIContext18menu__item_2einner(m, "网格吸附", "", false).clicked) {
        _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = "Menu: Snap to Grid";
        return;
      } else {
        return;
      }
    });
    _M0MP49LING7167111moon_2degui3src4core9UIContext4menu(bar, "帮助 (Help)", (m) => {
      if (_M0MP49LING7167111moon_2degui3src4core9UIContext18menu__item_2einner(m, "关于 moon-egui", "", false).clicked) {
        _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = "Menu: About moon-egui";
      }
      if (_M0MP49LING7167111moon_2degui3src4core9UIContext18menu__item_2einner(m, "MoonBit 官方文档", "", false).clicked) {
        _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = "Menu: MoonBit Docs";
        return;
      } else {
        return;
      }
    });
  });
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 14);
  _M0MP49LING7167111moon_2degui3src4core9UIContext9separator(ui);
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 8);
  _M0MP49LING7167111moon_2degui3src4core9UIContext5label(ui, "支持桌面原生 hover 联动切换下拉、快捷键标识与分割线。");
}
function _M0FP49LING7167111moon_2degui8examples6canvas29draw__progress__bar__showcase(ui) {
  _M0MP49LING7167111moon_2degui3src4core9UIContext14label__colored(ui, "进度加载指示器 (ProgressBar)", _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary());
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 10);
  const pct_text = `${_M0MPC13int3Int18to__string_2einner(_M0MPC16double6Double7to__int(_M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.progress_val * 100), 10)}%`;
  _M0MP49LING7167111moon_2degui3src4core9UIContext13progress__bar(ui, _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.progress_val, `渲染合成进度 ${pct_text}`);
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 16);
  _M0MP49LING7167111moon_2degui3src4core9UIContext10horizontal(ui, (row) => {
    if (_M0MP49LING7167111moon_2degui3src4core9UIContext13button__sized(row, "步进 +10%", _M0MP49LING7167111moon_2degui3src4math4Vec23new(80, 26)).clicked) {
      let nv = _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.progress_val + 0.1;
      if (nv > 1) {
        nv = 1;
      }
      _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.progress_val = nv;
      _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = `Progress: ${_M0MPC13int3Int18to__string_2einner(_M0MPC16double6Double7to__int(nv * 100), 10)}%`;
    }
    _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(row, 8);
    if (_M0MP49LING7167111moon_2degui3src4core9UIContext13button__sized(row, "倒退 -10%", _M0MP49LING7167111moon_2degui3src4math4Vec23new(80, 26)).clicked) {
      let nv = _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.progress_val - 0.1;
      if (nv < 0) {
        nv = 0;
      }
      _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.progress_val = nv;
      _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = `Progress: ${_M0MPC13int3Int18to__string_2einner(_M0MPC16double6Double7to__int(nv * 100), 10)}%`;
    }
    _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(row, 8);
    if (_M0MP49LING7167111moon_2degui3src4core9UIContext13button__sized(row, "重置为 0", _M0MP49LING7167111moon_2degui3src4math4Vec23new(80, 26)).clicked) {
      _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.progress_val = 0;
      _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = "Progress reset to 0%";
      return;
    } else {
      return;
    }
  });
}
function _M0FP49LING7167111moon_2degui8examples6canvas21draw__radio__showcase(ui) {
  _M0MP49LING7167111moon_2degui3src4core9UIContext14label__colored(ui, "互斥单选按钮组 (Radio Group)", _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary());
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 10);
  _M0MP49LING7167111moon_2degui3src4core9UIContext5label(ui, "选择当前图层渲染引擎管线：");
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 8);
  const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext5radio(ui, "高性能光栅化模式 (WebGL 2.0 Direct Raster)", _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.radio_quality === 0);
  const _r0 = _bind._1;
  if (_r0.clicked) {
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.radio_quality = 0;
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = "Quality mode: WebGL 2.0 Direct";
  }
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 6);
  const _bind$2 = _M0MP49LING7167111moon_2degui3src4core9UIContext5radio(ui, "平衡矢量渲染模式 (Canvas 2D Batch)", _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.radio_quality === 1);
  const _r1 = _bind$2._1;
  if (_r1.clicked) {
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.radio_quality = 1;
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = "Quality mode: Canvas 2D Batch";
  }
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 6);
  const _bind$3 = _M0MP49LING7167111moon_2degui3src4core9UIContext5radio(ui, "纯 Wasm 软件像素保真 (Pure Software Wasm)", _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.radio_quality === 2);
  const _r2 = _bind$3._1;
  if (_r2.clicked) {
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.radio_quality = 2;
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = "Quality mode: Software Wasm";
  }
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 14);
  _M0MP49LING7167111moon_2degui3src4core9UIContext9separator(ui);
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 8);
  const _bind$4 = _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.radio_quality;
  let mode_desc;
  switch (_bind$4) {
    case 0: {
      mode_desc = "已启用直接着色管线，兼具百万人偶高帧率刷新。";
      break;
    }
    case 1: {
      mode_desc = "当前生效：兼顾广泛浏览器兼容性与视网膜清晰度。";
      break;
    }
    default: {
      mode_desc = "已启用纯 CPU 标量像素仿真，保证 100% 确定性输出。";
    }
  }
  _M0MP49LING7167111moon_2degui3src4core9UIContext5label(ui, mode_desc);
}
function _M0FP49LING7167111moon_2degui8examples6canvas26draw__rich__text__showcase(ui) {
  _M0MP49LING7167111moon_2degui3src4core9UIContext14label__colored(ui, "流式排版富文本与超链接 (RichText & Hyperlink)", _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary());
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 6);
  _M0MP49LING7167111moon_2degui3src4core9UIContext5label(ui, "支持单词自适应折行、行内代码块质感与悬停柔和下划线超链接。");
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 12);
  const spans = [_M0MP49LING7167111moon_2degui3src4core8TextSpan6normal("当前运行环境为"), _M0MP49LING7167111moon_2degui3src4core8TextSpan4code("MoonBit Wasm"), _M0MP49LING7167111moon_2degui3src4core8TextSpan4bold("即时模式渲染管线。"), _M0MP49LING7167111moon_2degui3src4core8TextSpan6normal("它直接向原生 HTML5 Canvas 提交绘制指令。欲了解更多细节，请访问"), _M0MP49LING7167111moon_2degui3src4core8TextSpan4link("MoonBit 官方主页", "https://www.moonbitlang.cn"), _M0MP49LING7167111moon_2degui3src4core8TextSpan6normal("或查看"), _M0MP49LING7167111moon_2degui3src4core8TextSpan4link("API 手册", "https://docs.moonbitlang.com"), _M0MP49LING7167111moon_2degui3src4core8TextSpan6normal("。")];
  const resp = _M0MP49LING7167111moon_2degui3src4core9UIContext18rich__text_2einner(ui, "gal_rt", spans, ui.available_width);
  const _bind = resp.clicked_url;
  if (_bind === undefined) {
  } else {
    const _Some = _bind;
    const _url = _Some;
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.rich_text_last_url = _url;
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = `Clicked URL: ${_url}`;
  }
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 16);
  const _bind$2 = _M0MP49LING7167111moon_2degui3src4core9UIContext9hyperlink(ui, "独立超链接组件: moon-egui GitHub Repository", "https://github.com/LING71671/moon-egui");
  const _clicked = _bind$2._0;
  if (_clicked) {
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.rich_text_last_url = "https://github.com/LING71671/moon-egui";
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = "Clicked GitHub Link";
  }
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 8);
  _M0MP49LING7167111moon_2degui3src4core9UIContext5label(ui, `最后激活链接: ${_M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.rich_text_last_url}`);
}
function _M0FP49LING7167111moon_2degui8examples6canvas28draw__scroll__area__showcase(ui) {
  _M0MP49LING7167111moon_2degui3src4core9UIContext14label__colored(ui, "带视口裁剪与滑块的滚动区域 (ScrollArea)", _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary());
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 6);
  _M0MP49LING7167111moon_2degui3src4core9UIContext12scroll__area(ui, "gallery_scroll", _M0MP49LING7167111moon_2degui3src4math4Vec23new(ui.available_width, 200), (sa) => {
    let _tmp = 1;
    while (true) {
      const i = _tmp;
      if (i <= 20) {
        const text = `图元索引条目 #${_M0MPC13int3Int18to__string_2einner(i, 10)} (Immediate-Mode Vector Render Record)`;
        _M0MP49LING7167111moon_2degui3src4core9UIContext5label(sa, text);
        _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(sa, 4);
        _tmp = i + 1 | 0;
        continue;
      } else {
        return;
      }
    }
  });
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 8);
  _M0MP49LING7167111moon_2degui3src4core9UIContext5label(ui, "支持鼠标滚轮滚动、精确局部 Scissor 剪裁与按需滚动条。");
}
function _M0FP49LING7167111moon_2degui8examples6canvas34draw__segmented__control__showcase(ui) {
  _M0MP49LING7167111moon_2degui3src4core9UIContext14label__colored(ui, "分段控制器 (SegmentedControl)", _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary());
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 6);
  _M0MP49LING7167111moon_2degui3src4core9UIContext5label(ui, "微凹浅灰底槽 + 悬浮纯白瓷药丸，支持鼠标点击与左右方向键轮转选项。");
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 12);
  const views = ["日视图 (Day)", "周视图 (Week)", "月视图 (Month)", "年趋势 (Year)"];
  const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext26segmented__control_2einner(ui, "gal_seg", views, _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.segmented_sel, 34, 480);
  const _sel = _bind._0;
  if (_sel !== _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.segmented_sel) {
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.segmented_sel = _sel;
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = `Segment Selected: ${_M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(views, _sel)}`;
    return;
  } else {
    return;
  }
}
function _M0FP49LING7167111moon_2degui8examples6canvas22draw__slider__showcase(ui) {
  _M0MP49LING7167111moon_2degui3src4core9UIContext14label__colored(ui, "连续标量滑块 (Continuous Slider)", _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary());
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 10);
  const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext6slider(ui, "缩放倍率 (Zoom)", _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.slider_zoom, 0.1, 5);
  const _z = _bind._0;
  if (_z !== _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.slider_zoom) {
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.slider_zoom = _z;
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = `Zoom: ${String(_z)}`;
  }
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 10);
  const _bind$2 = _M0MP49LING7167111moon_2degui3src4core9UIContext6slider(ui, "图层透明度 (Opacity)", _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.slider_opacity, 0, 100);
  const _op = _bind$2._0;
  if (_op !== _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.slider_opacity) {
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.slider_opacity = _op;
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = `Opacity: ${String(_op)}%`;
    return;
  } else {
    return;
  }
}
function _M0FP49LING7167111moon_2degui8examples6canvas25draw__sparkline__showcase(ui) {
  _M0MP49LING7167111moon_2degui3src4core9UIContext14label__colored(ui, "实时微型折线走势图 (Sparkline Metrics)", _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary());
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 6);
  _M0MP49LING7167111moon_2degui3src4core9UIContext5label(ui, "归一化极值自适应映射，浅晕投影，内置零差值防崩溃与鼠标就近吸附准心。");
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 12);
  _M0MP49LING7167111moon_2degui3src4core9UIContext10horizontal(ui, (row) => {
    const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext9sparkline(row, "spk_cpu", _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.sparkline_data, _M0MP49LING7167111moon_2degui3src4math4Vec23new(140, 42), undefined, -1, -1);
    const _h1 = _bind._0;
    _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(row, 16);
    const _bind$2 = _M0MP49LING7167111moon_2degui3src4core9UIContext17sparkline_2einner(row, "spk_fps", [58, 59, 60, 60, 59, 60, 60, 60, 59, 60], _M0MP49LING7167111moon_2degui3src4math4Vec23new(140, 42), _M0MP49LING7167111moon_2degui3src5color5Color7success(), true, true);
    const _h2 = _bind$2._0;
    _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(row, 16);
    const _bind$3 = _M0MP49LING7167111moon_2degui3src4core9UIContext17sparkline_2einner(row, "spk_mem", [120, 125, 130, 140, 142, 138, 145, 150], _M0MP49LING7167111moon_2degui3src4math4Vec23new(140, 42), _M0MP49LING7167111moon_2degui3src5color5Color7warning(), true, true);
    const _h3 = _bind$3._0;
    if (_h1 === undefined) {
      if (_h2 === undefined) {
        if (_h3 === undefined) {
          return;
        } else {
          const _Some = _h3;
          const _idx = _Some;
          _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = `Memory Sparkline Node: #${_M0MPC13int3Int18to__string_2einner(_idx, 10)}`;
          return;
        }
      } else {
        const _Some = _h2;
        const _idx = _Some;
        _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = `FPS Sparkline Node: #${_M0MPC13int3Int18to__string_2einner(_idx, 10)}`;
        return;
      }
    } else {
      const _Some = _h1;
      const _idx = _Some;
      _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = `CPU Sparkline Node: #${_M0MPC13int3Int18to__string_2einner(_idx, 10)}`;
      return;
    }
  });
}
function _M0FP49LING7167111moon_2degui8examples6canvas23draw__spinner__showcase(ui) {
  _M0MP49LING7167111moon_2degui3src4core9UIContext14label__colored(ui, "时间驱动呼吸微加载动画 (Spinner Animation)", _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary());
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 6);
  _M0MP49LING7167111moon_2degui3src4core9UIContext5label(ui, "纯时间物理驱动的非对称伸缩公转弧线，60 FPS 平滑无卡顿，无额外定时器开销。");
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 14);
  _M0MP49LING7167111moon_2degui3src4core9UIContext10horizontal(ui, (row) => {
    _M0MP49LING7167111moon_2degui3src4core9UIContext7spinner(row, _M0FP49LING7167111moon_2degui8examples6canvas23draw__spinner__showcaseN6constrS1080, undefined, _M0DTPC16option6OptionGdE4None__);
    _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(row, 16);
    _M0MP49LING7167111moon_2degui3src4core9UIContext15spinner_2einner(row, 24, _M0MP49LING7167111moon_2degui3src5color5Color7success(), 2.5);
    _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(row, 16);
    _M0MP49LING7167111moon_2degui3src4core9UIContext15spinner_2einner(row, 32, _M0MP49LING7167111moon_2degui3src5color5Color6danger(), 3);
  });
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 16);
  _M0MP49LING7167111moon_2degui3src4core9UIContext20spinner__with__label(ui, "正在同步远程 MoonBit 模块索引...", _M0FP49LING7167111moon_2degui8examples6canvas23draw__spinner__showcaseN6constrS1081, undefined, _M0DTPC16option6OptionGdE4None__);
}
function _M0FP49LING7167111moon_2degui8examples6canvas24draw__splitter__showcase(ui) {
  _M0MP49LING7167111moon_2degui3src4core9UIContext14label__colored(ui, "双向可拖拽分栏容器 (Splitter Panes)", _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary());
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 6);
  _M0MP49LING7167111moon_2degui3src4core9UIContext5label(ui, "鼠标拖拽中央把手调节比例，内置 >= 60px 物理防挤压防护与 Scissor 裁剪盒。");
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 10);
  const split_size = _M0MP49LING7167111moon_2degui3src4math4Vec23new(ui.available_width, 220);
  const new_ratio = _M0MP49LING7167111moon_2degui3src4core9UIContext25split__horizontal_2einner(ui, "gal_split_h", _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.splitter_ratio, split_size, (pane_ui, rect) => {
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(pane_ui.draw_list, rect, _M0MP49LING7167111moon_2degui3src5color5Color9bg__hover(), 4);
    _M0MP49LING7167111moon_2degui3src4core9UIContext11set__cursor(pane_ui, _M0MP49LING7167111moon_2degui3src4math4Vec23new(rect.x + 12, rect.y + 12));
    _M0MP49LING7167111moon_2degui3src4core9UIContext14label__colored(pane_ui, "左侧主导航栏", _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary());
    _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(pane_ui, 6);
    _M0MP49LING7167111moon_2degui3src4core9UIContext5label(pane_ui, "项目文件 (src/)");
    _M0MP49LING7167111moon_2degui3src4core9UIContext5label(pane_ui, "资源目录 (assets/)");
  }, (pane_ui, rect) => {
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(pane_ui.draw_list, rect, _M0MP49LING7167111moon_2degui3src5color5Color11bg__surface(), 4);
    _M0MP49LING7167111moon_2degui3src4core9UIContext11set__cursor(pane_ui, _M0MP49LING7167111moon_2degui3src4math4Vec23new(rect.x + 12, rect.y + 12));
    _M0MP49LING7167111moon_2degui3src4core9UIContext14label__colored(pane_ui, "右侧工作区画布", _M0MP49LING7167111moon_2degui3src5color5Color12text__strong());
    _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(pane_ui, 6);
    _M0MP49LING7167111moon_2degui3src4core9UIContext5label(pane_ui, `实时分栏比例: ${_M0MPC13int3Int18to__string_2einner(_M0MPC16double6Double7to__int(_M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.splitter_ratio * 100), 10)}%`);
  }, 0.15, 0.85, 60);
  _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.splitter_ratio = new_ratio;
}
function _M0FP49LING7167111moon_2degui8examples6canvas24draw__tab__bar__showcase(ui) {
  _M0MP49LING7167111moon_2degui3src4core9UIContext14label__colored(ui, "分段式导航标签栏 (TabBar)", _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary());
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 8);
  const tabs = ["规范概览 Overview", "内核性能 Metrics", "运行日志 Logs"];
  const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext8tab__bar(ui, "demo_tab", tabs, _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.tab_selected);
  const _cur = _bind._0;
  if (_cur !== _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.tab_selected) {
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.tab_selected = _cur;
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = `Tab switched: ${_M0MPC15array5Array2atGRP49LING7167111moon_2degui3src4core2IdE(tabs, _cur)}`;
  }
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 14);
  _M0MP49LING7167111moon_2degui3src4core9UIContext9separator(ui);
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 10);
  const _bind$2 = _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.tab_selected;
  switch (_bind$2) {
    case 0: {
      _M0MP49LING7167111moon_2degui3src4core9UIContext5label(ui, "【规范概览】Moon-EGUI 遵循 Studio Light 极简陶瓷质感标准。");
      _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 4);
      _M0MP49LING7167111moon_2degui3src4core9UIContext5label(ui, "采用精准 8px 网格步进系统，高透光微投影与 1px 细发丝描边。");
      return;
    }
    case 1: {
      _M0MP49LING7167111moon_2degui3src4core9UIContext5label(ui, "【内核性能】微秒级布局计算，零中间虚拟 DOM 分配开销。");
      _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 4);
      _M0MP49LING7167111moon_2degui3src4core9UIContext5label(ui, "全量 DrawList 矢量原语管线，满帧稳定运行于 60 FPS。");
      return;
    }
    default: {
      _M0MP49LING7167111moon_2degui3src4core9UIContext5label(ui, "【运行日志】[INFO] Canvas Host Mounted successfully.");
      _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 4);
      _M0MP49LING7167111moon_2degui3src4core9UIContext5label(ui, "[INFO] Immediate-mode engine tick: 0.28ms dispatch time.");
      return;
    }
  }
}
function _M0FP49LING7167111moon_2degui8examples6canvas21draw__table__showcase(ui) {
  _M0MP49LING7167111moon_2degui3src4core9UIContext14label__colored(ui, "虚拟化数据表格 (Virtual Table)", _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary());
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 6);
  _M0MP49LING7167111moon_2degui3src4core9UIContext5label(ui, "支持 10,000 行极速虚拟滚动（只渲染视口行），支持列宽拖拽与表头排序。");
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 10);
  const resp = _M0MP49LING7167111moon_2degui3src4core9UIContext13table_2einner(ui, "gal_table", _M0MP49LING7167111moon_2degui3src4math4Vec23new(ui.available_width, 220), _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.table_columns, 10000, (cell_ui, r, c, rect) => {
    let cell_text;
    switch (c) {
      case 0: {
        cell_text = `#${_M0MPC13int3Int18to__string_2einner(r, 10)}`;
        break;
      }
      case 1: {
        cell_text = `User_${_M0MPC13int3Int18to__string_2einner(r, 10)}`;
        break;
      }
      case 2: {
        cell_text = (r % 3 | 0) === 0 ? "Admin" : (r % 3 | 0) === 1 ? "Developer" : "Viewer";
        break;
      }
      case 3: {
        cell_text = `${_M0MPC13int3Int18to__string_2einner(80 + ((Math.imul(r, 7) | 0) % 20 | 0) | 0, 10)} pts`;
        break;
      }
      default: {
        cell_text = "";
      }
    }
    _M0MP49LING7167111moon_2degui3src4core9UIContext11set__cursor(cell_ui, _M0MP49LING7167111moon_2degui3src4math4Vec23new(rect.x + 8, rect.y + 7));
    _M0MP49LING7167111moon_2degui3src4core9UIContext5label(cell_ui, cell_text);
  }, 0, 0, _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.table_selected_row, _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.table_sort_col, _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.table_sort_dir);
  if (resp.sort_changed) {
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.table_sort_col = resp.sort_column;
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.table_sort_dir = resp.sort_direction;
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = `Table Sorted: ${resp.sort_column}`;
  }
  const _bind = resp.clicked_row;
  if (_bind === undefined) {
    return;
  } else {
    const _Some = _bind;
    const _r = _Some;
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.table_selected_row = _r;
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = `Row Selected: ${_M0MPC13int3Int18to__string_2einner(_r, 10)}`;
    return;
  }
}
function _M0FP49LING7167111moon_2degui8examples6canvas26draw__text__edit__showcase(ui) {
  _M0MP49LING7167111moon_2degui3src4core9UIContext14label__colored(ui, "单行文本输入框 (TextEdit)", _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary());
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 10);
  const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext10text__edit(ui, "name_input", _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.text_name, "请输入开发者姓名");
  const _n = _bind._0;
  const _r1 = _bind._1;
  _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.text_name = _n;
  if (_r1.has_focus) {
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = `Editing Name: ${_n}`;
  }
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 10);
  const _bind$2 = _M0MP49LING7167111moon_2degui3src4core9UIContext10text__edit(ui, "email_input", _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.text_email, "dev@moonbitlang.com");
  const _e = _bind$2._0;
  const _r2 = _bind$2._1;
  _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.text_email = _e;
  if (_r2.has_focus) {
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = `Editing Email: ${_e}`;
  }
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 16);
  _M0MP49LING7167111moon_2degui3src4core9UIContext9separator(ui);
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 8);
  _M0MP49LING7167111moon_2degui3src4core9UIContext5label(ui, "支持光标精确定位、文本追加、退格以及焦点切换。");
}
function _M0FP49LING7167111moon_2degui8examples6canvas21draw__toast__showcase(ui, vp_w, vp_h) {
  _M0MP49LING7167111moon_2degui3src4core9UIContext14label__colored(ui, "全局胶囊通知堆栈与平滑衰减 (Toast Notifications)", _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary());
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 10);
  _M0MP49LING7167111moon_2degui3src4core9UIContext10horizontal(ui, (row) => {
    if (_M0MP49LING7167111moon_2degui3src4core9UIContext13button__sized(row, "触发信息通知", _M0MP49LING7167111moon_2degui3src4math4Vec23new(104, 28)).clicked) {
      const t = _M0MP49LING7167111moon_2degui3src4core5Toast12info_2einner("工程提示", "Canvas 2D 光栅化管线就绪", 4);
      _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(_M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.toasts, t);
      _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = "Triggered: Info Toast";
    }
    _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(row, 8);
    if (_M0MP49LING7167111moon_2degui3src4core9UIContext13button__sized(row, "触发成功通知", _M0MP49LING7167111moon_2degui3src4math4Vec23new(104, 28)).clicked) {
      const t = _M0MP49LING7167111moon_2degui3src4core5Toast15success_2einner("编译完成", "Wasm 内核输出 0 警告", 4);
      _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(_M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.toasts, t);
      _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = "Triggered: Success Toast";
    }
    _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(row, 8);
    if (_M0MP49LING7167111moon_2degui3src4core9UIContext13button__sized(row, "触发警告通知", _M0MP49LING7167111moon_2degui3src4math4Vec23new(104, 28)).clicked) {
      const t = _M0MP49LING7167111moon_2degui3src4core5Toast15warning_2einner("内存警告", "视口包含超过 65,536 节点", 4);
      _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(_M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.toasts, t);
      _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = "Triggered: Warning Toast";
    }
    _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(row, 8);
    if (_M0MP49LING7167111moon_2degui3src4core9UIContext13button__sized(row, "触发错误通知", _M0MP49LING7167111moon_2degui3src4math4Vec23new(104, 28)).clicked) {
      const t = _M0MP49LING7167111moon_2degui3src4core5Toast14danger_2einner("连接中断", "WebSocket 帧丢失", 4);
      _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4core5EventE(_M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.toasts, t);
      _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = "Triggered: Danger Toast";
      return;
    } else {
      return;
    }
  });
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 16);
  _M0MP49LING7167111moon_2degui3src4core9UIContext9separator(ui);
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 8);
  _M0MP49LING7167111moon_2degui3src4core9UIContext5label(ui, "通知将自动悬浮在右上方，带有时间进度衰减条与手动关闭按钮。");
  _M0MP49LING7167111moon_2degui3src4core9UIContext20toast__stack_2einner(ui, _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.toasts, 0, _M0MP49LING7167111moon_2degui3src4math4Vec23new(vp_w, vp_h));
}
function _M0FP49LING7167111moon_2degui8examples6canvas22draw__toggle__showcase(ui) {
  _M0MP49LING7167111moon_2degui3src4core9UIContext14label__colored(ui, "胶囊式状态切换开关 (Toggle Switch)", _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary());
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 10);
  const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext6toggle(ui, "极简专注模式 (Zen Mode)", _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.toggle_minimal);
  const _min = _bind._0;
  const _r1 = _bind._1;
  if (_r1.clicked) {
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.toggle_minimal = _min;
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = `Zen Mode: ${_min ? "true" : "false"}`;
  }
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 8);
  const _bind$2 = _M0MP49LING7167111moon_2degui3src4core9UIContext6toggle(ui, "云端自动同步保存 (Cloud Sync)", _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.toggle_autosave);
  const _auto = _bind$2._0;
  const _r2 = _bind$2._1;
  if (_r2.clicked) {
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.toggle_autosave = _auto;
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = `Auto-save: ${_auto ? "true" : "false"}`;
  }
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 8);
  const _bind$3 = _M0MP49LING7167111moon_2degui3src4core9UIContext6toggle(ui, "视网膜高分屏自适应 (Retina High-DPR)", _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.toggle_retina);
  const _retina = _bind$3._0;
  const _r3 = _bind$3._1;
  if (_r3.clicked) {
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.toggle_retina = _retina;
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = `Retina DPR: ${_retina ? "true" : "false"}`;
  }
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 8);
  const _bind$4 = _M0MP49LING7167111moon_2degui3src4core9UIContext6toggle(ui, "微触觉反馈模拟 (Micro-haptics)", _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.toggle_haptics);
  const _hap = _bind$4._0;
  const _r4 = _bind$4._1;
  if (_r4.clicked) {
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.toggle_haptics = _hap;
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = `Haptics: ${_hap ? "true" : "false"}`;
    return;
  } else {
    return;
  }
}
function _M0FP49LING7167111moon_2degui8examples6canvas23draw__tooltip__showcase(ui) {
  _M0MP49LING7167111moon_2degui3src4core9UIContext14label__colored(ui, "即时浮动微型提示气泡 (Tooltip Bubble)", _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary());
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 8);
  _M0MP49LING7167111moon_2degui3src4core9UIContext5label(ui, "将鼠标悬停在下方各控制按钮上查看即时气泡提示：");
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 12);
  _M0MP49LING7167111moon_2degui3src4core9UIContext10horizontal(ui, (row) => {
    const r1 = _M0MP49LING7167111moon_2degui3src4core9UIContext13button__sized(row, "图元渲染统计", _M0MP49LING7167111moon_2degui3src4math4Vec23new(110, 28));
    if (r1.hovered) {
      _M0MP49LING7167111moon_2degui3src4core9UIContext7tooltip(row, "当前视口活跃图元: 1,024 Rects, 32 Texts");
    }
    _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(row, 10);
    const r2 = _M0MP49LING7167111moon_2degui3src4core9UIContext13button__sized(row, "GC 运行状态", _M0MP49LING7167111moon_2degui3src4math4Vec23new(110, 28));
    if (r2.hovered) {
      _M0MP49LING7167111moon_2degui3src4core9UIContext7tooltip(row, "MoonBit 自动内存管理正常，零垃圾回收卡顿");
    }
    _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(row, 10);
    const r3 = _M0MP49LING7167111moon_2degui3src4core9UIContext13button__sized(row, "导出设计令牌", _M0MP49LING7167111moon_2degui3src4math4Vec23new(110, 28));
    if (r3.hovered) {
      _M0MP49LING7167111moon_2degui3src4core9UIContext7tooltip(row, "导出符合 Studio Light 规范的标准 Token JSON");
      return;
    } else {
      return;
    }
  });
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 16);
  _M0MP49LING7167111moon_2degui3src4core9UIContext9separator(ui);
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 8);
  _M0MP49LING7167111moon_2degui3src4core9UIContext5label(ui, "气泡在顶层前景渲染层自动绘制，带精准像素避让与轻量投影。");
}
function _M0FP49LING7167111moon_2degui8examples6canvas26draw__tree__view__showcase(ui) {
  _M0MP49LING7167111moon_2degui3src4core9UIContext14label__colored(ui, "分层引导线资产树 (Hierarchy TreeView)", _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary());
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 6);
  const tree_data = [_M0MP49LING7167111moon_2degui3src4core8TreeNode11new_2einner("src", "src", [], "folder"), _M0MP49LING7167111moon_2degui3src4core8TreeNode11new_2einner("assets", "assets", [_M0MP49LING7167111moon_2degui3src4core8TreeNode12leaf_2einner("logo_png", "logo.png", "img"), _M0MP49LING7167111moon_2degui3src4core8TreeNode12leaf_2einner("shader_wgsl", "shader.wgsl", "code"), _M0MP49LING7167111moon_2degui3src4core8TreeNode12leaf_2einner("theme_json", "theme.json", "json")], "folder"), _M0MP49LING7167111moon_2degui3src4core8TreeNode12leaf_2einner("moon_mod", "moon.mod", "doc"), _M0MP49LING7167111moon_2degui3src4core8TreeNode12leaf_2einner("readme_md", "README.md", "doc")];
  const tree_resp = _M0MP49LING7167111moon_2degui3src4core9UIContext18tree__view_2einner(ui, "gallery_tree", tree_data, _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.tree_selected, _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.tree_expanded, 16, 0, _M0MP49LING7167111moon_2degui3src4math4Vec23new(ui.available_width, 290));
  _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.tree_expanded = tree_resp.expanded_ids;
  const _bind = tree_resp.selected_id;
  if (_bind === undefined) {
    return;
  } else {
    const _Some = _bind;
    const _sid = _Some;
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.tree_selected = _sid;
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = `Selected: ${_sid}`;
    return;
  }
}
function _M0FP49LING7167111moon_2degui8examples6canvas22draw__window__showcase(ui, vp_w, vp_h) {
  _M0MP49LING7167111moon_2degui3src4core9UIContext14label__colored(ui, "浮动视窗与拖拽吸附 (Floating Window)", _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary());
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 6);
  _M0MP49LING7167111moon_2degui3src4core9UIContext5label(ui, "按住标题栏可在 Canvas 画布内任意拖动，具有层级抬升与边界约束。");
  const win_pos = _M0MP49LING7167111moon_2degui3src4math4Vec23new(80, 80);
  const win_size = _M0MP49LING7167111moon_2degui3src4math4Vec23new(260, 180);
  _M0MP49LING7167111moon_2degui3src4core9UIContext6window(ui, "CAD 属性面板 (Window)", win_pos, win_size, (w) => {
    _M0MP49LING7167111moon_2degui3src4core9UIContext5label(w, "即时模式浮动视窗");
    _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(w, 4);
    const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext6slider(w, "缩放", _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.slider_zoom, 0.1, 5);
    const _z = _bind._0;
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.slider_zoom = _z;
    _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(w, 4);
    if (_M0MP49LING7167111moon_2degui3src4core9UIContext6button(w, "置中镜头", undefined, -1, undefined).clicked) {
      _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text = "Window Action: Recenter";
      return;
    } else {
      return;
    }
  }, _M0FP49LING7167111moon_2degui8examples6canvas22draw__window__showcaseN6constrS1082, _M0MP49LING7167111moon_2degui3src4math4Rect3new(0, 0, vp_w, vp_h));
}
function _M0FP49LING7167111moon_2degui8examples6canvas24draw__component__preview(ui, comp_id, cur_w, cur_h) {
  switch (comp_id) {
    case "button": {
      _M0FP49LING7167111moon_2degui8examples6canvas22draw__button__showcase(ui);
      return;
    }
    case "text_edit": {
      _M0FP49LING7167111moon_2degui8examples6canvas26draw__text__edit__showcase(ui);
      return;
    }
    case "code_editor": {
      _M0FP49LING7167111moon_2degui8examples6canvas28draw__code__editor__showcase(ui);
      return;
    }
    case "checkbox": {
      _M0FP49LING7167111moon_2degui8examples6canvas24draw__checkbox__showcase(ui);
      return;
    }
    case "toggle": {
      _M0FP49LING7167111moon_2degui8examples6canvas22draw__toggle__showcase(ui);
      return;
    }
    case "radio": {
      _M0FP49LING7167111moon_2degui8examples6canvas21draw__radio__showcase(ui);
      return;
    }
    case "slider": {
      _M0FP49LING7167111moon_2degui8examples6canvas22draw__slider__showcase(ui);
      return;
    }
    case "drag_value": {
      _M0FP49LING7167111moon_2degui8examples6canvas27draw__drag__value__showcase(ui);
      return;
    }
    case "knob": {
      _M0FP49LING7167111moon_2degui8examples6canvas20draw__knob__showcase(ui);
      return;
    }
    case "combo_box": {
      _M0FP49LING7167111moon_2degui8examples6canvas26draw__combo__box__showcase(ui);
      return;
    }
    case "color_button": {
      _M0FP49LING7167111moon_2degui8examples6canvas29draw__color__button__showcase(ui);
      return;
    }
    case "progress_bar": {
      _M0FP49LING7167111moon_2degui8examples6canvas29draw__progress__bar__showcase(ui);
      return;
    }
    case "collapsing_header": {
      _M0FP49LING7167111moon_2degui8examples6canvas34draw__collapsing__header__showcase(ui);
      return;
    }
    case "tree_view": {
      _M0FP49LING7167111moon_2degui8examples6canvas26draw__tree__view__showcase(ui);
      return;
    }
    case "tooltip": {
      _M0FP49LING7167111moon_2degui8examples6canvas23draw__tooltip__showcase(ui);
      return;
    }
    case "tab_bar": {
      _M0FP49LING7167111moon_2degui8examples6canvas24draw__tab__bar__showcase(ui);
      return;
    }
    case "menu_bar": {
      _M0FP49LING7167111moon_2degui8examples6canvas25draw__menu__bar__showcase(ui);
      return;
    }
    case "scroll_area": {
      _M0FP49LING7167111moon_2degui8examples6canvas28draw__scroll__area__showcase(ui);
      return;
    }
    case "window": {
      _M0FP49LING7167111moon_2degui8examples6canvas22draw__window__showcase(ui, cur_w, cur_h);
      return;
    }
    case "command_palette": {
      _M0FP49LING7167111moon_2degui8examples6canvas32draw__command__palette__showcase(ui);
      return;
    }
    case "context_menu": {
      _M0FP49LING7167111moon_2degui8examples6canvas29draw__context__menu__showcase(ui, cur_w, cur_h);
      return;
    }
    case "toast": {
      _M0FP49LING7167111moon_2degui8examples6canvas21draw__toast__showcase(ui, cur_w, cur_h);
      return;
    }
    case "splitter": {
      _M0FP49LING7167111moon_2degui8examples6canvas24draw__splitter__showcase(ui);
      return;
    }
    case "table": {
      _M0FP49LING7167111moon_2degui8examples6canvas21draw__table__showcase(ui);
      return;
    }
    case "dialog": {
      _M0FP49LING7167111moon_2degui8examples6canvas22draw__dialog__showcase(ui, cur_w, cur_h);
      return;
    }
    case "spinner": {
      _M0FP49LING7167111moon_2degui8examples6canvas23draw__spinner__showcase(ui);
      return;
    }
    case "sparkline": {
      _M0FP49LING7167111moon_2degui8examples6canvas25draw__sparkline__showcase(ui);
      return;
    }
    case "segmented_control": {
      _M0FP49LING7167111moon_2degui8examples6canvas34draw__segmented__control__showcase(ui);
      return;
    }
    case "badge": {
      _M0FP49LING7167111moon_2degui8examples6canvas21draw__badge__showcase(ui);
      return;
    }
    case "breadcrumb": {
      _M0FP49LING7167111moon_2degui8examples6canvas26draw__breadcrumb__showcase(ui);
      return;
    }
    case "color_picker": {
      _M0FP49LING7167111moon_2degui8examples6canvas29draw__color__picker__showcase(ui);
      return;
    }
    case "rich_text": {
      _M0FP49LING7167111moon_2degui8examples6canvas26draw__rich__text__showcase(ui);
      return;
    }
    default: {
      _M0MP49LING7167111moon_2degui3src4core9UIContext14label__colored(ui, `MoonBit 原生组件: ${comp_id}`, _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary());
      _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(ui, 10);
      _M0FP49LING7167111moon_2degui8examples6canvas22draw__button__showcase(ui);
      return;
    }
  }
}
function _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__info(comp_id) {
  switch (comp_id) {
    case "button": {
      return _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1083;
    }
    case "text_edit": {
      return _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1084;
    }
    case "code_editor": {
      return _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1085;
    }
    case "rich_text": {
      return _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1086;
    }
    case "checkbox": {
      return _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1087;
    }
    case "toggle": {
      return _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1088;
    }
    case "radio": {
      return _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1089;
    }
    case "segmented_control": {
      return _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1090;
    }
    case "slider": {
      return _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1091;
    }
    case "drag_value": {
      return _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1092;
    }
    case "knob": {
      return _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1093;
    }
    case "combo_box": {
      return _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1094;
    }
    case "color_button": {
      return _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1095;
    }
    case "color_picker": {
      return _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1096;
    }
    case "progress_bar": {
      return _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1097;
    }
    case "spinner": {
      return _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1098;
    }
    case "badge": {
      return _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1099;
    }
    case "sparkline": {
      return _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1100;
    }
    case "collapsing_header": {
      return _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1101;
    }
    case "tree_view": {
      return _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1102;
    }
    case "tooltip": {
      return _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1103;
    }
    case "splitter": {
      return _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1104;
    }
    case "table": {
      return _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1105;
    }
    case "tab_bar": {
      return _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1106;
    }
    case "menu_bar": {
      return _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1107;
    }
    case "scroll_area": {
      return _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1108;
    }
    case "breadcrumb": {
      return _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1109;
    }
    case "window": {
      return _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1110;
    }
    case "dialog": {
      return _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1111;
    }
    case "command_palette": {
      return _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1112;
    }
    case "context_menu": {
      return _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1113;
    }
    case "toast": {
      return _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__infoN5tupleS1114;
    }
    default: {
      return { _0: `MoonBit 基础组件: ${comp_id}`, _1: `ui.${comp_id}`, _2: "///| 默认组件代码\npub fn render(ui : @core.UIContext) -> Unit {\n  let _ = ui.button(\"操作按钮\")\n}" };
    }
  }
}
function _M0FP49LING7167111moon_2degui8examples6canvas21gallery__step_2einner(comp_id, mouse_x, mouse_y, mouse_down, scroll_dy, vp_w, vp_h, text_input, keys_pressed, keys_released, mod_flags, mouse_secondary_down) {
  const cur_w = vp_w > 100 ? vp_w : 800;
  const cur_h = vp_h > 100 ? vp_h : 500;
  let _tmp;
  if (_M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.theme_idx === 0) {
    const _p = _M0FP49LING7167111moon_2degui8examples6canvas12gallery__ctx.theme.name;
    const _p$2 = "studio_light";
    _tmp = !(_p === _p$2);
  } else {
    _tmp = false;
  }
  if (_tmp) {
    _M0MP49LING7167111moon_2degui3src4core9UIContext10set__theme(_M0FP49LING7167111moon_2degui8examples6canvas12gallery__ctx, _M0MP49LING7167111moon_2degui3src4core5Theme13studio__light());
  } else {
    let _tmp$2;
    if (_M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.theme_idx === 1) {
      const _p = _M0FP49LING7167111moon_2degui8examples6canvas12gallery__ctx.theme.name;
      const _p$2 = "slate_dark";
      _tmp$2 = !(_p === _p$2);
    } else {
      _tmp$2 = false;
    }
    if (_tmp$2) {
      _M0MP49LING7167111moon_2degui3src4core9UIContext10set__theme(_M0FP49LING7167111moon_2degui8examples6canvas12gallery__ctx, _M0MP49LING7167111moon_2degui3src4core5Theme11slate__dark());
    } else {
      let _tmp$3;
      if (_M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.theme_idx === 2) {
        const _p = _M0FP49LING7167111moon_2degui8examples6canvas12gallery__ctx.theme.name;
        const _p$2 = "high_contrast";
        _tmp$3 = !(_p === _p$2);
      } else {
        _tmp$3 = false;
      }
      if (_tmp$3) {
        _M0MP49LING7167111moon_2degui3src4core9UIContext10set__theme(_M0FP49LING7167111moon_2degui8examples6canvas12gallery__ctx, _M0MP49LING7167111moon_2degui3src4core5Theme14high__contrast());
      }
    }
  }
  const theme = _M0FP49LING7167111moon_2degui8examples6canvas12gallery__ctx.theme;
  const raw = _M0FP49LING7167111moon_2degui8examples6canvas24host__raw__input_2einner(mouse_x, mouse_y, mouse_down, text_input, keys_pressed, keys_released, mod_flags, scroll_dy, mouse_secondary_down);
  const _p = _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.active_comp_id;
  if (!(comp_id === _p)) {
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.active_comp_id = comp_id;
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.cmd_open = false;
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.ctx_menu_open = false;
    _M0MP49LING7167111moon_2degui3src4core9UIContext20set__open__combo__id(_M0FP49LING7167111moon_2degui8examples6canvas12gallery__ctx, _M0MP49LING7167111moon_2degui3src4core2Id4zeroN6recordS4226);
    _M0MP49LING7167111moon_2degui3src4core9UIContext19set__open__menu__id(_M0FP49LING7167111moon_2degui8examples6canvas12gallery__ctx, _M0MP49LING7167111moon_2degui3src4core2Id4zeroN6recordS4226);
  }
  _M0MP49LING7167111moon_2degui3src4core9UIContext12begin__frame(_M0FP49LING7167111moon_2degui8examples6canvas12gallery__ctx, raw);
  const dl = _M0FP49LING7167111moon_2degui8examples6canvas12gallery__ctx.draw_list;
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(dl, _M0MP49LING7167111moon_2degui3src4math4Rect3new(0, 0, cur_w, cur_h), theme.bg_app, 0);
  const header_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(0, 0, cur_w, 42);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(dl, header_rect, theme.bg_surface, 0);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(dl, _M0MP49LING7167111moon_2degui3src4math4Vec23new(0, 42), _M0MP49LING7167111moon_2degui3src4math4Vec23new(cur_w, 42), theme.border_muted, 1);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList11add__circle(dl, _M0MP49LING7167111moon_2degui3src4math4Vec23new(18, 21), 5, _M0MP49LING7167111moon_2degui3src5color5Color3hex(15680580));
  _M0MP49LING7167111moon_2degui3src4draw8DrawList11add__circle(dl, _M0MP49LING7167111moon_2degui3src4math4Vec23new(32, 21), 5, _M0MP49LING7167111moon_2degui3src5color5Color3hex(16096779));
  _M0MP49LING7167111moon_2degui3src4draw8DrawList11add__circle(dl, _M0MP49LING7167111moon_2degui3src4math4Vec23new(46, 21), 5, _M0MP49LING7167111moon_2degui3src5color5Color3hex(1096065));
  const _bind = _M0FP49LING7167111moon_2degui8examples6canvas29get__gallery__component__info(comp_id);
  const _comp_title = _bind._0;
  const _comp_sig = _bind._1;
  const _code_text = _bind._2;
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(dl, _M0MP49LING7167111moon_2degui3src4math4Vec23new(64, 14), _comp_title, 13.5, theme.text_strong);
  if (cur_w > 720) {
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(dl, _M0MP49LING7167111moon_2degui3src4math4Vec23new(210, 15), _comp_sig, 11.5, theme.text_muted);
  }
  if (cur_w > 580) {
    const tm_x = cur_w - 170;
    _M0MP49LING7167111moon_2degui3src4core9UIContext11set__cursor(_M0FP49LING7167111moon_2degui8examples6canvas12gallery__ctx, _M0MP49LING7167111moon_2degui3src4math4Vec23new(tm_x, 5));
    const _bind$2 = _M0MP49LING7167111moon_2degui3src4core9UIContext26segmented__control_2einner(_M0FP49LING7167111moon_2degui8examples6canvas12gallery__ctx, "studio_theme_seg", ["浅色", "深色", "对比"], _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.theme_idx, 0, 0);
    const _new_tm = _bind$2._0;
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.theme_idx = _new_tm;
    const vm_x = tm_x - 170;
    _M0MP49LING7167111moon_2degui3src4core9UIContext11set__cursor(_M0FP49LING7167111moon_2degui8examples6canvas12gallery__ctx, _M0MP49LING7167111moon_2degui3src4math4Vec23new(vm_x, 5));
    const _bind$3 = _M0MP49LING7167111moon_2degui3src4core9UIContext26segmented__control_2einner(_M0FP49LING7167111moon_2degui8examples6canvas12gallery__ctx, "studio_view_seg", ["UI", "50/50", "代码"], _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.view_mode, 0, 0);
    const _new_vm = _bind$3._0;
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.view_mode = _new_vm;
  }
  const body_h = cur_h - 42 - 30;
  if (_M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.view_mode === 0) {
    const pad_x = cur_w > 560 ? 24 : 12;
    const card_w = cur_w - pad_x * 2;
    const card_h = body_h - 32;
    const card_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(pad_x, 58, card_w, card_h);
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(dl, _M0MP49LING7167111moon_2degui3src4math4Rect3new(pad_x, 60, card_w, card_h), _M0MP49LING7167111moon_2degui3src5color5Color6shadow(), 8);
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(dl, card_rect, theme.bg_window, 8);
    _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(dl, card_rect, theme.border_default, 1, 8);
    _M0MP49LING7167111moon_2degui3src4core9UIContext11set__cursor(_M0FP49LING7167111moon_2degui8examples6canvas12gallery__ctx, _M0MP49LING7167111moon_2degui3src4math4Vec23new(pad_x + 18, 74));
    _M0MP49LING7167111moon_2degui3src4core9UIContext21set__available__width(_M0FP49LING7167111moon_2degui8examples6canvas12gallery__ctx, card_w - 36);
    _M0FP49LING7167111moon_2degui8examples6canvas24draw__component__preview(_M0FP49LING7167111moon_2degui8examples6canvas12gallery__ctx, comp_id, card_w, card_h);
  } else {
    if (_M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.view_mode === 2) {
      const pad_x = cur_w > 560 ? 24 : 12;
      const code_w = cur_w - pad_x * 2;
      const code_h = body_h - 32;
      _M0MP49LING7167111moon_2degui3src4core9UIContext11set__cursor(_M0FP49LING7167111moon_2degui8examples6canvas12gallery__ctx, _M0MP49LING7167111moon_2degui3src4math4Vec23new(pad_x, 58));
      _M0MP49LING7167111moon_2degui3src4core9UIContext20code__editor_2einner(_M0FP49LING7167111moon_2degui8examples6canvas12gallery__ctx, "studio_code_editor_full", _code_text, _M0MP49LING7167111moon_2degui3src4math4Vec23new(code_w, code_h), true, true);
    } else {
      _M0MP49LING7167111moon_2degui3src4core9UIContext11set__cursor(_M0FP49LING7167111moon_2degui8examples6canvas12gallery__ctx, _M0MP49LING7167111moon_2degui3src4math4Vec23new(0, 42));
      const split_size = _M0MP49LING7167111moon_2degui3src4math4Vec23new(cur_w, body_h);
      const new_ratio = _M0MP49LING7167111moon_2degui3src4core9UIContext25split__horizontal_2einner(_M0FP49LING7167111moon_2degui8examples6canvas12gallery__ctx, "studio_curtain_split", _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.curtain_ratio, split_size, (ui_left, left_rect) => {
        const preview_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(left_rect.x + 12, left_rect.y + 12, left_rect.w - 24, left_rect.h - 24);
        _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(ui_left.draw_list, preview_rect, theme.bg_window, 8);
        _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(ui_left.draw_list, preview_rect, theme.border_default, 1, 8);
        _M0MP49LING7167111moon_2degui3src4core9UIContext11set__cursor(ui_left, _M0MP49LING7167111moon_2degui3src4math4Vec23new(preview_rect.x + 16, preview_rect.y + 16));
        _M0MP49LING7167111moon_2degui3src4core9UIContext21set__available__width(ui_left, preview_rect.w - 32);
        _M0FP49LING7167111moon_2degui8examples6canvas24draw__component__preview(ui_left, comp_id, preview_rect.w, preview_rect.h);
      }, (ui_right, right_rect) => {
        const code_w = right_rect.w - 24;
        const code_h = right_rect.h - 24;
        _M0MP49LING7167111moon_2degui3src4core9UIContext11set__cursor(ui_right, _M0MP49LING7167111moon_2degui3src4math4Vec23new(right_rect.x + 12, right_rect.y + 12));
        _M0MP49LING7167111moon_2degui3src4core9UIContext20code__editor_2einner(ui_right, "studio_code_editor_split", _code_text, _M0MP49LING7167111moon_2degui3src4math4Vec23new(code_w, code_h), true, true);
      }, 0.15, 0.85, 180);
      _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.curtain_ratio = new_ratio;
    }
  }
  const footer_y = cur_h - 30;
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(dl, _M0MP49LING7167111moon_2degui3src4math4Rect3new(0, footer_y, cur_w, 30), theme.bg_surface, 0);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(dl, _M0MP49LING7167111moon_2degui3src4math4Vec23new(0, footer_y), _M0MP49LING7167111moon_2degui3src4math4Vec23new(cur_w, footer_y), theme.border_muted, 1);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(dl, _M0MP49LING7167111moon_2degui3src4math4Vec23new(16, footer_y + 8), `状态响应: ${_M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text}`, 11.5, theme.text_secondary);
  const code_pct = _M0MPC16double6Double7to__int(_M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.curtain_ratio * 100);
  const ui_pct = 100 - code_pct | 0;
  const ratio_str = _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.view_mode === 0 ? "视图: 纯 UI (0%)" : _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.view_mode === 2 ? "视图: 源码 (100%)" : `视图: 50/50 对比 (代码 ${_M0MPC13int3Int18to__string_2einner(code_pct, 10)}% | UI ${_M0MPC13int3Int18to__string_2einner(ui_pct, 10)}%)`;
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(dl, _M0MP49LING7167111moon_2degui3src4math4Vec23new(cur_w * 0.5 - 75, footer_y + 8), ratio_str, 11.5, theme.text_muted);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(dl, _M0MP49LING7167111moon_2degui3src4math4Vec23new(cur_w - 180, footer_y + 8), "内核刷新率: 60 FPS (Wasm-GC)", 11.5, theme.text_muted);
  return _M0MP49LING7167111moon_2degui3src4core9UIContext10end__frame(_M0FP49LING7167111moon_2degui8examples6canvas12gallery__ctx);
}
function _M0FP49LING7167111moon_2degui8examples6canvas20get__gallery__cursor() {
  return _M0FP49LING7167111moon_2degui8examples6canvas12gallery__ctx.cursor_icon;
}
function _M0FP49LING7167111moon_2degui8examples6canvas20get__gallery__status() {
  const s = _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.status_text;
  return s === "" ? "Ready" : s;
}
function _M0FP49LING7167111moon_2degui8examples6canvas19set__gallery__theme(theme_idx) {
  if (theme_idx >= 0 && theme_idx <= 2) {
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.theme_idx = theme_idx;
    return;
  } else {
    return;
  }
}
function _M0FP49LING7167111moon_2degui8examples6canvas24set__gallery__view__mode(mode) {
  if (mode >= 0 && mode <= 2) {
    _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.view_mode = mode;
    return;
  } else {
    return;
  }
}
(() => {
  const frame = _M0FP49LING7167111moon_2degui8examples6canvas4step(580, 270, false, 0, 0, 1, -1, 920, 540, "", [], [], 0);
  _M0FP49LING7167111moon_2degui8examples6canvas21gallery__step_2einner("knob", 0, 0, false, 0, 800, 600, "", [], [], 0, false);
  _M0FP49LING7167111moon_2degui8examples6canvas20get__gallery__status();
  _M0FP49LING7167111moon_2degui8examples6canvas20get__gallery__cursor();
  _M0FP49LING7167111moon_2degui8examples6canvas24set__gallery__view__mode(1);
  _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.view_mode;
  _M0FP49LING7167111moon_2degui8examples6canvas19set__gallery__theme(1);
  _M0FP49LING7167111moon_2degui8examples6canvas14gallery__state.theme_idx;
  const _string_builder = _M0MPB13StringBuilder21StringBuilder_2einner(47);
  _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, "Benchmark initialized, total commands: ");
  const _p = frame.draw_list;
  _M0MPB13StringBuilder13write__objectGiE(_string_builder, _p.commands.length);
  _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", zoom: ");
  _M0MPB13StringBuilder13write__objectGdE(_string_builder, frame.zoom);
  _M0FPB7printlnGsE(_string_builder.val);
})();

if (typeof window !== 'undefined') window.moon_step = _M0FP49LING7167111moon_2degui8examples6canvas4step;
if (typeof globalThis !== 'undefined') globalThis.moon_step = _M0FP49LING7167111moon_2degui8examples6canvas4step;
if (typeof window !== 'undefined') window.moon_gallery_step = _M0FP49LING7167111moon_2degui8examples6canvas21gallery__step_2einner;
if (typeof globalThis !== 'undefined') globalThis.moon_gallery_step = _M0FP49LING7167111moon_2degui8examples6canvas21gallery__step_2einner;
if (typeof window !== 'undefined') window.moon_gallery_status = _M0FP49LING7167111moon_2degui8examples6canvas20get__gallery__status;
if (typeof globalThis !== 'undefined') globalThis.moon_gallery_status = _M0FP49LING7167111moon_2degui8examples6canvas20get__gallery__status;
if (typeof window !== 'undefined') window.moon_gallery_cursor = _M0FP49LING7167111moon_2degui8examples6canvas20get__gallery__cursor;
if (typeof globalThis !== 'undefined') globalThis.moon_gallery_cursor = _M0FP49LING7167111moon_2degui8examples6canvas20get__gallery__cursor;
if (typeof window !== 'undefined') window.moon_set_gallery_view_mode = _M0FP49LING7167111moon_2degui8examples6canvas24set__gallery__view__mode;
if (typeof globalThis !== 'undefined') globalThis.moon_set_gallery_view_mode = _M0FP49LING7167111moon_2degui8examples6canvas24set__gallery__view__mode;
if (typeof window !== 'undefined') window.moon_set_gallery_theme = _M0FP49LING7167111moon_2degui8examples6canvas19set__gallery__theme;
if (typeof globalThis !== 'undefined') globalThis.moon_set_gallery_theme = _M0FP49LING7167111moon_2degui8examples6canvas19set__gallery__theme;
