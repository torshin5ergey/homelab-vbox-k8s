#! /bin/bash

set -e

# Create and register VM
VBoxManage createvm --name ubuntu18server --ostype Ubuntu_64 --register
# Setup VM storage
VBoxManage createmedium \
--filename /home/kifarunix/VirtualBox\ VMs/ubuntu18server/ubuntu18server.vdi \
--size 10240
