#!/bin/bash
# 1Password SSH agent setup

SSH_CONFIG="$HOME/.ssh/config"

# Check if already configured
if [[ -f "$SSH_CONFIG" ]] && grep -q "1password" "$SSH_CONFIG"; then
	warn "1Password SSH agent already configured"
	return 0
fi

if ! ask "Set up SSH agent via 1Password?"; then return 0; fi

bold "Configuring 1Password SSH agent..."
mkdir -p "$HOME/.ssh"
cat > "$SSH_CONFIG" <<-'EOF'
Host *
    IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
EOF
bold "SSH agent configured!"
