<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:variable name="LANGUAGES" select="document('languages.xml')/languages/language"/>

<xsl:template name="getLanguageLong">
  <xsl:param name="lang" select="@lang"/>
  <xsl:param name="destinationLanguage" select="'en'"/>  
  <xsl:variable name="long" select="$LANGUAGES[@id=$lang]/long[@lang=$destinationLanguage]"/>  
  <xsl:if test="not($long)">
    <xsl:message terminate="yes">
      language <xsl:value-of select="@lang"/> not available in
      language <xsl:value-of select="$destinationLanguage"/>!
    </xsl:message>
  </xsl:if>    
  <xsl:value-of select="$long"/>
</xsl:template>

<xsl:template name="getLanguageAbbrev">
  <xsl:param name="lang" select="@lang"/>
  <xsl:param name="destinationLanguage" select="'en'"/>  
  <xsl:variable name="abbrev" select="$LANGUAGES[@id=$lang]/abbrev[@lang=$destinationLanguage]"/>  
  <!--xsl:message terminate="no">
    LANGUAGES=<xsl:value-of select="count($LANGUAGES)"/>
    und zwar <xsl:value-of select="$lang"/>:
    <xsl:value-of select="$LANGUAGES[@id=$lang]/@id"/>
    (<xsl:for-each select="$LANGUAGES">
      <xsl:value-of select="name(.)"/>[@id=<xsl:value-of select="@id"/>]
    </xsl:for-each>)
  </xsl:message-->  
  <xsl:if test="not($abbrev)">
    <xsl:message terminate="yes">
      language <xsl:value-of select="@lang"/> not available in
      language <xsl:value-of select="$destinationLanguage"/>!
    </xsl:message>
  </xsl:if>    
  <xsl:value-of select="$abbrev"/>
</xsl:template>


<xsl:template match="foreign" name="element-foreign">
  <xsl:param name="node" select="node()"/>  
  <i>
    <xsl:apply-templates select="$node"/>
  </i>
</xsl:template>

</xsl:stylesheet>
