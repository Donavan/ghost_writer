@echo off
setlocal enabledelayedexpansion

echo Starting Agent C installation...

:: Save the current directory to return to it later
set "STARTING_DIR=%CD%"

:: Check if we're in the scripts folder and go up one level if needed
set "CURRENT_FOLDER=%CD%"
for %%I in ("%CURRENT_FOLDER%") do set "FOLDER_NAME=%%~nxI"
if "%FOLDER_NAME%"=="scripts" (
    echo Detected scripts folder, moving up one directory...
    cd ..
    if !ERRORLEVEL! neq 0 (
        echo Error: Failed to navigate up from scripts folder.
        goto :error
    )
    set "STARTING_DIR=%CD%"
)

:: Activate the virtual environment
echo Activating virtual environment...
if not exist ".venv\Scripts\activate" (
    echo Error: Virtual environment not found at .venv\Scripts\activate
    echo Please run this script from the root project directory.
    goto :error
)

call .venv\Scripts\activate
if %ERRORLEVEL% neq 0 (
    echo Error: Failed to activate virtual environment.
    goto :error
)

:: Determine the agent_c_framework source directory
echo Locating Agent C Framework source...
if defined AGENT_C_SOURCE (
    echo Using AGENT_C_SOURCE environment variable: %AGENT_C_SOURCE%
    set "FRAMEWORK_DIR=%AGENT_C_SOURCE%"
) else if exist "..\agent_c_framework" (
    echo Found framework in default relative location.
    set "FRAMEWORK_DIR=..\agent_c_framework"
) else if exist "agent_c_framework" (
    echo Found framework in current directory.
    set "FRAMEWORK_DIR=agent_c_framework"
) else (
    echo Error: Could not find agent_c_framework source directory.
    echo Please either:
    echo  - Set the AGENT_C_SOURCE environment variable
    echo  - Ensure agent_c_framework is in the expected location
    goto :error
)

:: Check for .env file and copy it if it doesn't exist
if not exist ".env" (
    echo .env file not found in project root.
    if exist "%FRAMEWORK_DIR%\.env" (
        echo Copying .env file from %FRAMEWORK_DIR%...
        copy "%FRAMEWORK_DIR%\.env" ".env" > nul
        if !ERRORLEVEL! neq 0 (
            echo Warning: Failed to copy .env file. You may need to create one manually.
        ) else (
            echo .env file copied successfully.
        )
    ) else (
        echo Warning: No .env file found in %FRAMEWORK_DIR%. You may need to create one manually.
    )
)

:: Navigate to the framework source directory for installation
echo Navigating to %FRAMEWORK_DIR%\src...
cd "%FRAMEWORK_DIR%\src"
if %ERRORLEVEL% neq 0 (
    echo Error: Failed to navigate to the framework source directory.
    goto :error
)

:: Install the packages in development mode
echo Installing agent_c_core in development mode...
pip install -e agent_c_core
if %ERRORLEVEL% neq 0 (
    echo Error: Failed to install agent_c_core.
    goto :error
)

echo Installing agent_c_tools in development mode...
pip install -e agent_c_tools
if %ERRORLEVEL% neq 0 (
    echo Error: Failed to install agent_c_tools.
    goto :error
)

echo Installing agent_c_reference_apps in development mode...
pip install -e agent_c_reference_apps
if %ERRORLEVEL% neq 0 (
    echo Error: Failed to install agent_c_reference_apps.
    goto :error
)

:: Return to the starting directory
echo Returning to starting directory...
cd "%STARTING_DIR%"
if %ERRORLEVEL% neq 0 (
    echo Warning: Failed to return to the starting directory.
)

echo Agent C installation completed successfully.
goto :end

:error
echo Installation failed with errors.
:: Try to return to starting directory even after an error
cd "%STARTING_DIR%" 2>nul
exit /b 1

:end
echo Installation process completed.
endlocal