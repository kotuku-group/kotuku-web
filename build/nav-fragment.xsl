<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">
<!--
Renders the shared navigation as a standalone HTML fragment, for pages that are not themselves produced by
XSLT.  Used by gen-nav.sh to build build/wiki-header.html.  Not used by module.xsl or class.xsl, which import
nav.xsl directly. 
-->

  <xsl:import href="nav.xsl"/>
  <xsl:output method="html" encoding="utf-8" omit-xml-declaration="yes" indent="no"/>

  <!-- Wiki pages live in site/wiki/, one level below the site root. -->
  <xsl:param name="root" select="'../'"/>

  <!-- Which fragment to emit: 'navbar' or 'sidebar'. -->
  <xsl:param name="fragment" select="'sidebar'"/>

  <!-- Which sidebar branch to open on arrival; see nav-sidebar in nav.xsl. -->
  <xsl:param name="expand" select="''"/>

  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="$fragment='navbar'"><xsl:call-template name="nav-bar"/></xsl:when>
      <xsl:otherwise><xsl:call-template name="nav-sidebar"><xsl:with-param name="expand" select="$expand"/></xsl:call-template></xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
