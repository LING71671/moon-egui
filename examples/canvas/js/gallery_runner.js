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
  let isSecondaryMouseDown = false;
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

    // Off-screen hidden text input element for native browser IME composition (CJK, accents)
    let imeInput = document.getElementById('canvasImeInput');
    if (!imeInput) {
      imeInput = document.createElement('textarea');
      imeInput.id = 'canvasImeInput';
      imeInput.setAttribute('autocomplete', 'off');
      imeInput.setAttribute('autocorrect', 'off');
      imeInput.setAttribute('autocapitalize', 'off');
      imeInput.setAttribute('spellcheck', 'false');
      imeInput.style.cssText = 'position:fixed; opacity:0; pointer-events:none; left:0; top:0; width:1px; height:1px; z-index:-1; border:none; outline:none; background:transparent; resize:none; overflow:hidden;';
      document.body.appendChild(imeInput);
    }

    let isComposing = false;

    imeInput.addEventListener('compositionstart', () => {
      isComposing = true;
    });

    imeInput.addEventListener('compositionend', (e) => {
      isComposing = false;
      if (e.data) {
        pendingText += e.data;
      }
      imeInput.value = '';
    });

    imeInput.addEventListener('input', (e) => {
      if (!isComposing && imeInput.value) {
        pendingText += imeInput.value;
        imeInput.value = '';
      }
    });

    function handleKeyDown(e) {
      modFlags = 0;
      if (e.shiftKey) modFlags |= 2;
      if (e.ctrlKey) modFlags |= 1;
      if (e.altKey) modFlags |= 4;
      if (e.metaKey) modFlags |= 8;

      if (e.key.length > 1) {
        keysPressed.push(e.key);
        if (['ArrowUp', 'ArrowDown', 'ArrowLeft', 'ArrowRight', 'Tab', 'Enter', 'Backspace', 'Delete', 'Escape', 'Home', 'End'].includes(e.key)) {
          e.preventDefault();
        }
      } else if (!isComposing && !e.ctrlKey && !e.metaKey && !e.altKey && e.target !== imeInput) {
        pendingText += e.key;
        if (e.key === ' ') e.preventDefault();
      }
    }

    function handleKeyUp(e) {
      if (e.key.length > 1) {
        keysReleased.push(e.key);
      }
    }

    canvas.addEventListener('keydown', handleKeyDown, { passive: false });
    canvas.addEventListener('keyup', handleKeyUp);
    imeInput.addEventListener('keydown', handleKeyDown, { passive: false });
    imeInput.addEventListener('keyup', handleKeyUp);

    canvas.addEventListener('mousemove', (e) => {
      const rect = canvas.getBoundingClientRect();
      mouseX = e.clientX - rect.left;
      mouseY = e.clientY - rect.top;
    }, { passive: true });

    canvas.addEventListener('mousedown', (e) => {
      const rect = canvas.getBoundingClientRect();
      mouseX = e.clientX - rect.left;
      mouseY = e.clientY - rect.top;
      if (e.button === 0) {
        isMouseDown = true;
        canvas.focus();
        if (imeInput) imeInput.focus();
      } else if (e.button === 2) {
        isSecondaryMouseDown = true;
        canvas.focus();
      }
    });

    window.addEventListener('mouseup', (e) => {
      if (e.button === 0) {
        isMouseDown = false;
      } else if (e.button === 2) {
        isSecondaryMouseDown = false;
      }
    });

    // Touch gesture support for mobile and stylus pointers
    function updateTouchPointer(e) {
      if (!canvas || !e.touches || e.touches.length === 0) return;
      const t = e.touches[0];
      const rect = canvas.getBoundingClientRect();
      mouseX = t.clientX - rect.left;
      mouseY = t.clientY - rect.top;
    }

    canvas.addEventListener('touchstart', (e) => {
      updateTouchPointer(e);
      isMouseDown = true;
      if (imeInput) imeInput.focus();
      if (e.cancelable) e.preventDefault();
    }, { passive: false });

    canvas.addEventListener('touchmove', (e) => {
      updateTouchPointer(e);
      if (e.cancelable) e.preventDefault();
    }, { passive: false });

    window.addEventListener('touchend', () => {
      isMouseDown = false;
    });

    window.addEventListener('touchcancel', () => {
      isMouseDown = false;
    });

    canvas.addEventListener('contextmenu', (e) => {
      e.preventDefault();
    });

    canvas.addEventListener('mouseleave', () => {
      mouseX = -100;
      mouseY = -100;
    });

    // Trackpad and wheel scrolling supporting vertical and horizontal delta
    canvas.addEventListener('wheel', (e) => {
      scrollDy += e.deltaY;
      if (Math.abs(e.deltaX) > 0.01 && Math.abs(e.deltaY) < 0.01) {
        scrollDy += e.deltaX;
      }
      e.preventDefault();
    }, { passive: false });

    window.addEventListener('resize', resizeCanvas);
  }

  function renderDrawList(dl) {
    if (!dl || !dl.commands) return;
    cachedFont = '';
    cachedFillStyle = '';
    cachedStrokeStyle = '';
    cachedLineWidth = -1;
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
        modFlags,
        isSecondaryMouseDown
      );
      const kTime = (performance.now() - t0).toFixed(2);

      // Reset per-frame transient inputs
      scrollDy = 0.0;
      pendingText = '';
      keysPressed = [];
      keysReleased = [];

      ctx.clearRect(0, 0, width, height);
      renderDrawList(dl);

      // Update dynamic canvas cursor based on MoonBit core interaction state
      if (window.moon_gallery_cursor) {
        try {
          const cur = window.moon_gallery_cursor();
          if (canvas.style.cursor !== cur) {
            canvas.style.cursor = cur;
          }
        } catch (e) {}
      }

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

  window.setGalleryViewMode = function (mode) {
    if (window.moon_set_gallery_view_mode) {
      try {
        window.moon_set_gallery_view_mode(mode);
      } catch (e) {}
    }
  };

  window.setGalleryTheme = function (themeIdx) {
    if (window.moon_set_gallery_theme) {
      try {
        window.moon_set_gallery_theme(themeIdx);
      } catch (e) {}
    }
  };

  window.initNativeGallery = initCanvas;
  window.resizeGalleryCanvas = resizeCanvas;

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initCanvas);
  } else {
    initCanvas();
  }
})();
