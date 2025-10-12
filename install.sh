#!/bin/bash
set -e

# ==========================================
# Laravel Server Tools Installer v1.0.0
# ==========================================

REPO_URL="https://github.com/donnebanget/laravel-server-tools.git"
INSTALL_DIR="/tmp/laravel-server-tools"
BIN_DIR="/usr/local/bin"
BASH_COMPLETION_DIR="/etc/bash_completion.d"
LOG_DIR="/var/log/laravel-workers"

echo "=========================================="
echo " 🚀 Laravel Server Tools Installer"
echo "=========================================="
echo

# Detect if run directly or remotely
if [ ! -f "install.sh" ]; then
    echo "📦 Cloning Laravel Server Tools..."
    rm -rf "$INSTALL_DIR"
    git clone --depth=1 "$REPO_URL" "$INSTALL_DIR" >/dev/null 2>&1
    cd "$INSTALL_DIR"
fi

echo "🧰 Installing binaries..."
mkdir -p "$BIN_DIR"
cp -f bin/* "$BIN_DIR/"
chmod +x "$BIN_DIR"/*

echo "⚙️  Setting up bash completions..."
mkdir -p "$BASH_COMPLETION_DIR"
cp -f completions/* "$BASH_COMPLETION_DIR/"

echo "🪵 Creating log directory..."
mkdir -p "$LOG_DIR"
chmod 777 "$LOG_DIR"

echo "🧹 Cleaning up..."
if [[ "$PWD" == "$INSTALL_DIR" ]]; then
    cd /
    rm -rf "$INSTALL_DIR"
fi

echo
echo "✅ Installation complete!"
echo
echo "You can now use:"
echo "   worker start"
echo "   worker stop"
echo "   worker status"
echo
echo "To enable completions immediately, run:"
echo "   source /etc/bash_completion"
echo
echo "✨ Enjoy your Laravel Server Tools!"
