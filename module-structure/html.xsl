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
        <xsl:when test="head and not(normalize-space(head)='')"><xsl:apply-templates select="." mode="head"/></xsl:when>
        <xsl:otherwise><xsl:apply-templates select="default-head"/></xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </a>
  <xsl:apply-templates select="*[name()!='head']"/>
</xsl:template>

<xsl:template match="chapter|section|subsection|block|subblock|part|frame" mode="default-head">
  <xsl:choose>
      <xsl:when test="name()='frame'"><xsl:value-of select="$VOCABLES/frame/@*[name()=$LANG]" /></xsl:when>
      <xsl:when test="name()='chapter'"><xsl:value-of select="$VOCABLES/chapter/@*[name()=$LANG]" /></xsl:when>
      <xsl:when test="name()='section'"><xsl:value-of select="$VOCABLES/section/@*[name()=$LANG]" /></xsl:when>
      <xsl:when test="name()='subsection'"><xsl:value-of select="$VOCABLES/subsection/@*[name()=$LANG]" /></xsl:when>
      <xsl:when test="name()='block'"><xsl:value-of select="$VOCABLES/block/@*[name()=$LANG]" /></xsl:when>
      <xsl:when test="name()='subblock'"><xsl:value-of select="$VOCABLES/subblock/@*[name()=$LANG]" /></xsl:when>
      <xsl:when test="name()='part'"><xsl:value-of select="$VOCABLES/part/@*[name()=$LANG]" /></xsl:when>
    </xsl:choose>	
</xsl:template>

</xsl:stylesheet>