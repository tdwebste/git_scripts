# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# Source global definitions
if [ -f /etc/bash.bashrc ]; then
    . /etc/bash.bashrc
fi

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
#export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth

#switch path order to select local autoconf or system autoconf
#export PATH=$PATH:~/nrf/nrfjprog
#export PATH=~/bin:
export PATH=/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games
#export PATH=~/bin:$PATH #added by finding directories below ~/bin
if [ -d /snap/bin ]; then
    export PATH=$PATH:/snap/bin
fi


# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=90000
HISTFILESIZE=90000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set variable identifying the git branch you work in (used in the prompt below)
export GIT_PS1_SHOWDIRTYSTATE=1     # unstaged *, staged +
export GIT_PS1_SHOWUNTRACKEDFILES=1 # untracked %
export GIT_PS1_SHOWSTASHSTATE=1     # stashed #
export GIT_PS1_SHOWUPSTREAM="auto"  # "<>" diverged and "=" no difference.

export PS1_DELAY=1


if [ -f $HOME/src/git_scripts/findbranch.sh ]; then
    _timed_git_ps1() {
        timeout $PS1_DELAY $HOME/src/git_scripts/findbranch.sh
    }
else
    _timed_git_ps1() {
        time __git_ps1
    }
fi

pt_user_co() {
    if [ "$(id -u)" == "0" ]; then
        # root red
        echo -en "\033[1;31m"
    else
        # not root green
        echo -en "\033[1;32m"
    fi
}

pt_host_co() {
    if [[ ${SSH_CLIENT} ]] || [[ ${SSH2_CLIENT} ]]; then 
        # ssh login purple
        echo -en "\033[1;35m"
    else
        # nossh login blue
        echo -en "\033[1;34m"
    fi
}


_git_repo() {
    if type -p __git_ps1; then
        branch=$(_timed_git_ps1) 
        if [ -n "$branch" ]; then 
            subdir=$(timeout $PS1_DELAY git rev-parse --show-prefix 2>/dev/null)
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
        branch=$(_timed_git_ps1)
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

            status=$(timeout $PS1_DELAY git status 2> /dev/null)
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

            subdir=$(timeout $PS1_DELAY git rev-parse --show-prefix 2>/dev/null)
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
        branch=$(_timed_git_ps1)
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

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias pcregrep='pcregrep --color=auto'
fi

# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# required for UBUNTU
# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! [ `type -t have` ]; then
    have()
    {
        type -t $1 >/dev/null
        return $?
    }
fi
# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    elif [ -d /etc/bash_completion.d ]; then
        for f in /etc/bash_completion.d/*; do
            . $f
        done
    fi
fi


 # if the command-not-found package is installed, use it
if [ -x /usr/lib/command-not-found -o -x /usr/share/command-not-found/command-not-found ]; then
    function command_not_found_handle {
        # check because c-n-f could've been removed in the meantime
        if [ -x /usr/lib/command-not-found ]; then
	   /usr/lib/command-not-found -- "$1"
           return $?
        elif [ -x /usr/share/command-not-found/command-not-found ]; then
	   /usr/share/command-not-found/command-not-found -- "$1"
           return $?
	else
	   printf "%s: command not found\n" "$1" >&2
	   return 127
	fi
    }
fi

#git alias
#‘gco ‘, hit tab, and see all of branches
complete -o default -o nospace -F _git_checkout gco

alias gco='git checkout'

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

#. ~/src/git_scripts/.emb_bashrc

#github ssh keys
#https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/
eval "$(ssh-agent -s)"
if [ -f ~/.ssh/id_dsa_github ]; then
    ssh-add ~/.ssh/id_dsa_github
fi
ssh-add ~/.ssh/*_rsa

if [ -d /home/local/ANT/tweb/.local/share/umake/bin ]; then
    # Ubuntu make installation of Ubuntu Make binary symlink
    export PATH=/home/local/ANT/tweb/.local/share/umake/bin:$PATH
fi
if [ -d /usr/local/cuda-9.0 ]; then
    export LD_LIBRARY_PATH=/usr/local/cuda-9.0/lib64:$LD_LIBRARY_PATH
    export PATH=/usr/local/cuda-9.0/bin:$PATH
fi

# Virtual Environment Wrapper
if [ -e "/apollo/env/SDETools/bin" ]; then
        export PATH="/apollo/env/SDETools/bin:$PATH"
fi
if [ -e /etc/brazilcli.env ]; then
    export PATH=$BRAZIL_CLI_BIN:$PATH
fi
if [ -d $HOME/.toolbox/bin ]; then
    export PATH=$HOME/.toolbox/bin:$PATH
fi


EXTPATH=$(find -L $HOME/bin -name 'bin' | tr '\n' ':')
export PATH=$PATH:$EXTPATH
