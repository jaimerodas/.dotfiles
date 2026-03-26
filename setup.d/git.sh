#!/bin/bash
# Git setup

DOTFILES="$HOME/.dotfiles"
GITCONFIG="$HOME/.gitconfig"

# Check if already configured
if git config --global user.name &>/dev/null && git config --global user.email &>/dev/null; then
	warn "Git already configured"
	return 0
fi

if ! ask "Set up Git?"; then return 0; fi

bold "Configuring Git..."
read -rp "Git name: " git_name
read -rp "Git email: " git_email

cp "$DOTFILES/git/gitconfig" "$DOTFILES/git/gitconfig.local"
git config --file "$DOTFILES/git/gitconfig.local" user.name "$git_name"
git config --file "$DOTFILES/git/gitconfig.local" user.email "$git_email"

ln -sf "$DOTFILES/git/gitconfig.local" "$GITCONFIG"
bold "Git configured!"
