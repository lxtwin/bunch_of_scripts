PS1='\[\033[32m\]\u \[\033[36m\]@ \h \w\[\033[32m\]$(__git_ps1)\n└─ \$ ▶\[\033[0m\] '

# =================================================

gb() {
        echo -n '(' && git branch 2>/dev/null | grep '^*' | colrm 1 2 | tr -d '\n' && echo  -n ')'
}
git_branch() {
        gb | sed 's/()//'
}



# =================================================

function shortwd() {
    num_dirs=3
    pwd_symbol="..."
    newPWD="${PWD/#$HOME/~}"
    if [ $(echo -n $newPWD | awk -F '/' '{print NF}') -gt $num_dirs ]; then
        newPWD=$(echo -n $newPWD | awk -F '/' '{print $1 "/.../" $(NF-1) "/" $(NF)}')
    fi 
    echo -n $newPWD
}

git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

PS1='\n\e[38;5;211m$(shortwd)\e[38;5;48m $(git_branch)\e[0m$ '
export PS1

# =======================================================================

pt_user_co() {
    if [ "$(id -u)" == "0" ]; then
        echo -en "\033[1;31m"
    else
        echo -en "\033[1;32m"
    fi
}

pt_host_co() {
    if [[ ${SSH_CLIENT} ]] || [[ ${SSH2_CLIENT} ]]; then 
        echo -en "\033[1;35m"
    else
        echo -en "\033[1;34m"
    fi
}

_git_repo() {
    if type -p __git_ps1; then
#        branch=$(__git_ps1 '%s')
        branch=$(__git_ps1)
        if [ -n "$branch" ]; then 
            subdir=$(git rev-parse --show-prefix 2>/dev/null)
            subdir="${subdir%/}" 
            predir="${PWD%/$subdir}"
            echo -ne "${predir#~}/${subdir}"
        else
            echo -ne ""
        fi
    fi
}

_git_repo_path() {
    if type -p __git_ps1; then
#        branch=$(__git_ps1 '%s')
        branch=$(__git_ps1)
        if [ -n "$branch" ]; then 
            n_remote="$(git remote | wc -l)"
            if [ $n_remote -eq 0 ]; then 
            # no remote repo, no backup red
                c_rem="[1;31m"
            elif [ $n_remote -eq 1 ]; then
            # single remote repo green
                c_rem="[1;32m"
            else
            # multiple remote repo purple
                c_rem="[1;35m"
            fi

            status=$(git status 2> /dev/null)
            if $(echo $status | grep 'added to commit' &> /dev/null); then
            # If we have modified files but no index (blue)
               c_stat="[1;34m"
            else
                if $(echo $status | grep 'to be committed' &> /dev/null); then
                # If we have files in index (red)
                   c_stat="[1;31m"
                else
                # If we are completely clean (green)
                   c_stat="[1;32m"
                fi
            fi

            subdir=$(git rev-parse --show-prefix 2>/dev/null)
            subdir="${subdir%/}" 
            predir="${PWD%/$subdir}"
            echo -ne "\033[01;34m~${predir#~}\033${c_rem}/${subdir}\033${c_stat}"
        else
            echo -ne "\033[01;34m"
        fi
    fi
}

# detect working directory relative to working tree root
pt_git_co() {
    if type -p __git_ps1; then
#        branch=$(__git_ps1 '%s')
        branch=$(__git_ps1)
        if [ -n "$branch" ]; then 
            if [ -n "$1" ]; then
                printf "$1" "${branch}"
            else
                printf "\n%s" "${branch}"
            fi
        else
            printf "%s" "~${PWD#~}"
        fi
    else
        printf "%s" "~${PWD#~}"
    fi
}

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    elif [ "$TERM" = "cygwin" ]; then
	color_prompt=yes
    else
	color_prompt=
    fi
fi


if [ "$color_prompt" = yes ]; then
    #excape \[ non pritable char \]
    PS1='${debian_chroot:+($debian_chroot)}\[$(pt_user_co)\]\u\[\033[0m\]@\[$(pt_host_co)\]\h\[\033[0m\]:\[$(_git_repo_path)\]$(pt_git_co)\[\033[0m\]\$ '
#    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\n$(_git_repo)$(__git_ps1)\$ '
#    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h:\w\a\]$PS1"
    ;;
*)
    ;;
esac

