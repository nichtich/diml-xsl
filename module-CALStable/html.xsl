<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" >

<xsl:include href="html/table.xsl"/>

<!-- TODO: handle 'caption' and 'legend' -->
<xsl:template match="table">

<!-- this will print pagenumbers included in a table or list etc.  -->
<!-- in a combined way at the begin of this table, list etc.       -->

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

  <p class="tablecaption">
     <a> 
        <xsl:call-template name="a-name-attribute"/>    
        <xsl:apply-templates select="caption" />
     </a>
  </p>
  <xsl:if test="tgroup/@cols &lt; 1">
    <xsl:message terminate="yes">tgroup/@cols &lt; 1!</xsl:message>
  </xsl:if>
  <xsl:apply-templates select="*[not(self::caption or self::legend)]" />
   <xsl:apply-templates select="legend"/>
</xsl:template>

<xsl:param name="table.cell.border.color" select="''"/>
<xsl:param name="table.cell.border.style" select="'solid'"/>
<xsl:param name="table.cell.border.thickness" select="'0.5pt'"/>
<xsl:param name="table.frame.border.color" select="''"/>
<xsl:param name="table.frame.border.style" select="'solid'"/>
<xsl:param name="table.frame.border.thickness" select="'0.5pt'"/>
<xsl:param name="table.borders.with.css" select="0"/>
<xsl:param name="tablecolumns.extension" select="'1'"/>
<xsl:param name="html.cellpadding" select="''"/>
<xsl:param name="html.cellspacing" select="''"/>

<!-- TODO? : defined templates in DocBook Stylesheets -->
<xsl:template name='copy-string'/>

</xsl:stylesheet>