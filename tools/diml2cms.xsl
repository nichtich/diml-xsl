<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
 	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:cms="http://edoc.hu-berlin.de/diml/module/cms">

<xsl:output method="xml" indent="yes"/>

<!-- id of the element we want to see -->
<xsl:param name="SELECTID"/>

<xsl:param name="LANG">
	<xsl:choose>
		<xsl:when test="/etd/@lang"><xsl:value-of select="/etd/@lang"/></xsl:when>
		<xsl:otherwise>de</xsl:otherwise>
	</xsl:choose>
</xsl:param>
<xsl:param name="VOCFILE">vocables.xml</xsl:param>
<xsl:variable name="VOCABLES" select="document($VOCFILE)/vocables"/>

<!-- parts of the document that may be content of the container --> 
<xsl:variable name="parts" select="/etd/front|/etd/body/*|/etd/back/*"/>

<!-- ROOT template -->
<xsl:template match="/">
  <xsl:variable name="selected-part" select="//*[@id=$SELECTID]"/>  
  <xsl:if test="not($selected-part)">
    <xsl:message terminate="yes">
    	No SELECTID or element of SELECTID=<xsl:value-of select="$SELECTID"/> not found!
    </xsl:message>
  </xsl:if>
    
  <cms:container xmlns:cms="http://edoc.hu-berlin.de/diml/module/cms">
    <cms:document>
      <cms:meta>
         <xsl:apply-templates select="*" mode="cms"/>
         <xsl:call-template name="navigation">
         	<xsl:with-param name="selected-part" select="$selected-part"/>
         </xsl:call-template>
       </cms:meta>
     <!-- Copy the selected part into cms:content -->                
	  <cms:content>
    		<xsl:choose>
    	    		<xsl:when test="name($selected-part)='front'">
		  	    	<xsl:call-template name="createFront"/>
	    </xsl:when>
    		<xsl:otherwise>
    		    <xsl:copy-of select="$selected-part"/>
	    	</xsl:otherwise>
    		</xsl:choose>	    
      </cms:content>
    </cms:document> 
  </cms:container>
</xsl:template>

<!-- traverse all nodes in mode cms and print a cms:entry for elements that have an @id -->
<!-- TODO: what about list of images, tables, TableOfContents/chapter? -->
<xsl:template match="*[@id]" mode="cms">
  <!-- -->
  <xsl:variable name="part" select="ancestor-or-self::*[@id=$parts/@id][1]/@id"/>
  <!--xsl:if test="$part=@id"-->
      <cms:entry type="{name(.)}" ref="{@id}">
      <xsl:call-template name="entry-id-attributes"/>
      <!-- does the element have a name or something like this? -->
      <xsl:choose>
	   <xsl:when test="@label"><xsl:value-of select="@label"/></xsl:when>
	   <xsl:when test="@start"><xsl:value-of select="@start"/></xsl:when>
        <!-- TODO: remove footnotes etc. in head -->
	   <xsl:when test="head"><xsl:value-of select="head"/></xsl:when>
	 </xsl:choose>
    </cms:entry> 
  <!--/xsl:if-->
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
    <xsl:choose>
    	<xsl:when test="@label"><xsl:value-of select="@label"/></xsl:when>
    	<xsl:otherwise><xsl:value-of select="@start"/></xsl:otherwise>
    </xsl:choose>
  </cms:entry>
</xsl:template>

<xsl:template match="front" mode="cms">
  <xsl:call-template name="check-id"/>
  <cms:entry type="front" ref="{@id}">
    <xsl:call-template name="entry-id-attributes"/>
  </cms:entry>
  <xsl:apply-templates mode="cms"/>
</xsl:template>

<!-- Diese Angaben können zur Navigation ausgewertet werden (siehe HTML-Element link) -->
<xsl:template name="navigation">
	<xsl:param name="selected-part"/>
	<!-- NUR TEST! NICHT ENDGÜLTIG! -->
	<!--xsl:if test="$selected-part/preceding-sibling::*[1]/@id">
		<cms:entry type=":prev" part="{$selected-part/preceding-sibling::*[1]/@id}.html"/>
	</xsl:if>	
	<xsl:if test="$selected-part/following-sibling::*[1]/@id">
		<cms:entry type=":next" part="{$selected-part/following-sibling::*[1]/@id}.html"/>
	</xsl:if>
	<cms:entry type=":first" part="{$selected-part/../*[1]/@id}.html"/>
	<cms:entry type=":last" part="{$selected-part/../*[last()]/@id}.html"/>
	<xsl:if test="//back/@id">
		<cms:entry type=":appendix" part="{//back/@id}.html"/>
	</xsl:if>
	<cms:entry type=":lang"><xsl:value-of select="$LANG"/></cms:entry-->
</xsl:template>

<!--===============================================================-->
<xsl:template name="createFront">
	<front>
    		<xsl:copy-of select="@*"/>		
		<xsl:apply-templates select="/etd/front/*"/>
    		<xsl:call-template name="TableOfContents"/>
    		<xsl:if test="//table">
			<xsl:call-template name="TableOfTables"/>
		</xsl:if>
		<xsl:if test="//im | //mm">
			<xsl:call-template name="TableOfMedias"/>
		</xsl:if>	
		<xsl:if test="//example">
			<xsl:call-template name="TableOfExamples"/>
		</xsl:if>	
    	</front>	    		
</xsl:template>

<!--== Create Tables ==-->
<xsl:variable name="TOC_DEPTH">99</xsl:variable>

<!-- TODO: bibliography mit mehreren parts -->
  
