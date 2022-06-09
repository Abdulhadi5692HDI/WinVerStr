@echo off

:: Get admin first
:-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:: Start initial batch script
echo Starting operation. . .
echo WARNING: This program modifys system values. This program isnt responsible for any damage to your system.
echo Do you want to continue. (press any key to or exit)
pause>nul
echo Modifying. . .
REG ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /V DisplayVersion /T REG_DWORD /D 1 /F
echo Modification completed!
echo Now restarting Windows Desktop and GUI Application
pause
taskkill /f /im explorer.exe
echo Closed PROCESS now reopening. . .
explorer
echo Done!
echo Press any key to exit. . .
pause>nul
exit
