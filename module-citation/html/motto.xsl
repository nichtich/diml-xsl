<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--== quotation ==-->
<xsl:template match="motto">
  <!-- pagenumber is not allowed in "motto" anyway -->
  <xsl:apply-templates select="pagenumber"/>
  <xsl:for-each select="p">
    <p><i>
      <xsl:apply-templates/>
    </i></p>
  </xsl:for-each>
  <!-- TODO: a lot -->
  <xsl:apply-templates select="citation"/>
</xsl:template>

<xsl:template match="motto/citation" name="element-motto">
  <p>
    (<xsl:apply-templates/>)    
  </p>
</xsl:template>

</xsl:stylesheet>

