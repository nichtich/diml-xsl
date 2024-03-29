#!/bin/bash

CURRENTDIR=`pwd`

if [[ -e html/ ]] 
then 
  echo Directory html/ exists, removing .html files
  cd html/
  rm -f *.html
  cd $CURRENTDIR
else
  echo Directory html/ does not exist, creating directory html/
  mkdir html
fi

if [[ -e hacked/ ]] 
then 
  echo Directory hacked/ exists, removing .xml files
  cd hacked/
  rm -f *.xml
  cd $CURRENTDIR
else
  echo Directory hacked/ does not exist, creating directory hacked/
  mkdir hacked
fi


# suppose that the diml-xsl directory is in parent directory of this script
DIMLXSL=`dirname $0`/..
CLASSPATH=$DIMLXSL/tools/:$DIMLXSL/lib/xml-apis.jar:$DIMLXSL/xalan.jar:$DIMLXSL/lib/xercesImpl.jar

MAINCLASS=DiMLTransform
ARGUMENTS=$*

XLSTPROCESSOR=org.apache.xalan.processor.TransformerFactoryImpl
#XLSTPROCESSOR=jd.xml.xslt.trax.TransformerFactoryImpl
#XLSTPROCESSOR=net.sf.saxon.TransformerFactoryImpl
#XLSTPROCESSOR=com.icl.saxon.om.DocumentBuilderFactoryImpl # Saxon old
#XLSTPROCESSOR=org.apache.xalan.xsltc.trax.TransformerFactoryImpl
#XLSTPROCESSOR=oracle.xml.jaxp.JXSAXTransformerFactory

java -Xmx512M -Xms128M -Djavax.xml.transform.TransformerFactory=$XLSTPROCESSOR -DDIMLXSL=$DIMLXSL -classpath "$CLASSPATH" $MAINCLASS $ARGUMENTS

# -DTOOLSDir=$TOOLSDir -DRESULTDir=$RESULTDir -classpath $CLASSPATH $MAINCLASS -P$PREPROCESSING $XMLFILE $ARGUMENTS
