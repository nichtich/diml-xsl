<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--== quotation ==-->
<xsl:variable name="QUOTATION_MARKS">en</xsl:variable>

<xsl:template match="q" name="element-q">
  <xsl:param name="lang" select="@lang"/>
  <xsl:param name="type" select="@type"/>
  
  <!-- TODO: q innerhalb von q -->
  <!-- TODO: @citation -->
  <xsl:variable name="use-type">
    <xsl:choose>
      <xsl:when test="$lang">
        <xsl:value-of select="$lang"/>
      </xsl:when>
      <xsl:when test="$type='literal'">
        <xsl:text>en-single</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$QUOTATION_MARKS"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <xsl:choose>
    <xsl:when test="$use-type='en-single'">&#8216;<xsl:apply-templates/>&#8217;</xsl:when> <!-- single quotation marks -->
    <xsl:when test="$use-type='fr'">&#xAB;<xsl:apply-templates/>&#xBB;</xsl:when>
    <xsl:when test="$use-type='de-fr'">&#xBB;<xsl:apply-templates/>&#xAB;</xsl:when>
    <xsl:when test="$use-type='de'">&#8222;<xsl:apply-templates/>&#8220;</xsl:when>
    <!--xsl:when test="$type='de'">&#8218;<xsl:apply-templates/>&#8216;</xsl:when--> <!-- einfache Anfuehrungszeichen -->
    <xsl:when test="$use-type='en'">&#8220;<xsl:apply-templates/>&#8221;</xsl:when> <!-- double quotation marks -->
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
