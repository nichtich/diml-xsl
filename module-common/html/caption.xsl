<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="caption">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="caption" mode="TableOfContents">
    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template match="caption" mode="mmcaption">
    <tr>
      <td width="15%"></td>
      <td width="70%" class="caption">
         <xsl:apply-templates/>
      </td>
    <td width="15%"></td>
    </tr>
  </xsl:template>

  <xsl:template match="caption" mode="tablecaption">
    <tr>
      <td class="caption">
         <xsl:apply-templates/>
      </td>
    </tr>
  </xsl:template>



</xsl:stylesheet>

