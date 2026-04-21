#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$HOME/.dotfiles"

# Keep up-to-date as you want to manage more configs
STOW_PACKAGES=(
  nvim
  hammerspoon
  zed
  tmux
  starship
  ghostty
  zsh
)

# 1. Xcode CLT (skips if already present)
xcode-select -p >/dev/null 2>&1 || xcode-select --install

# 2. Homebrew (arm64 & Intel)
if ! command -v brew >/dev/null; then
  NONINTERACTIVE=1 /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# 3. Bundle everything
brew bundle --file="$DOTFILES_DIR/Brewfile"

# 4. Stow dotfiles (only if there are packages to stow)
if [ "${#STOW_PACKAGES[@]}" -gt 0 ]; then
  for pkg in "${STOW_PACKAGES[@]}"; do
    stow -d "$DOTFILES_DIR" -v -R "$pkg"
  done
fi
