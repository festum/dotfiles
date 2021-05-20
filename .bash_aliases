#!/bin/bash

# -------------------------------------------------------------------
# Config (set your own in $HOME/.aliases_local)
# -------------------------------------------------------------------
GIT_USERNAME='Festum Qin'
GIT_USEREMAIL='festum@g.pl'
GIT_LOG_FORMAT="format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset'"
SSH_PK='/Users/festum/Dropbox/Festum/Archives/AppConf/ssh/f_app'

[ -f $HOME/.aliases_local ] && source $HOME/.aliases_local
[ -f $HOME/.aliases.local ] && source $HOME/.aliases.local
[ -f $HOME/configs/custom_aliases ] && source $HOME/configs/custom_aliases
[ -f $HOME/.fe0/.bash_aliases ] && source $HOME/.fe0/.bash_aliases && export BASH_IT_THEME=candy

# -------------------------------------------------------------------
# Setup
# -------------------------------------------------------------------
function ssh_with_rc(){
    if [ "$(uname)" == "Darwin" ]; then
        break_arg='-b 0'
    else
        break_arg='-w0'
    fi
    if [ -f $HOME/.fe0/.bash_aliases ]; then
        RC_DATA=`cat $HOME/.fe0/.bashrc | base64 $break_arg`
        AL_DATA=`cat $HOME/.fe0/.bash_aliases | base64 $break_arg`
    else
        RC_DATA=`cat $HOME/.bashrc | base64 $break_arg`
        AL_DATA=`cat $HOME/.bash_aliases | base64 $break_arg`
    fi
    ssh -t $@ "mkdir -p $HOME/.fe0;echo \"${RC_DATA}\" | base64 --decode > $HOME/.fe0/.bashrc;echo \"${AL_DATA}\" | base64 --decode > $HOME/.fe0/.bash_aliases;bash --rcfile $HOME/.fe0/.bashrc"
}
function exit_and_rm(){
    if [ -f $HOME/.fe0/.bash_aliases ]; then
        rm -rf $HOME/.fe0/
    fi
    exit
}
alias sshz='ssh_with_rc'
alias sshf='ssh -i "${SSH_PK}"'
alias sshr='ssh -R 52698:localhost:52698'
alias exit=exit_and_rm
alias init_vim='git clone --depth=1 https://github.com/amix/vimrc.git $HOME/.vim_runtime; sh $HOME/.vim_runtime/install_awesome_vimrc.sh'
function bashrc(){
    [ -f $HOME/.bashrc ] && source $HOME/.bashrc
    [ -f $HOME/.bach_profile ] && source $HOME/.bach_profile
    [ -f $HOME/.profile ] && source $HOME/.profile
    [ -f $HOME/.fe0/.bashrc ] && source $HOME/.fe0/.bashrc
}
function ttmux(){
    # echo "set-option -g default-shell \"/bin/bash\"" > $HOME/.tmux.conf
    if ([ -z $TMUX ]); then
        source $HOME/.bash_it/.bashrc
        tmux new-session -A -s main
    fi
}

