<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">

  <!-- Shared navigation (navbar + sidebar).  Edit build/nav.xsl to change the site navigation.
       xsl:import (rather than xsl:include) is required so that the 'root' parameter can be overridden below. -->

  <xsl:import href="nav.xsl"/>

  <!-- Module pages live in site/modules/, one level below the site root. -->

  <xsl:param name="root" select="'../'"/>

  <!-- python3 -m http.server -d /kotuku/docs/xml -->

  <xsl:output
    doctype-public="-//W3C//DTD XHTML 1.1//EN"
    doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"
    method="html" encoding="utf-8"
    omit-xml-declaration="yes" indent="no"/>

  <xsl:template match="constants">
    <xsl:choose>
      <xsl:when test="const">
        <table class="table">
          <thead><tr><th>Name</th><th>Description</th></tr></thead>
          <tbody>
            <xsl:for-each select="const">
              <tr><th class="col-md-1"><xsl:value-of select="../@prefix"/>::<xsl:value-of select="@name"/></th><td><xsl:apply-templates select="."/></td></tr>
              <xsl:text>&#xa;</xsl:text>
            </xsl:for-each>
          </tbody>
        </table>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="prefix"><xsl:value-of select="@prefix"/></xsl:variable>
        <table class="table">
          <thead><tr><th>Name</th><th>Description</th></tr></thead>
          <tbody>
            <xsl:for-each select="/book/types/constants[@lookup=$prefix]/const">
              <tr><th class="col-md-1"><xsl:value-of select="../@lookup"/>::<xsl:value-of select="@name"/></th><td><xsl:apply-templates select="."/></td></tr>
              <xsl:text>&#xa;</xsl:text>
            </xsl:for-each>
          </tbody>
        </table>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="types">
    <xsl:choose>
      <xsl:when test="type">
        <table class="table">
          <thead><tr><th>Name</th><th>Description</th></tr></thead>
          <tbody>
            <xsl:for-each select="type">
              <xsl:choose>
                <xsl:when test="../@lookup">
                  <tr><th class="col-md-1"><xsl:value-of select="../@lookup"/>::<xsl:value-of select="@name"/></th><td><xsl:apply-templates select="."/></td></tr>
                </xsl:when>
                <xsl:otherwise>
                  <tr><th class="col-md-1"><xsl:value-of select="@name"/></th><td><xsl:apply-templates select="."/></td></tr>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:text>&#xa;</xsl:text>
            </xsl:for-each>
          </tbody>
        </table>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="prefix"><xsl:value-of select="@lookup"/></xsl:variable>
        <table class="table">
          <thead><tr><th>Name</th><th>Description</th></tr></thead>
          <tbody>
            <xsl:for-each select="/book/types/constants[@lookup=$prefix]/const">
              <tr><th><xsl:value-of select="../@lookup"/>::<xsl:value-of select="@name"/></th><td><xsl:apply-templates select="."/></td></tr>
              <xsl:text>&#xa;</xsl:text>
            </xsl:for-each>
          </tbody>
        </table>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="text()"><xsl:value-of select="."/></xsl:template>

  <xsl:template match="p|b|li">
    <xsl:element name="{name()}" xmlns="http://www.w3.org/1999/xhtml">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates select="*|text()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="st"> <!-- Struct reference -->
    <xsl:variable name="structName"><xsl:value-of select="node()"/></xsl:variable>
    <a data-toggle="tooltip"><xsl:attribute name="title"><xsl:value-of select="/book/structs/struct[name=$structName]/comment"/></xsl:attribute><xsl:attribute name="href">?page=struct-<xsl:value-of select="node()"/></xsl:attribute><xsl:value-of select="node()"/></a>
  </xsl:template>

  <xsl:template match="lk"> <!-- Type reference -->
    <xsl:variable name="typeName"><xsl:value-of select="node()"/></xsl:variable>
    <a data-toggle="tooltip"><xsl:attribute name="title"><xsl:value-of select="/book/structs/struct[name=$typeName]/comment"/></xsl:attribute><xsl:attribute name="href">?page=<xsl:value-of select="node()"/></xsl:attribute><xsl:value-of select="node()"/></a>
  </xsl:template>

  <xsl:template match="function">
    <xsl:choose>
      <xsl:when test="@module">
        <xsl:variable name="mod_name"><xsl:value-of select="@module"/></xsl:variable>
        <xsl:variable name="mod_lower" select="translate($mod_name,'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
        <a><xsl:attribute name="href"><xsl:value-of select="$mod_lower"/>.html?page=<xsl:value-of select="."/></xsl:attribute><xsl:value-of select="."/>()</a>
      </xsl:when>
      <xsl:otherwise>
        <a><xsl:attribute name="href">?page=<xsl:value-of select="."/></xsl:attribute><xsl:value-of select="."/>()</a>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="list">
    <xsl:choose>
      <xsl:when test="@type='ordered'">
        <ol><xsl:apply-templates select="*|node()"/></ol>
      </xsl:when>
      <xsl:otherwise>
        <ul><xsl:apply-templates select="*|node()"/></ul>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="class">
    <xsl:variable name="class_name"><xsl:value-of select="@name"/></xsl:variable>
    <xsl:variable name="class_lower" select="translate($class_name,'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>

    <xsl:choose>
      <xsl:when test="@field">
        <a><xsl:attribute name="href">classes/<xsl:value-of select="$class_lower"/>.html#tf-<xsl:value-of select="@field"/></xsl:attribute><xsl:value-of select="@name"/>&#8658;<xsl:value-of select="@field"/></a>
      </xsl:when>
      <xsl:when test="@method">
        <a><xsl:attribute name="href">classes/<xsl:value-of select="$class_lower"/>.html#tm-<xsl:value-of select="@method"/></xsl:attribute><xsl:value-of select="@name"/>&#8658;<xsl:value-of select="@method"/>()</a>
      </xsl:when>
      <xsl:otherwise>
        <a><xsl:attribute name="href">classes/<xsl:value-of select="$class_lower"/>.html</xsl:attribute><xsl:value-of select="@name"/></a>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="include">
    <code><xsl:value-of select="."/></code>
  </xsl:template>

  <xsl:template match="header">
    <h4><xsl:value-of select="."/></h4>
  </xsl:template>

  <xsl:template match="code">
    <xsl:element name="{name()}" xmlns="http://www.w3.org/1999/xhtml">
      <xsl:apply-templates select="*|text()" />
    </xsl:element>
  </xsl:template>

  <xsl:template match="pre"> <!-- Note that pre areas can legitimately use elements like 'b' for visual enhancement -->
    <xsl:element name="{name()}" xmlns="http://www.w3.org/1999/xhtml">
      <xsl:apply-templates select="*|node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template name="addGoogleTracking">
    <!-- Global site tag (gtag.js) - Google Analytics -->
	 <script type="text/javascript" async="async" src="https://www.googletagmanager.com/gtag/js?id=G-8254DG7MT6"><xsl:text> </xsl:text></script>
	 <script type="text/javascript">
	   <xsl:text disable-output-escaping="yes">
	   window.dataLayer = window.dataLayer || [];
	   function gtag(){dataLayer.push(arguments);}
	   gtag('js', new Date());
      gtag('config', 'G-8254DG7MT6');</xsl:text>
	 </script>
  </xsl:template>

  <xsl:template match="/book">
    <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
      <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <xsl:call-template name="addGoogleTracking"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <!-- The above 2 meta tags *must* come first in the head; any other head content must come *after* these tags -->
        <meta name="description" content="Kōtuku documentation, machine generated from source"/>
        <meta name="author" content="Paul Manias"/>
        <link rel="icon" href="/favicon.ico"/>
        <title>Kōtuku Manual</title>
        <link href="../css/bootstrap.min.css" rel="stylesheet"/>
        <link href="../css/module-template.css" rel="stylesheet"/>
      </head>

      <body>
        <xsl:call-template name="nav-bar"/>
        <xsl:text>&#xa;</xsl:text>
        <div class="container-fluid"> <!-- 'container-fluid' for full width, 'container' for restricted -->
          <div class="row">

            <!-- SIDEBAR -->
            <div class="d-sm-block d-none col-3 sidebar" style="max-width: 230px;">
              <div class="flex-shrink-1 pt-2 pe-2 sticky-top overflow-auto vh-100 b-shadow">

