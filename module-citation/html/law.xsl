<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="citation/law">
  <span class="law">
    <xsl:apply-templates/>
  </span>  
</xsl:template>

</xsl:stylesheet>

