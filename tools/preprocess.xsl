<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cms="http://edoc.hu-berlin.de/diml/module/cms"
exclude-result-prefixes="cms">

<xsl:include href="functions.xsl"/>

<!-- TODO: number citation if desired (set @label) -->

<xsl:param name="CONFIGFILE">config.xml</xsl:param>
<xsl:param name="ENDNOTESBIB">false</xsl:param>
<xsl:variable name="CONFIG" select="document($CONFIGFILE)/config"/>
<xsl:variable name="VOCABLES" select="document($CONFIGFILE)/config/vocables"/>

<xsl:param name="LANG">
  <xsl:choose>
    <xsl:when test="string(/etd/@lang)!=''">
      <xsl:value-of select="/etd/@lang"/>
    </xsl:when>
    <xsl:when test="/cms:container/cms:document/cms:meta/cms:entry[@type=':lang']">
      <xsl:value-of select="/cms:container/cms:document/cms:meta/cms:entry[@type=':lang']"/>
    </xsl:when>
    <xsl:otherwise>en</xsl:otherwise>
  </xsl:choose>
</xsl:param>

<xsl:key name="id" match="*" use="@id"/>

<!--== add id attribute if missing ==-->
<xsl:template name="provide-id">
	<xsl:param name="suggest"/>
	<xsl:attribute name="id">
		<xsl:choose>
			<xsl:when test="@id and @id!=''">
				<xsl:value-of select="@id"/>
			</xsl:when>
			<xsl:when test="$suggest!='' and not(key('id',$suggest))">
				<xsl:value-of select="$suggest"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="generate-id()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:attribute>	
</xsl:template>

<!--== convert entity references in <mm> into file references ==-->

<xsl:template name="entity-to-filename">
	<xsl:param name="file" select="unparsed-entity-uri(@entity)"/>
	<xsl:choose>
		<xsl:when test="contains($file,'/')">
			<xsl:call-template name="entity-to-filename">
				<xsl:with-param name="file" select="substring-after($file,'/')"/>
			</xsl:call-template>			
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$file"/>
		</xsl:otherwise>		
	</xsl:choose>
</xsl:template>

<!--== add missing pagenumber labels ==-->
<xsl:template match="pagenumber">
	<pagenumber>
		<xsl:call-template name="provide-id"/>
		<xsl:attribute name="label">
		<xsl:choose>

                  <!-- 1. if exists @label, use it -->
                  <xsl:when test="@label">
                    <xsl:copy-of select="@label"/>
                  </xsl:when>

                  <!-- 2. create number out of @start formatted with @numbering -->
                  <xsl:when test="@start">
      
                    <!-- use template "number" in tools/functions.xsl -->
                    <xsl:call-template name="number">
                      <xsl:with-param name="number" select="@start"/>
                      <xsl:with-param name="numbering" select="@numbering"/>
                    </xsl:call-template>
        
                  </xsl:when>

                  <!-- 3rd: count from previous pagenumber with @start, use @numbering -->
                  <xsl:when test="preceding::pagenumber[@start]">
    
                      <!-- use template "number" in tools/functions.xsl -->
                      <xsl:call-template name="number">
                        <xsl:with-param name="number" select="preceding::pagenumber[@start][position()=1]/@start + count(preceding::pagenumber) - count(preceding::pagenumber[@start][position()=1]/preceding::pagenumber)"/>
                        <xsl:with-param name="numbering" select="@numbering"/>
                      </xsl:call-template>
                      <xsl:message>preprocess.xsl says: Warning! Pagenumber has no attribute start and label. Count from previous pagenumber with attribute start.</xsl:message>

                  </xsl:when>

                  <!-- otherwise: use consecutive number of pagenumber -->
                  <xsl:otherwise>
                    <xsl:value-of select="count(preceding::pagenumber)+1"/>
                    <xsl:message>preprocess.xsl says: Warning! Pagenumber has no attribute start and label. Count total number of pagenumbers.</xsl:message>
                  </xsl:otherwise>

		</xsl:choose>
		</xsl:attribute>
		<xsl:apply-templates select="@*|node()"/>					
	</pagenumber>
</xsl:template>

