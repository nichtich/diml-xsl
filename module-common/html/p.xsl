<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--xsl:template match="p[not(text()) and count(*)=1 and (name(*)='ol' or name(*)='ul' or name(*)='dl')]">
  <xsl:apply-templates/>
</xsl:template-->

<xsl:template match="p">
  <p>
    <xsl:apply-templates/>
  </p>
</xsl:template>

</xsl:stylesheet>
