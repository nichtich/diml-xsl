<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:src="http://nwalsh.com/xmlns/litprog/fragment" 
exclude-result-prefixes="src" version="1.0">


   <!-- momentan nur plaintext-notationen von formeln ausgeben-->
<!--   <xsl:template match="alt[not(@notation) or @notation='plaintext']">-->
<!--      <xsl:apply-templates /> -->
<!--   </xsl:template>-->

   
<xsl:template match="alt[@notation='plaintext']">
   <xsl:apply-templates />
</xsl:template>

<xsl:template match="alt">
</xsl:template>


</xsl:stylesheet>
