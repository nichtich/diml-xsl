<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- will be called for creating a seperation line                 -->
<!-- though, a seperation line is never created in a table or list -->
<!-- is called from "p" to create first citenumber -->

<xsl:template match="citenumber" mode="hline" name="citenumber-hline">
   <xsl:choose>
     <xsl:when test="not(ancestor::table or ancestor::li or ancestor::ol or ancestor::ul or ancestor::dl)">
       <table width="100%" border="0">
       <tr>
       <td width="100%"></td>
       <td><xsl:call-template name="citenumber-simple"/></td>
       </tr>
       </table>
     </xsl:when>
     <xsl:otherwise>
            <xsl:call-template name="citenumber-simple"/>
     </xsl:otherwise>
   </xsl:choose>
</xsl:template>


  <!-- 1. do not create a citenumber in tables and citations          -->
  <!--    (but create "a name")                                       -->
  <!--    citenumber in tables will be shown in a combined way        -->
  <!--    at the beginning of a table                                 -->
  <!-- 2. create "a name"-Element only if "id" exists                 -->
  <!-- 3. do not create citenumbers in head here                      -->
  
  <!--     Default case (if not called otherwise)      -->

<xsl:template match="citenumber" name="citenumber-simple">
 <xsl:choose>
    <xsl:when test="ancestor::table">
      <a name="{@id}"></a>
    </xsl:when>
    <xsl:when test="ancestor::citation">
      <!-- no ID, will be generated with citenumber-hline -->
      <!-- at beginning of citation -->
    </xsl:when>
    <xsl:when test="@id">
      <a name="{@id}"><xsl:call-template name="citenumber-content"/></a>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="citenumber-content"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- Content of a citenumber from "span" to "/span"               -->
<!-- that means "a name" and seperation line are not created here -->

<xsl:template name="citenumber-content">
  <span class="pagenumber">
    <xsl:value-of select="$CONFIG/citenumber[@lang=$LANG]/@before"/>
    <xsl:value-of select="@system"/>
    <xsl:call-template name="cnumber" />
    <xsl:value-of select="$CONFIG/citenumber[@lang=$LANG]/@after"/>
    <xsl:if test="@helper='true'">
      <xsl:value-of select="$CONFIG/citenumber[@lang=$LANG]/@continued"/>
    </xsl:if>
  </span>
</xsl:template>

<!-- create only the number of a citenumber                       -->
<!-- first use label, otherwise use number created out of "start" -->

<xsl:template name="cnumber">
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

      <!-- 3rd: count from previous citenumber with @start, use @numbering -->
      <xsl:when test="preceding::citenumber[@start]">
    
          <!-- use template "number" in tools/functions.xsl -->
          <xsl:call-template name="number">
            <xsl:with-param name="number" select="preceding::citenumber[@start][position()=1]/@start + count(preceding::citenumber) - count(preceding::citenumber[@start][position()=1]/preceding::citenumber)"/>
            <xsl:with-param name="numbering" select="@numbering"/>
          </xsl:call-template>
    
      </xsl:when>

      <!-- otherwise: use consecutive number of citenumber -->
      <xsl:otherwise>
        <xsl:value-of select="count(preceding::citenumber)+1"/>
      </xsl:otherwise>

    </xsl:choose>

</xsl:template>


<!-- ignore citenumbers in "head" (is called from "module-structure"
     respectivly from all elements that may contain element "head") -->
<xsl:template match="head/citenumber" />

<!-- will be handled in preceding citation element -->
<xsl:template match="bibliography/citation//citenumber" />

<!-- first citenumber without preceeding text will be called from "p" -->
<xsl:template match="p/citenumber[count(preceding-sibling::*)=0][normalize-space(preceding-sibling::text())='']"/>

<!-- first citenumber without preceeding text will be called -->
<!-- from "li" element preceeding the actual "li" element    -->
<xsl:template match="li/citenumber[count(preceding-sibling::*)=0][normalize-space(preceding-sibling::text())='']"/> 

<!-- first citenumber without preceeding text in "li" can be -->
<!-- forced to output, e.g. when called from preceding "li"  -->
<xsl:template match="li//citenumber[count(preceding-sibling::*)=0][normalize-space(preceding-sibling::text())='']" mode="forceOutput"> 
  <xsl:call-template name="citenumber-simple"/>
</xsl:template>


<!-- citenumbers that are direct childs of chapter, section etc. -->
<!-- will be created with a seperation line                      -->
<xsl:template match="chapter/citenumber|section/citenumber|subsection/citenumber|subblock/citenumber|block/citenumber|part/citenumber">
   <xsl:call-template name="citenumber-hline"/>
</xsl:template>

<!-- special elements with separation line -->
<xsl:template match="front/citenumber|submission/citenumber|
                     dedication/citenumber|vita/citenumber|
                     footnote/citenumber|endnote/citenumber|
                     entry/citenumber|glossary/citenumber">
   <xsl:call-template name="citenumber-hline"/>
</xsl:template>

<!-- special elements with separation line              -->
<!-- where "citenumber" is not allowed according to DTD -->
<xsl:template match="body/citenumber|back/citenumber|
                     abstract/citenumber|approvals/citenumber|
                     grant/citenumber|copyright/citenumber|
                     abbreviation/citenumber|preface/citenumber|
                     summary/citenumber|frame/citenumber|
                     resources/citenumber|appendix/citenumber|
                     bibliography/citenumber|
                     acknowledgement/citenumber|declaration/citenumber|
                     motto/citenumber">
   <xsl:call-template name="citenumber-hline"/>
</xsl:template>

</xsl:stylesheet>
