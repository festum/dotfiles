#!/bin/bash

# -------------------------------------------------------------------
# Config (set your own in $HOME/.aliases_local)
# -------------------------------------------------------------------
GIT_USERNAME=${GIT_USERNAME:-Festum Qin}
GIT_USEREMAIL=${GIT_USEREMAIL:-festum@g.pl}
GIT_LOG_FORMAT=${GIT_LOG_FORMAT:-"format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset'"}

# -------------------------------------------------------------------
# Setup
# -------------------------------------------------------------------
safe_source $HOME/.aliases_local
safe_source $HOME/.aliases.local
safe_source $HOME/configs/custom_aliases
[ -f $HOME/.remote/.bash_aliases ] && source $HOME/.remote/.bash_aliases && export BASH_IT_THEME=candy
function sshz(){
    if [ "$(uname)" == "Darwin" ]; then
        break_arg='-b 0'
    else
        break_arg='-w0'
    fi
    if [ -f $HOME/.remote/.bash_aliases ]; then
        RC_DATA=`cat $HOME/.remote/.bashrc | base64 $break_arg`
        AL_DATA=`cat $HOME/.remote/.bash_aliases | base64 $break_arg`
    else
        RC_DATA=`cat $HOME/.bashrc | base64 $break_arg`
        AL_DATA=`cat $HOME/.bash_aliases | base64 $break_arg`
    fi
    ssh -t $@ "mkdir -p $HOME/.remote;echo \"${RC_DATA}\" | base64 --decode > $HOME/.remote/.bashrc;echo \"${AL_DATA}\" | base64 --decode > $HOME/.remote/.bash_aliases;bash --rcfile $HOME/.remote/.bashrc"
}
function exit_and_rm(){
    rm -rf $HOME/.fe0/
    exit
}
alias sshr='ssh -R 52698:localhost:52698'
alias exit=exit_and_rm
alias bye=exit
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
alias wget='wget -c' # with resume download
alias cic='set completion-ignore-case On' # cic: Make tab-completion case-insensitive
alias src='unalias -a && source $HOME/.bashrc' # src: Reload .bashrc file
alias tcn='mv --force -t $HOME/.local/share/Trash '
alias h='history | tail'
alias hg='history | grep'
alias hrmdup='nl ~/.bash_history | sort -k 2  -k 1,1nr| uniq -f 1 | sort -n | cut -f 2 | sed -e "/^#d*/d" > unduped_history && cp -f unduped_history ~/.bash_history'
alias g='grep'
alias {ack,ak}='ack-grep'
alias uig='f(){ grep -i --color $@ /etc/group; unset -f f; }; f' # uig: List file groups

# Directory Listing
alias path='echo -e ${PATH//:/\\n}' # path: Echo all executable Paths
alias dir='ls -hFx'
alias ll='ls -GFhl'
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
alias less='less -FSRXc'
alias dud='du -d 1 -h'          # Short and human-readable file listing
alias duf='du -sh *'            # Short and human-readable directory listing

# Permission
alias sudid='sudo !!'
alias owned='sudo chown $(id -u -n)'
alias perm='stat --printf "%a %n \n "'      # perm: Show permission of target in number
alias 000='chmod 000'                       # ---------- (nobody)
alias 640='chmod 640'                       # -rw-r----- (user: rw, group: r, other: -)
alias 644='chmod 644'                       # -rw-r--r-- (user: rw, group: r, other: -)
alias 755='chmod 755'                       # -rwxr-xr-x (user: rwx, group: rx, other: x)
alias 775='chmod 775'                       # -rwxrwxr-x (user: rwx, group: rwx, other: rx)
alias mx='chmod a+x'                        # ---x--x--x (user: --x, group: --x, other: --x)
alias ux='chmod u+x'                        # ---x------ (user: --x, group: -, other: -)
alias 644f='find . -type f -exec chmod 644 {} \;'
alias 755d='find . -type d -exec chmod 755 {} \;'
alias chm='644f && 755d' # normalize permission
alias gpin='f(){ usermod -a -G $1 $USER; unset -f f; }; f' # gpin: Join group
alias gpls='cat /etc/group | cut -d: -f1'                  # gpls: List groups
alias vboxin='usermod -aG vboxsf $USER'                    # vboxin: Allow me to have access shared folder

