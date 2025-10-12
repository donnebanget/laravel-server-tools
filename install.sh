#!/bin/bash
set -e

# ==========================================
# Laravel Server Tools Installer v1.0.1
# ==========================================

REPO_URL="https://github.com/donnebanget/laravel-server-tools.git"
INSTALL_DIR="/tmp/laravel-server-tools"
BIN_DIR="/usr/local/bin"
BASH_COMPLETION_DIR="/etc/bash_completion.d"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo "=========================================="
echo " 🚀 Laravel Server Tools Installer"
echo "=========================================="
echo

# Check if running as root or with sudo
if [ "$(id -u)" -ne 0 ]; then
  echo -e "${YELLOW}⚠️  This installer requires root privileges.${NC}"
  echo "Please run with: sudo bash install.sh"
  exit 1
fi

# Pre-flight checks for required commands
echo "🔍 Checking dependencies..."

command -v git >/dev/null 2>&1 || { 
  echo -e "${RED}Error: git is not installed.${NC}"
  echo "Install it with: apt install git"
  exit 1
}

command -v supervisorctl >/dev/null 2>&1 || { 
  echo -e "${YELLOW}⚠️  Warning: supervisor is not installed.${NC}"
  echo "   The 'worker' command will not work without it."
  echo "   Install it with: apt install supervisor"
  read -p "Continue anyway? (y/N): " confirm
  [[ "$confirm" != "y" && "$confirm" != "Y" ]] && exit 1
}

echo -e "${GREEN}✅ Dependencies check passed.${NC}\n"

# Detect if run directly or remotely
if [ ! -f "install.sh" ]; then
    echo "📦 Cloning Laravel Server Tools..."
    rm -rf "$INSTALL_DIR"
    git clone --depth=1 "$REPO_URL" "$INSTALL_DIR" >/dev/null 2>&1
    
    if [ $? -ne 0 ]; then
      echo -e "${RED}Error: Failed to clone repository.${NC}"
      exit 1
    fi
    
    cd "$INSTALL_DIR"
fi

# Install binaries
echo "🧰 Installing binaries..."
mkdir -p "$BIN_DIR"

if [ ! -d "bin" ]; then
  echo -e "${RED}Error: bin/ directory not found.${NC}"
  exit 1
fi

cp -f bin/* "$BIN_DIR/" 2>/dev/null || {
  echo -e "${RED}Error: Failed to copy binaries.${NC}"
  exit 1
}

chmod +x "$BIN_DIR"/deploy "$BIN_DIR"/worker 2>/dev/null || {
  echo -e "${RED}Error: Failed to set executable permissions.${NC}"
  exit 1
}

echo -e "${GREEN}✅ Binaries installed to ${BIN_DIR}${NC}"

# Setup bash completions
if [ -d "completions" ]; then
  echo "⚙️  Setting up bash completions..."
  mkdir -p "$BASH_COMPLETION_DIR"
  cp -f completions/* "$BASH_COMPLETION_DIR/" 2>/dev/null || {
    echo -e "${YELLOW}⚠️  Warning: Failed to install bash completions.${NC}"
  }
  echo -e "${GREEN}✅ Bash completions installed.${NC}"
else
  echo -e "${YELLOW}⚠️  Warning: completions/ directory not found, skipping.${NC}"
fi

# Cleanup
echo "🧹 Cleaning up..."
if [[ "$PWD" == "$INSTALL_DIR" ]]; then
    cd /
    rm -rf "$INSTALL_DIR"
fi

echo
echo "=========================================="
echo -e "${GREEN}✅ Installation complete!${NC}"
echo "=========================================="
echo
echo "Available commands:"
echo -e "  ${CYAN}deploy${NC}          Quick optimization"
echo -e "  ${CYAN}deploy --init${NC}   First-time setup"
echo -e "  ${CYAN}deploy --update${NC} Git pull + rebuild"
echo -e "  ${CYAN}deploy --help${NC}   Show help"
echo
echo -e "  ${CYAN}worker create${NC}   Create new worker"
echo -e "  ${CYAN}worker remove${NC}   Remove worker"
echo -e "  ${CYAN}worker status${NC}   Check worker status"
echo -e "  ${CYAN}worker logs${NC}     Tail worker logs"
echo -e "  ${CYAN}worker --help${NC}   Show help"
echo
echo "To enable bash completions immediately, run:"
echo -e "  ${YELLOW}source /etc/bash_completion${NC}"
echo
echo -e "${CYAN}Note:${NC} Worker logs are stored in each project's storage/logs/ directory"
echo
echo "✨ Enjoy your Laravel Server Tools!"
echo