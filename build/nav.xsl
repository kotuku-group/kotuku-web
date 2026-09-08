<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">
<!--
This is the single source of truth for the top navbar and the sidebar tree.  It is included by module.xsl and
class.xsl, and is also used to regenerate the navigation fragments embedded in wiki-header.html (see
build/gen-nav.sh).  Adding a module, class or wiki page means editing this file and nothing else.

Callers must supply 'root', the relative path from the generated page back to the site root:

    site/modules/*.html         root = '../'
    site/modules/classes/*.html root = '../../'
    site/wiki/*.html            root = '../'

All links are built from 'root' so that the generated URLs stay relative.  That keeps the pages viewable
directly from the filesystem, and preserves the existing XSLT browsing mode where the SDK's .xml files are
opened in a browser and transformed on the fly.
-->

  <xsl:param name="root" select="'../'"/>

  <xsl:variable name="modules" select="concat($root,'modules/')"/>
  <xsl:variable name="classes" select="concat($root,'modules/classes/')"/>
  <xsl:variable name="wiki" select="concat($root,'wiki/')"/>

  <!-- Emit a sidebar link.  Every nav link carries class 'api-ref' so that highlightNavLink() in base.js can find and highlight whichever entry matches the current page. -->

  <xsl:template name="nav-link">
    <xsl:param name="href"/>
    <xsl:param name="label"/>
    <li class="api-ref"><a class="rounded"><xsl:attribute name="href"><xsl:value-of select="$href"/></xsl:attribute><xsl:value-of select="$label"/></a></li>
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>

  <!-- Emit a collapsible sidebar section header. -->

  <xsl:template name="nav-toggle">
    <xsl:param name="target"/>
    <xsl:param name="label"/>
    <xsl:param name="show" select="false()"/>
    <button class="btn btn-toggle align-items-center rounded collapsed" data-bs-toggle="collapse">
      <xsl:attribute name="data-bs-target">#<xsl:value-of select="$target"/></xsl:attribute>
      <xsl:attribute name="aria-expanded"><xsl:choose><xsl:when test="$show">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
      <xsl:value-of select="$label"/>
    </button>
  </xsl:template>

  <!-- TOP NAVBAR -->

  <xsl:template name="nav-bar">
    <nav class="navbar navbar-expand-sm navbar-dark bg-dark">
      <div class="container-fluid">
        <div class="navbar-header"><a class="navbar-brand"><xsl:attribute name="href"><xsl:value-of select="$root"/>index.html</xsl:attribute>Kōtuku</a></div>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbar" aria-controls="navbar" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button><xsl:text>&#xa;</xsl:text>
        <div id="navbar" class="collapse navbar-collapse">
          <ul class="nav navbar-nav">
            <li class="nav-item"><a class="nav-link"><xsl:attribute name="href"><xsl:value-of select="$root"/>gallery.html</xsl:attribute>Gallery</a></li>
            <li class="nav-item"><a class="nav-link"><xsl:attribute name="href"><xsl:value-of select="$modules"/>api.html</xsl:attribute>API</a></li>
            <li class="nav-item"><a class="nav-link"><xsl:attribute name="href"><xsl:value-of select="$wiki"/>Home.html</xsl:attribute>Wiki</a></li>
            <li class="nav-item"><a class="nav-link" href="https://github.com/kotuku-group/kotuku">GitHub</a></li>
          </ul><xsl:text>&#xa;</xsl:text>
        </div> <!-- nav-collapse -->
      </div>
    </nav>
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>

  <!-- SIDEBAR: 'expand' selects which top level branch is open on arrival: 'classes' for class pages, 'wiki' for wiki pages, and empty for module pages (which open their own API branch instead). -->

  <xsl:template name="nav-sidebar">
    <xsl:param name="expand" select="''"/>

    <!-- MODULES -->

    <ul class="list-unstyled">
      <li class="border-top my-3"></li> <!-- Line break -->
      <li>
        <xsl:call-template name="nav-toggle">
          <xsl:with-param name="target" select="'mod-collapse'"/>
          <xsl:with-param name="label" select="'Modules'"/>
        </xsl:call-template>
        <div class="collapse" id="mod-collapse">
          <ul class="btn-toggle-nav list-unstyled fw-normal"><xsl:text>&#xa;</xsl:text>
            <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($modules,'audio.html')"/><xsl:with-param name="label" select="'Audio'"/></xsl:call-template>
            <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($modules,'config.html')"/><xsl:with-param name="label" select="'Config'"/></xsl:call-template>
            <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($modules,'core.html')"/><xsl:with-param name="label" select="'Core'"/></xsl:call-template>
            <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($modules,'display.html')"/><xsl:with-param name="label" select="'Display'"/></xsl:call-template>
            <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($modules,'document.html')"/><xsl:with-param name="label" select="'Document'"/></xsl:call-template>
            <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($modules,'font.html')"/><xsl:with-param name="label" select="'Font'"/></xsl:call-template>
            <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($modules,'http.html')"/><xsl:with-param name="label" select="'HTTP'"/></xsl:call-template>
            <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($modules,'network.html')"/><xsl:with-param name="label" select="'Network'"/></xsl:call-template>
            <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($modules,'regex.html')"/><xsl:with-param name="label" select="'Regex'"/></xsl:call-template>
            <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($modules,'svg.html')"/><xsl:with-param name="label" select="'SVG'"/></xsl:call-template>
            <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($modules,'tiri.html')"/><xsl:with-param name="label" select="'Tiri'"/></xsl:call-template>
            <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($modules,'vector.html')"/><xsl:with-param name="label" select="'Vector'"/></xsl:call-template>
            <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($modules,'xml.html')"/><xsl:with-param name="label" select="'XML'"/></xsl:call-template>
            <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($modules,'xquery.html')"/><xsl:with-param name="label" select="'XQuery'"/></xsl:call-template>
            <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($modules,'xrandr.html')"/><xsl:with-param name="label" select="'XRandR'"/></xsl:call-template>
          </ul>
        </div>
      </li>
    </ul>
    <xsl:text>&#xa;</xsl:text>

    <!-- CLASSES -->

    <ul class="list-unstyled">
      <li class="border-top my-3"></li> <!-- Line break -->
      <li>
        <xsl:call-template name="nav-toggle">
          <xsl:with-param name="target" select="'class-collapse'"/>
          <xsl:with-param name="label" select="'Classes'"/>
          <xsl:with-param name="show" select="$expand='classes'"/>
        </xsl:call-template>
        <div id="class-collapse">
          <xsl:attribute name="class">collapse<xsl:if test="$expand='classes'"> show</xsl:if></xsl:attribute>
          <ul class="btn-toggle-nav list-unstyled fw-normal pb-1 ps-3"><xsl:text>&#xa;</xsl:text>

            <li>
              <xsl:call-template name="nav-toggle"><xsl:with-param name="target" select="'audio-collapse'"/><xsl:with-param name="label" select="'Audio'"/></xsl:call-template>
              <div class="collapse" id="audio-collapse">
                <ul class="btn-toggle-nav list-unstyled fw-normal pb-1"><xsl:text>&#xa;</xsl:text>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'audio.html')"/><xsl:with-param name="label" select="'Audio'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'mp3.html')"/><xsl:with-param name="label" select="'MP3'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'sound.html')"/><xsl:with-param name="label" select="'Sound'"/></xsl:call-template>
                </ul>
              </div>
            </li><xsl:text>&#xa;</xsl:text>

            <li>
              <xsl:call-template name="nav-toggle"><xsl:with-param name="target" select="'core-collapse'"/><xsl:with-param name="label" select="'Core'"/></xsl:call-template>
              <div class="collapse" id="core-collapse">
                <ul class="btn-toggle-nav list-unstyled pb-1"><xsl:text>&#xa;</xsl:text>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'file.html')"/><xsl:with-param name="label" select="'File'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'metaclass.html')"/><xsl:with-param name="label" select="'MetaClass'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'module.html')"/><xsl:with-param name="label" select="'Module'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'storagedevice.html')"/><xsl:with-param name="label" select="'StorageDevice'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'task.html')"/><xsl:with-param name="label" select="'Task'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'thread.html')"/><xsl:with-param name="label" select="'Thread'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'time.html')"/><xsl:with-param name="label" select="'Time'"/></xsl:call-template>
                </ul>
              </div>
            </li><xsl:text>&#xa;</xsl:text>

            <li>
              <xsl:call-template name="nav-toggle"><xsl:with-param name="target" select="'data-collapse'"/><xsl:with-param name="label" select="'Data'"/></xsl:call-template>
              <div class="collapse" id="data-collapse">
                <ul class="btn-toggle-nav list-unstyled pb-1"><xsl:text>&#xa;</xsl:text>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'compression.html')"/><xsl:with-param name="label" select="'Compression'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'compressedstream.html')"/><xsl:with-param name="label" select="'CompressedStream'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'config.html')"/><xsl:with-param name="label" select="'Config'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'lzmastream.html')"/><xsl:with-param name="label" select="'LZMAStream'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'script.html')"/><xsl:with-param name="label" select="'Script'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'tiri.html')"/><xsl:with-param name="label" select="'Tiri'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'xml.html')"/><xsl:with-param name="label" select="'XML'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'xquery.html')"/><xsl:with-param name="label" select="'XQuery'"/></xsl:call-template>
                </ul>
              </div>
            </li><xsl:text>&#xa;</xsl:text>

            <li>
              <xsl:call-template name="nav-toggle"><xsl:with-param name="target" select="'devices-collapse'"/><xsl:with-param name="label" select="'Devices'"/></xsl:call-template>
              <div class="collapse" id="devices-collapse">
                <ul class="btn-toggle-nav list-unstyled pb-1"><xsl:text>&#xa;</xsl:text>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'controller.html')"/><xsl:with-param name="label" select="'Controller'"/></xsl:call-template>
                </ul>
              </div>
            </li><xsl:text>&#xa;</xsl:text>

            <li>
              <xsl:call-template name="nav-toggle"><xsl:with-param name="target" select="'effects-collapse'"/><xsl:with-param name="label" select="'Effects'"/></xsl:call-template>
              <div class="collapse" id="effects-collapse">
                <ul class="btn-toggle-nav list-unstyled pb-1"><xsl:text>&#xa;</xsl:text>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'blurfx.html')"/><xsl:with-param name="label" select="'BlurFX'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'colourfx.html')"/><xsl:with-param name="label" select="'ColourFX'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'compositefx.html')"/><xsl:with-param name="label" select="'CompositeFX'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'convolvefx.html')"/><xsl:with-param name="label" select="'ConvolveFX'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'displacementfx.html')"/><xsl:with-param name="label" select="'DisplacementFX'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'filtereffect.html')"/><xsl:with-param name="label" select="'FilterEffect'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'floodfx.html')"/><xsl:with-param name="label" select="'FloodFX'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'imagefx.html')"/><xsl:with-param name="label" select="'ImageFX'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'lightingfx.html')"/><xsl:with-param name="label" select="'LightingFX'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'mergefx.html')"/><xsl:with-param name="label" select="'MergeFX'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'morphologyfx.html')"/><xsl:with-param name="label" select="'MorphologyFX'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'offsetfx.html')"/><xsl:with-param name="label" select="'OffsetFX'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'remapfx.html')"/><xsl:with-param name="label" select="'RemapFX'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'sourcefx.html')"/><xsl:with-param name="label" select="'SourceFX'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'turbulencefx.html')"/><xsl:with-param name="label" select="'TurbulenceFX'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'wavefunctionfx.html')"/><xsl:with-param name="label" select="'WaveFunctionFX'"/></xsl:call-template>
                </ul>
              </div>
            </li><xsl:text>&#xa;</xsl:text>

            <li>
              <xsl:call-template name="nav-toggle"><xsl:with-param name="target" select="'ext-collapse'"/><xsl:with-param name="label" select="'Extensions'"/></xsl:call-template>
              <div class="collapse" id="ext-collapse">
                <ul class="btn-toggle-nav list-unstyled pb-1"><xsl:text>&#xa;</xsl:text>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'scintilla.html')"/><xsl:with-param name="label" select="'Scintilla'"/></xsl:call-template>
                </ul>
              </div>
            </li><xsl:text>&#xa;</xsl:text>

            <li>
              <xsl:call-template name="nav-toggle"><xsl:with-param name="target" select="'gfx-collapse'"/><xsl:with-param name="label" select="'Graphics'"/></xsl:call-template>
              <div class="collapse" id="gfx-collapse">
                <ul class="btn-toggle-nav list-unstyled pb-1"><xsl:text>&#xa;</xsl:text>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'bitmap.html')"/><xsl:with-param name="label" select="'Bitmap'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'clipboard.html')"/><xsl:with-param name="label" select="'Clipboard'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'display.html')"/><xsl:with-param name="label" select="'Display'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'document.html')"/><xsl:with-param name="label" select="'Document'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'font.html')"/><xsl:with-param name="label" select="'Font'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'image.html')"/><xsl:with-param name="label" select="'Image'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'pointer.html')"/><xsl:with-param name="label" select="'Pointer'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'surface.html')"/><xsl:with-param name="label" select="'Surface'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'svg.html')"/><xsl:with-param name="label" select="'SVG'"/></xsl:call-template>
                </ul>
              </div>
            </li><xsl:text>&#xa;</xsl:text>

            <li>
              <xsl:call-template name="nav-toggle"><xsl:with-param name="target" select="'net-collapse'"/><xsl:with-param name="label" select="'Network'"/></xsl:call-template>
              <div class="collapse" id="net-collapse">
                <ul class="btn-toggle-nav list-unstyled pb-1"><xsl:text>&#xa;</xsl:text>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'clientsocket.html')"/><xsl:with-param name="label" select="'ClientSocket'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'http.html')"/><xsl:with-param name="label" select="'HTTP'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'netclient.html')"/><xsl:with-param name="label" select="'NetClient'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'netlookup.html')"/><xsl:with-param name="label" select="'NetLookup'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'netserver.html')"/><xsl:with-param name="label" select="'NetServer'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'netsocket.html')"/><xsl:with-param name="label" select="'NetSocket'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'proxy.html')"/><xsl:with-param name="label" select="'Proxy'"/></xsl:call-template>
                </ul>
              </div>
            </li><xsl:text>&#xa;</xsl:text>

            <li>
              <xsl:call-template name="nav-toggle"><xsl:with-param name="target" select="'vectors-collapse'"/><xsl:with-param name="label" select="'Vectors'"/></xsl:call-template>
              <div class="collapse" id="vectors-collapse">
                <ul class="btn-toggle-nav list-unstyled pb-1"><xsl:text>&#xa;</xsl:text>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'gradient.html')"/><xsl:with-param name="label" select="'Gradient'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'gradientconic.html')"/><xsl:with-param name="label" select="'GradientConic'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'gradientcontour.html')"/><xsl:with-param name="label" select="'GradientContour'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'gradientdiamond.html')"/><xsl:with-param name="label" select="'GradientDiamond'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'gradientdiffusion.html')"/><xsl:with-param name="label" select="'GradientDiffusion'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'gradientdistal.html')"/><xsl:with-param name="label" select="'GradientDistal'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'gradientgouraud.html')"/><xsl:with-param name="label" select="'GradientGouraud'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'gradientlinear.html')"/><xsl:with-param name="label" select="'GradientLinear'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'gradientmesh.html')"/><xsl:with-param name="label" select="'GradientMesh'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'gradientradial.html')"/><xsl:with-param name="label" select="'GradientRadial'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'gradientvoronoi.html')"/><xsl:with-param name="label" select="'GradientVoronoi'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'vector.html')"/><xsl:with-param name="label" select="'Vector'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'vectorclip.html')"/><xsl:with-param name="label" select="'VectorClip'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'vectorcolour.html')"/><xsl:with-param name="label" select="'VectorColour'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'vectorellipse.html')"/><xsl:with-param name="label" select="'VectorEllipse'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'vectorfilter.html')"/><xsl:with-param name="label" select="'VectorFilter'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'vectorgradient.html')"/><xsl:with-param name="label" select="'VectorGradient'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'vectorgroup.html')"/><xsl:with-param name="label" select="'VectorGroup'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'vectorimage.html')"/><xsl:with-param name="label" select="'VectorImage'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'vectorpath.html')"/><xsl:with-param name="label" select="'VectorPath'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'vectorpattern.html')"/><xsl:with-param name="label" select="'VectorPattern'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'vectorpolygon.html')"/><xsl:with-param name="label" select="'VectorPolygon'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'vectorrectangle.html')"/><xsl:with-param name="label" select="'VectorRectangle'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'vectorscene.html')"/><xsl:with-param name="label" select="'VectorScene'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'vectorshape.html')"/><xsl:with-param name="label" select="'VectorShape'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'vectorspiral.html')"/><xsl:with-param name="label" select="'VectorSpiral'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'vectortext.html')"/><xsl:with-param name="label" select="'VectorText'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'vectortransition.html')"/><xsl:with-param name="label" select="'VectorTransition'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'vectorviewport.html')"/><xsl:with-param name="label" select="'VectorViewport'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($classes,'vectorwave.html')"/><xsl:with-param name="label" select="'VectorWave'"/></xsl:call-template>
                </ul>
              </div>
            </li><xsl:text>&#xa;</xsl:text>

          </ul>
        </div>
      </li>
    </ul> <!-- Classes -->
    <xsl:text>&#xa;</xsl:text>

    <!-- WIKI -->

    <ul class="list-unstyled">
      <li class="border-top my-3"></li> <!-- Line break -->
      <li>
        <xsl:call-template name="nav-toggle">
          <xsl:with-param name="target" select="'wiki-collapse'"/>
          <xsl:with-param name="label" select="'Wiki'"/>
          <xsl:with-param name="show" select="$expand='wiki'"/>
        </xsl:call-template>
        <div id="wiki-collapse">
          <xsl:attribute name="class">collapse<xsl:if test="$expand='wiki'"> show</xsl:if></xsl:attribute>
          <ul class="btn-toggle-nav list-unstyled fw-normal pb-1 ps-3"><xsl:text>&#xa;</xsl:text>

            <li>
              <xsl:call-template name="nav-toggle"><xsl:with-param name="target" select="'bp-collapse'"/><xsl:with-param name="label" select="'Build Process'"/></xsl:call-template>
              <div class="collapse" id="bp-collapse">
                <ul class="btn-toggle-nav list-unstyled pb-1"><xsl:text>&#xa;</xsl:text>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($wiki,'Linux-Builds.html')"/><xsl:with-param name="label" select="'Linux Builds'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($wiki,'Windows-Builds.html')"/><xsl:with-param name="label" select="'Windows Builds'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($wiki,'Customising-Your-Build.html')"/><xsl:with-param name="label" select="'Customising Your Build'"/></xsl:call-template>
                </ul>
              </div>
            </li><xsl:text>&#xa;</xsl:text>

            <li>
              <xsl:call-template name="nav-toggle"><xsl:with-param name="target" select="'tm-collapse'"/><xsl:with-param name="label" select="'Technical Manuals'"/></xsl:call-template>
              <div class="collapse" id="tm-collapse">
                <ul class="btn-toggle-nav list-unstyled pb-1"><xsl:text>&#xa;</xsl:text>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($wiki,'Kotuku-Objects.html')"/><xsl:with-param name="label" select="'Kōtuku Objects'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($wiki,'Kotuku-In-Depth.html')"/><xsl:with-param name="label" select="'Kōtuku In Depth'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($wiki,'Coding-With-AI.html')"/><xsl:with-param name="label" select="'Coding With AI'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($wiki,'Regex-Manual.html')"/><xsl:with-param name="label" select="'Regex Manual'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($wiki,'XML-Comparisons.html')"/><xsl:with-param name="label" select="'XML Comparisons'"/></xsl:call-template>
                </ul>
              </div>
            </li><xsl:text>&#xa;</xsl:text>

            <li>
              <xsl:call-template name="nav-toggle"><xsl:with-param name="target" select="'fg-collapse'"/><xsl:with-param name="label" select="'Tiri'"/></xsl:call-template>
              <div class="collapse" id="fg-collapse">
                <ul class="btn-toggle-nav list-unstyled pb-1"><xsl:text>&#xa;</xsl:text>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($wiki,'Tiri-Reference-Manual.html')"/><xsl:with-param name="label" select="'Tiri Reference Manual'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($wiki,'Tiri-Config-API.html')"/><xsl:with-param name="label" select="'Config API'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($wiki,'Tiri-Defer-Syntax.html')"/><xsl:with-param name="label" select="'Defer Syntax'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($wiki,'Tiri-GUI-API.html')"/><xsl:with-param name="label" select="'GUI API'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($wiki,'Tiri-HTTP-Server-API.html')"/><xsl:with-param name="label" select="'HTTP Server API'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($wiki,'Tiri-IO-API.html')"/><xsl:with-param name="label" select="'I/O API'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($wiki,'Tiri-JSON-API.html')"/><xsl:with-param name="label" select="'JSON API'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($wiki,'Tiri-OAuth-API.html')"/><xsl:with-param name="label" select="'OAuth API'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($wiki,'Tiri-Options-API.html')"/><xsl:with-param name="label" select="'Options API'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($wiki,'Tiri-Proxy-Server-API.html')"/><xsl:with-param name="label" select="'Proxy Server API'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($wiki,'Tiri-Tempus-API.html')"/><xsl:with-param name="label" select="'Tempus API'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($wiki,'Tiri-URL-API.html')"/><xsl:with-param name="label" select="'URL API'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($wiki,'Tiri-VFX-API.html')"/><xsl:with-param name="label" select="'VFX API'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($wiki,'Tiri-Widgets.html')"/><xsl:with-param name="label" select="'Widgets'"/></xsl:call-template>
                </ul>
              </div>
            </li><xsl:text>&#xa;</xsl:text>

            <li>
              <xsl:call-template name="nav-toggle"><xsl:with-param name="target" select="'rrm-collapse'"/><xsl:with-param name="label" select="'RIPL'"/></xsl:call-template>
              <div class="collapse" id="rrm-collapse">
                <ul class="btn-toggle-nav list-unstyled pb-1"><xsl:text>&#xa;</xsl:text>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($wiki,'RIPL-Reference-Manual.html')"/><xsl:with-param name="label" select="'RIPL Reference Manual'"/></xsl:call-template>
                </ul>
              </div>
            </li><xsl:text>&#xa;</xsl:text>

            <li>
              <xsl:call-template name="nav-toggle"><xsl:with-param name="target" select="'tools-collapse'"/><xsl:with-param name="label" select="'Tools'"/></xsl:call-template>
              <div class="collapse" id="tools-collapse">
                <ul class="btn-toggle-nav list-unstyled pb-1"><xsl:text>&#xa;</xsl:text>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($wiki,'Origo.html')"/><xsl:with-param name="label" select="'Origo'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($wiki,'Unit-Testing.html')"/><xsl:with-param name="label" select="'Flute / Unit Testing'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($wiki,'Tuku.html')"/><xsl:with-param name="label" select="'Tuku'"/></xsl:call-template>
                </ul>
              </div>
            </li><xsl:text>&#xa;</xsl:text>

            <li>
              <xsl:call-template name="nav-toggle"><xsl:with-param name="target" select="'doc-collapse'"/><xsl:with-param name="label" select="'Doc Generation'"/></xsl:call-template>
              <div class="collapse" id="doc-collapse">
                <ul class="btn-toggle-nav list-unstyled pb-1"><xsl:text>&#xa;</xsl:text>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($wiki,'Embedded-Document-Formatting.html')"/><xsl:with-param name="label" select="'Embedded Document Format'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($wiki,'TDL-Reference-Manual.html')"/><xsl:with-param name="label" select="'TDL Reference Manual'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($wiki,'TDL-Tools.html')"/><xsl:with-param name="label" select="'TDL Tools'"/></xsl:call-template>
                </ul>
              </div>
            </li><xsl:text>&#xa;</xsl:text>

            <li>
              <xsl:call-template name="nav-toggle"><xsl:with-param name="target" select="'app-collapse'"/><xsl:with-param name="label" select="'Appendix'"/></xsl:call-template>
              <div class="collapse" id="app-collapse">
                <ul class="btn-toggle-nav list-unstyled pb-1"><xsl:text>&#xa;</xsl:text>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($wiki,'Action-Reference-Manual.html')"/><xsl:with-param name="label" select="'Action Reference Manual'"/></xsl:call-template>
                  <xsl:call-template name="nav-link"><xsl:with-param name="href" select="concat($wiki,'System-Error-Codes.html')"/><xsl:with-param name="label" select="'System Error Codes'"/></xsl:call-template>
                </ul>
              </div>
            </li><xsl:text>&#xa;</xsl:text>

          </ul>
        </div>
      </li>
    </ul> <!-- Wiki -->
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>

</xsl:stylesheet>
