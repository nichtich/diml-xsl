<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
 	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:cms="http://edoc.hu-berlin.de/diml/module/cms">

<!-- id of the element we want to see -->
<xsl:param name="SELECTID"/>

<!-- parts of the document that may be content of the container --> 
<xsl:variable name="parts" select="/etd/front|/etd/body/*|/etd/back/*"/>

<xsl:output method="xml" indent="yes"/>

<xsl:template match="/">
  <xsl:variable name="selected-part" select="//*[@id=$SELECTID]"/>
  <xsl:if test="$selected-part">
    <cms:container xmlns:cms="http://edoc.hu-berlin.de/diml/module/cms">
      <cms:document>
        <cms:meta>
           <xsl:apply-templates select="*" mode="cms"/>
         </cms:meta>
	  <cms:content>
	    <xsl:copy-of select="$selected-part"/>
        </cms:content>
      </cms:document> 
    </cms:container>
  </xsl:if>
</xsl:template>

<!-- traverse all nodes in mode cms and print a cms:entry -->
<xsl:template match="*" mode="cms">
  <xsl:variable name="part" select="ancestor-or-self::*[@id=$parts/@id][1]/@id"/>
  <xsl:if test="$part=@id">
    <cms:entry type="{name(.)}" ref="{@id}">
      <xsl:call-template name="entry-id-attributes"/>
      <!-- does the element have a name or something like this? -->
      <xsl:if test="head">
        <!-- QUESTION: why not copy-of? -->
        <xsl:value-of select="head"/>
      </xsl:if>
    </cms:entry> 
  </xsl:if>
  <xsl:apply-templates mode="cms"/>
</xsl:template>

<!-- do not output text on places we do not want to -->
<xsl:template match="text()" mode="cms"/>

<!-- Metadaten, die einfach nur angezeigt werden sollen -->
<xsl:template match="front/title" mode="cms">
  <cms:entry type="title">
    <xsl:value-of select="."/>
  </cms:entry>
  <xsl:apply-templates mode="cms"/>
</xsl:template>

<xsl:template match="front/author" mode="cms">
  <cms:entry type="author">
  	<xsl:choose>
  	  <xsl:when test="surname">
    	    <xsl:value-of select="surname"/>
  	  </xsl:when>
  	  <xsl:otherwise>
           <xsl:value-of select="."/>
  	  </xsl:otherwise>
  	</xsl:choose>
  </cms:entry>
  <xsl:apply-templates mode="cms"/>  
</xsl:template>

<!-- Metadaten, die verlinkt werden sollen -->
<xsl:template match="pagenumber" mode="cms">
  <xsl:variable name="part" select="ancestor-or-self::*[@id=$parts/@id][1]/@id"/>
  <cms:entry type="pagenumber" ref="{@id}">
    <xsl:call-template name="entry-id-attributes"/>
      <xsl:value-of select="@start"/>
  </cms:entry>
</xsl:template>

<xsl:template match="front" mode="cms">
  <xsl:call-template name="check-id"/>
  <cms:entry type="front" ref="{@id}">
    <xsl:call-template name="entry-id-attributes"/>
  </cms:entry>
  <xsl:apply-templates mode="cms"/>
</xsl:template>


<!--== templates that are functions/tools ==-->

<!-- generate attribute id and attribute part for a cms:entry element -->
<xsl:template name="entry-id-attributes">
  <xsl:variable name="part" select="ancestor-or-self::*[@id=$parts/@id][1]/@id"/>
  <xsl:if test="$SELECTID!=$part">
      <xsl:attribute name="id">
        <xsl:value-of select="@id"/>
      </xsl:attribute>
      <xsl:attribute name="part">
      	  <!-- FIXME: this will only work if we want to create html-files! -->
        <xsl:value-of select="concat($part,'.html')"/>
      </xsl:attribute>                  
  </xsl:if>
</xsl:template>

<!-- check whether an element has an id-attribute -->
<xsl:template name="check-id">
  <xsl:if test="not(@id)">
    <xsl:message terminate="yes">
    	<xsl:text>id attribute is missing for element </xsl:text>
    	<xsl:value-of select="name(.)"/>
    </xsl:message>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
