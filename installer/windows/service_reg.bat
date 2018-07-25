@echo off
setlocal

rem needs to be in the /bin of the release 

set TDP0=%~dp0
set TN0=%~n0
set P1=%1
setlocal enabledelayedexpansion

set DEFAULT_SERVICENAME=CargoTube
set DEFAULT_BOOT_FILE=cargotube

if "!SERVICENAME!"=="" (
    set SERVICENAME=!DEFAULT_SERVICENAME!
)

if "!BOOT_FILE!"=="" (
    set BOOT_FILE=!DEFAULT_BOOT_FILE!
)

if "!SERVICE_BASE!" == "" (
	set SERVICE_BASE=!TDP0!..
	for %%f in ("!SERVICE_BASE!") do set SERVICE_BASE=%%~ff
)

if "!SERVICE_EBIN!" == "" (
	set SERVICE_EBIN=!SERVICE_BASE!\lib\
)

if "!RELEASE_SUBDIR!" =="" (
	set RELEASE_SUBDIR=releases\
	for /f "delims=" %%i in ('dir /ad/b "!SERVICE_BASE!\!RELEASE_SUBDIR!"') do if exist "!SERVICE_BASE!\!RELEASE_SUBDIR!%%i\sys.config" (
		set RELEASE_SUBDIR=!RELEASE_SUBDIR!%%i
	)	
)

if "!SERVICE_DEBUG!" == "" (
	set SERVICE_DEBUG=none
)

if "!ERLANG_BASE!" == "" (
	if exist "!ERLANG_HOME!\erl.exe" (		
		set ERLANG_BASE="!ERLANG_HOME!"
	) else (
		set ERLANG_BASE=!SERVICE_BASE!\
		for /f "delims=" %%i in ('dir /ad/b "!ERLANG_BASE!"') do if exist "!ERLANG_BASE!%%i\bin\erl.exe" (
			set ERLANG_BASE=!ERLANG_BASE!%%i\bin
		)
	)
)


if not exist "!ERLANG_BASE!\erl.exe" (
    echo.
    echo ******************************
    echo ERLANG_BASE not usable.
    echo ******************************
    echo.
    echo Please either set ERLANG_HOME to point to your Erlang installation or place the
    echo CargoTube in the Erlang lib folder.
    echo currently set to !ERLANG_BASE!
    echo.
    pause
    exit /B
)

if not exist "!ERLANG_BASE!\erlsrv.exe" (
    echo.
    echo **********************************************
    echo ERLANG_BASE does not contain erlsrv.exe .
    echo **********************************************
    echo.
    echo "!ERLANG_BASE!\erlsrv.exe" not found
    echo Please set ERLANG_BASE to the folder containing "erlsrv.exe".
    echo.
    exit /B 1
)

set BOOT_FILE_PATH="!SERVICE_BASE!\!RELEASE_SUBDIR!\!BOOT_FILE!.boot"
if not exist "!BOOT_FILE_PATH!" (
    echo.
    echo **********************************************
    echo RELEASE_DIR does not contain boot file .
    echo **********************************************
    echo.
    echo "!BOOT_FILE_PATH!" not found
    echo Please set !RELEASE_SUBDIR! to the sub-folder containing boot file.
    echo.
    exit /B 2
)

if not exist "!SERVICE_BASE!\!RELEASE_SUBDIR!\sys.config" (
    echo.
    echo **********************************************
    echo RELEASE_DIR does not contain config file .
    echo **********************************************
    echo.
    echo "!RELEASE_SUBDIR!\sys.config" not found in "!SERVICE_BASE!"
    echo Please set !RELEASE_SUBDIR! to the sub-folder containing config file.
    echo.
    exit /B 3
)


if "!P1!" == "install" goto INSTALL_SERVICE
if "!P1!" == "info" goto INFO_SERVICE
for %%i in (start stop disable enable list remove) do if "%%i" == "!P1!" goto MODIFY_SERVICE

echo.
echo *********************
echo Service control usage
echo *********************
echo.
echo !TN0! help    - Display this help
echo !TN0! install - Install the !SERVICENAME! service
echo !TN0! remove  - Remove the !SERVICENAME! service
echo.
echo The following actions can also be accomplished by using
echo Windows Services Management Console (services.msc):
echo.
echo !TN0! start   - Start the !SERVICENAME! service
echo !TN0! info    - Informations about !SERVICENAME! service
echo !TN0! stop    - Stop the !SERVICENAME! service
echo !TN0! disable - Disable the !SERVICENAME! service
echo !TN0! enable  - Enable the !SERVICENAME! service
echo.
exit /B



:INSTALL_SERVICE
set ERLANG_SERVICE_ARGS=^
-boot "!RELEASE_SUBDIR!\!BOOT_FILE!" ^
-config "!RELEASE_SUBDIR!\sys.config"

set ERLANG_SERVICE_ARGS=!ERLANG_SERVICE_ARGS:\=\\!
set ERLANG_SERVICE_ARGS=!ERLANG_SERVICE_ARGS:"=\"!

SET COMMAND="!ERLANG_BASE!\erlsrv" add "!SERVICENAME!" ^
-comment "CargoTube the software router" ^
-onfail restart ^
-debugtype new ^
-machine "!ERLANG_BASE!\erl.exe" ^
-workdir "!SERVICE_BASE!\\" ^
-args "!ERLANG_SERVICE_ARGS!"

echo !COMMAND!

!COMMAND!


"!ERLANG_BASE!\erlsrv" start "!SERVICENAME!"
goto END


:INFO_SERVICE
"!ERLANG_BASE!\erlsrv" list "!SERVICENAME!"
goto END


:MODIFY_SERVICE
"!ERLANG_BASE!\erlsrv" !P1! !SERVICENAME!
goto END


:END


endlocal
endlocal