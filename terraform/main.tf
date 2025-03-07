resource "virtualbox_vm" "node" {
  count  = var.node_count
  name   = var.node_names_file == "" ? data.external.node_names_generated.result[tostring(count.index)] : jsondecode(data.local_file.node_names_file[0].content)[tostring(count.index)]
  image  = var.base_image
  cpus   = 2
  memory = "2.0 gib"

  network_adapter {
    type           = "bridged"
    host_interface = "wlp0s20f3"
  }
}

locals {
  # paths
  project_dir    = var.project_dir != "" ? var.project_dir : "${path.module}/.."
  ssh_key_path   = var.ssh_key_path != "" ? var.ssh_key_path : "${local.project_dir}/.ssh/id_rsa"
  inventory_path = var.inventory_path != "" ? var.inventory_path : "${local.project_dir}/ansible/inventory/inventory.ini"
  # node groups
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

# Generate ansible inventory
resource "local_file" "ansible_inventory" {
  filename = "${local.project_dir}/ansible/inventory/inventory.ini"
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
