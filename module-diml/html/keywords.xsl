<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="keywords">
  <p class="keywords">
     <span class="keywordsText">
       <xsl:choose>
         <xsl:when test="@language='de'">
            Eigene Schlagworte:
         </xsl:when>
         <xsl:when test="@language='en'">
            Keywords:
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="$VOCABLES/keywords/@*[name()=$lang]" /><xsl:text>: </xsl:text>
         </xsl:otherwise>
       </xsl:choose>
     </span>
     <xsl:text> </xsl:text>
     <xsl:apply-templates/>
  </p>
</xsl:template>

</xsl:stylesheet>

