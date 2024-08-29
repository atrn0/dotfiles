#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Arata Sato <aratsato@gmail.com>

# zmodload zsh/zprof && zprof

ARCH=`arch`

if [[ "${ARCH}" == "arm64" ]]
then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

### history
export HISTFILESIZE=1000000000
export HISTSIZE=1000000000
setopt HIST_IGNORE_DUPS
setopt share_history
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS


### completion
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
else
  echo 'brew is not installed'
fi

fpath=($HOME/.zsh/completion $fpath)

autoload -U compinit
compinit -i

# ### init go
if type go &>/dev/null; then
  GOPATH=$(go env GOPATH)
  GOROOT=$(go env GOROOT)
  export PATH="$GOROOT/bin:$PATH"
  export PATH="$PATH:$GOPATH/bin"
fi

if type ghq &>/dev/null; then
  FPATH=$(ghq root)/github.com/zsh-users/zsh-completions/src:$FPATH
fi

. $HOME/.zsh/completion.zsh

# ------------------------------------------------------------------------------
# ##### Plugins #####


# RPROMPT='$(git config --local --get user.email 2>/dev/null)'
### Pure prompt
### https://github.com/sindresorhus/pure
# PURE_REPO_REMOTE=github.com/sindresorhus/pure
# FPATH=$(ghq root)/$PURE_REPO_REMOTE:$FPATH
# autoload -U promptinit; promptinit;
# if prompt -p pure | grep 'Unknown theme: pure'; then
#   echo 'installing pure'
#   ghq get $PURE_REPO_REMOTE
#   autoload -U promptinit; promptinit
# fi
#
# if ! prompt -p pure | grep 'Unknown theme: pure'; then
#   PURE_PROMPT_SYMBOL=🌵
#   PURE_GIT_UNTRACKED_DIRTY=0
#   zstyle :prompt:pure:git:branch color '#bbb'
#   prompt pure
# fi

### Starship
# eval "$(starship init zsh)"

### incremental completion
# AUTO_SUGGESTION_REPO_REMOTE=github.com/zsh-users/zsh-autosuggestions
# if [ ! -e $(ghq root)/$AUTO_SUGGESTION_REPO_REMOTE ]; then
#   ghq get $AUTO_SUGGESTION_REPO_REMOTE
# fi
# source $(ghq root)/$AUTO_SUGGESTION_REPO_REMOTE/zsh-autosuggestions.zsh
# ZSH_AUTOSUGGEST_HISTORY_IGNORE="cd *,ls *"
# ZSH_AUTOSUGGEST_STRATEGY=(completion history)
# ZSH_AUTOSUGGEST_USE_ASYNC=true
# bindkey '\t ' autosuggest-accept
# ### https://mimosa-pudica.net/zsh-incremental.html
# # source $HOME/.zsh/incr*.zsh

### syntax highlighting
SYNTAX_HIGHLIGHTING_REPO_REMOTE=github.com/zsh-users/zsh-syntax-highlighting
if [ ! -e $(ghq root)/$SYNTAX_HIGHLIGHTING_REPO_REMOTE ]; then
  ghq get $SYNTAX_HIGHLIGHTING_REPO_REMOTE
fi
source $(ghq root)/$SYNTAX_HIGHLIGHTING_REPO_REMOTE/zsh-syntax-highlighting.zsh

### emacs style key bind
bindkey -e

### autojump
### https://github.com/wting/autojump
### make sure to use Python3
# [[ -s $HOME/.autojump/etc/profile.d/autojump.sh ]] && source $HOME/.autojump/etc/profile.d/autojump.sh
if ! type autojump &>/dev/null; then
  brew install autojump
