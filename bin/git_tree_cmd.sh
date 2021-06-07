#!/bin/bash

# in bash functions global variables are often prefered over function text output
# Not capturing function text output, execution is more robust

# Global var are a good practice for powershell for the same reason
### GLOBAL VARS ###
gpaths=()

function usage() {
    echo "$0 <path> <option> <\"script cmd\">"
    echo "path: file glob pattern"
    echo "option: '' All git repos
        -a All git submodule repos
        -m git submodule Root repo
        -n NOT git submodule repo"
    echo "\"script cmd\": script ran in each git repo"
    exit
}

#global gpaths pw
function allgitrepos() {
    echo "All git repos"
    local fcmd="find $path -name '.git' -print -prune"
    local ifs="$IFS"
    IFS=$'\n'
    gpaths=( $(eval "$fcmd" | while read dir; do
        cd "$pw"
        path="${dir#./}"
        if [ "$path" != ".git" ]; then
            path="${path%/.git}"
            cd "$path"
        fi
        pwd
    done) )
    IFS="$ifs"
    GELEMENTS=${#gpaths[@]}
    echo "Number: $GELEMENTS"
}

#global gpaths pw
function allgitsubmodules() {
    echo "All submodules"
    local fcmd="find $path -name '.gitmodules' -print -prune"
    local ifs="$IFS"
    IFS=$'\n'
    gpaths=( $(eval "$fcmd" | while read dir; do
        cd "$pw"
        path="${dir#./}"
        if [ "$path" != ".gitmodules" ]; then
            path="${path%/.gitmodules}"
            cd "$path"
        fi
        pwd
        cmd="awk '/path/ { printf \"$PWD/%s\n\", \$NF }' .gitmodules"
        eval "$cmd"
    done | sort | uniq) )
    IFS="$ifs"
    GELEMENTS=${#gpaths[@]}
    echo "Number: $GELEMENTS"
}

#global gpaths pw
function gitsubmoduleroots() {
    echo "submodule Root"
    local fcmd="find $path -name '.gitmodules' -print -prune"
    local ipath
    local ifs="$IFS"
    IFS=$'\n'
    gpaths=( $(eval "$fcmd" | while read dir; do
        cd "$pw"
        path="${dir#./}"
        if [ "$path" != ".gitmodules" ]; then
            path="${path%/.gitmodules}"
            cd "$path"
        fi
        if [ -z "$ipath" ]; then
            ipath=$PWD
            pwd
        else
            cmd="echo \${PWD#${ipath}/}"
            if [ "$PWD" == $(eval "$cmd") ]; then
                ipath=$PWD
                pwd
            fi
        fi
    done) )
    IFS="$ifs"
    GELEMENTS=${#gpaths[@]}
    echo "Number: $GELEMENTS"
}

#global cmd0 cmdbr
function execgit() {
    local result="$(2>&1 eval $cmd0)"
    local status=$?
    local rtnstr
    if [ -n "${result}" ]; then
        rtnstr="
$PWD"
        if [ "$cmd0" != "$cmdbr" ]; then
            rtnstr="$rtnstr
    $(eval $cmdbr)"
        fi
        if [ $status != 0 ]; then
            rtnstr="$rtnstr
ERROR: $status"
        fi
        rtnstr="$rtnstr
$result"
        echo "$rtnstr"
    fi
}

### MAIN ###

path="$1"
cmd="ls -d $path"
dirs=$(eval "$cmd")
if [ -z "$dirs" ]; then
    echo "invalidpath: '${path}'"
    usage
    echo "set path='.'"
    path='.'
fi
echo "path:
$path"
echo "search dirs:
$dirs"
echo

shift
args=("$@")
ELEMENTS=${#args[@]}

#echo "$ELEMENTS input arguments"
#for (( i=0;i<$ELEMENTS;i++)); do
#    echo ${args[${i}]}
#done

pw="$PWD"
i=0
case "${args[${i}]}" in
    #git submodule root repos, not git submodules
    -m)
        if (( i<$ELEMENTS )); then
            ((i++))
            cmd0="${args[${i}]}"
        fi
        cmd0="${args[${i}]}"
        gitsubmoduleroots
        ;;
    #all git submodule repos
    -a)
        if (( i<$ELEMENTS )); then
            ((i++))
            cmd0="${args[${i}]}"
        fi
        cmd0="${args[${i}]}"
        allgitsubmodules
        ;;
    #NOT! git submodule repos
    -n)
        if (( i<$ELEMENTS )); then
            ((i++))
            cmd0="${args[${i}]}"
        fi
        cmd0="${args[${i}]}"
        allgitrepos
        all_gpaths=("${gpaths[@]}")

        allgitsubmodules
        submodule_gpaths=("${gpaths[@]}")

        echo "NOT git submodule repos"
        ifs="$IFS"
        IFS=$'\n'
        gpaths=( $(printf '%s\n' "${all_gpaths[@]}" "${submodule_gpaths[@]}" | sort | uniq -u))
        GELEMENTS=${#gpaths[@]}
        IFS="$ifs"
        echo "Number: $GELEMENTS"
        ;;
    #all git repos
    *)
        cmd0="${args[${i}]}"
        allgitrepos
        ;;
    #usage
   -h)
        usage
        ;;
esac

cmdbr="git branch -a |grep -F '*'"
if [ -z "$cmd0" ]; then
    cmd0="$cmdbr"
fi
echo "cmd:
$cmd0"

GELEMENTS=${#gpaths[@]}
#echo "gpaths: $GELEMENTS: " "${gpaths[@]}"


for (( i=0; i < $GELEMENTS; i++ )); do
    dir="${gpaths[${i}]}"
    cd "$dir"

    execgit &
done
wait
