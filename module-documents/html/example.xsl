<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- Definition of example: -->
<!-- <!ELEMENT example (head? , (p | example | pagenumber)+)> -->

<xsl:template match="example">
  <xsl:apply-templates select="head/pagenumber" mode="hline"/>
  <table class="example" width="100%">
  <tr>
  <td width="1%"></td>
  <td class="example" width="98%">
     <xsl:if test="head and not(normalize-space(head)='')">
       <p class="examplehead">
         <xsl:apply-templates select="head"/>
       </p>  
     </xsl:if>  
     <xsl:apply-templates select="*[name()!='head']" />
  </td>
  <td width="1%"></td>
  </tr>
  </table>
  
</xsl:template>

</xsl:stylesheet>



