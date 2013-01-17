@ECHO OFF

@REM *** Set global variable
@REM SET JAVA_HOME=C:\Progra~1\Java\jre1.6.0_07\
SET JAVA=%JAVA_HOME%\bin\java.exe
SET JAVA_HEAP_MAX=-Xmx256M
SET HADOOP_DATANODE_OPTS=
SET HADOOP_CLASSPATH=
SET HADOOP_OPTS=

@REM *** Find the bin directory for the start-dfs.bat script
SET BIN=%~dp0 
CD %BIN%

@REM *** Find the Hadoop home directory
PUSHD ..
SET HADOOP_HOME=%CD%
SET PATH=%PATH%:%BIN%
POPD


@REM Process command line
IF "%1" == "start" goto START
IF "%1" == "stop" goto STOP
IF "%1" == "status" goto STATUS
GOTO USAGE

:USAGE
ECHO "Usage: datanode.bat [start|stop|status] [--config <config dir>]"
GOTO END

:STOP
GOTO END

:STATUS
GOTO END

:START
SET HADOOP_CONF_DIR=%HADOOP_HOME%\etc
IF "%2" == "--config" SET HADOOP_CONF_DIR=%3

IF NOT EXIST %HADOOP_CONF_DIR% GOTO :ERROR

SET HADOOP_DATANODE_OPTS=-Dcom.sun.management.jmxremote %HADOOP_DATANODE_OPTS% 
SET HADOOP_LOG_DIR=%HADOOP_HOME%\logs
SET HADOOP_PID_DIR=%HADOOP_HOME%\var

IF NOT EXIST %HADOOP_LOG_DIR% MKDIR %HADOOP_LOG_DIR%
IF NOT EXIST %HADOOP_PID_DIR% MKDIR %HADOOP_PID_DIR%

SET HADOOP_IDENT_STRING=%USERNAME%
SET HADOOP_LOGFILE=hadoop-datanode-%USERNAME%.log
SET HADOOP_ROOT_LOGGER="INFO,DRFA"
SET LOG=%HADOOP_LOG_DIR%\hadoop-datanode-%USERNAME%.out
SET PID=%HADOOP_PID_DIR%\hadoop-datanode-%USERNAME%.pid

IF EXIST %PID% GOTO RUNNING

SET CLASSPATH=%HADOOP_HOME%;%HADOOP_CONF_DIR%
SET CLASSPATH=%CLASSPATH%;%JAVA_HOME%\lib\tools.jar
SET CLASSPATH=%CLASSPATH%;%HADOOP_HOME%\lib\commons-cli-1.2.jar
SET CLASSPATH=%CLASSPATH%;%HADOOP_HOME%\lib\commons-codec-1.3.jar
SET CLASSPATH=%CLASSPATH%;%HADOOP_HOME%\lib\commons-logging-1.0.4.jar
SET CLASSPATH=%CLASSPATH%;%HADOOP_HOME%\lib\commons-net-1.4.1.jar
SET CLASSPATH=%CLASSPATH%;%HADOOP_HOME%\lib\commons-el-1.0.jar
SET CLASSPATH=%CLASSPATH%;%HADOOP_HOME%\lib\core-3.1.1.jar
SET CLASSPATH=%CLASSPATH%;%HADOOP_HOME%\lib\jasper-runtime-5.5.12.jar
SET CLASSPATH=%CLASSPATH%;%HADOOP_HOME%\lib\jasper-compiler-5.5.12.jar
SET CLASSPATH=%CLASSPATH%;%HADOOP_HOME%\lib\jets3t-0.6.1.jar
SET CLASSPATH=%CLASSPATH%;%HADOOP_HOME%\lib\jetty-6.1.14.jar
SET CLASSPATH=%CLASSPATH%;%HADOOP_HOME%\lib\jetty-util-6.1.14.jar
SET CLASSPATH=%CLASSPATH%;%HADOOP_HOME%\lib\kfs-0.2.2.jar
SET CLASSPATH=%CLASSPATH%;%HADOOP_HOME%\lib\log4j-1.2.15.jar
SET CLASSPATH=%CLASSPATH%;%HADOOP_HOME%\lib\jsp-api-2.1.jar
SET CLASSPATH=%CLASSPATH%;%HADOOP_HOME%\lib\jsp-2.1.jar
SET CLASSPATH=%CLASSPATH%;%HADOOP_HOME%\lib\servlet-api-2.5-6.1.14.jar
SET CLASSPATH=%CLASSPATH%;%HADOOP_HOME%\lib\xmlenc-0.52.jar
SET CLASSPATH=%CLASSPATH%;%HADOOP_HOME%\lib\__VERSION__-hdfs.jar
IF EXIST %HADOOP_CONF_DIR%\hadoop-policy.xml SET HADOOP_POLICYFILE=hadoop-policy.xml

SET CLASS=org.apache.hadoop.hdfs.server.datanode.DataNode

SET HADOOP_OPTS=%HADOOP_OPTS% %HADOOP_DATANODE_OPTS%
SET HADOOP_OPTS=%HADOOP_OPTS% -Dhadoop.log.dir=%HADOOP_LOG_DIR%
SET HADOOP_OPTS=%HADOOP_OPTS% -Dhadoop.log.file=%HADOOP_LOGFILE%
SET HADOOP_OPTS=%HADOOP_OPTS% -Dhadoop.home.dir=%HADOOP_HOME%
SET HADOOP_OPTS=%HADOOP_OPTS% -Dhadoop.id.str=%HADOOP_IDENT_STRING%
SET HADOOP_OPTS=%HADOOP_OPTS% -Dhadoop.root.logger=%HADOOP_ROOT_LOGGER%
SET HADOOP_OPTS=%HADOOP_OPTS% -Dhadoop.policy.file=%HADOOP_POLICYFILE%

@REM GOTO PRINT
%JAVA% %JAVA_HEAP_MAX% %HADOOP_OPTS% -classpath "%CLASSPATH%" %CLASS%

GOTO END


:PRINT
ECHO
ECHO HADOOP_HOME	%HADOOP_HOME%
ECHO HADOOP_CONF_DIR	%HADOOP_CONF_DIR%
ECHO HADOOP_DATANODE_OPTS	%HADOOP_DATANODE_OPTS%
ECHO HADOOP_LOG_DIR	%HADOOP_LOG_DIR%
ECHO HADOOP_PID_DIR	%HADOOP_PID_DIR%
ECHO HADOOP_IDENT_STRING %HADOOP_IDENT_STRING%
ECHO HADOOP_LOGFILE	%HADOOP_LOGFILE%
ECHO LOG	%LOG%
ECHO PID	%PID%
ECHO CLASSPATH	%CLASSPATH%
ECHO CLASS	%CLASS%
ECHO HADOOP_POLICYFILE	%HADOOP_POLICYFILE%
ECHO HADOOP_OPTS	%HADOOP_OPTS%
GOTO END

:RUNNING
ECHO Datanode already running
GOTO END

:ERROR
ECHO Cannot start the datanode
GOTO END

:END
