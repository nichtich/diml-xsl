<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="chapter|section|subsection|block|subblock|part">
  <xsl:apply-templates select="*[1][name()='pagenumber']"/>
  <xsl:variable name="elementname">
    <xsl:choose>
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
  <xsl:apply-templates select="*[name()!='head'][not(position()=1 and name()='pagenumber')]"/>
</xsl:template>

</xsl:stylesheet>