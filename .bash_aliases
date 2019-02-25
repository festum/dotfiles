#!/bin/bash

[ -f ~/.aliases.local ] && . ~/.aliases.local
[ -f ~/configs/custom_aliases ] && . ~/configs/custom_aliases

# -------------------------------------------------------------------
# Config
# -------------------------------------------------------------------

GIT_USERNAME="Festum Qin"
GIT_USEREMAIL="festum@g.pl"
SSH_PK="/Users/festum/Dropbox/Festum/Archives/AppConf/ssh/f_app"

# -------------------------------------------------------------------
# General
# -------------------------------------------------------------------

alias c="clear && printf '\e[3J'"
alias cls="echo -ne '\033c'"
alias rd='rm -rf'
alias md='mkdir'
alias h='history | tail'
alias g='grep'
alias hg='history | grep'
alias mvi='mv -i'
alias rmi='rm -i'
alias rm0='find . -size 0 -print0 |xargs -0 rm --'
alias {ack,ak}='ack-grep'
alias rv='source ~/.bash_aliases'
alias rva='source ~/.bash_aliases && source ~/.bashrc'
alias myip="ifconfig | ack 'inet (\d+.*) netmask .* broadcast'"
alias gpc='grep --color=always -R'
alias grep='grep --color=auto'

# -------------------------------------------------------------------
# Setup
# -------------------------------------------------------------------
function ssh_with_rc(){
  if [ "$(uname)" == "Darwin" ]; then
    break_arg='-b 0'
  else
    break_arg='-w0'
  fi
  if [ -f ${HOME}/.fe0/.bash_aliases ]; then
    RC_DATA=`cat ${HOME}/.fe0/.bashrc | base64 ${break_arg}`
    AL_DATA=`cat ${HOME}/.fe0/.bash_aliases | base64 ${break_arg}`
  else
    RC_DATA=`cat ${HOME}/.bashrc | base64 ${break_arg}`
    AL_DATA=`cat ${HOME}/.bash_aliases | base64 ${break_arg}`
  fi
  ssh -t $@ "mkdir ~/.fe0;echo \"${RC_DATA}\" | base64 --decode > ~/.fe0/.bashrc;echo \"${AL_DATA}\" | base64 --decode > ~/.fe0/.bash_aliases;bash --rcfile ~/.fe0/.bashrc"
}
function exit_and_rm(){
  if [ -f ${HOME}/.fe0/.bash_aliases ]; then
    rm -rf ${HOME}/.fe0/
  fi
  exit
}
alias ssh='ssh_with_rc'
alias sshf='ssh -i "${SSH_PK}"'
alias sshr='ssh -R 52698:localhost:52698'
alias exit=exit_and_rm
alias init_vim='git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime; sh ~/.vim_runtime/install_awesome_vimrc.sh'
function bashrc(){
  [ -f ~/.bash_keys ] && . ~/.bash_keys
  [ -f ~/.bash_aliases ] && . ~/.bash_aliases
  [ -f ~/.bashrc ] && . ~/.bashrc
  [ -f ~/.bach_profile ] && . ~/.bach_profile
  [ -f ~/.profile ] && . ~/.profile
  [ -f ~/.fe0/.bash_aliases ] && . ~/.fe0/.bash_aliases
  [ -f ~/.fe0/.bashrc ] && . ~/.fe0/.bashrc
}
function ttmux(){
  # echo "set-option -g default-shell \"/bin/bash\"" > ~/.tmux.conf
  if ([ -z $TMUX ]); then
    mv ~/.bashrc ~/.tmuxed
    cp ~/.bash_it/.bashrc ~/.bashrc
    source  ~/.bashrc
    tmux new-session -A -s main
    cp -f ~/.tmuxed ~/.bashrc
    rm -rf ~/.tmuxed
  fi
}
function daemon(){
  $@ > /dev/null 2>&1 &
}
function daemono(){
  $@ >> ./out 2>&1 &
}
# -------------------------------------------------------------------
# FS
# -------------------------------------------------------------------
alias l='ls -al'    # -CF
alias ls='ls -GFh'  # Colorize output, add file type indicator, and put sizes in human readable format
alias ll='ls -GFhl' # Same as above, but in long listing format -alF'
alias lh='ls -d .*' # show hidden files/directories only
alias la='ls -A'
alias diff='git diff --no-index --'
alias ~='cd ~'
alias d='cd ~/Downloads/'
alias ln="ln -v"
alias mkdir="mkdir -p"
alias fe0='cd /fe0/repo'
alias fm='python /fe0/bin/ranger/ranger.py'
alias r='ranger'
alias count='f(){ cat $@ |wc -l; unset -f f; }; f'
alias getg='cat /etc/group | cut -d: -f1'
alias joing='f(){ usermod -a -G $1 $USER; unset -f f; }; f'
alias uig='f(){ grep -i --color $@ /etc/group; unset -f f; }; f'
alias rep='find . -type f -print0 | xargs -0 sed -i'

