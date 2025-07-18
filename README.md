# Homelab VBox Kubernetes

Automated* local environment Kubernetes cluster setup in VirtualBox for DevOps and Kubernetes practice.

## TL;DR

```bash
git clone https://github.com/torshin5ergey/homelab-vbox-k8s.git
cd homelab-vbox-k8s/
./justinstall.sh
```

## Used Tools

- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- [Terraform](https://www.terraform.io/downloads.html)
- [Ansible]() (2.6.14)
- [Kubespray](https://github.com/kubernetes-sigs/kubespray) (2.27.0)

## Quickstart

### VM Setup Methods

#### Script-based VM Setup (Python/Bash)

There is a Python script `deploy_vms.py` (recommended) and a Bash script `deploy_vms.sh`.

##### Python `deploy_vms.py`

- For Python script describe VM config with `vmconfig.yaml` template
- Run with
```bash
python scripts/deploy_vms.py vmconfig.yaml
```

#### Terraform VM Setup

1. Initialize Terraform and download providers:
```bash
terraform init
```
2. Create the VM nodes:
```bash
terraform apply
```

### Ansible

3. For now you need to login to every node and set `PasswordAuthentication yes` in `/etc/ssh/sshd_config.d/60-cloudimg-settings.conf`, restart VMs and deploy SSH key
```bash
./stop_vms.sh && ./run_vms.sh
ansible-playbook -i ansible/inventory/inventory.ini ansible/playbooks/deploy-ssh-keys.yaml
```
During this play, you will need to enter the vagrant user password `vagrant`.
4. Test Ansible connection
```bash
ansible all -m ping -i ansible/inventory/inventory.ini
```
5. Check nodes Python and pip version
```bash
ansible-playbook -i ansible/inventory/inventory.ini ansible/playbooks/install-python-pip.yaml
```

### Kubespray

6. Download kubespray
```bash
git clone https://github.com/kubernetes-sigs/kubespray.git
cd kubespray
```
7. Install Kubespray requirements
```bash
pip install -r requirements.txt
```
8. Run Kubespray cluster installation playbook
```bash
ansible-playbook -i $HOME/homelab-vbox-k8s/ansible/inventory/inventory.ini cluster.yml -b -v @ansible/vars/kubespray/k8s-cluster.yml
```
9. Get kubeconfig
```bash
ansible-playbook -i ansible/inventory/inventory.ini ansible/playbooks/get-kubeconfig.yaml
```
- When you're done, you can remove all created resources:
```bash
terraform destroy
```

## Author
Sergey Torshin [@torshin5ergey](https://github.com/torshin5ergey)
