<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:key name="term" match="term" use="@id"/>
  
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
    <!--xsl:variable name="ref" select="//term[@ref=current()/@id]"/-->
    <xsl:variable name="ref" select="key('term',@ref)"/>
    <xsl:choose>
      <xsl:when test="$ref">
        <a href="#{generate-id($ref)}">
          <xsl:choose>
            <xsl:when test="node()">
              <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="$ref/node()"/>
            </xsl:otherwise>
          </xsl:choose>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>
