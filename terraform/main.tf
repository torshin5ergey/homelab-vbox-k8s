resource "virtualbox_vm" "node" {
  count  = var.node_count
  name   = data.external.node_names.result[tostring(count.index)]
  image  = var.base_image
  cpus   = 2
  memory = "2048 mib"

  network_adapter {
    type           = "bridged"
    host_interface = "wlp0s20f3"
  }
}

locals {
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

# Generate inventory
resource "local_file" "ansible_inventory" {
  filename = "${pathexpand("~")}/homelab-vbox-k8s/ansible/inventory/inventory.ini"
  content = templatefile("${path.module}/templates/inventory.tftpl", {
    masters      = local.masters
    workers      = local.workers
    ansible_user = var.username
    ssh_key_path = var.ssh_key_path
  })
  file_permission = "0640"
  depends_on = [
    virtualbox_vm.node
  ]
}
