<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" >

<xsl:include href="html/table.xsl"/>

<!-- TODO: handle 'caption' and 'legend' -->
<xsl:template match="table">
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

<xsl:template name='dbhtml-attribute'/>
<!--xsl:template name='language.attribute'/>
<xsl:template name='copy-string'/>
<xsl:template name='pi-attribute'/-->
<xsl:template name="dot.count"/>
<xsl:template name="gentext"/>
<xsl:template name="gentext.endquote"/>
<xsl:template name="gentext.nestedendquote"/>
<xsl:template name="gentext.template"/>
<xsl:template name="gentext.startquote"/>
<xsl:template name="gentext.nestedstartquote"/>
<!--xsl:template name="lookup.key"/>
<xsl:template name="xpath.location"/>
<xsl:template name="is.graphic.format"/>
<xsl:template name="is.graphic.extension"/>
<xsl:template name="xpointer.idref"/>
<xsl:template name='substitute-markup'/-->

<xsl:template name="copy-string">
  <!-- returns 'count' copies of 'string' -->
  <xsl:param name="string"/>
  <xsl:param name="count" select="0"/>
  <xsl:param name="result"/>

  <xsl:choose>
    <xsl:when test="$count&gt;0">
      <xsl:call-template name="copy-string">
        <xsl:with-param name="string" select="$string"/>
        <xsl:with-param name="count" select="$count - 1"/>
        <xsl:with-param name="result">
          <xsl:value-of select="$result"/>
          <xsl:value-of select="$string"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$result"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>



<!--== Parameters ==-->
<!-- Tables -->
<xsl:param name="default.table.width" select="''"></xsl:param>
<xsl:param name="nominal.table.width" select="'6in'"></xsl:param>
<xsl:param name="table.borders.with.css" select="0"></xsl:param>
<xsl:param name="table.cell.border.style" select="'solid'"></xsl:param>
<xsl:param name="table.cell.border.thickness" select="'0.5pt'"></xsl:param>
<xsl:param name="table.cell.border.color" select="''"></xsl:param>
<xsl:param name="table.frame.border.style" select="'solid'"></xsl:param>
<xsl:param name="table.frame.border.thickness" select="'0.5pt'"></xsl:param>
<xsl:param name="table.frame.border.color" select="''"></xsl:param>
<xsl:param name="html.cellspacing" select="''"></xsl:param>
<xsl:param name="html.cellpadding" select="''"></xsl:param>

<!-- Extensions -->
<xsl:param name="tablecolumns.extension" select="'1'"></xsl:param>
<xsl:param name="use.extensions" select="'0'"></xsl:param>

<!-- HTML -->
<xsl:param name="entry.propagates.style" select="1"></xsl:param>

<!-- Misc -->
<xsl:param name="show.revisionflag">0</xsl:param>


</xsl:stylesheet>