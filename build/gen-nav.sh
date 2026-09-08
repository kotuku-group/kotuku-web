#!/bin/bash
#
# Substitutes the shared navigation from build/nav.xsl into the pages that are not produced by XSLT:
#
#   build/wiki-header.template.html -> build/wiki-header.html   (the header pandoc wraps every wiki page in)
#   build/api.template.html         -> site/modules/api.html    (the hand written API index)
#
# module.xsl and class.xsl do not go through here; they import nav.xsl directly.
#
# Run this after editing nav.xsl or either template, and commit the regenerated pages.
#
# Requires xsltproc.

set -euo pipefail

cd "$(dirname "$0")"

command -v xsltproc >/dev/null || { echo "gen-nav.sh: xsltproc is required but was not found on the path." >&2; exit 1; }

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

# xsltproc needs a source document; the navigation is entirely static so its content is irrelevant.
echo '<nav-source/>' > "$work/source.xml"

# The wiki and API pages are HTML5, so drop the XHTML namespace that XSLT stamps on each fragment's outermost
# elements.  module.xsl and class.xsl are unaffected: their <html> root carries the declaration for the whole page.
strip_ns='s| xmlns="http://www.w3.org/1999/xhtml"||g'

# generate <template> <target> <root> <expand>
generate() {
   local template=$1 target=$2 root=$3 expand=$4

   [ -f "$template" ] || { echo "gen-nav.sh: $template not found." >&2; exit 1; }

   local placeholder
   for placeholder in NAVBAR SIDEBAR; do
      grep -q "<!--$placeholder-->" "$template" || {
         echo "gen-nav.sh: $template is missing the <!--$placeholder--> placeholder." >&2; exit 1; }
   done

   xsltproc --stringparam fragment navbar --stringparam root "$root" --stringparam expand "$expand" \
      nav-fragment.xsl "$work/source.xml" | sed -e "$strip_ns" > "$work/navbar.html"
   xsltproc --stringparam fragment sidebar --stringparam root "$root" --stringparam expand "$expand" \
      nav-fragment.xsl "$work/source.xml" | sed -e "$strip_ns" > "$work/sidebar.html"

   [ -s "$work/navbar.html" ]  || { echo "gen-nav.sh: the navbar fragment came out empty." >&2; exit 1; }
   [ -s "$work/sidebar.html" ] || { echo "gen-nav.sh: the sidebar fragment came out empty." >&2; exit 1; }

   {
      printf '%s\n' '<!-- GENERATED FILE -->'
      # The TEMPLATE-NOTE block documents the template itself and is not wanted in the output.  Placeholder lines
      # are replaced with the rendered fragments; reading them via `r` keeps the content clear of sed's escaping.
      sed -e "/<!--TEMPLATE-NOTE/,/^-->$/d" \
          -e "/<!--NAVBAR-->/{r $work/navbar.html
d
}" -e "/<!--SIDEBAR-->/{r $work/sidebar.html
d
}" "$template"
   } > "$work/out.html"

   mv "$work/out.html" "$target"
   echo "gen-nav.sh: wrote $target"
}

#        template                        target                    root    expand
generate wiki-header.template.html       wiki-header.html          '../'   wiki
generate api.template.html               ../site/modules/api.html  '../'   ''
