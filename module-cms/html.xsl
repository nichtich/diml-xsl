<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cms="http://edoc.hu-berlin.de/diml/module/cms"
  exclude-result-prefixes="cms"
>

<!-- this variable reflects, whether frames are used in document -->
<xsl:variable name="frameExists">
  <xsl:choose>
    <xsl:when test="/cms:container/cms:document/cms:meta/cms:entry[@type='frame']">true</xsl:when>
    <xsl:otherwise>false</xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<xsl:template match="cms:container">
  <xsl:apply-templates select="cms:document[1]"/>
</xsl:template>

<xsl:template match="cms:document">
  <xsl:apply-templates select="cms:meta" mode="navigation"/>
  <xsl:apply-templates select="cms:content/*"/>
  <!-- Alles was am Ende des inhalts steht -->

  <xsl:if test="cms:content//footnote or cms:content//endnote">
    <hr/>
    <h3 class="footnoteheader"><xsl:value-of select="$VOCABLES/footnotesandendnotes/@*[name()=$LANG]" /></h3>
  </xsl:if>

  <xsl:apply-templates select="cms:content//footnote" mode="foot"/>
  <xsl:apply-templates select="cms:content//endnote" mode="foot"/>

  <xsl:if test="cms:content//footnote or cms:content//endnote">
    <hr/>
  </xsl:if>
  
  <!-- Navigationsleiste -->
  <xsl:apply-templates select="cms:meta" mode="navbottom"/>

	<!-- Copyright etc. -->
   <hr/>
  <xsl:call-template name="InfoTable"/>

</xsl:template>

<xsl:template match="cms:container" mode="html-head">
  <xsl:apply-templates select="cms:document[1]/cms:meta/*" mode="html-head"/>
</xsl:template>

<!--==================================================================-->
<!--==== Tags in the HTML HEAD element ===============================-->
<!--==================================================================-->

<xsl:template match="cms:entry[@type='title']" mode="html-head">
  <title>
    <xsl:value-of select="../cms:entry[@type='author']"/>:
    <xsl:value-of select="."/>
  </title>
</xsl:template>

<xsl:template match="cms:entry[@type=':start']" mode="html-head">
  <link rel="start" href="{@part}{$EXT}"/>
</xsl:template>

<xsl:template match="cms:entry[@type=':contents']" mode="html-head">
  <link rel="contents">
    <xsl:attribute name="href">
      <xsl:if test="@part and name(key('id',@ref))='cms:entry'"><xsl:value-of select="@part"/><xsl:value-of select="$EXT"/></xsl:if>
      <xsl:text>#</xsl:text><xsl:value-of select="@ref"/>
    </xsl:attribute>
  </link>
</xsl:template>

<xsl:template match="cms:entry[@type=':first']" mode="html-head">
  <link rel="first" href="{@part}{$EXT}"/>
</xsl:template>

<xsl:template match="cms:entry[@type=':prev']" mode="html-head">
  <link rel="prev" href="{@part}{$EXT}"/>
</xsl:template>

<xsl:template match="cms:entry[@type=':next']" mode="html-head">
  <link rel="next" href="{@part}{$EXT}"/>
</xsl:template>

<xsl:template match="cms:entry[@type=':last']" mode="html-head">
  <link rel="last" href="{@part}{$EXT}"/>
</xsl:template>

<xsl:template match="cms:entry[@type=':glossary']" mode="html-head">
  <link rel="glossary" href="{@part}{$EXT}"/>
</xsl:template>

<xsl:template match="cms:entry[@type=':appendix']" mode="html-head">
  <link rel="appendix" href="{@part}{$EXT}"/>
</xsl:template>

<xsl:template match="cms:entry[@type=':author']" mode="html-head">
  <link rel="author" href="{@part}{$EXT}"/>
</xsl:template>

<xsl:template match="cms:entry[@type=':copyright']" mode="html-head">
  <link rel="copyright" href="{url/@href}"/>
</xsl:template>

<xsl:template match="cms:entry[@type=':help']" mode="html-head">
  <link rel="help" href="{url/@href}"/>
</xsl:template>

<xsl:template match="cms:entry[@type=':search']" mode="html-head">
  <link rel="search" href="{url/@href}"/>
</xsl:template>

<xsl:template match="cms:entry" mode="label">
  <xsl:value-of select="."/>	
</xsl:template>

<xsl:template match="cms:entry" mode="html-head" />


