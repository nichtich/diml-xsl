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
  <xsl:element name="{$elementname}">
    <xsl:attribute name="class">
      <xsl:value-of select="name()"/>
    </xsl:attribute>
    <a name="#{generate-id(.)}">
      <xsl:apply-templates select="." mode="head"/>
    </a>      
  </xsl:element>
  <xsl:apply-templates select="*[name()!='head']"/>
</xsl:template>

<xsl:template match="frame" mode="table-of-contents">
  <xsl:param name="toc-depth">0</xsl:param>
  <xsl:call-template name="toc-entry">
    <xsl:with-param name="toc-depth" select="$toc-depth"/>
    <xsl:with-param name="subelements" select="part|chapter"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="chapter" mode="table-of-contents">
  <xsl:param name="toc-depth">0</xsl:param>
  <xsl:call-template name="toc-entry">
    <xsl:with-param name="toc-depth" select="$toc-depth"/>
    <xsl:with-param name="subelements" select="section"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="section" mode="table-of-contents">
  <xsl:param name="toc-depth">0</xsl:param>
  <xsl:call-template name="toc-entry">
    <xsl:with-param name="toc-depth" select="$toc-depth"/>
    <xsl:with-param name="subelements" select="subsection"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="subsection" mode="table-of-contents">
  <xsl:param name="toc-depth">0</xsl:param>
  <xsl:call-template name="toc-entry">
    <xsl:with-param name="toc-depth" select="$toc-depth"/>
    <xsl:with-param name="subelements" select="block"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="block" mode="table-of-contents">
  <xsl:param name="toc-depth">0</xsl:param>
  <xsl:call-template name="toc-entry">
    <xsl:with-param name="toc-depth" select="$toc-depth"/>
    <xsl:with-param name="subelements" select="subblock"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="subblock|part|resources" mode="table-of-contents">
  <xsl:param name="toc-depth">0</xsl:param>
  <xsl:call-template name="toc-entry">
    <xsl:with-param name="toc-depth" select="$toc-depth"/>
    <xsl:with-param name="subelements" select="part"/>
  </xsl:call-template>
</xsl:template>

</xsl:stylesheet>