<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="preface" mode="head">
  <xsl:choose>
    <xsl:when test="head">
      <xsl:apply-templates select="head"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$VOCABLES/preface/@*[name()=$lang]" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
