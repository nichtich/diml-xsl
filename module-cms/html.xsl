<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cms="DiMLCMS"
>

<xsl:template match="/cms:container">
  <xsl:apply-templates select="cms:document[1]"/>
</xsl:template>

<xsl:template match="cms:document">
  <html>
    <head>
      <meta http-equiv="content-type" content="text/html; charset=UTF-8"/>      
      <xsl:if test="$CSS-STYLESHEET">      
        <link rel="stylesheet" type="text/css" href="{$CSS-STYLESHEET}"/>
      </xsl:if>
      <xsl:apply-templates select="cms:meta/*" mode="html-head"/>
    </head>
    <body>
      <xsl:apply-templates select="cms:meta" mode="navigation"/>
      <xsl:apply-templates select="cms:content/*"/>
    </body>
  </html>
</xsl:template>

<!--==== Tags in the HTML HEAD element ===============================-->

<xsl:template match="cms:entry[@type='title']" mode="html-head">
  <title><xsl:value-of select="."/></title>
</xsl:template>

<xsl:template match="cms:entry" mode="html-head"/>

<!--==== Navigation Bar ==============================================-->

<xsl:template match="cms:meta" mode="navigation">
  <table width="100%" border="0" class="headline">
    <tr>
      <td class="headline1" valign="top">
         <xsl:apply-templates select="cms:entry[@type='author']"/>
         <xsl:apply-templates select="cms:entry[@type='title']"/>
      </td>   
    </tr>
    <tr>
      <td class="headline2" colspan="2">
        <xsl:apply-templates select="cms:entry[@linkid]" mode="link"/>
      </td>
    </tr>
  </table>
</xsl:template>

<!--
front: titelseite
preface: Vorwort
chapter: ....nummerierern...
bibliography: Literaturverzeichnis
vita: Lebenslauf
acknowledgement: Danksagung
-->
<xsl:template match="cms:entry" mode="link">
  [
  <a>
    <xsl:attribute name="href">
      <xsl:if test="@objid and name(key('id',@linkid))='cms:entry'">        
        <xsl:value-of select="@objid"/>
      </xsl:if>    
      <xsl:text>#</xsl:text>
      <xsl:value-of select="@linkid"/>
    </xsl:attribute>
    <xsl:value-of select="."/>
  </a>
  ]
</xsl:template>

<xsl:template match="cms:entry[@type='title']">
  <xsl:value-of select="."/>
</xsl:template>

<xsl:template match="cms:entry[@type='author']">
  <xsl:value-of select="."/>:
</xsl:template>

<xsl:template match="cms:entry"/>

</xsl:stylesheet>