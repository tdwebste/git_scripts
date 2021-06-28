#!/bin/bash

function help {
    echo "usage:"
    echo "$0 base_br_file delete_br_file"
    exit
}

args=("$@")
ELEMENTS=${#args[@]}
if (( $ELEMENTS < 2 )); then
    help
fi

echo "$ELEMENTS input arguments"
for (( i=0;i<$ELEMENTS;i++)); do
    echo ${args[${i}]}
done

i=0
basebr=$(cat  "${args[${i}]}")
((i++))
delete_br_f="${args[${i}]}"



base_list=$(for del_br in $(cat $delete_br_f); do
    cmd="git merge-base $basebr $del_br"
    echo "$cmd"
    merge_base=$(eval $cmd)
    echo "$merge_base"
    del_br_name="${merge_base}_$(echo $del_br | sed -e 's#/#_#g')"
done)

echo "$base_list"


