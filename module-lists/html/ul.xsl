<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="ul">
  <xsl:apply-templates select="caption"/>
  <ul>
    <xsl:apply-templates select="li"/>
  </ul>
</xsl:template>

</xsl:stylesheet>
