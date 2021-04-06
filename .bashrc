#!/usr/bin/env bash
# $HOME/.bashrc: executed by Festum-bash(1) for non-login shells.

case $- in
  *i*) ;;
    *) return;;
esac

# Perform file completion in a case insensitive fashion
# bind "set completion-ignore-case on"
# Treat hyphens and underscores as equivalent
bind "set completion-map-case on"
# Display matches for ambiguous patterns at first tab press
bind "set show-all-if-ambiguous on"
# Immediately add a trailing slash when autocompleting symlinks to directories
bind "set mark-symlinked-directories on"
# Enable history expansion with space
# E.g. typing !!<space> will replace the !! with your last command
bind Space:magic-space
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

function command_exists () {
    command -v $1 >/dev/null 2>&1;
}

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
unset MAILCHECK # Don't check mail when opening terminal.
case "$TERM" in
    xterm*|rxvt*)
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
    *)
    ;;
esac

[ -f $HOME/.bash_keys ] && source $HOME/.bash_keys
[ ! -d $HOME/.autocomplete ] && mkdir -p $HOME/.autocomplete
if command_exists kubectl; then
    source <(kubectl completion bash)
    alias k8=kubectl
    complete -F __start_kubectl k8
    [ ! -f $HOME/.autocomplete/fubectl.source ] && curl -L https://rawgit.com/kubermatic/fubectl/master/fubectl.source -o $HOME/.autocomplete/fubectl.source
    source $HOME/.autocomplete/fubectl.source
    [ ! -f $HOME/.kubectx/completion/kubens.bash ] && git clone https://github.com/ahmetb/kubectx.git $HOME/.kubectx && COMPDIR=$(pkg-config --variable=completionsdir bash-completion) && sudo ln -sf $HOME/.kubectx/completion/kubens.bash $COMPDIR/kubens && sudo ln -sf $HOME/.kubectx/completion/kubectx.bash $COMPDIR/kubectx && sudo ln -sf $HOME/.kubectx/kubectx /usr/local/bin/kubectx && sudo ln -sf $HOME/.kubectx/kubens /usr/local/bin/kubens
    export PATH=$HOME/.kubectx:$PATH
fi
if [[ $PS1 && -f /usr/share/bash-completion/bash_completion ]]; then
    . /usr/share/bash-completion/bash_completion
    set show-all-if-ambiguous on
    set visible-stats on
fi
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        source /usr/share/bash-completion/bash_completion
        elif [ -f /etc/bash_completion ]; then
        source /etc/bash_completion
    fi
fi
if ! [ -f /etc/os-release ]; then
    # install sudo for termux
    if ! command_exists sudo; then
        pkg install ncurses-utils
        git cone https://gitlab.com/st42/termux-sudo.git
        cat termux-sudo/sudo > /data/data/com.termux/files/usr/bin/sudo
        chmod 700 /data/data/com.termux/files/usr/bin/sudo
        rm -rf termux-sudo
    fi
else  # create folder for non-termux
    [ ! -d /usr/local ] && sudo mkdir /usr/local
    [ ! -d /usr/local/bin ] && sudo ln -s /usr/bin /usr/local/bin
    [ ! -d /usr/local/include ] && sudo ln -s /usr/include /usr/local/include
fi

if command_exists hstr; then
    if [[ $- =~ .*i.* ]]; then bind '"\C-r": "\C-a hstr -- \C-j"'; fi
    if [[ $- =~ .*i.* ]]; then bind '"\C-xk": "\C-a hstr -k \C-j"'; fi
fi

function debug_handler() {
    LAST_COMMAND=$BASH_COMMAND;
}
function error_handler() {
    local LAST_HISTORY_ENTRY=$(history | tail -1l)

    # if last command is in history (HISTCONTROL, HISTIGNORE)...
    if [ "$LAST_COMMAND" == "$(cut -d ' ' -f 2- <<< $LAST_HISTORY_ENTRY)" ]
    then
        # ...prepend it's history number into FAILED_COMMANDS,
        # marking the command for deletion.
        FAILED_COMMANDS="$(cut -d ' ' -f 1 <<< $LAST_HISTORY_ENTRY) $FAILED_COMMANDS"
    fi
}
function exit_handler() {
    for i in $(echo $FAILED_COMMANDS | tr ' ' '\n' | uniq)
    do
        history -d $i
    done
    FAILED_COMMANDS=
}
trap debug_handler DEBUG
trap error_handler ERR
trap exit_handler EXIT

