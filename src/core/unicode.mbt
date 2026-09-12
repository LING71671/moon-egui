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
/// Safe substring slice clamping start and end within valid string bounds.
pub fn string_slice(s : String, start : Int, end : Int) -> String {
  let len = s.length()
  let safe_start = if start < 0 { 0 } else if start > len { len } else { start }
  let safe_end = if end < safe_start {
    safe_start
  } else if end > len {
    len
  } else {
    end
  }
  s[safe_start:safe_end].to_owned()
}

///|
/// Returns true if the UTF-16 code point is a leading surrogate (high surrogate).
pub fn is_leading_surrogate(code : Int) -> Bool {
  code >= 0xD800 && code <= 0xDBFF
}

///|
/// Returns true if the UTF-16 code point is a trailing surrogate (low surrogate).
pub fn is_trailing_surrogate(code : Int) -> Bool {
  code >= 0xDC00 && code <= 0xDFFF
}

///|
/// Returns the safe cursor index stepping backwards by 1 Unicode scalar.
/// If preceded by a UTF-16 surrogate pair, steps back by 2 code units.
pub fn prev_char_boundary(text : String, pos : Int) -> Int {
  if pos <= 0 {
    0
  } else if pos >= 2 &&
    is_trailing_surrogate(text[pos - 1].to_int()) &&
    is_leading_surrogate(text[pos - 2].to_int()) {
    pos - 2
  } else {
    pos - 1
  }
}

///|
/// Returns the safe cursor index stepping forwards by 1 Unicode scalar.
/// If at the start of a UTF-16 surrogate pair, steps forwards by 2 code units.
pub fn next_char_boundary(text : String, pos : Int) -> Int {
  let len = text.length()
  if pos >= len {
    len
  } else if pos + 1 < len &&
    is_leading_surrogate(text[pos].to_int()) &&
    is_trailing_surrogate(text[pos + 1].to_int()) {
    pos + 2
  } else {
    pos + 1
  }
}

///|
/// Deletes 1 Unicode scalar before cursor_pos and returns (new_text, new_cursor_pos).
pub fn delete_prev_char(text : String, pos : Int) -> (String, Int) {
  if pos <= 0 || text.length() == 0 {
    (text, 0)
  } else {
    let prev = prev_char_boundary(text, pos)
    let left = string_slice(text, 0, prev)
    let right = string_slice(text, pos, text.length())
    (left + right, prev)
  }
}

///|
/// Deletes 1 Unicode scalar at cursor_pos and returns new_text.
pub fn delete_next_char(text : String, pos : Int) -> String {
  let len = text.length()
  if pos >= len || len == 0 {
    text
  } else {
    let next = next_char_boundary(text, pos)
    let left = string_slice(text, 0, pos)
    let right = string_slice(text, next, len)
    left + right
  }
}

///|
/// Returns true if the character code is in common East Asian / CJK script ranges.
pub fn is_cjk_char(code : Int) -> Bool {
  (code >= 0x4E00 && code <= 0x9FFF) || // CJK Unified Ideographs
  (code >= 0x3400 && code <= 0x4DBF) || // CJK Extension A
  (code >= 0xF900 && code <= 0xFAFF) || // CJK Compatibility
  (code >= 0x3000 && code <= 0x303F) || // CJK Symbols & Punctuation
  (code >= 0x3040 && code <= 0x309F) || // Hiragana
  (code >= 0x30A0 && code <= 0x30FF) || // Katakana
  (code >= 0xAC00 && code <= 0xD7AF) || // Hangul Syllables
  (code >= 0xFF00 && code <= 0xFFEF) // Halfwidth and Fullwidth Forms
}

///|
/// Returns true if the character code is a closing quotation or punctuation mark
/// that should not start a new line under standard CJK typesetting rules.
pub fn is_cjk_closing_punct(code : Int) -> Bool {
  match code {
    0x3001 | 0x3002 | 0xFF0C | 0xFF0E | 0xFF01 | 0xFF1F | 0xFF1B | 0xFF1A =>
      true
    0x3009 | 0x300B | 0x300D | 0x300F | 0x3011 | 0x3015 | 0xFF09 | 0xFF5D =>
      true
    0x201D | 0x2019 => true
    _ => false
  }
}
