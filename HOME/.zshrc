#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Arata Sato <densiarata2@gmail.com>

### completion
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
else 
  echo 'brew is not installed'
  exit 1
fi

### install go
if ! type go &>/dev/null; then
  echo 'installing go'
  brew install go || exit 1
fi

### init go
if type go &>/dev/null; then
  GOPATH=$(go env GOPATH)
  GOROOT=$(go env GOROOT)
  export PATH="$GOROOT/bin:$PATH"
  export PATH="$PATH:$GOPATH/bin"
fi

### install ghq
if ! type ghq &>/dev/null; then
  echo 'installing ghq'
  go get github.com/x-motemen/ghq && echo 'ghq installed' || exit 1
fi

if type ghq &>/dev/null; then
  FPATH=$(ghq root)/github.com/zsh-users/zsh-completions/src:$FPATH
fi

fpath=($HOME/.zsh/completion $fpath)
source $HOME/.zsh/completion.zsh
autoload -U compinit
compinit -C

# ------------------------------------------------------------------------------
##### Plugins #####

### Pure prompt
### https://github.com/sindresorhus/pure
PURE_REPO_REMOTE=github.com/sindresorhus/pure
FPATH=$(ghq root)/$PURE_REPO_REMOTE:$FPATH
autoload -U promptinit; promptinit;
if prompt -p pure | grep 'Unknown theme: pure'; then
  echo 'installing pure'
  ghq get $PURE_REPO_REMOTE
  autoload -U promptinit; promptinit
fi

if ! prompt -p pure | grep 'Unknown theme: pure'; then
  PURE_PROMPT_SYMBOL=🌵
  zstyle :prompt:pure:git:branch color '#bbb'
  prompt pure
fi

### incremental completion
AUTO_SUGGESTION_REPO_REMOTE=github.com/zsh-users/zsh-autosuggestions
if [ ! -e $(ghq root)/$AUTO_SUGGESTION_REPO_REMOTE ]; then
  ghq get $AUTO_SUGGESTION_REPO_REMOTE || exit 1
fi
source $(ghq root)/$AUTO_SUGGESTION_REPO_REMOTE/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HISTORY_IGNORE="cd *,ls *"
ZSH_AUTOSUGGEST_STRATEGY=(completion history)
ZSH_AUTOSUGGEST_USE_ASYNC=true
bindkey '\t ' autosuggest-accept
### https://mimosa-pudica.net/zsh-incremental.html
# source $HOME/.zsh/incr*.zsh

### syntax highlighting
SYNTAX_HIGHLIGHTING_REPO_REMOTE=github.com/zsh-users/zsh-syntax-highlighting
if [ ! -e $(ghq root)/$SYNTAX_HIGHLIGHTING_REPO_REMOTE ]; then
  ghq get $SYNTAX_HIGHLIGHTING_REPO_REMOTE || exit 1
fi
source $(ghq root)/$SYNTAX_HIGHLIGHTING_REPO_REMOTE/zsh-syntax-highlighting.zsh

### vim style key bind
bindkey -v

### autojump
### https://github.com/wting/autojump
### make sure to use Python3
# [[ -s $HOME/.autojump/etc/profile.d/autojump.sh ]] && source $HOME/.autojump/etc/profile.d/autojump.sh
if ! type autojump &>/dev/null; then
  brew install autojump
fi
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

### zsh-history-substring-search
### https://github.com/zsh-users/zsh-history-substring-search
if ! brew list zsh-history-substring-search &>/dev/null; then
  brew install zsh-history-substring-search
fi
source /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# ------------------------------------------------------------------------------

### Python
if ! type pyenv &>/dev/null; then
  brew install pyenv
fi
py_init() {
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  # Setting for pip
  export PATH="$PYENV_ROOT/shims:$PATH"
  eval "$(pyenv init -)"
}

py_init

### Ruby
if ! type rbenv &>/dev/null; then
  brew install rbenv
fi
rb_init() {
  export RBENV_ROOT="$HOME/.rbenv"
  export PATH="$RBENV_ROOT/bin:$PATH"
  eval "$(rbenv init -)"
}

rb_init

### ESP-IDF
# export PATH=$HOME/esp/xtensa-esp32-elf/bin:$PATH
# export IDF_PATH=~/esp/esp-idf

### Node.js
nvm_init() {
  export NVM_DIR="$HOME/.nvm"
  if [ ! -e $NVM_DIR ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | sh
  fi
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
}

nvm_init &!

# eval "$(direnv hook zsh)"

# gcloud_init() {
#   ### The next line updates PATH for the Google Cloud SDK.
#   if [ -f '/Users/ataran/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/ataran/google-cloud-sdk/path.zsh.inc'; fi

#   ### The next line enables shell command completion for gcloud.
#   if [ -f '/Users/ataran/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/ataran/google-cloud-sdk/completion.zsh.inc'; fi
# }

### path for flutter
# export PATH="$PATH:$(ghq root)/github.com/flutter/flutter/bin"

# ### opam configuration
# test -r /Users/ataran/.opam/opam-init/init.zsh && . /Users/ataran/.opam/opam-init/init.zsh >/dev/null 2>/dev/null || true
# # alias ocaml="rlwrap ocaml"
# eval $(opam env)

### Dart
export PATH="$PATH":"$HOME/.pub-cache/bin"

### JetBrains
export PATH="$PATH":"$HOME/.jetbrains/bin"

### Java ###
# export JAVA_HOME=`/usr/libexec/java_home -v 14`

# export PATH="/usr/local/opt/llvm@9/bin:$PATH"

### Rust ###
export PATH="$HOME/.cargo/bin:$PATH"

# use Touch ID for sudo
# https://gist.github.com/kawaz/d95fb3b547351e01f0f3f99783180b9f
if ! grep -Eq '^auth\s.*\spam_tid\.so$' /etc/pam.d/sudo; then
  ( set -e; set -o pipefail
    # 最初の auth として pam_tid.so を追加
    pam_sudo=$(awk 'fixed||!/^auth /{print} !fixed&&/^auth/{print "auth       sufficient     pam_tid.so";print;fixed=1}' /etc/pam.d/sudo)
    sudo tee /etc/pam.d/sudo <<<"$pam_sudo"
  )
fi

### aliases ###
alias myip='curl http://ipecho.net/plain; echo'
alias reload='source $HOME/.zshrc'
alias zshconfig='code $(ghq root)/github.com/atrn0/dotfiles'
alias d='docker'
alias dco='docker-compose'
alias dab='git branch -D `git branch --merged | grep -v \* | xargs`'

# if (which zprof >/dev/null 2>&1); then
#   zprof
# fi