export ME=$(id -u -n)
export HISTTIMEFORMAT="%F %T "
export HISTCONTROL=ignoreboth:erasedups
export HISTFILESIZE=500000
export HISTSIZE=${HISTFILESIZE}
export HSTR_CONFIG=hicolor,keywords,favorites,noconfirm,verbose-kill
export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"
export HISTIGNORE="&:[ ]*:[ \t]*:l[sla]:[bf]g:clear:cls:c:exit:mount:umount:history*:h:hh:ps:rv*:gs:gaa:gp:gl:gpl:gpush:gps:venv:pipi:python:php:go:java:node"
export BASH_IT_THEME=minimal
export BASH_IT=$HOME/.bash_it
export BASH_IT_AUTOMATIC_RELOAD_AFTER_CONFIG_CHANGE=1 # Bash-it auto reload after enabling or disabling aliases, plugins, and completions
export BASH_IT_RELOAD_LEGACY=0
export SCM_GIT_SHOW_MINIMAL_INFO=true
export BYOBU_PREFIX=/usr/local
export TERM=xterm-256color
export GIT_HOSTING=git@github.com
export GIT_EDITOR=$VISUAL
export VISUAL=vim
export EDITOR=$VISUAL
export TODO=t
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export LANG=en_US.UTF-8
export LANGUAGE=$LANG
export LC_ALL=$LANG
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'
export IRC_CLIENT=irssi # Change this to your console based IRC client of choice.
export SCM_CHECK=true # Version control status checking
export SHORT_HOSTNAME=$(hostname -s) # Set Xterm/screen/Tmux title with only a short hostname
export SHORT_TERM_LINE=true # Set Xterm/screen/Tmux title with shortened command and directory
#export SHORT_USER=${USER:0:8} # Trim max len of username
export TMUX_TMPDIR=$HOME/.tmux/tmp
export NVM_DIR=$HOME/.nvm
export GO111MODULE=auto
export GOPROXY=direct
export GOPATH=$HOME/.go
export GOBIN=$GOPATH/bin #$(go env GOPATH)
[ -d /usr/local/go ] && export GOROOT=/usr/local/go
[ ! -d $HOME/.local ] && mkdir -p $HOME/.local
[ ! -d $HOME/.config ] && mkdir -p $HOME/.config
[ -f $HOME/.bashrc_local ] && source $HOME/.bashrc_local
export BIN=$HOME/bin:/snap/bin:$HOME/.local/bin:/fe0/bin:$GOROOT/bin:$GOBIN:/fe0/opt/gotools/bin:$JAVA_HOME/bin:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin
export PATH=$BIN:$PATH
[ ! -f $HOME/.bash_it/install.sh ] && git clone --depth=1 https://github.com/Bash-it/bash-it $HOME/.bash_it && $HOME/.bash_it/install.sh -s -n
[ -f $BASH_IT/bash_it.sh ] && source $BASH_IT/bash_it.sh
[ ! -d $HOME/.tmux ] && git clone --depth=1 https://github.com/gpakosz/.tmux $HOME/.tmux && ln -s -f $HOME/.tmux/.tmux.conf $HOME && mkdir -p $HOME/.tmux/tmp
[ ! -d $HOME/.tmux/plugins/tpm ] && git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
[ -f $HOME/.bash_aliases ] && source $HOME/.bash_aliases
[ -s $HOME/.sdkman/bin/sdkman-init.sh ] && export SDKMAN_DIR=$HOME/.sdkman && source $HOME/.sdkman/bin/sdkman-init.sh
[ -s $NVM_DIR/nvm.sh ] && source $NVM_DIR/nvm.sh
[ -s $NVM_DIR/bash_completion ] && source $NVM_DIR/bash_completion && c
[ -f $HOME/.gvm/scripts/gvm ] && source $HOME/.gvm/scripts/gvm
[ -f $HOME/.bashhub/bashhub.sh ] && source $HOME/.bashhub/bashhub.sh
[ -f $(pwd)/alacritty-completions.bash ] && source $(pwd)/alacritty-completions.bash
[ -f $HOME/.fzf.bash ] && source $HOME/.fzf.bash
command_exists docker-compose && [ "$(uname)" != "Linux" ] && export DMHOST=$(docker-machine ip default) && dmused
command_exists direnv && eval "$(direnv hook bash)"
command_exists thefuck && eval "$(thefuck --alias)"
command_exists pipenv && eval "$(pipenv --completion)"
command_exists lesspipe && eval "$(SHELL=/bin/sh lesspipe)"
command_exists jump && eval "$(jump shell bash --bind=j)"
command_exists awless && source <(awless completion bash)


if [ "$(uname)" == "Darwin" ]; then
    [ ! -f $HOME/.bash_profile ] && echo source $HOME/.bashrc >> $HOME/.bash_profile
else
    shopt -s histappend
    shopt -s cdspell
    shopt -s checkwinsize
    shopt -s globstar
    welcome
fi
[ $TILIX_ID ] && source /etc/profile.d/vte.sh # Ubuntu Budgie END

