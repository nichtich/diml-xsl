<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:param name="em-style" select="italic"/>
<xsl:param name="em-color" select="''"/>

<xsl:template match="em" name="element-em">
  <em>
    <xsl:if test="@color">
      <!-- ... -->
    </xsl:if>
    <xsl:apply-templates/>
  </em>
</xsl:template>

</xsl:stylesheet>