# -------------------------------------------------------------------
# Aliases
# -------------------------------------------------------------------
# General
alias c="clear && printf '\e[3J'"
alias cls="echo -ne '\033c'"
alias cp='cp -iv'                           # Preferred 'cp' implementation
alias cpv='rsync -ah --info=progress2'      # CP continuously
alias mv='mv -iv'                           # Preferred 'mv' implementation
alias mkdir='mkdir -pv'                     # Preferred 'mkdir' implementation
alias ll='ls -GFhl'                         # Preferred 'ls' implementation
alias less='less -FSRXc'                    # Preferred 'less' implementation
alias nano='nano -W'                        # Preferred 'nano' implementation
alias wget='wget -c'                        # Preferred 'wget' implementation (resume download)
alias c='clear'                             # c:            Clear terminal display
alias path='echo -e ${PATH//:/\\n}'         # path:         Echo all executable Paths
alias show_options='shopt'                  # Show_options: display bash options settings
alias fix_stty='stty sane'                  # fix_stty:     Restore terminal settings when screwed up
alias cic='set completion-ignore-case On'   # cic:          Make tab-completion case-insensitive
alias src='source $HOME/.bashrc'                # src:          Reload .bashrc file
alias tcn='mv --force -t $HOME/.local/share/Trash '
alias h='history | tail'
alias hg='history | grep'
alias g='grep'
alias {ack,ak}='ack-grep'
# Directory Listing aliases
alias dir='ls -hFx'
alias l.='ls -d .* --color=tty' # short listing, only hidden files - .*
alias l='ls -lathF'             # long, sort by newest to oldest
alias L='ls -latrhF'            # long, sort by oldest to newest
alias la='ls -Al'               # show hidden files
alias lc='ls -lcr'              # sort by change time
alias lk='ls -lSr'              # sort by size
alias lh='ls -lSrh'             # sort by size human readable
alias lm='ls -al | more'        # pipe through 'more'
alias lo='ls -laSFh'            # sort by size largest to smallest
alias lr='ls -lR'               # recursive ls
alias lt='ls -ltr'              # sort by date
alias lu='ls -lur'              # sort by access time
alias left='ls -t -1'
alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less' # Full Recursive Directory Listing
alias dud='du -d 1 -h'          # Short and human-readable file listing
alias duf='du -sh *'            # Short and human-readable directory listing
# Permission
alias perm='stat --printf "%a %n \n "'      # perm: Show permission of target in number
alias 000='chmod 000'                       # ---------- (nobody)
alias 640='chmod 640'                       # -rw-r----- (user: rw, group: r, other: -)
alias 644='chmod 644'                       # -rw-r--r-- (user: rw, group: r, other: -)
alias 755='chmod 755'                       # -rwxr-xr-x (user: rwx, group: rx, other: x)
alias 775='chmod 775'                       # -rwxrwxr-x (user: rwx, group: rwx, other: rx)
alias mx='chmod a+x'                        # ---x--x--x (user: --x, group: --x, other: --x)
alias ux='chmod u+x'                        # ---x------ (user: --x, group: -, other: -)
alias gpin='f(){ usermod -a -G $1 $USER; unset -f f; }; f' # gpin: Join group
alias gpls='cat /etc/group | cut -d: -f1'                  # gpls: List groups
alias vboxin='usermod -aG vboxsf $USER'                    # vboxin: Allow me to have access for shared folder
alias chm='find . -type d -exec sudo chmod 755 {} \; && find . -type f -exec sudo chmod 644 {} \;' # normalize permission
# File and folder
alias rd='rm -rf'
alias rmi='rm -i'
alias rm0='find . -size 0 -print0 |xargs -0 rm --'  # Remove zero size files
alias mkdir="mkdir -p"
alias md='mkdir'
alias mvi='mv -i'
alias ln="ln -v"
alias ~='cd ~'
alias -- -='cd ~-'
alias d='cd $HOME/Downloads/'
alias numFiles='echo $(ls -1 | wc -l)'               # numFiles: Count of non-hidden files in current dir
alias make1mb='truncate -s 1m ./1MB.dat'             # make1mb:  Creates a file of 1mb size (all zeros)
alias make5mb='truncate -s 5m ./5MB.dat'             # make5mb:  Creates a file of 5mb size (all zeros)
alias make10mb='truncate -s 10m ./10MB.dat'          # make10mb: Creates a file of 10mb size (all zeros)
alias ffind='f(){ find . -type f -iname '*'$@'*' -ls | grep -v "Permission denied"; unset -f f; }; f' # Find a file with a pattern in name:
alias efind='f(){ find . -type f -iname '*'$@'*' -exec "${2:-file}" {} \; unset -f f; }; f' # Find a file with pattern $1 in name and Execute $2 on it:
alias qfind="find . -name "                          # qfind:    Quickly search for file
alias count='f(){ cat $@ |wc -l; unset -f f; }; f'   # count:    Get the number of files in this folder
alias rep='find . -type f -print0 | xargs -0 sed -i' # rep:      Find file by string
# Process
alias memHogsTop='top -l 1 -o rsize | head -20' # Find memory hogs
alias memHogsPs='ps wwaxm -o pid,stat,vsize,rss,time,command | head -10'
alias cpuHogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10' # Find CPU hogs
alias topForever='top -l 9999999 -s 10 -o cpu' # Continual 'top' listing (every 10 seconds)
alias ttop="top -R -F -s 10 -o rsize" # Recommended 'top' invocation to minimize resources
alias psa='ps -Ao pid,comm,pcpu,pmem --sort=-pcpu | head -11'                      # psa:     List processes with minimal info
alias psc='ps -ax -opid,lstart,pcpu,cputime,comm --sort=-%cpu,-cputime | head -11' # psc:     List processes by CPU
alias psm='ps -ax -opid,lstart,pmem,rss,comm --sort=-pmem,-rss | head -11'         # psm:     List processes by memory
alias pss='f(){ ps -eaf | grep "$1"; unset -f f; }; f'                             # pss:     Search process
alias psp='f(){ sudo netstat -nlp | grep $@; unset -f f; }; f'                     # psp:     Get process by port
alias daemon='f(){ $@ > /dev/null 2>&1 &; unset -f f; }; f'                        # daemon:  Run in background
alias daemono='f(){ $@ >> ./out 2>&1 &; unset -f f; }; f'                          # daemono: Run in background with output
alias fu='sudo kill -9'      # fu:   Force kill
alias fuu='sudo killall'     # fuu:  Kill them all
alias fuuu='sudo killall -9' # fuuu: Force kill them all
alias setcb="echo -e '\e[6 q'"
alias setcu="echo -e '\e[4 q'"

