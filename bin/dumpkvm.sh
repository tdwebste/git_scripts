#!/bin/bash

ifs="$IFS"
IFS=$'\n'
vmlist=( $(sudo virsh list --all|tail -n +3))
IFS="$ifs"
VMS=${#vmlist[@]}
echo "Number vm lists: $VMS"

vmnames=()
for vm in "${vmlist[@]}"; do
    line=( $vm )
    vm_name="${line[1]}"
    [[ -n "$vm_name" ]] && vmnames+=("$vm_name")
done
echo "vm    names"
echo "${vmnames[@]}"
echo
read -p "Select VM 0, ... ,$((VMS - 1)): " vm_input


VM="${vmnames[$vm_input]}"
echo "dump vm $VM"

vmdir="dump-$VM"
cmd="sudo rm -rf $vmdir; sudo mkdir $vmdir; sudo chown $USER:$USER $vmdir"
#echo "$cmd"
eval "$cmd"

sudo bash -c "
    virsh dominfo $VM > '$vmdir/dominfo.txt'
    virsh dumpxml $VM > '$vmdir/config.xml'
    virsh domblklist $VM > '$vmdir/disks.txt'
    virsh domiflist $VM > '$vmdir/network.txt'
    virsh domstats $VM > '$vmdir/stats.txt'
"
sudo ls -l "$vmdir"/*
