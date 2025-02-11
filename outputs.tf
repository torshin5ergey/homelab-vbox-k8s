# output "vm_info" {
#   description = "Node names and IPs"
#   value = [
#     for vm in virtualbox_vm.node : {
#       name = vm.name
#       ip   = vm.network_adapter.ipv4_address
#     }
#   ]
# }
