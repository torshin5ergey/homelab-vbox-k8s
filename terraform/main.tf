resource "virtualbox_vm" "node" {
  count  = var.node_count
  name   = data.external.node_names.result[tostring(count.index)]
  image  = var.base_image
  cpus   = 2
  memory = "1024 mib"

  network_adapter {
    type           = "hostonly"
    host_interface = "vboxnet0"
    device         = "IntelPro1000MTServer"
  }
}
