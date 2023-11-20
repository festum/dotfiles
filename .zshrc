# CASE_SENSITIVE="true"
HYPHEN_INSENSITIVE="true"
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time
# zstyle ':omz:update' frequency 13
DISABLE_UNTRACKED_FILES_DIRTY="true" # Performance: Disable marking untracked files under VCS as dirty
# DISABLE_MAGIC_FUNCTIONS="true"
# DISABLE_AUTO_TITLE="true"
ENABLE_CORRECTION="true"
# COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="yyyy-mm-dd"
plugins=(z fd fzf adb aws kubectl web-search)
ZSH_THEME="fwalch"  # See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "miloshadzic" "arrow" "simple" "fwalch" "wuffers" "zhann")
# ZSH_CUSTOM=/path/to/new-custom-folder # ZSH custom folder rather than $ZSH/custom
export ZSH="$HOME/.oh-my-zsh"
[ ! -f $ZSH/oh-my-zsh.sh ] && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && sh install.sh && mv -f ~/.zshrc.pre-oh-my-zsh ~/.zshrc
source $ZSH/oh-my-zsh.sh
source $HOME/.aliases
safe_source $HOME/.rc_local
safe_source $HOME/.fzf.zsh

# export MANPATH="/usr/local/man:$MANPATH"
export LANG=en_US.UTF-8
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='hx'
fi
export SCM_CHECK=true # Version control status checking
export SCM_GIT_SHOW_MINIMAL_INFO=true
export SHORT_HOSTNAME=$(hostname -s) # Set Xterm/screen/Tmux title with only a short hostname
export SHORT_TERM_LINE=true # Set Xterm/screen/Tmux title with shortened command and directory
export GPG_TTY=$(tty)
export TMUX_TMPDIR=${TMUX_TMPDIR:-$HOME/.tmux/tmp}
export NVM_DIR=${NVM_DIR:-$HOME/.nvm}
export VOLTA_HOME=${NVM_DIR:-$HOME/.volta$}
export COMPOSE_DOCKER_CLI_BUILD=0
export DOCKER_BUILDKIT=0
export DOCKER_DEFAULT_PLATFORM=linux/amd64
export GO111MODULE=${GO111MODULE:-auto}
export GOPROXY=${GOPROXY:-direct}
export GOPATH=${GOPATH:-$HOME/.go}
export GOBIN=${GOBIN:-$GOPATH/bin}
[ -d /usr/local/go ] && export GOROOT=/usr/local/go
export BIN=$HOME/.local/bin:/opt/homebrew/bin:$GOROOT/bin:$GOBIN:$JAVA_HOME/bin:$VOLTA_HOME/bin:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin
export PATH=$HOME/bin:/usr/local/bin:$PATH:$BIN
# export ARCHFLAGS="-arch x86_64"
