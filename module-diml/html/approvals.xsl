<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="approvals">
  <p class="approvals">
  <span class="gutachterText">Gutachter: </span><br />
  <xsl:apply-templates select="name" mode="namensListe" /></p>
</xsl:template>

</xsl:stylesheet>

