<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- front -->
<xsl:template match="front">
	<xsl:apply-templates/>
 	<hr/>
</xsl:template>

<!-- front -->
<xsl:template match="front" mode="html-head">
 	<xsl:apply-templates mode="html-head"/>
</xsl:template>

</xsl:stylesheet>

