<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="dmath">
<a>
 <xsl:call-template name="a-name-attribute"/>
 <table class="dmath" width="100%" border="0" cellspacing="0" cellpadding="0">
 <xsl:apply-templates select="caption" mode="centeredTable"/>
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
 <xsl:apply-templates select="legend" mode="centeredTable"/>
 </table>
</a> 
</xsl:template> 

</xsl:stylesheet>
