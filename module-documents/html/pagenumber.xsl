<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:param name="PAGENUMBER-INFO" select="false()"/>

<xsl:template match="head/pagenumber"/>
<xsl:template match="p/pagenumber[count(preceding-sibling::*)=0][normalize-space(preceding-sibling::text())='']"/> 

<xsl:template match="front/pagenumber|
	footnote/pagenumber|endnote/pagenumber|
	entry/pagenumber|glossary/pagenumber|dedication/pagenumber">
   <xsl:call-template name="pagenumber-hline"/>
</xsl:template>

<xsl:template match="chapter/pagenumber|section/pagenumber|subsection/pagenumber|subblock/pagenumber|block/pagenumber|part/pagenumber">
   <xsl:call-template name="pagenumber-hline"/>
</xsl:template>

<xsl:template match="pagenumber" mode="hline">
   <xsl:call-template name="pagenumber-hline"/>
</xsl:template>

<!-- this will print pagenumbers included in a table or list etc.  -->
<!-- in a combined way at the begin of this table, list etc.       -->
<xsl:template name="more-pagenumbers-inside">
     <table width="100%" border="0">
       <tr>
         <td width="100%"><hr/></td>
         <td class="pagenumber">
	    	<nobr>
          	<xsl:value-of select="$CONFIG/pagenumber[@lang=$LANG]/@before"/>

           <xsl:choose>
           <xsl:when test="count(descendant::pagenumber) = 1">              	 	
 				<xsl:value-of select="$VOCABLES/page/@*[name()=$LANG]" />: 				
 				<xsl:apply-templates select="descendant::pagenumber[1]" mode="pagenumber-combined" />
           </xsl:when>
           <xsl:otherwise>
               <xsl:value-of select="$VOCABLES/pages/@*[name()=$LANG]" />:               
              <xsl:apply-templates select="descendant::pagenumber[1]" mode="pagenumber-combined" />
			<xsl:value-of select="$CONFIG/pagenumber[name()=$LANG]/@between"/> 
			<xsl:apply-templates select="descendant::pagenumber[position()=last()]" mode="pagenumber-combined" />
           </xsl:otherwise>
         </xsl:choose> 				
				<xsl:value-of select="$CONFIG/pagenumber[@lang=$LANG]/@after"/>
			</nobr></td>         
       </tr>
     </table>
</xsl:template>


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

<xsl:template match="pagenumber" name="number-formated" mode="number">
	<xsl:param name="numbering" select="@numbering"/>
	<xsl:param name="value" select="@start"/>
	<xsl:choose>
		<xsl:when test="$numbering='arabic'">
			<xsl:number value="$value" format="1"/>
		</xsl:when>
		<xsl:when test="$numbering='lalpha'">
			<xsl:number value="$value" format="a"/>
		</xsl:when>
		<xsl:when test="$numbering='ualpha'">
			<xsl:number value="$value" format="A"/>
		</xsl:when>
		<xsl:when test="$numbering='lroman'">
			<xsl:number value="$value" format="i"/>
		</xsl:when>
		<xsl:when test="$numbering='uroman'">
			<xsl:number value="$value" format="I"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="."/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!--xsl:template match="pagenumber" name="pagenumber-content"-->
<!-- Use the start attribute or the label attribute! -->
<xsl:template match="pagenumber" name="pagenumber-content">
	<xsl:if test="$PAGENUMBER-INFO">
	  <xsl:message>page: <xsl:value-of select="@label"/></xsl:message>
 	</xsl:if>
  <span class="pagenumber">
  	<xsl:value-of select="$CONFIG/pagenumber[@lang=$LANG]/@before"/>
  	<xsl:value-of select="@system"/>
  	<xsl:choose>
		<xsl:when test="@label">
			<xsl:value-of select="@label"/>
		</xsl:when>
		<xsl:otherwise>
		  	<xsl:apply-templates select="." mode="number"/>
		</xsl:otherwise>
	</xsl:choose>
  	<xsl:value-of select="$CONFIG/pagenumber[@lang=$LANG]/@after"/>
  </span>
</xsl:template>

<xsl:template match="pagenumber" name="pagenumber-simple">
  <xsl:choose>
    <xsl:when test="ancestor::table or ancestor::li or ancestor::ol or ancestor::ul or ancestor::dl">
      <a name="{@id}"></a>
    </xsl:when>
    <xsl:when test="@id">
      <a name="{@id}"><xsl:call-template name="pagenumber-content"/></a>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="pagenumber-content"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="pagenumber" mode="pagenumber-combined">
   <xsl:apply-templates select="." mode="number"/>
</xsl:template>

</xsl:stylesheet>
