# Dotfiles

My personal dotfiles for macOS.

## Installation

To install, simply run the `install.sh` script:

```bash
./install.sh
```

The script will:

*   Install Xcode Command Line Tools
*   Install Homebrew
*   Install all the packages from the `Brewfile`
*   Create symlinks for `.zshrc` and `.gitconfig`
*   Source the `.zshrc` file

## Adding new packages

To add a new package, simply add it to the `install/Brewfile`. You can find more information on how to use the `Brewfile` in the [Homebrew documentation](https://docs.brew.sh/Manpage#bundle-subcommand-verbs-install-dump-cleanup-check-list-exec).

## Structure

The most important files are:

*   `install.sh`: the main installation script
*   `install/packages.sh`: the script that installs all the packages
*   `install/Brewfile`: the list of all the packages to install
*   `.zshrc`: the ZSH configuration file
*   `.gitconfig`: the Git configuration file