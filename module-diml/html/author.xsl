<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- wenn der erste Knoten ein Textknoten ist und nur aus Leerzeichen -->
<!-- besteht oder wenn der erste Knoten kein Textknoten ist, dann     -->
<!-- Ausgabe von "vorgelegt von"                                      -->
<xsl:template match="author">
  <p class="author">
  <xsl:if test="(node()[1][self::text()] and normalize-space(node()[1])='') or not(node()[1][self::text()])">
    <span class="vorgelegtText">vorgelegt von</span>
  </xsl:if>
  <xsl:for-each select="node()">
    <xsl:choose>
      <xsl:when test="name()='suffix'">
        <br />
      </xsl:when>
      <xsl:otherwise>
        <xsl:text> </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates select="." />
  </xsl:for-each>
  </p>
</xsl:template>

<!-- Kopfzeile -->
<xsl:template match="author" mode="headline">
    <span class="headline-author">
      <xsl:apply-templates select="surname"/><xsl:text>, </xsl:text><xsl:apply-templates select="given"/><xsl:text>: </xsl:text>
    </span>
</xsl:template>

</xsl:stylesheet>


