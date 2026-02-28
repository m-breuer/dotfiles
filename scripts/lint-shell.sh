#!/usr/bin/env bash

set -euo pipefail

if ! command -v shellcheck >/dev/null 2>&1; then
    echo "shellcheck is required. Install it with: brew install shellcheck"
    exit 1
fi

if ! command -v shfmt >/dev/null 2>&1; then
    echo "shfmt is required. Install it with: brew install shfmt"
    exit 1
fi

mapfile -t shell_files < <(rg --files -g '*.sh')

if [ "${#shell_files[@]}" -eq 0 ]; then
    echo "No shell files found."
    exit 0
fi

shellcheck "${shell_files[@]}"
shfmt -d "${shell_files[@]}"
