<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="back">
  <!--xsl:apply-templates select="head"/-->
  <xsl:if test="//footnote">
    <hr/>
    <h3 class="footnoteheader"><xsl:value-of select="$VOCABLES/footnotesandendnotes/@*[name()=$LANG]" /></h3>
    <xsl:apply-templates select="//footnote|//endnote" mode="foot"/>
  </xsl:if>
  <hr/>
  <xsl:apply-templates/>
</xsl:template>

</xsl:stylesheet>