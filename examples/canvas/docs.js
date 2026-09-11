/* moon-egui Documentation & Wiki Helper Script (docs.js)
 * Implements code copying, sidebar search filtering, TOC scroll-spy, and mobile drawer.
 */
(function() {
  'use strict';

  document.addEventListener('DOMContentLoaded', function() {
    initCopyButtons();
    initSidebarFilter();
    initScrollSpy();
    initMobileSidebar();
  });

  /* One-click copy code snippet */
  function initCopyButtons() {
    var copyBtns = document.querySelectorAll('.code-copy-btn');
    copyBtns.forEach(function(btn) {
      btn.addEventListener('click', function() {
        var wrapper = btn.closest('.code-wrapper');
        if (!wrapper) return;
        var pre = wrapper.querySelector('pre');
        if (!pre) return;
        var text = pre.innerText || pre.textContent;

        navigator.clipboard.writeText(text).then(function() {
          var originalHtml = btn.innerHTML;
          btn.classList.add('copied');
          btn.innerHTML = '<svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"/></svg> <span>Copied!</span>';
          setTimeout(function() {
            btn.classList.remove('copied');
            btn.innerHTML = originalHtml;
          }, 2000);
        }).catch(function(err) {
          console.error('Failed to copy text: ', err);
        });
      });
    });
  }

  /* Live search filter in sidebar */
  function initSidebarFilter() {
    var searchInput = document.getElementById('sidebarSearch');
    if (!searchInput) return;

    searchInput.addEventListener('input', function() {
      var query = this.value.trim().toLowerCase();
      var groups = document.querySelectorAll('.sidebar-group');

      groups.forEach(function(group) {
        var links = group.querySelectorAll('.sidebar-link');
        var anyVisible = false;

        links.forEach(function(link) {
          var text = (link.textContent || '').toLowerCase();
          if (!query || text.indexOf(query) !== -1) {
            link.style.display = 'flex';
            anyVisible = true;
          } else {
            link.style.display = 'none';
          }
        });

        group.style.display = anyVisible ? 'block' : 'none';
      });
    });

    // Keyboard shortcut '/' or 'Ctrl+K' / 'Cmd+K' to focus search
    document.addEventListener('keydown', function(e) {
      if ((e.key === '/' || ((e.metaKey || e.ctrlKey) && e.key === 'k')) && document.activeElement !== searchInput) {
        e.preventDefault();
        searchInput.focus();
        searchInput.select();
      } else if (e.key === 'Escape' && document.activeElement === searchInput) {
        searchInput.blur();
      }
    });
  }

  /* Scroll-Spy for Right TOC */
  function initScrollSpy() {
    var tocLinks = document.querySelectorAll('.toc-link');
    if (!tocLinks.length) return;

    var headingIds = [];
    tocLinks.forEach(function(link) {
      var href = link.getAttribute('href');
      if (href && href.startsWith('#')) {
        headingIds.push(href.substring(1));
      }
    });

    var headings = headingIds.map(function(id) {
      return document.getElementById(id);
    }).filter(function(el) { return el !== null; });

    if (!headings.length) return;

    function onScroll() {
      var scrollPos = window.scrollY + 100;
      var activeId = null;

      for (var i = 0; i < headings.length; i++) {
        var el = headings[i];
        if (el.offsetTop <= scrollPos) {
          activeId = el.id;
        } else {
          break;
        }
      }

      if (!activeId && headings.length > 0) {
        activeId = headings[0].id;
      }

      tocLinks.forEach(function(link) {
        var href = link.getAttribute('href');
        if (href === '#' + activeId) {
          link.classList.add('active');
        } else {
          link.classList.remove('active');
        }
      });
    }

    window.addEventListener('scroll', onScroll, { passive: true });
    onScroll();
  }

  /* Mobile sidebar toggle */
  function initMobileSidebar() {
    var toggleBtn = document.getElementById('sidebarToggle');
    var sidebar = document.querySelector('.docs-sidebar');
    if (!toggleBtn || !sidebar) return;

    toggleBtn.addEventListener('click', function(e) {
      e.stopPropagation();
      sidebar.classList.toggle('open');
    });

    document.addEventListener('click', function(e) {
      if (!sidebar.contains(e.target) && !toggleBtn.contains(e.target)) {
        sidebar.classList.remove('open');
      }
    });
  }
})();
