#!/bin/bash

# Determine the shell and configuration file
if [[ -n "$BASH_VERSION" ]]; then
    RC_FILE="$HOME/.bashrc"
elif [[ -n "$ZSH_VERSION" ]]; then
    RC_FILE="$HOME/.zshrc"
else
    echo "❌ Unknown shell. Only Bash and Zsh are supported."
    exit 1
fi

echo "⚙️ Using configuration file: $RC_FILE"

# 🔹 Install required packages
echo "🔄 Updating package list and installing Python..."
sudo apt update && sudo apt install -y python3 python3-pip python3-venv python-is-python3

# 🔹 Install Poetry if not installed
if ! command -v poetry &> /dev/null; then
    echo "📦 Installing Poetry..."
    curl -sSL https://install.python-poetry.org | python3 -
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$RC_FILE"
else
    echo "✅ Poetry is already installed!"
fi

# 🔹 Configure Poetry
echo "🛠 Configuring Poetry..."
poetry config virtualenvs.in-project true
poetry config virtualenvs.path "venv"
poetry config virtualenvs.prompt "venv-{project_name}"

# 🔹 Check if the poetry function exists in the rc-file
if ! grep -q "^poetry() {" "$RC_FILE"; then
    echo "📌 Adding the poetry function to $RC_FILE..."
    cat << 'EOF' >> "$RC_FILE"

poetry() {
    case "$1" in
        create)
            shift  # Remove "create" from arguments
            create_venv.sh "$@"
            ;;
        clear)
            shift  # Remove "clear" from arguments
            clear_venv.sh "$@"
            ;;
        *)
            # For other commands, delegate to the standard poetry
            command poetry "$@"
            ;;
    esac
}
EOF
    echo "✅ Poetry function added!"
else
    echo "ℹ️ Poetry function already exists. Skipping."
fi


# Check and create the directory $HOME/.local/bin
if [ ! -d "$HOME/.local/bin" ]; then
    mkdir -p "$HOME/.local/bin"
fi


# 🔹 Create and move the create_venv.sh script to .local/bin
if [[ ! -f "$HOME/.local/bin/create_venv.sh" ]]; then
    echo "🚀 Creating create_venv.sh..."

    cat << 'EOF' > "$HOME/create_venv.sh"
#!/usr/bin/zsh

# Function to colorize text output
color_echo() {
  echo "\033[$1m$2\033[0m"
}

# Default project name (current directory name)
PROJECT_NAME=$(basename "$(pwd)")
EXAMPLE_PROJECT_NAME="my_project"
PROJECT_NAME_PATTERN='^[a-zA-Z0-9_][a-zA-Z0-9._-]*[a-zA-Z0-9_]?$'

# Function to prompt for project name
get_project_name() {
  while true; do
    echo -n "$(color_echo "1;32" "Enter project name (example: '$EXAMPLE_PROJECT_NAME', default: '$PROJECT_NAME'): ")"
    read input_name
    PROJECT_NAME=${input_name:-$PROJECT_NAME}
    [[ $PROJECT_NAME =~ $PROJECT_NAME_PATTERN ]] && break
    color_echo "1;31" "Error: Invalid project name!"
  done
}

# Prompt for project name
get_project_name
PROJECT_DESCRIPTION="$PROJECT_NAME project"

# Prompt for project description
echo -n "$(color_echo "1;32" "Enter project description (default: '$PROJECT_DESCRIPTION'): ")"
read input_desc
PROJECT_DESCRIPTION=${input_desc:-$PROJECT_DESCRIPTION}

# Detect Python version
PYTHON_VERSION=$(python3 -V 2>/dev/null | awk '{print $2}' | cut -d. -f1,2)
PYTHON_VERSION=${PYTHON_VERSION:-"3.9"}

# Prompt for minimum Python version
echo -n "$(color_echo "1;32" "Enter minimum Python version (default: '$PYTHON_VERSION'): ")"
read input_python
PYTHON_VERSION=${input_python:-$PYTHON_VERSION}

# Prompt for author's name
AUTHORS_NAME="Cool Coder"
echo -n "$(color_echo "1;32" "Enter author's name (default: '$AUTHORS_NAME'): ")"
read input_name
AUTHORS_NAME=${input_name:-$AUTHORS_NAME}

# Prompt for author's email
AUTHORS_EMAIL="mail@example.com"
echo -n "$(color_echo "1;32" "Enter author's email (default: '$AUTHORS_EMAIL'): ")"
read input_email
AUTHORS_EMAIL=${input_email:-$AUTHORS_EMAIL}

