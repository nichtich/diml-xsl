<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:param name="strong-color" select="''"/>

<xsl:template match="strong">
  <b>
    <xsl:if test="@color">
      <!-- ... -->
    </xsl:if>
    <xsl:apply-templates/>
  </b>
</xsl:template>

</xsl:stylesheet>
