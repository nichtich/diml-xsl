#!/bin/bash

DIMLXSL=..
CLASSPATH=$DIMLXSL/tools/:$DIMLXSL/lib/xml-apis.jar:$DIMLXSL/xalan.jar:$DIMLXSL/lib/xercesImpl.jar

MAINCLASS=DiMLTransform
ARGUMENTS=$*

java -DDIMLXSL=$DIMLXSL -classpath "$CLASSPATH" $MAINCLASS $ARGUMENTS
