<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:key name="id" match="*" use="@id"/>

<xsl:template name="link.target">
	<xsl:param name="object" select="."/>	
  <xsl:if test="name($object)='cms:entry'">
    <xsl:value-of select="$object/@part"/>
  </xsl:if>
  <xsl:text>#</xsl:text>
  <xsl:value-of select="$object/@id"/>
</xsl:template>
      
<xsl:template match="link" name="link">
  <xsl:param name="a.target"/>

  <!--xsl:variable name="target" select="id(@ref)"/-->

  <a>
    <xsl:if test="@id">
      <xsl:attribute name="name"><xsl:value-of select="@id"/></xsl:attribute>
    </xsl:if>

    <xsl:if test="$a.target">
      <xsl:attribute name="target"><xsl:value-of select="$a.target"/></xsl:attribute>
    </xsl:if>

	<xsl:if test="@ref">
		<xsl:variable name="target" select="key('id',@ref)[1]"/>
		
	    <xsl:attribute name="href">
     	 <xsl:call-template name="link.target">
	        <xsl:with-param name="object" select="$target"/>
     	 </xsl:call-template>
	    </xsl:attribute>
    <!-- FIXME: is there a better way to tell what elements have a title? -->
    <!-- or local-name($target) = 'bibliography' -->
    <xsl:if test="local-name($target) = 'book'
                  or local-name($target) = 'set'
                  or local-name($target) = 'chapter'
                  or local-name($target) = 'preface'
                  or local-name($target) = 'appendix'                  
                  or local-name($target) = 'glossary'
                  or local-name($target) = 'index'
                  or local-name($target) = 'part'
                  or local-name($target) = 'refentry'
                  or local-name($target) = 'reference'
                  or local-name($target) = 'example'
                  or local-name($target) = 'equation'
                  or local-name($target) = 'table'
                  or local-name($target) = 'figure'
                  or local-name($target) = 'simplesect'
                  or starts-with(local-name($target),'sect')
                  or starts-with(local-name($target),'refsect')">
      <xsl:attribute name="title">
        <!--xsl:apply-templates select="$target"
                             mode="object.title.markup.textonly"/-->
      </xsl:attribute>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="count(child::node()) &gt; 0">
        <!-- If it has content, use it -->
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:when test="name($target)='citation'">
        <xsl:apply-templates select="$target" mode="label"/>
      </xsl:when>
      <!--xsl:otherwise>
            <xsl:message>
              <xsl:text>Link element has no content and no Endterm. </xsl:text>
              <xsl:text>Nothing to show in the link to </xsl:text>
              <xsl:value-of select="$target"/>
            </xsl:message>
            <xsl:text>???</xsl:text>
      </xsl:otherwise-->
    </xsl:choose>
        </xsl:if>
  </a>
</xsl:template>

<!--xsl:template match="link"> 
!!!!!!!!!!!!!!!!!
	ref:<xsl:value-of select="@ref"/>
  <a href="#{@ref}" class="link">
    <xsl:choose>
      <xsl:when test="not(*|text())">
        <xsl:variable name="target" select="id(@ref)"/>
        <xsl:choose>
          <xsl:when test="$target/head">
            <xsl:apply-templates select="$target/head"/>      
          </xsl:when>
          <xsl:when test="name($target)='citation'">
            <xsl:apply-templates select="$target" mode="label"/>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>        
      </xsl:otherwise>
    </xsl:choose>  
  </a>
</xsl:template-->

</xsl:stylesheet>
