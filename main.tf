resource "virtualbox_vm" "node" {
  count  = var.node_count
  name   = data.external.node_names.result[tostring(count.index)]
  image  = var.base_image_url
  cpus   = 2
  memory = "1024 MiB"

  network_adapter {
    type           = "bridged"
    host_interface = ""
  }
}
