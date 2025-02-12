# node-name: node-ip
output "vm_info" {
  description = "Node names and IPs"
  value = {
    for vm in virtualbox_vm.node : vm.name => vm.network_adapter[0].ipv4_address
  }
}
