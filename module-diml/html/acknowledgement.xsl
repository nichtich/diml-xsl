<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="acknowledgement">
  <xsl:apply-templates select="head/pagenumber" mode="hline"/>
  <h3>
    <a>
      <xsl:call-template name="a-name-attribute"/>
      <xsl:apply-templates select="." mode="head"/>
    </a>
  </h3>
  <xsl:apply-templates select="*[not(self::head)]" />
</xsl:template>

<xsl:template match="acknowledgement" mode="head">
  <xsl:choose>
    <xsl:when test="head">
      <xsl:apply-templates select="head"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$VOCABLES/acknowledgement/@*[name()=$LANG]" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
