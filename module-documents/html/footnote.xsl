<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="footnote">
  <a name="{concat(generate-id(),'link')}">
    <a href="#{generate-id()}">
      <xsl:apply-templates select="." mode="label"/>
    </a>  
  </a>  
</xsl:template>

<xsl:template match="footnote" mode="label">
  <!-- TODO: label, numbering... -->
  <!--xsl:choose>
    <xsl:when test=""></xsl:when>
  </xsl:choose-->
  <sup><xsl:value-of select="count(preceding::footnote)+1"/></sup>
</xsl:template>

<xsl:template match="footnote" mode="foot">
  <p>
    <a name="{generate-id()}">
      <a href="#{concat(generate-id(),'link')}">
        <xsl:apply-templates select="." mode="label"/>
      </a>  
    </a>
    <xsl:text>&#xA0;</xsl:text>    
    <xsl:choose>
      <xsl:when test="count(*)=1 and p">
        <xsl:apply-templates select="p/*|p/text()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </p>  
</xsl:template>

</xsl:stylesheet>