# Networking
alias netCons='lsof -i'                                   # netCons:      Show all open TCP/IP sockets
alias lsock='sudo /usr/sbin/lsof -i -P'                   # lsock:        Display open sockets
alias lsockU='sudo /usr/sbin/lsof -nP | grep UDP'         # lsockU:       Display only open UDP sockets
alias lsockT='sudo /usr/sbin/lsof -nP | grep TCP'         # lsockT:       Display only open TCP sockets
alias ipInfo0='ifconfig getpacket en0'                    # ipInfo0:      Get info on connections for en0
alias ipInfo1='ifconfig getpacket en1'                    # ipInfo1:      Get info on connections for en1
alias openPorts='sudo lsof -i | grep LISTEN'              # openPorts:    All listening connections
alias showBlocked='sudo ipfw list'                        # showBlocked:  All ipfw rules inc/ blocked IPs
alias myip='curl ifconfig.me'                             # myip:         Show my external IP
alias myips="ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'"
alias newip='sudo ipconfig set en0 BOOTP ; ipconfig set en0 DHCP'     # Request a new DHCP lease for a new IP address
alias portf='f(){ kill "$(lsof -t -i :$1)"; unset -f f; }; f'         # portf: Free occupied process for certain port
alias portt='f(){ kill -kill "$(lsof -t -i :$1)"; unset -f f; }; f'   # portt: Kill occupied process for certain port
alias dl='f(){ curl -OJ $@; unset -f f; }; f'                         # dl:    Download
alias dlb='f(){ sudo curl -o "/usr/local/bin/${1##*/}" $1 && sudo sudo chmod +x "/usr/local/bin/${1##*/}"; unset -f f; }; f' # dlb: Download binary and move as executable
alias transfer='f(){  curl --progress-bar --upload-file $1 https://transfer.sh/$(basename $1) | tee /dev/null; unset -f f; }; f' # transfer: Upload to public
alias serveo='f(){ ssh -R 80:$1 serveo.net; unset -f f; }; f'           # dl: Expose local port
alias serveop='f(){ autossh -M 0 -R 80:$1 serveo.net; unset -f f; }; f' # dl: Expose local port as daemon
# Date
alias bdate="date '+%a, %b %d %Y %T %Z'"
alias cal3='cal -3'
alias da='date "+%Y-%m-%d %A    %T %Z"'
alias daysleft='echo "There are $(($(date +%j -d"Dec 31, $(date +%Y)")-$(date +%j))) left in year $(date +%Y)."'
alias epochtime='date +%s'
alias mytime='date +%H:%M:%S'
alias secconvert='date -d@1234567890'
alias stamp='date "+%Y%m%d%a%H%M"'
alias timestamp='date "+%Y%m%dT%H%M%S"'
alias today='date +"%A, %B %-d, %Y"'
alias weeknum='date +%V'
# Misc
alias uig='f(){ grep -i --color $@ /etc/group; unset -f f; }; f'
alias sudo='sudo '

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
# Coding
# -------------------------------------------------------------------
# Go
alias goi='go install'
alias got='go test ./... -tags test'
alias go.='go run .'
alias gom='go mod'
alias gog='go get -u'
alias gogg='GO111MODULE=off go get'
alias gogd='go get -d ./...'
alias gol='golangci-lint --color always'
alias gopi='echo export GOPATH=$(pwd) > .envrc'