<xsl:template match="im|mm">
	<xsl:element name="{name()}">
		<xsl:call-template name="provide-id"/>
		<xsl:if test="@entity">
			<xsl:attribute name="file">
				<xsl:call-template name="entity-to-filename"/>				
			</xsl:attribute>
		</xsl:if>
		<xsl:apply-templates select="@*|node()"/>		
	</xsl:element>
</xsl:template>

<xsl:template name="numbering">
	<xsl:variable name="name" select="name()"/>
	<xsl:variable name="generate" select="$CONFIG/generate[@of=$name][@numbering][1]"/>
	<xsl:if test="$generate and (not(@label) or $generate/@force='yes')">
		<xsl:attribute name="label">
			<xsl:value-of select="$generate/@beforeLabel"/>
			<xsl:apply-templates select="." mode="numberingLabel"/>
			<xsl:value-of select="$generate/@afterLabel"/>			
		</xsl:attribute>
	</xsl:if>	
</xsl:template>


<xsl:template match="front">
	<xsl:copy>		
		<xsl:variable name="name" select="name()"/>
		<xsl:call-template name="provide-id">
			<xsl:with-param name="suggest">front</xsl:with-param>
		</xsl:call-template>
		<xsl:apply-templates select="@*|node()"/>	
		<!-- TODO: if there are no chapters etc. this will result in an error (empty list)! -->
		<!--xsl:if test="$CONFIG/toc[@generate='yes']">
		  <p>
		    <freehead id=":contents"><xsl:value-of select="$CONFIG/toc/title[@lang=$LANG]"/></freehead>
		    <ul>		    	 
		      <xsl:apply-templates select="/*" mode="toc"/>
		    </ul> 
		  </p>
		</xsl:if-->
	</xsl:copy>		
</xsl:template>

<xsl:template match="section | subsection | block | subblock | part">
	<xsl:copy>
		<xsl:call-template name="provide-id"/>
		<xsl:call-template name="numbering"/>
		<xsl:apply-templates select="@*|node()"/>
	</xsl:copy>
</xsl:template>

<xsl:template match="chapter | frame">
	<xsl:variable name="name" select="name()"/>
	<xsl:copy>
		<xsl:call-template name="provide-id">
			<xsl:with-param name="suggest">
				<xsl:value-of select="name()"/>
				<xsl:value-of select="count(preceding-sibling::*[name()=$name]) + 1"/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="numbering"/>
		<xsl:apply-templates select="@*|node()"/>
	</xsl:copy>
</xsl:template>

<xsl:template match="table | example">
	<xsl:copy>		
		<xsl:call-template name="provide-id"/>		
		<xsl:apply-templates select="@*|node()"/>
	</xsl:copy>
</xsl:template>

<!--== Table of contents ==-->
<!--xsl:template match="etd" mode="toc">
  <xsl:apply-templates select="body/*" mode="toc"/>
  <xsl:apply-templates select="back/*" mode="toc"/>
</xsl:template>

<xsl:template match="*" mode="toc">
  <xsl:variable name="myConfig" select="$CONFIG/toc/*[name()=current()/name()]"/>
  <xsl:if test="$myConfig">
    <li>
    </li>
    <xsl:choose>
      <xsl:when test="$myConfig/@indent='yes'">
      </xsl:when>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<xsl:template match="section" mode="toclabel">
  <xsl:variable name="myConfig" select="$CONFIG/toc/*[name()=current()/name()]"/>

</xsl:template>

    <chapter hidelabel="no" indent="yes"/>
    <section hidelabel="no" indent="yes"/>

<xsl:template match="*" mode="toc"/>

<xsl:template match="*" mode="toclabel">
  <link ref="{@id}">
    <xsl:if test="@label and not($CONFIG/toc/*[name()=$name and @hidelabel='yes'])">
	  		<xsl:value-of select="@label"/>
	  		<xsl:text>&#xA0;</xsl:text>
    </xsl:if>	
    <xsl:apply-templates select="head" mode="TableOfContents"/>
  </link>
</xsl:template-->

