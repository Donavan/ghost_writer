#!/bin/bash

echo "Starting Agent C installation..."

# Save the current directory to return to it later
STARTING_DIR="$(pwd)"

# Check if we're in the scripts folder and go up one level if needed
FOLDER_NAME="$(basename "$(pwd)")"
if [ "$FOLDER_NAME" = "scripts" ]; then
    echo "Detected scripts folder, moving up one directory..."
    cd ..
    if [ $? -ne 0 ]; then
        echo "Error: Failed to navigate up from scripts folder."
        exit 1
    fi
    STARTING_DIR="$(pwd)"
fi

# Activate the virtual environment
echo "Activating virtual environment..."
if [ ! -f ".venv/bin/activate" ]; then
    echo "Error: Virtual environment not found at .venv/bin/activate"
    echo "Please run this script from the root project directory."
    exit 1
fi

source .venv/bin/activate
if [ $? -ne 0 ]; then
    echo "Error: Failed to activate virtual environment."
    exit 1
fi

# Determine the agent_c_framework source directory
echo "Locating Agent C Framework source..."
if [ -n "$AGENT_C_SOURCE" ]; then
    echo "Using AGENT_C_SOURCE environment variable: $AGENT_C_SOURCE"
    FRAMEWORK_DIR="$AGENT_C_SOURCE"
elif [ -d "../agent_c_framework" ]; then
    echo "Found framework in default relative location."
    FRAMEWORK_DIR="../agent_c_framework"
elif [ -d "agent_c_framework" ]; then
    echo "Found framework in current directory."
    FRAMEWORK_DIR="agent_c_framework"
else
    echo "Error: Could not find agent_c_framework source directory."
    echo "Please either:"
    echo " - Set the AGENT_C_SOURCE environment variable"
    echo " - Ensure agent_c_framework is in the expected location"
    exit 1
fi

# Check for .env file and copy it if it doesn't exist
if [ ! -f ".env" ]; then
    echo ".env file not found in project root."
    if [ -f "$FRAMEWORK_DIR/.env" ]; then
        echo "Copying .env file from $FRAMEWORK_DIR..."
        cp "$FRAMEWORK_DIR/.env" ".env"
        if [ $? -ne 0 ]; then
            echo "Warning: Failed to copy .env file. You may need to create one manually."
        else
            echo ".env file copied successfully."
        fi
    else
        echo "Warning: No .env file found in $FRAMEWORK_DIR. You may need to create one manually."
    fi
fi

# Navigate to the framework source directory for installation
echo "Navigating to $FRAMEWORK_DIR/src..."
cd "$FRAMEWORK_DIR/src"
if [ $? -ne 0 ]; then
    echo "Error: Failed to navigate to the framework source directory."
    cd "$STARTING_DIR"
    exit 1
fi

# Install the packages in development mode
echo "Installing agent_c_core in development mode..."
pip install -e agent_c_core
if [ $? -ne 0 ]; then
    echo "Error: Failed to install agent_c_core."
    cd "$STARTING_DIR"
    exit 1
fi

echo "Installing agent_c_tools in development mode..."
pip install -e agent_c_tools
if [ $? -ne 0 ]; then
    echo "Error: Failed to install agent_c_tools."
    cd "$STARTING_DIR"
    exit 1
fi

echo "Installing agent_c_reference_apps in development mode..."
pip install -e agent_c_reference_apps
if [ $? -ne 0 ]; then
    echo "Error: Failed to install agent_c_reference_apps."
    cd "$STARTING_DIR"
    exit 1
fi

# Return to the starting directory
echo "Returning to starting directory..."
cd "$STARTING_DIR"
if [ $? -ne 0 ]; then
    echo "Warning: Failed to return to the starting directory."
    exit 1
fi

echo "Agent C installation completed successfully."