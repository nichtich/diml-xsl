<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template name="extractMediaFileName">
  <xsl:param name="fileNameWithPath" />
  <xsl:choose>
    <xsl:when test="contains($fileNameWithPath, '/')">
      <xsl:call-template name="extractMediaFileName">
        <xsl:with-param name="fileNameWithPath" select="substring-after($fileNameWithPath, '/')" />
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$fileNameWithPath" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="MEDIA-URL">
  <xsl:param name="object"/>
  <xsl:call-template name="extractMediaFileName">
    <xsl:with-param name="fileNameWithPath" select="unparsed-entity-uri($object)" />
  </xsl:call-template>
</xsl:template>

<xsl:template match="mm" name="mm">
<a>
 <xsl:call-template name="a-name-attribute"/>
 <table class="mm" width="100%" border="0" cellspacing="0" cellpadding="0">
 <xsl:apply-templates select="caption" mode="mmcaption"/>
 <tr>
 <td width="15%"></td>
 <td width="70%">
  <!-- Image of mm starts here -->
  <p class="mmimg">
    <img>
      <xsl:attribute name="src">
        <xsl:choose>
          <xsl:when test="@file">
            <xsl:value-of select="@file" />
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
      <xsl:if test="alt">
        <xsl:attribute name="alt">
            <xsl:value-of select="alt"/>
        </xsl:attribute>
      </xsl:if>
    </img>
  </p>
 </td>
 <td width="15%"></td>
 </tr>
 <xsl:apply-templates select="legend" mode="mmlegend"/>
 </table>  
</a>
</xsl:template>

<xsl:template match="mm" name="mm-inline" mode="inline">
    <img>
      <xsl:attribute name="src">
        <xsl:choose>
          <xsl:when test="@file">
            <xsl:value-of select="@file" />
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
      <xsl:if test="alt">
        <xsl:attribute name="alt">
            <xsl:value-of select="alt"/>
        </xsl:attribute>
      </xsl:if>
    </img>
</xsl:template>

</xsl:stylesheet>

