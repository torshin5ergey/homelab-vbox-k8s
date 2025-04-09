#!/bin/bash

set -e

VMS=("node-master" "node-worker1" "node-worker2")

for VM in "${VMS[@]}"; do
    echo "Stopping $VM"
    VBoxManage controlvm "$VM" poweroff
    sleep 5
done

echo "All nodes has been successfully stopped."
