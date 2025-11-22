source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.env
stty -ixon
set -o noclobber
alias audio='yt-dlp -o "/Users/kian/Music/Music/Media.localized/Music/Unknown Artist/Unknown Album/%(title)s.%(ext)s" -x --audio-format mp3'
alias journal='open -a VoiceMemos'
alias loop='ffplay -nodisp -autoexit -loop 0'
alias makeenv='echo "GOOGLE_API_KEY=$GOOGLE_API_KEY\nANTHROPIC_API_KEY=$ANTHROPIC_API_KEY\nHUGGINGFACE_API_KEY=$HUGGINGFACE_API_KEY" > .env && echo ".env file created"'
alias songs='cd /Users/kian/Music/Music/Media.localized/Music/Unknown\ Artist/Unknown\ Album/'
alias video='yt-dlp -o "$HOME/Downloads/%(title)s.%(ext)s" -f "bv*[vcodec^=avc]+ba[ext=m4a]/b[ext=mp4]/b" --merge-output-format mp4'
alias config='git --git-dir=/Users/kian/.cfg/ --work-tree=/Users/kian'
