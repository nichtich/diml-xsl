<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" >

<xsl:include href="html/table.xsl"/>

<xsl:template match="table">

  <!-- this will print pagenumbers included in a table or list etc.  -->
  <!-- in a combined way at the begin of this table, list etc.       -->
  <xsl:if test="descendant::pagenumber">
     <table width="100%" border="0">
       <tr>
         <td width="100%"><hr/></td>
         <xsl:choose>
           <xsl:when test="count(descendant::pagenumber) = 1">
              <td><span class="pagenumber"><nobr>[ <xsl:value-of select="$VOCABLES/page/@*[name()=$LANG]" />: <xsl:apply-templates select="descendant::pagenumber[1]" mode="pagenumber-combined" /> ]&#8595;</nobr></span></td>
           </xsl:when>
           <xsl:otherwise>
              <td><span class="pagenumber"><nobr>[ <xsl:value-of select="$VOCABLES/pages/@*[name()=$LANG]" />: <xsl:apply-templates select="descendant::pagenumber[1]" mode="pagenumber-combined" /> - <xsl:apply-templates select="descendant::pagenumber[position()=last()]" mode="pagenumber-combined" /> ]&#8595;</nobr></span></td>
           </xsl:otherwise>
         </xsl:choose>
       </tr>
     </table>
  </xsl:if>


 <div align="center">
 <table class="calstable" border="0" cellspacing="0" cellpadding="0">
   <xsl:apply-templates select="caption" mode="tablecaption"/>
   <tr>
     <td>
        <xsl:if test="tgroup/@cols &lt; 1">
          <xsl:message terminate="yes">tgroup/@cols &lt; 1!</xsl:message>
        </xsl:if>
        <xsl:apply-templates select="*[not(self::caption or self::legend)]" />
     </td>
   </tr>
   <xsl:apply-templates select="legend" mode="tablelegend"/>
 </table>
 </div>

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