function _M0TP49LING7167111moon_2degui8examples6canvas14BenchmarkState(param0, param1, param2, param3, param4, param5, param6, param7, param8, param9, param10, param11) {
  this.grid_dim = param0;
  this.click_count = param1;
  this.magnetic_repel = param2;
  this.wave_pulse = param3;
  this.frame_tick = param4;
  this.selected_id = param5;
  this.selected_col = param6;
  this.selected_row = param7;
  this.ripple_cx = param8;
  this.ripple_cy = param9;
  this.ripple_active = param10;
  this.ripple_progress = param11;
}
function _M0TPB13StringBuilder(param0) {
  this.val = param0;
}
class $PanicError extends Error {}
function $panic() {
  throw new $PanicError();
}
function _M0TPC16string10StringView(param0, param1, param2) {
  this.str = param0;
  this.start = param1;
  this.end = param2;
}
const _M0FPB19int__to__string__js = (x, radix) => {
  return x.toString(radix);
};
function $oob() {
  throw new Error("Index out of bounds");
}
const _M0MPB7JSArray4push = (arr, val) => { arr.push(val); };
const _M0MPB7JSArray11set__length = (arr, len) => { arr.length = len; };
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
function _M0TP49LING7167111moon_2degui3src4core2Id(param0) {
  this.val = param0;
}
function _M0TPB8MutLocalGmE(param0) {
  this.val = param0;
}
function _M0TP49LING7167111moon_2degui3src4core8Response(param0, param1, param2, param3, param4, param5) {
  this.id = param0;
  this.rect = param1;
  this.hovered = param2;
  this.clicked = param3;
  this.pressed = param4;
  this.dragged = param5;
}
function _M0TP49LING7167111moon_2degui3src4core8RawInput(param0, param1, param2, param3) {
  this.mouse_pos = param0;
  this.mouse_down = param1;
  this.scroll_delta = param2;
  this.dt = param3;
}
function _M0TP49LING7167111moon_2degui3src4core10InputState(param0, param1, param2, param3, param4, param5, param6, param7) {
  this.mouse_pos = param0;
  this.mouse_prev_pos = param1;
  this.mouse_delta = param2;
  this.mouse_down = param3;
  this.mouse_pressed = param4;
  this.mouse_released = param5;
  this.scroll_delta = param6;
  this.dt = param7;
}
function _M0TP49LING7167111moon_2degui3src4core7IdStack(param0) {
  this.stack = param0;
}
function _M0TP49LING7167111moon_2degui3src4core9UIContext(param0, param1, param2, param3, param4, param5, param6, param7, param8, param9, param10) {
  this.input = param0;
  this.draw_list = param1;
  this.id_stack = param2;
  this.hot_id = param3;
  this.active_id = param4;
  this.focused_id = param5;
  this.cursor = param6;
  this.available_width = param7;
  this.item_spacing = param8;
  this.clip_stack = param9;
  this.auto_id_counter = param10;
}
function _M0TPB8MutLocalGiE(param0) {
  this.val = param0;
}
function _M0TPB8MutLocalGdE(param0) {
  this.val = param0;
}
function _M0TPB8MutLocalGbE(param0) {
  this.val = param0;
}
const _M0FP092moonbitlang_2fcore_2fbuiltin_2fStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger = { method_0: _M0IPB13StringBuilderPB6Logger13write__string, method_1: _M0IP016_24default__implPB6Logger16write__substringGRPB13StringBuilderE, method_2: _M0IPB13StringBuilderPB6Logger11write__view, method_3: _M0IPB13StringBuilderPB6Logger11write__char, method_4: _M0IP016_24default__implPB6Logger28write__string__interpolationGRPB13StringBuilderE, method_5: _M0IP016_24default__implPB6Logger5writeGRPB13StringBuilderE };
const _M0FP49LING7167111moon_2degui8examples6canvas5state = new _M0TP49LING7167111moon_2degui8examples6canvas14BenchmarkState(32, 0, true, false, 0, -1, -1, -1, 580, 270, false, 0);
const _M0FP49LING7167111moon_2degui8examples6canvas14logo__grid__12 = [0, 0, 0, 28844929, 29172868, 0, 0, 29238662, 28779649, 0, 0, 0, 0, 0, 28845186, 29566601, 29894541, 28910721, 28845185, 29960077, 29501064, 28910722, 0, 0, 0, 0, 28844929, 30091407, 29829004, 28910465, 28976258, 29763467, 30156943, 28976002, 0, 0, 0, 0, 28845184, 28910465, 29042052, 28911233, 28910722, 29042051, 29041539, 28844930, 0, 0, 0, 0, 0, 0, 28580733, 28778110, 28778110, 28646011, 0, 0, 0, 0, 0, 0, 0, 0, 29439630, 29373324, 29438604, 29439630, 0, 0, 0, 0, 0, 0, 0, 30767795, 33545205, 33024498, 33157110, 33546487, 30834870, 0, 0, 0, 0, 0, 0, 30171557, 32815838, 31299523, 31432135, 32816095, 30238376, 0, 0, 0, 0, 0, 0, 27197510, 29108873, 28776829, 28776829, 29240458, 0, 0, 0, 0, 0, 0, 0, 30736383, 28942801, 29370247, 29370247, 29928918, 29555967, 0, 0, 0, 0, 0, 29217007, 30799359, 28999869, 28848266, 28980622, 28864177, 29289471, 29940466, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 30205432, 0, 0];
const _M0FP49LING7167111moon_2degui8examples6canvas14logo__grid__20 = [0, 0, 0, 0, 0, 28648319, 29369735, 29172869, 28713343, 0, 0, 28975748, 29173125, 29304198, 28648320, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28910207, 29172869, 29041795, 29829004, 28845186, 0, 0, 28910721, 29763211, 29107332, 29107332, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28976001, 29829004, 28844929, 29173124, 28910465, 0, 0, 28845185, 29107588, 28844929, 29829004, 28910465, 0, 0, 0, 0, 0, 0, 0, 0, 28910465, 29304198, 28845186, 28976259, 28910723, 0, 0, 28976259, 28910722, 28845186, 29369735, 28844930, 0, 0, 0, 0, 0, 0, 0, 0, 28845185, 29501064, 29173125, 28910721, 29566601, 29107076, 29042307, 29632138, 28845185, 29173125, 29501065, 28910465, 0, 0, 0, 0, 0, 0, 0, 0, 28844930, 28910722, 28844930, 29501064, 29763467, 28845185, 28779392, 29829004, 29435528, 28845185, 28976258, 28910466, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28976259, 30288017, 28845186, 28910465, 30353553, 28910722, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28845443, 30550676, 28910977, 28910978, 30485139, 28911235, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28381300, 29106307, 28909697, 28909696, 29106307, 28381558, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28249972, 29701007, 29374093, 29373324, 29373068, 29373836, 29635214, 28446582, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 27985771, 31754434, 33021422, 32758506, 33024498, 33090547, 32825068, 33154289, 31887303, 28052333, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28910466, 33552127, 32427490, 32028373, 33554431, 33554431, 32160985, 32493539, 33553919, 29109127, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28447352, 32151244, 33024242, 31962068, 31431365, 31630282, 32094679, 33155827, 32349904, 28578936, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28779394, 29040514, 29767312, 28844672, 28644986, 28579193, 28778879, 29832849, 29040770, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28574826, 29174666, 29108359, 28911235, 28911235, 29174408, 29240459, 28508258, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29223167, 28694773, 28984728, 28975488, 28975232, 28985241, 30928636, 30667007, 28624876, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28759024, 31057654, 30667519, 28674499, 28846212, 29173381, 29173125, 28846213, 29724100, 29288701, 28561392, 28168435, 0, 0, 0, 0, 0, 0, 0, 0, 28891381, 31517432, 30207999, 28675269, 29237379, 28851088, 28851088, 29500551, 28604602, 28305919, 29546481, 30335991, 0, 0, 0, 0, 0, 0, 0, 0, 28759024, 29285622, 28758769, 28966911, 28862125, 28688101, 28821992, 28730538, 28770303, 28626927, 29547766, 30926841, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
const _M0FP49LING7167111moon_2degui8examples6canvas14logo__grid__32 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 29041538, 29172868, 29173125, 28844931, 0, 0, 0, 0, 0, 0, 29042051, 29173125, 29238661, 28910722, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28779393, 29960077, 28976259, 28910722, 30025614, 28845186, 0, 0, 0, 0, 28779393, 30025614, 28845186, 29041795, 29894540, 28779393, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28910721, 29829004, 28844930, 28845185, 28910722, 29107333, 28845186, 0, 0, 0, 0, 28976259, 29041795, 28845185, 28845185, 28910723, 29632138, 28779395, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28844928, 29501064, 28910721, 28910722, 28910722, 28845186, 29435272, 28713601, 0, 0, 28910209, 29566601, 28845185, 28910722, 28910722, 28845185, 29566601, 28844928, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29041282, 29107332, 28845186, 28910722, 28910722, 28910722, 28844930, 29697675, 28844931, 0, 0, 28844929, 29763467, 28844930, 28910722, 28910722, 28910722, 28976258, 28976258, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28910721, 29763467, 28844930, 28910722, 28910722, 28910722, 28844930, 29763467, 28910722, 0, 0, 28779649, 29763467, 28844930, 28910722, 28910722, 28910722, 28844929, 29697674, 28714114, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28910721, 29763467, 28844930, 28910722, 28845185, 28910722, 28845186, 29632138, 28845186, 0, 0, 28845185, 29566601, 28910721, 28910722, 28845185, 28910722, 28844930, 29763467, 28844930, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28910465, 29697675, 28910466, 29304198, 29107588, 28845186, 28845186, 29435271, 28910722, 0, 0, 28910465, 29304198, 28910722, 28845185, 29107588, 29304198, 28910465, 29697931, 28844929, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28910722, 30156943, 30025614, 28845186, 28910722, 29697674, 28844930, 29173125, 28910466, 0, 0, 28845185, 29041796, 28844930, 29763211, 28910466, 28910466, 30025870, 30091407, 28779649, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29107333, 29500808, 29107075, 0, 29042305, 29369735, 28910722, 28910722, 29041795, 0, 28910213, 29304198, 28910722, 28976259, 29238662, 28845695, 0, 29041795, 29238406, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28713856, 29632138, 28844930, 29697674, 28779393, 28910209, 29829004, 28910465, 29697675, 28779392, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29042305, 29304198, 28844929, 29960077, 28910722, 28844929, 29960077, 28844930, 29172869, 28976514, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28779392, 29435528, 29829004, 28845185, 28779649, 29763467, 29501065, 28779393, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28780933, 29304455, 29304455, 28910978, 28910979, 29304455, 29173126, 28911751, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29172355, 29106563, 28844161, 28778623, 29106563, 29106563, 28778623, 28909697, 29106307, 29106820, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28776316, 30025870, 29503885, 29175945, 29176201, 29176202, 29110665, 29176202, 29175688, 29503884, 30026127, 28775803, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28513400, 31418804, 32957167, 33223415, 33288952, 33288952, 33222389, 33222390, 33222902, 33355257, 33289465, 33023472, 31683514, 28447865, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29440143, 33553405, 33288695, 32028374, 32692200, 32692200, 33554431, 33554431, 33488125, 32492770, 32360671, 33553661, 33554431, 29639572, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 27918440, 30761386, 33554431, 32426720, 31365060, 31962324, 31962580, 33554431, 33554174, 32293852, 31564490, 31829456, 31896275, 33554431, 31092402, 27787369, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28579196, 29898643, 33355514, 33487869, 32493283, 33089778, 32493026, 33488382, 33488382, 33554431, 32890861, 32625895, 33554431, 33553661, 30163353, 28578424, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28777341, 30104224, 32625638, 32691944, 31166143, 30237349, 29574292, 29574549, 30104738, 31232192, 32625638, 32626407, 30303142, 28842621, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28911236, 29826696, 28712830, 28778367, 28512888, 28645243, 28777854, 28777598, 28645499, 28512888, 28778111, 28778624, 29826441, 28910979, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29108871, 29959820, 28844672, 28977284, 28976771, 28976771, 28976771, 28977027, 28977284, 28909952, 29959821, 29174663, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29174922, 29174922, 28910209, 28845442, 28910722, 28910722, 28910722, 28976003, 29373069, 29175177, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28694775, 28698109, 28757486, 28856477, 29105535, 28845699, 28845699, 29105535, 28790942, 30269942, 31193599, 30861560, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29548536, 30598648, 29546995, 28696313, 28877266, 28912262, 28913032, 28910466, 28976001, 28913288, 28714372, 30059219, 31454463, 30334964, 28694003, 28890868, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28825331, 30729975, 31649529, 30860790, 28696828, 28851345, 28913545, 28914315, 29041282, 29041282, 28848522, 28848265, 29047696, 29747451, 28824819, 28759540, 28693747, 28693490, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28891126, 29087989, 31583994, 31977722, 30664953, 28627441, 28849035, 29042308, 28845185, 28910979, 28910979, 28844929, 29042821, 28847239, 28493547, 28760821, 28627697, 29153780, 29482229, 28430833, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28890614, 28496626, 30796024, 31190010, 29087475, 28696826, 28873158, 29172869, 28845700, 28741318, 28874187, 28846212, 29303685, 28871875, 28829951, 28890098, 28431091, 30204664, 32240635, 29416180, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28693490, 28760309, 28562672, 28628724, 28628724, 28954865, 28901375, 28798383, 28799668, 28770303, 28770303, 28865717, 28732335, 28637695, 28758513, 28891637, 28628982, 29350644, 31452410, 29481203, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
const _M0FP49LING7167111moon_2degui8examples6canvas14logo__grid__40 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28451711, 29238407, 29107588, 29238405, 28976259, 0, 0, 0, 0, 0, 0, 0, 0, 29107331, 29238660, 29172868, 29238661, 28450687, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28713599, 29369734, 29501064, 28910722, 29041795, 29960077, 28779649, 0, 0, 0, 0, 0, 0, 28779393, 29960077, 28976259, 28976258, 29566601, 29238662, 28845442, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29107332, 29435527, 28779393, 28910722, 28845185, 28844930, 29697674, 28975745, 0, 0, 0, 0, 28910722, 29894541, 28844929, 28845186, 28910722, 28779393, 29566601, 28976002, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28844930, 29829004, 28844929, 28910722, 28910722, 28910722, 28844930, 29697674, 28910465, 0, 0, 0, 0, 28910721, 29632138, 28845186, 28910722, 28910722, 28910722, 28844929, 29894540, 28910466, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29041795, 29041795, 28845186, 28910722, 28910722, 28910722, 28845186, 29369735, 28844929, 0, 0, 0, 0, 28844929, 29238662, 28910722, 28910722, 28910722, 28910722, 28845185, 29107588, 28844930, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28845187, 29763467, 28844930, 28910722, 28910722, 28910722, 28910722, 28845185, 29173125, 28844929, 0, 0, 0, 0, 28910722, 29041795, 28845186, 28910722, 28910722, 28910722, 28910722, 28844929, 29632138, 28976002, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28910721, 29632138, 28844930, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28910723, 0, 0, 0, 28910977, 29238661, 28845185, 28910722, 28910722, 28910722, 28910722, 28910722, 28844930, 29697931, 28844930, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28910722, 29304198, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845186, 29501064, 28779393, 0, 0, 28779136, 29632138, 28845186, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 29435528, 28910722, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28910722, 29107588, 28845185, 28845186, 28910722, 28910722, 28910722, 28910722, 28844930, 29763467, 28910467, 0, 0, 28845185, 29763467, 28844930, 28910722, 28910722, 28910722, 28910722, 28845186, 28910722, 29238662, 28845186, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28845185, 29107588, 28779649, 28976259, 29304198, 28910722, 28910722, 28910722, 28844930, 29763467, 28844930, 0, 0, 28844929, 29697675, 28844930, 28910722, 28910722, 28910722, 29304198, 28976259, 28910721, 29238661, 28844929, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28910721, 29107333, 29304198, 28910721, 28910721, 28976259, 28910722, 28910722, 28910721, 29632138, 28845185, 0, 0, 28910722, 29501064, 28910722, 28910722, 29041795, 28910465, 28845184, 28910466, 29107588, 29369735, 28910721, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28910465, 30550420, 29238661, 28844931, 0, 28779649, 29632138, 28844929, 28845186, 29369735, 28844929, 0, 0, 28910466, 29238661, 28845185, 28844930, 29697675, 28910466, 0, 28844928, 29238662, 30550419, 28910722, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29894540, 0, 0, 0, 28975743, 29238661, 28910722, 28845185, 29107588, 28910466, 0, 0, 28910466, 28976259, 28845185, 28976259, 29107333, 0, 0, 0, 28386172, 29566857, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28714112, 29632138, 28844930, 28910722, 29173125, 0, 28648063, 29435528, 28910722, 28844930, 29763467, 28779393, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28910466, 29238662, 28910722, 28910721, 29763467, 28910979, 28779906, 29894540, 28844930, 29041795, 29173124, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28779392, 29763467, 28845186, 30025614, 28844930, 28910465, 30025614, 28845186, 29829004, 28845185, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29238661, 28910723, 29763467, 28844930, 28844929, 29697931, 28976259, 29173124, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29304968, 29042052, 29107845, 28910978, 28910978, 28910978, 28910978, 29173381, 28976259, 29435782, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28978566, 29238149, 29696905, 28975490, 28778624, 28844416, 28844416, 28844416, 28844416, 28778624, 29041026, 29696905, 29238149, 29043846, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28845184, 29497988, 29238918, 29044359, 29110409, 29175688, 29176201, 29176201, 29176201, 29176201, 29176201, 29110152, 29110153, 29304967, 29563268, 28714113, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28780419, 29367940, 30966199, 32759788, 33421563, 33222902, 33355770, 33222646, 33222389, 33222389, 33156853, 33156597, 33355514, 33288951, 32825324, 31231166, 29433990, 28844929, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28447096, 31290807, 33554431, 33554175, 32293853, 33421819, 32691944, 33488382, 33554431, 33554431, 33554431, 33554431, 32757993, 33090291, 33554431, 33554431, 31623105, 28447094, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28711804, 32558051, 33553919, 32293853, 31299010, 32360672, 31564233, 33089778, 33554174, 33488125, 33421819, 31431622, 32160985, 31564233, 32227547, 33553919, 32889835, 28779136, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29044104, 28843647, 32559076, 33488125, 32294366, 31299010, 32360415, 31431365, 32691687, 33554431, 33488382, 33355514, 30967482, 32492770, 31630539, 31896019, 33488125, 32825068, 29107588, 28909439, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29374351, 28644986, 31033275, 33554431, 33421820, 32293853, 33554175, 32493026, 33090034, 33554431, 33554175, 33554431, 33554431, 32559589, 32758250, 33554431, 33554431, 31365829, 28710523, 29308043, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28844929, 29172356, 31498184, 33355770, 33554174, 32160985, 31100094, 30171044, 29640854, 29706647, 30104481, 30900920, 32293853, 33421563, 33355514, 31763407, 29304455, 28779137, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28845442, 29959821, 28579706, 29440911, 29309069, 28645242, 28512888, 28645499, 28712061, 28712061, 28645755, 28578937, 28579193, 29308556, 29441681, 28579962, 29959564, 28976771, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29041795, 29763980, 28712574, 28778367, 28977028, 28977284, 28976771, 28976771, 28976771, 28977027, 28977284, 28977028, 28778624, 28712574, 29960590, 28976516, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29239175, 29894540, 28910465, 28845442, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 28845442, 28975489, 29829004, 29173894, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29175178, 29175691, 29039999, 28910722, 28910722, 28910722, 28910722, 28910722, 28910722, 29040768, 29374095, 29110154, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28760565, 28698365, 28757487, 28869055, 28910466, 28910722, 28910722, 28910722, 28910722, 28910465, 28936899, 30533369, 31127551, 30796024, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29744886, 29679094, 28759282, 28758769, 28827385, 28856734, 28975745, 28845956, 28910722, 28910722, 28911492, 28975745, 28854682, 30730746, 31123704, 31255289, 29679350, 28628468, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 30007799, 31123961, 31452665, 29546995, 28633087, 28867258, 29366398, 28854168, 28911492, 28910466, 28910722, 28911236, 28854424, 29169020, 29655483, 31194367, 30006515, 28759539, 28825332, 28760052, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28825332, 31123960, 31517945, 31517945, 30270198, 28563958, 28981647, 28911749, 28851602, 29106562, 28845442, 28845442, 29106562, 28851345, 28912518, 28782986, 28892150, 28562674, 28759027, 28825333, 28759540, 28693747, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28694002, 28956404, 31583994, 31715322, 31911930, 29745143, 28627698, 28915084, 29106818, 28845442, 28910722, 28976515, 28976515, 28910722, 28845186, 29041795, 28913544, 28757228, 28825845, 28890355, 28759285, 29153524, 29679093, 28759285, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28759797, 28890868, 28562162, 30861048, 31977723, 30467064, 28693746, 28826358, 28815836, 28978055, 30220427, 28913802, 28744912, 28942803, 28848779, 30220427, 28977541, 28813781, 28827385, 28824819, 29087733, 28497139, 30401528, 32437757, 29941750, 28366324, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28759794, 28759794, 28956150, 28759794, 29153780, 28497139, 28759796, 28889071, 28704767, 28928942, 29636244, 28930996, 28704767, 28704767, 28867514, 29636244, 28730282, 28770303, 28889071, 28825587, 28891126, 28628211, 29679348, 32306427, 30598391, 28233201, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 28956409, 28627954, 28760818, 28759282, 0, 0, 0, 29022712, 28953325, 0, 0, 0, 28560103, 28560109, 0, 0, 0, 28823533, 29022712, 28759282, 28759282, 28627954, 28693489, 29547509, 29154034, 28563187, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
const _M0FP49LING7167111moon_2degui8examples6canvas3ctx = _M0MP49LING7167111moon_2degui3src4core9UIContext3new();
function _M0MPB13StringBuilder13write__objectGiE(self, obj) {
  _M0IP016_24default__implPB4Show6outputGiE(obj, { self: self, method_table: _M0FP092moonbitlang_2fcore_2fbuiltin_2fStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger });
}
function _M0MPB13StringBuilder21StringBuilder_2einner(size_hint) {
  return new _M0TPB13StringBuilder("");
}
function _M0MPB13StringBuilder10to__string(self) {
  return self.val;
}
function _M0IPB13StringBuilderPB6Logger11write__char(self, ch) {
  self.val = `${self.val}${String.fromCodePoint(ch)}`;
}
function _M0IPB13StringBuilderPB6Logger13write__string(self, str) {
  self.val = `${self.val}${str}`;
}
function _M0MPC16uint166UInt1623is__trailing__surrogate(self) {
  return self >= 56320 && self <= 57343;
}
function _M0MPC13int3Int10to__uint64(self) {
  return BigInt.asUintN(64, BigInt(self));
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
      if (!_M0MPC16uint166UInt1623is__trailing__surrogate(self.charCodeAt(start))) {
      } else {
        $panic();
      }
    }
    if (end$2 < len) {
      if (!_M0MPC16uint166UInt1623is__trailing__surrogate(self.charCodeAt(end$2))) {
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
function _M0MPC13int3Int18to__string_2einner(self, radix) {
  return _M0FPB19int__to__string__js(self, radix);
}
function _M0MPC16string10StringView9to__owned(self) {
  return self.str.substring(self.start, self.end);
}
function _M0IPB13StringBuilderPB6Logger11write__view(self, str) {
  self.val = `${self.val}${_M0MPC16string10StringView9to__owned(str)}`;
}
function _M0IPC16string6StringPB4Show10to__string(self) {
  return self;
}
function _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4draw7DrawCmdE(self, value) {
  _M0MPB7JSArray4push(self, value);
}
function _M0IPC13int3IntPB4Show10to__string(self) {
  return _M0MPC13int3Int18to__string_2einner(self, 10);
}
function _M0MPC16double6Double7to__int(self) {
  return self !== self ? 0 : self >= 2147483647 ? 2147483647 : self <= -2147483648 ? -2147483648 : self | 0;
}
function _M0FPB7printlnGsE(input) {
  console.log(_M0IPC16string6StringPB4Show10to__string(input));
}
function _M0MPC15array5Array28unsafe__truncate__to__lengthGRP49LING7167111moon_2degui3src4math4RectE(self, new_len) {
  _M0MPB7JSArray11set__length(self, new_len);
}
function _M0MPC15array5Array9is__emptyGmE(self) {
  return self.length === 0;
}
function _M0MPC15array5Array2atGiE(self, index) {
  const len = self.length;
  return index >= 0 && index < len ? self[index] : $panic();
}
function _M0MPC15array5Array2atGmE(self, index) {
  const len = self.length;
  return index >= 0 && index < len ? self[index] : $panic();
}
function _M0MPC15array5Array5clearGRP49LING7167111moon_2degui3src4math4RectE(self) {
  _M0MPC15array5Array28unsafe__truncate__to__lengthGRP49LING7167111moon_2degui3src4math4RectE(self, 0);
}
function _M0MP49LING7167111moon_2degui3src5color5Color3rgb(r, g, b) {
  return new _M0TP49LING7167111moon_2degui3src5color5Color(r, g, b, 255);
}
function _M0MP49LING7167111moon_2degui3src5color5Color3hex(code) {
  const r = code >> 16 & 255;
  const g = code >> 8 & 255;
  const b = code & 255;
  return new _M0TP49LING7167111moon_2degui3src5color5Color(r, g, b, 255);
}
function _M0MP49LING7167111moon_2degui3src5color5Color5white() {
  return new _M0TP49LING7167111moon_2degui3src5color5Color(255, 255, 255, 255);
}
function _M0MP49LING7167111moon_2degui3src5color5Color10bg__window() {
  return _M0MP49LING7167111moon_2degui3src5color5Color3hex(1710883);
}
function _M0MP49LING7167111moon_2degui3src5color5Color11bg__surface() {
  return _M0MP49LING7167111moon_2degui3src5color5Color3hex(2303280);
}
function _M0MP49LING7167111moon_2degui3src5color5Color9bg__hover() {
  return _M0MP49LING7167111moon_2degui3src5color5Color3hex(2961470);
}
function _M0MP49LING7167111moon_2degui3src5color5Color10bg__active() {
  return _M0MP49LING7167111moon_2degui3src5color5Color3hex(3751247);
}
function _M0MP49LING7167111moon_2degui3src5color5Color13border__muted() {
  return _M0MP49LING7167111moon_2degui3src5color5Color3hex(3027005);
}
function _M0MP49LING7167111moon_2degui3src5color5Color13text__primary() {
  return _M0MP49LING7167111moon_2degui3src5color5Color3hex(15658738);
}
function _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary() {
  return _M0MP49LING7167111moon_2degui3src5color5Color3hex(5142015);
}
function _M0MP49LING7167111moon_2degui3src5color5Color13accent__hover() {
  return _M0MP49LING7167111moon_2degui3src5color5Color3hex(6719999);
}
function _M0MP49LING7167111moon_2degui3src4math4Vec23new(x, y) {
  return new _M0TP49LING7167111moon_2degui3src4math4Vec2(x, y);
}
function _M0MP49LING7167111moon_2degui3src4math4Vec24zero() {
  return new _M0TP49LING7167111moon_2degui3src4math4Vec2(0, 0);
}
function _M0MP49LING7167111moon_2degui3src4math4Vec23add(self, other) {
  return new _M0TP49LING7167111moon_2degui3src4math4Vec2(self.x + other.x, self.y + other.y);
}
function _M0MP49LING7167111moon_2degui3src4math4Vec23sub(self, other) {
  return new _M0TP49LING7167111moon_2degui3src4math4Vec2(self.x - other.x, self.y - other.y);
}
function _M0MP49LING7167111moon_2degui3src4math4Vec210length__sq(self) {
  return self.x * self.x + self.y * self.y;
}
function _M0MP49LING7167111moon_2degui3src4math4Rect3new(x, y, w, h) {
  return new _M0TP49LING7167111moon_2degui3src4math4Rect(x, y, w, h);
}
function _M0MP49LING7167111moon_2degui3src4math4Rect8contains(self, pt) {
  return pt.x >= self.x && (pt.x <= self.x + self.w && (pt.y >= self.y && pt.y <= self.y + self.h));
}
function _M0MP49LING7167111moon_2degui3src4math4Rect6shrink(self, margin) {
  const w = self.w > margin * 2 ? self.w - margin * 2 : 0;
  const h = self.h > margin * 2 ? self.h - margin * 2 : 0;
  return new _M0TP49LING7167111moon_2degui3src4math4Rect(self.x + margin, self.y + margin, w, h);
}
function _M0MP49LING7167111moon_2degui3src4draw8DrawList3new() {
  return new _M0TP49LING7167111moon_2degui3src4draw8DrawList([]);
}
function _M0MP49LING7167111moon_2degui3src4draw8DrawList5clear(self) {
  _M0MPC15array5Array5clearGRP49LING7167111moon_2degui3src4math4RectE(self.commands);
}
function _M0MP49LING7167111moon_2degui3src4draw8DrawList3len(self) {
  return self.commands.length;
}
function _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self, rect, color, corner_radius) {
  _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4draw7DrawCmdE(self.commands, new _M0DTP49LING7167111moon_2degui3src4draw7DrawCmd4Rect(rect, color, corner_radius));
}
function _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(self, rect, color, stroke_width, corner_radius) {
  _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4draw7DrawCmdE(self.commands, new _M0DTP49LING7167111moon_2degui3src4draw7DrawCmd10RectStroke(rect, color, stroke_width, corner_radius));
}
function _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(self, start, end, color, stroke_width) {
  _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4draw7DrawCmdE(self.commands, new _M0DTP49LING7167111moon_2degui3src4draw7DrawCmd4Line(start, end, color, stroke_width));
}
function _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self, pos, text, font_size, color) {
  _M0MPC15array5Array4pushGRP49LING7167111moon_2degui3src4draw7DrawCmdE(self.commands, new _M0DTP49LING7167111moon_2degui3src4draw7DrawCmd4Text(pos, text, font_size, color));
}
function _M0IP49LING7167111moon_2degui3src4core2IdPB2Eq5equal(_x_155, _x_156) {
  return BigInt.asUintN(64, _x_155.val) === BigInt.asUintN(64, _x_156.val);
}
function _M0MP49LING7167111moon_2degui3src4core2Id4zero() {
  return new _M0TP49LING7167111moon_2degui3src4core2Id(0n);
}
function _M0MP49LING7167111moon_2degui3src4core2Id10with__seed(seed, str) {
  const hash = new _M0TPB8MutLocalGmE(seed);
  const prime = 1099511628211n;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < str.length) {
      const char_code = _M0MPC13int3Int10to__uint64(i >>> 0 < str.length ? str.charCodeAt(i) : $oob());
      hash.val = BigInt.asUintN(64, BigInt.asUintN(64, hash.val ^ char_code) * prime);
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return new _M0TP49LING7167111moon_2degui3src4core2Id(hash.val);
}
function _M0MP49LING7167111moon_2degui3src4core7IdStack13current__seed(self) {
  return _M0MPC15array5Array9is__emptyGmE(self.stack) ? 14695981039346656037n : _M0MPC15array5Array2atGmE(self.stack, self.stack.length - 1 | 0);
}
function _M0MP49LING7167111moon_2degui3src4core7IdStack10derive__id(self, str) {
  return _M0MP49LING7167111moon_2degui3src4core2Id10with__seed(_M0MP49LING7167111moon_2degui3src4core7IdStack13current__seed(self), str);
}
function _M0MP49LING7167111moon_2degui3src4core8Response3new(id, rect, hovered, clicked, pressed, dragged) {
  return new _M0TP49LING7167111moon_2degui3src4core8Response(id, rect, hovered, clicked, pressed, dragged);
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext15allocate__space(self, size) {
  self.auto_id_counter = self.auto_id_counter + 1 | 0;
  const id = _M0MP49LING7167111moon_2degui3src4core7IdStack10derive__id(self.id_stack, _M0MPC13int3Int18to__string_2einner(self.auto_id_counter, 10));
  const rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(self.cursor.x, self.cursor.y, size.x, size.y);
  self.cursor = _M0MP49LING7167111moon_2degui3src4math4Vec23new(self.cursor.x, self.cursor.y + size.y + self.item_spacing.y);
  const hovered = _M0MP49LING7167111moon_2degui3src4math4Rect8contains(rect, self.input.mouse_pos);
  if (hovered) {
    self.hot_id = id;
  }
  if (hovered && self.input.mouse_pressed) {
    self.active_id = id;
  }
  const is_active = _M0IP49LING7167111moon_2degui3src4core2IdPB2Eq5equal(self.active_id, id);
  const pressed = is_active && self.input.mouse_down;
  const clicked = is_active && (self.input.mouse_released && hovered);
  const dragged = is_active && (self.input.mouse_down && _M0MP49LING7167111moon_2degui3src4math4Vec210length__sq(self.input.mouse_delta) > 0);
  if (self.input.mouse_released && is_active) {
    self.active_id = _M0MP49LING7167111moon_2degui3src4core2Id4zero();
  }
  const response = _M0MP49LING7167111moon_2degui3src4core8Response3new(id, rect, hovered, clicked, pressed, dragged);
  return { _0: id, _1: rect, _2: response };
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext14label__colored(self, text, color) {
  const char_w = 8;
  const text_w = (text.length + 0) * char_w;
  const w = text_w > 20 ? text_w : 20;
  const h = 18;
  let rect;
  let _id;
  let resp;
  _L: {
    const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext15allocate__space(self, _M0MP49LING7167111moon_2degui3src4math4Vec23new(w, h));
    const __id = _bind._0;
    const _rect = _bind._1;
    const _resp = _bind._2;
    rect = _rect;
    _id = __id;
    resp = _resp;
    break _L;
  }
  const text_pos = _M0MP49LING7167111moon_2degui3src4math4Vec23new(rect.x, rect.y + 2);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, text_pos, text, 14, color);
  return resp;
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext5label(self, text) {
  return _M0MP49LING7167111moon_2degui3src4core9UIContext14label__colored(self, text, _M0MP49LING7167111moon_2degui3src5color5Color13text__primary());
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext6button(self, text) {
  const char_w = 8;
  const text_w = (text.length + 0) * char_w;
  const w = text_w + 28 > 64 ? text_w + 28 : 64;
  const h = 32;
  let rect;
  let _id;
  let resp;
  _L: {
    const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext15allocate__space(self, _M0MP49LING7167111moon_2degui3src4math4Vec23new(w, h));
    const __id = _bind._0;
    const _rect = _bind._1;
    const _resp = _bind._2;
    rect = _rect;
    _id = __id;
    resp = _resp;
    break _L;
  }
  const bg_color = resp.pressed ? _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary() : resp.hovered ? _M0MP49LING7167111moon_2degui3src5color5Color9bg__hover() : _M0MP49LING7167111moon_2degui3src5color5Color11bg__surface();
  const border_color = resp.pressed ? _M0MP49LING7167111moon_2degui3src5color5Color13accent__hover() : resp.hovered ? _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary() : _M0MP49LING7167111moon_2degui3src5color5Color13border__muted();
  const text_color = resp.pressed || resp.hovered ? _M0MP49LING7167111moon_2degui3src5color5Color5white() : _M0MP49LING7167111moon_2degui3src5color5Color13text__primary();
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, rect, bg_color, 4);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(self.draw_list, rect, border_color, 1, 4);
  const text_x = rect.x + (rect.w - text_w) * 0.5;
  const text_y = rect.y + (rect.h - 14) * 0.5;
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(text_x, text_y), text, 14, text_color);
  return resp;
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext15button__primary(self, text) {
  const char_w = 8;
  const text_w = (text.length + 0) * char_w;
  const w = text_w + 28 > 64 ? text_w + 28 : 64;
  const h = 32;
  let rect;
  let _id;
  let resp;
  _L: {
    const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext15allocate__space(self, _M0MP49LING7167111moon_2degui3src4math4Vec23new(w, h));
    const __id = _bind._0;
    const _rect = _bind._1;
    const _resp = _bind._2;
    rect = _rect;
    _id = __id;
    resp = _resp;
    break _L;
  }
  const bg_color = resp.pressed ? _M0MP49LING7167111moon_2degui3src5color5Color10bg__active() : resp.hovered ? _M0MP49LING7167111moon_2degui3src5color5Color13accent__hover() : _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary();
  const border_color = resp.hovered ? _M0MP49LING7167111moon_2degui3src5color5Color5white() : _M0MP49LING7167111moon_2degui3src5color5Color13accent__hover();
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, rect, bg_color, 4);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(self.draw_list, rect, border_color, 1, 4);
  const text_x = rect.x + (rect.w - text_w) * 0.5;
  const text_y = rect.y + (rect.h - 14) * 0.5;
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(text_x, text_y), text, 14, _M0MP49LING7167111moon_2degui3src5color5Color5white());
  return resp;
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext9separator(self) {
  const w = self.available_width;
  const h = 9;
  let rect;
  let _id;
  let _resp;
  _L: {
    const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext15allocate__space(self, _M0MP49LING7167111moon_2degui3src4math4Vec23new(w, h));
    const __id = _bind._0;
    const _rect = _bind._1;
    const __resp = _bind._2;
    rect = _rect;
    _id = __id;
    _resp = __resp;
    break _L;
  }
  const y = rect.y + 4;
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__line(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(rect.x, y), _M0MP49LING7167111moon_2degui3src4math4Vec23new(rect.x + rect.w, y), _M0MP49LING7167111moon_2degui3src5color5Color13border__muted(), 1);
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext15advance__cursor(self, offset) {
  self.cursor = _M0MP49LING7167111moon_2degui3src4math4Vec23add(self.cursor, offset);
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(self, height) {
  _M0MP49LING7167111moon_2degui3src4core9UIContext15advance__cursor(self, _M0MP49LING7167111moon_2degui3src4math4Vec23new(0, height));
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext8checkbox(self, text, checked) {
  const box_size = 18;
  const gap = 8;
  const char_w = 8;
  const text_w = (text.length + 0) * char_w;
  const w = box_size + gap + text_w;
  const h = 22;
  let rect;
  let _id;
  let resp;
  _L: {
    const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext15allocate__space(self, _M0MP49LING7167111moon_2degui3src4math4Vec23new(w, h));
    const __id = _bind._0;
    const _rect = _bind._1;
    const _resp = _bind._2;
    rect = _rect;
    _id = __id;
    resp = _resp;
    break _L;
  }
  const new_state = resp.clicked ? !checked : checked;
  const box_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(rect.x, rect.y + (h - box_size) * 0.5, box_size, box_size);
  if (checked) {
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, box_rect, _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary(), 3);
    const inner = _M0MP49LING7167111moon_2degui3src4math4Rect6shrink(box_rect, 4);
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, inner, _M0MP49LING7167111moon_2degui3src5color5Color5white(), 2);
  } else {
    const box_bg = resp.hovered ? _M0MP49LING7167111moon_2degui3src5color5Color9bg__hover() : _M0MP49LING7167111moon_2degui3src5color5Color10bg__window();
    const box_border = resp.hovered ? _M0MP49LING7167111moon_2degui3src5color5Color15accent__primary() : _M0MP49LING7167111moon_2degui3src5color5Color13border__muted();
    _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(self.draw_list, box_rect, box_bg, 3);
    _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(self.draw_list, box_rect, box_border, 1, 3);
  }
  const text_x = rect.x + box_size + gap;
  const text_y = rect.y + (h - 14) * 0.5;
  const text_color = resp.hovered ? _M0MP49LING7167111moon_2degui3src5color5Color5white() : _M0MP49LING7167111moon_2degui3src5color5Color13text__primary();
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__text(self.draw_list, _M0MP49LING7167111moon_2degui3src4math4Vec23new(text_x, text_y), text, 14, text_color);
  return { _0: new_state, _1: resp };
}
function _M0MP49LING7167111moon_2degui3src4core8Response7clicked(self) {
  return self.clicked;
}
function _M0MP49LING7167111moon_2degui3src4core8RawInput11from__mouse(mouse_pos, mouse_down) {
  return new _M0TP49LING7167111moon_2degui3src4core8RawInput(mouse_pos, mouse_down, _M0MP49LING7167111moon_2degui3src4math4Vec24zero(), 0.0166);
}
function _M0MP49LING7167111moon_2degui3src4core10InputState3new() {
  return new _M0TP49LING7167111moon_2degui3src4core10InputState(_M0MP49LING7167111moon_2degui3src4math4Vec24zero(), _M0MP49LING7167111moon_2degui3src4math4Vec24zero(), _M0MP49LING7167111moon_2degui3src4math4Vec24zero(), false, false, false, _M0MP49LING7167111moon_2degui3src4math4Vec24zero(), 0.0166);
}
function _M0MP49LING7167111moon_2degui3src4core10InputState6update(self, raw) {
  self.mouse_prev_pos = self.mouse_pos;
  self.mouse_pos = raw.mouse_pos;
  self.mouse_delta = _M0MP49LING7167111moon_2degui3src4math4Vec23sub(self.mouse_pos, self.mouse_prev_pos);
  const was_down = self.mouse_down;
  self.mouse_down = raw.mouse_down;
  self.mouse_pressed = raw.mouse_down && !was_down;
  self.mouse_released = !raw.mouse_down && was_down;
  self.scroll_delta = raw.scroll_delta;
  self.dt = raw.dt > 0 ? raw.dt : 0.0166;
}
function _M0MP49LING7167111moon_2degui3src4core7IdStack3new() {
  return new _M0TP49LING7167111moon_2degui3src4core7IdStack([14695981039346656037n]);
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext3new() {
  return new _M0TP49LING7167111moon_2degui3src4core9UIContext(_M0MP49LING7167111moon_2degui3src4core10InputState3new(), _M0MP49LING7167111moon_2degui3src4draw8DrawList3new(), _M0MP49LING7167111moon_2degui3src4core7IdStack3new(), _M0MP49LING7167111moon_2degui3src4core2Id4zero(), _M0MP49LING7167111moon_2degui3src4core2Id4zero(), _M0MP49LING7167111moon_2degui3src4core2Id4zero(), _M0MP49LING7167111moon_2degui3src4math4Vec24zero(), 800, _M0MP49LING7167111moon_2degui3src4math4Vec23new(0, 8), [], 0);
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext12begin__frame(self, raw_input) {
  _M0MP49LING7167111moon_2degui3src4core10InputState6update(self.input, raw_input);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList5clear(self.draw_list);
  self.cursor = _M0MP49LING7167111moon_2degui3src4math4Vec24zero();
  _M0MPC15array5Array5clearGRP49LING7167111moon_2degui3src4math4RectE(self.clip_stack);
  self.auto_id_counter = 0;
  self.hot_id = _M0MP49LING7167111moon_2degui3src4core2Id4zero();
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext10end__frame(self) {
  return self.draw_list;
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext10draw__list(self) {
  return self.draw_list;
}
function _M0MP49LING7167111moon_2degui3src4core9UIContext21set__available__width(self, width) {
  self.available_width = width;
}
function _M0FP49LING7167111moon_2degui8examples6canvas6d__abs(val) {
  return val < 0 ? -val : val;
}
function _M0FP49LING7167111moon_2degui8examples6canvas16get__logo__color(size, index) {
  let code;
  switch (size) {
    case 12: {
      code = index >= 0 && index < _M0FP49LING7167111moon_2degui8examples6canvas14logo__grid__12.length ? _M0MPC15array5Array2atGiE(_M0FP49LING7167111moon_2degui8examples6canvas14logo__grid__12, index) : 0;
      break;
    }
    case 20: {
      code = index >= 0 && index < _M0FP49LING7167111moon_2degui8examples6canvas14logo__grid__20.length ? _M0MPC15array5Array2atGiE(_M0FP49LING7167111moon_2degui8examples6canvas14logo__grid__20, index) : 0;
      break;
    }
    case 32: {
      code = index >= 0 && index < _M0FP49LING7167111moon_2degui8examples6canvas14logo__grid__32.length ? _M0MPC15array5Array2atGiE(_M0FP49LING7167111moon_2degui8examples6canvas14logo__grid__32, index) : 0;
      break;
    }
    case 40: {
      code = index >= 0 && index < _M0FP49LING7167111moon_2degui8examples6canvas14logo__grid__40.length ? _M0MPC15array5Array2atGiE(_M0FP49LING7167111moon_2degui8examples6canvas14logo__grid__40, index) : 0;
      break;
    }
    default: {
      code = 0;
    }
  }
  if (code === 0) {
    return undefined;
  } else {
    const r = code >> 16 & 255;
    const g = code >> 8 & 255;
    const b = code & 255;
    return _M0MP49LING7167111moon_2degui3src5color5Color3rgb(r, g, b);
  }
}
function _M0FP49LING7167111moon_2degui8examples6canvas4step(mouse_x, mouse_y, mouse_down) {
  _M0FP49LING7167111moon_2degui8examples6canvas5state.frame_tick = _M0FP49LING7167111moon_2degui8examples6canvas5state.frame_tick + 1;
  if (_M0FP49LING7167111moon_2degui8examples6canvas5state.ripple_active) {
    _M0FP49LING7167111moon_2degui8examples6canvas5state.ripple_progress = _M0FP49LING7167111moon_2degui8examples6canvas5state.ripple_progress + 10;
    if (_M0FP49LING7167111moon_2degui8examples6canvas5state.ripple_progress > 600) {
      _M0FP49LING7167111moon_2degui8examples6canvas5state.ripple_active = false;
      _M0FP49LING7167111moon_2degui8examples6canvas5state.ripple_progress = 0;
    }
  }
  const raw = _M0MP49LING7167111moon_2degui3src4core8RawInput11from__mouse(_M0MP49LING7167111moon_2degui3src4math4Vec23new(mouse_x, mouse_y), mouse_down);
  _M0MP49LING7167111moon_2degui3src4core9UIContext12begin__frame(_M0FP49LING7167111moon_2degui8examples6canvas3ctx, raw);
  _M0MP49LING7167111moon_2degui3src4core9UIContext21set__available__width(_M0FP49LING7167111moon_2degui8examples6canvas3ctx, 230);
  _M0MP49LING7167111moon_2degui3src4core9UIContext5label(_M0FP49LING7167111moon_2degui8examples6canvas3ctx, "STRESS PROFILE");
  _M0MP49LING7167111moon_2degui3src4core9UIContext9separator(_M0FP49LING7167111moon_2degui8examples6canvas3ctx);
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(_M0FP49LING7167111moon_2degui8examples6canvas3ctx, 2);
  _M0MP49LING7167111moon_2degui3src4core9UIContext5label(_M0FP49LING7167111moon_2degui8examples6canvas3ctx, "Logo Granularity:");
  if (_M0MP49LING7167111moon_2degui3src4core8Response7clicked(_M0MP49LING7167111moon_2degui3src4core9UIContext6button(_M0FP49LING7167111moon_2degui8examples6canvas3ctx, "144 Widgets (12x12)"))) {
    _M0FP49LING7167111moon_2degui8examples6canvas5state.grid_dim = 12;
  }
  if (_M0MP49LING7167111moon_2degui3src4core8Response7clicked(_M0MP49LING7167111moon_2degui3src4core9UIContext6button(_M0FP49LING7167111moon_2degui8examples6canvas3ctx, "400 Widgets (20x20)"))) {
    _M0FP49LING7167111moon_2degui8examples6canvas5state.grid_dim = 20;
  }
  if (_M0MP49LING7167111moon_2degui3src4core8Response7clicked(_M0MP49LING7167111moon_2degui3src4core9UIContext6button(_M0FP49LING7167111moon_2degui8examples6canvas3ctx, "1,024 Widgets (32x32)"))) {
    _M0FP49LING7167111moon_2degui8examples6canvas5state.grid_dim = 32;
  }
  if (_M0MP49LING7167111moon_2degui3src4core8Response7clicked(_M0MP49LING7167111moon_2degui3src4core9UIContext6button(_M0FP49LING7167111moon_2degui8examples6canvas3ctx, "1,600 Widgets (40x40)"))) {
    _M0FP49LING7167111moon_2degui8examples6canvas5state.grid_dim = 40;
  }
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(_M0FP49LING7167111moon_2degui8examples6canvas3ctx, 4);
  _M0MP49LING7167111moon_2degui3src4core9UIContext9separator(_M0FP49LING7167111moon_2degui8examples6canvas3ctx);
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(_M0FP49LING7167111moon_2degui8examples6canvas3ctx, 2);
  let new_repel;
  let repel_resp;
  _L: {
    const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext8checkbox(_M0FP49LING7167111moon_2degui8examples6canvas3ctx, "Magnetic Repulsion", _M0FP49LING7167111moon_2degui8examples6canvas5state.magnetic_repel);
    const _new_repel = _bind._0;
    const _repel_resp = _bind._1;
    new_repel = _new_repel;
    repel_resp = _repel_resp;
    break _L;
  }
  if (_M0MP49LING7167111moon_2degui3src4core8Response7clicked(repel_resp)) {
    _M0FP49LING7167111moon_2degui8examples6canvas5state.magnetic_repel = new_repel;
  }
  let new_wave;
  let wave_resp;
  _L$2: {
    const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext8checkbox(_M0FP49LING7167111moon_2degui8examples6canvas3ctx, "Kinetic Resonance", _M0FP49LING7167111moon_2degui8examples6canvas5state.wave_pulse);
    const _new_wave = _bind._0;
    const _wave_resp = _bind._1;
    new_wave = _new_wave;
    wave_resp = _wave_resp;
    break _L$2;
  }
  if (_M0MP49LING7167111moon_2degui3src4core8Response7clicked(wave_resp)) {
    _M0FP49LING7167111moon_2degui8examples6canvas5state.wave_pulse = new_wave;
  }
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(_M0FP49LING7167111moon_2degui8examples6canvas3ctx, 4);
  if (_M0MP49LING7167111moon_2degui3src4core8Response7clicked(_M0MP49LING7167111moon_2degui3src4core9UIContext15button__primary(_M0FP49LING7167111moon_2degui8examples6canvas3ctx, "Trigger Shockwave"))) {
    _M0FP49LING7167111moon_2degui8examples6canvas5state.ripple_active = true;
    _M0FP49LING7167111moon_2degui8examples6canvas5state.ripple_progress = 0;
    _M0FP49LING7167111moon_2degui8examples6canvas5state.ripple_cx = 580;
    _M0FP49LING7167111moon_2degui8examples6canvas5state.ripple_cy = 270;
  }
  if (_M0MP49LING7167111moon_2degui3src4core8Response7clicked(_M0MP49LING7167111moon_2degui3src4core9UIContext6button(_M0FP49LING7167111moon_2degui8examples6canvas3ctx, "Reset Statistics"))) {
    _M0FP49LING7167111moon_2degui8examples6canvas5state.click_count = 0;
    _M0FP49LING7167111moon_2degui8examples6canvas5state.selected_id = -1;
    _M0FP49LING7167111moon_2degui8examples6canvas5state.selected_col = -1;
    _M0FP49LING7167111moon_2degui8examples6canvas5state.selected_row = -1;
  }
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(_M0FP49LING7167111moon_2degui8examples6canvas3ctx, 4);
  _M0MP49LING7167111moon_2degui3src4core9UIContext9separator(_M0FP49LING7167111moon_2degui8examples6canvas3ctx);
  const total_widgets = Math.imul(_M0FP49LING7167111moon_2degui8examples6canvas5state.grid_dim, _M0FP49LING7167111moon_2degui8examples6canvas5state.grid_dim) | 0;
  const _string_builder = _M0MPB13StringBuilder21StringBuilder_2einner(16);
  _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, "Active Widgets: ");
  _M0MPB13StringBuilder13write__objectGiE(_string_builder, total_widgets);
  _M0MP49LING7167111moon_2degui3src4core9UIContext5label(_M0FP49LING7167111moon_2degui8examples6canvas3ctx, _M0MPB13StringBuilder10to__string(_string_builder));
  const _string_builder$2 = _M0MPB13StringBuilder21StringBuilder_2einner(15);
  _M0IPB13StringBuilderPB6Logger13write__string(_string_builder$2, "Recorded Hits: ");
  _M0MPB13StringBuilder13write__objectGiE(_string_builder$2, _M0FP49LING7167111moon_2degui8examples6canvas5state.click_count);
  _M0MP49LING7167111moon_2degui3src4core9UIContext5label(_M0FP49LING7167111moon_2degui8examples6canvas3ctx, _M0MPB13StringBuilder10to__string(_string_builder$2));
  if (_M0FP49LING7167111moon_2degui8examples6canvas5state.selected_id >= 0) {
    const _string_builder$3 = _M0MPB13StringBuilder21StringBuilder_2einner(14);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder$3, "Target: #");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder$3, _M0FP49LING7167111moon_2degui8examples6canvas5state.selected_id);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder$3, " (");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder$3, _M0FP49LING7167111moon_2degui8examples6canvas5state.selected_col);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder$3, ", ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder$3, _M0FP49LING7167111moon_2degui8examples6canvas5state.selected_row);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder$3, ")");
    _M0MP49LING7167111moon_2degui3src4core9UIContext5label(_M0FP49LING7167111moon_2degui8examples6canvas3ctx, _M0MPB13StringBuilder10to__string(_string_builder$3));
  } else {
    _M0MP49LING7167111moon_2degui3src4core9UIContext5label(_M0FP49LING7167111moon_2degui8examples6canvas3ctx, "Target: None (Hover Logo)");
  }
  const dl = _M0MP49LING7167111moon_2degui3src4core9UIContext10draw__list(_M0FP49LING7167111moon_2degui8examples6canvas3ctx);
  const vp_x = 270;
  const vp_y = 20;
  const vp_w = 620;
  const vp_h = 500;
  _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(dl, _M0MP49LING7167111moon_2degui3src4math4Rect3new(vp_x, vp_y, vp_w, vp_h), _M0MP49LING7167111moon_2degui3src5color5Color3rgb(13, 15, 23), 8);
  _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(dl, _M0MP49LING7167111moon_2degui3src4math4Rect3new(vp_x, vp_y, vp_w, vp_h), _M0MP49LING7167111moon_2degui3src5color5Color3rgb(38, 43, 61), 1, 8);
  const grid_dim = _M0FP49LING7167111moon_2degui8examples6canvas5state.grid_dim;
  const matrix_size = 460;
  const offset_x = vp_x + (vp_w - matrix_size) / 2;
  const offset_y = vp_y + (vp_h - matrix_size) / 2;
  const gap = grid_dim <= 12 ? 4 : grid_dim <= 20 ? 3 : grid_dim <= 32 ? 2 : 1.5;
  const cell_size = (matrix_size - gap * ((grid_dim - 1 | 0) + 0)) / (grid_dim + 0);
  const mouse_pt = _M0MP49LING7167111moon_2degui3src4math4Vec23new(mouse_x, mouse_y);
  const hovered_index = new _M0TPB8MutLocalGiE(-1);
  const repel_radius_sq = 7225;
  let _tmp = 0;
  while (true) {
    const idx = _tmp;
    if (idx < total_widgets) {
      if (grid_dim === 0) {
        $panic();
      }
      const col = idx % grid_dim | 0;
      if (grid_dim === 0) {
        $panic();
      }
      const row = idx / grid_dim | 0;
      const base_x = offset_x + (col + 0) * (cell_size + gap);
      const base_y = offset_y + (row + 0) * (cell_size + gap);
      const center_x = base_x + cell_size / 2;
      const center_y = base_y + cell_size / 2;
      const base_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(base_x, base_y, cell_size, cell_size);
      const is_hovered = _M0MP49LING7167111moon_2degui3src4math4Rect8contains(base_rect, mouse_pt);
      if (is_hovered) {
        hovered_index.val = idx;
        _M0FP49LING7167111moon_2degui8examples6canvas5state.selected_col = col;
        _M0FP49LING7167111moon_2degui8examples6canvas5state.selected_row = row;
        if (mouse_down) {
          _M0FP49LING7167111moon_2degui8examples6canvas5state.click_count = _M0FP49LING7167111moon_2degui8examples6canvas5state.click_count + 1 | 0;
          _M0FP49LING7167111moon_2degui8examples6canvas5state.ripple_active = true;
          _M0FP49LING7167111moon_2degui8examples6canvas5state.ripple_progress = 0;
          _M0FP49LING7167111moon_2degui8examples6canvas5state.ripple_cx = center_x;
          _M0FP49LING7167111moon_2degui8examples6canvas5state.ripple_cy = center_y;
        }
      }
      const dx = new _M0TPB8MutLocalGdE(0);
      const dy = new _M0TPB8MutLocalGdE(0);
      if (!is_hovered && _M0FP49LING7167111moon_2degui8examples6canvas5state.magnetic_repel) {
        const d_sq = (center_x - mouse_x) * (center_x - mouse_x) + (center_y - mouse_y) * (center_y - mouse_y);
        if (d_sq < repel_radius_sq && d_sq > 1) {
          const repel_factor = (repel_radius_sq - d_sq) / repel_radius_sq;
          const push = repel_factor * (grid_dim <= 20 ? 10 : 5);
          const approx_dist = 35;
          dx.val = (center_x - mouse_x) / approx_dist * push;
          dy.val = (center_y - mouse_y) / approx_dist * push;
        }
      }
      if (_M0FP49LING7167111moon_2degui8examples6canvas5state.wave_pulse) {
        const wave_val = _M0FP49LING7167111moon_2degui8examples6canvas5state.frame_tick * 0.08 + ((col + row | 0) + 0) * 0.35;
        const phase = wave_val - (_M0MPC16double6Double7to__int(wave_val) + 0);
        const wave_dy = (phase < 0.5 ? phase * 4 - 1 : 3 - phase * 4) * 1.5;
        dy.val = dy.val + wave_dy;
      }
      const ripple_boost = new _M0TPB8MutLocalGbE(false);
      if (_M0FP49LING7167111moon_2degui8examples6canvas5state.ripple_active) {
        const r_dx = center_x - _M0FP49LING7167111moon_2degui8examples6canvas5state.ripple_cx;
        const r_dy = center_y - _M0FP49LING7167111moon_2degui8examples6canvas5state.ripple_cy;
        const r_dist_sq = r_dx * r_dx + r_dy * r_dy;
        const target_r = _M0FP49LING7167111moon_2degui8examples6canvas5state.ripple_progress;
        const target_r_sq = target_r * target_r;
        const diff = _M0FP49LING7167111moon_2degui8examples6canvas6d__abs(r_dist_sq - target_r_sq);
        if (diff < 1600) {
          ripple_boost.val = true;
          const bump = (1600 - diff) / 1600 * 4;
          dy.val = dy.val - bump;
        }
      }
      const cell_rect = _M0MP49LING7167111moon_2degui3src4math4Rect3new(base_x + dx.val, base_y + dy.val, cell_size, cell_size);
      const _bind = _M0FP49LING7167111moon_2degui8examples6canvas16get__logo__color(grid_dim, idx);
      const is_logo = !(_bind === undefined);
      let base_color;
      const _bind$2 = _M0FP49LING7167111moon_2degui8examples6canvas16get__logo__color(grid_dim, idx);
      if (_bind$2 === undefined) {
        if (2 === 0) {
          $panic();
        }
        if (((col + row | 0) % 2 | 0) === 0) {
          base_color = _M0MP49LING7167111moon_2degui3src5color5Color3rgb(20, 24, 36);
        } else {
          base_color = _M0MP49LING7167111moon_2degui3src5color5Color3rgb(25, 30, 44);
        }
      } else {
        const _Some = _bind$2;
        const _c = _Some;
        base_color = _c;
      }
      const draw_color = is_hovered ? (mouse_down ? _M0MP49LING7167111moon_2degui3src5color5Color3rgb(255, 255, 255) : _M0MP49LING7167111moon_2degui3src5color5Color3rgb(56, 189, 248)) : ripple_boost.val ? _M0MP49LING7167111moon_2degui3src5color5Color3rgb(244, 114, 182) : base_color;
      const radius = cell_size < 12 ? 1 : cell_size < 20 ? 2 : 3;
      _M0MP49LING7167111moon_2degui3src4draw8DrawList9add__rect(dl, cell_rect, draw_color, radius);
      if (is_hovered) {
        _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(dl, cell_rect, _M0MP49LING7167111moon_2degui3src5color5Color3rgb(255, 255, 255), 1.5, radius);
      } else {
        if (is_logo && grid_dim <= 20) {
          _M0MP49LING7167111moon_2degui3src4draw8DrawList17add__rect__stroke(dl, cell_rect, _M0MP49LING7167111moon_2degui3src5color5Color3rgb(48, 55, 78), 0.5, radius);
        }
      }
      _tmp = idx + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  if (hovered_index.val >= 0) {
    _M0FP49LING7167111moon_2degui8examples6canvas5state.selected_id = hovered_index.val;
  }
  return _M0MP49LING7167111moon_2degui3src4core9UIContext10end__frame(_M0FP49LING7167111moon_2degui8examples6canvas3ctx);
}
(() => {
  const dl = _M0FP49LING7167111moon_2degui8examples6canvas4step(580, 270, false);
  const _string_builder = _M0MPB13StringBuilder21StringBuilder_2einner(39);
  _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, "Benchmark initialized, total commands: ");
  _M0MPB13StringBuilder13write__objectGiE(_string_builder, _M0MP49LING7167111moon_2degui3src4draw8DrawList3len(dl));
  _M0FPB7printlnGsE(_M0MPB13StringBuilder10to__string(_string_builder));

  if (typeof window !== 'undefined') window.moon_step = _M0FP49LING7167111moon_2degui8examples6canvas4step;
  if (typeof globalThis !== 'undefined') globalThis.moon_step = _M0FP49LING7167111moon_2degui8examples6canvas4step;
})();
//# sourceMappingURL=canvas.js.map
