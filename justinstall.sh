#! /bin/bash

set -e

# Setup VM nodes
cd terraform/
terraform init
terraform apply -auto-approve
cd ..

while true; do
    echo "Setup login with password on VMs.Then type 'go' to continue or 'stor' to exit:"
    read user_input
    if [[ "$user_input" == "go" ]]; then
        echo "Installation continued."
        break
    elif [[ "$user_input" == "stop" ]]; then
        echo "Installation anceled."
        exit 0
    else
        echo "Please, type 'go' or 'stop': "
    fi
done

# Restart and deploy SSH
./stop_vms.sh && ./run_vms.sh
ansible-playbook -i ansible/inventory/inventory.ini ansible/playbooks/deploy-ssh-keys.yaml

# Check python/pip versions
ansible-playbook -i ansible/inventory/inventory.ini ansible/playbooks/install_python_pip.yaml

# Install k8s via kubespray
git clone https://github.com/kubernetes-sigs/kubespray.git
cd kubespray/
pip install -r requirements.txt
## Installing the cluster
ansible-playbook -i $HOME/homelab-vbox-k8s/ansible/inventory/inventory.ini cluster.yml -b -v -e @ansible/vars/kubespray/k8s-cluster.yml
### Get kubeconfig
cd ..
ansible-playbook -i ansible/inventory/inventory.ini ansible/playbooks/get_kubeconfig.yaml