# File and folder
alias rd='rm -rf'
alias rd.='TMP=`pwd -P` && cd "`dirname $TMP`" && rm -rf "./`basename $TMP`" && unset TMP'
alias rmi='rm -i'
alias rm0='find . -size 0 -print0 |xargs -0 rm --'  # Remove zero size files
alias cpv='rsync -ah --info=progress2' # CP continuously
alias mv='mv -iv'
alias mkdir='mkdir -pv'
alias md='f(){ mkdir -p $1 && cd $1; unset -f f; unset -f f; }; f' # Create folder and goto
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
alias free='free -mt'
alias hogmt='top -l 1 -o rsize | head -20' # hogmt: Find memory hogs by top
alias hogmp='ps wwaxm -o pid,stat,vsize,rss,time,command | head -10' # hogmp: Find memory hogs by ps
alias hogcp='ps wwaxr -o pid,stat,%cpu,time,command | head -10' # hogcp: Find CPU hogs
alias ktop='top -l 9999999 -s 10 -o cpu' # ktop: top listing every 10s
alias ttop="top -R -F -s 10 -o rsize" # ttop: invocation to minimize resources
alias psls='ps auxf'
alias psa='ps -Ao pid,comm,pcpu,pmem --sort=-pcpu | head -11'                      # psa:     List processes with minimal info
alias psc='ps -ax -opid,lstart,pcpu,cputime,comm --sort=-%cpu,-cputime | head -11' # psc:     List processes by CPU
alias psm='ps -ax -opid,lstart,pmem,rss,comm --sort=-pmem,-rss | head -11'         # psm:     List processes by memory
alias psp='f(){ sudo netstat -nlp | grep $@; unset -f f; }; f'                     # psp:     Get process by port
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'                              # psg:     Search process
alias daemon='f(){ $@ > /dev/null 2>&1 &; unset -f f; }; f'                        # daemon:  Run in background
alias daemono='f(){ $@ >> ./out 2>&1 &; unset -f f; }; f'                          # daemono: Run in background with output
alias fu='sudo kill -9'      # fu:   Force kill
alias fuu='sudo killall'     # fuu:  Kill them all
alias fuuu='sudo killall -9' # fuuu: Force kill them all
alias setcur='f(){ echo -e -n "\x1b[\x3${1:-3} q"; unset -f f; }; f' # setcur: set cursor 0-6

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
alias da='date "+%Y-%m-%d %A %T %Z"'
alias daysleft='echo "There are $(($(date +%j -d"Dec 31, $(date +%Y)")-$(date +%j))) left in year $(date +%Y)."'
alias epoch='date +%s'
alias secconvert='date -d@1234567890'
alias stamp='date "+%Y%m%d%a%H%M"'
alias timestamp='date "+%Y%m%dT%H%M%S"'
alias today='date +"%A, %B %-d, %Y"'
alias weeknum='date +%V'


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
alias gobin='sudo GO111MODULE=on GOBIN=/usr/local/bin go install'
alias got='go test ./... -tags test'
alias gor='f() { arg=${@:-.}; go run $arg; unset -f f; }; f'
alias gom='go mod'
alias gog='go get -u'
alias gogg='GO111MODULE=off go get -u'
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
    [[ -z $requirements_file ]] && requirements_file='./requirements.txt'
    pip install $package_name && pip freeze | grep -i $package_name >> $requirements_file
}
alias pipi='pip3 install -U'
alias pipr='pip3 install -U -r requirements.txt'
alias pipu='pip3 install -U $(pip3 freeze | cut -d '=' -f 1)'
alias pips=pip_install_save
alias venv='python -m venv'

