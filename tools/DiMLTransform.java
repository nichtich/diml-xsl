import java.io.*;
import java.util.*;
import org.w3c.dom.*;
import javax.xml.parsers.*;
import javax.xml.transform.*;
import javax.xml.transform.dom.*;
import org.xml.sax.SAXException;
import javax.xml.transform.*;
import javax.xml.transform.dom.*;
import javax.xml.transform.stream.*;
import org.apache.xpath.XPathAPI;

public class DiMLTransform extends XMLReading {

	Document dimlDocument = null;
	
	public DiMLTransform() {}
  	  	  
	public boolean provideOutputDir(String dir) {
		resultDir = new File(dir);
 		if (!resultDir.exists()) resultDir.mkdirs();
 		return resultDir.isDirectory();	
	}

  /**
   * Select Elements to split document into by an XPath expression
   * Add an 'id'-Attribute for elements that do not have one.
   * The method ids are created will lead in errors if there are
   * already ids of the same name in other places! (FIXME)
   */
  public NodeList selectParts(String xpath) throws TransformerException { 	  
	  
	  // get Nodes
	  NodeList parts = XPathAPI.selectNodeList(dimlDocument.getDocumentElement(),xpath);
	  	
	  Hashtable names = new Hashtable();
	  		
  	for(int s=0; s<parts.getLength(); s++) {
  	  Node node = parts.item(s);  
  	
  	  // TODO: if nodetype != Element => error in xpath
  	        
  	  Integer n = (Integer)names.get(node.getNodeName());
  	  if (n != null) {
  	    n = new Integer(n.intValue()+1);        
  	  } else {
  	  	n = new Integer(0);
  	  }
  	  names.put(node.getNodeName(), n);
  	  
  	  String id = null;
  	  if(node.hasAttributes())
  	    if(node.getAttributes().getNamedItem("id") != null)
  	      id = node.getAttributes().getNamedItem("id").getNodeValue();
  	      
  	  if(id==null) {
  	  	id = node.getNodeName();
  	  	if(n.intValue() > 0) id+=n.toString();
  	  	((Element)node).setAttribute("id",id);
  	  }
  	}
  	  
	  return parts;  	// TODO: Array of ids and Elemenst
  }  
  
  /**
   * Load DiML-XSL files and store them as Templates
   */
  public Templates loadXSL(String dimlxsl) throws TransformerConfigurationException {
		File dimlxslFile = new File(dimlxsl);		
		message("parsing "+dimlxslFile);				
		TransformerFactory tFactory = TransformerFactory.newInstance(); 
		Templates t = tFactory.newTemplates(new StreamSource(dimlxslFile));
		message("parsing done.");
		return t;
  }
    
	
	public void run() throws ParserConfigurationException, TransformerException, IOException {
		Source input;    
		input = new DOMSource(dimlDocument);
		
		Element e = dimlDocument.getDocumentElement();
		
		message("transforming:");
    
    if(e.getTagName() == "cms:container") {
      
      transform(dimlDocument,resultDir+"/output.html");
      
		} else if(e.getTagName() == "etd") {
		  
		 // load diml2cms.xsl
	   Templates diml2cms = loadXSL("diml2cms.xsl");
		   
		  
     // if you do not want do split, just use "/etd";    
     String xpath = "/etd/front|/etd/body/*|/etd/back/*";
	   //if (requestId!="") xpath += "[.='"+requestId+"']";
	   
	   NodeList parts = selectParts(xpath);	
	  
	   message("document split into "+parts.getLength()+" parts");
	   
	   //CMSContainer cmsContainer = new CMSContainer();
  
	   // TODO: if there are no parts...
	  
	   for(int s=0; s<parts.getLength(); s++) {
  	   Node node = parts.item(s);  	  
	  	
	  	 String id = node.getAttributes().getNamedItem("id").getNodeValue();
	  	
	  	 //Document cmsd = cmsContainer.getDocument(node);    
	 
	     Transformer t = diml2cms.newTransformer();
	     Source in  = new DOMSource(dimlDocument);
	     DOMResult output = new DOMResult();
	     t.setParameter("SELECTID",id);
	     t.transform(in, output);
	     Node cmsd = output.getNode();
	 
	 
	     if(makeCMSFiles) { 
	       String cmsContainerFile = resultDir+"/"+id+".xml";
         DOMSource domSource = new DOMSource(cmsd);
         StreamResult streamResult = new StreamResult(new FileWriter(cmsContainerFile));
   
         message("writing cms:container "+cmsContainerFile);
         TransformerFactory tf = TransformerFactory.newInstance();
         Transformer serializer = tf.newTransformer();
         serializer.setOutputProperty(OutputKeys.ENCODING,"ISO-8859-1");
         //serializer.setOutputProperty(OutputKeys.DOCTYPE_SYSTEM,"users.dtd");
         //serializer.setOutputProperty(OutputKeys.INDENT,"yes");
         serializer.transform(domSource, streamResult); 
       }

       if(makeHTMLFiles) {    
	  	   String resultFile = resultDir+"/"+id+".html"; 
	       transform( cmsd, resultFile);
		   }
		} // for
		} else {
    	message("document node is neither etd nor cms:container!");
      return;
   	}      	
		
		message("everything done.");
	}

