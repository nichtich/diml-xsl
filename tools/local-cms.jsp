<%@ page session="true" %>
<%@ page language="java" contentType="text/html" %>
<%@ page import="org.w3c.dom.*" %>
<%@ page import="javax.xml.parsers.*" %>
<%@ page import="javax.xml.transform.*"%>
<%@ page import="javax.xml.transform.sax.*"%>
<%@ page import="javax.xml.transform.stream.*"%>
<%@ page import="javax.xml.transform.dom.*"%> 
<%@ page import="org.xml.sax.*"%>
<%@ page import="org.xml.sax.helpers.*"%>
<%@ page import="org.apache.xalan.serialize.*"%>
<%@ page import="org.apache.xalan.templates.OutputProperties" %>
<%@ page import="java.io.*" %>
<%@ page import="java.io.*" %>
<%/*==========================================================
Folgende Java-Bibliotheken (Xalan) muss der Server finden:
  jasper-compiler.jar 
  jasper-runtime.jar 
  naming-factory.jar
  xalanservlet.jar
  xalan.jar
  xercesImpl.jar

Bei Tomcat z.B. im Verzeichnis  Apache Tomcat 4.0/lib/
==========================================================*/

/*<!--% @ page import="java.util.Enumeration" %-->
<!--% @ page import="org.w3c.dom.traversal.NodeIterator" %>
<% @ page import="org.apache.xpath.XPathAPI" %-->*/

File dimlStyleFile = new File(application.getRealPath("diml-xsl/diml2html.xsl"));

DocumentBuilderFactory factory =  DocumentBuilderFactory.newInstance();
factory.setNamespaceAware(true);
DocumentBuilder dbuilder = factory.newDocumentBuilder();

Document dimlDocument = null;
String filename   = request.getParameter("file");
String objid      = request.getParameter("objid");
String linkid     = request.getParameter("linkid");
File dimlFile = null;

if (filename!=null) {
  dimlFile   = new File(application.getRealPath(filename));
  Long lastModified = (Long)session.getAttribute("lastmod-"+filename);

  /* DiML-Dokument ggf. aus Cache holen */
  if (lastModified != null && lastModified.longValue() >= dimlFile.lastModified()) {
    dimlDocument = (Document)session.getAttribute("cached-"+filename);
  }

  /* DiML-Dokument aus Datei holen und cachen */
  if (dimlDocument==null) {
    dimlDocument = dbuilder.parse(new FileInputStream(dimlFile),dimlFile.toString());
    session.setAttribute("lastmod-"+filename, new Long(dimlFile.lastModified()));
    session.setAttribute("cached-", dimlDocument); 
  }
}

Node objDOM = dimlDocument.getDocumentElement();

if(dimlDocument==null) {  
  out.print("<h1>Local-CMS</h1><br>simuliert ein CMS.<p><b>Aufruf: </b><tt>local-cms.jsp?file=<i>dateiname</i>[&linkid=<i>linkid</i>][&objid=<i>objid</i>]</p>");
} else {
  DOMResult resultDOM = null;
  TransformerFactory tFactory = TransformerFactory.newInstance();
  Transformer transformer = tFactory.newTransformer();
  String systemId = dimlFile.toString();
    
  transformer = tFactory.newTransformer(new StreamSource(dimlStyleFile));
  
  //out.print("Transfomer:" +transformer);
  transformer.transform(new DOMSource(objDOM,systemId),new StreamResult(out));
}


%>