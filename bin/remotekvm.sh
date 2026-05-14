#!/bin/bash

tmpf="/tmp/tmpf.$$"
remoteuser="${1:-tdwebste@ml2}"

#cmd="ssh -t $remoteuser \"sudo bash -c 'virsh list --all|tail -n +3'\""
cmd="ssh -t $remoteuser \"sudo bash -c 'virsh list --all'\""
echo "enter remote user sudo password"
echo "$cmd"
eval "$cmd" >$tmpf
echo "$tmpf"


mapfile -t virsh_lines < <(
    awk '
        /Id[[:space:]]+Name[[:space:]]+State/ { capturing=1; next }
        capturing && NF >= 2 && $0 !~ /sudo\] password/ && $0 !~ /^-+$/ && $0 ~ /[[:alnum:]]/ {
            gsub(/\r$/, "");  # remove ^M if present
            print
        }
    ' "$tmpf"
)

printf '%s\n' "${virsh_lines[@]}"

VMS=${#virsh_lines[@]}
echo "Number vm lists: $VMS"

vmnames=()
for vm in "${virsh_lines[@]}"; do
    line=( $vm )
    vm_name="${line[1]}"
    [[ -n "$vm_name" ]] && vmnames+=("$vm_name")
done
echo
echo "vm  names"
echo "${vmnames[@]}"
read -p "Select VM 0, ... ,$((VMS - 1)): " vm_input

VM="${vmnames[$vm_input]}"
echo "remote=$VM"

REMOTE_USER="tdwebste"
REMOTE_HOST="ml2"
LOCAL_PORT="5900"

cmd="ssh -N -L $((LOCAL_PORT + vm_input)):localhost:$((LOCAL_PORT + vm_input)) ${REMOTE_USER}@${REMOTE_HOST}"
echo "$cmd"
eval "$cmd" &
SSH_PID=$!

sleep 1

remote-viewer spice://localhost:${LOCAL_PORT}

kill ${SSH_PID}


rm -f $tmpf
