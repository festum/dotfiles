# ~/.bashrc: executed by Festum-bash(1) for non-login shells.

ME="$(id -u -n)"

case $- in
    *i*) ;;
      *) return;;
esac
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
[ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ] && debian_chroot=$(cat /etc/debian_chroot)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt
unset MAILCHECK
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    # alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

if [[ $PS1 && -f /usr/share/bash-completion/bash_completion ]]; then
  . /usr/share/bash-completion/bash_completion
  set show-all-if-ambiguous on
  set visible-stats on
fi
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
export BASH_IT_THEME='minimal'
[ ! -f ~/.bash_it/install.sh ] && git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it && ~/.bash_it/install.sh -s -n
[ -f ~/.bash_aliases ] && . ~/.bash_aliases
[ -f ~/.fe0/.bash_aliases ] && . ~/.fe0/.bash_aliases && export BASH_IT_THEME='sexy'
if [ "$(uname)" != "Darwin" ]; then
    shopt -s histappend
    shopt -s cdspell
    shopt -s checkwinsize
    shopt -s globstar
    welcome
fi
export ME=$(id -u -n)
export HISTTIMEFORMAT="%Y-%m-%d %T "
export HISTCONTROL=ignorespace
export HISTFILESIZE=10000
export HISTSIZE=${HISTFILESIZE}
export HH_CONFIG=hicolor,keywords,favorites,noconfirm,verbose-kill
export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"
export HISTIGNORE="exit:hh:history*:h:ps:gs:gpl:gaa:gpull:gpush:rv:venv:pipi:python:php:go:java:node:"
export BASH_IT=$HOME/.bash_it
export BYOBU_PREFIX=/usr/local
export TERM=xterm-256color
export GIT_HOSTING=$ME@gitlab.com
export VISUAL=vim
export EDITOR=$VISUAL
export GIT_EDITOR=$VISUAL
export TODO=t
export TMUX_TMPDIR=~/.tmux_tmp
export LANG=en_US.UTF-8
export LC_ALL=$LANG
export IRC_CLIENT=irssi
export SCM_CHECK=true
export SHORT_HOSTNAME=$(hostname -s)
export SHORT_USER=${USER:0:8}
export SHORT_TERM_LINE=true
export BASH_IT_AUTOMATIC_RELOAD_AFTER_CONFIG_CHANGE=1
[ -f ${BASH_IT}/bash_it.sh ] && source "$BASH_IT"/bash_it.sh
export SDKMAN_DIR=$HOME/.sdkman
export NVM_DIR=$HOME/.nvm
export GOROOT=/usr/local/go
export GOPATH=$HOME/Repo/godev
export GO111MODULE=on
export JAVA_HOME=/usr/lib/jvm/java-8-oracle
export CARGO=$HOME/.cargo/bin
export BIN=$HOME/bin:$HOME/.local/bin
export PYBIN=$HOME/Library/Python/3.6/bin:$HOME/Library/Python/2.7/bin
export PATH=/usr/bin/:/usr/local/bin:$PYBIN:$BIN:$CARGO:/usr/local/go/bin:$GOROOT/bin:$GOPATH/bin:$HOME/.nexustools:$PATH

if [ -x /usr/local/bin/hh ] || [ -x /usr/bin/hh ]; then
    [[ $- =~ .*i.* ]] && bind '"\C-r": "\C-a hh -- \C-j"'
    [[ $- =~ .*i.* ]] && bind '"\C-xk": "\C-a hh -k \C-j"'
fi
[ -x /usr/bin/docker-machine ] || [ -x /usr/local/bin/docker-machine ] && export DMHOST=$(docker-machine ip default) && dmused
[ -x /usr/bin/direnv ] || [ -x /usr/local/bin/direnv ] && eval "$(direnv hook bash)"
[ -x /usr/local/bin/thefuck ] && eval "$(thefuck --alias)"
[ -s ${HOME}/.sdkman/bin/sdkman-init.sh ] && source ${HOME}/.sdkman/bin/sdkman-init.sh
[ -s $NVM_DIR/nvm.sh ] && \. $NVM_DIR/nvm.sh
[ -s $NVM_DIR/bash_completion ] && \. $NVM_DIR/bash_completion && c
[ -f ${HOME}/.gvm/scripts/gvm ] && source ${HOME}/.gvm/scripts/gvm
[ -f ${HOME}/.bashhub/bashhub.sh ] && source ${HOME}/.bashhub/bashhub.sh
[ -f $(pwd)/alacritty-completions.bash ] && source ${pwd}/alacritty-completions.bash
[ -f ${HOME}/.fzf.bash ] && source ${HOME}/.fzf.bash
[ -f ${NVM_DIR}/versions/node/v8.4.0/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.bash ] && source ${NVM_DIR}/versions/node/v8.4.0/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.bash
[ -f ${NVM_DIR}/versions/node/v8.4.0/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.bash ] && source ${NVM_DIR}/versions/node/v8.4.0/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.bash
[ -x /usr/bin/pipenv ] || [ -x /usr/local/bin/pipenv ] && eval "$(pipenv --completion)"
[ -x /usr/bin/kubectl ] || [ -x /usr/local/bin/kubectl ] && source <(kubectl completion bash)

