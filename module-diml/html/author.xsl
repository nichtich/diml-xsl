<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="author">
  <p class="author"><span class="vorgelegtText">vorgelegt von</span>
  <xsl:text> </xsl:text>
  <xsl:apply-templates select="given"/>
  <xsl:text> </xsl:text>
  <xsl:apply-templates select="surname"/>
  <br />
  <xsl:apply-templates select="suffix"/>
  </p>
</xsl:template>

<!-- Kopfzeile -->
<xsl:template match="author" mode="headline">
    <span class="headline-author">
      <xsl:apply-templates select="surname"/><xsl:text>, </xsl:text><xsl:apply-templates select="given"/><xsl:text>: </xsl:text>
    </span>
</xsl:template>

</xsl:stylesheet>


