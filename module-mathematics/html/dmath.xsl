<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="dmath">
 <table class="dmath" width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr>
 <td width="15%"></td>
 <td width="70%">
  <!-- Caption of dmath starts here -->
  <p class="dmathcaption">
    <a>
      <xsl:call-template name="a-name-attribute"/>
      <xsl:apply-templates select="caption"/>
    </a>
  </p>  
 </td>
 <td width="15%"></td>
 </tr>
 <tr>
 <td width="15%"></td>
 <td width="70%">
  <!-- Formula of dmath starts here -->
  <p class="dmathimath">
    <xsl:apply-templates select="imath"/>
  </p>
 </td>
 <td width="15%"></td>
 </tr>
 <tr>
 <td width="15%"></td>
 <td width="70%">
  <!-- Legend of dmath starts here -->
  <p class="dmathlegend">
    <a>
      <xsl:call-template name="a-name-attribute"/>
      <xsl:apply-templates select="legend"/>
    </a>
  </p>  
 </td>
 <td width="15%"></td>
 </tr>
 </table>
</xsl:template>

</xsl:stylesheet>
