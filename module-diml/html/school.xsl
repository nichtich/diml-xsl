<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


<xsl:template match="school">

  <xsl:apply-templates select="*[(self::p)]">
     <xsl:with-param name="cssTemplate" select="'school'" />
  </xsl:apply-templates>
  <xsl:apply-templates select="*[not(self::p)]"/>

</xsl:template>



</xsl:stylesheet>

