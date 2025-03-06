# group: {node name: node ip}
output "vm_info" {
  description = "Node names and IPs by roles"
  value = {
    masters = local.masters
    workers = local.workers
  }
}
