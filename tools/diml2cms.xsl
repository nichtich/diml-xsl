<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:cms="http://edoc.hu-berlin.de/diml/module/cms">

<xsl:include href="functions.xsl"/>

<xsl:param name="CONFIGFILE">config.xml</xsl:param>
<xsl:variable name="CONFIG" select="document($CONFIGFILE)/config"/>
<xsl:variable name="VOCABLES" select="document($CONFIGFILE)/config/vocables"/>

<xsl:output method="xml" indent="yes"/>

<xsl:key name="id" match="*" use="@id"/>

<!-- id of the element we want to see -->
<xsl:param name="SELECTID"/>

<xsl:param name="LANG">
   <xsl:choose>
      <xsl:when test="/etd/@lang"><xsl:value-of select="/etd/@lang"/></xsl:when>
      <xsl:otherwise>de</xsl:otherwise>
   </xsl:choose>
</xsl:param>

<!-- parts of the document that may be content of the container --> 
<xsl:variable name="parts" select="/etd/front|/etd/body/*|/etd/back/*"/>

<!--               -->
<!-- ROOT template -->
<!--               -->
<xsl:template match="/">
  <xsl:variable name="selected-part" select="//*[@id=$SELECTID]"/>  
  <xsl:if test="not($selected-part)">
    <xsl:message terminate="yes">
       No SELECTID or element of SELECTID=<xsl:value-of select="$SELECTID"/> not found!
    </xsl:message>
  </xsl:if>
  <xsl:if test="key('id',':toc') or key('id',':toc-media') or key('id',':toc-tables') or key('id',':toc-examples')">
     <xsl:message terminate="yes">
      id value :toc, :toc-media, :toc-tables or :toc-examples already set!
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
    <xsl:apply-templates select="node()" mode="navtitle" />
  </cms:entry>
  <xsl:apply-templates mode="cms"/>
</xsl:template>

<!-- helper for copying heads to toc: copy elements, omit some -->
<xsl:template match="@*|node()" priority="-1" mode="navtitle">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()" mode="navtitle"/>
  </xsl:copy>  
</xsl:template>
      
<!-- helper for copying heads to toc: convert "br" to space -->
<xsl:template match="br" mode="navtitle"><xsl:text>&#xA0;</xsl:text></xsl:template>

<xsl:template match="front/author" mode="cms">
  <cms:entry type="author">
     <xsl:choose>
       <xsl:when test="given|surname">
           <xsl:value-of select="given"/>
           <xsl:text> </xsl:text>
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
   </xsl:if-->
   <cms:entry type=":lang"><xsl:value-of select="$LANG"/></cms:entry>
   
   <cms:entry type=":contents" ref=":contents">
      <xsl:if test="$SELECTID != /etd/front/@id">
        <xsl:attribute name="id">:contents</xsl:attribute>
        <xsl:attribute name="part"><xsl:value-of select="/etd/front/@id"/></xsl:attribute>
      </xsl:if>      
      <xsl:value-of select="$CONFIG/toc/title[@lang=$LANG]"/>
   </cms:entry>
   
   <xsl:if test="$CONFIG/helpLink[@lang=$LANG]">
     <cms:entry type=":help">
        <url href="{$CONFIG/helpLink[@lang=$LANG]/@href}">
          <xsl:value-of select="$CONFIG/helpLink[@lang=$LANG]"/>
        </url>
     </cms:entry>
   </xsl:if>

   <xsl:if test="$CONFIG/searchLink[@lang=$LANG]">
     <cms:entry type=":search">
        <url href="{$CONFIG/searchLink[@lang=$LANG]/@href}">
          <xsl:value-of select="$CONFIG/searchLink[@lang=$LANG]"/>
        </url>
     </cms:entry>
   </xsl:if>   
   
</xsl:template>


<!--===============================================================-->
<!--===================== Create Front ============================-->
<!--===============================================================-->

