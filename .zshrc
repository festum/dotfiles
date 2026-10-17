zstyle ':omz:update' mode auto       # auto/reminder/disabled
zstyle ':omz:update' frequency 3     # day
zstyle ':autocomplete:*' insert-unambiguous yes
zstyle ':autocomplete:*' delay 0.1
zstyle ':autocomplete:*' add-space ''
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
  # zsh-autocomplete
  zsh-autosuggestions
  zsh-syntax-highlighting
  copybuffer              # ctrl+o copy command line text to clipboard
  copyfile                # copies contents of a file to clipboard
  copypath                # copies the absolute path of the current directory
  sudo                    # pressing esc twice, will add sudo to command
  web-search              # google/ddg/sp/github/youtube/image/ducky/map
  poetry
)
ZSH_THEME="sunaku" ZSH=$HOME/.oh-my-zsh
[ ! -f $ZSH/oh-my-zsh.sh ] && { d=$(mktemp -d) && git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git $d/omz && mkdir -p $ZSH && cp -R $d/omz/. $ZSH/ && rm -rf $d; for r in plugins:zsh-users/zsh-syntax-highlighting plugins:zsh-users/zsh-autosuggestions plugins:marlonrichert/zsh-autocomplete; do p=${r#*:} t=$ZSH/custom/${r%%:*}/${p##*/}; [ -d $t/.git ] || git clone --depth 1 https://github.com/$p $t; done; }
export ME=$(id -u -n) USER_ID=$(id -u) GROUP_ID=$(id -g) DOCKER_GID=$(grep -E '^docker:' /etc/group 2>/dev/null | cut -d: -f3 || echo "")
export LANG=${LANG:-en_US.UTF-8} LANGUAGE=$LANG LC_ALL=$LANG
export EDITOR=$([ -n "$SSH_CONNECTION" ] && echo 'nvim' || echo 'hx')
export SCM_CHECK=true SCM_GIT_SHOW_MINIMAL_INFO=true
export SHORT_HOSTNAME=$(hostname -s) # Set Xterm/screen/Tmux title with only a short hostname
export SHORT_TERM_LINE=true # Set Xterm/screen/Tmux title with shortened command and directory
export GPG_TTY=$TTY
export TMUX_TMPDIR=${TMUX_TMPDIR:-$HOME/.tmux/tmp}
export NVM_DIR=${NVM_DIR:-$HOME/.nvm}
export OLLAMA_HOST=${OLLAMA_HOST:-0.0.0.0}
export OLLAMA_ORIGINS=${OLLAMA_ORIGINS:-"*"}
export DOCKER_BUILDKIT=0 DOCKER_DEFAULT_PLATFORM=${DOCKER_DEFAULT_PLATFORM:-linux/amd64} COMPOSE_DOCKER_CLI_BUILD=0
export GOPATH=${GOPATH:-$HOME/.go}
export GO111MODULE=${GO111MODULE:-auto} GOPROXY=${GOPROXY:-direct} GOBIN=${GOBIN:-$GOPATH/bin}
[ -d /usr/local/go ] && export GOROOT=${GOROOT:-/usr/local/go}
[ -f $HOME/.cargo/env ] && source $HOME/.cargo/env && export CARGO_HOME=$HOME/.cargo/env
[ -s $HOME/.bun/_bun ] && source $HOME/.bun/_bun
export BIN=$GOROOT/bin:$GOBIN:$HOME/.config/yarn/global/node_modules/.bin:/opt/homebrew/bin:/opt/homebrew/opt/llvm/bin:$HOME/bin:/snap/bin:/usr/local/bin:/usr/bin:/bin
export PATH=$(find "$HOME" -mindepth 2 -maxdepth 3 -type d -name bin -not -path '*/.cache/*' -print0 2>/dev/null | tr '\0' ':' | sed 's/:\+$//'):$BIN:$PATH
[ -f $ZSH/oh-my-zsh.sh ] && source $ZSH/oh-my-zsh.sh
command -v zmodload >/dev/null && zmodload -i zsh/complist
source $HOME/.cargo/env 2>/dev/null
source $HOME/.fzf.zsh 2>/dev/null
source $HOME/.aliases
is_runnable clang && is_runnable clang++ && is_runnable llvm-ar && export CC=clang AR=llvm-ar CXX=clang++ CFLAGS="-Wno-implicit-function-declaration" CXXFLAGS="-Wno-implicit-function-declaration"
safe_source $HOME/.rc_local
is_runnable fox && eval "$(vfox activate zsh)"
is_runnable poetry && mkdir -p ${ZSH_CUSTOM:-$ZSH/custom}/plugins/poetry && poetry completions zsh > ${ZSH_CUSTOM:-$ZSH/custom}/plugins/poetry/_poetry

bindkey '^@' menu-complete # Ctrl+Space: Accept top word suggestion (like Tab but for words only)
bindkey "\e[1;3C" forward-word # Alt+Right Arrow: Forward and accept next word after space
bindkey '^[[1;5C' .forward-char # Optional: In menu, make Right Arrow cycle completions word-by-word
bindkey -l | grep -qx menuselect && bindkey -M menuselect '^[[C' menu-complete
bindkey '^F' forward-word
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
