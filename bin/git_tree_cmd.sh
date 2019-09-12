#!/bin/bash

#opt=
# q quiet

#opt=$1; shift
cmd0="$*"
#echo "opt=$opt"
echo "$cmd0"
##exit

pw="$PWD"
find . -name '.git' -print -prune| while read dir; do
    cd "$pw"
    path="${dir#./}"
    path="${path%/.git}"
    cd "$path"
    echo
    if $(echo $opt | grep -vq q); then
        pwd
    fi
    eval "$cmd0"
done
