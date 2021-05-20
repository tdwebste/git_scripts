#!/bin/bash

# quote patterns "path*"
# quote command "git branch | grep '*'"
path="$1"

dirs=$(ls -d $path)
if [ -z "$dirs" ]; then
    echo "$0 path <\"script cmd\">"
    echo "invalidpath: '${path}'"
    echo "set path='.'"
    path='.'
fi
echo "path:
$path"
echo "search dirs:
$dirs"

shift
args=("$@")
ELEMENTS=${#args[@]}

echo "$ELEMENTS input arguments"
for (( i=0;i<$ELEMENTS;i++)); do
    echo ${args[${i}]}
done

pw="$PWD"
i=0
case "${args[${i}]}" in
    #main git repo, not git submodules
    -m)
        if (( i<$ELEMENTS )); then
            ((i++))
            cmd0="${args[${i}]}"
        fi
        cmd0="${args[${i}]}"
        echo "submodule Root"
        fcmd="find $path -name '.gitmodules' -print -prune"
        gpaths=$(eval "$fcmd" | while read dir; do
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
        done)
        ;;
    #all git repos with .gitmodules
    -a)
        if (( i<$ELEMENTS )); then
            ((i++))
            cmd0="${args[${i}]}"
        fi
        cmd0="${args[${i}]}"
        echo "All submodules"
        fcmd="find $path -name '.gitmodules' -print -prune"
        gpaths=$(eval "$fcmd" | while read dir; do
            cd "$pw"
            path="${dir#./}"
            if [ "$path" != ".gitmodules" ]; then
                path="${path%/.gitmodules}"
                cd "$path"
            fi
            pwd
        done)
        ;;
    *)
        cmd0="${args[${i}]}"
        echo "Default"
        fcmd="find $path -name '.git' -print -prune"
        gpaths=$(eval "$fcmd" | while read dir; do
            cd "$pw"
            path="${dir#./}"
            if [ "$path" != ".git" ]; then
                path="${path%/.git}"
                cd "$path"
            fi
            pwd
        done)
        ;;
esac

if [ -z "$cmd0" ]; then
    cmd0="git branch |grep '*'"
fi
echo "cmd:
$cmd0"

echo "$gpaths" | while read dir; do
    cd $dir

    result="$(2>&1 eval $cmd0)"
    status=$?
    if [ -n "${result}" ]; then
        echo
        pwd
        if [ $status != 0 ]; then
            echo "ERROR: $status"
        fi
        echo "$result"
    fi
done
