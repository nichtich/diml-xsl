<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="li">
  <li>
    <xsl:choose>
      <xsl:when test="count(*)=1 and p">
        <xsl:apply-templates select="p/*|p/text()"/>  
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>      
      </xsl:otherwise>
    </xsl:choose>
    <!-- wenn Seitenzahl als erstes in "li" oder enthaltenem "p",    -->
    <!-- dann schon am Ende des vorhergehenden "li"-Elements ausgeben -->
    <xsl:apply-templates select="following-sibling::li[1]//pagenumber[count(preceding-sibling::*)=0][normalize-space(preceding-sibling::text())='']" mode="forceOutput" />
  </li>
</xsl:template>

</xsl:stylesheet>