# Node
alias node='node --harmony'

# Kotlin
alias ktl="ktlint -F '**/*.kt'"

# Python
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
alias venv3='rm -rf ./venv && virtualenv -p $HOME/.pyenv/versions/3.7.0/bin/python3.7 --no-site-packages venv && source venv/bin/activate'
alias venvr='source venv/bin/activate'
alias pipi='pip3 install -U'
alias pipr='pip3 install -r -U requirements.txt'
alias pipu='pip3 install -U $(pip3 freeze | cut -d '=' -f 1)'
alias pips=pip_install_save
alias pe='pipenv'
alias pei='pipenv install'
alias pes='pipenv shell'
alias pep='pipenv run python'

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

# -------------------------------------------------------------------
# Git
# -------------------------------------------------------------------
alias save='git stash save -u'
alias apply='git stash apply'
alias undo='git reset --hard && git clean -fd'
alias stashc='git stash clear'
alias stashd='git stash drop -q'
alias stashs='git stash show'
alias stashl='git stash list'
alias stashb='git stash branch'
alias diff='git diff --no-index'
alias pname='basename `git rev-parse --show-toplevel`'
alias ga='git add'
alias gaa='git add .'
alias gb='git branch'
alias gbl='git branch-select -l'
alias gbr='git rev-parse --abbrev-ref --symbolic-full-name @{u}'
alias gbd='git branch -D'
alias gbn='f() { git switch $1 2>/dev/null || git switch -c $1; }; f' # Git 2.23
alias gbdr='git push -d origin'
alias gbdd="git fetch --prune && git branch -r | egrep -v -f /dev/fd/0  <(git branch -vv | grep origin | grep -v 'master\|main') | awk '{print \$1}' | xargs -r git branch -D"
alias gbdc='git branch | egrep -v "(^\*|master|main|dev|develop)" | xargs git branch -D'
alias gbo='git for-each-ref --sort=committerdate refs/heads/ --format="%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))"'
alias gc='git checkout --recurse-submodules'
alias gcm='git checkout --recurse-submodules master'
alias gcp='git cherry-pick'
alias gcl='git clone'
alias gd='git diff --no-renames -b -w --ignore-blank-lines --color'
alias gda='git diff --shortstat master | sed -E "s/([0-9]+) file.* ([0-9]+) insertion.* ([0-9]+) deletion.*/#\1 +\2 -\3/"'
alias gdc='git diff --shortstat --cached'
alias gdev='git checkout master && git branch -D dev && git pull && git checkout -b dev'
alias gdm='git diff master...'
alias gds='gd --stat'
alias gfa='git fetch --all -p'
alias gfp='git fetch --progress --prune origin'
alias gm='git commit -m '
alias gm0='git commit -C HEAD@{1}'
alias gma='git commit -am'
alias gmr='git commit --amend -m'
alias gmu='git -c user.name="${GIT_USERNAME}" -c user.email="${GIT_USEREMAIL}" commit -m '
alias gmg='git merge'
alias gmgp='git merge @{-1}'
alias gmgm='git merge master'
alias gmv='git mv'
alias gp='git pull'
alias gpa='git pull --all'
alias gpf='git pull --all --rebase --autostash'
alias gpm='git pull --rebase --autostash origin master'
alias gpu='git fetch upstream && git rebase upstream/master'
alias gpush=gu
alias gl='git log --date=iso --name-status'
alias glp='git log --pretty="${GIT_LOG_FORMAT}" --abbrev-commit --no-merges --date=iso'
alias glg='git log --graph --topo-order --decorate --oneline --all'
alias glc='git log --pretty=format:'%s' | cut -d " " -f 1 | sort | uniq -c | sort -nr' # get counts
alias gld='rm -f .git/index.lock'
alias grb='git rebase'
alias grba='git rebase --abort'
alias unlockref='git remote prune origin'
alias grbc='git rebase --continue'
alias grbs='git rebase --skip'
alias grbi='git rebase --interactive' # merge
alias grbm='git rebase master'
alias grbmb='save && gc master && gp && gc - && grbm'
alias grc='git ls-files --deleted -z | xargs -0 git rm' # clean
alias grf='git reflog'
alias grm='git rm --ignore-unmatch -f -r --cached'
alias grmt='git remote'
alias grma='git remote add'
alias grmau='git remote add upstream'
alias grmsu='git remote set-url --add --push origin'
alias grmr='git remote rm'
alias grs='git reset'
alias grs0='git reset --soft HEAD^1 && git add . && git commit -C HEAD@{1}'
alias grs1='git reset --soft HEAD^1'
alias grh1='git reset --hard HEAD^1'
alias grhh='git update-ref -d HEAD'
alias gru="git status -su | cut -d' ' -f2- | tr '\n' '\0' | xargs -0 rm"
alias gs='git status -sb'
alias gmod="git status --porcelain | sed -ne 's/^ M //p'"
alias gsm='git submodule'
alias gsmi='git submodule update --init --recursive'
alias gsmu='git submodule update --remote --merge --recursive'
alias gsmp='git submodule foreach git pull'
alias gsmr='git submodule foreach --recursive git reset --hard'
alias gsho='git show --color'
alias gslc="git shortlog | grep -E '^[ ]+\w+' | wc -l"
alias gslu="git shortlog | grep -E '^[^ ]'"
alias gt='git tag -n'
alias gta='git tag -a -m'
alias ghusky='rm -rf .git/hooks/ && npm i -D husky' # https://github.com/typicode/husky/issues/333
alias gu='git push -f'
alias gus='git push -f -o ci.skip'
alias gub='git push -u origin $(git rev-parse --abbrev-ref HEAD)' # git branch --show-current for git 2.22
alias gubs='git push -f -o ci.skip -u origin $(git rev-parse --abbrev-ref HEAD)'
alias gum='git push -o merge_request.create -o merge_request.target=master -o merge_request.merge_when_pipeline_succeeds'
alias guo='git push origin'
function gta2() {
    local date=`date +%Y-%m-%d`
    if test -z $1; then
        echo -e $C_1"use it like that: "$C_2"gt \$tagname"$C_1
        echo -e "it will do: "$C_2"git tag -am\"`date +%Y-%m-%d` \$tagname\" \$tagname"$C_1
        echo -e "example: "$C_2"gt v0.0.1"$C_0
    else
        echo -e $C_1"----→ git tag -f -am\"${date} $1\" $1"$C_0
        git tag -f -am"${date} $1" $1
        echo -e $C_1"----→ done"$C_0
    fi
}
function gmeta() {
    url=$(git config --get remote.origin.url)
    re="^(https|git)(:\/\/|@)([^\/:]+)[\/:]([^\/:]+)\/(.+)(.git)?$"
    if [[ $url =~ $re ]]; then
        export repo_proto=${BASH_REMATCH[1]}
        export repo_sepa=${BASH_REMATCH[2]}
        export repo_host=${BASH_REMATCH[3]}
        export repo_user=${BASH_REMATCH[4]}
        export repo_name=`basename -s .git ${BASH_REMATCH[5]}`
        git remote set-head origin --auto
        export repo_default_branch=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
        export repo_current_branch=$(git rev-parse --abbrev-ref HEAD)
    fi
}
function mr(){
    gmeta
    link="https://${repo_host}/${repo_user}/${repo_name}/merge_requests/new?merge_request%5Bsource_branch%5D=${repo_current_branch}"
    [ $repo_host == "github.com" ] && link="https://${repo_host}/${repo_user}/${repo_name}/compare/${repo_default_branch}...${repo_current_branch}"
    if [ "$(uname)" == "Darwin" ]
    then open $link </dev/null >/dev/null 2>&1 & disown
    else xdg-open $link </dev/null >/dev/null 2>&1 & disown
    fi
}
function ltag() {
    curl --silent "https://github.com/$1/releases/latest" | sed 's#.*tag/\(.*\)\".*#\1#' && echo ''
}

