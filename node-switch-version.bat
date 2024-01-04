@echo off
setlocal EnableDelayedExpansion

:mainMenu
cls
echo +----------------------------------------------------+
echo ^|    Please make sure you have nvm                   ^|
echo ^|  environment in your PC. If you don't   	     ^|
echo ^|  have it, please download it from:      	     ^|
set "url=https://github.com/coreybutler/nvm-windows"  ^|
echo ^|  %url%        ^|
echo +----------------------------------------------------+

rem Additional commands can be added here

echo Main Menu:
echo 1. View Node.js versions and switch version
echo 2. Install a new Node.js version
echo 3. Uninstall a Node.js version
echo 0. Exit
echo *---------------------------------------------------*
REM Prompt user for menu choice
set /P menuChoice=Enter the menu option: 

REM Process user choice
if "%menuChoice%"=="1" (
    call :viewAndSwitchVersions
) else if "%menuChoice%"=="2" (
    call :installNewNodeVersion
) else if "%menuChoice%"=="3" (
    call :uninstallNodeVersion
) else if "%menuChoice%"=="0" (
    exit /b 0
) else (
    echo Invalid choice. Please enter a valid option.
    goto :mainMenu
)

:exitScript
endlocal
exit /b 0

:viewAndSwitchVersions
cls
:displayVersions

set versionCount=0
REM Display the list of Node.js versions
for /f "tokens=* delims= " %%a in ('nvm list') do (
    set "line=%%a"
    set "line=!line:*Node.js =!"
    if defined line (
        set /a versionCount+=1
        echo !versionCount!. Node !line!
    )
)

REM Option to go back to the main menu
set /a versionCount+=1
echo 0. Back to Main Menu
echo *---------------------------------------------------*
REM Prompt user for version choice
set /P versionChoice=Enter the number corresponding to the Node.js version you want to use: 

REM Validate user input
if %versionChoice% lss 0 (
    echo Invalid choice. Exiting.
    goto :exitScript
)

REM If the user chooses to go back to the main menu, return to main menu
if %versionChoice% equ 0 (
    goto :mainMenu

) else (
    REM Extract the selected version based on the user's choice
    set selectedVersion=
    for /f "tokens=* delims= " %%a in ('nvm list') do (
        set "line=%%a"
        set "line=!line:*Node.js =!"
        if defined line (
            set /a versionChoice-=1
            if !versionChoice! equ 0 (
                set selectedVersion=!line!
                goto :switchVersion
            )
        )
    )
)

:switchVersion
if not defined selectedVersion (
    echo Invalid choice. Exiting.
    goto :exitScript
)

echo Switching to Node.js version !selectedVersion!...
nvm use !selectedVersion!

REM Delay for a moment to allow the user to read the messages
timeout /nobreak /t 2 >nul

goto :mainMenu

:installNewNodeVersion
cls
echo Available Node.js versions:
REM Display the list of available Node.js versions before allowing the user to install a new version
echo | nvm list available

REM Option to go back to the main menu
echo 0. Back to Main Menu
echo *---------------------------------------------------*

rem Prompt user to enter the Node.js version to install
set /P newVersionChoice=Enter the Node.js version you want to install: 

REM Check if the user pressed the Escape (Esc) key or entered 0
if not defined newVersionChoice goto :mainMenu
if "%newVersionChoice%"=="0" goto :mainMenu

REM Install the chosen Node.js version
call :installNodeVersion %newVersionChoice%
goto :mainMenu

:installNodeVersion
set versionToInstall=%1
if not defined versionToInstall (
    echo Version argument is required but missing.
    goto :mainMenu
)

echo Installing Node.js version %versionToInstall%...
nvm install %versionToInstall%
nvm use %versionToInstall!

REM Delay for a moment to allow the user to read the messages
timeout /nobreak /t 2 >nul

goto :mainMenu

:uninstallNodeVersion
cls
echo Node.js versions installed:

REM Display the list of installed Node.js versions with order numbers
set versionCount=0
for /f "tokens=* delims= " %%a in ('nvm list') do (
    set "line=%%a"
    set "line=!line:*Node.js =!"
    if defined line (
        set /a versionCount+=1
        echo !versionCount!. Node !line!
    )
)

REM Option to go back to the main menu
echo 0. Back to Main Menu
echo *---------------------------------------------------*

REM Prompt user for version choice
set /P versionToRemove=Enter the number corresponding to the Node.js version you want to uninstall: 

REM Validate user input
if %versionToRemove% lss 0 (
    echo Invalid choice. Exiting.
    goto :exitScript
)

REM If the user chooses to go back to the main menu, return to the main menu
if %versionToRemove% equ 0 (
    goto :mainMenu
) else (
    REM Extract the version to uninstall based on the user's choice
    set versionToUninstall=
    set /a index=0
    for /f "tokens=* delims= " %%a in ('nvm list') do (
        set "line=%%a"
        set "line=!line:*Node.js =!"
        if defined line (
            set /a index+=1
            if !index! equ %versionToRemove% (
                set versionToUninstall=!line!
                goto :confirmUninstall
            )
        )
    )
)

:confirmUninstall
if not defined versionToUninstall (
    echo Invalid choice. Exiting.
    goto :exitScript
)

echo Uninstalling Node.js version !versionToUninstall!...
nvm uninstall !versionToUninstall!

REM Delay for a moment to allow the user to read the messages
timeout /nobreak /t 2 >nul

goto :mainMenu