<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cms="http://edoc.hu-berlin.de/diml/module/cms"
exclude-result-prefixes="cms">

<xsl:param name="NUMBERING">1</xsl:param>

<xsl:key name="id" match="*" use="@id"/>

<xsl:template name="provide-id">
	<xsl:param name="suggest"/>
	<xsl:if test="not(@id)">
		<xsl:attribute name="id">
			<xsl:choose>
				<xsl:when test="$suggest!='' and key('id',$suggest)">
					<xsl:value-of select="generate-id()"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$suggest"/>
				</xsl:otherwise>
			</xsl:choose>
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

<xsl:template match="pagenumber">
	<pagenumber>
		<xsl:call-template name="provide-id"/>
		<xsl:attribute name="label">
		<xsl:choose>
			<xsl:when test="@label"><xsl:copy-of select="@label"/></xsl:when> <!-- ok -->
			<xsl:when test="not(@label) and @start">
				<xsl:call-template name="number">
					<xsl:with-param name="number" select="@start"/>
					<xsl:with-param name="numbering" select="@numbering"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:message>
					pagenumber without label/start!
				</xsl:message>
				<!--xsl:call-template name="number">
					<xsl:with-param name="number" select="count(preceding@start"/>
					<xsl:with-param name="numbering" select="@numbering"/>
				</xsl:call-template-->				
			</xsl:otherwise>
		</xsl:choose>
		</xsl:attribute>
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

<!--TODO: numbering types -->
<xsl:template name="numbering">
	<xsl:variable name="name" select="name()"/>
	<xsl:if test="not(@label)">
		<xsl:attribute name="label">
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
</xsl:template>

<xsl:template match="section|subsection|block|subblock|part">
	<xsl:copy>
		<xsl:call-template name="provide-id"/>
		<xsl:call-template name="numbering"/>
		<xsl:apply-templates select="@*|node()"/>
	</xsl:copy>
</xsl:template>

<xsl:template match="chapter|frame">
	<xsl:variable name="name" select="name()"/>
	<xsl:copy>
		<xsl:call-template name="provide-id">
			<xsl:with-param name="suggest">
				<xsl:value-of select="name()"/>
				<xsl:value-of select="count(preceding-sibling::*[name()=$name]) + 1"/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="numbering"/>
		<xsl:apply-templates select="@*|node()"/>
	</xsl:copy>
</xsl:template>


<xsl:template match="table|im|example|frame">
	<xsl:copy>		
		<xsl:call-template name="provide-id"/>		
		<xsl:apply-templates select="@*|node()"/>
	</xsl:copy>
</xsl:template>

<xsl:template match="front | body/* | back/*">
	<xsl:copy>		
		<xsl:variable name="name" select="name()"/>
		<xsl:call-template name="provide-id">
			<xsl:with-param name="suggest">
				<xsl:value-of select="name()"/>
				<xsl:value-of select="count(preceding-sibling::*[name()=$name]) + 1"/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:apply-templates select="@*|node()"/>	
	</xsl:copy>		
</xsl:template>

<!-- copy the rest -->
<xsl:template match="*">
	<xsl:copy>		
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