<?xml version="1.0" encoding="ISO-8859-1"?>
<!-- sh Änderung, wenn pt Größe für Bilder berücksichtigt werden soll xsl:template match="mm" name="mm-inline" mode="inline" -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
<xsl:template name="extractMediaFileName">
   <xsl:param name="fileNameWithPath"/>
   <xsl:choose>
      <xsl:when test="contains($fileNameWithPath, '/')">
         <xsl:call-template name="extractMediaFileName">
            <xsl:with-param name="fileNameWithPath" select="substring-after($fileNameWithPath, '/')"/>
         </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
         <xsl:value-of select="$fileNameWithPath"/>
      </xsl:otherwise>
   </xsl:choose>
</xsl:template>
	
<xsl:template name="MEDIA-URL">
   <xsl:param name="object"/>
   <xsl:call-template name="extractMediaFileName">
      <xsl:with-param name="fileNameWithPath" select="unparsed-entity-uri($object)"/>
   </xsl:call-template>
</xsl:template>


<xsl:template match="mm" name="mm">
   <a>
      <xsl:call-template name="a-name-attribute"/>
      <xsl:choose>
         <xsl:when test="caption or legend">
            <xsl:apply-templates select="." mode="mm_with_caption_or_legend"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates select="." mode="mm_without_caption_and_legend"/>
         </xsl:otherwise>
      </xsl:choose>
   </a>
</xsl:template>

<xsl:template match="mm" mode="mm_with_caption_or_legend">
   <table class="mm" width="100%" border="0" cellspacing="0" cellpadding="0">
      <xsl:apply-templates select="caption" mode="mmcaption"/>
         <tr>
            <td width="15%"/>
            <td width="70%">
               <!-- Image of mm starts here -->
               <p class="mmimg">
                       <xsl:call-template name="mm-inline"/>
               </p>
            </td>
            <td width="15%"/>
         </tr>
      <xsl:apply-templates select="legend" mode="mmlegend"/>
   </table>
</xsl:template>

<xsl:template match="mm" mode="mm_without_caption_and_legend">
   <xsl:call-template name="mm-inline"/>
</xsl:template>

   <xsl:template match="mm" name="mm-inline" mode="inline">
      
      <a href="{@file}" target="_blank"><img>
         <xsl:attribute name="border">0</xsl:attribute>
         <xsl:attribute name="src">
            <xsl:choose>
               <xsl:when test="@file">
                  <xsl:value-of select="@file"/>
               </xsl:when>
               <xsl:when test="@entity">
                  <xsl:call-template name="MEDIA-URL">
                     <xsl:with-param name="object" select="@entity|@file"/>
                  </xsl:call-template>
               </xsl:when>
               <xsl:otherwise>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:attribute>
         <xsl:if test="@label">
            <xsl:attribute name="width">
               <xsl:value-of select="(substring-before(@label,'#'))"/>
            </xsl:attribute>
            <xsl:attribute name="height">
               <xsl:value-of select="(substring-after(@label,'#'))"/>
            </xsl:attribute>
         </xsl:if>
         <xsl:if test="alt">
            <xsl:attribute name="alt">
               <xsl:value-of select="alt[1]"/>
            </xsl:attribute>
         </xsl:if>
         <xsl:if test="caption">
            <xsl:attribute name="title">
               <xsl:value-of select="caption[1]"/>
            </xsl:attribute>
         </xsl:if>
      </img></a>
   </xsl:template>
	
</xsl:stylesheet>
