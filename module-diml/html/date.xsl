<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- Art des Datums wird bercksichtigt -->
<xsl:template match="date">
  <p class="date">
    <xsl:choose>
      <!-- type="1": Abgabe der Dissertation -->
      <xsl:when test="@type='1'">
         <span class="dateText">Datum der Einreichung:</span>
      </xsl:when>
      <!-- type="2": Verteidigung der Dissertation -->
      <xsl:when test="@type='2'">
         <span class="dateText">Datum der Promotion:</span>
      </xsl:when>
      <!-- ohne Typangabe -->
      <xsl:otherwise>
         <span class="dateText">Datum:</span>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text> </xsl:text><xsl:apply-templates/>
  </p>
</xsl:template>
</xsl:stylesheet>