<xsl:template name="createFront">
   <front>
      <xsl:copy-of select="/etd/front/@*"/>
      <xsl:apply-templates select="/etd/front/*"/>
      <xsl:call-template name="TableOfContents"/>
      <xsl:if test="//table[caption]">
        <xsl:call-template name="TableOfTables"/>
      </xsl:if>
      <xsl:if test="//im[caption] | //mm[caption]">
        <xsl:call-template name="TableOfMedias"/>
      </xsl:if>   
      <xsl:if test="//example[caption]">
        <xsl:call-template name="TableOfExamples"/>
      </xsl:if>   
       </front>             
</xsl:template>


<!--===============================================================-->
<!--===================== Create Tables ===========================-->
<!--===============================================================-->

<!-- TODO: bibliography mit mehreren parts -->
  
<xsl:template name="TableOfContents">
   <freehead id=":contents"><xsl:value-of select="$CONFIG/toc/title[@lang=$LANG]"/></freehead>
   <ul>
     <xsl:apply-templates select="/etd/body/*" mode="TableOfContents"/>
     <xsl:apply-templates select="/etd/back/*" mode="TableOfContents"/>
   </ul>   
</xsl:template>

<xsl:template name="TableOfTables">
   <freehead id=":toc-tables"><xsl:value-of select="$VOCABLES/toc-tables/@*[name()=$LANG]"/></freehead>
   <ul>
      <xsl:apply-templates select="//table" mode="TableOfContents"/>
   </ul>
</xsl:template>

<xsl:template name="TableOfMedias">
   <freehead id=":toc-media"><xsl:value-of select="$VOCABLES/toc-media/@*[name()=$LANG]"/></freehead>
   <ul>
      <xsl:apply-templates select="//mm" mode="TableOfContents"/>
   </ul>
</xsl:template>

<xsl:template name="TableOfExamples">
   <freehead id=":toc-examples"><xsl:value-of select="$VOCABLES/toc-examples/@*[name()=$LANG]"/></freehead>
   <ul>
      <xsl:apply-templates select="//example" mode="TableOfContents"/>
   </ul>
</xsl:template>

<!--                                                           -->
<!--         Elements of TOC                                   -->
<!--                                                           -->

<xsl:template match="abbreviation|preface|summary|acknowledgement|declaration|glossary|bibliography|vita" mode="TableOfContents">
  <xsl:call-template name="toc-entry">
    <xsl:with-param name="subelements" select="part"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="appendix" mode="TableOfContents">
  <xsl:call-template name="toc-entry">
    <xsl:with-param name="subelements" select="bibliography|resources|glossary|appendix|abbreviation|part"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="frame" mode="TableOfContents">
  <xsl:call-template name="toc-entry">
    <xsl:with-param name="subelements" select="part|chapter"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="chapter" mode="TableOfContents">
  <xsl:call-template name="toc-entry">
    <xsl:with-param name="subelements" select="section"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="section" mode="TableOfContents">
  <xsl:call-template name="toc-entry">
    <xsl:with-param name="subelements" select="subsection"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="subsection" mode="TableOfContents">
  <xsl:call-template name="toc-entry">
    <xsl:with-param name="subelements" select="block"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="block" mode="TableOfContents">
  <xsl:call-template name="toc-entry">
    <xsl:with-param name="subelements" select="subblock"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="subblock|resources" mode="TableOfContents">
  <xsl:call-template name="toc-entry">
    <xsl:with-param name="subelements" select="part"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="part" mode="TableOfContents">
  <xsl:if test="ancestor::subsection or (head and not(head=''))">
    <xsl:call-template name="toc-entry">
      <xsl:with-param name="subelements" select="part"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template name="toc-entry">
  <xsl:param name="subelements"/>
  <xsl:variable name="name" select="name()"/>  
  <xsl:variable name="subname" select="name($subelements[1])"/>
  <xsl:variable name="has-label" select="@label and not($CONFIG/toc/*[name()=$name and @hidelabel='yes'])"/>
  
  <li>
    <p>
      <xsl:choose>
      <xsl:when test="$has-label">
        <xsl:choose>
        <xsl:when test="@label=''">
          <link ref="{@id}">
            <xsl:apply-templates select="head" mode="TableOfContents"/>
          </link>
        </xsl:when>  
        <xsl:otherwise>
          <link ref="{@id}">
            <xsl:value-of select="@label"/>
          </link>
          <xsl:text>&#xA0;</xsl:text>
          <xsl:apply-templates select="head" mode="TableOfContents"/>
        </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <link ref="{@id}">
          <!-- if no head, write out terms for element in config.xml -->
          <xsl:choose>
            <xsl:when test="head and not(head='')">
              <xsl:apply-templates select="head" mode="TableOfContents"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:variable name="name" select="name()"/>
              <xsl:value-of select="$VOCABLES/node()[name()=$name]/@*[name()=$LANG]"/>
            </xsl:otherwise>
          </xsl:choose>
        </link>
      </xsl:otherwise>
      </xsl:choose>
        <xsl:if test="$subelements and not($CONFIG/toc/*[name()=$subname and @indent='no'])">
          <ul>
            <xsl:apply-templates select="$subelements" mode="TableOfContents"/>
         </ul>
        </xsl:if>
    </p>
  </li>  
    <xsl:if test="$subelements and $CONFIG/toc/*[name()=$subname and @indent='no']">
        <xsl:apply-templates select="$subelements" mode="TableOfContents"/>
    </xsl:if>  
