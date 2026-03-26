#!/bin/bash
# Mise setup

DOTFILES="$HOME/.dotfiles"
MISE_CONFIG="$HOME/.config/mise/config.toml"

# Check if already configured
if [[ "$(readlink "$MISE_CONFIG")" == "$DOTFILES/mise/config.toml" ]]; then
	warn "Mise already configured"
	return 0
fi

if ! ask "Set up mise (Ruby version manager)?"; then return 0; fi

bold "Configuring mise..."
mkdir -p "$HOME/.config/mise"
ln -sf "$DOTFILES/mise/config.toml" "$MISE_CONFIG"

if command -v mise &>/dev/null; then
	bold "Installing Ruby via mise..."
	mise install
fi

bold "Mise configured!"