<!--==================================================================-->
<!--==== Navigation Bar ==============================================-->
<!--==================================================================-->

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
         <form action="" name="navForm">
           <xsl:apply-templates select="cms:entry[@type='front']" mode="link"/>
           <xsl:apply-templates select="cms:entry[@type='preface']" mode="link"/>

           <xsl:choose>
         
             <!-- show frames instead of chapters if frames exist -->         
             <xsl:when test="$frameExists='true'">
               <xsl:value-of select="$VOCABLES/frame/@*[name()=$LANG]" />
               <xsl:text>:&#xA0;</xsl:text>
               <!-- choose a) frames and parts, which are a file -->
               <!-- if part is current file, an extra condition is required -->
               <!-- cms:entry[@type='part'][not(@id)][not(@part)] -->
               <xsl:for-each select="cms:entry[@type='frame'] | cms:entry[@type='part'][@id=@part] | cms:entry[@type='part'][@ref=../cms:entry[@type=':current']/@part]">
                       <xsl:apply-templates select="." mode="link">
                            <xsl:with-param name="before"/>
                            <xsl:with-param name="after"/>
                       </xsl:apply-templates>
                       <xsl:if test="following-sibling::cms:entry[@type='frame'] | following-sibling::cms:entry[@type='part'][@id=@part]"> | </xsl:if>
               </xsl:for-each>           
             </xsl:when>
           
             <!-- normal case: show chapters -->
             <xsl:otherwise>
               <xsl:if test="cms:entry[@type='chapter']">
                 <xsl:value-of select="$VOCABLES/chapter/@*[name()=$LANG]" />
                 <xsl:text>:&#xA0;</xsl:text>
               <!-- cms:entry[@type='part'][not(@id)][not(@part)] -->
                 <xsl:for-each select="cms:entry[@type='chapter'] | cms:entry[@type='part'][@id=@part] | cms:entry[@type='part'][@ref=../cms:entry[@type=':current']/@part]">
                         <xsl:apply-templates select="." mode="link">
                              <xsl:with-param name="before"/>
                              <xsl:with-param name="after"/>
                         </xsl:apply-templates>
                         <xsl:if test="following-sibling::cms:entry[@type='chapter'] | following-sibling::cms:entry[@type='part'][@id=@part] | following-sibling::cms:entry[@type='part'][@id=@part]"> | </xsl:if>
                 </xsl:for-each>           
               </xsl:if>
             </xsl:otherwise>
           
           </xsl:choose>
           <xsl:text>&#xA0;</xsl:text>
           
          <!-- andere teile: bibliography, declaration ... -->
          <xsl:apply-templates select="cms:entry[@type!='pagenumber' and @type!='chapter' and @type!='frame' and @type!='front' and @type!='preface' and @type!='dedication' and substring(@type,1,1)!=':'][@ref]" mode="navbar"/>
          <br/>
          
          <!-- if citenumbers exists, print citenumbers and no pagenumbers -->
          <!-- else print pagenumbers, if pagenumbers exists               -->
          
          <xsl:choose>
            <xsl:when test="cms:entry[@type='citenumber']">
              <xsl:call-template name="citenumbers-nav"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:if test="cms:entry[@type='pagenumber']">
                <xsl:call-template name="pagenumbers-nav"/>
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose>
          
          <xsl:apply-templates select="cms:entry[@type=':contents']" mode="navbar"/>
        </form>
      </td>
    </tr>
  </table>
</xsl:template>

<xsl:template match="cms:meta" mode="navbottom">
  <table width="100%" border="0" class="navigation">
    <tr>
      <td class="nav-parts" colspan="2">
        <p class="navbottom">
         <xsl:apply-templates select="cms:entry[@type='front']" mode="link"/>
         <xsl:apply-templates select="cms:entry[@type='preface']" mode="link"/>

         <xsl:choose>
           <!-- show frames instead of chapters if frames exist -->         
           <xsl:when test="cms:entry[@type='frame']">
             <xsl:apply-templates select="cms:entry[@type='frame'] | cms:entry[@type='part'][@id=@part] | cms:entry[@type='part'][@ref=../cms:entry[@type=':current']/@part]" mode="link">
             </xsl:apply-templates>
           </xsl:when>
           
           <!-- normal case: show chapters -->
           <xsl:otherwise>
             <xsl:if test="cms:entry[@type='chapter']">
               <xsl:apply-templates select="cms:entry[@type='chapter'] | cms:entry[@type='part'][@id=@part] | cms:entry[@type='part'][@ref=../cms:entry[@type=':current']/@part]" mode="link">
               </xsl:apply-templates>
             </xsl:if>
           </xsl:otherwise>
         </xsl:choose>
         
         <!-- old version: -->
         <!--<xsl:if test="cms:entry[@type='chapter']">
           <xsl:apply-templates select="cms:entry[@type='chapter']" mode="link"/>
         </xsl:if>-->
         
         <!-- andere teile: bibliography, declaration ... -->
         <xsl:apply-templates select="cms:entry[@type!='pagenumber' and @type!='chapter' and @type!='front' and @type!='preface' and @type!='dedication'][@ref]" mode="navbar" />
        </p>
      </td>
    </tr>
  </table>
