@echo off

REM --- You may set the following two environment variables          ---
REM --- according to your system                                     ---
REM --- (but maybe the system works without setting them)            ---
REM --- First:  directory where your Java is, without trailing \     ---                         ---
REM --- (e.g. c:\Programme\Java\j2re1.4.2 )                          ---
REM --- Second: directory where your diml-xsl is, without trailing \ ---
REM --- (e.g. c:\thema\diml-xsl )                                    ---

rem set JAVA_HOME=
rem set DIMLXSL=

REM ---                                                              ---

set currentdir=%cd%
set currentdir=%currentdir%\
set batfiledir=%~dp0
set xmlfiledir=%~dp1

REM * Warning, if not started from directory of xml-file (works anyway) *
REM * Set working directory as directory of xml-file or current directory *
if not "%xmlfiledir%" == "" (
  if not "%xmlfiledir%" == "%currentdir%" (
    echo Warnung: DiMLTransform is supposed to be started from the directory of xml-file!
  )
  set workdir=%xmlfiledir%
) ELSE (  
  set workdir=%currentdir%
)

set htmldir=%workdir%..\
set hackeddir=%workdir%..\

REM * if DIMLXSL is defined and okay, use it *
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

REM * Guess DIMLXSL from location of bat-File if not defined *
IF EXIST "%batfiledir%DiMLTransform.bat" (
   echo DIMLXSL not set - using %batfiledir%..
   set DIMLXSL=%batfiledir%..
   goto checkConfigFile
) ELSE (
   echo Error: The DIMLXSL environment variable is not defined
   echo This environment variable is needed to run this program
   goto end
)

:checkConfigFile

REM * search Configfile in Workdirectory or in current directory *
IF EXIST "%workdir%config.xml" (
   echo Using config.xml found in xml-file directory: %workdir%config.xml
   set CONFIGFILE=%workdir%config.xml
   goto checkHTMLDir
) ELSE (
   echo Warning: config.xml does not exist in xml-file directory: %workdir%
)

IF EXIST "%currentdir%config.xml" (
   echo Using config.xml found in current directory: %currentdir%config.xml
   set CONFIGFILE=%currentdir%config.xml
   goto checkHTMLDir
) ELSE (
    echo Error: Can't find config.xml file in current directory %currentdir%
    echo It is needed to run this program
    goto end
)

REM rem do not use diml-xsl directory any more
REM IF EXIST "%DIMLXSL%\config.xml" (
REM    echo Using config.xml found in DIMLXSL directory: %DIMLXSL%\config.xml
REM   set CONFIGFILE=%DIMLXSL%\config.xml
REM   goto checkHTMLDir
REM ) ELSE (
REM    echo Error: Can't find config.xml file 
REM    echo It is needed to run this program
REM    goto end
REM )

:checkHTMLDir
REM *Create htmldir or delete files in htmldir *
if exist "%htmldir%html" goto delHTMLs
rem for win9x: if exist "%htmldir%html\nul"
:makeHTMLDir
  echo Directory %htmldir%html does not exist, creating it
  mkdir "%htmldir%html"
  goto checkHACKEDDir
:delHTMLs
  echo Directory %htmldir%html exists, removing .html files
  cd "%htmldir%html"
  del *.html >nul
  cd "%currentdir%"
  goto checkHACKEDDir

:checkHACKEDDir
REM *Create hackeddir or delete files in hackeddir *
if exist "%hackeddir%hacked" goto delHACKEDs
rem for win9x: if exist "%hackeddir%hacked\nul"
:makeHACKEDDir
  echo Directory %hackeddir%hacked does not exist, creating it
  mkdir "%hackeddir%hacked"
  goto okHome
:delHACKEDs
  echo Directory %hackeddir%hacked exists, removing .xml files
  cd "%hackeddir%hacked"
  del *.xml >nul
  cd "%currentdir%"
  goto okHome

:okHome
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
REM *Set Classpath*

set LOCALCLASSPATH=%CLASSPATH%;%DIMLXSL%\lib\xml-apis.jar;%DIMLXSL%\xalan.jar;%DIMLXSL%\lib\xercesImpl.jar;%DIMLXSL%\tools

rem Variable JAVA_HOME not set: use just "java" as executable
if not "%JAVA_HOME%" == "" goto gotJavaHome
echo Warning: The JAVA_HOME environment variable is not defined
echo Try setting this variable if DiMLTranform fails
set _RUNJAVA=java
goto setProcessor

:gotJavaHome
rem Variable JAVA_HOME is set: use location or if not exist, again just "java"
if not exist "%JAVA_HOME%\bin\java.exe" goto noJavaHome
rem everything o.k. with java
set _RUNJAVA="%JAVA_HOME%\bin\java"
echo Using %JAVA_HOME%\bin\java.exe
set LOCALCLASSPATH = %LOCALCLASSPATH%;%JAVA_HOME%\lib\tools.jar
goto setProcessor
:noJavaHome
echo Warning: The JAVA_HOME environment variable is not defined correctly,
echo "%JAVA_HOME%\bin\java.exe" not found
set _RUNJAVA=java

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
REM @echo on
%_RUNJAVA% -Xmx512M -Xms128M -Djavax.xml.transform.TransformerFactory=%XLSTPROCESSOR% -DDIMLXSL="%DIMLXSL%" -classpath "%LOCALCLASSPATH%" %MAINCLASS% -c"%CONFIGFILE%" %ARGUMENTS%

REM -DTOOLSDir=$TOOLSDir -DRESULTDir=$RESULTDir -classpath $CLASSPATH $MAINCLASS -P$PREPROCESSING $XMLFILE $ARGUMENTS

:end
