<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/etd">
  <html>
    <head>
      <xsl:apply-templates select="front" mode="html-head"/>
      <meta http-equiv="content-type" content="text/html; charset=UTF-8"/>      
      <link rel="stylesheet" type="text/css" href="{$CSS-STYLESHEET}"/>
    </head>
    <body>
      <xsl:apply-templates select="front" mode="headline"/>
      <xsl:apply-templates select="front"/>
      <xsl:call-template name="table-of-contents"/>
      <xsl:apply-templates select="body"/>
      <xsl:apply-templates select="back"/>      
    </body>
  </html>
</xsl:template>

</xsl:stylesheet>
