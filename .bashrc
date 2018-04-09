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
export FZF_DEFAULT_COMMAND='ag -U --ignore={"*.pyc",".git","node_modules","__pycache__"} --hidden -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Vim default editor
export EDITOR='vim'

# Not sure what this is, maybe for man an the such?
export VISUAL='vim'

# Aliases
alias mux="tmuxinator"
alias l="ls -lsh"
alias ll="ls -lsha"
alias comp="docker-compose"
alias g="gitsh"
alias cl="clear"
alias sshgrok='ssh -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null leo@tcp://0.tcp.ngrok.io -p'

# Add files in ~/bin to path
PATH=$PATH:~/bin

# Fixes the following problem with brew
# https://github.com/Homebrew/homebrew-php/issues/4527#issuecomment-346483994
PATH=$PATH:/usr/local/sbin

title() {
    echo -n -e "\033]0;"$*"\007"
}

# Highlight folders on ls
LS_COLORS=$LS_COLORS:'di=0;35:' ; export LS_COLORS

# Load custom, per machine, options. Such as adding cuda libraries to path
if [ -f ~/.bashrc_extra ]; then
  . ~/.bashrc_extra
fi
