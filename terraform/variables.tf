variable "node_count" {
  description = "Number of nodes to create"
  type        = number
  default     = 3
  nullable    = false

  validation {
    condition     = var.node_count >= 1
    error_message = "At least 1 node must be specified"
  }
}

variable "base_image" {
  description = "Base VM node images"
  type        = string
}

variable "username" {
  description = "Default nodes user"
  type        = string
}

variable "ssh_key_path" {
  description = "Path to ssh private key"
  type        = string
  default     = "~/homelab-vbox-k8s/.ssh/id_rsa"
}