<xsl:template name="TableOfContents">
	<freehead><xsl:value-of select="$VOCABLES/toc/@*[name()=$LANG]"/></freehead>
    	<ul>
     	<xsl:apply-templates select="/etd/body/*" mode="TableOfContents">
    			<xsl:with-param name="toc-depth" select="$TOC_DEPTH"/>
		</xsl:apply-templates>
      	<xsl:apply-templates select="/etd/back/*" mode="TableOfContents">
    			<xsl:with-param name="toc-depth" select="$TOC_DEPTH"/>
		</xsl:apply-templates>
	</ul>	
</xsl:template>

<xsl:template name="TableOfTables">
	<freehead>Tabellen</freehead>
	<ul>
      	<xsl:apply-templates select="//table" mode="TableOfContents"/>
	</ul>
</xsl:template>

<xsl:template name="TableOfMedias">
	<freehead>Bilder und andere Medien</freehead>
	<ul>
      	<xsl:apply-templates select="//mm" mode="TableOfContents"/>
	</ul>
</xsl:template>

<xsl:template name="TableOfExamples">
	<freehead>Beispiele</freehead>
	<ul>
      	<xsl:apply-templates select="//example" mode="TableOfContents"/>
	</ul>
</xsl:template>

<xsl:template match="abbreviation|preface|summary|acknowledgement|declaration|glossary|bibliography|vita" mode="TableOfContents">
  <li>
    <link ref="{@id}">
      <xsl:apply-templates select="head" mode="TableOfContents"/>
    </link>
  </li>  
</xsl:template>

<xsl:template match="resources" mode="TableOfContents">
  <xsl:param name="toc-depth">0</xsl:param>
  <xsl:call-template name="toc-entry">
    <xsl:with-param name="toc-depth" select="$toc-depth"/>
    <xsl:with-param name="subelements" select="part"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="appendix" mode="TableOfContents">
  <xsl:param name="toc-depth">0</xsl:param>
  <xsl:call-template name="toc-entry">
    <xsl:with-param name="toc-depth" select="$toc-depth"/>
    <xsl:with-param name="subelements" select="bibliography|resources|glossary|appendix|abbreviation|part"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="frame" mode="TableOfContents">
  <xsl:param name="toc-depth">0</xsl:param>
  <xsl:call-template name="toc-entry">
    <xsl:with-param name="toc-depth" select="$toc-depth"/>
    <xsl:with-param name="subelements" select="part|chapter"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="chapter" mode="TableOfContents">
  <xsl:param name="toc-depth">0</xsl:param>
  <xsl:call-template name="toc-entry">
    <xsl:with-param name="toc-depth" select="$toc-depth"/>
    <xsl:with-param name="subelements" select="section"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="section" mode="TableOfContents">
  <xsl:param name="toc-depth">0</xsl:param>
  <xsl:call-template name="toc-entry">
    <xsl:with-param name="toc-depth" select="$toc-depth"/>
    <xsl:with-param name="subelements" select="subsection"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="subsection" mode="TableOfContents">
  <xsl:param name="toc-depth">0</xsl:param>
  <xsl:call-template name="toc-entry">
    <xsl:with-param name="toc-depth" select="$toc-depth"/>
    <xsl:with-param name="subelements" select="block"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="block" mode="TableOfContents">
  <xsl:param name="toc-depth">0</xsl:param>
  <xsl:call-template name="toc-entry">
    <xsl:with-param name="toc-depth" select="$toc-depth"/>
    <xsl:with-param name="subelements" select="subblock"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="subblock|part|resources" mode="TableOfContents">
  <xsl:param name="toc-depth">0</xsl:param>
  <xsl:call-template name="toc-entry">
    <xsl:with-param name="toc-depth" select="$toc-depth"/>
    <xsl:with-param name="subelements" select="part"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="toc-entry">
  <xsl:param name="toc-depth">0</xsl:param>
  <xsl:param name="subelements"/>
  <li>
  	<p>
  	<link ref="{@id}">
  		<xsl:apply-templates select="head" mode="TableOfContents"/>
  	</link>
    <xsl:if test="$toc-depth>0 and $subelements">
    	<ul>        
        <xsl:apply-templates select="$subelements" mode="TableOfContents">
          <xsl:with-param name="toc-depth">
            <xsl:value-of select="$toc-depth - 1"/>
          </xsl:with-param>
        </xsl:apply-templates>
      </ul>
    </xsl:if>
    </p>
  </li>  
</xsl:template>

<xsl:template match="mm|table|example" mode="TableOfContents">
	<li>
   		<p>
   			<link ref="{@id}">
   				<xsl:value-of select="name()"/>
   				<xsl:text>: </xsl:text>
     			<xsl:apply-templates select="caption" mode="TableOfContents" />
     		</link>
     	</p>
	</li>
</xsl:template>

<xsl:template match="head" mode="TableOfContents">
	<xsl:value-of select="."/>
</xsl:template>

<xsl:template match="caption" mode="TableOfContents">
	<xsl:value-of select="."/>
</xsl:template>

<xsl:template match="*" mode="TableOfContents"/>

<!--== templates that are functions/tools ==-->

<!-- generate attribute id and attribute part for a cms:entry element -->
<xsl:template name="entry-id-attributes">
  <!--xsl:message>entry-id-attributes</xsl:message-->
	<!-- HIER UNTERSCHIEDE ZWISCHEN CITRIX3 und LOKAL -->
	  <!--xsl:variable name="part" select="ancestor-or-self::*[@id=$parts/@id][1]/@id"/-->

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

<!--===== copy the rest =====-->
<xsl:template match="@*|node()">
	<xsl:copy>		
		<xsl:apply-templates select="@*|node()"/>
	</xsl:copy>
</xsl:template>
</xsl:stylesheet>