# -------------------------------------------------------------------
# Tmux
# -------------------------------------------------------------------
alias tma='tmux attach -t'
alias tmn='tmux new -s'
alias tml='tmux ls'
alias tmd='tmux detach'
alias tmk='tmux kill-session -t'
alias tmkk='tmux kill-server'
alias tms='tmux switch -t'
alias tmwn='tmux new-window'
alias tmwl='tmux list-window'
alias tmws='tmux select-window -t' # :0-9
alias tmwr='tmux rename-window'
alias tmpw='tmux split-window'
alias tmps='tmux swap-window' # -[UDLR]
alias tmpp='tmux select-pane' # -[UDLR]
alias tmno='tmuxinator open'
alias tmns='tmuxinator start'

# -------------------------------------------------------------------
# Go
# -------------------------------------------------------------------
# alias go='GOPATH=$(echo $(pwd)) go'
alias gog='go get -d ./...'
alias addgp='echo export GOPATH=$(pwd) > .envrc'

# -------------------------------------------------------------------
# Node
# -------------------------------------------------------------------
alias node='node --harmony'

# -------------------------------------------------------------------
# Python
# -------------------------------------------------------------------
pip_install_save() {
  package_name=$1
  requirements_file=$2
  if [[ -z $requirements_file ]]
  then
      requirements_file='./requirements.txt'
  fi
  pip install $package_name && pip freeze | grep -i $package_name >> $requirements_file
}
alias venv='rm -rf ./venv && virtualenv --no-site-packages venv && source venv/bin/activate'
alias venv3='rm -rf ./venv && virtualenv -p ~/.pyenv/versions/3.7.0/bin/python3.7 --no-site-packages venv && source venv/bin/activate'
alias venvr='source venv/bin/activate'
alias pipi='pip install -r requirements.txt'
alias pe='pipenv'
alias pei='pipenv install'
alias pei='pipenv shell'
alias pep='pipenv run python'
alias pipu="sudo pip2 freeze — local | grep -v ‘^\-e’ | cut -d = -f 1 | xargs -n1 sudo -H pip2 install -U"
alias pips=pip_install_save

# -------------------------------------------------------------------
# Ruby
# -------------------------------------------------------------------
alias rake="noglob rake" # necessary to make rake work inside of zsh
alias be='bundle exec'
alias rials='rails'
alias raisl='rails'
alias rs='rails s'
alias rc='rails c'
alias rdb='rake db:migrate db:test:prepare'

# -------------------------------------------------------------------
# Heroku
# -------------------------------------------------------------------
alias hrc='heroku run rails c'
alias hrdb='heroku run rake db:migrate'
alias hlogs='heroku logs --tail'

# -------------------------------------------------------------------
# CentOS
# -------------------------------------------------------------------
alias ymu='sudo yum update -y'
alias ymi='sudo yum install -y'
alias ymr='sudo yum remove -y'
alias sc='sudo systemctl'

# -------------------------------------------------------------------
# Ubuntu
# -------------------------------------------------------------------
alias ap='sudo apt'
alias api='sudo apt install -y'
alias apr='f(){ sudo apt -y --purge remove $@;  unset -f f; }; f'
alias dpi='sudo dpkg -i'
alias dpf='dpkg --list | grep $1'
alias init_byb_u='sudo apt-get install byobu; byobu-enable; . ~/.bashrc'

