<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
<xsl:template match="dedication">
  <xsl:apply-templates select="head/pagenumber" mode="hline"/>
  <h3 class="{name()}">
    <a>
      <xsl:call-template name="a-name-attribute"/>
      <xsl:apply-templates select="." mode="head"/>
    </a>
  </h3>
  <xsl:apply-templates select="*[not(self::head)]" />
</xsl:template>

<xsl:template match="dedication" mode="head">
  <xsl:choose>
    <xsl:when test="head and not(normalize-space(head)='')">
      <xsl:apply-templates select="head"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$VOCABLES/dedication/@*[name()=$LANG]" /><xsl:text>: </xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
