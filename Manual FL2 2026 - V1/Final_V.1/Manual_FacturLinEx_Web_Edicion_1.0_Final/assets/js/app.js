
(() => {
  const rootPrefix = location.pathname.includes('/capitulos/') ? '../' : '';
  const body = document.body;
  const savedTheme = localStorage.getItem('flx-theme');
  const preferredDark = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
  if (savedTheme === 'dark' || (!savedTheme && preferredDark)) document.documentElement.dataset.theme = 'dark';

  document.querySelectorAll('[data-theme-toggle]').forEach(btn => btn.addEventListener('click', () => {
    const dark = document.documentElement.dataset.theme === 'dark';
    document.documentElement.dataset.theme = dark ? 'light' : 'dark';
    localStorage.setItem('flx-theme', dark ? 'light' : 'dark');
  }));

  const menuButton = document.querySelector('[data-menu-button]');
  const overlay = document.querySelector('[data-menu-overlay]');
  const closeMenu = () => { body.classList.remove('menu-open'); if (menuButton) menuButton.setAttribute('aria-expanded','false'); };
  if (menuButton) menuButton.addEventListener('click', () => {
    const open = body.classList.toggle('menu-open');
    menuButton.setAttribute('aria-expanded', String(open));
  });
  if (overlay) overlay.addEventListener('click', closeMenu);
  document.addEventListener('keydown', e => { if (e.key === 'Escape' && body.classList.contains('menu-open')) closeMenu(); });

  const dialog = document.querySelector('[data-search-dialog]');
  const input = document.querySelector('[data-search-input]');
  const results = document.querySelector('[data-search-results]');
  const hint = document.querySelector('[data-search-hint]');
  const openSearch = (event) => {
    if (event && event.preventDefault) event.preventDefault();
    if (!dialog) return;
    dialog.showModal();
    requestAnimationFrame(() => input && input.focus());
  };
  document.querySelectorAll('[data-search-open]').forEach(btn => btn.addEventListener('click', openSearch));
  document.addEventListener('keydown', e => {
    if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === 'k') { e.preventDefault(); openSearch(); }
  });

  const normalize = s => s.normalize('NFD').replace(/[\u0300-\u036f]/g,'').toLowerCase();
  const escapeHtml = s => s.replace(/[&<>'"]/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;',"'":'&#39;','"':'&quot;'}[c]));
  const resolveUrl = url => rootPrefix + url;
  const renderSearch = () => {
    if (!input || !results) return;
    const query = normalize(input.value.trim());
    results.innerHTML = '';
    if (query.length < 2) { hint.hidden = false; return; }
    hint.hidden = true;
    const words = query.split(/\s+/).filter(Boolean);
    const data = window.FLX_SEARCH_INDEX || [];
    const scored = data.map(item => {
      const title = normalize(item.title);
      const chapter = normalize(item.chapter);
      const text = normalize(item.text);
      let score = 0;
      for (const w of words) {
        if (title.includes(w)) score += 12;
        if (chapter.includes(w)) score += 6;
        if (text.includes(w)) score += 2;
        else return null;
      }
      return {item, score};
    }).filter(Boolean).sort((a,b) => b.score-a.score).slice(0,20);
    if (!scored.length) { results.innerHTML = '<div class="search-empty">No se encontraron resultados.</div>'; return; }
    results.innerHTML = scored.map(({item}) => {
      let excerpt = item.text || '';
      const first = words[0];
      const pos = normalize(excerpt).indexOf(first);
      if (pos > 80) excerpt = '…' + excerpt.slice(pos - 65);
      excerpt = excerpt.slice(0, 220) + (excerpt.length > 220 ? '…' : '');
      return `<a class="search-result" href="${resolveUrl(item.url)}"><strong>${escapeHtml(item.title)}</strong><small>${escapeHtml(item.chapter)}</small><p>${escapeHtml(excerpt)}</p></a>`;
    }).join('');
  };
  if (input) input.addEventListener('input', renderSearch);
  if (results) results.addEventListener('click', () => dialog && dialog.close());
})();
