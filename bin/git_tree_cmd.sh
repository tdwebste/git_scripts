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
cmd0="$*"
if [ -z "$cmd0" ]; then
    cmd0="git branch |grep '*'"
fi
echo "cmd:
$cmd0"

pw="$PWD"
fcmd="find $path -name '.git' -print -prune"
eval "$fcmd" | while read dir; do
    cd "$pw"
    path="${dir#./}"
    if [ "$path" != ".git" ]; then
        path="${path%/.git}"
        cd "$path"
    fi

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
