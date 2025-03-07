## Reminder!

If you use your own node names JSON then **it's important to have "master" or "worker" role in node names** because of:

```hcl
# main.tf

...
# node groups
masters = {
    for vm in virtualbox_vm.node :
    vm.name => vm.network_adapter[0].ipv4_address
    if can(regex("master", vm.name)) # regex master
}
workers = {
    for vm in virtualbox_vm.node :
    vm.name => vm.network_adapter[0].ipv4_address
    if can(regex("worker", vm.name)) # regex worker
}
...
```
