// MoonBit moon-egui Canvas 2D High-Performance Host Adapter
(function () {
  const canvas = document.getElementById('moon-canvas');
  if (!canvas) return;

  const ctx = canvas.getContext('2d', { alpha: false });
  const dpr = window.devicePixelRatio || 1;

  // Viewport dimensions (920 x 540)
  const width = 920;
  const height = 540;

  canvas.width = Math.round(width * dpr);
  canvas.height = Math.round(height * dpr);
  canvas.style.width = width + 'px';
  canvas.style.height = height + 'px';
  ctx.scale(dpr, dpr);

  let mouseX = -100;
  let mouseY = -100;
  let isMouseDown = false;

  // Mouse / Pointer Event Listeners
  canvas.addEventListener('mousemove', (e) => {
    const rect = canvas.getBoundingClientRect();
    mouseX = e.clientX - rect.left;
    mouseY = e.clientY - rect.top;
    updateCursorHud();
  }, { passive: true });

  canvas.addEventListener('mousedown', (e) => {
    if (e.button === 0) {
      isMouseDown = true;
      updateCursorHud();
    }
  });

  window.addEventListener('mouseup', (e) => {
    if (e.button === 0) {
      isMouseDown = false;
      updateCursorHud();
    }
  });

  canvas.addEventListener('mouseleave', () => {
    mouseX = -100;
    mouseY = -100;
    isMouseDown = false;
    updateCursorHud();
  });

  function updateCursorHud() {
    const coordsEl = document.getElementById('telemetry-coords');
    if (coordsEl) {
      coordsEl.textContent = `(${Math.max(0, Math.round(mouseX))}, ${Math.max(0, Math.round(mouseY))})`;
    }
    const stateEl = document.getElementById('telemetry-down');
    if (stateEl) {
      stateEl.textContent = isMouseDown ? 'PRESSED' : (mouseX >= 0 && mouseY >= 0 ? 'ACTIVE' : 'IDLE');
      stateEl.className = isMouseDown ? 'status-val status-pressed' : (mouseX >= 0 && mouseY >= 0 ? 'status-val status-hover' : 'status-val');
    }
  }

  // Retrieve step function
  function getStepFn() {
    if (typeof window.moon_step === 'function') return window.moon_step;
    if (typeof globalThis.moon_step === 'function') return globalThis.moon_step;
    for (const key of Object.getOwnPropertyNames(window)) {
      if (key.includes('canvas4step') || (key.includes('moon_2degui') && key.includes('step'))) {
        return window[key];
      }
    }
    return null;
  }

  // Pre-cached canvas state to prevent browser string recalculations
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

  function setStroke(colorStr, width) {
    if (cachedStrokeStyle !== colorStr) {
      ctx.strokeStyle = colorStr;
      cachedStrokeStyle = colorStr;
    }
    if (cachedLineWidth !== width) {
      ctx.lineWidth = width;
      cachedLineWidth = width;
    }
  }

  function setFont(fontStr) {
    if (cachedFont !== fontStr) {
      ctx.font = fontStr;
      cachedFont = fontStr;
    }
  }

  function renderDrawList(dl) {
    if (!dl || !dl.commands) return;

    // Fast clear
    setFill('#0a0c12');
    ctx.fillRect(0, 0, width, height);

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
          const colorStr = `rgba(${color.r},${color.g},${color.b},${color.a / 255})`;
          setFill(colorStr);
          ctx.beginPath();
          if (radius > 0 && ctx.roundRect) {
            ctx.roundRect(rect.x, rect.y, rect.w, rect.h, radius);
          } else {
            ctx.rect(rect.x, rect.y, rect.w, rect.h);
          }
          ctx.fill();
          break;
        }
        case 1: { // RectStroke: cmd._0: rect, cmd._1: color, cmd._2: strokeW, cmd._3: radius
          const rect = cmd._0;
          const color = cmd._1;
          const strokeW = cmd._2 || 1;
          const radius = cmd._3 || 0;
          const colorStr = `rgba(${color.r},${color.g},${color.b},${color.a / 255})`;
          setStroke(colorStr, strokeW);
          ctx.beginPath();
          if (radius > 0 && ctx.roundRect) {
            ctx.roundRect(rect.x, rect.y, rect.w, rect.h, radius);
          } else {
            ctx.rect(rect.x, rect.y, rect.w, rect.h);
          }
          ctx.stroke();
          break;
        }
        case 4: { // Line: cmd._0: p1, cmd._1: p2, cmd._2: color, cmd._3: strokeW
          const p1 = cmd._0;
          const p2 = cmd._1;
          const color = cmd._2;
          const strokeW = cmd._3 || 1;
          const colorStr = `rgba(${color.r},${color.g},${color.b},${color.a / 255})`;
          setStroke(colorStr, strokeW);
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
          const colorStr = `rgba(${color.r},${color.g},${color.b},${color.a / 255})`;
          setFill(colorStr);
          setFont(`600 ${fontSize}px ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace`);
          ctx.textBaseline = 'top';
          ctx.fillText(text, pos.x, pos.y);
          break;
        }
      }
    }

    const cmdsEl = document.getElementById('telemetry-cmds');
    if (cmdsEl) {
      cmdsEl.textContent = len.toLocaleString();
    }
  }

  let stepFn = null;
  let lastFpsTime = performance.now();
  let frameCounter = 0;
  let fps = 60;
  let kernelTimeRolling = 0.2;

  function loop(now) {
    frameCounter++;
    if (now - lastFpsTime >= 500) {
      fps = Math.round((frameCounter * 1000) / (now - lastFpsTime));
      frameCounter = 0;
      lastFpsTime = now;
      const fpsEl = document.getElementById('telemetry-fps');
      if (fpsEl) fpsEl.textContent = fps.toFixed(1);
    }

    if (!stepFn) {
      stepFn = getStepFn();
    }

    if (stepFn) {
      // Benchmark precise MoonBit kernel computation time
      const t0 = performance.now();
      const dl = stepFn(mouseX, mouseY, isMouseDown);
      const dt = performance.now() - t0;

      // Exponential moving average for jitter-free metric display
      kernelTimeRolling = kernelTimeRolling * 0.85 + dt * 0.15;

      renderDrawList(dl);

      // Telemetry updates
      const kernelEl = document.getElementById('telemetry-kernel');
      if (kernelEl) {
        kernelEl.textContent = `${kernelTimeRolling.toFixed(2)} ms`;
      }

      const budgetPct = Math.min(100, Math.max(0.1, (kernelTimeRolling / 16.666) * 100));
      const budgetPctEl = document.getElementById('telemetry-budget-pct');
      if (budgetPctEl) {
        budgetPctEl.textContent = `${budgetPct.toFixed(1)}%`;
      }

      const budgetBar = document.getElementById('telemetry-budget-bar');
      if (budgetBar) {
        budgetBar.style.width = `${budgetPct}%`;
      }

      const throughputEl = document.getElementById('telemetry-throughput');
      if (throughputEl && dl && dl.commands) {
        // Each widget performs at least 1 AABB hit-test per frame
        const estimatedWidgets = Math.max(144, Math.round(dl.commands.length * 0.95));
        const aabbPerSec = estimatedWidgets * 60;
        throughputEl.textContent = `${aabbPerSec.toLocaleString()} / s`;
      }
    }

    requestAnimationFrame(loop);
  }

  requestAnimationFrame(loop);
})();
