<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- glossflag -->
<xsl:template match="glossflag">
  <a href="#{@ref}">
    <xsl:choose>
      <xsl:when test="not(*|text())">
        <xsl:apply-templates select="/etd/back/glossary/dl/def/term[@id=current()/@ref]"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>        
      </xsl:otherwise>
    </xsl:choose>
  </a>
</xsl:template>

</xsl:stylesheet>
