<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- see module-documents/html.xsl for matching this element --> 

<!-- (pagenumber is handled in module-documents\html.xsl) -->
<xsl:template match="vita" mode="head">
  <xsl:choose>
    <xsl:when test="head and not(normalize-space(head)='')">
      <xsl:apply-templates select="head"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$VOCABLES/vita/@*[name()=$LANG]" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
