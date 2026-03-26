# AGENTS.md

Jaime Rodas's macOS dotfiles. The repo uses Spanish for commits, comments, and README.

## Structure

```
Brewfile              # Homebrew packages (CLI tools + casks)
download              # Bootstrap script: installs Xcode CLI tools, Homebrew, clones repo
setup                 # Main orchestrator: runs Brewfile then setup.d/*.sh in order
setup.d/              # Modular, idempotent setup scripts (fish, git, ghostty, mise, 1password, macos)
fish/                 # Fish shell config + custom functions
git/                  # Gitconfig template (user details are set locally per machine)
ghostty/              # Ghostty terminal config (custom dark theme)
mise/                 # Mise config (Ruby latest)
```

## Conventions

- **Symlinks**: Configs live in the repo and are symlinked to their standard locations (~/.config/fish, ~/.gitconfig, etc.)
- **Idempotency**: Every script in setup.d/ checks whether it's already configured before acting. Running `setup` multiple times is safe.
- **Spanish**: Commits, comments, and user-facing messages are in Spanish.
- **Minimalism**: Lean shell config, no bloat. Fish functions only for essentials.

## Key tools

- **Shell**: Fish (default shell)
- **Terminal**: Ghostty
- **Editor**: Nova (`VISUAL=nova`)
- **Git**: pull with rebase, push with autoSetupRemote, default branch `main`
- **SSH**: 1Password agent (no traditional ssh-agent)
- **Version management**: Mise for Ruby
- **ls replacement**: eza (via `lt` function)
- **Finance**: fava/beancount (via `moneys` function)

## Setup scripts (setup.d/)

Each script uses helpers defined in `setup`: `bold()`, `warn()`, `ask()`, `sep()`.

| Script | Purpose | Idempotency check |
|---|---|---|
| fish.sh | Adds fish to /etc/shells, sets as default, symlinks config | Checks symlinks and $SHELL |
| git.sh | Prompts for name/email, creates local gitconfig, symlinks | Checks global user.name |
| ghostty.sh | Symlinks config | Checks existing symlink |
| mise.sh | Symlinks config + runs `mise install` | Checks existing symlink |
| 1password.sh | Creates ~/.ssh/config with 1Password socket | Looks for "1password" in ssh config |
| macos.sh | Configures hot corners via `defaults write` | Compares current values |

## When making changes

- Maintain idempotency in setup scripts.
- New tools go in the Brewfile with their config in a dedicated directory and a setup script in setup.d/.
- Fish functions go in `fish/functions/<name>.fish`.
- Never commit personal data (git name/email are configured locally per machine).
