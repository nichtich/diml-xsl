<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- Link: f�r einen internen Link                                   -->
<!-- (innerhalb des Dokumentes, nicht unbedingt innerhalb der Datei) -->

<!-- TODO: check for multiple ID and stupid link targets : warning! -->


<!-- find out exact link target -->

<xsl:template name="link.target">
  <xsl:param name="object" select="."/>	
  
  <!-- find out name of file stored in corresponding cms:entry -->
  <xsl:if test="name($object)='cms:entry'">
    <xsl:value-of select="$object/@part"/>
    <xsl:value-of select="$EXT"/>
  </xsl:if>
  
  <!-- find out exact name of id -->
  <!-- if file is named like id do not add #id -->

  <xsl:if test="not($object/@part=$object/@id)">
    <xsl:text>#</xsl:text>
    <xsl:value-of select="$object/@id"/>
  </xsl:if>  
  
</xsl:template>
      
<xsl:template match="link" name="link">

  <xsl:param name="a.target"/>
  <a>

    <!-- if link has attribut id, use it for creating atribute name -->
    <xsl:if test="@id">
      <xsl:attribute name="name"><xsl:value-of select="@id"/></xsl:attribute>
    </xsl:if>

    <!-- if link target comes with variable, use it as link target  -->
    <xsl:if test="$a.target">
      <xsl:attribute name="target"><xsl:value-of select="$a.target"/></xsl:attribute>
    </xsl:if>

    <!-- if link has attribut ref, use it to determine link target  -->    
    <xsl:if test="@ref">

      <!-- Variablen -->
      <xsl:variable name="target" select="key('id',@ref)[1]"/>
      <xsl:variable name="targetname">
        <xsl:choose>
          <xsl:when test="name($target)='cms:entry'"><xsl:value-of select="$target/@type"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="name($target)"/></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:choose>

        <!-- dummy -->
        <xsl:when test="''!=''"></xsl:when>

        <!-- wenn jemand das Element Link falsch verwendet: -->
        <!-- Hyperlink mit http-Protokoll    -disabled-     -->
        <!-- <xsl:when test="substring(@ref,1,7)='http://'"> -->
        <!--   <xsl:attribute name="href"><xsl:value-of select="@ref"/></xsl:attribute> -->
        <!-- </xsl:when> -->
        <!-- wenn jemand das Element Link falsch verwendet: -->
        <!-- Hyperlink mit ftp-Protokoll     -disabled-     -->
        <!-- <xsl:when test="substring(@ref,1,6)='ftp://'"> -->
        <!--  <xsl:attribute name="href"><xsl:value-of select="@ref"/></xsl:attribute> -->
        <!-- </xsl:when> -->

        <!-- Link Dokumentintern (nicht unbedingt Dateiintern) -->
        <xsl:otherwise>
          <xsl:attribute name="href">
            <xsl:call-template name="link.target">
              <xsl:with-param name="object" select="$target"/>
            </xsl:call-template>
          </xsl:attribute>
          
          <!-- ??? -->
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
                     or starts-with(local-name($target),'sect')
                     or starts-with(local-name($target),'refsect')">
            <xsl:attribute name="title">
              <!-- xsl:apply-templates select="$target"
                                 mode="object.title.markup.textonly"/ -->
            </xsl:attribute>
          </xsl:if>
          
          
        </xsl:otherwise>
      </xsl:choose>

      <!-- Content (if @ref exists) -->

      <xsl:choose>
        <xsl:when test="count(child::node()) &gt; 0">
          <!-- If it has content, use it -->
          <xsl:apply-templates/>
        </xsl:when>
        <xsl:when test="$CONFIG/link[@to=$targetname]">
          <xsl:value-of select="$CONFIG/link[@to=$targetname]/@before"/>
          <xsl:apply-templates select="$target" mode="label"/>
          <xsl:value-of select="$CONFIG/link[@to=$targetname]/@after"/>        
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>[LINK to </xsl:text>
          <xsl:value-of select="name($target)"/>]
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if> <!-- test="@ref" -->

    <!-- Content (if @ref does not exists) -->
    <xsl:if test="not(@ref)">
      <xsl:apply-templates/>
    </xsl:if>


  </a>
</xsl:template>

<!--xsl:template match="link"> 
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
