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
  let currentCompId = 'button';
  let canvas = null;
  let ctx = null;
  let width = 600;
  let height = 400;
  let dpr = window.devicePixelRatio || 1;

  let mouseX = -100;
  let mouseY = -100;
  let isMouseDown = false;
  let scrollDy = 0.0;
  let pendingText = '';
  let keysPressed = [];
  let keysReleased = [];
  let modFlags = 0;

  // Cached rasterizer properties
  let cachedFillStyle = '';
  let cachedStrokeStyle = '';
  let cachedLineWidth = -1;
  let cachedFont = '';

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
  function getFontStr(fontSize) {
    let f = fontMap.get(fontSize);
    if (!f) {
      f = `500 ${fontSize}px "Plus Jakarta Sans", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif`;
      fontMap.set(fontSize, f);
    }
    return f;
  }

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

  function initCanvas() {
    canvas = document.getElementById('gallery-canvas');
    if (!canvas) {
      const sandboxBox = document.getElementById('sandboxBox');
      if (!sandboxBox) return;
      canvas = document.createElement('canvas');
      canvas.id = 'gallery-canvas';
      sandboxBox.appendChild(canvas);
    }
    canvas.style.width = '100%';
    canvas.style.height = '100%';
    canvas.style.display = 'block';
    canvas.style.outline = 'none';
    canvas.tabIndex = 0;

    ctx = canvas.getContext('2d', { alpha: false });
    resizeCanvas();
    bindEvents();
    requestAnimationFrame(renderLoop);
  }

  function resizeCanvas() {
    if (!canvas || !canvas.parentElement) return;
    const rect = canvas.parentElement.getBoundingClientRect();
    width = Math.max(300, Math.floor(rect.width));
    height = Math.max(260, Math.floor(rect.height));
    dpr = window.devicePixelRatio || 1;

    canvas.width = Math.round(width * dpr);
    canvas.height = Math.round(height * dpr);
    ctx.setTransform(1, 0, 0, 1, 0, 0);
    ctx.scale(dpr, dpr);
    ctx.imageSmoothingEnabled = true;

    cachedFillStyle = '';
    cachedStrokeStyle = '';
    cachedLineWidth = -1;
    cachedFont = '';
  }

  function bindEvents() {
    if (!canvas) return;

    canvas.addEventListener('mousemove', (e) => {
      const rect = canvas.getBoundingClientRect();
      mouseX = e.clientX - rect.left;
      mouseY = e.clientY - rect.top;
    }, { passive: true });

    canvas.addEventListener('mousedown', (e) => {
      if (e.button === 0) {
        isMouseDown = true;
        const rect = canvas.getBoundingClientRect();
        mouseX = e.clientX - rect.left;
        mouseY = e.clientY - rect.top;
        canvas.focus();
      }
    });

    window.addEventListener('mouseup', (e) => {
      if (e.button === 0) {
        isMouseDown = false;
      }
    });

    canvas.addEventListener('mouseleave', () => {
      mouseX = -100;
      mouseY = -100;
    });

    canvas.addEventListener('wheel', (e) => {
      scrollDy += e.deltaY;
      e.preventDefault();
    }, { passive: false });

    canvas.addEventListener('keydown', (e) => {
      modFlags = 0;
      if (e.shiftKey) modFlags |= 2;
      if (e.ctrlKey) modFlags |= 1;
      if (e.altKey) modFlags |= 4;
      if (e.metaKey) modFlags |= 8;

      if (e.key.length > 1) {
        keysPressed.push(e.key);
        if (['ArrowUp', 'ArrowDown', 'ArrowLeft', 'ArrowRight', 'Tab', 'Enter', 'Backspace', 'Delete'].includes(e.key)) {
          e.preventDefault();
        }
      } else if (!e.ctrlKey && !e.metaKey && !e.altKey) {
        pendingText += e.key;
        if (e.key === ' ') e.preventDefault();
      }
    }, { passive: false });

    canvas.addEventListener('keyup', (e) => {
      if (e.key.length > 1) {
        keysReleased.push(e.key);
      }
    });

    window.addEventListener('resize', resizeCanvas);
  }

  function renderDrawList(dl) {
    if (!dl || !dl.commands) return;
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
        case 5: { // Text: cmd._0: pos, cmd._1: text, cmd._2: fontSize, cmd._3: color
          const pos = cmd._0;
          const text = cmd._1;
          const fontSize = cmd._2 || 14;
          const color = cmd._3;
          setFill(getColorStr(color));
          setFont(getFontStr(fontSize));
          ctx.textBaseline = 'top';
          ctx.fillText(text, pos.x, pos.y);
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
          break;
        }
      }
    }
  }

  let lastTime = performance.now();
  let frameCount = 0;
  let fps = 60.0;

  function renderLoop(now) {
    frameCount++;
    if (now - lastTime >= 1000) {
      fps = ((frameCount * 1000) / (now - lastTime)).toFixed(0);
      frameCount = 0;
      lastTime = now;
    }

    if (canvas && ctx && window.moon_gallery_step) {
      const t0 = performance.now();
      const dl = window.moon_gallery_step(
        currentCompId,
        mouseX,
        mouseY,
        isMouseDown,
        scrollDy,
        width,
        height,
        pendingText,
        keysPressed,
        keysReleased,
        modFlags
      );
      const kTime = (performance.now() - t0).toFixed(2);

      // Reset per-frame transient inputs
      scrollDy = 0.0;
      pendingText = '';
      keysPressed = [];
      keysReleased = [];

      ctx.clearRect(0, 0, width, height);
      renderDrawList(dl);

      // Update footer response
      const statResp = document.getElementById('statResponse');
      if (statResp && window.moon_gallery_status) {
        try {
          const status = window.moon_gallery_status();
          statResp.textContent = status || `active: ${currentCompId} (${kTime}ms)`;
        } catch (e) {
          statResp.textContent = `active: ${currentCompId}`;
        }
      }
    }

    requestAnimationFrame(renderLoop);
  }

  window.setGalleryActiveComp = function (compId) {
    currentCompId = compId;
    resizeCanvas();
  };

  window.initNativeGallery = initCanvas;
  window.resizeGalleryCanvas = resizeCanvas;

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initCanvas);
  } else {
    initCanvas();
  }
})();
