<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template name="MEDIA-URL">
  <xsl:param name="object"/>
  <xsl:value-of select="$object"/>
  <!--unparsed-entity-uri($object)}-->
</xsl:template>

<xsl:template match="mm" name="mm">
 <p class="mmcaption">
    <a>
      <xsl:call-template name="a-name-attribute"/>
      <xsl:apply-templates select="caption"/>
    </a>
  </p>  
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

<xsl:template match="mm" mode="table-of-figures">
  <li>
    <a>
      <xsl:call-template name="a-href-attribute"/>
      <xsl:apply-templates select="caption" mode="table-of-figures" />
    </a>
  </li>
</xsl:template>


</xsl:stylesheet>

