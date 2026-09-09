// Moon-EGUI Canvas 2D Host Runner
(function () {
  const canvas = document.getElementById('moon-canvas');
  if (!canvas) return;

  const ctx = canvas.getContext('2d');
  const dpr = window.devicePixelRatio || 1;

  // Set display size versus coordinate resolution
  const width = 760;
  const height = 480;
  canvas.width = width * dpr;
  canvas.height = height * dpr;
  canvas.style.width = width + 'px';
  canvas.style.height = height + 'px';
  ctx.scale(dpr, dpr);

  let mouseX = -100;
  let mouseY = -100;
  let isMouseDown = false;

  // Track mouse coordinates relative to canvas
  canvas.addEventListener('mousemove', (e) => {
    const rect = canvas.getBoundingClientRect();
    mouseX = e.clientX - rect.left;
    mouseY = e.clientY - rect.top;
    updateStatus();
  });

  canvas.addEventListener('mousedown', (e) => {
    if (e.button === 0) {
      isMouseDown = true;
      updateStatus();
    }
  });

  window.addEventListener('mouseup', (e) => {
    if (e.button === 0) {
      isMouseDown = false;
      updateStatus();
    }
  });

  canvas.addEventListener('mouseleave', () => {
    mouseX = -100;
    mouseY = -100;
    isMouseDown = false;
    updateStatus();
  });

  function updateStatus() {
    const coordsEl = document.getElementById('telemetry-coords');
    if (coordsEl) {
      coordsEl.textContent = `(${Math.max(0, Math.round(mouseX))}, ${Math.max(0, Math.round(mouseY))})`;
    }
    const downEl = document.getElementById('telemetry-down');
    if (downEl) {
      downEl.textContent = isMouseDown ? 'PRESSED' : 'UP';
      downEl.style.color = isMouseDown ? '#60a5fa' : '#94a3b8';
    }
  }

  // Dynamically discover MoonBit step function in global scope
  function findMoonStep() {
    if (typeof window.moon_step === 'function') return window.moon_step;
    for (const key of Object.getOwnPropertyNames(window)) {
      if (key.includes('moon_2degui') && key.includes('canvas4step')) {
        return window[key];
      }
    }
    return null;
  }

  function renderDrawList(dl) {
    if (!dl || !dl.commands) return;

    // Clear background
    ctx.fillStyle = '#0f1117';
    ctx.fillRect(0, 0, width, height);

    // Render each geometric draw command
    for (let i = 0; i < dl.commands.length; i++) {
      const cmd = dl.commands[i];
      if (!cmd) continue;

      switch (cmd.$tag) {
        case 0: { // Rect
          const rect = cmd._0;
          const color = cmd._1;
          const radius = cmd._2 || 0;
          ctx.fillStyle = `rgba(${color.r}, ${color.g}, ${color.b}, ${color.a / 255})`;
          ctx.beginPath();
          if (ctx.roundRect) {
            ctx.roundRect(rect.x + 20, rect.y + 20, rect.w, rect.h, radius);
          } else {
            ctx.rect(rect.x + 20, rect.y + 20, rect.w, rect.h);
          }
          ctx.fill();
          break;
        }
        case 1: { // RectStroke
          const rect = cmd._0;
          const color = cmd._1;
          const strokeW = cmd._2 || 1;
          const radius = cmd._3 || 0;
          ctx.strokeStyle = `rgba(${color.r}, ${color.g}, ${color.b}, ${color.a / 255})`;
          ctx.lineWidth = strokeW;
          ctx.beginPath();
          if (ctx.roundRect) {
            ctx.roundRect(rect.x + 20, rect.y + 20, rect.w, rect.h, radius);
          } else {
            ctx.rect(rect.x + 20, rect.y + 20, rect.w, rect.h);
          }
          ctx.stroke();
          break;
        }
        case 4: { // Line
          const p1 = cmd._0;
          const p2 = cmd._1;
          const color = cmd._2;
          const strokeW = cmd._3 || 1;
          ctx.strokeStyle = `rgba(${color.r}, ${color.g}, ${color.b}, ${color.a / 255})`;
          ctx.lineWidth = strokeW;
          ctx.beginPath();
          ctx.moveTo(p1.x + 20, p1.y + 20);
          ctx.lineTo(p2.x + 20, p2.y + 20);
          ctx.stroke();
          break;
        }
        case 5: { // Text
          const pos = cmd._0;
          const text = cmd._1;
          const fontSize = cmd._2 || 14;
          const color = cmd._3;
          ctx.fillStyle = `rgba(${color.r}, ${color.g}, ${color.b}, ${color.a / 255})`;
          ctx.font = `600 ${fontSize}px -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif`;
          ctx.textBaseline = 'top';
          ctx.fillText(text, pos.x + 20, pos.y + 20);
          break;
        }
      }
    }

    const cmdsEl = document.getElementById('telemetry-cmds');
    if (cmdsEl) {
      cmdsEl.textContent = dl.commands.length;
    }
  }

  let stepFn = null;
  let lastTime = performance.now();
  let frameCount = 0;
  let fps = 60;

  function loop(currentTime) {
    frameCount++;
    if (currentTime - lastTime >= 1000) {
      fps = frameCount;
      frameCount = 0;
      lastTime = currentTime;
      const fpsEl = document.getElementById('telemetry-fps');
      if (fpsEl) fpsEl.textContent = fps;
    }

    if (!stepFn) {
      stepFn = findMoonStep();
    }

    if (stepFn) {
      // Pass coordinates offset by padding
      const effectiveX = Math.max(-100, mouseX - 20);
      const effectiveY = Math.max(-100, mouseY - 20);
      const dl = stepFn(effectiveX, effectiveY, isMouseDown);
      renderDrawList(dl);
    }

    requestAnimationFrame(loop);
  }

  requestAnimationFrame(loop);
})();
