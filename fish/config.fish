eval "$(/opt/homebrew/bin/brew shellenv)"

# editor
set -gx VISUAL nova

/opt/homebrew/bin/mise activate fish | source

# Added by OrbStack: command-line tools and integration
source ~/.orbstack/shell/init2.fish 2>/dev/null; or :
