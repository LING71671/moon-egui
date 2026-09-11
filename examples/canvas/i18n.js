/* moon-egui — bilingual layer (zh / en)
 * Resolution order: ?lang= → localStorage → navigator.languages → zh
 * Markup hooks:
 *   [data-i18n]              textContent replacement
 *   [data-i18n-html]         innerHTML replacement (same element also carries data-i18n)
 *   [data-i18n-attrs]        "title=key;placeholder=key" attribute pairs
 *   [data-lang-switch]       mount point for the zh / EN control
 *   <body data-i18n-title>   document.title key
 * Scripts may call t(key) / L({zh,en}) / T(zh,en) at any time, and listen for
 * the "langchange" event on document to re-render dynamic content.
 */
(function () {
  'use strict';

  var STORAGE_KEY = 'moon-egui.lang';
  var SUPPORTED = ['zh', 'en'];
  var FALLBACK_LANG = 'zh';

  /* ------------------------------------------------------------------ *
   * Dictionary — static markup only. Inline script strings use T().
   * ------------------------------------------------------------------ */
  var DICT = {
    zh: {
      /* --- shared --- */
      'nav.gallery': '组件展厅',
      'nav.canvas': '画板演示',
      'nav.architecture': '设计架构',
      'nav.code': '代码范例',
      'nav.github': 'GitHub 源码',
      'nav.openCanvas': '进入画板 →',
      'footer.copy': '© 2026 Ling71671. Apache 2.0 协议开源项目。',
      'footer.canvas': '画板',
      'footer.moonbit': 'MoonBit 官网',

      /* --- index.html --- */
      'index.title': 'moon-egui | MoonBit 原生即时模式 GUI 引擎',
      'hero.title': 'MoonBit 原生即时模式 GUI 引擎',
      'hero.subtitle': '零外部依赖、微秒级帧管线，面向 WebAssembly 与 Canvas 2D 的高性能即时渲染内核。',
      'hero.ctaGallery': '组件展厅',
      'hero.ctaCanvas': 'CAD 矩阵画板',
      'hero.ctaCode': '查看声明式代码',
      'wb.caption': 'CAD 矩阵画板实时运行预览',
      'wb.openNewTab': '新标签页打开 ↗',
      'wb.iframeTitle': 'moon-egui 实时画板',
      'features.title': '核心工程特性',
      'features.desc': '抛弃虚拟 DOM 与双向绑定，用纯函数与即时布局构筑现代界面。',
      'p1.title': '即时模式架构',
      'p1.desc': '每帧重绘、状态就地声明。无虚拟 DOM 树比对与垃圾回收抖动，界面逻辑即业务数据，代码结构极其扁平清爽。',
      'p2.title': '微秒级帧管线',
      'p2.desc': '视口自适应空间剔除与图元合并，百万级逻辑节点画板下帧内核计算耗时仅 0.1ms，稳定跑满 60 FPS 刷新率。',
      'p3.title': '纯粹原生与多后端',
      'p3.desc': '基于 MoonBit 原生代数数据类型构建，不绑定特定浏览器 API，可轻松适配 WebAssembly、Canvas 2D 及跨平台原生桌面。',
      'code.title': '声明式语法，所见即所得',
      'code.p1': '在即时模式下，界面组件没有复杂的生命周期回调，每一行声明直接对应当帧的绘制与事件命中。',
      'code.p2': '窗口容器、按钮、滑块、网格排列等常见控件均具备统一的布局流，极易嵌入至任何复杂的 CAD 画布与游戏引擎。',
      'code.windowTitle': '"属性面板"',
      'code.param': '"控制参数"',
      'code.resetBtn': '"重置视图"',
      'quickstart.title': '在 MoonBit 项目中快速引入依赖',
      'quickstart.sub': '支持 MoonBit 最新版本包管理规范',
      'quickstart.copy': '复制',
      'quickstart.copied': '已复制',
      'quickstart.copyTitle': '复制安装命令',

      /* --- gallery.html --- */
      'gallery.title': 'moon-egui | 组件展厅',
      'gallery.heroTitle': '组件展厅',
      'gallery.heroSub': '探索即时模式基础组件。拖动中央滑块可实时对比 UI 与源码。',
      'preset.ui': '纯 UI (0%)',
      'preset.split': '50/50 对比',
      'preset.code': '源码 (100%)',
      'search.ph': '搜索组件...',
      'cat.basic': '基础输入',
      'cat.values': '选择与数值',
      'cat.feedback': '反馈与展示',
      'cat.layout': '容器与排版',
      'comp.button.title': 'Button 按钮',
      'comp.button.tag': '交互',
      'comp.text_edit.title': 'TextEdit 文本输入',
      'comp.text_edit.tag': '编辑',
      'comp.checkbox.title': 'Checkbox 复选框',
      'comp.checkbox.tag': '开关',
      'comp.toggle.title': 'Toggle 胶囊开关',
      'comp.toggle.tag': '切换',
      'comp.radio.title': 'Radio 单选按钮',
      'comp.radio.tag': '单选',
      'comp.slider.title': 'Slider 滑动条',
      'comp.slider.tag': '数值',
      'comp.drag_value.title': 'DragValue 数字微调',
      'comp.drag_value.tag': '拖动',
      'comp.combo_box.title': 'ComboBox 下拉框',
      'comp.combo_box.tag': '选项',
      'comp.color_button.title': 'ColorButton 调色板',
      'comp.color_button.tag': '色彩',
      'comp.progress_bar.title': 'ProgressBar 进度条',
      'comp.progress_bar.tag': '进度',
      'comp.collapsing_header.title': 'CollapsingHeader 折叠树',
      'comp.collapsing_header.tag': '树形',
      'comp.tooltip.title': 'Tooltip 悬浮提示',
      'comp.tooltip.tag': '气泡',
      'comp.tab_bar.title': 'TabBar 标签导航',
      'comp.tab_bar.tag': '选项卡',
      'comp.scroll_area.title': 'ScrollArea 滚动区域',
      'comp.scroll_area.tag': '裁剪',
      'comp.window.title': 'Window 浮动窗口',
      'comp.window.tag': '面板',
      'wb.copy': '复制代码',
      'wb.response': '状态响应',
      'wb.refresh': '内核刷新率',
      'wb.kernelRate': '60 FPS',
      'curtain.drag': '左右拖拽对比 UI 与源码',
      'toast.copied': '已成功复制代码到剪贴板！',

      /* --- benchmark.html --- */
      'benchmark.title': 'moon-egui | 原生即时模式 CAD 矩阵画板',
      'bm.back': '返回',
      'bm.backTitle': '返回官网',
      'bm.components': '组件展厅',
      'bm.componentsTitle': '查看组件展厅与源码帘幕',
      'bm.canvas': '画板',
      'bm.wave': '水波',
      'bm.repel': '斥力',
      'bm.pan': '漫游',
      'bm.dragMode': '拖拽',
      'bm.center': '居中',
      'bm.fit': '全屏',
      'bm.panel': '面板',
      'bm.fps': '帧率',
      'bm.kernel': '内核',
      'bm.render': '渲染',
      'bm.cursor': '光标:',
      'bm.state': '状态:',
      'bm.ready': '就绪',
      'bm.hover': '悬停',
      'bm.dragging': '拖拽中',
      'bm.nodes': '逻辑节点'
    },

    en: {
      /* --- shared --- */
      'nav.gallery': 'Components',
      'nav.canvas': 'Live Canvas',
      'nav.architecture': 'Architecture',
      'nav.code': 'Code Examples',
      'nav.github': 'GitHub',
      'nav.openCanvas': 'Open Canvas →',
      'footer.copy': '© 2026 Ling71671. Open source under Apache 2.0.',
      'footer.canvas': 'Canvas',
      'footer.moonbit': 'MoonBit Docs',

      /* --- index.html --- */
      'index.title': 'moon-egui | A Native Immediate-Mode GUI Engine for MoonBit',
      'hero.title': 'A Native Immediate-Mode GUI Engine for MoonBit',
      'hero.subtitle': 'Zero external dependencies and a microsecond frame pipeline — a high-performance immediate renderer built for WebAssembly and Canvas 2D.',
      'hero.ctaGallery': 'Component Gallery',
      'hero.ctaCanvas': 'CAD Matrix Canvas',
      'hero.ctaCode': 'Declarative Code',
      'wb.caption': 'Live preview — CAD matrix canvas',
      'wb.openNewTab': 'Open in new tab ↗',
      'wb.iframeTitle': 'moon-egui live canvas',
      'features.title': 'Core Engineering',
      'features.desc': 'No virtual DOM, no two-way binding — modern interfaces built from pure functions and immediate layout.',
      'p1.title': 'Immediate-Mode Architecture',
      'p1.desc': 'Everything redraws every frame and state is declared in place. No virtual tree diffing, no garbage-collection jitter; your interface logic is your data, and the call site reads flat.',
      'p2.title': 'Microsecond Frame Pipeline',
      'p2.desc': 'Viewport-adaptive culling and primitive batching hold kernel cost at 0.1 ms per frame across a million-node canvas — a locked 60 FPS.',
      'p3.title': 'Native Core, Many Backends',
      'p3.desc': 'Built on MoonBit algebraic data types with no browser API baked in, so one core fits WebAssembly, Canvas 2D, and native desktop alike.',
      'code.title': 'Declarative syntax, rendered as written',
      'code.p1': 'In immediate mode there are no lifecycle callbacks to wire up. Each line you declare maps directly to this frame’s drawing and hit-testing.',
      'code.p2': 'Windows, buttons, sliders, and grid layout all share one layout flow, so they drop into any CAD canvas or game engine.',
      'code.windowTitle': '"Properties"',
      'code.param': '"Control parameters"',
      'code.resetBtn': '"Reset view"',
      'quickstart.title': 'Add the dependency to your MoonBit project',
      'quickstart.sub': 'Follows the current MoonBit package manager conventions',
      'quickstart.copy': 'Copy',
      'quickstart.copied': 'Copied',
      'quickstart.copyTitle': 'Copy install command',

      /* --- gallery.html --- */
      'gallery.title': 'moon-egui | Component Gallery',
      'gallery.heroTitle': 'Component Gallery',
      'gallery.heroSub': 'Explore the immediate-mode primitives. Drag the centre handle to compare the live UI with its source.',
      'preset.ui': 'UI only (0%)',
      'preset.split': '50/50 split',
      'preset.code': 'Source (100%)',
      'search.ph': 'Search components...',
      'cat.basic': 'Basic Input',
      'cat.values': 'Selection & Values',
      'cat.feedback': 'Feedback & Display',
      'cat.layout': 'Containers & Layout',
      'comp.button.title': 'Button',
      'comp.button.tag': 'Interaction',
      'comp.text_edit.title': 'TextEdit',
      'comp.text_edit.tag': 'Editing',
      'comp.checkbox.title': 'Checkbox',
      'comp.checkbox.tag': 'Toggles',
      'comp.toggle.title': 'Toggle',
      'comp.toggle.tag': 'Switch',
      'comp.radio.title': 'Radio',
      'comp.radio.tag': 'Exclusive',
      'comp.slider.title': 'Slider',
      'comp.slider.tag': 'Numeric',
      'comp.drag_value.title': 'DragValue',
      'comp.drag_value.tag': 'Drag',
      'comp.combo_box.title': 'ComboBox',
      'comp.combo_box.tag': 'Options',
      'comp.color_button.title': 'ColorButton',
      'comp.color_button.tag': 'Color',
      'comp.progress_bar.title': 'ProgressBar',
      'comp.progress_bar.tag': 'Progress',
      'comp.collapsing_header.title': 'CollapsingHeader',
      'comp.collapsing_header.tag': 'Tree',
      'comp.tooltip.title': 'Tooltip',
      'comp.tooltip.tag': 'Bubble',
      'comp.tab_bar.title': 'TabBar',
      'comp.tab_bar.tag': 'Tabs',
      'comp.scroll_area.title': 'ScrollArea',
      'comp.scroll_area.tag': 'Clipping',
      'comp.window.title': 'Window',
      'comp.window.tag': 'Panel',
      'wb.copy': 'Copy code',
      'wb.response': 'Response',
      'wb.refresh': 'Kernel refresh',
      'wb.kernelRate': '60 FPS',
      'curtain.drag': 'Drag to compare the UI with its source',
      'toast.copied': 'Code copied to the clipboard.',

      /* --- benchmark.html --- */
      'benchmark.title': 'moon-egui | Native Immediate-Mode CAD Matrix Canvas',
      'bm.back': 'Back',
      'bm.backTitle': 'Back to the home page',
      'bm.components': 'Components',
      'bm.componentsTitle': 'Open the component gallery',
      'bm.canvas': 'Canvas',
      'bm.wave': 'Wave',
      'bm.repel': 'Repel',
      'bm.pan': 'Pan',
      'bm.dragMode': 'Drag',
      'bm.center': 'Center',
      'bm.fit': 'Fit',
      'bm.panel': 'Panel',
      'bm.fps': 'FPS',
      'bm.kernel': 'Kernel',
      'bm.render': 'Render',
      'bm.cursor': 'Cursor:',
      'bm.state': 'State:',
      'bm.ready': 'Ready',
      'bm.hover': 'Hover',
      'bm.dragging': 'Dragging',
      'bm.nodes': 'nodes'
    }
  };

  /* ------------------------------------------------------------------ *
   * Language resolution
   * ------------------------------------------------------------------ */
  function normalize(tag) {
    var raw = String(tag || '').toLowerCase();
    if (raw.indexOf('zh') === 0) return 'zh';
    if (raw.indexOf('en') === 0) return 'en';
    return null;
  }

  function fromQuery() {
    try {
      var q = new URLSearchParams(window.location.search).get('lang');
      return q ? normalize(q) : null;
    } catch (err) {
      return null;
    }
  }

  function fromStorage() {
    try {
      return normalize(window.localStorage.getItem(STORAGE_KEY));
    } catch (err) {
      return null;
    }
  }

  function fromNavigator() {
    var list = (navigator.languages && navigator.languages.length)
      ? navigator.languages
      : [navigator.language || navigator.userLanguage];

    for (var i = 0; i < list.length; i++) {
      var hit = normalize(list[i]);
      if (hit) return hit;
    }
    return null;
  }

  function persist(lang) {
    try {
      window.localStorage.setItem(STORAGE_KEY, lang);
    } catch (err) {
      /* private mode or file:// — the session still works */
    }
  }

  var I18N = {
    lang: FALLBACK_LANG,
    supported: SUPPORTED.slice(),

    /** Translate a dictionary key. Unknown keys fall back to the zh entry. */
    t: function (key, fallback) {
      var table = DICT[I18N.lang] || DICT[FALLBACK_LANG];
      if (table && table[key] !== undefined) return table[key];
      if (DICT[FALLBACK_LANG][key] !== undefined) return DICT[FALLBACK_LANG][key];
      return fallback !== undefined ? fallback : key;
    },

    /** Pick the active branch of an inline { zh, en } pair. */
    L: function (pair) {
      if (pair === null || pair === undefined) return '';
      if (typeof pair === 'string') return pair;
      return pair[I18N.lang] !== undefined ? pair[I18N.lang] : (pair[FALLBACK_LANG] || '');
    },

    /** Switch language, persist the choice, repaint, and broadcast. */
    set: function (lang, silent) {
      var next = normalize(lang) || FALLBACK_LANG;
      var changed = next !== I18N.lang;
      I18N.lang = next;
      persist(next);

      if (changed) {
        var html = document.documentElement;
        html.classList.add('i18n-swapping');
        applyAll();
        window.setTimeout(function () { html.classList.remove('i18n-swapping'); }, 90);
      } else {
        applyAll();
      }

      if (!silent && changed) {
        document.dispatchEvent(new CustomEvent('langchange', { detail: { lang: next } }));
      }
      return next;
    },

    /** Re-run every [data-i18n] binding (call after injecting markup). */
    refresh: applyAll,

    /** Resolve once, up front: the document language is known before paint. */
    detect: function () {
      return fromQuery() || fromStorage() || fromNavigator() || FALLBACK_LANG;
    }
  };

  window.I18N = I18N;
  window.t = function (key, fallback) { return I18N.t(key, fallback); };
  window.L = function (pair) { return I18N.L(pair); };
  window.T = function (zh, en) { return I18N.lang === 'en' ? en : zh; };

  /* ------------------------------------------------------------------ *
   * Painting
   * ------------------------------------------------------------------ */
  function paintText(root) {
    var nodes = (root || document).querySelectorAll('[data-i18n]');
    for (var i = 0; i < nodes.length; i++) {
      var el = nodes[i];
      var key = el.getAttribute('data-i18n');
      var value = I18N.t(key, null);
      if (value === null || value === undefined) continue;
      if (el.hasAttribute('data-i18n-html')) el.innerHTML = value;
      else if (el.textContent !== value) el.textContent = value;
    }
  }

  function paintAttrs(root) {
    var nodes = (root || document).querySelectorAll('[data-i18n-attrs]');
    for (var i = 0; i < nodes.length; i++) {
      var el = nodes[i];
      var pairs = el.getAttribute('data-i18n-attrs').split(';');
      for (var j = 0; j < pairs.length; j++) {
        /* Accepts "title:key", "title=key" or "placeholder:key". */
        var hit = /^\s*([a-zA-Z][\w-]*)\s*[:=]\s*([\w.]+)\s*$/.exec(pairs[j]);
        if (!hit) continue;
        var value = I18N.t(hit[2], null);
        if (value !== null && value !== undefined) el.setAttribute(hit[1], value);
      }
    }
  }

  function paintDocument() {
    var html = document.documentElement;
    html.setAttribute('lang', I18N.lang === 'zh' ? 'zh-CN' : 'en');
    html.setAttribute('data-lang', I18N.lang);

    var body = document.body;
    if (body && body.hasAttribute('data-i18n-title')) {
      document.title = I18N.t(body.getAttribute('data-i18n-title'), document.title);
    }
  }

  function applyAll() {
    paintDocument();
    paintText();
    paintAttrs();
    syncSwitcher();
  }

  /* ------------------------------------------------------------------ *
   * Switcher control
   * ------------------------------------------------------------------ */
  var switcherHost = null;

  function buildSwitcher() {
    switcherHost = document.querySelector('[data-lang-switch]');
    if (!switcherHost) return;

    switcherHost.innerHTML =
      '<div class="lang-switch" data-active="0" role="group" aria-label="Language / 语言">' +
        '<span class="lang-switch-thumb" aria-hidden="true"></span>' +
        '<button type="button" data-lang="zh" aria-pressed="false">中文</button>' +
        '<button type="button" data-lang="en" aria-pressed="false">EN</button>' +
      '</div>';

    var buttons = switcherHost.querySelectorAll('button[data-lang]');
    for (var i = 0; i < buttons.length; i++) {
      buttons[i].addEventListener('click', function () {
        I18N.set(this.getAttribute('data-lang'));
      });
    }
    syncSwitcher();
  }

  function syncSwitcher() {
    if (!switcherHost) return;
    var root = switcherHost.querySelector('.lang-switch');
    if (!root) return;

    var index = SUPPORTED.indexOf(I18N.lang);
    if (index < 0) index = 0;
    root.setAttribute('data-active', String(index));

    var buttons = root.querySelectorAll('button[data-lang]');
    for (var i = 0; i < buttons.length; i++) {
      var code = buttons[i].getAttribute('data-lang');
      buttons[i].setAttribute('aria-pressed', code === I18N.lang ? 'true' : 'false');
      buttons[i].setAttribute(
        'title',
        code === 'zh' ? T('切换到中文', 'Switch to Chinese') : T('切换到英文', 'Switch to English')
      );
    }
  }

  /* ------------------------------------------------------------------ *
   * Boot
   * ------------------------------------------------------------------ */
  function boot() {
    buildSwitcher();
    applyAll();

    document.dispatchEvent(new CustomEvent('langchange', {
      detail: { lang: I18N.lang, initial: true }
    }));

    /* Follow the browser if the visitor never picked a language by hand. */
    window.addEventListener('languagechange', function () {
      try {
        if (window.localStorage.getItem(STORAGE_KEY)) return;
      } catch (err) { /* ignore */ }
      var next = fromNavigator();
      if (next && next !== I18N.lang) {
        I18N.lang = next;
        applyAll();
        document.dispatchEvent(new CustomEvent('langchange', { detail: { lang: next } }));
      }
    });
  }

  /* The language is resolved synchronously, before any page script runs, so
   * scripts executing during parsing (gallery.js builds its first stage on
   * load) already see the right value. Only DOM painting waits for the tree. */
  I18N.lang = I18N.detect();
  /* An explicit ?lang= choice sticks for the rest of the session. */
  if (fromQuery()) persist(I18N.lang);
  document.documentElement.setAttribute('lang', I18N.lang === 'zh' ? 'zh-CN' : 'en');
  document.documentElement.setAttribute('data-lang', I18N.lang);

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', boot);
  } else {
    boot();
  }
})();
