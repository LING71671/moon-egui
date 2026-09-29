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

  const colorMap = new Map();
  function getColorStr(color) {
    if (!color) return '#000000';
    const key = (color.r << 24) | (color.g << 16) | (color.b << 8) | color.a;
    let s = colorMap.get(key);
    if (!s) {
      s = color.a === 255
        ? `rgb(${color.r},${color.g},${color.b})`
        : `rgba(${color.r},${color.g},${color.b},${(color.a / 255).toFixed(3)})`;
      colorMap.set(key, s);
    }
    return s;
  }

  const fontMap = new Map();
  function getFontStr(fontSize, fontFamily, fontWeight) {
    const weight = fontWeight || 500;
    const family = (fontFamily && fontFamily.length > 0)
      ? (fontFamily.includes('monospace') ? '"JetBrains Mono", Menlo, Monaco, Consolas, monospace' : fontFamily)
      : '"Plus Jakarta Sans", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif';
    const key = `${weight}_${fontSize}_${family}`;
    let f = fontMap.get(key);
    if (!f) {
      f = `${weight} ${fontSize}px ${family}`;
      fontMap.set(key, f);
    }
    return f;
  }

  function renderDrawList(ctx, dl) {
    if (!dl || !dl.commands) return;
    ctx.save();
    let cachedFillStyle = '';
    let cachedStrokeStyle = '';
    let cachedLineWidth = -1;
    let cachedFont = '';

    function setFill(colorStr) {
      if (cachedFillStyle !== colorStr) {
        ctx.fillStyle = colorStr;
        cachedFillStyle = colorStr;
      }
    }

    function setStroke(colorStr, strokeWidth) {
      if (cachedStrokeStyle !== colorStr) {
        ctx.strokeStyle = colorStr;
        cachedStrokeStyle = colorStr;
      }
      if (cachedLineWidth !== strokeWidth) {
        ctx.lineWidth = strokeWidth;
        cachedLineWidth = strokeWidth;
      }
    }

    function setFont(fontStr) {
      if (cachedFont !== fontStr) {
        ctx.font = fontStr;
        cachedFont = fontStr;
      }
    }

    const cmds = dl.commands;
    const len = cmds.length;

    for (let i = 0; i < len; i++) {
      const cmd = cmds[i];
      if (!cmd) continue;

      switch (cmd.$tag) {
        case 0: { // Rect: cmd._0: rect, cmd._1: color, cmd._2: radius
          const rect = cmd._0;
          const color = cmd._1;
          const radius = cmd._2 || 0;
          setFill(getColorStr(color));

          if (radius > 1 && ctx.roundRect) {
            ctx.beginPath();
            ctx.roundRect(rect.x, rect.y, rect.w, rect.h, radius);
            ctx.fill();
          } else {
            ctx.fillRect(rect.x, rect.y, rect.w, rect.h);
          }
          break;
        }
        case 1: { // RectStroke: cmd._0: rect, cmd._1: color, cmd._2: strokeW, cmd._3: radius
          const rect = cmd._0;
          const color = cmd._1;
          const strokeW = cmd._2 || 1;
          const radius = cmd._3 || 0;
          setStroke(getColorStr(color), strokeW);

          ctx.beginPath();
          if (radius > 0 && ctx.roundRect) {
            ctx.roundRect(rect.x, rect.y, rect.w, rect.h, radius);
          } else {
            ctx.rect(rect.x, rect.y, rect.w, rect.h);
          }
          ctx.stroke();
          break;
        }
        case 2: { // Circle: cmd._0: center, cmd._1: radius, cmd._2: color
          const center = cmd._0;
          const radius = cmd._1;
          const color = cmd._2;
          setFill(getColorStr(color));
          ctx.beginPath();
          ctx.arc(center.x, center.y, radius, 0, Math.PI * 2);
          ctx.fill();
          break;
        }
        case 3: { // CircleStroke: cmd._0: center, cmd._1: radius, cmd._2: color, cmd._3: strokeW
          const center = cmd._0;
          const radius = cmd._1;
          const color = cmd._2;
          const strokeW = cmd._3 || 1;
          setStroke(getColorStr(color), strokeW);
          ctx.beginPath();
          ctx.arc(center.x, center.y, radius, 0, Math.PI * 2);
          ctx.stroke();
          break;
        }
        case 4: { // Line: cmd._0: p1, cmd._1: p2, cmd._2: color, cmd._3: strokeW
          const p1 = cmd._0;
          const p2 = cmd._1;
          const color = cmd._2;
          const strokeW = cmd._3 || 1;
          setStroke(getColorStr(color), strokeW);
          ctx.beginPath();
          ctx.moveTo(p1.x, p1.y);
          ctx.lineTo(p2.x, p2.y);
          ctx.stroke();
          break;
        }
        case 5: { // Text: cmd._0: pos, cmd._1: text, cmd._2: fontSize, cmd._3: color, cmd._4: fontFamily, cmd._5: fontWeight
          const pos = cmd._0;
          const text = cmd._1;
          const fontSize = cmd._2 || 14;
          const color = cmd._3;
          const fontFamily = cmd._4;
          const fontWeight = cmd._5;
          setFill(getColorStr(color));
          setFont(getFontStr(fontSize, fontFamily, fontWeight));
          ctx.textBaseline = 'middle';
          ctx.fillText(text, pos.x, pos.y + fontSize * 0.48);
          break;
        }
        case 6: { // Clip: cmd._0: rect
          const rect = cmd._0;
          ctx.save();
          ctx.beginPath();
          ctx.rect(rect.x, rect.y, rect.w, rect.h);
          ctx.clip();
          break;
        }
        case 7: { // ResetClip
          ctx.restore();
          cachedFont = '';
          cachedFillStyle = '';
          cachedStrokeStyle = '';
          cachedLineWidth = -1;
          break;
        }
        case 8: { // LinearGradient: cmd._0: rect, cmd._1: p1, cmd._2: p2, cmd._3: col1, cmd._4: col2, cmd._5: radius
          const rect = cmd._0;
          const p1 = cmd._1;
          const p2 = cmd._2;
          const grad = ctx.createLinearGradient(p1.x, p1.y, p2.x, p2.y);
          grad.addColorStop(0, getColorStr(cmd._3));
          grad.addColorStop(1, getColorStr(cmd._4));
          ctx.fillStyle = grad;
          cachedFillStyle = '';
          const radius = cmd._5 || 0;
          if (radius > 1 && ctx.roundRect) {
            ctx.beginPath();
            ctx.roundRect(rect.x, rect.y, rect.w, rect.h, radius);
            ctx.fill();
          } else {
            ctx.fillRect(rect.x, rect.y, rect.w, rect.h);
          }
          break;
        }
        case 9: { // BezierCurve: cmd._0: p0, cmd._1: p1, cmd._2: p2, cmd._3: p3, cmd._4: color, cmd._5: strokeW
          const p0 = cmd._0;
          const p1 = cmd._1;
          const p2 = cmd._2;
          const p3 = cmd._3;
          const color = cmd._4;
          const strokeW = cmd._5 || 1;
          setStroke(getColorStr(color), strokeW);
          ctx.beginPath();
          ctx.moveTo(p0.x, p0.y);
          ctx.bezierCurveTo(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y);
          ctx.stroke();
          break;
        }
      }
    }
    ctx.restore();
  }

  class MicroSandbox {
    constructor(container) {
      this.container = container;
      this.compId = container.getAttribute('data-comp') || 'button';
      this.height = parseInt(container.getAttribute('data-height') || '160', 10);
      this.width = container.clientWidth || 600;

      this.mouseX = -100;
      this.mouseY = -100;
      this.isMouseDown = false;
      this.isSecondaryMouseDown = false;
      this.scrollDy = 0.0;
      this.pendingText = '';
      this.keysPressed = [];
      this.keysReleased = [];
      this.modFlags = 0;
      this.isVisible = false;
      this.lastTime = performance.now();

      this.buildDOM();
      this.bindEvents();
    }

    buildDOM() {
      this.container.innerHTML = `
        <div class="doc-sandbox-header">
          <div class="doc-sandbox-meta">
            <span class="doc-sandbox-dot"></span>
            <span class="doc-sandbox-title">即时交互微沙箱</span>
            <span class="doc-sandbox-badge">@widgets.${this.compId}</span>
          </div>
          <div class="doc-sandbox-ctrls">
            <span class="doc-sandbox-tag">Wasm-GC 原生内核</span>
          </div>
        </div>
        <div class="doc-sandbox-body" style="height: ${this.height}px;">
          <canvas class="doc-sandbox-canvas" tabindex="0"></canvas>
        </div>
      `;

      this.canvas = this.container.querySelector('.doc-sandbox-canvas');
      this.ctx = this.canvas.getContext('2d');
      this.resize();
    }

    resize() {
      const rect = this.canvas.getBoundingClientRect();
      const newWidth = Math.max(rect.width || this.container.clientWidth || 400, 200);
      const newHeight = this.height;
      const dpr = window.devicePixelRatio || 1;

      this.width = newWidth;
      this.canvas.width = Math.round(newWidth * dpr);
      this.canvas.height = Math.round(newHeight * dpr);
      this.ctx.setTransform(1, 0, 0, 1, 0, 0);
      this.ctx.scale(dpr, dpr);
      this.ctx.imageSmoothingEnabled = true;
    }

    bindEvents() {
      const c = this.canvas;

      c.addEventListener('mousemove', (e) => {
        const r = c.getBoundingClientRect();
        this.mouseX = e.clientX - r.left;
        this.mouseY = e.clientY - r.top;
      }, { passive: true });

      c.addEventListener('mousedown', (e) => {
        const r = c.getBoundingClientRect();
        this.mouseX = e.clientX - r.left;
        this.mouseY = e.clientY - r.top;
        if (e.button === 0) {
          this.isMouseDown = true;
          c.focus();
        } else if (e.button === 2) {
          this.isSecondaryMouseDown = true;
          c.focus();
        }
      });

      window.addEventListener('mouseup', (e) => {
        if (e.button === 0) this.isMouseDown = false;
        if (e.button === 2) this.isSecondaryMouseDown = false;
      });

      c.addEventListener('mouseleave', () => {
        this.mouseX = -100;
        this.mouseY = -100;
      });

      // Touch gesture support
      c.addEventListener('touchstart', (e) => {
        if (!e.touches || !e.touches[0]) return;
        const r = c.getBoundingClientRect();
        this.mouseX = e.touches[0].clientX - r.left;
        this.mouseY = e.touches[0].clientY - r.top;
        this.isMouseDown = true;
      }, { passive: true });

      c.addEventListener('touchmove', (e) => {
        if (!e.touches || !e.touches[0]) return;
        const r = c.getBoundingClientRect();
        this.mouseX = e.touches[0].clientX - r.left;
        this.mouseY = e.touches[0].clientY - r.top;
      }, { passive: true });

      c.addEventListener('touchend', () => {
        this.isMouseDown = false;
        this.mouseX = -100;
        this.mouseY = -100;
      });

      c.addEventListener('keydown', (e) => {
        this.modFlags = 0;
        if (e.shiftKey) this.modFlags |= 2;
        if (e.ctrlKey) this.modFlags |= 1;
        if (e.altKey) this.modFlags |= 4;
        if (e.metaKey) this.modFlags |= 8;

        if (e.key.length > 1) {
          this.keysPressed.push(e.key);
          if (['ArrowUp', 'ArrowDown', 'ArrowLeft', 'ArrowRight', 'Tab', 'Enter', 'Escape'].includes(e.key)) {
            e.preventDefault();
          }
        } else {
          this.pendingText += e.key;
          if (e.key === ' ') e.preventDefault();
        }
      }, { passive: false });

      c.addEventListener('keyup', (e) => {
        if (e.key.length > 1) {
          this.keysReleased.push(e.key);
        }
      });

      c.addEventListener('wheel', (e) => {
        this.scrollDy += e.deltaY;
        if (Math.abs(e.deltaX) > 0.01 && Math.abs(e.deltaY) < 0.01) {
          this.scrollDy += e.deltaX;
        }
        e.preventDefault();
      }, { passive: false });
    }

    render(now) {
      if (!this.isVisible || !window.moon_gallery_step) return;

      const dt = Math.min((now - this.lastTime) / 1000.0, 0.1);
      this.lastTime = now;

      // Check for dimension changes
      const rect = this.canvas.getBoundingClientRect();
      if (Math.abs(rect.width - this.width) > 2) {
        this.resize();
      }

      const dl = window.moon_gallery_step(
        this.compId,
        this.mouseX,
        this.mouseY,
        this.isMouseDown,
        this.scrollDy,
        this.width,
        this.height,
        this.pendingText,
        this.keysPressed,
        this.keysReleased,
        this.modFlags,
        this.isSecondaryMouseDown
      );

      this.scrollDy = 0.0;
      this.pendingText = '';
      this.keysPressed = [];
      this.keysReleased = [];

      this.ctx.clearRect(0, 0, this.width, this.height);
      renderDrawList(this.ctx, dl);

      if (window.moon_gallery_cursor) {
        try {
          const cur = window.moon_gallery_cursor();
          if (this.canvas.style.cursor !== cur) {
            this.canvas.style.cursor = cur;
          }
        } catch (e) {}
      }
    }
  }

  function initDocSandboxes() {
    const containers = document.querySelectorAll('.doc-sandbox');
    if (!containers || containers.length === 0) return;

    const sandboxes = [];
    containers.forEach((el) => {
      sandboxes.push(new MicroSandbox(el));
    });

    // IntersectionObserver to only render visible sandboxes
    const observer = new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        const sb = sandboxes.find((s) => s.container === entry.target);
        if (sb) {
          sb.isVisible = entry.isIntersecting;
          if (sb.isVisible) {
            sb.resize();
          }
        }
      });
    }, { threshold: 0.05 });

    sandboxes.forEach((sb) => observer.observe(sb.container));

    function loop(now) {
      requestAnimationFrame(loop);
      for (let i = 0; i < sandboxes.length; i++) {
        sandboxes[i].render(now);
      }
    }
    requestAnimationFrame(loop);

    window.addEventListener('resize', () => {
      sandboxes.forEach((sb) => sb.resize());
    });
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initDocSandboxes);
  } else {
    initDocSandboxes();
  }
})();
