#!/usr/bin/env bash

#
# Package installer
#
# Inspired by: https://github.com/alrra/dotfiles/blob/main/os/os_x/installs/main.sh
#

# Defines the function to check if a command is installed
command_exists() {
    command -v "$1" &> /dev/null
}

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

#
# Xcode Command Line Tools
#

# Check if Xcode Command Line Tools are installed
if ! xcode-select -p &> /dev/null; then
    echo "Xcode Command Line Tools not found. Installing..."
    xcode-select --install
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
