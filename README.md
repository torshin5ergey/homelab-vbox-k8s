# homelab-vbox-k8s

Automated local environment ~~Kubernetes cluster~~ setup in VirtualBox for DevOps and Kubernetes practice.

## Used Tools

- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- [Terraform](https://www.terraform.io/downloads.html)
- ~~[Ansible]()~~
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
3. When you're done, you can remove all created resources:
    ```
    terraform destroy
    ```

## TODO

- [ ] `generate_inventory.sh` script for Ansible
- [ ] Change vagrant box to generic distro
- [ ] Change vbox to another virtualisation tool

## Author
Sergey Torshin [@torshin5ergey](https://github.com/torshin5ergey)
