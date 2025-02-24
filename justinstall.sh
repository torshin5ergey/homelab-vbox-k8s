set -e

cd terraform/
terraform init
terraform apply -auto-approve

# install k8s via kubespray
git clone https://github.com/kubernetes-sigs/kubespray.git
pip install -r kubespray/requirements.txt
