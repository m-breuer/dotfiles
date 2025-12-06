#!/usr/bin/env bash

#
# Dotfiles installer
#
# Inspired by: https://github.com/alrra/dotfiles/blob/main/install.sh
#

export DOTFILES_DIR
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#
# Functions
#

# Print a header
print_header() {
    printf "\n"
    printf "================================================================================\n"
    printf "› %s\n" "$1"
    printf "================================================================================\n"
}

# Create a symlink
create_symlink() {
    # $1: source
    # $2: destination

    # Check if the destination file exists
    if [ -e "$2" ]; then
        # If it exists, check if it is a symlink
        if [ -L "$2" ]; then
            # If it is a symlink, remove it
            rm "$2"
        else
            # If it is a file, move it to a backup
            mv "$2" "$2.bak"
        fi
    fi

    # Create the symlink
    ln -s "$1" "$2"
}

#
# Sudo
#

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

#
# Git
#

print_header "Updating dotfiles..."

# Update dotfiles itself
if [ -d "$DOTFILES_DIR/.git" ]; then
    git --work-tree="$DOTFILES_DIR" --git-dir="$DOTFILES_DIR/.git" pull origin master
fi

#
# Symlinks
#

print_header "Creating symlinks..."

# .zshrc
create_symlink "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

# .gitconfig
create_symlink "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"

#
# Packages
#

print_header "Installing packages..."

. "$DOTFILES_DIR/install/packages.sh"

#
# Extra
#

EXTRA_DIR="$HOME/.extra"

# Install extra stuff
if [ -d "$EXTRA_DIR" -a -f "$EXTRA_DIR/install.sh" ]; then
    print_header "Installing extra stuff..."
    . "$EXTRA_DIR/install.sh"
fi

#
# ZSH
#

print_header "Configuring ZSH..."

# Source .zshrc
. "$HOME/.zshrc"

print_header "Done!"
