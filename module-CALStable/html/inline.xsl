<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlink='http://www.w3.org/1999/xlink'
                xmlns:suwl="http://nwalsh.com/xslt/ext/com.nwalsh.saxon.UnwrapLinks"
                exclude-result-prefixes="xlink suwl"
                version='1.0'>

<!-- ********************************************************************
     $Id: inline.xsl,v 1.1 2003-02-05 01:08:54 nichtich Exp $
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://nwalsh.com/docbook/xsl/ for copyright
     and other information.

     ******************************************************************** -->

<xsl:template name="simple.xlink">
  <xsl:param name="node" select="."/>
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>

  <xsl:variable name="link">
    <xsl:choose>
      <xsl:when test="$node/@xlink:href
                      and (not($node/@xlink:type) or $node/@xlink:type='simple')">
        <a>
          <xsl:if test="@xlink.title">
            <xsl:attribute name="title">
              <xsl:value-of select="@xlink:title"/>
            </xsl:attribute>
          </xsl:if>

          <xsl:attribute name="href">
            <xsl:choose>
              <!-- if the href starts with # and does not contain an "(" -->
              <!-- or if the href starts with #xpointer(id(, it's just an ID -->
              <xsl:when test="starts-with(@xlink:href,'#')
                              and (not(contains(@xlink:href,'&#40;'))
                              or starts-with(@xlink:href,'#xpointer&#40;id&#40;'))">
                <xsl:variable name="idref">
                  <xsl:call-template name="xpointer.idref">
                    <xsl:with-param name="xpointer" select="@xlink:href"/>
                  </xsl:call-template>
                </xsl:variable>

                <xsl:variable name="targets" select="key('id',$idref)"/>
                <xsl:variable name="target" select="$targets[1]"/>

                <xsl:call-template name="check.id.unique">
                  <xsl:with-param name="linkend" select="@linkend"/>
                </xsl:call-template>

                <xsl:choose>
                  <xsl:when test="count($target) = 0">
                    <xsl:message>
                      <xsl:text>XLink to nonexistent id: </xsl:text>
                      <xsl:value-of select="$idref"/>
                    </xsl:message>
                    <xsl:text>???</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="href.target">
                      <xsl:with-param name="object" select="$target"/>
                    </xsl:call-template>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>

              <!-- otherwise it's a URI -->
              <xsl:otherwise>
                <xsl:value-of select="@xlink:href"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:copy-of select="$content"/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$content"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="function-available('suwl:unwrapLinks')">
      <xsl:copy-of select="suwl:unwrapLinks($link)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$link"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="inline.charseq">
  <xsl:param name="content">
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="simple.xlink">
      <xsl:with-param name="content">
        <xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:param>
  <xsl:copy-of select="$content"/>
</xsl:template>

<xsl:template name="inline.monoseq">
  <xsl:param name="content">
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="simple.xlink">
      <xsl:with-param name="content">
        <xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:param>
  <tt><xsl:copy-of select="$content"/></tt>
</xsl:template>

<xsl:template name="inline.boldseq">
  <xsl:param name="content">
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="simple.xlink">
      <xsl:with-param name="content">
        <xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:param>
  <!-- don't put <b> inside figure, example, or table titles -->
  <xsl:choose>
    <xsl:when test="local-name(..) = 'title'
                    and (local-name(../..) = 'figure'
                         or local-name(../..) = 'example'
                         or local-name(../..) = 'table')">
      <xsl:copy-of select="$content"/>
    </xsl:when>
    <xsl:otherwise>
      <b><xsl:copy-of select="$content"/></b>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="inline.italicseq">
  <xsl:param name="content">
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="simple.xlink">
      <xsl:with-param name="content">
        <xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:param>
  <i><xsl:copy-of select="$content"/></i>
</xsl:template>

<xsl:template name="inline.boldmonoseq">
  <xsl:param name="content">
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="simple.xlink">
      <xsl:with-param name="content">
        <xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:param>
  <!-- don't put <b> inside figure, example, or table titles -->
  <!-- or other titles that may already be represented with <b>'s. -->
  <xsl:choose>
    <xsl:when test="local-name(..) = 'title'
                    and (local-name(../..) = 'figure'
                         or local-name(../..) = 'example'
                         or local-name(../..) = 'table'
                         or local-name(../..) = 'formalpara')">
      <tt><xsl:copy-of select="$content"/></tt>
    </xsl:when>
    <xsl:otherwise>
      <b><tt><xsl:copy-of select="$content"/></tt></b>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="inline.italicmonoseq">
  <xsl:param name="content">
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="simple.xlink">
      <xsl:with-param name="content">
        <xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:param>
  <i><tt><xsl:copy-of select="$content"/></tt></i>
</xsl:template>

<xsl:template name="inline.superscriptseq">
  <xsl:param name="content">
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="simple.xlink">
      <xsl:with-param name="content">
        <xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:param>
  <sup><xsl:copy-of select="$content"/></sup>
</xsl:template>

<xsl:template name="inline.subscriptseq">
  <xsl:param name="content">
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="simple.xlink">
      <xsl:with-param name="content">
        <xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:param>
  <sub><xsl:copy-of select="$content"/></sub>
</xsl:template>


</xsl:stylesheet>

