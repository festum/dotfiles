# ~/.bashrc: executed by Festum-bash(1) for non-login shells.

ME="$(id -u -n)"

# Perform file completion in a case insensitive fashion
# bind "set completion-ignore-case on"
# Treat hyphens and underscores as equivalent
# bind "set completion-map-case on"
# Display matches for ambiguous patterns at first tab press
# bind "set show-all-if-ambiguous on"
# Immediately add a trailing slash when autocompleting symlinks to directories
# bind "set mark-symlinked-directories on"
# Enable history expansion with space
# E.g. typing !!<space> will replace the !! with your last command
# bind Space:magic-space
# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;
# Save multi-line commands as one command
shopt -s cmdhist
# Prepend cd to directory names automatically
shopt -s autocd 2> /dev/null
# Correct spelling errors during tab-completion
shopt -s dirspell 2> /dev/null
# Correct spelling errors in arguments supplied to cd
shopt -s cdspell 2> /dev/null
# Turn on recursive globbing (enables ** to recurse all directories)
shopt -s globstar 2> /dev/null
# Allows to bookmark favorite places across the file system
shopt -s cdable_vars

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
[ ! -d ~/.tmux ] && git clone --depth=1 https://github.com/gpakosz/.tmux.git ~/.tmux && cp ~/.tmux/.tmux.conf.local ~
[ ! -d ~/.tmux/plugins/tpm ] && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
[ -f ~/.bash_aliases ] && . ~/.bash_aliases
[ -f ~/.fe0/.bash_aliases ] && . ~/.fe0/.bash_aliases && export BASH_IT_THEME='candy'
if [ "$(uname)" != "Darwin" ]; then
    shopt -s histappend
    shopt -s cdspell
    shopt -s checkwinsize
    shopt -s globstar
    welcome
fi
export ME=$(id -u -n)
export HISTTIMEFORMAT="%F %T "
export HISTCONTROL=ignoreboth:erasedups
export HISTFILESIZE=500000
export HISTSIZE=${HISTFILESIZE}
export HSTR_CONFIG=hicolor,keywords,favorites,noconfirm,verbose-kill
export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"
export HISTIGNORE="&:[ ]*:ls:ll:bg:fg:clear:cls:c:exit:history*:h:hh:ps:rv*:gs:gaa:gp:gl:gpl:gpush:gps:venv:pipi:python:php:go:java:node"
export BASH_IT=$HOME/.bash_it
export BYOBU_PREFIX=/usr/local
export TERM=xterm-256color
export GIT_HOSTING=$ME@gitlab.com
export VISUAL=vim
export EDITOR=$VISUAL
export GIT_EDITOR=$VISUAL
export TODO=t
export TMUX_TMPDIR=~/.tmux/tmp
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
export JAVA_HOME=/opt/jdk
export CARGO=$HOME/.cargo/bin
export BIN=$HOME/bin:$HOME/.local/bin:/fe0/bin:/usr/local/go/bin:$GOROOT/bin:$GOPATH/bin:/fe0/opt/gotools/bin:$JAVA_HOME/bin
export PYBIN=$HOME/Library/Python/2.7/bin:$HOME/Library/Python/3.6/bin
export PATH=/usr/bin:/usr/local/bin:$PYBIN:$BIN:$CARGO:$HOME/.nexustools:$PATH
[ -f ~/.bashrc_local ] && . ~/.bashrc_local
[ -x /usr/local/bin/docker-machine ] && [ "$(uname)" != "Linux" ] && export DMHOST=$(docker-machine ip default) && dmused
[ -x /usr/bin/direnv ] || [ -x /usr/local/bin/direnv ] && eval "$(direnv hook bash)"
[ -x /usr/local/bin/thefuck ] && eval "$(thefuck --alias)"
[ -x /usr/bin/pipenv ] || [ -x /usr/local/bin/pipenv ] && eval "$(pipenv --completion)"
[ -x /usr/bin/kubectl ] || [ -x /usr/local/bin/kubectl ] && source <(kubectl completion bash)
[ -x /usr/local/bin/awless ] && source <(awless completion bash)
[ -x /usr/bin/direnv ] || [ -x /usr/local/bin/direnv ] && eval "$(direnv hook bash)"
[ -s ${HOME}/.sdkman/bin/sdkman-init.sh ] && source ${HOME}/.sdkman/bin/sdkman-init.sh
[ -s $NVM_DIR/nvm.sh ] && \. $NVM_DIR/nvm.sh
[ -s $NVM_DIR/bash_completion ] && \. $NVM_DIR/bash_completion && c
[ -f ${HOME}/.gvm/scripts/gvm ] && source ${HOME}/.gvm/scripts/gvm
[ -f ${HOME}/.bashhub/bashhub.sh ] && source ${HOME}/.bashhub/bashhub.sh
[ -f $(pwd)/alacritty-completions.bash ] && source ${pwd}/alacritty-completions.bash
[ -f ${HOME}/.fzf.bash ] && source ${HOME}/.fzf.bash
[ -f /usr/local/lib/python2.7/dist-packages/powerline/bindings/bash/powerline.sh ] && source /usr/local/lib/python2.7/dist-packages/powerline/bindings/bash/powerline.sh
[ -f ${NVM_DIR}/versions/node/v8.4.0/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.bash ] && source ${NVM_DIR}/versions/node/v8.4.0/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.bash
[ -f ${NVM_DIR}/versions/node/v8.4.0/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.bash ] && source ${NVM_DIR}/versions/node/v8.4.0/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.bash

if [ -x /usr/bin/hstr ]; then
    if [[ $- =~ .*i.* ]]; then bind '"\C-r": "\C-a hstr -- \C-j"'; fi
    if [[ $- =~ .*i.* ]]; then bind '"\C-xk": "\C-a hstr -k \C-j"'; fi
fi
if [ $TILIX_ID ] || [ $VTE_VERSION ] ; then source /etc/profile.d/vte.sh; fi # Ubuntu Budgie END
