<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="blockquote">


 <table class="blockquote" width="100%" border="0" cellspacing="0" cellpadding="0">
    <xsl:apply-templates select="caption" mode="blockquotecaption"/>
 <tr>
 <td width="15%"></td>
 <td width="70%" class="blockquotebody">
    <xsl:apply-templates select="*[not(self::caption or self::citation)]" />
 </td>
 <td width="15%"></td>
 </tr>
     <xsl:apply-templates select="citation" mode="blockquotecitation"/>
 </table>  

</xsl:template>

</xsl:stylesheet>

