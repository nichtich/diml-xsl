<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:param name="lang">
<xsl:choose>
  <xsl:when test="/etd/@lang"><xsl:value-of select="/etd/@lang" />
  </xsl:when>
  <xsl:when test="/cms:meta...">
  </csl:when>
  <xsl:otherwise>de</xsl:otherwise>
</xsl:choose>

<xsl:param name="STYLEDIRECTORY">
  <xsl:choose>
    <xsl:when test="/processing-instruction('css-stylesheet')">
      <xsl:value-of select="/processing-instruction('css-stylesheet')"/>
    </xsl:when>
    <xsl:otherwise>/dissertationen/style/</xsl:otherwise>
  </xsl:choose>
</xsl:param>

<xsl:param name="LANGUAGE" select="de"/>

<xsl:param name="vorgelegtbeiText" select="'vorgelegt von'" />

<!--<xsl:output method="html" encoding="ISO-8859-1"/>-->

<xsl:include href="module-diml/html.xsl"/>
<xsl:include href="module-media/html.xsl"/>
<xsl:include href="module-structure/html.xsl"/>
<xsl:include href="module-citation/html.xsl"/>
<xsl:include href="module-common/html.xsl"/>
<!--xsl:include href="module-mathematics/html.xsl"/-->
<xsl:include href="module-documents/html.xsl"/>
<!--xsl:include href="module-verse/html.xsl"/-->
<xsl:include href="module-CALStable/html.xsl"/>
<xsl:include href="module-lists/html.xsl"/>
<xsl:include href="module-text/html.xsl"/>
<xsl:include href="module-cms/html.xsl"/>

<xsl:key name="term" match="term" use="@id"/>
<xsl:key name="id" match="*[@id]" use="@id"/>

<!-- debugging -->
<!--xsl:template match="/">
  <xsl:value-of select="$CSS-STYLESHEET"/>
</xsl:template-->

<!-- Ueberschrift eines Kapitels/Unterkapitels/... -->
<xsl:template match="frame|chapter|section|subsection|block|subblock|part" mode="head">
  <xsl:apply-templates select="head"/>
</xsl:template>


<xsl:template name="a-name-attribute">
	<xsl:param name="object" select="."/>
	<xsl:attribute name="name">
		<xsl:call-template name="object.id">
			<xsl:with-param name="object" select="$object"/>
		</xsl:call-template>
	</xsl:attribute>
</xsl:template>

<xsl:template name="a-href-attribute">
	<xsl:param name="object" select="."/>
	<xsl:attribute name="href">
		<xsl:text>#</xsl:text>
		<xsl:call-template name="object.id">
			<xsl:with-param name="object" select="$object"/>
		</xsl:call-template>
	</xsl:attribute>
</xsl:template>

<!-- Taucht genauso bei module-common\html\head.xsl auf -->
<!--
<xsl:template match="head">
  <xsl:apply-templates/>
</xsl:template>
-->

<!--xsl:template match="caption">
  <p align="center"><b>
    <xsl:apply-templates/>
  </b></p>
</xsl:template-->

<!--== Elemente mit ggf. Inhaltsergaenzung ==-->
<!-- glossflag -->
<xsl:template match="glossflag">
  <a href="#{@ref}">
    <xsl:choose>
      <xsl:when test="not(*|text())">
        <xsl:apply-templates select="/etd/back/glossary/dl/def/term[@id=current()/@ref]"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>        
      </xsl:otherwise>
    </xsl:choose>
  </a>
</xsl:template>


<!--== Table of contents ==-->
<xsl:variable name="TOC_DEPTH">99</xsl:variable>
<xsl:variable name="TOC_HEAD">Inhaltsverzeichnis</xsl:variable>

<xsl:template name="table-of-contents">
  <xsl:if test="$TOC_DEPTH>0">
    <h1>
      <xsl:value-of select="$TOC_HEAD"/>  
    </h1>
    <ul>
      <xsl:apply-templates select="body" mode="table-of-contents"/>
      <xsl:apply-templates select="back" mode="table-of-contents"/>
    </ul>
   </xsl:if> 