# Initialize the project using Poetry
color_echo "1;34" "Initializing project with Poetry..."
poetry init --no-interaction

# Check if pyproject.toml was created
if [[ ! -f "pyproject.toml" ]]; then
  color_echo "1;31" "Error: pyproject.toml file not found."
  exit 1
fi

# Add [tool.poetry] section with package-mode if it doesn't exist
if ! grep -q "^\[tool.poetry\]" pyproject.toml; then
  echo -e "\n[tool.poetry]\npackage-mode = false" >> pyproject.toml
fi

# Add or update the [project] section
if ! grep -q "^\[project\]" pyproject.toml; then
  # Add a new [project] section with proper formatting
  echo -e "\n[project]\nname = \"$PROJECT_NAME\"\ndescription = \"$PROJECT_DESCRIPTION\"\nversion = \"0.1.0\"\nrequires-python = \">=$PYTHON_VERSION\"\nauthors = [\n    {name = \"$AUTHORS_NAME\", email = \"$AUTHORS_EMAIL\"}\n]" >> pyproject.toml
else
  # Update existing [project] section
  sed -i "s/^name = \".*\"/name = \"$PROJECT_NAME\"/" pyproject.toml
  sed -i "s/^description = \".*\"/description = \"$PROJECT_DESCRIPTION\"/" pyproject.toml
  sed -i "s/^version = \".*\"/version = \"0.1.0\"/" pyproject.toml
  sed -i "s/^requires-python = \".*\"/requires-python = \">=$PYTHON_VERSION\"/" pyproject.toml
  # Update authors section with proper formatting
  sed -i '/^authors = \[/, /^\]/c\authors = [\n    {name = "'"$AUTHORS_NAME"'", email = "'"$AUTHORS_EMAIL"'"}\n]' pyproject.toml
fi

# Update other fields
sed -i "s/readme = \"README.md\"/readme = \"readme.md\"/" pyproject.toml

# Create readme.md if it doesn't exist
if [[ ! -f "readme.md" ]]; then
  echo "# $PROJECT_DESCRIPTION" > readme.md
  color_echo "1;34" "Created readme.md file."
fi

# Install dependencies and create virtual environment
color_echo "1;34" "Installing dependencies and creating virtual environment..."
poetry install

# Add .gitignore if it doesn't exist
if [[ ! -f ".gitignore" ]]; then
  echo ".venv/" > .gitignore
  color_echo "1;34" "Created .gitignore with .venv/."
elif ! grep -q "\.venv/" .gitignore; then
  echo ".venv/" >> .gitignore
  color_echo "1;34" "Added .venv/ to .gitignore."
fi

# Success message
color_echo "1;32" "Project '$PROJECT_NAME' successfully configured!"
EOF

    chmod +x "$HOME/create_venv.sh"
    mv "$HOME/create_venv.sh" "$HOME/.local/bin/create_venv.sh"
    echo "✅ Script create_venv.sh moved to .local/bin."
fi

# 🔹 Create and move the clear_venv.sh script to .local/bin
if [[ ! -f "$HOME/.local/bin/clear_venv.sh" ]]; then
    echo "🗑 Creating clear_venv.sh..."

    cat << 'EOF' > "$HOME/clear_venv.sh"
#!/usr/bin/env bash

# Check if .venv directory exists
if [ ! -d ".venv" ]; then
  echo -e "\033[31mError: virtual environment not found\033[0m"
  echo "Check if the virtual environment has been created for this project."
  exit 1
fi

# Check if Poetry is installed
if ! command -v poetry &> /dev/null; then
  echo -e "\033[31mError: Poetry is not installed!\033[0m"
  echo "Make sure Poetry is installed and available in the system."
  exit 1
fi

# Remove the virtual environment
echo -e "\033[33mRemoving virtual environment...\033[0m"
poetry env remove

# Remove project files
echo -e "\033[33mRemoving project files...\033[0m"
rm -f poetry.lock pyproject.toml .gitignore

# Completion notification
echo -e "\033[32m✅ Environment and project files successfully removed!\033[0m"
EOF

    chmod +x "$HOME/clear_venv.sh"
    mv "$HOME/clear_venv.sh" "$HOME/.local/bin/clear_venv.sh"
    echo "✅ Script clear_venv.sh moved to .local/bin."
fi

# 🔹 Load updated settings
if [[ -n "$PS1" ]]; then
    # Apply changes only for interactive sessions
    echo "🔄 Applying changes..."
    source "$RC_FILE"
fi

echo
echo "🎉 Done! Now you can use:"
echo "  - 'poetry create' to create an environment"
echo "  - 'poetry clear' to remove an environment"
echo

