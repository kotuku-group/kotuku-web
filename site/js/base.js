
var glParameters = {};

function isEmpty(str) {
   return (!str || 0 === str.length);
}

function esc_html(str) {
   return str.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
}

function esc_regexp(text) {
   return text.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, "\\$&");
}

function cancelAnimations() {
   document.getAnimations().forEach((animation) => { animation.cancel(); });
}

const getParentNode = (child, selector) =>
   !selector || !child || !child.parentElement ? undefined
   : (child.parentElement.querySelectorAll(selector).values().find(x => x === child)
   ?? getParentNode(child.parentElement, selector));

// Support function for glParameters

(function () {
   var e,
      a = /\+/g,
      r = /([^&=]+)=?([^&]*)/g,
      d = function (s) { return decodeURIComponent(s.replace(a, " ")); },
      q = window.location.search.substring(1);

   while (e = r.exec(q))
      glParameters[d(e[1])] = d(e[2]);
})();

// Highlight the sidebar entry for the current page and open its enclosing branch.
//
// Anchors expose a fully resolved .pathname, so matching against that works regardless of how the href was written.
// This matters because the sidebar is shared between module, class and wiki pages, which sit at different depths and
// therefore carry different relative prefixes.  Comparing resolved paths also removes the old ambiguity between a
// module and a class of the same name (e.g. modules/audio.html vs modules/classes/audio.html).

function highlightNavLink() {
   var path = window.location.pathname;
   if (path.endsWith('.xml')) path = path.substr(0, path.length-4) + '.html'; // XSLT browsing mode

   var links = document.querySelectorAll('li.api-ref > a');
   for (var i=0; i < links.length; i++) {
      if (links[i].pathname !== path) continue;

      var parent = getParentNode(links[i], '[class="collapse"]');
      if (parent) new bootstrap.Collapse(parent, { show: true }); // Causes animation

      links[i].style.backgroundColor = '#d2f4ea';
      return links[i];
   }
}
