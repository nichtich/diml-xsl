<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="url" name="element-url">
  <xsl:param name="href" select="@href"/>
  <xsl:param name="type" select="@type"/>
  <xsl:call-template name="before-url"/>

  <xsl:choose>
    <xsl:when test="@type!='URL'">
      <xsl:value-of select="$href"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
         <xsl:when test="*|text()">
            <a class="url" href="{$href}">
               <xsl:apply-templates/>
            </a>    
         </xsl:when>
         <xsl:otherwise>
            <a class="url" href="{$href}">
              <xsl:value-of select="$href"/>
            </a>    
         </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>    

</xsl:template>

<xsl:template name="before-url"/> <!-- z.B. fuer icons -->

</xsl:stylesheet>


<!-- old version:

  <xsl:choose>
    <xsl:when test="@type!='URL'">
      <xsl:if test="@type and @type!='text'">
        <xsl:value-of select="@type"/>
        <xsl:text>&#xA0;</xsl:text>
      </xsl:if>      
      <xsl:value-of select="$href"/>
    </xsl:when>
    <xsl:when test="*|text()">
      <a class="url" href="{$href}">
        <xsl:apply-templates/>
      </a>
    </xsl:when>
    <xsl:otherwise>
      <a class="url" href="{$href}">
        <xsl:value-of select="$href"/>
      </a>    
    </xsl:otherwise>
  </xsl:choose>    

-->
