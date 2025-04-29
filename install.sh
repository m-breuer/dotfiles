#!/usr/bin/env bash

# Get current dir

export DOTFILES_DIR EXTRA_DIR
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
EXTRA_DIR="$HOME/.extra"

# Update dotfiles itself

[ -d "$DOTFILES_DIR/.git" ] && git --work-tree="$DOTFILES_DIR" --git-dir="$DOTFILES_DIR/.git" pull origin master

# Package managers & packages

. "$DOTFILES_DIR/install/brew.sh"
. "$DOTFILES_DIR/install/brew-apps.sh"
. "$DOTFILES_DIR/install/brew-cask.sh"

# Install extra stuff

if [ -d "$EXTRA_DIR" -a -f "$EXTRA_DIR/install.sh" ]; then
    . "$EXTRA_DIR/install.sh"
fi

# Copy custom zshrc to home
if [ -f "$DOTFILES_DIR/install/.zshrc" ]; then
    cp "$DOTFILES_DIR/install/.zshrc" "$HOME/.zshrc"
fi

