source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[[ -t 0 ]] && stty -ixon
set -o noclobber
autoload -Uz compinit
if [[ -s "${ZDOTDIR:-$HOME}/.zcompdump" ]]; then
  compinit -C
else
  compinit
fi
alias rm='rm -I'
alias audio='yt-dlp -o "/Users/kian/Music/Music/Media.localized/Music/Unknown Artist/Unknown Album/%(title)s.%(ext)s" -x --audio-format mp3'
alias journal='open -a VoiceMemos'
alias loop='ffplay -nodisp -autoexit -loop 0'
alias songs='cd /Users/kian/Music/Music/Media.localized/Music/Unknown\ Artist/Unknown\ Album/'
alias video='yt-dlp -o "$HOME/Downloads/%(title)s.%(ext)s" -f "bestvideo+bestaudio/best" --merge-output-format mp4'
alias config='git --git-dir=/Users/kian/.cfg/ --work-tree=/Users/kian'
alias cdr='cd $(git rev-parse --show-toplevel)'

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/kian/Developer/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/kian/Developer/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/kian/Developer/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/kian/Developer/google-cloud-sdk/completion.zsh.inc'; fi

# bun completions
[ -s "/Users/kian/.bun/_bun" ] && source "/Users/kian/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
