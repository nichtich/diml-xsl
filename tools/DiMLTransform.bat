@echo off

REM --- Please set the following two environment variables according ---
REM --- to your system                                               ---
REM --- First:  directory where your Java is                         ---
REM --- (e.g. c:\Programme\Java\j2re1.4.2 )                          ---
REM --- Second: directory where your diml-xsl is                     ---
REM --- (e.g. c:\thema\diml-xsl )                                    ---

rem set JAVA_HOME=
rem set DIMLXSL=

REM ---                                                              ---

set currentdir=%cd%
set batfiledir=%~dp0

rem Guess DIMLXSL if not defined

if not "%DIMLXSL%" == "" ( 
   if exist "%DIMLXSL%\tools\DiMLTransform.bat" (
      echo Using the DIMLXSL environment variable: %DIMLXSL%
      goto checkConfigFile
   ) ELSE (
      echo Error: The DIMLXSL environment variable is not defined correctly
      echo This environment variable is needed to run this program
      goto end
   )
)

IF EXIST "..\tools\DiMLTransform.bat" (
   echo DIMLXSL not set - using ..
   set DIMLXSL=..
   goto checkConfigFile
) ELSE (
   echo Error: The DIMLXSL environment variable is not defined
   echo This environment variable is needed to run this program
   goto end
)

:checkConfigFile

IF EXIST "%currentdir%\config.xml" (
   echo Using config.xml found in local directory: %currentdir%\config.xml
   set CONFIGFILE=%currentdir%\config.xml
   goto checkHTMLDir
) 
IF EXIST "%DIMLXSL%\config.xml" (
   echo Using config.xml found in DIMLXSL directory: %DIMLXSL%\config.xml
   set CONFIGFILE=%DIMLXSL%\config.xml
   goto checkHTMLDir
) ELSE (
   echo Error: Can't find config.xml file 
   echo It is needed to run this program
)

:checkHTMLDir
if exist "html" goto delHTMLs
rem for win9x: if exist "html\nul"
:makeHTMLDir
  echo Directory html does not exist, creating directory html
  mkdir html
  goto checkHACKEDDir
:delHTMLs
  echo Directory html exists, removing .html files
  cd html
  del *.html
  cd %currentdir%
  goto checkHACKEDDir

:checkHACKEDDir
if exist "hacked" goto delHACKEDs
rem for win9x: if exist "hacked\nul"
:makeHACKEDDir
  echo Directory hacked does not exist, creating directory hacked
  mkdir hacked
  goto okHome
:delHACKEDs
  echo Directory hacked exists, removing .xml files
  cd hacked
  del *.xml >nul
  cd %currentdir%
  goto okHome

:okHome
rem Get standard Java environment variables
if exist "%DIMLXSL%\tools\setclasspath.bat" goto okSetclasspath
echo Cannot find %DIMLXSL%\tools\setclasspath.bat
echo This file is needed to run this program
goto end

:okSetclasspath
set _RUNJAVA=java
REM echo "%_RUNJAVA%"
REM if exist "%_RUNJAVA%" goto okJava
REM echo Please set JAVA_HOME to point to your installation of Java
REM goto end

:okJava
rem Do you have Xalan?
if not exist "%DIMLXSL%\lib\xml-apis.jar" goto noXalan
if not exist "%DIMLXSL%\lib\xalan.jar" goto noXalan
if not exist "%DIMLXSL%\lib\xercesImpl.jar" goto noXalan
goto okXalan

:noXalan
echo Xalan or Xerces jar file is missing.
echo Please put the file xml-apis.jar, xalan.jar and xercesImpl.jar
echo into the directory %DIMLXSL%\lib
goto end

:okXalan
set BASEDIR=%DIMLXSL%
call "%DIMLXSL%\tools\setclasspath.bat"
set LOCALCLASSPATH=%CLASSPATH%;%DIMLXSL%\lib\xml-apis.jar;%DIMLXSL%\xalan.jar;%DIMLXSL%\lib\xercesImpl.jar;%DIMLXSL%\tools

:setProcessor
set XLSTPROCESSOR=org.apache.xalan.processor.TransformerFactoryImpl
REM set XLSTPROCESSOR=jd.xml.xslt.trax.TransformerFactoryImpl
REM set XLSTPROCESSOR=net.sf.saxon.TransformerFactoryImpl
REM set XLSTPROCESSOR=com.icl.saxon.om.DocumentBuilderFactoryImpl # Saxon old
REM set XLSTPROCESSOR=org.apache.xalan.xsltc.trax.TransformerFactoryImpl
REM set XLSTPROCESSOR=oracle.xml.jaxp.JXSAXTransformerFactory

:exec
set MAINCLASS=DiMLTransform
set ARGUMENTS=%*
@echo on
%_RUNJAVA% -Xmx512M -Xms128M -Djavax.xml.transform.TransformerFactory=%XLSTPROCESSOR% -DDIMLXSL="%DIMLXSL%" -classpath "%LOCALCLASSPATH%" %MAINCLASS% -c"%CONFIGFILE%" %ARGUMENTS%

REM -DTOOLSDir=$TOOLSDir -DRESULTDir=$RESULTDir -classpath $CLASSPATH $MAINCLASS -P$PREPROCESSING $XMLFILE $ARGUMENTS

:end