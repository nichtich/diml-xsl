<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:param name="PAGENUMBER-LABEL"></xsl:param> <!-- 'Seite: ' -->

<xsl:template match="head/pagenumber"/>
<xsl:template match="p/pagenumber[count(preceding-sibling::*)=0][normalize-space(preceding-sibling::text())='']"/> 

<xsl:template match="front/pagenumber|
	footnote/pagenumber|endnote/pagenumber|
	entry/pagenumber|glossary/pagenumber|dedication/pagenumber">
	<xsl:call-template name="pagenumber-hline"/>
</xsl:template>

<xsl:template match="chapter/pagenumber|section/pagenumber|subsection/pagenumber|subblock/pagenumber|block/pagenumber|part/pagenumber">
  <xsl:call-template name="pagenumber-hline"/>
</xsl:template>

<xsl:template match="pagenumber" mode="hline">
  <xsl:call-template name="pagenumber-hline"/>
</xsl:template>

<!--xsl:template match="pagenumber[count(preceding-sibling::text())=0]" mode="hline">	
	xx<xsl:call-template name="pagenumber-hline"/>
</xsl:template-->
	
<xsl:template name="pagenumber-hline">	
  <table width="100%" border="0">
    <tr>
      <td width="100%"><hr/></td>
      <td><xsl:call-template name="pagenumber-simple"/></td>
    </tr>  
  </table>
</xsl:template>

<xsl:template match="pagenumber/@start">
	<xsl:choose>
		<xsl:when test="@numerbing='arabic'">
			<xsl:number value="." format="1"/>
		</xsl:when>
		<xsl:when test="@numerbing='lalpha'">
			<xsl:number value="." format="a"/>
		</xsl:when>
		<xsl:when test="@numerbing='ualpha'">
			<xsl:number value="." format="A"/>
		</xsl:when>
		<xsl:when test="@numerbing='lroman'">
			<xsl:number value="." format="i"/>
		</xsl:when>
		<xsl:when test="@numerbing='uroman'">
			<xsl:number value="." format="I"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="."/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!--xsl:template match="pagenumber" name="pagenumber-content"-->
<!-- Use the start attribute or the label attribute! -->
<xsl:template match="pagenumber" name="pagenumber-content">
  <span class="pagenumber">
  	<xsl:text>[</xsl:text>
  	<xsl:value-of select="$PAGENUMBER-LABEL"/>
  	<xsl:value-of select="@system"/>
  	<xsl:choose>
		<xsl:when test="@label">
			<xsl:value-of select="@label"/>
		</xsl:when>
		<xsl:otherwise>
		  	<xsl:apply-templates select="@start"/>
		</xsl:otherwise>
	</xsl:choose>
  	<xsl:text>]</xsl:text>
  </span>
</xsl:template>

<xsl:template match="pagenumber" name="pagenumber-simple">
  <xsl:choose>
    <xsl:when test="@id">
      <a name="{@id}"><xsl:call-template name="pagenumber-content"/></a>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="pagenumber-content"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>

