<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="abbreviation">
  <h3>
    <xsl:apply-templates select="." mode="head"/>
  </h3>
  <xsl:apply-templates select="*[not(self::head)]" />
</xsl:template>

<xsl:template match="abbreviation" mode="head">
  <xsl:choose>
    <xsl:when test="head">
      <xsl:apply-templates select="head"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>Abkuerzungsverzeichnis</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