<ul class="list-unstyled">
  <li><button class="btn btn-toggle align-items-center rounded collapsed" data-bs-toggle="collapse" data-bs-target="#func-collapse" aria-expanded="true"><xsl:value-of select="/book/info/name"/> API</button>
    <div class="collapse show" id="func-collapse"><xsl:text>&#xa;</xsl:text>
      <ul class="btn-toggle-nav list-unstyled fw-normal"><xsl:text>&#xa;</xsl:text>
        <li><a class="rounded" role="button"><xsl:attribute name="onclick">showPage('default-page');</xsl:attribute><i class="bi bi-house"/><xsl:text>&#160;</xsl:text>Overview</a></li>
        <li class="border-top my-1"></li> <!-- Line break -->
        <xsl:text>&#xa;</xsl:text>
        <xsl:if test="count(/book/*/category) = 0">
          <xsl:for-each select="/book/function[not(category)]"><li><a role="button" class="rounded"><xsl:attribute name="onclick">showPage('<xsl:value-of select="name"/>');</xsl:attribute><xsl:value-of select="name"/>()</a></li></xsl:for-each>
        </xsl:if>
        <xsl:text>&#xa;</xsl:text>
        <xsl:for-each select="info/categories/category">
          <xsl:variable name="category"><xsl:value-of select="."/></xsl:variable>
          <xsl:variable name="id-category" select="translate($category,' ','_')"/>
          <li><ul class="list-unstyled ps-3">
             <li><button class="btn btn-toggle align-items-center rounded collapsed" data-bs-toggle="collapse" aria-expanded="false"><xsl:attribute name="data-bs-target">#<xsl:value-of select="."/>-collapse</xsl:attribute><xsl:value-of select="."/></button>
               <div class="collapse">
                 <xsl:attribute name="id"><xsl:value-of select="."/>-collapse</xsl:attribute>
                 <ul class="btn-toggle-nav list-unstyled fw-normal pb-1 ps-3">
                   <xsl:for-each select="/book/function[category=$category]">
                     <li><a class="rounded" role="button"><xsl:attribute name="onclick">showPage('<xsl:value-of select="name"/>');</xsl:attribute><xsl:value-of select="name"/>()</a></li>
                     <xsl:text>&#xa;</xsl:text>
                   </xsl:for-each>
                 </ul><xsl:text>&#xa;</xsl:text>
               </div><xsl:text>&#xa;</xsl:text>
             </li><xsl:text>&#xa;</xsl:text>
           </ul></li><xsl:text>&#xa;</xsl:text>
           <xsl:text>&#xa;</xsl:text>
        </xsl:for-each> <!-- Category -->
      </ul>
    </div>
  </li>
