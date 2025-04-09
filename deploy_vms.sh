#! /bin/bash
set -e

vm_name="ubuntu2204server-test"
vm_ostype="Ubuntu_64"
iso_path="$HOME/Downloads/ubuntu-22.04.5-live-server-amd64.iso"
vm_cpus=2
vm_memory=2048
vm_vram=128
vm_storage=10240
vm_user=admin
vm_password=admin
vm_basefolder='$HOME/VirtualBox VMs'

wait_for_install() {
    echo -n "Installing..."
    while true; do
        state=$(VBoxManage showvminfo $vm_name --machinereadable | grep "VMState=")
        if [[ $state == *"poweroff"* ]]; then
            echo -e "\nVM $vm_name has been successfully installed!"
            break
        fi
        sleep 10
        echo -n "."
    done
}

# https://www.heatware.net/devops-cloud/bash-parse-yaml-examples/

# Create and register VM
VBoxManage createvm --name $vm_name \
    --ostype $vm_ostype \
    --basefolder "$vm_basefolder" \
    --register

# https://www.osboxes.org/ubuntu-server/#ubuntu-server-22-04-vbox

# Setup VM storage
VBoxManage createhd \
    --filename "$vm_basefolder/$vm_name/$vm_name.vdi" \
    --size $vm_storage \
    --variant Standard \
    --format VDI

# Add SATA Controller
VBoxManage storagectl $vm_name \
    --name "SATA" \
    --add sata \
    --bootable on \
    --portcount 2 \
    --hostiocache on \
# Add IDE Storage Controller
VBoxManage storagectl $vm_name \
    --name "IDE" \
    --add ide \
# Attach Controllers
VBoxManage storageattach $vm_name \
    --storagectl "SATA" \
    --port 0 \
    --device 0 \
    --type hdd \
    --medium "$vm_basefolder/$vm_name/$vm_name.vdi"
VBoxManage storageattach $vm_name \
    --storagectl "IDE" \
    --port 0 \
    --device 0 \
    --type dvddrive \
    --medium $iso_path

# Define VM General Settings
VBoxManage modifyvm $vm_name \
    --cpus $vm_cpus \
    --memory $vm_memory \
    --vram $vm_vram \
    --ioapic on \
    --boot1 dvd --boot2 disk --boot3 none --boot4 none \
    --audio-driver none \
    --usbohci on \
    --mouse usbtablet \
    --nic1 nat \
    # --usb off --usbehci off --usbxhci off \
    # --nic1 bridged --bridgeadapter1 wlp0s20f3 --cableconnected1 on

# VM auto install
VBoxManage unattended install $vm_name \
    --user=$vm_user --password=$vm_password \
    --country=US --time-zone=EST \
    --language=en-US \
    --iso=$iso_path \
    --post-install-command "shutdown -h now" \
    --start-vm=gui

wait_for_install