# ------------------------------------
# Docker aliases/functions
# ------------------------------------
alias dm='docker-machine'
alias dmip='docker-machine ip'
alias dme='docker-machine env'
alias dmused='dmuse default'
alias dc='docker-compose'
alias dcb='docker-compose build'
alias dcd='docker-compose down'
alias dcu='docker-compose up --remove-orphans'
alias dcub='docker-compose up --remove-orphans --build'
alias dcubf='dcub --force-recreate'
alias dcubn='dcub --no-deps'
alias dcrs='docker-compose down && docker-compose up -d'
alias dcl='docker-compose logs'
alias dclt='dcl --tail="all"'
alias dcx='docker-compose exec'
alias dk='docker'
alias dkx='docker exec -it'
alias dkm='docker commit'
alias dkl='docker logs'
alias dpush='docker push'
alias dkb='docker build'
alias dkr='docker run -it -d -P'
alias dkr1='docker run --rm -it $(docker build -q .)'
alias dkp='docker ps -a'
alias dkpl='docker ps -l -q'
alias dkpf='docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Ports}}\t{{.Command}}\t{{.Status}}\t"'
alias dks='docker stats --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"'
alias dkr='f(){ docker ps -ga -f name="$@" | xargs --no-run-if-empty docker rm -f;  unset -f f; }; f'
alias dkrm='f(){ docker rm $(docker ps -aq -f name="$@"); unset -f f; }; f'
alias dkrma='docker rm -f $(docker ps -aq)'
alias dkrme='docker rm $(docker ps -aq -f status=exited)'
alias dkra='docker ps -qa | xargs --no-run-if-empty docker rm -f'
alias dkip="docker ps -q | xargs -n 1 docker inspect --format '{{ .Name }} {{range .NetworkSettings.Networks}} {{.IPAddress}}{{end}}' | sed 's#^/##';"
alias dki='docker images'
alias dkir='docker rmi'
alias dkirn='docker rmi $(docker images | grep "^<none>" | awk "{ print $3 }")'
alias dkird='docker rmi $(docker images -f "dangling=true" -q)'
alias dkire='docker images -q -f dangling=true | xargs --no-run-if-empty docker rmi'
alias dsh='f(){ docker exec -it "$@" /bin/bash;  unset -f f; }; f'
alias k8='kubectl'
alias k8a='kubectl apply -f'
alias k8c='kubectl config'
alias k8cv='kubectl config view'
alias k8d='kubectl describe'
alias k8g='kubectl get'
alias k8gd='kubectl get deployment,svc,pods,pvc,rc,rs'
alias k8l='kubectl logs'
alias k8r='kubectl delete -f'
alias k8s='kubectl config use-context'
alias k8rp='kubectl delete --grace-period=1 --force po'
alias k8t='kubectl logs --tail=1 -f'
alias k8x='kubectl exec -it'
alias kc='kompose'
alias kcc='kompose convert -f'
alias mk='minikube'
function dmuse() {
    if [ "$(docker-machine status ${1})" == "Stopped" ]; then
        docker-machine start ${1}
    fi
    eval $(docker-machine env ${1})
}
function random_local_port() {
    python -c 'import socket; s = socket.socket(); s.bind(("127.0.0.1", 0)); print s.getsockname()[1]; s.close();'
}
function dmp() {
    PORT="$(random_local_port)"
    ssh -f -o ExitOnForwardFailure=yes \
    -L "127.0.0.1:$PORT:127.0.0.1:2375" "$PRODSERVER" \
    sleep 5
    DOCKER_HOST="127.0.0.1:$PORT" "$@"
}
# ------------------------------------
# Serverless and AWS
# ------------------------------------
alias sld='serverless deploy'
alias sldl='serverless deploy list'
alias sli='serverless invoke --function'
alias slil='serverless invoke local --function'
alias fnc='aws lambda create-function --memory-size 512 --timeout 300 --function-name'
alias login_ecr='$(aws ecr get-login --region eu-central-1 --no-include-email)'
alias login_ghcr='echo $CR_PAT | docker login ghcr.io -u $(git config user.email) --password-stdin'

