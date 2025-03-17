This is a skeleton.

# Getting Started

This project builds upon Agent C Framework and provides additional utilities and reference implementations. Follow these instructions to get started with development.

## Prerequisites

- **Python 3.10+**: This project requires Python 3.10 or newer. [Download Python](https://www.python.org/downloads/)
- **Git**: For version control and cloning repositories. [Download Git](https://git-scm.com/downloads)
- **Agent C Framework**: You need access to the Agent C Framework codebase (either in a relative path or specified via environment variable)

## Installation

### Clone the Repository

```bash
git clone https://github.com/your-organization/your-project.git
cd your-project
```

### Setup Options

#### Option 1: Automated Setup (Recommended)

Run the setup script to automatically check dependencies, create a virtual environment, and install the Agent C components:

**On Windows:**
```batch
scripts\initial_setup.bat
```

**On Linux/macOS:**
```bash
chmod +x scripts/initial_setup.sh  # Make executable (first time only)
./scripts/initial_setup.sh
```

The script will:
1. Check that you have Python 3.10+
2. Create a virtual environment if one doesn't exist
3. Install required packages
4. Set up the Agent C components

#### Option 2: Manual Setup

If you prefer to set things up manually:

1. **Create and activate a virtual environment:**

   **Windows:**
   ```batch
   python -m venv .venv
   .venv\Scripts\activate
   ```

   **Linux/macOS:**
   ```bash
   python3 -m venv .venv
   source .venv/bin/activate
   ```

2. **Update pip and install wheel:**
   ```bash
   pip install --upgrade pip wheel
   ```

3. **Install Agent C components:**

   **Windows:**
   ```batch
   scripts\install_agent_c.bat
   ```

   **Linux/macOS:**
   ```bash
   chmod +x scripts/install_agent_c.sh  # Make executable (first time only)
   ./scripts/install_agent_c.sh
   ```

### Agent C Framework Location

The installation scripts look for the Agent C Framework in the following locations (in order):

1. The location specified by the `AGENT_C_SOURCE` environment variable
2. A directory named `agent_c_framework` in the parent directory (`../agent_c_framework`)
3. A directory named `agent_c_framework` in the current directory 

If you have the Agent C Framework in a different location, set the `AGENT_C_SOURCE` environment variable:

**Windows:**
```batch
set AGENT_C_SOURCE=C:\path\to\agent_c_framework
```

**Linux/macOS:**
```bash
export AGENT_C_SOURCE=/path/to/agent_c_framework
```

## Environment Configuration

If you don't have a `.env` file in your project root, the installation scripts will attempt to copy one from the Agent C Framework. You may need to edit this file to configure your environment-specific settings.

## Running Tests

After installation, you can run the tests to verify everything is working correctly:

```bash
pytest
```

## Development Workflow

1. Activate your virtual environment:

   **Windows:**
   ```batch
   .venv\Scripts\activate
   ```

   **Linux/macOS:**
   ```bash
   source .venv/bin/activate
   ```

2. Make your changes to the code
3. Run tests to ensure functionality
4. Commit your changes:
   ```bash
   git add .
   git commit -m "Description of changes"
   ```

## Troubleshooting

- **Python Version Issues**: Ensure you have Python 3.10+ installed and available in your PATH
- **Agent C Framework Not Found**: Set the `AGENT_C_SOURCE` environment variable to the correct path
- **Missing .env File**: Create one manually by copying from the Agent C Framework or from the template
- **Permission Issues on Unix**: Make sure the shell scripts are executable using `chmod +x script_name.sh`