</xsl:template>

<xsl:template match="mm|table|example" mode="TableOfContents">
   <xsl:if test="string(caption)">
      <li>
        <p>
          <link ref="{@id}">
            <xsl:apply-templates select="caption" mode="TableOfContents" />
          </link>
        </p>
      </li>
   </xsl:if>
</xsl:template>

<!-- Content of Head for Table of Contents       -->
<!-- Do not print footnotes, endnotes, pagenumbers or brs in heading -->

<xsl:template match="head | caption" mode="TableOfContents">
  <xsl:for-each select="node()[not(name()='footnote') and not(name()='endnote') and not(name()='pagenumber')]">

    <!-- old version: only copy content of head to toc-head -->
    <!-- <xsl:value-of select="."/> -->
    
    <!-- new: copy elements to toc-head, omit "br" and other elements -->
    <xsl:apply-templates select="." mode="tochead" />
    
  </xsl:for-each>

</xsl:template>

<!-- helper for copying heads to toc: copy elements, omit some -->
<xsl:template match="@*|node()" priority="-1" mode="tochead">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>
      
<!-- helper for copying heads to toc: convert "br" to space -->
<xsl:template match="br" mode="tochead"><xsl:text>&#xA0;</xsl:text></xsl:template>

<!-- helper for copying heads to toc: omit some elements -->
<xsl:template match="footnote | endnote | pagenumber" />

<xsl:template match="*" mode="TableOfContents"/>

<!--== templates that are functions/tools ==-->

<!-- generate attribute id and attribute part for a cms:entry element -->
<xsl:template name="entry-id-attributes">
    <!-- this is a work around to calcualte $parts --> 
   <xsl:if test="count($parts)&lt;1"><xsl:message>the document contains no parts</xsl:message></xsl:if>
  <xsl:variable name="part" select="ancestor-or-self::*[@id=$parts/@id][1]/@id"/>
  <xsl:if test="$SELECTID!=$part">
      <xsl:attribute name="id">
        <xsl:value-of select="@id"/>
      </xsl:attribute>
      <xsl:attribute name="part">
        <xsl:value-of select="$part"/>
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

<!--===============================================================-->
<xsl:template match="*" mode="strip-ids">
   <xsl:copy>      
      <xsl:apply-templates select="@*|node()" mode="strip-id"/>
   </xsl:copy>
</xsl:template>

<xsl:template match="@id" mode="strip-id"/>

<!--===== copy the rest =====-->
<xsl:template match="@*|node()">
   <xsl:copy>      
      <xsl:apply-templates select="@*|node()"/>
   </xsl:copy>
</xsl:template>

</xsl:stylesheet>