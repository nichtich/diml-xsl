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
              <td><p class="combinedPagenumbersText"><nobr>Eine Seite in der Tabelle enthalten: Seite <xsl:apply-templates select="descendant::pagenumber[1]" mode="pagenumber-combined" /></nobr></p></td>
           </xsl:when>
           <xsl:when test="count(descendant::pagenumber) = 2">
              <td><p class="combinedPagenumbersText"><nobr>Zwei Seiten in der Tabelle enthalten: Seite <xsl:apply-templates select="descendant::pagenumber[1]" mode="pagenumber-combined" /> und <xsl:apply-templates select="descendant::pagenumber[position()=last()]" mode="pagenumber-combined" /></nobr></p></td>
           </xsl:when>
           <xsl:otherwise>
              <td><p class="combinedPagenumbersText"><nobr><xsl:value-of select="count(descendant::pagenumber)"/> Seiten in der Tabelle enthalten: Seite <xsl:apply-templates select="descendant::pagenumber[1]" mode="pagenumber-combined" /> bis <xsl:apply-templates select="descendant::pagenumber[position()=last()]" mode="pagenumber-combined" /></nobr></p></td>
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
  <p class="tablelegend">
     <xsl:apply-templates select="legend" mode="tablelegend" />
  </p>
</xsl:template>

<!-- no elements (TODO: clean up and [re]move) -->
<xsl:include href="html/param.xsl"/>
<xsl:include href="html/inline.xsl"/>
<xsl:include href="html/xref.xsl"/>
<xsl:include href="html/html.xsl"/>
<xsl:include href="common/common.xsl"/>

<!-- special DiML-Table -->
<xsl:include href="html/legend.xsl"/>

<!-- defined templates in DocBook Stylesheets -->
<xsl:template name='dbhtml-attribute'/>
<xsl:template name='language.attribute'/>
<xsl:template name='copy-string'/>
<xsl:template name='pi-attribute'/>
<xsl:template name="dot.count"/>
<xsl:template name="gentext"/>
<xsl:template name="gentext.endquote"/>
<xsl:template name="gentext.nestedendquote"/>
<xsl:template name="gentext.template"/>
<xsl:template name="gentext.startquote"/>
<xsl:template name="gentext.nestedstartquote"/>
<xsl:template name="lookup.key"/>
<xsl:template name="xpath.location"/>
<xsl:template name="is.graphic.format"/>
<xsl:template name="is.graphic.extension"/>
<xsl:template name="xpointer.idref"/>
<xsl:template name='substitute-markup'/>


</xsl:stylesheet>