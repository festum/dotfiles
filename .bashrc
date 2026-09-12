#!/usr/bin/env bash
# Source https://github.com/festum/dotfiles

[[ $- == *i* ]] || return

bind "set completion-map-case on"
bind "set show-all-if-ambiguous on"
bind "set mark-symlinked-directories on"
bind "set enable-bracketed-paste on"
bind Space:magic-space
shopt -s nocaseglob cmdhist histappend checkwinsize
shopt -u lithist
shopt -s autocd dirspell cdspell globstar cdable_vars extglob 2>/dev/null
printf '\x1b[3 q'
mkdir -p $HOME/.autocomplete $HOME/.local $HOME/.config
source $HOME/.bash_keys 2>/dev/null

[[ -z "${debian_chroot:-}" ]] && [[ -r /etc/debian_chroot ]] && debian_chroot=$(cat /etc/debian_chroot)
case "$TERM" in xterm-color|*-256color|xterm-kitty) color_prompt=yes;; esac
[ "$TERM" = "xterm-kitty" ] && alias ssh='kitty +kitten ssh'
if [[ -n "$force_color_prompt" ]]; then if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then color_prompt=yes; else color_prompt=; fi; fi
if [ "$color_prompt" = yes ]; then PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '; else PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '; fi
unset PROMPT_COMMAND MAILCHECK color_prompt force_color_prompt

case "$TERM" in
    xterm*|rxvt*) PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1" ;;
    *) ;;
esac

debug_handler() { LAST_COMMAND=$BASH_COMMAND; }
error_handler() { local LAST_HISTORY_ENTRY=$(history | tail -n 1); [[ "$LAST_COMMAND" == "$(cut -d ' ' -f 2- <<< $LAST_HISTORY_ENTRY)" ]] && FAILED_COMMANDS="$(cut -d ' ' -f 1 <<< $LAST_HISTORY_ENTRY) $FAILED_COMMANDS"; }
exit_handler() { for i in $(echo $FAILED_COMMANDS | tr ' ' '\n' | uniq); do history -d $i; done; FAILED_COMMANDS=; }
trap debug_handler DEBUG
trap error_handler ERR
trap exit_handler EXIT

export ME=$(id -u -n) USER_ID=$(id -u) GROUP_ID=$(id -g) DOCKER_GID=$(grep -E '^docker:' /etc/group 2>/dev/null | cut -d: -f3 || echo "")
export HISTTIMEFORMAT="%F %T " HISTCONTROL=ignoreboth:erasedups HISTFILESIZE=500000 HISTSIZE=${HISTFILESIZE} HSTR_CONFIG=hicolor,keywords,favorites,noconfirm,verbose-kill
export HISTIGNORE="&[ ]*:l[sla.]:[bf]g:g[agsplu]:gr[sh]*:clear:cls:c:d:exit:bye:mount*:umount*:history*:h:hh:ps*:rv*:pwd:cd*:-:~:..*:d:j *:jp:src:gaa:glp:gub:grbm:gpush:gps:save:undo:redo:fresh:gbd*:venv:pipi:python:php:go:java:node:dc[du]:ed:code"
export BASH_IT=${BASH_IT:-$HOME/.bash_it} BASH_IT_THEME=${BASH_IT_THEME:-minimal} BASH_IT_AUTOMATIC_RELOAD_AFTER_CONFIG_CHANGE=1 BASH_IT_RELOAD_LEGACY=0 BASH_IT_COMMAND_DURATION=true THEME_CHECK_SUDO=true
export IRC_CLIENT=irssi SCM_CHECK=true SCM_GIT_SHOW_MINIMAL_INFO=true
export SHORT_HOSTNAME=$(hostname -s) SHORT_TERM_LINE=true SHORT_USER=${USER:0:8}
export BYOBU_PREFIX=/usr/local
export VISUAL=${VISUAL:-hx} EDITOR=$VISUAL GIT_EDITOR=$VISUAL TODO=t
export GIT_HOSTING=${GIT_HOSTING:-git@github.com} GPG_TTY=$(tty)
export GCC_COLORS="error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01;32:locus=01:quote=01"
export CC=clang AR=llvm-ar CXX=clang++ CFLAGS="-Wno-implicit-function-declaration" CXXFLAGS="-Wno-implicit-function-declaration"
export LANG=${LANG:-en_US.UTF-8} LANGUAGE=$LANG LC_ALL=$LANG
export LESS_TERMCAP_mb=$'\E[01;31m' LESS_TERMCAP_md=$'\E[01;31m' LESS_TERMCAP_me=$'\E[0m' LESS_TERMCAP_se=$'\E[0m' LESS_TERMCAP_so=$'\E[01;44;33m' LESS_TERMCAP_ue=$'\E[0m' LESS_TERMCAP_us=$'\E[01;32m'
export TMUX_TMPDIR=${TMUX_TMPDIR:-$HOME/.tmux/tmp}
export NVM_DIR=${NVM_DIR:-$HOME/.nvm}
export OLLAMA_HOST=${OLLAMA_HOST:-0.0.0.0} OLLAMA_ORIGINS=${OLLAMA_ORIGINS:-"*"}
export DOCKER_BUILDKIT=0 COMPOSE_DOCKER_CLI_BUILD=0 DOCKER_DEFAULT_PLATFORM=${DOCKER_DEFAULT_PLATFORM:-linux/$(case $(uname -m) in x86_64) echo amd64 ;; aarch64|arm64) echo arm64 ;; armv7l) echo arm/v7 ;; *) uname -m ;; esac)}
export GO111MODULE=${GO111MODULE:-auto} GOPROXY=${GOPROXY:-direct} GOPATH=${GOPATH:-$HOME/.go} GOBIN=${GOBIN:-$GOPATH/bin}
[[ -d /usr/local/go ]] && export GOROOT=${GOROOT:-/usr/local/go}
export XDG_CONFIG_HOME=$HOME/.config
export PATH=$(find "$HOME" -mindepth 2 -maxdepth 3 -type d -name bin -not -path '*/.cache/*' -print0 2>/dev/null | tr '\0' ':' | sed 's/:\+$//'):$BIN:$PATH

