<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="keywords">
  <p class="keywords">
     <span class="keywordsText">
       <xsl:variable name="keywordslang" select="@lang"/>
       <xsl:value-of select="$VOCABLES/keywords/@*[name()=$keywordslang]" /><xsl:text>: </xsl:text>
     </span>
     <xsl:text> </xsl:text>
     <xsl:apply-templates/>
  </p>
</xsl:template>

</xsl:stylesheet>

