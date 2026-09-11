const appState = {
      activeId: 'button',
      curtainPct: 0,
      compStates: {}
    };

    // DOM Elements
    const curtainDivider = document.getElementById('curtainDivider');
    const uiCurtainLayer = document.getElementById('uiCurtainLayer');
    const stageContainer = document.getElementById('stageContainer');
    const curtainRatioText = document.getElementById('curtainRatioText');
    const activeCompTitle = document.getElementById('activeCompTitle');
    const activeCompSignature = document.getElementById('activeCompSignature');
    const codeSnippetTarget = document.getElementById('codeSnippetTarget');
    const sandboxBox = document.getElementById('sandboxBox');
    const copyCodeBtn = document.getElementById('copyCodeBtn');
    const toastMsg = document.getElementById('toastMsg');

    function showToast(txt) {
      toastMsg.textContent = txt;
      toastMsg.classList.add('show');
      setTimeout(() => toastMsg.classList.remove('show'), 2000);
    }

    // Set Curtain Percentage (0 ~ 100)
    function setCurtain(pct) {
      pct = Math.max(0, Math.min(100, pct));
      appState.curtainPct = pct;

      // 100% exact mathematical lockstep synchronization
      curtainDivider.style.left = `${pct}%`;
      uiCurtainLayer.style.clipPath = `inset(0 0 0 ${pct}%)`;

      const codePct = Math.round(pct);
      const uiPct = 100 - codePct;
      curtainRatioText.textContent = T(`代码 ${codePct}% | UI ${uiPct}%`, `Code ${codePct}% | UI ${uiPct}%`);


      document.querySelectorAll('.seg-btn').forEach(b => b.classList.remove('active'));
      if (pct < 10) {
        document.getElementById('btnPresetUI').classList.add('active');
      } else if (pct > 40 && pct < 60) {
        document.getElementById('btnPresetSplit').classList.add('active');
      } else if (pct > 90) {
        document.getElementById('btnPresetCode').classList.add('active');
      }

      if (window.resizeGalleryCanvas) {
        window.resizeGalleryCanvas();
      }
    }

    // Dragging Logic
    let isDragging = false;

    function startDrag(e) {
      isDragging = true;
      curtainDivider.classList.add('dragging');
      window.addEventListener('mousemove', onDrag);
      window.addEventListener('mouseup', stopDrag);
      window.addEventListener('touchmove', onTouch);
      window.addEventListener('touchend', stopDrag);
      e.preventDefault();
    }

    function onDrag(e) {
      if (!isDragging) return;
      const rect = stageContainer.getBoundingClientRect();
      const pct = ((e.clientX - rect.left) / rect.width) * 100;
      setCurtain(pct);
    }

    function onTouch(e) {
      if (!isDragging || !e.touches || !e.touches[0]) return;
      const rect = stageContainer.getBoundingClientRect();
      const pct = ((e.touches[0].clientX - rect.left) / rect.width) * 100;
      setCurtain(pct);
    }

    function stopDrag() {
      if (!isDragging) return;
      isDragging = false;
      curtainDivider.classList.remove('dragging');
      window.removeEventListener('mousemove', onDrag);
      window.removeEventListener('mouseup', stopDrag);
      window.removeEventListener('touchmove', onTouch);
      window.removeEventListener('touchend', stopDrag);
    }

    curtainDivider.addEventListener('mousedown', startDrag);
    curtainDivider.addEventListener('touchstart', startDrag, { passive: false });


    // Presets
    document.getElementById('btnPresetUI').onclick = () => setCurtain(0);
    document.getElementById('btnPresetSplit').onclick = () => setCurtain(50);
    document.getElementById('btnPresetCode').onclick = () => setCurtain(100);

    curtainDivider.ondblclick = () => {
      if (appState.curtainPct < 25) setCurtain(50);
      else if (appState.curtainPct < 75) setCurtain(100);
      else setCurtain(0);
    };

    // Syntax Highlighter matching index.html colors
    function highlightMoonBit(raw) {
      return raw
        .replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;")
        .replace(/(\/\/\/.*|\/\/.*)/g, '<span class="code-comment">$1</span>')
        .replace(/\b(pub|fn|let|mut|match|struct|type|if|else|return|for|in|while|true|false)\b/g, '<span class="code-kw">$1</span>')
        .replace(/\b(Unit|Int|Double|String|Bool|UIContext|Response|AppState|Rect|Vec2)\b/g, '<span class="code-type">$1</span>')
        .replace(/(".*?")/g, '<span class="code-str">$1</span>')
        .replace(/\b([a-zA-Z_]\w*)(?=\()/g, '<span class="code-fn">$1</span>');
    }

    // Switch Component with smooth stage animation
    function switchComponent(id) {
      const comp = COMPONENTS[id];
      if (!comp) return;

      appState.activeId = id;
      activeCompTitle.textContent = t(comp.titleKey, comp.titleKey);
      activeCompSignature.textContent = comp.signature;
      codeSnippetTarget.innerHTML = highlightMoonBit(L(comp.code));

      codeSnippetTarget.classList.remove('is-animating');
      void codeSnippetTarget.offsetWidth; // trigger reflow
      codeSnippetTarget.classList.add('is-animating');

      if (window.setGalleryActiveComp) {
        window.setGalleryActiveComp(id);
      }

      document.querySelectorAll('.comp-btn').forEach(btn => {
        if (btn.getAttribute('data-id') === id) {
          btn.classList.add('active');
        } else {
          btn.classList.remove('active');
        }
      });
    }

    document.querySelectorAll('.comp-btn').forEach(btn => {
      btn.onclick = () => switchComponent(btn.getAttribute('data-id'));
    });

    copyCodeBtn.onclick = () => {
      const comp = COMPONENTS[appState.activeId];
      if (!comp) return;
      navigator.clipboard.writeText(L(comp.code)).then(() => {
        showToast(t('toast.copied'));
      });
    };

    // Filter
    document.getElementById('filterInput').oninput = (e) => {
      const q = e.target.value.toLowerCase().trim();
      document.querySelectorAll('.comp-btn').forEach(btn => {
        const text = btn.textContent.toLowerCase();
        const id = btn.getAttribute('data-id').toLowerCase();
        btn.style.display = (!q || text.includes(q) || id.includes(q)) ? 'flex' : 'none';
      });
    };

    // Keyboard Arrow Keys
    window.addEventListener('keydown', (e) => {
      if (e.target.tagName === 'INPUT') return;
      if (e.key === 'ArrowRight') setCurtain(appState.curtainPct + 5);
      if (e.key === 'ArrowLeft') setCurtain(appState.curtainPct - 5);
    });

    // Initial State
    switchComponent('button');
    setCurtain(0);

    // Language swap: repaint the static chrome, then rebuild the stage
    // (component titles, code sample, demo labels and status text all
    // resolve through T() at render time).
    document.addEventListener('langchange', (e) => {
      if (e.detail && e.detail.initial) return;
      switchComponent(appState.activeId);
      setCurtain(appState.curtainPct);
    });
