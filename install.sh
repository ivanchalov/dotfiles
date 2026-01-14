#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$HOME/.dotfiles"

# Keep up-to-date as you want to manage more configs
STOW_PACKAGES=()

# 1. Xcode CLT (skips if already present)
xcode-select -p >/dev/null 2>&1 || xcode-select --install

# 2. Homebrew (arm64 & Intel)
if ! command -v brew >/dev/null; then
  NONINTERACTIVE=1 /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# 3. Bundle everything
brew bundle --file="$DOTFILES_DIR/Brewfile"

# 4. Install LazyVim

# If an existing nvim config exists, delete it
if [ -e "${HOME}/.config/nvim" ]; then
  rm -rf "${HOME}/.config/nvim"
fi

mkdir -p "${HOME}/.config"
git clone https://github.com/LazyVim/starter "${HOME}/.config/nvim"

# Make it "plain LazyVim" by detaching from the starter repo
rm -rf "${HOME}/.config/nvim/.git"

# 5. Stow dotfiles
brew list stow >/dev/null 2>&1 || brew install stow
for pkg in "${STOW_PACKAGES[@]}"; do
  stow -v -R "$pkg"
done
