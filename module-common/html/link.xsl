<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="link"> 
  <a href="#{generate-id(//*[@id=current()/@ref])}" class="link">
    <xsl:choose>
      <xsl:when test="not(*|text())">
        <xsl:variable name="target" select="//*[@id=current()/@ref]"/>
        <xsl:choose>
          <xsl:when test="$target/head">
            <xsl:apply-templates select="$target/head"/>      
          </xsl:when>
          <xsl:when test="name($target)='citation'">
            <xsl:apply-templates select="$target" mode="label"/>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>        
      </xsl:otherwise>
    </xsl:choose>  
  </a>
</xsl:template>

</xsl:stylesheet>
