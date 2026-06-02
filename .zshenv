# Ensure unique entries in PATH and fpath to automatically prevent duplicates
typeset -U path fpath

# uv configuration
export PATH="/Users/kian/.local/bin:$PATH"

# Cargo / Rust environment setup
if [ -f "$HOME/.cargo/env" ]; then
  source "$HOME/.cargo/env"
fi
