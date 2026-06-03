# ==============================================================================
# 1. Environment & PATH Configurations
# ==============================================================================

# Added by Antigravity CLI installer
export PATH="/Users/kian/.local/bin:$PATH"

# Bun configuration
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# >>> grok installer >>>
export PATH="$HOME/.grok/bin:$PATH"
fpath=(~/.grok/completions/zsh $fpath)
autoload -Uz compinit && compinit -C
# <<< grok installer <<<

# ==============================================================================
# 2. Shell Options & Settings
# ==============================================================================

# Disable terminal flow control (Ctrl-S / Ctrl-Q) to prevent freeze
[[ -t 0 ]] && stty -ixon

# Prevent overriding files with '>' redirection (use '>!' or '>|' to override)
set -o noclobber

# ==============================================================================
# 3. Autocompletion System
# ==============================================================================

# Initialize compinit (with caching support for faster startup)
autoload -Uz compinit
if [[ -s "${ZDOTDIR:-$HOME}/.zcompdump" ]]; then
  compinit -C
else
  compinit
fi

# Bun completions
[[ -s "/Users/kian/.bun/_bun" ]] && source "/Users/kian/.bun/_bun"

# ==============================================================================
# 4. Aliases
# ==============================================================================

# Safety & Navigation
alias rm='rm -I'
alias cdr='cd $(git rev-parse --show-toplevel)'

# Git Config repository management
alias config='git --git-dir=/Users/kian/.cfg/ --work-tree=/Users/kian'

# Media Downloads & Playback
alias audio='yt-dlp -o "/Users/kian/Music/Music/Media.localized/Music/Unknown Artist/Unknown Album/%(title)s.%(ext)s" -x --audio-format mp3'
alias video='yt-dlp -o "$HOME/Downloads/%(title)s.%(ext)s" -f "bestvideo+bestaudio/best" --merge-output-format mp4'
alias loop='ffplay -nodisp -autoexit -af "volume=3.0"'
alias songs='cd /Users/kian/Music/Music/Media.localized/Music/Unknown\ Artist/Unknown\ Album/'

# Productivity & Utilities
alias journal='open -a VoiceMemos'

# Sync Homebrew bundle and Cursor extensions
brew-sync() {
  echo "==> Syncing system packages with Homebrew..."
  brew bundle --file=~/.Brewfile
  if command -v cursor >/dev/null 2>&1; then
    echo "==> Syncing Cursor extensions..."
    grep '^# vscode ' ~/.Brewfile | cut -d'"' -f2 | xargs -I{} cursor --install-extension {}
  else
    echo "==> Cursor CLI not found, skipping extension sync."
  fi
}

# ==============================================================================
# 5. External Integrations
# ==============================================================================

# Google Cloud SDK path updates
if [ -f '/Users/kian/Developer/google-cloud-sdk/path.zsh.inc' ]; then
  source '/Users/kian/Developer/google-cloud-sdk/path.zsh.inc'
fi

# Google Cloud SDK shell command completion
if [ -f '/Users/kian/Developer/google-cloud-sdk/completion.zsh.inc' ]; then
  source '/Users/kian/Developer/google-cloud-sdk/completion.zsh.inc'
fi

# ==============================================================================
# 6. Plugins & Styling (Must be loaded last)
# ==============================================================================

# Source syntax highlighting if available
if [ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
