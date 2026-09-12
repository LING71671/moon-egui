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

// ----------------------------------------------------------------------
// Text & Editor Components (TextEdit, CodeEditor, RichText)
// ----------------------------------------------------------------------

///|
fn draw_text_edit_showcase(ui : @core.UIContext) -> Unit {
  let _ = ui.label_colored(
    "单行文本输入框 (TextEdit)",
    @color.Color::accent_primary(),
  )
  ui.spacer(10.0)

  let (n, r1) = ui.text_edit(
    "name_input",
    gallery_state.text_name,
    "请输入开发者姓名",
  )
  gallery_state.text_name = n
  if r1.has_focus {
    gallery_state.status_text = "Editing Name: " + n
  }

  ui.spacer(10.0)

  let (e, r2) = ui.text_edit(
    "email_input",
    gallery_state.text_email,
    "dev@moonbitlang.com",
  )
  gallery_state.text_email = e
  if r2.has_focus {
    gallery_state.status_text = "Editing Email: " + e
  }

  ui.spacer(16.0)
  ui.separator()
  ui.spacer(8.0)
  let _ = ui.label(
    "支持光标精确定位、文本追加、退格以及焦点切换。",
  )
}

///|
fn draw_code_editor_showcase(ui : @core.UIContext) -> Unit {
  let _ = ui.label_colored(
    "多行代码与行号标尺编辑器 (CodeEditor)",
    @color.Color::accent_primary(),
  )
  ui.spacer(6.0)

  let (new_code, resp) = ui.code_editor(
    "gallery_code",
    gallery_state.code_buffer,
    size=@math.Vec2::new(ui.available_width(), 210.0),
    show_line_numbers=true,
  )
  gallery_state.code_buffer = new_code
  if resp.has_focus {
    gallery_state.status_text = "CodeEditor Focused"
  }
}

///|
fn draw_rich_text_showcase(ui : @core.UIContext) -> Unit {
  let _ = ui.label_colored(
    "流式排版富文本与超链接 (RichText & Hyperlink)",
    @color.Color::accent_primary(),
  )
  ui.spacer(6.0)
  let _ = ui.label(
    "支持单词自适应折行、行内代码块质感与悬停柔和下划线超链接。",
  )
  ui.spacer(12.0)

  let spans = [
    @core.TextSpan::normal("当前运行环境为"),
    @core.TextSpan::code("MoonBit Wasm"),
    @core.TextSpan::bold("即时模式渲染管线。"),
    @core.TextSpan::normal(
      "它直接向原生 HTML5 Canvas 提交绘制指令。欲了解更多细节，请访问",
    ),
    @core.TextSpan::link("MoonBit 官方主页", "https://www.moonbitlang.cn"),
    @core.TextSpan::normal("或查看"),
    @core.TextSpan::link("API 手册", "https://docs.moonbitlang.com"),
    @core.TextSpan::normal("。"),
  ]

  let resp = ui.rich_text("gal_rt", spans, wrap_width=ui.available_width())
  match resp.clicked_url {
    Some(url) => {
      gallery_state.rich_text_last_url = url
      gallery_state.status_text = "Clicked URL: " + url
    }
    None => ()
  }

  ui.spacer(16.0)
  let (clicked, _) = ui.hyperlink(
    "独立超链接组件: moon-egui GitHub Repository", "https://github.com/LING71671/moon-egui",
  )
  if clicked {
    gallery_state.rich_text_last_url = "https://github.com/LING71671/moon-egui"
    gallery_state.status_text = "Clicked GitHub Link"
  }

  ui.spacer(8.0)
  let _ = ui.label("最后激活链接: " + gallery_state.rich_text_last_url)
}