# -------------------------------------------------------------------
# Converters
# -------------------------------------------------------------------
alias 7za='7z a -t7z -m0=lzma2 -mx=9 -mfb=258 -md=32m -ms=on'
alias i2='convert -density 300 -quality 100'

# -------------------------------------------------------------------
# Commands mapping
# -------------------------------------------------------------------
! command_exists code && command_exists code-oss && alias code=code-oss
! command_exists code && command_exists codium && alias code=codium
command_exists code && alias ed='code .'
! command_exists pm && command_exists homebrew && alias pm='sudo homebrew'
! command_exists pm && command_exists cave && alias pm='sudo cave'
! command_exists pm && command_exists pkgng && alias pm='sudo pkgng'
! command_exists pm && command_exists pkg_tools && alias pm='sudo pkg_tools'
! command_exists pm && command_exists sun_tools && alias pm='sudo sun_tools'
! command_exists pm && command_exists tazpkg && alias pm='sudo tazpkg'
! command_exists pm && command_exists swupd && alias pm='sudo swupd'
! command_exists pm && command_exists tlmgr && alias pm='sudo tlmgr'
! command_exists pm && command_exists conda && alias pm='sudo conda'
! command_exists pm && command_exists portage && alias pm='sudo portage'
! command_exists pm && command_exists dnf && alias pm='sudo dnf'
! command_exists pm && command_exists pacman && alias pm='sudo pacman'
! command_exists pm && command_exists yum && alias pm='sudo yum'
! command_exists pm && command_exists eopkg && alias pm='sudo eopkg'
! command_exists pm && command_exists apk && alias pm='sudo apk'
! command_exists pm && command_exists apt-get && alias pm='sudo apt-get'
! command_exists pm && command_exists pkg && alias pm='sudo pkg'
command_exists hstr && alias hh=hstr
command_exists http && alias https='http --default-scheme=https --verify=no'
command_exists serverless && alias sls=serverless
command_exists bw && alias bws='bw list items --search'
command_exists direnv && alias de=direnv
command_exists zerotier-one.zerotier-cli && alias zt='sudo zerotier-one.zerotier-cli'
command_exists surfshark-vpn && alias surf='sudo surfshark-vpn' && alias surfa='sudo surfshark-vpn attack' && alias surfd='sudo surfshark-vpn down'

