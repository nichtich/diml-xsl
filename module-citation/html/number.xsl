<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="citation/number">
  <span class="number">
    <xsl:apply-templates/>
  </span>  
</xsl:template>

</xsl:stylesheet>
