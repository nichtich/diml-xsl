#!/bin/bash

echo please modfiy this file to fit your needs!

DIMLXSL=..
CLASSPATH=$DIMLXSL/tools/:$DIMLXSL/lib/xml-apis.jar:$DIMLXSL/xalan.jar:$DIMLXSL/lib/xercesImpl.jar

MAINCLASS=DiMLTransform
ARGUMENTS=$*

java -DDIMLXSL=$DIMLXSL -classpath "$CLASSPATH" $MAINCLASS $ARGUMENTS
