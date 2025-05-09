#!/usr/bin/env bash
# Source https://github.com/festum/dotfiles

# Skipping non-interactively shell
[[ $- == *i* ]] || return

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
shopt -u lithist
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
# Enable extra wildcard patterns such as @(foo|bar) to match foo or bar
shopt -s extglob
# Blinking bar cursor
echo -e -n "\x1b[\x33 q"


[[ -z "${debian_chroot:-}" ]] && [[ -r /etc/debian_chroot ]] && debian_chroot=$(cat /etc/debian_chroot)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac
if [[ -n "$force_color_prompt" ]]; then
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
unset PROMPT_COMMAND
unset color_prompt force_color_prompt
unset MAILCHECK # Don't check mail when opening terminal.
case "$TERM" in
    xterm*|rxvt*)
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
    *)
    ;;
esac

mkdir -p $HOME/.autocomplete $HOME/.local $HOME/.config
source $HOME/.bash_keys 2>/dev/null
if [[ -x "$(command -v kubectl)" ]]; then
    source <(kubectl completion bash)
    alias k8=kubectl
    complete -F __start_kubectl k8
    [[ ! -f $HOME/.autocomplete/fubectl.source ]] && curl -L https://rawgit.com/kubermatic/fubectl/master/fubectl.source -o $HOME/.autocomplete/fubectl.source
    source $HOME/.autocomplete/fubectl.source 2>/dev/null
    [[ ! -f $HOME/.kubectx/completion/kubens.bash ]] && git clone https://github.com/ahmetb/kubectx.git $HOME/.kubectx && COMPDIR=$(pkg-config --variable=completionsdir bash-completion) && sudo ln -sf $HOME/.kubectx/completion/kubens.bash $COMPDIR/kubens && sudo ln -sf $HOME/.kubectx/completion/kubectx.bash $COMPDIR/kubectx && sudo ln -sf $HOME/.kubectx/kubectx /usr/local/bin/kubectx && sudo ln -sf $HOME/.kubectx/kubens /usr/local/bin/kubens
    export PATH=$HOME/.kubectx:$PATH
fi
if [[ $PS1 && -f /usr/share/bash-completion/bash_completion ]]; then
    . /usr/share/bash-completion/bash_completion
    set show-all-if-ambiguous on
    set visible-stats on
fi
if ! shopt -oq posix; then
    if [[ -f /usr/share/bash-completion/bash_completion ]]; then
        source /usr/share/bash-completion/bash_completion 2>/dev/null
        elif [[ -f /etc/bash_completion ]]; then
        source /etc/bash_completion 2>/dev/null
    fi
fi
if ! [[ -f /etc/os-release ]]; then
    # install sudo for termux
    if ! [[ -x "$(command -v sudo)" ]]; then
        pkg install ncurses-utils
        git clone https://gitlab.com/st42/termux-sudo.git
        cat termux-sudo/sudo > /data/data/com.termux/files/usr/bin/sudo
        chmod 700 /data/data/com.termux/files/usr/bin/sudo
        rm -rf termux-sudo
    fi
else  # create folder for non-termux
    [[ ! -d /usr/local ]] && sudo mkdir -p /usr/local
    [[ ! -L /usr/local/bin ]] && [[ ! -d /usr/local/bin ]] && echo "Condition true" && sudo ln -s /usr/bin /usr/local/bin
    [[ ! -L /usr/local/include ]] && [[ ! -d /usr/local/include ]] && echo "Condition true" && sudo ln -s /usr/include /usr/local/include
fi
if [[ -x "hstr" ]]; then
    if [[ $- =~ .*i.* ]]; then bind '"\C-r": "\C-a hstr -- \C-j"'; fi
    if [[ $- =~ .*i.* ]]; then bind '"\C-xk": "\C-a hstr -k \C-j"'; fi
fi
if test -n "$KITTY_INSTALLATION_DIR" -a -e "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"; then source "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash" 2>/dev/null; fi


debug_handler() { LAST_COMMAND=$BASH_COMMAND; }
error_handler() { local LAST_HISTORY_ENTRY=$(history | tail -1l); [[ "$LAST_COMMAND" == "$(cut -d ' ' -f 2- <<< $LAST_HISTORY_ENTRY)" ]] && FAILED_COMMANDS="$(cut -d ' ' -f 1 <<< $LAST_HISTORY_ENTRY) $FAILED_COMMANDS"; }
exit_handler() { for i in $(echo $FAILED_COMMANDS | tr ' ' '\n' | uniq); do history -d $i; done; FAILED_COMMANDS=; }
trap debug_handler DEBUG
trap error_handler ERR
trap exit_handler EXIT

