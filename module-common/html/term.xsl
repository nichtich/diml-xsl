<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
<!-- Duplicate entry: -->
<!--  <xsl:key name="term" match="term" use="@id"/> -->
  
<!--  terms koennen per @id und @ref verbunden werden   fuer <term ref="foo"/> wird der Inhalt von      <term id="foo">...</term> angezeigt. -->
  <xsl:template match="term">
    <span class="term">
      <xsl:choose>
        <xsl:when test="@id">
          <a name="{@id}">
            <xsl:call-template name="term-content"/>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="term-content"/>
        </xsl:otherwise>
      </xsl:choose>
    </span>
  </xsl:template>

  <xsl:template name="term-content">
    <xsl:choose>
      <xsl:when test="@ref and key('term',@ref)">
        <a href="#{@ref}"> <!-- TODO: term on other page! -->
          <xsl:choose>
            <xsl:when test="node()">
              <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:for-each select="key('term',@ref)">
                <xsl:call-template name="term-content"/>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
        </a>
      </xsl:when>
      <xsl:when test="@ref">        
        <xsl:message terminate="yes">This is stylesheet module-common/term.xsl speaking. Error: term/@ref to unknown term/@id (value="<xsl:value-of select="@ref"/>)</xsl:message>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>
