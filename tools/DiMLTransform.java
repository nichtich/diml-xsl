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

	String cssFile = null;
	File diml2cmsFile  = null;
	File diml2htmlFile = null;
	File preprocessFile = null;
	
	TransformerFactory tFactory = TransformerFactory.newInstance(); 
	
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
  public NodeList selectParts(Node document, String xpath) throws TransformerException { 	  
	  
	  // get Nodes
	  NodeList parts = XPathAPI.selectNodeList(document,xpath);
	  	
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
   * Parse XSL files and return it as Templates
   */
  public Templates loadXSL(File xslFile) throws TransformerConfigurationException {
		if(!xslFile.exists()) {
		  message(xslFile + " not found!");
		  System.exit(1);
		}  
		message("\tparsing "+xslFile);						
		Templates t = tFactory.newTemplates(new StreamSource(xslFile));
		message("\tparsing done.");
		return t;
  }
    
	
	public void run(Node document) throws ParserConfigurationException, TransformerException, IOException {
		Source input;    
	  DOMResult output;
		
		input = new DOMSource(document);
		
		//getDocumentElement();
		Element e = (Element)XPathAPI.selectSingleNode(document,"/*"); 
		
		message("transforming:");
    
    /*if(e.getTagName() == "cms:container") {
      
      transform(dimlDocument,resultDir+"/output.html");
      
		} else*/ if(e.getTagName() == "etd") {				 
		 
		 		  
		 // load diml2cms.xsl
	   Templates diml2cms = loadXSL(diml2cmsFile);
		   		  
     // if you do not want do split, just use "/etd";    
     String xpath = "/etd/front|/etd/body/*|/etd/back/*";
	   //if (requestId!="") xpath += "[.='"+requestId+"']";
	   
	   NodeList parts = selectParts(document,xpath);	
	  
	   message("document split into "+parts.getLength()+" parts");
	   
	   //CMSContainer cmsContainer = new CMSContainer();
  
	   // TODO: if there are no parts...
	  
	  
	   for(int s=0; s<parts.getLength(); s++) {
  	   Node node = parts.item(s);  	  
	  	
	  	 String id = node.getAttributes().getNamedItem("id").getNodeValue();
	  	
	  	 //Document cmsd = cmsContainer.getDocument(node);    
	 
	     Transformer t = diml2cms.newTransformer();
	     input  = new DOMSource(document);
	     output = new DOMResult();
	     t.setParameter("SELECTID",id);	     
	     t.transform(input, output);
	     Node cmsd = output.getNode();	 
	 
	     if(makeCMSFiles) { 
	       String cmsContainerFile = resultDir+"/"+id+".xml";
         DOMSource domSource = new DOMSource(cmsd);
         StreamResult streamResult = new StreamResult(new FileWriter(cmsContainerFile));
   
         message("writing cms:container "+cmsContainerFile);
         
         Transformer serializer = tFactory.newTransformer();
         serializer.setOutputProperty(OutputKeys.ENCODING,"ISO-8859-1");
         //serializer.setOutputProperty(OutputKeys.DOCTYPE_SYSTEM,"users.dtd");
         //serializer.setOutputProperty(OutputKeys.INDENT,"yes");
         serializer.transform(domSource, streamResult); 
       }

       if(makeHTMLFiles) {    
	  	   String resultFile = resultDir+"/"+id+".html"; 
	  	   
	  	   message("transforming "+resultFile);      		
	       Transformer transformer = templates.newTransformer();
	       if(cssFile!=null) transformer.setParameter("STYLEDIRECTORY",cssFile);
	       input  = new DOMSource(cmsd);
	       StreamResult out = new StreamResult(resultFile);
	       transformer.transform(input, out);	       
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
	  if(cssFile!=null) transformer.setParameter("STYLEDIRECTORY",cssFile);
	  Source input  = new DOMSource(node);
	  Result output = new StreamResult(resultFile);
	  transformer.transform(input, output);
	}
	
  public void message(String msg) {
    System.out.println(msg);
	}  	


  public void action(String[] args)  throws Exception {
    
    // Provide Output Directory
    if( !provideOutputDir(args.length>1 ? args[1] : ".") ) {
      message("unable to create output directory: "+resultDir);
      return;
    }  
    
    if(args.length>2) {
       cssFile = args[2];
    }

    String DIMLXSL = System.getProperty("DIMLXSL","..");
    diml2cmsFile  = new File(DIMLXSL+"/tools/diml2cms.xsl");
	  diml2htmlFile = new File(DIMLXSL+"/diml2html.xsl");
	  preprocessFile = new File(DIMLXSL+"/tools/preprocess.xsl");    
    
    Source input;
    DOMResult output;
    
    // load DiMLFile
    File dimlFile = new File(args[0]);
    if(!dimlFile.exists()) dimlFile = new File(args[0]+".xml");
    if(!dimlFile.exists()) dimlFile = new File(args[0]+"_xdiml.xml");
    if(!dimlFile.exists()) {
      message("xdiml file does not exist!");  
    }  
	  
    // load preprocess.xsl
		message("preprocessing");
		Templates preprocess = loadXSL(preprocessFile);
    Transformer t = preprocess.newTransformer();
    input = new StreamSource(dimlFile);
 	  output = new DOMResult();
 	  message("\ttransforming "+dimlFile);
	  t.transform(input, output);
	  message("\tdone.");
    
    String preFile = resultDir+File.separator+"-pre.xml";
    message("preprocessing done (writing to "+preFile+")");
            
    DOMSource domSource = new DOMSource(output.getNode());
    StreamResult streamResult = new StreamResult(new FileWriter(preFile));
    Transformer serializer = tFactory.newTransformer();
    serializer.setOutputProperty(OutputKeys.ENCODING,"ISO-8859-1");
    serializer.transform(domSource, streamResult);     

    // load XSL
    if(makeHTMLFiles)
      templates = loadXSL(diml2htmlFile);
    
    // create output	
    run(output.getNode()); 
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