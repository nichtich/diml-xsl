<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="bibliography" name="element-bibliography">
  
  <xsl:apply-templates select="head/pagenumber" mode="hline"/>
    <h3 class="bibliography">
      <a>
        <xsl:call-template name="a-name-attribute"/>
        <xsl:apply-templates select="." mode="head"/>
      </a>
    </h3>
  <xsl:apply-templates select="*[not(self::head)]" />

</xsl:template>

<xsl:template match="bibliography" mode="head" name="bibliography-head">
  <xsl:choose>
    <xsl:when test="head and not(normalize-space(head)='')">
      <xsl:apply-templates select="head"/>
    </xsl:when>
    <xsl:otherwise>
       <xsl:value-of select="$VOCABLES/bibliography/@*[name()=$LANG]" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>

<!--                                                        -->
<!--    Old Version with additional "p" for "citation"      -->
<!--                                                        -->

<!--
<xsl:template match="bibliography" name="element-bibliography">
  <xsl:apply-templates select="head/pagenumber" mode="hline"/>
  <h3 class="bibliography">
    <xsl:apply-templates select="." mode="head"/>
  </h3>
  <xsl:for-each select="*[name()!='head']">
    <xsl:choose>
      <xsl:when test="name(.)='citation'">
        <xsl:apply-templates select="."/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
</xsl:template>
-->
