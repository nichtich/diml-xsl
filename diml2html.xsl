<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:cms="http://edoc.hu-berlin.de/diml/module/cms">

<xsl:param name="lang">
<xsl:choose>
  <xsl:when test="/etd/@lang"><xsl:value-of select="/etd/@lang" />
  </xsl:when>
  <xsl:when test="/cms:meta...">
  </xsl:when>
  <xsl:otherwise>de</xsl:otherwise>
</xsl:choose>
</xsl:param>

<xsl:param name="STYLEDIRECTORY">
  <xsl:choose>
    <xsl:when test="/processing-instruction('css-stylesheet')">
      <xsl:value-of select="/processing-instruction('css-stylesheet')"/>
    </xsl:when>
    <xsl:otherwise>/dissertationen/style/</xsl:otherwise>
  </xsl:choose>
</xsl:param>

<xsl:param name="LANGUAGE" select="de"/>

<xsl:param name="vorgelegtbeiText" select="'vorgelegt von'" />

<xsl:output method="html" encoding="ISO-8859-1"/>

<xsl:include href="module-diml/html.xsl"/>
<xsl:include href="module-media/html.xsl"/>
<xsl:include href="module-structure/html.xsl"/>
<xsl:include href="module-citation/html.xsl"/>
<xsl:include href="module-common/html.xsl"/>
<!--xsl:include href="module-mathematics/html.xsl"/-->
<xsl:include href="module-documents/html.xsl"/>
<!--xsl:include href="module-verse/html.xsl"/-->
<xsl:include href="module-CALStable/html.xsl"/>
<xsl:include href="module-lists/html.xsl"/>
<xsl:include href="module-text/html.xsl"/>
<xsl:include href="module-cms/html.xsl"/>

<xsl:key name="term" match="term" use="@id"/>
<xsl:key name="id" match="*[@id]" use="@id"/>

<!-- Ueberschrift eines Kapitels/Unterkapitels/... -->
<xsl:template match="frame|chapter|section|subsection|block|subblock|part" mode="head">
  <xsl:apply-templates select="head"/>
</xsl:template>

<xsl:template name="a-name-attribute">
	<xsl:param name="object" select="."/>
	<xsl:attribute name="name">
		<xsl:call-template name="object.id">
			<xsl:with-param name="object" select="$object"/>
		</xsl:call-template>
	</xsl:attribute>
</xsl:template>

<xsl:template name="a-href-attribute">
	<xsl:param name="object" select="."/>
	<xsl:attribute name="href">
		<xsl:text>#</xsl:text>
		<xsl:call-template name="object.id">
			<xsl:with-param name="object" select="$object"/>
		</xsl:call-template>
	</xsl:attribute>
</xsl:template>

<!-- Taucht genauso bei module-common\html\head.xsl auf -->

<!-- <head> -->
<xsl:template match="*" mode="html-head"/>

<!-- Debugging -->
<xsl:template match="*">
  <font color="#FF0000">
    <xsl:text>&lt;</xsl:text>
    <xsl:value-of select="name(.)"/>
    <xsl:text>&gt;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&lt;/</xsl:text>
    <xsl:value-of select="name(.)"/>
    <xsl:text>&gt;</xsl:text>    
  </font>
</xsl:template>

</xsl:stylesheet>

