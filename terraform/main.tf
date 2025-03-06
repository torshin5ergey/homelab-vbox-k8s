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
