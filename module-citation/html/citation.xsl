<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- Citation mitten im Text -->
<xsl:template match="citation">
  <xsl:text> [</xsl:text>
  <xsl:apply-templates/>
   <xsl:text>] </xsl:text> 
</xsl:template>

<xsl:template match="citation" mode="label">
  <xsl:text>[</xsl:text>  
  <xsl:value-of select="count(preceding-sibling::citation)+1"/>
  <xsl:text>]</xsl:text>
</xsl:template>

<xsl:template match="bibliography/citation">
  <p>
    <a>
      <xsl:if test="@id">
        <xsl:attribute name="id">
          <xsl:value-of select="@id"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="." mode="label"/>
    </a>
    <xsl:text>&#xA0;</xsl:text>    
    <xsl:apply-templates/>
  </p>  
</xsl:template>

</xsl:stylesheet>

