<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:include href="html/footnote.xsl"/> <!-- and endnote -->
<xsl:include href="html/glossary.xsl"/>
<xsl:include href="html/glossref.xsl"/>
<xsl:include href="html/indexref.xsl"/>

<xsl:include href="html/example.xsl"/>
<xsl:include href="html/pagenumber.xsl"/>

<xsl:include href="html/abbreviation.xsl"/>
<xsl:include href="html/preface.xsl"/>
<xsl:include href="html/summary.xsl"/>

<xsl:include href="html/appendix.xsl"/>
<xsl:include href="html/vita.xsl"/>
<xsl:include href="html/resources.xsl"/>

<xsl:template match="abbreviation|preface|summary|vita|appendix">
  <xsl:apply-templates select="head/pagenumber" mode="hline"/>
  <h3 class="{name()}">
    <a name="#{generate-id(.)}">
      <xsl:apply-templates select="." mode="head"/>
    </a>
  </h3>
  <xsl:apply-templates select="*[not(self::head)]" />
</xsl:template>

</xsl:stylesheet>