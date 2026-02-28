#!/usr/bin/env bash

set -euo pipefail

#
# Package installer
#
# Inspired by: https://github.com/alrra/dotfiles/blob/main/os/os_x/installs/main.sh
#

# Defines the function to check if a command is installed
command_exists() {
    command -v "$1" &> /dev/null
}

if [ -z "${DOTFILES_DIR:-}" ]; then
    DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
fi

#
# Xcode Command Line Tools
#

# Check if Xcode Command Line Tools are installed
if ! xcode-select -p &> /dev/null; then
    echo "Xcode Command Line Tools not found. Installing..."
    xcode-select --install || true
    echo "Finish the Xcode Command Line Tools installation, then rerun ./install.sh."
    exit 0
fi

#
# Homebrew
#

# Check if Homebrew is installed
if ! command_exists "brew"; then
    echo "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

#
# Install packages from Brewfile
#

brew bundle --file="$DOTFILES_DIR/install/Brewfile"
