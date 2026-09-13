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
// state to `window.moon_mines_step` and blits the returned DrawList.
(function () {
  'use strict';

  const canvas = document.getElementById('mines-canvas');
  const ctx = canvas.getContext('2d');
  let width = window.innerWidth;
  let height = window.innerHeight;

  let mouseX = -1000;
  let mouseY = -1000;
  let isMouseDown = false;
  let secondaryDown = false;
  let panDX = 0;
  let panDY = 0;
  let zoomDelta = 0;
  let downX = 0;
  let downY = 0;
  let moved = false;
  let pendingAction = -1;
  let densityPermille = 156;

  function resize() {
    const dpr = Math.min(window.devicePixelRatio || 1, 2);
    width = window.innerWidth;
    height = window.innerHeight;
    canvas.width = Math.floor(width * dpr);
    canvas.height = Math.floor(height * dpr);
    canvas.style.width = width + 'px';
    canvas.style.height = height + 'px';
    ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
  }
  window.addEventListener('resize', resize);
  resize();

  canvas.addEventListener('mousemove', (e) => {
    mouseX = e.clientX;
    mouseY = e.clientY;
    if (isMouseDown && !moved) {
      const dx = e.clientX - downX;
      const dy = e.clientY - downY;
      if (dx * dx + dy * dy > 16) moved = true;
    }
    if (isMouseDown && moved) {
      panDX += e.clientX - (minesLastX === undefined ? e.clientX : minesLastX);
      panDY += e.clientY - (minesLastY === undefined ? e.clientY : minesLastY);
    }
    minesLastX = e.clientX;
    minesLastY = e.clientY;
  });
  let minesLastX = undefined;
  let minesLastY = undefined;

  canvas.addEventListener('mousedown', (e) => {
    minesLastX = e.clientX;
    minesLastY = e.clientY;
    moved = false;
    downX = e.clientX;
    downY = e.clientY;
    if (e.button === 0) isMouseDown = true;
    if (e.button === 2) secondaryDown = true;
  });

  window.addEventListener('mouseup', (e) => {
    if (e.button === 0) isMouseDown = false;
    if (e.button === 2) secondaryDown = false;
  });

  canvas.addEventListener('contextmenu', (e) => e.preventDefault());

  canvas.addEventListener('wheel', (e) => {
    e.preventDefault();
    mouseX = e.clientX;
    mouseY = e.clientY;
    zoomDelta += e.deltaY < 0 ? 1 : -1;
  }, { passive: false });

  window.minesSetAction = function (a) {
    pendingAction = a;
    window.minesPendingAction = a;
  };
  window.minesSetDensity = function (v) {
    densityPermille = v;
    document.getElementById('density-value').textContent = v + '‰';
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

  const elRevealed = document.getElementById('stat-revealed');
  const elFlags = document.getElementById('stat-flags');
  const elCascade = document.getElementById('stat-cascade');
  const elHits = document.getElementById('stat-hits');
  const elCoords = document.getElementById('stat-coords');

  let lastFpsTime = performance.now();
  let frames = 0;
  let fps = 60;

  function loop() {
    try {
    const res = window.moon_mines_step(
      mouseX, mouseY, isMouseDown, secondaryDown,
      panDX, panDY, zoomDelta,
      pendingAction, densityPermille,
      width, height
    );
    panDX = 0;
    panDY = 0;
    zoomDelta = 0;
    pendingAction = -1;

    window.minesLastFrame = res;
    renderDrawList(res.draw_list);
    if (canvas.style.cursor !== res.cursor) {
      canvas.style.cursor = res.cursor;
    }

    frames++;
    const now = performance.now();
    if (now - lastFpsTime >= 500) {
      fps = (frames * 1000) / (now - lastFpsTime);
      frames = 0;
      lastFpsTime = now;
      const fpsEl = document.getElementById('stat-fps');
      if (fpsEl) fpsEl.textContent = fps.toFixed(0);
    }
    if (elRevealed) elRevealed.textContent = res.revealed.toLocaleString();
    if (elFlags) elFlags.textContent = res.flagged.toLocaleString();
    if (elHits) elHits.textContent = res.hits.toLocaleString();
    if (elCascade) elCascade.textContent = res.pending ? '连锁展开中…' : (res.boom ? '踩雷！' : '完成');
    if (elCoords) {
      elCoords.textContent = '(' + Math.floor(mouseX) + ', ' + Math.floor(mouseY) + ') px';
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