# -------------------------------------------------------------------
# Git
# -------------------------------------------------------------------
alias save='git stash save -u'
alias redo='git stash apply'
alias undo='git reset --hard && git clean -fd'
alias fresh='git stash clear'
alias stashd='git stash drop -q'
alias stashs='git stash show'
alias stashl='git stash list'
alias stashb='git stash branch'
alias diff='git diff --no-index'
alias git-main-branch='f() { git symbolic-ref refs/remotes/origin/HEAD | cut -d"/" -f4; }; f'
alias pname='basename `git rev-parse --show-toplevel`'
alias ga='git add'
alias gaa='git add .'
alias gb='git branch'
alias gbs='f() { git checkout --recurse-submodules $1 2>/dev/null || git checkout -b $1; unset -f f; }; f'
alias gbl='git branch-select -l'
alias gbr='git rev-parse --abbrev-ref --symbolic-full-name @{u}'
alias gbd='git branch -D'
alias gbdr='git push -d origin'
alias gbdd="git fetch --prune && git branch -r | grep -E -v -f /dev/fd/0  <(git branch -vv | grep origin | grep -v 'master\|main') | awk '{print \$1}' | xargs -r git branch -D"
alias gbdc='git branch | grep -E -v "(^\*|master|main|dev|develop)" | xargs git branch -D'
alias gbo='git for-each-ref --sort=committerdate refs/heads/ --format="%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))"'
alias gc='git checkout --recurse-submodules'
alias gcat='git cat-file'
alias gcm='f(){ git checkout --recurse-submodules $(git-main-branch); unset -f f;}; f'
alias gcp='git cherry-pick'
alias gcl='f() { git clone "$1" && cd "$(basename "$1" .git)"; unset -f f; }; f'
alias gcln='f() { git clone --filter=blob:none --no-checkout "$1" && cd "$(basename "$1" .git)"; unset -f f; }; f'
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
alias gpm='f(){ git pull --rebase --autostash origin $(git-main-branch; unset -f f;}; f'
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
alias grbm='f(){ git rebase -i --autosquash origin/$(git-main-branch) --no-verify; unset -f f;}; f'
alias grbmb='save && gc master && gp && gc - && grbm'
alias grc='git ls-files --deleted -z | xargs -0 git rm' # clean
alias grf='git reflog'
alias grm='git rm --ignore-unmatch -f -r --cached'
alias grmt='git remote'
alias grma='git remote add'
alias grmau='git remote add upstream'
alias grmsh='git remote set-head origin --auto'
alias grmsu='git remote set-url --add --push origin'
alias grmr='git remote rm'
alias grs='git reset'
alias checkCommitter='export IAM_COMMITTER=false && [ $(git log -1 --pretty=format:"%ae") = $(git config user.email) ] && export IAM_COMMITTER=true'
alias grs0='checkCommitter && [ $IAM_COMMITTER = true ] && grs --soft HEAD^1 && git add . && git commit -C HEAD@{1}'
alias grs1='checkCommitter && [ $IAM_COMMITTER = true ] && grs --soft HEAD^1'
alias grh1='checkCommitter && [ $IAM_COMMITTER = true ] && grs --hard HEAD^1'
alias grhh='git update-ref -d HEAD' # Git reset first commit
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
alias gt='git tag'
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
# Docker related
# ------------------------------------
alias dk='docker'
alias dkx='docker exec -it'
alias dkm='docker commit'
alias dkl='docker logs'
alias dpush='docker push'
alias dkb='docker-buildx'
alias dkr='docker run -it -d -P'
alias dkrb='f(){ dockerfile=${1:-Dockerfile}; docker run -it "$(docker build -q -f $dockerfile .)"; unset -f f; }; f'
alias dkrb1='f(){ dockerfile=${1:-Dockerfile}; docker run -it --rm "$(docker build -q -f $dockerfile .)"; unset -f f; }; f'
alias dkp='docker ps -a'
alias dkpl='docker ps -l -q'
alias dkpf='docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Ports}}\t{{.Command}}\t{{.Status}}\t"'
alias dkpip="docker ps -q | xargs -n 1 docker inspect --format '{{ .Name }} {{range .NetworkSettings.Networks}} {{.IPAddress}}{{end}}' | sed 's#^/##';"
alias dks='docker stats --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"'
alias dkr='f(){ docker ps -ga -f name="$@" | xargs --no-run-if-empty docker rm -f; unset -f f; }; f'
alias dkrm='f(){ docker rm $(docker ps -aq -f name="$@"); unset -f f; }; f'
alias dkrma='docker rm -f $(docker ps -aq)'
alias dkrme='docker rm $(docker ps -aq -f status=exited)'
alias dkrmi='docker rmi'
alias dkrmin='docker rmi $(docker images | grep "^<none>" | awk "{ print $3 }")'
alias dkra='docker ps -qa | xargs --no-run-if-empty docker rm -f'
alias dki='docker images'
alias dkip='docker image prune'
alias dsh='f(){ docker exec -it "$@" /bin/bash; unset -f f; }; f'
alias dc='docker-compose --compatibility'
alias dcb='dc build'
alias dcd='dc down'
alias dcu='dc up --remove-orphans'
alias dcub='dcu --build'
alias dcubf='dcub --force-recreate'
alias dcubn='dcub --no-deps'
alias dcrs='dcd && dc up -d'
alias dcl='dc logs'
alias dclt='dcl --tail="all"'
alias dcx='dc exec'
alias dm='docker-machine'
alias dmip='dm ip'
alias dmenv='dm env'
alias dmused='dmuse default'
alias dmex='f(){ ngrok http $DMHOST:$1; unset -f f; }; f'
alias k8='kubectl'
alias k8a='kubectl apply -f'
alias k8c='kubectl config'
alias k8cc='k8c current-context'
alias k8s='k8c use-context'
alias k8cv='kubectl view'
alias k8d='kubectl describe'
alias k8g='kubectl get --all-namespaces'
alias k8ga='kubectl get --all-namespaces'
alias k8gd='k8g deploy,svc,pods,pvc,rc,rs'
alias k8l='kubectl logs --all-containers'
alias k8t='k8l --tail=1 -f'
alias k8r='kubectl delete -f'
alias k8rp='k8r --grace-period=1 po'
alias k8x='kubectl exec -it'
alias kc='kompose'
alias kcc='kc convert -f'
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
alias sls='serverless'
alias sld='serverless deploy'
alias sli='serverless invoke --function'
alias slil='serverless invoke local --function'
alias fnc='aws lambda create-function --memory-size 512 --timeout 300 --function-name'
alias login_ecr='$(aws ecr get-login --region eu-central-1 --no-include-email)'
alias login_ghcr='echo $CR_PAT | docker login ghcr.io -u $(git config user.email) --password-stdin'
alias tf='terraform'
alias tfr='terraformer'

