# ~/.zshrc

# Tmuxifier
export PATH="$HOME/.tmux/plugins/tmuxifier/bin:$PATH"
eval "$(tmuxifier init -)"

# Find and set branch name var if in git repository.
function git_branch_name()
{
  branch=$(git symbolic-ref HEAD 2> /dev/null | awk 'BEGIN{FS="/"} {print $NF}')
  if [[ $branch == "" ]];
  then
    :
  elif [[ $branch == "main" ]];
  then
    echo '- '%F{010}$branch%F{015}
  else
    echo '- '%F{011}$branch%F{015}
  fi
}

# Enable substitution in the prompt.
setopt prompt_subst

# Config for prompt. PS1 synonym.
prompt='%n@%m %1/ $(git_branch_name) %% '
