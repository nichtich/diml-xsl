<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="freehead">
	<p class="freehead">
		<xsl:if test="@id"><a name="{@id}"/></xsl:if>
		<xsl:apply-templates/>
	</p>	
</xsl:template>

</xsl:stylesheet>

