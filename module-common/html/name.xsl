<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="name">
  <span class="name">
    <xsl:apply-templates/>
  </span>
</xsl:template>

<xsl:template match="given|surname|suffix|organization">
  <xsl:apply-templates/>
  <!--
  <xsl:if test="following-sibling::* and generate-id(following-sibling::node()[1])!=generate-id(following-sibling::text()[1])">
    <xsl:text>&#xA0;</xsl:text>
  </xsl:if>
  -->
</xsl:template>

<xsl:template match="name" mode="namensListe">
  <span class="name">
  <xsl:choose>
     <xsl:when test="count(preceding-sibling::name)+1!=count(../child::name)">
        <xsl:number level="single" format="1. " />
        <xsl:value-of select="." /><br />
     </xsl:when>
     <xsl:otherwise>
        <xsl:number level="single" format="1. " />
        <xsl:value-of select="." />
     </xsl:otherwise>
  </xsl:choose>   
  </span>  
</xsl:template>


</xsl:stylesheet>



