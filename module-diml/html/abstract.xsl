<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


<xsl:template match="abstract">

  <p class="abstracthead">
       <xsl:choose>
         <xsl:when test="head">
              <xsl:apply-templates select="head"/>
         </xsl:when>
         <xsl:otherwise>
              <xsl:variable name="abstractlang" select="@lang"/>
              <xsl:value-of select="$VOCABLES/abstract/@*[name()=$abstractlang]" /><xsl:text>: </xsl:text>
         </xsl:otherwise>
       </xsl:choose>
  </p>
  <xsl:apply-templates select="*[not(self::head)]">
     <xsl:with-param name="cssTemplate" select="'abstract'"/>
  </xsl:apply-templates>
  
</xsl:template>

</xsl:stylesheet>

