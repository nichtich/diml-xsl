<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- front -->
<xsl:template match="front">

  <xsl:apply-templates select="school"/>
  <xsl:apply-templates select="title"/>
  <xsl:apply-templates select="submission"/>
  <xsl:apply-templates select="degree"/>
  <xsl:apply-templates select="major"/>
  <xsl:apply-templates select="author"/>
  <xsl:apply-templates select="dean"/>  
  <xsl:apply-templates select="approvals"/>
  <xsl:apply-templates select="date"/>
  <xsl:apply-templates select="grant"/>
  <xsl:apply-templates select="dedication"/>
  <xsl:apply-templates select="copyright"/>
  <xsl:apply-templates select="motto"/>
  <xsl:apply-templates select="*[not(self::school or self::title or self::submission or self::degree or self::major or self::author or self::dean or self::approvals or self::date or self::grant or self::dedication or self::copyright or self::motto)]" />
  <hr/>
</xsl:template>


<!-- front -->

<xsl:template match="front" mode="html-head">

  <xsl:apply-templates mode="html-head"/>

</xsl:template>



<!-- Kopfzeile -->

<xsl:template match="front" mode="headline">

    <table width="100%" border="0" class="headline"><tr>

    <td class="headline1" valign="top"><xsl:apply-templates select="author" mode="headline" /></td>

    <td class="headline1" valign="top"><xsl:apply-templates select="title" mode="headline" /></td>

    </tr><tr>

    <td class="headline2" colspan="2">

      <!-- Erstellung der Links auf die verschiedenen Dateien -->

      [<A HREF="{$NAME_OF_FILE}.html">Titelseite</A>] 

      <xsl:if test="/etd/body/abbreviation or /etd/back/abbreviation">

         [<A HREF="{$NAME_OF_FILE}-abb.html">Abkuerzungsverzeichnis</A>]

      </xsl:if> 

      <xsl:if test="/etd/body/preface or /etd/front/preface">

         [<A HREF="{$NAME_OF_FILE}-pre.html">Vorwort</A>]

      </xsl:if> 

      <xsl:for-each select="/etd/body/chapter">

      [<A HREF="{$NAME_OF_FILE}-ch{position()}.html"><xsl:value-of select="position()"/></A>] 

      </xsl:for-each>

      <xsl:if test="/etd/back/bibliography">

         [<A HREF="{$NAME_OF_FILE}-bib.html">Literaturverzeichnis</A>]

      </xsl:if> 

      <xsl:if test="/etd/back/vita">

         [<A HREF="{$NAME_OF_FILE}-vita.html">Lebenslauf</A>]

      </xsl:if> 

      <xsl:if test="/etd/back/acknowledgement">

         [<A HREF="{$NAME_OF_FILE}-ack.html">Danksagung</A>]

      </xsl:if>

    </td>

    </tr></table>



</xsl:template>



</xsl:stylesheet>

