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

# Sync system packages, Cursor extensions, dotfiles configuration, and LaunchAgents
synchronisation() {
  echo "==> Syncing system packages with Homebrew..."
  brew bundle --file=~/.Brewfile
  if command -v cursor >/dev/null 2>&1; then
    echo "==> Syncing Cursor extensions..."
    grep '^# vscode ' ~/.Brewfile | cut -d'"' -f2 | xargs -I{} cursor --install-extension {}
  else
    echo "==> Cursor CLI not found, skipping extension sync."
  fi

  if [ -d "$HOME/.cfg" ]; then
    echo "==> Configuring dotfiles repository to only show tracked files..."
    git --git-dir="$HOME/.cfg" --work-tree="$HOME" config --local status.showUntrackedFiles no
  fi

  if [ -f "$HOME/Library/LaunchAgents/com.obsidian.daily-git-sync.plist" ]; then
    echo "==> Registering Obsidian daily git sync LaunchAgent..."
    if ! launchctl print gui/$(id -u)/com.obsidian.daily-git-sync >/dev/null 2>&1; then
      launchctl bootstrap gui/$(id -u) "$HOME/Library/LaunchAgents/com.obsidian.daily-git-sync.plist"
      echo "    LaunchAgent registered successfully."
    else
      echo "    LaunchAgent already registered."
    fi
  fi
}

# ==============================================================================
# 5. External Integrations
# ==============================================================================

# ==============================================================================
# 6. Plugins & Styling (Must be loaded last)
# ==============================================================================

# Source syntax highlighting if available
if [ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
