@rem
@rem Get current directory 
@rem http://home7.inet.tele.dk/batfiles/main/tricktip.htm#46
@rem 
@SET cd=
@SET promp$=%prompt%
@PROMPT SET cd$Q$P
@CALL>%temp%.\setdir.bat
@
% do not delete this line %
@ECHO off
PROMPT %promp$%
FOR %%c IN (CALL DEL) DO %%c %temp%.\setdir.bat
set currentdir=%cd%


@echo off
rem Guess DIMLXSL if not defined
if not "%DIMLXSL%" == "" goto checkHTMLDir
echo DIMLXSL not set - using ..
set DIMLXSL=..

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
  goto gotHome
:delHACKEDs
  echo Directory hacked exists, removing .xml files
  cd hacked
  del *.xml >nul
  cd %currentdir%
  goto gotHome

:gotHome

if exist "%DIMLXSL%\tools\DiMLTransform.bat" goto okHome
echo The DIMLXSL environment variable is not defined correctly
echo This environment variable is needed to run this program
goto end

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
set CLASSPATH=%CLASSPATH%;%DIMLXSL%\lib\xml-apis.jar;%DIMLXSL%\xalan.jar;%DIMLXSL%\lib\xercesImpl.jar;%DIMLXSL%\tools

:setProcessor
set XLSTPROCESSOR=org.apache.xalan.processor.TransformerFactoryImpl
REM set XLSTPROCESSOR=jd.xml.xslt.trax.TransformerFactoryImpl
REM set XLSTPROCESSOR=net.sf.saxon.TransformerFactoryImpl
REM set XLSTPROCESSOR=org.apache.xalan.xsltc.trax.TransformerFactoryImpl
REM set XLSTPROCESSOR=oracle.xml.jaxp.JXSAXTransformerFactory

:exec
set MAINCLASS=DiMLTransform
set ARGUMENTS=%*
REM @echo on
%_RUNJAVA% -Xmx512M -Xms128M -Djavax.xml.transform.TransformerFactory=%XLSTPROCESSOR% -DDIMLXSL=%DIMLXSL% -classpath "%CLASSPATH%" %MAINCLASS% %ARGUMENTS%

REM -DTOOLSDir=$TOOLSDir -DRESULTDir=$RESULTDir -classpath $CLASSPATH $MAINCLASS -P$PREPROCESSING $XMLFILE $ARGUMENTS

:end