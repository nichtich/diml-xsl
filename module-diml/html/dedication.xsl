<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
<xsl:template match="dedication">
  <xsl:apply-templates select="head/pagenumber" mode="hline"/>
  <xsl:apply-templates select="." mode="head"/>
  <!--<p class="dedication">-->
  <xsl:apply-templates select="*[not(self::head)]" />
  <!--</p>-->
</xsl:template>

<xsl:template match="dedication" mode="head">
  <xsl:choose>
    <xsl:when test="head">
      <H3><xsl:apply-templates select="head"/></H3>
    </xsl:when>
    <xsl:otherwise>
      <H3><xsl:value-of select="$VOCABLES/dedication/@*[name()=$LANG]" /><xsl:text>: </xsl:text></H3>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>