export ME=$(id -u -n)
export HISTTIMEFORMAT="%F %T "
export HISTCONTROL=ignoreboth:erasedups #only ignores consecutive duplicate commands
export HISTFILESIZE=500000
export HISTSIZE=${HISTFILESIZE}
export HSTR_CONFIG=hicolor,keywords,favorites,noconfirm,verbose-kill
export PROMPT_COMMAND="history -n; history -w; history -c; history -r; $PROMPT_COMMAND"
export HISTIGNORE="&[ ]*:l[sla.]:[bf]g:g[agsplu]:gr[sh]*:clear:cls:c:d:exit:bye:mount*:umount*:history*:h:hh:ps*:rv*:pwd:cd*:-:~:..*:d:j *:jp:src:gaa:glp:gub:grbm:gpush:gps:save:undo:redo:fresh:gbd*:venv:pipi:python:php:go:java:node:dc[du]:ed:code"
source $HOME/.bashrc_local 2>/dev/null
source $HOME/.rc_local 2>/dev/null
export BASH_IT=${BASH_IT:-$HOME/.bash_it}
export BASH_IT_THEME=${BASH_IT_THEME:-minimal}
export BASH_IT_AUTOMATIC_RELOAD_AFTER_CONFIG_CHANGE=1 BASH_IT_RELOAD_LEGACY=0 BASH_IT_COMMAND_DURATION=true
#export COMMAND_DURATION_MIN_SECONDS=1
export THEME_CHECK_SUDO=true
export IRC_CLIENT=irssi # Change this to your console based IRC client of choice.
export SCM_CHECK=true # Version control status checking
export SCM_GIT_SHOW_MINIMAL_INFO=true
export SHORT_HOSTNAME=$(hostname -s) # Set Xterm/screen/Tmux title with only a short hostname
export SHORT_TERM_LINE=true # Set Xterm/screen/Tmux title with shortened command and directory
#export SHORT_USER=${USER:0:8} # Trim max len of username
#export SHORT_TERM_LINE=true
export BYOBU_PREFIX=/usr/local
export TERM=xterm-256color
export VISUAL=${VISUAL:-nvim}
export EDITOR=$VISUAL
export GIT_HOSTING=${GIT_HOSTING:-git@github.com}
export GIT_EDITOR=$VISUAL
export TODO=t
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export LANG=${LANG:-en_US.UTF-8} LANGUAGE=$LANG LC_ALL=$LANG
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'
export GPG_TTY=$(tty)
export TMUX_TMPDIR=${TMUX_TMPDIR:-$HOME/.tmux/tmp}
export NVM_DIR=${NVM_DIR:-$HOME/.nvm}
export VOLTA_HOME=${NVM_DIR:-$HOME/.volta$}
export DOCKER_BUILDKIT=0 DOCKER_DEFAULT_PLATFORM=linux/amd64 COMPOSE_DOCKER_CLI_BUILD=0
export GOPATH=${GOPATH:-$HOME/.go}
export GOBIN=${GOBIN:-$GOPATH/bin}
export GO111MODULE=${GO111MODULE:-auto}
export GOPROXY=${GOPROXY:-direct}
[[ -d /usr/local/go ]] && export GOROOT=/usr/local/go
export XDG_CONFIG_HOME=$HOME/.config
export BIN=/bin:/snap/bin:$HOME/bin:$HOME/.local/bin:$GOROOT/bin:$GOBIN:$JAVA_HOME/bin:$VOLTA_HOME/bin:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin
export PATH=$BIN:$PATH
[[ ! -f $BASH_IT/install.sh ]] && git clone --depth=1 https://github.com/Bash-it/bash-it $BASH_IT && $BASH_IT/install.sh -s -n
source $BASH_IT/bash_it.sh 2>/dev/null
[[ ! -d $HOME/.tmux ]] && git clone --depth=1 https://github.com/gpakosz/.tmux $HOME/.tmux && ln -s -f $HOME/.tmux/.tmux.conf $HOME && mkdir -p $HOME/.tmux/tmp
[[ ! -d $HOME/.tmux/plugins/tpm ]] && git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
source $HOME/.aliases
[[ -s $HOME/.sdkman/bin/sdkman-init.sh ]] && export SDKMAN_DIR=$HOME/.sdkman && source $HOME/.sdkman/bin/sdkman-init.sh
safe_source $NVM_DIR/nvm.sh
safe_source $NVM_DIR/bash_completion
safe_source $HOME/.gvm/scripts/gvm
safe_source $HOME/.bashhub/bashhub.sh
safe_source $HOME/.cargo/env
safe_source $HOME/.fzf.bash
safe_source $(pwd)/extra/completions/alacritty.bash
safe_source $KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash
[[ $TILIX_ID ]] && safe_source /etc/profile.d/vte.sh # Ubuntu Budgie
is_runnable direnv && eval "$(direnv hook bash)"
is_runnable thefuck && eval "$(thefuck --alias)"
is_runnable lesspipe && eval "$(SHELL=/bin/sh lesspipe)"
is_runnable jump && eval "$(jump shell bash --bind=j)" && alias jp='jump pin .'
is_runnable awless && source <(awless completion bash)
is_runnable kitty && source <(kitty + complete setup bash)
is_runnable fox && eval "$(vfox activate bash)"
is_runnable poetry && mkdir -p ${XDG_DATA_HOME:-~/.local/share}/bash-completion/completions && poetry completions bash > ${XDG_DATA_HOME:-~/.local/share}/bash-completion/completions/poetry

if [[ "$(uname)" == "Darwin" ]]; then
    [[ ! -f $HOME/.bash_profile ]] && echo source $HOME/.bashrc > $HOME/.bash_profile
    # TODO: Prompt to upgrade latest bash https://www.unindented.org/blog/change-shell-to-latest-bash-on-macos/
    export BASH_SILENCE_DEPRECATION_WARNING=1
    export HOMEBREW_NO_INSTALL_CLEANUP=1
    export HOMEBREW_NO_ANALYTICS=1
    export PATH=$PATH:/opt/homebrew/bin
else
    shopt -s histappend
    shopt -s cdspell
    shopt -s checkwinsize
    shopt -s globstar
    [[ ! -f $HOME/.hushlogin ]] && welcome
fi

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/fqin/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

