<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="ul">

  <!-- Am Anfang von Listen wird momentan keine Zusammenfassung ausgegeben -->
  <xsl:if test="descendant::pagenumber">
    <!--<xsl:call-template name="more-pagenumbers-inside"/>-->
  </xsl:if>

  <xsl:apply-templates select="caption"/>
  <ul>
    <xsl:apply-templates select="li"/>
  </ul>
</xsl:template>

</xsl:stylesheet>
