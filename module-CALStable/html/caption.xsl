<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:src="http://nwalsh.com/xmlns/litprog/fragment" exclude-result-prefixes="src" version="1.0">

   <xsl:template match="caption" mode="tablecaption">
   
     <caption class="tablecaption"><xsl:apply-templates/></caption>
     
   </xsl:template>

</xsl:stylesheet>