<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="head">
	<xsl:if test="../@label">
		<xsl:value-of select="../@label"/>
		<xsl:text>&#xA0;</xsl:text>
	</xsl:if>
	<xsl:apply-templates />
</xsl:template>

</xsl:stylesheet>

