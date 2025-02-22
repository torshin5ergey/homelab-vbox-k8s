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
- ~~[kubectl]()~~

## Instructions
1. Initialize Terraform and download providers:
    ```
    terraform init
    ```
2. Create the VM nodes:
    ```
    terraform apply
    ```
3. Set nodes IP to Ansible `inventory.ini`
4. For now you need to login to every node and set `PasswordAuthentication yes` in `/etc/ssh/sshd_config` and add generated ssh keys with
    ```
    ssh-copy-id -i terraform/.ssh/id_rsa -o IdentitiesOnly=yes vagrant@ipaddress
    ```
5. Test Ansible connection
    ```
    ansible all -m ping -i ansible/inventory/inventory.ini
    ```
6. Check nodes Pytohn and pip version
    ```
    ansible-playbook -i ansible/inventory/inventory.ini ansible/playbooks/01_check_python_pip.yaml
    ```
- When you're done, you can remove all created resources:
    ```
    terraform destroy
    ```

## TODO

- [ ] `generate_inventory.sh` script for Ansible
- [ ] Change vagrant box to generic distro
- [ ] Add another virtualisation tool
- [ ] Fix ssh keys deploy
- [ ] `justinstall.sh`

## Author
Sergey Torshin [@torshin5ergey](https://github.com/torshin5ergey)
