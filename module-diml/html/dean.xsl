<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- do print "Dekan:" now -->
<xsl:template match="dean">
  <p class="dean"><span class="deanText"><xsl:value-of select="$VOCABLES/dean/@*[name()=$LANG]" /><xsl:text>:</xsl:text></span><xsl:text> </xsl:text><xsl:apply-templates/></p>
</xsl:template>

</xsl:stylesheet>

