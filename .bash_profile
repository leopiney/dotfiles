if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

# GHC configurations
export PATH="$HOME/Library/Haskell/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$(pyenv root)/shims:$PATH"
