<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template name="MEDIA-URL">
  <xsl:param name="object"/>
  <xsl:value-of select="$object"/>
  <!--unparsed-entity-uri($object)}-->
</xsl:template>

<xsl:template match="mm" name="mm">
  <p>
    <img>
      <xsl:attribute name="src">
        <xsl:call-template name="MEDIA-URL">        	
          <xsl:with-param name="object" select="@entity|@file"/>          
        </xsl:call-template>
      </xsl:attribute>
    </img>
  </p>
</xsl:template>

</xsl:stylesheet>
