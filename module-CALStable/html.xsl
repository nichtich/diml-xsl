<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" >

<xsl:include href="html/table.xsl"/>

<!-- TODO: handle 'caption' and 'legend' -->
<xsl:template match="table">
  <xsl:if test="tgroup/@cols &lt; 1">
    <xsl:message terminate="yes">tgroup/@cols &lt; 1!</xsl:message>
  </xsl:if>
  <xsl:apply-templates/>
</xsl:template>

<!-- no elements (TODO: clean up and [re]move) -->
<xsl:include href="html/param.xsl"/>
<xsl:include href="html/inline.xsl"/>
<xsl:include href="html/xref.xsl"/>
<xsl:include href="html/html.xsl"/>
<xsl:include href="common/common.xsl"/>

<!-- defined templates in DocBook Stylesheets -->
<xsl:template name='dbhtml-attribute'/>
<xsl:template name='language.attribute'/>
<xsl:template name='copy-string'/>
<xsl:template name='pi-attribute'/>
<xsl:template name="dot.count"/>
<xsl:template name="gentext"/>
<xsl:template name="gentext.endquote"/>
<xsl:template name="gentext.nestedendquote"/>
<xsl:template name="gentext.template"/>
<xsl:template name="gentext.startquote"/>
<xsl:template name="gentext.nestedstartquote"/>
<xsl:template name="lookup.key"/>
<xsl:template name="xpath.location"/>
<xsl:template name="is.graphic.format"/>
<xsl:template name="is.graphic.extension"/>
<xsl:template name="xpointer.idref"/>
<xsl:template name='substitute-markup'/>

</xsl:stylesheet>