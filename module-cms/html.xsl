<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cms="http://edoc.hu-berlin.de/diml/module/cms"
  exclude-result-prefixes="cms"
>

<xsl:template match="cms:container">
  <xsl:apply-templates select="cms:document[1]"/>
</xsl:template>

<xsl:template match="cms:document">
  <xsl:apply-templates select="cms:meta" mode="navigation"/>
  <xsl:apply-templates select="cms:content/*"/>
  <!-- Alles was am Ende des inhalts steht -->
  
  <xsl:apply-templates select="cms:content//footnote" mode="foot"/>
  <xsl:apply-templates select="cms:content//endnote" mode="foot"/>
  
  <!-- Navigationsleiste -->
  <xsl:apply-templates select="cms:meta" mode="navbottom"/>
</xsl:template>

<xsl:template match="cms:container" mode="html-head">
  <xsl:apply-templates select="cms:document[1]/cms:meta/*" mode="html-head"/>
</xsl:template>

<!--==== Tags in the HTML HEAD element ===============================-->

<xsl:template match="cms:entry[@type='title']" mode="html-head">
  <title><xsl:value-of select="."/></title>
</xsl:template>

<xsl:template match="cms:entry[@type=':start']" mode="html-head">
  <link rel="start" href="{@part}"/>
</xsl:template>

<xsl:template match="cms:entry[@type=':contents']" mode="html-head">
  <link rel="contents" href="{@part}"/>
</xsl:template>

<xsl:template match="cms:entry[@type=':first']" mode="html-head">
  <link rel="first" href="{@part}"/>
</xsl:template>

<xsl:template match="cms:entry[@type=':prev']" mode="html-head">
  <link rel="prev" href="{@part}"/>
</xsl:template>

<xsl:template match="cms:entry[@type=':next']" mode="html-head">
  <link rel="next" href="{@part}"/>
</xsl:template>

<xsl:template match="cms:entry[@type=':last']" mode="html-head">
  <link rel="last" href="{@part}"/>
</xsl:template>

<xsl:template match="cms:entry[@type=':glossary']" mode="html-head">
  <link rel="glossary" href="{@part}"/>
</xsl:template>

<xsl:template match="cms:entry[@type=':appendix']" mode="html-head">
  <link rel="appendix" href="{@part}"/>
</xsl:template>

<xsl:template match="cms:entry[@type=':copyright']" mode="html-head">
  <link rel="copyright" href="{@part}"/>
</xsl:template>

<xsl:template match="cms:entry[@type=':author']" mode="html-head">
  <link rel="author" href="{@part}"/>
</xsl:template>

<xsl:template match="cms:entry[@type=':help']" mode="html-head">
  <link rel="help" href="{@part}"/>
</xsl:template>

<xsl:template match="cms:entry[@type=':search']" mode="html-head">
  <link rel="search" href="{@part}"/>
</xsl:template>


<xsl:template match="cms:entry" mode="html-head"/>

<!--==== Navigation Bar ==============================================-->

<xsl:template match="cms:meta" mode="navigation">
  <table width="100%" border="0" class="navigation">
    <tr>
      <td class="nav-about" valign="top">
         <xsl:apply-templates select="cms:entry[@type='author']"/>
         <xsl:apply-templates select="cms:entry[@type='title']"/>
      </td>   
    </tr>
    <tr>
      <td class="nav-parts" colspan="2">
         <xsl:apply-templates select="cms:entry[@type='front']" mode="link"/>
         <xsl:if test="cms:entry[@type='chapter']">
           <xsl:value-of select="$VOCABLES/chapter/@*[name()=$lang]" />: <xsl:apply-templates select="cms:entry[@type='chapter']" mode="link"/>
           <br/>
         </xsl:if>         
         <xsl:if test="cms:entry[@type='pagenumber']">
      	 <xsl:call-template name="pagenumbers-nav"/>
         </xsl:if>         
         <!-- bibliography, declaration ... -->
        <xsl:apply-templates select="cms:entry[@type!='pagenumber' and @type!='chapter' and @type!='front'][@ref]" mode="navbar"/>
        <!--xsl:apply-templates select="cms:entry" mode="navbar"/-->
      </td>
    </tr>
  </table>
</xsl:template>

<xsl:template match="cms:meta" mode="navbottom">
  <table width="100%" border="0" class="headline">
    <tr>
    	 <td>
    	 	<xsl:apply-templates select="cms:entry" mode="navbar"/>
    	 </td>
    </tr>
  </table>
</xsl:template>

<!--navbar-->
<xsl:template match="cms:entry[@type=':next']" mode="navbar">
  <a href="{@part}">next</a>&#xA0;
</xsl:template>

<xsl:template match="cms:entry[@type=':prev']" mode="navbar">
  <a href="{@part}">prev</a>&#xA0;
</xsl:template>

<xsl:template match="cms:entry[@type=':first']" mode="navbar">
  <a href="{@part}">first</a>&#xA0;
</xsl:template>

<xsl:template match="cms:entry[@type=':last']" mode="navbar">
  <a href="{@part}">last</a>&#xA0;
</xsl:template>

<!--==== Page navigation with Javascript =========================-->

<xsl:template match="cms:entry[@type='pagenumber']" mode="nav-form">
	<option>
		<xsl:attribute name="value">
			<xsl:if test="@part and name(key('id',@ref))='cms:entry'">        
				<xsl:value-of select="@part"/>
		     </xsl:if>    
		      <xsl:text>#</xsl:text>
	      <xsl:value-of select="@ref"/>
		</xsl:attribute>
		<xsl:value-of select="."/>
	</option>
</xsl:template>

<!-- there is still a bug (some pages multiple/some missing) -->
<xsl:template name="pagenumbers-nav">
	<!--Seiten: <xsl:apply-templates select="cms:entry[@type='pagenumber']" mode="link"/>-->
	<form method="get"
	 action="javascript:self.location.href=document.pagenumForm.pagenumber.value;void(0);" name="pagenumForm">
		<!--input type="submit" value="Gehe zu Seite:"/-->
           <xsl:value-of select="$VOCABLES/page/@*[name()=$lang]" /><xsl:text>:</xsl:text>
		<select name="pagenumber" onChange="document.pagenumForm.submit();">
			<xsl:apply-templates select="cms:entry[@type='pagenumber']" mode="nav-form"/>			
		</select>
	</form>
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
      <xsl:when test="@type='front'">
        <xsl:value-of select="$VOCABLES/front/@*[name()=$lang]" />
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
    </xsl:choose>
  </a>
 <xsl:text>] </xsl:text>
</xsl:template>

<xsl:template match="cms:entry[@type='title']">
  <span class="nav-title"><xsl:value-of select="."/></span>
</xsl:template>

<xsl:template match="cms:entry[@type='author']">
  <span class="nav-author"><xsl:value-of select="."/>: </span>
</xsl:template>

<xsl:template match="cms:entry" mode="navbar"/> <!--ignore-->
<xsl:template match="cms:entry"/>

</xsl:stylesheet>