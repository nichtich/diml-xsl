<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:param name="PAGENUMBER-LABEL"></xsl:param> <!-- 'Seite: ' -->

<xsl:template match="head/pagenumber"/>

<xsl:template match="pagenumber[not(preceding-sibling::node())]" mode="hline">
  <table width="100%" border="0">
    <tr>
      <td width="100%"><hr/></td>
      <td><xsl:call-template name="pagenumber-simple"/></td>
    </tr>  
  </table>
</xsl:template>

<!-- @start ist nur eine tempor„re ausgabe -->
<xsl:template match="pagenumber" name="pagenumber-simple">
  <span class="pagenumber">[<xsl:value-of select="$PAGENUMBER-LABEL"/><xsl:value-of select="@system"/><xsl:value-of select="@start"/>]</span>
</xsl:template>

</xsl:stylesheet>