<!--== Test color names ==-->
<xsl:template match="em/@color">
  <xsl:copy/>
  <xsl:if test="translate(.,'0123456789ABCDEabcdef','FFFFFFFFFFFFFFFFFFFFF')!='#FFFFFF'">
  	<xsl:message>
  		<xsl:text>Attribute @color (</xsl:text>
  		<xsl:value-of select="."/>
  		<xsl:text>) of element em must match "#FFFFFF"</xsl:text>
  	</xsl:message>
  </xsl:if>
</xsl:template>

<!--xsl:template match="citation">
	<xsl:copy>		
		<xsl:if test="not(@label)">
			<xsl:if test="cut">
				<xsl:attribute name="label">
					<xsl:value-of select="cut"/>
				</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:apply-templates select="@*|node()"/>
	</xsl:copy>
</xsl:template-->

<!-- no p around single citations in bibliography -->
<xsl:template match="bibliography/p[citation and count(*)=1 and normalize-space(text())='']">
	<xsl:apply-templates/>
</xsl:template>


<!--== helper for add bibliographie for endnotes if missing ==-->

<xsl:template match="endnote">
<xsl:choose>

  <xsl:when test="$ENDNOTESBIB='true'">
     <link id="{concat(generate-id(),'link')}"></link>
       <link ref="{generate-id()}">
         <xsl:apply-templates select="." mode="label"/>
       </link>  
   </xsl:when>

   <xsl:otherwise>
   <xsl:copy-of select=".">
   </xsl:copy-of>
   </xsl:otherwise>
</xsl:choose>
</xsl:template>

<!--== helper for add bibliographie for endnotes if missing ==-->

<xsl:template match="endnote" mode="label">
  <sup class="footnotelabel"><xsl:value-of select="count(preceding::endnote)+1"/></sup>
</xsl:template>

<!--== helper for add bibliographie for endnotes if missing ==-->

<xsl:template match="endnote" mode="foot">
  <p>
      <link id="{generate-id()}"></link>
      <link ref="{concat(generate-id(),'link')}">
        <xsl:apply-templates select="." mode="label"/>
      </link>  
    <xsl:text>&#xA0;</xsl:text>    
    <xsl:choose>
      <xsl:when test="count(*)=1 and p">
        <xsl:apply-templates select="p/*|p/text()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </p>  
</xsl:template>

<!--== add bibliographie for endnotes if missing ==-->

<xsl:template match="back">
<xsl:element name="back">
   <xsl:call-template name="provide-id" />

<xsl:if test="$ENDNOTESBIB='true'">
   <xsl:if test="/etd/body//endnote and not(bibliography[@id='endnotebibliography'])">
      <bibliography id="endnotebibliography">
        <head><xsl:value-of select="$VOCABLES/bibliography/@*[name()=$LANG]" /></head>
        <xsl:apply-templates select="//endnote" mode="foot"/>
      </bibliography>
   </xsl:if>
</xsl:if>

   <!-- other elements in back -->
   <xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:template>


<!--==Strip additional labels==-->
<!-- don't strip additional labels anymore -->
<!-- see module-diml/dean.xsl              -->
<!--
<xsl:template match="dean/text()[1]">
  <xsl:choose>
    <xsl:when test="substring(.,1,6)='Dekan:'">
      <xsl:value-of select="substring(.,7)"/>    
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="."/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
-->

<!--===== copy the rest =====-->
<xsl:template match="@*|node()">
	<xsl:copy>		
		<xsl:if test="parent::back | parent::body | parent:: appendix">
			<xsl:call-template name="provide-id">
				<!--xsl:with-param name=""/>-->
			</xsl:call-template>
		</xsl:if>
		<xsl:apply-templates select="@*|node()"/>
	</xsl:copy>
</xsl:template>

<!-- element in "front" that need an id and is not otherwise handled -->
<xsl:template match="dedication">
	<xsl:copy>		
		<xsl:call-template name="provide-id"/>
		<xsl:apply-templates select="@*|node()"/>
	</xsl:copy>
</xsl:template>

<!-- the following elements in "front" don't need an id, because there  -->
<!-- is no link to them. and because creating a "head" in the           -->
<!-- html-version is not mandatory bringing an id to html would be      -->
<!-- difficult anyway:                                                  -->

<!-- copyright, grant, abstract                                         -->

</xsl:stylesheet>
