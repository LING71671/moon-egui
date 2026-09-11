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

  /* Scroll-Spy for Left Sidebar & Right TOC */
  function initScrollSpy() {
    var sidebarLinks = document.querySelectorAll('.sidebar-link');
    var tocLinks = document.querySelectorAll('.toc-link');
    if (!sidebarLinks.length && !tocLinks.length) return;

    // Collect all referenced IDs from both sidebar and TOC
    var idSet = new Set();
    var targets = [];

    function registerLinks(links) {
      links.forEach(function(link) {
        var href = link.getAttribute('href');
        if (href && href.startsWith('#') && href.length > 1) {
          var targetId = href.substring(1);
          if (!idSet.has(targetId)) {
            idSet.add(targetId);
            var el = document.getElementById(targetId);
            if (el) {
              targets.push({ id: targetId, el: el });
            }
          }
        }
      });
    }

    registerLinks(sidebarLinks);
    registerLinks(tocLinks);

    // Also collect all section elements for hierarchal fallback
    document.querySelectorAll('section[id]').forEach(function(sec) {
      if (!idSet.has(sec.id)) {
        idSet.add(sec.id);
        targets.push({ id: sec.id, el: sec });
      }
    });

    if (!targets.length) return;

    function getElementTop(el) {
      var box = el.getBoundingClientRect();
      return box.top + window.scrollY;
    }

    function onScroll() {
      // Re-sort targets in case dynamic layouts or images shifted positions
      targets.sort(function(a, b) {
        return getElementTop(a.el) - getElementTop(b.el);
      });

      var scrollPos = window.scrollY + 130;
      var activeTarget = null;

      for (var i = 0; i < targets.length; i++) {
        var top = getElementTop(targets[i].el);
        if (top <= scrollPos) {
          activeTarget = targets[i];
        } else {
          break;
        }
      }

      if (!activeTarget && targets.length > 0) {
        activeTarget = targets[0];
      }

      var activeId = activeTarget ? activeTarget.id : null;
      var activeEl = activeTarget ? activeTarget.el : null;

      // 1. Update Right TOC links
      tocLinks.forEach(function(link) {
        var href = link.getAttribute('href');
        if (href === '#' + activeId) {
          link.classList.add('active');
        } else {
          link.classList.remove('active');
        }
      });

      // 2. Update Left Sidebar links
      var matchedSidebarLink = null;
      if (activeId) {
        for (var s = 0; s < sidebarLinks.length; s++) {
          if (sidebarLinks[s].getAttribute('href') === '#' + activeId) {
            matchedSidebarLink = sidebarLinks[s];
            break;
          }
        }
      }

      // Fallback: If current active is a sub-heading inside a parent section
      if (!matchedSidebarLink && activeEl) {
        var parentSection = activeEl.closest('section[id]');
        if (parentSection) {
          for (var p = 0; p < sidebarLinks.length; p++) {
            if (sidebarLinks[p].getAttribute('href') === '#' + parentSection.id) {
              matchedSidebarLink = sidebarLinks[p];
              break;
            }
          }
        }
      }

      sidebarLinks.forEach(function(link) {
        if (link === matchedSidebarLink) {
          if (!link.classList.contains('active')) {
            link.classList.add('active');
            if (typeof link.scrollIntoView === 'function') {
              link.scrollIntoView({ block: 'nearest', behavior: 'smooth' });
            }
          }
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
