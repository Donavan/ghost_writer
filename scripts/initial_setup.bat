@echo off
setlocal enabledelayedexpansion

echo Initial Setup
echo ====================
echo.

:: Save the current directory
set "ORIGINAL_DIR=%CD%"

:: Determine if we're in the scripts folder and navigate to project root if needed
set "CURRENT_FOLDER=%CD%"
for %%I in ("%CURRENT_FOLDER%") do set "FOLDER_NAME=%%~nxI"
if "%FOLDER_NAME%"=="scripts" (
    echo Detected running from scripts folder, moving up to project root...
    cd ..
    if !ERRORLEVEL! neq 0 (
        echo Error: Failed to navigate up from scripts folder.
        goto :error
    )
)

:: Store the project root directory
set "PROJECT_ROOT=%CD%"
echo Project root directory: %PROJECT_ROOT%

:: Check for Python 3.10 or higher
echo Checking Python version...
python --version > python_version.txt 2>&1
set /p PYTHON_VERSION=<python_version.txt
del python_version.txt

echo Found: %PYTHON_VERSION%

:: Check for Python command not found
findstr /C:"not recognized" python_version.txt >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo Error: Python not found. Please install Python 3.10 or higher and ensure it's in your PATH.
    goto :error
)

:: Extract Python version numbers
for /f "tokens=2 delims= " %%a in ("%PYTHON_VERSION%") do set "PY_VER=%%a"
for /f "tokens=1,2 delims=." %%a in ("!PY_VER!") do (
    set "PY_MAJOR=%%a"
    set "PY_MINOR=%%b"
)

:: Check if Python meets version requirements
if "%PY_MAJOR%" == "" (
    echo Error: Python not found. Please install Python 3.10 or higher.
    goto :error
)

if %PY_MAJOR% LSS 3 (
    echo Error: Python 3 required. Found Python %PY_MAJOR%.
    goto :error
)

if %PY_MAJOR% EQU 3 (
    if %PY_MINOR% LSS 10 (
        echo Error: Python 3.10 or higher required. Found Python %PY_MAJOR%.%PY_MINOR%.
        goto :error
    )
)

echo Python version check passed: %PY_MAJOR%.%PY_MINOR%

:: Check if virtual environment exists
if exist "%PROJECT_ROOT%\.venv" (
    echo Virtual environment already exists.
) else (
    echo Creating virtual environment...
    python -m venv "%PROJECT_ROOT%\.venv"
    if !ERRORLEVEL! neq 0 (
        echo Error: Failed to create virtual environment.
        goto :error
    )
    echo Virtual environment created successfully.
)

:: Activate the virtual environment
echo Activating virtual environment...
call "%PROJECT_ROOT%\.venv\Scripts\activate"
if %ERRORLEVEL% neq 0 (
    echo Error: Failed to activate virtual environment.
    goto :error
)

:: Upgrade pip to latest version
echo Upgrading pip...
python -m pip install --upgrade pip
if %ERRORLEVEL% neq 0 (
    echo Warning: Failed to upgrade pip, but continuing anyway.
)

:: Install wheel package for better package installation
echo Installing wheel package...
pip install wheel
if %ERRORLEVEL% neq 0 (
    echo Warning: Failed to install wheel package, but continuing anyway.
)

:: Check for install_agent_c.bat in project root or scripts subfolder
set "INSTALL_SCRIPT="
if exist "%PROJECT_ROOT%\install_agent_c.bat" (
    set "INSTALL_SCRIPT=%PROJECT_ROOT%\install_agent_c.bat"
) else if exist "%PROJECT_ROOT%\scripts\install_agent_c.bat" (
    set "INSTALL_SCRIPT=%PROJECT_ROOT%\scripts\install_agent_c.bat"
) else (
    echo Error: Could not find install_agent_c.bat in project root or scripts subfolder.
    goto :error
)

:: Run the installation script
echo.
echo Running Agent C installation script: %INSTALL_SCRIPT%
echo ------------------------------------------------
call "%INSTALL_SCRIPT%"
if %ERRORLEVEL% neq 0 (
    echo Error: Agent C installation failed.
    goto :error
)

:: Return to the original directory
cd "%ORIGINAL_DIR%"

echo.
echo Initial setup completed successfully!
echo You can build Agent C applications.
goto :end

:error
echo.
echo Setup failed with errors.
:: Try to return to original directory even after an error
cd "%ORIGINAL_DIR%" 2>nul
exit /b 1

:end
:: Pause when run by double-clicking to see the output
echo.
echo Press any key to exit...
pause >nul
endlocal