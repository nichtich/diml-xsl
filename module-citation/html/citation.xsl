<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="citation">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="citation" mode="label">
  <xsl:text>[</xsl:text>  
  <xsl:value-of select="count(preceding-sibling::citation)+1"/>
  <xsl:text>]</xsl:text>
</xsl:template>

<xsl:template match="bibliography/citation">
  <p>
    <a name="{generate-id(.)}">
      <xsl:apply-templates select="." mode="label"/>
    </a>
    <xsl:text>&#xA0;</xsl:text>    
    <xsl:apply-templates/>
  </p>  
</xsl:template>

</xsl:stylesheet>
