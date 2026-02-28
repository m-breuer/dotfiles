#!/usr/bin/env bash

set -euo pipefail

#
# Dotfiles installer
#
# Inspired by: https://github.com/alrra/dotfiles/blob/main/install.sh
#

export DOTFILES_DIR
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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

# Keep sudo credentials fresh while the script runs.
start_sudo_keepalive() {
	while true; do
		sudo -n true
		sleep 60
		kill -0 "$$" || exit
	done 2>/dev/null &
	SUDO_KEEPALIVE_PID=$!
}

cleanup() {
	if [ -n "${SUDO_KEEPALIVE_PID:-}" ] && kill -0 "${SUDO_KEEPALIVE_PID}" 2>/dev/null; then
		kill "${SUDO_KEEPALIVE_PID}" 2>/dev/null || true
	fi
}

# Create a symlink
create_symlink() {
	# $1: source
	# $2: destination
	local source="$1"
	local destination="$2"
	local current_target
	local backup_path

	# Keep existing correct symlinks untouched to stay idempotent.
	if [ -L "$destination" ]; then
		current_target="$(readlink "$destination")"
		if [ "$current_target" = "$source" ]; then
			return
		fi
		rm -f "$destination"
	elif [ -e "$destination" ]; then
		backup_path="${destination}.bak.$(date +%Y%m%d%H%M%S)"
		mv "$destination" "$backup_path"
		printf "Backed up %s to %s\n" "$destination" "$backup_path"
	fi

	ln -s "$source" "$destination"
}

#
# Sudo
#

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished
start_sudo_keepalive
trap cleanup EXIT

#
# Git
#

print_header "Updating dotfiles..."

# Update dotfiles itself
if [ -d "$DOTFILES_DIR/.git" ]; then
	CURRENT_BRANCH="$(git -C "$DOTFILES_DIR" rev-parse --abbrev-ref HEAD)"
	if [ "$CURRENT_BRANCH" != "HEAD" ]; then
		git -C "$DOTFILES_DIR" pull --ff-only origin "$CURRENT_BRANCH"
	else
		DEFAULT_BRANCH="$(git -C "$DOTFILES_DIR" symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's|^origin/||')"
		if [ -n "$DEFAULT_BRANCH" ]; then
			git -C "$DOTFILES_DIR" pull --ff-only origin "$DEFAULT_BRANCH"
		else
			printf "Skipping git pull: could not determine remote default branch.\n"
		fi
	fi
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

bash "$DOTFILES_DIR/install/packages.sh"

#
# Extra
#

EXTRA_DIR="$HOME/.extra"

# Install extra stuff
if [ -d "$EXTRA_DIR" ] && [ -f "$EXTRA_DIR/install.sh" ]; then
	print_header "Installing extra stuff..."
	. "$EXTRA_DIR/install.sh"
fi

#
# ZSH
#

print_header "Configuring ZSH..."

printf "Skipping .zshrc sourcing in installer to avoid non-interactive side effects.\n"
printf "Open a new shell session (or run 'source ~/.zshrc') to apply shell changes.\n"

print_header "Done!"