# -------------------------------------------------------------------
# database
# ------------------------------------------------------------------
alias 'pgstart=pg_ctl -D /opt/boxen/data/postgresql/ -l logfile start'
alias 'pgstop=pg_ctl -D /opt/boxen/data/postgresql/ stop'
alias 'pgrestart=pg_ctl -D /opt/boxen/data/postgresql/ restart'
# ex: pgrestore db_name file_name
alias 'pgrestore=pg_restore --verbose --clean --no-acl --no-owner -h localhost -d'
# Start elasticsearch
#alias esstart='elasticsearch -f -D es.config=/opt/boxen/homebrew/opt/elasticsearch/config/elasticsearch.yml'

# -------------------------------------------------------------------
# Git
# -------------------------------------------------------------------
alias ga='git add'
alias gaa='git add .'
alias gb='git branch'
alias gbd='git branch -D'
alias gc='git checkout'
alias gcb='git checkout -b'
alias gcl='git clone'
alias gd='git diff'
alias gfe='git fetch --progress --prune origin'
alias gm='git commit -m '
alias gma='git commit -am'
alias gmr='git commit --amend -m'
alias gmu='git -c user.name="${GIT_USERNAME}" -c user.email="${GIT_USEREMAIL}" commit -m '
alias gmg='git merge'
alias gp='git pull --all'
alias gpf='git pull --rebase --autostash'
alias gpu='git fetch upstream && git rebase upstream/master'
alias gpush=gph
alias gph='git push -f'
alias gpho='git push origin'
alias gl='git log --date=iso --name-status'
alias glp="git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset' --abbrev-commit --no-merges --date=iso"
alias glc='git log --pretty=format:'%s' | cut -d " " -f 1 | sort | uniq -c | sort -nr' # get counts
alias gr='git rm --ignore-unmatch -f -r --cached'
alias grc='git ls-files --deleted -z | xargs -0 git rm' # clean
alias gru="git status -su | cut -d' ' -f2- | tr '\n' '\0' | xargs -0 rm"
alias grb='git rebase'
alias grbc='git rebase --continue'
alias grbi='git rebase --interactive' # merge
alias grf='git reflog'
alias grm='git remote'
alias grma='git remote add'
alias grmr='git remote rm'
alias grmau='git remote add upstream'
alias grmso='git remote set-url --add --push origin'
alias grs1='git reset HEAD~1'
alias gs='git status -sb'
alias gst='git stash'
alias gsb='git stash apply'
alias gsb='git stash branch'
alias gscl='git stash clear'
alias gsd='git stash drop -q'
alias gsl='git stash list'
alias gsp='git stash pop'
alias gss='git stash show -p'
alias gslc="git shortlog | grep -E '^[ ]+\w+' | wc -l"
alias gslu="git shortlog | grep -E '^[^ ]'"
alias gta='git tag -a -m'

# ------------------------------------
# Docker alias and function
# ------------------------------------
alias dm='docker-machine'
alias dmip='docker-machine ip'
alias dme='docker-machine env'
function dmuse() {
  if [ "$(docker-machine status ${1})" == "Stopped" ]; then
    docker-machine start ${1}
  fi
  eval $(docker-machine env ${1})
}
alias dmused='dmuse default'
alias dc='docker-compose'
alias dcd='docker-compose down'
alias dcu='docker-compose up -d'
alias dcb='docker-compose up -d --no-deps --build '
alias dcr='docker-compose down && docker-compose up -d'
alias dcl='docker-compose logs'
alias dce='docker-compose exec'
alias dk='docker'
alias dkx='docker exec -it'
alias dkm='docker commit'
alias dkl='docker logs'
alias dpush='docker push'
alias dkb='docker build .'
alias dkr='docker run -it -d -P'
alias dkp='docker ps -a'
alias dkpl='docker ps -l -q'
alias dkpf='docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Ports}}\t{{.Command}}\t{{.Status}}\t"
'
alias dks='docker stats --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"'
alias dkr='f(){ docker ps -ga --filter name="$@" | xargs --no-run-if-empty docker rm -f;  unset -f f; }; f'
alias dkrm='f(){ docker rm $(docker ps -aq --filter name="$@") }; f'
alias dkra='docker ps -qa | xargs --no-run-if-empty docker rm -f'
alias dkip="docker inspect --format '{{ .NetworkSettings.IPAddress }}'"
alias dki='docker images'
alias dkir='docker rmi'
alias dkirn='docker rmi $(docker images | grep "^<none>" | awk "{ print $3 }"")'
alias dkird='docker rmi $(docker images -f "dangling=true" -q)'
alias dkire='docker images -q -f dangling=true | xargs --no-run-if-empty docker rmi'
alias dsh='f(){ docker exec -it "$@" /bin/bash;  unset -f f; }; f'
alias dkkill='docker rm -f $(docker ps -a -q)'
random_local_port() {
    python -c 'import socket; s = socket.socket(); s.bind(("127.0.0.1", 0)); print s.getsockname()[1]; s.close();'
}
function dmp() {
    PORT="$(random_local_port)"
    ssh -f -o ExitOnForwardFailure=yes \
        -L "127.0.0.1:$PORT:127.0.0.1:2375" "$PRODSERVER" \
        sleep 5
    DOCKER_HOST="127.0.0.1:$PORT" "$@"
}
alias k8='kubectl'
alias k8a='kubectl apply -f'
alias k8c='kubectl config'
alias k8d='kubectl describe'
alias k8g='kubectl get'
alias k8gd='kubectl get deployment,svc,pods,pvc,rc,rs'
alias k8l='kubectl logs'
alias k8r='kubectl delete'
alias k8rp='kubectl delete pods --grace-period=0 --force'
alias k8t='kubectl logs --tail=1 -f'
alias k8x='kubectl exec -it'
alias kc='kompose'
alias kcc='kompose convert -f'
alias dsh='f(){   unset -f f; }; f'
# for each in $(kubectl get pods|grep Terminating|awk '{print $1}');
# do
# kubectl delete pods $each --force --grace-period=0
# done


