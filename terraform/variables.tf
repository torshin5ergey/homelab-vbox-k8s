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

variable "host_interface" {
  description = "Host interafce name"
  type        = string
  default     = "en0"
}
