<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="back">
  <!--xsl:apply-templates select="head"/-->
  <xsl:if test="//footnote">
    <hr/>
    <h3>Fu&#xDF;noten</h3>
    <xsl:apply-templates select="//footnote" mode="foot"/>
  </xsl:if>  
  <hr/>
  <xsl:apply-templates/>
</xsl:template>

</xsl:stylesheet>