fi
if [[ "${ARCH}" == "arm64" ]] then
  [ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh
else
  [ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh
fi

### zsh-history-substring-search
### https://github.com/zsh-users/zsh-history-substring-search
# if ! brew list zsh-history-substring-search &>/dev/null; then
#   brew install zsh-history-substring-search
# fi
# if [[ "${ARCH}" == "arm64" ]] then
#   source /opt/homebrew/Cellar/zsh-history-substring-search/1.0.2/share/zsh-history-substring-search/zsh-history-substring-search.zsh
# else
#   source /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh
# fi
# bindkey '^P' history-substring-search-up
# bindkey '^N' history-substring-search-down

# # ------------------------------------------------------------------------------
### path for flutter
export PATH="$PATH:$(ghq root)/github.com/flutter/flutter/bin"

# # opam configuration
# test -r $HOME/.opam/opam-init/init.zsh && . $HOME/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

# ### Dart
export PATH="$PATH":"$HOME/.pub-cache/bin"

# ### JetBrains
export PATH="$PATH":"$HOME/.jetbrains/bin"

# ### LLVM ###
# export PATH=/usr/local/opt/llvm/bin:$PATH

# ### dosfstools ###
export PATH=/usr/local/Cellar/dosfstools/4.2/sbin:$PATH

# ### binutils ###
# export PATH=/usr/local/opt/binutils/bin:$PATH

# ### Rust ###
export PATH="$HOME/.cargo/bin:$PATH"


# ### Docker on Lima ###
# export DOCKER_HOST=unix:///Users/atrn0/.lima/docker/sock/docker.sock

### direnv ###
eval "$(direnv hook zsh)"

### Terraform ###
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C $(brew --prefix)/bin/terraform terraform


### asdf
. $(brew --prefix asdf)/libexec/asdf.sh
. $(brew --prefix asdf)/etc/bash_completion.d/asdf.bash

### Java
# instead of `. ~/.asdf/plugins/java/set-java-home.zsh`
asdf_update_java_home() {
  local java_path
  java_path="$(asdf which java)"
  if [[ -n "${java_path}" ]]; then
    export JAVA_HOME
    JAVA_HOME="$(dirname "$(dirname "${java_path:A}")")"
    export JDK_HOME=${JAVA_HOME}
  fi
}

autoload -U add-zsh-hook
add-zsh-hook chpwd asdf_update_java_home

### iTerm2
export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=YES

### terminal-notifier
# function preexec () {
#    _prev_cmd=$1
#    _prev_cmd_start_time=$SECONDS
#    _cmd_is_running=true
# }
#
# function precmd() {
#   _status=$?
#   if $_cmd_is_running ; then
#     _prev_cmd_exec_time=$((SECONDS - _prev_cmd_start_time))
#     if ((_prev_cmd_exec_time > 5)); then
#       title=`[ $_status = 0 ] && echo 🟢 || echo 🔴`
#       terminal-notifier -title $title -subtitle "$_prev_cmd" -message "finished" -activate com.googlecode.iterm2
#     fi
#   fi
#   _cmd_is_running=false
# }

### grep
export GREP_OPTIONS='--color=auto'

### k8s
source <(kubectl completion zsh)

### fzf
# [ -f ~/.config/.fzf.zsh ] && source ~/.config/.fzf.zsh
# export FZF_DEFAULT_OPTS="--multi --bind=ctrl-k:kill-line"
# export FZF_TMUX=1
# export FZF_TMUX_OPTS="-p 80%"
# export FZF_CTRL_T_OPTS="--preview 'cat {}'"

### aliases ###
alias myip='curl http://ipecho.net/plain; echo'
alias reload='exec $SHELL -l'
alias zshconfig='code $(ghq root)/github.com/atrn0/dotfiles'
alias dab='git branch -D `git branch --merged | grep -v \* | xargs`'
alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"
# alias gpg='LANG=en gpg'
alias qr=qrcode-terminal
alias glog='git log --graph --date=format-local:"%Y/%m/%d %H:%M:%S" --pretty=format:"%C(yellow)[%ad] %C(cyan)%h%C(red)%d %C(green)%an : %C(blue)%s"'
alias tf="terraform"
alias d="docker"
alias dco="docker compose"
alias g="git"
alias m="make"
alias rcode="code --folder-uri \"vscode-remote://ssh-remote+ien20s/home/atrn0/ghq\""
alias now='date +"%Y-%m-%dT%H:%M:%S%z"'

function decode_uri() {
  if [ -n "$1" ]; then
    python3 -c "import sys, urllib.parse; print(urllib.parse.unquote('$1'))"
  elif [ -t 0 ]; then
    echo "Error: No input provided" >&2
    return 1
  else
    python3 -c "import sys, urllib.parse; print(urllib.parse.unquote(sys.stdin.read().rstrip()))"
  fi
}

function decode_jwt() {
  if [ -n "$1" ]; then
    python -c "import sys, jwt, json; print(json.dumps(jwt.decode('$1', options={'verify_signature': False}), indent=2))"
  elif [ -t 0 ]; then
    echo "Error: No input provided" >&2
    return 1
  else
    python -c "import sys, jwt, json; print(json.dumps(jwt.decode(sys.stdin.read().strip(), options={'verify_signature': False}), indent=2))"
  fi
}

export AWS_ASSUME_ROLE_TTL=1h
export GREP_OPTIONS='--color=auto'

# export PATH="/opt/homebrew/opt/binutils/bin:$PATH"
export BUILDKIT_PROGRESS=plain
# export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"

# mysql-client
export PATH="$(brew --prefix mysql-client)/bin:$PATH"
export LDFLAGS="-L$(brew --prefix mysql-client)/lib $LDFLAGS"
export CPPFLAGS="-I$(brew --prefix mysql-client)/include $CPPFLAGS"
export PKG_CONFIG_PATH="$(brew --prefix mysql-client)/lib/pkgconfig:$PKG_CONFIG_PATH"
export LIBRARY_PATH="$(brew --prefix mysql-client)/lib:$LIBRARY_PATH"

# curl
export LDFLAGS="-L$(brew --prefix curl)/lib $LDFLAGS"
export CPPFLAGS="-I$(brew --prefix curl)/include $CPPFLAGS"
export PKG_CONFIG_PATH="$(brew --prefix curl)/lib/pkgconfig:$PKG_CONFIG_PATH"
export LIBRARY_PATH="$(brew --prefix curl)/lib:$LIBRARY_PATH"

# zstd
export LDFLAGS="-L$(brew --prefix zstd)/lib $LDFLAGS"
export CPPFLAGS="-I$(brew --prefix zstd)/include $CPPFLAGS"
export PKG_CONFIG_PATH="$(brew --prefix zstd)/lib/pkgconfig:$PKG_CONFIG_PATH"
export LIBRARY_PATH="$(brew --prefix zstd)/lib:$LIBRARY_PATH"

# openssl
export LDFLAGS="-L$(brew --prefix openssl)/lib $LDFLAGS"
export CPPFLAGS="-I$(brew --prefix openssl)/include $CPPFLAGS"
export PKG_CONFIG_PATH="$(brew --prefix openssl)/lib/pkgconfig:$PKG_CONFIG_PATH"
export LIBRARY_PATH="$(brew --prefix openssl)/lib:$LIBRARY_PATH"
export OPENSSL_PREFIX="$(brew --prefix openssl@3)"

# GitHub Copilot
eval "$(gh copilot alias -- zsh)"

[ -f ~/.zsh/local.zsh ] && . ~/.zsh/local.zsh

# if (which zprof >/dev/null 2>&1); then
#   zprof
# fi
