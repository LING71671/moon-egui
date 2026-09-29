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

  let currentPreset = 'button';
  let canvas = null;
  let ctx = null;
  let width = 800;
  let height = 480;
  let dpr = window.devicePixelRatio || 1;

  let mouseX = -100;
  let mouseY = -100;
  let isMouseDown = false;
  let isSecondaryMouseDown = false;
  let scrollDy = 0.0;
  let pendingText = '';
  let keysPressed = [];
  let keysReleased = [];
  let modFlags = 0;
  let lastTime = performance.now();

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
        case 0: { // Rect
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
        case 1: { // RectStroke
          const rect = cmd._0;
          const color = cmd._1;
          const strokeW = cmd._2 || 1;
          const radius = cmd._3 || 0;
          setStroke(getColorStr(color), strokeW);

          ctx.beginPath();
          if (radius > 1 && ctx.roundRect) {
            ctx.roundRect(rect.x, rect.y, rect.w, rect.h, radius);
          } else {
            ctx.rect(rect.x, rect.y, rect.w, rect.h);
          }
          ctx.stroke();
          break;
        }
        case 2: { // Circle
          const center = cmd._0;
          const radius = cmd._1;
          const color = cmd._2;
          setFill(getColorStr(color));

          ctx.beginPath();
          ctx.arc(center.x, center.y, radius, 0, Math.PI * 2);
          ctx.fill();
          break;
        }
        case 3: { // CircleStroke
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
        case 4: { // Line
          const from = cmd._0;
          const to = cmd._1;
          const color = cmd._2;
          const strokeW = cmd._3 || 1;
          setStroke(getColorStr(color), strokeW);

          ctx.beginPath();
          ctx.moveTo(from.x, from.y);
          ctx.lineTo(to.x, to.y);
          ctx.stroke();
          break;
        }
        case 5: { // Text
          const pos = cmd._0;
          const text = cmd._1;
          const color = cmd._2;
          const fontSz = cmd._3 || 13;
          const fontFam = cmd._4 || '';
          const fontWt = cmd._5 || 500;

          setFont(getFontStr(fontSz, fontFam, fontWt));
          setFill(getColorStr(color));
          ctx.textBaseline = 'middle';
          ctx.fillText(text, pos.x, pos.y);
          break;
        }
        case 6: { // Clip
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
        case 8: { // LinearGradient
          const rect = cmd._0;
          const c1 = cmd._1;
          const c2 = cmd._2;
          const isHoriz = cmd._3;
          const radius = cmd._4 || 0;

          const grad = isHoriz
            ? ctx.createLinearGradient(rect.x, rect.y, rect.x + rect.w, rect.y)
            : ctx.createLinearGradient(rect.x, rect.y, rect.x, rect.y + rect.h);

          grad.addColorStop(0, getColorStr(c1));
          grad.addColorStop(1, getColorStr(c2));
          ctx.fillStyle = grad;
          cachedFillStyle = '';

          if (radius > 1 && ctx.roundRect) {
            ctx.beginPath();
            ctx.roundRect(rect.x, rect.y, rect.w, rect.h, radius);
            ctx.fill();
          } else {
            ctx.fillRect(rect.x, rect.y, rect.w, rect.h);
          }
          break;
        }
        case 9: { // BezierCurve
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

  function resizeCanvas() {
    if (!canvas) return;
    const rect = canvas.getBoundingClientRect();
    width = Math.max(rect.width || 800, 300);
    height = Math.max(rect.height || 480, 200);
    dpr = window.devicePixelRatio || 1;

    canvas.width = Math.round(width * dpr);
    canvas.height = Math.round(height * dpr);
    ctx.setTransform(1, 0, 0, 1, 0, 0);
    ctx.scale(dpr, dpr);
    ctx.imageSmoothingEnabled = true;
  }

  function bindEvents() {
    if (!canvas) return;

    canvas.addEventListener('mousemove', (e) => {
      const r = canvas.getBoundingClientRect();
      mouseX = e.clientX - r.left;
      mouseY = e.clientY - r.top;
    }, { passive: true });

    canvas.addEventListener('mousedown', (e) => {
      const r = canvas.getBoundingClientRect();
      mouseX = e.clientX - r.left;
      mouseY = e.clientY - r.top;
      if (e.button === 0) {
        isMouseDown = true;
        canvas.focus();
      } else if (e.button === 2) {
        isSecondaryMouseDown = true;
        canvas.focus();
      }
    });

    window.addEventListener('mouseup', (e) => {
      if (e.button === 0) isMouseDown = false;
      if (e.button === 2) isSecondaryMouseDown = false;
    });

    canvas.addEventListener('mouseleave', () => {
      mouseX = -100;
      mouseY = -100;
    });

    canvas.addEventListener('contextmenu', (e) => {
      e.preventDefault();
    });

    // Touch gesture support
    canvas.addEventListener('touchstart', (e) => {
      if (!e.touches || !e.touches[0]) return;
      const r = canvas.getBoundingClientRect();
      mouseX = e.touches[0].clientX - r.left;
      mouseY = e.touches[0].clientY - r.top;
      isMouseDown = true;
    }, { passive: true });

    canvas.addEventListener('touchmove', (e) => {
      if (!e.touches || !e.touches[0]) return;
      const r = canvas.getBoundingClientRect();
      mouseX = e.touches[0].clientX - r.left;
      mouseY = e.touches[0].clientY - r.top;
    }, { passive: true });

    window.addEventListener('touchend', () => {
      isMouseDown = false;
      mouseX = -100;
      mouseY = -100;
    });

    canvas.addEventListener('keydown', (e) => {
      modFlags = 0;
      if (e.shiftKey) modFlags |= 2;
      if (e.ctrlKey) modFlags |= 1;
      if (e.altKey) modFlags |= 4;
      if (e.metaKey) modFlags |= 8;

      if (e.key.length > 1) {
        keysPressed.push(e.key);
        if (['ArrowUp', 'ArrowDown', 'ArrowLeft', 'ArrowRight', 'Tab', 'Enter', 'Escape'].includes(e.key)) {
          e.preventDefault();
        }
      } else {
        pendingText += e.key;
        if (e.key === ' ') e.preventDefault();
      }
    }, { passive: false });

    canvas.addEventListener('keyup', (e) => {
      if (e.key.length > 1) {
        keysReleased.push(e.key);
      }
    });

    canvas.addEventListener('wheel', (e) => {
      scrollDy += e.deltaY;
      if (Math.abs(e.deltaX) > 0.01 && Math.abs(e.deltaY) < 0.01) {
        scrollDy += e.deltaX;
      }
      e.preventDefault();
    }, { passive: false });

    window.addEventListener('resize', resizeCanvas);
  }

  function bindTabs() {
    const tabBtns = document.querySelectorAll('.hero-tab-btn');
    tabBtns.forEach((btn) => {
      btn.addEventListener('click', () => {
        tabBtns.forEach((b) => b.classList.remove('active'));
        btn.classList.add('active');
        currentPreset = btn.getAttribute('data-preset') || 'button';
      });
    });
  }

  function renderFrame(now) {
    if (!canvas || !ctx || !window.moon_gallery_step) return;

    const dt = Math.min((now - lastTime) / 1000.0, 0.1);
    lastTime = now;

    // Check for dimension changes
    const rect = canvas.getBoundingClientRect();
    if (Math.abs(rect.width - width) > 2) {
      resizeCanvas();
    }

    const dl = window.moon_gallery_step(
      currentPreset,
      mouseX,
      mouseY,
      isMouseDown,
      scrollDy,
      width,
      height,
      pendingText,
      keysPressed,
      keysReleased,
      modFlags,
      isSecondaryMouseDown
    );

    scrollDy = 0.0;
    pendingText = '';
    keysPressed = [];
    keysReleased = [];

    ctx.clearRect(0, 0, width, height);
    renderDrawList(ctx, dl);

    if (window.moon_gallery_cursor) {
      try {
        const cur = window.moon_gallery_cursor();
        if (canvas.style.cursor !== cur) {
          canvas.style.cursor = cur;
        }
      } catch (e) {}
    }
  }

  function loop(now) {
    requestAnimationFrame(loop);
    renderFrame(now);
  }

  function initHeroPlayground() {
    canvas = document.getElementById('hero-workbench-canvas');
    if (!canvas) return;

    ctx = canvas.getContext('2d');
    resizeCanvas();
    bindEvents();
    bindTabs();
    requestAnimationFrame(loop);
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initHeroPlayground);
  } else {
    initHeroPlayground();
  }
})();
