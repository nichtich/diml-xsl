<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--                                                 -->
<!--     Default case (if not called otherwise)      -->
<!--                                                 -->

<xsl:template match="pagenumber" name="pagenumber-simple">
  <!-- 1. do not create a pagenumbers in tables and citations         -->
  <!--    (but create "a name")                                       -->
  <!--    pagenumbers in tables will be shown in a combined way       -->
  <!--    at the beginning of a table                                 -->
  <!-- 2. create "a name"-Element only if "id" exists                 -->
  <!-- 3. do not create pagenumbers in head here                      -->

 <xsl:choose>
<!--    <xsl:when test="ancestor::head">
    </xsl:when>-->
    <xsl:when test="ancestor::table">
      <a name="{@id}"></a>
    </xsl:when>
    <xsl:when test="ancestor::citation">
      <!-- no ID, will be generated with hline-pagenumber -->
      <!-- at beginning of citation -->
    </xsl:when>
    <xsl:when test="@id">
      <a name="{@id}"><xsl:call-template name="pagenumber-content"/></a>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="pagenumber-content"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- Content of a pagenumber from "span" to "/span"               -->
<!-- that means "a name" and seperation line are not created here -->
<xsl:template name="pagenumber-content">
  <span class="pagenumber">
    <xsl:value-of select="$CONFIG/pagenumber[@lang=$LANG]/@before"/>
    <xsl:value-of select="@system"/>
    <xsl:call-template name="pnumber" />
    <xsl:value-of select="$CONFIG/pagenumber[@lang=$LANG]/@after"/>
  </span>
</xsl:template>

<!-- create the number of a pagenumber                            -->
<!-- first use label, otherwise use number created out of "start" -->
<xsl:template match="pagenumber" mode="number" name="pnumber">
  <xsl:choose>

      <!-- 1. create simply out of @label (should be provided by preprocess.xsl)-->
      <xsl:when test="@label">
        <xsl:value-of select="@label"/>
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
    
      </xsl:when>

      <!-- otherwise: use consecutive number of pagenumber -->
      <xsl:otherwise>
        <xsl:value-of select="count(preceding::pagenumber)+1"/>
      </xsl:otherwise>

    </xsl:choose>

</xsl:template>

<!-- will be called for creating a seperation line                 -->
<!-- though, a seperation line is never created in a table or list -->
<xsl:template name="pagenumber-hline">
   <xsl:choose>
     <xsl:when test="not(ancestor::table or ancestor::li or ancestor::ol or ancestor::ul or ancestor::dl)">
         <table width="100%" border="0">
          <tr>
            <td width="100%"><hr/></td>
            <td><xsl:call-template name="pagenumber-simple"/></td>
          </tr>  
        </table>
     </xsl:when>
     <xsl:otherwise>
            <xsl:call-template name="pagenumber-simple"/>
     </xsl:otherwise>
   </xsl:choose>
</xsl:template>

<!-- ignore pagenumbers in "head" (is called from "module-structure"
     respectivly from all elements that may contain element "head") -->
<xsl:template match="head/pagenumber" />

<!-- will be handled in preceding citation element -->
<xsl:template match="bibliography/citation//pagenumber" />

<!-- first pagenumber without preceeding text will be called from "p" -->
<xsl:template match="p/pagenumber[count(preceding-sibling::*)=0][normalize-space(preceding-sibling::text())='']"/>

<!-- first pagenumber without preceeding text will be called -->
<!-- from "li" element preceeding the actual "li" element    -->
<xsl:template match="li/pagenumber[count(preceding-sibling::*)=0][normalize-space(preceding-sibling::text())='']"/> 

<!-- first pagenumber without preceeding text in "li" can be -->
<!-- forced to output, e.g. when called from preceding "li"  -->
<xsl:template match="li//pagenumber[count(preceding-sibling::*)=0][normalize-space(preceding-sibling::text())='']" mode="forceOutput"> 
  <xsl:call-template name="pagenumber-simple"/>
</xsl:template>


<!-- special elements with separation line -->
<xsl:template match="front/pagenumber|submission/pagenumber|
                     dedication/pagenumber|vita/pagenumber|
                     footnote/pagenumber|endnote/pagenumber|
                     entry/pagenumber|glossary/pagenumber">
   <xsl:call-template name="pagenumber-hline"/>
</xsl:template>

<!-- special elements with separation line              -->
<!-- where "pagenumber" is not allowed according to DTD -->
<xsl:template match="body/pagenumber|back/pagenumber|
                     abstract/pagenumber|approvals/pagenumber|
                     grant/pagenumber|copyright/pagenumber|
                     abbreviation/pagenumber|preface/pagenumber|
                     summary/pagenumber|frame/pagenumber|
                     resources/pagenumber|appendix/pagenumber|
                     bibliography/pagenumber|
                     acknowledgement/pagenumber|declaration/pagenumber|
                     motto/pagenumber">
   <xsl:call-template name="pagenumber-hline"/>
</xsl:template>

<!-- pagenumbers that are direct childs of chapter, section etc. -->
<!-- will be created with a seperation line                      -->
<xsl:template match="chapter/pagenumber|section/pagenumber|subsection/pagenumber|subblock/pagenumber|block/pagenumber|part/pagenumber">
   <xsl:call-template name="pagenumber-hline"/>
</xsl:template>

<!-- this one is called e.g. from "p" to create first pagenumber -->
<!-- without preceeding text with a seperation line              -->
<xsl:template match="pagenumber" mode="hline">
   <xsl:call-template name="pagenumber-hline"/>
</xsl:template>

<!-- this will print pagenumbers included in a table or list etc.  -->
<!-- in a combined way at the begin of this table, list etc.       -->
<!-- Achtung: Am Anfang von Listen wird momentan keine Zusammenfassung ausgegeben -->

<xsl:template name="more-pagenumbers-inside">
<xsl:param name="additionalMessage"/>
<xsl:variable name="isRange" select="count(descendant::pagenumber) &gt; 1"/>
  <xsl:variable name="myConfig" select="$CONFIG/pagenumber[@lang=$LANG]"/>
  <table width="100%" border="0">
    <tr>
      <td width="100%"><hr/></td>
      <td class="pagenumber">
        <nobr>
          <xsl:for-each select="descendant::pagenumber">
            <a name="{@id}"></a>
          </xsl:for-each>
          <xsl:choose>
            <xsl:when test="$isRange and $myConfig/@before2">
              <xsl:value-of select="$myConfig/@before2"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$myConfig/@before"/>
            </xsl:otherwise>
          </xsl:choose>
          
          <xsl:value-of select="$additionalMessage"/>
              
          <xsl:choose>
            <xsl:when test="$isRange">              	 	
              <xsl:apply-templates select="descendant::pagenumber[1]" mode="number" />
                <xsl:value-of select="$myConfig/@between"/> 
                <xsl:apply-templates select="descendant::pagenumber[position()=last()]" mode="number" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="descendant::pagenumber[1]" mode="number" />
            </xsl:otherwise>
          </xsl:choose> 				
            <xsl:value-of select="$myConfig/@after"/>
        </nobr>
      </td>         
    </tr>
  </table>
</xsl:template>

</xsl:stylesheet>
