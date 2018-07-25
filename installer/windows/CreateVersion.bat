@ECHO OFF
rem /f CargoTubeVersion.nsh
FOR /F "delims=" %%i IN ('git describe --tags') DO set VERSION=%%i
@echo !define VERSION "%VERSION%" > CargoTubeVersion.nsh
