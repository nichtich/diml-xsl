<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="sub">
  <sub>
     <xsl:if test="@class">
        <xsl:attribute name="class">
           <xsl:value-of select="@class"/>
        </xsl:attribute>
     </xsl:if>
    <xsl:apply-templates/>
  </sub>
</xsl:template>

</xsl:stylesheet>

