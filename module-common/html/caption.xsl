<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="caption">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="caption" mode="table-of-figures">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="caption" mode="table-of-tables">
   <xsl:apply-templates/>
</xsl:template>

</xsl:stylesheet>

