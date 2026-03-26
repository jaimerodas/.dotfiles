#!/bin/bash
# Ghostty setup

DOTFILES="$HOME/.dotfiles"
GHOSTTY_CONFIG="$HOME/Library/Application Support/com.mitchellh.ghostty/config.ghostty"

# Check if already configured
if [[ "$(readlink "$GHOSTTY_CONFIG")" == "$DOTFILES/ghostty/config.ghostty" ]]; then
	warn "Ghostty already configured"
	return 0
fi

bold "Configuring Ghostty..."
mkdir -p "$(dirname "$GHOSTTY_CONFIG")"
ln -sf "$DOTFILES/ghostty/config.ghostty" "$GHOSTTY_CONFIG"
bold "Ghostty configured!"
