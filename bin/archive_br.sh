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


#base_list=$(for del_br in $(cat $delete_br_f); do
#    echo "$(git log --pretty=format:'%ct %h' -n 1 $del_br) $del_br"
#done | sort -k 1 )
#echo "$base_list"
#exit


base_list=$(for del_br in $(cat $delete_br_f); do
    cmd="git merge-base $basebr $del_br"
    echo "$cmd"
    merge_base=$(eval $cmd)
    echo "$merge_base"
    del_br_name="${merge_base}_$(echo $del_br | sed -e 's#/#_#g')"
    #mkdir -p $del_br_name
  #  printf "$(git log --pretty=format:'%ct %h' -n 1 ${merge_base})..${del_br} -o ${del_br_name}\n"
done)

echo "$base_list"
#start_end_cc=$(echo "$base_list" | sort | sed -e 's#^[0-9]* #git format-patch #' )
#echo "$start_end_cc"
#eval "$start_end_cc"