# -------------------------------------------------------------------
# UTILITIES
# -------------------------------------------------------------------
# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# show status
function swap() {
    local TMPFILE=tmp.$$
    mv "$1" $TMPFILE && mv "$2" "$1" && mv $TMPFILE $2
}
function authme() {
    cat $HOME/.ssh/id_rsa.pub | ssh $1 'umask 0077; mkdir -p $HOME/.ssh; cat >> .ssh/authorized_keys && chmod 700 $HOME/.ssh && chmod 600 $HOME/.ssh/authorized_keys && echo "Key copied"'
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
    tar -czf ${BN}.tar.gz ${1}
}

function ngr() {
    ngrok http $DMHOST:$1
}
# search from CLI
function google {
    if ! command_exists googler; then
        sudo curl -o /usr/local/bin/googler https://raw.githubusercontent.com/jarun/googler/v4.3.2/googler && sudo chmod +x /usr/local/bin/googler
    fi
    googler
}
# translate
function translate() {
    if ! command_exists trans; then
        sudo curl -o /usr/local/bin/trans https://git.io/trans && sudo chmod +x /usr/local/bin/trans
    fi
    translate
}
# enable color support of ls and also add handy aliases
if command_exists dircolors; then
    test -r $HOME/.dircolors && eval "$(dircolors -b $HOME/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    # alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi
