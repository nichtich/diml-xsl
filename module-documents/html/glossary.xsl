<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- Vorraussetzung: jeder term hat 'ne id -->

<!-- see module-documents/html.xsl for matching this element --> 

<xsl:template match="glossary" mode="head">
    <xsl:choose>
      <xsl:when test="head and not(normalize-space(head)='')">
        <xsl:apply-templates select="head/*"/>
      </xsl:when>
      <xsl:otherwise>
      <xsl:value-of select="$VOCABLES/glossary/@*[name()=$LANG]" />
      </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:variable name="DEF_SYNONYM_SEE">
  <!-->&#xBB;</b-->
  <b>&#x2192;&#xA;</b>
</xsl:variable>

<xsl:template match="term" mode="in-def">
  <xsl:value-of select="$DEF_SYNONYM_SEE"/>
  <xsl:apply-templates select="."/> 
</xsl:template>

<xsl:template match="dd" mode="in-def">
  <xsl:apply-templates/>
</xsl:template>

</xsl:stylesheet>

