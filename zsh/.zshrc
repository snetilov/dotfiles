# ~/.zshrc

# ---------- PATH ----------
# Set PATH once, before anything looks up commands: after vevery PATH change zsh
# re-indexes all PATH dirs on the next lookup (~55 ms with WSL's /mnt/c dirs)
typeset -U path # drop duplicate entries
if [[ -n $WSL_DISTRO_NAME ]]; then
  # Windows dirs are on slow 9P mount; keep only needed ones
  # (explorer.exe for nvim's `gx`, VS Code's `code`).
  () {
    local -a keep=(/mnt/c/Windows "/mnt/c/Program Files/Microsoft VS Code/bin")
    path=(${path:#/mnt/*} ${path:*keep})
  }
fi
# User-local libraries + zinit's bin dir (added here so zinit doesn't change PATH later)
path=("$HOME/.local/bin" "${XDG_DATA_DIR:-$HOME/.local/share}/zinit/polaris/bin" $path)

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Zinit install (if not already installed)
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d "$ZINIT_HOME" ] && mkdir -p "$(dirname "$ZINIT_HOME")"
[ ! -d "$ZINIT_HOME/.git" ] && git clone --depth=1 https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# ---------- Editor ----------
# Default editor used by git, crontab, etc.
export EDITOR="nvim"
export VISUAL="nvim"

# ---------- Pager ----------
if command -v bat >/dev/null 2>&1; then
  export MANPAGER="bat -l man -p"
elif command -v batcat >/dev/null 2>&1; then
  export MANPAGER="batcat -l man -p"
fi

# ---------- GPG ----------
export GPG_TTY=$(tty)

# Plugins (optional but useful)
# Load completions
autoload -Uz compinit
# Full check (picks up newly installed completions) at most once a day;
# otherwise load the cached dump as is.
() {
  if (( $# )); then
    compinit -C -u
  else
    compinit -u && touch "${ZDOTDIR:-$HOME}/.zcompdump"
  fi
} "${ZDOTDIR:-$HOME}"/.zcompdump(N.mh-24)
# Order is IMPORTANT
zinit ice wait lucid
zinit light Aloxaf/fzf-tab
zinit ice wait lucid
# Bind widgets once instead  of rebinding them before every prompt (~10 ms/prompt)
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
zinit light zsh-users/zsh-autosuggestions
#zinit light zsh-users/zsh-syntax-highlighting
zinit ice wait lucid
zinit light zdharma-continuum/fast-syntax-highlighting
#zinit light jeffreytse/zsh-vi-mode

# =========================================================
# fzf
# =========================================================

export FZF_DEFAULT_COMMAND='fd --type f --hidden --strip-cwd-prefix'  # strip-cwd-prefix removes the leading ./ from results

# Ctrl-T uses fd
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# UI
export FZF_DEFAULT_OPTS='
  --height=60%
  --layout=reverse
  --border=rounded
  --prompt="  "
  --pointer="  "
  --preview-window=right:65%:wrap:border-left
'

export _FZF_PREVIEW_CMD='bat --color=always --style=plain,numbers --line-range=:500 --file-name={} {}'
export FZF_CTRL_T_OPTS="--preview \"$_FZF_PREVIEW_CMD\""

# Ctrl+F: file picker excluding hidden files
_fzf_file_no_hidden() {
  local cmd result
  cmd="${FZF_DEFAULT_COMMAND/--hidden /}"
  result=$(eval "${cmd:-find . -type f}" | fzf --preview "$_FZF_PREVIEW_CMD") \
    && LBUFFER+="$result"  # LBUFFER is the text left of the cursor
  zle reset-prompt
}
zle -N _fzf_file_no_hidden
bindkey '^F' _fzf_file_no_hidden

# End fzf
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

# =========================================================
# Shell behaviour
# =========================================================

setopt AUTOCD
setopt NOBEEP
setopt NUMERIC_GLOB_SORT  # sort file10 after file9, not after file1
setopt EXTENDED_GLOB  # enable extended pattern matching

# Completion styling
#zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias vim="nvim"

# Better ls
alias ls='eza --icons'

# Detailed listing
alias ll='eza -lh --icons --git'

# Detailed listing including hidden files
alias la='eza -lah --icons --git'

# Tree view
alias tree='eza --tree --icons'

# Reuse ls completions for eza (avoids defining a separate completion function)
compdef eza=ls

# Better cat
alias cat='bat'

# =========================================================
# Core utilities
# =========================================================

alias grep='rg --color=auto'
alias diff='diff --color=auto'
alias df='df -h'

# Fzf integration
(( $+commands[fzf] )) && eval "$(fzf --zsh)"

# Initialize zoxide
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"

# Load Starship prompt
#(( $+commands[starship] )) && eval "$(starship init zsh)"

# Load Powerlevel10k prompt
typeset -g POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
zinit ice depth=1
zinit light romkatv/powerlevel10k
[[ -r "${ZDOTDIR:-$HOME}/.p10k.zsh" ]] && source "${ZDOTDIR:-$HOME}/.p10k.zsh"

# Machine-local-overrrides
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
