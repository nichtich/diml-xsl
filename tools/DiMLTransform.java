import java.io.*;
import java.text.DateFormat;
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
	File configFile = null;

  String selectedId = "";
  int verboseLevel = 0;
	Templates templates;
	File resultDir;
	File resultDirHTML;
	File resultDirHACKED;

  boolean debugMode = false;
  
	private boolean generateHTMLFiles = true;
	private boolean generateCMSFiles  = true;
	private boolean doPreprocessing   = true;
  
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
		return t;
  }
    
	
	public void run(Node document) throws ParserConfigurationException, TransformerException, IOException {
		Source input;    
	  DOMResult output;
		
		input = new DOMSource(document); 
		// TODO: validate
		
		//getDocumentElement();
		Element e = (Element)XPathAPI.selectSingleNode(document,"/*"); 
		
		message("transforming:");
    params.put("CONVDATE",DateFormat.getDateInstance().format(new Date()));
    if(cssDirectory!=null) params.put("STYLEDIRECTORY",cssDirectory.toString()+File.separator);

    
    if(e.getTagName() == "etd") {				 		 
		 		  
		 // load diml2cms.xsl
	   Templates diml2cms = loadXSL(diml2cmsFile);
		   		  
     // if you do not want do split, just use "/etd";    
     String xpath = "/etd/front|/etd/body/*|/etd/back/*";
	   
	   if (!selectedId.equals("")) xpath = "//*[@id='"+selectedId+"']";
	   
	   NodeList parts = selectParts(document,xpath);	

	   message("document split into "+parts.getLength()+" parts:");
	     
	   // TODO: if there are no parts...	  	  
	   for(int s=0; s<parts.getLength(); s++) {
  	   Node node = parts.item(s);  	  
	  		  	 
	  	 if(node.getAttributes().getNamedItem("id")==null) {
	  	   message("@id of element missing");
	  	   System.exit(0);
	  	 } 
	  	 
	  	 String id = node.getAttributes().getNamedItem("id").getNodeValue();
	  	 params.put("SELECTID",id);
	  	 
	  	 Node cmsd=null;
	  	 
       if (generateCMSFiles || generateHTMLFiles) {	 
	       Transformer transformer = diml2cms.newTransformer();
	       input  = new DOMSource(document);
	       output = new DOMResult();
	       setParameters(transformer);
	       transformer.transform(input, output);
	       cmsd = output.getNode();	 
       } else {
         message("-i "+id);
       }              

     if(generateCMSFiles) { 
         String cmsContainerFile = resultDirHACKED+"/"+id+".xml";  

         DOMSource domSource = new DOMSource(cmsd);
         StreamResult streamResult = new StreamResult(new FileWriter(cmsContainerFile));

         message("writing cms:container "+cmsContainerFile);

         Transformer serializer = tFactory.newTransformer();
         serializer.setOutputProperty(OutputKeys.ENCODING,"ISO-8859-1");
         //TODO: validate!
         //serializer.setOutputProperty(OutputKeys.DOCTYPE_SYSTEM,"cms.dtd");
         //serializer.setOutputProperty(OutputKeys.INDENT,"yes");
         serializer.transform(domSource, streamResult); 
       }

       if(generateHTMLFiles) {    
  	   String resultFile = resultDirHTML+"/"+id+".html"; 

  	   message("transforming "+resultFile);      		
  	   //message("manually: 'diml2html.xsl SELECTID="+id+"'"+params);

           Transformer transformer = templates.newTransformer();
           setParameters(transformer);

           input  = new DOMSource(cmsd);
           StreamResult out = new StreamResult(resultFile);
           transformer.transform(input, out);	       
        }
		} // end for
	  } else {
	    errorMsg("File "+dimlFile+" contains no DiML-Document!");
   	}      	
		
            message("everything done.");
	}
	
	 	 	 	
  public void message(String msg) {
    System.out.println(msg);
	}  	

  public void errorMsg(String msg) {
    System.err.println(msg);
    System.exit(1);
	}

  public void action(String[] args) throws Exception {
    try {
    resultDir = new File(".");
    resultDirHTML = new File("html");
    resultDirHACKED = new File("hacked");

    DIMLXSL = System.getProperty("DIMLXSL","..");
    configFile = new File(System.getProperty("DIMLXSLCONFIG","config.xml"));

    diml2cmsFile  = new File(DIMLXSL+"/tools/diml2cms.xsl");
    diml2htmlFile = new File(DIMLXSL+"/diml2html.xsl");
    preprocessFile = new File(DIMLXSL+"/tools/preprocess.xsl");    

    Source input;
    DOMResult output;

    if(!parseArgs(args))
      printUsageAndExit();

      if (!resultDir.exists()) resultDir.mkdirs();
      if (!resultDirHTML.exists()) resultDir.mkdirs();
      if (!resultDirHACKED.exists()) resultDir.mkdirs();
      if (!resultDir.isDirectory()) {
        message("unable to create result output directory: " + resultDir);
        return;
      }  
      if (!resultDirHTML.isDirectory()) {
        message("unable to create HTML output directory: " + resultDirHTML);
        return;
      }  
      if (!resultDirHACKED.isDirectory()) {
        message("unable to create HACKED output directory: " + resultDirHACKED);
        return;
      }  

      if (!configFile.exists()) {
        configFile = new File(DIMLXSL+File.separator+"config.xml");
        if (!configFile.exists())
          errorMsg("Config file "+configFile+" does not exist!");
      } 
      params.put("CONFIGFILE",configFile.getAbsolutePath());

      Node doc=null;
	  	  
	  
    if(doPreprocessing) {
      // load preprocess.xsl
      message("preprocessing");
      Templates preprocess = loadXSL(preprocessFile);
      Transformer transformer = preprocess.newTransformer();
      setParameters(transformer);            
      input = new StreamSource(dimlFile);
      output = new DOMResult();
      message("\ttransforming "+dimlFile);
      transformer.transform(input, output);
    
      String preFile = resultDir+File.separator+"_pre.xml";
      message("preprocessing done - writing "+preFile);
            
      DOMSource domSource = new DOMSource(output.getNode());
      StreamResult streamResult = new StreamResult(new FileWriter(preFile));
      Transformer serializer = tFactory.newTransformer();
      serializer.setOutputProperty(OutputKeys.ENCODING,"ISO-8859-1");
      serializer.transform(domSource, streamResult);     
      doc = output.getNode();
    } else {
      message("using "+dimlFile+" without preprocessing");
      DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
      DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
      doc = dBuilder.parse(dimlFile);
    }  

    // load XSL
    if(generateHTMLFiles)
      templates = loadXSL(diml2htmlFile);
    
    // create output	
    run(doc); 
    } catch(javax.xml.transform.TransformerException e) {
		  if(verboseLevel < 2)
		    System.err.println("TransformerException"+e.getLocationAsString()+": "+e.getMessage());
		  else throw e;
		}
  }

  private void setParameters(Transformer transformer) {
    Enumeration keys = params.keys();
    String name,value;
    
    while(keys.hasMoreElements()) {
      name = (String)keys.nextElement();
      value = (String)params.get(name);
      transformer.setParameter(name,value);
    }
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
		}  /*catch(Exception e) {
		  System.out.println("HEY!");
		  System.out.println(e.getClass().getName());
		} */ 	 		 
	}
	
	private void setDiMLFile(String name) {
	  dimlFile = new File(name);
	  if(!dimlFile.exists()) dimlFile = new File(name+".xml");
    if(!dimlFile.exists()) dimlFile = new File(name+"_xdiml.xml");
    if(!dimlFile.exists())
      errorMsg("XDiML file "+name+" does not exist!");  
  }  

  public int atoi(String s) {
    try {
      return (new Integer(s)).intValue(); 
    } catch(NumberFormatException nfe) {
      return 0;
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
          else if(c=='s') cssDirectory = new File(value);
          else if(c=='o') resultDir = new File(value);
          else if(c=='x') resultDirHACKED = new File(value);
          else if(c=='h') resultDirHTML = new File(value);
          else if(c=='p') preprocessFile = new File(value);
          else if(c=='P') doPreprocessing = value.equals("0") ? false : true;
          else if(c=='H') generateHTMLFiles = value.equals("0") ? false : true;
          else if(c=='C') generateCMSFiles = value.equals("0") ? false : true;          
          else if(c=='v') verboseLevel = atoi(value);
          else if(c=='c') configFile = new File(value);
          else if(c=='i') selectedId = value;  
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
		s += "Usage: java DiMLTransform <dimlFile> [<resultDir> [<cssDir>]] [PARAMS]\n";
		s += "You can also use the following arguments:\n";
		s += " -f dimlFile (also test dimlFile_xdiml.xml and dimlFile.xml)\n";
		s += " -d debug Mode\n";
		s += " -v n verbose Level n\n";
		s += " -s cssDirectory (location of xdiml.css)\n";
		s += " -o resultDir (current directory if omitted)\n";
		s += " -x resultDir hacked XML (./hacked/ if omitted)\n";
		s += " -h resultDir HTML (./html/ if omitted)\n";
		s += " -c configFile (default $DIMLXSLCONFIG or config.xml)\n";
		s += " -p preprocessFile (preprocess.xsl)\n";
		s += " -i select one id - only process this part of the document\n";
    s += " -P1 use preprocessor    / -P0 do not preprocess\n";		
		s += " -C1 generate CMS files  / -C0 do not generate CMS files\n";
    s += " -H1 generate HTML files / -H0 do not generate CMS files\n";		
    s += " PARAM=VALUE pairs are passed through to the XSLT scripts\n";
    s += "\nExamples:\n";
    s += "  DiMLTransform foo_xdiml.xml html/ ../style/\n";
    s += "  DiMLTransform -P0 -f _pre.xml -o html/ -c ../style/\n";
    s += "  DiMLTransform foo -i front -C0\n";

		System.out.println(s);
		System.exit(0);
	}
}