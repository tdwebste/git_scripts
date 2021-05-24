#!/bin/bash
args=("$@")
ELEMENTS=${#args[@]}
#echo "$ELEMENTS input arguments"
#for (( i=0;i<$ELEMENTS;i++)); do
#    echo ${args[${i}]}
#done

i=0
sha1="${args[${i}]}"
git show $sha1 | sed -e 's/PR \([0-9]*\).*/!\1/'