</ul>

<xsl:call-template name="nav-sidebar"/>
              </div>
            </div>

            <!-- DEFAULT BODY -->
            <div class="col-sm-9" style="max-width: 1200px;">
              <div class="docs-content" style="display:none;" id="default-page">
                <div class="page-header"><h1><xsl:value-of select="/book/info/name"/> Module</h1></div>

                <p class="lead"><xsl:value-of select="/book/info/comment"/></p>
                <xsl:for-each select="/book/info/description">
                  <xsl:apply-templates/>
                  <xsl:text>&#xa;</xsl:text>
                </xsl:for-each>

                <h3>Functions</h3>

                <!-- Non-categorised functions -->
                <xsl:if test="count(/book/*/category) = 0">
                  <p class="appendix"><xsl:for-each select="/book/function">
                    <a role="button"><xsl:attribute name="onclick">showPage('<xsl:value-of select="name"/>');</xsl:attribute><xsl:value-of select="name"/></a><xsl:if test="position() != last()"><xsl:text>&#160;</xsl:text>| </xsl:if>
                  </xsl:for-each></p>
                </xsl:if>

                <!-- Categorised functions -->
                <xsl:for-each select="info/categories/category">
                  <xsl:variable name="category"><xsl:value-of select="."/></xsl:variable>
                  <xsl:variable name="id-category" select="translate($category,' ','_')"/>
                  <h6><xsl:value-of select="."/></h6>
                  <p class="appendix ps-4"><xsl:for-each select="/book/function[category=$category]">
                    <a role="button"><xsl:attribute name="onclick">showPage('<xsl:value-of select="name"/>');</xsl:attribute><xsl:value-of select="name"/></a><xsl:if test="position() != last()"><xsl:text>&#160;</xsl:text>| </xsl:if>
                  </xsl:for-each></p>
                </xsl:for-each>

                <xsl:if test="count(structs/struct) > 0">
                  <h3>Structures</h3>
                  <p class="appendix"><xsl:for-each select="structs/struct">
                    <xsl:sort select="@name"/>
                    <a role="button"><xsl:attribute name="onclick">showPage('struct-<xsl:value-of select="@name"/>');</xsl:attribute><xsl:value-of select="@name"/></a><xsl:if test="position() != last()"><xsl:text>&#160;</xsl:text>| </xsl:if>
                  </xsl:for-each></p>
                </xsl:if>

                <xsl:if test="count(info/classes/class) > 0">
                  <h3>Classes</h3>
                  <p class="appendix"><xsl:for-each select="info/classes/class">
                    <xsl:variable name="class_name"><xsl:value-of select="."/></xsl:variable>
                    <xsl:variable name="lower" select="translate($class_name,'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
                    <a role="button" onclick=""><xsl:attribute name="href">classes/<xsl:value-of select="$lower"/>.html</xsl:attribute><xsl:value-of select="."/></a><xsl:if test="position() != last()"><xsl:text>&#160;</xsl:text>| </xsl:if>
                  </xsl:for-each></p>
                </xsl:if>

                <xsl:if test="count(types/constants) > 0">
                  <h3>Constants</h3>
                  <p class="appendix"><xsl:for-each select="types/constants">
                    <xsl:sort select="@lookup"/>
                    <a role="button"><xsl:attribute name="onclick">showPage('<xsl:value-of select="@lookup"/>');</xsl:attribute><xsl:value-of select="@lookup"/></a><xsl:if test="position() != last()"><xsl:text>&#160;</xsl:text>| </xsl:if>
                  </xsl:for-each></p>
                </xsl:if>
              </div>

              <!-- FUNCTION BODY -->
              <xsl:for-each select="function">
                <div class="docs-content" style="display:none;">
                  <xsl:attribute name="id"><xsl:value-of select="name"/></xsl:attribute>

                  <h2><xsl:value-of select="name"/>()</h2>
                  <p class="lead"><xsl:value-of select="comment"/></p>
                  <div class="card card-info mb-3">
                    <div class="card-header"><samp><xsl:value-of select="prototype"/></samp></div>

                    <xsl:choose>
                      <xsl:when test="input/param">
                        <div class="card-body" style="padding:0px">
                          <table class="table mb-3 thead-light">
                            <thead>
                              <tr><th class="col-md-1">Parameter</th><th>Description</th></tr>
                            </thead>
                            <tbody>
                              <xsl:for-each select="input/param">
                                <xsl:choose>
                                  <xsl:when test="@lookup">
                                    <tr><td><a><xsl:attribute name="onclick">showPage('<xsl:value-of select="@lookup"/>');</xsl:attribute><xsl:value-of select="@name"/></a></td><td><xsl:apply-templates select="."/></td></tr>
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <tr><td><xsl:value-of select="@name"/></td><td><xsl:apply-templates select="."/></td></tr>
                                  </xsl:otherwise>
                                </xsl:choose>
                                <xsl:text>&#xa;</xsl:text>
                              </xsl:for-each>
                            </tbody>
                          </table>
                        </div>
                      </xsl:when>
                    </xsl:choose>
                  </div>

                  <xsl:for-each select="description">
                    <xsl:apply-templates/>
                  </xsl:for-each>

                  <xsl:choose>
                    <xsl:when test="result/error">
                      <h3>Error Codes</h3>
                      <table class="table table-sm borderless">
                        <tbody>
                          <xsl:for-each select="result/error">
                            <tr><th class="col-md-1"><xsl:value-of select="@code"/></th><td><xsl:apply-templates select="."/></td></tr>
                            <xsl:text>&#xa;</xsl:text>
                          </xsl:for-each>
                        </tbody>
                      </table>
                    </xsl:when>
                    <xsl:when test="result">
                      <h3>Result</h3>
                      <p><xsl:apply-templates select="result/."/></p>
                    </xsl:when>
                  </xsl:choose>

                  <div class="footer copyright text-right"><xsl:value-of select="/book/info/name"/> module documentation © <xsl:value-of select="/book/info/copyright"/></div>
                </div>
                <xsl:text>&#xa;</xsl:text>
              </xsl:for-each> <!-- End of function scan -->

              <!-- TYPES -->

              <xsl:if test="count(types/constants) > 0">
                <xsl:for-each select="types/constants">
                  <div class="docs-content" style="display:none;">
                    <xsl:attribute name="id"><xsl:value-of select="@lookup"/></xsl:attribute>
                    <h1><xsl:value-of select="@lookup"/> Type</h1>
                    <p class="lead"><xsl:apply-templates select="@comment"/></p>
                    <xsl:if test="count(const) > 0">
                      <table class="table">
                        <thead><tr><th class="col-md-1">Name</th><th>Description</th></tr></thead>
                        <tbody>
                          <xsl:for-each select="const">
                            <tr><th><xsl:value-of select="../@lookup"/>::<xsl:value-of select="@name"/></th><td><xsl:apply-templates select="."/></td></tr>
                            <xsl:text>&#xa;</xsl:text>
                          </xsl:for-each>
                        </tbody>
                      </table>
                    </xsl:if>
                    <div class="footer copyright text-right"><xsl:value-of select="/book/info/name"/> module documentation © <xsl:value-of select="/book/info/copyright"/></div>
                  </div>
                  <xsl:text>&#xa;</xsl:text>
                </xsl:for-each> <!-- End of type scan -->
              </xsl:if>

              <!-- STRUCTURES -->
              <xsl:for-each select="structs/struct">
                <div class="docs-content" style="display:none;">
                  <xsl:attribute name="id">struct-<xsl:value-of select="@name"/></xsl:attribute>
                  <h1><xsl:value-of select="@name"/> Structure</h1>
                  <p class="lead"><xsl:apply-templates select="@comment"/></p>
                  <table class="table">
                    <thead><tr><th class="col-md-1">Field</th><th class="col-md-1">Type</th><th>Description</th></tr></thead>
                    <tbody>
                      <xsl:for-each select="field">
                        <tr>
                          <th><xsl:value-of select="@name"/></th>
                          <td><span class="text-nowrap"><xsl:value-of select="@type"/></span></td>
                          <td><xsl:apply-templates select="."/></td>
                        </tr>
                        <xsl:text>&#xa;</xsl:text>
                      </xsl:for-each>
                    </tbody>
                  </table>
                  <div class="footer copyright text-right"><xsl:value-of select="/book/info/name"/> module documentation © <xsl:value-of select="/book/info/copyright"/></div>
                </div>
                <xsl:text>&#xa;</xsl:text>
              </xsl:for-each> <!-- End of struct scan -->
            </div> <!-- End of core content -->
          </div> <!-- row -->
        </div> <!-- container -->

        <script type="text/javascript" src="../js/bootstrap.bundle.min.js"></script>
        <script type="text/javascript" src="../js/base.js"></script>
        <script type="text/javascript"><xsl:text disable-output-escaping="yes">
