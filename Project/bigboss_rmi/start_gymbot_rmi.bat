@echo off
cd /d %~dp0

echo [1/3] Compiling Java RMI source files...
javac -d Project Project\bigboss_rmi\*.java

echo [2/3] Starting rmiregistry...
start cmd /k "cd /d %~dp0\Project && set CLASSPATH=.;%cd% && rmiregistry"

echo [3/3] Launching RMI Server...
timeout /t 2 >nul
java -cp Project bigboss_rmi.GymServer

pause
