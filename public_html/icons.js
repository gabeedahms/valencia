/* =====================================================================
   VALENCIA — Icon glyph injector
   Maps each <i class="ico" data-ico="name"> to its Font Awesome 6 Free
   codepoint and writes it as a text node once the self-hosted fonts are
   ready. Text-node injection (vs ::before) guarantees the glyph paints.
   ===================================================================== */
(function () {
  "use strict";
  var GLYPHS = {
    scissors:      "\uf0c4",
    palette:       "\uf53f",
    sparkles:      "\uf0d0", /* fa-magic (wand) — compatible with all FA versions */
    calendar:      "\uf274", /* calendar-check */
    "map-pin":     "\uf3c5", /* location-dot */
    clock:         "\uf017",
    "arrow-right": "\uf061",
    check:         "\uf00c",
    menu:          "\uf0c9", /* bars */
    close:         "\uf00d", /* xmark */
    message:       "\uf4ad", /* comment-dots */
    instagram:     "\uf16d",
    whatsapp:      "\uf232",
    facebook:      "\uf39e"  /* facebook-f */
  };

  function paint() {
    var nodes = document.querySelectorAll(".ico[data-ico]");
    for (var i = 0; i < nodes.length; i++) {
      var g = GLYPHS[nodes[i].getAttribute("data-ico")];
      if (g) nodes[i].textContent = g; /* fresh text node → reliable paint */
    }
  }

  function run() {
    if (document.fonts && document.fonts.ready) {
      document.fonts.ready.then(paint);
    }
    paint();                 /* immediate attempt */
    setTimeout(paint, 1200); /* safety net if fonts.ready is slow/absent */
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", run);
  } else {
    run();
  }
})();
