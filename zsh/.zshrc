# ~/.zshrc

# Zinit install (if not already installed)
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Plugins (optional but useful)
# Load completions
autoload -U compinit && compinit
# Order is IMPORTANT
zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-autosuggestions
#zinit light zsh-users/zsh-syntax-highlighting
zinit light zdharma-continuum/fast-syntax-highlighting

# Catppuccin mocha
export LS_COLORS="no=00:fi=38;2;205;214;244:di=38;2;137;180;250:ln=38;2;203;166;247:pi=38;2;250;179;135:so=38;2;245;194;231:bd=38;2;250;179;135:cd=38;2;250;179;135:or=38;2;243;139;168:mi=38;2;243;139;168:su=38;2;166;227;161:sg=38;2;166;227;161:ca=38;2;243;139;168:tw=38;2;148;226;213:ow=38;2;148;226;213:st=38;2;116;199;236:ex=38;2;166;227;161:*.tar=38;2;250;179;135:*.tgz=38;2;250;179;135:*.arc=38;2;250;179;135:*.arj=38;2;250;179;135:*.taz=38;2;250;179;135:*.lha=38;2;250;179;135:*.lz4=38;2;250;179;135:*.lzh=38;2;250;179;135:*.lzma=38;2;250;179;135:*.tlz=38;2;250;179;135:*.txz=38;2;250;179;135:*.tzo=38;2;250;179;135:*.t7z=38;2;250;179;135:*.zip=38;2;250;179;135:*.z=38;2;250;179;135:*.dz=38;2;250;179;135:*.gz=38;2;250;179;135:*.lrz=38;2;250;179;135:*.lz=38;2;250;179;135:*.lzo=38;2;250;179;135:*.xz=38;2;250;179;135:*.zst=38;2;250;179;135:*.7z=38;2;250;179;135:*.rar=38;2;250;179;135:*.jpg=38;2;245;224;220:*.jpeg=38;2;245;224;220:*.mjpg=38;2;245;224;220:*.mjpeg=38;2;245;224;220:*.gif=38;2;245;224;220:*.bmp=38;2;245;224;220:*.pbm=38;2;245;224;220:*.pgm=38;2;245;224;220:*.ppm=38;2;245;224;220:*.tga=38;2;245;224;220:*.xbm=38;2;245;224;220:*.xpm=38;2;245;224;220:*.tif=38;2;245;224;220:*.tiff=38;2;245;224;220:*.png=38;2;245;224;220:*.svg=38;2;245;224;220:*.svgz=38;2;245;224;220:*.mng=38;2;245;224;220:*.pcx=38;2;245;224;220:*.mov=38;2;245;194;231:*.mpg=38;2;245;194;231:*.mpeg=38;2;245;194;231:*.m2v=38;2;245;194;231:*.mkv=38;2;245;194;231:*.webm=38;2;245;194;231:*.ogm=38;2;245;194;231:*.mp4=38;2;245;194;231:*.m4v=38;2;245;194;231:*.mp4v=38;2;245;194;231:*.vob=38;2;245;194;231:*.qt=38;2;245;194;231:*.nuv=38;2;245;194;231:*.wmv=38;2;245;194;231:*.asf=38;2;245;194;231:*.rm=38;2;245;194;231:*.rmvb=38;2;245;194;231:*.flc=38;2;245;194;231:*.avi=38;2;245;194;231:*.fli=38;2;245;194;231:*.flv=38;2;245;194;231:*.gl=38;2;245;194;231:*.dl=38;2;245;194;231:*.xcf=38;2;245;194;231:*.xwd=38;2;245;194;231:*.yuv=38;2;245;194;231:*.cgm=38;2;245;194;231:*.emf=38;2;245;194;231:*.audio=38;2;166;227;161:*.aac=38;2;166;227;161:*.au=38;2;166;227;161:*.flac=38;2;166;227;161:*.m4a=38;2;166;227;161:*.mid=38;2;166;227;161:*.midi=38;2;166;227;161:*.mka=38;2;166;227;161:*.mp3=38;2;166;227;161:*.mpc=38;2;166;227;161:*.ogg=38;2;166;227;161:*.ra=38;2;166;227;161:*.wav=38;2;166;227;161:*.oga=38;2;166;227;161:*.opus=38;2;166;227;161:*.spx=38;2;166;227;161:*.xspf=38;2;166;227;161"

# Keybindings
#bindkey '^p' history-search-backward
#bindkey '^n' history-search-forward

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
#zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='ls --color'
alias vim="nvim"

# Fzf integration
command -v fzf >/dev/null && eval "$(fzf --zsh)"

# Load Starship prompt
export PATH="$HOME/.local/bin:$PATH"
command -v starship >/dev/null && eval "$(~/.local/bin/starship init zsh)"

# Tmuxifier
export PATH="$HOME/.tmux/plugins/tmuxifier/bin:$PATH"
command -v tmuxifier >/dev/null && eval "$(tmuxifier init -)"

