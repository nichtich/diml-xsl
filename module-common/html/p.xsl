<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="p">

  <!-- als Parameter kann eine Wert fr das class-Attribut mitgegebnen werden -->
  <xsl:param name="cssTemplate"/>
  
  <!-- wenn erste Seitenzahl im Absatz ohne vorhergehenden Textknoten: -->
  <!-- Seitenzahl wird mit Trennstrich ausgegeben -->
  <xsl:apply-templates
  	select="pagenumber[1][count(preceding-sibling::*)=0][normalize-space(preceding-sibling::text())='']" mode="hline"/>

  <xsl:element name="p">
     <xsl:if test="$cssTemplate!=''">
        <xsl:attribute name="class">
           <xsl:value-of select="$cssTemplate"/>
        </xsl:attribute>
     </xsl:if>   
     <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

</xsl:stylesheet>
