# ==============================================================================
# 1. Environment & PATH Configurations
# ==============================================================================

# User-local commands installed by native tools
export PATH="$HOME/.local/bin:$PATH"

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

# Install a vendor-native CLI only when it is missing.
_install_native_cli() {
  local display_name="$1"
  local command_name="$2"
  local installer_url="$3"
  local installer_path
  local temporary_root="${TMPDIR:-/tmp}"

  if command -v "$command_name" >/dev/null 2>&1; then
    echo "==> $display_name already installed."
    return 0
  fi

  echo "==> Installing $display_name with its official installer..."
  installer_path="$(mktemp "${temporary_root%/}/${command_name}-installer.XXXXXX")" || return 1

  if ! /usr/bin/curl --fail --silent --show-error --location "$installer_url" --output "$installer_path"; then
    /bin/rm -f "$installer_path"
    echo "Failed to download the $display_name installer." >&2
    return 1
  fi

  if ! /bin/bash "$installer_path"; then
    /bin/rm -f "$installer_path"
    echo "Failed to install $display_name." >&2
    return 1
  fi

  /bin/rm -f "$installer_path"
  rehash

  if ! command -v "$command_name" >/dev/null 2>&1; then
    echo "$display_name installed, but $command_name is not available on PATH." >&2
    return 1
  fi
}

# Keep vendor-specific CLI names explicit: `grok` and `cursor-agent`.
_remove_ambiguous_agent_launchers() {
  local launcher
  local target

  for launcher in "$HOME/.grok/bin/agent" "$HOME/.local/bin/agent"; do
    if [[ ! -L "$launcher" ]]; then
      if [[ -e "$launcher" ]]; then
        echo "Refusing to remove unexpected non-symlink: $launcher" >&2
        return 1
      fi
      continue
    fi

    target="$(/usr/bin/readlink "$launcher")" || return 1
    case "$target" in
      *grok*|*cursor-agent*)
        /bin/rm -f "$launcher" || return 1
        echo "==> Removed ambiguous agent launcher: $launcher"
        ;;
      *)
        echo "Refusing to remove unexpected agent symlink: $launcher -> $target" >&2
        return 1
        ;;
    esac
  done

  rehash
}

# Sync command-line tools, Cursor extensions, and dotfiles configuration.
synchronisation() {
  local autoupdate_plist="$HOME/Library/LaunchAgents/com.github.domt4.homebrew-autoupdate.plist"
  local cursor_launcher="/Applications/Cursor.app/Contents/Resources/app/bin/cursor"
  local extension_id

  echo "==> Syncing command-line tools with Homebrew..."
  brew bundle --file="$HOME/.Brewfile" || return 1

  if [[ ! -f "$autoupdate_plist" ]]; then
    echo "==> Configuring weekly Homebrew autoupdate..."
    brew autoupdate start 1w --upgrade --cleanup --leaves-only --no-notify || return 1
  else
    echo "==> Homebrew autoupdate already configured."
  fi

  _install_native_cli "Grok CLI" "grok" "https://x.ai/cli/install.sh" || return 1
  _install_native_cli "Claude Code" "claude" "https://claude.ai/install.sh" || return 1
  _remove_ambiguous_agent_launchers || return 1

  if [[ -x "$cursor_launcher" ]]; then
    echo "==> Syncing Cursor extensions..."
    while IFS= read -r extension_id; do
      "$cursor_launcher" --install-extension "$extension_id" || return 1
    done < <(sed -n 's/^# vscode "\([^"]*\)".*/\1/p' "$HOME/.Brewfile")
  else
    echo "==> Cursor.app not found, skipping Cursor extension sync."
  fi

  if [ -d "$HOME/.cfg" ]; then
    echo "==> Configuring dotfiles repository to only show tracked files..."
    git --git-dir="$HOME/.cfg" --work-tree="$HOME" config --local status.showUntrackedFiles no
  fi
}

# ==============================================================================
# 5. External Integrations
# ==============================================================================

# ==============================================================================
# 6. Plugins & Styling
# ==============================================================================

# Source syntax highlighting if available
if [ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# >>> grok installer >>>
export PATH="$HOME/.grok/bin:$PATH"
fpath=(~/.grok/completions/zsh $fpath)
autoload -Uz compinit && compinit -C
# <<< grok installer <<<
