#!/bin/bash

if [[ -e html/ ]] 
then 
  echo Directory html/ exists, removing .html files
  cd html/
  rm -f *.html
  cd ..
else
  echo Directory html/ does not exist, creating directory html/
  mkdir html
fi

if [[ -e hacked/ ]] 
then 
  echo Directory hacked/ exists, removing .xml files
  cd hacked/
  rm -f *.xml
  cd ..
else
  echo Directory hacked/ does not exist, creating directory hacked/
  mkdir hacked
fi


DIMLXSL=..
CLASSPATH=$DIMLXSL/tools/:$DIMLXSL/lib/xml-apis.jar:$DIMLXSL/xalan.jar:$DIMLXSL/lib/xercesImpl.jar

MAINCLASS=DiMLTransform
ARGUMENTS=$*

java -DDIMLXSL=$DIMLXSL -classpath "$CLASSPATH" $MAINCLASS $ARGUMENTS
