function _M0TP49LING7167111moon_2degui8examples6canvas8AppState(param0, param1, param2) {
  this.counter = param0;
  this.glow_enabled = param1;
  this.sound_enabled = param2;
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
const _M0FP092moonbitlang_2fcore_2fbuiltin_2fStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger = { method_0: _M0IPB13StringBuilderPB6Logger13write__string, method_1: _M0IP016_24default__implPB6Logger16write__substringGRPB13StringBuilderE, method_2: _M0IPB13StringBuilderPB6Logger11write__view, method_3: _M0IPB13StringBuilderPB6Logger11write__char, method_4: _M0IP016_24default__implPB6Logger28write__string__interpolationGRPB13StringBuilderE, method_5: _M0IP016_24default__implPB6Logger5writeGRPB13StringBuilderE };
const _M0FP49LING7167111moon_2degui8examples6canvas5state = new _M0TP49LING7167111moon_2degui8examples6canvas8AppState(0, true, false);
const _M0FP49LING7167111moon_2degui8examples6canvas3ctx = _M0MP49LING7167111moon_2degui3src4core9UIContext3new();
function _M0MPB13StringBuilder13write__objectGiE(self, obj) {
  _M0IP016_24default__implPB4Show6outputGiE(obj, { self: self, method_table: _M0FP092moonbitlang_2fcore_2fbuiltin_2fStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger });
}
function _M0MPB13StringBuilder13write__objectGbE(self, obj) {
  _M0IP016_24default__implPB4Show6outputGbE(obj, { self: self, method_table: _M0FP092moonbitlang_2fcore_2fbuiltin_2fStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger });
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
function _M0IP016_24default__implPB4Show6outputGbE(self, logger) {
  logger.method_table.method_0(logger.self, _M0IPC14bool4BoolPB4Show10to__string(self));
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
function _M0IPC14bool4BoolPB4Show10to__string(self) {
  return self ? "true" : "false";
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
function _M0MPC15array5Array2atGmE(self, index) {
  const len = self.length;
  return index >= 0 && index < len ? self[index] : $panic();
}
function _M0MPC15array5Array5clearGRP49LING7167111moon_2degui3src4math4RectE(self) {
  _M0MPC15array5Array28unsafe__truncate__to__lengthGRP49LING7167111moon_2degui3src4math4RectE(self, 0);
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
function _M0FP49LING7167111moon_2degui8examples6canvas4step(mouse_x, mouse_y, mouse_down) {
  const raw = _M0MP49LING7167111moon_2degui3src4core8RawInput11from__mouse(_M0MP49LING7167111moon_2degui3src4math4Vec23new(mouse_x, mouse_y), mouse_down);
  _M0MP49LING7167111moon_2degui3src4core9UIContext12begin__frame(_M0FP49LING7167111moon_2degui8examples6canvas3ctx, raw);
  _M0MP49LING7167111moon_2degui3src4core9UIContext5label(_M0FP49LING7167111moon_2degui8examples6canvas3ctx, "⚡ Moon-EGUI v0.1.0 • Immediate-Mode Canvas Demo");
  _M0MP49LING7167111moon_2degui3src4core9UIContext9separator(_M0FP49LING7167111moon_2degui8examples6canvas3ctx);
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(_M0FP49LING7167111moon_2degui8examples6canvas3ctx, 4);
  const _string_builder = _M0MPB13StringBuilder21StringBuilder_2einner(29);
  _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, "🚀 Click Me (+1)  [Count: ");
  _M0MPB13StringBuilder13write__objectGiE(_string_builder, _M0FP49LING7167111moon_2degui8examples6canvas5state.counter);
  _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, "]");
  const btn_text = _M0MPB13StringBuilder10to__string(_string_builder);
  const btn_resp = _M0MP49LING7167111moon_2degui3src4core9UIContext6button(_M0FP49LING7167111moon_2degui8examples6canvas3ctx, btn_text);
  if (_M0MP49LING7167111moon_2degui3src4core8Response7clicked(btn_resp)) {
    _M0FP49LING7167111moon_2degui8examples6canvas5state.counter = _M0FP49LING7167111moon_2degui8examples6canvas5state.counter + 1 | 0;
  }
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(_M0FP49LING7167111moon_2degui8examples6canvas3ctx, 4);
  const pbtn_resp = _M0MP49LING7167111moon_2degui3src4core9UIContext15button__primary(_M0FP49LING7167111moon_2degui8examples6canvas3ctx, "Reset Counter");
  if (_M0MP49LING7167111moon_2degui3src4core8Response7clicked(pbtn_resp)) {
    _M0FP49LING7167111moon_2degui8examples6canvas5state.counter = 0;
  }
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(_M0FP49LING7167111moon_2degui8examples6canvas3ctx, 8);
  _M0MP49LING7167111moon_2degui3src4core9UIContext9separator(_M0FP49LING7167111moon_2degui8examples6canvas3ctx);
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(_M0FP49LING7167111moon_2degui8examples6canvas3ctx, 4);
  let new_glow;
  let glow_resp;
  _L: {
    const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext8checkbox(_M0FP49LING7167111moon_2degui8examples6canvas3ctx, "Enable Cyberpunk Glow", _M0FP49LING7167111moon_2degui8examples6canvas5state.glow_enabled);
    const _new_glow = _bind._0;
    const _glow_resp = _bind._1;
    new_glow = _new_glow;
    glow_resp = _glow_resp;
    break _L;
  }
  if (_M0MP49LING7167111moon_2degui3src4core8Response7clicked(glow_resp)) {
    _M0FP49LING7167111moon_2degui8examples6canvas5state.glow_enabled = new_glow;
  }
  let new_sound;
  let sound_resp;
  _L$2: {
    const _bind = _M0MP49LING7167111moon_2degui3src4core9UIContext8checkbox(_M0FP49LING7167111moon_2degui8examples6canvas3ctx, "Simulate Audio Haptics", _M0FP49LING7167111moon_2degui8examples6canvas5state.sound_enabled);
    const _new_sound = _bind._0;
    const _sound_resp = _bind._1;
    new_sound = _new_sound;
    sound_resp = _sound_resp;
    break _L$2;
  }
  if (_M0MP49LING7167111moon_2degui3src4core8Response7clicked(sound_resp)) {
    _M0FP49LING7167111moon_2degui8examples6canvas5state.sound_enabled = new_sound;
  }
  _M0MP49LING7167111moon_2degui3src4core9UIContext6spacer(_M0FP49LING7167111moon_2degui8examples6canvas3ctx, 8);
  _M0MP49LING7167111moon_2degui3src4core9UIContext9separator(_M0FP49LING7167111moon_2degui8examples6canvas3ctx);
  const _string_builder$2 = _M0MPB13StringBuilder21StringBuilder_2einner(21);
  _M0IPB13StringBuilderPB6Logger13write__string(_string_builder$2, "Cursor: (");
  _M0MPB13StringBuilder13write__objectGiE(_string_builder$2, _M0MPC16double6Double7to__int(mouse_x));
  _M0IPB13StringBuilderPB6Logger13write__string(_string_builder$2, ", ");
  _M0MPB13StringBuilder13write__objectGiE(_string_builder$2, _M0MPC16double6Double7to__int(mouse_y));
  _M0IPB13StringBuilderPB6Logger13write__string(_string_builder$2, ") | Down: ");
  _M0MPB13StringBuilder13write__objectGbE(_string_builder$2, mouse_down);
  const status_text = _M0MPB13StringBuilder10to__string(_string_builder$2);
  _M0MP49LING7167111moon_2degui3src4core9UIContext5label(_M0FP49LING7167111moon_2degui8examples6canvas3ctx, status_text);
  return _M0MP49LING7167111moon_2degui3src4core9UIContext10end__frame(_M0FP49LING7167111moon_2degui8examples6canvas3ctx);
}
(() => {
  const dl = _M0FP49LING7167111moon_2degui8examples6canvas4step(100, 50, false);
  const _string_builder = _M0MPB13StringBuilder21StringBuilder_2einner(43);
  _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, "Canvas demo initialized, emitted ");
  _M0MPB13StringBuilder13write__objectGiE(_string_builder, _M0MP49LING7167111moon_2degui3src4draw8DrawList3len(dl));
  _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, " commands.");
  _M0FPB7printlnGsE(_M0MPB13StringBuilder10to__string(_string_builder));
})();
//# sourceMappingURL=canvas.js.map
