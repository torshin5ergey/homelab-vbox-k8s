# homelab-vbox-k8s

Automated local environment ~~Kubernetes cluster~~ setup in VirtualBox for DevOps and Kubernetes practice.

## TL;DR

```
git clone https://github.com/torshin5ergey/homelab-vbox-k8s.git
cd homelab-vbox-k8s/
chmod +x justinstall.sh
./justinstall.sh
```

## Used Tools

- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- [Terraform](https://www.terraform.io/downloads.html)
- [Ansible]()
- [Kubespray](https://github.com/kubernetes-sigs/kubespray) (2.27.0)
- ~~[kubectl]()~~

## Instructions

### Terraform

1. Initialize Terraform and download providers:
    ```bash
    terraform init
    ```
2. Create the VM nodes:
    ```bash
    terraform apply
    ```

### Ansible

3. Set nodes IP to Ansible `inventory.ini`
4. For now you need to login to every node and set `PasswordAuthentication yes` in `/etc/ssh/sshd_config` and add generated ssh keys with
    ```bash
    ssh-copy-id -i terraform/.ssh/id_rsa -o IdentitiesOnly=yes vagrant@ipaddress
    ```
5. Test Ansible connection
    ```bash
    ansible all -m ping -i ansible/inventory/inventory.ini
    ```
6. Check nodes Python and pip version
    ```bash
    ansible-playbook -i ansible/inventory/inventory.ini ansible/playbooks/install_python_pip.yaml
    ```

### Kubespray

7. Download kubespray
    ```bash
    git clone https://github.com/kubernetes-sigs/kubespray.git
    cd kubespray
    ```
8. Install Kubespray requirements
    ```bash
    pip install -r requirements.txt
    ```
9. Run Kubespray cluster installation playbook
    ```bash
    ansible-playbook -i $HOME/homelab-vbox-k8s/ansible/inventory/inventory.ini cluster.yml -b -v
    ```
10. Get kubeconfig
    ```bash
    ansible-playbook -i ansible/inventory/inventory.ini ansible/playbooks/get_kubeconfig.yaml
    ```
- When you're done, you can remove all created resources:
    ```bash
    terraform destroy
    ```

## TODO

- [ ] `generate_inventory.sh` script for Ansible
- [ ] Change vagrant box to generic distro
- [ ] Add another virtualisation tool
- [ ] Fix ssh keys deploy
- [ ] `justinstall.sh`
- [ ] sudo kubectl
- [ ] kubeconfig

## Author
Sergey Torshin [@torshin5ergey](https://github.com/torshin5ergey)
