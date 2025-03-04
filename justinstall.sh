set -e

# Setup VM nodes
cd terraform/
terraform init
terraform apply -auto-approve
cd ..

# TODO: Set login with password
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
