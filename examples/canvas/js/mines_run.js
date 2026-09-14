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

// Host driver for minesweeper.html - a slim loop that only forwards pointer
// state to `window.moon_mines_step`, blits the returned DrawList, and prints
// the frame's telemetry into the chrome.
(function () {
  'use strict';

  const canvas = document.getElementById('mines-canvas');
  const ctx = canvas.getContext('2d');

  // The canvas is a flex item between the two chrome bars, so its drawing
  // buffer follows its own box rather than the window, and pointer events are
  // translated into canvas-local coordinates. Assuming the canvas covers the
  // viewport would offset every hit test by the height of the top bar.
  let width = 1;
  let height = 1;
  let originX = 0;
  let originY = 0;

  const OFF = -100000;

  let mouseX = OFF;
  let mouseY = OFF;
  let isMouseDown = false;
  let secondaryDown = false;
  let panDX = 0;
  let panDY = 0;
  let zoomDelta = 0;
  let downX = 0;
  let downY = 0;
  let moved = false;
  let pendingAction = -1;
  let lastX = undefined;
  let lastY = undefined;

  function resize() {
    const dpr = Math.min(window.devicePixelRatio || 1, 2);
    const rect = canvas.getBoundingClientRect();
    width = Math.max(1, Math.round(rect.width));
    height = Math.max(1, Math.round(rect.height));
    originX = rect.left;
    originY = rect.top;
    canvas.width = Math.floor(width * dpr);
    canvas.height = Math.floor(height * dpr);
    ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
  }
  window.addEventListener('resize', resize);
  resize();

  function localX(e) {
    return e.clientX - originX;
  }
  function localY(e) {
    return e.clientY - originY;
  }

  canvas.addEventListener('mousemove', (e) => {
    mouseX = localX(e);
    mouseY = localY(e);
    if (isMouseDown && !moved) {
      const dx = e.clientX - downX;
      const dy = e.clientY - downY;
      if (dx * dx + dy * dy > 16) moved = true;
    }
    if (isMouseDown && moved) {
      panDX += e.clientX - (lastX === undefined ? e.clientX : lastX);
      panDY += e.clientY - (lastY === undefined ? e.clientY : lastY);
    }
    lastX = e.clientX;
    lastY = e.clientY;
  });

  canvas.addEventListener('mouseleave', () => {
    mouseX = OFF;
    mouseY = OFF;
  });

  // A click whose press and release both land between two animation frames
  // would never be seen by the engine: it samples the button once per frame,
  // so a sub-frame click produced no press edge at all and the dig was
  // silently dropped. Every press now also raises a one-frame latch, which
  // keeps the button "down" for exactly the frame that consumes it and turns
  // such a click into an ordinary press/release pair.
  let leftPulse = false;
  let rightPulse = false;

  canvas.addEventListener('mousedown', (e) => {
    lastX = e.clientX;
    lastY = e.clientY;
    moved = false;
    downX = e.clientX;
    downY = e.clientY;
    if (e.button === 0) { isMouseDown = true; leftPulse = true; }
    if (e.button === 2) { secondaryDown = true; rightPulse = true; }
  });

  window.addEventListener('mouseup', (e) => {
    if (e.button === 0) isMouseDown = false;
    if (e.button === 2) secondaryDown = false;
  });

  // A mouseup delivered outside the window never arrives, which would leave
  // the board glued to the pointer; drop the drag state on focus loss.
  window.addEventListener('blur', () => {
    isMouseDown = false;
    secondaryDown = false;
    panDX = 0;
    panDY = 0;
  });

  canvas.addEventListener('contextmenu', (e) => e.preventDefault());

  canvas.addEventListener('wheel', (e) => {
    e.preventDefault();
    mouseX = localX(e);
    mouseY = localY(e);
    zoomDelta += e.deltaY < 0 ? 1 : -1;
  }, { passive: false });

  // Toolbar buttons queue an action code for the next frame:
  // 0 new field, 1 flag mode, 2 zoom in, 3 zoom out, 4 default zoom, 5 recentre
  window.minesSetAction = function (a) {
    pendingAction = a;
  };

  function getColorStr(color) {
    return 'rgba(' + color.r + ',' + color.g + ',' + color.b + ',' + (color.a / 255).toFixed(3) + ')';
  }

  let cachedFont = '';
  function setFont(str) {
    if (cachedFont !== str) {
      ctx.font = str;
      cachedFont = str;
    }
  }

  function renderDrawList(dl) {
    ctx.fillStyle = '#f8fafc';
    ctx.fillRect(0, 0, width, height);
    cachedFont = '';
    const cmds = dl ? dl.commands : [];
    for (let i = 0; i < cmds.length; i++) {
      const cmd = cmds[i];
      if (!cmd) continue;
      switch (cmd.$tag) {
        case 0: {
          const rect = cmd._0;
          const radius = cmd._2 || 0;
          ctx.fillStyle = getColorStr(cmd._1);
          if (radius > 1 && ctx.roundRect) {
            ctx.beginPath();
            ctx.roundRect(rect.x, rect.y, rect.w, rect.h, radius);
            ctx.fill();
          } else {
            ctx.fillRect(rect.x, rect.y, rect.w, rect.h);
          }
          break;
        }
        case 1: {
          const rect = cmd._0;
          ctx.strokeStyle = getColorStr(cmd._1);
          ctx.lineWidth = cmd._2 || 1;
          ctx.beginPath();
          const radius = cmd._3 || 0;
          if (radius > 0 && ctx.roundRect) {
            ctx.roundRect(rect.x, rect.y, rect.w, rect.h, radius);
          } else {
            ctx.rect(rect.x, rect.y, rect.w, rect.h);
          }
          ctx.stroke();
          break;
        }
        case 2: {
          ctx.fillStyle = getColorStr(cmd._2);
          ctx.beginPath();
          ctx.arc(cmd._0.x, cmd._0.y, cmd._1, 0, Math.PI * 2);
          ctx.fill();
          break;
        }
        case 3: {
          ctx.strokeStyle = getColorStr(cmd._2);
          ctx.lineWidth = cmd._3 || 1;
          ctx.beginPath();
          ctx.arc(cmd._0.x, cmd._0.y, cmd._1, 0, Math.PI * 2);
          ctx.stroke();
          break;
        }
        case 4: {
          ctx.strokeStyle = getColorStr(cmd._2);
          ctx.lineWidth = cmd._3 || 1;
          ctx.beginPath();
          ctx.moveTo(cmd._0.x, cmd._0.y);
          ctx.lineTo(cmd._1.x, cmd._1.y);
          ctx.stroke();
          break;
        }
        case 5: {
          ctx.fillStyle = getColorStr(cmd._3);
          setFont((cmd._5 || 500) + ' ' + (cmd._2 || 14) + 'px ' + (cmd._4 || 'sans-serif'));
          ctx.textBaseline = 'top';
          ctx.fillText(cmd._1, cmd._0.x, cmd._0.y);
          break;
        }
        case 6: {
          ctx.save();
          ctx.beginPath();
          ctx.rect(cmd._0.x, cmd._0.y, cmd._0.w, cmd._0.h);
          ctx.clip();
          break;
        }
        case 7: {
          ctx.restore();
          cachedFont = '';
          break;
        }
        case 8: {
          const rect = cmd._0;
          const grad = ctx.createLinearGradient(cmd._1.x, cmd._1.y, cmd._2.x, cmd._2.y);
          grad.addColorStop(0, getColorStr(cmd._3));
          grad.addColorStop(1, getColorStr(cmd._4));
          ctx.fillStyle = grad;
          ctx.fillRect(rect.x, rect.y, rect.w, rect.h);
          break;
        }
      }
    }
  }

  const elFps = document.getElementById('telemetry-fps');
  const elRevealed = document.getElementById('telemetry-revealed');
  const elFlags = document.getElementById('telemetry-flags');
  const elHits = document.getElementById('telemetry-hits');
  const elCoords = document.getElementById('telemetry-coords');
  const elZoom = document.getElementById('telemetry-zoom');
  const elResetZoom = document.getElementById('btn-zoom-reset');
  const elState = document.getElementById('telemetry-state');

  const DEFAULT_CELL = 22;   // mirrors DEFAULT_CELL in mines_main.mbt

  let lastFpsTime = performance.now();
  let frames = 0;

  function loop() {
    try {
      const res = window.moon_mines_step(
        mouseX, mouseY, isMouseDown || leftPulse, secondaryDown || rightPulse,
        panDX, panDY, zoomDelta,
        // keep this list in lockstep with mines_step's signature: a stale
        // extra arg shifts every later parameter one slot left (a leftover
        // density arg made vp_w = 156 -> a 156px-wide world)
        pendingAction,
        width, height
      );
      panDX = 0;
      panDY = 0;
      zoomDelta = 0;
      pendingAction = -1;
      // The pulses are one-frame latches: clear them AFTER the frame that
      // consumed them. Leaving them set kept the engine permanently "held
      // down" - it saw a press once and then never a release, so `revealed`
      // stayed 0 forever and a right click could plant exactly one flag.
      leftPulse = false;
      rightPulse = false;

      window.minesLastFrame = res;
      renderDrawList(res.draw_list);
      // The engine owns the pointer feedback (pointer over unopened tiles,
      // default over dug ground); the host only has to publish it.
      if (canvas.style.cursor !== res.cursor) canvas.style.cursor = res.cursor;

      frames++;
      const now = performance.now();
      if (now - lastFpsTime >= 500) {
        const fps = (frames * 1000) / (now - lastFpsTime);
        frames = 0;
        lastFpsTime = now;
        if (elFps) elFps.textContent = fps.toFixed(0);
      }

      if (elRevealed) elRevealed.textContent = res.revealed.toLocaleString();
      if (elFlags) elFlags.textContent = res.flagged.toLocaleString();
      if (elHits) {
        elHits.textContent = res.hits.toLocaleString();
        elHits.classList.toggle('is-hit', res.hits > 0);
      }
      if (elZoom && elResetZoom) {
        const pct = Math.round((res.cell / DEFAULT_CELL) * 100);
        elZoom.textContent = pct + '%';
        elResetZoom.textContent = pct + '%';
      }
      if (elState) elState.textContent = res.pending ? T('连锁展开中', 'Cascading') : T('就绪', 'Ready');
      if (elCoords) {
        elCoords.textContent = mouseX <= OFF / 2
          ? '\u2014'
          : '(' + res.tile_x + ', ' + res.tile_y + ')';
      }

      requestAnimationFrame(loop);
    } catch (e) {
      window.__loopErr = (e && e.message) || String(e);
      console.error('mines loop error:', e);
      requestAnimationFrame(loop);
    }
  }
  requestAnimationFrame(loop);
})();
