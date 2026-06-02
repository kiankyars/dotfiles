# ==============================================================================
# Zsh Login Shell Configuration (.zprofile)
# ==============================================================================

# Initialize Homebrew environment variables and path settings
eval "$(/opt/homebrew/bin/brew shellenv)"

# Add Obsidian CLI to the PATH to allow launching Obsidian from the terminal
export PATH="$PATH:/Applications/Obsidian.app/Contents/MacOS"

# Added by Antigravity CLI installer
export PATH="/Users/kian/.local/bin:$PATH"
