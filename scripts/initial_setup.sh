#!/bin/bash

echo "Initial Setup"
echo "===================="
echo ""

# Save the current directory
ORIGINAL_DIR="$(pwd)"

# Determine if we're in the scripts folder and navigate to project root if needed
FOLDER_NAME="$(basename "$(pwd)")"
if [ "$FOLDER_NAME" = "scripts" ]; then
    echo "Detected running from scripts folder, moving up to project root..."
    cd ..
    if [ $? -ne 0 ]; then
        echo "Error: Failed to navigate up from scripts folder."
        exit 1
    fi
fi

# Store the project root directory
PROJECT_ROOT="$(pwd)"
echo "Project root directory: $PROJECT_ROOT"

# Check for Python 3.10 or higher
echo "Checking Python version..."
if ! command -v python3 &> /dev/null; then
    echo "Error: Python 3 not found. Please install Python 3.10 or higher."
    exit 1
fi

PYTHON_VERSION=$(python3 --version 2>&1)
echo "Found: $PYTHON_VERSION"

# Extract Python version numbers
PY_VER=$(echo "$PYTHON_VERSION" | awk '{print $2}')
PY_MAJOR=$(echo "$PY_VER" | cut -d. -f1)
PY_MINOR=$(echo "$PY_VER" | cut -d. -f2)

# Check if Python meets version requirements
if [ -z "$PY_MAJOR" ]; then
    echo "Error: Python not found. Please install Python 3.10 or higher."
    exit 1
fi

if [ "$PY_MAJOR" -lt 3 ]; then
    echo "Error: Python 3 required. Found Python $PY_MAJOR."
    exit 1
fi

if [ "$PY_MAJOR" -eq 3 ] && [ "$PY_MINOR" -lt 10 ]; then
    echo "Error: Python 3.10 or higher required. Found Python $PY_MAJOR.$PY_MINOR."
    exit 1
fi

echo "Python version check passed: $PY_MAJOR.$PY_MINOR"

# Check if virtual environment exists
if [ -d "$PROJECT_ROOT/.venv" ]; then
    echo "Virtual environment already exists."
else
    echo "Creating virtual environment..."
    python3 -m venv "$PROJECT_ROOT/.venv"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to create virtual environment."
        exit 1
    fi
    echo "Virtual environment created successfully."
fi

# Activate the virtual environment
echo "Activating virtual environment..."
source "$PROJECT_ROOT/.venv/bin/activate"
if [ $? -ne 0 ]; then
    echo "Error: Failed to activate virtual environment."
    exit 1
fi

# Upgrade pip to latest version
echo "Upgrading pip..."
python -m pip install --upgrade pip
if [ $? -ne 0 ]; then
    echo "Warning: Failed to upgrade pip, but continuing anyway."
fi

# Install wheel package for better package installation
echo "Installing wheel package..."
pip install wheel
if [ $? -ne 0 ]; then
    echo "Warning: Failed to install wheel package, but continuing anyway."
fi

# Check for install_agent_c.sh in project root or scripts subfolder
INSTALL_SCRIPT=""
if [ -f "$PROJECT_ROOT/install_agent_c.sh" ]; then
    INSTALL_SCRIPT="$PROJECT_ROOT/install_agent_c.sh"
elif [ -f "$PROJECT_ROOT/scripts/install_agent_c.sh" ]; then
    INSTALL_SCRIPT="$PROJECT_ROOT/scripts/install_agent_c.sh"
else
    echo "Error: Could not find install_agent_c.sh in project root or scripts subfolder."
    exit 1
fi

# Make sure the install script is executable
chmod +x "$INSTALL_SCRIPT"

# Run the installation script
echo ""
echo "Running Agent C installation script: $INSTALL_SCRIPT"
echo "------------------------------------------------"
"$INSTALL_SCRIPT"
if [ $? -ne 0 ]; then
    echo "Error: Agent C installation failed."
    exit 1
fi

# Return to the original directory
cd "$ORIGINAL_DIR"

echo ""
echo "Initial setup completed successfully!"
echo "You can build Agent C applications."