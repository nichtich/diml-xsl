<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="bibliography" name="element-bibliography">
  <h3>
    <a name="#{generate-id(.)}">
      <xsl:apply-templates select="." mode="head"/>
    </a> 
  </h3>
  <xsl:for-each select="*[name()!='head']"> <!-- != head -->
    <xsl:choose>
      <xsl:when test="name(.)='citation'">
        <p><xsl:apply-templates select="."/></p>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
</xsl:template>

<xsl:template match="bibliography" mode="head" name="bibliography-head">
  <xsl:choose>
    <xsl:when test="head">
      <xsl:apply-templates select="head"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>Literatur</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
