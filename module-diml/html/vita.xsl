<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="vita">
  <h3>
    <a name="#{generate-id(.)}">
      <xsl:apply-templates select="." mode="head"/>
    </a>
  </h3>
  <xsl:apply-templates select="*[not(self::head)]" />
</xsl:template>

<xsl:template match="vita" mode="head">
  <xsl:choose>
    <xsl:when test="head">
      <xsl:apply-templates select="head"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>Lebenslauf</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
