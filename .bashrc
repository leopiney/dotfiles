export BASH_SILENCE_DEPRECATION_WARNING=1

# FZF
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Base virtualenv
export VIRTUAL_ENV_BASE_ACTIVATE_THIS=~/.env-base/bin/activate_this.py

# Save history after each command (to share history between windows)
export PROMPT_COMMAND='history -a'

# Expand size of bash history and dont save duplicate commands
export HISTSIZE=20000
export HISTFILESIZE=20000
export HISTCONTROL=ignoredups:erasedups

# FZF configurations
export FZF_IGNORED="*.pyc,.git,.DS_store,.env,node_modules,__pycache__,.ipynb_checkpoints,.serverless,.next,*.ibc,*.idr~,*.swp"
export FZF_DEFAULT_COMMAND='ag -U --ignore={'$FZF_IGNORED'} --hidden -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Complete stuff
complete -W "\`grep -oE '^[a-zA-Z0-9_.-]+:([^=]|$)' Makefile | sed 's/[^a-zA-Z0-9_.-]*$//'\`" make

# PIPENV
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Vim default editor
export EDITOR='vim'

# Aliases
alias batt="pmset -g batt"
alias cl="clear"
alias comp="docker-compose"
alias g="gitsh"
alias l="ls -lsh"
alias ll="ls -lsha"
alias sshgrok='ssh -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null leo@0.tcp.ngrok.io -p'

# Load custom, per machine, options. Such as adding cuda libraries to path
if [ -f ~/.bashrc_extra ]; then
  . ~/.bashrc_extra
fi