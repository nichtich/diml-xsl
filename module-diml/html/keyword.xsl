<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="keyword">
  <span class="keyword">
     <xsl:apply-templates/>
     <xsl:choose>
        <xsl:when test="count(preceding-sibling::keyword)+1!=count(../child::keyword)">
           <xsl:text>, </xsl:text>
        </xsl:when>
        <xsl:otherwise>
        </xsl:otherwise>
     </xsl:choose>   
  </span>
</xsl:template>

</xsl:stylesheet>

