import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.SAXParseException;
import org.xml.sax.ErrorHandler;
import javax.xml.parsers.DocumentBuilderFactory;
import java.util.ArrayList;
import java.io.*;

/**
 * Implements a frameset for reading XML sources.
 * Validating and Namespaces are switched on by default.
 * Provides an implementation of ErrorHandler.
 */
public class XMLReading {
	DocumentBuilderFactory dFactory;
	
	public XMLReading() {
		dFactory =  DocumentBuilderFactory.newInstance();
		
		dFactory.setNamespaceAware(true);
    dFactory.setValidating(true);
  }
      
  class ErrorHandlerImpl implements ErrorHandler {
  	ArrayList errors = new ArrayList();   
  	ArrayList warnings = new ArrayList(); 
    
    public void error(SAXParseException exception) {
    	errors.add(exception);
    }
    
    public void warning(SAXParseException exception) {
    	warnings.add(exception);
    }	
    
    public void fatalError(SAXParseException exception) throws SAXParseException {
      throw exception;
    }
  
    public String getErrorMessages() {
    	String s = "";
    	for(int i=0; i<errors.size(); i++) {
    		SAXParseException ex = (SAXParseException)errors.get(i);    		
    		s += ex.getSystemId() + " line " + ex.getLineNumber() + ": " + ex.getMessage() + "\n";
    	}
    	return s;
    }
  }	
  
  /**
   * static utility function to test whether a file is XML
   */
  public static boolean isXMLFile(File f) {
  	try {
      FileReader freader = new FileReader(f);
  	  char[] chars = new char[5];
  	  if(freader.read(chars,0,5)==5)
  	    return (new String(chars)).equals("<?xml");
  	  else return false;  
  	} catch(FileNotFoundException e) {
  		return false;
  	}	catch(IOException e) {
  		return false;
  	}	
  }
}