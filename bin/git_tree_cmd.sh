#!/bin/bash

# quote patters "path*"
# quote command "pwd;git branch | grep '*'"
path="$1"
if [ ! -d "$path" ]; then
    echo "$0 path <\"script cmd\">"
    echo "invalidpath: '${path}'"
    echo "set path='.'"
    path='.'
fi
echo "path: $path"
shift
cmd0="$*"
if [ -z "$cmd0" ]; then
    cmd0="git branch |grep '*'"
fi
echo "cmd: $cmd0"
##exit

pw="$PWD"
find $path -name '.git' -print -prune| while read dir; do
    cd "$pw"
    path="${dir#./}"
    path="${path%/.git}"
    cd "$path"

    result="$(eval $cmd0)"
    if [ -n "${result}" ]; then
        echo
        pwd
        echo "$result"
    fi
done
