@echo off
rem Guess DIMLXSL if not defined
if not "%DIMLXSL%" == "" goto checkHTMLDir
echo DIMLXSL not set - using ..
set DIMLXSL=..

:checkHTMLDir
if exist "html" goto delHTMLs
:makeHTMLDir
  echo Directory html does not exist, creating directory html
  mkdir html
  goto checkHACKEDDir
:delHTMLs
  echo Directory html exists, removing .html files
  cd html
  del *.html
  cd ..
  goto checkHACKEDDir

:checkHACKEDDir
if exist "hacked" goto delHACKEDs
:makeHACKEDDir
  echo Directory hacked does not exist, creating directory hacked
  mkdir hacked
  goto checkHome
:delHACKEDs
  echo Directory hacked exists, removing .xml files
  cd hacked
  del *.xml
  cd ..
  goto checkHome


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

:exec
set MAINCLASS=DiMLTransform
set ARGUMENTS=%*
REM @echo on
%_RUNJAVA% -DDIMLXSL=%DIMLXSL% -classpath "%CLASSPATH%" %MAINCLASS% %ARGUMENTS%

:end