var glCurrentMethod;

const ready = fn => document.readyState !== 'loading' ? fn() : document.addEventListener('DOMContentLoaded', fn);

   var xslt = window.location.pathname.endsWith(".xml"); // XSLT is being used to view this document

ready(function(){
   // Initialise tooltips
   var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
   var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
     return new bootstrap.Tooltip(tooltipTriggerEl)
   })

   glCurrentMethod = document.getElementById("Introduction");

   highlightNavLink(); // Highlight and open the sidebar branch for this page (see base.js)

   var page = glParameters["page"];
   if (isEmpty(page)) page = glParameters["function"];

   if (isEmpty(page)) showPage("default-page", true);
   else showPage(page, true);

   window.onpopstate = popState;

   // In XSLT mode, changing all HTML links to XML is helpful for navigation (if heavy handed)
   if (xslt) {
      var nl = document.querySelectorAll('a[href$=".html"]');
      nl.forEach((el) => {
         el.href = el.href.substr(0, el.href.length-5) + '.xml'
      })
   }
});

function popState(event) {
   console.log("popState() to " + JSON.stringify(event.state));

   state = event.state
   if (!state) state = { page: 'default-page' }

   var div
   if (state.page) div = document.getElementById(state.page);
   else div =  document.getElementById('default-page');

   if (div) {
      if (glCurrentMethod) glCurrentMethod.style.display = "none"; // Hide previous method.
      div.style.display = "block"; // Show selected method.
      glCurrentMethod = div;
   }
   else console.log("Div for '" + state.page + "' not found.");
}

function showPage(Name, NoHistory)
{
   var div = document.getElementById(Name);
   if (div) {
      if (glCurrentMethod) glCurrentMethod.style.display = "none"; // Hide previous method.
      div.style.display = "block"; // Show selected method.
      glCurrentMethod = div;

      if (!NoHistory) {
         history.pushState({ page: Name }, null, "?page=" + Name);
      }
      window.scrollTo(0, 0)
   }
   else console.log("Div for '" + Name + "' not found.");

   return false;
}
         </xsl:text>
        </script>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
