<?xml version="1.0" encoding="ISO-8859-1"?>
<!-- LIBRARY OF COMMON TEMPLATES AND FUNCTIONS -->
<xsl:stylesheet version="1.0"
 	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:cms="http://edoc.hu-berlin.de/diml/module/cms">

<xsl:template name="number">
	<xsl:param name="number"/>
	<xsl:param name="numbering"/>
	<xsl:choose>
		<xsl:when test="$numbering='arabic'">
			<xsl:number value="$number" format="1"/>
		</xsl:when>
		<xsl:when test="$numbering='lalpha'">
			<xsl:number value="$number" format="a"/>
		</xsl:when>
		<xsl:when test="$numbering='ualpha'">
			<xsl:number value="$number" format="A"/>
		</xsl:when>
		<xsl:when test="$numbering='lroman'">
			<xsl:number value="$number" format="i"/>
		</xsl:when>
		<xsl:when test="$numbering='uroman'">
			<xsl:number value="$number" format="I"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$number"/>
		</xsl:otherwise>	
	</xsl:choose>	
</xsl:template>

<!-- Numbering Label of chapter, frame, section... -->
<xsl:template match="*" mode="numberingLabel">
	<xsl:variable name="name" select="name()"/>
	<xsl:variable name="generate" select="$CONFIG/generate[@of=$name][@numbering][1]"/>
	
	<xsl:if test="not(@label) and $generate">			
		<xsl:if test="$generate/@elementBefore">
			<xsl:apply-templates select="parent::*[name()=$CONFIG/generate[@of=$name][@numbering]/@elementBefore]" mode="numberingLabel"/>
		</xsl:if>
		<xsl:variable name="recent-start" select="preceding-sibling::*[name()=$name][@start][1]"/>		
		<xsl:value-of select="$generate/@before"/>
		<xsl:call-template name="number">
			<xsl:with-param name="number">
				<xsl:choose>
					<xsl:when test="$recent-start">
						<xsl:value-of select="$recent-start/@start +
						count(preceding-sibling::*[name()=$name]) - count($recent-start/preceding-sibling::*[name()=$name])"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="count(preceding-sibling::*[name()=$name])+1"/>
					</xsl:otherwise>
				</xsl:choose>			
			</xsl:with-param>
			<xsl:with-param name="numbering">
				<xsl:value-of select="$generate/@numbering"/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:value-of select="$generate/@after"/>
	</xsl:if>
</xsl:template>


	
</xsl:stylesheet>