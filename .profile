# ==============================================================================
# Shell Profile Configuration (.profile)
# ==============================================================================

# Initialize Cargo / Rust toolchain environment
if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi

# Added by Antigravity CLI installer
export PATH="/Users/kian/.local/bin:$PATH"
