<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--== Glossary ==-->
<xsl:variable name="GLOSSARY_HEAD">Glossar</xsl:variable>

<!-- Vorraussetzung: jeder term hat 'ne id -->
<xsl:template match="glossary">
  <h2>
    <a name="#{generate-id(.)}">
      <xsl:apply-templates select="." mode="head"/>
    </a>  
  </h2>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="glossary" mode="head">
    <xsl:choose>
      <xsl:when test="head">
        <xsl:apply-templates select="head/*"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$GLOSSARY_HEAD"/>
      </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!--xsl:template match="dl[parent::glossary]">
  <xsl:apply-templates select="caption"/>
  <table>
    <xsl:apply-templates select="def" mode="glossary"/>
  </table>
</xsl:template-->


<xsl:template match="dl">
  <xsl:apply-templates select="caption"/>
  <table>
    <xsl:apply-templates select="def" mode="in-dl"/>
  </table>
</xsl:template>

<!--== Definition inside Definition List -->
<xsl:template match="def" mode="in-dl">
  <tr>
    <td colspan="2">
      <b><xsl:apply-templates select="*[1]"/>:</b>
    </td>
  </tr>
  <tr>
    <td>&#xA0;&#xA0;</td>
    <td>
      <xsl:choose>
        <xsl:when test="count(*)>2">
          <ol>
            <xsl:for-each select="*[position()>1]">
              <li>
                <xsl:apply-templates mode="in-def"/>              
              </li>
            </xsl:for-each>
          </ol>
        </xsl:when>
        <xsl:otherwise>
          <p>
            <xsl:apply-templates select="*[2]" mode="in-def"/>
          </p>
        </xsl:otherwise>
      </xsl:choose>
    </td>
  </tr>
</xsl:template>

<xsl:variable name="DEF_SYNONYM_SEE">
  <!-->&#xBB;</b-->
  <b>&#x2192;&#xA;</b>
</xsl:variable>

<xsl:template match="term" mode="in-def">
  <xsl:value-of select="$DEF_SYNONYM_SEE"/>
  <xsl:apply-templates select="."/> 
</xsl:template>

<xsl:template match="dd" mode="in-def">
  <xsl:apply-templates/>
</xsl:template>

</xsl:stylesheet>
