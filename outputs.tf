output "node_ips" {
  value = [for vm in virtualbox_vm.node : vm.network_adapter[0].ipv4_address]
}
