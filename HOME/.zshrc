#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Arata Sato <densiarata2@gmail.com>

### completion
fpath=($(brew --prefix)/share/zsh/site-functions $fpath)
fpath=($(ghq root)/github.com/zsh-users/zsh-completions/src $fpath)
source $HOME/.zsh/completion.zsh
autoload -U compinit
# compinit

# ------------------------------------------------------------------------------
##### Plugins #####

### Pure prompt
### https://github.com/sindresorhus/pure
autoload -U promptinit; promptinit
PURE_PROMPT_SYMBOL=🌵
zstyle :prompt:pure:git:branch color '#bbb'
prompt pure

### incremental completion
# source $(ghq root)/github.com/zsh-users/zsh-autosuggestions/zsh-autosuggestions.zsh
# ZSH_AUTOSUGGEST_HISTORY_IGNORE="cd *,ls *"
# ZSH_AUTOSUGGEST_STRATEGY=(completion history)
# bindkey '\t ' autosuggest-accept
### https://mimosa-pudica.net/zsh-incremental.html
source $HOME/.zsh/incr*.zsh

### syntax highlighting
source $(ghq root)/github.com/zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

### vim style key bind
bindkey -v

### autojump
### https://github.com/wting/autojump
### make sure to use Python3
# [[ -s $HOME/.autojump/etc/profile.d/autojump.sh ]] && source $HOME/.autojump/etc/profile.d/autojump.sh
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

### zsh-history-substring-search
### https://github.com/zsh-users/zsh-history-substring-search
source /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# ------------------------------------------------------------------------------

### Python
py_init() {
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  # Setting for pip
  export PATH="$PYENV_ROOT/shims:$PATH"
  eval "$(pyenv init -)"
  # eval "$(pipenv --completion)"
}

py_init

# pyenv() {
#   unset -f pyenv
#   py_init
#   pyenv "$@"
# }

# python() {
#   unset -f python
#   py_init
#   python "$@"
# }

# pipenv() {
#   unset -f pipenv
#   py_init
#   pipenv "$@"
# }

### Ruby
rb_init() {
  export RBENV_ROOT="$HOME/.rbenv"
  export PATH="$RBENV_ROOT/bin:$PATH"
  eval "$(rbenv init -)"
}

rb_init

### Go
go_init() {
  # export GOPATH=$HOME/go
  export GOENV_ROOT="$HOME/.goenv"
  export PATH="$GOENV_ROOT/bin:$PATH"
  export PATH="$GOROOT/bin:$PATH"
  export PATH="$PATH:$GOPATH/bin"
  eval "$(goenv init -)"
}

goenv() {
  unset -f goenv
  go_init
  goenv "$@"
}

go() {
  unset -f go
  go_init
  go "$@"
}

### ESP-IDF
# export PATH=$HOME/esp/xtensa-esp32-elf/bin:$PATH
# export IDF_PATH=~/esp/esp-idf

### Node.js
node_init() {
  export NVM_DIR="$HOME/.nvm"
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"
}

nvm() {
  unset -f nvm
  node_init
  nvm "$@"
}

node() {
  unset -f node
  node_init
  node "$@"
}

npm() {
  unset -f npm
  node_init
  npm "$@"
}

# eval "$(direnv hook zsh)"

gcloud_init() {
  ### The next line updates PATH for the Google Cloud SDK.
  if [ -f '/Users/ataran/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/ataran/google-cloud-sdk/path.zsh.inc'; fi

  ### The next line enables shell command completion for gcloud.
  if [ -f '/Users/ataran/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/ataran/google-cloud-sdk/completion.zsh.inc'; fi
}

gcloud() {
  unset -f gcloud
  gcloud_init
  gcloud "$@"
}

### path for flutter
export PATH="$PATH:$(ghq root)/github.com/flutter/flutter/bin"

### opam configuration
# test -r /Users/ataran/.opam/opam-init/init.zsh && . /Users/ataran/.opam/opam-init/init.zsh >/dev/null 2>/dev/null || true
# alias ocaml="rlwrap ocaml"

### ngspice
# export PATH="/Applications/ngspice/bin/:$PATH"

### Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
# export PATH="$PATH:$HOME/.rvm/bin"

### Dart
export PATH="$PATH":"$HOME/.pub-cache/bin"


### aliases ###
alias myip='curl http://ipecho.net/plain; echo'
alias reload='source $HOME/.zshrc'
alias zshconfig='code $(ghq root)/github.com/atrn0/dotfiles'

# if (which zprof >/dev/null 2>&1); then
#   zprof
# fi