# ------------------------------------
# Serverless and AWS
# ------------------------------------
alias sld='serverless deploy'
alias sll='serverless deploy list'
alias sli='serverless invoke --function'
alias sli='serverless invoke local --function'
alias as3c='aws s3api create-bucket --bucket my-bucket'
alias alac='aws lambda create-function --memory-size 512 --timeout 300 --function-name'

# -------------------------------------------------------------------
# Vagrant
# -------------------------------------------------------------------
alias vgu='vagrant up --provision'
alias vgh='vagrant halt'
alias vgd='vagrant destroy'
alias vgs='vagrant ssh'

# -------------------------------------------------------------------
# Clients
# -------------------------------------------------------------------
alias bws='bw list items --search'
alias nrc='nrclientcmd -d f0 -u festum'
alias https='http --default-scheme=https --verify=no'
alias de='direnv'
alias dea='direnv allow'
alias det='vim .envrc'
alias lynx='/Applications/Lynxlet.app/Contents/Resources/lynx/bin/lynx'
alias zt='zerotier-cli'

# -------------------------------------------------------------------
# Servers
# -------------------------------------------------------------------
# Serverlist

# A server with a non-standard SSH port, using passwordless RSA key authentication
#alias server1='ssh -p 2200 user@server-domain.com'

# A server that uses a certficate for authentication
#alias server2='ssh -i ~/.ssh/amazon_ec2_certificate.pem user@123.123.123.123'

# Automatically switch to a directory upon login
#alias server3='ssh -t -p 2200 user@123.123.123.123 "cd /var/www/vhosts ; bash"'
alias k81='kubelogin k8s1 --namespace=jobfeed --user=festum'

# -------------------------------------------------------------------
# UTILITIES
# -------------------------------------------------------------------
function swap() {
  local TMPFILE=tmp.$$
  mv "$1" $TMPFILE && mv "$2" "$1" && mv $TMPFILE $2
}

function authme() {
  cat ~/.ssh/id_rsa.pub | ssh $1 'umask 0077; mkdir -p ~/.ssh; cat >> .ssh/authorized_keys && chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys && echo "Key copied"'
}

# ex - archive extractor.
# Usage: ex <file>.
function ex(){
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar e $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}
function ar(){
  BN=`basename ${1}`
  tar -zcvf ${BN}.tar.gz ${1}
}


export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

