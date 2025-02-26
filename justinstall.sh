set -e

cd terraform/
terraform init
terraform apply -auto-approve
cd ..

# install k8s via kubespray
git clone https://github.com/kubernetes-sigs/kubespray.git
cd kubespray/
pip install -r requirements.txt
## installing the cluster
ansible-playbook -i $HOME/homelab-vbox-k8s/ansible/inventory/inventory.ini cluster.yml -b -v
### Get kubeconfig
cd ..
ansible-playbook -i ansible/inventory/inventory.ini ansible/playbooks/get_kubeconfig.yaml
