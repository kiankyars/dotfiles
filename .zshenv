# Ensure unique entries in PATH and fpath to automatically prevent duplicates
typeset -U path fpath

# User-local commands installed by native tools
path=("$HOME/.local/bin" $path)

# Expose command-line launchers bundled with transferred applications.
if [[ -d "/Applications/Cursor.app/Contents/Resources/app/bin" ]]; then
  path=("/Applications/Cursor.app/Contents/Resources/app/bin" $path)
fi

if [[ -d "/Applications/Tailscale.app/Contents/MacOS" ]]; then
  path=("/Applications/Tailscale.app/Contents/MacOS" $path)
  export TAILSCALE_BE_CLI=1
fi

# Cargo / Rust environment setup
if [ -f "$HOME/.cargo/env" ]; then
  source "$HOME/.cargo/env"
fi