</xsl:template>

<xsl:template name="InfoTable">
	<table width="100%" border="0" class="infoTable">
		<xsl:if test="$CONFIG/infoBottom[@lang=$LANG]">
	  		<tr>
  				<td colspan="3" class="infoBottom">
  					<xsl:value-of select="$CONFIG/infoBottom[@lang=$LANG]" disable-output-escaping="yes"/>
  				</td>
		  	</tr>
		</xsl:if> 	
		<tr>
			<td class="infoLeft">
				<xsl:value-of select="$CONFIG/infoLeft[@lang=$LANG]" disable-output-escaping="yes"/>
			</td>
     	  	<td class="infoMiddle">
     	   		<xsl:value-of select="$CONFIG/infoMiddle[@lang=$LANG]" disable-output-escaping="yes"/>
	      	</td>
     	   	<td class="infoRight">
     	   		<xsl:value-of select="$CONFIG/infoRight[@lang=$LANG]" disable-output-escaping="yes"/>
	          	<xsl:value-of select="$CONVDATE" />
        		</td>
     	</tr>
	</table>
</xsl:template>

<!--navbar-->
<xsl:template match="cms:entry[@type=':next']" mode="navbar">
<xsl:text>[</xsl:text><a href="{@part}{$EXT}"><xsl:value-of select="$VOCABLES/next/@*[name()=$LANG]" /></a>&#xA0;
</xsl:template>

<xsl:template match="cms:entry[@type=':prev']" mode="navbar">
<xsl:text>[</xsl:text><a href="{@part}{$EXT}"><xsl:value-of select="$VOCABLES/prev/@*[name()=$LANG]" /></a>&#xA0;<xsl:text>]</xsl:text>
</xsl:template>

<xsl:template match="cms:entry[@type=':first']" mode="navbar">
<xsl:text>[</xsl:text><a href="{@part}{$EXT}"><xsl:value-of select="$VOCABLES/first/@*[name()=$LANG]" /></a>&#xA0;<xsl:text>]</xsl:text>
</xsl:template>

<xsl:template match="cms:entry[@type=':last']" mode="navbar">
<xsl:text>[</xsl:text><a href="{@part}{$EXT}"><xsl:value-of select="$VOCABLES/last/@*[name()=$LANG]" /></a>&#xA0;<xsl:text>]</xsl:text>
</xsl:template>



<!--==================================================================-->
<!--==== Page navigation with Javascript =========================-->
<!--==================================================================-->

<xsl:template name="pagenumbers-nav">
  <xsl:value-of select="$VOCABLES/page/@*[name()=$LANG]" /><xsl:text>:&#xA0;</xsl:text>

  <select name="pagenumber" onchange="self.location.href=document.navForm.pagenumber.value;void(0);">
    <xsl:apply-templates select="cms:entry[@type='pagenumber']" mode="nav-form"/>			
  </select>
</xsl:template>

<xsl:template match="cms:entry[@type='pagenumber']" mode="nav-form">
  <option>
    <xsl:attribute name="value">
      <xsl:if test="@part and name(key('id',@ref))='cms:entry'">
        <xsl:value-of select="@part"/>
        <xsl:value-of select="$EXT"/>
      </xsl:if>  
      <xsl:text>#</xsl:text>
      <xsl:value-of select="@ref"/>
    </xsl:attribute>
    <xsl:value-of select="."/>
  </option>
</xsl:template>

<xsl:template name="citenumbers-nav">
  <xsl:value-of select="$VOCABLES/cite/@*[name()=$LANG]" /><xsl:text>:&#xA0;</xsl:text>
  <select name="citenumber" onchange="self.location.href=document.navForm.citenumber.value;void(0);">
    <xsl:apply-templates select="cms:entry[@type='citenumber']" mode="nav-form"/>
  </select>
</xsl:template>

<xsl:template match="cms:entry[@type='citenumber']" mode="nav-form">
  <option>
    <xsl:attribute name="value">
      <xsl:if test="@part and name(key('id',@ref))='cms:entry'">
        <xsl:value-of select="@part"/>
        <xsl:value-of select="$EXT"/>
      </xsl:if>  
      <xsl:text>#</xsl:text>
      <xsl:value-of select="@ref"/>
    </xsl:attribute>
    <xsl:value-of select="."/>
  </option>
</xsl:template>

<!-- create a link for a cms:entry element. The name of the link will be -->
<!-- the content of cms:entry or an @type called element in $VOCABLES    -->

<xsl:template match="cms:entry" mode="link">
  <xsl:param name="before"> [</xsl:param>
  <xsl:param name="after">] </xsl:param>	
  <xsl:param name="type" select="current()/@type"/>
  <xsl:param name="LABEL">
  
    <xsl:choose>
      <xsl:when test="string(.)!=''">
        <xsl:value-of select="."/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$VOCABLES/*[name()=$type]/@*[name()=$LANG]" />
      </xsl:otherwise>
    </xsl:choose>    
  </xsl:param>
 <xsl:value-of select="$before"/>
 <a>
    <xsl:attribute name="href">
    
      <xsl:choose>
      
      <!-- standard case: attribute "part" exists: links to another file -->
      <!-- if @part exists and @ref points to a xms:entry-element        -->
      <!-- means name of part with extension (e.g. ".html") is printed   -->

         <xsl:when test="@part and name(key('id',@ref))='cms:entry'">
           <xsl:value-of select="@part"/>
           <xsl:value-of select="$EXT"/>
         </xsl:when>

      <!-- this case means link to the same file.                        -->
      <!-- name of courrent file will be used                            -->
      <!-- in older versions the follwing test was used:                 -->
      <!-- test="(@ref and @type and not(@part) and not(@id))"           -->
      
         <xsl:otherwise> 
            <xsl:value-of select="../cms:entry[@type=':current']/@part"/>
            <xsl:value-of select="$EXT"/>
         </xsl:otherwise>
      </xsl:choose>

      <!-- link to anchor only if link goes to TOC                  -->
      <!-- some old test: @ref=../cms:entry[@type=':current']/@part -->
      <!-- the following test would link to anchor, if current part -->
      <!-- <xsl:if test="@ref=':contents' or (not(@id=@part))">     -->
      
      <xsl:if test="@ref=':contents'">
         <xsl:text>#</xsl:text><xsl:value-of select="@ref"/>
      </xsl:if>

    </xsl:attribute>
    <xsl:value-of select="normalize-space($LABEL)"/>
  </a>
  <xsl:value-of select="$after"/>
</xsl:template>

<!-- Metadata (cms:entry) for Navigation bar -->

<xsl:template match="cms:entry[@type='title']">
  <!-- !!! try to test if formatting in navbar title can be visualised -->
  <!--<span class="nav-title"><xsl:value-of select="."/></span>-->
  <span class="nav-title"><xsl:apply-templates select="node()" /></span>
</xsl:template>

<xsl:template match="cms:entry[@type='author']">
  <span class="nav-author"><xsl:value-of select="."/>: </span>
</xsl:template>

<xsl:template match="cms:entry[@type=':contents']" mode="navbar">
  <xsl:apply-templates select="." mode="link">
    <xsl:with-param name="type" select="_contents"/>
  </xsl:apply-templates>  
</xsl:template>


<!-- Create a link in the navigation bar for each of this cms:entry elements -->
<xsl:template match="cms:entry[@type='acknowledgement' or @type='vita' or @type='bibliography' or @type='preface' or @type='submission' or @type='grant' or @type='dedication' or @type='copyright' or @type='motto' or @type='declaration' or @type='resources' or @type='glossary' or @type='appendix' or @type='abbreviation'  or @type='abbreviation' or @type='summary']" mode="navbar">
  <xsl:apply-templates select="." mode="link"/>
</xsl:template>

<!-- ignore everything else -->
<xsl:template match="cms:entry" mode="navbar" />
<xsl:template match="cms:entry" /> 


</xsl:stylesheet>