<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="chapter|section|subsection|block|subblock|part|frame">
  <xsl:apply-templates select="head/pagenumber" mode="hline"/>
  <xsl:variable name="elementname">
    <xsl:choose>
      <xsl:when test="name()='frame'">h1</xsl:when>
      <xsl:when test="name()='chapter'">h1</xsl:when>
      <xsl:when test="name()='section'">h2</xsl:when>
      <xsl:when test="name()='subsection'">h3</xsl:when>
      <xsl:when test="name()='block'">h4</xsl:when>
      <xsl:when test="name()='subblock'">h4</xsl:when>
      <xsl:when test="name()='part'">h4</xsl:when>
    </xsl:choose>
  </xsl:variable>  
  <a>
    <xsl:call-template name="a-name-attribute"/>
    <xsl:element name="{$elementname}">
      <xsl:attribute name="class">
        <xsl:value-of select="name()"/>
      </xsl:attribute>
      <xsl:choose>
	 	<xsl:when test="head"><xsl:apply-templates select="." mode="head"/></xsl:when>
	 	<xsl:otherwise><xsl:apply-templates select="default-head"/></xsl:otherwise>
	 </xsl:choose>
    </xsl:element>
  </a>
  <xsl:apply-templates select="*[name()!='head']"/>
</xsl:template>

<xsl:template match="chapter|section|subsection|block|subblock|part|frame" mode="default-head">
  <xsl:choose>
      <xsl:when test="name()='frame'">Teil</xsl:when>
      <xsl:when test="name()='chapter'">Kapitel</xsl:when>
      <xsl:when test="name()='section'">Abschnitt</xsl:when>
      <xsl:when test="name()='subsection'">Unterabschnitt</xsl:when>
      <xsl:when test="name()='block'"></xsl:when>
      <xsl:when test="name()='subblock'"></xsl:when>
      <xsl:when test="name()='part'"></xsl:when>
    </xsl:choose>	
</xsl:template>

</xsl:stylesheet>