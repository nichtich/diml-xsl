<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="footnote|endnote">
  <a name="{concat(generate-id(),'link')}">
    <a href="#{generate-id()}">
      <xsl:apply-templates select="." mode="label"/>
    </a>  
  </a>  
</xsl:template>

<xsl:template match="footnote|endnote" mode="label">

  <xsl:choose>

    <!-- 1st: use @start, with @numbering -->
    <xsl:when test="@start">
      <sup class="footnotelabel">
      
        <!-- use template "number" in tools/functions.xsl -->
        <xsl:call-template name="number">
          <xsl:with-param name="number" select="@start"/>
          <xsl:with-param name="numbering" select="@numbering"/>
        </xsl:call-template>

      </sup>	
	
    </xsl:when>

    <!-- 2nd: use @label, as is -->
    <xsl:when test="@label">
      <sup class="footnotelabel"><xsl:value-of select="@label"/></sup>
    </xsl:when>

    <!-- 3rd: count from previous footnote/endnote with @start, use @numbering -->
    <xsl:when test="preceding::footnote[@start]">
    
      <sup class="footnotelabel">
        <!-- use template "number" in tools/functions.xsl -->
        <xsl:call-template name="number">
        
          <!-- count only footnotes with @start -->
          <!--<xsl:with-param name="number" select="preceding::footnote[@start][position()=1]/@start + count(preceding::footnote) - count(preceding::footnote[@start][position()=1]/preceding::footnote)"/>-->

          <!-- count footnotes and endnotes with @start -->
          <xsl:with-param name="number" select="(preceding::footnote[@start] | preceding::endnote[@start])[position()=last()]/@start + count(preceding::footnote | preceding::endnote) - count((preceding::footnote[@start] | preceding::endnote[@start])[position()=last()]/(preceding::footnote | preceding::endnote))"/>

          <xsl:with-param name="numbering" select="@numbering"/>
        </xsl:call-template>
      </sup>
    
    </xsl:when>

    <!-- otherwise: use consecutive number of footnote/endnote -->
    <xsl:otherwise>
      <sup class="footnotelabel"><xsl:value-of select="count(preceding::footnote | preceding::endnote)+1"/></sup>
    </xsl:otherwise>
    
  </xsl:choose>
  
</xsl:template>

<xsl:template match="footnote|endnote" mode="foot">
  <p>
    <a name="{generate-id()}">
      <a href="#{concat(generate-id(),'link')}">
        <xsl:apply-templates select="." mode="label"/>
      </a>  
    </a>
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

</xsl:stylesheet>