source "$HOME/.bashrc_local" 2>/dev/null
source "$HOME/.rc_local" 2>/dev/null

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
    if ! [[ -x "$(command -v sudo)" ]]; then
        pkg install ncurses-utils
        git clone https://gitlab.com/st42/termux-sudo.git
        cat termux-sudo/sudo > /data/data/com.termux/files/usr/bin/sudo
        chmod 700 /data/data/com.termux/files/usr/bin/sudo
        rm -rf termux-sudo
    fi
else
    [[ ! -d /usr/local ]] && sudo mkdir -p /usr/local
    [[ ! -L /usr/local/bin ]] && [[ ! -d /usr/local/bin ]] && echo "Condition true" && sudo ln -s /usr/bin /usr/local/bin
    [[ ! -L /usr/local/include ]] && [[ ! -d /usr/local/include ]] && echo "Condition true" && sudo ln -s /usr/include /usr/local/include
fi

if [[ -x "hstr" ]]; then
    if [[ $- =~ .*i.* ]]; then bind '"\C-r": "\C-a hstr -- \C-j"'; fi
    if [[ $- =~ .*i.* ]]; then bind '"\C-xk": "\C-a hstr -k \C-j"'; fi
fi

[[ ! -f $BASH_IT/install.sh ]] && git clone --depth=1 https://github.com/Bash-it/bash-it $BASH_IT && $BASH_IT/install.sh -s -n
source $BASH_IT/bash_it.sh 2>/dev/null
[[ ! -d $HOME/.tmux ]] && git clone --depth=1 https://github.com/gpakosz/.tmux $HOME/.tmux && ln -s -f $HOME/.tmux/.tmux.conf $HOME && mkdir -p $HOME/.tmux/tmp
[[ ! -d $HOME/.tmux/plugins/tpm ]] && git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
source $HOME/.aliases
[[ -s $HOME/.sdkman/bin/sdkman-init.sh ]] && export SDKMAN_DIR=$HOME/.sdkman && source $HOME/.sdkman/bin/sdkman-init.sh
[[ -s $HOME/.bun/_bun ]] && source $HOME/.bun/_bun

safe_source $NVM_DIR/nvm.sh
safe_source $NVM_DIR/bash_completion
safe_source $HOME/.gvm/scripts/gvm
safe_source $HOME/.bashhub/bashhub.sh
safe_source $HOME/.cargo/env
safe_source $HOME/.fzf.bash
safe_source $(pwd)/extra/completions/alacritty.bash
safe_source $KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash
[[ $TILIX_ID ]] && safe_source /etc/profile.d/vte.sh
is_runnable direnv && eval "$(direnv hook bash)"
is_runnable thefuck && eval "$(thefuck --alias)"
is_runnable lesspipe && eval "$(SHELL=/bin/sh lesspipe)"
is_runnable jump && eval "$(jump shell bash --bind=j)" && alias jp='jump pin .'
is_runnable awless && source <(awless completion bash)
is_runnable kitty && source <(kitty + complete setup bash)
is_runnable fox && eval "$(vfox activate bash)"
is_runnable poetry && mkdir -p ${XDG_DATA_HOME:-~/.local/share}/bash-completion/completions && poetry completions bash > ${XDG_DATA_HOME:-~/.local/share}/bash-completion/completions/poetry
is_runnable pyenv && { eval "$(pyenv init --path)"; eval "$(pyenv init -)"; if [ -d "$(pyenv root)/plugins/pyenv-virtualenv" ]; then eval "$(pyenv virtualenv-init -)"; else git clone https://github.com/pyenv/pyenv-virtualenv.git "$(pyenv root)/plugins/pyenv-virtualenv" && eval "$(pyenv virtualenv-init -)"; fi; }

export PROMPT_COMMAND="history -a; history -n; printf '\e[?1000l\e[?1002l\e[?1003l\e[?1006l'; $PROMPT_COMMAND"

if [[ "$(uname)" == "Darwin" ]]; then
    [[ ! -f $HOME/.bash_profile ]] && echo source $HOME/.bashrc > $HOME/.bash_profile
    export BASH_SILENCE_DEPRECATION_WARNING=1
    export HOMEBREW_NO_INSTALL_CLEANUP=1
    export HOMEBREW_NO_ANALYTICS=1
    export PATH=$PATH:/opt/homebrew/bin
else
    [[ ! -f $HOME/.hushlogin ]] && welcome
fi
