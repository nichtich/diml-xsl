<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:variable name="OL_NUMBERING_STYLE">decimal</xsl:variable>

<xsl:template match="ol">

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
    <xsl:apply-templates select="li"/>
  </ol>
</xsl:template>

</xsl:stylesheet>
