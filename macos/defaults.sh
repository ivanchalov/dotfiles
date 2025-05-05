#!/usr/bin/env bash

# Disable windows opening animations
# Helps to reduce animations when using tiling window manager, e.g. Aerospace
# Particularly for Google Chrome
# Idempotent call
current=$(defaults read -g NSAutomaticWindowAnimationsEnabled 2>/dev/null || echo "(unset)")
if [[ "$current" != "0" ]]; then
  defaults write -g NSAutomaticWindowAnimationsEnabled -bool false
  echo "→ Animation disabled"
else
  echo "✓ Animation already disabled"
fi
