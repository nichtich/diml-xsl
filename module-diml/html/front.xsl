<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- front -->
<xsl:template match="front">
  <xsl:apply-templates select="school"/>
  <xsl:apply-templates select="title"/>
  <xsl:apply-templates select="submission"/>
  <xsl:apply-templates select="degree"/>
  <xsl:apply-templates select="major"/>
  <xsl:apply-templates select="author"/>
  <xsl:apply-templates select="dean"/>  
  <xsl:apply-templates select="approvals"/>
  <xsl:apply-templates select="date"/>
  <xsl:apply-templates select="grant"/>
  <xsl:apply-templates select="dedication"/>
  <xsl:apply-templates select="copyright"/>
  <xsl:apply-templates select="motto"/>
  <xsl:apply-templates select="*[not(self::school or self::title or self::submission or self::degree or self::major or self::author or self::dean or self::approvals or self::date or self::grant or self::dedication or self::copyright or self::motto)]" />
  <hr/>
</xsl:template>


<!-- front -->
<xsl:template match="front" mode="html-head">
  <xsl:apply-templates mode="html-head"/>
</xsl:template>

</xsl:stylesheet>

