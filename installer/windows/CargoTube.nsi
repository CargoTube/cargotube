;--------------------------------
;Include Modern UI

  !include "MUI2.nsh"

;--------------------------------
;Include Windows Version checking

  !include "WinVer.nsh"
  
;--------------------------------
;Include CargoTube Version

  !include "CargoTubeVersion.nsh"  

;--------------------------------
;General
  !define NAME "CargoTube"
  !define COMMENT "CargoTube the software router"



  ;Name and file
  Name "CargoTube"
  OutFile "${Name}_Setup-${VERSION}.exe"

  ;Default installation folder
  InstallDir "$PROGRAMFILES\${Name}"

  ;Request application privileges for Windows Vista
  RequestExecutionLevel admin

;--------------------------------
;Interface Settings

  !define MUI_ABORTWARNING

;--------------------------------
;Pages

  !insertmacro MUI_PAGE_LICENSE "..\..\LICENSE.txt"
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES

  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES

;--------------------------------
;Languages

  !insertmacro MUI_LANGUAGE "English"

;--------------------------------
;Installer Sections

Section "CargoTube" SecCargoTube

  SetOutPath "$INSTDIR"

  ; remove erl.ini to not link the path of the erlang vm to the current development directory
  ; remove unneeded file types: bat, log, dump, debug, pdf, html, src
  File /r /x erl.ini /x *.bat /x *.log /x *.dump /x *.debug.* /x *.pdf /x *.html /x src\*.* ..\..\_build\default\rel\cargotube\*.*
  File /oname=bin\service_reg.bat service_reg.bat
  ExecWait '"$INSTDIR\bin\service_reg.bat" install'

  ;Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"

${If} ${IsWin10}
     MessageBox MB_OK|MB_ICONEXCLAMATION "Windows 10 detected. Please change the service to start 'automatically (delayed)'"
${EndIf}

SectionEnd

;--------------------------------
;Uninstaller Section

Section "Uninstall"

  ExecWait '"$INSTDIR\bin\service_reg.bat" remove'
  ; ensure epmd is stopped
  ExecWait 'taskkill /F /IM epmd.exe'
  Delete "$INSTDIR\Uninstall.exe"

  RMDir /r "$INSTDIR"

SectionEnd