<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="title">
  <p class="title"><xsl:apply-templates/></p>
</xsl:template>

<!-- Metadata -->
<xsl:template match="title" mode="html-head">
  <title><xsl:value-of select="text()"/></title>
</xsl:template>

<!-- Kopfzeile -->
<xsl:template match="title" mode="headline">
  <span class="headline-title"><xsl:apply-templates/></span>
</xsl:template>


</xsl:stylesheet>
