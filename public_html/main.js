/* =====================================================================
   VALENCIA — Website interactions (vanilla JS, no framework)
   Sticky header · mobile menu. (WhatsApp is the only CTA — no forms.)
   ===================================================================== */
(function () {
  "use strict";

  /* ---------- Sticky header: transparent over hero → solid on scroll ---------- */
  var hdr = document.getElementById("hdr");
  function onScroll() {
    hdr.classList.toggle("is-solid", window.scrollY > 40);
  }
  onScroll();
  window.addEventListener("scroll", onScroll, { passive: true });

  /* ---------- Mobile menu ---------- */
  var scrim = document.querySelector("[data-menu-scrim]");
  var sheet = document.querySelector("[data-menu-sheet]");

  function openMenu() {
    scrim.classList.remove("is-hidden");
    sheet.classList.remove("is-hidden");
    document.body.style.overflow = "hidden";
  }
  function closeMenu() {
    scrim.classList.add("is-hidden");
    sheet.classList.add("is-hidden");
    document.body.style.overflow = "";
  }

  document.querySelector("[data-menu-open]").addEventListener("click", openMenu);
  document.querySelector("[data-menu-close]").addEventListener("click", closeMenu);
  scrim.addEventListener("click", closeMenu);
  document.querySelectorAll("[data-menu-link]").forEach(function (a) {
    a.addEventListener("click", closeMenu);
  });

  /* ---------- Escape closes the menu ---------- */
  document.addEventListener("keydown", function (e) {
    if (e.key === "Escape") closeMenu();
  });
})();
