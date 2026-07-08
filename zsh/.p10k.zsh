# Powerlevel10k config styled after ../starship/starship.toml.

'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
  emulate -L zsh -o extended_glob

  unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'
  [[ $ZSH_VERSION == (5.<1->*|<6->.*) ]] || return

  local red='#f38ba8'
  local peach='#fab387'
  local yellow='#f9e2af'
  local green='#a6e3a1'
  local lavender='#b4befe'
  local crust='#11111b'

  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    os_icon
    context_joined
    dir
    vcs
    newline
    prompt_char
  )
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    time
    command_execution_time
    newline
  )

  typeset -g POWERLEVEL9K_MODE=nerdfont-complete
  typeset -g POWERLEVEL9K_ICON_PADDING=none
  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=false
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_CHAR='─'
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_BACKGROUND=
  typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_GAP_BACKGROUND=
  if [[ $POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_CHAR != ' ' ]]; then
    typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_FOREGROUND=238
    typeset -g POWERLEVEL9K_EMPTY_LINE_LEFT_PROMPT_FIRST_SEGMENT_END_SYMBOL='%{%}'
    typeset -g POWERLEVEL9K_EMPTY_LINE_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL='%{%}'
  fi
  typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=always
  typeset -g POWERLEVEL9K_DISABLE_RPROMPT=false
  typeset -g POWERLEVEL9K_BACKGROUND=
  typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=
  typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=
  typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=''
  typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=''
  typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=''
  typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=''
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL=''
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL=''

  typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=$crust
  typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND=$red

  typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND=$crust
  typeset -g POWERLEVEL9K_CONTEXT_BACKGROUND=$red
  typeset -g POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND=$crust
  typeset -g POWERLEVEL9K_CONTEXT_ROOT_BACKGROUND=$red
  typeset -g POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_FOREGROUND=$crust
  typeset -g POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_BACKGROUND=$red
  typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE='%n'
  typeset -g POWERLEVEL9K_CONTEXT_ROOT_TEMPLATE='%n'
  typeset -g POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_TEMPLATE='%n'

  typeset -g POWERLEVEL9K_DIR_FOREGROUND=$crust
  typeset -g POWERLEVEL9K_DIR_BACKGROUND=$peach
  typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=$crust
  typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=$crust
  typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=false
  typeset -g POWERLEVEL9K_DIR_VISUAL_IDENTIFIER_EXPANSION=
  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_last
  typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
  typeset -g POWERLEVEL9K_SHORTEN_DELIMITER='…/'

  typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=$crust
  typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND=$yellow
  typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=$crust
  typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND=$yellow
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=$crust
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND=$yellow
  typeset -g POWERLEVEL9K_VCS_CONFLICTED_FOREGROUND=$crust
  typeset -g POWERLEVEL9K_VCS_CONFLICTED_BACKGROUND=$yellow
  typeset -g POWERLEVEL9K_VCS_LOADING_FOREGROUND=$crust
  typeset -g POWERLEVEL9K_VCS_LOADING_BACKGROUND=$yellow
  typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=' '
  typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_EXPANSION=
  typeset -g POWERLEVEL9K_VCS_DISABLE_GITSTATUS_FORMATTING=true
  typeset -g POWERLEVEL9K_VCS_CONTENT_EXPANSION='${$((starship_p10k_git_formatter()))+${starship_p10k_git_format}}'
  typeset -g POWERLEVEL9K_VCS_{STAGED,UNSTAGED,UNTRACKED,CONFLICTED,COMMITS_AHEAD,COMMITS_BEHIND}_MAX_NUM=-1
  typeset -g POWERLEVEL9K_VCS_BACKENDS=(git)

  function starship_p10k_git_formatter() {
    emulate -L zsh

    local branch git_status
    if [[ -n $VCS_STATUS_LOCAL_BRANCH ]]; then
      branch=${(V)VCS_STATUS_LOCAL_BRANCH}
      git_status="${(g::)POWERLEVEL9K_VCS_BRANCH_ICON}${branch//\%/%%}"
    elif [[ -n $VCS_STATUS_TAG ]]; then
      git_status="#${(V)VCS_STATUS_TAG//\%/%%}"
    else
      git_status="@${VCS_STATUS_COMMIT[1,8]}"
    fi

    git_status+=" "
    [[ -n $VCS_STATUS_ACTION ]] && git_status+="%B${VCS_STATUS_ACTION}%b"
    (( VCS_STATUS_NUM_CONFLICTED )) && git_status+="%B=%b"
    (( VCS_STATUS_STASHES )) && git_status+="%B\$%b"
    (( VCS_STATUS_NUM_STAGED )) && git_status+="%B+%b"
    (( VCS_STATUS_NUM_UNSTAGED )) && git_status+="%B!%b"
    (( VCS_STATUS_NUM_UNTRACKED )) && git_status+="%B?%b"
    (( VCS_STATUS_COMMITS_AHEAD && VCS_STATUS_COMMITS_BEHIND )) && git_status+="%B⇕%b"
    (( VCS_STATUS_COMMITS_AHEAD && !VCS_STATUS_COMMITS_BEHIND )) && git_status+="%B⇡%b"
    (( VCS_STATUS_COMMITS_BEHIND && !VCS_STATUS_COMMITS_AHEAD )) && git_status+="%B⇣%b"

    typeset -g starship_p10k_git_format=$git_status
  }
  functions -M starship_p10k_git_formatter 2>/dev/null

  typeset -g POWERLEVEL9K_TIME_FOREGROUND=$crust
  typeset -g POWERLEVEL9K_TIME_BACKGROUND=$lavender
  typeset -g POWERLEVEL9K_TIME_VISUAL_IDENTIFIER_EXPANSION=
  typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M}'

  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=$crust
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND=$lavender
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=2
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=3
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='d h m s'
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_VISUAL_IDENTIFIER_EXPANSION=
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PREFIX='in '
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_LEFT_SEGMENT_SEPARATOR=
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_RIGHT_SEGMENT_SEPARATOR=

  function p10k-on-post-prompt() {
    emulate -L zsh

    local -i last_status=${_p9k__status:-0}
    local prompt_char_color=$'%{\e[38;2;166;227;161m%}'
    (( last_status )) && prompt_char_color=$'%{\e[38;2;243;139;168m%}'
    local prompt_char_reset=$'%{\e[0m%}'
    _p9k_transient_prompt="${prompt_char_color}❯${prompt_char_reset} "
  }

  function starship_p10k_draw_command_start_time() {
    emulate -L zsh
    [[ -t 1 ]] || return

    local start_time="${(%):-%D{%H:%M\}}"
    local -i column=$(( COLUMNS - ${#start_time} ))
    (( column < 1 )) && column=1

    local esc=$'\e'
    print -rn -- "${esc}7${esc}[1A${esc}[${column}G${esc}[38;2;108;112;134m${start_time}${esc}[0m${esc}8"
  }

  autoload -Uz add-zsh-hook
  add-zsh-hook -d preexec starship_p10k_draw_command_start_time 2>/dev/null
  add-zsh-hook preexec starship_p10k_draw_command_start_time

  typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND=
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_SEGMENT_SEPARATOR=
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_{LEFT,RIGHT}_WHITESPACE=
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=true
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND=$green
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND=$red
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_FOREGROUND=$green
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_FOREGROUND=$green
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIVIS_FOREGROUND=$yellow
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIVIS_FOREGROUND=$yellow
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIOWR_FOREGROUND=$lavender
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIOWR_FOREGROUND=$lavender
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='%B❯%b'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='%B❮%b'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='%B❮%b'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIOWR_CONTENT_EXPANSION='%B❮%b'
}

(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'
