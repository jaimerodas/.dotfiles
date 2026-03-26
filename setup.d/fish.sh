#!/bin/bash
# Fish shell setup

DOTFILES="$HOME/.dotfiles"
FISH_CONFIG="$HOME/.config/fish/config.fish"
FISH_FUNCTIONS="$HOME/.config/fish/functions"

# Check if already configured
if [[ "$(readlink "$FISH_CONFIG")" == "$DOTFILES/fish/config.fish" ]] \
	&& [[ "$(readlink "$FISH_FUNCTIONS")" == "$DOTFILES/fish/functions" ]] \
	&& [[ "$SHELL" == *"fish"* ]]; then
	warn "Fish already configured"
	return 0
fi

if ! ask "Set up Fish shell?"; then return 0; fi

bold "Configuring Fish..."
FISH_PATH="$(command -v fish)"

if [[ -z "$FISH_PATH" ]]; then
	warn "Fish not found, skipping"
	return 0
fi

# Add fish to allowed shells if needed
if ! grep -qF "$FISH_PATH" /etc/shells; then
	echo "$FISH_PATH" | sudo tee -a /etc/shells
fi

# Set as default shell
if [[ "$SHELL" != *"fish"* ]]; then
	chsh -s "$FISH_PATH"
fi

# Symlink fish config files
mkdir -p "$HOME/.config/fish"
ln -sf "$DOTFILES/fish/config.fish" "$FISH_CONFIG"
ln -snf "$DOTFILES/fish/functions" "$FISH_FUNCTIONS"

bold "Fish configured!"
