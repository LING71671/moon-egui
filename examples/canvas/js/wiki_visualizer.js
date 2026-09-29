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

(function () {
  'use strict';

  // ----------------------------------------------------------------------
  // Visualizer 1: 5-Stage Frame Lifecycle Stepper
  // ----------------------------------------------------------------------

  const PIPELINE_STAGES = [
    {
      step: 1,
      name: '输入数据采集 (Input Gathering)',
      sub: 'RawInput 归一化',
      tag: 'Host Event Bridge',
      desc: '宿主拦截 pointer/mouse/touch、wheel、keydown/keyup 与 IME 文本事件，统一封装并归一化为平台无关的不可变结构体 `RawInput`。',
      code: `let raw = host_raw_input(
  mouse_x, mouse_y, is_down,
  text_input, keys_pressed, keys_released, mod_flags,
  scroll_dy~, mouse_secondary_down~
)`,
      metrics: '开销: ~0.02ms · 内存分配: 0 Bytes · 无垃圾回收负担',
    },
    {
      step: 2,
      name: '上下文帧初始化 (Context Frame Init)',
      sub: 'ctx.begin_frame(raw)',
      tag: 'Engine Runtime',
      desc: '重置流式排版游标至视口原点，交换上一帧活跃 ID 双缓冲集合，清空几何指令队列，计算当前帧时间差 delta_time。',
      code: `pub fn UIContext::begin_frame(self : UIContext, raw : RawInput) -> Unit {
  self.frame_index = self.frame_index + 1
  self.draw_list.clear()
  self.focus.begin_frame(self.input)
}`,
      metrics: '开销: ~0.04ms · ID 栈深度: 0 · 游标重置为 (0.0, 0.0)',
    },
    {
      step: 3,
      name: '即时逻辑求值 (IM Evaluation)',
      sub: 'Decl Code Execution',
      tag: 'Widget Tree Free',
      desc: '执行声明式 UI 函数。在单次向下遍历中，同时完成 AABB 碰撞命中检测、游标尺寸度量推进，并立即返回交互响应与排队绘制指令。',
      code: `if @widgets.button_primary(ui, "立即编译").clicked {
  app_state.compile()
}
let (new_val, resp) = @widgets.slider(ui, "缩放", state.zoom, 0.5, 3.0)`,
      metrics: '开销: ~0.25ms · 控件求值: 30+ 实体 · 碰撞检测: 矢量 AABB',
    },
    {
      step: 4,
      name: '图层合成与排序 (Layer Composition)',
      sub: 'Z-Index & Scissor Clip',
      tag: 'Layer Engine',
      desc: '图层管理器根据窗口聚焦深度执行 Z-Index 升序重排，裁切栈合并计算嵌套 Scissor 区域，将前台弹窗/菜单提升至最高渲染优先级。',
      code: `self.layer_manager.end_foreground()
self.layer_manager.compose_into(self.draw_list)
// 扁平化全局 DrawCmd 队列供后端光栅化`,
      metrics: '开销: ~0.06ms · 图层数: 2 · 视口裁剪矩形: 已扁平化',
    },
    {
      step: 5,
      name: '后端渲染分发 (Backend Render Dispatch)',
      sub: 'Canvas 2D / Wasm-GC',
      tag: 'Rasterizer Output',
      desc: '返回只读 `DrawList` 纯矢量图元列表给宿主。宿主批量分发指令并在 HTML5 Canvas 2D / WebGL 上执行硬件加速光栅化，零 DOM 开销。',
      code: `const drawList = window.moon_step(mouseX, mouseY, isDown, dt);
renderDrawList(ctx, drawList);
// 帧渲染完毕，等待下一次 requestAnimationFrame`,
      metrics: '开销: ~0.42ms · 帧率: 60 FPS (16.6ms 预算剩余 > 90%)',
    },
  ];

  let currentStageIdx = 0;
  let autoPlayTimer = null;

  function renderStageUI() {
    const stage = PIPELINE_STAGES[currentStageIdx];
    const stepNodes = document.querySelectorAll('.pipeline-step-node');
    stepNodes.forEach((node, idx) => {
      if (idx === currentStageIdx) {
        node.classList.add('active');
        node.classList.remove('completed');
      } else if (idx < currentStageIdx) {
        node.classList.add('completed');
        node.classList.remove('active');
      } else {
        node.classList.remove('active', 'completed');
      }
    });

    const titleEl = document.getElementById('pipelineStageTitle');
    const badgeEl = document.getElementById('pipelineStageBadge');
    const descEl = document.getElementById('pipelineStageDesc');
    const codeEl = document.getElementById('pipelineStageCode');
    const metricsEl = document.getElementById('pipelineStageMetrics');

    if (titleEl) titleEl.textContent = `阶段 ${stage.step}：${stage.name}`;
    if (badgeEl) badgeEl.textContent = stage.tag;
    if (descEl) descEl.textContent = stage.desc;
    if (codeEl) codeEl.textContent = stage.code;
    if (metricsEl) metricsEl.textContent = stage.metrics;
  }

  function initPipelineStepper() {
    const prevBtn = document.getElementById('pipelinePrevBtn');
    const nextBtn = document.getElementById('pipelineNextBtn');
    const playBtn = document.getElementById('pipelinePlayBtn');

    if (prevBtn) {
      prevBtn.addEventListener('click', () => {
        if (autoPlayTimer) stopAutoPlay();
        currentStageIdx = (currentStageIdx - 1 + PIPELINE_STAGES.length) % PIPELINE_STAGES.length;
        renderStageUI();
      });
    }

    if (nextBtn) {
      nextBtn.addEventListener('click', () => {
        if (autoPlayTimer) stopAutoPlay();
        currentStageIdx = (currentStageIdx + 1) % PIPELINE_STAGES.length;
        renderStageUI();
      });
    }

    function stopAutoPlay() {
      if (autoPlayTimer) {
        clearInterval(autoPlayTimer);
        autoPlayTimer = null;
        if (playBtn) playBtn.textContent = '▶ 自动步进演示';
      }
    }

    if (playBtn) {
      playBtn.addEventListener('click', () => {
        if (autoPlayTimer) {
          stopAutoPlay();
        } else {
          playBtn.textContent = '⏸ 暂停演示';
          autoPlayTimer = setInterval(() => {
            currentStageIdx = (currentStageIdx + 1) % PIPELINE_STAGES.length;
            renderStageUI();
          }, 2400);
        }
      });
    }

    renderStageUI();
  }

  // ----------------------------------------------------------------------
  // Visualizer 2: Live DrawCmd Stream Inspector
  // ----------------------------------------------------------------------

  const TAG_NAMES = [
    'Rect', 'RectStroke', 'Circle', 'CircleStroke',
    'Line', 'Text', 'Clip', 'ResetClip', 'LinearGradient', 'BezierCurve'
  ];

  function initDrawCmdInspector() {
    const canvas = document.getElementById('inspectorCanvas');
    const streamBox = document.getElementById('drawcmdStreamBox');
    const countBadge = document.getElementById('drawcmdCountBadge');
    if (!canvas || !streamBox || !window.moon_gallery_step) return;

    const ctx = canvas.getContext('2d');
    let width = 360;
    let height = 240;
    let dpr = window.devicePixelRatio || 1;

    let mouseX = -100;
    let mouseY = -100;
    let isMouseDown = false;
    let compId = 'button';

    function resize() {
      const rect = canvas.getBoundingClientRect();
      width = Math.max(rect.width || 360, 200);
      height = 240;
      dpr = window.devicePixelRatio || 1;
      canvas.width = Math.round(width * dpr);
      canvas.height = Math.round(height * dpr);
      ctx.setTransform(1, 0, 0, 1, 0, 0);
      ctx.scale(dpr, dpr);
    }
    resize();

    canvas.addEventListener('mousemove', (e) => {
      const r = canvas.getBoundingClientRect();
      mouseX = e.clientX - r.left;
      mouseY = e.clientY - r.top;
    });

    canvas.addEventListener('mousedown', (e) => {
      const r = canvas.getBoundingClientRect();
      mouseX = e.clientX - r.left;
      mouseY = e.clientY - r.top;
      if (e.button === 0) isMouseDown = true;
    });

    window.addEventListener('mouseup', () => {
      isMouseDown = false;
    });

    canvas.addEventListener('mouseleave', () => {
      mouseX = -100;
      mouseY = -100;
    });

    const selector = document.getElementById('inspectorCompSelect');
    if (selector) {
      selector.addEventListener('change', (e) => {
        compId = e.target.value;
      });
    }

    function formatCmd(cmd, idx) {
      if (!cmd) return '';
      const tag = TAG_NAMES[cmd.$tag] || `Cmd_${cmd.$tag}`;
      let details = '';

      switch (cmd.$tag) {
        case 0: // Rect
          details = `x:${cmd._0.x.toFixed(0)} y:${cmd._0.y.toFixed(0)} w:${cmd._0.w.toFixed(0)} h:${cmd._0.h.toFixed(0)} r:${cmd._2 || 0}`;
          break;
        case 1: // RectStroke
          details = `x:${cmd._0.x.toFixed(0)} y:${cmd._0.y.toFixed(0)} w:${cmd._0.w.toFixed(0)} h:${cmd._0.h.toFixed(0)} stroke:${cmd._2 || 1}`;
          break;
        case 2: // Circle
          details = `cx:${cmd._0.x.toFixed(0)} cy:${cmd._0.y.toFixed(0)} r:${cmd._1.toFixed(0)}`;
          break;
        case 4: // Line
          details = `(${cmd._0.x.toFixed(0)},${cmd._0.y.toFixed(0)}) -> (${cmd._1.x.toFixed(0)},${cmd._1.y.toFixed(0)})`;
          break;
        case 5: // Text
          details = `"${cmd._1}" @ (${cmd._0.x.toFixed(0)},${cmd._0.y.toFixed(0)}) ${cmd._3}px`;
          break;
        default:
          details = 'metadata...';
      }

      return `<div class="cmd-line"><span class="cmd-idx">#${idx < 10 ? '0' + idx : idx}</span> <span class="cmd-tag">${tag}</span> <span class="cmd-meta">${details}</span></div>`;
    }

    function render(now) {
      requestAnimationFrame(render);
      if (!window.moon_gallery_step) return;

      const dl = window.moon_gallery_step(
        compId, mouseX, mouseY, isMouseDown, 0, width, height, '', [], [], 0, false
      );

      ctx.clearRect(0, 0, width, height);

      // Simple rasterize for inspector canvas
      if (dl && dl.commands) {
        const cmds = dl.commands;
        const len = cmds.length;
        if (countBadge) countBadge.textContent = `${len} 图元指令 / 帧`;

        // Render commands
        for (let i = 0; i < len; i++) {
          const cmd = cmds[i];
          if (!cmd) continue;
          if (cmd.$tag === 0) { // Rect
            ctx.fillStyle = `rgb(${cmd._1.r},${cmd._1.g},${cmd._1.b})`;
            if (cmd._2 > 1 && ctx.roundRect) {
              ctx.beginPath();
              ctx.roundRect(cmd._0.x, cmd._0.y, cmd._0.w, cmd._0.h, cmd._2);
              ctx.fill();
            } else {
              ctx.fillRect(cmd._0.x, cmd._0.y, cmd._0.w, cmd._0.h);
            }
          } else if (cmd.$tag === 1) { // RectStroke
            ctx.strokeStyle = `rgb(${cmd._1.r},${cmd._1.g},${cmd._1.b})`;
            ctx.lineWidth = cmd._2 || 1;
            ctx.strokeRect(cmd._0.x, cmd._0.y, cmd._0.w, cmd._0.h);
          } else if (cmd.$tag === 5) { // Text
            ctx.fillStyle = `rgb(${cmd._2.r},${cmd._2.g},${cmd._2.b})`;
            ctx.font = `${cmd._5 || 500} ${cmd._3 || 13}px sans-serif`;
            ctx.textBaseline = 'middle';
            ctx.fillText(cmd._1, cmd._0.x, cmd._0.y);
          }
        }

        // Update inspector text list (first 14 commands)
        let html = '';
        const limit = Math.min(len, 14);
        for (let i = 0; i < limit; i++) {
          html += formatCmd(cmds[i], i);
        }
        if (len > 14) {
          html += `<div class="cmd-line cmd-more">... 及其余 ${len - 14} 项矢量绘制指令</div>`;
        }
        streamBox.innerHTML = html;
      }
    }
    requestAnimationFrame(render);
  }

  function initWikiVisualizers() {
    initPipelineStepper();
    initDrawCmdInspector();
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initWikiVisualizers);
  } else {
    initWikiVisualizers();
  }
})();
