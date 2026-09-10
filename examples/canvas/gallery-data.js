// Registry of Components with Code & Interactive Demo
// Language note: user-facing strings go through T(zh, en) so a language switch
// only needs a re-render; component titles live in the i18n dictionary and are
// referenced by `titleKey` so the sidebar and the workbench header never drift.
    const COMPONENTS = {
      button: {
        titleKey: 'comp.button.title',
        signature: "ui.button(text, shortcut~, primary~, size~) -> Response",
        code: {
          zh: `///|
pub fn draw_buttons(ui : @core.UIContext, state : AppState) -> Unit {
  // 主要按钮（支持快捷键）
  let res_primary = ui.button("提交", shortcut="⌘S", primary=true)
  if res_primary.clicked {
    state.count += 1
  }

  // 次要按钮
  let res_default = ui.button("重置", shortcut="Esc")
  if res_default.clicked {
    state.count = 0
  }

  // 自定义尺寸
  let res_sized = ui.button("自定义尺寸", size=Some(@math.Vec2::new(140.0, 36.0)))
}`,
          en: `///|
pub fn draw_buttons(ui : @core.UIContext, state : AppState) -> Unit {
  // primary button (with a keyboard shortcut)
  let res_primary = ui.button("Submit", shortcut="⌘S", primary=true)
  if res_primary.clicked {
    state.count += 1
  }

  // secondary button
  let res_default = ui.button("Reset", shortcut="Esc")
  if res_default.clicked {
    state.count = 0
  }

  // custom size
  let res_sized = ui.button("Custom size", size=Some(@math.Vec2::new(140.0, 36.0)))
}`
        },
        renderUI: (container, state) => {
          const countLabel = T('点击次数', 'Click count');
          container.innerHTML = `
            <div class="sandbox-header">
              <span>Button</span>
              <span>${countLabel}: ${state.count || 0}</span>
            </div>
            <div class="sandbox-body">
              <div class="widget-row">
                <button class="btn-primary" id="demoPrimaryBtn">${T('提交', 'Submit')} <kbd class="kbd-badge">⌘S</kbd></button>
                <button class="btn-secondary" id="demoDefaultBtn">${T('重置', 'Reset')} <kbd class="kbd-badge">Esc</kbd></button>
              </div>
            </div>
            <div class="sandbox-tip">
              ${T('支持快捷键：⌘S 提交，Esc 重置。', 'Keyboard shortcuts: ⌘S submits, Esc resets.')}
            </div>
          `;
          const pBtn = container.querySelector('#demoPrimaryBtn');
          const dBtn = container.querySelector('#demoDefaultBtn');

          const triggerPress = (btn, callback) => {
            btn.classList.add('is-pressed');
            setTimeout(() => btn.classList.remove('is-pressed'), 120);
            callback();
          };

          pBtn.onclick = () => {
            triggerPress(pBtn, () => {
              state.count = (state.count || 0) + 1;
              container.querySelector('.sandbox-header span:last-child').textContent = `${countLabel}: ${state.count}`;
              document.getElementById('statResponse').textContent = `clicked: true, count: ${state.count}`;
              showToast(T(`点击了主要按钮！计数: ${state.count}`, `Primary button clicked. Count: ${state.count}`));
            });
          };

          dBtn.onclick = () => {
            triggerPress(dBtn, () => {
              state.count = 0;
              container.querySelector('.sandbox-header span:last-child').textContent = `${countLabel}: 0`;
              document.getElementById('statResponse').textContent = `clicked: true, count: 0`;
              showToast(T('计数已清零', 'Counter reset to zero'));
            });
          };

          const keyHandler = (e) => {
            if ((e.metaKey || e.ctrlKey) && e.key.toLowerCase() === 's') {
              e.preventDefault();
              pBtn.click();
            } else if (e.key === 'Escape') {
              dBtn.click();
            }
          };
          window.addEventListener('keydown', keyHandler);
        }
      },

      text_edit: {
        titleKey: 'comp.text_edit.title',
        signature: "ui.text_edit(text, placeholder~) -> (String, Response)",
        code: {
          zh: `///|
pub fn draw_text_edit(ui : @core.UIContext, state : AppState) -> Unit {
  let (new_text, res) = ui.text_edit(
    state.username,
    placeholder="请输入用户名...",
  )
  if res.changed {
    state.username = new_text
  }
}`,
          en: `///|
pub fn draw_text_edit(ui : @core.UIContext, state : AppState) -> Unit {
  let (new_text, res) = ui.text_edit(
    state.username,
    placeholder="Enter a username...",
  )
  if res.changed {
    state.username = new_text
  }
}`
        },
        renderUI: (container, state) => {
          const val = state.inputText || "MoonBit";
          const lenLabel = T('字数', 'Characters');
          container.innerHTML = `
            <div class="sandbox-header">
              <span>TextEdit</span>
              <span>${lenLabel}: ${val.length}</span>
            </div>
            <div class="sandbox-body">
              <input type="text" class="input-box" id="demoTextInput" value="${val}" placeholder="${T('输入文本...', 'Type some text...')}" />
            </div>
            <div class="sandbox-tip">
              ${T('支持光标定位与文本输入。', 'Caret placement and text entry, exactly as typed.')}
            </div>
          `;
          const input = container.querySelector('#demoTextInput');
          input.oninput = (e) => {
            state.inputText = e.target.value;
            container.querySelector('.sandbox-header span:last-child').textContent = `${lenLabel}: ${state.inputText.length}`;
            document.getElementById('statResponse').textContent = `changed: true, len: ${state.inputText.length}`;
          };
        }
      },

      checkbox: {
        titleKey: 'comp.checkbox.title',
        signature: "ui.checkbox(label, is_checked) -> (Bool, Response)",
        code: {
          zh: `///|
pub fn draw_checkbox(ui : @core.UIContext, state : AppState) -> Unit {
  let (checked, res) = ui.checkbox("硬件加速", state.gpu)
  if res.changed {
    state.gpu = checked
  }

  let (vsync, res2) = ui.checkbox("垂直同步", state.vsync)
  if res2.changed {
    state.vsync = vsync
  }
}`,
          en: `///|
pub fn draw_checkbox(ui : @core.UIContext, state : AppState) -> Unit {
  let (checked, res) = ui.checkbox("Hardware acceleration", state.gpu)
  if res.changed {
    state.gpu = checked
  }

  let (vsync, res2) = ui.checkbox("Vertical sync", state.vsync)
  if res2.changed {
    state.vsync = vsync
  }
}`
        },
        renderUI: (container, state) => {
          if (state.chk1 === undefined) state.chk1 = true;
          if (state.chk2 === undefined) state.chk2 = false;
          container.innerHTML = `
            <div class="sandbox-header">
              <span>Checkbox</span>
            </div>
            <div class="sandbox-body">
              <div class="checkbox-row ${state.chk1 ? 'checked' : ''}" id="chk1">
                <div class="checkbox-sq">
                  <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="3"><polyline points="20 6 9 17 4 12"/></svg>
                </div>
                <span>${T('硬件加速', 'Hardware acceleration')}</span>
              </div>
              <div class="checkbox-row ${state.chk2 ? 'checked' : ''}" id="chk2">
                <div class="checkbox-sq">
                  <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="3"><polyline points="20 6 9 17 4 12"/></svg>
                </div>
                <span>${T('垂直同步', 'Vertical sync')}</span>
              </div>
            </div>
            <div class="sandbox-tip">
              ${T('点击切换勾选状态。', 'Click a row to toggle its state.')}
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
        titleKey: 'comp.toggle.title',
        signature: "ui.toggle(label, is_checked) -> (Bool, Response)",
        code: {
          zh: `///|
pub fn draw_toggles(ui : @core.UIContext, state : AppState) -> Unit {
  let (snap, res1) = ui.toggle("网格对齐", state.grid_snap)
  if res1.changed {
    state.grid_snap = snap
  }

  let (normals, res2) = ui.toggle("显示法线", state.normals)
  if res2.changed {
    state.normals = normals
  }
}`,
          en: `///|
pub fn draw_toggles(ui : @core.UIContext, state : AppState) -> Unit {
  let (snap, res1) = ui.toggle("Snap to grid", state.grid_snap)
  if res1.changed {
    state.grid_snap = snap
  }

  let (normals, res2) = ui.toggle("Show normals", state.normals)
  if res2.changed {
    state.normals = normals
  }
}`
        },
        renderUI: (container, state) => {
          if (state.t1 === undefined) state.t1 = true;
          if (state.t2 === undefined) state.t2 = false;
          const snapLabel = T('网格对齐', 'Snap to grid');
          const normalsLabel = T('显示法线', 'Show normals');
          container.innerHTML = `
            <div class="sandbox-header">
              <span>Toggle</span>
            </div>
            <div class="sandbox-body">
              <div class="toggle-row ${state.t1 ? 'active' : ''}" id="tog1">
                <div class="toggle-pill"><div class="toggle-circle"></div></div>
                <span>${snapLabel}</span>
              </div>
              <div class="toggle-row ${state.t2 ? 'active' : ''}" id="tog2">
                <div class="toggle-pill"><div class="toggle-circle"></div></div>
                <span>${normalsLabel}</span>
              </div>
            </div>
            <div class="sandbox-tip">
              ${T('点击切换开关状态。', 'Click a row to flip the switch.')}
            </div>
          `;
          const tog1 = container.querySelector('#tog1');
          const tog2 = container.querySelector('#tog2');

          const triggerToggle = (row, stateKey, label) => {
            state[stateKey] = !state[stateKey];
            row.classList.toggle('active', state[stateKey]);
            const pill = row.querySelector('.toggle-pill');
            if (pill) {
              pill.classList.add('is-stretching');
              setTimeout(() => pill.classList.remove('is-stretching'), 150);
            }
            const onOff = state[stateKey] ? T('开启', 'on') : T('关闭', 'off');
            document.getElementById('statResponse').textContent = `${label}: ${onOff}`;
          };

          tog1.onclick = () => triggerToggle(tog1, 't1', snapLabel);
          tog2.onclick = () => triggerToggle(tog2, 't2', normalsLabel);
        }
      },

      radio: {
        titleKey: 'comp.radio.title',
        signature: "ui.radio(label, is_selected) -> (Bool, Response)",
        code: {
          zh: `///|
pub fn draw_radio(ui : @core.UIContext, state : AppState) -> Unit {
  let (_, r1) = ui.radio("浅色模式", state.theme == 0)
  if r1.clicked { state.theme = 0 }

  let (_, r2) = ui.radio("深色模式", state.theme == 1)
  if r2.clicked { state.theme = 1 }

  let (_, r3) = ui.radio("跟随系统", state.theme == 2)
  if r3.clicked { state.theme = 2 }
}`,
          en: `///|
pub fn draw_radio(ui : @core.UIContext, state : AppState) -> Unit {
  let (_, r1) = ui.radio("Light", state.theme == 0)
  if r1.clicked { state.theme = 0 }

  let (_, r2) = ui.radio("Dark", state.theme == 1)
  if r2.clicked { state.theme = 1 }

  let (_, r3) = ui.radio("Follow the system", state.theme == 2)
  if r3.clicked { state.theme = 2 }
}`
        },
        renderUI: (container, state) => {
          if (state.radioIdx === undefined) state.radioIdx = 0;
          const opts = [T('浅色模式', 'Light'), T('深色模式', 'Dark'), T('跟随系统', 'Follow the system')];
          container.innerHTML = `
            <div class="sandbox-header">
              <span>Radio</span>
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
              ${T('单项互斥选择。', 'One selection at a time.')}
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
        titleKey: 'comp.slider.title',
        signature: "ui.slider(val, min~, max~) / ui.slider_int(val, min~, max~) -> (T, Response)",
        code: `///|
pub fn draw_slider(ui : @core.UIContext, state : AppState) -> Unit {
  let (scale, res1) = ui.slider(state.scale, min=0.1, max=5.0)
  if res1.changed { state.scale = scale }

  let (fps, res2) = ui.slider_int(state.fps, min=15, max=120)
  if res2.changed { state.fps = fps }
}`,
        renderUI: (container, state) => {
          if (state.sliderVal === undefined) state.sliderVal = 50;
          container.innerHTML = `
            <div class="sandbox-header">
              <span>Slider</span>
              <span id="sliderDisplay">${state.sliderVal}%</span>
            </div>
            <div class="sandbox-body">
              <div class="slider-track" id="sTrack">
                <div class="slider-ticks">
                  <div class="slider-tick" style="left: 25%;"></div>
                  <div class="slider-tick" style="left: 50%;"></div>
                  <div class="slider-tick" style="left: 75%;"></div>
                </div>
                <div class="slider-fill" id="sFill" style="width: ${state.sliderVal}%;"></div>
                <div class="slider-thumb" id="sThumb" style="left: ${state.sliderVal}%;">
                  <div class="slider-value-bubble" id="sBubble">${state.sliderVal}%</div>
                </div>
              </div>
            </div>
            <div class="sandbox-tip">
              ${T('拖动手柄调节数值。', 'Drag the handle to adjust the value.')}
            </div>
          `;
          const track = container.querySelector('#sTrack');
          const fill = container.querySelector('#sFill');
          const thumb = container.querySelector('#sThumb');
          const display = container.querySelector('#sliderDisplay');
          const bubble = container.querySelector('#sBubble');
          const ticks = container.querySelectorAll('.slider-tick');
          const detents = [25, 50, 75];

          const update = (e) => {
            const rect = track.getBoundingClientRect();
            let rawP = ((e.clientX - rect.left) / rect.width) * 100;
            let p = Math.round(Math.max(0, Math.min(100, rawP)));

            // Magnetic Detent within ±2.2%
            for (let d of detents) {
              if (Math.abs(rawP - d) <= 2.2) {
                p = d;
                break;
              }
            }

            // Highlight ticks when thumb is aligned
            ticks.forEach((tick, idx) => {
              const d = detents[idx];
              if (Math.abs(p - d) <= 1) {
                tick.classList.add('active');
              } else {
                tick.classList.remove('active');
              }
            });

            state.sliderVal = p;
            fill.style.width = p + '%';
            thumb.style.left = p + '%';
            display.textContent = p + '%';
            if (bubble) bubble.textContent = p + '%';
            document.getElementById('statResponse').textContent = `value: ${p}%`;
          };

          let dragging = false;
          track.onmousedown = (e) => {
            dragging = true;
            track.classList.add('is-active');
            update(e);
            window.addEventListener('mousemove', onMove);
            window.addEventListener('mouseup', onUp);
          };
          function onMove(e) { if (dragging) update(e); }
          function onUp() {
            dragging = false;
            track.classList.remove('is-active');
            window.removeEventListener('mousemove', onMove);
            window.removeEventListener('mouseup', onUp);
          }
        }
      },

      drag_value: {
        titleKey: 'comp.drag_value.title',
        signature: "ui.drag_value(label, val, speed~, min~, max~) -> (Double, Response)",
        code: {
          zh: `///|
pub fn draw_drag_values(ui : @core.UIContext, state : AppState) -> Unit {
  let (x, _) = ui.drag_value("X 坐标", state.pos_x, speed=0.5, min=-1000.0, max=1000.0)
  let (y, _) = ui.drag_value("Y 坐标", state.pos_y, speed=0.5, min=-1000.0, max=1000.0)
  let (scale, _) = ui.drag_value("缩放", state.scale, speed=0.05, min=0.1, max=10.0)
}`,
          en: `///|
pub fn draw_drag_values(ui : @core.UIContext, state : AppState) -> Unit {
  let (x, _) = ui.drag_value("X", state.pos_x, speed=0.5, min=-1000.0, max=1000.0)
  let (y, _) = ui.drag_value("Y", state.pos_y, speed=0.5, min=-1000.0, max=1000.0)
  let (scale, _) = ui.drag_value("Scale", state.scale, speed=0.05, min=0.1, max=10.0)
}`
        },
        renderUI: (container, state) => {
          if (state.dx === undefined) state.dx = 120.0;
          if (state.dy === undefined) state.dy = 80.0;
          if (state.dscale === undefined) state.dscale = 1.25;

          const xLabel = T('X 坐标', 'X');
          const yLabel = T('Y 坐标', 'Y');
          const scaleLabel = T('缩放比例', 'Scale');

          const getPct = (val, min, max) => {
            return Math.max(0, Math.min(100, ((val - min) / (max - min)) * 100)).toFixed(1);
          };

          container.innerHTML = `
            <div class="sandbox-header">
              <span>DragValue</span>
            </div>
            <div class="sandbox-body">
              <div class="dragval-row">
                <span>${xLabel}</span>
                <div class="dragval-box" id="dvX">
                  <div class="dragval-mercury" id="dvXMerk" style="width: ${getPct(state.dx, -1000, 1000)}%;"></div>
                  <div class="dragval-content">
                    <span class="dragval-arrows arrow-left">◀</span>
                    <span id="dvXVal">${state.dx.toFixed(1)}</span>
                    <span class="dragval-arrows arrow-right">▶</span>
                  </div>
                </div>
              </div>
              <div class="dragval-row">
                <span>${yLabel}</span>
                <div class="dragval-box" id="dvY">
                  <div class="dragval-mercury" id="dvYMerk" style="width: ${getPct(state.dy, -1000, 1000)}%;"></div>
                  <div class="dragval-content">
                    <span class="dragval-arrows arrow-left">◀</span>
                    <span id="dvYVal">${state.dy.toFixed(1)}</span>
                    <span class="dragval-arrows arrow-right">▶</span>
                  </div>
                </div>
              </div>
              <div class="dragval-row">
                <span>${scaleLabel}</span>
                <div class="dragval-box" id="dvScale">
                  <div class="dragval-mercury" id="dvScaleMerk" style="width: ${getPct(state.dscale, 0.1, 10.0)}%;"></div>
                  <div class="dragval-content">
                    <span class="dragval-arrows arrow-left">◀</span>
                    <span id="dvScaleVal">${state.dscale.toFixed(2)}x</span>
                    <span class="dragval-arrows arrow-right">▶</span>
                  </div>
                </div>
              </div>

              <div class="dragval-modifier-bar">
                <span>${T('修饰键:', 'Modifiers:')}</span>
                <span class="dragval-modifier-tag active" id="modNormal">${T('常规 1.0x', 'Normal 1.0x')}</span>
                <span class="dragval-modifier-tag" id="modShift">${T('Shift 0.1x 精细', 'Shift 0.1x fine')}</span>
                <span class="dragval-modifier-tag" id="modCtrl">${T('Ctrl/⌘ 10x 快速', 'Ctrl/⌘ 10x coarse')}</span>
              </div>
            </div>
            <div class="sandbox-tip">
              ${T('左右拖动调节数值。Shift 精调，Ctrl/⌘ 粗调。', 'Drag left or right to change the value. Hold Shift for fine steps, Ctrl/⌘ for coarse ones.')}
            </div>
          `;

          const tagNormal = container.querySelector('#modNormal');
          const tagShift = container.querySelector('#modShift');
          const tagCtrl = container.querySelector('#modCtrl');

          const updateModStatus = (shift, ctrl) => {
            if (shift) {
              tagNormal.classList.remove('active');
              tagShift.classList.add('active');
              tagCtrl.classList.remove('active');
            } else if (ctrl) {
              tagNormal.classList.remove('active');
              tagShift.classList.remove('active');
              tagCtrl.classList.add('active');
            } else {
              tagNormal.classList.add('active');
              tagShift.classList.remove('active');
              tagCtrl.classList.remove('active');
            }
          };

          const keyHandler = (e) => {
            updateModStatus(e.shiftKey, e.ctrlKey || e.metaKey);
          };
          window.addEventListener('keydown', keyHandler);
          window.addEventListener('keyup', keyHandler);

          const setupDrag = (el, valEl, merkEl, key, speed, min, max, suffix = '') => {
            let isDragging = false;
            let startX = 0;
            let startVal = state[key];

            const onDown = (e) => {
              isDragging = true;
              startX = e.clientX || (e.touches && e.touches[0].clientX);
              startVal = state[key];
              el.classList.add('is-dragging');
              updateModStatus(e.shiftKey, e.ctrlKey || e.metaKey);
              window.addEventListener('mousemove', onMove);
              window.addEventListener('mouseup', onUp);
              window.addEventListener('touchmove', onTouch, { passive: false });
              window.addEventListener('touchend', onUp);
              e.preventDefault();
            };

            const updateDelta = (clientX, shift, ctrl) => {
              const dx = clientX - startX;
              let mult = 1.0;
              if (shift) mult = 0.1;
              else if (ctrl) mult = 10.0;
              updateModStatus(shift, ctrl);

              if (dx > 2) {
                el.classList.add('push-right');
                el.classList.remove('push-left');
              } else if (dx < -2) {
                el.classList.add('push-left');
                el.classList.remove('push-right');
              } else {
                el.classList.remove('push-left', 'push-right');
              }

              let nv = startVal + dx * speed * mult;
              if (min !== undefined && nv < min) nv = min;
              if (max !== undefined && nv > max) nv = max;
              state[key] = parseFloat(nv.toFixed(2));
              valEl.textContent = (key === 'dscale' ? state[key].toFixed(2) : state[key].toFixed(1)) + suffix;
              if (merkEl) merkEl.style.width = getPct(state[key], min, max) + '%';
              document.getElementById('statResponse').textContent = `${key}: ${state[key]} (mult: ${mult}x)`;
            };

            const onMove = (e) => { if (isDragging) updateDelta(e.clientX, e.shiftKey, e.ctrlKey || e.metaKey); };
            const onTouch = (e) => { if (isDragging && e.touches && e.touches[0]) updateDelta(e.touches[0].clientX, false, false); };
            const onUp = () => {
              if (!isDragging) return;
              isDragging = false;
              el.classList.remove('is-dragging', 'push-left', 'push-right');
              updateModStatus(false, false);
              window.removeEventListener('mousemove', onMove);
              window.removeEventListener('mouseup', onUp);
              window.removeEventListener('touchmove', onTouch);
              window.removeEventListener('touchend', onUp);
            };

            el.addEventListener('mousedown', onDown);
            el.addEventListener('touchstart', onDown, { passive: false });
          };

          setupDrag(container.querySelector('#dvX'), container.querySelector('#dvXVal'), container.querySelector('#dvXMerk'), 'dx', 0.5, -1000, 1000);
          setupDrag(container.querySelector('#dvY'), container.querySelector('#dvYVal'), container.querySelector('#dvYMerk'), 'dy', 0.5, -1000, 1000);
          setupDrag(container.querySelector('#dvScale'), container.querySelector('#dvScaleVal'), container.querySelector('#dvScaleMerk'), 'dscale', 0.02, 0.1, 10.0, 'x');
        }
      },

      combo_box: {
        titleKey: 'comp.combo_box.title',
        signature: "ui.combo_box(id, label, selected_idx, options) -> (Int, Response)",
        code: {
          zh: `///|
pub fn draw_combo_box(ui : @core.UIContext, state : AppState) -> Unit {
  let formats = ["PNG", "SVG", "WebP", "PDF"]
  let (selected_idx, res) = ui.combo_box(
    "format",
    "格式",
    state.format_idx,
    formats,
  )
  if res.changed {
    state.format_idx = selected_idx
  }
}`,
          en: `///|
pub fn draw_combo_box(ui : @core.UIContext, state : AppState) -> Unit {
  let formats = ["PNG", "SVG", "WebP", "PDF"]
  let (selected_idx, res) = ui.combo_box(
    "format",
    "Format",
    state.format_idx,
    formats,
  )
  if res.changed {
    state.format_idx = selected_idx
  }
}`
        },
        renderUI: (container, state) => {
          if (state.comboIdx === undefined) state.comboIdx = 0;
          const opts = [
            T('PNG (便携位图)', 'PNG (portable bitmap)'),
            T('SVG (矢量标量)', 'SVG (vector)'),
            T('WebP (现代有损)', 'WebP (modern lossy)'),
            T('PDF (印刷矢量)', 'PDF (print vector)')
          ];
          const shortOpts = ["PNG", "SVG", "WebP", "PDF"];

          container.innerHTML = `
            <div class="sandbox-header">
              <span>ComboBox</span>
            </div>
            <div class="sandbox-body">
              <div class="custom-combobox" id="cBoxRoot">
                <div class="combobox-trigger" id="comboTrigger" tabindex="0">
                  <span id="comboSelectedText">${opts[state.comboIdx]}</span>
                  <span class="combobox-chevron">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                      <polyline points="6 9 12 15 18 9"></polyline>
                    </svg>
                  </span>
                </div>
                <div class="combobox-menu" id="comboMenu">
                  <div class="combobox-menu-inner">
                    ${opts.map((o, i) => `
                      <div class="combobox-option ${i === state.comboIdx ? 'is-selected' : ''}" data-idx="${i}">
                        <span>${o}</span>
                        <span class="combobox-check">
                          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                            <polyline points="20 6 9 17 4 12"></polyline>
                          </svg>
                        </span>
                      </div>
                    `).join('')}
                  </div>
                </div>
              </div>
            </div>
            <div class="sandbox-tip">
              ${T('点击下拉选择导出格式。', 'Open the menu to pick an export format.')}
            </div>
          `;

          const trigger = container.querySelector('#comboTrigger');
          const menu = container.querySelector('#comboMenu');
          const text = container.querySelector('#comboSelectedText');

          let isOpen = false;
          const toggleMenu = (open) => {
            isOpen = (open !== undefined) ? open : !isOpen;
            trigger.classList.toggle('is-open', isOpen);
            menu.classList.toggle('is-open', isOpen);
          };

          trigger.onclick = (e) => {
            e.stopPropagation();
            toggleMenu();
          };

          trigger.onkeydown = (e) => {
            if (e.key === 'Enter' || e.key === ' ') {
              e.preventDefault();
              toggleMenu();
            } else if (e.key === 'Escape') {
              toggleMenu(false);
            }
          };

          container.querySelectorAll('.combobox-option').forEach(opt => {
            opt.onclick = (e) => {
              e.stopPropagation();
              const idx = parseInt(opt.getAttribute('data-idx'));
              state.comboIdx = idx;
              text.textContent = opts[idx];
              container.querySelectorAll('.combobox-option').forEach((o, i) => {
                o.classList.toggle('is-selected', i === idx);
              });
              toggleMenu(false);
              document.getElementById('statResponse').textContent = `format: ${shortOpts[idx]} (idx: ${idx})`;
              showToast(T(`已选择「${shortOpts[idx]}」格式`, `Selected the ${shortOpts[idx]} format`));
            };
          });

          const closeIfOutside = (e) => {
            if (!container.contains(e.target)) {
              toggleMenu(false);
            }
          };
          window.addEventListener('click', closeIfOutside);
        }
      },

      color_button: {
        titleKey: 'comp.color_button.title',
        signature: "ui.color_button(id, color) -> (Bool, Response)",
        code: `///|
pub fn draw_colors(ui : @core.UIContext, state : AppState) -> Unit {
  let (clicked_stroke, _) = ui.color_button("stroke", state.stroke_color)
  let (clicked_fill, _) = ui.color_button("fill", state.fill_color)
}`,
        renderUI: (container, state) => {
          if (state.strokeCol === undefined) state.strokeCol = '#2563eb';
          if (state.fillCol === undefined) state.fillCol = '#eff6ff';

          const palette = ['#2563eb', '#10b981', '#f59e0b', '#ef4444', '#8b5cf6', '#0f172a'];

          container.innerHTML = `
            <div class="sandbox-header">
              <span>ColorButton</span>
            </div>
            <div class="sandbox-body">
              <div class="color-picker-row">
                <div class="color-swatch-btn" id="strokeSwatch" style="background: ${state.strokeCol};"></div>
                <div style="flex: 1;">
                  <div style="font-size: 13px; font-weight: 600; color: var(--text-main); margin-bottom: 4px;">${T('描边颜色', 'Stroke color')}</div>
                  <div class="color-palette-grid" id="strokePalette">
                    ${palette.map(c => `<div class="palette-item" style="background: ${c};" data-col="${c}"></div>`).join('')}
                  </div>
                </div>
              </div>
              <div class="color-picker-row" style="margin-top: 16px;">
                <div class="color-swatch-btn" id="fillSwatch" style="background: ${state.fillCol};"></div>
                <div style="flex: 1;">
                  <div style="font-size: 13px; font-weight: 600; color: var(--text-main); margin-bottom: 4px;">${T('填充颜色', 'Fill color')}</div>
                  <div class="color-palette-grid" id="fillPalette">
                    ${['#eff6ff', '#ecfdf5', '#fffbeb', '#fef2f2', '#faf5ff', '#ffffff'].map(c => `<div class="palette-item" style="background: ${c};" data-col="${c}"></div>`).join('')}
                  </div>
                </div>
              </div>
            </div>
            <div class="sandbox-tip">
              ${T('点击色块选择颜色。', 'Click a swatch to apply the color.')}
            </div>
          `;

          const strokeSwatch = container.querySelector('#strokeSwatch');
          const fillSwatch = container.querySelector('#fillSwatch');

          container.querySelectorAll('#strokePalette .palette-item').forEach(item => {
            item.onclick = () => {
              state.strokeCol = item.getAttribute('data-col');
              strokeSwatch.style.background = state.strokeCol;
              document.getElementById('statResponse').textContent = `stroke: ${state.strokeCol}`;
              showToast(T(`已更换描边颜色: ${state.strokeCol}`, `Stroke color set to ${state.strokeCol}`));
            };
          });

          container.querySelectorAll('#fillPalette .palette-item').forEach(item => {
            item.onclick = () => {
              state.fillCol = item.getAttribute('data-col');
              fillSwatch.style.background = state.fillCol;
              document.getElementById('statResponse').textContent = `fill: ${state.fillCol}`;
              showToast(T(`已更换填充颜色: ${state.fillCol}`, `Fill color set to ${state.fillCol}`));
            };
          });
        }
      },

      progress_bar: {
        titleKey: 'comp.progress_bar.title',
        signature: "ui.progress_bar(fraction, text~) -> Response",
        code: `///|
pub fn draw_progress_bar(ui : @core.UIContext, state : AppState) -> Unit {
  ui.progress_bar(state.progress, text="\{state.progress * 100}%")
}`,
        renderUI: (container, state) => {
          if (state.prog === undefined) state.prog = 65;
          container.innerHTML = `
            <div class="sandbox-header">
              <span>ProgressBar</span>
              <button class="mini-btn" id="simProgBtn">${T('模拟进度 ▶', 'Simulate progress ▶')}</button>
            </div>
            <div class="sandbox-body">
              <div class="prog-track">
                <div class="prog-fill" id="pFill" style="width: ${state.prog}%;"></div>
                <div class="prog-text" id="pText">${state.prog}%</div>
              </div>
            </div>
            <div class="sandbox-tip">
              ${T('显示执行进度。', 'Shows how far the current task has run.')}
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
                showToast(T('加载已完成', 'Loading complete'));
              }
              fill.style.width = state.prog + '%';
              text.textContent = `${state.prog}%`;
              document.getElementById('statResponse').textContent = `prog: ${state.prog}%`;
            }, 30);
          };
        }
      },

      collapsing_header: {
        titleKey: 'comp.collapsing_header.title',
        signature: "ui.collapsing_header(id, title, default_open~, content)",
        code: {
          zh: `///|
pub fn draw_collapsing(ui : @core.UIContext, state : AppState) -> Unit {
  ui.collapsing_header("advanced", "高级设置", default_open=true, fn(ui) {
    let (msaa, _) = ui.checkbox("抗锯齿", state.msaa)
    let (shadows, _) = ui.checkbox("阴影", state.shadows)
  })
}`,
          en: `///|
pub fn draw_collapsing(ui : @core.UIContext, state : AppState) -> Unit {
  ui.collapsing_header("advanced", "Advanced", default_open=true, fn(ui) {
    let (msaa, _) = ui.checkbox("Antialiasing", state.msaa)
    let (shadows, _) = ui.checkbox("Shadows", state.shadows)
  })
}`
        },
        renderUI: (container, state) => {
          if (state.open === undefined) state.open = true;
          if (state.msaa === undefined) state.msaa = true;
          if (state.shadows === undefined) state.shadows = false;

          const openLabel = () => (state.open ? T('已展开', 'Expanded') : T('已折叠', 'Collapsed'));

          container.innerHTML = `
            <div class="sandbox-header">
              <span>CollapsingHeader</span>
            </div>
            <div class="sandbox-body">
              <div class="collapsing-card">
                <div class="collapsing-trigger ${state.open ? 'is-open' : ''}" id="treeToggle" tabindex="0">
                  <div style="display: flex; align-items: center; gap: 10px;">
                    <span class="collapsing-chevron">
                      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                        <polyline points="9 18 15 12 9 6"></polyline>
                      </svg>
                    </span>
                    <span style="font-weight: 600; font-size: 13.5px; color: var(--text-main);">${T('高级图形设置', 'Advanced graphics settings')}</span>
                  </div>
                  <span class="collapsing-status-badge">${openLabel()}</span>
                </div>
                <div class="collapsing-wrapper ${state.open ? 'is-open' : ''}" id="treeWrapper">
                  <div class="collapsing-inner">
                    <div class="collapsing-content">
                      <div class="checkbox-row ${state.msaa ? 'checked' : ''}" id="colMsaa">
                        <div class="checkbox-sq">
                          <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="3"><polyline points="20 6 9 17 4 12"/></svg>
                        </div>
                        <div style="display: flex; flex-direction: column;">
                          <span style="font-weight: 500;">${T('四倍抗锯齿 (4x MSAA)', '4x antialiasing (MSAA)')}</span>
                          <span style="font-size: 11px; color: var(--text-muted);">${T('平滑曲线与图元边缘', 'Smooths curve and primitive edges')}</span>
                        </div>
                      </div>
                      <div class="checkbox-row ${state.shadows ? 'checked' : ''}" id="colShadows" style="margin-top: 10px;">
                        <div class="checkbox-sq">
                          <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="3"><polyline points="20 6 9 17 4 12"/></svg>
                        </div>
                        <div style="display: flex; flex-direction: column;">
                          <span style="font-weight: 500;">${T('动态图元阴影', 'Dynamic primitive shadows')}</span>
                          <span style="font-size: 11px; color: var(--text-muted);">${T('启用实时高斯软阴影滤波', 'Real-time Gaussian soft-shadow filtering')}</span>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="sandbox-tip">
              ${T('点击标题栏平滑展开与收起，支持键盘回车/空格触发。', 'Click the header to expand or collapse it; Enter and Space work too.')}
            </div>
          `;

          const toggle = container.querySelector('#treeToggle');
          const wrapper = container.querySelector('#treeWrapper');
          const badge = container.querySelector('.collapsing-status-badge');

          const updateOpen = (open) => {
            state.open = open;
            toggle.classList.toggle('is-open', state.open);
            wrapper.classList.toggle('is-open', state.open);
            badge.textContent = openLabel();
            document.getElementById('statResponse').textContent = `tree_open: ${state.open}`;
          };

          toggle.onclick = () => updateOpen(!state.open);
          toggle.onkeydown = (e) => {
            if (e.key === 'Enter' || e.key === ' ') {
              e.preventDefault();
              updateOpen(!state.open);
            }
          };

          const msaaRow = container.querySelector('#colMsaa');
          msaaRow.onclick = () => {
            state.msaa = !state.msaa;
            msaaRow.classList.toggle('checked', state.msaa);
            document.getElementById('statResponse').textContent = `msaa: ${state.msaa}`;
          };

          const shadowsRow = container.querySelector('#colShadows');
          shadowsRow.onclick = () => {
            state.shadows = !state.shadows;
            shadowsRow.classList.toggle('checked', state.shadows);
            document.getElementById('statResponse').textContent = `shadows: ${state.shadows}`;
          };
        }
      },

      tooltip: {
        titleKey: 'comp.tooltip.title',
        signature: "ui.tooltip(text)",
        code: {
          zh: `///|
pub fn draw_tooltips(ui : @core.UIContext, state : AppState) -> Unit {
  let res_export = ui.button("导出")
  if res_export.hovered {
    ui.tooltip("导出 SVG 矢量图")
  }

  let res_mesh = ui.button("网格")
  if res_mesh.hovered {
    ui.tooltip("重新计算三角网格")
  }
}`,
          en: `///|
pub fn draw_tooltips(ui : @core.UIContext, state : AppState) -> Unit {
  let res_export = ui.button("Export")
  if res_export.hovered {
    ui.tooltip("Export a vector SVG")
  }

  let res_mesh = ui.button("Mesh")
  if res_mesh.hovered {
    ui.tooltip("Recompute the triangle mesh")
  }
}`
        },
        renderUI: (container, state) => {
          container.innerHTML = `
            <div class="sandbox-header">
              <span>Tooltip</span>
            </div>
            <div class="sandbox-body">
              <div class="widget-row" style="gap: 16px; padding: 20px 0;">
                <div class="tooltip-target-card">
                  <button class="btn-primary">${T('导出', 'Export')}</button>
                  <div class="tooltip-bubble">${T('导出 SVG 矢量图', 'Export a vector SVG')}</div>
                </div>
                <div class="tooltip-target-card">
                  <button class="btn-secondary">${T('网格', 'Mesh')}</button>
                  <div class="tooltip-bubble">${T('重新计算三角网格', 'Recompute the triangle mesh')}</div>
                </div>
              </div>
            </div>
            <div class="sandbox-tip">
              ${T('鼠标悬停在按钮上查看提示。', 'Hover a button to reveal its tooltip.')}
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
        titleKey: 'comp.tab_bar.title',
        signature: "ui.tab_bar(id, tabs, selected_idx) -> (Int, Response)",
        code: {
          zh: `///|
pub fn draw_tabs(ui : @core.UIContext, state : AppState) -> Unit {
  let tabs = ["属性", "视口", "图层", "输出"]
  let (active_tab, res) = ui.tab_bar("tabs", tabs, state.tab_idx)
  if res.changed {
    state.tab_idx = active_tab
  }
}`,
          en: `///|
pub fn draw_tabs(ui : @core.UIContext, state : AppState) -> Unit {
  let tabs = ["Properties", "Viewport", "Layers", "Output"]
  let (active_tab, res) = ui.tab_bar("tabs", tabs, state.tab_idx)
  if res.changed {
    state.tab_idx = active_tab
  }
}`
        },
        renderUI: (container, state) => {
          if (state.tabIdx === undefined) state.tabIdx = 0;
          const tabs = [T('属性', 'Properties'), T('视口', 'Viewport'), T('图层', 'Layers'), T('输出', 'Output')];
          const grid = "display: grid; grid-template-columns: max-content 1fr; gap: 6px; font-size: 12px; font-family: 'JetBrains Mono', monospace;";
          const paneTitle = "font-weight: 600; font-size: 13.5px; margin-bottom: 8px; color: var(--text-main); display: flex; align-items: center; justify-content: space-between;";
          const badge = (bg, fg) => `font-family: 'JetBrains Mono', monospace; font-size: 11px; background: ${bg}; color: ${fg}; padding: 1px 6px; border-radius: 4px;`;
          const dim = "color: var(--text-muted);";
          const panels = [
            `<div>
              <div style="${paneTitle}">
                <span>${T('图元属性', 'Primitive properties')}</span>
                <span style="${badge('#eff6ff', 'var(--brand)')}">Active</span>
              </div>
              <div style="${grid}">
                <span style="${dim}">${T('图元类型:', 'Element:')}</span><span>${T('Bezier Spline (三次贝塞尔)', 'Bezier spline (cubic)')}</span>
                <span style="${dim}">${T('控制点数:', 'Control points:')}</span><span>${T('16 个控制手柄', '16 handles')}</span>
                <span style="${dim}">${T('填充模式:', 'Fill rule:')}</span><span>${T('Non-Zero (非零环绕)', 'Non-zero winding')}</span>
              </div>
            </div>`,
            `<div>
              <div style="${paneTitle}">
                <span>${T('视口参数', 'Viewport')}</span>
                <span style="${badge('#f0fdf4', '#16a34a')}">60 FPS</span>
              </div>
              <div style="${grid}">
                <span style="${dim}">${T('视口尺寸:', 'Viewport size:')}</span><span>1920 × 1080 px</span>
                <span style="${dim}">${T('缩放比例:', 'Zoom:')}</span><span>${T('1.00x (100% 原始像素)', '1.00x (100% native pixels)')}</span>
                <span style="${dim}">${T('DPR 缩放:', 'DPR scale:')}</span><span>${T('2.0x Retina 渲染', '2.0x Retina rendering')}</span>
              </div>
            </div>`,
            `<div>
              <div style="${paneTitle}">
                <span>${T('图层管理', 'Layers')}</span>
                <span style="${badge('#faf5ff', '#9333ea')}">3 Layers</span>
              </div>
              <div style="display: flex; flex-direction: column; gap: 6px; font-size: 12px; font-family: 'JetBrains Mono', monospace;">
                <div style="display: flex; justify-content: space-between;"><span>${T('Layer 0: 背景网格', 'Layer 0: background grid')}</span><span style="color: var(--brand); font-weight: 600;">${T('[显示]', '[Visible]')}</span></div>
                <div style="display: flex; justify-content: space-between;"><span>${T('Layer 1: 贝塞尔轮廓', 'Layer 1: bezier outline')}</span><span style="color: var(--brand); font-weight: 600;">${T('[活跃]', '[Active]')}</span></div>
                <div style="display: flex; justify-content: space-between;"><span>${T('Layer 2: 辅助对齐线', 'Layer 2: guide lines')}</span><span style="color: var(--text-muted);">${T('[锁定]', '[Locked]')}</span></div>
              </div>
            </div>`,
            `<div>
              <div style="${paneTitle}">
                <span>${T('导出输出', 'Export output')}</span>
                <span style="${badge('#fffbeb', '#d97706')}">Vector</span>
              </div>
              <div style="${grid}">
                <span style="${dim}">${T('导出格式:', 'Format:')}</span><span>${T('SVG 矢量图形 (.svg)', 'SVG vector graphics (.svg)')}</span>
                <span style="${dim}">${T('路径优化:', 'Path optimisation:')}</span><span>${T('开启 (精度 2 位小数)', 'On (2 decimal places)')}</span>
                <span style="${dim}">${T('嵌入字体:', 'Embedded fonts:')}</span><span>JetBrains Mono / Plus Jakarta</span>
              </div>
            </div>`
          ];

          container.innerHTML = `
            <div class="sandbox-header">
              <span>TabBar</span>
              <span style="color: var(--brand); font-weight: 600;">${tabs[state.tabIdx]}</span>
            </div>
            <div class="sandbox-body">
              <div class="tabbar-container" id="demoTabContainer">
                <div class="tabbar-indicator" id="demoTabIndicator"></div>
                ${tabs.map((t, i) => `
                  <button class="tabbar-item ${state.tabIdx === i ? 'active' : ''}" data-idx="${i}">
                    ${t}
                  </button>
                `).join('')}
              </div>
              <div class="tab-pane-card" id="tabContent">
                ${panels[state.tabIdx]}
              </div>
            </div>
            <div class="sandbox-tip">
              ${T('点击选项卡，观察物理滑块平滑滑动至对应位置。', 'Click a tab and watch the indicator glide into place.')}
            </div>
          `;

          const tabContainer = container.querySelector('#demoTabContainer');
          const indicator = container.querySelector('#demoTabIndicator');
          const tabButtons = container.querySelectorAll('.tabbar-item');
          const content = container.querySelector('#tabContent');

          const updateIndicator = (activeBtn) => {
            if (!activeBtn || !tabContainer || !indicator) return;
            const containerRect = tabContainer.getBoundingClientRect();
            const btnRect = activeBtn.getBoundingClientRect();
            const left = btnRect.left - containerRect.left;
            indicator.style.transform = `translateX(${left}px)`;
            indicator.style.width = `${btnRect.width}px`;
          };

          // Position indicator after paint
          requestAnimationFrame(() => {
            const activeBtn = tabButtons[state.tabIdx] || tabButtons[0];
            updateIndicator(activeBtn);
          });

          tabButtons.forEach(btn => {
            btn.onclick = () => {
              const idx = parseInt(btn.getAttribute('data-idx'));
              if (state.tabIdx === idx) return;
              state.tabIdx = idx;
              tabButtons.forEach(b => b.classList.remove('active'));
              btn.classList.add('active');
              container.querySelector('.sandbox-header span:last-child').textContent = tabs[idx];
              updateIndicator(btn);

              // Smooth transition keyframe
              content.style.animation = 'none';
              content.offsetHeight; // trigger reflow
              content.style.animation = '';
              content.innerHTML = panels[idx];

              document.getElementById('statResponse').textContent = `active_tab: [${idx}] ${tabs[idx]}`;
              showToast(T(`已切换至「${tabs[idx]}」标签`, `Switched to the ${tabs[idx]} tab`));
            };
          });
        }
      },

      scroll_area: {
        titleKey: 'comp.scroll_area.title',
        signature: "ui.scroll_area(id, width~, height~, content)",
        code: {
          zh: `///|
pub fn draw_scroll_area(ui : @core.UIContext, state : AppState) -> Unit {
  ui.scroll_area("logs", width=360.0, height=200.0, fn(ui) {
    for i = 0; i < 30; i = i + 1 {
      ui.label("日志项 [\{i}]")
    }
  })
}`,
          en: `///|
pub fn draw_scroll_area(ui : @core.UIContext, state : AppState) -> Unit {
  ui.scroll_area("logs", width=360.0, height=200.0, fn(ui) {
    for i = 0; i < 30; i = i + 1 {
      ui.label("Log entry [\{i}]")
    }
  })
}`
        },
        renderUI: (container, state) => {
          const logs = [
            { tag: 'info', text: T('内核初始化成功: @core.UIContext 实例就绪', 'Kernel booted: @core.UIContext instance ready'), time: '0.00ms' },
            { tag: 'render', text: T('图形后端挂载: Canvas 2D 上下文已激活', 'Graphics backend attached: Canvas 2D context active'), time: '1.20ms' },
            { tag: 'vram', text: T('顶点缓冲分配: 64KB 几何图元缓冲区', 'Vertex buffer allocated: 64KB primitive arena'), time: '2.45ms' },
            { tag: 'info', text: T('字体引擎加载: Plus Jakarta Sans / JetBrains Mono', 'Font engines loaded: Plus Jakarta Sans / JetBrains Mono'), time: '3.10ms' },
            { tag: 'render', text: T('布局树计算完成: 32 个节点已测量约束', 'Layout tree solved: 32 nodes measured'), time: '4.80ms' },
            { tag: 'render', text: T('第一帧栅格化生成: 耗时 0.42ms (60 FPS 稳定)', 'First frame rasterised: 0.42 ms, a steady 60 FPS'), time: '5.22ms' },
            { tag: 'info', text: T('事件系统就绪: 鼠标拖拽、滚轮、按键监听', 'Event system ready: drag, wheel, and key listeners'), time: '5.90ms' },
            { tag: 'vram', text: T('纹理合批优化: Draw Call 压制至 1 次批处理', 'Batch optimisation: draw calls collapsed into one'), time: '6.50ms' },
            { tag: 'render', text: T('贝塞尔样条细分: 细分精度 ε=0.01 曲线平滑', 'Bezier subdivision: ε=0.01 keeps curves smooth'), time: '7.12ms' },
            { tag: 'info', text: T('即时模式刷新周期: 16.6ms 每帧循环', 'Immediate-mode refresh cycle: 16.6 ms per frame'), time: '8.00ms' },
            { tag: 'render', text: T('剪裁矩形压栈: push_clip_rect() 视口防溢出', 'Clip rect pushed: push_clip_rect() guards the viewport'), time: '9.30ms' },
            { tag: 'vram', text: T('抗锯齿采样使能: subpixel text rendering 开启', 'Antialiasing enabled: subpixel text rendering on'), time: '10.15ms' },
            { tag: 'info', text: T('组件树就绪: 所有 11 项核心控件待命', 'Widget tree ready: all 11 core controls standing by'), time: '11.00ms' },
            { tag: 'render', text: T('滚动视口建立: scroll_area("logs", h=150.0)', 'Scroll viewport created: scroll_area("logs", h=150.0)'), time: '12.40ms' },
            { tag: 'info', text: T('系统待命: 等待用户输入操作', 'System idle: waiting for user input'), time: '13.00ms' }
          ];

          container.innerHTML = `
            <div class="sandbox-header">
              <span>ScrollArea</span>
              <span id="scrollPosBadge" style="font-family: 'JetBrains Mono', monospace; font-size: 11px;">0px (0%)</span>
            </div>
            <div class="sandbox-body">
              <div class="scroll-container-wrapper">
                <div class="scroll-toolbar">
                  <span>${T(`实时渲染事件流 (${logs.length} 项)`, `Live render event stream (${logs.length} entries)`)}</span>
                  <div class="scroll-toolbar-actions">
                    <button class="scroll-btn-mini" id="btnScrollTop">${T('顶部 ↑', 'Top ↑')}</button>
                    <button class="scroll-btn-mini" id="btnScrollBottom">${T('底部 ↓', 'Bottom ↓')}</button>
                  </div>
                </div>
                <div class="scroll-viewport" id="sBox">
                  ${logs.map((log, i) => `
                    <div class="scroll-log-row">
                      <div style="display: flex; align-items: center; gap: 8px;">
                        <span class="log-tag ${log.tag}">${log.tag.toUpperCase()}</span>
                        <span>${log.text}</span>
                      </div>
                      <span style="font-size: 10px; color: var(--text-muted);">${log.time}</span>
                    </div>
                  `).join('')}
                </div>
              </div>
            </div>
            <div class="sandbox-tip">
              ${T('支持平滑滚动、惯性拖拽以及快速定位。', 'Smooth scrolling, inertial dragging, and quick jumps.')}
            </div>
          `;

          const sBox = container.querySelector('#sBox');
          const posBadge = container.querySelector('#scrollPosBadge');
          const btnTop = container.querySelector('#btnScrollTop');
          const btnBottom = container.querySelector('#btnScrollBottom');

          const updateScrollStats = () => {
            const top = Math.round(sBox.scrollTop);
            const max = sBox.scrollHeight - sBox.clientHeight;
            const pct = max > 0 ? Math.round((top / max) * 100) : 0;
            posBadge.textContent = `${top}px (${pct}%)`;
            document.getElementById('statResponse').textContent = `scrollTop: ${top}px (${pct}%)`;
          };

          sBox.onscroll = updateScrollStats;

          btnTop.onclick = () => {
            sBox.scrollTo({ top: 0, behavior: 'smooth' });
          };

          btnBottom.onclick = () => {
            sBox.scrollTo({ top: sBox.scrollHeight, behavior: 'smooth' });
          };
        }
      },

      window: {
        titleKey: 'comp.window.title',
        signature: "ui.window(id, title, content)",
        code: {
          zh: `///|
pub fn draw_window(ui : @core.UIContext, state : AppState) -> Unit {
  ui.window("inspector", "属性检查器", fn(ui) {
    ui.label("当前选中: 样条曲线")
    let (w, _) = ui.slider(state.curve_width, min=1.0, max=10.0)
    let (closed, _) = ui.checkbox("闭合路径", state.curve_closed)
  })
}`,
          en: `///|
pub fn draw_window(ui : @core.UIContext, state : AppState) -> Unit {
  ui.window("inspector", "Inspector", fn(ui) {
    ui.label("Selected: spline curve")
    let (w, _) = ui.slider(state.curve_width, min=1.0, max=10.0)
    let (closed, _) = ui.checkbox("Closed path", state.curve_closed)
  })
}`
        },
        renderUI: (container, state) => {
          if (state.winX === undefined) state.winX = 0;
          if (state.winY === undefined) state.winY = 0;
          if (state.curveWidth === undefined) state.curveWidth = 4.5;
          if (state.closedPath === undefined) state.closedPath = true;

          const worldLabel = T('世界坐标', 'World');
          const dragHint = T('按住标题栏拖拽', 'Drag the title bar');
          const coordOf = (x, y) => `${worldLabel} (X: ${Math.round(120 + x)}, Y: ${Math.round(80 + y)})`;
          const dragIcon = '<svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M5 9l-3 3 3 3M9 5l3-3 3 3M15 19l-3 3-3-3M19 9l3 3-3 3M2 12h20M12 2v20"/></svg>';

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
                  <span class="win-title-text">${T('属性检查器', 'Inspector')}</span>
                </div>
                <span class="win-drag-cue" id="winDragCue">
                  ${dragIcon}
                  ${T('拖拽标题栏', 'Drag the title bar')}
                </span>
              </div>
              <div class="win-body">
                <div class="win-coord-badge">
                  <b id="winCoordText">${coordOf(state.winX, state.winY)}</b>
                </div>
                <div style="margin-bottom: 12px; font-size: 13px; color: var(--text-main);">
                  ${T('当前图元:', 'Selected:')} <b>${T('样条曲线', 'spline curve')}</b>
                </div>
                <div style="margin-bottom: 12px;">
                  <div style="display: flex; justify-content: space-between; font-size: 12px; color: var(--text-sub); margin-bottom: 4px;">
                    <span>${T('线宽', 'Stroke width')}</span>
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
                  <span>${T('闭合路径', 'Closed path')}</span>
                </div>
                <div style="display: flex; align-items: center; gap: 8px;">
                  <button class="mini-btn" id="winResetBtn">${T('重置位置', 'Reset position')}</button>
                  <button class="btn-primary" style="padding: 6px 14px; font-size: 12px;" id="winFocusBtn">${T('聚焦窗口', 'Focus window')}</button>
                </div>
              </div>
            </div>
            <div class="sandbox-tip" style="margin-top: 14px;">
              ${T('按住标题栏可拖拽移动窗口。', 'Hold the title bar to drag the window around.')}
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
            showToast(T('已聚焦图元检查器窗口', 'Brought the inspector window into focus'));
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
            coordText.textContent = coordOf(x, y);
            document.getElementById('statResponse').textContent = `window_pos: (X: ${wx}, Y: ${wy})`;
          }

          function onWinMouseDown(e) {
            if (e.target.closest('button') || e.target.closest('input')) return;
            isWinDragging = true;
            winCard.classList.add('is-dragging');
            dragCue.textContent = T('拖拽中...', 'Dragging...');
            statusText.textContent = T('● 正在位移', '● Moving');
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
            dragCue.innerHTML = `${dragIcon} ${dragHint}`;
            statusText.textContent = T('● 自由浮动', '● Free floating');
            statusText.style.color = '';
            window.removeEventListener('mousemove', onWinMouseMove);
            window.removeEventListener('mouseup', onWinMouseUp);
            window.removeEventListener('touchmove', onWinTouchMove);
            window.removeEventListener('touchend', onWinMouseUp);
            const wx = Math.round(120 + state.winX);
            const wy = Math.round(80 + state.winY);
            showToast(T(`浮动窗口已定位到 X: ${wx}, Y: ${wy}`, `Floating window placed at X: ${wx}, Y: ${wy}`));
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
            showToast(T('已重置浮动窗口位置至原点', 'Floating window returned to the origin'));
          };
        }
      }
    };

    // State