</xsl:template>

<xsl:template match="body" mode="table-of-contents">
  <xsl:apply-templates mode="table-of-contents">
    <xsl:with-param name="toc-depth" select="$TOC_DEPTH"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="back" mode="table-of-contents">
  <xsl:apply-templates mode="table-of-contents">
    <xsl:with-param name="toc-depth" select="$TOC_DEPTH"/>
  </xsl:apply-templates>
</xsl:template>

<!--== Table of figures ==-->
<xsl:variable name="TOF_HEAD">Abbildungsverzeichnis</xsl:variable>

<xsl:template name="table-of-figures">
    <h1>
      <xsl:value-of select="$TOF_HEAD"/>
    </h1>
    <ul>
      <xsl:apply-templates select="body" mode="table-of-figures"/>
      <xsl:apply-templates select="back" mode="table-of-figures"/>
    </ul>
</xsl:template>

<xsl:template match="body" mode="table-of-figures">
  <xsl:apply-templates select="/etd/body//mm" mode="table-of-figures">
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="back" mode="table-of-figures">
  <xsl:apply-templates select="/etd/back//mm" mode="table-of-figures">
  </xsl:apply-templates>
</xsl:template>

<!--== Table of tables ==-->
<xsl:variable name="TOT_HEAD">Tabellenverzeichnis</xsl:variable>

<xsl:template name="table-of-tables">
    <!--h1>
      <xsl:value-of select="$TOT_HEAD"/>
    </h1>
    <ul>
      <xsl:apply-templates select="body" mode="table-of-tables"/>
      <xsl:apply-templates select="back" mode="table-of-tables"/>
    </ul-->
</xsl:template>

<xsl:template match="body" mode="table-of-tables">
  <xsl:apply-templates select="/etd/body//table" mode="table-of-tables">
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="back" mode="table-of-tables">
  <xsl:apply-templates select="/etd/back//table" mode="table-of-tables">
  </xsl:apply-templates>
</xsl:template>

<!-- TODO: bibliography mit mehreren parts -->

<xsl:template match="abbreviation|preface|summary|acknowledgement|declaration|glossary|bibliography|vita" mode="table-of-contents">
  <li>
    <a>
      <xsl:call-template name="a-href-attribute"/>
      <xsl:apply-templates select="." mode="head"/>
    </a>
  </li>  
</xsl:template>

<xsl:template match="resources" mode="table-of-contents">
  <xsl:param name="toc-depth">0</xsl:param>
  <xsl:call-template name="toc-entry">
    <xsl:with-param name="toc-depth" select="$toc-depth"/>
    <xsl:with-param name="subelements" select="part"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="appendix" mode="table-of-contents">
  <xsl:param name="toc-depth">0</xsl:param>
  <xsl:call-template name="toc-entry">
    <xsl:with-param name="toc-depth" select="$toc-depth"/>
    <xsl:with-param name="subelements" select="bibliography|resources|glossary|appendix|abbreviation|part"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="toc-entry">
  <xsl:param name="toc-depth">0</xsl:param>
  <xsl:param name="subelements"/>
  <li>
    <a>
      <xsl:call-template name="a-href-attribute"/>    
      <xsl:apply-templates select="." mode="head"/>
    </a>
    <xsl:if test="$toc-depth>0 and $subelements">
      <ul>        
        <xsl:apply-templates select="$subelements" mode="table-of-contents">
          <xsl:with-param name="toc-depth">
            <xsl:value-of select="$toc-depth - 1"/>
          </xsl:with-param>
        </xsl:apply-templates>
      </ul>
    </xsl:if>
  </li>  
</xsl:template>

<!-- <head> -->
<xsl:template match="*" mode="html-head"/>

<!-- Debugging -->
<xsl:template match="*">
  <font color="#FF0000">
    <xsl:text>&lt;</xsl:text>
    <xsl:value-of select="name(.)"/>
    <xsl:text>&gt;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&lt;/</xsl:text>
    <xsl:value-of select="name(.)"/>
    <xsl:text>&gt;</xsl:text>    
  </font>
</xsl:template>


</xsl:stylesheet>

