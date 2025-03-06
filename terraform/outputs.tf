# group: {node name: node ip}
output "vm_info" {
  description = "Node names and IPs by roles"
  value = {
    masters = {
      for vm in virtualbox_vm.node :
      vm.name => vm.network_adapter[0].ipv4_address
      if can(regex("master", vm.name))
    }
    workers = {
      for vm in virtualbox_vm.node :
      vm.name => vm.network_adapter[0].ipv4_address
      if can(regex("worker", vm.name))
    }
  }
}