# -------------------------------------------------------------------
# Converters
# -------------------------------------------------------------------
alias 7za='7z a -t7z -m0=LZMA2:27 -mx=9 -ms=on -mfb=273 -mtm=- -mmt -mmtf -md=1536m -mmf=bt3 -mmc=10000 -mpb=0 -mlc=0'
alias i2='convert -density 300 -quality 100'

# -------------------------------------------------------------------
# Commands mapping
# -------------------------------------------------------------------
! is_runnable code && is_runnable code-oss && alias code=code-oss
! is_runnable code && is_runnable codium && alias code=codium
is_runnable code && alias ed='f() { file=${1:-.}; [ "$file" != "." ] && file="-r ${file}"; code $file 2>/dev/null; unset -f f;}; f'
is_runnable code && alias vc=code
is_runnable nvim && alias nv=nvim
! is_runnable pm && is_runnable homebrew && alias pm='sudo homebrew'
! is_runnable pm && is_runnable cave && alias pm='sudo cave'
! is_runnable pm && is_runnable pkgng && alias pm='sudo pkgng'
! is_runnable pm && is_runnable pkg_tools && alias pm='sudo pkg_tools'
! is_runnable pm && is_runnable sun_tools && alias pm='sudo sun_tools'
! is_runnable pm && is_runnable tazpkg && alias pm='sudo tazpkg'
! is_runnable pm && is_runnable swupd && alias pm='sudo swupd'
! is_runnable pm && is_runnable tlmgr && alias pm='sudo tlmgr'
! is_runnable pm && is_runnable conda && alias pm='sudo conda'
! is_runnable pm && is_runnable portage && alias pm='sudo portage'
! is_runnable pm && is_runnable dnf && alias pm='sudo dnf'
! is_runnable pm && is_runnable pacman && alias pm='sudo pacman'
! is_runnable pm && is_runnable yum && alias pm='sudo yum'
! is_runnable pm && is_runnable eopkg && alias pm='sudo eopkg'
! is_runnable pm && is_runnable apk && alias pm='sudo apk'
! is_runnable pm && is_runnable apt-get && alias pm='sudo apt-get'
! is_runnable pm && is_runnable pkg && alias pm='sudo pkg'
is_runnable hstr && alias hh=hstr
is_runnable http && alias https='http --default-scheme=https --verify=no'
is_runnable serverless && alias sls=serverless
is_runnable bw && alias bws='bw list items --search'
is_runnable direnv && alias de=direnv
is_runnable zerotier-one.zerotier-cli && alias zt='sudo zerotier-one.zerotier-cli'
is_runnable surfshark-vpn && alias surf='sudo surfshark-vpn' && alias surfa='sudo surfshark-vpn attack' && alias surfd='sudo surfshark-vpn down'
is_runnable kitty && alias icat='kitty +kitten icat'


