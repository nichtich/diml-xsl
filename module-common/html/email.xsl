<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="email">
  <a href="mailto:{string.}">
    <xsl:apply-templates/>
  </a>
</xsl:template>

</xsl:stylesheet>