if [ "$(uname)" == "Darwin" ]; then
    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'
fi

function getstate(){
    echo "CPU `LC_ALL=C top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}'`% RAM `free -m | awk '/Mem:/ { printf("%3.1f%%", $3/$2*100) }'` HDD `df -h / | awk '/\// {print $(NF-1)}'`"
}
function update_terminal_cwd() {
    # Identify the directory using a "file:" scheme URL,
    # including the host name to disambiguate local vs.
    # remote connections. Percent-escape spaces.
    local SEARCH=' '
    local REPLACE='%20'
    local PWD_URL="file://$HOSTNAME${PWD//$SEARCH/$REPLACE}"
    printf '\e]7;%s\a' "$PWD_URL"
}

function welcome(){
    # Basic info
    HOSTNAME=`uname -n`
    ROOT=`df -h 2>/dev/null | awk '$NF=="/"{printf "%s", $5}'`
    DF="df -h --total 2>/dev/null"
    if [ -f /etc/os-release ]; then
        DISTO1=`awk -F'=' '/PRETTY_NAME/ {print $2}' /etc/os-release`
    else
        DISTO1="Unknown"
        DF="df -ha 2>/dev/null"
    fi
    # System load
    MEMORY1=`free -t -m | grep Total | awk '{print $3" MB";}'`
    MEMORY2=`free -t -m | grep "Mem" | awk '{print $2" MB";}'`
    DISK_TOTAL=`eval $DF | awk 'END {print $2}'`
    DISK_USED=`eval $DF | awk 'END {print $3}'`
    DISK_USAGE=`eval $DF | awk 'END {print $5}'`
    LOAD1=`cat /proc/loadavg | awk {'print $1'}`
    LOAD5=`cat /proc/loadavg | awk {'print $2'}`
    LOAD15=`cat /proc/loadavg | awk END{'print $3'}`
    echo "===============================================
 - Hostname............: $HOSTNAME
 - Linux Distribution..: $DISTO1
 - Disk Space..........: $DISK_USED/$DISK_TOTAL ($DISK_USAGE) used
 - CPU usage...........: $LOAD1, $LOAD5, $LOAD15 (1, 5, 15 min)
 - Memory used.........: $MEMORY1 / $MEMORY2
 - Swap in use.........: `free -m | tail -n 1 | awk '{print $3}'` MB
==============================================="
}
