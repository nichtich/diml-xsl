<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:src="http://nwalsh.com/xmlns/litprog/fragment" exclude-result-prefixes="src" version="1.0">

  <xsl:template match="legend">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="legend" mode="mmlegend">
    <xsl:apply-templates select="." mode="centeredTable" />
  </xsl:template>

  <xsl:template match="legend" mode="tablelegend">
    <xsl:apply-templates select="." mode="centeredTable" />
  </xsl:template>

  <xsl:template match="legend" mode="centeredTable">
   <tr>
   <td width="15%"></td>
   <td width="70%" class="legend">
      <!--a>
        <xsl:call-template name="a-name-attribute"/>
        <xsl:apply-templates/>
      </a-->
      <xsl:apply-templates/>
   </td>
   <td width="15%"></td>
   </tr>
  </xsl:template>

</xsl:stylesheet>
