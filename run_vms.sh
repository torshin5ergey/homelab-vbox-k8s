#!/bin/bash

set -e

VMS=("node-master" "node-worker1" "node-worker2")

for VM in "${VMS[@]}"; do
    echo 'Starting "$VM"'
    VBoxManage startvm "$VM" --type headless
    sleep 5
done

echo "All nodes has been successfully started."
