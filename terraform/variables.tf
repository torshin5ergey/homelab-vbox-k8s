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

variable "node_names_file" {
  description = "Path to the node names JSON file"
  type        = string
  default     = ""
}

variable "base_image" {
  description = "Base VM node images"
  type        = string
}

variable "username" {
  description = "Default nodes user"
  type        = string
}

variable "project_dir" {
  description = "Path to project directory"
  type        = string
  default     = ""
}

variable "ssh_key_path" {
  description = "Path to ssh private key"
  type        = string
  default     = ""
}

variable "inventory_path" {
  description = "Path to generated ansible inventory file"
  type        = string
  default     = ""
}