# -------------------------------------------------------------------
# UTILITIES
# -------------------------------------------------------------------
# alert - long running commands
# Usage: sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
function swap() {
    local TMPFILE=tmp.$$
    mv "$1" $TMPFILE && mv "$2" "$1" && mv $TMPFILE $2
}
function authadd() {
    cat $HOME/.ssh/id_rsa.pub | ssh $1 'umask 0077; mkdir -p $HOME/.ssh; cat >> .ssh/authorized_keys && chmod 700 $HOME/.ssh && chmod 600 $HOME/.ssh/authorized_keys && echo "Key copied"'
}
# ex - archive extractor
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
# ex - archiver
function ar(){
    local BN=`basename ${1}`
    tar -czf ${BN}.tar.gz ${1}
}
# ex - downloaded archive installer
# Usage: din <app_name> <installation_parent_path> <archive_strip_top_level>
function din(){
    local TARGET_PATH='/usr/local/'
    [[ -n "${2}" ]] && TARGET_PATH=${2}
    local EX_TYPE=''
    [[ -n "${3}" ]] && EX_TYPE='--strip-components 1'
    echo "Extract to ${TARGET_PATH}/${1} ..."
    sudo rm -rf ${TARGET_PATH}/${1} && sudo mkdir -p $_ && sudo tar -xzf ~/Downloads/${1}*.tar.gz ${EX_TYPE} -C $_
}
# search from CLI
function google {
    if ! is_runnable googler; then
        sudo curl -o /usr/local/bin/googler https://raw.githubusercontent.com/jarun/googler/v4.3.2/googler && sudo chmod +x /usr/local/bin/googler
    fi
    googler
}
# translate
function translate() {
    if ! is_runnable trans; then
        sudo curl -o /usr/local/bin/trans https://git.io/trans && sudo chmod +x /usr/local/bin/trans
    fi
    translate
}
# enable color support of ls and also add handy aliases
if is_runnable dircolors; then
    test -r $HOME/.dircolors && eval "$(dircolors -b $HOME/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    # alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='grep -E --color=auto'
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
    MEMORY1=`free | grep Total | awk '{print $3" MB";}'`
    MEMORY2=`free | grep "Mem" | awk '{print $2" MB";}'`
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
 - Swap in use.........: `free | tail -n 1 | awk '{print $3}'` MB
==============================================="
}
