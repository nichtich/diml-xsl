<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cms="http://edoc.hu-berlin.de/diml/module/cms"
>

<xsl:template match="cms:container">
  <xsl:apply-templates select="cms:document[1]"/>
</xsl:template>

<xsl:template match="cms:document">
  <xsl:apply-templates select="cms:meta" mode="navigation"/>
  <xsl:apply-templates select="cms:content/*"/>
</xsl:template>

<xsl:template match="cms:container" mode="html-head">
  <xsl:apply-templates select="cms:document[1]/cms:meta/*" mode="html-head"/>
</xsl:template>

<!--==== Tags in the HTML HEAD element ===============================-->

<xsl:template match="cms:entry[@type='title']" mode="html-head">
  <title><xsl:value-of select="."/></title>
</xsl:template>

<xsl:template match="cms:entry[@type='rel-next']" mode="html-head">
  <link rel="next" href="{@part}"/> <!-- TODO: get part -->
</xsl:template>

<xsl:template match="cms:entry[@type='rel-prev']" mode="html-head">
  <link rel="prev" href="{@part}"/>
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
      <xsl:if test="cms:entry[@type='pagenumber']">
           Seiten: <xsl:apply-templates select="cms:entry[@type='pagenumber']" mode="link"/>
           <br/>
         </xsl:if>
         <xsl:if test="cms:entry[@type='chapter']">
           Kapitel: <xsl:apply-templates select="cms:entry[@type='chapter']" mode="link"/>
           <br/>
         </xsl:if>         
        <xsl:apply-templates select="cms:entry[@type!='pagenumber' and @type!='chapter'][@ref]" mode="link"/>
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
 <xsl:text> [</xsl:text>
  <a>
    <xsl:attribute name="href">
      <xsl:if test="@part and name(key('id',@ref))='cms:entry'">        
        <xsl:value-of select="@part"/>
      </xsl:if>    
      <xsl:text>#</xsl:text>
      <xsl:value-of select="@ref"/>
    </xsl:attribute>
    <xsl:choose>
      <xsl:when test="@type='front'">Titelseite</xsl:when>
      <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
    </xsl:choose>
  </a>
 <xsl:text>] </xsl:text>
</xsl:template>

<xsl:template match="cms:entry[@type='title']">
  <xsl:value-of select="."/>
</xsl:template>

<xsl:template match="cms:entry[@type='author']">
  <xsl:value-of select="."/>:
</xsl:template>

<xsl:template match="cms:entry"/>

</xsl:stylesheet>