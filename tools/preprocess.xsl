<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cms="http://edoc.hu-berlin.de/diml/module/cms">

<xsl:param name="NUMBERING">1</xsl:param>

<xsl:template name="provide-id">
	<xsl:if test="not(@id)">
		<xsl:attribute name="id">
			<xsl:value-of select="generate-id()"/>
		</xsl:attribute>	
	</xsl:if>
</xsl:template>

<xsl:template name="entity-to-filename">
	<xsl:param name="file" select="unparsed-entity-uri(@entity)"/>
	<xsl:choose>
		<xsl:when test="contains($file,'/')">
			<xsl:call-template name="entity-to-filename">
				<xsl:with-param name="file" select="substring-after($file,'/')"/>
			</xsl:call-template>			
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$file"/>
		</xsl:otherwise>		
	</xsl:choose>
</xsl:template>

<xsl:template match="pagenumber">
	<pagenumber>
		<xsl:call-template name="provide-id"/>
		<xsl:apply-templates select="@*|node()"/>		
	</pagenumber>
</xsl:template>

<xsl:template match="im|mm">
	<xsl:element name="{name()}">
		<xsl:call-template name="provide-id"/>
		<xsl:if test="@entity">
			<xsl:attribute name="file">
				<xsl:call-template name="entity-to-filename"/>				
			</xsl:attribute>
		</xsl:if>
		<xsl:apply-templates select="@*|node()"/>		
	</xsl:element>
</xsl:template>

<!--xsl:template match="citation">
</xsl:template-->

<!--TODO: numbering -->
<xsl:template match="chapter|section|subsection|block|subblock|part">
	<xsl:variable name="name" select="name()"/>
	<xsl:element name="{$name}">
		<xsl:if test="not(@label) and not(@start)">
			<xsl:attribute name="start">
				<xsl:variable name="recent-start" select="preceding-sibling::*[name()=$name][@start][1]"/>
				<xsl:choose>
					<xsl:when test="$recent-start">
						<xsl:value-of select="$recent-start/@start+
						count(preceding-sibling::*[name()=$name])-count($recent-start/preceding-sibling::*[name()=$name])"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="count(preceding-sibling::*[name()=$name])+1"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
		</xsl:if>
		<xsl:apply-templates select="@*|node()"/>
	</xsl:element>
</xsl:template>

<xsl:template match="*">
	<xsl:copy>		
		<!--xsl:call-template name="provide-id"/-->		
		<xsl:apply-templates select="@*|node()"/>
	</xsl:copy>
</xsl:template>

<xsl:template match="@*|text()|comment()|processing-instruction()">
	<xsl:copy-of select="."/>
</xsl:template>

<!--
 Every element that may have a 'head' should have an id-attribute
 and pagebreaks in the head are moved in front of it.
-->
<!--
<xsl:template match="&head-parents;">
  <xsl:element name="{name()}">
    <xsl:attribute name="id">
      <xsl:value-of select="generate-id()"/>
    </xsl:attribute>
  </xsl:element>
</xsl:template>
-->

</xsl:stylesheet>