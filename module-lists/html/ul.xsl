<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="ul">

  <xsl:if test="descendant::pagenumber">
     <table width="100%" border="0">
       <tr>
         <td width="100%"><hr/></td>
         <xsl:choose>
           <xsl:when test="count(descendant::pagenumber) = 1">
              <td><p class="combinedPagenumbersText"><nobr>[ <xsl:value-of select="$VOCABLES/pages/@*[name()=$LANG]" />: <xsl:apply-templates select="descendant::pagenumber[1]" mode="pagenumber-combined" /> ]</nobr></p></td>
           </xsl:when>
           <xsl:otherwise>
              <td><p class="combinedPagenumbersText"><nobr>[ <xsl:value-of select="$VOCABLES/pages/@*[name()=$LANG]" />: <xsl:apply-templates select="descendant::pagenumber[1]" mode="pagenumber-combined" /> - <xsl:apply-templates select="descendant::pagenumber[position()=last()]" mode="pagenumber-combined" /> ]</nobr></p></td>
           </xsl:otherwise>
         </xsl:choose>
       </tr>
     </table>
  </xsl:if>

  <xsl:apply-templates select="caption"/>
  <ul>
    <xsl:apply-templates select="li"/>
  </ul>
</xsl:template>

</xsl:stylesheet>
