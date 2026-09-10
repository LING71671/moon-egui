// Registry of Components with Code & Interactive Demo
    const COMPONENTS = {
      button: {
        title: "Button 按钮",
        signature: "ui.button / ui.button_primary",
        code: `///|
/// 基础按钮交互范例 (Button)
pub fn draw_buttons(ui : @core.UIContext, state : AppState) -> Unit {
  // 1. 主要强调按钮 (Primary)
  let res_primary = ui.button_primary("立即提交 (Submit)")
  if res_primary.clicked {
    state.count += 1
  }

  // 2. 次要常规按钮 (Default)
  let res_default = ui.button("重置计数 (Reset)")
  if res_default.clicked {
    state.count = 0
  }

  // 3. 自定义尺寸大按钮 (Sized)
  let res_sized = ui.button_sized("自定义大按钮", 160.0, 40.0)
}`,
        renderUI: (container, state) => {
          container.innerHTML = `
            <div class="sandbox-header">
              <span>Interactive Button Sandbox</span>
              <span>Count: ${state.count || 0}</span>
            </div>
            <div class="sandbox-body">
              <div class="widget-row">
                <button class="btn-primary" id="demoPrimaryBtn">主要按钮</button>
                <button class="btn-secondary" id="demoDefaultBtn">重置计数</button>
              </div>
            </div>
            <div class="sandbox-tip">
              试着点击按钮：每次交互都在即时模式单帧循环中驱动状态变更与重绘。
            </div>
          `;
          const pBtn = container.querySelector('#demoPrimaryBtn');
          const dBtn = container.querySelector('#demoDefaultBtn');
          pBtn.onclick = () => {
            state.count = (state.count || 0) + 1;
            container.querySelector('.sandbox-header span:last-child').textContent = `Count: ${state.count}`;
            document.getElementById('statResponse').textContent = `clicked: true, count: ${state.count}`;
            showToast(`点击了主要按钮！计数: ${state.count}`);
          };
          dBtn.onclick = () => {
            state.count = 0;
            container.querySelector('.sandbox-header span:last-child').textContent = `Count: 0`;
            document.getElementById('statResponse').textContent = `clicked: true, count: 0`;
            showToast('计数已清零');
          };
        }
      },

      text_edit: {
        title: "TextEdit 文本输入框",
        signature: "ui.text_edit(text, placeholder=...)",
        code: `///|
/// 单行文本输入框 (TextEdit)
pub fn draw_text_edit(ui : @core.UIContext, state : AppState) -> Unit {
  // 带有光标导航与聚焦环 (Focus Ring)
  let (new_text, res) = ui.text_edit(
    state.username,
    placeholder="请输入开发者用户名...",
  )
  if res.changed {
    state.username = new_text
  }
}`,
        renderUI: (container, state) => {
          const val = state.inputText || "MoonBit 现代 GUI";
          container.innerHTML = `
            <div class="sandbox-header">
              <span>TextEdit Input Sandbox</span>
              <span>Length: ${val.length}</span>
            </div>
            <div class="sandbox-body">
              <input type="text" class="input-box" id="demoTextInput" value="${val}" placeholder="输入文本..." />
            </div>
            <div class="sandbox-tip">
              支持点击聚焦、方向键移动光标、退格回删及中英文字符流输入。
            </div>
          `;
          const input = container.querySelector('#demoTextInput');
          input.oninput = (e) => {
            state.inputText = e.target.value;
            container.querySelector('.sandbox-header span:last-child').textContent = `Length: ${state.inputText.length}`;
            document.getElementById('statResponse').textContent = `changed: true, len: ${state.inputText.length}`;
          };
        }
      },

      checkbox: {
        title: "Checkbox 复选框",
        signature: "ui.checkbox(label, is_checked)",
        code: `///|
/// 复选框状态切换 (Checkbox)
pub fn draw_checkbox(ui : @core.UIContext, state : AppState) -> Unit {
  let (checked, res) = ui.checkbox("启用硬件加速管线", state.gpu)
  if res.changed {
    state.gpu = checked
  }

  let (vsync, res2) = ui.checkbox("开启垂直同步 (VSync)", state.vsync)
  if res2.changed {
    state.vsync = vsync
  }
}`,
        renderUI: (container, state) => {
          if (state.chk1 === undefined) state.chk1 = true;
          if (state.chk2 === undefined) state.chk2 = false;
          container.innerHTML = `
            <div class="sandbox-header">
              <span>Checkbox Sandbox</span>
            </div>
            <div class="sandbox-body">
              <div class="checkbox-row ${state.chk1 ? 'checked' : ''}" id="chk1">
                <div class="checkbox-sq">
                  <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="3"><polyline points="20 6 9 17 4 12"/></svg>
                </div>
                <span>启用 GPU 硬件加速管线</span>
              </div>
              <div class="checkbox-row ${state.chk2 ? 'checked' : ''}" id="chk2">
                <div class="checkbox-sq">
                  <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="3"><polyline points="20 6 9 17 4 12"/></svg>
                </div>
                <span>开启垂直同步 (VSync)</span>
              </div>
            </div>
            <div class="sandbox-tip">
              二值布尔状态切换，支持微缩放动画与外发光高亮。
            </div>
          `;
          const c1 = container.querySelector('#chk1');
          const c2 = container.querySelector('#chk2');
          c1.onclick = () => {
            state.chk1 = !state.chk1;
            c1.classList.toggle('checked', state.chk1);
            document.getElementById('statResponse').textContent = `gpu: ${state.chk1}`;
          };
          c2.onclick = () => {
            state.chk2 = !state.chk2;
            c2.classList.toggle('checked', state.chk2);
            document.getElementById('statResponse').textContent = `vsync: ${state.chk2}`;
          };
        }
      },

      toggle: {
        title: "Toggle 胶囊开关",
        signature: "ui.toggle(label, is_checked)",
        code: `///|
/// 胶囊滑动开关交互范例 (Toggle Switch)
pub fn draw_toggles(ui : @core.UIContext, state : AppState) -> Unit {
  // 1. 视口网格几何吸附开关
  let (snap, res1) = ui.toggle("开启网格端点自动吸附", state.grid_snap)
  if res1.changed {
    state.grid_snap = snap
  }

  // 2. 实时光影法线着色管线
  let (normals, res2) = ui.toggle("实时光影法线着色管线", state.normals)
  if res2.changed {
    state.normals = normals
  }
}`,
        renderUI: (container, state) => {
          if (state.t1 === undefined) state.t1 = true;
          if (state.t2 === undefined) state.t2 = false;
          container.innerHTML = `
            <div class="sandbox-header">
              <span>Toggle Switch Sandbox</span>
            </div>
            <div class="sandbox-body">
              <div class="toggle-row ${state.t1 ? 'active' : ''}" id="tog1">
                <div class="toggle-pill"><div class="toggle-circle"></div></div>
                <span>开启网格端点自动吸附 (Snap to Grid)</span>
              </div>
              <div class="toggle-row ${state.t2 ? 'active' : ''}" id="tog2">
                <div class="toggle-pill"><div class="toggle-circle"></div></div>
                <span>实时光影法线着色管线 (Surface Normals)</span>
              </div>
            </div>
            <div class="sandbox-tip">
              现代胶囊药丸滑块，带平滑水平缓动位移与主题品牌强调色。
            </div>
          `;
          const t1 = container.querySelector('#tog1');
          const t2 = container.querySelector('#tog2');
          t1.onclick = () => {
            state.t1 = !state.t1;
            t1.classList.toggle('active', state.t1);
            document.getElementById('statResponse').textContent = `grid_snap: ${state.t1}`;
            showToast(`网格吸附已${state.t1 ? '开启' : '关闭'}`);
          };
          t2.onclick = () => {
            state.t2 = !state.t2;
            t2.classList.toggle('active', state.t2);
            document.getElementById('statResponse').textContent = `normals: ${state.t2}`;
            showToast(`法线着色已${state.t2 ? '开启' : '关闭'}`);
          };
        }
      },

      radio: {
        title: "Radio 单选按钮",
        signature: "ui.radio(label, is_selected)",
        code: `///|
/// 单选按钮互斥交互 (Radio)
pub fn draw_radio(ui : @core.UIContext, state : AppState) -> Unit {
  let (s1, r1) = ui.radio("极简白昼 (Studio Light)", state.theme == 0)
  if r1.clicked { state.theme = 0 }

  let (s2, r2) = ui.radio("太空银灰 (Slate Gray)", state.theme == 1)
  if r2.clicked { state.theme = 1 }

  let (s3, r3) = ui.radio("高对比黑白 (High Contrast)", state.theme == 2)
  if r3.clicked { state.theme = 2 }
}`,
        renderUI: (container, state) => {
          if (state.radioIdx === undefined) state.radioIdx = 0;
          const opts = ["极简白昼", "太空银灰", "高对比度"];
          container.innerHTML = `
            <div class="sandbox-header">
              <span>Radio Group Sandbox</span>
            </div>
            <div class="sandbox-body">
              ${opts.map((opt, i) => `
                <div class="checkbox-row radio-row ${state.radioIdx === i ? 'active' : ''}" data-idx="${i}">
                  <div class="radio-circle"><span class="radio-dot"></span></div>
                  <span>${opt}</span>
                </div>
              `).join('')}
            </div>
            <div class="sandbox-tip">
              同组内单项互斥点选，支持键盘轮转与双圈缩放动效。
            </div>
          `;
          container.querySelectorAll('.radio-row').forEach(row => {
            row.onclick = () => {
              const idx = parseInt(row.getAttribute('data-idx'));
              state.radioIdx = idx;
              container.querySelectorAll('.radio-row').forEach(r => r.classList.remove('active'));
              row.classList.add('active');
              document.getElementById('statResponse').textContent = `theme: ${idx}`;
            };
          });
        }
      },

      slider: {
        title: "Slider 滑动条",
        signature: "ui.slider / ui.slider_int",
        code: `///|
/// 连续浮点与离散整型滑动条
pub fn draw_slider(ui : @core.UIContext, state : AppState) -> Unit {
  // 1. 浮点连续缩放 (0.1 ~ 5.0)
  let (scale, res1) = ui.slider(state.scale, min=0.1, max=5.0)
  if res1.changed { state.scale = scale }

  // 2. 离散整型步进 (15 ~ 120 FPS)
  let (fps, res2) = ui.slider_int(state.fps, min=15, max=120)
  if res2.changed { state.fps = fps }
}`,
        renderUI: (container, state) => {
          if (state.sliderVal === undefined) state.sliderVal = 50;
          container.innerHTML = `
            <div class="sandbox-header">
              <span>Slider Sandbox</span>
              <span id="sliderDisplay">${state.sliderVal}%</span>
            </div>
            <div class="sandbox-body">
              <div class="slider-track" id="sTrack">
                <div class="slider-fill" id="sFill" style="width: ${state.sliderVal}%;"></div>
                <div class="slider-thumb" id="sThumb" style="left: ${state.sliderVal}%;"></div>
              </div>
            </div>
            <div class="sandbox-tip">
              支持连续浮点数拖拽或离散整数吸附步进。
            </div>
          `;
          const track = container.querySelector('#sTrack');
          const fill = container.querySelector('#sFill');
          const thumb = container.querySelector('#sThumb');
          const display = container.querySelector('#sliderDisplay');

          const update = (e) => {
            const rect = track.getBoundingClientRect();
            let p = Math.round(((e.clientX - rect.left) / rect.width) * 100);
            p = Math.max(0, Math.min(100, p));
            state.sliderVal = p;
            fill.style.width = p + '%';
            thumb.style.left = p + '%';
            display.textContent = p + '%';
            document.getElementById('statResponse').textContent = `value: ${p}%`;
          };

          let dragging = false;
          track.onmousedown = (e) => {
            dragging = true;
            update(e);
            window.addEventListener('mousemove', onMove);
            window.addEventListener('mouseup', onUp);
          };
          function onMove(e) { if (dragging) update(e); }
          function onUp() {
            dragging = false;
            window.removeEventListener('mousemove', onMove);
            window.removeEventListener('mouseup', onUp);
          }
        }
      },

      drag_value: {
        title: "DragValue 数字微调器",
        signature: "ui.drag_value(label, val, speed=..., min=..., max=...)",
        code: `///|
/// 紧凑型数字拖动调节器 (DragValue)
pub fn draw_drag_values(ui : @core.UIContext, state : AppState) -> Unit {
  // 按住鼠标水平拖动即可平滑步进数值，占用面积比 Slider 小 70%
  let (x, _) = ui.drag_value("坐标 X", state.pos_x, speed=0.5, min=-1000.0, max=1000.0)
  let (y, _) = ui.drag_value("坐标 Y", state.pos_y, speed=0.5, min=-1000.0, max=1000.0)
  let (scale, _) = ui.drag_value("几何缩放", state.scale, speed=0.05, min=0.1, max=10.0)
}`,
        renderUI: (container, state) => {
          if (state.dx === undefined) state.dx = 120.0;
          if (state.dy === undefined) state.dy = 80.0;
          if (state.dscale === undefined) state.dscale = 1.25;

          container.innerHTML = `
            <div class="sandbox-header">
              <span>DragValue Sandbox</span>
            </div>
            <div class="sandbox-body">
              <div class="dragval-row">
                <span>图元空间世界坐标 X</span>
                <div class="dragval-box" id="dvX" title="按住左右拖动调节">
                  <span class="dragval-arrows">◀</span>
                  <span id="dvXVal">${state.dx.toFixed(1)}</span>
                  <span class="dragval-arrows">▶</span>
                </div>
              </div>
              <div class="dragval-row">
                <span>图元空间世界坐标 Y</span>
                <div class="dragval-box" id="dvY" title="按住左右拖动调节">
                  <span class="dragval-arrows">◀</span>
                  <span id="dvYVal">${state.dy.toFixed(1)}</span>
                  <span class="dragval-arrows">▶</span>
                </div>
              </div>
              <div class="dragval-row">
                <span>全局拓扑缩放比例</span>
                <div class="dragval-box" id="dvScale" title="按住左右拖动调节">
                  <span class="dragval-arrows">◀</span>
                  <span id="dvScaleVal">${state.dscale.toFixed(2)}x</span>
                  <span class="dragval-arrows">▶</span>
                </div>
              </div>
            </div>
            <div class="sandbox-tip">
              egui 标志性数值微调控件：按住数字方块左右滑动即可无极步进，极其紧凑。
            </div>
          `;

          const setupDrag = (el, valEl, key, speed, min, max, suffix = '') => {
            let isDragging = false;
            let startX = 0;
            let startVal = state[key];

            const onDown = (e) => {
              isDragging = true;
              startX = e.clientX || (e.touches && e.touches[0].clientX);
              startVal = state[key];
              el.classList.add('is-dragging');
              window.addEventListener('mousemove', onMove);
              window.addEventListener('mouseup', onUp);
              window.addEventListener('touchmove', onTouch, { passive: false });
              window.addEventListener('touchend', onUp);
              e.preventDefault();
            };

            const updateDelta = (clientX) => {
              const dx = clientX - startX;
              let nv = startVal + dx * speed;
              if (min !== undefined && nv < min) nv = min;
              if (max !== undefined && nv > max) nv = max;
              state[key] = parseFloat(nv.toFixed(2));
              valEl.textContent = (key === 'dscale' ? state[key].toFixed(2) : state[key].toFixed(1)) + suffix;
              document.getElementById('statResponse').textContent = `${key}: ${state[key]}`;
            };

            const onMove = (e) => { if (isDragging) updateDelta(e.clientX); };
            const onTouch = (e) => { if (isDragging && e.touches && e.touches[0]) updateDelta(e.touches[0].clientX); };
            const onUp = () => {
              if (!isDragging) return;
              isDragging = false;
              el.classList.remove('is-dragging');
              window.removeEventListener('mousemove', onMove);
              window.removeEventListener('mouseup', onUp);
              window.removeEventListener('touchmove', onTouch);
              window.removeEventListener('touchend', onUp);
            };

            el.addEventListener('mousedown', onDown);
            el.addEventListener('touchstart', onDown, { passive: false });
          };

          setupDrag(container.querySelector('#dvX'), container.querySelector('#dvXVal'), 'dx', 0.5, -1000, 1000);
          setupDrag(container.querySelector('#dvY'), container.querySelector('#dvYVal'), 'dy', 0.5, -1000, 1000);
          setupDrag(container.querySelector('#dvScale'), container.querySelector('#dvScaleVal'), 'dscale', 0.02, 0.1, 10.0, 'x');
        }
      },

      combo_box: {
        title: "ComboBox 下拉选择框",
        signature: "ui.combo_box(id, label, idx, opts)",
        code: `///|
/// 下拉选择框 (ComboBox)
pub fn draw_combo_box(ui : @core.UIContext, state : AppState) -> Unit {
  let formats = ["PNG 无损位图", "SVG 矢量图形", "WebP 高压缩率", "PDF 文档格式"]
  let (selected_idx, res) = ui.combo_box(
    "export_format",
    "导出文件类型",
    state.format_idx,
    formats,
  )
  if res.changed {
    state.format_idx = selected_idx
  }
}`,
        renderUI: (container, state) => {
          if (state.comboIdx === undefined) state.comboIdx = 0;
          const opts = ["PNG 无损位图", "SVG 矢量图形", "WebP 高压缩率", "PDF 文档格式"];
          container.innerHTML = `
            <div class="sandbox-header">
              <span>ComboBox Sandbox</span>
            </div>
            <div class="sandbox-body">
              <select class="input-box" id="comboSelect">
                ${opts.map((o, i) => `<option value="${i}" ${i === state.comboIdx ? 'selected' : ''}>${o}</option>`).join('')}
              </select>
            </div>
            <div class="sandbox-tip">
              紧凑型下拉菜单，支持选项高亮与即时模式状态反馈。
            </div>
          `;
          const sel = container.querySelector('#comboSelect');
          sel.onchange = () => {
            state.comboIdx = parseInt(sel.value);
            document.getElementById('statResponse').textContent = `selected: ${opts[state.comboIdx]}`;
          };
        }
      },

      color_button: {
        title: "ColorButton 调色板",
        signature: "ui.color_button(id, color)",
        code: `///|
/// 颜色选择与色块预览按钮 (ColorButton)
pub fn draw_colors(ui : @core.UIContext, state : AppState) -> Unit {
  // 1. 图元描边色
  let (clicked_stroke, _) = ui.color_button("stroke_col", state.stroke_color)

  // 2. 图元内部填充色
  let (clicked_fill, _) = ui.color_button("fill_col", state.fill_color)
}`,
        renderUI: (container, state) => {
          if (state.strokeCol === undefined) state.strokeCol = '#2563eb';
          if (state.fillCol === undefined) state.fillCol = '#eff6ff';

          const palette = ['#2563eb', '#10b981', '#f59e0b', '#ef4444', '#8b5cf6', '#0f172a'];

          container.innerHTML = `
            <div class="sandbox-header">
              <span>Color Swatch Sandbox</span>
            </div>
            <div class="sandbox-body">
              <div class="color-picker-row">
                <div class="color-swatch-btn" id="strokeSwatch" style="background: ${state.strokeCol};" title="点击选择描边色"></div>
                <div style="flex: 1;">
                  <div style="font-size: 13px; font-weight: 600; color: var(--text-main); margin-bottom: 4px;">图元描边颜色 (Stroke)</div>
                  <div class="color-palette-grid" id="strokePalette">
                    ${palette.map(c => `<div class="palette-item" style="background: ${c};" data-col="${c}"></div>`).join('')}
                  </div>
                </div>
              </div>
              <div class="color-picker-row" style="margin-top: 16px;">
                <div class="color-swatch-btn" id="fillSwatch" style="background: ${state.fillCol};" title="点击选择填充色"></div>
                <div style="flex: 1;">
                  <div style="font-size: 13px; font-weight: 600; color: var(--text-main); margin-bottom: 4px;">图元几何填充 (Fill)</div>
                  <div class="color-palette-grid" id="fillPalette">
                    ${['#eff6ff', '#ecfdf5', '#fffbeb', '#fef2f2', '#faf5ff', '#ffffff'].map(c => `<div class="palette-item" style="background: ${c};" data-col="${c}"></div>`).join('')}
                  </div>
                </div>
              </div>
            </div>
            <div class="sandbox-tip">
              CAD 图元色彩选择核心控件，支持色块即时响应与快速调色板拾取。
            </div>
          `;

          const strokeSwatch = container.querySelector('#strokeSwatch');
          const fillSwatch = container.querySelector('#fillSwatch');

          container.querySelectorAll('#strokePalette .palette-item').forEach(item => {
            item.onclick = () => {
              state.strokeCol = item.getAttribute('data-col');
              strokeSwatch.style.background = state.strokeCol;
              document.getElementById('statResponse').textContent = `stroke: ${state.strokeCol}`;
              showToast(`已更换描边颜色: ${state.strokeCol}`);
            };
          });

          container.querySelectorAll('#fillPalette .palette-item').forEach(item => {
            item.onclick = () => {
              state.fillCol = item.getAttribute('data-col');
              fillSwatch.style.background = state.fillCol;
              document.getElementById('statResponse').textContent = `fill: ${state.fillCol}`;
              showToast(`已更换填充颜色: ${state.fillCol}`);
            };
          });
        }
      },

      progress_bar: {
        title: "ProgressBar 进度条",
        signature: "ui.progress_bar(fraction, text)",
        code: `///|
/// 进度指示条展示 (ProgressBar)
pub fn draw_progress_bar(ui : @core.UIContext, state : AppState) -> Unit {
  // 数值范围自动 Clamp 限制在 0.0 ~ 1.0
  ui.progress_bar(
    fraction=state.progress,
    text="渲染管线就绪: \{state.progress * 100}%",
  )
}`,
        renderUI: (container, state) => {
          if (state.prog === undefined) state.prog = 65;
          container.innerHTML = `
            <div class="sandbox-header">
              <span>ProgressBar Sandbox</span>
              <button class="mini-btn" id="simProgBtn">模拟加载 ▶</button>
            </div>
            <div class="sandbox-body">
              <div class="prog-track">
                <div class="prog-fill" id="pFill" style="width: ${state.prog}%;"></div>
                <div class="prog-text" id="pText">进度: ${state.prog}%</div>
              </div>
            </div>
            <div class="sandbox-tip">
              数值范围受 Clamp 保护，支持居中文本说明与动态动画。
            </div>
          `;
          const btn = container.querySelector('#simProgBtn');
          const fill = container.querySelector('#pFill');
          const text = container.querySelector('#pText');

          let timer = null;
          btn.onclick = () => {
            if (timer) clearInterval(timer);
            state.prog = 0;
            timer = setInterval(() => {
              state.prog += 2;
              if (state.prog > 100) {
                state.prog = 100;
                clearInterval(timer);
                showToast('加载已完成！');
              }
              fill.style.width = state.prog + '%';
              text.textContent = `进度: ${state.prog}%`;
              document.getElementById('statResponse').textContent = `prog: ${state.prog}%`;
            }, 30);
          };
        }
      },

      collapsing_header: {
        title: "CollapsingHeader 折叠树",
        signature: "ui.collapsing_header(id, title, ...)",
        code: `///|
/// 可折叠分组与树节点
pub fn draw_collapsing(ui : @core.UIContext, state : AppState) -> Unit {
  ui.collapsing_header("render_advanced", "高级渲染参数", default_open=true, fn(ui) {
    let (msaa, _) = ui.checkbox("开启 4x MSAA 抗锯齿", state.msaa)
    let (shadows, _) = ui.checkbox("启用高精度阴影映射", state.shadows)
  })
}`,
        renderUI: (container, state) => {
          if (state.open === undefined) state.open = true;
          container.innerHTML = `
            <div class="sandbox-header">
              <span>Collapsing Tree Sandbox</span>
            </div>
            <div class="sandbox-body" style="border: 1px solid var(--border); border-radius: 6px; overflow: hidden;">
              <div style="background: var(--bg-subtle); padding: 8px 12px; cursor: pointer; display: flex; align-items: center; gap: 8px; font-size: 13px; font-weight: 600;" id="treeToggle">
                <span id="treeArrow">${state.open ? '▼' : '▶'}</span>
                <span>高级图形光栅化参数</span>
              </div>
              <div id="treeContent" style="padding: 12px; display: ${state.open ? 'block' : 'none'};">
                <div class="checkbox-row checked">
                  <div class="checkbox-sq"><svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="3"><polyline points="20 6 9 17 4 12"/></svg></div>
                  <span>四倍超采样抗锯齿 (4x MSAA)</span>
                </div>
                <div class="checkbox-row">
                  <div class="checkbox-sq"></div>
                  <span>各向异性过滤 (Anisotropic 16x)</span>
                </div>
              </div>
            </div>
            <div class="sandbox-tip" style="margin-top: 12px;">
              即时模式树节点，支持旋转箭头指示符与子控件嵌套缩进。
            </div>
          `;
          const toggle = container.querySelector('#treeToggle');
          const arrow = container.querySelector('#treeArrow');
          const content = container.querySelector('#treeContent');
          toggle.onclick = () => {
            state.open = !state.open;
            arrow.textContent = state.open ? '▼' : '▶';
            content.style.display = state.open ? 'block' : 'none';
            document.getElementById('statResponse').textContent = `tree_open: ${state.open}`;
          };
        }
      },

      tooltip: {
        title: "Tooltip 悬浮提示",
        signature: "ui.tooltip(text) / response.hovered",
        code: `///|
/// 悬停气泡提示 (Tooltip)
pub fn draw_tooltips(ui : @core.UIContext, state : AppState) -> Unit {
  let res_export = ui.button("导出 CAD 实体")
  if res_export.hovered {
    ui.tooltip("支持导出 DXF、STEP 及高精度无损 SVG 矢量路径")
  }

  let res_mesh = ui.button("重构曲面网格")
  if res_mesh.hovered {
    ui.tooltip("基于四边形 Delaunay 剖分重新生成三角面片")
  }
}`,
        renderUI: (container, state) => {
          container.innerHTML = `
            <div class="sandbox-header">
              <span>Tooltip Bubble Sandbox</span>
            </div>
            <div class="sandbox-body">
              <div class="widget-row" style="gap: 16px; padding: 20px 0;">
                <div class="tooltip-target-card">
                  <button class="btn-primary">导出 CAD 实体</button>
                  <div class="tooltip-bubble">支持导出 DXF、STEP 及高精度无损 SVG 矢量路径</div>
                </div>
                <div class="tooltip-target-card">
                  <button class="btn-secondary">重构曲面网格</button>
                  <div class="tooltip-bubble">基于四边形 Delaunay 剖分重新生成三角面片</div>
                </div>
              </div>
            </div>
            <div class="sandbox-tip">
              把鼠标移到上方按钮上：悬停即刻浮现顶层深色气泡提示，带指引小三角。
            </div>
          `;
          container.querySelectorAll('.btn-primary, .btn-secondary').forEach(btn => {
            btn.onmouseenter = () => {
              document.getElementById('statResponse').textContent = `tooltip: active [${btn.textContent}]`;
            };
            btn.onmouseleave = () => {
              document.getElementById('statResponse').textContent = `tooltip: inactive`;
            };
          });
        }
      },

      tab_bar: {
        title: "TabBar 标签导航",
        signature: "ui.tab_bar(id, tabs, selected_idx)",
        code: `///|
/// 多标签页分段切换 (TabBar)
pub fn draw_tabs(ui : @core.UIContext, state : AppState) -> Unit {
  let tabs = ["图元属性", "视口光照", "图层拓扑", "渲染输出"]
  let (active_tab, res) = ui.tab_bar("panel_tabs", tabs, state.tab_idx)
  if res.changed {
    state.tab_idx = active_tab
  }
}`,
        renderUI: (container, state) => {
          if (state.tabIdx === undefined) state.tabIdx = 0;
          const tabs = ["图元属性", "视口光照", "图层拓扑", "渲染输出"];
          const panels = [
            "【图元属性】CAD 贝塞尔曲线 (阶数: 3, 控制点: 16, 封闭: 是)",
            "【视口光照】环境光遮蔽 AO: 85%, 方向光源: (0.5, 1.0, 0.2), 阴影级别: 4K",
            "【图层拓扑】Layer_0 (基础图元), Layer_1 (尺寸标注), Layer_2 (约束辅助线)",
            "【渲染输出】视口格式: 32-bit HDR, 抗锯齿: 8x MSAA, 输出分辨率: 3840x2160"
          ];

          container.innerHTML = `
            <div class="sandbox-header">
              <span>TabBar Sandbox</span>
            </div>
            <div class="sandbox-body">
              <div class="tabbar-container">
                ${tabs.map((t, i) => `
                  <button class="tabbar-item ${state.tabIdx === i ? 'active' : ''}" data-idx="${i}">
                    ${t}
                  </button>
                `).join('')}
              </div>
              <div style="background: var(--bg-subtle); border: 1px solid var(--border); border-radius: 6px; padding: 14px; font-size: 13px; color: var(--text-main); font-family: 'JetBrains Mono', monospace;" id="tabContent">
                ${panels[state.tabIdx]}
              </div>
            </div>
            <div class="sandbox-tip">
              水平紧凑分段标签导航，单帧返回当前激活索引与即时内容联动。
            </div>
          `;

          const content = container.querySelector('#tabContent');
          container.querySelectorAll('.tabbar-item').forEach(btn => {
            btn.onclick = () => {
              const idx = parseInt(btn.getAttribute('data-idx'));
              state.tabIdx = idx;
              container.querySelectorAll('.tabbar-item').forEach(b => b.classList.remove('active'));
              btn.classList.add('active');
              content.textContent = panels[idx];
              document.getElementById('statResponse').textContent = `active_tab: [${idx}] ${tabs[idx]}`;
              showToast(`已切换至「${tabs[idx]}」标签`);
            };
          });
        }
      },

      scroll_area: {
        title: "ScrollArea 视口滚动容器",
        signature: "ui.scroll_area(id, width, height, ...)",
        code: `///|
/// 视口滚动容器与 Scissor 剪裁
pub fn draw_scroll_area(ui : @core.UIContext, state : AppState) -> Unit {
  ui.scroll_area("terminal_logs", width=360.0, height=200.0, fn(ui) {
    for i = 0; i < 30; i = i + 1 {
      ui.label("Frame [\{i}]: 渲染指令已分发 -> Scissor Clip OK")
    }
  })
}`,
        renderUI: (container, state) => {
          container.innerHTML = `
            <div class="sandbox-header">
              <span>ScrollArea with Scissor Clip</span>
            </div>
            <div class="sandbox-body">
              <div style="width: 100%; height: 140px; background: #ffffff; border: 1px solid var(--border); border-radius: 6px; overflow-y: auto; padding: 10px; font-family: 'JetBrains Mono', monospace; font-size: 11px; line-height: 1.6; color: var(--text-sub);" id="sBox">
                ${Array.from({length: 20}, (_, i) => `<div>[Render_Pass_${i + 1}] Scissor Clip Rect OK</div>`).join('')}
              </div>
            </div>
            <div class="sandbox-tip">
              视口内由相交几何剪裁保护，内容不溢出边框。
            </div>
          `;
          const sBox = container.querySelector('#sBox');
          sBox.onscroll = () => {
            document.getElementById('statResponse').textContent = `scrollTop: ${Math.round(sBox.scrollTop)}px`;
          };
        }
      },

      window: {
        title: "Window 浮动面板",
        signature: "ui.window(id, title, ...)",
        code: `///|
/// 浮动窗口面板容器 (Window)
pub fn draw_window(ui : @core.UIContext, state : AppState) -> Unit {
  ui.window("debug_inspector", "图元属性检查器", fn(ui) {
    ui.label("当前选中对象: CAD 贝塞尔曲线")
    let (w, _) = ui.slider(state.curve_width, min=1.0, max=10.0)
    let (closed, _) = ui.checkbox("闭合路径", state.curve_closed)
  })
}`,
        renderUI: (container, state) => {
          if (state.winX === undefined) state.winX = 0;
          if (state.winY === undefined) state.winY = 0;
          if (state.curveWidth === undefined) state.curveWidth = 4.5;
          if (state.closedPath === undefined) state.closedPath = true;

          container.innerHTML = `
            <div class="draggable-window-card" id="winCard" style="transform: translate(${state.winX}px, ${state.winY}px);">
              <span id="winStatusText" style="display: none;"></span>
              <div class="win-titlebar" id="winTitleBar">
                <div class="win-titlebar-left">
                  <div class="win-dots">
                    <span class="win-dot-mini" style="background: #cbd5e1;"></span>
                    <span class="win-dot-mini" style="background: #cbd5e1;"></span>
                    <span class="win-dot-mini" style="background: #cbd5e1;"></span>
                  </div>
                  <span class="win-title-text">图元属性检查器 (Inspector)</span>
                </div>
                <span class="win-drag-cue" id="winDragCue">
                  <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M5 9l-3 3 3 3M9 5l3-3 3 3M15 19l-3 3-3-3M19 9l3 3-3 3M2 12h20M12 2v20"/></svg>
                  按住标题栏拖拽
                </span>
              </div>
              <div class="win-body">
                <div class="win-coord-badge">
                  坐标空间: <b id="winCoordText">世界坐标 (X: ${Math.round(120 + state.winX)}, Y: ${Math.round(80 + state.winY)})</b>
                </div>
                <div style="margin-bottom: 12px; font-size: 13px; color: var(--text-main);">
                  当前图元: <b>CAD 贝塞尔样条曲面</b>
                </div>
                <div style="margin-bottom: 12px;">
                  <div style="display: flex; justify-content: space-between; font-size: 12px; color: var(--text-sub); margin-bottom: 4px;">
                    <span>曲线采样线宽</span>
                    <b id="winSliderVal">${state.curveWidth} px</b>
                  </div>
                  <div class="slider-track" id="winSliderTrack">
                    <div class="slider-fill" id="winSliderFill" style="width: ${(state.curveWidth / 10) * 100}%;"></div>
                    <div class="slider-thumb" id="winSliderThumb" style="left: ${(state.curveWidth / 10) * 100}%;"></div>
                  </div>
                </div>
                <div class="checkbox-row ${state.closedPath ? 'checked' : ''}" id="winClosedCheck" style="margin-bottom: 14px;">
                  <div class="checkbox-sq">
                    <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="3"><polyline points="20 6 9 17 4 12"/></svg>
                  </div>
                  <span>闭合多边形路径 (Closed Loop)</span>
                </div>
                <div style="display: flex; align-items: center; gap: 8px;">
                  <button class="mini-btn" id="winResetBtn">重置位置</button>
                  <button class="btn-primary" style="padding: 6px 14px; font-size: 12px;" id="winFocusBtn">聚焦检查器</button>
                </div>
              </div>
            </div>
            <div class="sandbox-tip" style="margin-top: 14px;">
              按住上方浅灰标题栏可在画板中自由拖拽；窗口内部子控件（滑动条、复选框）均支持即时模式实时响应。
            </div>
          `;

          const winCard = container.querySelector('#winCard');
          const titleBar = container.querySelector('#winTitleBar');
          const dragCue = container.querySelector('#winDragCue');
          const coordText = container.querySelector('#winCoordText');
          const statusText = container.querySelector('#winStatusText');
          const resetBtn = container.querySelector('#winResetBtn');
          const focusBtn = container.querySelector('#winFocusBtn');
          const closedCheck = container.querySelector('#winClosedCheck');
          const sliderTrack = container.querySelector('#winSliderTrack');
          const sliderFill = container.querySelector('#winSliderFill');
          const sliderThumb = container.querySelector('#winSliderThumb');
          const sliderVal = container.querySelector('#winSliderVal');

          // Slider inside window
          let isSliding = false;
          const updateSlider = (e) => {
            const rect = sliderTrack.getBoundingClientRect();
            let p = Math.max(0, Math.min(1, (e.clientX - rect.left) / rect.width));
            state.curveWidth = parseFloat((p * 10).toFixed(1));
            if (state.curveWidth < 0.5) state.curveWidth = 0.5;
            sliderFill.style.width = (state.curveWidth * 10) + '%';
            sliderThumb.style.left = (state.curveWidth * 10) + '%';
            sliderVal.textContent = state.curveWidth + ' px';
            document.getElementById('statResponse').textContent = `curve_width: ${state.curveWidth}`;
          };
          sliderTrack.onmousedown = (e) => {
            isSliding = true;
            updateSlider(e);
            window.addEventListener('mousemove', onSlideMove);
            window.addEventListener('mouseup', onSlideUp);
          };
          function onSlideMove(e) { if (isSliding) updateSlider(e); }
          function onSlideUp() {
            isSliding = false;
            window.removeEventListener('mousemove', onSlideMove);
            window.removeEventListener('mouseup', onSlideUp);
          }

          // Checkbox inside window
          closedCheck.onclick = () => {
            state.closedPath = !state.closedPath;
            closedCheck.classList.toggle('checked', state.closedPath);
            document.getElementById('statResponse').textContent = `closed_path: ${state.closedPath}`;
          };

          // Focus button
          focusBtn.onclick = () => {
            winCard.style.boxShadow = '0 0 0 3px rgba(37, 99, 235, 0.35), 0 16px 32px rgba(15, 23, 42, 0.12)';
            showToast('已聚焦图元检查器窗口');
            setTimeout(() => {
              winCard.style.boxShadow = '';
            }, 1000);
          };

          // Drag Window Logic
          let isWinDragging = false;
          let startX = 0, startY = 0;

          function setWinPos(x, y) {
            state.winX = x;
            state.winY = y;
            winCard.style.transform = `translate(${x}px, ${y}px)`;
            const wx = Math.round(120 + x);
            const wy = Math.round(80 + y);
            coordText.textContent = `世界坐标 (X: ${wx}, Y: ${wy})`;
            document.getElementById('statResponse').textContent = `window_pos: (X: ${wx}, Y: ${wy})`;
          }

          function onWinMouseDown(e) {
            if (e.target.closest('button') || e.target.closest('input')) return;
            isWinDragging = true;
            winCard.classList.add('is-dragging');
            dragCue.textContent = '拖拽中...';
            statusText.textContent = '● 正在位移';
            statusText.style.color = 'var(--brand)';
            const clientX = e.touches ? e.touches[0].clientX : e.clientX;
            const clientY = e.touches ? e.touches[0].clientY : e.clientY;
            startX = clientX - state.winX;
            startY = clientY - state.winY;

            window.addEventListener('mousemove', onWinMouseMove);
            window.addEventListener('mouseup', onWinMouseUp);
            window.addEventListener('touchmove', onWinTouchMove, { passive: false });
            window.addEventListener('touchend', onWinMouseUp);
            e.preventDefault();
          }

          function onWinMouseMove(e) {
            if (!isWinDragging) return;
            let nx = e.clientX - startX;
            let ny = e.clientY - startY;
            // Bound clamping so window stays gracefully on stage
            nx = Math.max(-180, Math.min(180, nx));
            ny = Math.max(-90, Math.min(90, ny));
            setWinPos(nx, ny);
          }

          function onWinTouchMove(e) {
            if (!isWinDragging || !e.touches || !e.touches[0]) return;
            let nx = e.touches[0].clientX - startX;
            let ny = e.touches[0].clientY - startY;
            nx = Math.max(-180, Math.min(180, nx));
            ny = Math.max(-90, Math.min(90, ny));
            setWinPos(nx, ny);
            e.preventDefault();
          }

          function onWinMouseUp() {
            if (!isWinDragging) return;
            isWinDragging = false;
            winCard.classList.remove('is-dragging');
            dragCue.innerHTML = '<svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M5 9l-3 3 3 3M9 5l3-3 3 3M15 19l-3 3-3-3M19 9l3 3-3 3M2 12h20M12 2v20"/></svg> 按住标题栏拖拽';
            statusText.textContent = '● 自由浮动';
            statusText.style.color = '';
            window.removeEventListener('mousemove', onWinMouseMove);
            window.removeEventListener('mouseup', onWinMouseUp);
            window.removeEventListener('touchmove', onWinTouchMove);
            window.removeEventListener('touchend', onWinMouseUp);
            showToast(`浮动窗口已定位到 X: ${Math.round(120 + state.winX)}, Y: ${Math.round(80 + state.winY)}`);
          }

          titleBar.addEventListener('mousedown', onWinMouseDown);
          titleBar.addEventListener('touchstart', onWinMouseDown, { passive: false });

          // Reset Button
          resetBtn.onclick = () => {
            winCard.style.transition = 'transform 0.3s cubic-bezier(0.16, 1, 0.3, 1)';
            setWinPos(0, 0);
            setTimeout(() => {
              winCard.style.transition = '';
            }, 320);
            showToast('已重置浮动窗口位置至原点');
          };
        }
      }
    };

    // State
