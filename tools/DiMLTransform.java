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
	
	String DIMLXSL;
	
	File dimlFile = null;
	File cssDirectory = null;
	
	File diml2cmsFile  = null;
	File diml2htmlFile = null;
	File preprocessFile = null;

  boolean debugMode = false;
  
	private boolean generateHTMLFiles = true;
	private boolean generateCMSFiles  = true;
  
  Hashtable params = new Hashtable();
	
	
	TransformerFactory tFactory = TransformerFactory.newInstance(); 
	
	public DiMLTransform() {}
  	  	  

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
    
    if(e.getTagName() == "etd") {				 		 
		 		  
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
	 
	     Transformer transformer = diml2cms.newTransformer();
	     input  = new DOMSource(document);
	     output = new DOMResult();
	     transformer.setParameter("SELECTID",id);	     
	     transformer.setParameter("VOCFILE",DIMLXSL+"/vocables.xml");
	     transformer.transform(input, output);
	     Node cmsd = output.getNode();	 

       String cmsContainerFile = resultDir+"/"+id+".xml";
       	 
	     if(generateCMSFiles) { 
	       
         DOMSource domSource = new DOMSource(cmsd);
         StreamResult streamResult = new StreamResult(new FileWriter(cmsContainerFile));
   
         message("writing cms:container "+cmsContainerFile);
         message("manually: 'diml2cms.xsl SELECTID="+id+"'");
         
         Transformer serializer = tFactory.newTransformer();
         serializer.setOutputProperty(OutputKeys.ENCODING,"ISO-8859-1");
         //serializer.setOutputProperty(OutputKeys.DOCTYPE_SYSTEM,"cms.dtd");
         //serializer.setOutputProperty(OutputKeys.INDENT,"yes");
         serializer.transform(domSource, streamResult); 
       }

       if(generateHTMLFiles) {    
	  	   String resultFile = resultDir+"/"+id+".html"; 
	  	   
	  	   message("transforming "+resultFile);      		
	  	   message("manually: 'diml2html.xsl SELECTID="+id+"'");
	  	   
	       transformer = templates.newTransformer();
	       transformer.setParameter("VOCFILE",DIMLXSL+"/vocables.xml");
	       if(cssDirectory!=null) transformer.setParameter("STYLEDIRECTORY",cssDirectory.toString());
	       
	       input  = new DOMSource(cmsd);
	       StreamResult out = new StreamResult(resultFile);
	       transformer.transform(input, out);	       
		   }
		} // end for
		} else {
    	message("Document is no DiML-Document: "+dimlFile);
      return;
   	}      	
		
		message("everything done.");
	}

  /**
   * Load DiML Document
   */
  /*public Document parseDocument(String source) throws ParserConfigurationException, SAXException, IOException {  
	  //dimlFile = new File(source);
	    
		DocumentBuilder dBuilder = dFactory.newDocumentBuilder();
		
	  ErrorHandlerImpl handler = new ErrorHandlerImpl();
	  dBuilder.setErrorHandler(handler);
		
	  Document doc = dBuilder.parse(dimlFile);
		    
	  if(!handler.errors.isEmpty()) {
	  	throw new SAXException(handler.getErrorMessages());
	  }
	  	  
	  return doc;    
  }	*/
	
	 	 
	private Templates templates;
	private File resultDir;
	 	
  public void message(String msg) {
    System.out.println(msg);
	}  	


  public void action(String[] args) throws Exception {
    
    resultDir = new File(".");        
    
    DIMLXSL = System.getProperty("DIMLXSL","..");
    diml2cmsFile  = new File(DIMLXSL+"/tools/diml2cms.xsl");
	  diml2htmlFile = new File(DIMLXSL+"/diml2html.xsl");
	  preprocessFile = new File(DIMLXSL+"/tools/preprocess.xsl");    
        
    Source input;
    DOMResult output;
        
    if(!parseArgs(args))
      printUsageAndExit();
    
 		if (!resultDir.exists()) resultDir.mkdirs();
 		if (!resultDir.isDirectory()) {
      message("unable to create output directory: "+resultDir);
      return;
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
    
    String preFile = resultDir+File.separator+"_pre.xml";
    message("preprocessing done (writing to "+preFile+")");
            
    DOMSource domSource = new DOMSource(output.getNode());
    StreamResult streamResult = new StreamResult(new FileWriter(preFile));
    Transformer serializer = tFactory.newTransformer();
    serializer.setOutputProperty(OutputKeys.ENCODING,"ISO-8859-1");
    serializer.transform(domSource, streamResult);     

    // load XSL
    if(generateHTMLFiles)
      templates = loadXSL(diml2htmlFile);
    
    // create output	
    run(output.getNode()); 
  }

  
	public static void main(String[] args) throws Exception {
		if(args.length<1) {
			printUsageAndExit();
		}
		try {
		  DiMLTransform tr = new DiMLTransform();
		  tr.action(args);
		} catch(org.apache.xml.dtm.DTMException e) {
		  System.err.println("DTDException! Propably there is not enough memory or an old version of Xalan\n" +
		  "You may specify java to use more memory with -Xms and -Xmx\n"+
		  "On some Linux JVMs there is a build in Jaxp xalan-implementatation."+
		  "In this case you have to put xalan.jar into java/lib/endorsed/ to override it!\n"+
		  e.getMessage()
		  );
		  //System.err.println("File not found!"+e.getMessage());
		} catch(javax.xml.transform.TransformerException e) {
		  System.out.println("TransformerException"+e.getLocationAsString()+": "+e.getMessage());
		} /*catch(Exception e) {
		  System.out.println("HEY!");
		  System.out.println(e.getClass().getName());
		} */ 	 		 
	}
	
	private void setDiMLFile(String name) {
	  dimlFile = new File(name);
	  if(!dimlFile.exists()) dimlFile = new File(name+".xml");
    if(!dimlFile.exists()) dimlFile = new File(name+"_xdiml.xml");
    if(!dimlFile.exists()) {
      message("xdiml file does not exist!");  
      System.exit(0);
    }  
  }  


  /**
   * Parse command line arguments
   * @returns true if there is no error
   */
  private boolean parseArgs(String [] args) {    
    int n=0; // 0: dimlFile 1:resultDir 2:cssDirectory
    for(int i=0; i<args.length; i++) {
      String arg = args[i];
      char c = (arg.length()>1) ? arg.charAt(1) : 0;
      if(arg.charAt(0)=='-' && c!=0) { // flag (starting with '-')      
        String value = "";
        if(arg.length()>2) value = arg.substring(2);
        else value = i<args.length-1 ? args[++i] : "";
        
        if(!value.equals("")) { // attributes that need a value
               if(c=='f') setDiMLFile(value);
          else if(c=='c') cssDirectory = new File(value);
          else if(c=='o') resultDir = new File(value);
          else if(c=='p') preprocessFile = new File(value);
          else if(c=='H') generateHTMLFiles = value.equals("0") ? false : true;
          else if(c=='C') generateCMSFiles = value.equals("0") ? false : true;          
          // -v : verbose
        }
        if(c=='d') debugMode = true;
        else if(c=='?' || c=='h') return false;
      } else { //
        int p = arg.indexOf("=");
        if(p==-1) { // simple argument
          if(n==0) setDiMLFile(arg);
          else if(n==1) resultDir = new File(arg);
          else if(n==2) cssDirectory = new File(arg);
          n++;
        } else { // key=value pair
          String k = arg.substring(0,p);
          String v = arg.substring(p+1);
          if(!k.equals("")) params.put(k,v);
        }
      } 
    }              
    return true;
  }  
	

	public static void printUsageAndExit() {
		String s;

		s  = "DiMLTransform - generate html output from DiML\n";
		s += "Usage: java DiML2html [<dimlFile> [<resultDir> [<cssDir>]] [<options>]\n";
		s += " -f dimlFile\n";
		s += " -d : Debug Mode\n";
		s += " -v : verbose Level\n";
		s += " -c cssDirectory (location of xdiml.css)\n";
		s += " -o resultDir\n";
		s += " -p preprocessFile (preprocess.xsl)\n";
		s += " -H (0/1) generate HTML files\n";

		System.out.println(s);
		System.exit(0);
	}
}