<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:variable name="PRINT-DATE-LABEL" select="false()"/>

<!-- Art des Datums wird ber_cksichtigt -->
<xsl:template match="date">
	<!-- type="1": Abgabe der Dissertation -->
   	<!-- type="2": Verteidigung der Dissertation -->
  <p class="date">
  	<xsl:if test="$PRINT-DATE-LABEL">
    <xsl:choose>
      <xsl:when test="@type='1'">
         <span class="dateText">Datum der Einreichung:</span>
      </xsl:when>
      <xsl:when test="@type='2'">
         <span class="dateText">Datum der Promotion:</span>
      </xsl:when>
      <!-- ohne Typangabe -->
      <xsl:otherwise>
         <span class="dateText">Datum:</span>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
  </p>
</xsl:template>
</xsl:stylesheet>

