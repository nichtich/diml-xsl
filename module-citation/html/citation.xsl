<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- Citation mitten im Text -->
<xsl:template match="citation">
  <xsl:text> [</xsl:text>
  <xsl:apply-templates/>
   <xsl:text>] </xsl:text> 
</xsl:template>

<xsl:template match="citation" mode="blockquotecitation">
  <tr>
    <td width="15%"></td>
    <td width="70%" class="blockquotecitation">
      <xsl:apply-templates/>
    </td>
  <td width="15%"></td>
  </tr>
</xsl:template>

<xsl:template match="citation/@label">
  <xsl:text>[</xsl:text>
  <xsl:value-of select="."/>
  <xsl:text>]&#xA0;</xsl:text>
</xsl:template>

<xsl:template match="bibliography//citation">
  <xsl:if test="descendant::pagenumber">
    <xsl:call-template name="more-pagenumbers-inside">
       <xsl:with-param name="additionalMessage">
         <xsl:value-of select="$CONFIG/pagenumberInCitationAdditionalMessage[@lang=$LANG]/@text" />
       </xsl:with-param>
    </xsl:call-template>
  </xsl:if>
  <p>
    <xsl:apply-templates select="." mode="labeled"/>
  </p>  
</xsl:template>

<xsl:template match="citation" mode="labeled">
	<xsl:choose>
		<xsl:when test="@id">
		   <a name="{@id}">
		     <xsl:apply-templates select="@label"/>
                   </a>
		</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates select="@label"/>
		</xsl:otherwise>
	</xsl:choose>    
    <xsl:apply-templates/>
</xsl:template>

<!-- listed citations are not rendered inline -->
<xsl:template match="citation[count(../node())=1]">
  	<xsl:apply-templates select="." mode="labeled"/>
</xsl:template>
  	
</xsl:stylesheet>