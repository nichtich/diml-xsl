<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--xsl:template match="dl[parent::glossary]">
  <xsl:apply-templates select="caption"/>
  <table>
    <xsl:apply-templates select="def" mode="glossary"/>
  </table>
</xsl:template-->

<xsl:template match="dl">

  <xsl:if test="descendant::pagenumber">
    <xsl:call-template name="more-pagenumbers-inside"/>
  </xsl:if>
  
  <xsl:apply-templates select="caption"/>
  <table class="dl">
    <xsl:apply-templates select="def" mode="in-dl"/>
  </table>
</xsl:template>

<!--== Definition inside Definition List -->
<xsl:template match="def" mode="in-dl">
  <tr>
    <td colspan="2" class="dlterm">
      <b><xsl:apply-templates select="*[1]"/>:</b>
    </td>
  </tr>
  <tr>
    <td class="dlspacer">&#xA0;&#xA0;</td>
    <td class="dldefinition">
      <xsl:choose>
        <xsl:when test="count(*)>2">
          <ol class="dl">
            <xsl:for-each select="*[position()>1]">
              <li class="dl">
                <xsl:apply-templates mode="in-def"/>              
              </li>
            </xsl:for-each>
          </ol>
        </xsl:when>
        <xsl:otherwise>
          <!--<p class="dl">-->
            <xsl:apply-templates select="*[2]" mode="in-def"/>
          <!--</p>-->
        </xsl:otherwise>
      </xsl:choose>
    </td>
  </tr>
</xsl:template>

</xsl:stylesheet>