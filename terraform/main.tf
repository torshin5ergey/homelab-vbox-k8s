resource "virtualbox_vm" "node" {
  count  = var.node_count
  name   = data.external.node_names.result[tostring(count.index)]
  image  = var.base_image
  cpus   = 2
  memory = "2048 mib"

  network_adapter {
    type           = "hostonly" # TODO make bridged
    host_interface = "vboxnet0" # TODO wlp0s20f3
  }

  # provisioner "file" {
  #   content     = local_file.ssh_public.content
  #   destination = "/home/${var.username}/.ssh/authorized_keys"

  #   connection {
  #     type     = "ssh"
  #     user     = var.username
  #     password = "vagrant"
  #     host     = self.network_adapter.0.ipv4_address
  #   }
  # }

  # provisioner "remote-exec" {
  #   inline = [
  #     "chmod 700 ~/.ssh",
  #     "chmod 600 ~/.ssh/authorized_keys"
  #   ]

  #   connection {
  #     type        = "ssh"
  #     user        = var.username
  #     private_key = tls_private_key.cluster_ssh.private_key_openssh
  #     host        = self.network_adapter.0.ipv4_address
  #   }
  # }
}

resource "tls_private_key" "cluster_ssh" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "ssh_private" {
  filename        = "${path.module}/.ssh/id_rsa"
  content         = tls_private_key.cluster_ssh.private_key_openssh
  file_permission = "0600"
}

resource "local_file" "ssh_public" {
  filename = "${path.module}/.ssh/id_rsa.pub"
  content  = tls_private_key.cluster_ssh.public_key_openssh
}
