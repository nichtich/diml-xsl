<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- Definition of example: -->
<!-- <!ELEMENT example (head? , (p | example | pagenumber)+)> -->

<xsl:template match="example">
  <xsl:if test="head">
    <p class="examplehead">
      <xsl:apply-templates select="head"/>
    </p>  
  </xsl:if>  
  
  <xsl:apply-templates select="*[name()!='head']">
    <xsl:with-param name="cssTemplate" select="example" />
  </xsl:apply-templates>  
  
</xsl:template>

</xsl:stylesheet>



