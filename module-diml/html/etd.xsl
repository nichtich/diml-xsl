<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

      <!--xsl:apply-templates select="front" mode="html-head"/-->

<xsl:template match="/">
 <html>
    <head>
      <meta http-equiv="content-type" content="text/html; charset=UTF-8"/>      
      <xsl:if test="$CSS-STYLESHEET">      
        <link rel="stylesheet" type="text/css" href="{$CSS-STYLESHEET}"/>
      </xsl:if>
      <xsl:apply-templates mode="html-head"/>     
    </head>
    <body>
      <xsl:apply-templates/>
    </body>
  </html>    
</xsl:template>

<xsl:template match="etd">
  <xsl:apply-templates select="front" mode="headline"/>
  <xsl:apply-templates select="front"/>
  <xsl:call-template name="table-of-contents"/>
      <xsl:call-template name="table-of-figures"/>
      <xsl:call-template name="table-of-tables"/>      
      <xsl:apply-templates select="body"/>
      <xsl:apply-templates select="back"/>      
</xsl:template>

<xsl:template match="etd" mode="html-head"/>

</xsl:stylesheet>

