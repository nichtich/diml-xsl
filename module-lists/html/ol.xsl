<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:variable name="OL_NUMBERING_STYLE">decimal</xsl:variable>

<xsl:template match="ol">

  <!-- Am Anfang von Listen wird momentan keine Zusammenfassung ausgegeben -->
  <xsl:if test="descendant::pagenumber">
    <!--<xsl:call-template name="more-pagenumbers-inside"/>-->
  </xsl:if>

  <xsl:apply-templates select="caption"/>
  <ol>
    <xsl:attribute name="style">
      <xsl:text>list-style-type:</xsl:text>
      <xsl:choose>
        <xsl:when test="@numbering='arabic'">decimal</xsl:when>
        <xsl:when test="@numbering='lalpha'">lower-alpha</xsl:when>
        <xsl:when test="@numbering='lroman'">lower-roman</xsl:when>
        <xsl:when test="@numbering='uroman'">upper-roman</xsl:when>
        <xsl:when test="@numbering='ualpha'">upper-alpha</xsl:when>
        <xsl:otherwise><xsl:value-of select="$OL_NUMBERING_STYLE"/></xsl:otherwise>        
      </xsl:choose>        
    </xsl:attribute>       
    <xsl:if test="@start">
      <xsl:attribute name="start"><xsl:value-of select="@start" /></xsl:attribute>
    </xsl:if>
    <xsl:apply-templates select="li"/>
  </ol>
</xsl:template>

</xsl:stylesheet>