  /**
   * Load DiML Document
   */
  public Document parseDocument(String source) throws ParserConfigurationException, SAXException, IOException {  
	  File dimlFile = new File(source);
	    
		DocumentBuilder dBuilder = dFactory.newDocumentBuilder();
		
	  ErrorHandlerImpl handler = new ErrorHandlerImpl();
	  dBuilder.setErrorHandler(handler);
		
	  Document doc = dBuilder.parse(dimlFile);
		    
	  if(!handler.errors.isEmpty()) {
	  	throw new SAXException(handler.getErrorMessages());
	  }
	  
	  return doc;    
  }	
	
	 
	private boolean makeHTMLFiles = true;
	private boolean makeCMSFiles  = true;
	 
	private Templates templates;
	private File resultDir;
	 
	private void transform(Node node, String resultFile) 
	 throws TransformerConfigurationException, TransformerException {
	  message("transforming "+resultFile);      		
	  Transformer transformer = templates.newTransformer();
	  Source input  = new DOMSource(node);
	  Result output = new StreamResult(resultFile);
	  transformer.transform(input, output);
	}
	
  public void message(String msg) {
    System.out.println(msg);
	}  	


  public void action(String[] args)  throws Exception {
      // modi: 
		  // -split (xml) (mit xsl-Anweisung und DTD?)
		  // -cms (xml) (mit xsl-Anweisung) <-notwendig wegen ids!
	  
    
    // Provide Output Directory
    if( !provideOutputDir(args.length>1 ? args[1] : "") ) {
      message("unable to create output directory: "+resultDir);
      return;
    }  
    
    // load DiMLFile
    String dimlFile = args[0];
	  message("parsing "+dimlFile);
    dimlDocument = parseDocument(dimlFile);
    message("parsing done.");

    // load XSL
    if(makeHTMLFiles)
      templates = loadXSL("../diml2html.xsl");
    
    // create output	
    run(); 
  }

  
	public static void main(String[] args) throws Exception {
		if(args.length<1) {
			printUsage();
			System.exit(0);
		}
		DiMLTransform tr = new DiMLTransform();
		tr.action(args);
	}
	

	public static void printUsage() {
		String usageMsg;

		usageMsg  = "DiMLTransform - generate html output from DiML";
		usageMsg += "Usage: java DiML2html [<options>] <file> [<dir>]\n";
		usageMsg += "  file\tXDiML-file\n";
		usageMsg += "  dir\tdestination-directory\n";

		System.out.println(usageMsg);
	}
}