function transfer() {
  curl --progress-bar --upload-file $1 https://transfer.sh/$(basename $1) | tee /dev/null;
}
function dl() {
  curl -OJ $@
}
function serveo() { #https://serveo.net/
  ssh -R 80:$1 serveo.net
}
function serveop() { #https://serveo.net/
  autossh -M 0 -R 80:$1 serveo.net
}
function ngr() {
  ngrok http $DMHOST:$1
}
# Find a file with a pattern in name:
function ff() {
  find . -type f -iname '*'$@'*' -ls | grep -v "Permission denied";
}
# Find a file with pattern $1 in name and Execute $2 on it:
function fe() {
  find . -type f -iname '*'$@'*' -exec "${2:-file}" {} \;  ;
}
# search from CLI
function google {
  if [ ! -x /usr/local/bin/googler ]; then
    sudo curl -o /usr/local/bin/googler https://raw.githubusercontent.com/jarun/googler/v2.9/googler && sudo chmod +x /usr/local/bin/googler
  fi
  googler
}
# translate fr zh
function translate() {
    wget -U "Mozilla/5.0" -qO - "https://translate.google.com/translate_a/single?client=t&sl=${3:-auto}&tl=${2:-en}&dt=t&q=$1" | cut -d'"' -f2;
}

# Request a new DHCP lease for a new IP address
alias newip='sudo ipconfig set en0 BOOTP ; ipconfig set en0 DHCP'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF --block-size=M'
alias la='ls -A --block-size=M'
alias l='ls -CF --block-size=M'
if [ "$(uname)" == "Darwin" ]; then
  alias ll='ls -alF'
  alias la='ls -A'
  alias l='ls -CF'
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# task kill
alias fu='sudo kill'
alias fuu='sudo kill -9'
alias fuuu='sudo killall'
alias fuuuu='sudo killall -9'
alias fp='f(){ sudo netstat -nlp | grep $@;  unset -f f; }; f'
free-port() { kill "$(lsof -t -i :$1)"; }
kill-port() { kill -kill "$(lsof -t -i :$1)"; }
# normalize permission
alias chm='find . -type d -exec sudo chmod 755 {} \; && find . -type f -exec sudo chmod 644 {} \;'

# show status
function getstate(){
  echo "CPU `LC_ALL=C top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}'`% RAM `free -m | awk '/Mem:/ { printf("%3.1f%%", $3/$2*100) }'` HDD `df -h / | awk '/\// {print $(NF-1)}'`"
}
function pss(){
  ps -eaf | grep "$1"
}
update_terminal_cwd() {
    # Identify the directory using a "file:" scheme URL,
    # including the host name to disambiguate local vs.
    # remote connections. Percent-escape spaces.
    local SEARCH=' '
    local REPLACE='%20'
    local PWD_URL="file://$HOSTNAME${PWD//$SEARCH/$REPLACE}"
    printf '\e]7;%s\a' "$PWD_URL"
}
alias pss='ps -p $1 -o %cpu,%mem,cmd'
alias myip="ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'"
alias myipr='curl ifconfig.me'
function welcome(){
  # Basic info
  HOSTNAME=`uname -n`
  ROOT=`df -h | awk '$NF=="/"{printf "%s", $5}'`
  # System load
  MEMORY1=`free -t -m | grep Total | awk '{print $3" MB";}'`
  MEMORY2=`free -t -m | grep "Mem" | awk '{print $2" MB";}'`
  DISK_TOTAL=`df -h --total | awk 'END {print $2}'`
  DISK_USED=`df -h --total | awk 'END {print $3}'`
  DISK_USAGE=`df -h --total | awk 'END {print $5}'`
  LOAD1=`cat /proc/loadavg | awk {'print $1'}`
  LOAD5=`cat /proc/loadavg | awk {'print $2'}`
  LOAD15=`cat /proc/loadavg | awk END{'print $3'}`
  if [ -f /etc/os-release ]; then
    DISTO1=`awk -F'=' '/PRETTY_NAME/ {print $2}' /etc/os-release`
  else
    DISTO1="Unknown"
  fi
  echo "
===============================================
 - Hostname............: $HOSTNAME
 - Linux Distribution..: $DISTO1
 - Disk Space..........: $DISK_USED/$DISK_TOTAL ($DISK_USAGE) used
===============================================
 - CPU usage...........: $LOAD1, $LOAD5, $LOAD15 (1, 5, 15 min)
 - Memory used.........: $MEMORY1 / $MEMORY2
 - Swap in use.........: `free -m | tail -n 1 | awk '{print $3}'` MB
===============================================
"
}

