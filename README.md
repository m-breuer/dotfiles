# Dotfiles

My personal dotfiles for macOS.

## Prerequisites

- macOS
- Administrator access (`sudo`)
- Internet connection

## Installation

To install, simply run the `install.sh` script:

```bash
./install.sh
```

The script will:

- Install Xcode Command Line Tools (and exit early until they are finished)
- Install Homebrew
- Install all packages from `install/Brewfile`
- Create symlinks for `.zshrc` and `.gitconfig`
- Keep backups of existing dotfiles using timestamped `.bak.YYYYMMDDHHMMSS` names

## Idempotency

- Safe to run multiple times.
- Existing correct symlinks are preserved.
- Existing files are backed up before replacement.

## Partial runs

Install only packages:

```bash
./install/packages.sh
```

Refresh only symlinks:

```bash
./install.sh
```

The installer avoids sourcing `.zshrc` in non-interactive mode. Open a new terminal or run:

```bash
source ~/.zshrc
```

## Adding new packages

To add a new package, simply add it to the `install/Brewfile`. You can find more information on how to use the `Brewfile` in the [Homebrew documentation](https://docs.brew.sh/Manpage#bundle-subcommand-verbs-install-dump-cleanup-check-list-exec).

## Quality checks

Run shell lint/format checks locally:

```bash
./scripts/lint-shell.sh
```

A GitHub Actions workflow also runs these checks on push and pull request.

## Structure

The most important files are:

- `install.sh`: main installation script
- `install/packages.sh`: package installation script
- `install/Brewfile`: Homebrew package list
- `scripts/lint-shell.sh`: shell quality checks (`shellcheck` + `shfmt`)
- `.zshrc`: ZSH configuration file
- `.gitconfig`: Git configuration file
