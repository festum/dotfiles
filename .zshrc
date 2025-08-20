[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ] && source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"

zstyle ':omz:update' mode auto       # auto/reminder/disabled
zstyle ':omz:update' frequency 3     # day
CASE_SENSITIVE="false"
HYPHEN_INSENSITIVE="true"
DISABLE_UNTRACKED_FILES_DIRTY="true" # Performance: Disable marking untracked files under VCS as dirty
# DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_AUTO_TITLE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="false"
HIST_STAMPS="yyyy-mm-dd"
ZSH_WEB_SEARCH_ENGINES=(
  red "https://www.reddit.com/search/?q="
  soft "https://sanet.st/search/?q="
)
plugins=(
  aws
  fzf
  ipfs
  kubectl
  rust
  terraform
  vscode
  z
  zsh-autosuggestions
  zsh-syntax-highlighting
  copybuffer              # ctrl+o copy command line text to clipboard
  copyfile                # copies contents of a file to clipboard
  copypath                # copies the absolute path of the current directory
  sudo                    # pressing esc twice, will add sudo to command
  web-search              # google/ddg/sp/github/youtube/image/ducky/map
  poetry
)
ZSH_THEME=powerlevel10k/powerlevel10k
# ZSH_THEME_RANDOM_CANDIDATES=( "fwalch" "robbyrussell" "miloshadzic" "arrow" "simple" "wuffers" "zhann")
ZSH=$HOME/.oh-my-zsh
[ ! -f $ZSH/oh-my-zsh.sh ] && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && sh install.sh && mv -f $HOME/.zshrc.pre-oh-my-zsh $HOME/.zshrc && source $HOME/.aliases && git_install https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-$ZSH/custom}/plugins/zsh-syntax-highlighting && git_install https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$ZSH/custom}/plugins/zsh-autosuggestions && git_install https://github.com/romkatv/powerlevel10k ${ZSH_CUSTOM:-$ZSH/custom}/themes/powerlevel10k
export LANG=en_US.UTF-8
export EDITOR=$([ -n $SSH_CONNECTION ] && echo 'nvim' || echo 'hx')
export SCM_CHECK=true SCM_GIT_SHOW_MINIMAL_INFO=true
export SHORT_HOSTNAME=$(hostname -s) # Set Xterm/screen/Tmux title with only a short hostname
export SHORT_TERM_LINE=true # Set Xterm/screen/Tmux title with shortened command and directory
export GPG_TTY=$TTY
export TMUX_TMPDIR=${TMUX_TMPDIR:-$HOME/.tmux/tmp}
export NVM_DIR=${NVM_DIR:-$HOME/.nvm}
export VOLTA_HOME=${NVM_DIR:-$HOME/.volta$}
export DOCKER_BUILDKIT=0 DOCKER_DEFAULT_PLATFORM=linux/amd64 COMPOSE_DOCKER_CLI_BUILD=0
export GOPATH=${GOPATH:-$HOME/.go}
export GOBIN=${GOBIN:-$GOPATH/bin}
export GO111MODULE=${GO111MODULE:-auto}
export GOPROXY=${GOPROXY:-direct}
[ -d /usr/local/go ] && export GOROOT=/usr/local/go
[ -f $HOME/.cargo/env ] && source $HOME/.cargo/env && export CARGO_HOME=$HOME/.cargo/env
export BIN=$GOROOT/bin:$GOBIN:$JAVA_HOME/bin:$VOLTA_HOME/bin:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$HOME/.rd/bin:$HOME/.local/bin:$HOME/bin:/opt/homebrew/bin:/snap/bin:/usr/local/bin:/usr/bin:/bin:$PATH
export PATH=$BIN:$PATH
source $ZSH/oh-my-zsh.sh
source $HOME/.cargo/env 2>/dev/null
[ -f ~/.p10k.zsh ] && source ~/.p10k.zsh # run `p10k configure`
source $HOME/.fzf.zsh 2>/dev/null
source $HOME/.aliases
safe_source $HOME/.rc_local
is_runnable fox && eval "$(vfox activate zsh)"
is_runnable poetry && mkdir -p $ZSH_CUSTOM/plugins/poetry && poetry completions zsh > $ZSH_CUSTOM/plugins/poetry/_poetry
bindkey '^B' backward-word
bindkey '^F' forward-word
bindkey "\e[1;3D" backward-word # ⌥←
bindkey "\e[1;3C" forward-word # ⌥→
bindkey '^[a' beginning-of-line
bindkey '^[e' end-of-line
unsetopt correct_all
setopt ksh_glob
# export ARCHFLAGS="-arch x86_64"
is_runnable pyenv && { eval "$(pyenv init --path)"; eval "$(pyenv init -)"; if [ -d "$(pyenv root)/plugins/pyenv-virtualenv" ]; then eval "$(pyenv virtualenv-init -)"; else git clone https://github.com/pyenv/pyenv-virtualenv.git "$(pyenv root)/plugins/pyenv-virtualenv" && eval "$(pyenv virtualenv-init -)"; fi; }
