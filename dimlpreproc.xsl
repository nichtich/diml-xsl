<?xml version="1.0" encoding="ISO-8859-1"?>
<!-- ==================================================================

dimlpreproc.xsl - preprocessing DiML-files before we can generate HTML

======================================================================= -->
<!DOCTYPE xsl:stylesheet [
  <!ENTITY head-parents "abbreviation|abstract|acknowledgement|appendix|bibliography|block|chapter|copyright|declaration|dedication|example|frame|glossary|grant|part|preface|resources|section|stanza|subblock|subsection|summary|vita">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- Parameters -->
<xsl:param name="xml-stylesheet"> type="text/xsl" href="../diml2html.xsl"</xsl:param>
<xsl:param name="css-stylesheet"> ../style/did.css</xsl:param>

<!-- output (up to now without DTD - this will be changed) -->
<xsl:output method="xml"/>

<!-- root -->
<xsl:template match="/">
  <xsl:processing-instruction name="xml-stylesheet">
    <xsl:value-of select="$xml-stylesheet"/>
  </xsl:processing-instruction>
  <xsl:processing-instruction name="css-stylesheet">
    <xsl:value-of select="$css-stylesheet"/>
  </xsl:processing-instruction>  
  <xsl:apply-templates/>
</xsl:template>


<!--
 Every element that may have a 'head' should have an id-attribute
 and pagebreaks in the head are moved in front of it.
-->
<xsl:template match="&head-parents;">
  <xsl:element name="{name()}">
    <xsl:attribute name="id">
      <xsl:value-of select="generate-id()"/>
    </xsl:attribute>
    <xsl:copy-of select="@*"/>
    <xsl:for-each select="head/pagenumber">
      <xsl:copy-of select="."/>
    </xsl:for-each>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="head/pagenumber"/>


<!-- Copy everything unchanged -->
<xsl:template match="*">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>