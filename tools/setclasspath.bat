rem ---------------------------------------------------------------------------
rem Set CLASSPATH and Java options
rem ---------------------------------------------------------------------------

rem Make sure prerequisite environment variables are set
if not "%JAVA_HOME%" == "" goto gotJavaHome
echo Warning: The JAVA_HOME environment variable is not defined
echo Try setting this variable if DiMLTranform fails
goto end
:gotJavaHome
if not exist "%JAVA_HOME%\bin\java.exe" goto noJavaHome
REM if not exist "%JAVA_HOME%\bin\javaw.exe" goto noJavaHome
REM if not exist "%JAVA_HOME%\bin\jdb.exe" goto noJavaHome
REM if not exist "%JAVA_HOME%\bin\javac.exe" goto noJavaHome
goto okJavaHome
:noJavaHome
echo Error: The JAVA_HOME environment variable is not defined correctly
echo This environment variable is needed to run this program
goto end

:okJavaHome
rem Set standard CLASSPATH
rem Note that there are no quotes as we do not want to introduce random
rem quotes into the CLASSPATH
REM set CLASSPATH=%JAVA_HOME%\lib\tools.jar

rem Set standard command for invoking Java.
rem Note that NT requires a window name argument when using start.
rem Also note the quoting as JAVA_HOME may contain spaces.
set _RUNJAVA="%JAVA_HOME%\bin\java"
REM set _RUNJAVAW="%JAVA_HOME%\bin\javaw"
REM set _RUNJDB="%JAVA_HOME%\bin\jdb"
REM set _RUNJAVAC="%JAVA_HOME%\bin\javac"

:end